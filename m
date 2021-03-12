Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E47339A12
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235900AbhCLXjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:39:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:32852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235830AbhCLXjB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:39:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B95564F9F;
        Fri, 12 Mar 2021 23:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615592341;
        bh=3cB7wlJC43SIuSjS6UZamwhKty89CIJLHjRK7nVt0Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WW9c25S6Sx6DYoP30YeN797RUyC18X/PchIDFs+c2F/UZiQB++KuIdz2d5VjbpRz6
         kZJ5dtNLt1ySk71gD8KdceONw4pWFf2RQwNOtb59FUSSZ+zjK/mJTuaUg3vzxd99kf
         ivdNNPa8d6JxueAKmhQSpMoC9QF9hWow6BAPvmHi51uWXUeaLNQd0fOwniRZmIu2cD
         LMed0zOK6tarlcaEclF4mj8Sen8ZfwxiWwqe1nddbid79Sie3mtYa8H2qbFIn/yYeH
         MZKrzvkiDry/waPpcbjlVHEd7kQzCaj+0Mszst5jwijO/lBMgVJJGgR5G865wqHtVE
         nC0/j32q+Lv0w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/13] net/mlx5e: Allow to match on ICMP parameters
Date:   Fri, 12 Mar 2021 15:38:51 -0800
Message-Id: <20210312233851.494832-14-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312233851.494832-1-saeed@kernel.org>
References: <20210312233851.494832-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Support matching on ICMPv4/6 type and code parameters using misc3
section of match parameters.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 47 +++++++++++++++++++
 include/linux/mlx5/device.h                   |  2 +
 2 files changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 121f0a744e55..54ea0dae7ded 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1961,6 +1961,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 				    misc_parameters);
 	void *misc_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				    misc_parameters);
+	void *misc_c_3 = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+				    misc_parameters_3);
+	void *misc_v_3 = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				    misc_parameters_3);
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
 	u16 addr_type = 0;
@@ -1990,6 +1994,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	      BIT(FLOW_DISSECTOR_KEY_CT) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_IP) |
 	      BIT(FLOW_DISSECTOR_KEY_ENC_OPTS) |
+	      BIT(FLOW_DISSECTOR_KEY_ICMP) |
 	      BIT(FLOW_DISSECTOR_KEY_MPLS))) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported key");
 		netdev_dbg(priv->netdev, "Unsupported key used: 0x%x\n",
@@ -2309,7 +2314,49 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		if (match.mask->flags)
 			*match_level = MLX5_MATCH_L4;
 	}
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ICMP)) {
+		struct flow_match_icmp match;
 
+		flow_rule_match_icmp(rule, &match);
+		switch (ip_proto) {
+		case IPPROTO_ICMP:
+			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
+			      MLX5_FLEX_PROTO_ICMP))
+				return -EOPNOTSUPP;
+			MLX5_SET(fte_match_set_misc3, misc_c_3, icmp_type,
+				 match.mask->type);
+			MLX5_SET(fte_match_set_misc3, misc_v_3, icmp_type,
+				 match.key->type);
+			MLX5_SET(fte_match_set_misc3, misc_c_3, icmp_code,
+				 match.mask->code);
+			MLX5_SET(fte_match_set_misc3, misc_v_3, icmp_code,
+				 match.key->code);
+			break;
+		case IPPROTO_ICMPV6:
+			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
+			      MLX5_FLEX_PROTO_ICMPV6))
+				return -EOPNOTSUPP;
+			MLX5_SET(fte_match_set_misc3, misc_c_3, icmpv6_type,
+				 match.mask->type);
+			MLX5_SET(fte_match_set_misc3, misc_v_3, icmpv6_type,
+				 match.key->type);
+			MLX5_SET(fte_match_set_misc3, misc_c_3, icmpv6_code,
+				 match.mask->code);
+			MLX5_SET(fte_match_set_misc3, misc_v_3, icmpv6_code,
+				 match.key->code);
+			break;
+		default:
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Code and type matching only with ICMP and ICMPv6");
+			netdev_err(priv->netdev,
+				   "Code and type matching only with ICMP and ICMPv6\n");
+			return -EINVAL;
+		}
+		if (match.mask->code || match.mask->type) {
+			*match_level = MLX5_MATCH_L4;
+			spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_3;
+		}
+	}
 	return 0;
 }
 
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index dc3d2508f5c6..92a029a800a0 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1142,6 +1142,8 @@ enum mlx5_flex_parser_protos {
 	MLX5_FLEX_PROTO_GENEVE	      = 1 << 3,
 	MLX5_FLEX_PROTO_CW_MPLS_GRE   = 1 << 4,
 	MLX5_FLEX_PROTO_CW_MPLS_UDP   = 1 << 5,
+	MLX5_FLEX_PROTO_ICMP	      = 1 << 8,
+	MLX5_FLEX_PROTO_ICMPV6	      = 1 << 9,
 };
 
 /* MLX5 DEV CAPs */
-- 
2.29.2

