Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBBD96C44
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731095AbfHTWdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37016 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731045AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+UjDYHJQHGXLV/E9l0IC61mmjdL5/8CXCPsmpfUS+30=; b=sGD2fJ4xLd4V9r1w32bETa4kip
        T+2HP42xpx+G4BTZDFQTcNqrXa5OiUshHKwR/2jKsEihj2NP7jYDG74RL7jzzKB/EV69fMsD55Qfc
        dMOQ+wTcUnHJqZCgpg6Se2x8unxRlEqzoCjNfL0uBTJIMw1fLHcEtKXWIOsz2i1KdBPnQKsLGtntV
        KJmLm8vGsHwp15Zylnb2vdiP6W/Ug3+/QNKQ/llCEnL5D2ttdvBcXh3/cBIP4dYHkfRO5pApRh915
        h4ab6pxZ2jUf7Ljo73S66XNuDEQAiS12CKNV5wPlnvBOYPqMxMvwCsz6i1wedKGwcXRot5v8LNGio
        Ch4tWxxQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005sK-6u; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 29/38] cls_flower: Convert handle_idr to XArray
Date:   Tue, 20 Aug 2019 15:32:50 -0700
Message-Id: <20190820223259.22348-30-willy@infradead.org>
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

Inline __fl_get() into fl_get().  Use the RCU lock explicitly for
lookups and walks instead of relying on RTNL.  The xa_lock protects us,
but remains nested under the RTNL for now.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/sched/cls_flower.c | 54 ++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 054123742e32..54026c9e9b05 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -91,7 +91,7 @@ struct cls_fl_head {
 	struct list_head masks;
 	struct list_head hw_filters;
 	struct rcu_work rwork;
-	struct idr handle_idr;
+	struct xarray filters;
 };
 
 struct cls_fl_filter {
@@ -334,7 +334,7 @@ static int fl_init(struct tcf_proto *tp)
 	INIT_LIST_HEAD_RCU(&head->masks);
 	INIT_LIST_HEAD(&head->hw_filters);
 	rcu_assign_pointer(tp->root, head);
-	idr_init(&head->handle_idr);
+	xa_init_flags(&head->filters, XA_FLAGS_ALLOC1);
 
 	return rhashtable_init(&head->ht, &mask_ht_params);
 }
@@ -530,19 +530,6 @@ static void __fl_put(struct cls_fl_filter *f)
 		__fl_destroy_filter(f);
 }
 
-static struct cls_fl_filter *__fl_get(struct cls_fl_head *head, u32 handle)
-{
-	struct cls_fl_filter *f;
-
-	rcu_read_lock();
-	f = idr_find(&head->handle_idr, handle);
-	if (f && !refcount_inc_not_zero(&f->refcnt))
-		f = NULL;
-	rcu_read_unlock();
-
-	return f;
-}
-
 static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 		       bool *last, bool rtnl_held,
 		       struct netlink_ext_ack *extack)
@@ -560,7 +547,7 @@ static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 	f->deleted = true;
 	rhashtable_remove_fast(&f->mask->ht, &f->ht_node,
 			       f->mask->filter_ht_params);
-	idr_remove(&head->handle_idr, f->handle);
+	xa_erase(&head->filters, f->handle);
 	list_del_rcu(&f->list);
 	spin_unlock(&tp->lock);
 
@@ -599,7 +586,7 @@ static void fl_destroy(struct tcf_proto *tp, bool rtnl_held,
 				break;
 		}
 	}
-	idr_destroy(&head->handle_idr);
+	xa_destroy(&head->filters);
 
 	__module_get(THIS_MODULE);
 	tcf_queue_work(&head->rwork, fl_destroy_sleepable);
@@ -615,8 +602,15 @@ static void fl_put(struct tcf_proto *tp, void *arg)
 static void *fl_get(struct tcf_proto *tp, u32 handle)
 {
 	struct cls_fl_head *head = fl_head_dereference(tp);
+	struct cls_fl_filter *f;
+
+	rcu_read_lock();
+	f = xa_load(&head->filters, handle);
+	if (f && !refcount_inc_not_zero(&f->refcnt))
+		f = NULL;
+	rcu_read_unlock();
 
-	return __fl_get(head, handle);
+	return f;
 }
 
 static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
@@ -1663,7 +1657,7 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		rhashtable_remove_fast(&fold->mask->ht,
 				       &fold->ht_node,
 				       fold->mask->filter_ht_params);
-		idr_replace(&head->handle_idr, fnew, fnew->handle);
+		xa_store(&head->filters, fnew->handle, fnew, 0);
 		list_replace_rcu(&fold->list, &fnew->list);
 		fold->deleted = true;
 
@@ -1681,8 +1675,9 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	} else {
 		if (handle) {
 			/* user specifies a handle and it doesn't exist */
-			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
-					    handle, GFP_ATOMIC);
+			fnew->handle = handle;
+			err = xa_insert(&head->filters, handle, fnew,
+					GFP_ATOMIC);
 
 			/* Filter with specified handle was concurrently
 			 * inserted after initial check in cls_api. This is not
@@ -1690,18 +1685,16 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 			 * message flags. Returning EAGAIN will cause cls_api to
 			 * try to update concurrently inserted rule.
 			 */
-			if (err == -ENOSPC)
+			if (err == -EBUSY)
 				err = -EAGAIN;
 		} else {
-			handle = 1;
-			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
-					    INT_MAX, GFP_ATOMIC);
+			err = xa_alloc(&head->filters, &fnew->handle, fnew,
+					xa_limit_31b, GFP_ATOMIC);
 		}
 		if (err)
 			goto errout_hw;
 
 		refcount_inc(&fnew->refcnt);
-		fnew->handle = handle;
 		list_add_tail_rcu(&fnew->list, &fnew->mask->filters);
 		spin_unlock(&tp->lock);
 	}
@@ -1755,23 +1748,28 @@ static void fl_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 		    bool rtnl_held)
 {
 	struct cls_fl_head *head = fl_head_dereference(tp);
-	unsigned long id = arg->cookie, tmp;
+	unsigned long id;
 	struct cls_fl_filter *f;
 
 	arg->count = arg->skip;
 
-	idr_for_each_entry_continue_ul(&head->handle_idr, f, tmp, id) {
+	rcu_read_lock();
+	xa_for_each_start(&head->filters, id, f, arg->cookie) {
 		/* don't return filters that are being deleted */
 		if (!refcount_inc_not_zero(&f->refcnt))
 			continue;
+		rcu_read_unlock();
 		if (arg->fn(tp, f, arg) < 0) {
 			__fl_put(f);
 			arg->stop = 1;
+			rcu_read_lock();
 			break;
 		}
 		__fl_put(f);
 		arg->count++;
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 	arg->cookie = id;
 }
 
-- 
2.23.0.rc1

