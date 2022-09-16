Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A395BA4F8
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 05:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiIPDEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 23:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiIPDES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 23:04:18 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18E99DF82;
        Thu, 15 Sep 2022 20:04:11 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MTJhn46JkzlVjJ;
        Fri, 16 Sep 2022 11:00:09 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 16 Sep
 2022 11:04:09 +0800
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
Subject: [PATCH net-next 08/18] selftests/tc-testings: add selftests for fq_codel qdisc
Date:   Fri, 16 Sep 2022 11:05:34 +0800
Message-ID: <20220916030544.228274-9-shaozhengchao@huawei.com>
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

Test 4957: Create FQ_CODEL with default setting
Test 7621: Create FQ_CODEL with limit setting
Test 6872: Create FQ_CODEL with memory_limit setting
Test 5636: Create FQ_CODEL with target setting
Test 630a: Create FQ_CODEL with interval setting
Test 4324: Create FQ_CODEL with quantum setting
Test b190: Create FQ_CODEL with noecn flag
Test c9d2: Create FQ_CODEL with ce_threshold setting
Test 523b: Create FQ_CODEL with multiple setting
Test 9283: Replace FQ_CODEL with noecn setting
Test 3459: Change FQ_CODEL with limit setting
Test 0128: Delete FQ_CODEL with handle
Test 0435: Show FQ_CODEL class

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/qdiscs/fq_codel.json  | 326 ++++++++++++++++++
 1 file changed, 326 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
new file mode 100644
index 000000000000..09608677cfee
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
@@ -0,0 +1,326 @@
+[
+    {
+        "id": "4957",
+        "name": "Create FQ_CODEL with default setting",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "7621",
+        "name": "Create FQ_CODEL with limit setting",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel limit 1000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 1000p flows 1024 quantum.*target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "6872",
+        "name": "Create FQ_CODEL with memory_limit setting",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel memory_limit 100000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 5ms interval 100ms memory_limit 100000b ecn drop_batch 64",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "5636",
+        "name": "Create FQ_CODEL with target setting",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel target 2000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 2ms interval 100ms memory_limit 32Mb ecn drop_batch 64",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "630a",
+        "name": "Create FQ_CODEL with interval setting",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel interval 5000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 5ms interval 5ms memory_limit 32Mb ecn drop_batch 64",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "4324",
+        "name": "Create FQ_CODEL with quantum setting",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel quantum 9000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum 9000 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "b190",
+        "name": "Create FQ_CODEL with noecn flag",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel noecn",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 5ms interval 100ms memory_limit 32Mb drop_batch 64",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "c9d2",
+        "name": "Create FQ_CODEL with ce_threshold setting",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel ce_threshold 1024000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 5ms ce_threshold 1.02s interval 100ms memory_limit 32Mb ecn drop_batch 64",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "c9d2",
+        "name": "Create FQ_CODEL with drop_batch setting",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel drop_batch 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum.*target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 100",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "523b",
+        "name": "Create FQ_CODEL with multiple setting",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel limit 1000 flows 256 drop_batch 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 1000p flows 256 quantum.*target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 100",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "9283",
+        "name": "Replace FQ_CODEL with noecn setting",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root fq_codel limit 1000 flows 256 drop_batch 100"
+        ],
+        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root fq_codel noecn",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 1000p flows 256 quantum.*target 5ms interval 100ms memory_limit 32Mb drop_batch 100",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "3459",
+        "name": "Change FQ_CODEL with limit setting",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root fq_codel limit 1000 flows 256 drop_batch 100"
+        ],
+        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: root fq_codel limit 2000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 2000p flows 256 quantum.*target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 100",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "0128",
+        "name": "Delete FQ_CODEL with handle",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root fq_codel limit 1000 flows 256 drop_batch 100"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 1000p flows 256 quantum.*target 5ms interval 100ms memory_limit 32Mb noecn drop_batch 100",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "0435",
+        "name": "Show FQ_CODEL class",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class fq_codel 1:",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.17.1

