Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96D5311B55
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 06:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhBFFIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 00:08:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231281AbhBFFGF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 00:06:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44D9064FDD;
        Sat,  6 Feb 2021 05:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612587766;
        bh=TO1//DvPN3n2X+XhFcGc9ReoiLYk3WSn/YiCcul7EZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iZDT0MeEWXel9fmnJbCaojm9gPcG054V89A+G9a/TFfQHbdlLMkIhknTZeWT/T6y8
         YkIFyeIxPs9LEa7XwhxEAlq66K3VgSTvSGQK6CT1mtT3K9RP+rvu1q0AnnUxTeckhL
         T32E4gIFhzgG13sn9yjBs0oDlKlLuvYJbdU9aNeusFZmcaBfFQRC+Xblm2hHfEe/Q5
         opk16O7tL6ozafu1WD6lHuGLL2e7L6VAXzjBuJ9+Q3ZsRpNVcsMN8HcKNzQ9OwyFgT
         26M10Q3xOFLzMuqHwnZvLjU6FpsZEEr/kwcAEid5Rrl6uc7DwST8jGjcwwKfUZPgVU
         QYz+MgSfDpb8w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 10/17] net/mlx5e: Refactor reg_c1 usage
Date:   Fri,  5 Feb 2021 21:02:33 -0800
Message-Id: <20210206050240.48410-11-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206050240.48410-1-saeed@kernel.org>
References: <20210206050240.48410-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Following patch in series uses reg_c1 in eswitch code. To use reg_c1
helpers in both TC and eswitch code, refactor existing helpers according to
similar use case of reg_c0 and move the functionality into eswitch.h.
Calculate reg mappings length from new defines to ensure that they are
always in sync and only need to be changed in single place.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  4 ++--
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |  6 ++----
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  2 +-
 include/linux/mlx5/eswitch.h                  | 19 +++++++++++++++++++
 5 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 76177f7c5ec2..14bcebd4a0b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -651,7 +651,7 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 
 		tc_skb_ext->chain = chain;
 
-		zone_restore_id = reg_c1 & ZONE_RESTORE_MAX;
+		zone_restore_id = reg_c1 & ESW_ZONE_ID_MASK;
 
 		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
 		uplink_priv = &uplink_rpriv->uplink_priv;
@@ -660,7 +660,7 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 			return false;
 	}
 
-	tunnel_id = reg_c1 >> REG_MAPPING_SHIFT(TUNNEL_TO_REG);
+	tunnel_id = reg_c1 >> ESW_TUN_OFFSET;
 	return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
 #endif /* CONFIG_NET_TC_SKB_EXT */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 6503b614337c..69e618d17071 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -73,7 +73,7 @@ struct mlx5_ct_attr {
 #define zone_restore_to_reg_ct {\
 	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_1,\
 	.moffset = 0,\
-	.mlen = 1,\
+	.mlen = (ESW_ZONE_ID_BITS / 8),\
 	.soffset = MLX5_BYTE_OFF(fte_match_param,\
 				 misc_parameters_2.metadata_reg_c_1) + 3,\
 }
@@ -81,14 +81,12 @@ struct mlx5_ct_attr {
 #define nic_zone_restore_to_reg_ct {\
 	.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_B,\
 	.moffset = 2,\
-	.mlen = 1,\
+	.mlen = (ESW_ZONE_ID_BITS / 8),\
 }
 
 #define REG_MAPPING_MLEN(reg) (mlx5e_tc_attr_to_reg_mappings[reg].mlen)
 #define REG_MAPPING_MOFFSET(reg) (mlx5e_tc_attr_to_reg_mappings[reg].moffset)
 #define REG_MAPPING_SHIFT(reg) (REG_MAPPING_MOFFSET(reg) * 8)
-#define ZONE_RESTORE_BITS (REG_MAPPING_MLEN(ZONE_RESTORE_TO_REG) * 8)
-#define ZONE_RESTORE_MAX GENMASK(ZONE_RESTORE_BITS - 1, 0)
 
 #if IS_ENABLED(CONFIG_MLX5_TC_CT)
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 098f3efa5d4d..90db5a99879d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -173,7 +173,7 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[TUNNEL_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_1,
 		.moffset = 1,
-		.mlen = 3,
+		.mlen = ((ESW_TUN_OPTS_BITS + ESW_TUN_ID_BITS) / 8),
 		.soffset = MLX5_BYTE_OFF(fte_match_param,
 					 misc_parameters_2.metadata_reg_c_1),
 	},
@@ -5649,7 +5649,7 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 		tc_skb_ext->chain = chain;
 
 		zone_restore_id = (reg_b >> REG_MAPPING_SHIFT(NIC_ZONE_RESTORE_TO_REG)) &
-				  ZONE_RESTORE_MAX;
+			ESW_ZONE_ID_MASK;
 
 		if (!mlx5e_tc_ct_restore_flow(tc->ct, skb,
 					      zone_restore_id))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index ee0029192504..1e4ee02bfb1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -302,7 +302,7 @@ static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 
 	reg_b = be32_to_cpu(cqe->ft_metadata);
 
-	if (reg_b >> (MLX5E_TC_TABLE_CHAIN_TAG_BITS + ZONE_RESTORE_BITS))
+	if (reg_b >> (MLX5E_TC_TABLE_CHAIN_TAG_BITS + ESW_ZONE_ID_BITS))
 		return false;
 
 	chain = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 67e341274a22..3b20e84049c1 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -98,6 +98,25 @@ u32 mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
 					      u16 vport_num);
 u32 mlx5_eswitch_get_vport_metadata_for_set(struct mlx5_eswitch *esw,
 					    u16 vport_num);
+
+/* Reg C1 usage:
+ * Reg C1 = < ESW_TUN_ID(12) | ESW_TUN_OPTS(12) | ESW_ZONE_ID(8) >
+ *
+ * Highest 12 bits of reg c1 is the encapsulation tunnel id, next 12 bits is
+ * encapsulation tunnel options, and the lowest 8 bits are used for zone id.
+ *
+ * Zone id is used to restore CT flow when packet misses on chain.
+ *
+ * Tunnel id and options are used together to restore the tunnel info metadata
+ * on miss and to support inner header rewrite by means of implicit chain 0
+ * flows.
+ */
+#define ESW_ZONE_ID_BITS 8
+#define ESW_TUN_OPTS_BITS 12
+#define ESW_TUN_ID_BITS 12
+#define ESW_TUN_OFFSET ESW_ZONE_ID_BITS
+#define ESW_ZONE_ID_MASK GENMASK(ESW_ZONE_ID_BITS - 1, 0)
+
 u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev);
 #else  /* CONFIG_MLX5_ESWITCH */
 
-- 
2.29.2

