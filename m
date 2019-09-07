Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBAC4AC94E
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 22:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406375AbfIGUyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 16:54:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43678 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfIGUyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 16:54:06 -0400
Received: by mail-wr1-f68.google.com with SMTP id q17so5155767wrx.10
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 13:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B4eyirXQl/71JnvB81plFfN+FjkRupFKSw5b9ZxXNI8=;
        b=HRgO9uctWLi+2OQTHiL6r1n1owIFfkfzAPmgvAGlevRW5TFHW3DoEC+BHUc7B+zGM+
         PFyyXTtS7JM0ltnLZnAV9Gc2b6+yjZk3SRDiAYrgnuKEOeeQg2pgJJgqzITm4IBJaEe6
         08Do3DDmnS5VrsOFT5GSMEAxCDT/+M9RktMbmGLALsKSyIbnmiNA2leGizHdSXO12fyq
         PXk7+9gvPR0F6vY37rgGuJcENNUOoIGUmrWB6hfn8LNafPahoLSWFggmzHcXpOpvab3E
         bmgg7fmq/c1s4brhZscUqKT0AJUx6FK1AAajAuqZTFxQq2lSgsz+Sh/v8SrCaSgIWRX4
         hWeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B4eyirXQl/71JnvB81plFfN+FjkRupFKSw5b9ZxXNI8=;
        b=FNCMchzpZgqJJmjxZMVLNNfB+66xtGfTlKwP+cxnTMf5Yp1xV5j6aHDaLS2Ggpn88S
         QxQXw4iyfiE6CvE3xEE8JG519c1bCeAdnfRtNXIIrXc+ANpgSRwMoSYTSQAJR7plbcph
         MpFxahqwPIJad4BuUVkfT9OTkSlb8MwqwaIdV0ENqpGcDu9Jb/GR/g7Y9dmFc8w/QVI9
         U6i9kNfc3Nt4eTAW3omkZ2m2eQKCw/7uv1kOkY3UykKWy+U4zFqoz7cbgqE4z8lJGOYn
         4kaPx3ouypzdERDNGZzl/3cEq9ZfSKldIH6J/Ed2xKhPxg6a029LJDvdkGprbOaF55ou
         YIDg==
X-Gm-Message-State: APjAAAX3Dr95kEH6DSAxc5L9AKA/eKAU8vmbsarc1f8TeKjt8Kx+5Bv3
        kWM/jU3zyiSht7l/yP4NDSbuD1yNF7A=
X-Google-Smtp-Source: APXvYqyV3st4rL0Bw3k6FA7FP0QdzDcywpZxmv3n/W7DdZVAXw11Nsoo85unWi3zVNhWVcJmPSp8sA==
X-Received: by 2002:adf:f110:: with SMTP id r16mr13018048wro.152.1567889643360;
        Sat, 07 Sep 2019 13:54:03 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v4sm16874944wrg.56.2019.09.07.13.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 13:54:03 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 2/3] net: devlink: split reload op into two
Date:   Sat,  7 Sep 2019 22:53:59 +0200
Message-Id: <20190907205400.14589-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190907205400.14589-1-jiri@resnulli.us>
References: <20190907205400.14589-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

In order to properly implement failure indication during reload,
split the reload op into two ops, one for down phase and one for
up phase.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c  | 19 +++++++++++++++----
 drivers/net/ethernet/mellanox/mlxsw/core.c | 19 +++++++++++++++----
 drivers/net/netdevsim/dev.c                | 13 ++++++++++---
 include/net/devlink.h                      |  5 ++++-
 net/core/devlink.c                         | 16 ++++++++++++----
 5 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index a39c647c12dc..ef3f3d06ff1e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3935,17 +3935,27 @@ static void mlx4_restart_one_down(struct pci_dev *pdev);
 static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
 			       struct devlink *devlink);
 
-static int mlx4_devlink_reload(struct devlink *devlink,
-			       struct netlink_ext_ack *extack)
+static int mlx4_devlink_reload_down(struct devlink *devlink,
+				    struct netlink_ext_ack *extack)
 {
 	struct mlx4_priv *priv = devlink_priv(devlink);
 	struct mlx4_dev *dev = &priv->dev;
 	struct mlx4_dev_persistent *persist = dev->persist;
-	int err;
 
 	if (persist->num_vfs)
 		mlx4_warn(persist->dev, "Reload performed on PF, will cause reset on operating Virtual Functions\n");
 	mlx4_restart_one_down(persist->pdev);
+	return 0;
+}
+
+static int mlx4_devlink_reload_up(struct devlink *devlink,
+				  struct netlink_ext_ack *extack)
+{
+	struct mlx4_priv *priv = devlink_priv(devlink);
+	struct mlx4_dev *dev = &priv->dev;
+	struct mlx4_dev_persistent *persist = dev->persist;
+	int err;
+
 	err = mlx4_restart_one_up(persist->pdev, true, devlink);
 	if (err)
 		mlx4_err(persist->dev, "mlx4_restart_one_up failed, ret=%d\n",
@@ -3956,7 +3966,8 @@ static int mlx4_devlink_reload(struct devlink *devlink,
 
 static const struct devlink_ops mlx4_devlink_ops = {
 	.port_type_set	= mlx4_devlink_port_type_set,
-	.reload		= mlx4_devlink_reload,
+	.reload_down	= mlx4_devlink_reload_down,
+	.reload_up	= mlx4_devlink_reload_up,
 };
 
 static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 963a2b4b61b1..c71a1d9ea17b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -984,16 +984,26 @@ mlxsw_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	return 0;
 }
 
-static int mlxsw_devlink_core_bus_device_reload(struct devlink *devlink,
-						struct netlink_ext_ack *extack)
+static int
+mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
+					  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
-	int err;
 
 	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_RESET))
 		return -EOPNOTSUPP;
 
 	mlxsw_core_bus_device_unregister(mlxsw_core, true);
+	return 0;
+}
+
+static int
+mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
+					struct netlink_ext_ack *extack)
+{
+	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
+	int err;
+
 	err = mlxsw_core_bus_device_register(mlxsw_core->bus_info,
 					     mlxsw_core->bus,
 					     mlxsw_core->bus_priv, true,
@@ -1066,7 +1076,8 @@ mlxsw_devlink_trap_group_init(struct devlink *devlink,
 }
 
 static const struct devlink_ops mlxsw_devlink_ops = {
-	.reload				= mlxsw_devlink_core_bus_device_reload,
+	.reload_down		= mlxsw_devlink_core_bus_device_reload_down,
+	.reload_up		= mlxsw_devlink_core_bus_device_reload_up,
 	.port_type_set			= mlxsw_devlink_port_type_set,
 	.port_split			= mlxsw_devlink_port_split,
 	.port_unsplit			= mlxsw_devlink_port_unsplit,
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 39cdb6c18ec0..7fba7b271a57 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -521,8 +521,14 @@ static void nsim_dev_traps_exit(struct devlink *devlink)
 	kfree(nsim_dev->trap_data);
 }
 
-static int nsim_dev_reload(struct devlink *devlink,
-			   struct netlink_ext_ack *extack)
+static int nsim_dev_reload_down(struct devlink *devlink,
+				struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+static int nsim_dev_reload_up(struct devlink *devlink,
+			      struct netlink_ext_ack *extack)
 {
 	enum nsim_resource_id res_ids[] = {
 		NSIM_RESOURCE_IPV4_FIB, NSIM_RESOURCE_IPV4_FIB_RULES,
@@ -638,7 +644,8 @@ nsim_dev_devlink_trap_action_set(struct devlink *devlink,
 }
 
 static const struct devlink_ops nsim_dev_devlink_ops = {
-	.reload = nsim_dev_reload,
+	.reload_down = nsim_dev_reload_down,
+	.reload_up = nsim_dev_reload_up,
 	.flash_update = nsim_dev_flash_update,
 	.trap_init = nsim_dev_devlink_trap_init,
 	.trap_action_set = nsim_dev_devlink_trap_action_set,
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 460bc629d1a4..c17709c0d0ec 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -637,7 +637,10 @@ enum devlink_trap_group_generic_id {
 	}
 
 struct devlink_ops {
-	int (*reload)(struct devlink *devlink, struct netlink_ext_ack *extack);
+	int (*reload_down)(struct devlink *devlink,
+			   struct netlink_ext_ack *extack);
+	int (*reload_up)(struct devlink *devlink,
+			 struct netlink_ext_ack *extack);
 	int (*port_type_set)(struct devlink_port *devlink_port,
 			     enum devlink_port_type port_type);
 	int (*port_split)(struct devlink *devlink, unsigned int port_index,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6e52d639dac6..1e3a2288b0b2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2672,12 +2672,17 @@ devlink_resources_validate(struct devlink *devlink,
 	return err;
 }
 
+static bool devlink_reload_supported(struct devlink *devlink)
+{
+	return devlink->ops->reload_down && devlink->ops->reload_up;
+}
+
 static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
 	int err;
 
-	if (!devlink->ops->reload)
+	if (!devlink_reload_supported(devlink))
 		return -EOPNOTSUPP;
 
 	err = devlink_resources_validate(devlink, NULL, info);
@@ -2685,7 +2690,10 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 		NL_SET_ERR_MSG_MOD(info->extack, "resources size validation failed");
 		return err;
 	}
-	return devlink->ops->reload(devlink, info->extack);
+	err = devlink->ops->reload_down(devlink, info->extack);
+	if (err)
+		return err;
+	return devlink->ops->reload_up(devlink, info->extack);
 }
 
 static int devlink_nl_flash_update_fill(struct sk_buff *msg,
@@ -7145,7 +7153,7 @@ __devlink_param_driverinit_value_set(struct devlink *devlink,
 int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 				       union devlink_param_value *init_val)
 {
-	if (!devlink->ops->reload)
+	if (!devlink_reload_supported(devlink))
 		return -EOPNOTSUPP;
 
 	return __devlink_param_driverinit_value_get(&devlink->param_list,
@@ -7192,7 +7200,7 @@ int devlink_port_param_driverinit_value_get(struct devlink_port *devlink_port,
 {
 	struct devlink *devlink = devlink_port->devlink;
 
-	if (!devlink->ops->reload)
+	if (!devlink_reload_supported(devlink))
 		return -EOPNOTSUPP;
 
 	return __devlink_param_driverinit_value_get(&devlink_port->param_list,
-- 
2.21.0

