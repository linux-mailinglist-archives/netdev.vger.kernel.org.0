Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBB63F860E
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242057AbhHZLEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241983AbhHZLEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 07:04:22 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED2DC0612A6;
        Thu, 26 Aug 2021 04:03:35 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s11so2722199pgr.11;
        Thu, 26 Aug 2021 04:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jE0c8w2D14yLBkd6fnDZwzC11wjJI2M6zzsF5Zja4T8=;
        b=gb1p7+2nezB4q4qvxbCe0fmMZcaIzCp7LsW105XeDU93ztgveifSjJ2osysPYLuZpm
         J3QSdp5UsM0roUR7YVUDoS5DYSObT8fpizdprWqLK2pdrPQRa6HhadtQucwamkfQcnkk
         OfcRUtd9qAbNltMnSHBXRzsBy4jl59jm5a/e8drf5w+VjgUf0lJBXh+003j4evDwQ2xf
         f6ZY37hQ1UBP56uF4r1Vre+MJrqxmhAyDi4hnP4JrD6ScOKRR84RYJqTr5I97lmvNz04
         Aa/vs2T8ZfWycTo/7lexV5dGuQqvh7+dckBtJ8wg50+293nCAFdKYmS1YjHzMtwFmEBV
         00tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jE0c8w2D14yLBkd6fnDZwzC11wjJI2M6zzsF5Zja4T8=;
        b=BRUrGINLYyPKS2p/eJItxz28KIncHe7tA3slSmuL6gH1KbwE9xUfNkQR6CwUNs9wnq
         5hDsFkBRiyeNduqtoMuYJnA62sv9JNNIKiU5VioloUMjW43+jklFN1XJRPnm2+VDNhFD
         Fg7nQ3GtzHVEhd0Aqex1qGJWbplxS64xHNcyaYe0kZmoaWmoYoaEKWjSiOzn1xW1VcYM
         eTRBf6qEpgLvGcHHXdiHVftZiUc92MMWeZ7NZ9NHA82Cz2OwKTf/LU1LHsq/Np2W6fg6
         dL/bslLxinyf2f6WFcSb5GNOGXADm53rbX4GloNpLnNTggRQI3h4SR/Eq1v455W5t1Cd
         cVfQ==
X-Gm-Message-State: AOAM533VDt17nM4oj7rpP4fNkhd0DW66rdMlZJaezW/LjUWSGdcDM1cm
        LythGFmwuDyRweBOQEP3Lf0=
X-Google-Smtp-Source: ABdhPJyhiOD54K79m4D2HScz7WT43sJB4E5yIwn6zRRkZn3wt4/YKNaPIa5x4h+gGnGcl15H9wVcXA==
X-Received: by 2002:a65:62c4:: with SMTP id m4mr2883326pgv.453.1629975814495;
        Thu, 26 Aug 2021 04:03:34 -0700 (PDT)
Received: from arn.com ([49.206.7.248])
        by smtp.googlemail.com with ESMTPSA id n24sm3106018pgv.60.2021.08.26.04.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 04:03:34 -0700 (PDT)
From:   Abhiram R N <abhiramrn@gmail.com>
To:     saeedm@nvidia.com
Cc:     abhiramrn@gmail.com, hakhande@redhat.com, arn@redhat.com,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5e: Add extack msgs related to TC for better debug
Date:   Thu, 26 Aug 2021 16:32:53 +0530
Message-Id: <20210826110253.311456-1-abhiramrn@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As multiple places EOPNOTSUPP and EINVAL is returned from driver
it becomes difficult to understand the reason only with error code.
With the netlink extack message exact reason will be known and will
aid in debugging.

Signed-off-by: Abhiram R N <abhiramrn@gmail.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 121 +++++++++++++-----
 1 file changed, 87 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d273758255c3..87faffda388d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1894,8 +1894,10 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 	bool needs_mapping, sets_mapping;
 	int err;
 
-	if (!mlx5e_is_eswitch_flow(flow))
+	if (!mlx5e_is_eswitch_flow(flow)) {
+		NL_SET_ERR_MSG_MOD(extack, "Not an eswitch Flow");
 		return -EOPNOTSUPP;
+	}
 
 	needs_mapping = !!flow->attr->chain;
 	sets_mapping = !flow->attr->chain && flow_has_tc_fwd_action(f);
@@ -2267,8 +2269,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		addr_type = match.key->addr_type;
 
 		/* the HW doesn't support frag first/later */
-		if (match.mask->flags & FLOW_DIS_FIRST_FRAG)
+		if (match.mask->flags & FLOW_DIS_FIRST_FRAG) {
+			NL_SET_ERR_MSG_MOD(extack, "HW doesn't support frag first/later");
 			return -EOPNOTSUPP;
+		}
 
 		if (match.mask->flags & FLOW_DIS_IS_FRAGMENT) {
 			MLX5_SET(fte_match_set_lyr_2_4, headers_c, frag, 1);
@@ -2435,8 +2439,11 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		switch (ip_proto) {
 		case IPPROTO_ICMP:
 			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
-			      MLX5_FLEX_PROTO_ICMP))
+			      MLX5_FLEX_PROTO_ICMP)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Match on Flex protocols for ICMP not supported");
 				return -EOPNOTSUPP;
+			}
 			MLX5_SET(fte_match_set_misc3, misc_c_3, icmp_type,
 				 match.mask->type);
 			MLX5_SET(fte_match_set_misc3, misc_v_3, icmp_type,
@@ -2448,8 +2455,11 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 			break;
 		case IPPROTO_ICMPV6:
 			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
-			      MLX5_FLEX_PROTO_ICMPV6))
+			      MLX5_FLEX_PROTO_ICMPV6)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Match on Flex protocols for ICMPV6 not supported");
 				return -EOPNOTSUPP;
+			}
 			MLX5_SET(fte_match_set_misc3, misc_c_3, icmpv6_type,
 				 match.mask->type);
 			MLX5_SET(fte_match_set_misc3, misc_v_3, icmpv6_type,
@@ -2555,15 +2565,19 @@ static int pedit_header_offsets[] = {
 #define pedit_header(_ph, _htype) ((void *)(_ph) + pedit_header_offsets[_htype])
 
 static int set_pedit_val(u8 hdr_type, u32 mask, u32 val, u32 offset,
-			 struct pedit_headers_action *hdrs)
+			 struct pedit_headers_action *hdrs,
+			 struct netlink_ext_ack *extack)
 {
 	u32 *curr_pmask, *curr_pval;
 
 	curr_pmask = (u32 *)(pedit_header(&hdrs->masks, hdr_type) + offset);
 	curr_pval  = (u32 *)(pedit_header(&hdrs->vals, hdr_type) + offset);
 
-	if (*curr_pmask & mask)  /* disallow acting twice on the same location */
+	if (*curr_pmask & mask) {  /* disallow acting twice on the same location */
+		NL_SET_ERR_MSG_MOD(extack,
+				   "curr_pmask and new mask same. Acting twice on same location");
 		goto out_err;
+	}
 
 	*curr_pmask |= mask;
 	*curr_pval  |= (val & mask);
@@ -2893,7 +2907,7 @@ parse_pedit_to_modify_hdr(struct mlx5e_priv *priv,
 	val = act->mangle.val;
 	offset = act->mangle.offset;
 
-	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd]);
+	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd], extack);
 	if (err)
 		goto out_err;
 
@@ -2913,8 +2927,10 @@ parse_pedit_to_reformat(struct mlx5e_priv *priv,
 	u32 mask, val, offset;
 	u32 *p;
 
-	if (act->id != FLOW_ACTION_MANGLE)
+	if (act->id != FLOW_ACTION_MANGLE) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported action id");
 		return -EOPNOTSUPP;
+	}
 
 	if (act->mangle.htype != FLOW_ACT_MANGLE_HDR_TYPE_ETH) {
 		NL_SET_ERR_MSG_MOD(extack, "Only Ethernet modification is supported");
@@ -3363,12 +3379,16 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 	u32 action = 0;
 	int err, i;
 
-	if (!flow_action_has_entries(flow_action))
+	if (!flow_action_has_entries(flow_action)) {
+		NL_SET_ERR_MSG_MOD(extack, "Flow Action doesn't have any entries");
 		return -EINVAL;
+	}
 
 	if (!flow_action_hw_stats_check(flow_action, extack,
-					FLOW_ACTION_HW_STATS_DELAYED_BIT))
+					FLOW_ACTION_HW_STATS_DELAYED_BIT)) {
+		NL_SET_ERR_MSG_MOD(extack, "Flow Action HW stats check not supported");
 		return -EOPNOTSUPP;
+	}
 
 	nic_attr = attr->nic_attr;
 
@@ -3409,7 +3429,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 						   act->csum_flags,
 						   extack))
 				break;
-
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Flow Action CSUM offload not supported in NIC actions");
 			return -EOPNOTSUPP;
 		case FLOW_ACTION_REDIRECT: {
 			struct net_device *peer_dev = act->dev;
@@ -3459,7 +3480,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 			flow_flag_set(flow, CT);
 			break;
 		default:
-			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
+			NL_SET_ERR_MSG_MOD(extack,
+					   "The offload action is not supported in NIC actions");
 			return -EOPNOTSUPP;
 		}
 	}
@@ -3492,8 +3514,11 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
-	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
+	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Action Match not supported for the flow in NIC actions");
 		return -EOPNOTSUPP;
+	}
 
 	return 0;
 }
@@ -3514,19 +3539,25 @@ static bool is_merged_eswitch_vfs(struct mlx5e_priv *priv,
 static int parse_tc_vlan_action(struct mlx5e_priv *priv,
 				const struct flow_action_entry *act,
 				struct mlx5_esw_flow_attr *attr,
-				u32 *action)
+				u32 *action,
+				struct netlink_ext_ack *extack)
 {
 	u8 vlan_idx = attr->total_vlan;
 
-	if (vlan_idx >= MLX5_FS_VLAN_DEPTH)
+	if (vlan_idx >= MLX5_FS_VLAN_DEPTH) {
+		NL_SET_ERR_MSG_MOD(extack, "VLAN IDs greater than supported");
 		return -EOPNOTSUPP;
+	}
 
 	switch (act->id) {
 	case FLOW_ACTION_VLAN_POP:
 		if (vlan_idx) {
 			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
-								 MLX5_FS_VLAN_DEPTH))
+								 MLX5_FS_VLAN_DEPTH)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "ESWITCH VLAN POP action requested is not supported");
 				return -EOPNOTSUPP;
+			}
 
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2;
 		} else {
@@ -3542,20 +3573,27 @@ static int parse_tc_vlan_action(struct mlx5e_priv *priv,
 
 		if (vlan_idx) {
 			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
-								 MLX5_FS_VLAN_DEPTH))
+								 MLX5_FS_VLAN_DEPTH)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "ESWITCH VLAN PUSH action requested is not supported");
 				return -EOPNOTSUPP;
+			}
 
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2;
 		} else {
 			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev, 1) &&
 			    (act->vlan.proto != htons(ETH_P_8021Q) ||
-			     act->vlan.prio))
+			     act->vlan.prio)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "ESWITCH VLAN PUSH act for vlan proto requested is not supported");
 				return -EOPNOTSUPP;
+			}
 
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
 		}
 		break;
 	default:
+		NL_SET_ERR_MSG_MOD(extack, "Unexpected action id for VLAN");
 		return -EINVAL;
 	}
 
@@ -3589,7 +3627,8 @@ static struct net_device *get_fdb_out_dev(struct net_device *uplink_dev,
 static int add_vlan_push_action(struct mlx5e_priv *priv,
 				struct mlx5_flow_attr *attr,
 				struct net_device **out_dev,
-				u32 *action)
+				u32 *action,
+				struct netlink_ext_ack *extack)
 {
 	struct net_device *vlan_dev = *out_dev;
 	struct flow_action_entry vlan_act = {
@@ -3600,7 +3639,7 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
 	};
 	int err;
 
-	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
+	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
 	if (err)
 		return err;
 
@@ -3611,14 +3650,15 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
 		return -ENODEV;
 
 	if (is_vlan_dev(*out_dev))
-		err = add_vlan_push_action(priv, attr, out_dev, action);
+		err = add_vlan_push_action(priv, attr, out_dev, action, extack);
 
 	return err;
 }
 
 static int add_vlan_pop_action(struct mlx5e_priv *priv,
 			       struct mlx5_flow_attr *attr,
-			       u32 *action)
+			       u32 *action,
+			       struct netlink_ext_ack *extack)
 {
 	struct flow_action_entry vlan_act = {
 		.id = FLOW_ACTION_VLAN_POP,
@@ -3628,7 +3668,7 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
 	nest_level = attr->parse_attr->filter_dev->lower_level -
 						priv->netdev->lower_level;
 	while (nest_level--) {
-		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
+		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
 		if (err)
 			return err;
 	}
@@ -3751,12 +3791,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	int err, i, if_count = 0;
 	bool mpls_push = false;
 
-	if (!flow_action_has_entries(flow_action))
+	if (!flow_action_has_entries(flow_action)) {
+		NL_SET_ERR_MSG_MOD(extack, "Flow action doesn't have any entries");
 		return -EINVAL;
+	}
 
 	if (!flow_action_hw_stats_check(flow_action, extack,
-					FLOW_ACTION_HW_STATS_DELAYED_BIT))
+					FLOW_ACTION_HW_STATS_DELAYED_BIT)) {
+		NL_SET_ERR_MSG_MOD(extack, "Flow Action HW stats check is not supported");
 		return -EOPNOTSUPP;
+	}
 
 	esw_attr = attr->esw_attr;
 	parse_attr = attr->parse_attr;
@@ -3824,7 +3868,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			if (csum_offload_supported(priv, action,
 						   act->csum_flags, extack))
 				break;
-
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Flow Action CSUM Offload not supported in FDB action");
 			return -EOPNOTSUPP;
 		case FLOW_ACTION_REDIRECT:
 		case FLOW_ACTION_MIRRED: {
@@ -3887,8 +3932,11 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 								out_dev,
 								ifindexes,
 								if_count,
-								extack))
+								extack)) {
+					NL_SET_ERR_MSG_MOD(extack,
+							   "Duplicated output device not supported");
 					return -EOPNOTSUPP;
+				}
 
 				ifindexes[if_count] = out_dev->ifindex;
 				if_count++;
@@ -3900,14 +3948,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				if (is_vlan_dev(out_dev)) {
 					err = add_vlan_push_action(priv, attr,
 								   &out_dev,
-								   &action);
+								   &action, extack);
 					if (err)
 						return err;
 				}
 
 				if (is_vlan_dev(parse_attr->filter_dev)) {
 					err = add_vlan_pop_action(priv, attr,
-								  &action);
+								  &action, extack);
 					if (err)
 						return err;
 				}
@@ -3953,10 +4001,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			break;
 		case FLOW_ACTION_TUNNEL_ENCAP:
 			info = act->tunnel;
-			if (info)
+			if (info) {
 				encap = true;
-			else
+			} else {
+				NL_SET_ERR_MSG_MOD(extack, "Non-zero tunnel value not set");
 				return -EOPNOTSUPP;
+			}
 
 			break;
 		case FLOW_ACTION_VLAN_PUSH:
@@ -3970,7 +4020,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 							      act, parse_attr, hdrs,
 							      &action, extack);
 			} else {
-				err = parse_tc_vlan_action(priv, act, esw_attr, &action);
+				err = parse_tc_vlan_action(priv, act, esw_attr, &action, extack);
 			}
 			if (err)
 				return err;
@@ -4023,7 +4073,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			flow_flag_set(flow, SAMPLE);
 			break;
 		default:
-			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
+			NL_SET_ERR_MSG_MOD(extack,
+					   "The offload action is not supported in FDB action");
 			return -EOPNOTSUPP;
 		}
 	}
@@ -4731,8 +4782,10 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (!flow_action_basic_hw_stats_check(flow_action, extack))
+	if (!flow_action_basic_hw_stats_check(flow_action, extack)) {
+		NL_SET_ERR_MSG_MOD(extack, "Flow Action HW stats check is not supported");
 		return -EOPNOTSUPP;
+	}
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
-- 
2.27.0

