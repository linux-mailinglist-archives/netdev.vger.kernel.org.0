Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3723068E52A
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjBHA4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjBHA4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:56:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D405F2B0BA;
        Tue,  7 Feb 2023 16:56:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A17CB81B07;
        Wed,  8 Feb 2023 00:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1C5C433D2;
        Wed,  8 Feb 2023 00:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675817787;
        bh=BaONysaXsW3KNtU1tBNOiAnrpx955nxBkgBWimY4rNY=;
        h=From:To:Cc:Subject:Date:From;
        b=QXzJDMzVKkPTZ2sCfXUwaT6vNZiLMsEbqVbBYFx1VpdN9Pbwg/hA8HNy7NifPgvCN
         32FJpS3LT7Jl2Uah/bsbPKxn8GKdRp8eXt9AQMmzPr9QSkOsZm68T88ysQwzbr3/ud
         OzdN94JsIG8A4kzSIsWqetWWyMs4y6Tc6lFUa7B5xTeVUJLkYoWhxXzP4wuHxr6AE3
         fCPQt9f4v2A0Ng4sCKPiT+fken9B3eo9Do/B/lxt+wOX4TFxRSF6LTrazdqwIuk6co
         V71TqQSY0+vf4honxFDMjZ+XSoWEy4iU1k5p3mI8wYXhikGB9DaxMBkvADs6fCZOCW
         JTAgAae39CtlQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
Subject: pull-request: mlx5-next netdev notifier deadlock 2023-02-07
Date:   Tue,  7 Feb 2023 16:56:26 -0800
Message-Id: <20230208005626.72930-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
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

The following changes since commit b7bfaa761d760e72a969d116517eaa12e404c262:

  Linux 6.2-rc3 (2023-01-08 11:49:43 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git tags/mlx5-next-netdev-deadlock

for you to fetch changes up to e630cb2daadd965933f1870dd65efc942d266210:

  RDMA/mlx5: Track netdev to avoid deadlock during netdev notifier unregister (2023-02-07 16:39:09 -0800)

----------------------------------------------------------------
mlx5-next-netdev-deadlock

This series from Jiri solves a deadlock when removing a network namespace
with mlx5 devlink instance being in it.
The deadlock is between:
1) mlx5_ib->unregister_netdevice_notifier()
AND
2) mlx5_core->devlink_reload->cleanup_net()

To slove this introduced mlx5 netdev added/removed events to track uplink
netdev to be used for register_netdevice_notifier_dev_net() purposes.

----------------------------------------------------------------
Jiri Pirko (3):
      net/mlx5e: Fix trap event handling
      net/mlx5e: Propagate an internal event in case uplink netdev changes
      RDMA/mlx5: Track netdev to avoid deadlock during netdev notifier unregister

Patrisious Haddad (1):
      net/mlx5: Introduce CQE error syndrome

 drivers/infiniband/hw/mlx5/main.c                  | 78 +++++++++++++++-------
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  3 +
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  | 24 +++----
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 15 +++--
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |  5 --
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 20 ++++++
 include/linux/mlx5/device.h                        |  1 +
 include/linux/mlx5/driver.h                        |  5 ++
 include/linux/mlx5/mlx5_ifc.h                      | 47 +++++++++++--
 11 files changed, 154 insertions(+), 51 deletions(-)

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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 5bd83c0275f8..c06baa317fbd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -263,9 +263,10 @@ static int mlx5_devlink_trap_action_set(struct devlink *devlink,
 					struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_devlink_trap_event_ctx trap_event_ctx;
 	enum devlink_trap_action action_orig;
 	struct mlx5_devlink_trap *dl_trap;
-	int err = 0;
+	int err;
 
 	if (is_mdev_switchdev_mode(dev)) {
 		NL_SET_ERR_MSG_MOD(extack, "Devlink traps can't be set in switchdev mode");
@@ -275,26 +276,25 @@ static int mlx5_devlink_trap_action_set(struct devlink *devlink,
 	dl_trap = mlx5_find_trap_by_id(dev, trap->id);
 	if (!dl_trap) {
 		mlx5_core_err(dev, "Devlink trap: Set action on invalid trap id 0x%x", trap->id);
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
-	if (action != DEVLINK_TRAP_ACTION_DROP && action != DEVLINK_TRAP_ACTION_TRAP) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	if (action != DEVLINK_TRAP_ACTION_DROP && action != DEVLINK_TRAP_ACTION_TRAP)
+		return -EOPNOTSUPP;
 
 	if (action == dl_trap->trap.action)
-		goto out;
+		return 0;
 
 	action_orig = dl_trap->trap.action;
 	dl_trap->trap.action = action;
+	trap_event_ctx.trap = &dl_trap->trap;
+	trap_event_ctx.err = 0;
 	err = mlx5_blocking_notifier_call_chain(dev, MLX5_DRIVER_EVENT_TYPE_TRAP,
-						&dl_trap->trap);
-	if (err)
+						&trap_event_ctx);
+	if (err == NOTIFY_BAD)
 		dl_trap->trap.action = action_orig;
-out:
-	return err;
+
+	return trap_event_ctx.err;
 }
 
 static const struct devlink_ops mlx5_devlink_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
index fd033df24856..b84cb70eb3ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.h
@@ -24,6 +24,11 @@ struct mlx5_devlink_trap {
 	struct list_head list;
 };
 
+struct mlx5_devlink_trap_event_ctx {
+	struct mlx5_trap_ctx *trap;
+	int err;
+};
+
 struct mlx5_core_dev;
 void mlx5_devlink_trap_report(struct mlx5_core_dev *dev, int trap_id, struct sk_buff *skb,
 			      struct devlink_port *dl_port);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index cff5f2e29e1e..85b51039d2a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -179,17 +179,21 @@ static void mlx5e_disable_async_events(struct mlx5e_priv *priv)
 static int blocking_event(struct notifier_block *nb, unsigned long event, void *data)
 {
 	struct mlx5e_priv *priv = container_of(nb, struct mlx5e_priv, blocking_events_nb);
+	struct mlx5_devlink_trap_event_ctx *trap_event_ctx = data;
 	int err;
 
 	switch (event) {
 	case MLX5_DRIVER_EVENT_TYPE_TRAP:
-		err = mlx5e_handle_trap_event(priv, data);
+		err = mlx5e_handle_trap_event(priv, trap_event_ctx->trap);
+		if (err) {
+			trap_event_ctx->err = err;
+			return NOTIFY_BAD;
+		}
 		break;
 	default:
-		netdev_warn(priv->netdev, "Sync event: Unknown event %ld\n", event);
-		err = -EINVAL;
+		return NOTIFY_DONE;
 	}
-	return err;
+	return NOTIFY_OK;
 }
 
 static void mlx5e_enable_blocking_events(struct mlx5e_priv *priv)
@@ -5957,7 +5961,7 @@ static int mlx5e_probe(struct auxiliary_device *adev,
 	}
 
 	mlx5e_dcbnl_init_app(priv);
-	mlx5_uplink_netdev_set(mdev, netdev);
+	mlx5_core_uplink_netdev_set(mdev, netdev);
 	mlx5e_params_print_info(mdev, &priv->channels.params);
 	return 0;
 
@@ -5977,6 +5981,7 @@ static void mlx5e_remove(struct auxiliary_device *adev)
 	struct mlx5e_priv *priv = auxiliary_get_drvdata(adev);
 	pm_message_t state = {};
 
+	mlx5_core_uplink_netdev_set(priv->mdev, NULL);
 	mlx5e_dcbnl_delete_app(priv);
 	unregister_netdev(priv->netdev);
 	mlx5e_suspend(adev, state);
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index 032adb21ad4b..bfd3a1121ed8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -96,11 +96,6 @@ static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
 	return devlink_net(priv_to_devlink(dev));
 }
 
-static inline void mlx5_uplink_netdev_set(struct mlx5_core_dev *mdev, struct net_device *netdev)
-{
-	mdev->mlx5e_res.uplink_netdev = netdev;
-}
-
 static inline struct net_device *mlx5_uplink_netdev_get(struct mlx5_core_dev *mdev)
 {
 	return mdev->mlx5e_res.uplink_netdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index df134f6d32dc..72716d1f8b37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -336,6 +336,24 @@ static u16 to_fw_pkey_sz(struct mlx5_core_dev *dev, u32 size)
 	}
 }
 
+void mlx5_core_uplink_netdev_set(struct mlx5_core_dev *dev, struct net_device *netdev)
+{
+	mutex_lock(&dev->mlx5e_res.uplink_netdev_lock);
+	dev->mlx5e_res.uplink_netdev = netdev;
+	mlx5_blocking_notifier_call_chain(dev, MLX5_DRIVER_EVENT_UPLINK_NETDEV,
+					  netdev);
+	mutex_unlock(&dev->mlx5e_res.uplink_netdev_lock);
+}
+
+void mlx5_core_uplink_netdev_event_replay(struct mlx5_core_dev *dev)
+{
+	mutex_lock(&dev->mlx5e_res.uplink_netdev_lock);
+	mlx5_blocking_notifier_call_chain(dev, MLX5_DRIVER_EVENT_UPLINK_NETDEV,
+					  dev->mlx5e_res.uplink_netdev);
+	mutex_unlock(&dev->mlx5e_res.uplink_netdev_lock);
+}
+EXPORT_SYMBOL(mlx5_core_uplink_netdev_event_replay);
+
 static int mlx5_core_get_caps_mode(struct mlx5_core_dev *dev,
 				   enum mlx5_cap_type cap_type,
 				   enum mlx5_cap_mode cap_mode)
@@ -1608,6 +1626,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	lockdep_register_key(&dev->lock_key);
 	mutex_init(&dev->intf_state_mutex);
 	lockdep_set_class(&dev->intf_state_mutex, &dev->lock_key);
+	mutex_init(&dev->mlx5e_res.uplink_netdev_lock);
 
 	mutex_init(&priv->bfregs.reg_head.lock);
 	mutex_init(&priv->bfregs.wc_head.lock);
@@ -1696,6 +1715,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mutex_destroy(&priv->alloc_mutex);
 	mutex_destroy(&priv->bfregs.wc_head.lock);
 	mutex_destroy(&priv->bfregs.reg_head.lock);
+	mutex_destroy(&dev->mlx5e_res.uplink_netdev_lock);
 	mutex_destroy(&dev->intf_state_mutex);
 	lockdep_unregister_key(&dev->lock_key);
 }
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 29d4b201c7b2..f2b271169daf 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -362,6 +362,7 @@ enum mlx5_event {
 
 enum mlx5_driver_event {
 	MLX5_DRIVER_EVENT_TYPE_TRAP = 0,
+	MLX5_DRIVER_EVENT_UPLINK_NETDEV,
 };
 
 enum {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index d476255c9a3f..cc48aa308269 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -49,6 +49,7 @@
 #include <linux/notifier.h>
 #include <linux/refcount.h>
 #include <linux/auxiliary_bus.h>
+#include <linux/mutex.h>
 
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/doorbell.h>
@@ -674,6 +675,7 @@ struct mlx5e_resources {
 	} hw_objs;
 	struct devlink_port dl_port;
 	struct net_device *uplink_netdev;
+	struct mutex uplink_netdev_lock;
 };
 
 enum mlx5_sw_icm_type {
@@ -1011,6 +1013,9 @@ int mlx5_cmd_exec_polling(struct mlx5_core_dev *dev, void *in, int in_size,
 			  void *out, int out_size);
 bool mlx5_cmd_is_down(struct mlx5_core_dev *dev);
 
+void mlx5_core_uplink_netdev_set(struct mlx5_core_dev *mdev, struct net_device *netdev);
+void mlx5_core_uplink_netdev_event_replay(struct mlx5_core_dev *mdev);
+
 int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type);
 void mlx5_health_cleanup(struct mlx5_core_dev *dev);
 int mlx5_health_init(struct mlx5_core_dev *dev);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a9ee7bc59c90..2d17b6a6d82d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1496,7 +1496,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         null_mkey[0x1];
 	u8         log_max_klm_list_size[0x6];
 
-	u8         reserved_at_120[0xa];
+	u8         reserved_at_120[0x2];
+	u8	   qpc_extension[0x1];
+	u8	   reserved_at_123[0x7];
 	u8         log_max_ra_req_dc[0x6];
 	u8         reserved_at_130[0x2];
 	u8         eth_wqe_too_small[0x1];
@@ -1662,7 +1664,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         log_bf_reg_size[0x5];
 
-	u8         reserved_at_270[0x6];
+	u8         reserved_at_270[0x3];
+	u8	   qp_error_syndrome[0x1];
+	u8	   reserved_at_274[0x2];
 	u8         lag_dct[0x2];
 	u8         lag_tx_port_affinity[0x1];
 	u8         lag_native_fdb_selection[0x1];
@@ -5342,6 +5346,37 @@ struct mlx5_ifc_query_rmp_in_bits {
 	u8         reserved_at_60[0x20];
 };
 
+struct mlx5_ifc_cqe_error_syndrome_bits {
+	u8         hw_error_syndrome[0x8];
+	u8         hw_syndrome_type[0x4];
+	u8         reserved_at_c[0x4];
+	u8         vendor_error_syndrome[0x8];
+	u8         syndrome[0x8];
+};
+
+struct mlx5_ifc_qp_context_extension_bits {
+	u8         reserved_at_0[0x60];
+
+	struct mlx5_ifc_cqe_error_syndrome_bits error_syndrome;
+
+	u8         reserved_at_80[0x580];
+};
+
+struct mlx5_ifc_qpc_extension_and_pas_list_in_bits {
+	struct mlx5_ifc_qp_context_extension_bits qpc_data_extension;
+
+	u8         pas[0][0x40];
+};
+
+struct mlx5_ifc_qp_pas_list_in_bits {
+	struct mlx5_ifc_cmd_pas_bits pas[0];
+};
+
+union mlx5_ifc_qp_pas_or_qpc_ext_and_pas_bits {
+	struct mlx5_ifc_qp_pas_list_in_bits qp_pas_list;
+	struct mlx5_ifc_qpc_extension_and_pas_list_in_bits qpc_ext_and_pas_list;
+};
+
 struct mlx5_ifc_query_qp_out_bits {
 	u8         status[0x8];
 	u8         reserved_at_8[0x18];
@@ -5358,7 +5393,7 @@ struct mlx5_ifc_query_qp_out_bits {
 
 	u8         reserved_at_800[0x80];
 
-	u8         pas[][0x40];
+	union mlx5_ifc_qp_pas_or_qpc_ext_and_pas_bits qp_pas_or_qpc_ext_and_pas;
 };
 
 struct mlx5_ifc_query_qp_in_bits {
@@ -5368,7 +5403,8 @@ struct mlx5_ifc_query_qp_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x8];
+	u8         qpc_ext[0x1];
+	u8         reserved_at_41[0x7];
 	u8         qpn[0x18];
 
 	u8         reserved_at_60[0x20];
@@ -8571,7 +8607,8 @@ struct mlx5_ifc_create_qp_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x8];
+	u8         qpc_ext[0x1];
+	u8         reserved_at_41[0x7];
 	u8         input_qpn[0x18];
 
 	u8         reserved_at_60[0x20];
