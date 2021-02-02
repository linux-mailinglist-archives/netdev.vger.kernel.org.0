Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E5430B823
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhBBG5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232262AbhBBG4d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:56:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CB7564EE9;
        Tue,  2 Feb 2021 06:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248914;
        bh=6qtDGJs5pEFlXfJ8pnZNm953PyPUJ0i5dvkjJArlQDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N5KT0MYzc8L2H1dI5ynIA/zVP1TxdvRDkm8m1xuo9Xzq7XY2s8VgPncA1riFYLU22
         E39Ut5ttmtIAef+5s9I5Th4S8UyugF51cTuhKIqUPg/IZQHw0PQyVv4AbxWgQk+cPz
         MwAcpLBtX909mejz4AL+2Xl9TTvFbaR/wxfs/a0FrzBumJqt9KBm94zee+8bA5+LUP
         bwRTRDQavio1fxxacscmL1pY45uZt8HPKj/+Hpzu9qVRNgVwz77RlyLQBJZUu6+oCt
         dpeRXn7tf1OjT/Z1KxUtwgUynUKYTgwe48PSsbP5uYuFCQAVZaz+L6bPrKHhZW8w96
         SS2NlxJXYCkMA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/14] net/mlx5e: Move set vxlan nic info to profile init
Date:   Mon,  1 Feb 2021 22:54:48 -0800
Message-Id: <20210202065457.613312-6-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Since its profile dependent let's init the vxlan info
as part of profile initialization.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 14 ++++++++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e468d8329c2a..b9d2cb6f178d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5101,8 +5101,6 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->hw_features      |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_features      |= NETIF_F_HW_VLAN_STAG_TX;
 
-	mlx5e_vxlan_set_netdev_info(priv);
-
 	if (mlx5e_tunnel_any_tx_proto_supported(mdev)) {
 		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
 		netdev->hw_enc_features |= NETIF_F_TSO;
@@ -5229,6 +5227,7 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	int err;
 
 	mlx5e_build_nic_params(priv, &priv->xsk, netdev->mtu);
+	mlx5e_vxlan_set_netdev_info(priv);
 
 	mlx5e_timestamp_init(priv);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index c8a0f4c88d4b..45669a1db426 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -717,15 +717,12 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev,
 				   struct mlx5_core_dev *mdev,
 				   struct mlx5_eswitch_rep *rep)
 {
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-
 	SET_NETDEV_DEV(netdev, mdev->device);
 	if (rep->vport == MLX5_VPORT_UPLINK) {
 		netdev->netdev_ops = &mlx5e_netdev_ops_uplink_rep;
 		/* we want a persistent mac for the uplink rep */
 		mlx5_query_mac_address(mdev, netdev->dev_addr);
 		netdev->ethtool_ops = &mlx5e_uplink_rep_ethtool_ops;
-		mlx5e_vxlan_set_netdev_info(priv);
 		mlx5e_dcbnl_build_rep_netdev(netdev);
 	} else {
 		netdev->netdev_ops = &mlx5e_netdev_ops_rep;
@@ -767,6 +764,15 @@ static int mlx5e_init_rep(struct mlx5_core_dev *mdev,
 	return 0;
 }
 
+static int mlx5e_init_ul_rep(struct mlx5_core_dev *mdev,
+			     struct net_device *netdev)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+
+	mlx5e_vxlan_set_netdev_info(priv);
+	return mlx5e_init_rep(mdev, netdev);
+}
+
 static void mlx5e_cleanup_rep(struct mlx5e_priv *priv)
 {
 }
@@ -1165,7 +1171,7 @@ static const struct mlx5e_profile mlx5e_rep_profile = {
 };
 
 static const struct mlx5e_profile mlx5e_uplink_rep_profile = {
-	.init			= mlx5e_init_rep,
+	.init			= mlx5e_init_ul_rep,
 	.cleanup		= mlx5e_cleanup_rep,
 	.init_rx		= mlx5e_init_ul_rep_rx,
 	.cleanup_rx		= mlx5e_cleanup_ul_rep_rx,
-- 
2.29.2

