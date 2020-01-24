Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 435A3147594
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 01:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbgAXA0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 19:26:46 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:35510 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729917AbgAXA0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 19:26:46 -0500
Received: by mail-pl1-f177.google.com with SMTP id g6so41776plt.2
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 16:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zraw7szpvGOsa5pC9+Uhkw4zb38mpx8EEmkCmKxZFA0=;
        b=G7s7B8FhQZdEfg1ccz0QOqPFNnRuSndDdf4sMbttfDCd80DR7/ENtncmdUZlbyfBE4
         QMJyrXNtKSjF5uVihsLzXO26alLTvK2QErVkhcN40Nc6GSoinJsdX+kIG55OmzfG3ShM
         8wk0CWwZSGInxeeH2YIL02wddTK12HCBnb5lAxG4/tx31lHjgqbmg3otpQcY2ngWz1rR
         1krbaXAJBLkUi0C3zGA/Evb/tFbbzzhnQD01F7LfUyAgktpP6n6+1hCb4ADukoeeXRRl
         etR5hCu5zo7e2/jj2GAoipbtIL5RvAhroAjcdjKL+kteskzuFwHS288aApoClogTMHJP
         4JEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zraw7szpvGOsa5pC9+Uhkw4zb38mpx8EEmkCmKxZFA0=;
        b=NiK9qqFMZKLVM5Cov8cuh2g9YyHNSQHpdEuLgYu+P5HhzbFZna+skULJdr6cdti7nZ
         mm2H26jgYc5mh+TcCt1AANCHo26lpwzjOfY1LUIxz2pciWcFTeReIn26f9pAHDSKdXtv
         m4aaRRSBwlFOuRKXxwvgYH1w6T3itrczy78kLLoPMrRirZcWiji1PpwLh8lpGwqv8uT8
         YnZtwHQf6W3gigG7BQ5FqiD0nHvCmJ5PT3a71Q4i7sRX6jhb1TQB1XZdFFKZBY92QvO3
         ShVBkDA2nc4jSGk6fI95gnLqfAtgaVDsBE/353ClOdVEGZXEH6wFUH9SOOwg+tnSaxQz
         lkzA==
X-Gm-Message-State: APjAAAWDMXWNJ7oiGrIfJJfB02wVnv2o2IEDCJJrOA7ciHJciJGE5yOu
        JxRz1aLasKw//omBXwNIAm7iA9o/BtQ=
X-Google-Smtp-Source: APXvYqy+A2039Opk/lT0s4e9kXhzTx2vIw7njfq5lpiDzbCRNaQLmTUGahxMiNRW38SXZQgdxPnDBg==
X-Received: by 2002:a17:902:ac97:: with SMTP id h23mr779557plr.237.1579825605110;
        Thu, 23 Jan 2020 16:26:45 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id d194sm4001951pfd.159.2020.01.23.16.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 16:26:44 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+0a0596220218fcb603a8@syzkaller.appspotmail.com,
        syzbot+63bdb6006961d8c917c6@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: fix ops->bind_class() implementations
Date:   Thu, 23 Jan 2020 16:26:18 -0800
Message-Id: <20200124002618.21518-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementations of ops->bind_class() are merely
searching for classid and updating class in the struct tcf_result,
without invoking either of cl_ops->bind_tcf() or
cl_ops->unbind_tcf(). This breaks the design of them as qdisc's
like cbq use them to count filters too. This is why syzbot triggered
the warning in cbq_destroy_class().

In order to fix this, we have to call cl_ops->bind_tcf() and
cl_ops->unbind_tcf() like the filter binding path. This patch does
so by refactoring out two helper functions __tcf_bind_filter()
and __tcf_unbind_filter(), which are lockless and accept a Qdisc
pointer, then teaching each implementation to call them correctly.

Note, we merely pass the Qdisc pointer as an opaque pointer to
each filter, they only need to pass it down to the helper
functions without understanding it at all.

Fixes: 07d79fc7d94e ("net_sched: add reverse binding for tc class")
Reported-and-tested-by: syzbot+0a0596220218fcb603a8@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+63bdb6006961d8c917c6@syzkaller.appspotmail.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/net/pkt_cls.h     | 33 +++++++++++++++++++--------------
 include/net/sch_generic.h |  3 ++-
 net/sched/cls_basic.c     | 11 ++++++++---
 net/sched/cls_bpf.c       | 11 ++++++++---
 net/sched/cls_flower.c    | 11 ++++++++---
 net/sched/cls_fw.c        | 11 ++++++++---
 net/sched/cls_matchall.c  | 11 ++++++++---
 net/sched/cls_route.c     | 11 ++++++++---
 net/sched/cls_rsvp.h      | 11 ++++++++---
 net/sched/cls_tcindex.c   | 11 ++++++++---
 net/sched/cls_u32.c       | 11 ++++++++---
 net/sched/sch_api.c       |  6 ++++--
 12 files changed, 97 insertions(+), 44 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index e553fc80eb23..9976ad2f54fd 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -141,31 +141,38 @@ __cls_set_class(unsigned long *clp, unsigned long cl)
 	return xchg(clp, cl);
 }
 
-static inline unsigned long
-cls_set_class(struct Qdisc *q, unsigned long *clp, unsigned long cl)
+static inline void
+__tcf_bind_filter(struct Qdisc *q, struct tcf_result *r, unsigned long base)
 {
-	unsigned long old_cl;
+	unsigned long cl;
 
-	sch_tree_lock(q);
-	old_cl = __cls_set_class(clp, cl);
-	sch_tree_unlock(q);
-	return old_cl;
+	cl = q->ops->cl_ops->bind_tcf(q, base, r->classid);
+	cl = __cls_set_class(&r->class, cl);
+	if (cl)
+		q->ops->cl_ops->unbind_tcf(q, cl);
 }
 
 static inline void
 tcf_bind_filter(struct tcf_proto *tp, struct tcf_result *r, unsigned long base)
 {
 	struct Qdisc *q = tp->chain->block->q;
-	unsigned long cl;
 
 	/* Check q as it is not set for shared blocks. In that case,
 	 * setting class is not supported.
 	 */
 	if (!q)
 		return;
-	cl = q->ops->cl_ops->bind_tcf(q, base, r->classid);
-	cl = cls_set_class(q, &r->class, cl);
-	if (cl)
+	sch_tree_lock(q);
+	__tcf_bind_filter(q, r, base);
+	sch_tree_unlock(q);
+}
+
+static inline void
+__tcf_unbind_filter(struct Qdisc *q, struct tcf_result *r)
+{
+	unsigned long cl;
+
+	if ((cl = __cls_set_class(&r->class, 0)) != 0)
 		q->ops->cl_ops->unbind_tcf(q, cl);
 }
 
@@ -173,12 +180,10 @@ static inline void
 tcf_unbind_filter(struct tcf_proto *tp, struct tcf_result *r)
 {
 	struct Qdisc *q = tp->chain->block->q;
-	unsigned long cl;
 
 	if (!q)
 		return;
-	if ((cl = __cls_set_class(&r->class, 0)) != 0)
-		q->ops->cl_ops->unbind_tcf(q, cl);
+	__tcf_unbind_filter(q, r);
 }
 
 struct tcf_exts {
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index fceddf89592a..151208704ed2 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -318,7 +318,8 @@ struct tcf_proto_ops {
 					  void *type_data);
 	void			(*hw_del)(struct tcf_proto *tp,
 					  void *type_data);
-	void			(*bind_class)(void *, u32, unsigned long);
+	void			(*bind_class)(void *, u32, unsigned long,
+					      void *, unsigned long);
 	void *			(*tmplt_create)(struct net *net,
 						struct tcf_chain *chain,
 						struct nlattr **tca,
diff --git a/net/sched/cls_basic.c b/net/sched/cls_basic.c
index 4aafbe3d435c..f256a7c69093 100644
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -263,12 +263,17 @@ static void basic_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 	}
 }
 
-static void basic_bind_class(void *fh, u32 classid, unsigned long cl)
+static void basic_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			     unsigned long base)
 {
 	struct basic_filter *f = fh;
 
-	if (f && f->res.classid == classid)
-		f->res.class = cl;
+	if (f && f->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &f->res, base);
+		else
+			__tcf_unbind_filter(q, &f->res);
+	}
 }
 
 static int basic_dump(struct net *net, struct tcf_proto *tp, void *fh,
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 8229ed4a67be..6e3e63db0e01 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -631,12 +631,17 @@ static int cls_bpf_dump(struct net *net, struct tcf_proto *tp, void *fh,
 	return -1;
 }
 
-static void cls_bpf_bind_class(void *fh, u32 classid, unsigned long cl)
+static void cls_bpf_bind_class(void *fh, u32 classid, unsigned long cl,
+			       void *q, unsigned long base)
 {
 	struct cls_bpf_prog *prog = fh;
 
-	if (prog && prog->res.classid == classid)
-		prog->res.class = cl;
+	if (prog && prog->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &prog->res, base);
+		else
+			__tcf_unbind_filter(q, &prog->res);
+	}
 }
 
 static void cls_bpf_walk(struct tcf_proto *tp, struct tcf_walker *arg,
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index b0f42e62dd76..f9c0d1e8d380 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2765,12 +2765,17 @@ static int fl_tmplt_dump(struct sk_buff *skb, struct net *net, void *tmplt_priv)
 	return -EMSGSIZE;
 }
 
-static void fl_bind_class(void *fh, u32 classid, unsigned long cl)
+static void fl_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			  unsigned long base)
 {
 	struct cls_fl_filter *f = fh;
 
-	if (f && f->res.classid == classid)
-		f->res.class = cl;
+	if (f && f->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &f->res, base);
+		else
+			__tcf_unbind_filter(q, &f->res);
+	}
 }
 
 static bool fl_delete_empty(struct tcf_proto *tp)
diff --git a/net/sched/cls_fw.c b/net/sched/cls_fw.c
index c9496c920d6f..ec945294626a 100644
--- a/net/sched/cls_fw.c
+++ b/net/sched/cls_fw.c
@@ -419,12 +419,17 @@ static int fw_dump(struct net *net, struct tcf_proto *tp, void *fh,
 	return -1;
 }
 
-static void fw_bind_class(void *fh, u32 classid, unsigned long cl)
+static void fw_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			  unsigned long base)
 {
 	struct fw_filter *f = fh;
 
-	if (f && f->res.classid == classid)
-		f->res.class = cl;
+	if (f && f->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &f->res, base);
+		else
+			__tcf_unbind_filter(q, &f->res);
+	}
 }
 
 static struct tcf_proto_ops cls_fw_ops __read_mostly = {
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 7fc2eb62aa98..039cc86974f4 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -393,12 +393,17 @@ static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
 	return -1;
 }
 
-static void mall_bind_class(void *fh, u32 classid, unsigned long cl)
+static void mall_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			    unsigned long base)
 {
 	struct cls_mall_head *head = fh;
 
-	if (head && head->res.classid == classid)
-		head->res.class = cl;
+	if (head && head->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &head->res, base);
+		else
+			__tcf_unbind_filter(q, &head->res);
+	}
 }
 
 static struct tcf_proto_ops cls_mall_ops __read_mostly = {
diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 2d9e0b4484ea..6f8786b06bde 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -641,12 +641,17 @@ static int route4_dump(struct net *net, struct tcf_proto *tp, void *fh,
 	return -1;
 }
 
-static void route4_bind_class(void *fh, u32 classid, unsigned long cl)
+static void route4_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			      unsigned long base)
 {
 	struct route4_filter *f = fh;
 
-	if (f && f->res.classid == classid)
-		f->res.class = cl;
+	if (f && f->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &f->res, base);
+		else
+			__tcf_unbind_filter(q, &f->res);
+	}
 }
 
 static struct tcf_proto_ops cls_route4_ops __read_mostly = {
diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index 2f3c03b25d5d..c22624131949 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -738,12 +738,17 @@ static int rsvp_dump(struct net *net, struct tcf_proto *tp, void *fh,
 	return -1;
 }
 
-static void rsvp_bind_class(void *fh, u32 classid, unsigned long cl)
+static void rsvp_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			    unsigned long base)
 {
 	struct rsvp_filter *f = fh;
 
-	if (f && f->res.classid == classid)
-		f->res.class = cl;
+	if (f && f->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &f->res, base);
+		else
+			__tcf_unbind_filter(q, &f->res);
+	}
 }
 
 static struct tcf_proto_ops RSVP_OPS __read_mostly = {
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index e573e5a5c794..3d4a1280352f 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -654,12 +654,17 @@ static int tcindex_dump(struct net *net, struct tcf_proto *tp, void *fh,
 	return -1;
 }
 
-static void tcindex_bind_class(void *fh, u32 classid, unsigned long cl)
+static void tcindex_bind_class(void *fh, u32 classid, unsigned long cl,
+			       void *q, unsigned long base)
 {
 	struct tcindex_filter_result *r = fh;
 
-	if (r && r->res.classid == classid)
-		r->res.class = cl;
+	if (r && r->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &r->res, base);
+		else
+			__tcf_unbind_filter(q, &r->res);
+	}
 }
 
 static struct tcf_proto_ops cls_tcindex_ops __read_mostly = {
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index a0e6fac613de..e15ff335953d 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1255,12 +1255,17 @@ static int u32_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 	return 0;
 }
 
-static void u32_bind_class(void *fh, u32 classid, unsigned long cl)
+static void u32_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			   unsigned long base)
 {
 	struct tc_u_knode *n = fh;
 
-	if (n && n->res.classid == classid)
-		n->res.class = cl;
+	if (n && n->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &n->res, base);
+		else
+			__tcf_unbind_filter(q, &n->res);
+	}
 }
 
 static int u32_dump(struct net *net, struct tcf_proto *tp, void *fh,
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 1047825d9f48..943ad3425380 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1891,8 +1891,9 @@ static int tclass_del_notify(struct net *net,
 
 struct tcf_bind_args {
 	struct tcf_walker w;
-	u32 classid;
+	unsigned long base;
 	unsigned long cl;
+	u32 classid;
 };
 
 static int tcf_node_bind(struct tcf_proto *tp, void *n, struct tcf_walker *arg)
@@ -1903,7 +1904,7 @@ static int tcf_node_bind(struct tcf_proto *tp, void *n, struct tcf_walker *arg)
 		struct Qdisc *q = tcf_block_q(tp->chain->block);
 
 		sch_tree_lock(q);
-		tp->ops->bind_class(n, a->classid, a->cl);
+		tp->ops->bind_class(n, a->classid, a->cl, q, a->base);
 		sch_tree_unlock(q);
 	}
 	return 0;
@@ -1936,6 +1937,7 @@ static void tc_bind_tclass(struct Qdisc *q, u32 portid, u32 clid,
 
 			arg.w.fn = tcf_node_bind;
 			arg.classid = clid;
+			arg.base = cl;
 			arg.cl = new_cl;
 			tp->ops->walk(tp, &arg.w, true);
 		}
-- 
2.21.1

