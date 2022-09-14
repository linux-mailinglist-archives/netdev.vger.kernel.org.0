Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CFD5B85D4
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiINKBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbiINKAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:00:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CEA67160;
        Wed, 14 Sep 2022 03:00:46 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MSG2g3DGSzmVJ4;
        Wed, 14 Sep 2022 17:56:59 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 14 Sep
 2022 18:00:43 +0800
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
Subject: [PATCH net-next,v2 6/9] selftests/tc-testings: add selftests for route filter
Date:   Wed, 14 Sep 2022 18:02:18 +0800
Message-ID: <20220914100221.386855-7-shaozhengchao@huawei.com>
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

Test e122: Add route filter with from and to tag
Test 6573: Add route filter with fromif and to tag
Test 1362: Add route filter with to flag and reclassify action
Test 4720: Add route filter with from flag and continue actions
Test 2812: Add route filter with form tag and pipe action
Test 7994: Add route filter with miltiple actions
Test 4312: List route filters
Test 2634: Delete route filter with pipe action

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/filters/route.json    | 181 ++++++++++++++++++
 1 file changed, 181 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/route.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/route.json b/tools/testing/selftests/tc-testing/tc-tests/filters/route.json
new file mode 100644
index 000000000000..82ae46dabeaf
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/route.json
@@ -0,0 +1,181 @@
+[
+    {
+        "id": "e122",
+        "name": "Add route filter with from and to tag",
+        "category": [
+            "filter",
+            "route"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: protocol ip prio 100 route from 1 to 10 classid 1:10",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter ls dev $DEV1 parent ffff:",
+        "matchPattern": "flowid 1:10 to 10 from 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "6573",
+        "name": "Add route filter with fromif and to tag",
+        "category": [
+            "filter",
+            "route"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: protocol ip prio 100 route fromif $DEV1 to 10 classid 1:10",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter ls dev $DEV1 parent ffff:",
+        "matchPattern": "flowid 1:10 to 10 fromif",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "1362",
+        "name": "Add route filter with to flag and reclassify action",
+        "category": [
+            "filter",
+            "route"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: protocol ip prio 2 route to 10 classid 1:20 action reclassify",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter ls dev $DEV1 parent ffff:",
+        "matchPattern": "filter protocol ip pref.*route chain [0-9]+.*flowid 1:20 to 10.*action order [0-9]+: gact action reclassify",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4720",
+        "name": "Add route filter with from flag and continue actions",
+        "category": [
+            "filter",
+            "route"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: protocol ip prio 2 route from 10 classid 1:100 action continue",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter ls dev $DEV1 parent ffff:",
+        "matchPattern": "filter protocol ip pref.*route chain [0-9]+.*flowid 1:100 from 10.*action continue",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2812",
+        "name": "Add route filter with form tag and pipe action",
+        "category": [
+            "filter",
+            "route"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: protocol ip prio 2 route from 10 to 2 classid 1:1 action pipe",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter ls dev $DEV1 parent ffff:",
+        "matchPattern": "filter protocol ip pref.*route chain [0-9]+.*flowid 1:1 to 2 from 10.*action pipe",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "7994",
+        "name": "Add route filter with miltiple actions",
+        "category": [
+            "filter",
+            "route"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: protocol ip prio 2 route from 10 to 2 classid 1:1 action skbedit mark 7 pipe action gact drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter ls dev $DEV1 parent ffff:",
+        "matchPattern": "filter protocol ip pref.*route chain [0-9]+.*flowid 1:1 to 2 from 10.*action order [0-9]+: skbedit  mark 7 pipe.*action order [0-9]+: gact action drop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4312",
+        "name": "List route filters",
+        "category": [
+            "filter",
+            "route"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 parent ffff: protocol ip prio 2 route from 10 to 2 classid 1:1 action pipe",
+	    "$TC filter add dev $DEV1 parent ffff: protocol ip prio 2 route from 20 to 1 classid 1:20 action pipe"
+	],
+        "cmdUnderTest": "$TC filter show dev $DEV1 parent ffff:",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "action order [0-9]+: gact action pipe",
+        "matchCount": "2",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2634",
+        "name": "Delete route filter with pipe action",
+        "category": [
+            "filter",
+            "route"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 parent ffff: protocol ip prio 2 route from 10 to 2 classid 1:1 action pipe"
+        ],
+        "cmdUnderTest": "$TC filter del dev $DEV1 parent ffff: protocol ip prio 2 route from 10 to 2 classid 1:1 action pipe",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "filter protocol ip pref.*route chain [0-9]+.*flowid 1:1 to 2 from 10.*action pipe",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    }
+]
-- 
2.17.1

