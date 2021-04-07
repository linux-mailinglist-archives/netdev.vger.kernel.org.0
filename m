Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D713562C2
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348573AbhDGEzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348553AbhDGEyt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 267E9613CC;
        Wed,  7 Apr 2021 04:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771280;
        bh=I/ssk4VeS2QjpRNm1i4FVRlr4Fa4Je8Bv3twNCffne8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDp6LCK08Dl1Wye0Q8HXCvfLVVPLTZbBfVwGR4c6W2dsQ5M1JwCMxjS0TBst3pjtN
         GqSSafkMLP3LWprFdxsBoSD8Q6aVsXAt0WhJrak41AGuG9Xry0gOGlBFA1USpQiRSK
         Px/a147JBJS9RV/r13FqY1Ga/oRT/R1WjdaKqAEoTahRLh+mf5g3sn4GWcliMCOaP9
         cwCShRiGUipBP103jj1w1LNdXyoNqVyM/AwwurrzcaiIxDYlPnusMwdBZ4MPuw7F/N
         cscW0hqWftV+Dw9/ccxhXLZZVRY8fUxNoPKDbIccQ8QScZPg5DgrwUh8AyYIvFSBXB
         gwUvd1tbFqOVg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/13] net/mlx5e: TC, Refactor tc update skb function
Date:   Tue,  6 Apr 2021 21:54:19 -0700
Message-Id: <20210407045421.148987-12-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407045421.148987-1-saeed@kernel.org>
References: <20210407045421.148987-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

As a pre-step to process sampled packet in this function.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 59 +++++++++++--------
 1 file changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 9b55a5c394d0..a25ec309d298 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -611,20 +611,46 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 
 	return true;
 }
+
+static bool mlx5e_restore_skb(struct sk_buff *skb, u32 chain, u32 reg_c1,
+			      struct mlx5e_tc_update_priv *tc_priv)
+{
+	struct mlx5e_priv *priv = netdev_priv(skb->dev);
+	u32 tunnel_id = reg_c1 >> ESW_TUN_OFFSET;
+
+	if (chain) {
+		struct mlx5_rep_uplink_priv *uplink_priv;
+		struct mlx5e_rep_priv *uplink_rpriv;
+		struct tc_skb_ext *tc_skb_ext;
+		struct mlx5_eswitch *esw;
+		u32 zone_restore_id;
+
+		tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
+		if (!tc_skb_ext) {
+			WARN_ON(1);
+			return false;
+		}
+		tc_skb_ext->chain = chain;
+		zone_restore_id = reg_c1 & ESW_ZONE_ID_MASK;
+		esw = priv->mdev->priv.eswitch;
+		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+		uplink_priv = &uplink_rpriv->uplink_priv;
+		if (!mlx5e_tc_ct_restore_flow(uplink_priv->ct_priv, skb,
+					      zone_restore_id))
+			return false;
+	}
+	return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
+}
 #endif /* CONFIG_NET_TC_SKB_EXT */
 
 bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 			     struct sk_buff *skb,
 			     struct mlx5e_tc_update_priv *tc_priv)
 {
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	u32 reg_c0, reg_c1, tunnel_id, zone_restore_id;
-	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct mlx5_mapped_obj mapped_obj;
-	struct tc_skb_ext *tc_skb_ext;
 	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
+	u32 reg_c0, reg_c1;
 	int err;
 
 	reg_c0 = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
@@ -640,7 +666,6 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 
 	priv = netdev_priv(skb->dev);
 	esw = priv->mdev->priv.eswitch;
-
 	err = mapping_find(esw->offloads.reg_c0_obj_pool, reg_c0, &mapped_obj);
 	if (err) {
 		netdev_dbg(priv->netdev,
@@ -649,31 +674,13 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 		return false;
 	}
 
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
-		if (mapped_obj.chain) {
-			tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
-			if (!tc_skb_ext) {
-				WARN_ON(1);
-				return false;
-			}
-
-			tc_skb_ext->chain = mapped_obj.chain;
-
-			zone_restore_id = reg_c1 & ESW_ZONE_ID_MASK;
-
-			uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-			uplink_priv = &uplink_rpriv->uplink_priv;
-			if (!mlx5e_tc_ct_restore_flow(uplink_priv->ct_priv, skb,
-						      zone_restore_id))
-				return false;
-		}
+		return mlx5e_restore_skb(skb, mapped_obj.chain, reg_c1, tc_priv);
 	} else {
 		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
 		return false;
 	}
-
-	tunnel_id = reg_c1 >> ESW_TUN_OFFSET;
-	return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
 #endif /* CONFIG_NET_TC_SKB_EXT */
 
 	return true;
-- 
2.30.2

