Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B6E67212A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjARPYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjARPXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:23:51 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827062C656
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:28 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id mp20so37469462ejc.7
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fdu/LMMDVPw+M4xLbPQuOn5+SEPJaDu97WWN+/EPaeo=;
        b=378BynuS84deh4NaaaV+A0BvTYwmhCtYLrOK1MYwM5SVH5qo/KtP2kYGB+YaBOipBZ
         svWwu+TkIIoV49Yy78M7MTOH9AX+lgtt7rS+y6aI+j1uf7oX185HdgonIF3IzNt3UlJm
         ha7SJPx5nye+urpuxhCDnBYRYLioqWGWBtjPk1PI+3irl+oOeHyYJ1PCG2zHSwHqDudi
         3d9mkD1rvSnLxGn52PrMhsUSCLjeryjntiTuXjfQeQiEUWJr9B7nzR6MZGinpOvGddsB
         m14kCYp8jNkRY/yB6XN7o8oQvi1FcNvnp1jmXnl2x8Ots9kNrMKSfdS6Jdj5+m2X/DQ+
         eZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fdu/LMMDVPw+M4xLbPQuOn5+SEPJaDu97WWN+/EPaeo=;
        b=Yy7Ll7GcBvgEeRbfOaY8X1KGLO1ks+UUDij1WphiZNWlBXRb6NOYox4QzXhiV8GPpD
         O/wiq6224ET41Sh4QDU6eMRe3d1hbXMd0cW7Pou68yluX5tCRw7IJbBBTNex2u7Z86TD
         F4GFzKr8PEWJtNXAV2oriGZN3erOGi3AqlPX+4bd05v0kdXfV5HYTXZz5FrwjDoW2KSM
         NfIopXRLoXK4kDmQXmCOlAD8F7ap30gn1Sztfs+QHMqbZziF3sEUoQ5SSF5Okgu34De6
         vpepDGPh61R2qXWPbrQ0E+KOrBe4ltD3i6qr4M2pDsx8967yV0Wo38xgCDK7zIAAk4N1
         /3aA==
X-Gm-Message-State: AFqh2kpMtTOKqcNJCILeCFpKsVCTqUQZhPqzVL7n7+KRM4oletGMWUxa
        umLDpOSV8dMwPKGnIVUvxrzMKsXzLUZQZVYVQo5O0Q==
X-Google-Smtp-Source: AMrXdXuDSmm4mkJ3zMycxifqtRjAXe6iB3kf8ToLi3phEh6G/gFDLV4Nc7dvlAArwyMzyS84fx7Cpg==
X-Received: by 2002:a17:906:1918:b0:7ad:ca80:5669 with SMTP id a24-20020a170906191800b007adca805669mr7695499eje.64.1674055287027;
        Wed, 18 Jan 2023 07:21:27 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id i12-20020aa7dd0c000000b0047021294426sm14214462edv.90.2023.01.18.07.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:21:26 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v5 05/12] devlink: protect health reporter operation with instance lock
Date:   Wed, 18 Jan 2023 16:21:08 +0100
Message-Id: <20230118152115.1113149-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118152115.1113149-1-jiri@resnulli.us>
References: <20230118152115.1113149-1-jiri@resnulli.us>
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
v4->v5:
- changed mlx5 bits due to changed locking scheme
- added locked versions of port reporter create/destroy functions
v2->v3:
- split from v2 patch #4 - "devlink: remove reporters_lock", no change
---
 drivers/net/ethernet/mellanox/mlxsw/core.c |  8 +-
 drivers/net/netdevsim/health.c             | 20 ++---
 include/net/devlink.h                      | 22 ++++-
 net/devlink/leftover.c                     | 99 +++++++++++++++++-----
 4 files changed, 110 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a0a06e2eff82..33ef726e4d54 100644
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
index d7c9572e5bea..0d64feaef7cb 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1865,18 +1865,34 @@ int devlink_fmsg_binary_pair_put(struct devlink_fmsg *fmsg, const char *name,
 				 const void *value, u32 value_len);
 
 struct devlink_health_reporter *
-devlink_health_reporter_create(struct devlink *devlink,
-			       const struct devlink_health_reporter_ops *ops,
-			       u64 graceful_period, void *priv);
+devl_port_health_reporter_create(struct devlink_port *port,
+				 const struct devlink_health_reporter_ops *ops,
+				 u64 graceful_period, void *priv);
 
 struct devlink_health_reporter *
 devlink_port_health_reporter_create(struct devlink_port *port,
 				    const struct devlink_health_reporter_ops *ops,
 				    u64 graceful_period, void *priv);
 
+struct devlink_health_reporter *
+devl_health_reporter_create(struct devlink *devlink,
+			    const struct devlink_health_reporter_ops *ops,
+			    u64 graceful_period, void *priv);
+
+struct devlink_health_reporter *
+devlink_health_reporter_create(struct devlink *devlink,
+			       const struct devlink_health_reporter_ops *ops,
+			       u64 graceful_period, void *priv);
+
+void
+devl_health_reporter_destroy(struct devlink_health_reporter *reporter);
+
 void
 devlink_health_reporter_destroy(struct devlink_health_reporter *reporter);
 
+void
+devl_port_health_reporter_destroy(struct devlink_health_reporter *reporter);
+
 void
 devlink_port_health_reporter_destroy(struct devlink_health_reporter *reporter);
 
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index c92bc04bc25c..0fc374140e6a 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -7337,8 +7337,8 @@ __devlink_health_reporter_create(struct devlink *devlink,
 }
 
 /**
- *	devlink_port_health_reporter_create - create devlink health reporter for
- *	                                      specified port instance
+ *	devl_port_health_reporter_create - create devlink health reporter for
+ *	                                   specified port instance
  *
  *	@port: devlink_port which should contain the new reporter
  *	@ops: ops
@@ -7346,12 +7346,13 @@ __devlink_health_reporter_create(struct devlink *devlink,
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
@@ -7370,10 +7371,26 @@ devlink_port_health_reporter_create(struct devlink_port *port,
 	mutex_unlock(&port->reporters_lock);
 	return reporter;
 }
+EXPORT_SYMBOL_GPL(devl_port_health_reporter_create);
+
+struct devlink_health_reporter *
+devlink_port_health_reporter_create(struct devlink_port *port,
+				    const struct devlink_health_reporter_ops *ops,
+				    u64 graceful_period, void *priv)
+{
+	struct devlink_health_reporter *reporter;
+	struct devlink *devlink = port->devlink;
+
+	devl_lock(devlink);
+	reporter = devl_port_health_reporter_create(port, ops,
+						    graceful_period, priv);
+	devl_unlock(devlink);
+	return reporter;
+}
 EXPORT_SYMBOL_GPL(devlink_port_health_reporter_create);
 
 /**
- *	devlink_health_reporter_create - create devlink health reporter
+ *	devl_health_reporter_create - create devlink health reporter
  *
  *	@devlink: devlink
  *	@ops: ops
@@ -7381,12 +7398,13 @@ EXPORT_SYMBOL_GPL(devlink_port_health_reporter_create);
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
@@ -7403,6 +7421,21 @@ devlink_health_reporter_create(struct devlink *devlink,
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
@@ -7429,35 +7462,61 @@ __devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
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
+EXPORT_SYMBOL_GPL(devl_port_health_reporter_destroy);
+
+void
+devlink_port_health_reporter_destroy(struct devlink_health_reporter *reporter)
+{
+	struct devlink *devlink = reporter->devlink;
+
+	devl_lock(devlink);
+	devl_port_health_reporter_destroy(reporter);
+	devl_unlock(devlink);
+}
 EXPORT_SYMBOL_GPL(devlink_port_health_reporter_destroy);
 
 static int
@@ -7805,12 +7864,11 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
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
@@ -7824,6 +7882,7 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
 				NLM_F_MULTI);
 			if (err) {
 				mutex_unlock(&devlink->reporters_lock);
+				devl_unlock(devlink);
 				devlink_put(devlink);
 				state->idx = idx;
 				goto out;
@@ -7832,10 +7891,6 @@ devlink_nl_cmd_health_reporter_get_dumpit(struct sk_buff *msg,
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

