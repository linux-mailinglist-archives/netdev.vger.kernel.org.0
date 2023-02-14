Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7EF69707B
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbjBNWOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbjBNWOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:14:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E16D29E26
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:14:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D7D7B81F5C
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 22:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB87AC4339B;
        Tue, 14 Feb 2023 22:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676412851;
        bh=luITvSp0blgKnR0KUenAutT1BGd9dYUNkH0KQdiQY3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wl7dGEMC6aLbfPz1HLA3SV1G8hIQHfPZhUZQwFpOPq4UVlr2w2h++BbFX9n1SBv+f
         30L7BtbVa2ye9WY9YnFaEwfJT3YzqorhfphKpAx2ofoONblx3eycXQOOAulXr0J6W5
         4FOZ1DaafYVekY0bdWf3tf6jyB5D1boyzb8uUgXJS7cq1pke6qel8bMjzK64ueikXP
         ar0PEwpNdYoM5l3PYIwygk0uH2y8TobThgxqduTZLzBeaOLz7U9PRFASwRIC6pP4Ng
         M7pTxNgHB08R929pSAfh4t3slo3BAgJbmLUXXMWKPbhd9fdqKwTQy+IlTyE8J/MVIL
         wnkYdu6kDvayA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next V2 05/15] net/mlx5: Lag, Add single RDMA device in multiport mode
Date:   Tue, 14 Feb 2023 14:12:29 -0800
Message-Id: <20230214221239.159033-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214221239.159033-1-saeed@kernel.org>
References: <20230214221239.159033-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

In MultiPort E-Switch mode a single RDMA is created. This device has multiple
RDMA ports that represent the uplink ports that are connected to the E-Switch.
Account for this when creating the RDMA device so it has an additional port for
the non native uplink.

As a side effect of this patch, use shared fdb in multiport eswitch mode.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c           | 18 ++++++---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  6 +--
 .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  3 ++
 .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 37 +++++++++++++++----
 include/linux/mlx5/driver.h                   |  1 +
 5 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 52821485371a..ddcfc116b19a 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -37,6 +37,7 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	const struct mlx5_ib_profile *profile;
 	struct mlx5_core_dev *peer_dev;
 	struct mlx5_ib_dev *ibdev;
+	int second_uplink = false;
 	u32 peer_num_ports;
 	int vport_index;
 	int ret;
@@ -47,17 +48,24 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		peer_dev = mlx5_lag_get_peer_mdev(dev);
 		peer_num_ports = mlx5_eswitch_get_total_vports(peer_dev);
 		if (mlx5_lag_is_master(dev)) {
-			/* Only 1 ib port is the representor for both uplinks */
-			num_ports += peer_num_ports - 1;
+			if (mlx5_lag_is_mpesw(dev))
+				num_ports += peer_num_ports;
+			else
+				num_ports += peer_num_ports - 1;
+
 		} else {
-			if (rep->vport == MLX5_VPORT_UPLINK)
-				return 0;
+			if (rep->vport == MLX5_VPORT_UPLINK) {
+				if (!mlx5_lag_is_mpesw(dev))
+					return 0;
+				second_uplink = true;
+			}
+
 			vport_index += peer_num_ports;
 			dev = peer_dev;
 		}
 	}
 
-	if (rep->vport == MLX5_VPORT_UPLINK)
+	if (rep->vport == MLX5_VPORT_UPLINK && !second_uplink)
 		profile = &raw_eth_profile;
 	else
 		return mlx5_ib_set_vport_rep(dev, rep, vport_index);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 301994741b08..5d331b940f4d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -644,7 +644,7 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 	return 0;
 }
 
-static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
+int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
@@ -721,7 +721,7 @@ bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 	return true;
 }
 
-static void mlx5_lag_add_devices(struct mlx5_lag *ldev)
+void mlx5_lag_add_devices(struct mlx5_lag *ldev)
 {
 	int i;
 
@@ -738,7 +738,7 @@ static void mlx5_lag_add_devices(struct mlx5_lag *ldev)
 	}
 }
 
-static void mlx5_lag_remove_devices(struct mlx5_lag *ldev)
+void mlx5_lag_remove_devices(struct mlx5_lag *ldev)
 {
 	int i;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 2dbd96a86ef8..bc1f1dd3e283 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -120,5 +120,8 @@ void mlx5_infer_tx_enabled(struct lag_tracker *tracker, u8 num_ports,
 void mlx5_ldev_add_debugfs(struct mlx5_core_dev *dev);
 void mlx5_ldev_remove_debugfs(struct dentry *dbg);
 void mlx5_disable_lag(struct mlx5_lag *ldev);
+void mlx5_lag_remove_devices(struct mlx5_lag *ldev);
+int mlx5_deactivate_lag(struct mlx5_lag *ldev);
+void mlx5_lag_add_devices(struct mlx5_lag *ldev);
 
 #endif /* __MLX5_LAG_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index 2f7f2af312d7..0c0ef600f643 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -67,15 +67,16 @@ static int mlx5_mpesw_metadata_set(struct mlx5_lag *ldev)
 
 static int enable_mpesw(struct mlx5_lag *ldev)
 {
-	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
+	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
 	int err;
 
 	if (ldev->mode != MLX5_LAG_MODE_NONE)
 		return -EINVAL;
 
-	if (mlx5_eswitch_mode(dev) != MLX5_ESWITCH_OFFLOADS ||
-	    !MLX5_CAP_PORT_SELECTION(dev, port_select_flow_table) ||
-	    !MLX5_CAP_GEN(dev, create_lag_when_not_master_up) ||
+	if (mlx5_eswitch_mode(dev0) != MLX5_ESWITCH_OFFLOADS ||
+	    !MLX5_CAP_PORT_SELECTION(dev0, port_select_flow_table) ||
+	    !MLX5_CAP_GEN(dev0, create_lag_when_not_master_up) ||
 	    !mlx5_lag_check_prereq(ldev))
 		return -EOPNOTSUPP;
 
@@ -83,15 +84,32 @@ static int enable_mpesw(struct mlx5_lag *ldev)
 	if (err)
 		return err;
 
-	err = mlx5_activate_lag(ldev, NULL, MLX5_LAG_MODE_MPESW, false);
+	mlx5_lag_remove_devices(ldev);
+
+	err = mlx5_activate_lag(ldev, NULL, MLX5_LAG_MODE_MPESW, true);
 	if (err) {
-		mlx5_core_warn(dev, "Failed to create LAG in MPESW mode (%d)\n", err);
-		goto out_err;
+		mlx5_core_warn(dev0, "Failed to create LAG in MPESW mode (%d)\n", err);
+		goto err_add_devices;
 	}
 
+	dev0->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
+	mlx5_rescan_drivers_locked(dev0);
+	err = mlx5_eswitch_reload_reps(dev0->priv.eswitch);
+	if (!err)
+		err = mlx5_eswitch_reload_reps(dev1->priv.eswitch);
+	if (err)
+		goto err_rescan_drivers;
+
 	return 0;
 
-out_err:
+err_rescan_drivers:
+	dev0->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
+	mlx5_rescan_drivers_locked(dev0);
+	mlx5_deactivate_lag(ldev);
+err_add_devices:
+	mlx5_lag_add_devices(ldev);
+	mlx5_eswitch_reload_reps(dev0->priv.eswitch);
+	mlx5_eswitch_reload_reps(dev1->priv.eswitch);
 	mlx5_mpesw_metadata_cleanup(ldev);
 	return err;
 }
@@ -109,6 +127,7 @@ static void mlx5_mpesw_work(struct work_struct *work)
 	struct mlx5_mpesw_work_st *mpesww = container_of(work, struct mlx5_mpesw_work_st, work);
 	struct mlx5_lag *ldev = mpesww->lag;
 
+	mlx5_dev_list_lock();
 	mutex_lock(&ldev->lock);
 	if (ldev->mode_changes_in_progress) {
 		mpesww->result = -EAGAIN;
@@ -121,6 +140,7 @@ static void mlx5_mpesw_work(struct work_struct *work)
 		disable_mpesw(ldev);
 unlock:
 	mutex_unlock(&ldev->lock);
+	mlx5_dev_list_unlock();
 	complete(&mpesww->comp);
 }
 
@@ -187,3 +207,4 @@ bool mlx5_lag_is_mpesw(struct mlx5_core_dev *dev)
 
 	return ldev && ldev->mode == MLX5_LAG_MODE_MPESW;
 }
+EXPORT_SYMBOL(mlx5_lag_is_mpesw);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a4bb5842a948..c9259350cdfc 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1162,6 +1162,7 @@ bool mlx5_lag_is_active(struct mlx5_core_dev *dev);
 bool mlx5_lag_mode_is_hash(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_master(struct mlx5_core_dev *dev);
 bool mlx5_lag_is_shared_fdb(struct mlx5_core_dev *dev);
+bool mlx5_lag_is_mpesw(struct mlx5_core_dev *dev);
 struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev);
 u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 			   struct net_device *slave);
-- 
2.39.1

