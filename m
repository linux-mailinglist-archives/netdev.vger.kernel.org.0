Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0549B2A2A
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfINGq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:46:26 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38454 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfINGqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:46:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id o184so4842840wme.3
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Q3BfLODAiaNr5+ufRKoXGY/m0nm2cQRBZOXP8Vg/7A=;
        b=pOvrw95AGmDGd98wEn80r6h5c47ljAuYqsJ5Eu3EHUHjHaOsuq2rfX5+0WIRm5T9mc
         cQJFCbUGI1CMtAFd5QvRnix9z4J7h8bSZSa+ETL8GGR/8IgY4O2QOPr3Wb2zrNlLEXJP
         zQhg3V7HhGb/rBgVMFCTNWGKwU7yPR60DJG8//2GkWL6RDgwo+fwY4Vh1aS0mXiy3SWH
         1h7utXS7FeQO5hHy7Bp3Eymiz5tOQt7fgi5Vd5OWvhBQSPsWWY2AKQaiO8m3sUvI8Yho
         zK11vC8gfNpIb39OCdnN6dFKgeRevyjT2GEZ0ZRCfVqPo5HxKelDqsNuL94V79Zd4Jxc
         xt9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Q3BfLODAiaNr5+ufRKoXGY/m0nm2cQRBZOXP8Vg/7A=;
        b=YG5rrhf8EL3NBqPxMPcp9mpuwwxypRBz6k61U475AG1OyTkGZFKHySfXbsX6I8asm5
         Km9WMgbfg9v5TfS3CeU0dXtd8nGfwEE3U3PdsikiUYUgic0e6pzA4EFd2pKqUGy8tOoD
         Ws1NOrkGU2aRevtZQiaRv5uNLnF+6St7zKOtZ+VU6c02O7osyCIeStp0kASTlgPgPyW3
         VEW3jp6ApuE5CnYlmq3VUhhEqnut9m7qdDpPJch0tfW5TamdCGhNbVXoqlwo1GJBDtfr
         yEot7fpNw+L2gpaASv8nUuOS2o7dlFPtf5AXQYanGvvAYT3NGzGO41Qa27F2+Cq/ffRG
         bluA==
X-Gm-Message-State: APjAAAXMyY1e56KM9QNMVAQDkFgZ+2ABf56/Ic2BrIrYd4p1FoYl91qK
        1XX3AMQTEypVBc5g1j09mysaazfWzpQ=
X-Google-Smtp-Source: APXvYqyAE7Ffr/YSkwZv0Myx477fvhdRgtEtIqiCJrPCUhegqj3d1ELVitio4t6kxCIUDieWkbbeJQ==
X-Received: by 2002:a1c:7d8e:: with SMTP id y136mr5997024wmc.83.1568443579151;
        Fri, 13 Sep 2019 23:46:19 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a13sm54904079wrf.73.2019.09.13.23.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:46:18 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next 09/15] mlxsw: Propagate extack down to register_fib_notifier()
Date:   Sat, 14 Sep 2019 08:46:02 +0200
Message-Id: <20190914064608.26799-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190914064608.26799-1-jiri@resnulli.us>
References: <20190914064608.26799-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

During the devlink reaload the extack is present, so propagate it all
the way down to register_fib_notifier() call in spectrum_router.c.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c        | 13 ++++++++-----
 drivers/net/ethernet/mellanox/mlxsw/core.h        |  6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/i2c.c         |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c     |  3 ++-
 drivers/net/ethernet/mellanox/mlxsw/pci.c         |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c    | 15 +++++++++------
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h    |  3 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c |  5 +++--
 drivers/net/ethernet/mellanox/mlxsw/switchib.c    |  3 ++-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c    |  3 ++-
 10 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 3fa96076e8a5..2bec677318d9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1005,7 +1005,7 @@ mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
 	return mlxsw_core_bus_device_register(mlxsw_core->bus_info,
 					      mlxsw_core->bus,
 					      mlxsw_core->bus_priv, true,
-					      devlink);
+					      devlink, extack);
 }
 
 static int mlxsw_devlink_flash_update(struct devlink *devlink,
@@ -1098,7 +1098,8 @@ static int
 __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 				 const struct mlxsw_bus *mlxsw_bus,
 				 void *bus_priv, bool reload,
-				 struct devlink *devlink)
+				 struct devlink *devlink,
+				 struct netlink_ext_ack *extack)
 {
 	const char *device_kind = mlxsw_bus_info->device_kind;
 	struct mlxsw_core *mlxsw_core;
@@ -1172,7 +1173,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	}
 
 	if (mlxsw_driver->init) {
-		err = mlxsw_driver->init(mlxsw_core, mlxsw_bus_info);
+		err = mlxsw_driver->init(mlxsw_core, mlxsw_bus_info, extack);
 		if (err)
 			goto err_driver_init;
 	}
@@ -1223,14 +1224,16 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 int mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 				   const struct mlxsw_bus *mlxsw_bus,
 				   void *bus_priv, bool reload,
-				   struct devlink *devlink)
+				   struct devlink *devlink,
+				   struct netlink_ext_ack *extack)
 {
 	bool called_again = false;
 	int err;
 
 again:
 	err = __mlxsw_core_bus_device_register(mlxsw_bus_info, mlxsw_bus,
-					       bus_priv, reload, devlink);
+					       bus_priv, reload,
+					       devlink, extack);
 	/* -EAGAIN is returned in case the FW was updated. FW needs
 	 * a reset, so lets try to call __mlxsw_core_bus_device_register()
 	 * again.
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 693b3c5ab355..361fcdf780c3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -37,7 +37,8 @@ void mlxsw_core_driver_unregister(struct mlxsw_driver *mlxsw_driver);
 int mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 				   const struct mlxsw_bus *mlxsw_bus,
 				   void *bus_priv, bool reload,
-				   struct devlink *devlink);
+				   struct devlink *devlink,
+				   struct netlink_ext_ack *extack);
 void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core, bool reload);
 
 struct mlxsw_tx_info {
@@ -248,7 +249,8 @@ struct mlxsw_driver {
 	const char *kind;
 	size_t priv_size;
 	int (*init)(struct mlxsw_core *mlxsw_core,
-		    const struct mlxsw_bus_info *mlxsw_bus_info);
+		    const struct mlxsw_bus_info *mlxsw_bus_info,
+		    struct netlink_ext_ack *extack);
 	void (*fini)(struct mlxsw_core *mlxsw_core);
 	int (*basic_trap_groups_set)(struct mlxsw_core *mlxsw_core);
 	int (*port_type_set)(struct mlxsw_core *mlxsw_core, u8 local_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
index 95f408d0e103..34566eb62c47 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -640,7 +640,7 @@ static int mlxsw_i2c_probe(struct i2c_client *client,
 
 	err = mlxsw_core_bus_device_register(&mlxsw_i2c->bus_info,
 					     &mlxsw_i2c_bus, mlxsw_i2c, false,
-					     NULL);
+					     NULL, NULL);
 	if (err) {
 		dev_err(&client->dev, "Fail to register core bus\n");
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index cee16ad58307..5edd8de57a24 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -327,7 +327,8 @@ static void mlxsw_m_ports_remove(struct mlxsw_m *mlxsw_m)
 }
 
 static int mlxsw_m_init(struct mlxsw_core *mlxsw_core,
-			const struct mlxsw_bus_info *mlxsw_bus_info)
+			const struct mlxsw_bus_info *mlxsw_bus_info,
+			struct netlink_ext_ack *extack)
 {
 	struct mlxsw_m *mlxsw_m = mlxsw_core_driver_priv(mlxsw_core);
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 615455a21567..4ac2f5c16adf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1790,7 +1790,7 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	err = mlxsw_core_bus_device_register(&mlxsw_pci->bus_info,
 					     &mlxsw_pci_bus, mlxsw_pci, false,
-					     NULL);
+					     NULL, NULL);
 	if (err) {
 		dev_err(&pdev->dev, "cannot register bus device\n");
 		goto err_bus_device_register;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 92b37b806dc1..87e06e718646 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4684,7 +4684,8 @@ static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
 				    unsigned long event, void *ptr);
 
 static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
-			 const struct mlxsw_bus_info *mlxsw_bus_info)
+			 const struct mlxsw_bus_info *mlxsw_bus_info,
+			 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	int err;
@@ -4777,7 +4778,7 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		goto err_acl_init;
 	}
 
-	err = mlxsw_sp_router_init(mlxsw_sp);
+	err = mlxsw_sp_router_init(mlxsw_sp, extack);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to initialize router\n");
 		goto err_router_init;
@@ -4870,7 +4871,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 }
 
 static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
-			  const struct mlxsw_bus_info *mlxsw_bus_info)
+			  const struct mlxsw_bus_info *mlxsw_bus_info,
+			  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
@@ -4890,11 +4892,12 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->listeners = mlxsw_sp1_listener;
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp1_listener);
 
-	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info);
+	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
 
 static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
-			  const struct mlxsw_bus_info *mlxsw_bus_info)
+			  const struct mlxsw_bus_info *mlxsw_bus_info,
+			  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
@@ -4910,7 +4913,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
 	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
 
-	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info);
+	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
 
 static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index f58d45e770cd..8f99d70d6b8b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -525,7 +525,8 @@ union mlxsw_sp_l3addr {
 	struct in6_addr addr6;
 };
 
-int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp);
+int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
+			 struct netlink_ext_ack *extack);
 void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp);
 int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
 					 unsigned long event, void *ptr);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index a1c06889178c..308526ed16ba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8061,7 +8061,8 @@ static void __mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rgcr), rgcr_pl);
 }
 
-int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp)
+int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
+			 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_router *router;
 	int err;
@@ -8139,7 +8140,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp->router->fib_nb.notifier_call = mlxsw_sp_router_fib_event;
 	err = register_fib_notifier(mlxsw_sp_net(mlxsw_sp),
 				    &mlxsw_sp->router->fib_nb,
-				    mlxsw_sp_router_fib_dump_flush, NULL);
+				    mlxsw_sp_router_fib_dump_flush, extack);
 	if (err)
 		goto err_register_fib_notifier;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchib.c b/drivers/net/ethernet/mellanox/mlxsw/switchib.c
index 0d9356b3f65d..4ff1e623aa76 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchib.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchib.c
@@ -446,7 +446,8 @@ static int mlxsw_sib_basic_trap_groups_set(struct mlxsw_core *mlxsw_core)
 }
 
 static int mlxsw_sib_init(struct mlxsw_core *mlxsw_core,
-			  const struct mlxsw_bus_info *mlxsw_bus_info)
+			  const struct mlxsw_bus_info *mlxsw_bus_info,
+			  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sib *mlxsw_sib = mlxsw_core_driver_priv(mlxsw_core);
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index a4d09392a8d7..de6cb22f68b1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -1564,7 +1564,8 @@ static int mlxsw_sx_basic_trap_groups_set(struct mlxsw_core *mlxsw_core)
 }
 
 static int mlxsw_sx_init(struct mlxsw_core *mlxsw_core,
-			 const struct mlxsw_bus_info *mlxsw_bus_info)
+			 const struct mlxsw_bus_info *mlxsw_bus_info,
+			 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sx *mlxsw_sx = mlxsw_core_driver_priv(mlxsw_core);
 	int err;
-- 
2.21.0

