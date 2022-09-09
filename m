Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CE55B2B8F
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 03:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiIIB1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 21:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiIIB1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 21:27:40 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385B11177A6;
        Thu,  8 Sep 2022 18:27:38 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MNytp10h4z14QTk;
        Fri,  9 Sep 2022 09:23:46 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 9 Sep
 2022 09:27:36 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next 3/8] selftests/tc-testings: add selftests for xt action
Date:   Fri, 9 Sep 2022 09:29:31 +0800
Message-ID: <20220909012936.268433-4-shaozhengchao@huawei.com>
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

Test 2029: Add xt action with log-prefix
Test 3562: Replace xt action log-prefix
Test 8291: Delete xt action with valid index
Test 5169: Delete xt action with invalid index
Test 7284: List xt actions
Test 5010: Flush xt actions
Test 8437: Add xt action with duplicate index
Test 2837: Add xt action with invalid index

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/actions/xt.json       | 219 ++++++++++++++++++
 1 file changed, 219 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/xt.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/xt.json b/tools/testing/selftests/tc-testing/tc-tests/actions/xt.json
new file mode 100644
index 000000000000..c9f002aea6d4
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/xt.json
@@ -0,0 +1,219 @@
+[
+    {
+        "id": "2029",
+        "name": "Add xt action with log-prefix",
+        "category": [
+            "actions",
+            "xt"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action xt",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action add action xt -j LOG --log-prefix PONG index 100",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action ls action xt",
+        "matchPattern": "action order [0-9]*:.*target  LOG level warning prefix \"PONG\".*index 100 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action xt"
+        ]
+    },
+    {
+        "id": "3562",
+        "name": "Replace xt action log-prefix",
+        "category": [
+            "actions",
+            "xt"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action xt",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC action add action xt -j LOG --log-prefix PONG index 1",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action replace action xt -j LOG --log-prefix WIN index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action get action xt index 1",
+        "matchPattern": "action order [0-9]*:.*target  LOG level warning prefix \"WIN\".*index 1 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action xt"
+        ]
+    },
+    {
+        "id": "8291",
+        "name": "Delete xt action with valid index",
+        "category": [
+            "actions",
+            "xt"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action xt",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC action add action xt -j LOG --log-prefix PONG index 1000",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action delete action xt index 1000",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action get action xt index 1000",
+        "matchPattern": "action order [0-9]*:.*target  LOG level warning prefix \"PONG\".*index 1000 ref",
+        "matchCount": "0",
+        "teardown": [
+            "$TC action flush action xt"
+        ]
+    },
+    {
+        "id": "5169",
+        "name": "Delete xt action with invalid index",
+        "category": [
+            "actions",
+            "xt"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action xt",
+                0,
+                1,
+                255
+            ],
+            [
+                "$TC action add action xt -j LOG --log-prefix PONG index 1000",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action delete action xt index 333",
+        "expExitCode": "255",
+        "verifyCmd": "$TC action get action xt index 1000",
+        "matchPattern": "action order [0-9]*:.*target  LOG level warning prefix \"PONG\".*index 1000 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action xt"
+        ]
+    },
+    {
+        "id": "7284",
+        "name": "List xt actions",
+        "category": [
+            "actions",
+            "xt"
+        ],
+        "setup": [
+            [
+                "$TC action flush action xt",
+                0,
+                1,
+                255
+            ],
+            "$TC action add action xt -j LOG --log-prefix PONG index 1001",
+            "$TC action add action xt -j LOG --log-prefix WIN index 1002",
+            "$TC action add action xt -j LOG --log-prefix LOSE index 1003"
+        ],
+        "cmdUnderTest": "$TC action list action xt",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action list action xt",
+        "matchPattern": "action order [0-9]*: tablename:",
+        "matchCount": "3",
+        "teardown": [
+            "$TC actions flush action xt"
+        ]
+    },
+    {
+        "id": "5010",
+        "name": "Flush xt actions",
+        "category": [
+            "actions",
+            "xt"
+        ],
+        "setup": [
+            [
+		"$TC actions flush action xt",
+                0,
+                1,
+                255
+            ],
+            "$TC action add action xt -j LOG --log-prefix PONG index 1001",
+            "$TC action add action xt -j LOG --log-prefix WIN index 1002",
+            "$TC action add action xt -j LOG --log-prefix LOSE index 1003"
+	],
+        "cmdUnderTest": "$TC action flush action xt",
+        "expExitCode": "0",
+        "verifyCmd": "$TC action list action xt",
+        "matchPattern": "action order [0-9]*: tablename:",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action xt"
+        ]
+    },
+    {
+        "id": "8437",
+        "name": "Add xt action with duplicate index",
+        "category": [
+            "actions",
+            "xt"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action xt",
+                0,
+                1,
+                255
+            ],
+            "$TC action add action xt -j LOG --log-prefix PONG index 101"
+        ],
+        "cmdUnderTest": "$TC action add action xt -j LOG --log-prefix WIN index 101",
+        "expExitCode": "255",
+        "verifyCmd": "$TC action get action xt index 101",
+        "matchPattern": "action order [0-9]*:.*target  LOG level warning prefix \"PONG\".*index 101",
+        "matchCount": "1",
+        "teardown": [
+            "$TC action flush action xt"
+        ]
+    },
+    {
+        "id": "2837",
+        "name": "Add xt action with invalid index",
+        "category": [
+            "actions",
+            "xt"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action xt",
+                0,
+                1,
+                255
+            ]
+        ],
+        "cmdUnderTest": "$TC action add action xt -j LOG --log-prefix WIN index 4294967296",
+        "expExitCode": "255",
+        "verifyCmd": "$TC action ls action xt",
+        "matchPattern": "action order [0-9]*:*target  LOG level warning prefix \"WIN\"",
+        "matchCount": "0",
+        "teardown": [
+            "$TC action flush action xt"
+        ]
+    }
+]
-- 
2.17.1

