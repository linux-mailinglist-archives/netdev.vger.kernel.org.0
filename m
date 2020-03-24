Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFB7191131
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgCXNcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:32:41 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47537 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728576AbgCXNRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 09:17:33 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 24 Mar 2020 15:17:28 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02ODHSYq030372;
        Tue, 24 Mar 2020 15:17:28 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH net-next 1/3] netfilter: flowtable: Use rw sem as flow block lock
Date:   Tue, 24 Mar 2020 15:17:19 +0200
Message-Id: <1585055841-14256-2-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1585055841-14256-1-git-send-email-paulb@mellanox.com>
References: <1585055841-14256-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently flow offload threads are synchronized by the flow block mutex.
Use rw lock instead to increase flow insertion (read) concurrency.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
---
 include/net/netfilter/nf_flow_table.h |  2 +-
 net/netfilter/nf_flow_table_core.c    | 11 +++++------
 net/netfilter/nf_flow_table_offload.c |  4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f523ea8..956193b 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -73,7 +73,7 @@ struct nf_flowtable {
 	struct delayed_work		gc_work;
 	unsigned int			flags;
 	struct flow_block		flow_block;
-	struct mutex			flow_block_lock; /* Guards flow_block */
+	struct rw_semaphore		flow_block_lock; /* Guards flow_block */
 	possible_net_t			net;
 };
 
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 9a477bd..9399bb2 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -392,7 +392,7 @@ int nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
 	struct flow_block_cb *block_cb;
 	int err = 0;
 
-	mutex_lock(&flow_table->flow_block_lock);
+	down_write(&flow_table->flow_block_lock);
 	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
 	if (block_cb) {
 		err = -EEXIST;
@@ -408,7 +408,7 @@ int nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
 	list_add_tail(&block_cb->list, &block->cb_list);
 
 unlock:
-	mutex_unlock(&flow_table->flow_block_lock);
+	up_write(&flow_table->flow_block_lock);
 	return err;
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_add_cb);
@@ -419,13 +419,13 @@ void nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
 	struct flow_block *block = &flow_table->flow_block;
 	struct flow_block_cb *block_cb;
 
-	mutex_lock(&flow_table->flow_block_lock);
+	down_write(&flow_table->flow_block_lock);
 	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
 	if (block_cb)
 		list_del(&block_cb->list);
 	else
 		WARN_ON(true);
-	mutex_unlock(&flow_table->flow_block_lock);
+	up_write(&flow_table->flow_block_lock);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_del_cb);
 
@@ -551,7 +551,7 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 
 	INIT_DEFERRABLE_WORK(&flowtable->gc_work, nf_flow_offload_work_gc);
 	flow_block_init(&flowtable->flow_block);
-	mutex_init(&flowtable->flow_block_lock);
+	init_rwsem(&flowtable->flow_block_lock);
 
 	err = rhashtable_init(&flowtable->rhashtable,
 			      &nf_flow_offload_rhash_params);
@@ -614,7 +614,6 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
 	nf_flow_table_offload_flush(flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
-	mutex_destroy(&flow_table->flow_block_lock);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
 
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ca40dfa..26591d2 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -691,7 +691,7 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 	if (cmd == FLOW_CLS_REPLACE)
 		cls_flow.rule = flow_rule->rule;
 
-	mutex_lock(&flowtable->flow_block_lock);
+	down_read(&flowtable->flow_block_lock);
 	list_for_each_entry(block_cb, block_cb_list, list) {
 		err = block_cb->cb(TC_SETUP_CLSFLOWER, &cls_flow,
 				   block_cb->cb_priv);
@@ -700,7 +700,7 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
 
 		i++;
 	}
-	mutex_unlock(&flowtable->flow_block_lock);
+	up_read(&flowtable->flow_block_lock);
 
 	if (cmd == FLOW_CLS_STATS)
 		memcpy(stats, &cls_flow.stats, sizeof(*stats));
-- 
1.8.3.1

