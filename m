Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26AA660DA7
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 11:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjAGKMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 05:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjAGKMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 05:12:13 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60F48060F
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 02:12:08 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id q64so3915691pjq.4
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 02:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=It6zM4RoWFORWkHObPx50BBNk6jBPzkZZzpaVNmCKXA=;
        b=3EbnR2cF8t3c7e7/zcUVgO+fQJ5MjdS6k3Dw+Kq6F3RIQ+IlGqH7LAo+y4C//yPy2J
         hiDTXuppx4NKSKHcLJKp99Xfpom/ro9zNYiNZA31dHZtD+c3nGlVEsTiWJex9//pS4kg
         wPQ+QVJNgW3H3NpuuFHg9ePzwIrsMv79Aj2/Csv3kfIrIMfnAiebMdpiQrgopV/mjtib
         1Ct62A7igLQmLl69VS+EgzsTFxfnzIlsGTzG75oovWOCM8Kt4aYlmP/FK3twE2Tmdfd5
         mT9NSegzAw7n24kxFlkfu18Lajnfag/4dWKGHtc8O5F0hIu0A8rTELjCQcz4qZwFtSjz
         No5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=It6zM4RoWFORWkHObPx50BBNk6jBPzkZZzpaVNmCKXA=;
        b=DEbj0+/mv815EaljyELs2NQ1D2SLRqITp5OkaPAokqvm5PxPD/Tfu7Db0eYvDXwz5j
         pbHKX6qpVasfV2vzCq/FRJwvAdKx0xqDiwU19OHyjAgTgxZpT00/rySxhyAeDReIIqzl
         kDD+xdGYlENGk93TfsXlPwuW0ra7iyTUJk4P8g/PEWym+l969bN3DCisKeqDcuUR/gQP
         SOehKXvWgAAgJw2LO6QDHUTDU3jRVrDr0WVit5m8tsQTQljYK+SPgrT3iSvZ9ijQjIvG
         +o1aHkN4RmmLq04jCbMkmgKyIx1RMM9AYC3siiEODzPE1kCNguTmcEaengf7b6rMgi8i
         V1Dg==
X-Gm-Message-State: AFqh2kr/42JIUU3siMadw7O0agCi0LJfDAo1DWrahc0fMCwwTgrtgolS
        DZWEcc9gyZM/uSwFbj3GBhB18PJ2nO8r0mv6KuldbA==
X-Google-Smtp-Source: AMrXdXuIBXJ3xN84xuAMGxd+rj6TWfT9Vng+6qV37Ry+2cSduxpPj9VjpAduc6VLgRsMZJmCOqguPg==
X-Received: by 2002:a17:902:da86:b0:187:3921:2b1c with SMTP id j6-20020a170902da8600b0018739212b1cmr85110678plx.55.1673086328368;
        Sat, 07 Jan 2023 02:12:08 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id f5-20020a170902ce8500b00178b9c997e5sm2399420plg.138.2023.01.07.02.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 02:12:07 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v2 4/9] devlink: remove reporters_lock
Date:   Sat,  7 Jan 2023 11:11:45 +0100
Message-Id: <20230107101151.532611-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230107101151.532611-1-jiri@resnulli.us>
References: <20230107101151.532611-1-jiri@resnulli.us>
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

Similar to other devlink objects, convert the reporters list to be
protected by devlink instance lock. Alongside add unlocked versions
of health reporter create functions and remove port-specific destroy
function which is no longer needed.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/health.c   |  12 ++
 .../mellanox/mlx5/core/en/reporter_rx.c       |   6 +-
 .../mellanox/mlx5/core/en/reporter_tx.c       |   6 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   8 +-
 drivers/net/netdevsim/health.c                |  20 +--
 include/net/devlink.h                         |  20 +--
 net/devlink/core.c                            |   2 -
 net/devlink/devl_internal.h                   |   1 -
 net/devlink/leftover.c                        | 131 +++++++-----------
 9 files changed, 96 insertions(+), 110 deletions(-)

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
index 1ae15b8536a8..662df2c21747 100644
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
+	devl_health_reporter_destroy(priv->rx_reporter);
 	priv->rx_reporter = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 60bc5b577ab9..a932878971ea 100644
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
+	devl_health_reporter_destroy(priv->tx_reporter);
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
index d7c9572e5bea..ef9bea6ecc63 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -146,7 +146,6 @@ struct devlink_port {
 	   initialized:1;
 	struct delayed_work type_warn_dw;
 	struct list_head reporter_list;
-	struct mutex reporters_lock; /* Protects reporter_list */
 
 	struct devlink_rate *devlink_rate;
 	struct devlink_linecard *linecard;
@@ -1864,21 +1863,26 @@ int devlink_fmsg_string_pair_put(struct devlink_fmsg *fmsg, const char *name,
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
-
 void
-devlink_health_reporter_destroy(struct devlink_health_reporter *reporter);
+devl_health_reporter_destroy(struct devlink_health_reporter *reporter);
 
 void
-devlink_port_health_reporter_destroy(struct devlink_health_reporter *reporter);
+devlink_health_reporter_destroy(struct devlink_health_reporter *reporter);
 
 void *
 devlink_health_reporter_priv(struct devlink_health_reporter *reporter);
diff --git a/net/devlink/core.c b/net/devlink/core.c
index d223a46fe557..4142b69ec680 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -217,7 +217,6 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	lockdep_register_key(&devlink->lock_key);
 	mutex_init(&devlink->lock);
 	lockdep_set_class(&devlink->lock, &devlink->lock_key);
-	mutex_init(&devlink->reporters_lock);
 	refcount_set(&devlink->refcount, 1);
 
 	return devlink;
@@ -239,7 +238,6 @@ void devlink_free(struct devlink *devlink)
 {
 	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
 
-	mutex_destroy(&devlink->reporters_lock);
 	mutex_destroy(&devlink->lock);
 	lockdep_unregister_key(&devlink->lock_key);
 	WARN_ON(!list_empty(&devlink->trap_policer_list));
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index ca49ad31027c..69d10b93616e 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -31,7 +31,6 @@ struct devlink {
 	struct list_head param_list;
 	struct list_head region_list;
 	struct list_head reporter_list;
-	struct mutex reporters_lock; /* protects reporter_list */
 	struct devlink_dpipe_headers *dpipe_headers;
 	struct list_head trap_list;
 	struct list_head trap_group_list;
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 2208711b4b18..70b8a9f15ac3 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7278,12 +7278,10 @@ EXPORT_SYMBOL_GPL(devlink_health_reporter_priv);
 
 static struct devlink_health_reporter *
 __devlink_health_reporter_find_by_name(struct list_head *reporter_list,
-				       struct mutex *list_lock,
 				       const char *reporter_name)
 {
 	struct devlink_health_reporter *reporter;
 
-	lockdep_assert_held(list_lock);
 	list_for_each_entry(reporter, reporter_list, list)
 		if (!strcmp(reporter->ops->name, reporter_name))
 			return reporter;
@@ -7295,7 +7293,6 @@ devlink_health_reporter_find_by_name(struct devlink *devlink,
 				     const char *reporter_name)
 {
 	return __devlink_health_reporter_find_by_name(&devlink->reporter_list,
-						      &devlink->reporters_lock,
 						      reporter_name);
 }
 
@@ -7304,7 +7301,6 @@ devlink_port_health_reporter_find_by_name(struct devlink_port *devlink_port,
 					  const char *reporter_name)
 {
 	return __devlink_health_reporter_find_by_name(&devlink_port->reporter_list,
-						      &devlink_port->reporters_lock,
 						      reporter_name);
 }
 
@@ -7334,8 +7330,8 @@ __devlink_health_reporter_create(struct devlink *devlink,
 }
 
 /**
- *	devlink_port_health_reporter_create - create devlink health reporter for
- *	                                      specified port instance
+ *	devl_port_health_reporter_create - create devlink health reporter for
+ *	                                   specified port instance
  *
  *	@port: devlink_port which should contain the new reporter
  *	@ops: ops
@@ -7343,34 +7339,31 @@ __devlink_health_reporter_create(struct devlink *devlink,
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
 
-	mutex_lock(&port->reporters_lock);
+	devl_assert_locked(port->devlink);
+
 	if (__devlink_health_reporter_find_by_name(&port->reporter_list,
-						   &port->reporters_lock, ops->name)) {
-		reporter = ERR_PTR(-EEXIST);
-		goto unlock;
-	}
+						   ops->name))
+		return ERR_PTR(-EEXIST);
 
 	reporter = __devlink_health_reporter_create(port->devlink, ops,
 						    graceful_period, priv);
 	if (IS_ERR(reporter))
-		goto unlock;
+		return reporter;
 
 	reporter->devlink_port = port;
 	list_add_tail(&reporter->list, &port->reporter_list);
-unlock:
-	mutex_unlock(&port->reporters_lock);
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
@@ -7378,26 +7371,38 @@ EXPORT_SYMBOL_GPL(devlink_port_health_reporter_create);
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
 
-	mutex_lock(&devlink->reporters_lock);
-	if (devlink_health_reporter_find_by_name(devlink, ops->name)) {
-		reporter = ERR_PTR(-EEXIST);
-		goto unlock;
-	}
+	devl_assert_locked(devlink);
+
+	if (devlink_health_reporter_find_by_name(devlink, ops->name))
+		return ERR_PTR(-EEXIST);
 
 	reporter = __devlink_health_reporter_create(devlink, ops,
 						    graceful_period, priv);
 	if (IS_ERR(reporter))
-		goto unlock;
+		return reporter;
 
 	list_add_tail(&reporter->list, &devlink->reporter_list);
-unlock:
-	mutex_unlock(&devlink->reporters_lock);
+	return reporter;
+}
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
 	return reporter;
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_create);
@@ -7418,44 +7423,31 @@ devlink_health_reporter_put(struct devlink_health_reporter *reporter)
 		devlink_health_reporter_free(reporter);
 }
 
-static void
-__devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
-{
-	list_del(&reporter->list);
-	devlink_health_reporter_put(reporter);
-}
-
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
-	struct mutex *lock = &reporter->devlink->reporters_lock;
+	devl_assert_locked(reporter->devlink);
 
-	mutex_lock(lock);
-	__devlink_health_reporter_destroy(reporter);
-	mutex_unlock(lock);
+	list_del(&reporter->list);
+	devlink_health_reporter_put(reporter);
 }
-EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
+EXPORT_SYMBOL_GPL(devl_health_reporter_destroy);
 
-/**
- *	devlink_port_health_reporter_destroy - destroy devlink port health reporter
- *
- *	@reporter: devlink health reporter to destroy
- */
 void
-devlink_port_health_reporter_destroy(struct devlink_health_reporter *reporter)
+devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 {
-	struct mutex *lock = &reporter->devlink_port->reporters_lock;
+	struct devlink *devlink = reporter->devlink;
 
-	mutex_lock(lock);
-	__devlink_health_reporter_destroy(reporter);
-	mutex_unlock(lock);
+	devl_lock(devlink);
+	devl_health_reporter_destroy(reporter);
+	devl_unlock(devlink);
 }
-EXPORT_SYMBOL_GPL(devlink_port_health_reporter_destroy);
+EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
 
 static int
 devlink_nl_health_reporter_fill(struct sk_buff *msg,
@@ -7696,17 +7688,13 @@ devlink_health_reporter_get_from_attrs(struct devlink *devlink,
 	reporter_name = nla_data(attrs[DEVLINK_ATTR_HEALTH_REPORTER_NAME]);
 	devlink_port = devlink_port_get_from_attrs(devlink, attrs);
 	if (IS_ERR(devlink_port)) {
-		mutex_lock(&devlink->reporters_lock);
 		reporter = devlink_health_reporter_find_by_name(devlink, reporter_name);
 		if (reporter)
 			refcount_inc(&reporter->refcount);
-		mutex_unlock(&devlink->reporters_lock);
 	} else {
-		mutex_lock(&devlink_port->reporters_lock);
 		reporter = devlink_port_health_reporter_find_by_name(devlink_port, reporter_name);
 		if (reporter)
 			refcount_inc(&reporter->refcount);
-		mutex_unlock(&devlink_port->reporters_lock);
 	}
 
 	return reporter;
@@ -7802,12 +7790,9 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 		unsigned long port_index;
 		int idx = 0;
 
-		mutex_lock(&devlink->reporters_lock);
-		if (!devl_is_registered(devlink)) {
-			mutex_unlock(&devlink->reporters_lock);
-			devlink_put(devlink);
-			continue;
-		}
+		devl_lock(devlink);
+		if (!devl_is_registered(devlink))
+			goto next_devlink;
 
 		list_for_each_entry(reporter, &devlink->reporter_list,
 				    list) {
@@ -7820,21 +7805,15 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 				NLM_F_MULTI);
 			if (err) {
-				mutex_unlock(&devlink->reporters_lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				state->idx = idx;
 				goto out;
 			}
 			idx++;
 		}
-		mutex_unlock(&devlink->reporters_lock);
-
-		devl_lock(devlink);
-		if (!devl_is_registered(devlink))
-			goto next_devlink;
 
 		xa_for_each(&devlink->ports, port_index, port) {
-			mutex_lock(&port->reporters_lock);
 			list_for_each_entry(reporter, &port->reporter_list, list) {
 				if (idx < state->idx) {
 					idx++;
@@ -7846,7 +7825,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 					NETLINK_CB(cb->skb).portid,
 					cb->nlh->nlmsg_seq, NLM_F_MULTI);
 				if (err) {
-					mutex_unlock(&port->reporters_lock);
 					devl_unlock(devlink);
 					devlink_put(devlink);
 					state->idx = idx;
@@ -7854,7 +7832,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				}
 				idx++;
 			}
-			mutex_unlock(&port->reporters_lock);
 		}
 next_devlink:
 		devl_unlock(devlink);
@@ -9580,12 +9557,9 @@ int devl_port_register(struct devlink *devlink,
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
-	mutex_init(&devlink_port->reporters_lock);
 	err = xa_insert(&devlink->ports, port_index, devlink_port, GFP_KERNEL);
-	if (err) {
-		mutex_destroy(&devlink_port->reporters_lock);
+	if (err)
 		return err;
-	}
 
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
@@ -9636,7 +9610,6 @@ void devl_port_unregister(struct devlink_port *devlink_port)
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	xa_erase(&devlink_port->devlink->ports, devlink_port->index);
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
-	mutex_destroy(&devlink_port->reporters_lock);
 	devlink_port->registered = false;
 }
 EXPORT_SYMBOL_GPL(devl_port_unregister);
-- 
2.39.0

