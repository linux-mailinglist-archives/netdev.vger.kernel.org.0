Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B072F5BA4EC
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 05:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiIPDEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 23:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiIPDEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 23:04:12 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FEA98D16;
        Thu, 15 Sep 2022 20:04:08 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MTJhk3zZjz14QcG;
        Fri, 16 Sep 2022 11:00:06 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 16 Sep
 2022 11:04:05 +0800
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
Subject: [PATCH net-next 04/18] selftests/tc-testings: add selftests for cbq qdisc
Date:   Fri, 16 Sep 2022 11:05:30 +0800
Message-ID: <20220916030544.228274-5-shaozhengchao@huawei.com>
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

Test 3460: Create CBQ with default setting
Test 0592: Create CBQ with mpu
Test 4684: Create CBQ with valid cell num
Test 4345: Create CBQ with invalid cell num
Test 4525: Create CBQ with valid ewma
Test 6784: Create CBQ with invalid ewma
Test 5468: Delete CBQ with handle
Test 492a: Show CBQ class

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/qdiscs/cbq.json       | 184 ++++++++++++++++++
 1 file changed, 184 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbq.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbq.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbq.json
new file mode 100644
index 000000000000..1ab21c83a122
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbq.json
@@ -0,0 +1,184 @@
+[
+    {
+        "id": "3460",
+        "name": "Create CBQ with default setting",
+        "category": [
+            "qdisc",
+            "cbq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbq bandwidth 10000 avpkt 9000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbq 1: root refcnt [0-9]+ rate 10Kbit \\(bounded,isolated\\) prio no-transmit",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "0592",
+        "name": "Create CBQ with mpu",
+        "category": [
+            "qdisc",
+            "cbq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbq bandwidth 10000 avpkt 9000 mpu 1000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbq 1: root refcnt [0-9]+ rate 10Kbit \\(bounded,isolated\\) prio no-transmit",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "4684",
+        "name": "Create CBQ with valid cell num",
+        "category": [
+            "qdisc",
+            "cbq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbq bandwidth 10000 avpkt 9000 cell 128",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbq 1: root refcnt [0-9]+ rate 10Kbit \\(bounded,isolated\\) prio no-transmit",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "4345",
+        "name": "Create CBQ with invalid cell num",
+        "category": [
+            "qdisc",
+            "cbq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbq bandwidth 10000 avpkt 9000 cell 100",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbq 1: root refcnt [0-9]+ rate 10Kbit \\(bounded,isolated\\) prio no-transmit",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "4525",
+        "name": "Create CBQ with valid ewma",
+        "category": [
+            "qdisc",
+            "cbq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbq bandwidth 10000 avpkt 9000 ewma 16",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbq 1: root refcnt [0-9]+ rate 10Kbit \\(bounded,isolated\\) prio no-transmit",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "6784",
+        "name": "Create CBQ with invalid ewma",
+        "category": [
+            "qdisc",
+            "cbq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbq bandwidth 10000 avpkt 9000 ewma 128",
+        "expExitCode": "1",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbq 1: root refcnt [0-9]+ rate 10Kbit \\(bounded,isolated\\) prio no-transmit",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "5468",
+        "name": "Delete CBQ with handle",
+        "category": [
+            "qdisc",
+            "cbq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root cbq bandwidth 10000 avpkt 9000"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbq 1: root refcnt [0-9]+ rate 10Kbit \\(bounded,isolated\\) prio no-transmit",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "492a",
+        "name": "Show CBQ class",
+        "category": [
+            "qdisc",
+            "cbq"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbq bandwidth 10000 avpkt 9000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class cbq 1: root rate 10Kbit \\(bounded,isolated\\) prio no-transmit",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.17.1

