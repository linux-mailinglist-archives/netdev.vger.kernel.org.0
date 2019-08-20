Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D8696C51
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731137AbfHTWd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37020 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731049AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wS0Pg711i60NN/j8RgpVwfILHAHlloOfykW9Zb4cfxc=; b=uLIUvIWD5pjpsxK8bUnr22t4yf
        xkpR1eePAoMpHaxCrtB+xPJkICRTO44UcM/Ne21pAcSW7D3emkET3Yr1zM02offLim7T2Xh+iZO85
        0NPktOhcjkjaxsKltn0oyGFzLo+8XWmlHyR/Oqho2wPyXGoPQWBthUseVdG7ij8Kr1DEQfYVlYeux
        97yBqLDNq5E7ydSTNdUKvsyKXIfOOxGdwo0Dabn6CPfPoPHuktQYT/HESKVvmwiXnjA/2ggBtvaZO
        yu2GthG/6TaYoEDD54msbdMyPHg3caPuBskVAhZkY9qE/TQlU3IZNncB1rUHJkxUshhn4nx22Y5uK
        idF40VUQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005sW-Af; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 31/38] cls_flower: Use XArray marks instead of separate list
Date:   Tue, 20 Aug 2019 15:32:52 -0700
Message-Id: <20190820223259.22348-32-willy@infradead.org>
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

Remove the hw_filter list in favour of using one of the XArray mark
bits which lets us iterate more efficiently than walking a linked list.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/sched/cls_flower.c | 47 ++++++++++--------------------------------
 1 file changed, 11 insertions(+), 36 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 2a1999d2b507..4625de5e29a7 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -85,11 +85,12 @@ struct fl_flow_tmplt {
 	struct tcf_chain *chain;
 };
 
+#define HW_FILTER	XA_MARK_1
+
 struct cls_fl_head {
 	struct rhashtable ht;
 	spinlock_t masks_lock; /* Protect masks list */
 	struct list_head masks;
-	struct list_head hw_filters;
 	struct rcu_work rwork;
 	struct xarray filters;
 };
@@ -102,7 +103,6 @@ struct cls_fl_filter {
 	struct tcf_result res;
 	struct fl_flow_key key;
 	struct list_head list;
-	struct list_head hw_list;
 	u32 handle;
 	u32 flags;
 	u32 in_hw_count;
@@ -332,7 +332,6 @@ static int fl_init(struct tcf_proto *tp)
 
 	spin_lock_init(&head->masks_lock);
 	INIT_LIST_HEAD_RCU(&head->masks);
-	INIT_LIST_HEAD(&head->hw_filters);
 	rcu_assign_pointer(tp->root, head);
 	xa_init_flags(&head->filters, XA_FLAGS_ALLOC1);
 
@@ -421,7 +420,6 @@ static void fl_hw_destroy_filter(struct tcf_proto *tp, struct cls_fl_filter *f,
 
 	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false);
 	spin_lock(&tp->lock);
-	list_del_init(&f->hw_list);
 	tcf_block_offload_dec(block, &f->flags);
 	spin_unlock(&tp->lock);
 
@@ -433,7 +431,6 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 				struct cls_fl_filter *f, bool rtnl_held,
 				struct netlink_ext_ack *extack)
 {
-	struct cls_fl_head *head = fl_head_dereference(tp);
 	struct tcf_block *block = tp->chain->block;
 	struct flow_cls_offload cls_flower = {};
 	bool skip_sw = tc_skip_sw(f->flags);
@@ -485,9 +482,6 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 		goto errout;
 	}
 
-	spin_lock(&tp->lock);
-	list_add(&f->hw_list, &head->hw_filters);
-	spin_unlock(&tp->lock);
 errout:
 	if (!rtnl_held)
 		rtnl_unlock();
@@ -1581,7 +1575,6 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		err = -ENOBUFS;
 		goto errout_tb;
 	}
-	INIT_LIST_HEAD(&fnew->hw_list);
 	refcount_set(&fnew->refcnt, 1);
 
 	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
@@ -1698,6 +1691,11 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 
 	*arg = fnew;
 
+	if (!tc_skip_hw(fnew->flags))
+		xa_set_mark(&head->filters, fnew->handle, HW_FILTER);
+	else if (fold)
+		xa_clear_mark(&head->filters, fnew->handle, HW_FILTER);
+
 	kfree(tb);
 	tcf_queue_work(&mask->rwork, fl_uninit_mask_free_work);
 	return 0;
@@ -1770,37 +1768,14 @@ static void fl_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 	arg->cookie = id;
 }
 
-static struct cls_fl_filter *
-fl_get_next_hw_filter(struct tcf_proto *tp, struct cls_fl_filter *f, bool add)
-{
-	struct cls_fl_head *head = fl_head_dereference(tp);
-
-	spin_lock(&tp->lock);
-	if (list_empty(&head->hw_filters)) {
-		spin_unlock(&tp->lock);
-		return NULL;
-	}
-
-	if (!f)
-		f = list_entry(&head->hw_filters, struct cls_fl_filter,
-			       hw_list);
-	list_for_each_entry_continue(f, &head->hw_filters, hw_list) {
-		if (!(add && f->deleted) && refcount_inc_not_zero(&f->refcnt)) {
-			spin_unlock(&tp->lock);
-			return f;
-		}
-	}
-
-	spin_unlock(&tp->lock);
-	return NULL;
-}
-
 static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 			void *cb_priv, struct netlink_ext_ack *extack)
 {
+	struct cls_fl_head *head = fl_head_dereference(tp);
 	struct tcf_block *block = tp->chain->block;
 	struct flow_cls_offload cls_flower = {};
-	struct cls_fl_filter *f = NULL;
+	struct cls_fl_filter *f;
+	unsigned long handle;
 	int err;
 
 	/* hw_filters list can only be changed by hw offload functions after
@@ -1809,7 +1784,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 	 */
 	ASSERT_RTNL();
 
-	while ((f = fl_get_next_hw_filter(tp, f, add))) {
+	xa_for_each_marked(&head->filters, handle, f, HW_FILTER) {
 		cls_flower.rule =
 			flow_rule_alloc(tcf_exts_num_actions(&f->exts));
 		if (!cls_flower.rule) {
-- 
2.23.0.rc1

