Return-Path: <netdev+bounces-8286-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79ED9723891
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 326A028142F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8312569D;
	Tue,  6 Jun 2023 07:12:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FDD566E
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60B5C433A0;
	Tue,  6 Jun 2023 07:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686035551;
	bh=sdoztlLc4f2m43rOwmJHkb69avnmq5w/ae/U7RVcCx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPsXPxyn0CuXPs9sdXoZkc0QIvV3evxVaJ4oSuYx61aCqQ3b15Nmhm02jMu4fbGFE
	 a3tlA82MxzgMlHJFlq5R18M9czcgr6/W7am4URxcTIDlaXL3q01xBG2IBHdlIP2y3O
	 941hGVyBKLmMXNJ+zYRAnJ4QerSdK8CgaetWWh60MFXC6phfuz/tu1d10BugZJK3wV
	 JV5MRQh2mmWUwXKD5LG/8s6mCSlBKMCNMz/K4i+mJCeBySDjzvgn5420c7EB/l9lRj
	 VL4zNB/58Fhh8YeiOgPxn8Kgiajc0rxOmUEE28fkZ/VJAZFa3XnYCb6wc9ENoIvBII
	 O68mKsa8bbwyA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 02/15] {net/RDMA}/mlx5: introduce lag_for_each_peer
Date: Tue,  6 Jun 2023 00:12:06 -0700
Message-Id: <20230606071219.483255-3-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606071219.483255-1-saeed@kernel.org>
References: <20230606071219.483255-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

Introduce a generic APIs to iterate over all the devices which are part
of the LAG. This API replace mlx5_lag_get_peer_mdev() which retrieve
only a single peer device from the lag.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c           | 98 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 24 +++--
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 21 +++-
 include/linux/mlx5/driver.h                   |  8 +-
 4 files changed, 100 insertions(+), 51 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index a4db22fe1883..c7a4ee896121 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -30,45 +30,65 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev,
 
 static void mlx5_ib_register_peer_vport_reps(struct mlx5_core_dev *mdev);
 
+static void mlx5_ib_num_ports_update(struct mlx5_core_dev *dev, u32 *num_ports)
+{
+	struct mlx5_core_dev *peer_dev;
+	int i;
+
+	mlx5_lag_for_each_peer_mdev(dev, peer_dev, i) {
+		u32 peer_num_ports = mlx5_eswitch_get_total_vports(peer_dev);
+
+		if (mlx5_lag_is_mpesw(peer_dev))
+			*num_ports += peer_num_ports;
+		else
+			/* Only 1 ib port is the representor for all uplinks */
+			*num_ports += peer_num_ports - 1;
+	}
+}
+
 static int
 mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 {
 	u32 num_ports = mlx5_eswitch_get_total_vports(dev);
+	struct mlx5_core_dev *lag_master = dev;
 	const struct mlx5_ib_profile *profile;
 	struct mlx5_core_dev *peer_dev;
 	struct mlx5_ib_dev *ibdev;
-	int second_uplink = false;
-	u32 peer_num_ports;
+	int new_uplink = false;
 	int vport_index;
 	int ret;
+	int i;
 
 	vport_index = rep->vport_index;
 
 	if (mlx5_lag_is_shared_fdb(dev)) {
-		peer_dev = mlx5_lag_get_peer_mdev(dev);
-		peer_num_ports = mlx5_eswitch_get_total_vports(peer_dev);
 		if (mlx5_lag_is_master(dev)) {
-			if (mlx5_lag_is_mpesw(dev))
-				num_ports += peer_num_ports;
-			else
-				num_ports += peer_num_ports - 1;
-
+			mlx5_ib_num_ports_update(dev, &num_ports);
 		} else {
 			if (rep->vport == MLX5_VPORT_UPLINK) {
 				if (!mlx5_lag_is_mpesw(dev))
 					return 0;
-				second_uplink = true;
+				new_uplink = true;
 			}
+			mlx5_lag_for_each_peer_mdev(dev, peer_dev, i) {
+				u32 peer_n_ports = mlx5_eswitch_get_total_vports(peer_dev);
+
+				if (mlx5_lag_is_master(peer_dev))
+					lag_master = peer_dev;
+				else if (!mlx5_lag_is_mpesw(dev))
+				/* Only 1 ib port is the representor for all uplinks */
+					peer_n_ports--;
 
-			vport_index += peer_num_ports;
-			dev = peer_dev;
+				if (mlx5_get_dev_index(peer_dev) < mlx5_get_dev_index(dev))
+					vport_index += peer_n_ports;
+			}
 		}
 	}
 
-	if (rep->vport == MLX5_VPORT_UPLINK && !second_uplink)
+	if (rep->vport == MLX5_VPORT_UPLINK && !new_uplink)
 		profile = &raw_eth_profile;
 	else
-		return mlx5_ib_set_vport_rep(dev, rep, vport_index);
+		return mlx5_ib_set_vport_rep(lag_master, rep, vport_index);
 
 	ibdev = ib_alloc_device(mlx5_ib_dev, ib_dev);
 	if (!ibdev)
@@ -85,8 +105,8 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	vport_index = rep->vport_index;
 	ibdev->port[vport_index].rep = rep;
 	ibdev->port[vport_index].roce.netdev =
-		mlx5_ib_get_rep_netdev(dev->priv.eswitch, rep->vport);
-	ibdev->mdev = dev;
+		mlx5_ib_get_rep_netdev(lag_master->priv.eswitch, rep->vport);
+	ibdev->mdev = lag_master;
 	ibdev->num_ports = num_ports;
 
 	ret = __mlx5_ib_add(ibdev, profile);
@@ -94,8 +114,8 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		goto fail_add;
 
 	rep->rep_data[REP_IB].priv = ibdev;
-	if (mlx5_lag_is_shared_fdb(dev))
-		mlx5_ib_register_peer_vport_reps(dev);
+	if (mlx5_lag_is_shared_fdb(lag_master))
+		mlx5_ib_register_peer_vport_reps(lag_master);
 
 	return 0;
 
@@ -118,23 +138,27 @@ mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	struct mlx5_ib_dev *dev = mlx5_ib_rep_to_dev(rep);
 	int vport_index = rep->vport_index;
 	struct mlx5_ib_port *port;
+	int i;
 
 	if (WARN_ON(!mdev))
 		return;
 
+	if (!dev)
+		return;
+
 	if (mlx5_lag_is_shared_fdb(mdev) &&
 	    !mlx5_lag_is_master(mdev)) {
-		struct mlx5_core_dev *peer_mdev;
-
 		if (rep->vport == MLX5_VPORT_UPLINK && !mlx5_lag_is_mpesw(mdev))
 			return;
-		peer_mdev = mlx5_lag_get_peer_mdev(mdev);
-		vport_index += mlx5_eswitch_get_total_vports(peer_mdev);
+		for (i = 0; i < dev->num_ports; i++) {
+			if (dev->port[i].rep == rep)
+				break;
+		}
+		if (WARN_ON(i == dev->num_ports))
+			return;
+		vport_index = i;
 	}
 
-	if (!dev)
-		return;
-
 	port = &dev->port[vport_index];
 	write_lock(&port->roce.netdev_lock);
 	port->roce.netdev = NULL;
@@ -143,16 +167,18 @@ mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 	port->rep = NULL;
 
 	if (rep->vport == MLX5_VPORT_UPLINK) {
-		struct mlx5_core_dev *peer_mdev;
-		struct mlx5_eswitch *esw;
 
 		if (mlx5_lag_is_shared_fdb(mdev) && !mlx5_lag_is_master(mdev))
 			return;
 
 		if (mlx5_lag_is_shared_fdb(mdev)) {
-			peer_mdev = mlx5_lag_get_peer_mdev(mdev);
-			esw = peer_mdev->priv.eswitch;
-			mlx5_eswitch_unregister_vport_reps(esw, REP_IB);
+			struct mlx5_core_dev *peer_mdev;
+			struct mlx5_eswitch *esw;
+
+			mlx5_lag_for_each_peer_mdev(mdev, peer_mdev, i) {
+				esw = peer_mdev->priv.eswitch;
+				mlx5_eswitch_unregister_vport_reps(esw, REP_IB);
+			}
 		}
 		__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
 	}
@@ -166,14 +192,14 @@ static const struct mlx5_eswitch_rep_ops rep_ops = {
 
 static void mlx5_ib_register_peer_vport_reps(struct mlx5_core_dev *mdev)
 {
-	struct mlx5_core_dev *peer_mdev = mlx5_lag_get_peer_mdev(mdev);
+	struct mlx5_core_dev *peer_mdev;
 	struct mlx5_eswitch *esw;
+	int i;
 
-	if (!peer_mdev)
-		return;
-
-	esw = peer_mdev->priv.eswitch;
-	mlx5_eswitch_register_vport_reps(esw, &rep_ops, REP_IB);
+	mlx5_lag_for_each_peer_mdev(mdev, peer_mdev, i) {
+		esw = peer_mdev->priv.eswitch;
+		mlx5_eswitch_register_vport_reps(esw, &rep_ops, REP_IB);
+	}
 }
 
 struct net_device *mlx5_ib_get_rep_netdev(struct mlx5_eswitch *esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 11374c3744c5..8a10ed4d8cbb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -244,16 +244,22 @@ static int mlx5_cmd_update_root_ft(struct mlx5_flow_root_namespace *ns,
 	    ft->type == FS_FT_FDB &&
 	    mlx5_lag_is_shared_fdb(dev) &&
 	    mlx5_lag_is_master(dev)) {
-		err = mlx5_cmd_set_slave_root_fdb(dev,
-						  mlx5_lag_get_peer_mdev(dev),
-						  !disconnect, (!disconnect) ?
-						  ft->id : 0);
-		if (err && !disconnect) {
-			MLX5_SET(set_flow_table_root_in, in, op_mod, 0);
-			MLX5_SET(set_flow_table_root_in, in, table_id,
-				 ns->root_ft->id);
-			mlx5_cmd_exec_in(dev, set_flow_table_root, in);
+		struct mlx5_core_dev *peer_dev;
+		int i;
+
+		mlx5_lag_for_each_peer_mdev(dev, peer_dev, i) {
+			err = mlx5_cmd_set_slave_root_fdb(dev, peer_dev, !disconnect,
+							  (!disconnect) ? ft->id : 0);
+			if (err && !disconnect) {
+				MLX5_SET(set_flow_table_root_in, in, op_mod, 0);
+				MLX5_SET(set_flow_table_root_in, in, table_id,
+					 ns->root_ft->id);
+				mlx5_cmd_exec_in(dev, set_flow_table_root, in);
+			}
+			if (err)
+				break;
 		}
+
 	}
 
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index c820f7d266de..c55e36e0571d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1519,26 +1519,37 @@ u8 mlx5_lag_get_num_ports(struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_lag_get_num_ports);
 
-struct mlx5_core_dev *mlx5_lag_get_peer_mdev(struct mlx5_core_dev *dev)
+struct mlx5_core_dev *mlx5_lag_get_next_peer_mdev(struct mlx5_core_dev *dev, int *i)
 {
 	struct mlx5_core_dev *peer_dev = NULL;
 	struct mlx5_lag *ldev;
 	unsigned long flags;
+	int idx;
 
 	spin_lock_irqsave(&lag_lock, flags);
 	ldev = mlx5_lag_dev(dev);
 	if (!ldev)
 		goto unlock;
 
-	peer_dev = ldev->pf[MLX5_LAG_P1].dev == dev ?
-			   ldev->pf[MLX5_LAG_P2].dev :
-			   ldev->pf[MLX5_LAG_P1].dev;
+	if (*i == ldev->ports)
+		goto unlock;
+	for (idx = *i; idx < ldev->ports; idx++)
+		if (ldev->pf[idx].dev != dev)
+			break;
+
+	if (idx == ldev->ports) {
+		*i = idx;
+		goto unlock;
+	}
+	*i = idx + 1;
+
+	peer_dev = ldev->pf[idx].dev;
 
 unlock:
 	spin_unlock_irqrestore(&lag_lock, flags);
 	return peer_dev;
 }
-EXPORT_SYMBOL(mlx5_lag_get_peer_mdev);
+EXPORT_SYMBOL(mlx5_lag_get_next_peer_mdev);
 
 int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 				 u64 *values,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 94d2be5848ae..9a744c48eec2 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1174,7 +1174,13 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 				 u64 *values,
 				 int num_counters,
 				 size_t *offsets);
-struct mlx5_core_dev *mlx5_lag_get_peer_mdev(struct mlx5_core_dev *dev);
+struct mlx5_core_dev *mlx5_lag_get_next_peer_mdev(struct mlx5_core_dev *dev, int *i);
+
+#define mlx5_lag_for_each_peer_mdev(dev, peer, i)				\
+	for (i = 0, peer = mlx5_lag_get_next_peer_mdev(dev, &i);		\
+	     peer;								\
+	     peer = mlx5_lag_get_next_peer_mdev(dev, &i))
+
 u8 mlx5_lag_get_num_ports(struct mlx5_core_dev *dev);
 struct mlx5_uars_page *mlx5_get_uars_page(struct mlx5_core_dev *mdev);
 void mlx5_put_uars_page(struct mlx5_core_dev *mdev, struct mlx5_uars_page *up);
-- 
2.40.1


