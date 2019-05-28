Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE2E2C5AB
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfE1Lsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:48:53 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36751 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfE1Lsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:48:51 -0400
Received: by mail-wr1-f68.google.com with SMTP id s17so19883210wru.3
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 04:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oNTD5eUYWhF5lyt/wEm4+kRnQRCfrTX1xw7rfTxlgl4=;
        b=IpvgvwRONV0GbsyTkgtXZggPZimPZ+MBEgzsfbZOv76wy11+PM19U3P+WEXhuujTVG
         PRVOZppGMXQ+UronLA345X/PzAQl0+U+y3sCWcT16gpVKNvMLVYwIUrSQVAIOLpi+e6J
         ikMpmz/aQ/Ipw/5poAML3FSIRsdvsYQvibKoIznZmbCDl82cd1f0/mJhEGcgiDS6Xhbx
         toly8hnx7TDOF/LiTkpmLo8Lw6yjN/rgNIwjDjM9M6Teh1ABmsge+q2YpsjvwajneFdQ
         7hwCmq7ud6ATnoSXazs6kAU+TCdUTQGXN2XnSsIyDWBL3tP002Hsz87TNvnCgUAXcPv8
         7TyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oNTD5eUYWhF5lyt/wEm4+kRnQRCfrTX1xw7rfTxlgl4=;
        b=mO5L1avTPfLHFKjCHMrJbErX7RX28B/7ApIbx+SFQkuFUAm73DLp+hjzgP9U98y42Q
         Xec1IkKTmyDkxtoarOqyD6GU6eXGOHH85lvbhSZyQ+sHWHkJC3YCMxFPiONMyZWfLaOW
         k2IIGDCKVwMBj1bXOBXbKZQwzR6RnB1ST+YuYUV9lRRuRmFepCHPtDZ9CSxoFcDZzJ1z
         mO2yURmDJyZtrL5+GdwYmcg6C2r5Hn4x2joTt8+1QdigInbf0DkqtvQXMxnBhfE6y+Pa
         ph+uO0dYFxC2MvMNdPefwtfjwP5miWQp2AaxQJMwKfJoYhe3x017EKPFNNfaIj7Hr9lM
         NXkQ==
X-Gm-Message-State: APjAAAXIBU7+ZECg6zU+y5QktdQsRI/Ttpv3mnAGt3ocuPRmFyZqXtVM
        FztX/2r6VvnYtreV99TfP9zHNrjAT9Y=
X-Google-Smtp-Source: APXvYqyTIqUWsJlzcXqf8VYly8VYTcZvGJ4/CkjXZyOIFfNZawz/4UEy6wMjE7BCQbL+N2Ykw57GUw==
X-Received: by 2002:a5d:688f:: with SMTP id h15mr18377380wru.44.1559044128125;
        Tue, 28 May 2019 04:48:48 -0700 (PDT)
Received: from localhost (ip-89-177-126-215.net.upcbroadband.cz. [89.177.126.215])
        by smtp.gmail.com with ESMTPSA id f11sm13927453wrv.93.2019.05.28.04.48.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 04:48:47 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v2 1/7] mlxsw: Move firmware flash implementation to devlink
Date:   Tue, 28 May 2019 13:48:40 +0200
Message-Id: <20190528114846.1983-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190528114846.1983-1-jiri@resnulli.us>
References: <20190528114846.1983-1-jiri@resnulli.us>
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

