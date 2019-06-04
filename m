Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCEB3491D
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfFDNkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:40:53 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46246 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfFDNkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:40:51 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so10625286wrw.13
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Mp4uqvyO2LQ97CKCjd4V8BfN+M5DYTzTrVh1LoVRFyI=;
        b=aAWF5h59YO6JLuw9wQ7o3pzLiEFVP0m8phCIpYas8xWZw7aZRYAC46m+X8EbAmBaQo
         mqL/EvB9bxO8GcO7R3HGLt2eJCAl7igNGewo078hKlOZ4hDsNmWSgIdkMYdmgVwvG8qk
         PJxg28BvjBRgvmIq9cYJnnWFsgnKQ2FMSJ5LsvHRGNkDCSvX+Iwisc3nhcy+RtwBvT9W
         YURPA8mmTjQLZ8sPBTIZdrSkMC1EmZ3/u00pBydOdpvmHLHoTOT1zq+9TVaBMv3uYqOu
         agdqQhgloziS5zodYKSfJ4pDoieitInK37bM+PnUXyGVo8+uwKw/OfmT36jd39SAwhNo
         LESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Mp4uqvyO2LQ97CKCjd4V8BfN+M5DYTzTrVh1LoVRFyI=;
        b=LOpiGbuq0jg2AfLooWMhSZUiwxejxTRdWu2MvuaJTmkBYgA+7oLWwMMp1cu120xZ+n
         KW7U0BHlUfQ/ZUIIhbJ7b3lWqwCAWYg4HDY8NMsrxkTvD76hS5AVYJWiBsRvt1voyrfZ
         rUydXGThsvFOUNl0RB5HoEwMRXTTyyMbm+DTnd+d0Aw0Ew8pkbXb/Za7ZXCzPUP2HbZT
         DpT/qqSAVQrtRX1R4Ar36DPuDTDcZUXz3TjSrUteNq9VAokWaSy+JB/fZzRS7y1lRrdB
         2KGuh6kSYrYqh2Vm2gVGF0KhYoIwRa9/BBgIjMCto3tcYKMD2An4qgUTUl7vezGCyBHa
         0C2Q==
X-Gm-Message-State: APjAAAWfd3Q+Ielq65xlhsTZOtFVfaUheLTkGGCBmdCDuUDvtSDVSak3
        7gf+9y/JfG2vf4BQ3OP1NMzXf5wp1YgcdImD
X-Google-Smtp-Source: APXvYqy/9ZQ8yQlc91obHhQtS62FP2A5k3QB5SDKdEirUpLRc3poL7X2NbdxFzNXTJQLlDOYG6Yz8w==
X-Received: by 2002:a5d:4bc8:: with SMTP id l8mr4295919wrt.52.1559655648813;
        Tue, 04 Jun 2019 06:40:48 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id g16sm12496538wmh.33.2019.06.04.06.40.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 06:40:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v3 3/8] mlxfw: Propagate error messages through extack
Date:   Tue,  4 Jun 2019 15:40:39 +0200
Message-Id: <20190604134044.2613-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190604134044.2613-1-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently the error messages are printed to dmesg. Propagate them also
to directly to user doing the flashing through extack.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---
v1->v2:
- dropped "is which" from errmsg.
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
index 2fc2162901de..7ec135eaabc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1230,7 +1230,7 @@ static int mlx5_devlink_flash_update(struct devlink *devlink,
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
index 240c027e5f07..61c32c43a309 100644
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
+		NL_SET_ERR_MSG_MOD(extack, "Component is bigger than limit");
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
index 6f9ca943f50d..2cba678863bd 100644
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

