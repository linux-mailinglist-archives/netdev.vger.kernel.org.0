Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21863DF85C
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhHCXUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233369AbhHCXUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:20:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E3FD60F70;
        Tue,  3 Aug 2021 23:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032820;
        bh=XIEHZdKku3R1IkD1Nyx3gMbhq0oS9QVpqCEARSwY/9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uuhhiD+URfWvErrxCIKZVrRZ6EeXMuSYG9grgYlG1YpBUsixWRVFgXokHnfigNl29
         yJ2/AwtOXEWUJh6urqQ1ZeAc/MZpr6J0HOQv77+NI9cywobDY8yOAJ8vWAcqLgtnLf
         85e8wx84yij8jWJ8RK+3B5SUobuwdU7SpZSJCCVVjZtxlF1x4l4O3eEM2z+/Fv/wxG
         9CejPOYZ/orEmiNG5j/80gs3kZQsP4/vzwzWO0CjBG6AfuP6wGHObLFqwSK4qviTsZ
         sdZppvsbhVnwTREfkH57QHyGA54TAgsLUNBgK7GBtm/zSDmHsG3AdY8C8HOhEdXOEV
         6O82s2XOM7Ptw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH mlx5-next 05/14] RDMA/mlx5: Add shared FDB support
Date:   Tue,  3 Aug 2021 16:19:50 -0700
Message-Id: <20210803231959.26513-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803231959.26513-1-saeed@kernel.org>
References: <20210803231959.26513-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Shared FDB allows to create a single RDMA device that holds representors
from both eswitches. As shared FDB is only active when both uplink
representors are enslaved there is a single RDMA port that represents
both uplinks.

The number of ports is the number of vports on both eswitches minus one
as we only need 1 port for both uplinks.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c | 75 ++++++++++++++++++++++++++---
 drivers/infiniband/hw/mlx5/main.c   | 44 ++++++++++-------
 2 files changed, 95 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index bf5a6e4d1c03..52821485371a 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -8,13 +8,15 @@
 #include "srq.h"
 
 static int
-mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
+mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev,
+		      struct mlx5_eswitch_rep *rep,
+		      int vport_index)
 {
 	struct mlx5_ib_dev *ibdev;
-	int vport_index;
 
 	ibdev = mlx5_eswitch_uplink_get_proto_dev(dev->priv.eswitch, REP_IB);
-	vport_index = rep->vport_index;
+	if (!ibdev)
+		return -EINVAL;
 
 	ibdev->port[vport_index].rep = rep;
 	rep->rep_data[REP_IB].priv = ibdev;
@@ -26,19 +28,39 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	return 0;
 }
 
+static void mlx5_ib_register_peer_vport_reps(struct mlx5_core_dev *mdev);
+
 static int
 mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
 	u32 num_ports = mlx5_eswitch_get_total_vports(dev);
 	const struct mlx5_ib_profile *profile;
+	struct mlx5_core_dev *peer_dev;
 	struct mlx5_ib_dev *ibdev;
+	u32 peer_num_ports;
 	int vport_index;
 	int ret;
 
+	vport_index = rep->vport_index;
+
+	if (mlx5_lag_is_shared_fdb(dev)) {
+		peer_dev = mlx5_lag_get_peer_mdev(dev);
+		peer_num_ports = mlx5_eswitch_get_total_vports(peer_dev);
+		if (mlx5_lag_is_master(dev)) {
+			/* Only 1 ib port is the representor for both uplinks */
+			num_ports += peer_num_ports - 1;
+		} else {
+			if (rep->vport == MLX5_VPORT_UPLINK)
+				return 0;
+			vport_index += peer_num_ports;
+			dev = peer_dev;
+		}
+	}
+
 	if (rep->vport == MLX5_VPORT_UPLINK)
 		profile = &raw_eth_profile;
 	else
-		return mlx5_ib_set_vport_rep(dev, rep);
+		return mlx5_ib_set_vport_rep(dev, rep, vport_index);
 
 	ibdev = ib_alloc_device(mlx5_ib_dev, ib_dev);
 	if (!ibdev)
@@ -64,6 +86,8 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		goto fail_add;
 
 	rep->rep_data[REP_IB].priv = ibdev;
+	if (mlx5_lag_is_shared_fdb(dev))
+		mlx5_ib_register_peer_vport_reps(dev);
 
 	return 0;
 
@@ -82,18 +106,45 @@ static void *mlx5_ib_rep_to_dev(struct mlx5_eswitch_rep *rep)
 static void
 mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 {
+	struct mlx5_core_dev *mdev = mlx5_eswitch_get_core_dev(rep->esw);
 	struct mlx5_ib_dev *dev = mlx5_ib_rep_to_dev(rep);
+	int vport_index = rep->vport_index;
 	struct mlx5_ib_port *port;
 
-	port = &dev->port[rep->vport_index];
+	if (WARN_ON(!mdev))
+		return;
+
+	if (mlx5_lag_is_shared_fdb(mdev) &&
+	    !mlx5_lag_is_master(mdev)) {
+		struct mlx5_core_dev *peer_mdev;
+
+		if (rep->vport == MLX5_VPORT_UPLINK)
+			return;
+		peer_mdev = mlx5_lag_get_peer_mdev(mdev);
+		vport_index += mlx5_eswitch_get_total_vports(peer_mdev);
+	}
+
+	if (!dev)
+		return;
+
+	port = &dev->port[vport_index];
 	write_lock(&port->roce.netdev_lock);
 	port->roce.netdev = NULL;
 	write_unlock(&port->roce.netdev_lock);
 	rep->rep_data[REP_IB].priv = NULL;
 	port->rep = NULL;
 
-	if (rep->vport == MLX5_VPORT_UPLINK)
+	if (rep->vport == MLX5_VPORT_UPLINK) {
+		struct mlx5_core_dev *peer_mdev;
+		struct mlx5_eswitch *esw;
+
+		if (mlx5_lag_is_shared_fdb(mdev)) {
+			peer_mdev = mlx5_lag_get_peer_mdev(mdev);
+			esw = peer_mdev->priv.eswitch;
+			mlx5_eswitch_unregister_vport_reps(esw, REP_IB);
+		}
 		__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
+	}
 }
 
 static const struct mlx5_eswitch_rep_ops rep_ops = {
@@ -102,6 +153,18 @@ static const struct mlx5_eswitch_rep_ops rep_ops = {
 	.get_proto_dev = mlx5_ib_rep_to_dev,
 };
 
+static void mlx5_ib_register_peer_vport_reps(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_core_dev *peer_mdev = mlx5_lag_get_peer_mdev(mdev);
+	struct mlx5_eswitch *esw;
+
+	if (!peer_mdev)
+		return;
+
+	esw = peer_mdev->priv.eswitch;
+	mlx5_eswitch_register_vport_reps(esw, &rep_ops, REP_IB);
+}
+
 struct net_device *mlx5_ib_get_rep_netdev(struct mlx5_eswitch *esw,
 					  u16 vport_num)
 {
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 094c976b1eed..ae05e143401c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -126,6 +126,7 @@ static int get_port_state(struct ib_device *ibdev,
 
 static struct mlx5_roce *mlx5_get_rep_roce(struct mlx5_ib_dev *dev,
 					   struct net_device *ndev,
+					   struct net_device *upper,
 					   u32 *port_num)
 {
 	struct net_device *rep_ndev;
@@ -137,6 +138,14 @@ static struct mlx5_roce *mlx5_get_rep_roce(struct mlx5_ib_dev *dev,
 		if (!port->rep)
 			continue;
 
+		if (upper == ndev && port->rep->vport == MLX5_VPORT_UPLINK) {
+			*port_num = i + 1;
+			return &port->roce;
+		}
+
+		if (upper && port->rep->vport == MLX5_VPORT_UPLINK)
+			continue;
+
 		read_lock(&port->roce.netdev_lock);
 		rep_ndev = mlx5_ib_get_rep_netdev(port->rep->esw,
 						  port->rep->vport);
@@ -196,11 +205,12 @@ static int mlx5_netdev_event(struct notifier_block *this,
 		}
 
 		if (ibdev->is_rep)
-			roce = mlx5_get_rep_roce(ibdev, ndev, &port_num);
+			roce = mlx5_get_rep_roce(ibdev, ndev, upper, &port_num);
 		if (!roce)
 			return NOTIFY_DONE;
-		if ((upper == ndev || (!upper && ndev == roce->netdev))
-		    && ibdev->ib_active) {
+		if ((upper == ndev ||
+		     ((!upper || ibdev->is_rep) && ndev == roce->netdev)) &&
+		    ibdev->ib_active) {
 			struct ib_event ibev = { };
 			enum ib_port_state port_state;
 
@@ -3012,7 +3022,7 @@ static int mlx5_eth_lag_init(struct mlx5_ib_dev *dev)
 	struct mlx5_flow_table *ft;
 	int err;
 
-	if (!ns || !mlx5_lag_is_roce(mdev))
+	if (!ns || !mlx5_lag_is_active(mdev))
 		return 0;
 
 	err = mlx5_cmd_create_vport_lag(mdev);
@@ -3074,9 +3084,11 @@ static int mlx5_enable_eth(struct mlx5_ib_dev *dev)
 {
 	int err;
 
-	err = mlx5_nic_vport_enable_roce(dev->mdev);
-	if (err)
-		return err;
+	if (!dev->is_rep && dev->profile != &raw_eth_profile) {
+		err = mlx5_nic_vport_enable_roce(dev->mdev);
+		if (err)
+			return err;
+	}
 
 	err = mlx5_eth_lag_init(dev);
 	if (err)
@@ -3085,7 +3097,8 @@ static int mlx5_enable_eth(struct mlx5_ib_dev *dev)
 	return 0;
 
 err_disable_roce:
-	mlx5_nic_vport_disable_roce(dev->mdev);
+	if (!dev->is_rep && dev->profile != &raw_eth_profile)
+		mlx5_nic_vport_disable_roce(dev->mdev);
 
 	return err;
 }
@@ -3093,7 +3106,8 @@ static int mlx5_enable_eth(struct mlx5_ib_dev *dev)
 static void mlx5_disable_eth(struct mlx5_ib_dev *dev)
 {
 	mlx5_eth_lag_cleanup(dev);
-	mlx5_nic_vport_disable_roce(dev->mdev);
+	if (!dev->is_rep && dev->profile != &raw_eth_profile)
+		mlx5_nic_vport_disable_roce(dev->mdev);
 }
 
 static int mlx5_ib_rn_get_params(struct ib_device *device, u32 port_num,
@@ -3950,12 +3964,7 @@ static int mlx5_ib_roce_init(struct mlx5_ib_dev *dev)
 
 		/* Register only for native ports */
 		err = mlx5_add_netdev_notifier(dev, port_num);
-		if (err || dev->is_rep || !mlx5_is_roce_init_enabled(mdev))
-			/*
-			 * We don't enable ETH interface for
-			 * 1. IB representors
-			 * 2. User disabled ROCE through devlink interface
-			 */
+		if (err)
 			return err;
 
 		err = mlx5_enable_eth(dev);
@@ -3980,8 +3989,7 @@ static void mlx5_ib_roce_cleanup(struct mlx5_ib_dev *dev)
 	ll = mlx5_port_type_cap_to_rdma_ll(port_type_cap);
 
 	if (ll == IB_LINK_LAYER_ETHERNET) {
-		if (!dev->is_rep)
-			mlx5_disable_eth(dev);
+		mlx5_disable_eth(dev);
 
 		port_num = mlx5_core_native_port_num(dev->mdev) - 1;
 		mlx5_remove_netdev_notifier(dev, port_num);
@@ -4037,7 +4045,7 @@ static int mlx5_ib_stage_ib_reg_init(struct mlx5_ib_dev *dev)
 {
 	const char *name;
 
-	if (!mlx5_lag_is_roce(dev->mdev))
+	if (!mlx5_lag_is_active(dev->mdev))
 		name = "mlx5_%d";
 	else
 		name = "mlx5_bond_%d";
-- 
2.31.1

