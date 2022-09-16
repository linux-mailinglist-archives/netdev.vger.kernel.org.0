Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7983E5BA4FD
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 05:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiIPDE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 23:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiIPDEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 23:04:35 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B433E9E0D5;
        Thu, 15 Sep 2022 20:04:14 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MTJh7701jzNmJs;
        Fri, 16 Sep 2022 10:59:35 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 16 Sep
 2022 11:04:12 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <cake@lists.bufferbloat.net>,
        <linux-kselftest@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <toke@toke.dk>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>, <shuah@kernel.org>,
        <victor@mojatatu.com>
CC:     <zhijianx.li@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next 12/18] selftests/tc-testings: add selftests for multiq qdisc
Date:   Fri, 16 Sep 2022 11:05:38 +0800
Message-ID: <20220916030544.228274-13-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220916030544.228274-1-shaozhengchao@huawei.com>
References: <20220916030544.228274-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test 20ba: Add multiq Qdisc to multi-queue device (8 queues)
Test 9903: List multiq Class
Test 7832: Delete nonexistent multiq Qdisc
Test 2891: Delete multiq Qdisc twice
Test 1329: Add multiq Qdisc to single-queue device

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/qdiscs/multiq.json    | 114 ++++++++++++++++++
 1 file changed, 114 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/multiq.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/multiq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/multiq.json
new file mode 100644
index 000000000000..2ae813f676a5
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/multiq.json
@@ -0,0 +1,114 @@
+[
+    {
+        "id": "20ba",
+        "name": "Add multiq Qdisc to multi-queue device (8 queues)",
+        "category": [
+            "qdisc",
+            "multiq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: multiq",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $ETH",
+        "matchPattern": "qdisc multiq 1: root refcnt [0-9]+ bands 8",
+        "matchCount": "1",
+        "teardown": [
+            "echo \"1\" > /sys/bus/netdevsim/del_device"
+        ]
+    },
+    {
+        "id": "9903",
+        "name": "List multiq Class",
+        "category": [
+            "qdisc",
+            "multiq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: multiq",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $ETH",
+        "matchPattern": "class multiq 1:[0-9]+ parent 1:",
+        "matchCount": "8",
+        "teardown": [
+            "echo \"1\" > /sys/bus/netdevsim/del_device"
+        ]
+    },
+    {
+        "id": "7832",
+        "name": "Delete nonexistent multiq Qdisc",
+        "category": [
+            "qdisc",
+            "multiq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "echo \"1 1 4\" > /sys/bus/netdevsim/new_device"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $ETH root handle 1: multiq",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $ETH",
+        "matchPattern": "qdisc multiq 1: root",
+        "matchCount": "0",
+        "teardown": [
+            "echo \"1\" > /sys/bus/netdevsim/del_device"
+        ]
+    },
+    {
+        "id": "2891",
+        "name": "Delete multiq Qdisc twice",
+        "category": [
+            "qdisc",
+            "multiq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "echo \"1 1 8\" > /sys/bus/netdevsim/new_device",
+            "$TC qdisc add dev $ETH root handle 1: multiq",
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
+        "id": "1329",
+        "name": "Add multiq Qdisc to single-queue device",
+        "category": [
+            "qdisc",
+            "multiq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "echo \"1 1\" > /sys/bus/netdevsim/new_device"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $ETH root handle 1: multiq",
+        "expExitCode": "2",
+        "verifyCmd": "$TC qdisc show dev $ETH",
+        "matchPattern": "qdisc multiq 1: root",
+        "matchCount": "0",
+        "teardown": [
+            "echo \"1\" > /sys/bus/netdevsim/del_device"
+        ]
+    }
+]
-- 
2.17.1

