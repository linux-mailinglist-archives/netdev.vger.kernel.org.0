Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940DD5EC309
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 14:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiI0MlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 08:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbiI0Mk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 08:40:57 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09B7B089E;
        Tue, 27 Sep 2022 05:40:46 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4McJy54kSZzHtdQ;
        Tue, 27 Sep 2022 20:35:57 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 20:40:43 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
Subject: [PATCH net-next 3/3] net: sched: use tc_cls_bind_class() in filter
Date:   Tue, 27 Sep 2022 20:48:55 +0800
Message-ID: <20220927124855.252023-4-shaozhengchao@huawei.com>
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

Use tc_cls_bind_class() in filter.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/sched/cls_basic.c    | 7 +------
 net/sched/cls_bpf.c      | 7 +------
 net/sched/cls_flower.c   | 7 +------
 net/sched/cls_fw.c       | 7 +------
 net/sched/cls_matchall.c | 7 +------
 net/sched/cls_route.c    | 7 +------
 net/sched/cls_rsvp.h     | 7 +------
 net/sched/cls_tcindex.c  | 7 +------
 net/sched/cls_u32.c      | 7 +------
 9 files changed, 9 insertions(+), 54 deletions(-)

diff --git a/net/sched/cls_basic.c b/net/sched/cls_basic.c
index d9fbaa0fbe8b..d229ce99e554 100644
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -261,12 +261,7 @@ static void basic_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
 {
 	struct basic_filter *f = fh;
 
-	if (f && f->res.classid == classid) {
-		if (cl)
-			__tcf_bind_filter(q, &f->res, base);
-		else
-			__tcf_unbind_filter(q, &f->res);
-	}
+	tc_cls_bind_class(classid, cl, q, &f->res, base);
 }
 
 static int basic_dump(struct net *net, struct tcf_proto *tp, void *fh,
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 938be14cfa3f..bc317b3eac12 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -635,12 +635,7 @@ static void cls_bpf_bind_class(void *fh, u32 classid, unsigned long cl,
 {
 	struct cls_bpf_prog *prog = fh;
 
-	if (prog && prog->res.classid == classid) {
-		if (cl)
-			__tcf_bind_filter(q, &prog->res, base);
-		else
-			__tcf_unbind_filter(q, &prog->res);
-	}
+	tc_cls_bind_class(classid, cl, q, &prog->res, base);
 }
 
 static void cls_bpf_walk(struct tcf_proto *tp, struct tcf_walker *arg,
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 22d32b82bc09..25bc57ee6ea1 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -3405,12 +3405,7 @@ static void fl_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
 {
 	struct cls_fl_filter *f = fh;
 
-	if (f && f->res.classid == classid) {
-		if (cl)
-			__tcf_bind_filter(q, &f->res, base);
-		else
-			__tcf_unbind_filter(q, &f->res);
-	}
+	tc_cls_bind_class(classid, cl, q, &f->res, base);
 }
 
 static bool fl_delete_empty(struct tcf_proto *tp)
diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index fa66191574a4..a32351da968c 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -416,12 +416,7 @@ static void fw_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
 {
 	struct fw_filter *f = fh;
 
-	if (f && f->res.classid == classid) {
-		if (cl)
-			__tcf_bind_filter(q, &f->res, base);
-		else
-			__tcf_unbind_filter(q, &f->res);
-	}
+	tc_cls_bind_class(classid, cl, q, &f->res, base);
 }
 
 static struct tcf_proto_ops cls_fw_ops __read_mostly = {
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 63b99ffb7dbc..39a5d9c170de 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -394,12 +394,7 @@ static void mall_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
 {
 	struct cls_mall_head *head = fh;
 
-	if (head && head->res.classid == classid) {
-		if (cl)
-			__tcf_bind_filter(q, &head->res, base);
-		else
-			__tcf_unbind_filter(q, &head->res);
-	}
+	tc_cls_bind_class(classid, cl, q, &head->res, base);
 }
 
 static struct tcf_proto_ops cls_mall_ops __read_mostly = {
diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 17bb04af2fa8..9e43b929d4ca 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -649,12 +649,7 @@ static void route4_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
 {
 	struct route4_filter *f = fh;
 
-	if (f && f->res.classid == classid) {
-		if (cl)
-			__tcf_bind_filter(q, &f->res, base);
-		else
-			__tcf_unbind_filter(q, &f->res);
-	}
+	tc_cls_bind_class(classid, cl, q, &f->res, base);
 }
 
 static struct tcf_proto_ops cls_route4_ops __read_mostly = {
diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index fb60f2c2c325..b00a7dbd0587 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -733,12 +733,7 @@ static void rsvp_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
 {
 	struct rsvp_filter *f = fh;
 
-	if (f && f->res.classid == classid) {
-		if (cl)
-			__tcf_bind_filter(q, &f->res, base);
-		else
-			__tcf_unbind_filter(q, &f->res);
-	}
+	tc_cls_bind_class(classid, cl, q, &f->res, base);
 }
 
 static struct tcf_proto_ops RSVP_OPS __read_mostly = {
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index a33076033462..1c9eeb98d826 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -691,12 +691,7 @@ static void tcindex_bind_class(void *fh, u32 classid, unsigned long cl,
 {
 	struct tcindex_filter_result *r = fh;
 
-	if (r && r->res.classid == classid) {
-		if (cl)
-			__tcf_bind_filter(q, &r->res, base);
-		else
-			__tcf_unbind_filter(q, &r->res);
-	}
+	tc_cls_bind_class(classid, cl, q, &r->res, base);
 }
 
 static struct tcf_proto_ops cls_tcindex_ops __read_mostly = {
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 58c7680faabd..fa7302503bf5 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1246,12 +1246,7 @@ static void u32_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
 {
 	struct tc_u_knode *n = fh;
 
-	if (n && n->res.classid == classid) {
-		if (cl)
-			__tcf_bind_filter(q, &n->res, base);
-		else
-			__tcf_unbind_filter(q, &n->res);
-	}
+	tc_cls_bind_class(classid, cl, q, &n->res, base);
 }
 
 static int u32_dump(struct net *net, struct tcf_proto *tp, void *fh,
-- 
2.17.1

