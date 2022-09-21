Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567C05BF3E9
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 04:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiIUCtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 22:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiIUCtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 22:49:32 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB8F99;
        Tue, 20 Sep 2022 19:49:28 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXN7M5vphzlWQm;
        Wed, 21 Sep 2022 10:45:19 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 10:49:26 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2 02/15] selftests/tc-testing: add selftests for choke qdisc
Date:   Wed, 21 Sep 2022 10:50:39 +0800
Message-ID: <20220921025052.23465-3-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220921025052.23465-1-shaozhengchao@huawei.com>
References: <20220921025052.23465-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test 8937: Create CHOKE with default setting
Test 48c0: Create CHOKE with min packet setting
Test 38c1: Create CHOKE with max packet setting
Test 234a: Create CHOKE with ecn setting
Test 4380: Create CHOKE with burst setting
Test 48c7: Delete CHOKE with valid handle
Test 4398: Replace CHOKE with min setting
Test 0301: Change CHOKE with limit setting

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/qdiscs/choke.json     | 188 ++++++++++++++++++
 1 file changed, 188 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/choke.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/choke.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/choke.json
new file mode 100644
index 000000000000..31b7775d25fc
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/choke.json
@@ -0,0 +1,188 @@
+[
+    {
+        "id": "8937",
+        "name": "Create CHOKE with default setting",
+        "category": [
+            "qdisc",
+            "choke"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root choke limit 1000 bandwidth 10000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc choke 1: root refcnt [0-9]+ limit 1000p min 83p max 250p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "48c0",
+        "name": "Create CHOKE with min packet setting",
+        "category": [
+            "qdisc",
+            "choke"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root choke limit 1000 bandwidth 10000 min 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc choke 1: root refcnt [0-9]+ limit 1000p min 100p max 250p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "38c1",
+        "name": "Create CHOKE with max packet setting",
+        "category": [
+            "qdisc",
+            "choke"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root choke limit 1000 bandwidth 10000 max 900",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc choke 1: root refcnt [0-9]+ limit 1000p min.*max 900p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "234a",
+        "name": "Create CHOKE with ecn setting",
+        "category": [
+            "qdisc",
+            "choke"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root choke limit 1000 bandwidth 10000 ecn",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc choke 1: root refcnt [0-9]+ limit 1000p min 83p max 250p ecn",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "4380",
+        "name": "Create CHOKE with burst setting",
+        "category": [
+            "qdisc",
+            "choke"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root choke limit 1000 bandwidth 10000 burst 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc choke 1: root refcnt [0-9]+ limit 1000p min 83p max 250p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "48c7",
+        "name": "Delete CHOKE with valid handle",
+        "category": [
+            "qdisc",
+            "choke"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root choke limit 1000 bandwidth 10000"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc choke 1: root refcnt [0-9]+ limit 1000p min 83p max 250p",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "4398",
+        "name": "Replace CHOKE with min setting",
+        "category": [
+            "qdisc",
+            "choke"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root choke limit 1000 bandwidth 10000"
+        ],
+        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root choke limit 1000 bandwidth 10000 min 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc choke 1: root refcnt [0-9]+ limit 1000p min 100p max 250p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "0301",
+        "name": "Change CHOKE with limit setting",
+        "category": [
+            "qdisc",
+            "choke"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root choke limit 1000 bandwidth 10000"
+        ],
+        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: root choke limit 1000 bandwidth 10000 min 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc choke 1: root refcnt [0-9]+ limit 1000p min 100p max 250p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.17.1

