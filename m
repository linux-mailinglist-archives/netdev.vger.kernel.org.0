Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D51C8DFE
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfJBQNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:13:02 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53315 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfJBQMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:12:45 -0400
Received: by mail-wm1-f67.google.com with SMTP id i16so7843396wmd.3
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EFnHhvIKcs8Tdec4KjF60PLS45TjmgGzMtfnuxqxoh4=;
        b=ucRifv+rBHIV1KRAtTArlF9gnOYurjPyTI7h1+6+qllFcSOYti5UnLVw+wIIzKNqFG
         QvsOUZF0EI0PFGQmk5UZKzRl3zmSYMuNwFdgv/ktvhO6nUst0gK5w+rqetqFQ8/0ufQh
         zef0Ww7mH5a2mbGszVqb8vNR9lHTxJ/YjUh6+5nR0ru73lxZe2p+eE7fbk7RXCHW9V8X
         +ruNhX/1aCMq8a+275sPMQOqXcGwGETA79vyK7dDjLVGTROWlM66qjtbCyo3Gl9EMFEG
         Uza0fWhe6yh0SUGiJp2utCX9vlYkZsnToi6LDCCA2e1W1fbORykGlUrkxE/hh9z4Rd7M
         keZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EFnHhvIKcs8Tdec4KjF60PLS45TjmgGzMtfnuxqxoh4=;
        b=ATfnLQ8TRYPwUftVp1tua4bgeMh6FH/EhPq1cRm89HRBzK9Uv6pkX0IKmGCKvabrzo
         bflo7lUWzyrDbs725+8c8q9QFsRh22vnjD356wfqp95q8qAxooyZhkvmiiVnI5+DJYrX
         kBWqh1/wjFTUDXruZGrybJ5Hsrnuj7sC4D7lyC9Oi/aXoq8Dc1uQlFnHIorTLoj/B/kw
         smB3sSfHyNo+Ody/r49AlEIu9FPbozAnW28jgmGepg6yDQ/pRXXkL8pJyTgzdLscOj3I
         sg0q3l4zdA4y3Ns3sbBJkeFEqeckfWC5t7XvLRL23M8CbpZD8/rDBC7Vl1FqsmTu13Wr
         6HaQ==
X-Gm-Message-State: APjAAAVmtyCXyAgdI/CVaWnj/xxGPURc2ppHetzPEoLrGXa3ko0ALTzw
        QwdZ9PlqRqObRtnxwkZfyhPEr9kQ2Kg=
X-Google-Smtp-Source: APXvYqzl7yPmDR/pvRCUtERRmfZC6rCRKeXYGNeSQnhJhSbUvRogm6lB1PG9HqogtoEN6s3Kug2VAw==
X-Received: by 2002:a7b:c391:: with SMTP id s17mr3703232wmj.94.1570032762434;
        Wed, 02 Oct 2019 09:12:42 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y3sm9232073wmg.2.2019.10.02.09.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:12:41 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v2 09/15] mlxsw: Propagate extack down to register_fib_notifier()
Date:   Wed,  2 Oct 2019 18:12:25 +0200
Message-Id: <20191002161231.2987-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002161231.2987-1-jiri@resnulli.us>
References: <20191002161231.2987-1-jiri@resnulli.us>
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
v1->v2:
- s/reaload/reload/ in the patch description
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
index 14dcc786926d..1e61a012ca43 100644
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
index e1ef4d255b93..3377a1b39b03 100644
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
@@ -253,7 +254,8 @@ struct mlxsw_driver {
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
index a9ea9c7b9e59..c91b8238c8c5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4739,7 +4739,8 @@ static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
 				    unsigned long event, void *ptr);
 
 static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
-			 const struct mlxsw_bus_info *mlxsw_bus_info)
+			 const struct mlxsw_bus_info *mlxsw_bus_info,
+			 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	int err;
@@ -4832,7 +4833,7 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		goto err_acl_init;
 	}
 
-	err = mlxsw_sp_router_init(mlxsw_sp);
+	err = mlxsw_sp_router_init(mlxsw_sp, extack);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to initialize router\n");
 		goto err_router_init;
@@ -4927,7 +4928,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 }
 
 static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
-			  const struct mlxsw_bus_info *mlxsw_bus_info)
+			  const struct mlxsw_bus_info *mlxsw_bus_info,
+			  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
@@ -4947,11 +4949,12 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
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
 
@@ -4967,7 +4970,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
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
index 3479f805b377..0e99b64450ca 100644
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

