Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAC3796C59
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfHTWdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:33:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731026AbfHTWdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OmY/G/h6m1qtU3MF3FkWrlAU1a8ggfwVufqd9nffwjk=; b=J3fRxlUw/9vQyZApP4PYvnBryZ
        fiGsPmFQqwv3XnO3Bc+osaup4jxFlUEdwWV0oQQoO95R/oa6Gt2mklzP0lQ7Jvlbmbu/par0jDF5H
        K9QjSElDh1hmXmQg034F2gPJV5YMf3be2osl3lh+r9Ha9GC3/NBBOr+07dYc8eNoQz6opILXoq9YG
        zcFx8d9yiFiavdEiqujAIjp02WdIhuJTiE3ZZNxckM1sqT+BuB/gK8dH84VPOuZQ2a/haZECpJCNu
        9Fy4amAcHLl0tdKKOBZ5NtWnnKW7W9fEFTQzD7UeMkfwdVo4Pz3b3vNzHGazIFYiUH/MnYJ9vhREh
        cgkNcM6g==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005rq-Vo; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 24/38] cls_u32: Convert tc_u_common->handle_idr to XArray
Date:   Tue, 20 Aug 2019 15:32:45 -0700
Message-Id: <20190820223259.22348-25-willy@infradead.org>
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

There are two structures called 'handle_idr' in this module, which is
most confusing.  Rename this one to ht_xa.  Leave the existing locking
alone, which means that we're covered by both the rtnl lock and the
XArray spinlock when accessing this XArray.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/sched/cls_u32.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 8614088edd1b..18ef5f375976 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -86,7 +86,8 @@ struct tc_u_common {
 	struct tc_u_hnode __rcu	*hlist;
 	void			*ptr;
 	int			refcnt;
-	struct idr		handle_idr;
+	u32			ht_next;
+	struct xarray		ht_xa;
 	struct hlist_node	hnode;
 	long			knodes;
 };
@@ -305,8 +306,12 @@ static void *u32_get(struct tcf_proto *tp, u32 handle)
 /* Protected by rtnl lock */
 static u32 gen_new_htid(struct tc_u_common *tp_c, struct tc_u_hnode *ptr)
 {
-	int id = idr_alloc_cyclic(&tp_c->handle_idr, ptr, 1, 0x7FF, GFP_KERNEL);
-	if (id < 0)
+	int err;
+	u32 id;
+
+	err = xa_alloc_cyclic(&tp_c->ht_xa, &id, ptr, XA_LIMIT(0, 0x7ff),
+			&tp_c->ht_next, GFP_KERNEL);
+	if (err < 0)
 		return 0;
 	return (id | 0x800U) << 20;
 }
@@ -371,8 +376,7 @@ static int u32_init(struct tcf_proto *tp)
 		}
 		tp_c->ptr = key;
 		INIT_HLIST_NODE(&tp_c->hnode);
-		idr_init(&tp_c->handle_idr);
-
+		xa_init_flags(&tp_c->ht_xa, XA_FLAGS_ALLOC1);
 		hlist_add_head(&tp_c->hnode, tc_u_hash(key));
 	}
 
@@ -608,7 +612,7 @@ static int u32_destroy_hnode(struct tcf_proto *tp, struct tc_u_hnode *ht,
 		if (phn == ht) {
 			u32_clear_hw_hnode(tp, ht, extack);
 			idr_destroy(&ht->handle_idr);
-			idr_remove(&tp_c->handle_idr, ht->handle);
+			xa_erase(&tp_c->ht_xa, ht->handle);
 			RCU_INIT_POINTER(*hn, ht->next);
 			kfree_rcu(ht, rcu);
 			return 0;
@@ -645,7 +649,6 @@ static void u32_destroy(struct tcf_proto *tp, bool rtnl_held,
 				kfree_rcu(ht, rcu);
 		}
 
-		idr_destroy(&tp_c->handle_idr);
 		kfree(tp_c);
 	}
 
@@ -950,8 +953,7 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 				return -ENOMEM;
 			}
 		} else {
-			err = idr_alloc_u32(&tp_c->handle_idr, ht, &handle,
-					    handle, GFP_KERNEL);
+			err = xa_insert(&tp_c->ht_xa, handle, ht, GFP_KERNEL);
 			if (err) {
 				kfree(ht);
 				return err;
@@ -966,7 +968,7 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 
 		err = u32_replace_hw_hnode(tp, ht, flags, extack);
 		if (err) {
-			idr_remove(&tp_c->handle_idr, handle);
+			xa_erase(&tp_c->ht_xa, handle);
 			kfree(ht);
 			return err;
 		}
-- 
2.23.0.rc1

