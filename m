Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318065BA4F2
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 05:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiIPDEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 23:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiIPDEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 23:04:13 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77979D8D4;
        Thu, 15 Sep 2022 20:04:07 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MTJhx4rs5zmV8j;
        Fri, 16 Sep 2022 11:00:17 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 16 Sep
 2022 11:04:04 +0800
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
Subject: [PATCH net-next 03/18] selftests/tc-testings: add selftests for cake qdisc
Date:   Fri, 16 Sep 2022 11:05:29 +0800
Message-ID: <20220916030544.228274-4-shaozhengchao@huawei.com>
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

Test 1212: Create CAKE with default setting
Test 3241: Create CAKE with bandwidth limit
Test c940: Create CAKE with autorate-ingress flag
Test 2310: Create CAKE with rtt time
Test 2385: Create CAKE with besteffort flag
Test a032: Create CAKE with diffserv8 flag
Test 2349: Create CAKE with diffserv4 flag
Test 8472: Create CAKE with flowblind flag
Test 2341: Create CAKE with dsthost and nat flag
Test 5134: Create CAKE with wash flag
Test 2302: Create CAKE with flowblind and no-split-gso flag
Test 0768: Create CAKE with dual-srchost and ack-filter flag
Test 0238: Create CAKE with dual-dsthost and ack-filter-aggressive flag
Test 6573: Create CAKE with memlimit and ptm flag
Test 2436: Create CAKE with fwmark and atm flag
Test 3984: Create CAKE with overhead and mpu
Test 2342: Create CAKE with conservative and ingress flag
Test 2313: Change CAKE with mpu
Test 4365: Show CAKE class

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/qdiscs/cake.json      | 488 ++++++++++++++++++
 1 file changed, 488 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cake.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cake.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cake.json
new file mode 100644
index 000000000000..11ca18bab721
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cake.json
@@ -0,0 +1,488 @@
+[
+    {
+        "id": "1212",
+        "name": "Create CAKE with default setting",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "3241",
+        "name": "Create CAKE with bandwidth limit",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake bandwidth 1000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth 1Kbit diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "c940",
+        "name": "Create CAKE with autorate-ingress flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake autorate-ingress",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited autorate-ingress diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2310",
+        "name": "Create CAKE with rtt time",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake rtt 200",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 200us raw overhead",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2385",
+        "name": "Create CAKE with besteffort flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake besteffort",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited besteffort triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "a032",
+        "name": "Create CAKE with diffserv8 flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake diffserv8",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv8 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2349",
+        "name": "Create CAKE with diffserv4 flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake diffserv4",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv4 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "8472",
+        "name": "Create CAKE with flowblind flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake flowblind",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 flowblind nonat nowash no-ack-filter split-gso rtt 100ms raw overhead",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2341",
+        "name": "Create CAKE with dsthost and nat flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake dsthost nat",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 dsthost nat nowash no-ack-filter split-gso rtt 100ms raw overhead",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "5134",
+        "name": "Create CAKE with wash flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake hosts wash",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 hosts nonat wash no-ack-filter split-gso rtt 100ms raw overhead",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2302",
+        "name": "Create CAKE with flowblind and no-split-gso flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake flowblind no-split-gso",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 flowblind nonat nowash no-ack-filter no-split-gso rtt 100ms raw overhead",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "0768",
+        "name": "Create CAKE with dual-srchost and ack-filter flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake dual-srchost ack-filter",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 dual-srchost nonat nowash ack-filter split-gso rtt 100ms raw overhead",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "0238",
+        "name": "Create CAKE with dual-dsthost and ack-filter-aggressive flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake dual-dsthost ack-filter-aggressive",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 dual-dsthost nonat nowash ack-filter-aggressive split-gso rtt 100ms raw overhead",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "6573",
+        "name": "Create CAKE with memlimit and ptm flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake memlimit 10000 ptm",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw ptm overhead 0 memlimit 10000b",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2436",
+        "name": "Create CAKE with fwmark and atm flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake fwmark 8 atm",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms raw atm overhead 0 fwmark 0x8",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "3984",
+        "name": "Create CAKE with overhead and mpu",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake overhead 128 mpu 256",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms noatm overhead 128 mpu 256",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2342",
+        "name": "Create CAKE with conservative and ingress flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake conservative ingress",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash ingress no-ack-filter split-gso rtt 100ms atm overhead 48",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2342",
+        "name": "Delete CAKE with conservative and ingress flag",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root cake conservative ingress"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash ingress no-ack-filter split-gso rtt 100ms atm overhead 48",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2342",
+        "name": "Replace CAKE with mpu",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root cake overhead 128 mpu 256"
+        ],
+        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root cake mpu 128",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms noatm overhead 128 mpu 128",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2313",
+        "name": "Change CAKE with mpu",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root cake overhead 128 mpu 256"
+        ],
+        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: root cake mpu 128",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cake 1: root refcnt [0-9]+ bandwidth unlimited diffserv3 triple-isolate nonat nowash no-ack-filter split-gso rtt 100ms noatm overhead 128 mpu 128",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "4365",
+        "name": "Show CAKE class",
+        "category": [
+            "qdisc",
+            "cake"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cake",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class cake",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.17.1

