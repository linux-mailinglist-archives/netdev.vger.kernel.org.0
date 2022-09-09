Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61065B2BA8
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 03:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiIIB1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 21:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiIIB1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 21:27:40 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23961177A2;
        Thu,  8 Sep 2022 18:27:37 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MNyv24qHDzmVK9;
        Fri,  9 Sep 2022 09:23:58 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 9 Sep
 2022 09:27:35 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next 2/8] selftests/tc-testings: add selftests for gate action
Date:   Fri, 9 Sep 2022 09:29:30 +0800
Message-ID: <20220909012936.268433-3-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220909012936.268433-1-shaozhengchao@huawei.com>
References: <20220909012936.268433-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

Test 5153: Add gate action with priority and sched-entry
Test 7189: Add gate action with base-time
Test a721: Add gate action with cycle-time
Test c029: Add gate action with cycle-time-ext
Test 3719: Replace gate base-time action
Test d821: Delete gate action with valid index
Test 3128: Delete gate action with invalid index
Test 7837: List gate actions
Test 9273: Flush gate actions
Test c829: Add gate action with duplicate index
Test 3043: Add gate action with invalid index
Test 2930: Add gate action with cookie

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/actions/gate.json     | 315 ++++++++++++++++++
 1 file changed, 315 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/gate.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/gate.json b/tools/testing/selftests/tc-testing/tc-tests/actions/gate.json
new file mode 100644
index 000000000000..e16a4963fdd2
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/gate.json
@@ -0,0 +1,315 @@
+[
+    {
+        "id": "5153",
+        "name": "Add gate action with priority and sched-entry",
+        "category": [
+            "actions",
+            "gate"
+        ],
+        "setup": [
+            [
+                "$TC action flush action gate",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action add action gate priority 1 sched-entry close 100000000ns index 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action get action gate index 100",
+        "matchPattern": "action order [0-9]*: .*priority 1.*index 100 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action gate"
+        ]
+    },
+    {
+        "id": "7189",
+        "name": "Add gate action with base-time",
+        "category": [
+            "actions",
+            "gate"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action gate",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action add action gate base-time 200000000000ns sched-entry close 100000000ns index 10",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action ls action gate",
+        "matchPattern": "action order [0-9]*: .*base-time 200s.*index 10 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action gate"
+        ]
+    },
+    {
+        "id": "a721",
+        "name": "Add gate action with cycle-time",
+        "category": [
+            "actions",
+            "gate"
+        ],
+        "setup": [
+            [
+                "$TC action flush action gate",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action add action gate cycle-time 200000000000ns sched-entry close 100000000ns index 1000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action ls action gate",
+        "matchPattern": "action order [0-9]*: .*cycle-time 200s.*index 1000 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action gate"
+        ]
+    },
+    {
+        "id": "c029",
+        "name": "Add gate action with cycle-time-ext",
+        "category": [
+            "actions",
+            "gate"
+        ],
+        "setup": [
+            [
+                "$TC action flush action gate",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action add action gate cycle-time-ext 20000000000ns sched-entry close 100000000ns index 1000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action get action gate index 1000",
+        "matchPattern": "action order [0-9]*: .*cycle-time-ext 20s.*index 1000 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action gate"
+        ]
+    },
+    {
+        "id": "3719",
+        "name": "Replace gate base-time action",
+        "category": [
+            "actions",
+            "gate"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action gate",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC action add action gate base-time 200000000000ns sched-entry open 200000000ns -1 8000000b index 20",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action replace action gate base-time 400000000000ns index 20",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action get action gate index 20",
+        "matchPattern": "action order [0-9]*: .*base-time 400s.*index 20 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action gate"
+        ]
+    },
+    {
+        "id": "d821",
+        "name": "Delete gate action with valid index",
+        "category": [
+            "actions",
+            "gate"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action gate",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC action add action gate base-time 200000000000ns sched-entry open 200000000ns -1 8000000b index 302",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action delete action gate index 302",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action get action bpf index 302",
+        "matchPattern": "action order [0-9]*: .*base-time 200s.*index 302 ref",
+        "matchCount": "0",
+        "teardown": [
+            "$TC action flush action gate"
+        ]
+    },
+    {
+        "id": "3128",
+        "name": "Delete gate action with invalid index",
+        "category": [
+            "actions",
+            "gate"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action gate",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC action add action gate base-time 600000000000ns sched-entry open 200000000ns -1 8000000b index 999",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action delete action gate index 333",
+        "expExitCode": "255",
+        "verifyCmd": "$TC action get action gate index 999",
+        "matchPattern": "action order [0-9]*: .*base-time 600s.*index 999 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action gate"
+        ]
+    },
+    {
+        "id": "7837",
+        "name": "List gate actions",
+        "category": [
+            "actions",
+            "gate"
+        ],
+        "setup": [
+            [
+                "$TC action flush action gate",
+                0,
+                1,
+                255
+            ],
+            "$TC action add action gate base-time 600000000000ns sched-entry open 200000000ns -1 8000000b index 101",
+            "$TC action add action gate cycle-time 600000000000ns sched-entry open 600000000ns -1 8000000b index 102",
+            "$TC action add action gate cycle-time-ext 400000000000ns sched-entry close 100000000ns index 103"
+        ],
+        "cmdUnderTest": "$TC action list action gate",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action list action gate",
+        "matchPattern": "action order [0-9]*:",
+        "matchCount": "3",
+        "teardown": [
+            "$TC actions flush action gate"
+        ]
+    },
+    {
+        "id": "9273",
+        "name": "Flush gate actions",
+        "category": [
+            "actions",
+            "gate"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action gate",
+                0,
+                1,
+                255
+            ],
+            "$TC action add action gate base-time 600000000000ns sched-entry open 200000000ns -1 8000000b index 101",
+            "$TC action add action gate cycle-time 600000000000ns sched-entry open 600000000ns -1 8000000b index 102",
+            "$TC action add action gate cycle-time-ext 400000000000ns sched-entry close 100000000ns index 103"
+	],
+        "cmdUnderTest": "$TC action flush action gate",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action list action gate",
+        "matchPattern": "action order [0-9]*: .*priority",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action gate"
+        ]
+    },
+    {
+        "id": "c829",
+        "name": "Add gate action with duplicate index",
+        "category": [
+            "actions",
+            "gate"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action gate",
+                0,
+                1,
+                255
+            ],
+            "$TC action add action gate cycle-time 600000000000ns sched-entry open 600000000ns -1 8000000b index 4294967295"
+        ],
+        "cmdUnderTest": "$TC action add action gate cycle-time 600000000000ns sched-entry open 600000000ns -1 8000000b index 4294967295",
+        "expExitCode": "255",
+        "verifyCmd": "$TC action get action gate index 4294967295",
+        "matchPattern": "action order [0-9]*: .*index 4294967295",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action gate"
+        ]
+    },
+    {
+        "id": "3043",
+        "name": "Add gate action with invalid index",
+        "category": [
+            "actions",
+            "gate"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action gate",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action add action gate cycle-time-ext 400000000000ns sched-entry close 100000000ns index 4294967296",
+        "expExitCode": "255",
+        "verifyCmd": "$TC action ls action gate",
+        "matchPattern": "action order [0-9]*:",
+        "matchCount": "0",
+        "teardown": [
+            "$TC action flush action gate"
+        ]
+    },
+    {
+        "id": "2930",
+        "name": "Add gate action with cookie",
+        "category": [
+            "actions",
+            "gate"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action gate",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action add action gate cycle-time-ext 400000000000ns sched-entry close 100000000ns index 4294 cookie d0d0d0d0d0d0d0d0",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action list action gate",
+        "matchPattern": "action order [0-9]*: .*cookie d0d0d0d0d0d0d0",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action gate"
+        ]
+    }
+]
-- 
2.17.1

