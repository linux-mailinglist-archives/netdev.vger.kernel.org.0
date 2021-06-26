Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97ED3B4D7A
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 09:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhFZHrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 03:47:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhFZHrF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 03:47:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EFC76191B;
        Sat, 26 Jun 2021 07:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624693483;
        bh=lcbHIWDQCYEnYoQQ8xwoWdVdZkM3X7Ys4EntH3dZ8aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvz/ls/sF7NzDE6ar26LiRKcxXPXoAb2N9tMl8MSj5WrlaRmle2Xka9RtmVf34v/8
         6MhA+voR/bpRz1Bmxi1gg28Qanm+XZiHeczqaPaXmjLUUzKVwsCohHJBMPehPaljgF
         z9QOUqO4+rZnWq34HcA1iMWxQvBqiivsENthx8Ol6crsSQZsJuwR4x12s9ddGHpeE5
         70so8hs4VtKDa7K0fu+5W1XFt0L/cSG+ZvVNntJib6Wj+JtFVVcqm1UFEL2aNgVGc/
         o2rb0TxPRnCPeANMtDp4gnQQuM6AfqhDiqftQuHZjTtdVz47dqISMbEB94S3JduVA8
         lOGCHMunXfkYA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 2/6] net/mlx5: DR, Add support for flow sampler offload
Date:   Sat, 26 Jun 2021 00:44:13 -0700
Message-Id: <20210626074417.714833-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210626074417.714833-1-saeed@kernel.org>
References: <20210626074417.714833-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add SW steering support for sFlow / flow sampler action.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 55 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_cmd.c      | 33 +++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h    | 14 +++++
 .../mellanox/mlx5/core/steering/fs_dr.c       | 17 +++++-
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  3 +
 include/linux/mlx5/mlx5_ifc.h                 |  5 ++
 6 files changed, 124 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index de68c0ec2143..6475ba35cf6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -31,6 +31,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_TNL_L2_TO_L2]	= DR_ACTION_STATE_DECAP,
@@ -45,6 +46,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
@@ -57,6 +59,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
 		},
@@ -64,6 +67,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
@@ -74,6 +78,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
@@ -86,6 +91,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_TNL_L2_TO_L2]	= DR_ACTION_STATE_DECAP,
@@ -104,6 +110,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_NO_ACTION] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
@@ -114,11 +121,13 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_ENCAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
 		},
 		[DR_ACTION_STATE_MODIFY_HDR] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
@@ -128,6 +137,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_MODIFY_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
@@ -137,6 +147,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
@@ -152,6 +163,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_NO_ACTION] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_TNL_L2_TO_L2]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_TNL_L3_TO_L2]	= DR_ACTION_STATE_DECAP,
@@ -166,6 +178,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_DECAP,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
@@ -178,11 +191,13 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
 		},
 		[DR_ACTION_STATE_MODIFY_HDR] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
@@ -192,6 +207,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_MODIFY_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
@@ -203,6 +219,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_TNL_L2_TO_L2]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_TNL_L3_TO_L2]	= DR_ACTION_STATE_DECAP,
@@ -221,6 +238,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_NO_ACTION] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
@@ -233,11 +251,13 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 		},
 		[DR_ACTION_STATE_MODIFY_HDR] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
@@ -248,6 +268,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_MODIFY_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
@@ -258,6 +279,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
@@ -519,6 +541,10 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			attr.reformat.size = action->reformat->size;
 			attr.reformat.id = action->reformat->id;
 			break;
+		case DR_ACTION_TYP_SAMPLER:
+			attr.final_icm_addr = rx_rule ? action->sampler->rx_icm_addr :
+							action->sampler->tx_icm_addr;
+			break;
 		case DR_ACTION_TYP_VPORT:
 			attr.hit_gvmi = action->vport->caps->vhca_gvmi;
 			dest_action = action;
@@ -612,6 +638,7 @@ static unsigned int action_size[DR_ACTION_TYP_MAX] = {
 	[DR_ACTION_TYP_VPORT]        = sizeof(struct mlx5dr_action_vport),
 	[DR_ACTION_TYP_PUSH_VLAN]    = sizeof(struct mlx5dr_action_push_vlan),
 	[DR_ACTION_TYP_INSERT_HDR]   = sizeof(struct mlx5dr_action_reformat),
+	[DR_ACTION_TYP_SAMPLER]      = sizeof(struct mlx5dr_action_sampler),
 };
 
 static struct mlx5dr_action *
@@ -824,6 +851,31 @@ struct mlx5dr_action *mlx5dr_action_create_tag(u32 tag_value)
 	return action;
 }
 
+struct mlx5dr_action *
+mlx5dr_action_create_flow_sampler(struct mlx5dr_domain *dmn, u32 sampler_id)
+{
+	struct mlx5dr_action *action;
+	u64 icm_rx, icm_tx;
+	int ret;
+
+	ret = mlx5dr_cmd_query_flow_sampler(dmn->mdev, sampler_id,
+					    &icm_rx, &icm_tx);
+	if (ret)
+		return NULL;
+
+	action = dr_action_create_generic(DR_ACTION_TYP_SAMPLER);
+	if (!action)
+		return NULL;
+
+	action->sampler->dmn = dmn;
+	action->sampler->sampler_id = sampler_id;
+	action->sampler->rx_icm_addr = icm_rx;
+	action->sampler->tx_icm_addr = icm_tx;
+
+	refcount_inc(&dmn->refcount);
+	return action;
+}
+
 static int
 dr_action_verify_reformat_params(enum mlx5dr_action_type reformat_type,
 				 struct mlx5dr_domain *dmn,
@@ -1624,6 +1676,9 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action)
 		kfree(action->rewrite->data);
 		refcount_dec(&action->rewrite->dmn->refcount);
 		break;
+	case DR_ACTION_TYP_SAMPLER:
+		refcount_dec(&action->sampler->dmn->refcount);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 6314f50efbd4..54e1f5438bbe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -228,6 +228,36 @@ int mlx5dr_cmd_query_flow_table(struct mlx5_core_dev *dev,
 	return 0;
 }
 
+int mlx5dr_cmd_query_flow_sampler(struct mlx5_core_dev *dev,
+				  u32 sampler_id,
+				  u64 *rx_icm_addr,
+				  u64 *tx_icm_addr)
+{
+	u32 out[MLX5_ST_SZ_DW(query_sampler_obj_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(general_obj_in_cmd_hdr)] = {};
+	void *attr;
+	int ret;
+
+	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
+		 MLX5_CMD_OP_QUERY_GENERAL_OBJECT);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
+		 MLX5_GENERAL_OBJECT_TYPES_SAMPLER);
+	MLX5_SET(general_obj_in_cmd_hdr, in, obj_id, sampler_id);
+
+	ret = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	if (ret)
+		return ret;
+
+	attr = MLX5_ADDR_OF(query_sampler_obj_out, out, sampler_object);
+
+	*rx_icm_addr = MLX5_GET64(sampler_obj, attr,
+				  sw_steering_icm_address_rx);
+	*tx_icm_addr = MLX5_GET64(sampler_obj, attr,
+				  sw_steering_icm_address_tx);
+
+	return 0;
+}
+
 int mlx5dr_cmd_sync_steering(struct mlx5_core_dev *mdev)
 {
 	u32 in[MLX5_ST_SZ_DW(sync_steering_in)] = {};
@@ -711,6 +741,9 @@ int mlx5dr_cmd_set_fte(struct mlx5_core_dev *dev,
 						 fte->dest_arr[i].vport.reformat_id);
 				}
 				break;
+			case MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER:
+				id = fte->dest_arr[i].sampler_id;
+				break;
 			default:
 				id = fte->dest_arr[i].tir_num;
 			}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 60b8c04e165e..f5e93fa87aff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -124,6 +124,7 @@ enum mlx5dr_action_type {
 	DR_ACTION_TYP_POP_VLAN,
 	DR_ACTION_TYP_PUSH_VLAN,
 	DR_ACTION_TYP_INSERT_HDR,
+	DR_ACTION_TYP_SAMPLER,
 	DR_ACTION_TYP_MAX,
 };
 
@@ -919,6 +920,13 @@ struct mlx5dr_action_reformat {
 	u8 param_1;
 };
 
+struct mlx5dr_action_sampler {
+	struct mlx5dr_domain *dmn;
+	u64 rx_icm_addr;
+	u64 tx_icm_addr;
+	u32 sampler_id;
+};
+
 struct mlx5dr_action_dest_tbl {
 	u8 is_fw_tbl:1;
 	union {
@@ -962,6 +970,7 @@ struct mlx5dr_action {
 		void *data;
 		struct mlx5dr_action_rewrite *rewrite;
 		struct mlx5dr_action_reformat *reformat;
+		struct mlx5dr_action_sampler *sampler;
 		struct mlx5dr_action_dest_tbl *dest_tbl;
 		struct mlx5dr_action_ctr *ctr;
 		struct mlx5dr_action_vport *vport;
@@ -1116,6 +1125,10 @@ int mlx5dr_cmd_query_gvmi(struct mlx5_core_dev *mdev,
 			  bool other_vport, u16 vport_number, u16 *gvmi);
 int mlx5dr_cmd_query_esw_caps(struct mlx5_core_dev *mdev,
 			      struct mlx5dr_esw_caps *caps);
+int mlx5dr_cmd_query_flow_sampler(struct mlx5_core_dev *dev,
+				  u32 sampler_id,
+				  u64 *rx_icm_addr,
+				  u64 *tx_icm_addr);
 int mlx5dr_cmd_sync_steering(struct mlx5_core_dev *mdev);
 int mlx5dr_cmd_set_fte_modify_and_vport(struct mlx5_core_dev *mdev,
 					u32 table_type,
@@ -1303,6 +1316,7 @@ struct mlx5dr_cmd_flow_destination_hw_info {
 		u32 ft_num;
 		u32 ft_id;
 		u32 counter_id;
+		u32 sampler_id;
 		struct {
 			u16 num;
 			u16 vhca_id;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 00b4c753cae2..d5926dd7e972 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -387,7 +387,7 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
 		list_for_each_entry(dst, &fte->node.children, node.list) {
 			enum mlx5_flow_destination_type type = dst->dest_attr.type;
-			u32 ft_id;
+			u32 id;
 
 			if (num_actions == MLX5_FLOW_CONTEXT_ACTION_MAX ||
 			    num_term_actions >= MLX5_FLOW_CONTEXT_ACTION_MAX) {
@@ -425,9 +425,20 @@ static int mlx5_cmd_dr_create_fte(struct mlx5_flow_root_namespace *ns,
 				num_term_actions++;
 				break;
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM:
-				ft_id = dst->dest_attr.ft_num;
+				id = dst->dest_attr.ft_num;
 				tmp_action = mlx5dr_action_create_dest_table_num(domain,
-										 ft_id);
+										 id);
+				if (!tmp_action) {
+					err = -ENOMEM;
+					goto free_actions;
+				}
+				fs_dr_actions[fs_dr_num_actions++] = tmp_action;
+				term_actions[num_term_actions++].dest = tmp_action;
+				break;
+			case MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER:
+				id = dst->dest_attr.sampler_id;
+				tmp_action = mlx5dr_action_create_flow_sampler(domain,
+									       id);
 				if (!tmp_action) {
 					err = -ENOMEM;
 					goto free_actions;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index b2aa6c93c3a1..bbfe101d4e57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -100,6 +100,9 @@ struct mlx5dr_action *mlx5dr_action_create_drop(void);
 
 struct mlx5dr_action *mlx5dr_action_create_tag(u32 tag_value);
 
+struct mlx5dr_action *
+mlx5dr_action_create_flow_sampler(struct mlx5dr_domain *dmn, u32 sampler_id);
+
 struct mlx5dr_action *
 mlx5dr_action_create_flow_counter(u32 counter_id);
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 2d1ed78289ff..e32a0d61929b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11083,6 +11083,11 @@ struct mlx5_ifc_create_sampler_obj_in_bits {
 	struct mlx5_ifc_sampler_obj_bits sampler_object;
 };
 
+struct mlx5_ifc_query_sampler_obj_out_bits {
+	struct mlx5_ifc_general_obj_out_cmd_hdr_bits general_obj_out_cmd_hdr;
+	struct mlx5_ifc_sampler_obj_bits sampler_object;
+};
+
 enum {
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_128 = 0x0,
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_256 = 0x1,
-- 
2.31.1

