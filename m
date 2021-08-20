Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02EC3F261D
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbhHTE4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233245AbhHTE4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E19E61004;
        Fri, 20 Aug 2021 04:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435327;
        bh=cv9KrtPsSBghN/WNo5MJufXS8wZ/1NqqlNuep5Ap5Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIvBON7Hk7rgsDQiLt5QZcdNwCE1VE+nnQDnzcaNTWBPV3PZMkLEcuLVjZuirhkoy
         hnZLjytU1DVkDLoNRcHttN9p+j9I8xuOkAsYTmLTtRG12GzkPcC3aHE856mP/rdc/3
         iANdhGCPnxN4y4CoU0GleA70gIJkL30D3dIMZwlLny47vuKrbL9muvLo+LjxBBqA7e
         pjbue77yuoQa/3FTgSRE5za/8U6WVwhnyue5Kyzy2Hb0+lTzW4J78gEektYM0QsJu6
         pjEzZa8MXEbKfNy5q/7PWA+Pu1v+IFNPhR4zM4tV2dtfpJWzOuJGg5VQdowqyFEFU8
         y97yyS1CqhfMA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: TC, Remove CONFIG_NET_TC_SKB_EXT dependency when restoring tunnel
Date:   Thu, 19 Aug 2021 21:55:07 -0700
Message-Id: <20210820045515.265297-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820045515.265297-1-saeed@kernel.org>
References: <20210820045515.265297-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

CONFIG_NET_TC_SKB_EXT controls the SKB extension support for
restoring chain ids. SKB extension is not required for tunnel
restoration.

Remove the CONFIG_NET_TC_SKB_EXT dependency as a pre-step for
using the tunnel restore methods for sample offload use cases.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c   | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index b35aa1ccd250..756b85349a95 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -516,7 +516,6 @@ void mlx5e_rep_tc_netdevice_event_unregister(struct mlx5e_rep_priv *rpriv)
 				 mlx5e_rep_indr_block_unbind);
 }
 
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 				 struct mlx5e_tc_update_priv *tc_priv,
 				 u32 tunnel_id)
@@ -615,6 +614,7 @@ static bool mlx5e_restore_skb(struct sk_buff *skb, u32 chain, u32 reg_c1,
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
 	u32 tunnel_id = (reg_c1 >> ESW_TUN_OFFSET) & TUNNEL_ID_MASK;
 
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	if (chain) {
 		struct mlx5_rep_uplink_priv *uplink_priv;
 		struct mlx5e_rep_priv *uplink_rpriv;
@@ -636,9 +636,10 @@ static bool mlx5e_restore_skb(struct sk_buff *skb, u32 chain, u32 reg_c1,
 					      zone_restore_id))
 			return false;
 	}
+#endif /* CONFIG_NET_TC_SKB_EXT */
+
 	return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
 }
-#endif /* CONFIG_NET_TC_SKB_EXT */
 
 bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 			     struct sk_buff *skb,
@@ -671,18 +672,14 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 		return false;
 	}
 
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN)
+	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
 		return mlx5e_restore_skb(skb, mapped_obj.chain, reg_c1, tc_priv);
-#endif /* CONFIG_NET_TC_SKB_EXT */
 #if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
-	if (mapped_obj.type == MLX5_MAPPED_OBJ_SAMPLE) {
+	} else if (mapped_obj.type == MLX5_MAPPED_OBJ_SAMPLE) {
 		mlx5e_tc_sample_skb(skb, &mapped_obj);
 		return false;
-	}
 #endif /* CONFIG_MLX5_TC_SAMPLE */
-	if (mapped_obj.type != MLX5_MAPPED_OBJ_SAMPLE &&
-	    mapped_obj.type != MLX5_MAPPED_OBJ_CHAIN) {
+	} else {
 		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
 		return false;
 	}
-- 
2.31.1

