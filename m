Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554B957FB5E
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiGYIaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbiGYI3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:29:50 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E3E1402C
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:43 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e15so12938333edj.2
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YmkTaxyGJgW7w2SUlYZy6eXzpq02LMHlVzFEacp5HJU=;
        b=0wlV0mIjJb8oI2D9f5zobIJ0JDV+hWB+IMwrzuAXKDc59dWfdfOau7Keyk5LTilv7z
         I6DzmSSzhsBAt7mvdI3x0Da/M1QzJkp41cCPYHxJg3LYHGEoQBOFcFRSXmNa9SGmfQ9t
         SGPByeo4A2ST2otf/+xKvSQWWhxbvbr/JB272MhUdegrIoM4wXO7I/4w7PeXj4iKdyMY
         +xQ3r38tiiYy33G1IcqY88QFs0rRTBBCQ7m3MrRIGT6OYu2DWdo2MM67vHsGcdb8T1QO
         A/lI1QpxULu/Bda01OKxSOdmxuA3WUG3OU1Z3PE5NaVCObNQ0NdeI3HbNApLTMqyKGLe
         7qBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YmkTaxyGJgW7w2SUlYZy6eXzpq02LMHlVzFEacp5HJU=;
        b=eX69YtCpl1Hw/TKm0c2rIRZxHQDtybxqTje+dpxbBgTttCOy88itj+mUIjFjoJuhm1
         ma/pXAw8GzzrPLD9e3rZSNdqfwxS8r97STOrH/XEp4+YW04+nxbm1fKcvIHWSs/HzVlH
         vCEtZs9gt/qHzapLDCqBf8pl6gEBVU4wW9XfPR2WLneoMFmmDmbohda/49Bu1DIztE7u
         xgUNNBV5XZxszrvILlfEWZEZZOrzIL1snDbwDPJHmKh+PFQ/EE3ObzAteaC31hiWU67E
         ZBxe8QPEM3Abb2VY2NE9LOuIqfXvHZZ2oQvXQRffOCmZlBRbu4QUcq2NlKVaQPAWqucL
         ba7A==
X-Gm-Message-State: AJIora/K4lpDTtPTcFGIyQMi3N7RcTQDRCZqoWggL38KXC5+6A8NzF9T
        AI6qejqEjv2KcUmzEltSEhJ5yfQu0X84a64IQZM=
X-Google-Smtp-Source: AGRyM1vxCoLpbZnicn3FHbAW5i8WdOnSan9Gyh4auhKvT/0Qujrc8EXVc8dam0CaIRj32E+GtKgsGw==
X-Received: by 2002:aa7:c9cd:0:b0:43b:247d:bedc with SMTP id i13-20020aa7c9cd000000b0043b247dbedcmr12169390edt.291.1658737782208;
        Mon, 25 Jul 2022 01:29:42 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l10-20020a1709060cca00b006fec56c57f3sm5124271ejh.178.2022.07.25.01.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 01:29:41 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v4 10/12] mlxsw: core_linecards: Implement line card device flashing
Date:   Mon, 25 Jul 2022 10:29:23 +0200
Message-Id: <20220725082925.366455-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725082925.366455-1-jiri@resnulli.us>
References: <20220725082925.366455-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Implement flash_update() devlink op for the line card devlink instance
to allow user to update line card gearbox FW using MDDT register
and mlxfw.

Example:
$ devlink dev flash auxiliary/mlxsw_core.lc.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
v3->v4:
- adjusted extack message
- added Ido's RVB tag
v2->v3:
- fixed the check in mlxsw_linecard_flash_update() to ->active, removed
  WARN_ON() and added extack fill-up.
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  31 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  11 +
 .../mellanox/mlxsw/core_linecard_dev.c        |  13 +
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 278 ++++++++++++++++++
 4 files changed, 323 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 1c8b72faf9e2..a48f893cf7b0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -951,6 +951,20 @@ static struct mlxsw_driver *mlxsw_core_driver_get(const char *kind)
 	return mlxsw_driver;
 }
 
+int mlxsw_core_fw_flash(struct mlxsw_core *mlxsw_core,
+			struct mlxfw_dev *mlxfw_dev,
+			const struct firmware *firmware,
+			struct netlink_ext_ack *extack)
+{
+	int err;
+
+	mlxsw_core->fw_flash_in_progress = true;
+	err = mlxfw_firmware_flash(mlxfw_dev, firmware, extack);
+	mlxsw_core->fw_flash_in_progress = false;
+
+	return err;
+}
+
 struct mlxsw_core_fw_info {
 	struct mlxfw_dev mlxfw_dev;
 	struct mlxsw_core *mlxsw_core;
@@ -1105,8 +1119,9 @@ static const struct mlxfw_dev_ops mlxsw_core_fw_mlxsw_dev_ops = {
 	.fsm_release		= mlxsw_core_fw_fsm_release,
 };
 
-static int mlxsw_core_fw_flash(struct mlxsw_core *mlxsw_core, const struct firmware *firmware,
-			       struct netlink_ext_ack *extack)
+static int mlxsw_core_dev_fw_flash(struct mlxsw_core *mlxsw_core,
+				   const struct firmware *firmware,
+				   struct netlink_ext_ack *extack)
 {
 	struct mlxsw_core_fw_info mlxsw_core_fw_info = {
 		.mlxfw_dev = {
@@ -1117,13 +1132,9 @@ static int mlxsw_core_fw_flash(struct mlxsw_core *mlxsw_core, const struct firmw
 		},
 		.mlxsw_core = mlxsw_core
 	};
-	int err;
 
-	mlxsw_core->fw_flash_in_progress = true;
-	err = mlxfw_firmware_flash(&mlxsw_core_fw_info.mlxfw_dev, firmware, extack);
-	mlxsw_core->fw_flash_in_progress = false;
-
-	return err;
+	return mlxsw_core_fw_flash(mlxsw_core, &mlxsw_core_fw_info.mlxfw_dev,
+				   firmware, extack);
 }
 
 static int mlxsw_core_fw_rev_validate(struct mlxsw_core *mlxsw_core,
@@ -1169,7 +1180,7 @@ static int mlxsw_core_fw_rev_validate(struct mlxsw_core *mlxsw_core,
 		return err;
 	}
 
-	err = mlxsw_core_fw_flash(mlxsw_core, firmware, NULL);
+	err = mlxsw_core_dev_fw_flash(mlxsw_core, firmware, NULL);
 	release_firmware(firmware);
 	if (err)
 		dev_err(mlxsw_bus_info->dev, "Could not upgrade firmware\n");
@@ -1187,7 +1198,7 @@ static int mlxsw_core_fw_flash_update(struct mlxsw_core *mlxsw_core,
 				      struct devlink_flash_update_params *params,
 				      struct netlink_ext_ack *extack)
 {
-	return mlxsw_core_fw_flash(mlxsw_core, params->fw, extack);
+	return mlxsw_core_dev_fw_flash(mlxsw_core, params->fw, extack);
 }
 
 static int mlxsw_core_devlink_param_fw_load_policy_validate(struct devlink *devlink, u32 id,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index a3246082219d..39c4a139188f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -19,6 +19,7 @@
 #include "reg.h"
 #include "cmd.h"
 #include "resources.h"
+#include "../mlxfw/mlxfw.h"
 
 enum mlxsw_core_resource_id {
 	MLXSW_CORE_RESOURCE_PORTS = 1,
@@ -48,6 +49,11 @@ mlxsw_core_fw_rev_minor_subminor_validate(const struct mlxsw_fw_rev *rev,
 int mlxsw_core_driver_register(struct mlxsw_driver *mlxsw_driver);
 void mlxsw_core_driver_unregister(struct mlxsw_driver *mlxsw_driver);
 
+int mlxsw_core_fw_flash(struct mlxsw_core *mlxsw_core,
+			struct mlxfw_dev *mlxfw_dev,
+			const struct firmware *firmware,
+			struct netlink_ext_ack *extack);
+
 int mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 				   const struct mlxsw_bus *mlxsw_bus,
 				   void *bus_priv, bool reload,
@@ -588,6 +594,7 @@ struct mlxsw_linecard {
 	struct mlxsw_linecard_bdev *bdev;
 	struct {
 		struct mlxsw_linecard_device_info info;
+		u8 index;
 	} device;
 };
 
@@ -612,6 +619,10 @@ mlxsw_linecard_get(struct mlxsw_linecards *linecards, u8 slot_index)
 int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
 				    struct devlink_info_req *req,
 				    struct netlink_ext_ack *extack);
+int mlxsw_linecard_flash_update(struct devlink *linecard_devlink,
+				struct mlxsw_linecard *linecard,
+				const struct firmware *firmware,
+				struct netlink_ext_ack *extack);
 
 int mlxsw_linecards_init(struct mlxsw_core *mlxsw_core,
 			 const struct mlxsw_bus_info *bus_info);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
index 13c20b83b190..49fee038a99c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
@@ -108,8 +108,21 @@ static int mlxsw_linecard_dev_devlink_info_get(struct devlink *devlink,
 	return mlxsw_linecard_devlink_info_get(linecard, req, extack);
 }
 
+static int
+mlxsw_linecard_dev_devlink_flash_update(struct devlink *devlink,
+					struct devlink_flash_update_params *params,
+					struct netlink_ext_ack *extack)
+{
+	struct mlxsw_linecard_dev *linecard_dev = devlink_priv(devlink);
+	struct mlxsw_linecard *linecard = linecard_dev->linecard;
+
+	return mlxsw_linecard_flash_update(devlink, linecard,
+					   params->fw, extack);
+}
+
 static const struct devlink_ops mlxsw_linecard_dev_devlink_ops = {
 	.info_get			= mlxsw_linecard_dev_devlink_info_get,
+	.flash_update			= mlxsw_linecard_dev_devlink_flash_update,
 };
 
 static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 771a3e43b8bb..ca59f0b946da 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -13,6 +13,7 @@
 #include <linux/vmalloc.h>
 
 #include "core.h"
+#include "../mlxfw/mlxfw.h"
 
 struct mlxsw_linecard_ini_file {
 	__le16 size;
@@ -87,6 +88,282 @@ static const char *mlxsw_linecard_type_name(struct mlxsw_linecard *linecard)
 	return linecard->name;
 }
 
+struct mlxsw_linecard_device_fw_info {
+	struct mlxfw_dev mlxfw_dev;
+	struct mlxsw_core *mlxsw_core;
+	struct mlxsw_linecard *linecard;
+};
+
+static int mlxsw_linecard_device_fw_component_query(struct mlxfw_dev *mlxfw_dev,
+						    u16 component_index,
+						    u32 *p_max_size,
+						    u8 *p_align_bits,
+						    u16 *p_max_write_size)
+{
+	struct mlxsw_linecard_device_fw_info *info =
+		container_of(mlxfw_dev, struct mlxsw_linecard_device_fw_info,
+			     mlxfw_dev);
+	struct mlxsw_linecard *linecard = info->linecard;
+	struct mlxsw_core *mlxsw_core = info->mlxsw_core;
+	char mddt_pl[MLXSW_REG_MDDT_LEN];
+	char *mcqi_pl;
+	int err;
+
+	mlxsw_reg_mddt_pack(mddt_pl, linecard->slot_index,
+			    linecard->device.index,
+			    MLXSW_REG_MDDT_METHOD_QUERY,
+			    MLXSW_REG(mcqi), &mcqi_pl);
+
+	mlxsw_reg_mcqi_pack(mcqi_pl, component_index);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mddt), mddt_pl);
+	if (err)
+		return err;
+	mlxsw_reg_mcqi_unpack(mcqi_pl, p_max_size, p_align_bits,
+			      p_max_write_size);
+
+	*p_align_bits = max_t(u8, *p_align_bits, 2);
+	*p_max_write_size = min_t(u16, *p_max_write_size,
+				  MLXSW_REG_MCDA_MAX_DATA_LEN);
+	return 0;
+}
+
+static int mlxsw_linecard_device_fw_fsm_lock(struct mlxfw_dev *mlxfw_dev,
+					     u32 *fwhandle)
+{
+	struct mlxsw_linecard_device_fw_info *info =
+		container_of(mlxfw_dev, struct mlxsw_linecard_device_fw_info,
+			     mlxfw_dev);
+	struct mlxsw_linecard *linecard = info->linecard;
+	struct mlxsw_core *mlxsw_core = info->mlxsw_core;
+	char mddt_pl[MLXSW_REG_MDDT_LEN];
+	u8 control_state;
+	char *mcc_pl;
+	int err;
+
+	mlxsw_reg_mddt_pack(mddt_pl, linecard->slot_index,
+			    linecard->device.index,
+			    MLXSW_REG_MDDT_METHOD_QUERY,
+			    MLXSW_REG(mcc), &mcc_pl);
+	mlxsw_reg_mcc_pack(mcc_pl, 0, 0, 0, 0);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mddt), mddt_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mcc_unpack(mcc_pl, fwhandle, NULL, &control_state);
+	if (control_state != MLXFW_FSM_STATE_IDLE)
+		return -EBUSY;
+
+	mlxsw_reg_mddt_pack(mddt_pl, linecard->slot_index,
+			    linecard->device.index,
+			    MLXSW_REG_MDDT_METHOD_WRITE,
+			    MLXSW_REG(mcc), &mcc_pl);
+	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_LOCK_UPDATE_HANDLE,
+			   0, *fwhandle, 0);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mddt), mddt_pl);
+}
+
+static int
+mlxsw_linecard_device_fw_fsm_component_update(struct mlxfw_dev *mlxfw_dev,
+					      u32 fwhandle,
+					      u16 component_index,
+					      u32 component_size)
+{
+	struct mlxsw_linecard_device_fw_info *info =
+		container_of(mlxfw_dev, struct mlxsw_linecard_device_fw_info,
+			     mlxfw_dev);
+	struct mlxsw_linecard *linecard = info->linecard;
+	struct mlxsw_core *mlxsw_core = info->mlxsw_core;
+	char mddt_pl[MLXSW_REG_MDDT_LEN];
+	char *mcc_pl;
+
+	mlxsw_reg_mddt_pack(mddt_pl, linecard->slot_index,
+			    linecard->device.index,
+			    MLXSW_REG_MDDT_METHOD_WRITE,
+			    MLXSW_REG(mcc), &mcc_pl);
+	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_UPDATE_COMPONENT,
+			   component_index, fwhandle, component_size);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mddt), mddt_pl);
+}
+
+static int
+mlxsw_linecard_device_fw_fsm_block_download(struct mlxfw_dev *mlxfw_dev,
+					    u32 fwhandle, u8 *data,
+					    u16 size, u32 offset)
+{
+	struct mlxsw_linecard_device_fw_info *info =
+		container_of(mlxfw_dev, struct mlxsw_linecard_device_fw_info,
+			     mlxfw_dev);
+	struct mlxsw_linecard *linecard = info->linecard;
+	struct mlxsw_core *mlxsw_core = info->mlxsw_core;
+	char mddt_pl[MLXSW_REG_MDDT_LEN];
+	char *mcda_pl;
+
+	mlxsw_reg_mddt_pack(mddt_pl, linecard->slot_index,
+			    linecard->device.index,
+			    MLXSW_REG_MDDT_METHOD_WRITE,
+			    MLXSW_REG(mcda), &mcda_pl);
+	mlxsw_reg_mcda_pack(mcda_pl, fwhandle, offset, size, data);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mddt), mddt_pl);
+}
+
+static int
+mlxsw_linecard_device_fw_fsm_component_verify(struct mlxfw_dev *mlxfw_dev,
+					      u32 fwhandle, u16 component_index)
+{
+	struct mlxsw_linecard_device_fw_info *info =
+		container_of(mlxfw_dev, struct mlxsw_linecard_device_fw_info,
+			     mlxfw_dev);
+	struct mlxsw_linecard *linecard = info->linecard;
+	struct mlxsw_core *mlxsw_core = info->mlxsw_core;
+	char mddt_pl[MLXSW_REG_MDDT_LEN];
+	char *mcc_pl;
+
+	mlxsw_reg_mddt_pack(mddt_pl, linecard->slot_index,
+			    linecard->device.index,
+			    MLXSW_REG_MDDT_METHOD_WRITE,
+			    MLXSW_REG(mcc), &mcc_pl);
+	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_VERIFY_COMPONENT,
+			   component_index, fwhandle, 0);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mddt), mddt_pl);
+}
+
+static int mlxsw_linecard_device_fw_fsm_activate(struct mlxfw_dev *mlxfw_dev,
+						 u32 fwhandle)
+{
+	struct mlxsw_linecard_device_fw_info *info =
+		container_of(mlxfw_dev, struct mlxsw_linecard_device_fw_info,
+			     mlxfw_dev);
+	struct mlxsw_linecard *linecard = info->linecard;
+	struct mlxsw_core *mlxsw_core = info->mlxsw_core;
+	char mddt_pl[MLXSW_REG_MDDT_LEN];
+	char *mcc_pl;
+
+	mlxsw_reg_mddt_pack(mddt_pl, linecard->slot_index,
+			    linecard->device.index,
+			    MLXSW_REG_MDDT_METHOD_WRITE,
+			    MLXSW_REG(mcc), &mcc_pl);
+	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_ACTIVATE,
+			   0, fwhandle, 0);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mddt), mddt_pl);
+}
+
+static int
+mlxsw_linecard_device_fw_fsm_query_state(struct mlxfw_dev *mlxfw_dev,
+					 u32 fwhandle,
+					 enum mlxfw_fsm_state *fsm_state,
+					 enum mlxfw_fsm_state_err *fsm_state_err)
+{
+	struct mlxsw_linecard_device_fw_info *info =
+		container_of(mlxfw_dev, struct mlxsw_linecard_device_fw_info,
+			     mlxfw_dev);
+	struct mlxsw_linecard *linecard = info->linecard;
+	struct mlxsw_core *mlxsw_core = info->mlxsw_core;
+	char mddt_pl[MLXSW_REG_MDDT_LEN];
+	u8 control_state;
+	u8 error_code;
+	char *mcc_pl;
+	int err;
+
+	mlxsw_reg_mddt_pack(mddt_pl, linecard->slot_index,
+			    linecard->device.index,
+			    MLXSW_REG_MDDT_METHOD_QUERY,
+			    MLXSW_REG(mcc), &mcc_pl);
+	mlxsw_reg_mcc_pack(mcc_pl, 0, 0, fwhandle, 0);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mddt), mddt_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mcc_unpack(mcc_pl, NULL, &error_code, &control_state);
+	*fsm_state = control_state;
+	*fsm_state_err = min_t(enum mlxfw_fsm_state_err, error_code,
+			       MLXFW_FSM_STATE_ERR_MAX);
+	return 0;
+}
+
+static void mlxsw_linecard_device_fw_fsm_cancel(struct mlxfw_dev *mlxfw_dev,
+						u32 fwhandle)
+{
+	struct mlxsw_linecard_device_fw_info *info =
+		container_of(mlxfw_dev, struct mlxsw_linecard_device_fw_info,
+			     mlxfw_dev);
+	struct mlxsw_linecard *linecard = info->linecard;
+	struct mlxsw_core *mlxsw_core = info->mlxsw_core;
+	char mddt_pl[MLXSW_REG_MDDT_LEN];
+	char *mcc_pl;
+
+	mlxsw_reg_mddt_pack(mddt_pl, linecard->slot_index,
+			    linecard->device.index,
+			    MLXSW_REG_MDDT_METHOD_WRITE,
+			    MLXSW_REG(mcc), &mcc_pl);
+	mlxsw_reg_mcc_pack(mcc_pl, MLXSW_REG_MCC_INSTRUCTION_CANCEL,
+			   0, fwhandle, 0);
+	mlxsw_reg_write(mlxsw_core, MLXSW_REG(mddt), mddt_pl);
+}
+
+static void mlxsw_linecard_device_fw_fsm_release(struct mlxfw_dev *mlxfw_dev,
+						 u32 fwhandle)
+{
+	struct mlxsw_linecard_device_fw_info *info =
+		container_of(mlxfw_dev, struct mlxsw_linecard_device_fw_info,
+			     mlxfw_dev);
+	struct mlxsw_linecard *linecard = info->linecard;
+	struct mlxsw_core *mlxsw_core = info->mlxsw_core;
+	char mddt_pl[MLXSW_REG_MDDT_LEN];
+	char *mcc_pl;
+
+	mlxsw_reg_mddt_pack(mddt_pl, linecard->slot_index,
+			    linecard->device.index,
+			    MLXSW_REG_MDDT_METHOD_WRITE,
+			    MLXSW_REG(mcc), &mcc_pl);
+	mlxsw_reg_mcc_pack(mcc_pl,
+			   MLXSW_REG_MCC_INSTRUCTION_RELEASE_UPDATE_HANDLE,
+			   0, fwhandle, 0);
+	mlxsw_reg_write(mlxsw_core, MLXSW_REG(mddt), mddt_pl);
+}
+
+static const struct mlxfw_dev_ops mlxsw_linecard_device_dev_ops = {
+	.component_query	= mlxsw_linecard_device_fw_component_query,
+	.fsm_lock		= mlxsw_linecard_device_fw_fsm_lock,
+	.fsm_component_update	= mlxsw_linecard_device_fw_fsm_component_update,
+	.fsm_block_download	= mlxsw_linecard_device_fw_fsm_block_download,
+	.fsm_component_verify	= mlxsw_linecard_device_fw_fsm_component_verify,
+	.fsm_activate		= mlxsw_linecard_device_fw_fsm_activate,
+	.fsm_query_state	= mlxsw_linecard_device_fw_fsm_query_state,
+	.fsm_cancel		= mlxsw_linecard_device_fw_fsm_cancel,
+	.fsm_release		= mlxsw_linecard_device_fw_fsm_release,
+};
+
+int mlxsw_linecard_flash_update(struct devlink *linecard_devlink,
+				struct mlxsw_linecard *linecard,
+				const struct firmware *firmware,
+				struct netlink_ext_ack *extack)
+{
+	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
+	struct mlxsw_linecard_device_fw_info info = {
+		.mlxfw_dev = {
+			.ops = &mlxsw_linecard_device_dev_ops,
+			.psid = linecard->device.info.psid,
+			.psid_size = strlen(linecard->device.info.psid),
+			.devlink = linecard_devlink,
+		},
+		.mlxsw_core = mlxsw_core,
+		.linecard = linecard,
+	};
+	int err;
+
+	mutex_lock(&linecard->lock);
+	if (!linecard->active) {
+		NL_SET_ERR_MSG_MOD(extack, "Only active line cards can be flashed");
+		err = -EINVAL;
+		goto unlock;
+	}
+	err = mlxsw_core_fw_flash(mlxsw_core, &info.mlxfw_dev,
+				  firmware, extack);
+unlock:
+	mutex_unlock(&linecard->lock);
+	return err;
+}
+
 static int mlxsw_linecard_device_psid_get(struct mlxsw_linecard *linecard,
 					  u8 device_index, char *psid)
 {
@@ -149,6 +426,7 @@ static int mlxsw_linecard_device_info_update(struct mlxsw_linecard *linecard)
 			return err;
 
 		linecard->device.info = info;
+		linecard->device.index = device_index;
 		flashable_found = true;
 	} while (msg_seq);
 
-- 
2.35.3

