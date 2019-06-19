Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A424C2C1
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfFSVKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:10:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43604 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfFSVKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 17:10:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 51B72223892;
        Wed, 19 Jun 2019 21:10:05 +0000 (UTC)
Received: from new-host.redhat.com (ovpn-204-42.brq.redhat.com [10.40.204.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA4FE608A7;
        Wed, 19 Jun 2019 21:10:03 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Vlad Buslov <vladbu@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Lucas Bates <lucasb@mojatatu.com>
Subject: [PATCH net] net/sched: flower: fix infinite loop in fl_walk()
Date:   Wed, 19 Jun 2019 23:09:07 +0200
Message-Id: <9068475730862e1d9014c16cee0ad2734a4dd1f9.1560978242.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 19 Jun 2019 21:10:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

on some CPUs (e.g. i686), tcf_walker.cookie has the same size as the IDR.
In this situation, the following script:

 # tc filter add dev eth0 ingress handle 0xffffffff flower action ok
 # tc filter show dev eth0 ingress

results in an infinite loop. It happened also on other CPUs (e.g x86_64),
before commit 061775583e35 ("net: sched: flower: introduce reference
counting for filters"), because 'handle' + 1 made the u32 overflow before
it was assigned to 'cookie'; but that commit replaced the assignment with
a self-increment of 'cookie', so the problem was indirectly fixed.

Ensure not to call idr_get_next_ul() when 'cookie' contains an overflowed
value, and bail out of fl_walk() when its value is equal to ULONG_MAX.
While at it, add a TDC selftest that can be used to reproduce the problem.

 test results (on 5.2.0-0.rc5.git0.1.fc31.i686)

 unpatched (or affected) kernel:
 # ./tdc.py  -e 2ff3 -d dum0
 Test 2ff3: Add flower with max handle and then dump it
 All test results:
 1..1
 not ok 1 2ff3 - Add flower with max handle and then dump it
         Could not match regex pattern. Verify command output:
 Command "/sbin/tc filter show dev dum0 ingress" timed out

 patched (or unaffected) kernel:
 # ./tdc.py  -e 2ff3 -d dum0
 Test 2ff3: Add flower with max handle and then dump it
 All test results:
 1..1
 ok 1 2ff3 - Add flower with max handle and then dump it

Fixes: 01683a146999 ("net: sched: refactor flower walk to iterate over idr")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/cls_flower.c                        |  2 ++
 .../tc-testing/tc-tests/filters/tests.json    | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index eedd5786c084..acc86ae159f4 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1702,6 +1702,8 @@ static void fl_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 			break;
 		}
 		__fl_put(f);
+		if (arg->cookie == ULONG_MAX)
+			break;
 		arg->cookie++;
 		arg->count++;
 	}
diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
index e2f92cefb8d5..16559c436f21 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
@@ -38,6 +38,25 @@
             "$TC qdisc del dev $DEV1 clsact"
         ]
     },
+    {
+        "id": "2ff3",
+        "name": "Add flower with max handle and then dump it",
+        "category": [
+            "filter",
+            "flower"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV2 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip pref 1 parent ffff: handle 0xffffffff flower action ok",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV2 ingress",
+        "matchPattern": "filter protocol ip pref 1 flower.*handle 0xffffffff",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV2 ingress"
+        ]
+    },
     {
         "id": "d052",
         "name": "Add 1M filters with the same action",
-- 
2.20.1

