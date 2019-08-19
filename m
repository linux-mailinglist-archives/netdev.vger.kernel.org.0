Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8346191E57
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 09:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfHSHxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 03:53:51 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58650 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726880AbfHSHxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 03:53:50 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 19 Aug 2019 10:53:43 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7J7rgG2010776;
        Mon, 19 Aug 2019 10:53:43 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jhs@mojatatu.com, lucasb@mojatatu.com,
        mrv@mojatatu.com, shuah@kernel.org, batuhanosmantaskaya@gmail.com,
        dcaratti@redhat.com, marcelo.leitner@gmail.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next 2/2] tc-testing: concurrency: wrap piped rule update commands
Date:   Mon, 19 Aug 2019 10:52:08 +0300
Message-Id: <20190819075208.12240-3-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190819075208.12240-1-vladbu@mellanox.com>
References: <20190819075208.12240-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Concurrent tests use several commands to update rules in parallel: 'find'
prints names of batch files in tmp directory and pipes result to 'xargs'
which runs instance of tc per batch file in parallel. This breaks when used
with ns plugin that adds 'ip netns exec $NS' prefix to the command, which
causes only first command in pipe to be executed in namespace:

=====> Test e41d: Add 1M flower filters with 10 parallel tc instances
-----> prepare stage
ns/SubPlugin.adjust_command
adjust_command:  stage is setup; inserting netns stuff in command [/bin/mkdir tmp] list [['/bin/mkdir', 'tmp']]
adjust_command:  return command [ip netns exec tcut /bin/mkdir tmp]
command "ip netns exec tcut /bin/mkdir tmp"
ns/SubPlugin.adjust_command
adjust_command:  stage is setup; inserting netns stuff in command [/sbin/tc qdisc add dev ens1f0 ingress] list [['/sbin/tc', 'qdisc', 'add', 'dev', 'ens1f0', 'ingress']]
adjust_command:  return command [ip netns exec tcut /sbin/tc qdisc add dev ens1f0 ingress]
command "ip netns exec tcut /sbin/tc qdisc add dev ens1f0 ingress"
ns/SubPlugin.adjust_command
adjust_command:  stage is setup; inserting netns stuff in command [./tdc_multibatch.py ens1f0 tmp 100000 10 add] list [['./tdc_multibatch.py', 'ens1f0', 'tmp', '100000', '10', 'add']]
adjust_command:  return command [ip netns exec tcut ./tdc_multibatch.py ens1f0 tmp 100000 10 add]
command "ip netns exec tcut ./tdc_multibatch.py ens1f0 tmp 100000 10 add"
-----> execute stage
ns/SubPlugin.adjust_command
adjust_command:  stage is execute; inserting netns stuff in command [find tmp/add* -print | xargs -n 1 -P 10 /sbin/tc -b] list [['find', 'tmp/add*', '-print', '|', 'xargs', '-n', '1', '-P', '10', '/sbin/tc', '-b']
]
adjust_command:  return command [ip netns exec tcut find tmp/add* -print | xargs -n 1 -P 10 /sbin/tc -b]
command "ip netns exec tcut find tmp/add* -print | xargs -n 1 -P 10 /sbin/tc -b"
exit: 123
exit: 0
Cannot find device "ens1f0"
Cannot find device "ens1f0"
Command failed tmp/add_0:1
Command failed tmp/add_1:1
Cannot find device "ens1f0"
Command failed tmp/add_2:1
Cannot find device "ens1f0"
Command failed tmp/add_4:1
Cannot find device "ens1f0"
Command failed tmp/add_3:1
Cannot find device "ens1f0"
Command failed tmp/add_5:1
Cannot find device "ens1f0"
Command failed tmp/add_6:1
Cannot find device "ens1f0"
Command failed tmp/add_8:1
Cannot find device "ens1f0"
Command failed tmp/add_7:1
Cannot find device "ens1f0"
Command failed tmp/add_9:1

Fix the issue by executing whole compound command in namespace by wrapping
it in 'bash -c' invocation.

Fixes: 489ce2f42514 ("tc-testing: Restore original behaviour for namespaces in tdc")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 .../tc-tests/filters/concurrency.json          | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/concurrency.json b/tools/testing/selftests/tc-testing/tc-tests/filters/concurrency.json
index 9002714b1851..c2a433a4737e 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/concurrency.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/concurrency.json
@@ -12,7 +12,7 @@
             "$TC qdisc add dev $DEV2 ingress",
             "./tdc_multibatch.py $DEV2 $BATCH_DIR 100000 10 add"
         ],
-        "cmdUnderTest": "find $BATCH_DIR/add* -print | xargs -n 1 -P 10 $TC -b",
+        "cmdUnderTest": "bash -c \"find $BATCH_DIR/add* -print | xargs -n 1 -P 10 $TC -b\"",
         "expExitCode": "0",
         "verifyCmd": "$TC -s filter show dev $DEV2 ingress",
         "matchPattern": "filter protocol ip pref 1 flower chain 0 handle",
@@ -37,7 +37,7 @@
             "$TC -b $BATCH_DIR/add_0",
             "./tdc_multibatch.py $DEV2 $BATCH_DIR 100000 10 del"
         ],
-        "cmdUnderTest": "find $BATCH_DIR/del* -print | xargs -n 1 -P 10 $TC -b",
+        "cmdUnderTest": "bash -c \"find $BATCH_DIR/del* -print | xargs -n 1 -P 10 $TC -b\"",
         "expExitCode": "0",
         "verifyCmd": "$TC -s filter show dev $DEV2 ingress",
         "matchPattern": "filter protocol ip pref 1 flower chain 0 handle",
@@ -62,7 +62,7 @@
             "$TC -b $BATCH_DIR/add_0",
             "./tdc_multibatch.py $DEV2 $BATCH_DIR 100000 10 replace"
         ],
-        "cmdUnderTest": "find $BATCH_DIR/replace* -print | xargs -n 1 -P 10 $TC -b",
+        "cmdUnderTest": "bash -c \"find $BATCH_DIR/replace* -print | xargs -n 1 -P 10 $TC -b\"",
         "expExitCode": "0",
         "verifyCmd": "$TC -s filter show dev $DEV2 ingress",
         "matchPattern": "filter protocol ip pref 1 flower chain 0 handle",
@@ -87,7 +87,7 @@
             "$TC -b $BATCH_DIR/add_0",
             "./tdc_multibatch.py -d $DEV2 $BATCH_DIR 100000 10 replace"
         ],
-        "cmdUnderTest": "find $BATCH_DIR/replace* -print | xargs -n 1 -P 10 $TC -b",
+        "cmdUnderTest": "bash -c \"find $BATCH_DIR/replace* -print | xargs -n 1 -P 10 $TC -b\"",
         "expExitCode": "0",
         "verifyCmd": "$TC -s filter show dev $DEV2 ingress",
         "matchPattern": "filter protocol ip pref 1 flower chain 0 handle",
@@ -112,7 +112,7 @@
             "$TC -b $BATCH_DIR/add_0",
             "./tdc_multibatch.py -d $DEV2 $BATCH_DIR 100000 10 del"
         ],
-        "cmdUnderTest": "find $BATCH_DIR/del* -print | xargs -n 1 -P 10 $TC -f -b",
+        "cmdUnderTest": "bash -c \"find $BATCH_DIR/del* -print | xargs -n 1 -P 10 $TC -f -b\"",
         "expExitCode": "123",
         "verifyCmd": "$TC -s filter show dev $DEV2 ingress",
         "matchPattern": "filter protocol ip pref 1 flower chain 0 handle",
@@ -134,11 +134,11 @@
             "/bin/mkdir $BATCH_DIR",
             "$TC qdisc add dev $DEV2 ingress",
             "./tdc_multibatch.py -x init_ $DEV2 $BATCH_DIR 100000 5 add",
-            "find $BATCH_DIR/init_* -print | xargs -n 1 -P 5 $TC -b",
+            "bash -c \"find $BATCH_DIR/init_* -print | xargs -n 1 -P 5 $TC -b\"",
             "./tdc_multibatch.py -x par_ -a 500001 -m 5 $DEV2 $BATCH_DIR 100000 5 add",
             "./tdc_multibatch.py -x par_ $DEV2 $BATCH_DIR 100000 5 del"
         ],
-        "cmdUnderTest": "find $BATCH_DIR/par_* -print | xargs -n 1 -P 10 $TC -b",
+        "cmdUnderTest": "bash -c \"find $BATCH_DIR/par_* -print | xargs -n 1 -P 10 $TC -b\"",
         "expExitCode": "0",
         "verifyCmd": "$TC -s filter show dev $DEV2 ingress",
         "matchPattern": "filter protocol ip pref 1 flower chain 0 handle",
@@ -160,11 +160,11 @@
             "/bin/mkdir $BATCH_DIR",
             "$TC qdisc add dev $DEV2 ingress",
             "./tdc_multibatch.py -x init_ $DEV2 $BATCH_DIR 100000 10 add",
-            "find $BATCH_DIR/init_* -print | xargs -n 1 -P 5 $TC -b",
+            "bash -c \"find $BATCH_DIR/init_* -print | xargs -n 1 -P 5 $TC -b\"",
             "./tdc_multibatch.py -x par_ -a 500001 -m 5 $DEV2 $BATCH_DIR 100000 5 replace",
             "./tdc_multibatch.py -x par_ $DEV2 $BATCH_DIR 100000 5 del"
         ],
-        "cmdUnderTest": "find $BATCH_DIR/par_* -print | xargs -n 1 -P 10 $TC -b",
+        "cmdUnderTest": "bash -c \"find $BATCH_DIR/par_* -print | xargs -n 1 -P 10 $TC -b\"",
         "expExitCode": "0",
         "verifyCmd": "$TC -s filter show dev $DEV2 ingress",
         "matchPattern": "filter protocol ip pref 1 flower chain 0 handle",
-- 
2.21.0

