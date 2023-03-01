failure() {
    echo "YOUR CODE IS A FAILURE!!! $1" >&2
    exit 1
}

CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'
cd student-submission
if [[ ! -f ListExamples.java  ]]
then
    failure "ListExamples.java not found in current directory"
fi

cd ..
cp student-submission/ListExamples.java ./

javac -cp $CPATH *.java
if [[ $? -ne 0 ]]
then
    failure "Failed to compile!!"
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > java.txt
cat java.txt

LAST=`tail -2 java.txt`

PASS=`echo $LAST | grep -oP '(?<=OK \()\d+'`
RAN=`echo $LAST | grep -oP '(?<=run: )\d+'`
FAIL=`echo $LAST | grep -oP '(?<=Failures: )\d+'`

echo hi $RAN $FAIL
if [[ -n $PASS ]]
then
    PASS=$(($RAN - $FAIL))
    TOTAL=$RAN
else
    TOTAL=$PASS
fi
echo You passed $PASS / $TOTAL tests
