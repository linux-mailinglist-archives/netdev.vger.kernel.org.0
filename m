Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5D81FA70E
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 05:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgFPDaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 23:30:55 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:7307 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgFPDax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 23:30:53 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 523FC41EE6;
        Tue, 16 Jun 2020 11:19:42 +0800 (CST)
From:   wenxu@ucloud.cn
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pablo@netfilter.org, vladbu@mellanox.com
Subject: [PATCH net v3 1/4] flow_offload: fix incorrect cleanup for flowtable indirect flow_blocks
Date:   Tue, 16 Jun 2020 11:19:37 +0800
Message-Id: <1592277580-5524-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkxOS0tLS0xKTklOTkxZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdIjULOBw*SB85ITQ0DhMeSkgDTjocVlZVSUNJKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6M0k6Nio6Hzg6TjYNKCM2CTIr
        EyoKFBdVSlVKTkJJSUxMTkNJT05CVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUxOTUs3Bg++
X-HM-Tid: 0a72bb23c2102086kuqy523fc41ee6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The cleanup operation based on the setup callback. But in the mlx5e
driver there are tc and flowtable indrict setup callback and shared
the same release callbacks. So when the representor is removed,
then identify the indirect flow_blocks that need to be removed by  
the release callback.

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

