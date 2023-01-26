Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707AE67C53C
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbjAZH6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235097AbjAZH6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:58:46 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BBC5A810
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:44 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id d4-20020a05600c3ac400b003db1de2aef0so554940wms.2
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZmLSJFpz4kTAU8QIdasxi7xpvJgPXLHfY6RKB1WQ4TA=;
        b=K9IonNFEB5S2HekwVHOWvqgyUDmn37OJSIlzX9Io8tzwHlJfQr5AExVb5sNUSiaB9j
         M0xXxYDzrrLiuuNvj/sctrASnwibMYub2XvmjWDD+lZL7of7PGf4vWsAOmmedYswkFsF
         1zM+FSBbJP60VFBZ7avN8r39dHA+pLCyx3SH8nQamb/yg0SP4giuX36iZs2S4DCFppKI
         b+1eugTpc1uTC6bCRFFizCbhgy4chElUROseh6f4L+Cu8q03BjczxX7P9Z9hYZ6yVRcT
         y5f4U1SuRiPzjU5wGGlcDCDXAvvJv9zjg507WaX9HkSMWDeJ5MLv1e9jn5swXexUOisN
         saEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZmLSJFpz4kTAU8QIdasxi7xpvJgPXLHfY6RKB1WQ4TA=;
        b=BKaUp/E1k8kuWvzKRtbH5bcKOxHs00IikN2nKl4oV+G96YyXuQgkO+GK7y/pto/Tul
         FB4kPN4xKHg7uuSxmqgSorq87DLM6CP83kL5xgnTgTCA7lXW/0PIkXYqCs83NAQRuXAs
         57vFj+y78OdvPWGtjtVj8dTj/eyMfXyHywgP40GNVQxN6dzL8Pt7Nr/xtijwWJA0N9q3
         aeKtKSSal6AJN8QThcZ7+S/6dlnvb6yq9S9HeCIxtODKfzfDstxDbiJj+lheKzDlX6pT
         Byo/4HwYyrhHm6gCVwSCEqurP0QwV/2E3p5zC0m/TJJ17Zn4XRUtk073N0Jz9LjOsGO5
         60Fg==
X-Gm-Message-State: AFqh2kptCgde3p7o8lAxObv3fl9FR2gPoa6P5L70L09Qw1nR2bN9yc/8
        6yoDimmQ8YZ3q7QFDv7oXOBUvQtv40SHSD5cEMogVA==
X-Google-Smtp-Source: AMrXdXu4ueUACweAntt7FyEW4ZzXksBAnvGCxmmZrA1HUfLh2SFzg6WnNEsLnD6rqm495hZb8E4CMA==
X-Received: by 2002:a05:600c:1d85:b0:3db:1bc5:bbe7 with SMTP id p5-20020a05600c1d8500b003db1bc5bbe7mr28141130wms.0.1674719923170;
        Wed, 25 Jan 2023 23:58:43 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ip15-20020a05600ca68f00b003dc0d5b4f75sm679974wmb.43.2023.01.25.23.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 23:58:42 -0800 (PST)
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
Subject: [patch net-next v2 02/12] net/mlx5: Covert devlink params registration to use devlink_params_register/unregister()
Date:   Thu, 26 Jan 2023 08:58:28 +0100
Message-Id: <20230126075838.1643665-3-jiri@resnulli.us>
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

Since mlx5 is the only user of devlink API to register/unregister a
single param, convert it to use array registration function allowing to
simplify the devlink API by removing the single param registration
functions.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 80 +++++++++++--------
 1 file changed, 46 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 91847a3d03a2..2d2fcb518172 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -624,11 +624,12 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 					   value);
 }
 
-static const struct devlink_param enable_eth_param =
+static const struct devlink_param mlx5_devlink_eth_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_ETH, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
-			      NULL, NULL, NULL);
+			      NULL, NULL, NULL),
+};
 
-static int mlx5_devlink_eth_param_register(struct devlink *devlink)
+static int mlx5_devlink_eth_params_register(struct devlink *devlink)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	union devlink_param_value value;
@@ -637,7 +638,8 @@ static int mlx5_devlink_eth_param_register(struct devlink *devlink)
 	if (!mlx5_eth_supported(dev))
 		return 0;
 
-	err = devlink_param_register(devlink, &enable_eth_param);
+	err = devlink_params_register(devlink, mlx5_devlink_eth_params,
+				      ARRAY_SIZE(mlx5_devlink_eth_params));
 	if (err)
 		return err;
 
@@ -648,14 +650,15 @@ static int mlx5_devlink_eth_param_register(struct devlink *devlink)
 	return 0;
 }
 
-static void mlx5_devlink_eth_param_unregister(struct devlink *devlink)
+static void mlx5_devlink_eth_params_unregister(struct devlink *devlink)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
 	if (!mlx5_eth_supported(dev))
 		return;
 
-	devlink_param_unregister(devlink, &enable_eth_param);
+	devlink_params_unregister(devlink, mlx5_devlink_eth_params,
+				  ARRAY_SIZE(mlx5_devlink_eth_params));
 }
 
 static int mlx5_devlink_enable_rdma_validate(struct devlink *devlink, u32 id,
@@ -670,11 +673,12 @@ static int mlx5_devlink_enable_rdma_validate(struct devlink *devlink, u32 id,
 	return 0;
 }
 
-static const struct devlink_param enable_rdma_param =
+static const struct devlink_param mlx5_devlink_rdma_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_RDMA, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
-			      NULL, NULL, mlx5_devlink_enable_rdma_validate);
+			      NULL, NULL, mlx5_devlink_enable_rdma_validate),
+};
 
-static int mlx5_devlink_rdma_param_register(struct devlink *devlink)
+static int mlx5_devlink_rdma_params_register(struct devlink *devlink)
 {
 	union devlink_param_value value;
 	int err;
@@ -682,7 +686,8 @@ static int mlx5_devlink_rdma_param_register(struct devlink *devlink)
 	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
 		return 0;
 
-	err = devlink_param_register(devlink, &enable_rdma_param);
+	err = devlink_params_register(devlink, mlx5_devlink_rdma_params,
+				      ARRAY_SIZE(mlx5_devlink_rdma_params));
 	if (err)
 		return err;
 
@@ -693,19 +698,21 @@ static int mlx5_devlink_rdma_param_register(struct devlink *devlink)
 	return 0;
 }
 
-static void mlx5_devlink_rdma_param_unregister(struct devlink *devlink)
+static void mlx5_devlink_rdma_params_unregister(struct devlink *devlink)
 {
 	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
 		return;
 
-	devlink_param_unregister(devlink, &enable_rdma_param);
+	devlink_params_unregister(devlink, mlx5_devlink_rdma_params,
+				  ARRAY_SIZE(mlx5_devlink_rdma_params));
 }
 
-static const struct devlink_param enable_vnet_param =
+static const struct devlink_param mlx5_devlink_vnet_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_VNET, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
-			      NULL, NULL, NULL);
+			      NULL, NULL, NULL),
+};
 
-static int mlx5_devlink_vnet_param_register(struct devlink *devlink)
+static int mlx5_devlink_vnet_params_register(struct devlink *devlink)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	union devlink_param_value value;
@@ -714,7 +721,8 @@ static int mlx5_devlink_vnet_param_register(struct devlink *devlink)
 	if (!mlx5_vnet_supported(dev))
 		return 0;
 
-	err = devlink_param_register(devlink, &enable_vnet_param);
+	err = devlink_params_register(devlink, mlx5_devlink_vnet_params,
+				      ARRAY_SIZE(mlx5_devlink_vnet_params));
 	if (err)
 		return err;
 
@@ -725,45 +733,46 @@ static int mlx5_devlink_vnet_param_register(struct devlink *devlink)
 	return 0;
 }
 
-static void mlx5_devlink_vnet_param_unregister(struct devlink *devlink)
+static void mlx5_devlink_vnet_params_unregister(struct devlink *devlink)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
 	if (!mlx5_vnet_supported(dev))
 		return;
 
-	devlink_param_unregister(devlink, &enable_vnet_param);
+	devlink_params_unregister(devlink, mlx5_devlink_vnet_params,
+				  ARRAY_SIZE(mlx5_devlink_vnet_params));
 }
 
 static int mlx5_devlink_auxdev_params_register(struct devlink *devlink)
 {
 	int err;
 
-	err = mlx5_devlink_eth_param_register(devlink);
+	err = mlx5_devlink_eth_params_register(devlink);
 	if (err)
 		return err;
 
-	err = mlx5_devlink_rdma_param_register(devlink);
+	err = mlx5_devlink_rdma_params_register(devlink);
 	if (err)
 		goto rdma_err;
 
-	err = mlx5_devlink_vnet_param_register(devlink);
+	err = mlx5_devlink_vnet_params_register(devlink);
 	if (err)
 		goto vnet_err;
 	return 0;
 
 vnet_err:
-	mlx5_devlink_rdma_param_unregister(devlink);
+	mlx5_devlink_rdma_params_unregister(devlink);
 rdma_err:
-	mlx5_devlink_eth_param_unregister(devlink);
+	mlx5_devlink_eth_params_unregister(devlink);
 	return err;
 }
 
 static void mlx5_devlink_auxdev_params_unregister(struct devlink *devlink)
 {
-	mlx5_devlink_vnet_param_unregister(devlink);
-	mlx5_devlink_rdma_param_unregister(devlink);
-	mlx5_devlink_eth_param_unregister(devlink);
+	mlx5_devlink_vnet_params_unregister(devlink);
+	mlx5_devlink_rdma_params_unregister(devlink);
+	mlx5_devlink_eth_params_unregister(devlink);
 }
 
 static int mlx5_devlink_max_uc_list_validate(struct devlink *devlink, u32 id,
@@ -791,11 +800,12 @@ static int mlx5_devlink_max_uc_list_validate(struct devlink *devlink, u32 id,
 	return 0;
 }
 
-static const struct devlink_param max_uc_list_param =
+static const struct devlink_param mlx5_devlink_max_uc_list_params[] = {
 	DEVLINK_PARAM_GENERIC(MAX_MACS, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
-			      NULL, NULL, mlx5_devlink_max_uc_list_validate);
+			      NULL, NULL, mlx5_devlink_max_uc_list_validate),
+};
 
-static int mlx5_devlink_max_uc_list_param_register(struct devlink *devlink)
+static int mlx5_devlink_max_uc_list_params_register(struct devlink *devlink)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	union devlink_param_value value;
@@ -804,7 +814,8 @@ static int mlx5_devlink_max_uc_list_param_register(struct devlink *devlink)
 	if (!MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list_wr_supported))
 		return 0;
 
-	err = devlink_param_register(devlink, &max_uc_list_param);
+	err = devlink_params_register(devlink, mlx5_devlink_max_uc_list_params,
+				      ARRAY_SIZE(mlx5_devlink_max_uc_list_params));
 	if (err)
 		return err;
 
@@ -816,14 +827,15 @@ static int mlx5_devlink_max_uc_list_param_register(struct devlink *devlink)
 }
 
 static void
-mlx5_devlink_max_uc_list_param_unregister(struct devlink *devlink)
+mlx5_devlink_max_uc_list_params_unregister(struct devlink *devlink)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
 	if (!MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list_wr_supported))
 		return;
 
-	devlink_param_unregister(devlink, &max_uc_list_param);
+	devlink_params_unregister(devlink, mlx5_devlink_max_uc_list_params,
+				  ARRAY_SIZE(mlx5_devlink_max_uc_list_params));
 }
 
 #define MLX5_TRAP_DROP(_id, _group_id)					\
@@ -885,7 +897,7 @@ int mlx5_devlink_params_register(struct devlink *devlink)
 	if (err)
 		goto auxdev_reg_err;
 
-	err = mlx5_devlink_max_uc_list_param_register(devlink);
+	err = mlx5_devlink_max_uc_list_params_register(devlink);
 	if (err)
 		goto max_uc_list_err;
 
@@ -904,7 +916,7 @@ int mlx5_devlink_params_register(struct devlink *devlink)
 
 void mlx5_devlink_params_unregister(struct devlink *devlink)
 {
-	mlx5_devlink_max_uc_list_param_unregister(devlink);
+	mlx5_devlink_max_uc_list_params_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
-- 
2.39.0

