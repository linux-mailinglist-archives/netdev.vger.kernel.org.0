Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D27F27996
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbfEWJpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:45:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42597 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730028AbfEWJpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:45:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id l2so5494285wrb.9
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 02:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oNTD5eUYWhF5lyt/wEm4+kRnQRCfrTX1xw7rfTxlgl4=;
        b=O3zN6XNOWh2fpGlVv0mrj5j3J7d3iOpKlJ/0OcWkYpd3AXBwnxFvSdDCnDHX4DVH4l
         Hj4o7EFNJkw3M/YDvacqWBR+7QEI/ox6AAODo22av5Yz+QEf5pw4iaDVhtBBBKpliSj9
         ue8MjWmTt1zlv/asO6oeu9sz20usC948qyNkiDAVujU8nVHYQD/pUX+llUzjXeXBM/Dt
         ZwaC+NNLSpuEsHTUyOmu/wQufA/IsK5ZwAkG0JITKBmjrYVRKUujMGPvpYjLArgB88DW
         6YJQ8ae6FkS7oXb3mDTFcYLVb5cYlOuA3FiP8IDOqzOhaIJAUax5adUfV1cG8QNjL4eR
         zhUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oNTD5eUYWhF5lyt/wEm4+kRnQRCfrTX1xw7rfTxlgl4=;
        b=D95HsYUPQqY3WBCozXV83n4Ze4ohLBiAX/7jZIrjyKKg4xC3ida4dRmEzJtxDSZf2/
         biOW4vSZx6V7dJiTtt0ukia4Q8JvBak4Pl4uht0teBk7QxnZxokVxjSP1KcX1F4qm8+A
         Dqar4db48WepnIKaYvXysF2NLKAB+nkxGyF4GSJw+Z3LO6E0GL+++o9UYBkRbjoshNTT
         2Sxk8zFd32Xz8iQ9OjN3rg5LHs0+iSRIcxYw5nDr3rBk/p6XKty/GkFi8OCgNEj1v7ve
         FC4EG04OYA5xVsCjjzHRMrf+RGB+etthl3TJxVjkI/T5tUMQKsW2TrDMmCaA8vNBCsIQ
         vInw==
X-Gm-Message-State: APjAAAUpXLC+Qu2LyvEfOuCYjyN2XzLu0P75uOHVwyzCIF55Q8FIsEEd
        6Wz2aM6lXMYk5C5XmRGI5e8g2nsxLLg=
X-Google-Smtp-Source: APXvYqyvtAHARfENmaiV7wOYVoVADeP+CGuv8IvrfjRFpDHdkcb7/cXPYgZh4O3UWQGuTgmjKJR18Q==
X-Received: by 2002:a5d:53c6:: with SMTP id a6mr34277007wrw.232.1558604712620;
        Thu, 23 May 2019 02:45:12 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id z5sm9193982wmi.34.2019.05.23.02.45.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 02:45:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org
Subject: [patch net-next 1/7] mlxsw: Move firmware flash implementation to devlink
Date:   Thu, 23 May 2019 11:45:04 +0200
Message-Id: <20190523094510.2317-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190523094510.2317-1-jiri@resnulli.us>
References: <20190523094510.2317-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Benefit from the devlink flash update implementation and ethtool
fallback to it and move firmware flash implementation there.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 15 ++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  3 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 49 +++++++++----------
 3 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 6ee6de7f0160..a992a7c69b45 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1003,6 +1003,20 @@ static int mlxsw_devlink_core_bus_device_reload(struct devlink *devlink,
 	return err;
 }
 
+static int mlxsw_devlink_flash_update(struct devlink *devlink,
+				      const char *file_name,
+				      const char *component,
+				      struct netlink_ext_ack *extack)
+{
+	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
+	struct mlxsw_driver *mlxsw_driver = mlxsw_core->driver;
+
+	if (!mlxsw_driver->flash_update)
+		return -EOPNOTSUPP;
+	return mlxsw_driver->flash_update(mlxsw_core, file_name,
+					  component, extack);
+}
+
 static const struct devlink_ops mlxsw_devlink_ops = {
 	.reload				= mlxsw_devlink_core_bus_device_reload,
 	.port_type_set			= mlxsw_devlink_port_type_set,
@@ -1019,6 +1033,7 @@ static const struct devlink_ops mlxsw_devlink_ops = {
 	.sb_occ_port_pool_get		= mlxsw_devlink_sb_occ_port_pool_get,
 	.sb_occ_tc_port_bind_get	= mlxsw_devlink_sb_occ_tc_port_bind_get,
 	.info_get			= mlxsw_devlink_info_get,
+	.flash_update			= mlxsw_devlink_flash_update,
 };
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index e3832cb5bdda..a44ad0fb9477 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -284,6 +284,9 @@ struct mlxsw_driver {
 				       unsigned int sb_index, u16 tc_index,
 				       enum devlink_sb_pool_type pool_type,
 				       u32 *p_cur, u32 *p_max);
+	int (*flash_update)(struct mlxsw_core *mlxsw_core,
+			    const char *file_name, const char *component,
+			    struct netlink_ext_ack *extack);
 	void (*txhdr_construct)(struct sk_buff *skb,
 				const struct mlxsw_tx_info *tx_info);
 	int (*resources_register)(struct mlxsw_core *mlxsw_core);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index dbb425717f5e..861a77538859 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -388,6 +388,27 @@ static int mlxsw_sp_fw_rev_validate(struct mlxsw_sp *mlxsw_sp)
 		return 0;
 }
 
+static int mlxsw_sp_flash_update(struct mlxsw_core *mlxsw_core,
+				 const char *file_name, const char *component,
+				 struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	const struct firmware *firmware;
+	int err;
+
+	if (component)
+		return -EOPNOTSUPP;
+
+	err = request_firmware_direct(&firmware, file_name,
+				      mlxsw_sp->bus_info->dev);
+	if (err)
+		return err;
+	err = mlxsw_sp_firmware_flash(mlxsw_sp, firmware);
+	release_firmware(firmware);
+
+	return err;
+}
+
 int mlxsw_sp_flow_counter_get(struct mlxsw_sp *mlxsw_sp,
 			      unsigned int counter_index, u64 *packets,
 			      u64 *bytes)
@@ -3155,31 +3176,6 @@ mlxsw_sp_port_set_link_ksettings(struct net_device *dev,
 	return 0;
 }
 
-static int mlxsw_sp_flash_device(struct net_device *dev,
-				 struct ethtool_flash *flash)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	const struct firmware *firmware;
-	int err;
-
-	if (flash->region != ETHTOOL_FLASH_ALL_REGIONS)
-		return -EOPNOTSUPP;
-
-	dev_hold(dev);
-	rtnl_unlock();
-
-	err = request_firmware_direct(&firmware, flash->data, &dev->dev);
-	if (err)
-		goto out;
-	err = mlxsw_sp_firmware_flash(mlxsw_sp, firmware);
-	release_firmware(firmware);
-out:
-	rtnl_lock();
-	dev_put(dev);
-	return err;
-}
-
 static int mlxsw_sp_get_module_info(struct net_device *netdev,
 				    struct ethtool_modinfo *modinfo)
 {
@@ -3220,7 +3216,6 @@ static const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.get_sset_count		= mlxsw_sp_port_get_sset_count,
 	.get_link_ksettings	= mlxsw_sp_port_get_link_ksettings,
 	.set_link_ksettings	= mlxsw_sp_port_set_link_ksettings,
-	.flash_device		= mlxsw_sp_flash_device,
 	.get_module_info	= mlxsw_sp_get_module_info,
 	.get_module_eeprom	= mlxsw_sp_get_module_eeprom,
 };
@@ -4885,6 +4880,7 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.sb_occ_max_clear		= mlxsw_sp_sb_occ_max_clear,
 	.sb_occ_port_pool_get		= mlxsw_sp_sb_occ_port_pool_get,
 	.sb_occ_tc_port_bind_get	= mlxsw_sp_sb_occ_tc_port_bind_get,
+	.flash_update			= mlxsw_sp_flash_update,
 	.txhdr_construct		= mlxsw_sp_txhdr_construct,
 	.resources_register		= mlxsw_sp1_resources_register,
 	.kvd_sizes_get			= mlxsw_sp_kvd_sizes_get,
@@ -4913,6 +4909,7 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.sb_occ_max_clear		= mlxsw_sp_sb_occ_max_clear,
 	.sb_occ_port_pool_get		= mlxsw_sp_sb_occ_port_pool_get,
 	.sb_occ_tc_port_bind_get	= mlxsw_sp_sb_occ_tc_port_bind_get,
+	.flash_update			= mlxsw_sp_flash_update,
 	.txhdr_construct		= mlxsw_sp_txhdr_construct,
 	.resources_register		= mlxsw_sp2_resources_register,
 	.params_register		= mlxsw_sp2_params_register,
-- 
2.17.2

