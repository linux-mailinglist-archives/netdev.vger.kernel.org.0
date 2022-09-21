Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87ECD5BF392
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 04:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiIUCkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 22:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiIUCkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 22:40:35 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8948246D91;
        Tue, 20 Sep 2022 19:40:33 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MXMx52sjNz14QPD;
        Wed, 21 Sep 2022 10:36:25 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 10:40:31 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <toke@toke.dk>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>, <shuah@kernel.org>,
        <victor@mojatatu.com>
CC:     <zhijianx.li@intel.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next,v3 05/18] selftests/tc-testing: add selftests for cbs qdisc
Date:   Wed, 21 Sep 2022 10:42:05 +0800
Message-ID: <20220921024205.388176-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test 1820: Create CBS with default setting
Test 1532: Create CBS with hicredit setting
Test 2078: Create CBS with locredit setting
Test 9271: Create CBS with sendslope setting
Test 0482: Create CBS with idleslope setting
Test e8f3: Create CBS with multiple setting
Test 23c9: Replace CBS with sendslope setting
Test a07a: Change CBS with idleslope setting
Test 43b3: Delete CBS with handle
Test 9472: Show CBS class

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
---
 .../tc-testing/tc-tests/qdiscs/cbs.json       | 234 ++++++++++++++++++
 1 file changed, 234 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbs.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbs.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbs.json
new file mode 100644
index 000000000000..a46bf5ff8277
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbs.json
@@ -0,0 +1,234 @@
+[
+    {
+        "id": "1820",
+        "name": "Create CBS with default setting",
+        "category": [
+            "qdisc",
+            "cbs"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 0 sendslope 0 idleslope 0 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "1532",
+        "name": "Create CBS with hicredit setting",
+        "category": [
+            "qdisc",
+            "cbs"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs hicredit 64",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 64 locredit 0 sendslope 0 idleslope 0 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "2078",
+        "name": "Create CBS with locredit setting",
+        "category": [
+            "qdisc",
+            "cbs"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs locredit 10",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 10 sendslope 0 idleslope 0 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "9271",
+        "name": "Create CBS with sendslope setting",
+        "category": [
+            "qdisc",
+            "cbs"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs sendslope 888",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 0 sendslope 888 idleslope 0 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "0482",
+        "name": "Create CBS with idleslope setting",
+        "category": [
+            "qdisc",
+            "cbs"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs idleslope 666",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 0 sendslope 0 idleslope 666 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "e8f3",
+        "name": "Create CBS with multiple setting",
+        "category": [
+            "qdisc",
+            "cbs"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs hicredit 10 locredit 75 sendslope 2 idleslope 666",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 10 locredit 75 sendslope 2 idleslope 666 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "23c9",
+        "name": "Replace CBS with sendslope setting",
+        "category": [
+            "qdisc",
+            "cbs"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root cbs idleslope 666"
+        ],
+        "cmdUnderTest": "$TC qdisc replace dev $DUMMY handle 1: root cbs sendslope 10",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 0 sendslope 10 idleslope 0 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "a07a",
+        "name": "Change CBS with idleslope setting",
+        "category": [
+            "qdisc",
+            "cbs"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root cbs idleslope 666"
+        ],
+        "cmdUnderTest": "$TC qdisc change dev $DUMMY handle 1: root cbs idleslope 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 0 sendslope 0 idleslope 1 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "43b3",
+        "name": "Delete CBS with handle",
+        "category": [
+            "qdisc",
+            "cbs"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY handle 1: root cbs idleslope 666"
+        ],
+        "cmdUnderTest": "$TC qdisc del dev $DUMMY handle 1: root",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc cbs 1: root refcnt [0-9]+ hicredit 0 locredit 0 sendslope 0 idleslope 1 offload 0.*qdisc pfifo 0: parent 1: limit 1000p",
+        "matchCount": "0",
+        "teardown": [
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    },
+    {
+        "id": "9472",
+        "name": "Show CBS class",
+        "category": [
+            "qdisc",
+            "cbs"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true"
+        ],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root cbs",
+        "expExitCode": "0",
+        "verifyCmd": "$TC class show dev $DUMMY",
+        "matchPattern": "class cbs 1:[0-9]+ parent 1:",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY handle 1: root",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.17.1

