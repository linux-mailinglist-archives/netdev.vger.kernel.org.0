Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8EA65E49F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjAEETC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjAEESa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:18:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD763D9F1;
        Wed,  4 Jan 2023 20:18:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCEFC6149B;
        Thu,  5 Jan 2023 04:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157AAC433F0;
        Thu,  5 Jan 2023 04:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672892296;
        bh=tjhtT0Naj9vHUE5H+m7L/09EBKqOtVE6Fou6FAGE1C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W46y3s5TXv7UoaINszA/+qYBUD1bCEQ3RYpyjJhicjj+WyTRuzbYUaAQxvQNjgtpw
         2IFloF7WR2iXUVmhX806CzwfY1HMF5mdzlTAc7aDdEUv71GDp+V+GGQz6WgdcPIPR9
         vBqfUh8a7c2J8xUtjP7lPTzSBjOMCRY0dlcTcnteviqZHklijFyC8XoPl7pSApQEA7
         pPO1QKRQFdIw5mQ0UXgwnFcI6G8AEdCqSzERXIvico5H0eB4EebtYYodhagLRpiP6C
         5JmjgibGSIe9FLODTuflkjBfgW/g3XATTuWbgoKDxxZOeLGLk2qIFQih4v1g0mzZh+
         foV9OuUjaZusg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH mlx5-next 3/8] RDMA/mlx5: Track netdev to avoid deadlock during netdev notifier unregister
Date:   Wed,  4 Jan 2023 20:17:51 -0800
Message-Id: <20230105041756.677120-4-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105041756.677120-1-saeed@kernel.org>
References: <20230105041756.677120-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

When removing a network namespace with mlx5 devlink instance being in
it, following callchain is performed:

cleanup_net (takes down_read(&pernet_ops_rwsem)
devlink_pernet_pre_exit()
devlink_reload()
mlx5_devlink_reload_down()
mlx5_unload_one_devl_locked()
mlx5_detach_device()
del_adev()
mlx5r_remove()
__mlx5_ib_remove()
mlx5_ib_roce_cleanup()
mlx5_remove_netdev_notifier()
unregister_netdevice_notifier (takes down_write(&pernet_ops_rwsem)

This deadlocks.

Resolve this by converting to register_netdevice_notifier_dev_net()
which does not take pernet_ops_rwsem and moves the notifier block around
according to netdev it takes as arg.

Use previously introduced netdev added/removed events to track uplink
netdev to be used for register_netdevice_notifier_dev_net() purposes.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c             | 78 +++++++++++++------
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  3 +
 .../net/ethernet/mellanox/mlx5/core/events.c  |  2 +
 3 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c669ef6e47e7..dc32e4518a28 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3012,26 +3012,63 @@ static void mlx5_eth_lag_cleanup(struct mlx5_ib_dev *dev)
 	}
 }
 
-static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u32 port_num)
+static void mlx5_netdev_notifier_register(struct mlx5_roce *roce,
+					  struct net_device *netdev)
 {
 	int err;
 
-	dev->port[port_num].roce.nb.notifier_call = mlx5_netdev_event;
-	err = register_netdevice_notifier(&dev->port[port_num].roce.nb);
-	if (err) {
-		dev->port[port_num].roce.nb.notifier_call = NULL;
-		return err;
-	}
+	if (roce->tracking_netdev)
+		return;
+	roce->tracking_netdev = netdev;
+	roce->nb.notifier_call = mlx5_netdev_event;
+	err = register_netdevice_notifier_dev_net(netdev, &roce->nb, &roce->nn);
+	WARN_ON(err);
+}
 
-	return 0;
+static void mlx5_netdev_notifier_unregister(struct mlx5_roce *roce)
+{
+	if (!roce->tracking_netdev)
+		return;
+	unregister_netdevice_notifier_dev_net(roce->tracking_netdev, &roce->nb,
+					      &roce->nn);
+	roce->tracking_netdev = NULL;
 }
 
-static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u32 port_num)
+static int mlx5e_mdev_notifier_event(struct notifier_block *nb,
+				     unsigned long event, void *data)
 {
-	if (dev->port[port_num].roce.nb.notifier_call) {
-		unregister_netdevice_notifier(&dev->port[port_num].roce.nb);
-		dev->port[port_num].roce.nb.notifier_call = NULL;
+	struct mlx5_roce *roce = container_of(nb, struct mlx5_roce, mdev_nb);
+	struct net_device *netdev = data;
+
+	switch (event) {
+	case MLX5_DRIVER_EVENT_UPLINK_NETDEV:
+		if (netdev)
+			mlx5_netdev_notifier_register(roce, netdev);
+		else
+			mlx5_netdev_notifier_unregister(roce);
+		break;
+	default:
+		return NOTIFY_DONE;
 	}
+
+	return NOTIFY_OK;
+}
+
+static void mlx5_mdev_netdev_track(struct mlx5_ib_dev *dev, u32 port_num)
+{
+	struct mlx5_roce *roce = &dev->port[port_num].roce;
+
+	roce->mdev_nb.notifier_call = mlx5e_mdev_notifier_event;
+	mlx5_blocking_notifier_register(dev->mdev, &roce->mdev_nb);
+	mlx5_core_uplink_netdev_event_replay(dev->mdev);
+}
+
+static void mlx5_mdev_netdev_untrack(struct mlx5_ib_dev *dev, u32 port_num)
+{
+	struct mlx5_roce *roce = &dev->port[port_num].roce;
+
+	mlx5_blocking_notifier_unregister(dev->mdev, &roce->mdev_nb);
+	mlx5_netdev_notifier_unregister(roce);
 }
 
 static int mlx5_enable_eth(struct mlx5_ib_dev *dev)
@@ -3138,7 +3175,7 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 	if (mpi->mdev_events.notifier_call)
 		mlx5_notifier_unregister(mpi->mdev, &mpi->mdev_events);
 	mpi->mdev_events.notifier_call = NULL;
-	mlx5_remove_netdev_notifier(ibdev, port_num);
+	mlx5_mdev_netdev_untrack(ibdev, port_num);
 	spin_lock(&port->mp.mpi_lock);
 
 	comps = mpi->mdev_refcnt;
@@ -3196,12 +3233,7 @@ static bool mlx5_ib_bind_slave_port(struct mlx5_ib_dev *ibdev,
 	if (err)
 		goto unbind;
 
-	err = mlx5_add_netdev_notifier(ibdev, port_num);
-	if (err) {
-		mlx5_ib_err(ibdev, "failed adding netdev notifier for port %u\n",
-			    port_num + 1);
-		goto unbind;
-	}
+	mlx5_mdev_netdev_track(ibdev, port_num);
 
 	mpi->mdev_events.notifier_call = mlx5_ib_event_slave_port;
 	mlx5_notifier_register(mpi->mdev, &mpi->mdev_events);
@@ -3909,9 +3941,7 @@ static int mlx5_ib_roce_init(struct mlx5_ib_dev *dev)
 		port_num = mlx5_core_native_port_num(dev->mdev) - 1;
 
 		/* Register only for native ports */
-		err = mlx5_add_netdev_notifier(dev, port_num);
-		if (err)
-			return err;
+		mlx5_mdev_netdev_track(dev, port_num);
 
 		err = mlx5_enable_eth(dev);
 		if (err)
@@ -3920,7 +3950,7 @@ static int mlx5_ib_roce_init(struct mlx5_ib_dev *dev)
 
 	return 0;
 cleanup:
-	mlx5_remove_netdev_notifier(dev, port_num);
+	mlx5_mdev_netdev_untrack(dev, port_num);
 	return err;
 }
 
@@ -3938,7 +3968,7 @@ static void mlx5_ib_roce_cleanup(struct mlx5_ib_dev *dev)
 		mlx5_disable_eth(dev);
 
 		port_num = mlx5_core_native_port_num(dev->mdev) - 1;
-		mlx5_remove_netdev_notifier(dev, port_num);
+		mlx5_mdev_netdev_untrack(dev, port_num);
 	}
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8b91babdd4c0..7394e7f36ba7 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -832,6 +832,9 @@ struct mlx5_roce {
 	rwlock_t		netdev_lock;
 	struct net_device	*netdev;
 	struct notifier_block	nb;
+	struct netdev_net_notifier nn;
+	struct notifier_block	mdev_nb;
+	struct net_device	*tracking_netdev;
 	atomic_t		tx_port_affinity;
 	enum ib_port_state last_port_state;
 	struct mlx5_ib_dev	*dev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 9459e56ee90a..718cf09c28ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -424,6 +424,7 @@ int mlx5_blocking_notifier_register(struct mlx5_core_dev *dev, struct notifier_b
 
 	return blocking_notifier_chain_register(&events->sw_nh, nb);
 }
+EXPORT_SYMBOL(mlx5_blocking_notifier_register);
 
 int mlx5_blocking_notifier_unregister(struct mlx5_core_dev *dev, struct notifier_block *nb)
 {
@@ -431,6 +432,7 @@ int mlx5_blocking_notifier_unregister(struct mlx5_core_dev *dev, struct notifier
 
 	return blocking_notifier_chain_unregister(&events->sw_nh, nb);
 }
+EXPORT_SYMBOL(mlx5_blocking_notifier_unregister);
 
 int mlx5_blocking_notifier_call_chain(struct mlx5_core_dev *dev, unsigned int event,
 				      void *data)
-- 
2.38.1

