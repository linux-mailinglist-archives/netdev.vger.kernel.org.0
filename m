Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 805E63491A
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfFDNkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:40:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37877 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfFDNks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:40:48 -0400
Received: by mail-wm1-f66.google.com with SMTP id 22so108481wmg.2
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VvaXS8h0GaowefIXWE0FjHpy7DVmpcp4vpaylD1KB9o=;
        b=A372HB6ZfvHfOH7S337zae04WfmHPw3zIxbwuylAZSKzwKTzqHFgK3QzoDzM1VA+zg
         EcLSjeUkjXW6QQUK1BYIzdTgrcg1qTx/TMuMF5N3iTJU04SacEzvLjSZLu8vv7q0f8Sg
         DCtvzFXRLg/fSH2BCQMPA9i90dR/W7O1CU+8Cb6O/zzY2OYYcgHWWYyFqkVDYkmxg4ua
         MP+4DlktzKhlqYssJqHXU33RIc6XPPVCpW6bTNZym3TeEsl7ncozUcZwqzVFZCiRhnsi
         35clT21do1BXN9MmJ7eTaMKDsOkn+eLQkiN2IRs11pp/KxbI+ZM2BkjxG+7x7gYxPGMK
         0yRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VvaXS8h0GaowefIXWE0FjHpy7DVmpcp4vpaylD1KB9o=;
        b=bHdEXZGf3rch5I1Jz3JpdaAp/h89vhYBLAs1Qlb+QkV/+/AopL8aea+l8OyEuYDDqb
         /7KkRye45L9ucIiv+Y90f2Pkby+YuEY+EUM1ir+PvkYvaMTy2Eel4D6WnavukCzX74sa
         NuGWcUDb9pgR35MhPLf5ZBko2WD6+i1pZnwvFTmBEqHCi9rs9Cacj9ZnJkG1DDpAUp6X
         zd7zxGPE2DiOiG33bZF+uDpp9WPR1tgIZ1/q2KKo9zIasVNTNAWVYw0+v00jzlVdp2Bp
         q4k2DEr2DiLjxzEaA/rDHwVA5HATn0RiooGifd1xsKv49HTIDUWyqO6IVn2cpu834in/
         sGnw==
X-Gm-Message-State: APjAAAWprLeCpY4UFZT7fIb2pj5SdFg+Rk+y9rMQXY1nITO3Z7PsDPvx
        q5qRqhDtLMv4ThPvNUWUftcjPsExX+z2guVN
X-Google-Smtp-Source: APXvYqybIQlosHW9u676ZojTaui50P0CYNc2MtM3InW/0Ix3c0DlGjPwdAVr7AzQoIMaXmkFfbmDmw==
X-Received: by 2002:a1c:dc07:: with SMTP id t7mr11508946wmg.164.1559655646668;
        Tue, 04 Jun 2019 06:40:46 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id a124sm22944911wmh.3.2019.06.04.06.40.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 06:40:46 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v3 1/8] mlxsw: Move firmware flash implementation to devlink
Date:   Tue,  4 Jun 2019 15:40:37 +0200
Message-Id: <20190604134044.2613-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190604134044.2613-1-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Benefit from the devlink flash update implementation and ethtool
fallback to it and move firmware flash implementation there.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 15 ++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  3 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 49 +++++++++----------
 3 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 182762898361..1c4ef8ed1706 100644
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
index dfe6b44baf63..6f9ca943f50d 100644
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
@@ -3159,31 +3180,6 @@ mlxsw_sp_port_set_link_ksettings(struct net_device *dev,
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
@@ -3224,7 +3220,6 @@ static const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.get_sset_count		= mlxsw_sp_port_get_sset_count,
 	.get_link_ksettings	= mlxsw_sp_port_get_link_ksettings,
 	.set_link_ksettings	= mlxsw_sp_port_set_link_ksettings,
-	.flash_device		= mlxsw_sp_flash_device,
 	.get_module_info	= mlxsw_sp_get_module_info,
 	.get_module_eeprom	= mlxsw_sp_get_module_eeprom,
 };
@@ -4889,6 +4884,7 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.sb_occ_max_clear		= mlxsw_sp_sb_occ_max_clear,
 	.sb_occ_port_pool_get		= mlxsw_sp_sb_occ_port_pool_get,
 	.sb_occ_tc_port_bind_get	= mlxsw_sp_sb_occ_tc_port_bind_get,
+	.flash_update			= mlxsw_sp_flash_update,
 	.txhdr_construct		= mlxsw_sp_txhdr_construct,
 	.resources_register		= mlxsw_sp1_resources_register,
 	.kvd_sizes_get			= mlxsw_sp_kvd_sizes_get,
@@ -4917,6 +4913,7 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.sb_occ_max_clear		= mlxsw_sp_sb_occ_max_clear,
 	.sb_occ_port_pool_get		= mlxsw_sp_sb_occ_port_pool_get,
 	.sb_occ_tc_port_bind_get	= mlxsw_sp_sb_occ_tc_port_bind_get,
+	.flash_update			= mlxsw_sp_flash_update,
 	.txhdr_construct		= mlxsw_sp_txhdr_construct,
 	.resources_register		= mlxsw_sp2_resources_register,
 	.params_register		= mlxsw_sp2_params_register,
-- 
2.17.2

