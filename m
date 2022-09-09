Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15DB5B2B9D
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 03:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiIIB1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 21:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiIIB1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 21:27:40 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCA61177A7;
        Thu,  8 Sep 2022 18:27:38 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MNyx05NxQzHnlS;
        Fri,  9 Sep 2022 09:25:40 +0800 (CST)
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
Subject: [PATCH net-next 4/8] selftests/tc-testings: add connmark action deleting test case
Date:   Fri, 9 Sep 2022 09:29:32 +0800
Message-ID: <20220909012936.268433-5-shaozhengchao@huawei.com>
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

Test 6571: Delete connmark action with valid index
Test 3426: Delete connmark action with invalid index

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-testing/tc-tests/actions/connmark.json | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/connmark.json b/tools/testing/selftests/tc-testing/tc-tests/actions/connmark.json
index cadde8f41fcd..0de2f79ea329 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/connmark.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/connmark.json
@@ -312,5 +312,55 @@
         "teardown": [
             "$TC actions flush action connmark"
         ]
+    },
+    {
+        "id": "6571",
+        "name": "Delete connmark action with valid index",
+        "category": [
+            "actions",
+            "connmark"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action connmark",
+                0,
+                1,
+                255
+            ],
+	    "$TC actions add action connmark pass index 20"
+        ],
+        "cmdUnderTest": "$TC actions del action connmark index 20",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions get action connmark index 20",
+        "matchPattern": "action order [0-9]+: connmark zone 0 pass.*index 20 ref",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action connmark"
+        ]
+    },
+    {
+        "id": "3426",
+        "name": "Delete connmark action with invalid index",
+        "category": [
+            "actions",
+            "connmark"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action connmark",
+                0,
+                1,
+                255
+            ],
+            "$TC actions add action connmark pass index 20"
+        ],
+        "cmdUnderTest": "$TC actions del action connmark index 1",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions get action connmark index 20",
+        "matchPattern": "action order [0-9]+: connmark zone 0 pass.*index 20 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action connmark"
+        ]
     }
 ]
-- 
2.17.1

