Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E025BB66B
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 07:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiIQFDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 01:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiIQFDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 01:03:17 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22247B6D01;
        Fri, 16 Sep 2022 22:03:15 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MTzHg5jFdzlVrL;
        Sat, 17 Sep 2022 12:59:11 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 17 Sep
 2022 13:03:12 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <toke@toke.dk>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>, <shuah@kernel.org>,
        <victor@mojatatu.com>
CC:     <zhijianx.li@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2 11/18] selftests/tc-testings: add selftests for mqprio qdisc
Date:   Sat, 17 Sep 2022 13:04:40 +0800
Message-ID: <20220917050440.131962-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test 9903: Add mqprio Qdisc to multi-queue device (8 queues)
Test 453a: Delete nonexistent mqprio Qdisc
Test 5292: Delete mqprio Qdisc twice
Test 45a9: Add mqprio Qdisc to single-queue device
Test 2ba9: Show mqprio class

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/qdiscs/mqprio.json    | 114 ++++++++++++++++++
 1 file changed, 114 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/mqprio.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mqprio.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mqprio.json
new file mode 100644
index 000000000000..6e1973f731e9
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/mqprio.json
@@ -0,0 +1,114 @@
+[
+    {
+        "id": "9903",
+        "name": "Add mqprio Qdisc to multi-queue device (8 queues)",
+        "category": [
+            "qdisc",
+            "mqprio"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mqprio num_tc 8 map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $ETH",
+        "matchPattern": "qdisc mqprio 1: root tc 8 map 0 1 2 3 4 5 6 7 0 0 0 0 0 0 0 0.*queues:\\(0:0\\) \\(1:1\\) \\(2:2\\) \\(3:3\\) \\(4:4\\) \\(5:5\\) \\(6:6\\) \\(7:7\\)",
+        "matchCount": "1",
+        "teardown": [
+            "echo \"1\" > /sys/bus/netdevsim/del_device"
+        ]
+    },
+    {
+        "id": "453a",
+        "name": "Delete nonexistent mqprio Qdisc",
+        "category": [
+            "qdisc",
+            "mqprio"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "echo \"1 1 4\" > /sys/bus/netdevsim/new_device"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $ETH root handle 1: mqprio",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $ETH",
+        "matchPattern": "qdisc mqprio 1: root",
+        "matchCount": "0",
+        "teardown": [
+            "echo \"1\" > /sys/bus/netdevsim/del_device"
+        ]
+    },
+    {
+        "id": "5292",
+        "name": "Delete mqprio Qdisc twice",
+        "category": [
+            "qdisc",
+            "mqprio"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device",
+            "$TC qdisc add dev $ETH root handle 1: mqprio num_tc 8 map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0",
+            "$TC qdisc del dev $ETH root handle 1:"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $ETH root handle 1:",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $ETH",
+        "matchPattern": "qdisc mqprio 1: root",
+        "matchCount": "0",
+        "teardown": [
+            "echo \"1\" > /sys/bus/netdevsim/del_device"
+        ]
+    },
+    {
+        "id": "45a9",
+        "name": "Add mqprio Qdisc to single-queue device",
+        "category": [
+            "qdisc",
+            "mqprio"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "echo \"1 1\" > /sys/bus/netdevsim/new_device"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mqprio num_tc 8 map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $ETH",
+        "matchPattern": "qdisc mqprio 1: root",
+        "matchCount": "0",
+        "teardown": [
+            "echo \"1\" > /sys/bus/netdevsim/del_device"
+        ]
+    },
+    {
+        "id": "2ba9",
+        "name": "Show mqprio class",
+        "category": [
+            "qdisc",
+            "mqprio"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: mqprio num_tc 8 map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $ETH",
+        "matchPattern": "class mqprio 1:",
+        "matchCount": "16",
+        "teardown": [
+            "echo \"1\" > /sys/bus/netdevsim/del_device"
+        ]
+    }
+]
-- 
2.17.1

