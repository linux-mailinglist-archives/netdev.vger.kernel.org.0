Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F369432C32
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhJSDXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231893AbhJSDXE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 23:23:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AC7061361;
        Tue, 19 Oct 2021 03:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634613652;
        bh=c+jEgwwHXkMoLavBwBiVzzSt4nhgXIoVfe8l3UoP1KM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q10WDaal/oBJ1CjhVHEQlO7bZS/jUeDBh3Un6yHTcKbklHvmbVYcImk0gvPOKZHN0
         gjG0oCfwIqZeWV77qKCkBNcf2jkh2JCftILSyY6khCyyNU0dxvzGmEMp7PgDyvCfTA
         RRcGE5Z8sT1fufttrDjSWSBNtWr+AsAC3Th1fOTXkMo6cQtvTBQX/zZgdvc3/GhAsT
         o1Uda4no6SXozh/WCmQbZLy4Ol/wKayqYBTvPeRrkcQvUBUxzbiWCphBpIfQuwkzzi
         D4lt4Dglm/62Jnyph009VRJvr8BepGitgcKZz8llc/oldlEILIVBvD9M70nzEKrWWq
         OXddPW5Jc9A0g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/13] net/mlx5: Lag, set match mask according to the traffic type bitmap
Date:   Mon, 18 Oct 2021 20:20:41 -0700
Message-Id: <20211019032047.55660-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019032047.55660-1-saeed@kernel.org>
References: <20211019032047.55660-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Set the related bits in the match definer mask according to the
TT mapping.
This mask will be used to create the match definers.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/lag/port_sel.c         | 182 ++++++++++++++++++
 1 file changed, 182 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
index 7b4ad49c8438..6095f1049bdb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
@@ -4,6 +4,188 @@
 #include <linux/netdevice.h>
 #include "lag.h"
 
+static int mlx5_lag_set_definer_inner(u32 *match_definer_mask,
+				      enum mlx5_traffic_types tt)
+{
+	int format_id;
+	u8 *ipv6;
+
+	switch (tt) {
+	case MLX5_TT_IPV4_UDP:
+	case MLX5_TT_IPV4_TCP:
+		format_id = 23;
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_l4_sport);
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_l4_dport);
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_ip_src_addr);
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_ip_dest_addr);
+		break;
+	case MLX5_TT_IPV4:
+		format_id = 23;
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_l3_type);
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_dmac_47_16);
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_dmac_15_0);
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_smac_47_16);
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_smac_15_0);
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_ip_src_addr);
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_ip_dest_addr);
+		break;
+	case MLX5_TT_IPV6_TCP:
+	case MLX5_TT_IPV6_UDP:
+		format_id = 31;
+		MLX5_SET_TO_ONES(match_definer_format_31, match_definer_mask,
+				 inner_l4_sport);
+		MLX5_SET_TO_ONES(match_definer_format_31, match_definer_mask,
+				 inner_l4_dport);
+		ipv6 = MLX5_ADDR_OF(match_definer_format_31, match_definer_mask,
+				    inner_ip_dest_addr);
+		memset(ipv6, 0xff, 16);
+		ipv6 = MLX5_ADDR_OF(match_definer_format_31, match_definer_mask,
+				    inner_ip_src_addr);
+		memset(ipv6, 0xff, 16);
+		break;
+	case MLX5_TT_IPV6:
+		format_id = 32;
+		ipv6 = MLX5_ADDR_OF(match_definer_format_32, match_definer_mask,
+				    inner_ip_dest_addr);
+		memset(ipv6, 0xff, 16);
+		ipv6 = MLX5_ADDR_OF(match_definer_format_32, match_definer_mask,
+				    inner_ip_src_addr);
+		memset(ipv6, 0xff, 16);
+		MLX5_SET_TO_ONES(match_definer_format_32, match_definer_mask,
+				 inner_dmac_47_16);
+		MLX5_SET_TO_ONES(match_definer_format_32, match_definer_mask,
+				 inner_dmac_15_0);
+		MLX5_SET_TO_ONES(match_definer_format_32, match_definer_mask,
+				 inner_smac_47_16);
+		MLX5_SET_TO_ONES(match_definer_format_32, match_definer_mask,
+				 inner_smac_15_0);
+		break;
+	default:
+		format_id = 23;
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_l3_type);
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_dmac_47_16);
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_dmac_15_0);
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_smac_47_16);
+		MLX5_SET_TO_ONES(match_definer_format_23, match_definer_mask,
+				 inner_smac_15_0);
+		break;
+	}
+
+	return format_id;
+}
+
+static int mlx5_lag_set_definer(u32 *match_definer_mask,
+				enum mlx5_traffic_types tt, bool tunnel,
+				enum netdev_lag_hash hash)
+{
+	int format_id;
+	u8 *ipv6;
+
+	if (tunnel)
+		return mlx5_lag_set_definer_inner(match_definer_mask, tt);
+
+	switch (tt) {
+	case MLX5_TT_IPV4_UDP:
+	case MLX5_TT_IPV4_TCP:
+		format_id = 22;
+		MLX5_SET_TO_ONES(match_definer_format_22, match_definer_mask,
+				 outer_l4_sport);
+		MLX5_SET_TO_ONES(match_definer_format_22, match_definer_mask,
+				 outer_l4_dport);
+		MLX5_SET_TO_ONES(match_definer_format_22, match_definer_mask,
+				 outer_ip_src_addr);
+		MLX5_SET_TO_ONES(match_definer_format_22, match_definer_mask,
+				 outer_ip_dest_addr);
+		break;
+	case MLX5_TT_IPV4:
+		format_id = 22;
+		MLX5_SET_TO_ONES(match_definer_format_22, match_definer_mask,
+				 outer_l3_type);
+		MLX5_SET_TO_ONES(match_definer_format_22, match_definer_mask,
+				 outer_dmac_47_16);
+		MLX5_SET_TO_ONES(match_definer_format_22, match_definer_mask,
+				 outer_dmac_15_0);
+		MLX5_SET_TO_ONES(match_definer_format_22, match_definer_mask,
+				 outer_smac_47_16);
+		MLX5_SET_TO_ONES(match_definer_format_22, match_definer_mask,
+				 outer_smac_15_0);
+		MLX5_SET_TO_ONES(match_definer_format_22, match_definer_mask,
+				 outer_ip_src_addr);
+		MLX5_SET_TO_ONES(match_definer_format_22, match_definer_mask,
+				 outer_ip_dest_addr);
+		break;
+	case MLX5_TT_IPV6_TCP:
+	case MLX5_TT_IPV6_UDP:
+		format_id = 29;
+		MLX5_SET_TO_ONES(match_definer_format_29, match_definer_mask,
+				 outer_l4_sport);
+		MLX5_SET_TO_ONES(match_definer_format_29, match_definer_mask,
+				 outer_l4_dport);
+		ipv6 = MLX5_ADDR_OF(match_definer_format_29, match_definer_mask,
+				    outer_ip_dest_addr);
+		memset(ipv6, 0xff, 16);
+		ipv6 = MLX5_ADDR_OF(match_definer_format_29, match_definer_mask,
+				    outer_ip_src_addr);
+		memset(ipv6, 0xff, 16);
+		break;
+	case MLX5_TT_IPV6:
+		format_id = 30;
+		ipv6 = MLX5_ADDR_OF(match_definer_format_30, match_definer_mask,
+				    outer_ip_dest_addr);
+		memset(ipv6, 0xff, 16);
+		ipv6 = MLX5_ADDR_OF(match_definer_format_30, match_definer_mask,
+				    outer_ip_src_addr);
+		memset(ipv6, 0xff, 16);
+		MLX5_SET_TO_ONES(match_definer_format_30, match_definer_mask,
+				 outer_dmac_47_16);
+		MLX5_SET_TO_ONES(match_definer_format_30, match_definer_mask,
+				 outer_dmac_15_0);
+		MLX5_SET_TO_ONES(match_definer_format_30, match_definer_mask,
+				 outer_smac_47_16);
+		MLX5_SET_TO_ONES(match_definer_format_30, match_definer_mask,
+				 outer_smac_15_0);
+		break;
+	default:
+		format_id = 0;
+		MLX5_SET_TO_ONES(match_definer_format_0, match_definer_mask,
+				 outer_smac_47_16);
+		MLX5_SET_TO_ONES(match_definer_format_0, match_definer_mask,
+				 outer_smac_15_0);
+
+		if (hash == NETDEV_LAG_HASH_VLAN_SRCMAC) {
+			MLX5_SET_TO_ONES(match_definer_format_0,
+					 match_definer_mask,
+					 outer_first_vlan_vid);
+			break;
+		}
+
+		MLX5_SET_TO_ONES(match_definer_format_0, match_definer_mask,
+				 outer_ethertype);
+		MLX5_SET_TO_ONES(match_definer_format_0, match_definer_mask,
+				 outer_dmac_47_16);
+		MLX5_SET_TO_ONES(match_definer_format_0, match_definer_mask,
+				 outer_dmac_15_0);
+		break;
+	}
+
+	return format_id;
+}
+
 static void set_tt_map(struct mlx5_lag_port_sel *port_sel,
 		       enum netdev_lag_hash hash)
 {
-- 
2.31.1

