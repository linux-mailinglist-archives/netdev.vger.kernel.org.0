Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACAA410D0A
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 21:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhISTSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 15:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhISTSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 15:18:34 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DDFC061574;
        Sun, 19 Sep 2021 12:17:08 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id j6so14222676pfa.4;
        Sun, 19 Sep 2021 12:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+FZa+h6qW7HKyaWwksIyihd1LwAuNa/BdY/YYHm6Kc4=;
        b=ZJvn3dONTzjl0ACvmg49Qz+zA45MUS6gVDpTcJJk0A0hXfaTgqQyM5kw6uslF6zg6P
         pOwcEkEdzMP08ppDHriuvTTx5cniJgqlJdYED6bSsPdUoyC5ThiwvSXWs2wN/6GMz7vf
         /geF8ZUUu1gvuR/a7PYMyy/YeE1iXKV9ceSr9UQjrmbuC3fum8WutNihKhpEWQeilh2K
         jkRrwWA6dbqkxzNJr7xsFPnWOWxVoa/Sn9ocVG0WtuF5GHdUHhs2W1sxpMxPyN/O19Ii
         QXGNXLkJZeCmN2Kb0QQq2OF1Hs8rzW2w1TH40pg7SoIaQctfHDw52kxqbI5/dxSvbBFs
         sQGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+FZa+h6qW7HKyaWwksIyihd1LwAuNa/BdY/YYHm6Kc4=;
        b=kVH/AKtedVopygLZTKQFJjOk4AYnCoretOTQOlP1V0De37P+ShUGT7H5w0tsacbHEj
         0R62sBLS4V7B5O/jvlth9OX5Timqq/a5ALmiBnhMOV/C+MnK4uSvHnM4CkcD+Gdiej32
         Ej7T4fmsCc+KBJ8giC5Z8C0mOK6NnbB+GsJpld3//HRPczW2/0oPggJ7rbwBuCEER9lP
         3pU1JheJvAU7Bej50fc1SZPo7BRHvZPIkJz1FZ3OR0tZOKVYO/NxSiDclSkJIBIDmHoS
         0vEMKn4Xfbb4OoyroELnAN5c3FyRKwF6MfaVfYt1rlVxh3Rb63/qiIdLsVB1ubpmzHGd
         ZjUw==
X-Gm-Message-State: AOAM5302GDzZdQYjACQK2bEEJcjWkfTZIVsHrAj45F00dizCgykikkfA
        XVoGtXmbNYN8c4CsqHHL4MI=
X-Google-Smtp-Source: ABdhPJxA8APnQxnnkPn0iv+tjajSbqSfRTYYaVHgKRwogmH8wK4P4MaCVAcerzmI9Ah3FMtPP5P0ig==
X-Received: by 2002:a63:7a04:: with SMTP id v4mr2691099pgc.123.1632079027577;
        Sun, 19 Sep 2021 12:17:07 -0700 (PDT)
Received: from arn.remote.csb ([49.206.7.248])
        by smtp.googlemail.com with ESMTPSA id 77sm11877856pfu.219.2021.09.19.12.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 12:17:07 -0700 (PDT)
From:   Abhiram R N <abhiramrn@gmail.com>
To:     roid@nvidia.com
Cc:     arn@redhat.com, hakhande@redhat.com, saeedm@nvidia.com,
        Abhiram R N <abhiramrn@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v5] net/mlx5e: Add extack msgs related to TC for better debug
Date:   Mon, 20 Sep 2021 00:46:48 +0530
Message-Id: <20210919191648.9953-1-abhiramrn@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <b2f9291a-4c6f-99f5-00be-21dfef110e12@nvidia.com>
References: <b2f9291a-4c6f-99f5-00be-21dfef110e12@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As multiple places EOPNOTSUPP and EINVAL is returned from driver
it becomes difficult to understand the reason only with error code.
With the netlink extack message exact reason will be known and will
aid in debugging.

V4->V5: Adressed comments (Rephrasing of msgs)
V3->V4: Rebased net-next (Fixed the merge conflicts in net-next branch)
V2->V3: Addressed comments (Rephrasing of msgs)
V1->V2: Addressed comments (Removed redundant msgs, rephrasing of msgs)

Signed-off-by: Abhiram R N <abhiramrn@gmail.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 106 +++++++++++++-----
 1 file changed, 76 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ba8164792016..0fda231c07cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1896,8 +1896,10 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 	bool needs_mapping, sets_mapping;
 	int err;
 
-	if (!mlx5e_is_eswitch_flow(flow))
+	if (!mlx5e_is_eswitch_flow(flow)) {
+		NL_SET_ERR_MSG_MOD(extack, "Match on tunnel is not supported");
 		return -EOPNOTSUPP;
+	}
 
 	needs_mapping = !!flow->attr->chain;
 	sets_mapping = flow_requires_tunnel_mapping(flow->attr->chain, f);
@@ -2269,8 +2271,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		addr_type = match.key->addr_type;
 
 		/* the HW doesn't support frag first/later */
-		if (match.mask->flags & FLOW_DIS_FIRST_FRAG)
+		if (match.mask->flags & FLOW_DIS_FIRST_FRAG) {
+			NL_SET_ERR_MSG_MOD(extack, "Match on frag first/later is not supported");
 			return -EOPNOTSUPP;
+		}
 
 		if (match.mask->flags & FLOW_DIS_IS_FRAGMENT) {
 			MLX5_SET(fte_match_set_lyr_2_4, headers_c, frag, 1);
@@ -2437,8 +2441,11 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		switch (ip_proto) {
 		case IPPROTO_ICMP:
 			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
-			      MLX5_FLEX_PROTO_ICMP))
+			      MLX5_FLEX_PROTO_ICMP)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Match on Flex protocols for ICMP is not supported");
 				return -EOPNOTSUPP;
+			}
 			MLX5_SET(fte_match_set_misc3, misc_c_3, icmp_type,
 				 match.mask->type);
 			MLX5_SET(fte_match_set_misc3, misc_v_3, icmp_type,
@@ -2450,8 +2457,11 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 			break;
 		case IPPROTO_ICMPV6:
 			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
-			      MLX5_FLEX_PROTO_ICMPV6))
+			      MLX5_FLEX_PROTO_ICMPV6)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Match on Flex protocols for ICMPV6 is not supported");
 				return -EOPNOTSUPP;
+			}
 			MLX5_SET(fte_match_set_misc3, misc_c_3, icmpv6_type,
 				 match.mask->type);
 			MLX5_SET(fte_match_set_misc3, misc_v_3, icmpv6_type,
@@ -2557,15 +2567,19 @@ static int pedit_header_offsets[] = {
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
+	if (*curr_pmask & mask) { /* disallow acting twice on the same location */
+		NL_SET_ERR_MSG_MOD(extack,
+				   "curr_pmask and new mask same. Acting twice on same location");
 		goto out_err;
+	}
 
 	*curr_pmask |= mask;
 	*curr_pval  |= (val & mask);
@@ -2898,7 +2912,7 @@ parse_pedit_to_modify_hdr(struct mlx5e_priv *priv,
 	val = act->mangle.val;
 	offset = act->mangle.offset;
 
-	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd]);
+	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd], extack);
 	if (err)
 		goto out_err;
 
@@ -2918,8 +2932,10 @@ parse_pedit_to_reformat(struct mlx5e_priv *priv,
 	u32 mask, val, offset;
 	u32 *p;
 
-	if (act->id != FLOW_ACTION_MANGLE)
+	if (act->id != FLOW_ACTION_MANGLE) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported action id");
 		return -EOPNOTSUPP;
+	}
 
 	if (act->mangle.htype != FLOW_ACT_MANGLE_HDR_TYPE_ETH) {
 		NL_SET_ERR_MSG_MOD(extack, "Only Ethernet modification is supported");
@@ -3368,12 +3384,16 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 	u32 action = 0;
 	int err, i;
 
-	if (!flow_action_has_entries(flow_action))
+	if (!flow_action_has_entries(flow_action)) {
+		NL_SET_ERR_MSG_MOD(extack, "Flow action doesn't have any entries");
 		return -EINVAL;
+	}
 
 	if (!flow_action_hw_stats_check(flow_action, extack,
-					FLOW_ACTION_HW_STATS_DELAYED_BIT))
+					FLOW_ACTION_HW_STATS_DELAYED_BIT)) {
+		NL_SET_ERR_MSG_MOD(extack, "Flow action HW stats type is not supported");
 		return -EOPNOTSUPP;
+	}
 
 	nic_attr = attr->nic_attr;
 	nic_attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
@@ -3462,7 +3482,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 			flow_flag_set(flow, CT);
 			break;
 		default:
-			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
+			NL_SET_ERR_MSG_MOD(extack,
+					   "The offload action is not supported in NIC action");
 			return -EOPNOTSUPP;
 		}
 	}
@@ -3517,19 +3538,25 @@ static bool is_merged_eswitch_vfs(struct mlx5e_priv *priv,
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
+		NL_SET_ERR_MSG_MOD(extack, "Total vlans used is greater than supported");
 		return -EOPNOTSUPP;
+	}
 
 	switch (act->id) {
 	case FLOW_ACTION_VLAN_POP:
 		if (vlan_idx) {
 			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
-								 MLX5_FS_VLAN_DEPTH))
+								 MLX5_FS_VLAN_DEPTH)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "vlan pop action is not supported");
 				return -EOPNOTSUPP;
+			}
 
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2;
 		} else {
@@ -3545,20 +3572,27 @@ static int parse_tc_vlan_action(struct mlx5e_priv *priv,
 
 		if (vlan_idx) {
 			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
-								 MLX5_FS_VLAN_DEPTH))
+								 MLX5_FS_VLAN_DEPTH)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "vlan push action is not supported for vlan depth > 1");
 				return -EOPNOTSUPP;
+			}
 
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2;
 		} else {
 			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev, 1) &&
 			    (act->vlan.proto != htons(ETH_P_8021Q) ||
-			     act->vlan.prio))
+			     act->vlan.prio)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "vlan push action is not supported");
 				return -EOPNOTSUPP;
+			}
 
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
 		}
 		break;
 	default:
+		NL_SET_ERR_MSG_MOD(extack, "Unexpected action id for VLAN");
 		return -EINVAL;
 	}
 
@@ -3592,7 +3626,8 @@ static struct net_device *get_fdb_out_dev(struct net_device *uplink_dev,
 static int add_vlan_push_action(struct mlx5e_priv *priv,
 				struct mlx5_flow_attr *attr,
 				struct net_device **out_dev,
-				u32 *action)
+				u32 *action,
+				struct netlink_ext_ack *extack)
 {
 	struct net_device *vlan_dev = *out_dev;
 	struct flow_action_entry vlan_act = {
@@ -3603,7 +3638,7 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
 	};
 	int err;
 
-	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
+	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
 	if (err)
 		return err;
 
@@ -3614,14 +3649,15 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
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
@@ -3631,7 +3667,7 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
 	nest_level = attr->parse_attr->filter_dev->lower_level -
 						priv->netdev->lower_level;
 	while (nest_level--) {
-		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
+		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
 		if (err)
 			return err;
 	}
@@ -3753,12 +3789,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
+		NL_SET_ERR_MSG_MOD(extack, "Flow action HW stats type is not supported");
 		return -EOPNOTSUPP;
+	}
 
 	esw_attr = attr->esw_attr;
 	parse_attr = attr->parse_attr;
@@ -3902,14 +3942,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
@@ -3955,10 +3995,13 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			break;
 		case FLOW_ACTION_TUNNEL_ENCAP:
 			info = act->tunnel;
-			if (info)
+			if (info) {
 				encap = true;
-			else
+			} else {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Zero tunnel attributes is not supported");
 				return -EOPNOTSUPP;
+			}
 
 			break;
 		case FLOW_ACTION_VLAN_PUSH:
@@ -3972,7 +4015,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 							      act, parse_attr, hdrs,
 							      &action, extack);
 			} else {
-				err = parse_tc_vlan_action(priv, act, esw_attr, &action);
+				err = parse_tc_vlan_action(priv, act, esw_attr, &action, extack);
 			}
 			if (err)
 				return err;
@@ -4025,7 +4068,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			flow_flag_set(flow, SAMPLE);
 			break;
 		default:
-			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
+			NL_SET_ERR_MSG_MOD(extack,
+					   "The offload action is not supported in FDB action");
 			return -EOPNOTSUPP;
 		}
 	}
@@ -4733,8 +4777,10 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (!flow_action_basic_hw_stats_check(flow_action, extack))
+	if (!flow_action_basic_hw_stats_check(flow_action, extack)) {
+		NL_SET_ERR_MSG_MOD(extack, "Flow action HW stats type is not supported");
 		return -EOPNOTSUPP;
+	}
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
-- 
2.27.0

