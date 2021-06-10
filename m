Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D453A2272
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhFJDAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229957AbhFJDAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 23:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C69686141D;
        Thu, 10 Jun 2021 02:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623293901;
        bh=wqUVz0wHRNAEuWibRjCSvtxJLf1DcvvPG5QTHkTgasU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=swhgrhhOlstfixQXhf8eIn9sojzAQJJgkyfoRl++NvQFKq42+nNXnlxDcKUNsETRF
         jAtMITKPssRlFDCDOqGDesOOsLstz0jaJ/0rtoofOJxszU1PTGdLon5OqpVEPsNEHK
         5oDxtGIYzQqlsWAlsolmba1Qv1QNMfvghpo6004WOT9r4u2KLno3KtU+Y129eCqqmg
         2CRwPsHINJwmYED7XQ9CYm0yk68J518tiK03ECqLPW8RtSb56E83xZQcoLZv+nMv5O
         hpH0b+3YD6DhpNIoRFnL+r80adhAFruF7Jmvn2ItMeh98H+fZ8iu9UT+MpXjPRnegF
         OPP7uqSMXli1w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/16] net/mlx5: DR, Added support for INSERT_HEADER reformat type
Date:   Wed,  9 Jun 2021 19:58:03 -0700
Message-Id: <20210610025814.274607-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610025814.274607-1-saeed@kernel.org>
References: <20210610025814.274607-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add support for INSERT_HEADER packet reformat context type

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 76 ++++++++++++++++---
 .../mellanox/mlx5/core/steering/dr_cmd.c      |  7 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   |  4 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 68 ++++++++++++++---
 .../mellanox/mlx5/core/steering/dr_types.h    | 17 ++++-
 .../mellanox/mlx5/core/steering/fs_dr.c       |  3 +
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  1 +
 7 files changed, 150 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 13fceba11d3f..de68c0ec2143 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -37,6 +37,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_TNL_L3_TO_L2]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 		},
@@ -48,6 +49,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 		},
@@ -66,6 +68,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 		},
 		[DR_ACTION_STATE_MODIFY_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -77,6 +80,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 		},
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -88,6 +92,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_TNL_L3_TO_L2]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 		},
@@ -102,6 +107,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 		},
@@ -116,6 +122,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 		},
 		[DR_ACTION_STATE_MODIFY_VLAN] = {
@@ -125,6 +132,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 		},
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -132,6 +140,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_NON_TERM,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 		},
@@ -148,6 +157,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_TNL_L3_TO_L2]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
@@ -161,6 +171,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 		},
 		[DR_ACTION_STATE_ENCAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -176,6 +187,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 		},
 		[DR_ACTION_STATE_MODIFY_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -186,6 +198,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 		},
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -195,6 +208,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_TNL_L3_TO_L2]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
@@ -211,6 +225,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 		},
@@ -226,6 +241,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 		},
@@ -236,6 +252,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 		},
 		[DR_ACTION_STATE_NON_TERM] = {
@@ -245,6 +262,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_MODIFY_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 		},
@@ -271,6 +289,9 @@ dr_action_reformat_to_action_type(enum mlx5dr_action_reformat_type reformat_type
 	case DR_ACTION_REFORMAT_TYP_L2_TO_TNL_L3:
 		*action_type = DR_ACTION_TYP_L2_TO_TNL_L3;
 		break;
+	case DR_ACTION_REFORMAT_TYP_INSERT_HDR:
+		*action_type = DR_ACTION_TYP_INSERT_HDR;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -495,8 +516,8 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 				mlx5dr_info(dmn, "Device doesn't support Encap on RX\n");
 				goto out_invalid_arg;
 			}
-			attr.reformat_size = action->reformat->reformat_size;
-			attr.reformat_id = action->reformat->reformat_id;
+			attr.reformat.size = action->reformat->size;
+			attr.reformat.id = action->reformat->id;
 			break;
 		case DR_ACTION_TYP_VPORT:
 			attr.hit_gvmi = action->vport->caps->vhca_gvmi;
@@ -522,6 +543,12 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 
 			attr.vlans.headers[attr.vlans.count++] = action->push_vlan->vlan_hdr;
 			break;
+		case DR_ACTION_TYP_INSERT_HDR:
+			attr.reformat.size = action->reformat->size;
+			attr.reformat.id = action->reformat->id;
+			attr.reformat.param_0 = action->reformat->param_0;
+			attr.reformat.param_1 = action->reformat->param_1;
+			break;
 		default:
 			goto out_invalid_arg;
 		}
@@ -584,6 +611,7 @@ static unsigned int action_size[DR_ACTION_TYP_MAX] = {
 	[DR_ACTION_TYP_MODIFY_HDR]   = sizeof(struct mlx5dr_action_rewrite),
 	[DR_ACTION_TYP_VPORT]        = sizeof(struct mlx5dr_action_vport),
 	[DR_ACTION_TYP_PUSH_VLAN]    = sizeof(struct mlx5dr_action_push_vlan),
+	[DR_ACTION_TYP_INSERT_HDR]   = sizeof(struct mlx5dr_action_reformat),
 };
 
 static struct mlx5dr_action *
@@ -692,7 +720,7 @@ mlx5dr_action_create_mult_dest_tbl(struct mlx5dr_domain *dmn,
 			if (reformat_action) {
 				reformat_req = true;
 				hw_dests[i].vport.reformat_id =
-					reformat_action->reformat->reformat_id;
+					reformat_action->reformat->id;
 				ref_actions[num_of_ref++] = reformat_action;
 				hw_dests[i].vport.flags |= MLX5_FLOW_DEST_VPORT_REFORMAT_ID;
 			}
@@ -799,11 +827,15 @@ struct mlx5dr_action *mlx5dr_action_create_tag(u32 tag_value)
 static int
 dr_action_verify_reformat_params(enum mlx5dr_action_type reformat_type,
 				 struct mlx5dr_domain *dmn,
+				 u8 reformat_param_0,
+				 u8 reformat_param_1,
 				 size_t data_sz,
 				 void *data)
 {
-	if ((!data && data_sz) || (data && !data_sz) || reformat_type >
-		DR_ACTION_TYP_L2_TO_TNL_L3) {
+	if ((!data && data_sz) || (data && !data_sz) ||
+	    ((reformat_param_0 || reformat_param_1) &&
+	     reformat_type != DR_ACTION_TYP_INSERT_HDR) ||
+	    reformat_type > DR_ACTION_TYP_INSERT_HDR) {
 		mlx5dr_dbg(dmn, "Invalid reformat parameter!\n");
 		goto out_err;
 	}
@@ -835,6 +867,7 @@ dr_action_verify_reformat_params(enum mlx5dr_action_type reformat_type,
 
 static int
 dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
+				 u8 reformat_param_0, u8 reformat_param_1,
 				 size_t data_sz, void *data,
 				 struct mlx5dr_action *action)
 {
@@ -852,13 +885,14 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 		else
 			rt = MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL;
 
-		ret = mlx5dr_cmd_create_reformat_ctx(dmn->mdev, rt, data_sz, data,
+		ret = mlx5dr_cmd_create_reformat_ctx(dmn->mdev, rt, 0, 0,
+						     data_sz, data,
 						     &reformat_id);
 		if (ret)
 			return ret;
 
-		action->reformat->reformat_id = reformat_id;
-		action->reformat->reformat_size = data_sz;
+		action->reformat->id = reformat_id;
+		action->reformat->size = data_sz;
 		return 0;
 	}
 	case DR_ACTION_TYP_TNL_L2_TO_L2:
@@ -900,6 +934,23 @@ dr_action_create_reformat_action(struct mlx5dr_domain *dmn,
 		}
 		return 0;
 	}
+	case DR_ACTION_TYP_INSERT_HDR:
+	{
+		ret = mlx5dr_cmd_create_reformat_ctx(dmn->mdev,
+						     MLX5_REFORMAT_TYPE_INSERT_HDR,
+						     reformat_param_0,
+						     reformat_param_1,
+						     data_sz, data,
+						     &reformat_id);
+		if (ret)
+			return ret;
+
+		action->reformat->id = reformat_id;
+		action->reformat->size = data_sz;
+		action->reformat->param_0 = reformat_param_0;
+		action->reformat->param_1 = reformat_param_1;
+		return 0;
+	}
 	default:
 		mlx5dr_info(dmn, "Reformat type is not supported %d\n", action->action_type);
 		return -EINVAL;
@@ -955,7 +1006,9 @@ mlx5dr_action_create_packet_reformat(struct mlx5dr_domain *dmn,
 		goto dec_ref;
 	}
 
-	ret = dr_action_verify_reformat_params(action_type, dmn, data_sz, data);
+	ret = dr_action_verify_reformat_params(action_type, dmn,
+					       reformat_param_0, reformat_param_1,
+					       data_sz, data);
 	if (ret)
 		goto dec_ref;
 
@@ -966,6 +1019,8 @@ mlx5dr_action_create_packet_reformat(struct mlx5dr_domain *dmn,
 	action->reformat->dmn = dmn;
 
 	ret = dr_action_create_reformat_action(dmn,
+					       reformat_param_0,
+					       reformat_param_1,
 					       data_sz,
 					       data,
 					       action);
@@ -1559,8 +1614,9 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action)
 		break;
 	case DR_ACTION_TYP_L2_TO_TNL_L2:
 	case DR_ACTION_TYP_L2_TO_TNL_L3:
+	case DR_ACTION_TYP_INSERT_HDR:
 		mlx5dr_cmd_destroy_reformat_ctx((action->reformat->dmn)->mdev,
-						action->reformat->reformat_id);
+						action->reformat->id);
 		refcount_dec(&action->reformat->dmn->refcount);
 		break;
 	case DR_ACTION_TYP_MODIFY_HDR:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 5970cb8fc0c0..6314f50efbd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -460,6 +460,8 @@ int mlx5dr_cmd_destroy_flow_table(struct mlx5_core_dev *mdev,
 
 int mlx5dr_cmd_create_reformat_ctx(struct mlx5_core_dev *mdev,
 				   enum mlx5_reformat_ctx_type rt,
+				   u8 reformat_param_0,
+				   u8 reformat_param_1,
 				   size_t reformat_size,
 				   void *reformat_data,
 				   u32 *reformat_id)
@@ -486,8 +488,11 @@ int mlx5dr_cmd_create_reformat_ctx(struct mlx5_core_dev *mdev,
 	pdata = MLX5_ADDR_OF(packet_reformat_context_in, prctx, reformat_data);
 
 	MLX5_SET(packet_reformat_context_in, prctx, reformat_type, rt);
+	MLX5_SET(packet_reformat_context_in, prctx, reformat_param_0, reformat_param_0);
+	MLX5_SET(packet_reformat_context_in, prctx, reformat_param_1, reformat_param_1);
 	MLX5_SET(packet_reformat_context_in, prctx, reformat_data_size, reformat_size);
-	memcpy(pdata, reformat_data, reformat_size);
+	if (reformat_data && reformat_size)
+		memcpy(pdata, reformat_data, reformat_size);
 
 	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 7e26a9e3afc7..f1950e4968da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -437,8 +437,8 @@ dr_ste_v0_set_actions_tx(struct mlx5dr_domain *dmn,
 						attr->gvmi);
 
 		dr_ste_v0_set_tx_encap(last_ste,
-				       attr->reformat_id,
-				       attr->reformat_size,
+				       attr->reformat.id,
+				       attr->reformat.size,
 				       action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3]);
 		/* Whenever prio_tag_required enabled, we can be sure that the
 		 * previous table (ACL) already push vlan to our packet,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index a5807d190698..b4dae628e716 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -374,6 +374,26 @@ static void dr_ste_v1_set_encap(u8 *hw_ste_p, u8 *d_action,
 	dr_ste_v1_set_reparse(hw_ste_p);
 }
 
+static void dr_ste_v1_set_insert_hdr(u8 *hw_ste_p, u8 *d_action,
+				     u32 reformat_id,
+				     u8 anchor, u8 offset,
+				     int size)
+{
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, d_action,
+		 action_id, DR_STE_V1_ACTION_ID_INSERT_POINTER);
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, d_action, start_anchor, anchor);
+
+	/* The hardware expects here size and offset in words (2 byte) */
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, d_action, size, size / 2);
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, d_action, start_offset, offset / 2);
+
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, d_action, pointer, reformat_id);
+	MLX5_SET(ste_double_action_insert_with_ptr_v1, d_action, attributes,
+		 DR_STE_V1_ACTION_INSERT_PTR_ATTR_NONE);
+
+	dr_ste_v1_set_reparse(hw_ste_p);
+}
+
 static void dr_ste_v1_set_tx_push_vlan(u8 *hw_ste_p, u8 *d_action,
 				       u32 vlan_hdr)
 {
@@ -520,8 +540,8 @@ static void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 			allow_encap = true;
 		}
 		dr_ste_v1_set_encap(last_ste, action,
-				    attr->reformat_id,
-				    attr->reformat_size);
+				    attr->reformat.id,
+				    attr->reformat.size);
 		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
 		action += DR_STE_ACTION_DOUBLE_SZ;
 	} else if (action_type_set[DR_ACTION_TYP_L2_TO_TNL_L3]) {
@@ -534,10 +554,23 @@ static void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 
 		dr_ste_v1_set_encap_l3(last_ste,
 				       action, d_action,
-				       attr->reformat_id,
-				       attr->reformat_size);
+				       attr->reformat.id,
+				       attr->reformat.size);
 		action_sz -= DR_STE_ACTION_TRIPLE_SZ;
 		action += DR_STE_ACTION_TRIPLE_SZ;
+	} else if (action_type_set[DR_ACTION_TYP_INSERT_HDR]) {
+		if (!allow_encap || action_sz < DR_STE_ACTION_DOUBLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+		}
+		dr_ste_v1_set_insert_hdr(last_ste, action,
+					 attr->reformat.id,
+					 attr->reformat.param_0,
+					 attr->reformat.param_1,
+					 attr->reformat.size);
+		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
+		action += DR_STE_ACTION_DOUBLE_SZ;
 	}
 
 	dr_ste_v1_set_hit_gvmi(last_ste, attr->hit_gvmi);
@@ -616,7 +649,9 @@ static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 	}
 
 	if (action_type_set[DR_ACTION_TYP_CTR]) {
-		/* Counter action set after decap to exclude decaped header */
+		/* Counter action set after decap and before insert_hdr
+		 * to exclude decaped / encaped header respectively.
+		 */
 		if (!allow_ctr) {
 			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
 			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
@@ -634,8 +669,8 @@ static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 			action_sz = DR_STE_ACTION_TRIPLE_SZ;
 		}
 		dr_ste_v1_set_encap(last_ste, action,
-				    attr->reformat_id,
-				    attr->reformat_size);
+				    attr->reformat.id,
+				    attr->reformat.size);
 		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
 		action += DR_STE_ACTION_DOUBLE_SZ;
 		allow_modify_hdr = false;
@@ -652,10 +687,25 @@ static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 
 		dr_ste_v1_set_encap_l3(last_ste,
 				       action, d_action,
-				       attr->reformat_id,
-				       attr->reformat_size);
+				       attr->reformat.id,
+				       attr->reformat.size);
 		action_sz -= DR_STE_ACTION_TRIPLE_SZ;
 		allow_modify_hdr = false;
+	} else if (action_type_set[DR_ACTION_TYP_INSERT_HDR]) {
+		/* Modify header, decap, and encap must use different STEs */
+		if (!allow_modify_hdr || action_sz < DR_STE_ACTION_DOUBLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes, attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1, last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+		}
+		dr_ste_v1_set_insert_hdr(last_ste, action,
+					 attr->reformat.id,
+					 attr->reformat.param_0,
+					 attr->reformat.param_1,
+					 attr->reformat.size);
+		action_sz -= DR_STE_ACTION_DOUBLE_SZ;
+		action += DR_STE_ACTION_DOUBLE_SZ;
+		allow_modify_hdr = false;
 	}
 
 	dr_ste_v1_set_hit_gvmi(last_ste, attr->hit_gvmi);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index b34018d49326..60b8c04e165e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -123,6 +123,7 @@ enum mlx5dr_action_type {
 	DR_ACTION_TYP_VPORT,
 	DR_ACTION_TYP_POP_VLAN,
 	DR_ACTION_TYP_PUSH_VLAN,
+	DR_ACTION_TYP_INSERT_HDR,
 	DR_ACTION_TYP_MAX,
 };
 
@@ -266,8 +267,12 @@ struct mlx5dr_ste_actions_attr {
 	u32	ctr_id;
 	u16	gvmi;
 	u16	hit_gvmi;
-	u32	reformat_id;
-	u32	reformat_size;
+	struct {
+		u32	id;
+		u32	size;
+		u8	param_0;
+		u8	param_1;
+	} reformat;
 	struct {
 		int	count;
 		u32	headers[MLX5DR_MAX_VLANS];
@@ -908,8 +913,10 @@ struct mlx5dr_action_rewrite {
 
 struct mlx5dr_action_reformat {
 	struct mlx5dr_domain *dmn;
-	u32 reformat_id;
-	u32 reformat_size;
+	u32 id;
+	u32 size;
+	u8 param_0;
+	u8 param_1;
 };
 
 struct mlx5dr_action_dest_tbl {
@@ -1147,6 +1154,8 @@ int mlx5dr_cmd_query_flow_table(struct mlx5_core_dev *dev,
 				struct mlx5dr_cmd_query_flow_table_details *output);
 int mlx5dr_cmd_create_reformat_ctx(struct mlx5_core_dev *mdev,
 				   enum mlx5_reformat_ctx_type rt,
+				   u8 reformat_param_0,
+				   u8 reformat_param_1,
 				   size_t reformat_size,
 				   void *reformat_data,
 				   u32 *reformat_id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index d866cd609d0b..00b4c753cae2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -543,6 +543,9 @@ static int mlx5_cmd_dr_packet_reformat_alloc(struct mlx5_flow_root_namespace *ns
 	case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
 		dr_reformat = DR_ACTION_REFORMAT_TYP_L2_TO_TNL_L3;
 		break;
+	case MLX5_REFORMAT_TYPE_INSERT_HDR:
+		dr_reformat = DR_ACTION_REFORMAT_TYP_INSERT_HDR;
+		break;
 	default:
 		mlx5_core_err(ns->dev, "Packet-reformat not supported(%d)\n",
 			      params->type);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 8d821bbe3309..0e2b73731117 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -26,6 +26,7 @@ enum mlx5dr_action_reformat_type {
 	DR_ACTION_REFORMAT_TYP_L2_TO_TNL_L2,
 	DR_ACTION_REFORMAT_TYP_TNL_L3_TO_L2,
 	DR_ACTION_REFORMAT_TYP_L2_TO_TNL_L3,
+	DR_ACTION_REFORMAT_TYP_INSERT_HDR,
 };
 
 struct mlx5dr_match_parameters {
-- 
2.31.1

