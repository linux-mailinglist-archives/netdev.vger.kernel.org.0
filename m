Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6305B2B88
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 03:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiIIB1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 21:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIIB1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 21:27:38 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFCD1177A5;
        Thu,  8 Sep 2022 18:27:37 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MNyt01yGZzZcKg;
        Fri,  9 Sep 2022 09:23:04 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 9 Sep
 2022 09:27:34 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next 1/8] selftests/tc-testings: add selftests for ctinfo action
Date:   Fri, 9 Sep 2022 09:29:29 +0800
Message-ID: <20220909012936.268433-2-shaozhengchao@huawei.com>
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

Test c826: Add ctinfo action with default setting
Test 0286: Add ctinfo action with dscp
Test 4938: Add ctinfo action with valid cpmark and zone
Test 7593: Add ctinfo action with drop control
Test 2961: Replace ctinfo action zone and action control
Test e567: Delete ctinfo action with valid index
Test 6a91: Delete ctinfo action with invalid index
Test 5232: List ctinfo actions
Test 7702: Flush ctinfo actions
Test 3201: Add ctinfo action with duplicate index
Test 8295: Add ctinfo action with invalid index
Test 3964: Replace ctinfo action with invalid goto_chain control

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/actions/ctinfo.json   | 316 ++++++++++++++++++
 1 file changed, 316 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/ctinfo.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/ctinfo.json b/tools/testing/selftests/tc-testing/tc-tests/actions/ctinfo.json
new file mode 100644
index 000000000000..d9710c067eb7
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/ctinfo.json
@@ -0,0 +1,316 @@
+[
+    {
+        "id": "c826",
+        "name": "Add ctinfo action with default setting",
+        "category": [
+            "actions",
+            "ctinfo"
+        ],
+        "setup": [
+            [
+                "$TC action flush action ctinfo",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action add action ctinfo index 10",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action get action ctinfo index 10",
+        "matchPattern": "action order [0-9]*: ctinfo zone 0 pipe.*index 10 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action ctinfo"
+        ]
+    },
+    {
+        "id": "0286",
+        "name": "Add ctinfo action with dscp",
+        "category": [
+            "actions",
+            "ctinfo"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action ctinfo",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action add action ctinfo dscp 0xfc000000 0x01000000 index 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action ls action ctinfo",
+        "matchPattern": "action order [0-9]*: ctinfo zone 0 pipe.*index 100 ref.*dscp 0xfc000000 0x01000000",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action ctinfo"
+        ]
+    },
+    {
+        "id": "4938",
+        "name": "Add ctinfo action with valid cpmark and zone",
+        "category": [
+            "actions",
+            "ctinfo"
+        ],
+        "setup": [
+            [
+                "$TC action flush action ctinfo",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action add action ctinfo cpmark 0x01000000 zone 1 index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action get action ctinfo index 1",
+        "matchPattern": "action order [0-9]*: ctinfo zone 1 pipe.*index 1 ref.*cpmark 0x01000000",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action ctinfo"
+        ]
+    },
+    {
+        "id": "7593",
+        "name": "Add ctinfo action with drop control",
+        "category": [
+            "actions",
+            "ctinfo"
+        ],
+        "setup": [
+            [
+                "$TC action flush action ctinfo",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action add action ctinfo drop index 1000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action ls action ctinfo",
+        "matchPattern": "action order [0-9]*: ctinfo zone 0 drop.*index 1000 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action ctinfo"
+        ]
+    },
+    {
+        "id": "2961",
+        "name": "Replace ctinfo action zone and action control",
+        "category": [
+            "actions",
+            "ctinfo"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action ctinfo",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC action add action ctinfo zone 1 drop index 1",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action replace action ctinfo zone 200 pass index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action get action ctinfo index 1",
+        "matchPattern": "action order [0-9]*: ctinfo zone 200 pass.*index 1 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action ctinfo"
+        ]
+    },
+    {
+        "id": "e567",
+        "name": "Delete ctinfo action with valid index",
+        "category": [
+            "actions",
+            "ctinfo"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action ctinfo",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC action add action ctinfo zone 200 pass index 1",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action delete action ctinfo index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action get action ctinfo index 1",
+        "matchPattern": "action order [0-9]*: ctinfo zone 200 pass.*index 1 ref",
+        "matchCount": "0",
+        "teardown": [
+            "$TC action flush action ctinfo"
+        ]
+    },
+    {
+        "id": "6a91",
+        "name": "Delete ctinfo action with invalid index",
+        "category": [
+            "actions",
+            "ctinfo"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action ctinfo",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC action add action ctinfo zone 200 pass index 1",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action delete action ctinfo index 333",
+        "expExitCode": "255",
+        "verifyCmd": "$TC action get action ctinfo index 1",
+        "matchPattern": "action order [0-9]*: ctinfo zone 200 pass.*index 1 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action ctinfo"
+        ]
+    },
+    {
+        "id": "5232",
+        "name": "List ctinfo actions",
+        "category": [
+            "actions",
+            "ctinfo"
+        ],
+        "setup": [
+            [
+                "$TC action flush action ctinfo",
+                0,
+                1,
+                255
+            ],
+            "$TC action add action ctinfo zone 20 pass index 101",
+            "$TC action add action ctinfo cpmark 0x02000000 drop index 102",
+            "$TC action add action ctinfo continue index 103"
+        ],
+        "cmdUnderTest": "$TC action list action ctinfo",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action list action ctinfo",
+        "matchPattern": "action order [0-9]*: ctinfo",
+        "matchCount": "3",
+        "teardown": [
+            "$TC actions flush action ctinfo"
+        ]
+    },
+    {
+        "id": "7702",
+        "name": "Flush ctinfo actions",
+        "category": [
+            "actions",
+            "ctinfo"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action ctinfo",
+                0,
+                1,
+                255
+            ],
+	    "$TC action add action ctinfo zone 20 pass index 101",
+            "$TC action add action ctinfo cpmark 0x02000000 drop index 102",
+            "$TC action add action ctinfo continue index 103"
+        ],
+        "cmdUnderTest": "$TC action flush action ctinfo",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action list action ctinfo",
+        "matchPattern": "action order [0-9]*: ctinfo",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action ctinfo"
+        ]
+    },
+    {
+        "id": "3201",
+        "name": "Add ctinfo action with duplicate index",
+        "category": [
+            "actions",
+            "ctinfo"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action ctinfo",
+                0,
+                1,
+                255
+            ],
+            "$TC action add action ctinfo zone 20 pass index 101"
+        ],
+        "cmdUnderTest": "$TC action add action ctinfo cpmark 0x02000000 drop index 101",
+        "expExitCode": "255",
+        "verifyCmd": "$TC action get action ctinfo index 101",
+        "matchPattern": "action order [0-9]*: ctinfo zone 20 pass.*index 101",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action ctinfo"
+        ]
+    },
+    {
+        "id": "8295",
+        "name": "Add ctinfo action with invalid index",
+        "category": [
+            "actions",
+            "ctinfo"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action ctinfo",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action add action ctinfo zone 20 index 4294967296",
+        "expExitCode": "255",
+        "verifyCmd": "$TC action ls action ctinfo",
+        "matchPattern": "action order [0-9]*: ctinfo",
+        "matchCount": "0",
+        "teardown": [
+            "$TC action flush action ctinfo"
+        ]
+    },
+    {
+        "id": "3964",
+        "name": "Replace ctinfo action with invalid goto_chain control",
+        "category": [
+            "actions",
+            "ctinfo"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action ctinfo",
+                0,
+                1,
+                255
+            ],
+            "$TC action add action ctinfo pass index 90"
+        ],
+        "cmdUnderTest": "$TC action replace action ctinfo goto chain 42 index 90",
+        "expExitCode": "255",
+        "verifyCmd": "$TC action list action ctinfo",
+        "matchPattern": "action order [0-9]*: ctinfo.*pass.*index 90",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action ctinfo"
+        ]
+    }
+]
-- 
2.17.1

