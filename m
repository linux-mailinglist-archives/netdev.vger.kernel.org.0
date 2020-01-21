Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412191441E9
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgAUQRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:17:18 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43510 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729327AbgAUQQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:16:57 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 21 Jan 2020 18:16:54 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00LGGrX4008966;
        Tue, 21 Jan 2020 18:16:54 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next-mlx5 09/13] net/mlx5e: Move tc tunnel parsing logic with the rest at tc_tun module
Date:   Tue, 21 Jan 2020 18:16:18 +0200
Message-Id: <1579623382-6934-10-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
References: <1579623382-6934-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, tunnel parsing is split between en_tc and tc_tun. The next
patch will replace the tunnel fields matching with a register match,
and will not need this parsing.

Move the tunnel parsing logic to tc_tun as a pre-step for skipping
it in the next patch.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    | 112 ++++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 109 +-------------------
 3 files changed, 112 insertions(+), 112 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index af4ebd2..608d0e07c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -469,10 +469,15 @@ int mlx5e_tc_tun_parse(struct net_device *filter_dev,
 		       struct mlx5e_priv *priv,
 		       struct mlx5_flow_spec *spec,
 		       struct flow_cls_offload *f,
-		       void *headers_c,
-		       void *headers_v, u8 *match_level)
+		       u8 *match_level)
 {
 	struct mlx5e_tc_tunnel *tunnel = mlx5e_get_tc_tun(filter_dev);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	void *headers_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+				       outer_headers);
+	void *headers_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				       outer_headers);
+	struct netlink_ext_ack *extack = f->common.extack;
 	int err = 0;
 
 	if (!tunnel) {
@@ -499,6 +504,109 @@ int mlx5e_tc_tun_parse(struct net_device *filter_dev,
 			goto out;
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
+		struct flow_match_control match;
+		u16 addr_type;
+
+		flow_rule_match_enc_control(rule, &match);
+		addr_type = match.key->addr_type;
+
+		/* For tunnel addr_type used same key id`s as for non-tunnel */
+		if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+			struct flow_match_ipv4_addrs match;
+
+			flow_rule_match_enc_ipv4_addrs(rule, &match);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 src_ipv4_src_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.mask->src));
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 src_ipv4_src_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.key->src));
+
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.mask->dst));
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.key->dst));
+
+			MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c,
+					 ethertype);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
+				 ETH_P_IP);
+		} else if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+			struct flow_match_ipv6_addrs match;
+
+			flow_rule_match_enc_ipv6_addrs(rule, &match);
+			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
+					    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+			       &match.mask->src, MLX5_FLD_SZ_BYTES(ipv6_layout,
+								   ipv6));
+			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
+					    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+			       &match.key->src, MLX5_FLD_SZ_BYTES(ipv6_layout,
+								  ipv6));
+
+			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
+					    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+			       &match.mask->dst, MLX5_FLD_SZ_BYTES(ipv6_layout,
+								   ipv6));
+			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
+					    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+			       &match.key->dst, MLX5_FLD_SZ_BYTES(ipv6_layout,
+								  ipv6));
+
+			MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c,
+					 ethertype);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
+				 ETH_P_IPV6);
+		}
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IP)) {
+		struct flow_match_ip match;
+
+		flow_rule_match_enc_ip(rule, &match);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_ecn,
+			 match.mask->tos & 0x3);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_ecn,
+			 match.key->tos & 0x3);
+
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_dscp,
+			 match.mask->tos >> 2);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_dscp,
+			 match.key->tos  >> 2);
+
+		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ttl_hoplimit,
+			 match.mask->ttl);
+		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ttl_hoplimit,
+			 match.key->ttl);
+
+		if (match.mask->ttl &&
+		    !MLX5_CAP_ESW_FLOWTABLE_FDB
+			(priv->mdev,
+			 ft_field_support.outer_ipv4_ttl)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Matching on TTL is not supported");
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+	}
+
+	/* Enforce DMAC when offloading incoming tunneled flows.
+	 * Flow counters require a match on the DMAC.
+	 */
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, dmac_47_16);
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, dmac_15_0);
+	ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
+				     dmac_47_16), priv->netdev->dev_addr);
+
+	/* let software handle IP fragments */
+	MLX5_SET(fte_match_set_lyr_2_4, headers_c, frag, 1);
+	MLX5_SET(fte_match_set_lyr_2_4, headers_v, frag, 0);
+
+	return 0;
+
 out:
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index 6f9a78c..1630f0e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -76,8 +76,7 @@ int mlx5e_tc_tun_parse(struct net_device *filter_dev,
 		       struct mlx5e_priv *priv,
 		       struct mlx5_flow_spec *spec,
 		       struct flow_cls_offload *f,
-		       void *headers_c,
-		       void *headers_v, u8 *match_level);
+		       u8 *match_level);
 
 int mlx5e_tc_tun_parse_udp_ports(struct mlx5e_priv *priv,
 				 struct mlx5_flow_spec *spec,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index bc2d71a..71c4e78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1677,122 +1677,15 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 			     struct net_device *filter_dev, u8 *match_level)
 {
 	struct netlink_ext_ack *extack = f->common.extack;
-	void *headers_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-				       outer_headers);
-	void *headers_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
-				       outer_headers);
-	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	int err;
 
-	err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f,
-				 headers_c, headers_v, match_level);
+	err = mlx5e_tc_tun_parse(filter_dev, priv, spec, f, match_level);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "failed to parse tunnel attributes");
 		return err;
 	}
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
-		struct flow_match_control match;
-		u16 addr_type;
-
-		flow_rule_match_enc_control(rule, &match);
-		addr_type = match.key->addr_type;
-
-		/* For tunnel addr_type used same key id`s as for non-tunnel */
-		if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
-			struct flow_match_ipv4_addrs match;
-
-			flow_rule_match_enc_ipv4_addrs(rule, &match);
-			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-				 src_ipv4_src_ipv6.ipv4_layout.ipv4,
-				 ntohl(match.mask->src));
-			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-				 src_ipv4_src_ipv6.ipv4_layout.ipv4,
-				 ntohl(match.key->src));
-
-			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-				 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
-				 ntohl(match.mask->dst));
-			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-				 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
-				 ntohl(match.key->dst));
-
-			MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c,
-					 ethertype);
-			MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
-				 ETH_P_IP);
-		} else if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
-			struct flow_match_ipv6_addrs match;
-
-			flow_rule_match_enc_ipv6_addrs(rule, &match);
-			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
-					    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-			       &match.mask->src, MLX5_FLD_SZ_BYTES(ipv6_layout,
-								   ipv6));
-			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
-					    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-			       &match.key->src, MLX5_FLD_SZ_BYTES(ipv6_layout,
-								  ipv6));
-
-			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
-					    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-			       &match.mask->dst, MLX5_FLD_SZ_BYTES(ipv6_layout,
-								   ipv6));
-			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
-					    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-			       &match.key->dst, MLX5_FLD_SZ_BYTES(ipv6_layout,
-								  ipv6));
-
-			MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c,
-					 ethertype);
-			MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
-				 ETH_P_IPV6);
-		}
-	}
-
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IP)) {
-		struct flow_match_ip match;
-
-		flow_rule_match_enc_ip(rule, &match);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_ecn,
-			 match.mask->tos & 0x3);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_ecn,
-			 match.key->tos & 0x3);
-
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_dscp,
-			 match.mask->tos >> 2);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_dscp,
-			 match.key->tos  >> 2);
-
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ttl_hoplimit,
-			 match.mask->ttl);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ttl_hoplimit,
-			 match.key->ttl);
-
-		if (match.mask->ttl &&
-		    !MLX5_CAP_ESW_FLOWTABLE_FDB
-			(priv->mdev,
-			 ft_field_support.outer_ipv4_ttl)) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Matching on TTL is not supported");
-			return -EOPNOTSUPP;
-		}
-
-	}
-
-	/* Enforce DMAC when offloading incoming tunneled flows.
-	 * Flow counters require a match on the DMAC.
-	 */
-	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, dmac_47_16);
-	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, dmac_15_0);
-	ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
-				     dmac_47_16), priv->netdev->dev_addr);
-
-	/* let software handle IP fragments */
-	MLX5_SET(fte_match_set_lyr_2_4, headers_c, frag, 1);
-	MLX5_SET(fte_match_set_lyr_2_4, headers_v, frag, 0);
-
 	return 0;
 }
 
-- 
1.8.3.1

