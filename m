Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 302AD96C5A
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbfHTWdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37008 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731032AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NqsNCWbyKtsiYxaEmoSXqdNctr+oz40HPwdXxVuOUEs=; b=sUINY7RkFrPbPHV+uTcyzUg5ei
        8ldxG0qKxWypqEsYgjVN17M+bw1K3SuRJPd4LOwBZR5FWR7K6EkEdDlhZO6fNXdH0YkxE/fMETTnP
        i+uQQuu1158jOTiJfhxmEMpmFkMiSwfE6SPTup8t+heODTeMzbgv8maO6D1421dFmeVsIXxh6WpBR
        mR/dizSf1zGPv4Lob87Jv32awqNNO5fL9+nmHWNq9PZAyX4U3VXD586Y1Xtl3KEuVXE90d5lOUyNS
        1mao2R2AHGyvj4W/A0DmlOmnL9wPDdFjKiEZyXCNnmLBCysTea96imyv8f26G3vxX6nU7WmQJsxk2
        wfdZiL8w==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgZ-0005rw-15; Tue, 20 Aug 2019 22:33:03 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 25/38] cls_u32: Convert tc_u_hnode->handle_idr to XArray
Date:   Tue, 20 Aug 2019 15:32:46 -0700
Message-Id: <20190820223259.22348-26-willy@infradead.org>
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

Rename this IDR to 'knodes' since that's what's being stored in it.
Use xa_alloc_cyclic() since that's what's being emulated in gen_new_kid().
Allow gen_new_kid() to return a "no space" indicator.  Access to this
XArray is now under both the rtnl lock and the XArray spinlock.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/sched/cls_u32.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 18ef5f375976..46ddfd312952 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -38,7 +38,7 @@
 #include <net/netlink.h>
 #include <net/act_api.h>
 #include <net/pkt_cls.h>
-#include <linux/idr.h>
+#include <linux/xarray.h>
 
 struct tc_u_knode {
 	struct tc_u_knode __rcu	*next;
@@ -72,7 +72,7 @@ struct tc_u_hnode {
 	u32			prio;
 	int			refcnt;
 	unsigned int		divisor;
-	struct idr		handle_idr;
+	struct xarray		knodes;
 	bool			is_root;
 	struct rcu_head		rcu;
 	u32			flags;
@@ -366,7 +366,7 @@ static int u32_init(struct tcf_proto *tp)
 	root_ht->handle = tp_c ? gen_new_htid(tp_c, root_ht) : 0x80000000;
 	root_ht->prio = tp->prio;
 	root_ht->is_root = true;
-	idr_init(&root_ht->handle_idr);
+	xa_init_flags(&root_ht->knodes, XA_FLAGS_ALLOC);
 
 	if (tp_c == NULL) {
 		tp_c = kzalloc(sizeof(*tp_c), GFP_KERNEL);
@@ -461,7 +461,7 @@ static int u32_delete_key(struct tcf_proto *tp, struct tc_u_knode *key)
 				tp_c->knodes--;
 
 				tcf_unbind_filter(tp, &key->res);
-				idr_remove(&ht->handle_idr, key->handle);
+				xa_erase(&ht->knodes, key->handle);
 				tcf_exts_get_net(&key->exts);
 				tcf_queue_work(&key->rwork, u32_delete_key_freepf_work);
 				return 0;
@@ -585,7 +585,7 @@ static void u32_clear_hnode(struct tcf_proto *tp, struct tc_u_hnode *ht,
 			tp_c->knodes--;
 			tcf_unbind_filter(tp, &n->res);
 			u32_remove_hw_knode(tp, n, extack);
-			idr_remove(&ht->handle_idr, n->handle);
+			xa_erase(&ht->knodes, n->handle);
 			if (tcf_exts_get_net(&n->exts))
 				tcf_queue_work(&n->rwork, u32_delete_key_freepf_work);
 			else
@@ -611,7 +611,6 @@ static int u32_destroy_hnode(struct tcf_proto *tp, struct tc_u_hnode *ht,
 	     hn = &phn->next, phn = rtnl_dereference(*hn)) {
 		if (phn == ht) {
 			u32_clear_hw_hnode(tp, ht, extack);
-			idr_destroy(&ht->handle_idr);
 			xa_erase(&tp_c->ht_xa, ht->handle);
 			RCU_INIT_POINTER(*hn, ht->next);
 			kfree_rcu(ht, rcu);
@@ -687,15 +686,13 @@ static int u32_delete(struct tcf_proto *tp, void *arg, bool *last,
 
 static u32 gen_new_kid(struct tc_u_hnode *ht, u32 htid)
 {
-	u32 index = htid | 0x800;
-	u32 max = htid | 0xFFF;
-
-	if (idr_alloc_u32(&ht->handle_idr, NULL, &index, max, GFP_KERNEL)) {
-		index = htid + 1;
-		if (idr_alloc_u32(&ht->handle_idr, NULL, &index, max,
-				 GFP_KERNEL))
-			index = max;
-	}
+	u32 start = htid | 0x800;
+	u32 index;
+
+	if (xa_alloc_cyclic(&ht->knodes, &index, NULL,
+				XA_LIMIT(htid + 1, htid | 0xfff), &start,
+				GFP_KERNEL) < 0)
+		index = htid;
 
 	return index;
 }
@@ -789,7 +786,7 @@ static void u32_replace_knode(struct tcf_proto *tp, struct tc_u_common *tp_c,
 		if (pins->handle == n->handle)
 			break;
 
-	idr_replace(&ht->handle_idr, n, n->handle);
+	xa_store(&ht->knodes, n->handle, n, 0);
 	RCU_INIT_POINTER(n->next, pins->next);
 	rcu_assign_pointer(*ins, n);
 }
@@ -963,7 +960,7 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		ht->divisor = divisor;
 		ht->handle = handle;
 		ht->prio = tp->prio;
-		idr_init(&ht->handle_idr);
+		xa_init_flags(&ht->knodes, XA_FLAGS_ALLOC);
 		ht->flags = flags;
 
 		err = u32_replace_hw_hnode(tp, ht, flags, extack);
@@ -1008,12 +1005,14 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 			return -EINVAL;
 		}
 		handle = htid | TC_U32_NODE(handle);
-		err = idr_alloc_u32(&ht->handle_idr, NULL, &handle, handle,
-				    GFP_KERNEL);
+		err = xa_insert(&ht->knodes, handle, NULL, GFP_KERNEL);
 		if (err)
 			return err;
-	} else
+	} else {
 		handle = gen_new_kid(ht, htid);
+		if (handle == htid)
+			return -ENOBUFS;
+	}
 
 	if (tb[TCA_U32_SEL] == NULL) {
 		NL_SET_ERR_MSG_MOD(extack, "Selector not specified");
@@ -1108,7 +1107,7 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 #endif
 	kfree(n);
 erridr:
-	idr_remove(&ht->handle_idr, handle);
+	xa_erase(&ht->knodes, handle);
 	return err;
 }
 
-- 
2.23.0.rc1

