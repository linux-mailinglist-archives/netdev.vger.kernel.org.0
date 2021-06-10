Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505BC3A2273
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhFJDAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229951AbhFJDAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E85E361426;
        Thu, 10 Jun 2021 02:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293900;
        bh=BbmzkfK+3XfdXMb8oHG/AQqpvvRKGCRJEnofvX8VjvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFckpKuwLh9IQnNrfaE5GJOfOjm0hoULfuBL0v5D7TyanpSyEMhtIlIh7IxXEgrxA
         f7RdYfMY2NaDX3jlaG/1KISOh49ViX1VI7NIGXk72VA89XwjKQlrHVkDFLpzzmgAvu
         dRcEKS35iMK/X3uG7LAAs8AfNhMOwSFHHIsLeWcOAfzVRqadya4pvRvP/vS6lk8Gfg
         XHLAFFrz9QHiU3vWK5IAAl8AzLIBl/HzifuaTrnSFhqPwXiTvGpMpNtXSgYx70mU8x
         Up+XiJYV0n+Z6OYgWrwMjRYLy7IYT5fLqDLVkvmigi1cjIjySlM2iI/ip5e74+DjY7
         qMW7HoDVUq7nA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/16] net/mlx5: DR, Allow encap action for RX for supporting devices
Date:   Wed,  9 Jun 2021 19:58:01 -0700
Message-Id: <20210610025814.274607-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Encap actions on RX flow were not supported on older devices.
However, this is no longer the case in devices that support STEv1.
This patch adds support for encap l3/l2 on RX flow for supported
devices: update actions state machine by adding the newely supported
transitions and add the required support in STEv0/1 files.
The new transitions that are supported are:
 - from decap/modify-header/pop-vlan to encap
 - from encap to termination table

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 40 +++++++++++++
 .../mellanox/mlx5/core/steering/dr_ste.h      |  1 +
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   |  1 +
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 60 ++++++++++++++-----
 .../mellanox/mlx5/core/steering/dr_types.h    |  5 ++
 5 files changed, 93 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 467f2eac6503..1b7a0e94d432 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
 
 #include "dr_types.h"
+#include "dr_ste.h"
 
 enum dr_action_domain {
 	DR_ACTION_DOMAIN_NIC_INGRESS,
@@ -34,6 +35,8 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_TNL_L2_TO_L2]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_TNL_L3_TO_L2]	= DR_ACTION_STATE_DECAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 		},
@@ -43,15 +46,26 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_DECAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 		},
+		[DR_ACTION_STATE_ENCAP] = {
+			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
+		},
 		[DR_ACTION_STATE_MODIFY_HDR] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 		},
 		[DR_ACTION_STATE_MODIFY_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -61,6 +75,8 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 		},
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -70,6 +86,8 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_TNL_L2_TO_L2]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_TNL_L3_TO_L2]	= DR_ACTION_STATE_DECAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 		},
@@ -128,6 +146,8 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_TNL_L2_TO_L2]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_TNL_L3_TO_L2]	= DR_ACTION_STATE_DECAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
@@ -139,12 +159,23 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+		},
+		[DR_ACTION_STATE_ENCAP] = {
+			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
 		},
 		[DR_ACTION_STATE_MODIFY_HDR] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 		},
 		[DR_ACTION_STATE_MODIFY_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -153,6 +184,8 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 		},
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -160,6 +193,8 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_TNL_L2_TO_L2]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_TNL_L3_TO_L2]	= DR_ACTION_STATE_DECAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
@@ -455,6 +490,11 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			break;
 		case DR_ACTION_TYP_L2_TO_TNL_L2:
 		case DR_ACTION_TYP_L2_TO_TNL_L3:
+			if (rx_rule &&
+			    !(dmn->ste_ctx->actions_caps & DR_STE_CTX_ACTION_CAP_RX_ENCAP)) {
+				mlx5dr_info(dmn, "Device doesn't support Encap on RX\n");
+				goto out_invalid_arg;
+			}
 			attr.reformat_size = action->reformat->reformat_size;
 			attr.reformat_id = action->reformat->reformat_id;
 			break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 992b591bf0c5..12a8bbbf944b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -156,6 +156,7 @@ struct mlx5dr_ste_ctx {
 	u16  (*get_byte_mask)(u8 *hw_ste_p);
 
 	/* Actions */
+	u32 actions_caps;
 	void (*set_actions_rx)(struct mlx5dr_domain *dmn,
 			       u8 *action_type_set,
 			       u8 *hw_ste_arr,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 0757a4e8540e..7e26a9e3afc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1893,6 +1893,7 @@ struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	.get_byte_mask			= &dr_ste_v0_get_byte_mask,
 
 	/* Actions */
+	.actions_caps			= DR_STE_CTX_ACTION_CAP_NONE,
 	.set_actions_rx			= &dr_ste_v0_set_actions_rx,
 	.set_actions_tx			= &dr_ste_v0_set_actions_tx,
 	.modify_field_arr_sz		= ARRAY_SIZE(dr_ste_v0_action_modify_field_arr),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 054c2e2b6554..a5807d190698 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -361,8 +361,8 @@ static void dr_ste_v1_set_reparse(u8 *hw_ste_p)
 	MLX5_SET(ste_match_bwc_v1, hw_ste_p, reparse, 1);
 }
 
-static void dr_ste_v1_set_tx_encap(u8 *hw_ste_p, u8 *d_action,
-				   u32 reformat_id, int size)
+static void dr_ste_v1_set_encap(u8 *hw_ste_p, u8 *d_action,
+				u32 reformat_id, int size)
 {
 	MLX5_SET(ste_double_action_insert_with_ptr_v1, d_action, action_id,
 		 DR_STE_V1_ACTION_ID_INSERT_POINTER);
@@ -401,11 +401,11 @@ static void dr_ste_v1_set_rx_pop_vlan(u8 *hw_ste_p, u8 *s_action, u8 vlans_num)
 	dr_ste_v1_set_reparse(hw_ste_p);
 }
 
-static void dr_ste_v1_set_tx_encap_l3(u8 *hw_ste_p,
-				      u8 *frst_s_action,
-				      u8 *scnd_d_action,
-				      u32 reformat_id,
-				      int size)
+static void dr_ste_v1_set_encap_l3(u8 *hw_ste_p,
+				   u8 *frst_s_action,
+				   u8 *scnd_d_action,
+				   u32 reformat_id,
+				   int size)
 {
 	/* Remove L2 headers */
 	MLX5_SET(ste_single_action_remove_header_v1, frst_s_action, action_id,
@@ -519,9 +519,9 @@ static void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 			action_sz = DR_STE_ACTION_TRIPLE_SZ;
 			allow_encap = true;
 		}
-		dr_ste_v1_set_tx_encap(last_ste, action,
-				       attr->reformat_id,
-				       attr->reformat_size);
+		dr_ste_v1_set_encap(last_ste, action,
+				    attr->reformat_id,
+				    attr->reformat_size);
 		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
 		action += DR_STE_ACTION_DOUBLE_SZ;
 	} else if (action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3]) {
@@ -532,10 +532,10 @@ static void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 		action_sz = DR_STE_ACTION_TRIPLE_SZ;
 		d_action = action + DR_STE_ACTION_SINGLE_SZ;
 
-		dr_ste_v1_set_tx_encap_l3(last_ste,
-					  action, d_action,
-					  attr->reformat_id,
-					  attr->reformat_size);
+		dr_ste_v1_set_encap_l3(last_ste,
+				       action, d_action,
+				       attr->reformat_id,
+				       attr->reformat_size);
 		action_sz -= DR_STE_ACTION_TRIPLE_SZ;
 		action += DR_STE_ACTION_TRIPLE_SZ;
 	}
@@ -627,6 +627,37 @@ static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 		dr_ste_v1_set_counter_id(last_ste, attr->ctr_id);
 	}
 
+	if (action_type_set[DR_ACTION_TYP_L2_TO_TNL_L2]) {
+		if (action_sz < DR_STE_ACTION_DOUBLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+		}
+		dr_ste_v1_set_encap(last_ste, action,
+				    attr->reformat_id,
+				    attr->reformat_size);
+		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
+		action += DR_STE_ACTION_DOUBLE_SZ;
+		allow_modify_hdr = false;
+	} else if (action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3]) {
+		u8 *d_action;
+
+		if (action_sz < DR_STE_ACTION_TRIPLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+		}
+
+		d_action = action + DR_STE_ACTION_SINGLE_SZ;
+
+		dr_ste_v1_set_encap_l3(last_ste,
+				       action, d_action,
+				       attr->reformat_id,
+				       attr->reformat_size);
+		action_sz -= DR_STE_ACTION_TRIPLE_SZ;
+		allow_modify_hdr = false;
+	}
+
 	dr_ste_v1_set_hit_gvmi(last_ste, attr->hit_gvmi);
 	dr_ste_v1_set_hit_addr(last_ste, attr->final_icm_addr, 1);
 }
@@ -1865,6 +1896,7 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	.set_byte_mask			= &dr_ste_v1_set_byte_mask,
 	.get_byte_mask			= &dr_ste_v1_get_byte_mask,
 	/* Actions */
+	.actions_caps			= DR_STE_CTX_ACTION_CAP_RX_ENCAP,
 	.set_actions_rx			= &dr_ste_v1_set_actions_rx,
 	.set_actions_tx			= &dr_ste_v1_set_actions_tx,
 	.modify_field_arr_sz		= ARRAY_SIZE(dr_ste_v1_action_modify_field_arr),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 7600004d79a8..b34018d49326 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -89,6 +89,11 @@ enum {
 	DR_STE_SIZE_REDUCED = DR_STE_SIZE - DR_STE_SIZE_MASK,
 };
 
+enum mlx5dr_ste_ctx_action_cap {
+	DR_STE_CTX_ACTION_CAP_NONE = 0,
+	DR_STE_CTX_ACTION_CAP_RX_ENCAP = 1 << 0,
+};
+
 enum {
 	DR_MODIFY_ACTION_SIZE = 8,
 };
-- 
2.31.1

