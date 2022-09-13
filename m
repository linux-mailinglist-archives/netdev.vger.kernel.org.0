Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBED5B668A
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 06:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiIMEWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 00:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbiIMEVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 00:21:53 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D85F564D7;
        Mon, 12 Sep 2022 21:20:32 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MRVVw22GmzNmD1;
        Tue, 13 Sep 2022 12:15:20 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 13 Sep
 2022 12:19:54 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <jhs@mojatatu.com>, <jiri@resnulli.us>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <shuah@kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next 5/9] selftests/tc-testings: add selftests for flow filter
Date:   Tue, 13 Sep 2022 12:21:31 +0800
Message-ID: <20220913042135.58342-6-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220913042135.58342-1-shaozhengchao@huawei.com>
References: <20220913042135.58342-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test 5294: Add flow filter with map key and ops
Test 3514: Add flow filter with map key or ops
Test 7534: Add flow filter with map key xor ops
Test 4524: Add flow filter with map key rshift ops
Test 0230: Add flow filter with map key addend ops
Test 2344: Add flow filter with src map key
Test 9304: Add flow filter with proto map key
Test 9038: Add flow filter with proto-src map key
Test 2a03: Add flow filter with proto-dst map key
Test a073: Add flow filter with iif map key
Test 3b20: Add flow filter with priority map key
Test 8945: Add flow filter with mark map key
Test c034: Add flow filter with nfct map key
Test 0205: Add flow filter with nfct-src map key
Test 5315: Add flow filter with nfct-src map key
Test 7849: Add flow filter with nfct-proto-src map key
Test 9902: Add flow filter with nfct-proto-dst map key
Test 6742: Add flow filter with rt-classid map key
Test 5432: Add flow filter with sk-uid map key
Test 4134: Add flow filter with sk-gid map key
Test 4522: Add flow filter with vlan-tag map key
Test 4253: Add flow filter with rxhash map key
Test 4452: Add flow filter with hash key list
Test 4341: Add flow filter with muliple ops
Test 4392: List flow filters
Test 4322: Change flow filter with map key num
Test 2320: Replace flow filter with map key num
Test 3213: Delete flow filter with map key num

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/filters/flow.json     | 623 ++++++++++++++++++
 1 file changed, 623 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/flow.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/flow.json b/tools/testing/selftests/tc-testing/tc-tests/filters/flow.json
new file mode 100644
index 000000000000..d2e2087220ff
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/flow.json
@@ -0,0 +1,623 @@
+[
+    {
+        "id": "5294",
+        "name": "Add flow filter with map key and ops",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key dst and 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys dst and 0x000000ff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "3514",
+        "name": "Add flow filter with map key or ops",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key dst or 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys dst.*or 0x000000ff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "7534",
+        "name": "Add flow filter with map key xor ops",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key dst xor 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys dst xor 0x000000ff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4524",
+        "name": "Add flow filter with map key rshift ops",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key dst rshift 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys dst rshift 255 baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "0230",
+        "name": "Add flow filter with map key addend ops",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key dst addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys dst addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2344",
+        "name": "Add flow filter with src map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key src addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys src addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "9304",
+        "name": "Add flow filter with proto map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key proto addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys proto addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "9038",
+        "name": "Add flow filter with proto-src map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key proto-src addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys proto-src addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2a03",
+        "name": "Add flow filter with proto-dst map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key proto-dst addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys proto-dst addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "a073",
+        "name": "Add flow filter with iif map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key iif addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys iif addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "3b20",
+        "name": "Add flow filter with priority map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key priority addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys priority addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "8945",
+        "name": "Add flow filter with mark map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key mark addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys mark addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "c034",
+        "name": "Add flow filter with nfct map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key nfct addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys nfct addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "0205",
+        "name": "Add flow filter with nfct-src map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key nfct-dst addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys nfct-dst addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "5315",
+        "name": "Add flow filter with nfct-src map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key nfct-src addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys nfct-src addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "7849",
+        "name": "Add flow filter with nfct-proto-src map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key nfct-proto-src addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys nfct-proto-src addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "9902",
+        "name": "Add flow filter with nfct-proto-dst map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key nfct-proto-dst addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys nfct-proto-dst addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "6742",
+        "name": "Add flow filter with rt-classid map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key rt-classid addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys rt-classid addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "5432",
+        "name": "Add flow filter with sk-uid map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key sk-uid addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys sk-uid addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4134",
+        "name": "Add flow filter with sk-gid map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key sk-gid addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys sk-gid addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4522",
+        "name": "Add flow filter with vlan-tag map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key vlan-tag addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys vlan-tag addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4253",
+        "name": "Add flow filter with rxhash map key",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key rxhash addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys rxhash addend 0xff baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4452",
+        "name": "Add flow filter with hash key list",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow hash keys src",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 hash keys src baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4341",
+        "name": "Add flow filter with muliple ops",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow hash keys src divisor 1024 baseclass 1:1 match 'cmp(u8 at 0 layer link mask 0xff gt 10)' action drop",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 protocol ip prio 1 flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 hash keys src divisor 1024 baseclass 1:1.*cmp\\(u8 at 0 layer 0 mask 0xff gt 10\\)",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4392",
+        "name": "List flow filters",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+	    "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key rxhash addend 0xff",
+	    "$TC filter add dev $DEV1 parent ffff: handle 2 prio 1 protocol ip flow map key rxhash or 0xff"
+        ],
+        "cmdUnderTest": "$TC filter show dev $DEV1 parent ffff:",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
+        "matchPattern": "filter protocol ip pref 1 flow chain 0 handle 0x[0-9]+ map keys rxhash",
+        "matchCount": "2",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "4322",
+        "name": "Change flow filter with map key num",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key rxhash addend 0xff"
+        ],
+        "cmdUnderTest": "$TC filter change dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key rxhash addend 0x22",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys rxhash addend 0x22 baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "2320",
+        "name": "Replace flow filter with map key num",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key rxhash addend 0xff"
+        ],
+        "cmdUnderTest": "$TC filter replace dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key rxhash addend 0x88",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys rxhash addend 0x88 baseclass",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    },
+    {
+        "id": "3213",
+        "name": "Delete flow filter with map key num",
+        "category": [
+            "filter",
+            "flow"
+        ],
+	"plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 ingress",
+            "$TC filter add dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key rxhash addend 0xff"
+        ],
+        "cmdUnderTest": "$TC filter delete dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow map key rxhash addend 0xff",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip flow",
+        "matchPattern": "filter parent ffff: protocol ip pref 1 flow chain [0-9]+ handle 0x1 map keys rxhash addend 0x88 baseclass",
+        "matchCount": "0",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 ingress"
+        ]
+    }
+]
-- 
2.17.1

