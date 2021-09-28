Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FCF41B6DD
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 21:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242371AbhI1TFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 15:05:33 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:36831 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242315AbhI1TFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 15:05:31 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 7AC1E200DBA0;
        Tue, 28 Sep 2021 21:03:49 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 7AC1E200DBA0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1632855829;
        bh=P3gPIKwQ5JEPLAYy92QOamoOfJyqUWSexAN5K9o6ddQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJ2c2jj5raL1TYKx/fuwcMJxiV0+BthZCR94nAlU3KWdusyPkA9lFUTSSpFb2xolf
         nu+vh67cQ1uddBp9T7svC/4e7JYMjDdDLmNB84NySaUYUyNv407XGYbPLwUoLbIB3Z
         M6G1cdtFvo7Z//KTrokXmrSKPN2dJREK+uKeD3kVOB7Y14qcFoEtGtWqc30hTBDe9X
         1CXhMUsu6UPR8My4XSZO0633vTREn9gu0M5hxiYWsCo0wQ48cOL/vZDvSiqlaNTc80
         DgM3ngiV1cNr6+eLuyDm+Qn3zflvGooL8xWqui7SG27beWo1B2DTiJycOVrYbCfuB8
         B5PivadETB8NA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net-next 2/2] selftests: net: Test for the IOAM encapsulation with IPv6
Date:   Tue, 28 Sep 2021 21:03:28 +0200
Message-Id: <20210928190328.24097-3-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928190328.24097-1-justin.iurman@uliege.be>
References: <20210928190328.24097-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for testing the encap mode of IOAM.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 tools/testing/selftests/net/ioam6.sh | 209 ++++++++++++++++++++-------
 1 file changed, 159 insertions(+), 50 deletions(-)

diff --git a/tools/testing/selftests/net/ioam6.sh b/tools/testing/selftests/net/ioam6.sh
index 3caf72bb9c6a..90700303d8a9 100755
--- a/tools/testing/selftests/net/ioam6.sh
+++ b/tools/testing/selftests/net/ioam6.sh
@@ -6,7 +6,7 @@
 # This script evaluates the IOAM insertion for IPv6 by checking the IOAM data
 # consistency directly inside packets on the receiver side. Tests are divided
 # into three categories: OUTPUT (evaluates the IOAM processing by the sender),
-# INPUT (evaluates the IOAM processing by the receiver) and GLOBAL (evaluates
+# INPUT (evaluates the IOAM processing by a receiver) and GLOBAL (evaluates
 # wider use cases that do not fall into the other two categories). Both OUTPUT
 # and INPUT tests only use a two-node topology (alpha and beta), while GLOBAL
 # tests use the entire three-node topology (alpha, beta, gamma). Each test is
@@ -200,7 +200,7 @@ check_kernel_compatibility()
   ip -netns ioam-tmp-node link set veth0 up
   ip -netns ioam-tmp-node link set veth1 up
 
-  ip -netns ioam-tmp-node ioam namespace add 0 &>/dev/null
+  ip -netns ioam-tmp-node ioam namespace add 0
   ns_ad=$?
 
   ip -netns ioam-tmp-node ioam namespace show | grep -q "namespace 0"
@@ -214,11 +214,11 @@ check_kernel_compatibility()
     exit 1
   fi
 
-  ip -netns ioam-tmp-node route add db02::/64 encap ioam6 trace prealloc \
-         type 0x800000 ns 0 size 4 dev veth0 &>/dev/null
+  ip -netns ioam-tmp-node route add db02::/64 encap ioam6 mode inline \
+         trace prealloc type 0x800000 ns 0 size 4 dev veth0
   tr_ad=$?
 
-  ip -netns ioam-tmp-node -6 route | grep -q "encap ioam6 trace"
+  ip -netns ioam-tmp-node -6 route | grep -q "encap ioam6"
   tr_sh=$?
 
   if [[ $tr_ad != 0 || $tr_sh != 0 ]]
@@ -232,6 +232,30 @@ check_kernel_compatibility()
 
   ip link del veth0 2>/dev/null || true
   ip netns del ioam-tmp-node || true
+
+  lsmod | grep -q "ip6_tunnel"
+  ip6tnl_loaded=$?
+
+  if [ $ip6tnl_loaded = 0 ]
+  then
+    encap_tests=0
+  else
+    modprobe ip6_tunnel &>/dev/null
+    lsmod | grep -q "ip6_tunnel"
+    encap_tests=$?
+
+    if [ $encap_tests != 0 ]
+    then
+      ip a | grep -q "ip6tnl0"
+      encap_tests=$?
+
+      if [ $encap_tests != 0 ]
+      then
+        echo "Note: ip6_tunnel not found neither as a module nor inside the" \
+             "kernel, tests that require it (encap mode) will be omitted"
+      fi
+    fi
+  fi
 }
 
 cleanup()
@@ -242,6 +266,11 @@ cleanup()
   ip netns del ioam-node-alpha || true
   ip netns del ioam-node-beta || true
   ip netns del ioam-node-gamma || true
+
+  if [ $ip6tnl_loaded != 0 ]
+  then
+    modprobe -r ip6_tunnel 2>/dev/null || true
+  fi
 }
 
 setup()
@@ -329,6 +358,12 @@ log_test_failed()
   printf "TEST: %-60s  [FAIL]\n" "${desc}"
 }
 
+log_results()
+{
+  echo "- Tests passed: ${npassed}"
+  echo "- Tests failed: ${nfailed}"
+}
+
 run_test()
 {
   local name=$1
@@ -349,16 +384,26 @@ run_test()
   ip netns exec $node_src ping6 -t 64 -c 1 -W 1 $ip6_dst &>/dev/null
   if [ $? != 0 ]
   then
+    nfailed=$((nfailed+1))
     log_test_failed "${desc}"
     kill -2 $spid &>/dev/null
   else
     wait $spid
-    [ $? = 0 ] && log_test_passed "${desc}" || log_test_failed "${desc}"
+    if [ $? = 0 ]
+    then
+      npassed=$((npassed+1))
+      log_test_passed "${desc}"
+    else
+      nfailed=$((nfailed+1))
+      log_test_failed "${desc}"
+    fi
   fi
 }
 
 run()
 {
+  echo
+  printf "%0.s-" {1..74}
   echo
   echo "OUTPUT tests"
   printf "%0.s-" {1..74}
@@ -369,7 +414,8 @@ run()
 
   for t in $TESTS_OUTPUT
   do
-    $t
+    $t "inline"
+    [ $encap_tests = 0 ] && $t "encap"
   done
 
   # clean OUTPUT settings
@@ -377,6 +423,8 @@ run()
   ip -netns ioam-node-alpha route change db01::/64 dev veth0
 
 
+  echo
+  printf "%0.s-" {1..74}
   echo
   echo "INPUT tests"
   printf "%0.s-" {1..74}
@@ -387,7 +435,8 @@ run()
 
   for t in $TESTS_INPUT
   do
-    $t
+    $t "inline"
+    [ $encap_tests = 0 ] && $t "encap"
   done
 
   # clean INPUT settings
@@ -396,7 +445,8 @@ run()
   ip -netns ioam-node-alpha ioam namespace set 123 schema ${ALPHA[8]}
   ip -netns ioam-node-alpha route change db01::/64 dev veth0
 
-
+  echo
+  printf "%0.s-" {1..74}
   echo
   echo "GLOBAL tests"
   printf "%0.s-" {1..74}
@@ -404,8 +454,12 @@ run()
 
   for t in $TESTS_GLOBAL
   do
-    $t
+    $t "inline"
+    [ $encap_tests = 0 ] && $t "encap"
   done
+
+  echo
+  log_results
 }
 
 bit2type=(
@@ -431,11 +485,16 @@ out_undef_ns()
   ##############################################################################
   local desc="Unknown IOAM namespace"
 
-  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
-         type 0x800000 ns 0 size 4 dev veth0
+  [ "$1" = "encap" ] && mode="$1 tundst db01::1" || mode="$1"
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 up
+
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 mode $mode \
+         trace prealloc type 0x800000 ns 0 size 4 dev veth0
 
-  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
-         db01::1 veth0 0x800000 0
+  run_test ${FUNCNAME[0]} "${desc} ($1 mode)" ioam-node-alpha ioam-node-beta \
+         db01::2 db01::1 veth0 0x800000 0
+
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 down
 }
 
 out_no_room()
@@ -446,11 +505,16 @@ out_no_room()
   ##############################################################################
   local desc="Missing trace room"
 
-  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
-         type 0xc00000 ns 123 size 4 dev veth0
+  [ "$1" = "encap" ] && mode="$1 tundst db01::1" || mode="$1"
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 up
+
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 mode $mode \
+         trace prealloc type 0xc00000 ns 123 size 4 dev veth0
+
+  run_test ${FUNCNAME[0]} "${desc} ($1 mode)" ioam-node-alpha ioam-node-beta \
+         db01::2 db01::1 veth0 0xc00000 123
 
-  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
-         db01::1 veth0 0xc00000 123
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 down
 }
 
 out_bits()
@@ -465,15 +529,21 @@ out_bits()
   local tmp=${bit2size[22]}
   bit2size[22]=$(( $tmp + ${#ALPHA[9]} + ((4 - (${#ALPHA[9]} % 4)) % 4) ))
 
+  [ "$1" = "encap" ] && mode="$1 tundst db01::1" || mode="$1"
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 up
+
   for i in {0..22}
   do
-    ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace \
-           prealloc type ${bit2type[$i]} ns 123 size ${bit2size[$i]} dev veth0
+    ip -netns ioam-node-alpha route change db01::/64 encap ioam6 mode $mode \
+           trace prealloc type ${bit2type[$i]} ns 123 size ${bit2size[$i]} \
+           dev veth0
 
-    run_test "out_bit$i" "${desc/<n>/$i}" ioam-node-alpha ioam-node-beta \
-           db01::2 db01::1 veth0 ${bit2type[$i]} 123
+    run_test "out_bit$i" "${desc/<n>/$i} ($1 mode)" ioam-node-alpha \
+           ioam-node-beta db01::2 db01::1 veth0 ${bit2type[$i]} 123
   done
 
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 down
+
   bit2size[22]=$tmp
 }
 
@@ -485,11 +555,16 @@ out_full_supp_trace()
   ##############################################################################
   local desc="Full supported trace"
 
-  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
-         type 0xfff002 ns 123 size 100 dev veth0
+  [ "$1" = "encap" ] && mode="$1 tundst db01::1" || mode="$1"
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 up
 
-  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
-         db01::1 veth0 0xfff002 123
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 mode $mode \
+         trace prealloc type 0xfff002 ns 123 size 100 dev veth0
+
+  run_test ${FUNCNAME[0]} "${desc} ($1 mode)" ioam-node-alpha ioam-node-beta \
+         db01::2 db01::1 veth0 0xfff002 123
+
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 down
 }
 
 
@@ -510,11 +585,16 @@ in_undef_ns()
   ##############################################################################
   local desc="Unknown IOAM namespace"
 
-  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
-         type 0x800000 ns 0 size 4 dev veth0
+  [ "$1" = "encap" ] && mode="$1 tundst db01::1" || mode="$1"
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 up
+
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 mode $mode \
+         trace prealloc type 0x800000 ns 0 size 4 dev veth0
 
-  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
-         db01::1 veth0 0x800000 0
+  run_test ${FUNCNAME[0]} "${desc} ($1 mode)" ioam-node-alpha ioam-node-beta \
+         db01::2 db01::1 veth0 0x800000 0
+
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 down
 }
 
 in_no_room()
@@ -525,11 +605,16 @@ in_no_room()
   ##############################################################################
   local desc="Missing trace room"
 
-  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
-         type 0xc00000 ns 123 size 4 dev veth0
+  [ "$1" = "encap" ] && mode="$1 tundst db01::1" || mode="$1"
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 up
+
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 mode $mode \
+         trace prealloc type 0xc00000 ns 123 size 4 dev veth0
 
-  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
-         db01::1 veth0 0xc00000 123
+  run_test ${FUNCNAME[0]} "${desc} ($1 mode)" ioam-node-alpha ioam-node-beta \
+         db01::2 db01::1 veth0 0xc00000 123
+
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 down
 }
 
 in_bits()
@@ -544,15 +629,21 @@ in_bits()
   local tmp=${bit2size[22]}
   bit2size[22]=$(( $tmp + ${#BETA[9]} + ((4 - (${#BETA[9]} % 4)) % 4) ))
 
+  [ "$1" = "encap" ] && mode="$1 tundst db01::1" || mode="$1"
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 up
+
   for i in {0..22}
   do
-    ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace \
-           prealloc type ${bit2type[$i]} ns 123 size ${bit2size[$i]} dev veth0
+    ip -netns ioam-node-alpha route change db01::/64 encap ioam6 mode $mode \
+           trace prealloc type ${bit2type[$i]} ns 123 size ${bit2size[$i]} \
+           dev veth0
 
-    run_test "in_bit$i" "${desc/<n>/$i}" ioam-node-alpha ioam-node-beta \
-           db01::2 db01::1 veth0 ${bit2type[$i]} 123
+    run_test "in_bit$i" "${desc/<n>/$i} ($1 mode)" ioam-node-alpha \
+           ioam-node-beta db01::2 db01::1 veth0 ${bit2type[$i]} 123
   done
 
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 down
+
   bit2size[22]=$tmp
 }
 
@@ -569,11 +660,16 @@ in_oflag()
   #   back the IOAM namespace that was previously configured on the sender.
   ip -netns ioam-node-alpha ioam namespace add 123
 
-  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
-         type 0xc00000 ns 123 size 4 dev veth0
+  [ "$1" = "encap" ] && mode="$1 tundst db01::1" || mode="$1"
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 up
+
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 mode $mode \
+         trace prealloc type 0xc00000 ns 123 size 4 dev veth0
+
+  run_test ${FUNCNAME[0]} "${desc} ($1 mode)" ioam-node-alpha ioam-node-beta \
+         db01::2 db01::1 veth0 0xc00000 123
 
-  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
-         db01::1 veth0 0xc00000 123
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 down
 
   # And we clean the exception for this test to get things back to normal for
   # other INPUT tests
@@ -588,11 +684,16 @@ in_full_supp_trace()
   ##############################################################################
   local desc="Full supported trace"
 
-  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace prealloc \
-         type 0xfff002 ns 123 size 80 dev veth0
+  [ "$1" = "encap" ] && mode="$1 tundst db01::1" || mode="$1"
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 up
 
-  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-beta db01::2 \
-         db01::1 veth0 0xfff002 123
+  ip -netns ioam-node-alpha route change db01::/64 encap ioam6 mode $mode \
+         trace prealloc type 0xfff002 ns 123 size 80 dev veth0
+
+  run_test ${FUNCNAME[0]} "${desc} ($1 mode)" ioam-node-alpha ioam-node-beta \
+         db01::2 db01::1 veth0 0xfff002 123
+
+  [ "$1" = "encap" ] && ip -netns ioam-node-beta link set ip6tnl0 down
 }
 
 
@@ -611,11 +712,16 @@ fwd_full_supp_trace()
   ##############################################################################
   local desc="Forward - Full supported trace"
 
-  ip -netns ioam-node-alpha route change db02::/64 encap ioam6 trace prealloc \
-         type 0xfff002 ns 123 size 244 via db01::1 dev veth0
+  [ "$1" = "encap" ] && mode="$1 tundst db02::2" || mode="$1"
+  [ "$1" = "encap" ] && ip -netns ioam-node-gamma link set ip6tnl0 up
+
+  ip -netns ioam-node-alpha route change db02::/64 encap ioam6 mode $mode \
+         trace prealloc type 0xfff002 ns 123 size 244 via db01::1 dev veth0
 
-  run_test ${FUNCNAME[0]} "${desc}" ioam-node-alpha ioam-node-gamma db01::2 \
-         db02::2 veth0 0xfff002 123
+  run_test ${FUNCNAME[0]} "${desc} ($1 mode)" ioam-node-alpha ioam-node-gamma \
+         db01::2 db02::2 veth0 0xfff002 123
+
+  [ "$1" = "encap" ] && ip -netns ioam-node-gamma link set ip6tnl0 down
 }
 
 
@@ -625,6 +731,9 @@ fwd_full_supp_trace()
 #                                                                              #
 ################################################################################
 
+npassed=0
+nfailed=0
+
 if [ "$(id -u)" -ne 0 ]
 then
   echo "SKIP: Need root privileges"
-- 
2.25.1

