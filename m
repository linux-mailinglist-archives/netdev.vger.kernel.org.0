Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06073F91AC
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244125AbhH0A7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244055AbhH0A7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53F15610A1;
        Fri, 27 Aug 2021 00:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025896;
        bh=E+xnqE7mv/AOYNkWYm5og00WmTSYnmBjChSUXrGGNlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvA9gWGOMYd/8atWeQ9G22bCMFMp3/BWGaIQlGhiFJFY4+3emr05Jcr1UcgZ8WjYK
         PxUUNFSK0W0CjvWiuTZ3lbzhfk+a25wjSvN0pbP2bnAJY2kPauXZrAqkpcdaLfi7bH
         czkYdygSyRHWW5HDMzYZYY7qDcC985ONJx0MdvGZ9aiumERV6YJvGKbIsr9w8fA/DR
         STXv+8jVj5UCLkf2hfu8PesV7g7HxiXl7TCjTQFoYvgRCGPkphr/r9an2+s7rIzNEL
         GtgmYHIDnygr+jqNspoCAgo5mQgVNREmfQj8vzQNuVozz0Yi+BSPgRssqG225x1HFr
         4JULBqrIVY5nw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/17] net/mlx5: DR, Enable VLAN pop on TX and VLAN push on RX
Date:   Thu, 26 Aug 2021 17:57:48 -0700
Message-Id: <20210827005802.236119-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Enable pop VLAN action in TX and push VLAN in RX.
These actions are supported only on STEv1.

On TX: when a host sends a packet, VLAN is popped at the beginning.
On RX: just before passing the packet to the host the VLAN is pushed.

Signed-off-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   | 71 ++++++++++++++++++-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   | 52 ++++++++++++--
 .../mellanox/mlx5/core/steering/dr_types.h    |  4 +-
 3 files changed, 118 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 0d2acb968615..bdaeb1b54640 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -43,6 +43,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
+			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 		},
 		[DR_ACTION_STATE_DECAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -56,6 +57,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
+			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 		},
 		[DR_ACTION_STATE_ENCAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -75,6 +77,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 		},
 		[DR_ACTION_STATE_POP_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -89,6 +92,16 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 		},
+		[DR_ACTION_STATE_PUSH_VLAN] = {
+			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_TAG]		= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+		},
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_QP]		= DR_ACTION_STATE_TERM,
@@ -104,6 +117,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
+			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 		},
 		[DR_ACTION_STATE_TERM] = {
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_TERM,
@@ -121,6 +135,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 		},
 		[DR_ACTION_STATE_DECAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -144,6 +159,17 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 		},
+		[DR_ACTION_STATE_POP_VLAN] = {
+			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_POP_VLAN,
+			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
+			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+		},
 		[DR_ACTION_STATE_PUSH_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
@@ -165,6 +191,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 		},
 		[DR_ACTION_STATE_TERM] = {
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_TERM,
@@ -183,6 +210,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 		},
@@ -192,11 +220,12 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
-			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
+			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 		},
 		[DR_ACTION_STATE_ENCAP] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -215,6 +244,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 		},
 		[DR_ACTION_STATE_POP_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
@@ -228,6 +258,18 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 		},
+		[DR_ACTION_STATE_PUSH_VLAN] = {
+			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+		},
 		[DR_ACTION_STATE_NON_TERM] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
@@ -241,6 +283,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
 			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
+			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 		},
 		[DR_ACTION_STATE_TERM] = {
@@ -259,6 +302,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 		},
 		[DR_ACTION_STATE_DECAP] = {
@@ -286,6 +330,18 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 		},
+		[DR_ACTION_STATE_POP_VLAN] = {
+			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_SAMPLER]		= DR_ACTION_STATE_TERM,
+			[DR_ACTION_TYP_CTR]		= DR_ACTION_STATE_POP_VLAN,
+			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
+			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_MODIFY_HDR]	= DR_ACTION_STATE_MODIFY_HDR,
+			[DR_ACTION_TYP_L2_TO_TNL_L2]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_L2_TO_TNL_L3]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
+			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
+		},
 		[DR_ACTION_STATE_PUSH_VLAN] = {
 			[DR_ACTION_TYP_DROP]		= DR_ACTION_STATE_TERM,
 			[DR_ACTION_TYP_FT]		= DR_ACTION_STATE_TERM,
@@ -308,6 +364,7 @@ next_action_state[DR_ACTION_DOMAIN_MAX][DR_ACTION_STATE_MAX][DR_ACTION_TYP_MAX]
 			[DR_ACTION_TYP_INSERT_HDR]	= DR_ACTION_STATE_ENCAP,
 			[DR_ACTION_TYP_REMOVE_HDR]	= DR_ACTION_STATE_DECAP,
 			[DR_ACTION_TYP_PUSH_VLAN]	= DR_ACTION_STATE_PUSH_VLAN,
+			[DR_ACTION_TYP_POP_VLAN]	= DR_ACTION_STATE_POP_VLAN,
 			[DR_ACTION_TYP_VPORT]		= DR_ACTION_STATE_TERM,
 		},
 		[DR_ACTION_STATE_TERM] = {
@@ -584,10 +641,22 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 			}
 			break;
 		case DR_ACTION_TYP_POP_VLAN:
+			if (!rx_rule && !(dmn->ste_ctx->actions_caps &
+					  DR_STE_CTX_ACTION_CAP_TX_POP)) {
+				mlx5dr_dbg(dmn, "Device doesn't support POP VLAN action on TX\n");
+				goto out_invalid_arg;
+			}
+
 			max_actions_type = MLX5DR_MAX_VLANS;
 			attr.vlans.count++;
 			break;
 		case DR_ACTION_TYP_PUSH_VLAN:
+			if (rx_rule && !(dmn->ste_ctx->actions_caps &
+					 DR_STE_CTX_ACTION_CAP_RX_PUSH)) {
+				mlx5dr_dbg(dmn, "Device doesn't support PUSH VLAN action on RX\n");
+				goto out_invalid_arg;
+			}
+
 			max_actions_type = MLX5DR_MAX_VLANS;
 			if (attr.vlans.count == MLX5DR_MAX_VLANS)
 				return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 3c5bd80e18ff..2894d9fcc672 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -417,8 +417,8 @@ static void dr_ste_v1_set_remove_hdr(u8 *hw_ste_p, u8 *s_action,
 	dr_ste_v1_set_reparse(hw_ste_p);
 }
 
-static void dr_ste_v1_set_tx_push_vlan(u8 *hw_ste_p, u8 *d_action,
-				       u32 vlan_hdr)
+static void dr_ste_v1_set_push_vlan(u8 *hw_ste_p, u8 *d_action,
+				    u32 vlan_hdr)
 {
 	MLX5_SET(ste_double_action_insert_with_inline_v1, d_action,
 		 action_id, DR_STE_V1_ACTION_ID_INSERT_INLINE);
@@ -431,7 +431,7 @@ static void dr_ste_v1_set_tx_push_vlan(u8 *hw_ste_p, u8 *d_action,
 	dr_ste_v1_set_reparse(hw_ste_p);
 }
 
-static void dr_ste_v1_set_rx_pop_vlan(u8 *hw_ste_p, u8 *s_action, u8 vlans_num)
+static void dr_ste_v1_set_pop_vlan(u8 *hw_ste_p, u8 *s_action, u8 vlans_num)
 {
 	MLX5_SET(ste_single_action_remove_header_size_v1, s_action,
 		 action_id, DR_STE_V1_ACTION_ID_REMOVE_BY_SIZE);
@@ -518,13 +518,28 @@ static void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 {
 	u8 *action = MLX5_ADDR_OF(ste_match_bwc_v1, last_ste, action);
 	u8 action_sz = DR_STE_ACTION_DOUBLE_SZ;
+	bool allow_modify_hdr = true;
 	bool allow_encap = true;
 
+	if (action_type_set[DR_ACTION_TYP_POP_VLAN]) {
+		if (action_sz < DR_STE_ACTION_SINGLE_SZ) {
+			dr_ste_v1_arr_init_next_match(&last_ste, added_stes,
+						      attr->gvmi);
+			action = MLX5_ADDR_OF(ste_mask_and_match_v1,
+					      last_ste, action);
+			action_sz = DR_STE_ACTION_TRIPLE_SZ;
+		}
+		dr_ste_v1_set_pop_vlan(last_ste, action, attr->vlans.count);
+		action_sz -= DR_STE_ACTION_SINGLE_SZ;
+		action += DR_STE_ACTION_SINGLE_SZ;
+		allow_modify_hdr = false;
+	}
+
 	if (action_type_set[DR_ACTION_TYP_CTR])
 		dr_ste_v1_set_counter_id(last_ste, attr->ctr_id);
 
 	if (action_type_set[DR_ACTION_TYP_MODIFY_HDR]) {
-		if (action_sz < DR_STE_ACTION_DOUBLE_SZ) {
+		if (!allow_modify_hdr || action_sz < DR_STE_ACTION_DOUBLE_SZ) {
 			dr_ste_v1_arr_init_next_match(&last_ste, added_stes,
 						      attr->gvmi);
 			action = MLX5_ADDR_OF(ste_mask_and_match_v1,
@@ -549,7 +564,8 @@ static void dr_ste_v1_set_actions_tx(struct mlx5dr_domain *dmn,
 				action_sz = DR_STE_ACTION_TRIPLE_SZ;
 				allow_encap = true;
 			}
-			dr_ste_v1_set_tx_push_vlan(last_ste, action, attr->vlans.headers[i]);
+			dr_ste_v1_set_push_vlan(last_ste, action,
+						attr->vlans.headers[i]);
 			action_sz -= DR_STE_ACTION_DOUBLE_SZ;
 			action += DR_STE_ACTION_DOUBLE_SZ;
 		}
@@ -662,7 +678,7 @@ static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 			allow_ctr = false;
 		}
 
-		dr_ste_v1_set_rx_pop_vlan(last_ste, action, attr->vlans.count);
+		dr_ste_v1_set_pop_vlan(last_ste, action, attr->vlans.count);
 		action_sz -= DR_STE_ACTION_SINGLE_SZ;
 		action += DR_STE_ACTION_SINGLE_SZ;
 	}
@@ -683,6 +699,26 @@ static void dr_ste_v1_set_actions_rx(struct mlx5dr_domain *dmn,
 		action += DR_STE_ACTION_DOUBLE_SZ;
 	}
 
+	if (action_type_set[DR_ACTION_TYP_PUSH_VLAN]) {
+		int i;
+
+		for (i = 0; i < attr->vlans.count; i++) {
+			if (action_sz < DR_STE_ACTION_DOUBLE_SZ ||
+			    !allow_modify_hdr) {
+				dr_ste_v1_arr_init_next_match(&last_ste,
+							      added_stes,
+							      attr->gvmi);
+				action = MLX5_ADDR_OF(ste_mask_and_match_v1,
+						      last_ste, action);
+				action_sz = DR_STE_ACTION_TRIPLE_SZ;
+			}
+			dr_ste_v1_set_push_vlan(last_ste, action,
+						attr->vlans.headers[i]);
+			action_sz -= DR_STE_ACTION_DOUBLE_SZ;
+			action += DR_STE_ACTION_DOUBLE_SZ;
+		}
+	}
+
 	if (action_type_set[DR_ACTION_TYP_CTR]) {
 		/* Counter action set after decap and before insert_hdr
 		 * to exclude decaped / encaped header respectively.
@@ -2001,7 +2037,9 @@ struct mlx5dr_ste_ctx ste_ctx_v1 = {
 	.set_byte_mask			= &dr_ste_v1_set_byte_mask,
 	.get_byte_mask			= &dr_ste_v1_get_byte_mask,
 	/* Actions */
-	.actions_caps			= DR_STE_CTX_ACTION_CAP_RX_ENCAP,
+	.actions_caps			= DR_STE_CTX_ACTION_CAP_TX_POP |
+					  DR_STE_CTX_ACTION_CAP_RX_PUSH |
+					  DR_STE_CTX_ACTION_CAP_RX_ENCAP,
 	.set_actions_rx			= &dr_ste_v1_set_actions_rx,
 	.set_actions_tx			= &dr_ste_v1_set_actions_tx,
 	.modify_field_arr_sz		= ARRAY_SIZE(dr_ste_v1_action_modify_field_arr),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 2f1f75ab8a34..474cf32a67c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -91,7 +91,9 @@ enum {
 
 enum mlx5dr_ste_ctx_action_cap {
 	DR_STE_CTX_ACTION_CAP_NONE = 0,
-	DR_STE_CTX_ACTION_CAP_RX_ENCAP = 1 << 0,
+	DR_STE_CTX_ACTION_CAP_TX_POP   = 1 << 0,
+	DR_STE_CTX_ACTION_CAP_RX_PUSH  = 1 << 1,
+	DR_STE_CTX_ACTION_CAP_RX_ENCAP = 1 << 2,
 };
 
 enum {
-- 
2.31.1

