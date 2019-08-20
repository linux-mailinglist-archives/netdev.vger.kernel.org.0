Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 131B496C4B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbfHTWdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37022 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731051AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZmZZXVlrj0yR9tD6NJHhZntmQHEYhX2foYRPM5aqMeQ=; b=S2pIgZG6TlvZ8jN1oty3Gsirho
        7b6FzAlhb0qr4H6XzUmrXhM2t2bKjNJEeKFm3au8Xb7O8z/D9jNwWWRrgKO7Z/Yr8ZOR+H1bcb0HB
        dbw8ypq7wahZmHZ9TcWSzYGdosLh62aC1CyLy3wEF1ssgy8CZVrfBq2kFk24K58t5C9rxQ8GqMwmA
        ovhH0GFbETKA1PPz5SNUIu3N9U/5Q5HQa+ptz7tCjiA1GPT02mWY2L/cS64GGRuhW/jD4CR+tc5ch
        KP/gvY47AxBcAtp8UF4otN5BJb+hvIN+sYRH477sRhp3qApq5Qy/owFDloDv7LMUBMkbvi4rZ28ge
        jNji0ZVw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005sc-CR; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 32/38] cls_basic: Convert handle_idr to XArray
Date:   Tue, 20 Aug 2019 15:32:53 -0700
Message-Id: <20190820223259.22348-33-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820223259.22348-1-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

The flist is redundant with the XArray, so remove it and use XArray
operations to iterate & look up filters by ID.  Locking is unadjusted,
so most XArray operations continue to be protected by both the rtnl
lock and the XArray spinlock.  Lookups remain under the rtnl lock,
but could be switched to pure RCU protection.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/sched/cls_basic.c | 56 ++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 35 deletions(-)

diff --git a/net/sched/cls_basic.c b/net/sched/cls_basic.c
index 4aafbe3d435c..66efad664a92 100644
--- a/net/sched/cls_basic.c
+++ b/net/sched/cls_basic.c
@@ -13,15 +13,14 @@
 #include <linux/errno.h>
 #include <linux/rtnetlink.h>
 #include <linux/skbuff.h>
-#include <linux/idr.h>
 #include <linux/percpu.h>
+#include <linux/xarray.h>
 #include <net/netlink.h>
 #include <net/act_api.h>
 #include <net/pkt_cls.h>
 
 struct basic_head {
-	struct list_head	flist;
-	struct idr		handle_idr;
+	struct xarray		filters;
 	struct rcu_head		rcu;
 };
 
@@ -31,7 +30,6 @@ struct basic_filter {
 	struct tcf_ematch_tree	ematches;
 	struct tcf_result	res;
 	struct tcf_proto	*tp;
-	struct list_head	link;
 	struct tc_basic_pcnt __percpu *pf;
 	struct rcu_work		rwork;
 };
@@ -42,8 +40,9 @@ static int basic_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 	int r;
 	struct basic_head *head = rcu_dereference_bh(tp->root);
 	struct basic_filter *f;
+	unsigned long index;
 
-	list_for_each_entry_rcu(f, &head->flist, link) {
+	xa_for_each(&head->filters, index, f) {
 		__this_cpu_inc(f->pf->rcnt);
 		if (!tcf_em_tree_match(skb, &f->ematches, NULL))
 			continue;
@@ -60,15 +59,8 @@ static int basic_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 static void *basic_get(struct tcf_proto *tp, u32 handle)
 {
 	struct basic_head *head = rtnl_dereference(tp->root);
-	struct basic_filter *f;
-
-	list_for_each_entry(f, &head->flist, link) {
-		if (f->handle == handle) {
-			return f;
-		}
-	}
 
-	return NULL;
+	return xa_load(&head->filters, handle);
 }
 
 static int basic_init(struct tcf_proto *tp)
@@ -78,8 +70,7 @@ static int basic_init(struct tcf_proto *tp)
 	head = kzalloc(sizeof(*head), GFP_KERNEL);
 	if (head == NULL)
 		return -ENOBUFS;
-	INIT_LIST_HEAD(&head->flist);
-	idr_init(&head->handle_idr);
+	xa_init_flags(&head->filters, XA_FLAGS_ALLOC1);
 	rcu_assign_pointer(tp->root, head);
 	return 0;
 }
@@ -107,18 +98,17 @@ static void basic_destroy(struct tcf_proto *tp, bool rtnl_held,
 			  struct netlink_ext_ack *extack)
 {
 	struct basic_head *head = rtnl_dereference(tp->root);
-	struct basic_filter *f, *n;
+	struct basic_filter *f;
+	unsigned long index;
 
-	list_for_each_entry_safe(f, n, &head->flist, link) {
-		list_del_rcu(&f->link);
+	xa_for_each(&head->filters, index, f) {
 		tcf_unbind_filter(tp, &f->res);
-		idr_remove(&head->handle_idr, f->handle);
+		xa_erase(&head->filters, index);
 		if (tcf_exts_get_net(&f->exts))
 			tcf_queue_work(&f->rwork, basic_delete_filter_work);
 		else
 			__basic_delete_filter(f);
 	}
-	idr_destroy(&head->handle_idr);
 	kfree_rcu(head, rcu);
 }
 
@@ -128,12 +118,11 @@ static int basic_delete(struct tcf_proto *tp, void *arg, bool *last,
 	struct basic_head *head = rtnl_dereference(tp->root);
 	struct basic_filter *f = arg;
 
-	list_del_rcu(&f->link);
 	tcf_unbind_filter(tp, &f->res);
-	idr_remove(&head->handle_idr, f->handle);
+	xa_erase(&head->filters, f->handle);
 	tcf_exts_get_net(&f->exts);
 	tcf_queue_work(&f->rwork, basic_delete_filter_work);
-	*last = list_empty(&head->flist);
+	*last = xa_empty(&head->filters);
 	return 0;
 }
 
@@ -199,17 +188,16 @@ static int basic_change(struct net *net, struct sk_buff *in_skb,
 	if (err < 0)
 		goto errout;
 
+	fnew->handle = handle;
 	if (!handle) {
-		handle = 1;
-		err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
-				    INT_MAX, GFP_KERNEL);
+		err = xa_alloc(&head->filters, &fnew->handle, fnew,
+				xa_limit_32b, GFP_KERNEL);
 	} else if (!fold) {
-		err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
-				    handle, GFP_KERNEL);
+		err = xa_insert(&head->filters, handle, fnew, GFP_KERNEL);
 	}
 	if (err)
 		goto errout;
-	fnew->handle = handle;
+
 	fnew->pf = alloc_percpu(struct tc_basic_pcnt);
 	if (!fnew->pf) {
 		err = -ENOMEM;
@@ -220,20 +208,17 @@ static int basic_change(struct net *net, struct sk_buff *in_skb,
 			      extack);
 	if (err < 0) {
 		if (!fold)
-			idr_remove(&head->handle_idr, fnew->handle);
+			xa_erase(&head->filters, fnew->handle);
 		goto errout;
 	}
 
 	*arg = fnew;
 
 	if (fold) {
-		idr_replace(&head->handle_idr, fnew, fnew->handle);
-		list_replace_rcu(&fold->link, &fnew->link);
+		xa_store(&head->filters, fnew->handle, fnew, GFP_KERNEL);
 		tcf_unbind_filter(tp, &fold->res);
 		tcf_exts_get_net(&fold->exts);
 		tcf_queue_work(&fold->rwork, basic_delete_filter_work);
-	} else {
-		list_add_rcu(&fnew->link, &head->flist);
 	}
 
 	return 0;
@@ -249,8 +234,9 @@ static void basic_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 {
 	struct basic_head *head = rtnl_dereference(tp->root);
 	struct basic_filter *f;
+	unsigned long index;
 
-	list_for_each_entry(f, &head->flist, link) {
+	xa_for_each(&head->filters, index, f) {
 		if (arg->count < arg->skip)
 			goto skip;
 
-- 
2.23.0.rc1

