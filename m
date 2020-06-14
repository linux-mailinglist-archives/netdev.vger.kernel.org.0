Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1169B1F888A
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 13:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgFNLNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 07:13:02 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54951 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726014AbgFNLM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 07:12:58 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with SMTP; 14 Jun 2020 14:12:51 +0300
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 05EBCocp013296;
        Sun, 14 Jun 2020 14:12:51 +0300
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, davem@davemloft.net,
        Jiri Pirko <jiri@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Roi Dayan <roid@mellanox.com>, Alaa Hleihel <alaa@mellanox.com>
Subject: [PATCH net 2/2] netfilter: flowtable: Make nf_flow_table_offload_add/del_cb inline
Date:   Sun, 14 Jun 2020 14:12:49 +0300
Message-Id: <20200614111249.6145-3-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20200614111249.6145-1-roid@mellanox.com>
References: <20200614111249.6145-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

Currently, nf_flow_table_offload_add/del_cb are exported by nf_flow_table
module, therefore modules using them will have hard-dependency
on nf_flow_table and will require loading it all the time.

This can lead to an unnecessary overhead on systems that do not
use this API.

To relax the hard-dependency between the modules, we unexport these
functions and make them static inline.

Fixes: 978703f42549 ("netfilter: flowtable: Add API for registering to flow table events")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 include/net/netfilter/nf_flow_table.h | 49 ++++++++++++++++++++++++++++++++---
 net/netfilter/nf_flow_table_core.c    | 45 --------------------------------
 2 files changed, 45 insertions(+), 49 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index c54a7f707e50..8a8f0e64edc3 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -161,10 +161,51 @@ struct nf_flow_route {
 struct flow_offload *flow_offload_alloc(struct nf_conn *ct);
 void flow_offload_free(struct flow_offload *flow);
 
-int nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
-				 flow_setup_cb_t *cb, void *cb_priv);
-void nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
-				  flow_setup_cb_t *cb, void *cb_priv);
+static inline int
+nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
+			     flow_setup_cb_t *cb, void *cb_priv)
+{
+	struct flow_block *block = &flow_table->flow_block;
+	struct flow_block_cb *block_cb;
+	int err = 0;
+
+	down_write(&flow_table->flow_block_lock);
+	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
+	if (block_cb) {
+		err = -EEXIST;
+		goto unlock;
+	}
+
+	block_cb = flow_block_cb_alloc(cb, cb_priv, cb_priv, NULL);
+	if (IS_ERR(block_cb)) {
+		err = PTR_ERR(block_cb);
+		goto unlock;
+	}
+
+	list_add_tail(&block_cb->list, &block->cb_list);
+
+unlock:
+	up_write(&flow_table->flow_block_lock);
+	return err;
+}
+
+static inline void
+nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
+			     flow_setup_cb_t *cb, void *cb_priv)
+{
+	struct flow_block *block = &flow_table->flow_block;
+	struct flow_block_cb *block_cb;
+
+	down_write(&flow_table->flow_block_lock);
+	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
+	if (block_cb) {
+		list_del(&block_cb->list);
+		flow_block_cb_free(block_cb);
+	} else {
+		WARN_ON(true);
+	}
+	up_write(&flow_table->flow_block_lock);
+}
 
 int flow_offload_route_init(struct flow_offload *flow,
 			    const struct nf_flow_route *route);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 42da6e337276..647680175213 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -387,51 +387,6 @@ static void nf_flow_offload_work_gc(struct work_struct *work)
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
 
-int nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
-				 flow_setup_cb_t *cb, void *cb_priv)
-{
-	struct flow_block *block = &flow_table->flow_block;
-	struct flow_block_cb *block_cb;
-	int err = 0;
-
-	down_write(&flow_table->flow_block_lock);
-	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
-	if (block_cb) {
-		err = -EEXIST;
-		goto unlock;
-	}
-
-	block_cb = flow_block_cb_alloc(cb, cb_priv, cb_priv, NULL);
-	if (IS_ERR(block_cb)) {
-		err = PTR_ERR(block_cb);
-		goto unlock;
-	}
-
-	list_add_tail(&block_cb->list, &block->cb_list);
-
-unlock:
-	up_write(&flow_table->flow_block_lock);
-	return err;
-}
-EXPORT_SYMBOL_GPL(nf_flow_table_offload_add_cb);
-
-void nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
-				  flow_setup_cb_t *cb, void *cb_priv)
-{
-	struct flow_block *block = &flow_table->flow_block;
-	struct flow_block_cb *block_cb;
-
-	down_write(&flow_table->flow_block_lock);
-	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
-	if (block_cb) {
-		list_del(&block_cb->list);
-		flow_block_cb_free(block_cb);
-	} else {
-		WARN_ON(true);
-	}
-	up_write(&flow_table->flow_block_lock);
-}
-EXPORT_SYMBOL_GPL(nf_flow_table_offload_del_cb);
 
 static int nf_flow_nat_port_tcp(struct sk_buff *skb, unsigned int thoff,
 				__be16 port, __be16 new_port)
-- 
2.8.4

