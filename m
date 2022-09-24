Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3EC5E87B3
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbiIXCvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbiIXCvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:51:07 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698AB12519A;
        Fri, 23 Sep 2022 19:51:06 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MZD4439y1zHpW8;
        Sat, 24 Sep 2022 10:48:52 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 24 Sep
 2022 10:51:04 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>, <victor@mojatatu.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v3 15/15] selftests/tc-testing: add selftests for teql qdisc
Date:   Sat, 24 Sep 2022 10:51:57 +0800
Message-ID: <20220924025157.331635-16-shaozhengchao@huawei.com>
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

Test 84a0: Create TEQL with default setting
Test 7734: Create TEQL with multiple device
Test 34a9: Delete TEQL with valid handle
Test 6289: Show TEQL stats

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 tools/testing/selftests/tc-testing/config     |  1 +
 .../tc-testing/tc-tests/qdiscs/teql.json      | 97 +++++++++++++++++++
 2 files changed, 98 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/teql.json

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index f8e5e1428bac..2b2c2a835757 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -27,6 +27,7 @@ CONFIG_NET_SCH_SFQ=m
 CONFIG_NET_SCH_SKBPRIO=m
 CONFIG_NET_SCH_TAPRIO=m
 CONFIG_NET_SCH_TBF=m
+CONFIG_NET_SCH_TEQL=m
 
 #
 # Classification
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/teql.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/teql.json
new file mode 100644
index 000000000000..0082be0e93ac
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/teql.json
@@ -0,0 +1,97 @@
+[
+    {
+        "id": "84a0",
+        "name": "Create TEQL with default setting",
+        "category": [
+            "qdisc",
+            "teql"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root teql0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc teql0 1: root refcnt",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "7734",
+        "name": "Create TEQL with multiple device",
+        "category": [
+            "qdisc",
+            "teql"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "echo \"1 1 4\" > /sys/bus/netdevsim/new_device",
+            "$TC qdisc add dev $ETH root handle 1: teql0"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root teql0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc teql0 1: root refcnt",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "echo \"1\" > /sys/bus/netdevsim/del_device",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "34a9",
+        "name": "Delete TEQL with valid handle",
+        "category": [
+            "qdisc",
+            "teql"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root teql0"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc teql0 1: root refcnt",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "6289",
+        "name": "Show TEQL stats",
+        "category": [
+            "qdisc",
+            "teql"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root teql0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC -s qdisc show dev $DUMMY",
+        "matchPattern": "qdisc teql0 1: root refcnt",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.17.1

