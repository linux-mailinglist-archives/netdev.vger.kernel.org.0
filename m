Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D005BF3E2
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 04:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiIUCt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 22:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiIUCtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 22:49:36 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA12B10B5;
        Tue, 20 Sep 2022 19:49:34 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MXN9054KyzpTf7;
        Wed, 21 Sep 2022 10:46:44 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 10:49:32 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v2 14/15] selftests/tc-testing: add selftests for tbf qdisc
Date:   Wed, 21 Sep 2022 10:50:51 +0800
Message-ID: <20220921025052.23465-15-shaozhengchao@huawei.com>
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

Test 6430: Create TBF with default setting
Test 0518: Create TBF with mtu setting
Test 320a: Create TBF with peakrate setting
Test 239b: Create TBF with latency setting
Test c975: Create TBF with overhead setting
Test 948c: Create TBF with linklayer setting
Test 3549: Replace TBF with mtu
Test f948: Change TBF with latency time
Test 2348: Show TBF class

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/qdiscs/tbf.json       | 211 ++++++++++++++++++
 1 file changed, 211 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/tbf.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/tbf.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/tbf.json
new file mode 100644
index 000000000000..a4b3dfe51ff5
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/tbf.json
@@ -0,0 +1,211 @@
+[
+    {
+        "id": "6430",
+        "name": "Create TBF with default setting",
+        "category": [
+            "qdisc",
+            "tbf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root tbf limit 1000 burst 1500 rate 10000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc tbf 1: root refcnt [0-9]+ rate 10Kbit burst 1500b limit 1000b",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "0518",
+        "name": "Create TBF with mtu setting",
+        "category": [
+            "qdisc",
+            "tbf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root tbf limit 1000 burst 1500 rate 20000 mtu 2048",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc tbf 1: root refcnt [0-9]+ rate 20Kbit burst 1500b limit 1000b",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "320a",
+        "name": "Create TBF with peakrate setting",
+        "category": [
+            "qdisc",
+            "tbf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root tbf limit 1000 burst 1500 rate 20000 mtu 1510 peakrate 30000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc tbf 1: root refcnt [0-9]+ rate 20Kbit burst 1500b peakrate 30Kbit minburst.*limit 1000b",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "239b",
+        "name": "Create TBF with latency setting",
+        "category": [
+            "qdisc",
+            "tbf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root tbf burst 1500 rate 20000 latency 100ms",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc tbf 1: root refcnt [0-9]+ rate 20Kbit burst 1500b lat 100ms",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "c975",
+        "name": "Create TBF with overhead setting",
+        "category": [
+            "qdisc",
+            "tbf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root tbf limit 1000 burst 1500 rate 20000 overhead 300",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc tbf 1: root refcnt [0-9]+ rate 20Kbit burst 1800b limit 1000b overhead 300",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "948c",
+        "name": "Create TBF with linklayer setting",
+        "category": [
+            "qdisc",
+            "tbf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root tbf limit 1000 burst 1500 rate 20000 linklayer atm",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc tbf 1: root refcnt [0-9]+ rate 20Kbit burst 1696b limit 1000b linklayer atm",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "3549",
+        "name": "Replace TBF with mtu",
+        "category": [
+            "qdisc",
+            "tbf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root tbf limit 1000 burst 1500 rate 20000 linklayer atm"
+        ],
+        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root tbf limit 1000 burst 1500 rate 20000 linklayer ethernet",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc tbf 1: root refcnt [0-9]+ rate 20Kbit burst 1500b limit 1000b",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "f948",
+        "name": "Change TBF with latency time",
+        "category": [
+            "qdisc",
+            "tbf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root tbf burst 1500 rate 20000 latency 10ms"
+        ],
+        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: root tbf burst 1500 rate 20000 latency 200ms",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc tbf 1: root refcnt [0-9]+ rate 20Kbit burst 1500b lat 200ms",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2348",
+        "name": "Show TBF class",
+        "category": [
+            "qdisc",
+            "tbf"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root tbf limit 1000 burst 1500 rate 10000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class tbf.*parent 1:",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.17.1

