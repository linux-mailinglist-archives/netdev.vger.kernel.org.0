Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D3DC3D96
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbfJAQkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729738AbfJAQkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:40:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7963B21906;
        Tue,  1 Oct 2019 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948016;
        bh=2py4yvsg+8cjdkDAYD5Lyx1lM4YYJQqh+WS9ZrdrzDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kf7X3A7d+1R0/ic7D3dZEXm74gT0VmprhZOoXrN4ln3MiEsKmL/mIA0Wridp5soxz
         a/0FFFYlouZlBhPUYsCedepffjJ4YNCpyCoa2LSdf5Rt5/Ko1t0utZBciWE962LmIr
         Qv7SU/PQBAL0iONAiTClDdq2BPMKhPI5W3xoqEwc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmytro Linkin <dmitrolin@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 37/71] net/mlx5e: Fix matching on tunnel addresses type
Date:   Tue,  1 Oct 2019 12:38:47 -0400
Message-Id: <20191001163922.14735-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

[ Upstream commit fe1587a7de94912ed75ba5ddbfabf0741f9f8239 ]

In mlx5 parse_tunnel_attr() function dispatch on encap IP address type
is performed by directly checking flow_rule_match_key() on
FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS, and then on
FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS. However, since those are stored in
union, first check is always true if any type of encap address is set,
which leads to IPv6 tunnel encap address being parsed as IPv4 by mlx5.
Determine correct IP address type by checking control key first and if
it set, take address type from match.key->addr_type.

Fixes: d1bda7eecd88 ("net/mlx5e: Allow matching only enc_key_id/enc_dst_port for decapsulation action")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 89 +++++++++++--------
 1 file changed, 53 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 00b2d4a86159f..98be5fe336743 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1369,46 +1369,63 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 		return err;
 	}
 
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
-		struct flow_match_ipv4_addrs match;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
+		struct flow_match_control match;
+		u16 addr_type;
 
-		flow_rule_match_enc_ipv4_addrs(rule, &match);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-			 src_ipv4_src_ipv6.ipv4_layout.ipv4,
-			 ntohl(match.mask->src));
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-			 src_ipv4_src_ipv6.ipv4_layout.ipv4,
-			 ntohl(match.key->src));
-
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-			 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
-			 ntohl(match.mask->dst));
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-			 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
-			 ntohl(match.key->dst));
-
-		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ethertype);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype, ETH_P_IP);
-	} else if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS)) {
-		struct flow_match_ipv6_addrs match;
+		flow_rule_match_enc_control(rule, &match);
+		addr_type = match.key->addr_type;
 
-		flow_rule_match_enc_ipv6_addrs(rule, &match);
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
-				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-		       &match.mask->src, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
-				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-		       &match.key->src, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
+		/* For tunnel addr_type used same key id`s as for non-tunnel */
+		if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+			struct flow_match_ipv4_addrs match;
 
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
-				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       &match.mask->dst, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
-				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       &match.key->dst, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
+			flow_rule_match_enc_ipv4_addrs(rule, &match);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 src_ipv4_src_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.mask->src));
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 src_ipv4_src_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.key->src));
 
-		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ethertype);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype, ETH_P_IPV6);
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
 	}
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IP)) {
-- 
2.20.1

