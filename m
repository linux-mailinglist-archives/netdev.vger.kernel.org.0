Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056F03F91A9
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244050AbhH0A72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244031AbhH0A7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B25FC60FD9;
        Fri, 27 Aug 2021 00:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025894;
        bh=R6189tT7iL6sRIFW8adKWk0J6DxoEgNvWNLQmazXs5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdglBp5B9eDbGHrxuYCHucyw560+YelwEnZZWoHvfwSHTd498rDnA/yz57kO076Ok
         zV7nZPP2a0VGKauqCscMM5EsGrlYNW/bCUUYpmAgoQaundfYyk/0fYWLRNJEGO2TWb
         5G9JEXPofVFGjWQVZGr7QR68axxn/u43kjG53nhLzwr0xImEchu08tKOj78YeXqdTW
         ffS3+f4QIM2Qrh0PPzBTJFp6RZiRWA5iRyF1eDcyq19bY4VSaJPG0YrVRnx6hLErg7
         lHGdYrHekeli3K59P/O70JLQtOn24I3SFm2qm1O4LbV9Kvn+noKA9C1FNVzfJxKL6O
         GdxwvxnoPIoLw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/17] net/mlx5: DR, Added support for REMOVE_HEADER packet reformat
Date:   Thu, 26 Aug 2021 17:57:46 -0700
Message-Id: <20210827005802.236119-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

ConnectX supports offloading of various encapsulations and decapsulations
(e.g. VXLAN), which are performed by 'Packet Reformat' action. Starting
with ConnectX-6 DX, a new reformat type is supported - REMOVE_HEADER, which
allows deleting an arbitrary size chunk at the selected position in the packet.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 57 ++++++++++++++++---
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 41 +++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    |  1 +
 .../mellanox/mlx5/core/steering/fs_dr.c       |  3 +
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  1 +
 5 files changed, 96 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 6475ba35cf6b..723f63aca157 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -39,6 +39,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 		},
@@ -99,6 +100,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 		},
@@ -115,9 +117,16 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 		},
+		[DR_ACTION_STATE_DECAP] = {
+			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_DECAP,
+		},
 		[DR_ACTION_STATE_ENCAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
@@ -152,6 +161,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 		},
@@ -170,6 +180,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
@@ -226,6 +237,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
@@ -244,9 +256,17 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 		},
+		[DR_ACTION_STATE_DECAP] = {
+			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_DECAP,
+			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
+		},
 		[DR_ACTION_STATE_ENCAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
@@ -285,6 +305,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 		},
@@ -314,6 +335,9 @@ dr_action_reformat_to_action_type(enum mlx5dr_action_reformat_type reformat_type
 	case DR_ACTION_REFORMAT_TYP_INSERT_HDR:
 		*action_type = DR_ACTION_TYP_INSERT_HDR;
 		break;
+	case DR_ACTION_REFORMAT_TYP_REMOVE_HDR:
+		*action_type = DR_ACTION_TYP_REMOVE_HDR;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -570,6 +594,7 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			attr.vlans.headers[attr.vlans.count++] = action->push_vlan->vlan_hdr;
 			break;
 		case DR_ACTION_TYP_INSERT_HDR:
+		case DR_ACTION_TYP_REMOVE_HDR:
 			attr.reformat.size = action->reformat->size;
 			attr.reformat.id = action->reformat->id;
 			attr.reformat.param_0 = action->reformat->param_0;
@@ -638,6 +663,7 @@ static unsigned int action_size[DR_ACTION_TYP_MAX] = {
 	[DR_ACTION_TYP_VPORT]        = sizeof(struct mlx5dr_action_vport),
 	[DR_ACTION_TYP_PUSH_VLAN]    = sizeof(struct mlx5dr_action_push_vlan),
 	[DR_ACTION_TYP_INSERT_HDR]   = sizeof(struct mlx5dr_action_reformat),
+	[DR_ACTION_TYP_REMOVE_HDR]   = sizeof(struct mlx5dr_action_reformat),
 	[DR_ACTION_TYP_SAMPLER]      = sizeof(struct mlx5dr_action_sampler),
 };
 
@@ -884,11 +910,23 @@ dr_action_verify_reformat_params(enum mlx5dr_action_type reformat_type,
 				 size_t data_sz,
 				 void *data)
 {
-	if ((!data && data_sz) || (data && !data_sz) ||
-	    ((reformat_param_0 || reformat_param_1) &&
-	     reformat_type != DR_ACTION_TYP_INSERT_HDR) ||
-	    reformat_type > DR_ACTION_TYP_INSERT_HDR) {
-		mlx5dr_dbg(dmn, "Invalid reformat parameter!\n");
+	if (reformat_type == DR_ACTION_TYP_INSERT_HDR) {
+		if ((!data && data_sz) || (data && !data_sz) ||
+		    MLX5_CAP_GEN_2(dmn->mdev, max_reformat_insert_size) < data_sz ||
+		    MLX5_CAP_GEN_2(dmn->mdev, max_reformat_insert_offset) < reformat_param_1) {
+			mlx5dr_dbg(dmn, "Invalid reformat parameters for INSERT_HDR\n");
+			goto out_err;
+		}
+	} else if (reformat_type == DR_ACTION_TYP_REMOVE_HDR) {
+		if (data ||
+		    MLX5_CAP_GEN_2(dmn->mdev, max_reformat_remove_size) < data_sz ||
+		    MLX5_CAP_GEN_2(dmn->mdev, max_reformat_remove_offset) < reformat_param_1) {
+			mlx5dr_dbg(dmn, "Invalid reformat parameters for REMOVE_HDR\n");
+			goto out_err;
+		}
+	} else if (reformat_param_0 || reformat_param_1 ||
+		   reformat_type > DR_ACTION_TYP_REMOVE_HDR) {
+		mlx5dr_dbg(dmn, "Invalid reformat parameters\n");
 		goto out_err;
 	}
 
@@ -987,7 +1025,6 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 		return 0;
 	}
 	case DR_ACTION_TYP_INSERT_HDR:
-	{
 		ret = mlx5dr_cmd_create_reformat_ctx(dmn->mdev,
 						     MLX5_REFORMAT_TYPE_INSERT_HDR,
 						     reformat_param_0,
@@ -1002,7 +1039,12 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 		action->reformat->param_0 = reformat_param_0;
 		action->reformat->param_1 = reformat_param_1;
 		return 0;
-	}
+	case DR_ACTION_TYP_REMOVE_HDR:
+		action->reformat->id = 0;
+		action->reformat->size = data_sz;
+		action->reformat->param_0 = reformat_param_0;
+		action->reformat->param_1 = reformat_param_1;
+		return 0;
 	default:
 		mlx5dr_info(dmn, "Reformat type is not supported %d\n", action->action_type);
 		return -EINVAL;
@@ -1658,6 +1700,7 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action)
 		}
 		break;
 	case DR_ACTION_TYP_TNL_L2_TO_L2:
+	case DR_ACTION_TYP_REMOVE_HDR:
 		refcount_dec(&action->reformat->dmn->refcount);
 		break;
 	case DR_ACTION_TYP_TNL_L3_TO_L2:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 4aaca8eb7597..3c5bd80e18ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -402,6 +402,21 @@ static void dr_ste_v1_set_insert_hdr(u8 *hw_ste_p, u8 *d_action,
 	dr_ste_v1_set_reparse(hw_ste_p);
 }
 
+static void dr_ste_v1_set_remove_hdr(u8 *hw_ste_p, u8 *s_action,
+				     u8 anchor, u8 offset,
+				     int size)
+{
+	MLX5_SET(ste_single_action_remove_header_size_v1, s_action,
+		 action_id, DR_STE_V1_ACTION_ID_REMOVE_BY_SIZE);
+	MLX5_SET(ste_single_action_remove_header_size_v1, s_action, start_anchor, anchor);
+
+	/* The hardware expects here size and offset in words (2 byte) */
+	MLX5_SET(ste_single_action_remove_header_size_v1, s_action, remove_size, size / 2);
+	MLX5_SET(ste_single_action_remove_header_size_v1, s_action, start_offset, offset / 2);
+
+	dr_ste_v1_set_reparse(hw_ste_p);
+}
+
 static void dr_ste_v1_set_tx_push_vlan(u8 *hw_ste_p, u8 *d_action,
 				       u32 vlan_hdr)
 {
@@ -579,6 +594,18 @@ static void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 					 attr->reformat.size);
 		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
 		action += DR_STE_ACTION_DOUBLE_SZ;
+	} else if (action_type_set[DR_ACTION_TYP_REMOVE_HDR]) {
+		if (action_sz < DR_STE_ACTION_SINGLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+		}
+		dr_ste_v1_set_remove_hdr(last_ste, action,
+					 attr->reformat.param_0,
+					 attr->reformat.param_1,
+					 attr->reformat.size);
+		action_sz -= DR_STE_ACTION_SINGLE_SZ;
+		action += DR_STE_ACTION_SINGLE_SZ;
 	}
 
 	dr_ste_v1_set_hit_gvmi(last_ste, attr->hit_gvmi);
@@ -714,6 +741,20 @@ static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
 		action += DR_STE_ACTION_DOUBLE_SZ;
 		allow_modify_hdr = false;
+	} else if (action_type_set[DR_ACTION_TYP_REMOVE_HDR]) {
+		if (action_sz < DR_STE_ACTION_SINGLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+			allow_modify_hdr = true;
+			allow_ctr = true;
+		}
+		dr_ste_v1_set_remove_hdr(last_ste, action,
+					 attr->reformat.param_0,
+					 attr->reformat.param_1,
+					 attr->reformat.size);
+		action_sz -= DR_STE_ACTION_SINGLE_SZ;
+		action += DR_STE_ACTION_SINGLE_SZ;
 	}
 
 	dr_ste_v1_set_hit_gvmi(last_ste, attr->hit_gvmi);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index f5e93fa87aff..2f1f75ab8a34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -124,6 +124,7 @@ enum mlx5dr_action_type {
 	DR_ACTION_TYP_POP_VLAN,
 	DR_ACTION_TYP_PUSH_VLAN,
 	DR_ACTION_TYP_INSERT_HDR,
+	DR_ACTION_TYP_REMOVE_HDR,
 	DR_ACTION_TYP_SAMPLER,
 	DR_ACTION_TYP_MAX,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index d5926dd7e972..7bfcb3456cf2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -557,6 +557,9 @@ static int mlx5_cmd_dr_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns
 	case MLX5_REFORMAT_TYPE_INSERT_HDR:
 		dr_reformat = DR_ACTION_REFORMAT_TYP_INSERT_HDR;
 		break;
+	case MLX5_REFORMAT_TYPE_REMOVE_HDR:
+		dr_reformat = DR_ACTION_REFORMAT_TYP_REMOVE_HDR;
+		break;
 	default:
 		mlx5_core_err(ns->dev, "Packet-reformat not supported(%d)\n",
 			      params->type);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index bbfe101d4e57..fee37fa01368 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -27,6 +27,7 @@ enum mlx5dr_action_reformat_type {
 	DR_ACTION_REFORMAT_TYP_TNL_L3_TO_L2,
 	DR_ACTION_REFORMAT_TYP_L2_TO_TNL_L3,
 	DR_ACTION_REFORMAT_TYP_INSERT_HDR,
+	DR_ACTION_REFORMAT_TYP_REMOVE_HDR,
 };
 
 struct mlx5dr_match_parameters {
-- 
2.31.1

