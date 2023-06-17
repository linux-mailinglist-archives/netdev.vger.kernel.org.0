Return-Path: <netdev+bounces-11666-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3EE9733DC5
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 05:21:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10A621C210A8
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 03:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 034D7A3F;
	Sat, 17 Jun 2023 03:21:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1D4A3D
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 03:21:12 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202E226B3;
	Fri, 16 Jun 2023 20:21:10 -0700 (PDT)
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Qjh7b0drKztQX8;
	Sat, 17 Jun 2023 11:18:35 +0800 (CST)
Received: from localhost.huawei.com (10.137.16.203) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 17 Jun 2023 11:21:06 +0800
From: renmingshuai <renmingshuai@huawei.com>
To: <pctammela@mojatatu.com>, <vladbu@nvidia.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <jhs@mojatatu.com>,
	<xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <liaichun@huawei.com>, <caowangbao@huawei.com>, <yanan@huawei.com>,
	<liubo335@huawei.com>
Subject: [PATCH] selftests: tc-testing: add one test for flushing explicitly created chain
Date: Sat, 17 Jun 2023 11:20:33 +0800
Message-ID: <20230617032033.892064-1-renmingshuai@huawei.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.137.16.203]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the test for additional reference to chains that are explicitly created
 by RTM_NEWCHAIN message

commit c9a82bec02c3 ("net/sched: cls_api: Fix lockup on flushing explicitly
 created chain")
Signed-off-by: Mingshuai Ren <renmingshuai@huawei.com>
---
 .../tc-testing/tc-tests/infra/filter.json     | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/infra/filter.json

diff --git a/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json b/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
new file mode 100644
index 000000000000..c4c778e83da2
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
@@ -0,0 +1,25 @@
+[
+    {
+        "id": "c2b4",
+        "name": "soft lockup alarm will be not generated after delete the prio 0 filter of the chain",
+        "category": [
+            "filter",
+            "chain"
+        ],
+        "setup": [
+            "$IP link add dev $DUMMY type dummy || /bin/true",
+            "$TC qdisc add dev $DUMMY root handle 1: htb default 1",
+            "$TC chain add dev $DUMMY",
+            "$TC filter del dev $DUMMY chain 0 parent 1: prio 0"
+        ],
+        "cmdUnderTest": "$TC filter add dev $DUMMY chain 0 parent 1:",
+        "expExitCode": "2",
+        "verifyCmd": "$TC chain ls dev $DUMMY",
+        "matchPattern": "chain parent 1: chain 0",
+        "matchCount": "1",
+        "teardown": [
+            "$TC qdisc del dev $DUMMY root handle 1: htb default 1",
+            "$IP link del dev $DUMMY type dummy"
+        ]
+    }
+]
-- 
2.27.0


