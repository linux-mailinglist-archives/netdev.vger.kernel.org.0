Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9D491E5A
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 09:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfHSHyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 03:54:22 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58639 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726867AbfHSHyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 03:54:21 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 19 Aug 2019 10:53:43 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7J7rgG1010776;
        Mon, 19 Aug 2019 10:53:43 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jhs@mojatatu.com, lucasb@mojatatu.com,
        mrv@mojatatu.com, shuah@kernel.org, batuhanosmantaskaya@gmail.com,
        dcaratti@redhat.com, marcelo.leitner@gmail.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next 1/2] tc-testing: use dedicated DUMMY interface name for dummy dev
Date:   Mon, 19 Aug 2019 10:52:07 +0300
Message-Id: <20190819075208.12240-2-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190819075208.12240-1-vladbu@mellanox.com>
References: <20190819075208.12240-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A lot of tests reuse $DEV1 veth name for naming dummy device. This causes
problem when tdc is invoked without specifying a test group and tries to
execute all tests. In this case tdc instantiates ns plugin, which creates
veth pair once before running tests. However, if any of the tests that
reuse $DEV1 run before test that depend on ns plugin, it will delete $DEV1
as a part of teardown section:

=====> Test 3b88: Delete ingress qdisc twice                                                                                                                                                             [3770/41080]
-----> prepare stage
ns/SubPlugin.adjust_command
adjust_command:  stage is setup; inserting netns stuff in command [/sbin/ip link add dev v0p1 type dummy || /bin/true] list [['/sbin/ip', 'link', 'add', 'dev', 'v0p1', 'type', 'dummy', '||', '/bin/true']]
adjust_command:  return command [ip netns exec tcut /sbin/ip link add dev v0p1 type dummy || /bin/true]
command "ip netns exec tcut /sbin/ip link add dev v0p1 type dummy || /bin/true"
ns/SubPlugin.adjust_command
adjust_command:  stage is setup; inserting netns stuff in command [/sbin/tc qdisc add dev v0p1 ingress] list [['/sbin/tc', 'qdisc', 'add', 'dev', 'v0p1', 'ingress']]
adjust_command:  return command [ip netns exec tcut /sbin/tc qdisc add dev v0p1 ingress]
command "ip netns exec tcut /sbin/tc qdisc add dev v0p1 ingress"
ns/SubPlugin.adjust_command
adjust_command:  stage is setup; inserting netns stuff in command [/sbin/tc qdisc del dev v0p1 ingress] list [['/sbin/tc', 'qdisc', 'del', 'dev', 'v0p1', 'ingress']]
adjust_command:  return command [ip netns exec tcut /sbin/tc qdisc del dev v0p1 ingress]
command "ip netns exec tcut /sbin/tc qdisc del dev v0p1 ingress"
-----> execute stage
ns/SubPlugin.adjust_command
adjust_command:  stage is execute; inserting netns stuff in command [/sbin/tc qdisc del dev v0p1 ingress] list [['/sbin/tc', 'qdisc', 'del', 'dev', 'v0p1', 'ingress']]
adjust_command:  return command [ip netns exec tcut /sbin/tc qdisc del dev v0p1 ingress]
command "ip netns exec tcut /sbin/tc qdisc del dev v0p1 ingress"
-----> verify stage
ns/SubPlugin.adjust_command
adjust_command:  stage is verify; inserting netns stuff in command [/sbin/tc qdisc show dev v0p1] list [['/sbin/tc', 'qdisc', 'show', 'dev', 'v0p1']]
adjust_command:  return command [ip netns exec tcut /sbin/tc qdisc show dev v0p1]
command "ip netns exec tcut /sbin/tc qdisc show dev v0p1"
-----> teardown stage
ns/SubPlugin.adjust_command
adjust_command:  stage is teardown; inserting netns stuff in command [/sbin/ip link del dev v0p1 type dummy] list [['/sbin/ip', 'link', 'del', 'dev', 'v0p1', 'type', 'dummy']]
adjust_command:  return command [ip netns exec tcut /sbin/ip link del dev v0p1 type dummy]
command "ip netns exec tcut /sbin/ip link del dev v0p1 type dummy"

After this ns-dependent tests will fail because dev doesn't exist:

=====> Test 901f: Add fw filter with prio at 32-bit maxixum
-----> prepare stage
ns/SubPlugin.adjust_command
adjust_command:  stage is setup; inserting netns stuff in command [/sbin/tc qdisc add dev v0p1 ingress] list [['/sbin/tc', 'qdisc', 'add', 'dev', 'v0p1', 'ingress']]
adjust_command:  return command [ip netns exec tcut /sbin/tc qdisc add dev v0p1 ingress]
command "ip netns exec tcut /sbin/tc qdisc add dev v0p1 ingress"

-----> prepare stage *** Could not execute: "$TC qdisc add dev $DEV1 ingress"

-----> prepare stage *** Error message: "Cannot find device "v0p1"
"
returncode 1; expected [0]

-----> prepare stage *** Aborting test run.

<_io.BufferedReader name=3> *** stdout ***

<_io.BufferedReader name=5> *** stderr ***
"-----> prepare stage" did not complete successfully
Exception <class '__main__.PluginMgrTestFail'> ('setup', None, '"-----> prepare stage" did not complete successfully') (caught in test_runner, running test 477 901f Add fw filter with prio at 32-bit maxixum stage
setup)
---------------
traceback
  File "./tdc.py", line 371, in test_runner
    res = run_one_test(pm, args, index, tidx)
  File "./tdc.py", line 272, in run_one_test
    prepare_env(args, pm, 'setup', "-----> prepare stage", tidx["setup"])
  File "./tdc.py", line 247, in prepare_env
    '"{}" did not complete successfully'.format(prefix))
---------------

Fix the issue by introducing standalone $DUMMY config variable and
substitute all usage of $DEV1 in tests that don't depend on ns plugin.

Fixes: 489ce2f42514 ("tc-testing: Restore original behaviour for namespaces in tdc")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 .../tc-testing/tc-tests/filters/matchall.json | 242 +++++++++---------
 .../tc-testing/tc-tests/qdiscs/fifo.json      | 150 +++++------
 .../tc-testing/tc-tests/qdiscs/ingress.json   |  50 ++--
 .../tc-testing/tc-tests/qdiscs/prio.json      | 128 ++++-----
 .../selftests/tc-testing/tdc_config.py        |   1 +
 5 files changed, 286 insertions(+), 285 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json b/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
index 5f24c0598624..51799874a972 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/matchall.json
@@ -7,17 +7,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ip matchall action ok",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ip matchall action ok",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ip matchall",
         "matchPattern": "^filter parent ffff: protocol ip pref 1 matchall.*handle 0x1.*gact action pass.*ref 1 bind 1",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -28,17 +28,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 root handle 1: prio"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY root handle 1: prio"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent 1: handle 0x1 prio 1 protocol ip matchall action ok",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent 1: handle 0x1 prio 1 protocol ip matchall action ok",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent 1: handle 1 prio 1 protocol ip matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent 1: handle 1 prio 1 protocol ip matchall",
         "matchPattern": "^filter parent 1: protocol ip pref 1 matchall.*handle 0x1.*gact action pass.*ref 1 bind 1",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 root handle 1: prio",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY root handle 1: prio",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -49,17 +49,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall action drop",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv6 matchall action drop",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ipv6 matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 1 protocol ipv6 matchall",
         "matchPattern": "^filter parent ffff: protocol ipv6 pref 1 matchall.*handle 0x1.*gact action drop.*ref 1 bind 1",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -70,17 +70,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 root handle 1: prio"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY root handle 1: prio"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent 1: handle 0x1 prio 1 protocol ipv6 matchall action drop",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent 1: handle 0x1 prio 1 protocol ipv6 matchall action drop",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent 1: handle 1 prio 1 protocol ipv6 matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent 1: handle 1 prio 1 protocol ipv6 matchall",
         "matchPattern": "^filter parent 1: protocol ipv6 pref 1 matchall.*handle 0x1.*gact action drop.*ref 1 bind 1",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 root handle 1: prio",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY root handle 1: prio",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -91,17 +91,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 65535 protocol ipv4 matchall action pass",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 65535 protocol ipv4 matchall action pass",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 65535 protocol ipv4 matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 65535 protocol ipv4 matchall",
         "matchPattern": "^filter parent ffff: protocol ip pref 65535 matchall.*handle 0x1.*gact action pass.*ref 1 bind 1",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -112,17 +112,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 root handle 1: prio"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY root handle 1: prio"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent 1: handle 0x1 prio 65535 protocol ipv4 matchall action pass",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent 1: handle 0x1 prio 65535 protocol ipv4 matchall action pass",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent 1: handle 1 prio 65535 protocol ipv4 matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent 1: handle 1 prio 65535 protocol ipv4 matchall",
         "matchPattern": "^filter parent 1: protocol ip pref 65535 matchall.*handle 0x1.*gact action pass.*ref 1 bind 1",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 root handle 1: prio",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY root handle 1: prio",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -133,17 +133,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 655355 protocol ipv4 matchall action pass",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 655355 protocol ipv4 matchall action pass",
         "expExitCode": "255",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 655355 protocol ipv4 matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 1 prio 655355 protocol ipv4 matchall",
         "matchPattern": "^filter parent ffff: protocol ip pref 655355 matchall.*handle 0x1.*gact action pass.*ref 1 bind 1",
         "matchCount": "0",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -154,17 +154,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 root handle 1: prio"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY root handle 1: prio"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent 1: handle 0x1 prio 655355 protocol ipv4 matchall action pass",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent 1: handle 0x1 prio 655355 protocol ipv4 matchall action pass",
         "expExitCode": "255",
-        "verifyCmd": "$TC filter get dev $DEV1 parent 1: handle 1 prio 655355 protocol ipv4 matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent 1: handle 1 prio 655355 protocol ipv4 matchall",
         "matchPattern": "^filter parent 1: protocol ip pref 655355 matchall.*handle 0x1.*gact action pass.*ref 1 bind 1",
         "matchCount": "0",
         "teardown": [
-            "$TC qdisc del dev $DEV1 root handle 1: prio",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY root handle 1: prio",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -175,17 +175,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0xffffffff prio 1 protocol all matchall action continue",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0xffffffff prio 1 protocol all matchall action continue",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0xffffffff prio 1 protocol all matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 0xffffffff prio 1 protocol all matchall",
         "matchPattern": "^filter parent ffff: protocol all pref 1 matchall.*handle 0xffffffff.*gact action continue.*ref 1 bind 1",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -196,17 +196,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 root handle 1: prio"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY root handle 1: prio"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent 1: handle 0xffffffff prio 1 protocol all matchall action continue",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent 1: handle 0xffffffff prio 1 protocol all matchall action continue",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent 1: handle 0xffffffff prio 1 protocol all matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent 1: handle 0xffffffff prio 1 protocol all matchall",
         "matchPattern": "^filter parent 1: protocol all pref 1 matchall.*handle 0xffffffff.*gact action continue.*ref 1 bind 1",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 root handle 1: prio",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY root handle 1: prio",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -217,17 +217,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol all matchall skip_hw action reclassify",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol all matchall skip_hw action reclassify",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0x1 prio 1 protocol all matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 0x1 prio 1 protocol all matchall",
         "matchPattern": "^filter parent ffff: protocol all pref 1 matchall.*handle 0x1.*skip_hw.*not_in_hw.*gact action reclassify.*ref 1 bind 1",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -238,17 +238,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 root handle 1: prio"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY root handle 1: prio"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent 1: handle 0x1 prio 1 protocol all matchall skip_hw action reclassify",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent 1: handle 0x1 prio 1 protocol all matchall skip_hw action reclassify",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent 1: handle 0x1 prio 1 protocol all matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent 1: handle 0x1 prio 1 protocol all matchall",
         "matchPattern": "^filter parent 1: protocol all pref 1 matchall.*handle 0x1.*skip_hw.*not_in_hw.*gact action reclassify.*ref 1 bind 1",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 root handle 1: prio",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY root handle 1: prio",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -259,17 +259,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall classid 1:1 action pass",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv6 matchall classid 1:1 action pass",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv6 matchall",
         "matchPattern": "^filter parent ffff: protocol ipv6 pref 1 matchall.*handle 0x1.*flowid 1:1.*gact action pass.*ref 1 bind 1",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -280,17 +280,17 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall classid 6789defg action pass",
+        "cmdUnderTest": "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv6 matchall classid 6789defg action pass",
         "expExitCode": "1",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv6 matchall",
         "matchPattern": "^filter protocol ipv6 pref 1 matchall.*handle 0x1.*flowid 6789defg.*gact action pass.*ref 1 bind 1",
         "matchCount": "0",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -301,18 +301,18 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress",
-            "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall classid 1:2 action pass"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv6 matchall classid 1:2 action pass"
         ],
-        "cmdUnderTest": "$TC filter del dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall",
+        "cmdUnderTest": "$TC filter del dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv6 matchall",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv6 matchall",
+        "verifyCmd": "$TC filter get dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv6 matchall",
         "matchPattern": "^filter protocol ipv6 pref 1 matchall.*handle 0x1.*flowid 1:2.*gact action pass.*ref 1 bind 1",
         "matchCount": "0",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -323,21 +323,21 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress",
-            "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol all matchall classid 1:2 action pass",
-            "$TC filter add dev $DEV1 parent ffff: handle 0x2 prio 2 protocol all matchall classid 1:3 action pass",
-            "$TC filter add dev $DEV1 parent ffff: handle 0x3 prio 3 protocol all matchall classid 1:4 action pass",
-            "$TC filter add dev $DEV1 parent ffff: handle 0x4 prio 4 protocol all matchall classid 1:5 action pass"
-        ],
-        "cmdUnderTest": "$TC filter del dev $DEV1 parent ffff:",
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol all matchall classid 1:2 action pass",
+            "$TC filter add dev $DUMMY parent ffff: handle 0x2 prio 2 protocol all matchall classid 1:3 action pass",
+            "$TC filter add dev $DUMMY parent ffff: handle 0x3 prio 3 protocol all matchall classid 1:4 action pass",
+            "$TC filter add dev $DUMMY parent ffff: handle 0x4 prio 4 protocol all matchall classid 1:5 action pass"
+        ],
+        "cmdUnderTest": "$TC filter del dev $DUMMY parent ffff:",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "verifyCmd": "$TC filter show dev $DUMMY parent ffff:",
         "matchPattern": "^filter protocol all pref.*matchall.*handle.*flowid.*gact action pass",
         "matchCount": "0",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -348,21 +348,21 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress",
-            "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol all matchall classid 1:2 action pass",
-            "$TC filter add dev $DEV1 parent ffff: handle 0x2 prio 2 protocol all matchall classid 1:3 action pass",
-            "$TC filter add dev $DEV1 parent ffff: handle 0x3 prio 3 protocol all matchall classid 1:4 action pass",
-            "$TC filter add dev $DEV1 parent ffff: handle 0x4 prio 4 protocol all matchall classid 1:5 action pass"
-        ],
-        "cmdUnderTest": "$TC filter del dev $DEV1 parent ffff: protocol all handle 0x2 prio 2 matchall",
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol all matchall classid 1:2 action pass",
+            "$TC filter add dev $DUMMY parent ffff: handle 0x2 prio 2 protocol all matchall classid 1:3 action pass",
+            "$TC filter add dev $DUMMY parent ffff: handle 0x3 prio 3 protocol all matchall classid 1:4 action pass",
+            "$TC filter add dev $DUMMY parent ffff: handle 0x4 prio 4 protocol all matchall classid 1:5 action pass"
+        ],
+        "cmdUnderTest": "$TC filter del dev $DUMMY parent ffff: protocol all handle 0x2 prio 2 matchall",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "verifyCmd": "$TC filter show dev $DUMMY parent ffff:",
         "matchPattern": "^filter protocol all pref 2 matchall.*handle 0x2 flowid 1:2.*gact action pass",
         "matchCount": "0",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -373,19 +373,19 @@
             "matchall"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress",
-            "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol all chain 1 matchall classid 1:1 action pass",
-            "$TC filter add dev $DEV1 parent ffff: handle 0x1 prio 1 protocol ipv4 chain 2 matchall classid 1:3 action continue"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol all chain 1 matchall classid 1:1 action pass",
+            "$TC filter add dev $DUMMY parent ffff: handle 0x1 prio 1 protocol ipv4 chain 2 matchall classid 1:3 action continue"
         ],
-        "cmdUnderTest": "$TC filter del dev $DEV1 parent ffff: chain 2",
+        "cmdUnderTest": "$TC filter del dev $DUMMY parent ffff: chain 2",
         "expExitCode": "0",
-        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "verifyCmd": "$TC filter show dev $DUMMY parent ffff:",
         "matchPattern": "^filter protocol all pref 1 matchall chain 1 handle 0x1 flowid 1:1.*gact action pass",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fifo.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fifo.json
index 9de61fa10878..5ecd93b4c473 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fifo.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fifo.json
@@ -8,16 +8,16 @@
             "fifo"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root bfifo",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root bfifo",
         "expExitCode": "0",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc bfifo 1: root.*limit [0-9]+b",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 handle 1: root bfifo",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY handle 1: root bfifo",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -29,16 +29,16 @@
             "fifo"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root pfifo",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root pfifo",
         "expExitCode": "0",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc pfifo 1: root.*limit [0-9]+p",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 handle 1: root pfifo",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY handle 1: root pfifo",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -49,16 +49,16 @@
             "fifo"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 root handle ffff: bfifo",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY root handle ffff: bfifo",
         "expExitCode": "0",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc bfifo ffff: root.*limit [0-9]+b",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 handle ffff: root bfifo",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY handle ffff: root bfifo",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -69,16 +69,16 @@
             "fifo"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root bfifo limit 3000b",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root bfifo limit 3000b",
         "expExitCode": "0",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc bfifo 1: root.*limit 3000b",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 handle 1: root bfifo",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY handle 1: root bfifo",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -89,16 +89,16 @@
             "fifo"
         ],
         "setup": [
-            "$IP link add dev $DEV1 txqueuelen 3000 type dummy || /bin/true"
+            "$IP link add dev $DUMMY txqueuelen 3000 type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root pfifo limit 3000",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root pfifo limit 3000",
         "expExitCode": "0",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc pfifo 1: root.*limit 3000p",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 handle 1: root pfifo",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY handle 1: root pfifo",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -109,15 +109,15 @@
             "fifo"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 root handle 10000: bfifo",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY root handle 10000: bfifo",
         "expExitCode": "255",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc bfifo 10000: root.*limit [0-9]+b",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -128,15 +128,15 @@
             "fifo"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root bfifo foorbar",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root bfifo foorbar",
         "expExitCode": "1",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc bfifo 1: root",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -147,15 +147,15 @@
             "fifo"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root pfifo foorbar",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root pfifo foorbar",
         "expExitCode": "1",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc pfifo 1: root",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -166,18 +166,18 @@
             "fifo"
         ],
         "setup": [
-            "$IP link del dev $DEV1 type dummy || /bin/true",
-            "$IP link add dev $DEV1 txqueuelen 1000 type dummy",
-            "$TC qdisc add dev $DEV1 handle 1: root bfifo"
+            "$IP link del dev $DUMMY type dummy || /bin/true",
+            "$IP link add dev $DUMMY txqueuelen 1000 type dummy",
+            "$TC qdisc add dev $DUMMY handle 1: root bfifo"
         ],
-        "cmdUnderTest": "$TC qdisc replace dev $DEV1 handle 1: root bfifo limit 3000b",
+        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root bfifo limit 3000b",
         "expExitCode": "0",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc bfifo 1: root.*limit 3000b",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 handle 1: root bfifo",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY handle 1: root bfifo",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -188,18 +188,18 @@
             "fifo"
         ],
         "setup": [
-            "$IP link del dev $DEV1 type dummy || /bin/true",
-            "$IP link add dev $DEV1 txqueuelen 1000 type dummy",
-            "$TC qdisc add dev $DEV1 handle 1: root pfifo"
+            "$IP link del dev $DUMMY type dummy || /bin/true",
+            "$IP link add dev $DUMMY txqueuelen 1000 type dummy",
+            "$TC qdisc add dev $DUMMY handle 1: root pfifo"
         ],
-        "cmdUnderTest": "$TC qdisc replace dev $DEV1 handle 1: root pfifo limit 30",
+        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root pfifo limit 30",
         "expExitCode": "0",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc pfifo 1: root.*limit 30p",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 handle 1: root pfifo",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY handle 1: root pfifo",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -210,15 +210,15 @@
             "fifo"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root bfifo limit foo-bar",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root bfifo limit foo-bar",
         "expExitCode": "1",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc bfifo 1: root.*limit foo-bar",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -229,17 +229,17 @@
             "fifo"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 handle 1: root bfifo"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root bfifo"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root bfifo",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root bfifo",
         "expExitCode": "2",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc bfifo 1: root",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 handle 1: root bfifo",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY handle 1: root bfifo",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -250,15 +250,15 @@
             "fifo"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc del dev $DEV1 root handle 1: bfifo",
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY root handle 1: bfifo",
         "expExitCode": "2",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc bfifo 1: root",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -269,15 +269,15 @@
             "fifo"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 root handle 123^ bfifo limit 100b",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY root handle 123^ bfifo limit 100b",
         "expExitCode": "255",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc bfifo 123 root",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -288,17 +288,17 @@
             "fifo"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 root handle 1: bfifo",
-            "$TC qdisc del dev $DEV1 root handle 1: bfifo"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY root handle 1: bfifo",
+            "$TC qdisc del dev $DUMMY root handle 1: bfifo"
         ],
-        "cmdUnderTest": "$TC qdisc del dev $DEV1 handle 1: root bfifo",
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root bfifo",
         "expExitCode": "2",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc bfifo 1: root",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ingress.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ingress.json
index f518c55f468b..d99dba6e2b1a 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ingress.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/ingress.json
@@ -7,16 +7,16 @@
             "ingress"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 ingress",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY ingress",
         "expExitCode": "0",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc ingress ffff:",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -27,15 +27,15 @@
             "ingress"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 ingress foorbar",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY ingress foorbar",
         "expExitCode": "1",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc ingress ffff:",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -46,17 +46,17 @@
             "ingress"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 ingress",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY ingress",
         "expExitCode": "2",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc ingress ffff:",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 ingress",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY ingress",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -67,15 +67,15 @@
             "ingress"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc del dev $DEV1 ingress",
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY ingress",
         "expExitCode": "2",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc ingress ffff:",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -86,17 +86,17 @@
             "ingress"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 ingress",
-            "$TC qdisc del dev $DEV1 ingress"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY ingress",
+            "$TC qdisc del dev $DUMMY ingress"
         ],
-        "cmdUnderTest": "$TC qdisc del dev $DEV1 ingress",
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY ingress",
         "expExitCode": "2",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc ingress ffff:",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/prio.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/prio.json
index 9c792fa8ca23..3076c02d08d6 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/prio.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/prio.json
@@ -7,16 +7,16 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root prio",
         "expExitCode": "0",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc prio 1: root",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 handle 1: root prio",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY handle 1: root prio",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -27,15 +27,15 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 root handle ffff: prio",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY root handle ffff: prio",
         "expExitCode": "0",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc prio ffff: root",
         "matchCount": "1",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -46,15 +46,15 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 root handle 10000: prio",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY root handle 10000: prio",
         "expExitCode": "255",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc prio 10000: root",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -65,15 +65,15 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio foorbar",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root prio foorbar",
         "expExitCode": "1",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc prio 1: root",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -84,16 +84,16 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio bands 4 priomap 1 1 2 2 3 3 0 0 1 2 3 0 0 0 0 0",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root prio bands 4 priomap 1 1 2 2 3 3 0 0 1 2 3 0 0 0 0 0",
         "expExitCode": "0",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc prio 1: root.*bands 4 priomap.*1 1 2 2 3 3 0 0 1 2 3 0 0 0 0 0",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 handle 1: root prio",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY handle 1: root prio",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -104,15 +104,15 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio bands 4 priomap 1 1 2 2 3 3 0 0 1 2 3 0 0 0 0 0 1 1",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root prio bands 4 priomap 1 1 2 2 3 3 0 0 1 2 3 0 0 0 0 0 1 1",
         "expExitCode": "1",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc prio 1: root.*bands 4 priomap.*1 1 2 2 3 3 0 0 1 2 3 0 0 0 0 0 1 1",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -123,15 +123,15 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio bands 4 priomap 1 1 2 2 7 5 0 0 1 2 3 0 0 0 0 0",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root prio bands 4 priomap 1 1 2 2 7 5 0 0 1 2 3 0 0 0 0 0",
         "expExitCode": "1",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc prio 1: root.*bands 4 priomap.*1 1 2 2 7 5 0 0 1 2 3 0 0 0 0 0",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -142,15 +142,15 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio bands 1 priomap 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root prio bands 1 priomap 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0",
         "expExitCode": "2",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc prio 1: root.*bands 1 priomap.*0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -161,15 +161,15 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio bands 1024 priomap 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root prio bands 1024 priomap 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16",
         "expExitCode": "2",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc prio 1: root.*bands 1024 priomap.*1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -180,17 +180,17 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 handle 1: root prio"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root prio"
         ],
-        "cmdUnderTest": "$TC qdisc replace dev $DEV1 handle 1: root prio bands 8 priomap 1 1 2 2 3 3 4 4 5 5 6 6 7 7 0 0",
+        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root prio bands 8 priomap 1 1 2 2 3 3 4 4 5 5 6 6 7 7 0 0",
         "expExitCode": "0",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc prio 1: root.*bands 8 priomap.*1 1 2 2 3 3 4 4 5 5 6 6 7 7 0 0",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 handle 1: root prio",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY handle 1: root prio",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -201,17 +201,17 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 handle 1: root prio"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root prio"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 handle 1: root prio",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root prio",
         "expExitCode": "2",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc prio 1: root",
         "matchCount": "1",
         "teardown": [
-            "$TC qdisc del dev $DEV1 handle 1: root prio",
-            "$IP link del dev $DEV1 type dummy"
+            "$TC qdisc del dev $DUMMY handle 1: root prio",
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -222,15 +222,15 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc del dev $DEV1 root handle 1: prio",
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY root handle 1: prio",
         "expExitCode": "2",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc prio 1: root",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -241,15 +241,15 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true"
+            "$IP link add dev $DUMMY type dummy || /bin/true"
         ],
-        "cmdUnderTest": "$TC qdisc add dev $DEV1 root handle 123^ prio",
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY root handle 123^ prio",
         "expExitCode": "255",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc prio 123 root",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     },
     {
@@ -260,17 +260,17 @@
             "prio"
         ],
         "setup": [
-            "$IP link add dev $DEV1 type dummy || /bin/true",
-            "$TC qdisc add dev $DEV1 root handle 1: prio",
-            "$TC qdisc del dev $DEV1 root handle 1: prio"
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY root handle 1: prio",
+            "$TC qdisc del dev $DUMMY root handle 1: prio"
         ],
-        "cmdUnderTest": "$TC qdisc del dev $DEV1 handle 1: root prio",
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root prio",
         "expExitCode": "2",
-        "verifyCmd": "$TC qdisc show dev $DEV1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
         "matchPattern": "qdisc ingress ffff:",
         "matchCount": "0",
         "teardown": [
-            "$IP link del dev $DEV1 type dummy"
+            "$IP link del dev $DUMMY type dummy"
         ]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tdc_config.py b/tools/testing/selftests/tc-testing/tdc_config.py
index b771d4c89621..080709cc4297 100644
--- a/tools/testing/selftests/tc-testing/tdc_config.py
+++ b/tools/testing/selftests/tc-testing/tdc_config.py
@@ -16,6 +16,7 @@ NAMES = {
           'DEV0': 'v0p0',
           'DEV1': 'v0p1',
           'DEV2': '',
+          'DUMMY': 'dummy1',
           'BATCH_FILE': './batch.txt',
           'BATCH_DIR': 'tmp',
           # Length of time in seconds to wait before terminating a command
-- 
2.21.0

