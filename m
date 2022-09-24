Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA295E87A8
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbiIXCvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbiIXCvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:51:01 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C74FD574F;
        Fri, 23 Sep 2022 19:51:00 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MZD1g5g15zlW3C;
        Sat, 24 Sep 2022 10:46:47 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 24 Sep
 2022 10:50:58 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v3 03/15] selftests/tc-testing: add selftests for codel qdisc
Date:   Sat, 24 Sep 2022 10:51:45 +0800
Message-ID: <20220924025157.331635-4-shaozhengchao@huawei.com>
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

Test 983a: Create CODEL with default setting
Test 38aa: Create CODEL with limit packet setting
Test 9178: Create CODEL with target setting
Test 78d1: Create CODEL with interval setting
Test 238a: Create CODEL with ecn setting
Test 939c: Create CODEL with ce_threshold setting
Test 8380: Delete CODEL with valid handle
Test 289c: Replace CODEL with limit setting
Test 0648: Change CODEL with limit setting

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 tools/testing/selftests/tc-testing/config     |   1 +
 .../tc-testing/tc-tests/qdiscs/codel.json     | 211 ++++++++++++++++++
 2 files changed, 212 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index e104e8ec30aa..a02f959abe66 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -14,6 +14,7 @@ CONFIG_NET_SCHED=y
 #
 CONFIG_NET_SCH_ATM=m
 CONFIG_NET_SCH_CHOKE=m
+CONFIG_NET_SCH_CODEL=m
 CONFIG_NET_SCH_PRIO=m
 CONFIG_NET_SCH_INGRESS=m
 
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json
new file mode 100644
index 000000000000..ea38099d48e5
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json
@@ -0,0 +1,211 @@
+[
+    {
+        "id": "983a",
+        "name": "Create CODEL with default setting",
+        "category": [
+            "qdisc",
+            "codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root codel",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1000p target 5ms interval 100ms",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "38aa",
+        "name": "Create CODEL with limit packet setting",
+        "category": [
+            "qdisc",
+            "codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root codel limit 1500",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1500p target 5ms interval 100ms",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "9178",
+        "name": "Create CODEL with target setting",
+        "category": [
+            "qdisc",
+            "codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root codel target 100ms",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1000p target 100ms interval 100ms",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "78d1",
+        "name": "Create CODEL with interval setting",
+        "category": [
+            "qdisc",
+            "codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root codel interval 20ms",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1000p target 5ms interval 20ms",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "238a",
+        "name": "Create CODEL with ecn setting",
+        "category": [
+            "qdisc",
+            "codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root codel ecn",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1000p target 5ms interval 100ms ecn",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "939c",
+        "name": "Create CODEL with ce_threshold setting",
+        "category": [
+            "qdisc",
+            "codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root codel ce_threshold 20ms",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1000p target 5ms ce_threshold 20ms interval 100ms",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "8380",
+        "name": "Delete CODEL with valid handle",
+        "category": [
+            "qdisc",
+            "codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root codel"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1000p target 5ms interval 100ms",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "289c",
+        "name": "Replace CODEL with limit setting",
+        "category": [
+            "qdisc",
+            "codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root codel"
+        ],
+        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root codel limit 5000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 5000p target 5ms interval 100ms",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "0648",
+        "name": "Change CODEL with limit setting",
+        "category": [
+            "qdisc",
+            "codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root codel"
+        ],
+        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: root codel limit 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 100p target 5ms interval 100ms",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.17.1

