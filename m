Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C1B67B40A
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbjAYOPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbjAYOPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:15:17 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D1D59555
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:38 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v10so21932391edi.8
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XF8PLt44V3bul06EFFkHl6GCcorJycZ8VARm6CJ82lU=;
        b=pTupbCmeVGxnjBj4kpZHXk7yAd7wUqgqTg2kKN9mSRo0MPI4Vg2FSqzCeEYG6zzJ2w
         McA2Ld1jvbT3QZdmz+RNNLA6KBwfZalk6SHb19ab80Qmsy1ToVWqbZyFMZ8eAdqS+Tbg
         2oXEcSx6LIM6lTT8gbQDqs6aUGYVenQlueHZ6w3vYOVu4MBE7o/c3YYUfxWd30apAssy
         VIe5w0H5i5roV/Ij5iEeI0Vtd/UAUoqkHb5+XS6OLSQPz1/R1u0yyWygAVAd/1f6S7X5
         xBrwpVEckdT7+KNiCnfX0wBdtH3MrzKG+nK6GuuXPz43Z638PnWeiCsoZIewxQ2T9IMd
         1Asg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XF8PLt44V3bul06EFFkHl6GCcorJycZ8VARm6CJ82lU=;
        b=N90QS6IDfTl3MV6Zmi3TvEtRgFiBtfqc1f7VEaP9GWHxgOnIuSubQCC2hfkwvEbmSP
         /3OGThHDrICI7NoP1B1kdXIULgbhKpf4SJIK8LHygDYK7TDpokix9aYG5cROeqOjkMk9
         ikG12E1V2L56SZC1xXoHP66LBrfZyeGCkf1jepEdDspYL2uYiwhoUHmaMox7nVZpi6YS
         U3xFclO7RKI/Kt90KdppDmtIYu0Du1G+sRF18BkHxUQ77/e3hpu6+GbQ10elTrpbJtb/
         x5/KjqaD08GiwVW5c2XgY6gS00asKk1L4BP6xXdPW7iE9uK/mwJFCRqdg9ktGz1LDxMg
         LZRw==
X-Gm-Message-State: AFqh2kolxFKkZWM5Xf3Yz9AK9z3qHPKKNYFrKizwd4tHr+PmUfNfRrgp
        AdrdmfDOgtGKC5auIHDlU389FkEgjjGwrhsQxEY=
X-Google-Smtp-Source: AMrXdXst4EUN/SE0z/JhYcT0NBwESlHrtKyWLLnaPk1uXw0GdFt2uTjQZhPLDfAJW/uiIuyv2HoOjA==
X-Received: by 2002:a05:6402:5110:b0:492:846d:e86d with SMTP id m16-20020a056402511000b00492846de86dmr42200477edd.23.1674656077381;
        Wed, 25 Jan 2023 06:14:37 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id x18-20020a05640226d200b004a087d1d313sm2183643edd.64.2023.01.25.06.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:14:36 -0800 (PST)
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
Subject: [patch net-next 10/12] net/mlx5: Move fw reset devlink param to fw reset code
Date:   Wed, 25 Jan 2023 15:14:10 +0100
Message-Id: <20230125141412.1592256-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230125141412.1592256-1-jiri@resnulli.us>
References: <20230125141412.1592256-1-jiri@resnulli.us>
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

