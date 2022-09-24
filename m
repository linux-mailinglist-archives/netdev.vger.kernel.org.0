Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791895E87B4
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbiIXCvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbiIXCvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:51:03 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7C5DDD9B;
        Fri, 23 Sep 2022 19:51:02 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MZD1j6PC1zlWQk;
        Sat, 24 Sep 2022 10:46:49 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 24 Sep
 2022 10:51:00 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v3 07/15] selftests/tc-testing: add selftests for hhf qdisc
Date:   Sat, 24 Sep 2022 10:51:49 +0800
Message-ID: <20220924025157.331635-8-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220924025157.331635-1-shaozhengchao@huawei.com>
References: <20220924025157.331635-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test 4812: Create HHF with default setting
Test 8a92: Create HHF with limit setting
Test 3491: Create HHF with quantum setting
Test ba04: Create HHF with reset_timeout setting
Test 4238: Create HHF with admit_bytes setting
Test 839f: Create HHF with evict_timeout setting
Test a044: Create HHF with non_hh_weight setting
Test 32f9: Change HHF with limit setting
Test 385e: Show HHF class

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 tools/testing/selftests/tc-testing/config     |   1 +
 .../tc-testing/tc-tests/qdiscs/hhf.json       | 210 ++++++++++++++++++
 2 files changed, 211 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/hhf.json

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index d8db68440395..86d57d599d67 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -18,6 +18,7 @@ CONFIG_NET_SCH_CODEL=m
 CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_GRED=m
+CONFIG_NET_SCH_HHF=m
 CONFIG_NET_SCH_PRIO=m
 CONFIG_NET_SCH_INGRESS=m
 
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/hhf.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/hhf.json
new file mode 100644
index 000000000000..949f6e5de902
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/hhf.json
@@ -0,0 +1,210 @@
+[
+    {
+        "id": "4812",
+        "name": "Create HHF with default setting",
+        "category": [
+            "qdisc",
+            "hhf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root hhf",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc hhf 1: root refcnt [0-9]+.*hh_limit 2048 reset_timeout 40ms admit_bytes 128Kb evict_timeout 1s non_hh_weight 2",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "8a92",
+        "name": "Create HHF with limit setting",
+        "category": [
+            "qdisc",
+            "hhf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root hhf limit 1500",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc hhf 1: root refcnt [0-9]+ limit 1500p.*hh_limit 2048 reset_timeout 40ms admit_bytes 128Kb evict_timeout 1s non_hh_weight 2",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "3491",
+        "name": "Create HHF with quantum setting",
+        "category": [
+            "qdisc",
+            "hhf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root hhf quantum 9000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc hhf 1: root refcnt [0-9]+.*quantum 9000b hh_limit 2048 reset_timeout 40ms admit_bytes 128Kb evict_timeout 1s non_hh_weight 2",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "ba04",
+        "name": "Create HHF with reset_timeout setting",
+        "category": [
+            "qdisc",
+            "hhf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root hhf reset_timeout 100ms",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc hhf 1: root refcnt [0-9]+.*hh_limit 2048 reset_timeout 100ms admit_bytes 128Kb evict_timeout 1s non_hh_weight 2",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "4238",
+        "name": "Create HHF with admit_bytes setting",
+        "category": [
+            "qdisc",
+            "hhf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root hhf admit_bytes 100000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc hhf 1: root refcnt [0-9]+.*hh_limit 2048 reset_timeout 40ms admit_bytes 100000b evict_timeout 1s non_hh_weight 2",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "839f",
+        "name": "Create HHF with evict_timeout setting",
+        "category": [
+            "qdisc",
+            "hhf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root hhf evict_timeout 0.5s",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc hhf 1: root refcnt [0-9]+.*hh_limit 2048 reset_timeout 40ms admit_bytes 128Kb evict_timeout 500ms non_hh_weight 2",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "a044",
+        "name": "Create HHF with non_hh_weight setting",
+        "category": [
+            "qdisc",
+            "hhf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root hhf non_hh_weight 10",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc hhf 1: root refcnt [0-9]+.*hh_limit 2048 reset_timeout 40ms admit_bytes 128Kb evict_timeout 1s non_hh_weight 10",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "32f9",
+        "name": "Change HHF with limit setting",
+        "category": [
+            "qdisc",
+            "hhf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root hhf"
+        ],
+        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: root hhf limit 1500",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc hhf 1: root refcnt [0-9]+ limit 1500p.*hh_limit 2048 reset_timeout 40ms admit_bytes 128Kb evict_timeout 1s non_hh_weight 2",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "385e",
+        "name": "Show HHF class",
+        "category": [
+            "qdisc",
+            "hhf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root hhf",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class hhf 1:",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.17.1

