Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8C51FD2EB
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgFQQzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:55:16 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:61218 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgFQQzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 12:55:16 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id F3DFA4164C;
        Thu, 18 Jun 2020 00:55:09 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pablo@netfilter.org, vladbu@mellanox.com,
        simon.horman@netronome.com
Subject: [PATCH net v4 3/4] net: flow_offload: fix flow_indr_dev_unregister path
Date:   Thu, 18 Jun 2020 00:55:06 +0800
Message-Id: <1592412907-3856-4-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592412907-3856-1-git-send-email-wenxu@ucloud.cn>
References: <1592412907-3856-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS01JQkJCQ09PTk5KS0JZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdIjULOBw6SBIDIw8oDgseLyQ4OTocVlZVSkNKSChJWVdZCQ
        4XHghZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ohg6Azo6Hjg8PzUfLCgvHRYR
        TD4KCzdVSlVKTkJJT0pJQkpLSkpNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUpJSEhKNwY+
X-HM-Tid: 0a72c334b1bf2086kuqyf3dfa4164c
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

If the representor is removed, then identify the indirect flow_blocks
that need to be removed by the release callback and the port representor
structure. To identify the port representor structure, a new
indr.cb_priv field needs to be introduced. The flow_block also needs to
be removed from the driver list from the cleanup path.

Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c |  5 +++--
 drivers/net/ethernet/netronome/nfp/flower/main.c    |  2 +-
 drivers/net/ethernet/netronome/nfp/flower/main.h    |  3 +--
 drivers/net/ethernet/netronome/nfp/flower/offload.c |  8 ++++----
 include/net/flow_offload.h                          |  4 +++-
 net/core/flow_offload.c                             | 16 ++++++++++------
 net/netfilter/nf_flow_table_offload.c               |  1 +
 net/netfilter/nf_tables_offload.c                   |  1 +
 net/sched/cls_api.c                                 |  1 +
 10 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 3e3a884..4a11c1e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1911,7 +1911,7 @@ static int bnxt_tc_setup_indr_block(struct net_device *netdev, struct bnxt *bp,
 		block_cb = flow_indr_block_cb_alloc(bnxt_tc_setup_indr_block_cb,
 						    cb_priv, cb_priv,
 						    bnxt_tc_setup_indr_rel, f,
-						    netdev, data, cleanup);
+						    netdev, data, bp, cleanup);
 		if (IS_ERR(block_cb)) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
@@ -2079,7 +2079,7 @@ void bnxt_shutdown_tc(struct bnxt *bp)
 		return;
 
 	flow_indr_dev_unregister(bnxt_tc_setup_indr_cb, bp,
-				 bnxt_tc_setup_indr_block_cb);
+				 bnxt_tc_setup_indr_rel);
 	rhashtable_destroy(&tc_info->flow_table);
 	rhashtable_destroy(&tc_info->l2_table);
 	rhashtable_destroy(&tc_info->decap_l2_table);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index d629864..eefeb1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -442,7 +442,8 @@ static void mlx5e_rep_indr_block_unbind(void *cb_priv)
 
 		block_cb = flow_indr_block_cb_alloc(setup_cb, indr_priv, indr_priv,
 						    mlx5e_rep_indr_block_unbind,
-						    f, netdev, data, cleanup);
+						    f, netdev, data, rpriv,
+						    cleanup);
 		if (IS_ERR(block_cb)) {
 			list_del(&indr_priv->list);
 			kfree(indr_priv);
@@ -503,7 +504,7 @@ int mlx5e_rep_tc_netdevice_event_register(struct mlx5e_rep_priv *rpriv)
 void mlx5e_rep_tc_netdevice_event_unregister(struct mlx5e_rep_priv *rpriv)
 {
 	flow_indr_dev_unregister(mlx5e_rep_indr_setup_cb, rpriv,
-				 mlx5e_rep_indr_setup_tc_cb);
+				 mlx5e_rep_indr_block_unbind);
 }
 
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index c393276..bb448c8 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -861,7 +861,7 @@ static void nfp_flower_clean(struct nfp_app *app)
 	flush_work(&app_priv->cmsg_work);
 
 	flow_indr_dev_unregister(nfp_flower_indr_setup_tc_cb, app,
-				 nfp_flower_setup_indr_block_cb);
+				 nfp_flower_setup_indr_tc_release);
 
 	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
 		nfp_flower_qos_cleanup(app);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 56b3b68..7f54a62 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -462,8 +462,7 @@ int nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
 				enum tc_setup_type type, void *type_data,
 				void *data,
 				void (*cleanup)(struct flow_block_cb *block_cb));
-int nfp_flower_setup_indr_block_cb(enum tc_setup_type type, void *type_data,
-				   void *cb_priv);
+void nfp_flower_setup_indr_tc_release(void *cb_priv);
 
 void
 __nfp_flower_non_repr_priv_get(struct nfp_flower_non_repr_priv *non_repr_priv);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 95c7525..d7340dc 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1619,8 +1619,8 @@ struct nfp_flower_indr_block_cb_priv {
 	return NULL;
 }
 
-int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
-				   void *type_data, void *cb_priv)
+static int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
+					  void *type_data, void *cb_priv)
 {
 	struct nfp_flower_indr_block_cb_priv *priv = cb_priv;
 	struct flow_cls_offload *flower = type_data;
@@ -1637,7 +1637,7 @@ int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
 	}
 }
 
-static void nfp_flower_setup_indr_tc_release(void *cb_priv)
+void nfp_flower_setup_indr_tc_release(void *cb_priv)
 {
 	struct nfp_flower_indr_block_cb_priv *priv = cb_priv;
 
@@ -1680,7 +1680,7 @@ static void nfp_flower_setup_indr_tc_release(void *cb_priv)
 		block_cb = flow_indr_block_cb_alloc(nfp_flower_setup_indr_block_cb,
 						    cb_priv, cb_priv,
 						    nfp_flower_setup_indr_tc_release,
-						    f, netdev, data, cleanup);
+						    f, netdev, data, app, cleanup);
 		if (IS_ERR(block_cb)) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 1961c79..6315324 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -450,6 +450,7 @@ struct flow_block_indr {
 	struct net_device		*dev;
 	enum flow_block_binder_type	binder_type;
 	void				*data;
+	void				*cb_priv;
 	void				(*cleanup)(struct flow_block_cb *block_cb);
 };
 
@@ -472,6 +473,7 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 					       void (*release)(void *cb_priv),
 					       struct flow_block_offload *bo,
 					       struct net_device *dev, void *data,
+					       void *indr_cb_priv,
 					       void (*cleanup)(struct flow_block_cb *block_cb));
 void flow_block_cb_free(struct flow_block_cb *block_cb);
 
@@ -551,7 +553,7 @@ typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
 
 int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv);
 void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
-			      flow_setup_cb_t *setup_cb);
+			      void (*release)(void *cb_priv));
 int flow_indr_dev_setup_offload(struct net_device *dev,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index ee0006c..e244925 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -332,10 +332,12 @@ struct flow_indr_dev {
 static void flow_block_indr_init(struct flow_block_cb *flow_block,
 				 struct flow_block_offload *bo,
 				 struct net_device *dev, void *data,
+				 void *cb_priv,
 				 void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	flow_block->indr.binder_type = bo->binder_type;
 	flow_block->indr.data = data;
+	flow_block->indr.cb_priv = cb_priv;
 	flow_block->indr.dev = dev;
 	flow_block->indr.cleanup = cleanup;
 }
@@ -345,6 +347,7 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 					       void (*release)(void *cb_priv),
 					       struct flow_block_offload *bo,
 					       struct net_device *dev, void *data,
+					       void *indr_cb_priv,
 					       void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	struct flow_block_cb *block_cb;
@@ -353,7 +356,7 @@ struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
 	if (IS_ERR(block_cb))
 		goto out;
 
-	flow_block_indr_init(block_cb, bo, dev, data, cleanup);
+	flow_block_indr_init(block_cb, bo, dev, data, indr_cb_priv, cleanup);
 	list_add(&block_cb->indr.list, &flow_block_indr_list);
 
 out:
@@ -404,14 +407,15 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 }
 EXPORT_SYMBOL(flow_indr_dev_register);
 
-static void __flow_block_indr_cleanup(flow_setup_cb_t *setup_cb, void *cb_priv,
+static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
+				      void *cb_priv,
 				      struct list_head *cleanup_list)
 {
 	struct flow_block_cb *this, *next;
 
 	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
-		if (this->cb == setup_cb &&
-		    this->cb_priv == cb_priv) {
+		if (this->release == release &&
+		    this->indr.cb_priv == cb_priv) {
 			list_move(&this->indr.list, cleanup_list);
 			return;
 		}
@@ -429,7 +433,7 @@ static void flow_block_indr_notify(struct list_head *cleanup_list)
 }
 
 void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
-			      flow_setup_cb_t *setup_cb)
+			      void (*release)(void *cb_priv))
 {
 	struct flow_indr_dev *this, *next, *indr_dev = NULL;
 	LIST_HEAD(cleanup_list);
@@ -450,7 +454,7 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 		return;
 	}
 
-	__flow_block_indr_cleanup(setup_cb, cb_priv, &cleanup_list);
+	__flow_block_indr_cleanup(release, cb_priv, &cleanup_list);
 	mutex_unlock(&flow_indr_block_lock);
 
 	flow_block_indr_notify(&cleanup_list);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 62651e6..5fff1e0 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -950,6 +950,7 @@ static void nf_flow_table_indr_cleanup(struct flow_block_cb *block_cb)
 	nf_flow_table_gc_cleanup(flowtable, dev);
 	down_write(&flowtable->flow_block_lock);
 	list_del(&block_cb->list);
+	list_del(&block_cb->driver_list);
 	flow_block_cb_free(block_cb);
 	up_write(&flowtable->flow_block_lock);
 }
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 185fc82..c7cf1cd 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -296,6 +296,7 @@ static void nft_indr_block_cleanup(struct flow_block_cb *block_cb)
 	nft_flow_block_offload_init(&bo, dev_net(dev), FLOW_BLOCK_UNBIND,
 				    basechain, &extack);
 	mutex_lock(&net->nft.commit_mutex);
+	list_del(&block_cb->driver_list);
 	list_move(&block_cb->list, &bo.cb_list);
 	nft_flow_offload_unbind(&bo, basechain);
 	mutex_unlock(&net->nft.commit_mutex);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index a00a203..f8028d7 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -652,6 +652,7 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
 			       &block->flow_block, tcf_block_shared(block),
 			       &extack);
 	down_write(&block->cb_lock);
+	list_del(&block_cb->driver_list);
 	list_move(&block_cb->list, &bo.cb_list);
 	up_write(&block->cb_lock);
 	rtnl_lock();
-- 
1.8.3.1

