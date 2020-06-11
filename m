Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38F71F6C86
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 19:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgFKRDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 13:03:40 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:2018 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgFKRDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 13:03:40 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 9010A5C16D8;
        Fri, 12 Jun 2020 00:52:07 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH net v3 1/2] flow_offload: fix incorrect cleanup for indirect flow_blocks
Date:   Fri, 12 Jun 2020 00:52:06 +0800
Message-Id: <1591894327-11915-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPT0JLS0tKSUtKTUlCTVlXWShZQU
        lCN1dZLVlBSVdZDwkaFQgSH1lBWRciNQs4HDkzFiQuSCIeMR4VLyEUOhxWVlVKT0pJKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ok06Ezo4NDg8ATAuFQs5Lw0c
        LBYaFDpVSlVKTkJKQ0JPSElMTU5OVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUxLTko3Bg++
X-HM-Tid: 0a72a44bc12d2087kuqy9010a5c16d8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

If the representor is removed, then identify the indirect
flow_blocks that need to be removed by the release callback.

Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 2 +-
 drivers/net/ethernet/netronome/nfp/flower/main.c    | 2 +-
 drivers/net/ethernet/netronome/nfp/flower/main.h    | 3 +--
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 6 +++---
 include/net/flow_offload.h                          | 2 +-
 net/core/flow_offload.c                             | 9 +++++----
 7 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 0eef4f5..ef7f6bc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -2074,7 +2074,7 @@ void bnxt_shutdown_tc(struct bnxt *bp)
 		return;
 
 	flow_indr_dev_unregister(bnxt_tc_setup_indr_cb, bp,
-				 bnxt_tc_setup_indr_block_cb);
+				 bnxt_tc_setup_indr_rel);
 	rhashtable_destroy(&tc_info->flow_table);
 	rhashtable_destroy(&tc_info->l2_table);
 	rhashtable_destroy(&tc_info->decap_l2_table);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 80713123..a62bcf0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -496,7 +496,7 @@ int mlx5e_rep_tc_netdevice_event_register(struct mlx5e_rep_priv *rpriv)
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
index 6c3dc3b..c983337 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -460,8 +460,7 @@ int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 void nfp_flower_stats_rlim_reply(struct nfp_app *app, struct sk_buff *skb);
 int nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
 				enum tc_setup_type type, void *type_data);
-int nfp_flower_setup_indr_block_cb(enum tc_setup_type type, void *type_data,
-				   void *cb_priv);
+void nfp_flower_setup_indr_tc_release(void *cb_priv);
 
 void
 __nfp_flower_non_repr_priv_get(struct nfp_flower_non_repr_priv *non_repr_priv);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 695d24b9..28de905 100644
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
 
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index f2c8311..3a2d6b4 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -536,7 +536,7 @@ typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
 
 int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv);
 void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
-			      flow_setup_cb_t *setup_cb);
+			      void (*release)(void *cb_priv));
 int flow_indr_dev_setup_offload(struct net_device *dev,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 0cfc35e..b288d2f 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -372,13 +372,14 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
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
+		if (this->release == release &&
 		    this->cb_priv == cb_priv) {
 			list_move(&this->indr.list, cleanup_list);
 			return;
@@ -397,7 +398,7 @@ static void flow_block_indr_notify(struct list_head *cleanup_list)
 }
 
 void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
-			      flow_setup_cb_t *setup_cb)
+			      void (*release)(void *cb_priv))
 {
 	struct flow_indr_dev *this, *next, *indr_dev = NULL;
 	LIST_HEAD(cleanup_list);
@@ -418,7 +419,7 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 		return;
 	}
 
-	__flow_block_indr_cleanup(setup_cb, cb_priv, &cleanup_list);
+	__flow_block_indr_cleanup(release, cb_priv, &cleanup_list);
 	mutex_unlock(&flow_indr_block_lock);
 
 	flow_block_indr_notify(&cleanup_list);
-- 
1.8.3.1

