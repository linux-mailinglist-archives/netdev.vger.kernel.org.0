Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2517A662F3F
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237711AbjAISfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237859AbjAISdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:33:49 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2C21B1DC
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:31:39 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id v23so5545018plo.1
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sz9hOjaOb59wSDgFcaYe1lturEOo+/ZnCL76oiExNDU=;
        b=VjBx3d2OQUk9KXJBwRnWE4pXdpAJDEl1W0ctO+Z/MMeQE3w0jQufWA0QAzMcy38443
         aIYOhwCyadKCn2P6HfcdRatKAggDJObpwXcU8cNng9GeVEEHvQJBwOQ/IuUTFN/V0ohD
         ADzCyOhzSwEidikRCpeRSqmDaSDe57Kir5pfWq/n10XUvdFSHsVLX2xCDbVrqq8Ty7OG
         j6IWgY8xXzvrhgfTk283m0fik0EaD7LHZSY75br7P1/BXVqx6YzvvB2C3hBVqXiDC88s
         3SXxUtCHZA17ZqMYrneqTf2Dq6K4QPxJa3J3NP3mpT1anHeTXSnFSCuthHCnLY8DGhcn
         VnZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sz9hOjaOb59wSDgFcaYe1lturEOo+/ZnCL76oiExNDU=;
        b=aA66bpovG9+xKIqSJAjmiY7dXMoPTN9cbkXk++5ZyW1t3o5KrNJaJe6NrNzRF9g9D0
         WWietVjk9yJiW9fOl9gge1fNvl88yVH0RUoQ6rbmruH//kKvOBBe6T8jmC1usqbS/43g
         raHbhPq80vWRPsSZ9OI+Pngdm0Z+7xYeqxQZTRw2CYHg53ryJfahULo13RU8wFw/0NML
         xwM0yVdxMVBaNTbA+cN3lBAyj21sdk7FUxDP72TCNo4MRbuA2dz1krqe6UxUkH4tq4ZO
         15t5ojl4kI9qGQPH3ucyuP8tl8/xvkSphTSck9HxEgblHBQxA+bLboF0ShcjbamKBGf9
         GFQw==
X-Gm-Message-State: AFqh2kpqbAEZCYV+Bcv5M5EzLK2EnszeTSyOaidt0Wh7qUn3zSvW4k9t
        Nx2vfNkOOzlBi28oWo7r0OEZKFfAa0VtdVTdoI616A==
X-Google-Smtp-Source: AMrXdXt7lKNGFTrKieJFHHKgMLPs71XZmWhOd16DOozfvh/rDW4Iz97JDvxqS3shFDAB74BH6dEkTg==
X-Received: by 2002:a17:902:aa4a:b0:193:1aa7:c7d9 with SMTP id c10-20020a170902aa4a00b001931aa7c7d9mr7772270plr.44.1673289098408;
        Mon, 09 Jan 2023 10:31:38 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c20d00b00189c4b8ca21sm6510144pll.18.2023.01.09.10.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 10:31:37 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v3 04/11] devlink: protect health reporter operation with instance lock
Date:   Mon,  9 Jan 2023 19:31:13 +0100
Message-Id: <20230109183120.649825-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230109183120.649825-1-jiri@resnulli.us>
References: <20230109183120.649825-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Similar to other devlink objects, protect the reporters list
by devlink instance lock. Alongside add unlocked versions
of health reporter create/destroy functions and use them in drivers
on call paths where the instance lock is held.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v2->v3:
- split from v2 patch #4 - "devlink: remove reporters_lock", no change
---
 .../ethernet/mellanox/mlx5/core/en/health.c   | 12 +++
 .../mellanox/mlx5/core/en/reporter_rx.c       |  6 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |  6 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  8 +-
 drivers/net/netdevsim/health.c                | 20 ++---
 include/net/devlink.h                         | 18 +++--
 net/devlink/leftover.c                        | 76 +++++++++++++------
 7 files changed, 97 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 6f4e6c34b2a2..acc4b1ebdfb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -137,14 +137,26 @@ int mlx5e_health_eq_diag_fmsg(struct mlx5_eq_comp *eq, struct devlink_fmsg *fmsg
 
 void mlx5e_health_create_reporters(struct mlx5e_priv *priv)
 {
+	struct devlink *devlink = priv_to_devlink(priv->mdev);
+
+	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW))
+		devl_lock(devlink);
 	mlx5e_reporter_tx_create(priv);
 	mlx5e_reporter_rx_create(priv);
+	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW))
+		devl_unlock(devlink);
 }
 
 void mlx5e_health_destroy_reporters(struct mlx5e_priv *priv)
 {
+	struct devlink *devlink = priv_to_devlink(priv->mdev);
+
+	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW))
+		devl_lock(devlink);
 	mlx5e_reporter_rx_destroy(priv);
 	mlx5e_reporter_tx_destroy(priv);
+	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW))
+		devl_unlock(devlink);
 }
 
 void mlx5e_health_channels_update(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 1ae15b8536a8..cdd4d2d0c876 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -739,8 +739,8 @@ void mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
 	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
 	struct devlink_health_reporter *reporter;
 
-	reporter = devlink_port_health_reporter_create(dl_port, &mlx5_rx_reporter_ops,
-						       MLX5E_REPORTER_RX_GRACEFUL_PERIOD, priv);
+	reporter = devl_port_health_reporter_create(dl_port, &mlx5_rx_reporter_ops,
+						    MLX5E_REPORTER_RX_GRACEFUL_PERIOD, priv);
 	if (IS_ERR(reporter)) {
 		netdev_warn(priv->netdev, "Failed to create rx reporter, err = %ld\n",
 			    PTR_ERR(reporter));
@@ -754,6 +754,6 @@ void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv)
 	if (!priv->rx_reporter)
 		return;
 
-	devlink_port_health_reporter_destroy(priv->rx_reporter);
+	devl_port_health_reporter_destroy(priv->rx_reporter);
 	priv->rx_reporter = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 60bc5b577ab9..ad24958f7a44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -593,8 +593,8 @@ void mlx5e_reporter_tx_create(struct mlx5e_priv *priv)
 	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
 	struct devlink_health_reporter *reporter;
 
-	reporter = devlink_port_health_reporter_create(dl_port, &mlx5_tx_reporter_ops,
-						       MLX5_REPORTER_TX_GRACEFUL_PERIOD, priv);
+	reporter = devl_port_health_reporter_create(dl_port, &mlx5_tx_reporter_ops,
+						    MLX5_REPORTER_TX_GRACEFUL_PERIOD, priv);
 	if (IS_ERR(reporter)) {
 		netdev_warn(priv->netdev,
 			    "Failed to create tx reporter, err = %ld\n",
@@ -609,6 +609,6 @@ void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv)
 	if (!priv->tx_reporter)
 		return;
 
-	devlink_port_health_reporter_destroy(priv->tx_reporter);
+	devl_port_health_reporter_destroy(priv->tx_reporter);
 	priv->tx_reporter = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 0b791706a9c1..ab07db99eeb3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2051,8 +2051,8 @@ static int mlxsw_core_health_init(struct mlxsw_core *mlxsw_core)
 	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_TXRX))
 		return 0;
 
-	fw_fatal = devlink_health_reporter_create(devlink, &mlxsw_core_health_fw_fatal_ops,
-						  0, mlxsw_core);
+	fw_fatal = devl_health_reporter_create(devlink, &mlxsw_core_health_fw_fatal_ops,
+					       0, mlxsw_core);
 	if (IS_ERR(fw_fatal)) {
 		dev_err(mlxsw_core->bus_info->dev, "Failed to create fw fatal reporter");
 		return PTR_ERR(fw_fatal);
@@ -2072,7 +2072,7 @@ static int mlxsw_core_health_init(struct mlxsw_core *mlxsw_core)
 err_fw_fatal_config:
 	mlxsw_core_trap_unregister(mlxsw_core, &mlxsw_core_health_listener, mlxsw_core);
 err_trap_register:
-	devlink_health_reporter_destroy(mlxsw_core->health.fw_fatal);
+	devl_health_reporter_destroy(mlxsw_core->health.fw_fatal);
 	return err;
 }
 
@@ -2085,7 +2085,7 @@ static void mlxsw_core_health_fini(struct mlxsw_core *mlxsw_core)
 	mlxsw_core_trap_unregister(mlxsw_core, &mlxsw_core_health_listener, mlxsw_core);
 	/* Make sure there is no more event work scheduled */
 	mlxsw_core_flush_owq();
-	devlink_health_reporter_destroy(mlxsw_core->health.fw_fatal);
+	devl_health_reporter_destroy(mlxsw_core->health.fw_fatal);
 }
 
 static void mlxsw_core_irq_event_handler_init(struct mlxsw_core *mlxsw_core)
diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index aa77af4a68df..eb04ed715d2d 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -233,16 +233,16 @@ int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink)
 	int err;
 
 	health->empty_reporter =
-		devlink_health_reporter_create(devlink,
-					       &nsim_dev_empty_reporter_ops,
-					       0, health);
+		devl_health_reporter_create(devlink,
+					    &nsim_dev_empty_reporter_ops,
+					    0, health);
 	if (IS_ERR(health->empty_reporter))
 		return PTR_ERR(health->empty_reporter);
 
 	health->dummy_reporter =
-		devlink_health_reporter_create(devlink,
-					       &nsim_dev_dummy_reporter_ops,
-					       0, health);
+		devl_health_reporter_create(devlink,
+					    &nsim_dev_dummy_reporter_ops,
+					    0, health);
 	if (IS_ERR(health->dummy_reporter)) {
 		err = PTR_ERR(health->dummy_reporter);
 		goto err_empty_reporter_destroy;
@@ -266,9 +266,9 @@ int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink)
 	return 0;
 
 err_dummy_reporter_destroy:
-	devlink_health_reporter_destroy(health->dummy_reporter);
+	devl_health_reporter_destroy(health->dummy_reporter);
 err_empty_reporter_destroy:
-	devlink_health_reporter_destroy(health->empty_reporter);
+	devl_health_reporter_destroy(health->empty_reporter);
 	return err;
 }
 
@@ -278,6 +278,6 @@ void nsim_dev_health_exit(struct nsim_dev *nsim_dev)
 
 	debugfs_remove_recursive(health->ddir);
 	kfree(health->recovered_break_msg);
-	devlink_health_reporter_destroy(health->dummy_reporter);
-	devlink_health_reporter_destroy(health->empty_reporter);
+	devl_health_reporter_destroy(health->dummy_reporter);
+	devl_health_reporter_destroy(health->empty_reporter);
 }
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7c1e47fe4f4b..8b0e63f7f49e 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1864,21 +1864,29 @@ int devlink_fmsg_string_pair_put(struct devlink_fmsg *fmsg, const char *name,
 int devlink_fmsg_binary_pair_put(struct devlink_fmsg *fmsg, const char *name,
 				 const void *value, u32 value_len);
 
+struct devlink_health_reporter *
+devl_port_health_reporter_create(struct devlink_port *port,
+				 const struct devlink_health_reporter_ops *ops,
+				 u64 graceful_period, void *priv);
+
+struct devlink_health_reporter *
+devl_health_reporter_create(struct devlink *devlink,
+			    const struct devlink_health_reporter_ops *ops,
+			    u64 graceful_period, void *priv);
+
 struct devlink_health_reporter *
 devlink_health_reporter_create(struct devlink *devlink,
 			       const struct devlink_health_reporter_ops *ops,
 			       u64 graceful_period, void *priv);
 
-struct devlink_health_reporter *
-devlink_port_health_reporter_create(struct devlink_port *port,
-				    const struct devlink_health_reporter_ops *ops,
-				    u64 graceful_period, void *priv);
+void
+devl_health_reporter_destroy(struct devlink_health_reporter *reporter);
 
 void
 devlink_health_reporter_destroy(struct devlink_health_reporter *reporter);
 
 void
-devlink_port_health_reporter_destroy(struct devlink_health_reporter *reporter);
+devl_port_health_reporter_destroy(struct devlink_health_reporter *reporter);
 
 void *
 devlink_health_reporter_priv(struct devlink_health_reporter *reporter);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 2208711b4b18..023c6c6b5f8a 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7334,8 +7334,8 @@ __devlink_health_reporter_create(struct devlink *devlink,
 }
 
 /**
- *	devlink_port_health_reporter_create - create devlink health reporter for
- *	                                      specified port instance
+ *	devl_port_health_reporter_create - create devlink health reporter for
+ *	                                   specified port instance
  *
  *	@port: devlink_port which should contain the new reporter
  *	@ops: ops
@@ -7343,12 +7343,13 @@ __devlink_health_reporter_create(struct devlink *devlink,
  *	@priv: priv
  */
 struct devlink_health_reporter *
-devlink_port_health_reporter_create(struct devlink_port *port,
-				    const struct devlink_health_reporter_ops *ops,
-				    u64 graceful_period, void *priv)
+devl_port_health_reporter_create(struct devlink_port *port,
+				 const struct devlink_health_reporter_ops *ops,
+				 u64 graceful_period, void *priv)
 {
 	struct devlink_health_reporter *reporter;
 
+	devl_assert_locked(port->devlink);
 	mutex_lock(&port->reporters_lock);
 	if (__devlink_health_reporter_find_by_name(&port->reporter_list,
 						   &port->reporters_lock, ops->name)) {
@@ -7367,10 +7368,10 @@ devlink_port_health_reporter_create(struct devlink_port *port,
 	mutex_unlock(&port->reporters_lock);
 	return reporter;
 }
-EXPORT_SYMBOL_GPL(devlink_port_health_reporter_create);
+EXPORT_SYMBOL_GPL(devl_port_health_reporter_create);
 
 /**
- *	devlink_health_reporter_create - create devlink health reporter
+ *	devl_health_reporter_create - create devlink health reporter
  *
  *	@devlink: devlink
  *	@ops: ops
@@ -7378,12 +7379,13 @@ EXPORT_SYMBOL_GPL(devlink_port_health_reporter_create);
  *	@priv: priv
  */
 struct devlink_health_reporter *
-devlink_health_reporter_create(struct devlink *devlink,
-			       const struct devlink_health_reporter_ops *ops,
-			       u64 graceful_period, void *priv)
+devl_health_reporter_create(struct devlink *devlink,
+			    const struct devlink_health_reporter_ops *ops,
+			    u64 graceful_period, void *priv)
 {
 	struct devlink_health_reporter *reporter;
 
+	devl_assert_locked(devlink);
 	mutex_lock(&devlink->reporters_lock);
 	if (devlink_health_reporter_find_by_name(devlink, ops->name)) {
 		reporter = ERR_PTR(-EEXIST);
@@ -7400,6 +7402,21 @@ devlink_health_reporter_create(struct devlink *devlink,
 	mutex_unlock(&devlink->reporters_lock);
 	return reporter;
 }
+EXPORT_SYMBOL_GPL(devl_health_reporter_create);
+
+struct devlink_health_reporter *
+devlink_health_reporter_create(struct devlink *devlink,
+			       const struct devlink_health_reporter_ops *ops,
+			       u64 graceful_period, void *priv)
+{
+	struct devlink_health_reporter *reporter;
+
+	devl_lock(devlink);
+	reporter = devl_health_reporter_create(devlink, ops,
+					       graceful_period, priv);
+	devl_unlock(devlink);
+	return reporter;
+}
 EXPORT_SYMBOL_GPL(devlink_health_reporter_create);
 
 static void
@@ -7426,36 +7443,51 @@ __devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 }
 
 /**
- *	devlink_health_reporter_destroy - destroy devlink health reporter
+ *	devl_health_reporter_destroy - destroy devlink health reporter
  *
  *	@reporter: devlink health reporter to destroy
  */
 void
-devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
+devl_health_reporter_destroy(struct devlink_health_reporter *reporter)
 {
 	struct mutex *lock = &reporter->devlink->reporters_lock;
 
+	devl_assert_locked(reporter->devlink);
+
 	mutex_lock(lock);
 	__devlink_health_reporter_destroy(reporter);
 	mutex_unlock(lock);
 }
+EXPORT_SYMBOL_GPL(devl_health_reporter_destroy);
+
+void
+devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
+{
+	struct devlink *devlink = reporter->devlink;
+
+	devl_lock(devlink);
+	devl_health_reporter_destroy(reporter);
+	devl_unlock(devlink);
+}
 EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
 
 /**
- *	devlink_port_health_reporter_destroy - destroy devlink port health reporter
+ *	devl_port_health_reporter_destroy - destroy devlink port health reporter
  *
  *	@reporter: devlink health reporter to destroy
  */
 void
-devlink_port_health_reporter_destroy(struct devlink_health_reporter *reporter)
+devl_port_health_reporter_destroy(struct devlink_health_reporter *reporter)
 {
 	struct mutex *lock = &reporter->devlink_port->reporters_lock;
 
+	devl_assert_locked(reporter->devlink);
+
 	mutex_lock(lock);
 	__devlink_health_reporter_destroy(reporter);
 	mutex_unlock(lock);
 }
-EXPORT_SYMBOL_GPL(devlink_port_health_reporter_destroy);
+EXPORT_SYMBOL_GPL(devl_port_health_reporter_destroy);
 
 static int
 devlink_nl_health_reporter_fill(struct sk_buff *msg,
@@ -7802,12 +7834,11 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		unsigned long port_index;
 		int idx = 0;
 
+		devl_lock(devlink);
+		if (!devl_is_registered(devlink))
+			goto next_devlink;
+
 		mutex_lock(&devlink->reporters_lock);
-		if (!devl_is_registered(devlink)) {
-			mutex_unlock(&devlink->reporters_lock);
-			devlink_put(devlink);
-			continue;
-		}
 
 		list_for_each_entry(reporter, &devlink->reporter_list,
 				    list) {
@@ -7821,6 +7852,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->reporters_lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				state->idx = idx;
 				goto out;
@@ -7829,10 +7861,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		}
 		mutex_unlock(&devlink->reporters_lock);
 
-		devl_lock(devlink);
-		if (!devl_is_registered(devlink))
-			goto next_devlink;
-
 		xa_for_each(&devlink->ports, port_index, port) {
 			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
-- 
2.39.0

