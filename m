Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDD8182D6C
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCLKX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:23:57 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:56533 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726851AbgCLKXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 06:23:33 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Mar 2020 12:23:28 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02CANSTb017875;
        Thu, 12 Mar 2020 12:23:28 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload v4 03/15] netfilter: flowtable: Add API for registering to flow table events
Date:   Thu, 12 Mar 2020 12:23:05 +0200
Message-Id: <1584008597-15875-4-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
References: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let drivers to add their cb allowing them to receive flow offload events
of type TC_SETUP_CLSFLOWER (REPLACE/DEL/STATS) for flows managed by the
flow table.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/netfilter/nf_flow_table.h |  6 +++++
 net/netfilter/nf_flow_table_core.c    | 47 +++++++++++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_offload.c |  4 +++
 3 files changed, 57 insertions(+)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index e0f709d9..d9d0945 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -44,6 +44,7 @@ struct nf_flowtable {
 	struct delayed_work		gc_work;
 	unsigned int			flags;
 	struct flow_block		flow_block;
+	struct mutex			flow_block_lock; /* Guards flow_block */
 	possible_net_t			net;
 };
 
@@ -129,6 +130,11 @@ struct nf_flow_route {
 struct flow_offload *flow_offload_alloc(struct nf_conn *ct);
 void flow_offload_free(struct flow_offload *flow);
 
+int nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
+				 flow_setup_cb_t *cb, void *cb_priv);
+void nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
+				  flow_setup_cb_t *cb, void *cb_priv);
+
 int flow_offload_route_init(struct flow_offload *flow,
 			    const struct nf_flow_route *route);
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 8af28e1..4af0327 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -372,6 +372,50 @@ static void nf_flow_offload_work_gc(struct work_struct *work)
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
 
+int nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
+				 flow_setup_cb_t *cb, void *cb_priv)
+{
+	struct flow_block *block = &flow_table->flow_block;
+	struct flow_block_cb *block_cb;
+	int err = 0;
+
+	mutex_lock(&flow_table->flow_block_lock);
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
+	mutex_unlock(&flow_table->flow_block_lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(nf_flow_table_offload_add_cb);
+
+void nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
+				  flow_setup_cb_t *cb, void *cb_priv)
+{
+	struct flow_block *block = &flow_table->flow_block;
+	struct flow_block_cb *block_cb;
+
+	mutex_lock(&flow_table->flow_block_lock);
+	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
+	if (block_cb)
+		list_del(&block_cb->list);
+	else
+		WARN_ON(true);
+	mutex_unlock(&flow_table->flow_block_lock);
+}
+EXPORT_SYMBOL_GPL(nf_flow_table_offload_del_cb);
+
 static int nf_flow_nat_port_tcp(struct sk_buff *skb, unsigned int thoff,
 				__be16 port, __be16 new_port)
 {
@@ -494,6 +538,7 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 
 	INIT_DEFERRABLE_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
 	flow_block_init(&flowtable->flow_block);
+	mutex_init(&flowtable->flow_block_lock);
 
 	err = rhashtable_init(&flowtable->rhashtable,
 			      &nf_flow_offload_rhash_params);
@@ -550,11 +595,13 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	mutex_lock(&flowtable_lock);
 	list_del(&flow_table->list);
 	mutex_unlock(&flowtable_lock);
+
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
 	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
 	nf_flow_table_offload_flush(flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
+	mutex_destroy(&flow_table->flow_block_lock);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 06f00cd..f5afdf0 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -610,6 +610,7 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 	if (cmd == FLOW_CLS_REPLACE)
 		cls_flow.rule = flow_rule->rule;
 
+	mutex_lock(&flowtable->flow_block_lock);
 	list_for_each_entry(block_cb, block_cb_list, list) {
 		err = block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow,
 				   block_cb->cb_priv);
@@ -618,6 +619,7 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 
 		i++;
 	}
+	mutex_unlock(&flowtable->flow_block_lock);
 
 	return i;
 }
@@ -692,8 +694,10 @@ static void flow_offload_tuple_stats(struct flow_offload_work *offload,
 			     FLOW_CLS_STATS,
 			     &offload->flow->tuplehash[dir].tuple, &extack);
 
+	mutex_lock(&flowtable->flow_block_lock);
 	list_for_each_entry(block_cb, &flowtable->flow_block.cb_list, list)
 		block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow, block_cb->cb_priv);
+	mutex_unlock(&flowtable->flow_block_lock);
 	memcpy(stats, &cls_flow.stats, sizeof(*stats));
 }
 
-- 
1.8.3.1

