Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84FD1D27F0
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 08:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgENGgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 02:36:11 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55764 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725818AbgENGgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 02:36:11 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 May 2020 09:36:09 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04E6a9wg000568;
        Thu, 14 May 2020 09:36:09 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     linux-kselftest@vger.kernel.org
Cc:     netdev@vger.kernel.org, shuah@kernel.org, davem@davemloft.net,
        xiyou.wangcong@gmail.com, jhs@mojatatu.com, dcaratti@redhat.com,
        marcelo.leitner@gmail.com, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH RESEND net-next] selftests: fix flower parent qdisc
Date:   Thu, 14 May 2020 09:35:52 +0300
Message-Id: <20200514063552.26678-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flower tests used to create ingress filter with specified parent qdisc
"parent ffff:" but dump them on "ingress". With recent commit that fixed
tcm_parent handling in dump those are not considered same parent anymore,
which causes iproute2 tc to emit additional "parent ffff:" in first line of
filter dump output. The change in output causes filter match in tests to
fail.

Prevent parent qdisc output when dumping filters in flower tests by always
correctly specifying "ingress" parent both when creating and dumping
filters.

Fixes: a7df4870d79b ("net_sched: fix tcm_parent in tc filter dump")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 .../selftests/tc-testing/tc-tests/filters/tests.json        | 6 +++---
 tools/testing/selftests/tc-testing/tdc_batch.py             | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
index 8877f7b2b809..12aa4bc1f6a0 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
@@ -32,7 +32,7 @@
         "setup": [
             "$TC qdisc add dev $DEV2 ingress"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip pref 1 parent ffff: handle 0xffffffff flower action ok",
+        "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip pref 1 ingress handle 0xffffffff flower action ok",
         "expExitCode": "0",
         "verifyCmd": "$TC filter show dev $DEV2 ingress",
         "matchPattern": "filter protocol ip pref 1 flower.*handle 0xffffffff",
@@ -77,9 +77,9 @@
         },
         "setup": [
             "$TC qdisc add dev $DEV2 ingress",
-            "$TC filter add dev $DEV2 protocol ip prio 1 parent ffff: flower dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50 ip_proto tcp src_ip 1.1.1.1 dst_ip 2.2.2.2 action drop"
+            "$TC filter add dev $DEV2 protocol ip prio 1 ingress flower dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50 ip_proto tcp src_ip 1.1.1.1 dst_ip 2.2.2.2 action drop"
         ],
-        "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip prio 1 parent ffff: flower dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50 ip_proto tcp src_ip 1.1.1.1 dst_ip 2.2.2.2 action drop",
+        "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip prio 1 ingress flower dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50 ip_proto tcp src_ip 1.1.1.1 dst_ip 2.2.2.2 action drop",
         "expExitCode": "2",
         "verifyCmd": "$TC -s filter show dev $DEV2 ingress",
         "matchPattern": "filter protocol ip pref 1 flower chain 0 handle",
diff --git a/tools/testing/selftests/tc-testing/tdc_batch.py b/tools/testing/selftests/tc-testing/tdc_batch.py
index 6a2bd2cf528e..995f66ce43eb 100755
--- a/tools/testing/selftests/tc-testing/tdc_batch.py
+++ b/tools/testing/selftests/tc-testing/tdc_batch.py
@@ -72,21 +72,21 @@ mac_prefix = args.mac_prefix
 
 def format_add_filter(device, prio, handle, skip, src_mac, dst_mac,
                       share_action):
-    return ("filter add dev {} {} protocol ip parent ffff: handle {} "
+    return ("filter add dev {} {} protocol ip ingress handle {} "
             " flower {} src_mac {} dst_mac {} action drop {}".format(
                 device, prio, handle, skip, src_mac, dst_mac, share_action))
 
 
 def format_rep_filter(device, prio, handle, skip, src_mac, dst_mac,
                       share_action):
-    return ("filter replace dev {} {} protocol ip parent ffff: handle {} "
+    return ("filter replace dev {} {} protocol ip ingress handle {} "
             " flower {} src_mac {} dst_mac {} action drop {}".format(
                 device, prio, handle, skip, src_mac, dst_mac, share_action))
 
 
 def format_del_filter(device, prio, handle, skip, src_mac, dst_mac,
                       share_action):
-    return ("filter del dev {} {} protocol ip parent ffff: handle {} "
+    return ("filter del dev {} {} protocol ip ingress handle {} "
             "flower".format(device, prio, handle))
 
 
-- 
2.21.0

