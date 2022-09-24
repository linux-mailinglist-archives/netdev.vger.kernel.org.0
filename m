Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494AE5E87B1
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbiIXCvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbiIXCvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:51:02 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A824913A952;
        Fri, 23 Sep 2022 19:51:01 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MZD3D389PzpTlm;
        Sat, 24 Sep 2022 10:48:08 +0800 (CST)
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
Subject: [PATCH net-next,v3 06/15] selftests/tc-testing: add selftests for gred qdisc
Date:   Sat, 24 Sep 2022 10:51:48 +0800
Message-ID: <20220924025157.331635-7-shaozhengchao@huawei.com>
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

Test 8942: Create GRED with default setting
Test 5783: Create GRED with grio setting
Test 8a09: Create GRED with limit setting
Test 48cb: Create GRED with ecn setting
Test 763a: Change GRED setting
Test 8309: Show GRED class

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 tools/testing/selftests/tc-testing/config     |   1 +
 .../tc-testing/tc-tests/qdiscs/gred.json      | 164 ++++++++++++++++++
 2 files changed, 165 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/gred.json

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index eea77f9d6ba1..d8db68440395 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -17,6 +17,7 @@ CONFIG_NET_SCH_CHOKE=m
 CONFIG_NET_SCH_CODEL=m
 CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_FQ=m
+CONFIG_NET_SCH_GRED=m
 CONFIG_NET_SCH_PRIO=m
 CONFIG_NET_SCH_INGRESS=m
 
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/gred.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/gred.json
new file mode 100644
index 000000000000..013c8ee037a4
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/gred.json
@@ -0,0 +1,164 @@
+[
+    {
+        "id": "8942",
+        "name": "Create GRED with default setting",
+        "category": [
+            "qdisc",
+            "gred"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root gred setup vqs 10 default 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc gred 1: root refcnt [0-9]+ vqs 10 default 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "5783",
+        "name": "Create GRED with grio setting",
+        "category": [
+            "qdisc",
+            "gred"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root gred setup vqs 10 default 1 grio",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc gred 1: root refcnt [0-9]+ vqs 10 default 1.*grio",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "8a09",
+        "name": "Create GRED with limit setting",
+        "category": [
+            "qdisc",
+            "gred"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root gred setup vqs 10 default 1 limit 1000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc gred 1: root refcnt [0-9]+ vqs 10 default 1 limit 1000b",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "48ca",
+        "name": "Create GRED with ecn setting",
+        "category": [
+            "qdisc",
+            "gred"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root gred setup vqs 10 default 2 ecn",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc gred 1: root refcnt [0-9]+ vqs 10 default 2.*ecn",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "48cb",
+        "name": "Create GRED with harddrop setting",
+        "category": [
+            "qdisc",
+            "gred"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root gred setup vqs 10 default 2 harddrop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc gred 1: root refcnt [0-9]+ vqs 10 default 2.*harddrop",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "763a",
+        "name": "Change GRED setting",
+        "category": [
+            "qdisc",
+            "gred"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root gred setup vqs 10 default 1"
+        ],
+        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: root gred limit 60KB min 15K max 25K burst 64 avpkt 1500 bandwidth 10Mbit DP 1 probability 0.1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc gred 1: root refcnt [0-9]+ vqs 10 default 1 limit.*vq 1 prio [0-9]+ limit 60Kb min 15Kb max 25Kb",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "8309",
+        "name": "Show GRED class",
+        "category": [
+            "qdisc",
+            "gred"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root gred setup vqs 10 default 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class gred 1:",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.17.1

