Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5D7F58C4
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbfKHUmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 15:42:47 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38621 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKHUmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 15:42:46 -0500
Received: by mail-wr1-f65.google.com with SMTP id i12so1573220wro.5
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 12:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JwoUIytky8KFIplKABVcprVJbi9zb2oLasBKQHogq0c=;
        b=TpjSw3l199//gLyh9wmCtxqYwen/sH3AcyUaMI2zgx7/zVyCzYpkS2dZKf6Pe6WnRh
         HYGXkWRSvXP07ufGCtayPES/9uQmbjck0HyGZlflwE2/XZGWh8zd+UKMwn2autydrePs
         9A76YdhfUVtJnbEqdb7eIpS+CL7qphB7GqheWYtGtmtA8K/NwUUwCa8mHE6467epv5AY
         ADtnVmh1KeOE9Wg9NMjcJkI1md3C8o4dGgE93HfPwUdTBaT/IkS+C4iQF7VtxojQhxCH
         WuufS+6Wo+2sBig+vvO/LMUNYGhfcd8NpYRkvV/cyY3Izg1+aVV+XltSAgWRxMdZxDi1
         jQ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JwoUIytky8KFIplKABVcprVJbi9zb2oLasBKQHogq0c=;
        b=N01urIn2D+JyxIDn0Lj5HYmTIz5k4wU07xhvzGiM2CqS/0zdxt/zmCxeYX+YUCTPiy
         uF6Tn4j+tNeKLVTZlzs4QYvNRevkNgIWEmTwMJAwMlzwE3Vv4bQL4byu+LmZVz0wqEl9
         /66wnFbxI7rtyaS5Gd6MdPYuJgfoBHvrznaMdNRjcwBboAkEPYxcQ9uoTEEQ6chBklnT
         Ce9A0BJTMDAaKkGoIC2miEpV+bND0i/OZDHwj/zbznYymdEan5sKlfw3FE+qYS+WNn6/
         /64FbcNdZBDZvG1stmiEkU0shDw34VXRenIu0htE6LLHjVnBwYLwW/sVb2ffwjyQNV/9
         agog==
X-Gm-Message-State: APjAAAV+FRUhVF+dBRBRAOpbR20UxqUZX2Q2RbBmBBR38oiNgUvg5/aa
        m+4TJ6q8MAZxlmetaDLHG7pCLM6MFmo=
X-Google-Smtp-Source: APXvYqwbrciqbTIyHHRQWMX8UKG828CYCkEmHn2wjLSi1xe16J9/zd0fijwR6O9hUeGbcP9byFrlww==
X-Received: by 2002:adf:efcb:: with SMTP id i11mr10100674wrp.229.1573245764268;
        Fri, 08 Nov 2019 12:42:44 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id z6sm8338116wro.18.2019.11.08.12.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 12:42:43 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        idosch@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next] devlink: disallow reload operation during device cleanup
Date:   Fri,  8 Nov 2019 21:42:43 +0100
Message-Id: <20191108204243.7241-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

There is a race between driver code that does setup/cleanup of device
and devlink reload operation that in some drivers works with the same
code. Use after free could we easily obtained by running:

while true; do
        echo 10 > /sys/bus/netdevsim/new_device
        devlink dev reload netdevsim/netdevsim10 &
        echo 10 > /sys/bus/netdevsim/del_device
done

Fix this by enabling reload only after setup of device is complete and
disabling it at the beginning of the cleanup process.

Reported-by: Ido Schimmel <idosch@mellanox.com>
Fixes: 2d8dc5bbf4e7 ("devlink: Add support for reload")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c  |  3 ++
 drivers/net/ethernet/mellanox/mlxsw/core.c |  6 +++-
 drivers/net/netdevsim/dev.c                |  3 ++
 include/net/devlink.h                      |  7 ++--
 net/core/devlink.c                         | 42 +++++++++++++++++++++-
 5 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 22c72fb7206a..77f056b0895e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4015,6 +4015,7 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_params_unregister;
 
 	devlink_params_publish(devlink);
+	devlink_reload_enable(devlink);
 	pci_save_state(pdev);
 	return 0;
 
@@ -4126,6 +4127,8 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(priv);
 	int active_vfs = 0;
 
+	devlink_reload_disable(devlink);
+
 	if (mlx4_is_slave(dev))
 		persist->interface_state |= MLX4_INTERFACE_STATE_NOWAIT;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index e1a90f5bddd0..da436a6aad2f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1198,8 +1198,10 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_thermal_init;
 
-	if (mlxsw_driver->params_register)
+	if (mlxsw_driver->params_register) {
 		devlink_params_publish(devlink);
+		devlink_reload_enable(devlink);
+	}
 
 	return 0;
 
@@ -1263,6 +1265,8 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
+	if (!reload)
+		devlink_reload_disable(devlink);
 	if (devlink_is_reload_failed(devlink)) {
 		if (!reload)
 			/* Only the parts that were not de-initialized in the
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 3da96c7e8265..059711edfc61 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -820,6 +820,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 		goto err_bpf_dev_exit;
 
 	devlink_params_publish(devlink);
+	devlink_reload_enable(devlink);
 	return 0;
 
 err_bpf_dev_exit:
@@ -865,6 +866,8 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
+	devlink_reload_disable(devlink);
+
 	nsim_dev_reload_destroy(nsim_dev);
 
 	nsim_bpf_dev_exit(nsim_dev);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8d6b5846822c..7891611868e4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -38,8 +38,9 @@ struct devlink {
 	struct device *dev;
 	possible_net_t _net;
 	struct mutex lock;
-	bool reload_failed;
-	bool registered;
+	u8 reload_failed:1,
+	   reload_enabled:1,
+	   registered:1;
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
@@ -824,6 +825,8 @@ void devlink_net_set(struct devlink *devlink, struct net *net);
 struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size);
 int devlink_register(struct devlink *devlink, struct device *dev);
 void devlink_unregister(struct devlink *devlink);
+void devlink_reload_enable(struct devlink *devlink);
+void devlink_reload_disable(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index ff53f7d29dea..2e027c9436e0 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2791,6 +2791,9 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 {
 	int err;
 
+	if (!devlink->reload_enabled)
+		return -EOPNOTSUPP;
+
 	err = devlink->ops->reload_down(devlink, !!dest_net, extack);
 	if (err)
 		return err;
@@ -6308,12 +6311,49 @@ EXPORT_SYMBOL_GPL(devlink_register);
 void devlink_unregister(struct devlink *devlink)
 {
 	mutex_lock(&devlink_mutex);
+	WARN_ON(devlink_reload_supported(devlink) &&
+		devlink->reload_enabled);
 	devlink_notify(devlink, DEVLINK_CMD_DEL);
 	list_del(&devlink->list);
 	mutex_unlock(&devlink_mutex);
 }
 EXPORT_SYMBOL_GPL(devlink_unregister);
 
+/**
+ *	devlink_reload_enable - Enable reload of devlink instance
+ *
+ *	@devlink: devlink
+ *
+ *	Should be called at end of device initialization
+ *	process when reload operation is supported.
+ */
+void devlink_reload_enable(struct devlink *devlink)
+{
+	mutex_lock(&devlink_mutex);
+	devlink->reload_enabled = true;
+	mutex_unlock(&devlink_mutex);
+}
+EXPORT_SYMBOL_GPL(devlink_reload_enable);
+
+/**
+ *	devlink_reload_disable - Disable reload of devlink instance
+ *
+ *	@devlink: devlink
+ *
+ *	Should be called at the beginning of device cleanup
+ *	process when reload operation is supported.
+ */
+void devlink_reload_disable(struct devlink *devlink)
+{
+	mutex_lock(&devlink_mutex);
+	/* Mutex is taken which ensures that no reload operation is in
+	 * progress while setting up forbidded flag.
+	 */
+	devlink->reload_enabled = false;
+	mutex_unlock(&devlink_mutex);
+}
+EXPORT_SYMBOL_GPL(devlink_reload_disable);
+
 /**
  *	devlink_free - Free devlink instance resources
  *
@@ -8201,7 +8241,7 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
 			if (WARN_ON(!devlink_reload_supported(devlink)))
 				continue;
 			err = devlink_reload(devlink, &init_net, NULL);
-			if (err)
+			if (err && err != -EOPNOTSUPP)
 				pr_warn("Failed to reload devlink instance into init_net\n");
 		}
 	}
-- 
2.21.0

