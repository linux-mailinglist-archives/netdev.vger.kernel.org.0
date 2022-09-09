Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4FD5B2BA1
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 03:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiIIB1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 21:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiIIB1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 21:27:41 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5B51177A7;
        Thu,  8 Sep 2022 18:27:41 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MNyt42XNHzZcm3;
        Fri,  9 Sep 2022 09:23:08 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 9 Sep
 2022 09:27:39 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <shuah@kernel.org>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH net-next 8/8] selftests/tc-testings: add tunnel_key action deleting test case
Date:   Fri, 9 Sep 2022 09:29:36 +0800
Message-ID: <20220909012936.268433-9-shaozhengchao@huawei.com>
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

Test 3671: Delete tunnel_key set action with valid index
Test 8597: Delete tunnel_key set action with invalid index

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 .../tc-tests/actions/tunnel_key.json          | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
index d06346968bcb..b40ee602918a 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/tunnel_key.json
@@ -933,5 +933,55 @@
         "teardown": [
             "$TC actions flush action tunnel_key"
         ]
+    },
+    {
+        "id": "3671",
+        "name": "Delete tunnel_key set action with valid index",
+	"category": [
+            "actions",
+            "tunnel_key"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action tunnel_key",
+                0,
+                1,
+                255
+            ],
+	    "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 index 1"
+        ],
+        "cmdUnderTest": "$TC actions del action tunnel_key index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action tunnel_key",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*index 1",
+        "matchCount": "0",
+        "teardown": [
+            "$TC actions flush action tunnel_key"
+        ]
+    },
+    {
+        "id": "8597",
+        "name": "Delete tunnel_key set action with invalid index",
+        "category": [
+            "actions",
+            "tunnel_key"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action tunnel_key",
+                0,
+                1,
+                255
+            ],
+            "$TC actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 index 1"
+        ],
+        "cmdUnderTest": "$TC actions del action tunnel_key index 10",
+        "expExitCode": "255",
+        "verifyCmd": "$TC actions list action tunnel_key",
+        "matchPattern": "action order [0-9]+: tunnel_key.*set.*src_ip 1.1.1.1.*dst_ip 2.2.2.2.*index 1",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action tunnel_key"
+        ]
     }
 ]
-- 
2.17.1

