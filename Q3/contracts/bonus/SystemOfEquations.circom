pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/gates.circom";

include "../../node_modules/circomlib-matrix/circuits/matMul.circom";

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    component matrixMul = matMul(n, n, 1);

    for(var j = 0; j < n; j++) {
        matrixMul.b[j][0] <== x[j];

        for(var k = 0; k < n; k++) {
            matrixMul.a[j][k] <== A[j][k];
        }
    }

    component multiAnd = MultiAND(n);
    component equals[n];

    for (var i = 0; i < n; i++) {
        equals[i] = IsEqual();

        equals[i].in[1] <== matrixMul.out[i][0];
        equals[i].in[0] <== b[i];

        multiAnd.in[i] <== equals[i].out;
    }

    out <== multiAnd.out;
}

component main {public [A, b]} = SystemOfEquations(3);