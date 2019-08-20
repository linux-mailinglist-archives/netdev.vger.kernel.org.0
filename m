Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A17596C6D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbfHTWeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:34:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36974 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730953AbfHTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:33:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xTe8eISmXiNJDbKasUBColXUOkyVKIerkNqgvAuNgvo=; b=UdaJbHQguy1UDuGZRwPByEZt6e
        Q+PtYa0edxkrcNlDI4rK1uzkMNkRiSu2WRGcumAapFX9WF0fNuE4ziVEYOXg+ewCBObpEeSO0LgKv
        N4VZL99wPcA3TZiYJXgdqvyTrnUp8A5vwxzjx4n6rFdLNGUtdV2BJaxK3cLwcEBqtqDVC3489QZSA
        Xf3OD9sdn+aBoj7SJNMaeC3o0/0+v+6hJY4O1RyiCGPA/RstOkOXa3VOMxeVduW32FcPQoZcqIOE2
        bS8h1efvloqCprEMNLk9baYtas7PVJKDhm9Hr7UzSQ/J1Jx2n+1OjB3oYMHKPp1r6mnvsj5JmFC6U
        jVxKYMOQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i0CgY-0005qG-2E; Tue, 20 Aug 2019 22:33:02 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 08/38] nfp: Convert to XArray
Date:   Tue, 20 Aug 2019 15:32:29 -0700
Message-Id: <20190820223259.22348-9-willy@infradead.org>
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

A minor change in semantics where we simply store into the XArray rather
than insert; this only matters if there could already be something stored
at that index, and from my reading of the code that can't happen.

Use xa_for_each() rather than xas_for_each() as none of these loops
appear to be performance-critical.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/net/ethernet/netronome/nfp/abm/main.c |  4 +--
 drivers/net/ethernet/netronome/nfp/abm/main.h |  4 +--
 .../net/ethernet/netronome/nfp/abm/qdisc.c    | 33 +++++++------------
 3 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/main.c b/drivers/net/ethernet/netronome/nfp/abm/main.c
index 9183b3e85d21..2a06a3012e39 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/main.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/main.c
@@ -345,7 +345,7 @@ nfp_abm_vnic_alloc(struct nfp_app *app, struct nfp_net *nn, unsigned int id)
 	netif_keep_dst(nn->dp.netdev);
 
 	nfp_abm_vnic_set_mac(app->pf, abm, nn, id);
-	INIT_RADIX_TREE(&alink->qdiscs, GFP_KERNEL);
+	xa_init(&alink->qdiscs);
 
 	return 0;
 
@@ -361,7 +361,7 @@ static void nfp_abm_vnic_free(struct nfp_app *app, struct nfp_net *nn)
 	struct nfp_abm_link *alink = nn->app_priv;
 
 	nfp_abm_kill_reprs(alink->abm, alink);
-	WARN(!radix_tree_empty(&alink->qdiscs), "left over qdiscs\n");
+	WARN(!xa_empty(&alink->qdiscs), "left over qdiscs\n");
 	kfree(alink->prio_map);
 	kfree(alink);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/abm/main.h b/drivers/net/ethernet/netronome/nfp/abm/main.h
index 48746c9c6224..2b78abe606d9 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/main.h
+++ b/drivers/net/ethernet/netronome/nfp/abm/main.h
@@ -6,7 +6,7 @@
 
 #include <linux/bits.h>
 #include <linux/list.h>
-#include <linux/radix-tree.h>
+#include <linux/xarray.h>
 #include <net/devlink.h>
 #include <net/pkt_cls.h>
 #include <net/pkt_sched.h>
@@ -219,7 +219,7 @@ struct nfp_abm_link {
 	struct list_head dscp_map;
 
 	struct nfp_qdisc *root_qdisc;
-	struct radix_tree_root qdiscs;
+	struct xarray qdiscs;
 };
 
 static inline bool nfp_abm_has_prio(struct nfp_abm *abm)
diff --git a/drivers/net/ethernet/netronome/nfp/abm/qdisc.c b/drivers/net/ethernet/netronome/nfp/abm/qdisc.c
index 2473fb5f75e5..b40ee2f5e1c1 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/qdisc.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/qdisc.c
@@ -24,11 +24,6 @@ static bool nfp_abm_qdisc_child_valid(struct nfp_qdisc *qdisc, unsigned int id)
 	       qdisc->children[id] != NFP_QDISC_UNTRACKED;
 }
 
-static void *nfp_abm_qdisc_tree_deref_slot(void __rcu **slot)
-{
-	return rtnl_dereference(*slot);
-}
-
 static void
 nfp_abm_stats_propagate(struct nfp_alink_stats *parent,
 			struct nfp_alink_stats *child)
@@ -245,10 +240,8 @@ nfp_abm_offload_compile_mq(struct nfp_abm_link *alink, struct nfp_qdisc *qdisc)
 void nfp_abm_qdisc_offload_update(struct nfp_abm_link *alink)
 {
 	struct nfp_abm *abm = alink->abm;
-	struct radix_tree_iter iter;
 	struct nfp_qdisc *qdisc;
-	void __rcu **slot;
-	size_t i;
+	unsigned long i;
 
 	/* Mark all thresholds as unconfigured */
 	for (i = 0; i < abm->num_bands; i++)
@@ -257,17 +250,14 @@ void nfp_abm_qdisc_offload_update(struct nfp_abm_link *alink)
 			     alink->total_queues);
 
 	/* Clear offload marks */
-	radix_tree_for_each_slot(slot, &alink->qdiscs, &iter, 0) {
-		qdisc = nfp_abm_qdisc_tree_deref_slot(slot);
+	xa_for_each(&alink->qdiscs, i, qdisc)
 		qdisc->offload_mark = false;
-	}
 
 	if (alink->root_qdisc)
 		nfp_abm_offload_compile_mq(alink, alink->root_qdisc);
 
 	/* Refresh offload status */
-	radix_tree_for_each_slot(slot, &alink->qdiscs, &iter, 0) {
-		qdisc = nfp_abm_qdisc_tree_deref_slot(slot);
+	xa_for_each(&alink->qdiscs, i, qdisc) {
 		if (!qdisc->offload_mark && qdisc->offloaded)
 			nfp_abm_qdisc_offload_stop(alink, qdisc);
 		qdisc->offloaded = qdisc->offload_mark;
@@ -285,9 +275,9 @@ static void
 nfp_abm_qdisc_clear_mq(struct net_device *netdev, struct nfp_abm_link *alink,
 		       struct nfp_qdisc *qdisc)
 {
-	struct radix_tree_iter iter;
 	unsigned int mq_refs = 0;
-	void __rcu **slot;
+	unsigned long index;
+	struct nfp_qdisc *mq;
 
 	if (!qdisc->use_cnt)
 		return;
@@ -300,8 +290,7 @@ nfp_abm_qdisc_clear_mq(struct net_device *netdev, struct nfp_abm_link *alink,
 		return;
 
 	/* Count refs held by MQ instances and clear pointers */
-	radix_tree_for_each_slot(slot, &alink->qdiscs, &iter, 0) {
-		struct nfp_qdisc *mq = nfp_abm_qdisc_tree_deref_slot(slot);
+	xa_for_each(&alink->qdiscs, index, mq) {
 		unsigned int i;
 
 		if (mq->type != NFP_QDISC_MQ || mq->netdev != netdev)
@@ -326,8 +315,7 @@ nfp_abm_qdisc_free(struct net_device *netdev, struct nfp_abm_link *alink,
 	if (!qdisc)
 		return;
 	nfp_abm_qdisc_clear_mq(netdev, alink, qdisc);
-	WARN_ON(radix_tree_delete(&alink->qdiscs,
-				  TC_H_MAJ(qdisc->handle)) != qdisc);
+	WARN_ON(xa_erase(&alink->qdiscs, TC_H_MAJ(qdisc->handle)) != qdisc);
 
 	kfree(qdisc->children);
 	kfree(qdisc);
@@ -360,10 +348,11 @@ nfp_abm_qdisc_alloc(struct net_device *netdev, struct nfp_abm_link *alink,
 	qdisc->handle = handle;
 	qdisc->num_children = children;
 
-	err = radix_tree_insert(&alink->qdiscs, TC_H_MAJ(qdisc->handle), qdisc);
+	err = xa_err(xa_store(&alink->qdiscs, TC_H_MAJ(qdisc->handle), qdisc,
+				GFP_KERNEL));
 	if (err) {
 		nfp_err(alink->abm->app->cpp,
-			"Qdisc insertion into radix tree failed: %d\n", err);
+			"Qdisc insertion failed: %d\n", err);
 		goto err_free_child_tbl;
 	}
 
@@ -380,7 +369,7 @@ nfp_abm_qdisc_alloc(struct net_device *netdev, struct nfp_abm_link *alink,
 static struct nfp_qdisc *
 nfp_abm_qdisc_find(struct nfp_abm_link *alink, u32 handle)
 {
-	return radix_tree_lookup(&alink->qdiscs, TC_H_MAJ(handle));
+	return xa_load(&alink->qdiscs, TC_H_MAJ(handle));
 }
 
 static int
-- 
2.23.0.rc1

