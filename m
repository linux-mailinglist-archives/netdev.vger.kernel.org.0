Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B09C67C546
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbjAZH7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236186AbjAZH7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:59:00 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88224677A8
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:57 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id y1so895862wru.2
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8oGCiJkiyf1YHjEjbUt8I5OOPXt9kJ58zh07JDs7V44=;
        b=6avUcF6tvbI9PtckHsYYxRheDqdB4P3lVZ/Y8Ecy/FzJ3FYIwBAj9p0T0UE2BUyV0m
         GN+GhB4H87eV/s6sw131j3EWCNosVcrCVyESU0CNbm1U1ynXuTqS9wvigDvFHIpcqfW6
         qNpK+V/DR3ATgrdVPYmKR4kXKx3GdHiSOFrx7VTyW8Nhnv6y19ajqUktsrXwXwMGU/Bp
         0p8Jr+0UiTWsOgRfwDQLlE5Yq3G+Ue2tdHRTM0lH1D1725PvEhaUv5LWn6NuHftRkJCD
         a5cGfLsiT8gEaf6mYSz1k3d7bKvUYL0Ba0J5Gz2r0gxdQA0FG0RWFFnDb7Cm7xX0ibaI
         0xbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8oGCiJkiyf1YHjEjbUt8I5OOPXt9kJ58zh07JDs7V44=;
        b=4Baat10dFNjhtY53a17bZcITzuFPM7uRgV5KwbHZ741rRuXFHQ83W/kkVo8bnj8HsJ
         1BX4ppwHRgmPXL8l0y7J9s+bP50RuxuNbF0Kbgnxh0ChWnf1JebHEjrI9Hw3Jc6hfmL/
         OfUOPNijPtX1JqUoWdltG/IL2KiToB3+AsII0myaByiUZrJYel8ryLd9emxrhCGmyrJX
         Zl7V4RHNaFKp1WuiMtZSu2GDmNEcCGcFsNRZAg+XBNAG0/eaCHpo14AH8Q8j3wVcMTJL
         qHoEEM+mNwjw1slRiCY/mRWXQlN4qdi/UxmYBpiFsypJmSJjMMfwirysjVQi58YIxGbn
         YG7Q==
X-Gm-Message-State: AFqh2kpjwITknaYXec5ENSE4CKAOz1p3VkIqY59I2n6lBCiPVuyfv9Ao
        bIYCZ2N+0W3m4tZwIKEzNhjL1n8SQLPwCpjytFppWw==
X-Google-Smtp-Source: AMrXdXssd024ucEt/20EPsRJphc1m3OZ0eR6J1R7nS+0uJiNF4KfGOj52P2g57WQ/zJmLTLVQt1YlQ==
X-Received: by 2002:a5d:5b0e:0:b0:2bd:e873:e20c with SMTP id bx14-20020a5d5b0e000000b002bde873e20cmr38567928wrb.70.1674719936038;
        Wed, 25 Jan 2023 23:58:56 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m2-20020a056000180200b002bfb5618ee7sm542547wrh.91.2023.01.25.23.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 23:58:55 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        aelior@marvell.com, manishc@marvell.com, jacob.e.keller@intel.com,
        gal@nvidia.com, yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: [patch net-next v2 10/12] net/mlx5: Move fw reset devlink param to fw reset code
Date:   Thu, 26 Jan 2023 08:58:36 +0100
Message-Id: <20230126075838.1643665-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230126075838.1643665-1-jiri@resnulli.us>
References: <20230126075838.1643665-1-jiri@resnulli.us>
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

Move the param registration and handling code into the fw reset code
as they are related to each other. No point in having the devlink param
registration done in separate file.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 21 ---------
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 44 ++++++++++++++++---
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  2 -
 3 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index ed4b79aeecd1..8bda15dda0d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -541,24 +541,6 @@ static int mlx5_devlink_esw_port_metadata_validate(struct devlink *devlink, u32
 
 #endif
 
-static int mlx5_devlink_enable_remote_dev_reset_set(struct devlink *devlink, u32 id,
-						    struct devlink_param_gset_ctx *ctx)
-{
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-
-	mlx5_fw_reset_enable_remote_dev_reset_set(dev, ctx->val.vbool);
-	return 0;
-}
-
-static int mlx5_devlink_enable_remote_dev_reset_get(struct devlink *devlink, u32 id,
-						    struct devlink_param_gset_ctx *ctx)
-{
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-
-	ctx->val.vbool = mlx5_fw_reset_enable_remote_dev_reset_get(dev);
-	return 0;
-}
-
 static int mlx5_devlink_eq_depth_validate(struct devlink *devlink, u32 id,
 					  union devlink_param_value val,
 					  struct netlink_ext_ack *extack)
@@ -587,9 +569,6 @@ static const struct devlink_param mlx5_devlink_params[] = {
 			     mlx5_devlink_esw_port_metadata_set,
 			     mlx5_devlink_esw_port_metadata_validate),
 #endif
-	DEVLINK_PARAM_GENERIC(ENABLE_REMOTE_DEV_RESET, BIT(DEVLINK_PARAM_CMODE_RUNTIME),
-			      mlx5_devlink_enable_remote_dev_reset_get,
-			      mlx5_devlink_enable_remote_dev_reset_set, NULL),
 	DEVLINK_PARAM_GENERIC(IO_EQ_SIZE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			      NULL, NULL, mlx5_devlink_eq_depth_validate),
 	DEVLINK_PARAM_GENERIC(EVENT_EQ_SIZE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 1e46f9afa40e..1da4da564e6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2020, Mellanox Technologies inc.  All rights reserved. */
 
+#include <devlink.h>
+
 #include "fw_reset.h"
 #include "diag/fw_tracer.h"
 #include "lib/tout.h"
@@ -28,21 +30,32 @@ struct mlx5_fw_reset {
 	int ret;
 };
 
-void mlx5_fw_reset_enable_remote_dev_reset_set(struct mlx5_core_dev *dev, bool enable)
+static int mlx5_fw_reset_enable_remote_dev_reset_set(struct devlink *devlink, u32 id,
+						     struct devlink_param_gset_ctx *ctx)
 {
-	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_fw_reset *fw_reset;
 
-	if (enable)
+	fw_reset = dev->priv.fw_reset;
+
+	if (ctx->val.vbool)
 		clear_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST, &fw_reset->reset_flags);
 	else
 		set_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST, &fw_reset->reset_flags);
+	return 0;
 }
 
-bool mlx5_fw_reset_enable_remote_dev_reset_get(struct mlx5_core_dev *dev)
+static int mlx5_fw_reset_enable_remote_dev_reset_get(struct devlink *devlink, u32 id,
+						     struct devlink_param_gset_ctx *ctx)
 {
-	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_fw_reset *fw_reset;
+
+	fw_reset = dev->priv.fw_reset;
 
-	return !test_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST, &fw_reset->reset_flags);
+	ctx->val.vbool = !test_bit(MLX5_FW_RESET_FLAGS_NACK_RESET_REQUEST,
+				   &fw_reset->reset_flags);
+	return 0;
 }
 
 static int mlx5_reg_mfrl_set(struct mlx5_core_dev *dev, u8 reset_level,
@@ -517,9 +530,16 @@ void mlx5_drain_fw_reset(struct mlx5_core_dev *dev)
 	cancel_work_sync(&fw_reset->reset_abort_work);
 }
 
+static const struct devlink_param mlx5_fw_reset_devlink_params[] = {
+	DEVLINK_PARAM_GENERIC(ENABLE_REMOTE_DEV_RESET, BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      mlx5_fw_reset_enable_remote_dev_reset_get,
+			      mlx5_fw_reset_enable_remote_dev_reset_set, NULL),
+};
+
 int mlx5_fw_reset_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = kzalloc(sizeof(*fw_reset), GFP_KERNEL);
+	int err;
 
 	if (!fw_reset)
 		return -ENOMEM;
@@ -532,6 +552,15 @@ int mlx5_fw_reset_init(struct mlx5_core_dev *dev)
 	fw_reset->dev = dev;
 	dev->priv.fw_reset = fw_reset;
 
+	err = devl_params_register(priv_to_devlink(dev),
+				   mlx5_fw_reset_devlink_params,
+				   ARRAY_SIZE(mlx5_fw_reset_devlink_params));
+	if (err) {
+		destroy_workqueue(fw_reset->wq);
+		kfree(fw_reset);
+		return err;
+	}
+
 	INIT_WORK(&fw_reset->fw_live_patch_work, mlx5_fw_live_patch_event);
 	INIT_WORK(&fw_reset->reset_request_work, mlx5_sync_reset_request_event);
 	INIT_WORK(&fw_reset->reset_reload_work, mlx5_sync_reset_reload_work);
@@ -546,6 +575,9 @@ void mlx5_fw_reset_cleanup(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
 
+	devl_params_unregister(priv_to_devlink(dev),
+			       mlx5_fw_reset_devlink_params,
+			       ARRAY_SIZE(mlx5_fw_reset_devlink_params));
 	destroy_workqueue(fw_reset->wq);
 	kfree(dev->priv.fw_reset);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
index dc141c7e641a..c57465595f7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
@@ -6,8 +6,6 @@
 
 #include "mlx5_core.h"
 
-void mlx5_fw_reset_enable_remote_dev_reset_set(struct mlx5_core_dev *dev, bool enable);
-bool mlx5_fw_reset_enable_remote_dev_reset_get(struct mlx5_core_dev *dev);
 int mlx5_fw_reset_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_type);
 int mlx5_fw_reset_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel,
 				 struct netlink_ext_ack *extack);
-- 
2.39.0

