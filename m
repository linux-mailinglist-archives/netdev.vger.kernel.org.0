Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE723935AD
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbhE0S6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235958AbhE0S6J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:58:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6F4D61355;
        Thu, 27 May 2021 18:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141796;
        bh=5kmzNoRGcUFU3OxAJV7o22SZAGG+4zXHBkBKCTZuFDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngiOlOl9ojwGVVaMxmNqk0iqsscFTSSLeX7DNOeYRWsX4SYxgYqS1Ipn/e70L7kQC
         QnEaJZ/FZ+yPve5xmy+ddgzmCFMgPPFXQuYza5DCRPGt0HXQd3w9jm4dLqz9WA1wAw
         qkXsZRo52vgcGhwJ2w9YEjoQu8aFEmw8ODR2BNJHQJjn6WdEvUVW/FZoPdR/OsXIDM
         zCQJD6H+v5K7quPUXdyOiKYlK2DSf/LE9EMmAfkgAhqqJintmR/1OxNrlNzn1JpMFJ
         EBwz9crYXdw6hQpDsRr2HROBPCdM9GdseX6Mxtsmx0QWrOk54kPPg/3w+Ryeuwe+Ir
         dtdNL/ka/4IMg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 03/15] net/mlx5e: TC: Use bit counts for register mapping
Date:   Thu, 27 May 2021 11:56:12 -0700
Message-Id: <20210527185624.694304-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527185624.694304-1-saeed@kernel.org>
References: <20210527185624.694304-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

To prepare for next patch where we will use a non-byte
aligned mapping, change all byte counts in register
mapping to bits.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  6 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    | 23 +++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 86 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  6 +-
 .../mellanox/mlx5/core/lib/fs_chains.c        |  5 +-
 5 files changed, 77 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index e3b0fd78184e..91e7a01e32be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -23,7 +23,7 @@
 #include "en_tc.h"
 #include "en_rep.h"
 
-#define MLX5_CT_ZONE_BITS (mlx5e_tc_attr_to_reg_mappings[ZONE_TO_REG].mlen * 8)
+#define MLX5_CT_ZONE_BITS (mlx5e_tc_attr_to_reg_mappings[ZONE_TO_REG].mlen)
 #define MLX5_CT_ZONE_MASK GENMASK(MLX5_CT_ZONE_BITS - 1, 0)
 #define MLX5_CT_STATE_ESTABLISHED_BIT BIT(1)
 #define MLX5_CT_STATE_TRK_BIT BIT(2)
@@ -32,11 +32,11 @@
 #define MLX5_CT_STATE_RELATED_BIT BIT(5)
 #define MLX5_CT_STATE_INVALID_BIT BIT(6)
 
-#define MLX5_FTE_ID_BITS (mlx5e_tc_attr_to_reg_mappings[FTEID_TO_REG].mlen * 8)
+#define MLX5_FTE_ID_BITS (mlx5e_tc_attr_to_reg_mappings[FTEID_TO_REG].mlen)
 #define MLX5_FTE_ID_MAX GENMASK(MLX5_FTE_ID_BITS - 1, 0)
 #define MLX5_FTE_ID_MASK MLX5_FTE_ID_MAX
 
-#define MLX5_CT_LABELS_BITS (mlx5e_tc_attr_to_reg_mappings[LABELS_TO_REG].mlen * 8)
+#define MLX5_CT_LABELS_BITS (mlx5e_tc_attr_to_reg_mappings[LABELS_TO_REG].mlen)
 #define MLX5_CT_LABELS_MASK GENMASK(MLX5_CT_LABELS_BITS - 1, 0)
 
 #define ct_dbg(fmt, args...)\
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 69e618d17071..644cf1641cde 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -33,15 +33,15 @@ struct mlx5_ct_attr {
 #define zone_to_reg_ct {\
 	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_2,\
 	.moffset = 0,\
-	.mlen = 2,\
+	.mlen = 16,\
 	.soffset = MLX5_BYTE_OFF(fte_match_param,\
-				 misc_parameters_2.metadata_reg_c_2) + 2,\
+				 misc_parameters_2.metadata_reg_c_2),\
 }
 
 #define ctstate_to_reg_ct {\
 	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_2,\
-	.moffset = 2,\
-	.mlen = 2,\
+	.moffset = 16,\
+	.mlen = 16,\
 	.soffset = MLX5_BYTE_OFF(fte_match_param,\
 				 misc_parameters_2.metadata_reg_c_2),\
 }
@@ -49,7 +49,7 @@ struct mlx5_ct_attr {
 #define mark_to_reg_ct {\
 	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_3,\
 	.moffset = 0,\
-	.mlen = 4,\
+	.mlen = 32,\
 	.soffset = MLX5_BYTE_OFF(fte_match_param,\
 				 misc_parameters_2.metadata_reg_c_3),\
 }
@@ -57,7 +57,7 @@ struct mlx5_ct_attr {
 #define labels_to_reg_ct {\
 	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_4,\
 	.moffset = 0,\
-	.mlen = 4,\
+	.mlen = 32,\
 	.soffset = MLX5_BYTE_OFF(fte_match_param,\
 				 misc_parameters_2.metadata_reg_c_4),\
 }
@@ -65,7 +65,7 @@ struct mlx5_ct_attr {
 #define fteid_to_reg_ct {\
 	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_5,\
 	.moffset = 0,\
-	.mlen = 4,\
+	.mlen = 32,\
 	.soffset = MLX5_BYTE_OFF(fte_match_param,\
 				 misc_parameters_2.metadata_reg_c_5),\
 }
@@ -73,20 +73,19 @@ struct mlx5_ct_attr {
 #define zone_restore_to_reg_ct {\
 	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_1,\
 	.moffset = 0,\
-	.mlen = (ESW_ZONE_ID_BITS / 8),\
+	.mlen = ESW_ZONE_ID_BITS,\
 	.soffset = MLX5_BYTE_OFF(fte_match_param,\
-				 misc_parameters_2.metadata_reg_c_1) + 3,\
+				 misc_parameters_2.metadata_reg_c_1),\
 }
 
 #define nic_zone_restore_to_reg_ct {\
 	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_B,\
-	.moffset = 2,\
-	.mlen = (ESW_ZONE_ID_BITS / 8),\
+	.moffset = 16,\
+	.mlen = ESW_ZONE_ID_BITS,\
 }
 
 #define REG_MAPPING_MLEN(reg) (mlx5e_tc_attr_to_reg_mappings[reg].mlen)
 #define REG_MAPPING_MOFFSET(reg) (mlx5e_tc_attr_to_reg_mappings[reg].moffset)
-#define REG_MAPPING_SHIFT(reg) (REG_MAPPING_MOFFSET(reg) * 8)
 
 #if IS_ENABLED(CONFIG_MLX5_TC_CT)
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 47a9c49b25fd..7d5c9b69ea37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -83,17 +83,17 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[CHAIN_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_0,
 		.moffset = 0,
-		.mlen = 2,
+		.mlen = 16,
 	},
 	[VPORT_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_0,
-		.moffset = 2,
-		.mlen = 2,
+		.moffset = 16,
+		.mlen = 16,
 	},
 	[TUNNEL_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_1,
-		.moffset = 1,
-		.mlen = ((ESW_TUN_OPTS_BITS + ESW_TUN_ID_BITS) / 8),
+		.moffset = 8,
+		.mlen = ESW_TUN_OPTS_BITS + ESW_TUN_ID_BITS,
 		.soffset = MLX5_BYTE_OFF(fte_match_param,
 					 misc_parameters_2.metadata_reg_c_1),
 	},
@@ -110,7 +110,7 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[NIC_CHAIN_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_B,
 		.moffset = 0,
-		.mlen = 2,
+		.mlen = 16,
 	},
 	[NIC_ZONE_RESTORE_TO_REG] = nic_zone_restore_to_reg_ct,
 };
@@ -128,23 +128,46 @@ static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow);
 void
 mlx5e_tc_match_to_reg_match(struct mlx5_flow_spec *spec,
 			    enum mlx5e_tc_attr_to_reg type,
-			    u32 data,
+			    u32 val,
 			    u32 mask)
 {
+	void *headers_c = spec->match_criteria, *headers_v = spec->match_value, *fmask, *fval;
 	int soffset = mlx5e_tc_attr_to_reg_mappings[type].soffset;
+	int moffset = mlx5e_tc_attr_to_reg_mappings[type].moffset;
 	int match_len = mlx5e_tc_attr_to_reg_mappings[type].mlen;
-	void *headers_c = spec->match_criteria;
-	void *headers_v = spec->match_value;
-	void *fmask, *fval;
+	u32 max_mask = GENMASK(match_len - 1, 0);
+	__be32 curr_mask_be, curr_val_be;
+	u32 curr_mask, curr_val;
 
 	fmask = headers_c + soffset;
 	fval = headers_v + soffset;
 
-	mask = (__force u32)(cpu_to_be32(mask)) >> (32 - (match_len * 8));
-	data = (__force u32)(cpu_to_be32(data)) >> (32 - (match_len * 8));
+	memcpy(&curr_mask_be, fmask, 4);
+	memcpy(&curr_val_be, fval, 4);
+
+	curr_mask = be32_to_cpu(curr_mask_be);
+	curr_val = be32_to_cpu(curr_val_be);
+
+	//move to correct offset
+	WARN_ON(mask > max_mask);
+	mask <<= moffset;
+	val <<= moffset;
+	max_mask <<= moffset;
+
+	//zero val and mask
+	curr_mask &= ~max_mask;
+	curr_val &= ~max_mask;
 
-	memcpy(fmask, &mask, match_len);
-	memcpy(fval, &data, match_len);
+	//add current to mask
+	curr_mask |= mask;
+	curr_val |= val;
+
+	//back to be32 and write
+	curr_mask_be = cpu_to_be32(curr_mask);
+	curr_val_be = cpu_to_be32(curr_val);
+
+	memcpy(fmask, &curr_mask_be, 4);
+	memcpy(fval, &curr_val_be, 4);
 
 	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
 }
@@ -152,23 +175,28 @@ mlx5e_tc_match_to_reg_match(struct mlx5_flow_spec *spec,
 void
 mlx5e_tc_match_to_reg_get_match(struct mlx5_flow_spec *spec,
 				enum mlx5e_tc_attr_to_reg type,
-				u32 *data,
+				u32 *val,
 				u32 *mask)
 {
+	void *headers_c = spec->match_criteria, *headers_v = spec->match_value, *fmask, *fval;
 	int soffset = mlx5e_tc_attr_to_reg_mappings[type].soffset;
+	int moffset = mlx5e_tc_attr_to_reg_mappings[type].moffset;
 	int match_len = mlx5e_tc_attr_to_reg_mappings[type].mlen;
-	void *headers_c = spec->match_criteria;
-	void *headers_v = spec->match_value;
-	void *fmask, *fval;
+	u32 max_mask = GENMASK(match_len - 1, 0);
+	__be32 curr_mask_be, curr_val_be;
+	u32 curr_mask, curr_val;
 
 	fmask = headers_c + soffset;
 	fval = headers_v + soffset;
 
-	memcpy(mask, fmask, match_len);
-	memcpy(data, fval, match_len);
+	memcpy(&curr_mask_be, fmask, 4);
+	memcpy(&curr_val_be, fval, 4);
+
+	curr_mask = be32_to_cpu(curr_mask_be);
+	curr_val = be32_to_cpu(curr_val_be);
 
-	*mask = be32_to_cpu((__force __be32)(*mask << (32 - (match_len * 8))));
-	*data = be32_to_cpu((__force __be32)(*data << (32 - (match_len * 8))));
+	*mask = (curr_mask >> moffset) & max_mask;
+	*val = (curr_val >> moffset) & max_mask;
 }
 
 int
@@ -192,13 +220,13 @@ mlx5e_tc_match_to_reg_set_and_get_id(struct mlx5_core_dev *mdev,
 		 (mod_hdr_acts->num_actions * MLX5_MH_ACT_SZ);
 
 	/* Firmware has 5bit length field and 0 means 32bits */
-	if (mlen == 4)
+	if (mlen == 32)
 		mlen = 0;
 
 	MLX5_SET(set_action_in, modact, action_type, MLX5_ACTION_TYPE_SET);
 	MLX5_SET(set_action_in, modact, field, mfield);
-	MLX5_SET(set_action_in, modact, offset, moffset * 8);
-	MLX5_SET(set_action_in, modact, length, mlen * 8);
+	MLX5_SET(set_action_in, modact, offset, moffset);
+	MLX5_SET(set_action_in, modact, length, mlen);
 	MLX5_SET(set_action_in, modact, data, data);
 	err = mod_hdr_acts->num_actions;
 	mod_hdr_acts->num_actions++;
@@ -296,13 +324,13 @@ void mlx5e_tc_match_to_reg_mod_hdr_change(struct mlx5_core_dev *mdev,
 	modact = mod_hdr_acts->actions + (act_id * MLX5_MH_ACT_SZ);
 
 	/* Firmware has 5bit length field and 0 means 32bits */
-	if (mlen == 4)
+	if (mlen == 32)
 		mlen = 0;
 
 	MLX5_SET(set_action_in, modact, action_type, MLX5_ACTION_TYPE_SET);
 	MLX5_SET(set_action_in, modact, field, mfield);
-	MLX5_SET(set_action_in, modact, offset, moffset * 8);
-	MLX5_SET(set_action_in, modact, length, mlen * 8);
+	MLX5_SET(set_action_in, modact, offset, moffset);
+	MLX5_SET(set_action_in, modact, length, mlen);
 	MLX5_SET(set_action_in, modact, data, data);
 }
 
@@ -5080,7 +5108,7 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 
 		tc_skb_ext->chain = chain;
 
-		zone_restore_id = (reg_b >> REG_MAPPING_SHIFT(NIC_ZONE_RESTORE_TO_REG)) &
+		zone_restore_id = (reg_b >> REG_MAPPING_MOFFSET(NIC_ZONE_RESTORE_TO_REG)) &
 			ESW_ZONE_ID_MASK;
 
 		if (!mlx5e_tc_ct_restore_flow(tc->ct, skb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 25c091795bcd..3534d14d7d5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -198,10 +198,10 @@ enum mlx5e_tc_attr_to_reg {
 
 struct mlx5e_tc_attr_to_reg_mapping {
 	int mfield; /* rewrite field */
-	int moffset; /* offset of mfield */
-	int mlen; /* bytes to rewrite/match */
+	int moffset; /* bit offset of mfield */
+	int mlen; /* bits to rewrite/match */
 
-	int soffset; /* offset of spec for match */
+	int soffset; /* byte offset of spec for match */
 };
 
 extern struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 00ef10a1a9f8..4c60c540bf9d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -336,9 +336,10 @@ create_chain_restore(struct fs_chain *chain)
 	MLX5_SET(set_action_in, modact, field,
 		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].mfield);
 	MLX5_SET(set_action_in, modact, offset,
-		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].moffset * 8);
+		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].moffset);
 	MLX5_SET(set_action_in, modact, length,
-		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].mlen * 8);
+		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].mlen == 32 ?
+		 0 : mlx5e_tc_attr_to_reg_mappings[chain_to_reg].mlen);
 	MLX5_SET(set_action_in, modact, data, chain->id);
 	mod_hdr = mlx5_modify_header_alloc(chains->dev, chains->ns,
 					   1, modact);
-- 
2.31.1

