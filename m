Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE5C2EB5D9
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbhAEXHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:07:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728259AbhAEXHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:07:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 090A32310A;
        Tue,  5 Jan 2021 23:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887918;
        bh=KRpYXofblXhM9+KhgLiwNaEnGV4f7ZRrkEXdLZAafcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgS9BNFc5vYWV66gx2IpA+HnoJJqSUpCEPvrsKUhTvEdk4G49Vt1jvi1NPp1N1CKd
         qu9QXLOeKV8E4KGI78KJg7+L+xP0gbUZhJcgVh+GkOd5j2uoEAIZ8Jh2B5VGqsTTtS
         MIg+E8gF8FNIYsG8v8+hfKJZYtUSz3wo9zRRme4YACET4tBwzhzC2Lr4q9XH01I3sR
         o+UJurLyUOVmcPTLwSquiZVr5V0MuE8B8T3i507oSDC4fRyQDARpuzRHQG/vxmJ/0b
         LfKhrroCJaafFiVyj26WfAkIUkELi0HCoE+/reiOE0nFUqloHhFdPKYMI7O4FV1lL8
         /amqX/S/XkCTQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 16/16] net/mlx5: DR, Move STEv0 modify header logic
Date:   Tue,  5 Jan 2021 15:03:33 -0800
Message-Id: <20210105230333.239456-17-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Move HW specific modify header fields and logic to STEv0 file
and use the new STE context callbacks.
Since STEv0 and STEv1 modify actions values are different, each
version has its own implementation.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 401 +++---------------
 .../mellanox/mlx5/core/steering/dr_ste.c      |  64 +++
 .../mellanox/mlx5/core/steering/dr_ste.h      |  17 +
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 327 +++++++++++++-
 .../mellanox/mlx5/core/steering/dr_types.h    |  37 ++
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h |  45 --
 6 files changed, 501 insertions(+), 390 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 9b2552a87af9..27c2b8416d02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -218,136 +218,6 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 	},
 };
 
-struct dr_action_modify_field_conv {
-	u16 hw_field;
-	u8 start;
-	u8 end;
-	u8 l3_type;
-	u8 l4_type;
-};
-
-static const struct dr_action_modify_field_conv dr_action_conv_arr[] = {
-	[MLX5_ACTION_IN_FIELD_OUT_SMAC_47_16] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L2_1, .start = 16, .end = 47,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_SMAC_15_0] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L2_1, .start = 0, .end = 15,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_ETHERTYPE] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L2_2, .start = 32, .end = 47,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_DMAC_47_16] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L2_0, .start = 16, .end = 47,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_DMAC_15_0] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L2_0, .start = 0, .end = 15,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_IP_DSCP] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L3_1, .start = 0, .end = 5,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_TCP_FLAGS] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L4_0, .start = 48, .end = 56,
-		.l4_type = MLX5DR_ACTION_MDFY_HW_HDR_L4_TCP,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_TCP_SPORT] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L4_0, .start = 0, .end = 15,
-		.l4_type = MLX5DR_ACTION_MDFY_HW_HDR_L4_TCP,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_TCP_DPORT] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L4_0, .start = 16, .end = 31,
-		.l4_type = MLX5DR_ACTION_MDFY_HW_HDR_L4_TCP,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_IP_TTL] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L3_1, .start = 8, .end = 15,
-		.l3_type = MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV4,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_IPV6_HOPLIMIT] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L3_1, .start = 8, .end = 15,
-		.l3_type = MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_UDP_SPORT] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L4_0, .start = 0, .end = 15,
-		.l4_type = MLX5DR_ACTION_MDFY_HW_HDR_L4_UDP,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_UDP_DPORT] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L4_0, .start = 16, .end = 31,
-		.l4_type = MLX5DR_ACTION_MDFY_HW_HDR_L4_UDP,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_127_96] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L3_3, .start = 32, .end = 63,
-		.l3_type = MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_95_64] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L3_3, .start = 0, .end = 31,
-		.l3_type = MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_63_32] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L3_4, .start = 32, .end = 63,
-		.l3_type = MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_31_0] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L3_4, .start = 0, .end = 31,
-		.l3_type = MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_127_96] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L3_0, .start = 32, .end = 63,
-		.l3_type = MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_95_64] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L3_0, .start = 0, .end = 31,
-		.l3_type = MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_63_32] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L3_2, .start = 32, .end = 63,
-		.l3_type = MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_31_0] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L3_2, .start = 0, .end = 31,
-		.l3_type = MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_SIPV4] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L3_0, .start = 0, .end = 31,
-		.l3_type = MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV4,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_DIPV4] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L3_0, .start = 32, .end = 63,
-		.l3_type = MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV4,
-	},
-	[MLX5_ACTION_IN_FIELD_METADATA_REG_A] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_METADATA, .start = 0, .end = 31,
-	},
-	[MLX5_ACTION_IN_FIELD_METADATA_REG_B] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_METADATA, .start = 32, .end = 63,
-	},
-	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_0] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_REG_0, .start = 32, .end = 63,
-	},
-	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_1] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_REG_0, .start = 0, .end = 31,
-	},
-	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_2] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_REG_1, .start = 32, .end = 63,
-	},
-	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_3] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_REG_1, .start = 0, .end = 31,
-	},
-	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_4] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_REG_2, .start = 32, .end = 63,
-	},
-	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_5] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_REG_2, .start = 0, .end = 31,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_TCP_SEQ_NUM] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L4_1, .start = 32, .end = 63,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_TCP_ACK_NUM] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L4_1, .start = 0, .end = 31,
-	},
-	[MLX5_ACTION_IN_FIELD_OUT_FIRST_VID] = {
-		.hw_field = MLX5DR_ACTION_MDFY_HW_FLD_L2_2, .start = 0, .end = 15,
-	},
-};
-
 static int
 dr_action_reformat_to_action_type(enum mlx5dr_action_reformat_type reformat_type,
 				  enum mlx5dr_action_type *action_type)
@@ -659,132 +529,6 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 	return -EINVAL;
 }
 
-#define CVLAN_ETHERTYPE 0x8100
-#define SVLAN_ETHERTYPE 0x88a8
-#define HDR_LEN_L2_ONLY 14
-#define HDR_LEN_L2_VLAN 18
-#define REWRITE_HW_ACTION_NUM 6
-
-static int dr_actions_l2_rewrite(struct mlx5dr_domain *dmn,
-				 struct mlx5dr_action *action,
-				 void *data, size_t data_sz)
-{
-	struct mlx5_ifc_l2_hdr_bits *l2_hdr = data;
-	u64 ops[REWRITE_HW_ACTION_NUM] = {};
-	u32 hdr_fld_4b;
-	u16 hdr_fld_2b;
-	u16 vlan_type;
-	bool vlan;
-	int i = 0;
-	int ret;
-
-	vlan = (data_sz != HDR_LEN_L2_ONLY);
-
-	/* dmac_47_16 */
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_length, 0);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_field_code, MLX5DR_ACTION_MDFY_HW_FLD_L2_0);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_left_shifter, 16);
-	hdr_fld_4b = MLX5_GET(l2_hdr, l2_hdr, dmac_47_16);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 inline_data, hdr_fld_4b);
-	i++;
-
-	/* smac_47_16 */
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_length, 0);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_field_code, MLX5DR_ACTION_MDFY_HW_FLD_L2_1);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_left_shifter, 16);
-	hdr_fld_4b = (MLX5_GET(l2_hdr, l2_hdr, smac_31_0) >> 16 |
-		      MLX5_GET(l2_hdr, l2_hdr, smac_47_32) << 16);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 inline_data, hdr_fld_4b);
-	i++;
-
-	/* dmac_15_0 */
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_length, 16);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_field_code, MLX5DR_ACTION_MDFY_HW_FLD_L2_0);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_left_shifter, 0);
-	hdr_fld_2b = MLX5_GET(l2_hdr, l2_hdr, dmac_15_0);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 inline_data, hdr_fld_2b);
-	i++;
-
-	/* ethertype + (optional) vlan */
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_field_code, MLX5DR_ACTION_MDFY_HW_FLD_L2_2);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_left_shifter, 32);
-	if (!vlan) {
-		hdr_fld_2b = MLX5_GET(l2_hdr, l2_hdr, ethertype);
-		MLX5_SET(dr_action_hw_set, ops + i, inline_data, hdr_fld_2b);
-		MLX5_SET(dr_action_hw_set, ops + i, destination_length, 16);
-	} else {
-		hdr_fld_2b = MLX5_GET(l2_hdr, l2_hdr, ethertype);
-		vlan_type = hdr_fld_2b == SVLAN_ETHERTYPE ? DR_STE_SVLAN : DR_STE_CVLAN;
-		hdr_fld_2b = MLX5_GET(l2_hdr, l2_hdr, vlan);
-		hdr_fld_4b = (vlan_type << 16) | hdr_fld_2b;
-		MLX5_SET(dr_action_hw_set, ops + i, inline_data, hdr_fld_4b);
-		MLX5_SET(dr_action_hw_set, ops + i, destination_length, 18);
-	}
-	i++;
-
-	/* smac_15_0 */
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_length, 16);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_field_code, MLX5DR_ACTION_MDFY_HW_FLD_L2_1);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 destination_left_shifter, 0);
-	hdr_fld_2b = MLX5_GET(l2_hdr, l2_hdr, smac_31_0);
-	MLX5_SET(dr_action_hw_set, ops + i,
-		 inline_data, hdr_fld_2b);
-	i++;
-
-	if (vlan) {
-		MLX5_SET(dr_action_hw_set, ops + i,
-			 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
-		hdr_fld_2b = MLX5_GET(l2_hdr, l2_hdr, vlan_type);
-		MLX5_SET(dr_action_hw_set, ops + i,
-			 inline_data, hdr_fld_2b);
-		MLX5_SET(dr_action_hw_set, ops + i,
-			 destination_length, 16);
-		MLX5_SET(dr_action_hw_set, ops + i,
-			 destination_field_code, MLX5DR_ACTION_MDFY_HW_FLD_L2_2);
-		MLX5_SET(dr_action_hw_set, ops + i,
-			 destination_left_shifter, 0);
-		i++;
-	}
-
-	action->rewrite.data = (void *)ops;
-	action->rewrite.num_of_actions = i;
-
-	ret = mlx5dr_send_postsend_action(dmn, action);
-	if (ret) {
-		mlx5dr_dbg(dmn, "Writing encapsulation action to ICM failed\n");
-		return ret;
-	}
-
-	return 0;
-}
-
 static struct mlx5dr_action *
 dr_action_create_generic(enum mlx5dr_action_type action_type)
 {
@@ -1059,21 +803,34 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 	}
 	case DR_ACTION_TYP_TNL_L3_TO_L2:
 	{
-		/* Only Ethernet frame is supported, with VLAN (18) or without (14) */
-		if (data_sz != HDR_LEN_L2_ONLY && data_sz != HDR_LEN_L2_VLAN)
-			return -EINVAL;
+		u8 hw_actions[ACTION_CACHE_LINE_SIZE] = {};
+		int ret;
+
+		ret = mlx5dr_ste_set_action_decap_l3_list(dmn->ste_ctx,
+							  data, data_sz,
+							  hw_actions,
+							  ACTION_CACHE_LINE_SIZE,
+							  &action->rewrite.num_of_actions);
+		if (ret) {
+			mlx5dr_dbg(dmn, "Failed creating decap l3 action list\n");
+			return ret;
+		}
 
 		action->rewrite.chunk = mlx5dr_icm_alloc_chunk(dmn->action_icm_pool,
 							       DR_CHUNK_SIZE_8);
-		if (!action->rewrite.chunk)
+		if (!action->rewrite.chunk) {
+			mlx5dr_dbg(dmn, "Failed allocating modify header chunk\n");
 			return -ENOMEM;
+		}
 
+		action->rewrite.data = (void *)hw_actions;
 		action->rewrite.index = (action->rewrite.chunk->icm_addr -
 					 dmn->info.caps.hdr_modify_icm_addr) /
 					 ACTION_CACHE_LINE_SIZE;
 
-		ret = dr_actions_l2_rewrite(dmn, action, data, data_sz);
+		ret = mlx5dr_send_postsend_action(dmn, action);
 		if (ret) {
+			mlx5dr_dbg(dmn, "Writing decap l3 actions to ICM failed\n");
 			mlx5dr_icm_free_chunk(action->rewrite.chunk);
 			return ret;
 		}
@@ -1085,6 +842,9 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 	}
 }
 
+#define CVLAN_ETHERTYPE 0x8100
+#define SVLAN_ETHERTYPE 0x88a8
+
 struct mlx5dr_action *mlx5dr_action_create_pop_vlan(void)
 {
 	return dr_action_create_generic(DR_ACTION_TYP_POP_VLAN);
@@ -1157,31 +917,13 @@ mlx5dr_action_create_packet_reformat(struct mlx5dr_domain *dmn,
 	return NULL;
 }
 
-static const struct dr_action_modify_field_conv *
-dr_action_modify_get_hw_info(u16 sw_field)
-{
-	const struct dr_action_modify_field_conv *hw_action_info;
-
-	if (sw_field >= ARRAY_SIZE(dr_action_conv_arr))
-		goto not_found;
-
-	hw_action_info = &dr_action_conv_arr[sw_field];
-	if (!hw_action_info->end && !hw_action_info->start)
-		goto not_found;
-
-	return hw_action_info;
-
-not_found:
-	return NULL;
-}
-
 static int
 dr_action_modify_sw_to_hw_add(struct mlx5dr_domain *dmn,
 			      __be64 *sw_action,
 			      __be64 *hw_action,
-			      const struct dr_action_modify_field_conv **ret_hw_info)
+			      const struct mlx5dr_ste_action_modify_field **ret_hw_info)
 {
-	const struct dr_action_modify_field_conv *hw_action_info;
+	const struct mlx5dr_ste_action_modify_field *hw_action_info;
 	u8 max_length;
 	u16 sw_field;
 	u32 data;
@@ -1191,7 +933,7 @@ dr_action_modify_sw_to_hw_add(struct mlx5dr_domain *dmn,
 	data = MLX5_GET(set_action_in, sw_action, data);
 
 	/* Convert SW data to HW modify action format */
-	hw_action_info = dr_action_modify_get_hw_info(sw_field);
+	hw_action_info = mlx5dr_ste_conv_modify_hdr_sw_field(dmn->ste_ctx, sw_field);
 	if (!hw_action_info) {
 		mlx5dr_dbg(dmn, "Modify add action invalid field given\n");
 		return -EINVAL;
@@ -1199,20 +941,12 @@ dr_action_modify_sw_to_hw_add(struct mlx5dr_domain *dmn,
 
 	max_length = hw_action_info->end - hw_action_info->start + 1;
 
-	MLX5_SET(dr_action_hw_set, hw_action,
-		 opcode, MLX5DR_ACTION_MDFY_HW_OP_ADD);
-
-	MLX5_SET(dr_action_hw_set, hw_action, destination_field_code,
-		 hw_action_info->hw_field);
-
-	MLX5_SET(dr_action_hw_set, hw_action, destination_left_shifter,
-		 hw_action_info->start);
-
-	/* PRM defines that length zero specific length of 32bits */
-	MLX5_SET(dr_action_hw_set, hw_action, destination_length,
-		 max_length == 32 ? 0 : max_length);
-
-	MLX5_SET(dr_action_hw_set, hw_action, inline_data, data);
+	mlx5dr_ste_set_action_add(dmn->ste_ctx,
+				  hw_action,
+				  hw_action_info->hw_field,
+				  hw_action_info->start,
+				  max_length,
+				  data);
 
 	*ret_hw_info = hw_action_info;
 
@@ -1223,9 +957,9 @@ static int
 dr_action_modify_sw_to_hw_set(struct mlx5dr_domain *dmn,
 			      __be64 *sw_action,
 			      __be64 *hw_action,
-			      const struct dr_action_modify_field_conv **ret_hw_info)
+			      const struct mlx5dr_ste_action_modify_field **ret_hw_info)
 {
-	const struct dr_action_modify_field_conv *hw_action_info;
+	const struct mlx5dr_ste_action_modify_field *hw_action_info;
 	u8 offset, length, max_length;
 	u16 sw_field;
 	u32 data;
@@ -1237,7 +971,7 @@ dr_action_modify_sw_to_hw_set(struct mlx5dr_domain *dmn,
 	data = MLX5_GET(set_action_in, sw_action, data);
 
 	/* Convert SW data to HW modify action format */
-	hw_action_info = dr_action_modify_get_hw_info(sw_field);
+	hw_action_info = mlx5dr_ste_conv_modify_hdr_sw_field(dmn->ste_ctx, sw_field);
 	if (!hw_action_info) {
 		mlx5dr_dbg(dmn, "Modify set action invalid field given\n");
 		return -EINVAL;
@@ -1253,19 +987,12 @@ dr_action_modify_sw_to_hw_set(struct mlx5dr_domain *dmn,
 		return -EINVAL;
 	}
 
-	MLX5_SET(dr_action_hw_set, hw_action,
-		 opcode, MLX5DR_ACTION_MDFY_HW_OP_SET);
-
-	MLX5_SET(dr_action_hw_set, hw_action, destination_field_code,
-		 hw_action_info->hw_field);
-
-	MLX5_SET(dr_action_hw_set, hw_action, destination_left_shifter,
-		 hw_action_info->start + offset);
-
-	MLX5_SET(dr_action_hw_set, hw_action, destination_length,
-		 length == 32 ? 0 : length);
-
-	MLX5_SET(dr_action_hw_set, hw_action, inline_data, data);
+	mlx5dr_ste_set_action_set(dmn->ste_ctx,
+				  hw_action,
+				  hw_action_info->hw_field,
+				  hw_action_info->start + offset,
+				  length,
+				  data);
 
 	*ret_hw_info = hw_action_info;
 
@@ -1276,12 +1003,12 @@ static int
 dr_action_modify_sw_to_hw_copy(struct mlx5dr_domain *dmn,
 			       __be64 *sw_action,
 			       __be64 *hw_action,
-			       const struct dr_action_modify_field_conv **ret_dst_hw_info,
-			       const struct dr_action_modify_field_conv **ret_src_hw_info)
+			       const struct mlx5dr_ste_action_modify_field **ret_dst_hw_info,
+			       const struct mlx5dr_ste_action_modify_field **ret_src_hw_info)
 {
 	u8 src_offset, dst_offset, src_max_length, dst_max_length, length;
-	const struct dr_action_modify_field_conv *hw_dst_action_info;
-	const struct dr_action_modify_field_conv *hw_src_action_info;
+	const struct mlx5dr_ste_action_modify_field *hw_dst_action_info;
+	const struct mlx5dr_ste_action_modify_field *hw_src_action_info;
 	u16 src_field, dst_field;
 
 	/* Get SW modify action data */
@@ -1292,8 +1019,8 @@ dr_action_modify_sw_to_hw_copy(struct mlx5dr_domain *dmn,
 	length = MLX5_GET(copy_action_in, sw_action, length);
 
 	/* Convert SW data to HW modify action format */
-	hw_src_action_info = dr_action_modify_get_hw_info(src_field);
-	hw_dst_action_info = dr_action_modify_get_hw_info(dst_field);
+	hw_src_action_info = mlx5dr_ste_conv_modify_hdr_sw_field(dmn->ste_ctx, src_field);
+	hw_dst_action_info = mlx5dr_ste_conv_modify_hdr_sw_field(dmn->ste_ctx, dst_field);
 	if (!hw_src_action_info || !hw_dst_action_info) {
 		mlx5dr_dbg(dmn, "Modify copy action invalid field given\n");
 		return -EINVAL;
@@ -1313,23 +1040,13 @@ dr_action_modify_sw_to_hw_copy(struct mlx5dr_domain *dmn,
 		return -EINVAL;
 	}
 
-	MLX5_SET(dr_action_hw_copy, hw_action,
-		 opcode, MLX5DR_ACTION_MDFY_HW_OP_COPY);
-
-	MLX5_SET(dr_action_hw_copy, hw_action, destination_field_code,
-		 hw_dst_action_info->hw_field);
-
-	MLX5_SET(dr_action_hw_copy, hw_action, destination_left_shifter,
-		 hw_dst_action_info->start + dst_offset);
-
-	MLX5_SET(dr_action_hw_copy, hw_action, destination_length,
-		 length == 32 ? 0 : length);
-
-	MLX5_SET(dr_action_hw_copy, hw_action, source_field_code,
-		 hw_src_action_info->hw_field);
-
-	MLX5_SET(dr_action_hw_copy, hw_action, source_left_shifter,
-		 hw_src_action_info->start + dst_offset);
+	mlx5dr_ste_set_action_copy(dmn->ste_ctx,
+				   hw_action,
+				   hw_dst_action_info->hw_field,
+				   hw_dst_action_info->start + dst_offset,
+				   length,
+				   hw_src_action_info->hw_field,
+				   hw_src_action_info->start + src_offset);
 
 	*ret_dst_hw_info = hw_dst_action_info;
 	*ret_src_hw_info = hw_src_action_info;
@@ -1341,8 +1058,8 @@ static int
 dr_action_modify_sw_to_hw(struct mlx5dr_domain *dmn,
 			  __be64 *sw_action,
 			  __be64 *hw_action,
-			  const struct dr_action_modify_field_conv **ret_dst_hw_info,
-			  const struct dr_action_modify_field_conv **ret_src_hw_info)
+			  const struct mlx5dr_ste_action_modify_field **ret_dst_hw_info,
+			  const struct mlx5dr_ste_action_modify_field **ret_src_hw_info)
 {
 	u8 action;
 	int ret;
@@ -1519,15 +1236,15 @@ static int dr_actions_convert_modify_header(struct mlx5dr_action *action,
 					    u32 *num_hw_actions,
 					    bool *modify_ttl)
 {
-	const struct dr_action_modify_field_conv *hw_dst_action_info;
-	const struct dr_action_modify_field_conv *hw_src_action_info;
-	u16 hw_field = MLX5DR_ACTION_MDFY_HW_FLD_RESERVED;
-	u32 l3_type = MLX5DR_ACTION_MDFY_HW_HDR_L3_NONE;
-	u32 l4_type = MLX5DR_ACTION_MDFY_HW_HDR_L4_NONE;
+	const struct mlx5dr_ste_action_modify_field *hw_dst_action_info;
+	const struct mlx5dr_ste_action_modify_field *hw_src_action_info;
 	struct mlx5dr_domain *dmn = action->rewrite.dmn;
 	int ret, i, hw_idx = 0;
 	__be64 *sw_action;
 	__be64 hw_action;
+	u16 hw_field = 0;
+	u32 l3_type = 0;
+	u32 l4_type = 0;
 
 	*modify_ttl = false;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 2af9487344a2..1614481fdf8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -534,6 +534,70 @@ void mlx5dr_ste_set_actions_rx(struct mlx5dr_ste_ctx *ste_ctx,
 				attr, added_stes);
 }
 
+const struct mlx5dr_ste_action_modify_field *
+mlx5dr_ste_conv_modify_hdr_sw_field(struct mlx5dr_ste_ctx *ste_ctx, u16 sw_field)
+{
+	const struct mlx5dr_ste_action_modify_field *hw_field;
+
+	if (sw_field >= ste_ctx->modify_field_arr_sz)
+		return NULL;
+
+	hw_field = &ste_ctx->modify_field_arr[sw_field];
+	if (!hw_field->end && !hw_field->start)
+		return NULL;
+
+	return hw_field;
+}
+
+void mlx5dr_ste_set_action_set(struct mlx5dr_ste_ctx *ste_ctx,
+			       __be64 *hw_action,
+			       u8 hw_field,
+			       u8 shifter,
+			       u8 length,
+			       u32 data)
+{
+	ste_ctx->set_action_set((u8 *)hw_action,
+				hw_field, shifter, length, data);
+}
+
+void mlx5dr_ste_set_action_add(struct mlx5dr_ste_ctx *ste_ctx,
+			       __be64 *hw_action,
+			       u8 hw_field,
+			       u8 shifter,
+			       u8 length,
+			       u32 data)
+{
+	ste_ctx->set_action_add((u8 *)hw_action,
+				hw_field, shifter, length, data);
+}
+
+void mlx5dr_ste_set_action_copy(struct mlx5dr_ste_ctx *ste_ctx,
+				__be64 *hw_action,
+				u8 dst_hw_field,
+				u8 dst_shifter,
+				u8 dst_len,
+				u8 src_hw_field,
+				u8 src_shifter)
+{
+	ste_ctx->set_action_copy((u8 *)hw_action,
+				 dst_hw_field, dst_shifter, dst_len,
+				 src_hw_field, src_shifter);
+}
+
+int mlx5dr_ste_set_action_decap_l3_list(struct mlx5dr_ste_ctx *ste_ctx,
+					void *data, u32 data_sz,
+					u8 *hw_action, u32 hw_action_sz,
+					u16 *used_hw_action_num)
+{
+	/* Only Ethernet frame is supported, with VLAN (18) or without (14) */
+	if (data_sz != HDR_LEN_L2 && data_sz != HDR_LEN_L2_W_VLAN)
+		return -EINVAL;
+
+	return ste_ctx->set_action_decap_l3_list(data, data_sz,
+						 hw_action, hw_action_sz,
+						 used_hw_action_num);
+}
+
 int mlx5dr_ste_build_pre_check(struct mlx5dr_domain *dmn,
 			       u8 match_criteria,
 			       struct mlx5dr_match_param *mask,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 1a70f4f26e40..4a3d6a849991 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -15,6 +15,11 @@
 #define IP_VERSION_IPV6 0x6
 #define STE_SVLAN 0x1
 #define STE_CVLAN 0x2
+#define HDR_LEN_L2_MACS   0xC
+#define HDR_LEN_L2_VLAN   0x4
+#define HDR_LEN_L2_ETHER  0x2
+#define HDR_LEN_L2        (HDR_LEN_L2_MACS + HDR_LEN_L2_ETHER)
+#define HDR_LEN_L2_W_VLAN (HDR_LEN_L2 + HDR_LEN_L2_VLAN)
 
 /* Set to STE a specific value using DR_STE_SET */
 #define DR_STE_SET_VAL(lookup_type, tag, t_fname, spec, s_fname, value) do { \
@@ -69,6 +74,18 @@
 	(_misc)->outer_first_mpls_over_udp_s_bos || \
 	(_misc)->outer_first_mpls_over_udp_ttl)
 
+enum dr_ste_action_modify_type_l3 {
+	DR_STE_ACTION_MDFY_TYPE_L3_NONE	= 0x0,
+	DR_STE_ACTION_MDFY_TYPE_L3_IPV4	= 0x1,
+	DR_STE_ACTION_MDFY_TYPE_L3_IPV6	= 0x2,
+};
+
+enum dr_ste_action_modify_type_l4 {
+	DR_STE_ACTION_MDFY_TYPE_L4_NONE	= 0x0,
+	DR_STE_ACTION_MDFY_TYPE_L4_TCP	= 0x1,
+	DR_STE_ACTION_MDFY_TYPE_L4_UDP	= 0x2,
+};
+
 u16 mlx5dr_ste_conv_bit_to_byte_mask(u8 *bit_mask);
 
 #define DR_STE_CTX_BUILDER(fname) \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 9bb6395f5d60..b76fdff08890 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -5,9 +5,10 @@
 #include <linux/crc32.h>
 #include "dr_ste.h"
 
-#define DR_STE_ENABLE_FLOW_TAG BIT(31)
+#define SVLAN_ETHERTYPE		0x88a8
+#define DR_STE_ENABLE_FLOW_TAG	BIT(31)
 
-enum dr_ste_tunl_action {
+enum dr_ste_v0_action_tunl {
 	DR_STE_TUNL_ACTION_NONE		= 0,
 	DR_STE_TUNL_ACTION_ENABLE	= 1,
 	DR_STE_TUNL_ACTION_DECAP	= 2,
@@ -15,12 +16,18 @@ enum dr_ste_tunl_action {
 	DR_STE_TUNL_ACTION_POP_VLAN	= 4,
 };
 
-enum dr_ste_action_type {
+enum dr_ste_v0_action_type {
 	DR_STE_ACTION_TYPE_PUSH_VLAN	= 1,
 	DR_STE_ACTION_TYPE_ENCAP_L3	= 3,
 	DR_STE_ACTION_TYPE_ENCAP	= 4,
 };
 
+enum dr_ste_v0_action_mdfy_op {
+	DR_STE_ACTION_MDFY_OP_COPY	= 0x1,
+	DR_STE_ACTION_MDFY_OP_SET	= 0x2,
+	DR_STE_ACTION_MDFY_OP_ADD	= 0x3,
+};
+
 #define DR_STE_CALC_LU_TYPE(lookup_type, rx, inner) \
 	((inner) ? DR_STE_V0_LU_TYPE_##lookup_type##_I : \
 		   (rx) ? DR_STE_V0_LU_TYPE_##lookup_type##_D : \
@@ -70,6 +77,155 @@ enum {
 	DR_STE_V0_LU_TYPE_DONT_CARE			= MLX5DR_STE_LU_TYPE_DONT_CARE,
 };
 
+enum {
+	DR_STE_V0_ACTION_MDFY_FLD_L2_0		= 0,
+	DR_STE_V0_ACTION_MDFY_FLD_L2_1		= 1,
+	DR_STE_V0_ACTION_MDFY_FLD_L2_2		= 2,
+	DR_STE_V0_ACTION_MDFY_FLD_L3_0		= 3,
+	DR_STE_V0_ACTION_MDFY_FLD_L3_1		= 4,
+	DR_STE_V0_ACTION_MDFY_FLD_L3_2		= 5,
+	DR_STE_V0_ACTION_MDFY_FLD_L3_3		= 6,
+	DR_STE_V0_ACTION_MDFY_FLD_L3_4		= 7,
+	DR_STE_V0_ACTION_MDFY_FLD_L4_0		= 8,
+	DR_STE_V0_ACTION_MDFY_FLD_L4_1		= 9,
+	DR_STE_V0_ACTION_MDFY_FLD_MPLS		= 10,
+	DR_STE_V0_ACTION_MDFY_FLD_L2_TNL_0	= 11,
+	DR_STE_V0_ACTION_MDFY_FLD_REG_0		= 12,
+	DR_STE_V0_ACTION_MDFY_FLD_REG_1		= 13,
+	DR_STE_V0_ACTION_MDFY_FLD_REG_2		= 14,
+	DR_STE_V0_ACTION_MDFY_FLD_REG_3		= 15,
+	DR_STE_V0_ACTION_MDFY_FLD_L4_2		= 16,
+	DR_STE_V0_ACTION_MDFY_FLD_FLEX_0	= 17,
+	DR_STE_V0_ACTION_MDFY_FLD_FLEX_1	= 18,
+	DR_STE_V0_ACTION_MDFY_FLD_FLEX_2	= 19,
+	DR_STE_V0_ACTION_MDFY_FLD_FLEX_3	= 20,
+	DR_STE_V0_ACTION_MDFY_FLD_L2_TNL_1	= 21,
+	DR_STE_V0_ACTION_MDFY_FLD_METADATA	= 22,
+	DR_STE_V0_ACTION_MDFY_FLD_RESERVED	= 23,
+};
+
+static const struct mlx5dr_ste_action_modify_field dr_ste_v0_action_modify_field_arr[] = {
+	[MLX5_ACTION_IN_FIELD_OUT_SMAC_47_16] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L2_1, .start = 16, .end = 47,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SMAC_15_0] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L2_1, .start = 0, .end = 15,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_ETHERTYPE] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L2_2, .start = 32, .end = 47,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DMAC_47_16] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L2_0, .start = 16, .end = 47,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DMAC_15_0] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L2_0, .start = 0, .end = 15,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_IP_DSCP] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L3_1, .start = 0, .end = 5,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_FLAGS] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L4_0, .start = 48, .end = 56,
+		.l4_type = DR_STE_ACTION_MDFY_TYPE_L4_TCP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_SPORT] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L4_0, .start = 0, .end = 15,
+		.l4_type = DR_STE_ACTION_MDFY_TYPE_L4_TCP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_DPORT] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L4_0, .start = 16, .end = 31,
+		.l4_type = DR_STE_ACTION_MDFY_TYPE_L4_TCP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_IP_TTL] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L3_1, .start = 8, .end = 15,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV4,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_IPV6_HOPLIMIT] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L3_1, .start = 8, .end = 15,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_UDP_SPORT] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L4_0, .start = 0, .end = 15,
+		.l4_type = DR_STE_ACTION_MDFY_TYPE_L4_UDP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_UDP_DPORT] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L4_0, .start = 16, .end = 31,
+		.l4_type = DR_STE_ACTION_MDFY_TYPE_L4_UDP,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_127_96] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L3_3, .start = 32, .end = 63,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_95_64] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L3_3, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_63_32] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L3_4, .start = 32, .end = 63,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV6_31_0] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L3_4, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_127_96] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L3_0, .start = 32, .end = 63,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_95_64] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L3_0, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_63_32] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L3_2, .start = 32, .end = 63,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV6_31_0] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L3_2, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV6,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_SIPV4] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L3_0, .start = 0, .end = 31,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV4,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_DIPV4] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L3_0, .start = 32, .end = 63,
+		.l3_type = DR_STE_ACTION_MDFY_TYPE_L3_IPV4,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_A] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_METADATA, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_B] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_METADATA, .start = 32, .end = 63,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_0] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_REG_0, .start = 32, .end = 63,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_1] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_REG_0, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_2] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_REG_1, .start = 32, .end = 63,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_3] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_REG_1, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_4] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_REG_2, .start = 32, .end = 63,
+	},
+	[MLX5_ACTION_IN_FIELD_METADATA_REG_C_5] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_REG_2, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_SEQ_NUM] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L4_1, .start = 32, .end = 63,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_TCP_ACK_NUM] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L4_1, .start = 0, .end = 31,
+	},
+	[MLX5_ACTION_IN_FIELD_OUT_FIRST_VID] = {
+		.hw_field = DR_STE_V0_ACTION_MDFY_FLD_L2_2, .start = 0, .end = 15,
+	},
+};
+
 static void dr_ste_v0_set_entry_type(u8 *hw_ste_p, u8 entry_type)
 {
 	MLX5_SET(ste_general, hw_ste_p, entry_type, entry_type);
@@ -365,6 +521,165 @@ dr_ste_v0_set_actions_rx(struct mlx5dr_domain *dmn,
 	dr_ste_v0_set_hit_addr(last_ste, attr->final_icm_addr, 1);
 }
 
+static void dr_ste_v0_set_action_set(u8 *hw_action,
+				     u8 hw_field,
+				     u8 shifter,
+				     u8 length,
+				     u32 data)
+{
+	length = (length == 32) ? 0 : length;
+	MLX5_SET(dr_action_hw_set, hw_action, opcode, DR_STE_ACTION_MDFY_OP_SET);
+	MLX5_SET(dr_action_hw_set, hw_action, destination_field_code, hw_field);
+	MLX5_SET(dr_action_hw_set, hw_action, destination_left_shifter, shifter);
+	MLX5_SET(dr_action_hw_set, hw_action, destination_length, length);
+	MLX5_SET(dr_action_hw_set, hw_action, inline_data, data);
+}
+
+static void dr_ste_v0_set_action_add(u8 *hw_action,
+				     u8 hw_field,
+				     u8 shifter,
+				     u8 length,
+				     u32 data)
+{
+	length = (length == 32) ? 0 : length;
+	MLX5_SET(dr_action_hw_set, hw_action, opcode, DR_STE_ACTION_MDFY_OP_ADD);
+	MLX5_SET(dr_action_hw_set, hw_action, destination_field_code, hw_field);
+	MLX5_SET(dr_action_hw_set, hw_action, destination_left_shifter, shifter);
+	MLX5_SET(dr_action_hw_set, hw_action, destination_length, length);
+	MLX5_SET(dr_action_hw_set, hw_action, inline_data, data);
+}
+
+static void dr_ste_v0_set_action_copy(u8 *hw_action,
+				      u8 dst_hw_field,
+				      u8 dst_shifter,
+				      u8 dst_len,
+				      u8 src_hw_field,
+				      u8 src_shifter)
+{
+	MLX5_SET(dr_action_hw_copy, hw_action, opcode, DR_STE_ACTION_MDFY_OP_COPY);
+	MLX5_SET(dr_action_hw_copy, hw_action, destination_field_code, dst_hw_field);
+	MLX5_SET(dr_action_hw_copy, hw_action, destination_left_shifter, dst_shifter);
+	MLX5_SET(dr_action_hw_copy, hw_action, destination_length, dst_len);
+	MLX5_SET(dr_action_hw_copy, hw_action, source_field_code, src_hw_field);
+	MLX5_SET(dr_action_hw_copy, hw_action, source_left_shifter, src_shifter);
+}
+
+#define DR_STE_DECAP_L3_MIN_ACTION_NUM	5
+
+static int
+dr_ste_v0_set_action_decap_l3_list(void *data, u32 data_sz,
+				   u8 *hw_action, u32 hw_action_sz,
+				   u16 *used_hw_action_num)
+{
+	struct mlx5_ifc_l2_hdr_bits *l2_hdr = data;
+	u32 hw_action_num;
+	int required_actions;
+	u32 hdr_fld_4b;
+	u16 hdr_fld_2b;
+	u16 vlan_type;
+	bool vlan;
+
+	vlan = (data_sz != HDR_LEN_L2);
+	hw_action_num = hw_action_sz / MLX5_ST_SZ_BYTES(dr_action_hw_set);
+	required_actions = DR_STE_DECAP_L3_MIN_ACTION_NUM + !!vlan;
+
+	if (hw_action_num < required_actions)
+		return -ENOMEM;
+
+	/* dmac_47_16 */
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 opcode, DR_STE_ACTION_MDFY_OP_SET);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 destination_length, 0);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 destination_field_code, DR_STE_V0_ACTION_MDFY_FLD_L2_0);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 destination_left_shifter, 16);
+	hdr_fld_4b = MLX5_GET(l2_hdr, l2_hdr, dmac_47_16);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 inline_data, hdr_fld_4b);
+	hw_action += MLX5_ST_SZ_BYTES(dr_action_hw_set);
+
+	/* smac_47_16 */
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 opcode, DR_STE_ACTION_MDFY_OP_SET);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 destination_length, 0);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 destination_field_code, DR_STE_V0_ACTION_MDFY_FLD_L2_1);
+	MLX5_SET(dr_action_hw_set, hw_action, destination_left_shifter, 16);
+	hdr_fld_4b = (MLX5_GET(l2_hdr, l2_hdr, smac_31_0) >> 16 |
+		      MLX5_GET(l2_hdr, l2_hdr, smac_47_32) << 16);
+	MLX5_SET(dr_action_hw_set, hw_action, inline_data, hdr_fld_4b);
+	hw_action += MLX5_ST_SZ_BYTES(dr_action_hw_set);
+
+	/* dmac_15_0 */
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 opcode, DR_STE_ACTION_MDFY_OP_SET);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 destination_length, 16);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 destination_field_code, DR_STE_V0_ACTION_MDFY_FLD_L2_0);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 destination_left_shifter, 0);
+	hdr_fld_2b = MLX5_GET(l2_hdr, l2_hdr, dmac_15_0);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 inline_data, hdr_fld_2b);
+	hw_action += MLX5_ST_SZ_BYTES(dr_action_hw_set);
+
+	/* ethertype + (optional) vlan */
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 opcode, DR_STE_ACTION_MDFY_OP_SET);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 destination_field_code, DR_STE_V0_ACTION_MDFY_FLD_L2_2);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 destination_left_shifter, 32);
+	if (!vlan) {
+		hdr_fld_2b = MLX5_GET(l2_hdr, l2_hdr, ethertype);
+		MLX5_SET(dr_action_hw_set, hw_action, inline_data, hdr_fld_2b);
+		MLX5_SET(dr_action_hw_set, hw_action, destination_length, 16);
+	} else {
+		hdr_fld_2b = MLX5_GET(l2_hdr, l2_hdr, ethertype);
+		vlan_type = hdr_fld_2b == SVLAN_ETHERTYPE ? DR_STE_SVLAN : DR_STE_CVLAN;
+		hdr_fld_2b = MLX5_GET(l2_hdr, l2_hdr, vlan);
+		hdr_fld_4b = (vlan_type << 16) | hdr_fld_2b;
+		MLX5_SET(dr_action_hw_set, hw_action, inline_data, hdr_fld_4b);
+		MLX5_SET(dr_action_hw_set, hw_action, destination_length, 18);
+	}
+	hw_action += MLX5_ST_SZ_BYTES(dr_action_hw_set);
+
+	/* smac_15_0 */
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 opcode, DR_STE_ACTION_MDFY_OP_SET);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 destination_length, 16);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 destination_field_code, DR_STE_V0_ACTION_MDFY_FLD_L2_1);
+	MLX5_SET(dr_action_hw_set, hw_action,
+		 destination_left_shifter, 0);
+	hdr_fld_2b = MLX5_GET(l2_hdr, l2_hdr, smac_31_0);
+	MLX5_SET(dr_action_hw_set, hw_action, inline_data, hdr_fld_2b);
+	hw_action += MLX5_ST_SZ_BYTES(dr_action_hw_set);
+
+	if (vlan) {
+		MLX5_SET(dr_action_hw_set, hw_action,
+			 opcode, DR_STE_ACTION_MDFY_OP_SET);
+		hdr_fld_2b = MLX5_GET(l2_hdr, l2_hdr, vlan_type);
+		MLX5_SET(dr_action_hw_set, hw_action,
+			 inline_data, hdr_fld_2b);
+		MLX5_SET(dr_action_hw_set, hw_action,
+			 destination_length, 16);
+		MLX5_SET(dr_action_hw_set, hw_action,
+			 destination_field_code, DR_STE_V0_ACTION_MDFY_FLD_L2_2);
+		MLX5_SET(dr_action_hw_set, hw_action,
+			 destination_left_shifter, 0);
+	}
+
+	*used_hw_action_num = required_actions;
+
+	return 0;
+}
+
 static void
 dr_ste_v0_build_eth_l2_src_dst_bit_mask(struct mlx5dr_match_param *value,
 					bool inner, u8 *bit_mask)
@@ -1316,4 +1631,10 @@ struct mlx5dr_ste_ctx ste_ctx_v0 = {
 	/* Actions */
 	.set_actions_rx			= &dr_ste_v0_set_actions_rx,
 	.set_actions_tx			= &dr_ste_v0_set_actions_tx,
+	.modify_field_arr_sz		= ARRAY_SIZE(dr_ste_v0_action_modify_field_arr),
+	.modify_field_arr		= dr_ste_v0_action_modify_field_arr,
+	.set_action_set			= &dr_ste_v0_set_action_set,
+	.set_action_add			= &dr_ste_v0_set_action_add,
+	.set_action_copy		= &dr_ste_v0_set_action_copy,
+	.set_action_decap_l3_list	= &dr_ste_v0_set_action_decap_l3_list,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 10f7cd56bc05..8d2c3b6e2755 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -268,6 +268,35 @@ void mlx5dr_ste_set_actions_tx(struct mlx5dr_ste_ctx *ste_ctx,
 			       struct mlx5dr_ste_actions_attr *attr,
 			       u32 *added_stes);
 
+void mlx5dr_ste_set_action_set(struct mlx5dr_ste_ctx *ste_ctx,
+			       __be64 *hw_action,
+			       u8 hw_field,
+			       u8 shifter,
+			       u8 length,
+			       u32 data);
+void mlx5dr_ste_set_action_add(struct mlx5dr_ste_ctx *ste_ctx,
+			       __be64 *hw_action,
+			       u8 hw_field,
+			       u8 shifter,
+			       u8 length,
+			       u32 data);
+void mlx5dr_ste_set_action_copy(struct mlx5dr_ste_ctx *ste_ctx,
+				__be64 *hw_action,
+				u8 dst_hw_field,
+				u8 dst_shifter,
+				u8 dst_len,
+				u8 src_hw_field,
+				u8 src_shifter);
+int mlx5dr_ste_set_action_decap_l3_list(struct mlx5dr_ste_ctx *ste_ctx,
+					void *data,
+					u32 data_sz,
+					u8 *hw_action,
+					u32 hw_action_sz,
+					u16 *used_hw_action_num);
+
+const struct mlx5dr_ste_action_modify_field *
+mlx5dr_ste_conv_modify_hdr_sw_field(struct mlx5dr_ste_ctx *ste_ctx, u16 sw_field);
+
 struct mlx5dr_ste_ctx *mlx5dr_ste_get_ctx(u8 version);
 void mlx5dr_ste_free(struct mlx5dr_ste *ste,
 		     struct mlx5dr_matcher *matcher,
@@ -765,6 +794,14 @@ struct mlx5dr_rule_member {
 	struct list_head use_ste_list;
 };
 
+struct mlx5dr_ste_action_modify_field {
+	u16 hw_field;
+	u8 start;
+	u8 end;
+	u8 l3_type;
+	u8 l4_type;
+};
+
 struct mlx5dr_action {
 	enum mlx5dr_action_type action_type;
 	refcount_t refcount;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
index b4babb6b6616..83df6df6b459 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5_ifc_dr.h
@@ -4,51 +4,6 @@
 #ifndef MLX5_IFC_DR_H
 #define MLX5_IFC_DR_H
 
-enum {
-	MLX5DR_ACTION_MDFY_HW_FLD_L2_0		= 0,
-	MLX5DR_ACTION_MDFY_HW_FLD_L2_1		= 1,
-	MLX5DR_ACTION_MDFY_HW_FLD_L2_2		= 2,
-	MLX5DR_ACTION_MDFY_HW_FLD_L3_0		= 3,
-	MLX5DR_ACTION_MDFY_HW_FLD_L3_1		= 4,
-	MLX5DR_ACTION_MDFY_HW_FLD_L3_2		= 5,
-	MLX5DR_ACTION_MDFY_HW_FLD_L3_3		= 6,
-	MLX5DR_ACTION_MDFY_HW_FLD_L3_4		= 7,
-	MLX5DR_ACTION_MDFY_HW_FLD_L4_0		= 8,
-	MLX5DR_ACTION_MDFY_HW_FLD_L4_1		= 9,
-	MLX5DR_ACTION_MDFY_HW_FLD_MPLS		= 10,
-	MLX5DR_ACTION_MDFY_HW_FLD_L2_TNL_0	= 11,
-	MLX5DR_ACTION_MDFY_HW_FLD_REG_0		= 12,
-	MLX5DR_ACTION_MDFY_HW_FLD_REG_1		= 13,
-	MLX5DR_ACTION_MDFY_HW_FLD_REG_2		= 14,
-	MLX5DR_ACTION_MDFY_HW_FLD_REG_3		= 15,
-	MLX5DR_ACTION_MDFY_HW_FLD_L4_2		= 16,
-	MLX5DR_ACTION_MDFY_HW_FLD_FLEX_0	= 17,
-	MLX5DR_ACTION_MDFY_HW_FLD_FLEX_1	= 18,
-	MLX5DR_ACTION_MDFY_HW_FLD_FLEX_2	= 19,
-	MLX5DR_ACTION_MDFY_HW_FLD_FLEX_3	= 20,
-	MLX5DR_ACTION_MDFY_HW_FLD_L2_TNL_1	= 21,
-	MLX5DR_ACTION_MDFY_HW_FLD_METADATA	= 22,
-	MLX5DR_ACTION_MDFY_HW_FLD_RESERVED	= 23,
-};
-
-enum {
-	MLX5DR_ACTION_MDFY_HW_OP_COPY		= 0x1,
-	MLX5DR_ACTION_MDFY_HW_OP_SET		= 0x2,
-	MLX5DR_ACTION_MDFY_HW_OP_ADD		= 0x3,
-};
-
-enum {
-	MLX5DR_ACTION_MDFY_HW_HDR_L3_NONE	= 0x0,
-	MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV4	= 0x1,
-	MLX5DR_ACTION_MDFY_HW_HDR_L3_IPV6	= 0x2,
-};
-
-enum {
-	MLX5DR_ACTION_MDFY_HW_HDR_L4_NONE	= 0x0,
-	MLX5DR_ACTION_MDFY_HW_HDR_L4_TCP	= 0x1,
-	MLX5DR_ACTION_MDFY_HW_HDR_L4_UDP	= 0x2,
-};
-
 enum {
 	MLX5DR_STE_LU_TYPE_DONT_CARE			= 0x0f,
 };
-- 
2.26.2

