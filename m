Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668395B85E2
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiINKBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbiINKBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:01:03 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3798E6AA17;
        Wed, 14 Sep 2022 03:00:50 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MSG1m14HJzNmG6;
        Wed, 14 Sep 2022 17:56:12 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 14 Sep
 2022 18:00:46 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2 9/9] selftests/tc-testings: add list case for basic filter
Date:   Wed, 14 Sep 2022 18:02:21 +0800
Message-ID: <20220914100221.386855-10-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220914100221.386855-1-shaozhengchao@huawei.com>
References: <20220914100221.386855-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test 0811: Add multiple basic filter with cmp ematch u8/link layer and
default action and dump them
Test 5129: List basic filters

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/filters/basic.json    | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
index e788c114a484..d1278de8ebc3 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/basic.json
@@ -1274,5 +1274,52 @@
         "teardown": [
             "$TC qdisc del dev $DEV1 ingress"
         ]
+    },
+    {
+        "id": "0811",
+        "name": "Add multiple basic filter with cmp ematch u8/link layer and default action and dump them",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u8 at 0 layer link mask 0xff gt 10)' classid 1:1"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 2 protocol ip prio 1 basic match 'cmp(u8 at 0 layer link mask 0xff gt 10)' classid 1:1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "^filter protocol ip pref 1 basic",
+        "matchCount": "3",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "5129",
+        "name": "List basic filters",
+        "category": [
+            "filter",
+            "basic"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 basic match 'cmp(u8 at 0 layer link mask 0xff gt 10)' classid 1:1",
+            "$TC filter add dev $DEV1 parent ffff: handle 2 protocol ip prio 1 basic match 'cmp(u8 at 0 layer link mask 0xff gt 10)' classid 1:1"
+        ],
+        "cmdUnderTest": "$TC filter show dev $DEV1 parent ffff:",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "cmp\\(u8 at 0 layer 0 mask 0xff gt 10\\)",
+        "matchCount": "2",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
     }
 ]
-- 
2.17.1

