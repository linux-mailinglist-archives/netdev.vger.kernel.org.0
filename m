Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417AF3562BC
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348574AbhDGEzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:55:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344888AbhDGEyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B9D2613D0;
        Wed,  7 Apr 2021 04:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771277;
        bh=/7CHAO42ecn+dM87fuXTYuQOwRTHb4NBXcW3sFkLw5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJKuBA9HJ1Ss4wwM5OoaVZ+lJBQEvKFOdARpwrazdLIAYVNP3jMtUG2FuhTIY8cLd
         urNYeu34xCBnCLG0zpUzOlCbcQRmbMFN58ZYNOQtSRn3aYSC1vPmJ8LRfiLV4n3gEq
         E5DxtAtPekEQs5bKjbvuWkPVGoUe29/ST/kOK9dW/zbBOejUjDlOLgLHjTz1KNw1fr
         skkllonAToqA2PoHQMW1a0HOeeaOgeJo5SXLLRyFTzXmhQsMJgFPIjN21fdvGdFR5D
         0VHqtUKEFrUBIpbbNDTrLqWbMbR/TjRcCwsEkDy4i6aWEj1MvTLelUODef4T3lMNHB
         JMLvCm0wx9Lgw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/13] net/mlx5: Map register values to restore objects
Date:   Tue,  6 Apr 2021 21:54:13 -0700
Message-Id: <20210407045421.148987-6-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407045421.148987-1-saeed@kernel.org>
References: <20210407045421.148987-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Currently reg_c0 lower 16 bits and reg_b are used to store the chain
id that missed in FDB and NIC tables accordingly. However, the
registers' values may index a restore object, rather than a single u32
value. Different object types can be used to restore mutually exclusive
contexts such as chain id and sample group id.

Use the mapping object to associate an index with a restore object
as a prestep for supporting additional restore types.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 38 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  9 ++++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 13 ++++++-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 14 ++-----
 .../mellanox/mlx5/core/lib/fs_chains.c        | 20 ++++++----
 .../mellanox/mlx5/core/lib/fs_chains.h        |  3 +-
 include/linux/mlx5/eswitch.h                  |  9 ++---
 7 files changed, 63 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 11a44d30adc7..dde83cba85c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -618,9 +618,10 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 			     struct mlx5e_tc_update_priv *tc_priv)
 {
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	u32 chain = 0, reg_c0, reg_c1, tunnel_id, zone_restore_id;
+	u32 reg_c0, reg_c1, tunnel_id, zone_restore_id;
 	struct mlx5_rep_uplink_priv *uplink_priv;
 	struct mlx5e_rep_priv *uplink_rpriv;
+	struct mlx5_mapped_obj mapped_obj;
 	struct tc_skb_ext *tc_skb_ext;
 	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
@@ -640,30 +641,35 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 	priv = netdev_priv(skb->dev);
 	esw = priv->mdev->priv.eswitch;
 
-	err = mlx5_get_chain_for_tag(esw_chains(esw), reg_c0, &chain);
+	err = mlx5_get_mapped_object(esw_chains(esw), reg_c0, &mapped_obj);
 	if (err) {
 		netdev_dbg(priv->netdev,
-			   "Couldn't find chain for chain tag: %d, err: %d\n",
+			   "Couldn't find mapped object for reg_c0: %d, err: %d\n",
 			   reg_c0, err);
 		return false;
 	}
 
-	if (chain) {
-		tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
-		if (!tc_skb_ext) {
-			WARN_ON(1);
-			return false;
-		}
+	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
+		if (mapped_obj.chain) {
+			tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
+			if (!tc_skb_ext) {
+				WARN_ON(1);
+				return false;
+			}
 
-		tc_skb_ext->chain = chain;
+			tc_skb_ext->chain = mapped_obj.chain;
 
-		zone_restore_id = reg_c1 & ESW_ZONE_ID_MASK;
+			zone_restore_id = reg_c1 & ESW_ZONE_ID_MASK;
 
-		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-		uplink_priv = &uplink_rpriv->uplink_priv;
-		if (!mlx5e_tc_ct_restore_flow(uplink_priv->ct_priv, skb,
-					      zone_restore_id))
-			return false;
+			uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+			uplink_priv = &uplink_rpriv->uplink_priv;
+			if (!mlx5e_tc_ct_restore_flow(uplink_priv->ct_priv, skb,
+						      zone_restore_id))
+				return false;
+		}
+	} else {
+		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
+		return false;
 	}
 
 	tunnel_id = reg_c1 >> ESW_TUN_OFFSET;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index bb1e0d442b5c..9b5607ddb9a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4973,6 +4973,7 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 	u32 chain = 0, chain_tag, reg_b, zone_restore_id;
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
+	struct mlx5_mapped_obj mapped_obj;
 	struct tc_skb_ext *tc_skb_ext;
 	int err;
 
@@ -4980,7 +4981,7 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 
 	chain_tag = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
 
-	err = mlx5_get_chain_for_tag(nic_chains(priv), chain_tag, &chain);
+	err = mlx5_get_mapped_object(nic_chains(priv), chain_tag, &mapped_obj);
 	if (err) {
 		netdev_dbg(priv->netdev,
 			   "Couldn't find chain for chain tag: %d, err: %d\n",
@@ -4988,7 +4989,8 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 		return false;
 	}
 
-	if (chain) {
+	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
+		chain = mapped_obj.chain;
 		tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
 		if (WARN_ON(!tc_skb_ext))
 			return false;
@@ -5001,6 +5003,9 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 		if (!mlx5e_tc_ct_restore_flow(tc->ct, skb,
 					      zone_restore_id))
 			return false;
+	} else {
+		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
+		return false;
 	}
 #endif /* CONFIG_NET_TC_SKB_EXT */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index e0415676821a..c5b35e7f8aed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -47,6 +47,17 @@
 #include "sf/sf.h"
 #include "en/tc_ct.h"
 
+enum mlx5_mapped_obj_type {
+	MLX5_MAPPED_OBJ_CHAIN,
+};
+
+struct mlx5_mapped_obj {
+	enum mlx5_mapped_obj_type type;
+	union {
+		u32 chain;
+	};
+};
+
 #ifdef CONFIG_MLX5_ESWITCH
 
 #define ESW_OFFLOADS_DEFAULT_NUM_GROUPS 15
@@ -733,8 +744,6 @@ mlx5_esw_vporttbl_put(struct mlx5_eswitch *esw, struct mlx5_vport_tbl_attr *attr
 
 struct mlx5_flow_handle *
 esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag);
-u32
-esw_get_max_restore_tag(struct mlx5_eswitch *esw);
 
 int esw_offloads_load_rep(struct mlx5_eswitch *esw, u16 vport_num);
 void esw_offloads_unload_rep(struct mlx5_eswitch *esw, u16 vport_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8ac4b60ea225..117d9fa93ff5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1286,7 +1286,7 @@ esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
 			    misc_parameters_2);
 	MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
-		 ESW_CHAIN_TAG_METADATA_MASK);
+		 ESW_REG_C0_USER_DATA_METADATA_MASK);
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 			    misc_parameters_2);
 	MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0, tag);
@@ -1312,12 +1312,6 @@ esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
 	return flow_rule;
 }
 
-u32
-esw_get_max_restore_tag(struct mlx5_eswitch *esw)
-{
-	return ESW_CHAIN_TAG_METADATA_MASK;
-}
-
 #define MAX_PF_SQ 256
 #define MAX_SQ_NVPORTS 32
 
@@ -1434,7 +1428,7 @@ esw_chains_create(struct mlx5_eswitch *esw, struct mlx5_flow_table *miss_fdb)
 	attr.max_ft_sz = fdb_max;
 	attr.max_grp_num = esw->params.large_group_num;
 	attr.default_ft = miss_fdb;
-	attr.max_restore_tag = esw_get_max_restore_tag(esw);
+	attr.max_restore_tag = ESW_REG_C0_USER_DATA_METADATA_MASK;
 
 	chains = mlx5_chains_create(dev, &attr);
 	if (IS_ERR(chains)) {
@@ -1928,7 +1922,7 @@ static int esw_create_restore_table(struct mlx5_eswitch *esw)
 		goto out_free;
 	}
 
-	ft_attr.max_fte = 1 << ESW_CHAIN_TAG_METADATA_BITS;
+	ft_attr.max_fte = 1 << ESW_REG_C0_USER_DATA_METADATA_BITS;
 	ft = mlx5_create_flow_table(ns, &ft_attr);
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
@@ -1943,7 +1937,7 @@ static int esw_create_restore_table(struct mlx5_eswitch *esw)
 			    misc_parameters_2);
 
 	MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
-		 ESW_CHAIN_TAG_METADATA_MASK);
+		 ESW_REG_C0_USER_DATA_METADATA_MASK);
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
 	MLX5_SET(create_flow_group_in, flow_group_in, end_flow_index,
 		 ft_attr.max_fte - 1);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 381325b4a863..00ff809dcfe8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -832,8 +832,7 @@ mlx5_chains_init(struct mlx5_core_dev *dev, struct mlx5_chains_attr *attr)
 	if (err)
 		goto init_prios_ht_err;
 
-	mapping = mapping_create(sizeof(u32), attr->max_restore_tag,
-				 true);
+	mapping = mapping_create(sizeof(struct mlx5_mapped_obj), attr->max_restore_tag, true);
 	if (IS_ERR(mapping)) {
 		err = PTR_ERR(mapping);
 		goto mapping_err;
@@ -884,21 +883,28 @@ int
 mlx5_chains_get_chain_mapping(struct mlx5_fs_chains *chains, u32 chain,
 			      u32 *chain_mapping)
 {
-	return mapping_add(chains_mapping(chains), &chain, chain_mapping);
+	struct mapping_ctx *ctx = chains->chains_mapping;
+	struct mlx5_mapped_obj mapped_obj = {};
+
+	mapped_obj.type = MLX5_MAPPED_OBJ_CHAIN;
+	mapped_obj.chain = chain;
+	return mapping_add(ctx, &mapped_obj, chain_mapping);
 }
 
 int
 mlx5_chains_put_chain_mapping(struct mlx5_fs_chains *chains, u32 chain_mapping)
 {
-	return mapping_remove(chains_mapping(chains), chain_mapping);
+	struct mapping_ctx *ctx = chains->chains_mapping;
+
+	return mapping_remove(ctx, chain_mapping);
 }
 
-int mlx5_get_chain_for_tag(struct mlx5_fs_chains *chains, u32 tag,
-			   u32 *chain)
+int
+mlx5_get_mapped_object(struct mlx5_fs_chains *chains, u32 tag, struct mlx5_mapped_obj *obj)
 {
 	int err;
 
-	err = mapping_find(chains_mapping(chains), tag, chain);
+	err = mapping_find(chains->chains_mapping, tag, obj);
 	if (err) {
 		mlx5_core_warn(chains->dev, "Can't find chain for tag: %d\n", tag);
 		return -ENOENT;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
index 6d5be31b05dd..75a3bba12a78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
@@ -7,6 +7,7 @@
 #include <linux/mlx5/fs.h>
 
 struct mlx5_fs_chains;
+struct mlx5_mapped_obj;
 
 enum mlx5_chains_flags {
 	MLX5_CHAINS_AND_PRIOS_SUPPORTED = BIT(0),
@@ -64,7 +65,7 @@ mlx5_chains_create(struct mlx5_core_dev *dev, struct mlx5_chains_attr *attr);
 void mlx5_chains_destroy(struct mlx5_fs_chains *chains);
 
 int
-mlx5_get_chain_for_tag(struct mlx5_fs_chains *chains, u32 tag, u32 *chain);
+mlx5_get_mapped_object(struct mlx5_fs_chains *chains, u32 tag, struct mlx5_mapped_obj *obj);
 
 void
 mlx5_chains_set_end_ft(struct mlx5_fs_chains *chains,
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 994c2c8cb4fd..125ae482383b 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -74,20 +74,19 @@ bool mlx5_eswitch_reg_c1_loopback_enabled(const struct mlx5_eswitch *esw);
 bool mlx5_eswitch_vport_match_metadata_enabled(const struct mlx5_eswitch *esw);
 
 /* Reg C0 usage:
- * Reg C0 = < ESW_PFNUM_BITS(4) | ESW_VPORT BITS(12) | ESW_CHAIN_TAG(16) >
+ * Reg C0 = < ESW_PFNUM_BITS(4) | ESW_VPORT BITS(12) | ESW_REG_C0_OBJ(16) >
  *
  * Highest 4 bits of the reg c0 is the PF_NUM (range 0-15), 12 bits of
  * unique non-zero vport id (range 1-4095). The rest (lowest 16 bits) is left
- * for tc chain tag restoration.
+ * for user data objects managed by a common mapping context.
  * PFNUM + VPORT comprise the SOURCE_PORT matching.
  */
 #define ESW_VPORT_BITS 12
 #define ESW_PFNUM_BITS 4
 #define ESW_SOURCE_PORT_METADATA_BITS (ESW_PFNUM_BITS + ESW_VPORT_BITS)
 #define ESW_SOURCE_PORT_METADATA_OFFSET (32 - ESW_SOURCE_PORT_METADATA_BITS)
-#define ESW_CHAIN_TAG_METADATA_BITS (32 - ESW_SOURCE_PORT_METADATA_BITS)
-#define ESW_CHAIN_TAG_METADATA_MASK GENMASK(ESW_CHAIN_TAG_METADATA_BITS - 1,\
-					    0)
+#define ESW_REG_C0_USER_DATA_METADATA_BITS (32 - ESW_SOURCE_PORT_METADATA_BITS)
+#define ESW_REG_C0_USER_DATA_METADATA_MASK GENMASK(ESW_REG_C0_USER_DATA_METADATA_BITS - 1, 0)
 
 static inline u32 mlx5_eswitch_get_vport_metadata_mask(void)
 {
-- 
2.30.2

