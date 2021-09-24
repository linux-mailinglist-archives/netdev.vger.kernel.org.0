Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E78417B4A
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348184AbhIXSuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243927AbhIXSty (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 14:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FC1061278;
        Fri, 24 Sep 2021 18:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509300;
        bh=bPB1r93nYlvDaDXzsVSLXFuhyLgSweqziqj/eqVBsSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxL52sjqiT4RIRC6Ss1TWW2WSQcKViFMrzuQ/KHzTNk+/tXNEnt8G5617ap0PFKEx
         EqlomjyD6dfE1K3OiYhaHwK01Oq+WFjKv7j5rj+fm6PeI10aRlR3oCiSCU5bfZZVrL
         smWJLxEie4SXGEHdzAPOEGkYWQGxNh5yjaHWKa22rhKKAu+pNpdzpdovalOqhqwkp+
         gJgoNQbnbBJGHCgUDFdUk+6IkkZ1VmK/dzKVRGHxx8eiOqCfa1y35xUVkkmot1OB3j
         KrXuT+jYInHmdG3PcwX0c1U7wyhaD80/XFoD89XPpcXcsv7xZnLn6hgzFLjWuYn/Ub
         HCslYe3Hki1og==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/12] net/mlx5e: Use tc sample stubs instead of ifdefs in source file
Date:   Fri, 24 Sep 2021 11:48:04 -0700
Message-Id: <20210924184808.796968-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924184808.796968-1-saeed@kernel.org>
References: <20210924184808.796968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Instead of having sparse ifdefs in source files use a single
ifdef in the tc sample header file and use stubs.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  2 --
 .../mellanox/mlx5/core/en/tc/sample.h         | 27 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 12 ---------
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index de03684528bb..8451940c16ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -647,9 +647,7 @@ static void mlx5e_restore_skb_sample(struct mlx5e_priv *priv, struct sk_buff *sk
 			   "Failed to restore tunnel info for sampled packet\n");
 		return;
 	}
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	mlx5e_tc_sample_skb(skb, mapped_obj);
-#endif /* CONFIG_MLX5_TC_SAMPLE */
 	mlx5_rep_tc_post_napi_receive(tc_priv);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
index db0146df9b30..9ef8a49d7801 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
@@ -19,6 +19,8 @@ struct mlx5e_sample_attr {
 	struct mlx5e_sample_flow *sample_flow;
 };
 
+#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
+
 void mlx5e_tc_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj);
 
 struct mlx5_flow_handle *
@@ -38,4 +40,29 @@ mlx5e_tc_sample_init(struct mlx5_eswitch *esw, struct mlx5e_post_act *post_act);
 void
 mlx5e_tc_sample_cleanup(struct mlx5e_tc_psample *tc_psample);
 
+#else /* CONFIG_MLX5_TC_SAMPLE */
+
+static inline struct mlx5_flow_handle *
+mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
+			struct mlx5_flow_spec *spec,
+			struct mlx5_flow_attr *attr,
+			u32 tunnel_id)
+{ return ERR_PTR(-EOPNOTSUPP); }
+
+static inline void
+mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *tc_psample,
+			  struct mlx5_flow_handle *rule,
+			  struct mlx5_flow_attr *attr) {}
+
+static inline struct mlx5e_tc_psample *
+mlx5e_tc_sample_init(struct mlx5_eswitch *esw, struct mlx5e_post_act *post_act)
+{ return ERR_PTR(-EOPNOTSUPP); }
+
+static inline void
+mlx5e_tc_sample_cleanup(struct mlx5e_tc_psample *tc_psample) {}
+
+static inline void
+mlx5e_tc_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj) {}
+
+#endif /* CONFIG_MLX5_TC_SAMPLE */
 #endif /* __MLX5_EN_TC_SAMPLE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0664ff77c5a1..9ee11715dd6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -246,7 +246,6 @@ get_ct_priv(struct mlx5e_priv *priv)
 	return priv->fs.tc.ct;
 }
 
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 static struct mlx5e_tc_psample *
 get_sample_priv(struct mlx5e_priv *priv)
 {
@@ -263,7 +262,6 @@ get_sample_priv(struct mlx5e_priv *priv)
 
 	return NULL;
 }
-#endif
 
 struct mlx5_flow_handle *
 mlx5_tc_rule_insert(struct mlx5e_priv *priv,
@@ -1146,11 +1144,9 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 		rule = mlx5_tc_ct_flow_offload(get_ct_priv(flow->priv),
 					       flow, spec, attr,
 					       mod_hdr_acts);
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	} else if (flow_flag_test(flow, SAMPLE)) {
 		rule = mlx5e_tc_sample_offload(get_sample_priv(flow->priv), spec, attr,
 					       mlx5e_tc_get_flow_tun_id(flow));
-#endif
 	} else {
 		rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 	}
@@ -1186,12 +1182,10 @@ void mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 		return;
 	}
 
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	if (flow_flag_test(flow, SAMPLE)) {
 		mlx5e_tc_sample_unoffload(get_sample_priv(flow->priv), flow->rule[0], attr);
 		return;
 	}
-#endif
 
 	if (attr->esw_attr->split_count)
 		mlx5_eswitch_del_fwd_rule(esw, flow->rule[1], attr);
@@ -4993,9 +4987,7 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 					       MLX5_FLOW_NAMESPACE_FDB,
 					       uplink_priv->post_act);
 
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	uplink_priv->tc_psample = mlx5e_tc_sample_init(esw, uplink_priv->post_act);
-#endif
 
 	mapping_id = mlx5_query_nic_system_image_guid(esw->dev);
 
@@ -5039,9 +5031,7 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 err_enc_opts_mapping:
 	mapping_destroy(uplink_priv->tunnel_mapping);
 err_tun_mapping:
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	mlx5e_tc_sample_cleanup(uplink_priv->tc_psample);
-#endif
 	mlx5_tc_ct_clean(uplink_priv->ct_priv);
 	netdev_warn(priv->netdev,
 		    "Failed to initialize tc (eswitch), err: %d", err);
@@ -5061,9 +5051,7 @@ void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht)
 	mapping_destroy(uplink_priv->tunnel_enc_opts_mapping);
 	mapping_destroy(uplink_priv->tunnel_mapping);
 
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	mlx5e_tc_sample_cleanup(uplink_priv->tc_psample);
-#endif
 	mlx5_tc_ct_clean(uplink_priv->ct_priv);
 	mlx5e_tc_post_act_destroy(uplink_priv->post_act);
 }
-- 
2.31.1

