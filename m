Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C50E5EC303
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 14:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiI0MlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 08:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiI0Mkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 08:40:53 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4C7AE9EB;
        Tue, 27 Sep 2022 05:40:45 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4McK0z3sQWzHqJM;
        Tue, 27 Sep 2022 20:38:27 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 20:40:42 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next 2/3] net: sched: cls_api: introduce tc_cls_bind_class() helper
Date:   Tue, 27 Sep 2022 20:48:54 +0800
Message-ID: <20220927124855.252023-3-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220927124855.252023-1-shaozhengchao@huawei.com>
References: <20220927124855.252023-1-shaozhengchao@huawei.com>
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

All the bind_class callback duplicate the same logic, this patch
introduces tc_cls_bind_class() helper for common usage.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/pkt_cls.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index d376c995d906..4cabb32a2ad9 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -210,6 +210,18 @@ tcf_unbind_filter(struct tcf_proto *tp, struct tcf_result *r)
 	__tcf_unbind_filter(q, r);
 }
 
+static inline void tc_cls_bind_class(u32 classid, unsigned long cl,
+				     void *q, struct tcf_result *res,
+				     unsigned long base)
+{
+	if (res->classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, res, base);
+		else
+			__tcf_unbind_filter(q, res);
+	}
+}
+
 struct tcf_exts {
 #ifdef CONFIG_NET_CLS_ACT
 	__u32	type; /* for backward compat(TCA_OLD_COMPAT) */
-- 
2.17.1

