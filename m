Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3105B85D1
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiINKAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiINKAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:00:44 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456D95FAE7;
        Wed, 14 Sep 2022 03:00:43 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MSG2c1pxRzmVBL;
        Wed, 14 Sep 2022 17:56:56 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 14 Sep
 2022 18:00:40 +0800
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
Subject: [PATCH net-next,v2 3/9] selftests/tc-testings: add selftests for bpf filter
Date:   Wed, 14 Sep 2022 18:02:15 +0800
Message-ID: <20220914100221.386855-4-shaozhengchao@huawei.com>
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

Test 23c3: Add cBPF filter with valid bytecode
Test 1563: Add cBPF filter with invalid bytecode
Test 2334: Add eBPF filter with valid object-file
Test 2373: Add eBPF filter with invalid object-file
Test 4423: Replace cBPF bytecode
Test 5122: Delete cBPF filter
Test e0a9: List cBPF filters

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/filters/bpf.json      | 171 ++++++++++++++++++
 1 file changed, 171 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json b/tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json
new file mode 100644
index 000000000000..625fafd11fcf
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json
@@ -0,0 +1,171 @@
+[
+    {
+        "id": "23c3",
+        "name": "Add cBPF filter with valid bytecode",
+        "category": [
+            "filter",
+            "bpf-filter"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
+        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1.*bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "1563",
+        "name": "Add cBPF filter with invalid bytecode",
+        "category": [
+            "filter",
+            "bpf-filter"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+	],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,31 0 1 2048,6 0 0 262144,6 0 0 0'",
+        "expExitCode": "2",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
+        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1.*bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2334",
+        "name": "Add eBPF filter with valid object-file",
+        "category": [
+            "filter",
+            "bpf-filter"
+        ],
+        "plugins": {
+                "requires": "buildebpfPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+	],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf object-file $EBPFDIR/action.o section action-ok",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
+        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1 action.o:\\[action-ok\\].*tag [0-9a-f]{16}( jited)?",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2373",
+        "name": "Add eBPF filter with invalid object-file",
+        "category": [
+            "filter",
+            "bpf-filter"
+        ],
+        "plugins": {
+                "requires": "buildebpfPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+	],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf object-file $EBPFDIR/action.o section action-ko",
+        "expExitCode": "1",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
+        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1 action.o:\\[action-ko\\].*tag [0-9a-f]{16}( jited)?",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+	]
+    },
+    {
+        "id": "4423",
+        "name": "Replace cBPF bytecode",
+        "category": [
+            "filter",
+            "bpf-filter"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            [
+                "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC filter replace dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2054,6 0 0 262144,6 0 0 0'",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
+        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1.*bytecode '4,40 0 0 12,21 0 1 2054,6 0 0 262144,6 0 0 0'",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+	]
+    },
+    {
+        "id": "5122",
+        "name": "Delete cBPF filter",
+        "category": [
+            "filter",
+            "bpf-filter"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+	    [
+                "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC filter del dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf",
+        "matchPattern": "filter parent ffff: protocol ip pref 100 bpf chain [0-9]+ handle 0x1.*bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+	]
+    },
+    {
+        "id": "e0a9",
+        "name": "List cBPF filters",
+        "category": [
+            "filter",
+            "bpf-filter"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+	    "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2048,6 0 0 262144,6 0 0 0'",
+            "$TC filter add dev $DEV1 parent ffff: handle 2 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 2054,6 0 0 262144,6 0 0 0'",
+            "$TC filter add dev $DEV1 parent ffff: handle 100 protocol ip prio 100 bpf bytecode '4,40 0 0 12,21 0 1 33024,6 0 0 262144,6 0 0 0'"
+        ],
+        "cmdUnderTest": "$TC filter show dev $DEV1 parent ffff:",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+	"matchPattern": "filter protocol ip pref 100 bpf chain [0-9]+ handle",
+        "matchCount": "3",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    }
+]
-- 
2.17.1

