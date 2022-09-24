Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADAB45E87AC
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbiIXCvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiIXCvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:51:02 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A90119199;
        Fri, 23 Sep 2022 19:51:01 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MZD1v6jKMzWgtf;
        Sat, 24 Sep 2022 10:46:59 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 24 Sep
 2022 10:50:59 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v3 05/15] selftests/tc-testing: add selftests for fq qdisc
Date:   Sat, 24 Sep 2022 10:51:47 +0800
Message-ID: <20220924025157.331635-6-shaozhengchao@huawei.com>
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

Test 983b: Create FQ with default setting
Test 38a1: Create FQ with limit packet setting
Test 0a18: Create FQ with flow_limit setting
Test 2390: Create FQ with quantum setting
Test 845b: Create FQ with initial_quantum setting
Test 9398: Create FQ with maxrate setting
Test 342c: Create FQ with nopacing setting
Test 6391: Create FQ with refill_delay setting
Test 238b: Create FQ with low_rate_threshold setting
Test 7582: Create FQ with orphan_mask setting
Test 4894: Create FQ with timer_slack setting
Test 324c: Create FQ with ce_threshold setting
Test 424a: Create FQ with horizon time setting
Test 89e1: Create FQ with horizon_cap setting
Test 32e1: Delete FQ with valid handle
Test 49b0: Replace FQ with limit setting
Test 9478: Change FQ with limit setting

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 tools/testing/selftests/tc-testing/config     |   1 +
 .../tc-testing/tc-tests/qdiscs/fq.json        | 395 ++++++++++++++++++
 2 files changed, 396 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index 058ef0bf9dad..eea77f9d6ba1 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -16,6 +16,7 @@ CONFIG_NET_SCH_ATM=m
 CONFIG_NET_SCH_CHOKE=m
 CONFIG_NET_SCH_CODEL=m
 CONFIG_NET_SCH_ETF=m
+CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_PRIO=m
 CONFIG_NET_SCH_INGRESS=m
 
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json
new file mode 100644
index 000000000000..8acb904d1419
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json
@@ -0,0 +1,395 @@
+[
+    {
+        "id": "983b",
+        "name": "Create FQ with default setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "38a1",
+        "name": "Create FQ with limit packet setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq limit 3000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 3000p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "0a18",
+        "name": "Create FQ with flow_limit setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq flow_limit 300",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 10000p flow_limit 300p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2390",
+        "name": "Create FQ with quantum setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq quantum 9000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 10000p flow_limit 100p buckets.*orphan_mask 1023 quantum 9000b",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "845b",
+        "name": "Create FQ with initial_quantum setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq initial_quantum 900000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 10000p flow_limit 100p buckets.*initial_quantum 900000b",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "9398",
+        "name": "Create FQ with maxrate setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq maxrate 100000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 10000p flow_limit 100p buckets.*maxrate 100Kbit",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "342c",
+        "name": "Create FQ with nopacing setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq nopacing",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 10000p flow_limit 100p.*nopacing",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "6391",
+        "name": "Create FQ with refill_delay setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq refill_delay 100ms",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 10000p flow_limit 100p.*refill_delay 100ms",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "238b",
+        "name": "Create FQ with low_rate_threshold setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq low_rate_threshold 10000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 10000p flow_limit 100p.*low_rate_threshold 10Kbit",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "7582",
+        "name": "Create FQ with orphan_mask setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq orphan_mask 255",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 10000p flow_limit 100p.*orphan_mask 255",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "4894",
+        "name": "Create FQ with timer_slack setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq timer_slack 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 10000p flow_limit 100p.*timer_slack 100ns",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "324c",
+        "name": "Create FQ with ce_threshold setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq ce_threshold 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 10000p flow_limit 100p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "424a",
+        "name": "Create FQ with horizon time setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq horizon 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 10000p flow_limit 100p.*horizon 100us",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "89e1",
+        "name": "Create FQ with horizon_cap setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq horizon_cap",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 10000p flow_limit 100p.*horizon_cap",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "32e1",
+        "name": "Delete FQ with valid handle",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root fq"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 10000p",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "49b0",
+        "name": "Replace FQ with limit setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root fq"
+        ],
+        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root fq limit 5000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 5000p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "9478",
+        "name": "Change FQ with limit setting",
+        "category": [
+            "qdisc",
+            "fq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root fq"
+        ],
+        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: root fq limit 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq 1: root refcnt [0-9]+ limit 100p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.17.1

