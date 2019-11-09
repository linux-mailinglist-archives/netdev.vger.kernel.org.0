Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A683F5E6E
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 11:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfKIK37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 05:29:59 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43532 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbfKIK37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 05:29:59 -0500
Received: by mail-wr1-f67.google.com with SMTP id n1so9652006wra.10
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 02:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2h2IbU2qrDmAGXwrToAIu5qz2ymRIYXETzdL9g9FkWs=;
        b=XYkCLS3IDO9UZRXnCYn+lbJanom2O/GuoPAAG7BwG5g0dKbGwQiF3vbiI+bP+VjlEe
         IKjSI/xc+A/K03K8d5UHPUk3UNkM7Hvhsklf8dFvLz/F0cxEUJr4PHGTWCpGHAolqw9N
         Rkq2ve1xvDKq5mbZgsEGNadfnkNkVdZotYk8EbdnS8EzXY8XewIOmnkRNyp50P1r0uUx
         z0+12ShC/sxceUrC01dv2SevGY3PusarfXLMQ5VpH2HAcHQLa4fNVLdcTaKXwKO8lHrY
         alckURU52Mk/2PHBesInafvrTEcbNGDdhAtoJPdBCcEsSMTDxQFusbjiqaAVzxXwYxQe
         IgUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2h2IbU2qrDmAGXwrToAIu5qz2ymRIYXETzdL9g9FkWs=;
        b=rXN12zcg5xorhtGdaUL4hT1gl2eWNRyqH3HbCh5ykIPtqgQgQmOHzEPoCR0MQmZy9c
         zelq6lAnptWanPD0Zk7i/3PXIsiGsS1hKaPcAm/HKWchwp0OJdADLc6YLZnGk181ToKx
         u1ONHT2loVHjiPtiLn0EiSYN8MLBfY1YG6nzKYiAmx+wzZ49NnOxTGwRLEF7yeSnyUcd
         UNX6RKrSFEcGJUInSGMFPJsN6dw9rzrTCBjadnXrmLPbGniL2NMKjwO76f5/0YUAOQkz
         zhIFuHadUuBni6ijo3ZPBhomiUxlGhD6YMBlaAZGmnFZYwhpIhKf7VUPtkQMjrRTButS
         o23g==
X-Gm-Message-State: APjAAAVKmi3mqxzgbJyVMSTu3yEMagoXDf5L+Tvlf0rKD1UYUqA1JLni
        jj4fGNso/IPtOYkMoqkhC09ozdyjkyo=
X-Google-Smtp-Source: APXvYqw1dcji5UgO/yip0/1SGPi+cIDgEcvSTWOfMmLMUCSpstvEXDq3/hMKupTf/djSnNE/N0RyYA==
X-Received: by 2002:a5d:5227:: with SMTP id i7mr12221062wra.39.1573295388235;
        Sat, 09 Nov 2019 02:29:48 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id x8sm8466715wrm.7.2019.11.09.02.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 02:29:47 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        idosch@mellanox.com, mlxsw@mellanox.com
Subject: [patch net] devlink: disallow reload operation during device cleanup
Date:   Sat,  9 Nov 2019 11:29:46 +0100
Message-Id: <20191109102946.8772-1-jiri@resnulli.us>
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
        echo "0000:00:10.0" >/sys/bus/pci/drivers/mlxsw_spectrum2/bind
        devlink dev reload pci/0000:00:10.0 &
        echo "0000:00:10.0" >/sys/bus/pci/drivers/mlxsw_spectrum2/unbind
done

Fix this by enabling reload only after setup of device is complete and
disabling it at the beginning of the cleanup process.

Reported-by: Ido Schimmel <idosch@mellanox.com>
Fixes: 2d8dc5bbf4e7 ("devlink: Add support for reload")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
This is -net version of fix, net-next fix was sent and is already applied.
Also note that unlike net-next, in -net this is not reproducible with
netdevsim, so the reproducer uses mlxsw driver instead. That is the only
difference in the patch desctiption.
---
 drivers/net/ethernet/mellanox/mlx4/main.c  |  3 ++
 drivers/net/ethernet/mellanox/mlxsw/core.c |  6 +++-
 drivers/net/netdevsim/dev.c                |  2 ++
 include/net/devlink.h                      |  5 ++-
 net/core/devlink.c                         | 39 +++++++++++++++++++++-
 5 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 69bb6bb06e76..d44ac666e730 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4010,6 +4010,7 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_params_unregister;
 
 	devlink_params_publish(devlink);
+	devlink_reload_enable(devlink);
 	pci_save_state(pdev);
 	return 0;
 
@@ -4121,6 +4122,8 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(priv);
 	int active_vfs = 0;
 
+	devlink_reload_disable(devlink);
+
 	if (mlx4_is_slave(dev))
 		persist->interface_state |= MLX4_INTERFACE_STATE_NOWAIT;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 4421ab22182f..20e9dc46cacd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1186,8 +1186,10 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_thermal_init;
 
-	if (mlxsw_driver->params_register)
+	if (mlxsw_driver->params_register) {
 		devlink_params_publish(devlink);
+		devlink_reload_enable(devlink);
+	}
 
 	return 0;
 
@@ -1249,6 +1251,8 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
+	if (!reload)
+		devlink_reload_disable(devlink);
 	if (devlink_is_reload_failed(devlink)) {
 		if (!reload)
 			/* Only the parts that were not de-initialized in the
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 54ca6681ba31..44c2d857a7fa 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -708,6 +708,7 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 		goto err_debugfs_exit;
 
 	devlink_params_publish(devlink);
+	devlink_reload_enable(devlink);
 	return nsim_dev;
 
 err_debugfs_exit:
@@ -732,6 +733,7 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 {
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
+	devlink_reload_disable(devlink);
 	nsim_bpf_dev_exit(nsim_dev);
 	nsim_dev_debugfs_exit(nsim_dev);
 	nsim_dev_traps_exit(devlink);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 23e4b65ec9df..2116c88663a1 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -38,7 +38,8 @@ struct devlink {
 	struct device *dev;
 	possible_net_t _net;
 	struct mutex lock;
-	bool reload_failed;
+	u8 reload_failed:1,
+	   reload_enabled:1;
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
@@ -774,6 +775,8 @@ struct ib_device;
 struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size);
 int devlink_register(struct devlink *devlink, struct device *dev);
 void devlink_unregister(struct devlink *devlink);
+void devlink_reload_enable(struct devlink *devlink);
+void devlink_reload_disable(struct devlink *devlink);
 void devlink_free(struct devlink *devlink);
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f80151eeaf51..7d64660a72fc 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2699,7 +2699,7 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	struct devlink *devlink = info->user_ptr[0];
 	int err;
 
-	if (!devlink_reload_supported(devlink))
+	if (!devlink_reload_supported(devlink) || !devlink->reload_enabled)
 		return -EOPNOTSUPP;
 
 	err = devlink_resources_validate(devlink, NULL, info);
@@ -6196,12 +6196,49 @@ EXPORT_SYMBOL_GPL(devlink_register);
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
-- 
2.21.0

