Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D761D2E8B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 13:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgENLkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 07:40:42 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39813 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726232AbgENLkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 07:40:42 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 May 2020 14:40:36 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04EBeZKe031451;
        Thu, 14 May 2020 14:40:36 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net-next 4/4] selftests: implement flower classifier terse dump tests
Date:   Thu, 14 May 2020 14:40:26 +0300
Message-Id: <20200514114026.27047-5-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200514114026.27047-1-vladbu@mellanox.com>
References: <20200514114026.27047-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement two basic tests to verify terse dump functionality of flower
classifier:

- Test that verifies that terse dump works.

- Test that verifies that terse dump doesn't print filter key.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 .../tc-testing/tc-tests/filters/tests.json    | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
index 8877f7b2b809..2d180865c857 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/tests.json
@@ -87,5 +87,43 @@
         "teardown": [
             "$TC qdisc del dev $DEV2 ingress"
         ]
+    },
+    {
+        "id": "7c65",
+        "name": "Add flower filter and then terse dump it",
+        "category": [
+            "filter",
+            "flower"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV2 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip pref 1 ingress flower dst_mac e4:11:22:11:4a:51 action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show terse dev $DEV2 ingress",
+        "matchPattern": "filter protocol ip pref 1 flower.*handle",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV2 ingress"
+        ]
+    },
+    {
+        "id": "d45e",
+        "name": "Add flower filter and verify that terse dump doesn't output filter key",
+        "category": [
+            "filter",
+            "flower"
+        ],
+        "setup": [
+            "$TC qdisc add dev $DEV2 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV2 protocol ip pref 1 ingress flower dst_mac e4:11:22:11:4a:51 action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show terse dev $DEV2 ingress",
+        "matchPattern": "  dst_mac e4:11:22:11:4a:51",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV2 ingress"
+        ]
     }
 ]
-- 
2.21.0

