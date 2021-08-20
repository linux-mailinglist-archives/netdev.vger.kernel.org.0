Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E956D3F261E
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbhHTE4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233502AbhHTE4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FA4A6103C;
        Fri, 20 Aug 2021 04:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435328;
        bh=U5G/1Htl7AIf+IMmyvwvhNL44l0plBLdaF8TSQ4G8bM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qLVmt0y5Mkq/ieyY376nju88hxlalyV2Tbt3gcCW5KNoRdgGVY92EXgHK9UyA5Mtl
         bOvlRb8Ss7WSakoPYzMvcCOqel644vS+fwCgjD/sjvIKhzlrrfh1KoqPTkxlMCRP5y
         3DD37Ay+BV3K82wzrYjT5gI/GipmZdaR/PA0UN9j0LHq77hZp70gY1/S3K9P53KGZS
         Zviri7cRMQMV/HcEctkzo4L0/c8Y6O68vESdB+ZN/YytylmyWCUpDqSxLw7556lCrv
         jygQgj3Jk3Gqfz1Z7X8wJEuGClX8paomVLX9axiRFY9hyXnLZ7kQRRMR8JxMK+8YA3
         Ot42CL4j0c+ZQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: TC, Restore tunnel info for sample offload
Date:   Thu, 19 Aug 2021 21:55:08 -0700
Message-Id: <20210820045515.265297-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820045515.265297-1-saeed@kernel.org>
References: <20210820045515.265297-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Currently the sample offload actions send the encapsulated packet
to software. sFlow expects tunneled packets to be decapsulated while
having the tunnel properties on the skb metadata fields.

Reuse the functions used by connection tracking to map the outer
header properties to a unique id. The next patch  will use that id
to restore the tunnel information of decapsulated packets onto the
skb.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 31 +++++++++++++------
 .../mellanox/mlx5/core/en/tc/sample.c         |  4 ++-
 .../mellanox/mlx5/core/en/tc/sample.h         |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 12 +++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 5 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 756b85349a95..51a4d80f7fa3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -608,8 +608,8 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 	return true;
 }
 
-static bool mlx5e_restore_skb(struct sk_buff *skb, u32 chain, u32 reg_c1,
-			      struct mlx5e_tc_update_priv *tc_priv)
+static bool mlx5e_restore_skb_chain(struct sk_buff *skb, u32 chain, u32 reg_c1,
+				    struct mlx5e_tc_update_priv *tc_priv)
 {
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
 	u32 tunnel_id = (reg_c1 >> ESW_TUN_OFFSET) & TUNNEL_ID_MASK;
@@ -641,6 +641,21 @@ static bool mlx5e_restore_skb(struct sk_buff *skb, u32 chain, u32 reg_c1,
 	return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
 }
 
+static void mlx5e_restore_skb_sample(struct mlx5e_priv *priv, struct sk_buff *skb,
+				     struct mlx5_mapped_obj *mapped_obj,
+				     struct mlx5e_tc_update_priv *tc_priv)
+{
+	if (!mlx5e_restore_tunnel(priv, skb, tc_priv, mapped_obj->sample.tunnel_id)) {
+		netdev_dbg(priv->netdev,
+			   "Failed to restore tunnel info for sampled packet\n");
+		return;
+	}
+#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
+	mlx5e_tc_sample_skb(skb, mapped_obj);
+#endif /* CONFIG_MLX5_TC_SAMPLE */
+	mlx5_rep_tc_post_napi_receive(tc_priv);
+}
+
 bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 			     struct sk_buff *skb,
 			     struct mlx5e_tc_update_priv *tc_priv)
@@ -648,7 +663,7 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 	struct mlx5_mapped_obj mapped_obj;
 	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
-	u32 reg_c0, reg_c1;
+	u32 reg_c0;
 	int err;
 
 	reg_c0 = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
@@ -660,8 +675,6 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 	 */
 	skb->mark = 0;
 
-	reg_c1 = be32_to_cpu(cqe->ft_metadata);
-
 	priv = netdev_priv(skb->dev);
 	esw = priv->mdev->priv.eswitch;
 	err = mapping_find(esw->offloads.reg_c0_obj_pool, reg_c0, &mapped_obj);
@@ -673,12 +686,12 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 	}
 
 	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
-		return mlx5e_restore_skb(skb, mapped_obj.chain, reg_c1, tc_priv);
-#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
+		u32 reg_c1 = be32_to_cpu(cqe->ft_metadata);
+
+		return mlx5e_restore_skb_chain(skb, mapped_obj.chain, reg_c1, tc_priv);
 	} else if (mapped_obj.type == MLX5_MAPPED_OBJ_SAMPLE) {
-		mlx5e_tc_sample_skb(skb, &mapped_obj);
+		mlx5e_restore_skb_sample(priv, skb, &mapped_obj, tc_priv);
 		return false;
-#endif /* CONFIG_MLX5_TC_SAMPLE */
 	} else {
 		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
 		return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index a6e19946e80f..739292d52aca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -364,7 +364,8 @@ void mlx5e_tc_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj
 struct mlx5_flow_handle *
 mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 			struct mlx5_flow_spec *spec,
-			struct mlx5_flow_attr *attr)
+			struct mlx5_flow_attr *attr,
+			u32 tunnel_id)
 {
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	struct mlx5_vport_tbl_attr per_vport_tbl_attr;
@@ -438,6 +439,7 @@ mlx5e_tc_sample_offload(struct mlx5e_tc_psample *tc_psample,
 	restore_obj.sample.group_id = sample_attr->group_num;
 	restore_obj.sample.rate = sample_attr->rate;
 	restore_obj.sample.trunc_size = sample_attr->trunc_size;
+	restore_obj.sample.tunnel_id = tunnel_id;
 	err = mapping_add(esw->offloads.reg_c0_obj_pool, &restore_obj, &obj_id);
 	if (err)
 		goto err_obj_id;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
index c8aa42ee0075..1bcf4d399ccd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.h
@@ -24,7 +24,8 @@ void mlx5e_tc_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj
 struct mlx5_flow_handle *
 mlx5e_tc_sample_offload(struct mlx5e_tc_psample *sample_priv,
 			struct mlx5_flow_spec *spec,
-			struct mlx5_flow_attr *attr);
+			struct mlx5_flow_attr *attr,
+			u32 tunnel_id);
 
 void
 mlx5e_tc_sample_unoffload(struct mlx5e_tc_psample *sample_priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 8049c4ca8989..38cf5bdfbd4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1148,7 +1148,8 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 					       mod_hdr_acts);
 #if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
 	} else if (flow_flag_test(flow, SAMPLE)) {
-		rule = mlx5e_tc_sample_offload(get_sample_priv(flow->priv), spec, attr);
+		rule = mlx5e_tc_sample_offload(get_sample_priv(flow->priv), spec, attr,
+					       mlx5e_tc_get_flow_tun_id(flow));
 #endif
 	} else {
 		rule = mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
@@ -1625,17 +1626,22 @@ static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 	}
 }
 
-static int flow_has_tc_fwd_action(struct flow_cls_offload *f)
+static bool flow_requires_tunnel_mapping(u32 chain, struct flow_cls_offload *f)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_action *flow_action = &rule->action;
 	const struct flow_action_entry *act;
 	int i;
 
+	if (chain)
+		return false;
+
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_GOTO:
 			return true;
+		case FLOW_ACTION_SAMPLE:
+			return true;
 		default:
 			continue;
 		}
@@ -1876,7 +1882,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 
 	needs_mapping = !!flow->attr->chain;
-	sets_mapping = !flow->attr->chain && flow_has_tc_fwd_action(f);
+	sets_mapping = flow_requires_tunnel_mapping(flow->attr->chain, f);
 	*match_inner = !needs_mapping;
 
 	if ((needs_mapping || sets_mapping) &&
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 3aae1152184b..3be34b24e737 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -61,6 +61,7 @@ struct mlx5_mapped_obj {
 			u32 group_id;
 			u32 rate;
 			u32 trunc_size;
+			u32 tunnel_id;
 		} sample;
 	};
 };
-- 
2.31.1

