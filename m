Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26C7F27998
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbfEWJpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:45:17 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32827 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730028AbfEWJpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:45:17 -0400
Received: by mail-wr1-f65.google.com with SMTP id d9so5529276wrx.0
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 02:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2/e8axWKjygMbyUrYbxubONd/CcJTWIZU7ookVM8+44=;
        b=gLemNv8slmi3yO3ld08TWFgZ01EO1162OB+2jAg+6HrH6VVfTL7YQaCr1kuaS5svwr
         xQYSGhTTIu8mPrK1U2AtdT6u5G41J7F22v9QHCIKGgwO7ss+EF/vvmVtAoHNEG6T0kg7
         jirASeSaWc78YIkblWMP3oMlaEBmK7ld6hQowC0pSovYTf7nFxHWRBKcHl449ctZIs4Y
         6lqCiQBfAqxxHWCF3kxxpExedFqoXBMmVV/qjLsWJFj32ghdZBes+cUejM8e8HDhD2LD
         biaU6Kc2ku7NGPlN5efyvT2o16DGZf/dlyksEdx11I6/X1dpeRP/8PvCxdzPprpGXktQ
         uvmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2/e8axWKjygMbyUrYbxubONd/CcJTWIZU7ookVM8+44=;
        b=VEfMJoxieC681cr3y+60hNRdZuKbOKeTpZRMOjzaDwnPQFGdvLpY5ljwu+E3MHOsgz
         w5zPxpnpkM/fReEwaUtnyOZq29q35/R5CywCLnFtxAVN/0bX1x1S+RjkMcmNJdTg33fj
         QGndg5p1J9mYa69ZQ2edr9S80kiDXkxnKgs3ARounfoejpyTzWENxIXXH0dXMdS6MUzw
         4QuSvk9iTO+Rfskm5A8d/Ln69t+b4aFdXGuYXMtW1bgZzijQCeP0sFmN75UdiopzH4B/
         iMvERQXWcVrijSXXzROzh7j84OejW8LorNx1iM+SJkY3yzut0XwjLXFfoX40nFk+2PJk
         X39g==
X-Gm-Message-State: APjAAAUI4ao7PoDyAkzZCGnIAaSPPTUU784Fc8IHqRi6naUhwxwIclkX
        VijuPNWkExAghXvsBtnJiJ5ik9Sp/vA=
X-Google-Smtp-Source: APXvYqzqsEaOJADgSgYl53qdjK7etF6wU3AQgWTFqMCnPLX7gB932ABZiFGtftMrOPA1O7UdHqFISA==
X-Received: by 2002:adf:eb89:: with SMTP id t9mr56361332wrn.109.1558604714822;
        Thu, 23 May 2019 02:45:14 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id f10sm39489303wrg.24.2019.05.23.02.45.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 02:45:14 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org
Subject: [patch net-next 3/7] mlxfw: Propagate error messages through extack
Date:   Thu, 23 May 2019 11:45:06 +0200
Message-Id: <20190523094510.2317-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190523094510.2317-1-jiri@resnulli.us>
References: <20190523094510.2317-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently the error messages are printed to dmesg. Propagate them also
to directly to user doing the flashing through extack.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |  6 ++--
 .../net/ethernet/mellanox/mlx5/core/main.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  3 +-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |  7 ++--
 .../net/ethernet/mellanox/mlxfw/mlxfw_fsm.c   | 33 +++++++++++++------
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 10 +++---
 6 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 1ab6f7e3bec6..e8fedb307b2c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -552,7 +552,8 @@ static const struct mlxfw_dev_ops mlx5_mlxfw_dev_ops = {
 };
 
 int mlx5_firmware_flash(struct mlx5_core_dev *dev,
-			const struct firmware *firmware)
+			const struct firmware *firmware,
+			struct netlink_ext_ack *extack)
 {
 	struct mlx5_mlxfw_dev mlx5_mlxfw_dev = {
 		.mlxfw_dev = {
@@ -571,5 +572,6 @@ int mlx5_firmware_flash(struct mlx5_core_dev *dev,
 		return -EOPNOTSUPP;
 	}
 
-	return mlxfw_firmware_flash(&mlx5_mlxfw_dev.mlxfw_dev, firmware);
+	return mlxfw_firmware_flash(&mlx5_mlxfw_dev.mlxfw_dev,
+				    firmware, extack);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 36acd0267a13..52fcfc17fcc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1226,7 +1226,7 @@ static int mlx5_devlink_flash_update(struct devlink *devlink,
 	if (err)
 		return err;
 
-	return mlx5_firmware_flash(dev, fw);
+	return mlx5_firmware_flash(dev, fw, extack);
 }
 
 static const struct devlink_ops mlx5_devlink_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 22e69d4813e4..d4dd8c1ae55c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -184,7 +184,8 @@ int mlx5_set_mtppse(struct mlx5_core_dev *mdev, u8 pin, u8 arm, u8 mode);
 			    MLX5_CAP_MCAM_FEATURE((mdev), mtpps_fs) &&	\
 			    MLX5_CAP_MCAM_FEATURE((mdev), mtpps_enh_out_per_adj))
 
-int mlx5_firmware_flash(struct mlx5_core_dev *dev, const struct firmware *fw);
+int mlx5_firmware_flash(struct mlx5_core_dev *dev, const struct firmware *fw,
+			struct netlink_ext_ack *extack);
 
 void mlx5e_init(void);
 void mlx5e_cleanup(void);
diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h b/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
index 14c0c62f8e73..83286b90593f 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw.h
@@ -5,6 +5,7 @@
 #define _MLXFW_H
 
 #include <linux/firmware.h>
+#include <linux/netlink.h>
 
 enum mlxfw_fsm_state {
 	MLXFW_FSM_STATE_IDLE,
@@ -67,11 +68,13 @@ struct mlxfw_dev {
 
 #if IS_REACHABLE(CONFIG_MLXFW)
 int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
-			 const struct firmware *firmware);
+			 const struct firmware *firmware,
+			 struct netlink_ext_ack *extack);
 #else
 static inline
 int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
-			 const struct firmware *firmware)
+			 const struct firmware *firmware,
+			 struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
index 240c027e5f07..588d9a9c08c9 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c
@@ -40,7 +40,8 @@ static const char * const mlxfw_fsm_state_err_str[] = {
 };
 
 static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
-				enum mlxfw_fsm_state fsm_state)
+				enum mlxfw_fsm_state fsm_state,
+				struct netlink_ext_ack *extack)
 {
 	enum mlxfw_fsm_state_err fsm_state_err;
 	enum mlxfw_fsm_state curr_fsm_state;
@@ -57,11 +58,13 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
 	if (fsm_state_err != MLXFW_FSM_STATE_ERR_OK) {
 		pr_err("Firmware flash failed: %s\n",
 		       mlxfw_fsm_state_err_str[fsm_state_err]);
+		NL_SET_ERR_MSG_MOD(extack, "Firmware flash failed");
 		return -EINVAL;
 	}
 	if (curr_fsm_state != fsm_state) {
 		if (--times == 0) {
 			pr_err("Timeout reached on FSM state change");
+			NL_SET_ERR_MSG_MOD(extack, "Timeout reached on FSM state change");
 			return -ETIMEDOUT;
 		}
 		msleep(MLXFW_FSM_STATE_WAIT_CYCLE_MS);
@@ -76,7 +79,8 @@ static int mlxfw_fsm_state_wait(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
 
 static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
 				 u32 fwhandle,
-				 struct mlxfw_mfa2_component *comp)
+				 struct mlxfw_mfa2_component *comp,
+				 struct netlink_ext_ack *extack)
 {
 	u16 comp_max_write_size;
 	u8 comp_align_bits;
@@ -96,6 +100,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
 	if (comp->data_size > comp_max_size) {
 		pr_err("Component %d is of size %d which is bigger than limit %d\n",
 		       comp->index, comp->data_size, comp_max_size);
+		NL_SET_ERR_MSG_MOD(extack, "Component is which is bigger than limit");
 		return -EINVAL;
 	}
 
@@ -110,7 +115,7 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
 		return err;
 
 	err = mlxfw_fsm_state_wait(mlxfw_dev, fwhandle,
-				   MLXFW_FSM_STATE_DOWNLOAD);
+				   MLXFW_FSM_STATE_DOWNLOAD, extack);
 	if (err)
 		goto err_out;
 
@@ -134,7 +139,8 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
 	if (err)
 		goto err_out;
 
-	err = mlxfw_fsm_state_wait(mlxfw_dev, fwhandle, MLXFW_FSM_STATE_LOCKED);
+	err = mlxfw_fsm_state_wait(mlxfw_dev, fwhandle,
+				   MLXFW_FSM_STATE_LOCKED, extack);
 	if (err)
 		goto err_out;
 	return 0;
@@ -145,7 +151,8 @@ static int mlxfw_flash_component(struct mlxfw_dev *mlxfw_dev,
 }
 
 static int mlxfw_flash_components(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
-				  struct mlxfw_mfa2_file *mfa2_file)
+				  struct mlxfw_mfa2_file *mfa2_file,
+				  struct netlink_ext_ack *extack)
 {
 	u32 component_count;
 	int err;
@@ -156,6 +163,7 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
 					      &component_count);
 	if (err) {
 		pr_err("Could not find device PSID in MFA2 file\n");
+		NL_SET_ERR_MSG_MOD(extack, "Could not find device PSID in MFA2 file");
 		return err;
 	}
 
@@ -168,7 +176,7 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
 			return PTR_ERR(comp);
 
 		pr_info("Flashing component type %d\n", comp->index);
-		err = mlxfw_flash_component(mlxfw_dev, fwhandle, comp);
+		err = mlxfw_flash_component(mlxfw_dev, fwhandle, comp, extack);
 		mlxfw_mfa2_file_component_put(comp);
 		if (err)
 			return err;
@@ -177,7 +185,8 @@ static int mlxfw_flash_components(struct mlxfw_dev *mlxfw_dev, u32 fwhandle,
 }
 
 int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
-			 const struct firmware *firmware)
+			 const struct firmware *firmware,
+			 struct netlink_ext_ack *extack)
 {
 	struct mlxfw_mfa2_file *mfa2_file;
 	u32 fwhandle;
@@ -185,6 +194,7 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 
 	if (!mlxfw_mfa2_check(firmware)) {
 		pr_err("Firmware file is not MFA2\n");
+		NL_SET_ERR_MSG_MOD(extack, "Firmware file is not MFA2");
 		return -EINVAL;
 	}
 
@@ -196,15 +206,16 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	err = mlxfw_dev->ops->fsm_lock(mlxfw_dev, &fwhandle);
 	if (err) {
 		pr_err("Could not lock the firmware FSM\n");
+		NL_SET_ERR_MSG_MOD(extack, "Could not lock the firmware FSM");
 		goto err_fsm_lock;
 	}
 
 	err = mlxfw_fsm_state_wait(mlxfw_dev, fwhandle,
-				   MLXFW_FSM_STATE_LOCKED);
+				   MLXFW_FSM_STATE_LOCKED, extack);
 	if (err)
 		goto err_state_wait_idle_to_locked;
 
-	err = mlxfw_flash_components(mlxfw_dev, fwhandle, mfa2_file);
+	err = mlxfw_flash_components(mlxfw_dev, fwhandle, mfa2_file, extack);
 	if (err)
 		goto err_flash_components;
 
@@ -212,10 +223,12 @@ int mlxfw_firmware_flash(struct mlxfw_dev *mlxfw_dev,
 	err = mlxfw_dev->ops->fsm_activate(mlxfw_dev, fwhandle);
 	if (err) {
 		pr_err("Could not activate the downloaded image\n");
+		NL_SET_ERR_MSG_MOD(extack, "Could not activate the downloaded image");
 		goto err_fsm_activate;
 	}
 
-	err = mlxfw_fsm_state_wait(mlxfw_dev, fwhandle, MLXFW_FSM_STATE_LOCKED);
+	err = mlxfw_fsm_state_wait(mlxfw_dev, fwhandle,
+				   MLXFW_FSM_STATE_LOCKED, extack);
 	if (err)
 		goto err_state_wait_activate_to_locked;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 861a77538859..639bb5778ff3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -307,7 +307,8 @@ static const struct mlxfw_dev_ops mlxsw_sp_mlxfw_dev_ops = {
 };
 
 static int mlxsw_sp_firmware_flash(struct mlxsw_sp *mlxsw_sp,
-				   const struct firmware *firmware)
+				   const struct firmware *firmware,
+				   struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_mlxfw_dev mlxsw_sp_mlxfw_dev = {
 		.mlxfw_dev = {
@@ -320,7 +321,8 @@ static int mlxsw_sp_firmware_flash(struct mlxsw_sp *mlxsw_sp,
 	int err;
 
 	mlxsw_core_fw_flash_start(mlxsw_sp->core);
-	err = mlxfw_firmware_flash(&mlxsw_sp_mlxfw_dev.mlxfw_dev, firmware);
+	err = mlxfw_firmware_flash(&mlxsw_sp_mlxfw_dev.mlxfw_dev,
+				   firmware, extack);
 	mlxsw_core_fw_flash_end(mlxsw_sp->core);
 
 	return err;
@@ -374,7 +376,7 @@ static int mlxsw_sp_fw_rev_validate(struct mlxsw_sp *mlxsw_sp)
 		return err;
 	}
 
-	err = mlxsw_sp_firmware_flash(mlxsw_sp, firmware);
+	err = mlxsw_sp_firmware_flash(mlxsw_sp, firmware, NULL);
 	release_firmware(firmware);
 	if (err)
 		dev_err(mlxsw_sp->bus_info->dev, "Could not upgrade firmware\n");
@@ -403,7 +405,7 @@ static int mlxsw_sp_flash_update(struct mlxsw_core *mlxsw_core,
 				      mlxsw_sp->bus_info->dev);
 	if (err)
 		return err;
-	err = mlxsw_sp_firmware_flash(mlxsw_sp, firmware);
+	err = mlxsw_sp_firmware_flash(mlxsw_sp, firmware, extack);
 	release_firmware(firmware);
 
 	return err;
-- 
2.17.2

