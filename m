Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA4B33E260
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhCPXvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229550AbhCPXvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DE3A64F99;
        Tue, 16 Mar 2021 23:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938678;
        bh=4zsfqjjuRzdkGGBobsVis5n4xBEayuH4OZnmptQ7Qm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wc/gyuNM0AEHr6Pzh805LzNnP9A7r3IaIZXad0Dp2CA+6nE9zydwtI1mBQyu+RXEj
         GKUTlGBI3qZDG5g8uz2SjNJw7Q/oMI3UKH3aA9Onwd+b7Yplcsvt42AYSYmulY1oj6
         EDkbn+iBj3cheOIwaFgjWUQOPOPEpQAMO0tomkAcrIy92u3B42i1Q04OO08G1k2W10
         dnMF32lYVPxJQIkyqZAgqJl/SD1DZCHZrKlgVmkmzNtExpsxAOtyzTD2y2RaXGQej+
         h/EVhylZPsFU300nGfDQBAumFHkylazdAhHCW0CnLCbo2hl3QYi0122EPeJuWPHu5w
         DxIm7RFxwgFxA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: Add offload stats ndos to nic netdev ops
Date:   Tue, 16 Mar 2021 16:51:02 -0700
Message-Id: <20210316235112.72626-6-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

We will re-use the native NIC port net device instance for the Uplink
representor, hence same ndos must be used.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 25 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  6 ++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  9 +++++++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index efd1a23ce7a0..39de3156877c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4452,6 +4452,29 @@ int mlx5e_get_vf_stats(struct net_device *dev,
 	return mlx5_eswitch_get_vport_stats(mdev->priv.eswitch, vf + 1,
 					    vf_stats);
 }
+
+static bool
+mlx5e_has_offload_stats(const struct net_device *dev, int attr_id)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
+	if (!mlx5e_is_uplink_rep(priv))
+		return false;
+
+	return mlx5e_rep_has_offload_stats(dev, attr_id);
+}
+
+static int
+mlx5e_get_offload_stats(int attr_id, const struct net_device *dev,
+			void *sp)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
+	if (!mlx5e_is_uplink_rep(priv))
+		return -EOPNOTSUPP;
+
+	return mlx5e_rep_get_offload_stats(attr_id, dev, sp);
+}
 #endif
 
 static bool mlx5e_tunnel_proto_supported_tx(struct mlx5_core_dev *mdev, u8 proto_type)
@@ -4808,6 +4831,8 @@ const struct net_device_ops mlx5e_netdev_ops = {
 	.ndo_get_vf_config       = mlx5e_get_vf_config,
 	.ndo_set_vf_link_state   = mlx5e_set_vf_link_state,
 	.ndo_get_vf_stats        = mlx5e_get_vf_stats,
+	.ndo_has_offload_stats   = mlx5e_has_offload_stats,
+	.ndo_get_offload_stats   = mlx5e_get_offload_stats,
 #endif
 	.ndo_get_devlink_port    = mlx5e_get_devlink_port,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 9156978c900d..b83652ed35cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -522,7 +522,7 @@ bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv)
 	return (rep->vport == MLX5_VPORT_UPLINK);
 }
 
-static bool mlx5e_rep_has_offload_stats(const struct net_device *dev, int attr_id)
+bool mlx5e_rep_has_offload_stats(const struct net_device *dev, int attr_id)
 {
 	switch (attr_id) {
 	case IFLA_OFFLOAD_XSTATS_CPU_HIT:
@@ -542,8 +542,8 @@ mlx5e_get_sw_stats64(const struct net_device *dev,
 	return 0;
 }
 
-static int mlx5e_rep_get_offload_stats(int attr_id, const struct net_device *dev,
-				       void *sp)
+int mlx5e_rep_get_offload_stats(int attr_id, const struct net_device *dev,
+				void *sp)
 {
 	switch (attr_id) {
 	case IFLA_OFFLOAD_XSTATS_CPU_HIT:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index d1696404cca9..931fa619cb01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -220,6 +220,10 @@ void mlx5e_rep_bond_unslave(struct mlx5_eswitch *esw,
 			    const struct net_device *lag_dev);
 int mlx5e_rep_bond_update(struct mlx5e_priv *priv, bool cleanup);
 
+bool mlx5e_rep_has_offload_stats(const struct net_device *dev, int attr_id);
+int mlx5e_rep_get_offload_stats(int attr_id, const struct net_device *dev,
+				void *sp);
+
 bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv);
 int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv);
 void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv);
@@ -240,6 +244,11 @@ static inline int mlx5e_add_sqs_fwd_rules(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv) {}
 static inline int mlx5e_rep_init(void) { return 0; };
 static inline void mlx5e_rep_cleanup(void) {};
+static inline bool mlx5e_rep_has_offload_stats(const struct net_device *dev,
+					       int attr_id) { return false; }
+static inline int mlx5e_rep_get_offload_stats(int attr_id,
+					      const struct net_device *dev,
+					      void *sp) { return -EOPNOTSUPP; }
 #endif
 
 static inline bool mlx5e_is_vport_rep(struct mlx5e_priv *priv)
-- 
2.30.2

