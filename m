Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F9C67B409
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbjAYOPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235618AbjAYOPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:15:12 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124A95954D
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:36 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id os24so4252516ejb.8
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6P9maehnumfQOyiFOvto4nCVqmuXdTGuqCJnAXkG/0=;
        b=jti5/DXsFzsi6jTN+iXNLvxb548EZcDcC4l2ZHwQIXJT8zHv27J2cbvVPcqWqkKm8t
         2xhgeE2wYdymXSxUQLeS/njnFETobAtDaTGy2PE029q48BEoXyBCVvD/DilRB5kGVENV
         g9t6Vdcfri0teHdXkucE48irEBBmK2HZOIFQRK/JTyfy31Uh6LGowu4nucKoY0XXwBHL
         qsk7Wi9K59d2znPsWgpQ6ZAtuY36TsWx4y32gO5SHKwvZz8mhi0OIrQWCa9fnlSvJVdz
         jmpqSlbY95flS8+3nBLSH0AJFtdwu1lkgjJ6NJrpGQndBXbS9jPfxRvM/RhCHSR/9fKV
         VNaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l6P9maehnumfQOyiFOvto4nCVqmuXdTGuqCJnAXkG/0=;
        b=yEffHJ4OTGPveqMKEe5MznlmNGTIdoxp/UDPDgNkD0km24mLFMnL4hT313dmacOy+3
         miMBbrqhQT9dqspTtdxWrXObpdM5yx9zNXHaC/AZ325MUO3EX0u/w0c7rw3tnm+2lTDd
         a2Ua/bMGWKKLyjw8aJugo0I5FXFMKx8jllW8MJN+AEDtmhsRS8S+cFY/KnBgAc9Zm9Si
         0+dPuzcCKHfo2eB9NY5cuQL1kcTZCDoTJWJNf1PbXYBPJ2HIWMgaeXh9dgLCsacDL9Pe
         GCTbtI2dUBQSl2ZN0KkNcM9MrLtgV528sd5vYbmPCwnbY4eazbp5u5uH02qiCgkI+h0b
         BMqw==
X-Gm-Message-State: AFqh2kpAZBPObuenXcMPdcgSeJfkwxzj3gBP2r4wvnuVR05T95Pzn0Bo
        d7T5ghLclP6VINzYH31MNpG5IN57kk24OH18uLM=
X-Google-Smtp-Source: AMrXdXuUFmc/i4zq0C+gCIrzO1Yo+G5x9XDvXwXztCWyjYEzWfZBuRe9+r10lm/NuoJcpjpM6BjheA==
X-Received: by 2002:a17:906:b28c:b0:851:97ca:7fc9 with SMTP id q12-20020a170906b28c00b0085197ca7fc9mr32582479ejz.40.1674656075189;
        Wed, 25 Jan 2023 06:14:35 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q22-20020a170906389600b00876479361edsm2456100ejd.149.2023.01.25.06.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:14:34 -0800 (PST)
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
Subject: [patch net-next 09/12] devlink: protect devlink param list by instance lock
Date:   Wed, 25 Jan 2023 15:14:09 +0100
Message-Id: <20230125141412.1592256-10-jiri@resnulli.us>
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

Commit 1d18bb1a4ddd ("devlink: allow registering parameters after
the instance") as the subject implies introduced possibility to register
devlink params even for already registered devlink instance. This is a
bit problematic, as the consistency or params list was originally
secured by the fact it is static during devlink lifetime. So in order to
protect the params list, take devlink instance lock during the params
operations. Introduce unlocked function variants and use them in drivers
in locked context. Put lock assertions to appropriate places.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c     | 80 ++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 18 ++--
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 92 +++++++++----------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 12 +--
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  6 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 12 +--
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 18 ++--
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 16 ++--
 .../ethernet/netronome/nfp/devlink_param.c    |  8 +-
 .../net/ethernet/netronome/nfp/nfp_net_main.c |  7 +-
 drivers/net/netdevsim/dev.c                   | 36 ++++----
 include/net/devlink.h                         | 16 +++-
 net/devlink/leftover.c                        | 77 +++++++++++-----
 13 files changed, 218 insertions(+), 180 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 3ae246391549..6152f77dcfd8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -265,29 +265,29 @@ static void mlx4_devlink_set_params_init_values(struct devlink *devlink)
 	union devlink_param_value value;
 
 	value.vbool = !!mlx4_internal_err_reset;
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
+					value);
 
 	value.vu32 = 1UL << log_num_mac;
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
+					value);
 
 	value.vbool = enable_64b_cqe_eqe;
-	devlink_param_driverinit_value_set(devlink,
-					   MLX4_DEVLINK_PARAM_ID_ENABLE_64B_CQE_EQE,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					MLX4_DEVLINK_PARAM_ID_ENABLE_64B_CQE_EQE,
+					value);
 
 	value.vbool = enable_4k_uar;
-	devlink_param_driverinit_value_set(devlink,
-					   MLX4_DEVLINK_PARAM_ID_ENABLE_4K_UAR,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					MLX4_DEVLINK_PARAM_ID_ENABLE_4K_UAR,
+					value);
 
 	value.vbool = false;
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_REGION_SNAPSHOT,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					DEVLINK_PARAM_GENERIC_ID_REGION_SNAPSHOT,
+					value);
 }
 
 static inline void mlx4_set_num_reserved_uars(struct mlx4_dev *dev,
@@ -3910,37 +3910,37 @@ static void mlx4_devlink_param_load_driverinit_values(struct devlink *devlink)
 	union devlink_param_value saved_value;
 	int err;
 
-	err = devlink_param_driverinit_value_get(devlink,
-						 DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
-						 &saved_value);
+	err = devl_param_driverinit_value_get(devlink,
+					      DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
+					      &saved_value);
 	if (!err && mlx4_internal_err_reset != saved_value.vbool) {
 		mlx4_internal_err_reset = saved_value.vbool;
 		/* Notify on value changed on runtime configuration mode */
-		devlink_param_value_changed(devlink,
-					    DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET);
+		devl_param_value_changed(devlink,
+					 DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET);
 	}
-	err = devlink_param_driverinit_value_get(devlink,
-						 DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
-						 &saved_value);
+	err = devl_param_driverinit_value_get(devlink,
+					      DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
+					      &saved_value);
 	if (!err)
 		log_num_mac = order_base_2(saved_value.vu32);
-	err = devlink_param_driverinit_value_get(devlink,
-						 MLX4_DEVLINK_PARAM_ID_ENABLE_64B_CQE_EQE,
-						 &saved_value);
+	err = devl_param_driverinit_value_get(devlink,
+					      MLX4_DEVLINK_PARAM_ID_ENABLE_64B_CQE_EQE,
+					      &saved_value);
 	if (!err)
 		enable_64b_cqe_eqe = saved_value.vbool;
-	err = devlink_param_driverinit_value_get(devlink,
-						 MLX4_DEVLINK_PARAM_ID_ENABLE_4K_UAR,
-						 &saved_value);
+	err = devl_param_driverinit_value_get(devlink,
+					      MLX4_DEVLINK_PARAM_ID_ENABLE_4K_UAR,
+					      &saved_value);
 	if (!err)
 		enable_4k_uar = saved_value.vbool;
-	err = devlink_param_driverinit_value_get(devlink,
-						 DEVLINK_PARAM_GENERIC_ID_REGION_SNAPSHOT,
-						 &saved_value);
+	err = devl_param_driverinit_value_get(devlink,
+					      DEVLINK_PARAM_GENERIC_ID_REGION_SNAPSHOT,
+					      &saved_value);
 	if (!err && crdump->snapshot_enable != saved_value.vbool) {
 		crdump->snapshot_enable = saved_value.vbool;
-		devlink_param_value_changed(devlink,
-					    DEVLINK_PARAM_GENERIC_ID_REGION_SNAPSHOT);
+		devl_param_value_changed(devlink,
+					 DEVLINK_PARAM_GENERIC_ID_REGION_SNAPSHOT);
 	}
 }
 
@@ -4021,8 +4021,8 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&dev->persist->interface_state_mutex);
 	mutex_init(&dev->persist->pci_status_mutex);
 
-	ret = devlink_params_register(devlink, mlx4_devlink_params,
-				      ARRAY_SIZE(mlx4_devlink_params));
+	ret = devl_params_register(devlink, mlx4_devlink_params,
+				   ARRAY_SIZE(mlx4_devlink_params));
 	if (ret)
 		goto err_devlink_unregister;
 	mlx4_devlink_set_params_init_values(devlink);
@@ -4037,8 +4037,8 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_params_unregister:
-	devlink_params_unregister(devlink, mlx4_devlink_params,
-				  ARRAY_SIZE(mlx4_devlink_params));
+	devl_params_unregister(devlink, mlx4_devlink_params,
+			       ARRAY_SIZE(mlx4_devlink_params));
 err_devlink_unregister:
 	kfree(dev->persist);
 err_devlink_free:
@@ -4181,8 +4181,8 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 
 	pci_release_regions(pdev);
 	mlx4_pci_disable_device(dev);
-	devlink_params_unregister(devlink, mlx4_devlink_params,
-				  ARRAY_SIZE(mlx4_devlink_params));
+	devl_params_unregister(devlink, mlx4_devlink_params,
+			       ARRAY_SIZE(mlx4_devlink_params));
 	kfree(dev->persist);
 	devl_unlock(devlink);
 	devlink_free(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index d7ae87ce435e..49bbfadc8c64 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -114,9 +114,9 @@ static bool is_eth_enabled(struct mlx5_core_dev *dev)
 	union devlink_param_value val;
 	int err;
 
-	err = devlink_param_driverinit_value_get(priv_to_devlink(dev),
-						 DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
-						 &val);
+	err = devl_param_driverinit_value_get(priv_to_devlink(dev),
+					      DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
+					      &val);
 	return err ? false : val.vbool;
 }
 
@@ -147,9 +147,9 @@ static bool is_vnet_enabled(struct mlx5_core_dev *dev)
 	union devlink_param_value val;
 	int err;
 
-	err = devlink_param_driverinit_value_get(priv_to_devlink(dev),
-						 DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
-						 &val);
+	err = devl_param_driverinit_value_get(priv_to_devlink(dev),
+					      DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
+					      &val);
 	return err ? false : val.vbool;
 }
 
@@ -221,9 +221,9 @@ static bool is_ib_enabled(struct mlx5_core_dev *dev)
 	union devlink_param_value val;
 	int err;
 
-	err = devlink_param_driverinit_value_get(priv_to_devlink(dev),
-						 DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
-						 &val);
+	err = devl_param_driverinit_value_get(priv_to_devlink(dev),
+					      DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
+					      &val);
 	return err ? false : val.vbool;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 2d2fcb518172..ed4b79aeecd1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -602,26 +602,26 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	union devlink_param_value value;
 
 	value.vbool = MLX5_CAP_GEN(dev, roce);
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+					value);
 
 #ifdef CONFIG_MLX5_ESWITCH
 	value.vu32 = ESW_OFFLOADS_DEFAULT_NUM_GROUPS;
-	devlink_param_driverinit_value_set(devlink,
-					   MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
+					value);
 #endif
 
 	value.vu32 = MLX5_COMP_EQ_SIZE;
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+					value);
 
 	value.vu32 = MLX5_NUM_ASYNC_EQE;
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+					value);
 }
 
 static const struct devlink_param mlx5_devlink_eth_params[] = {
@@ -638,15 +638,15 @@ static int mlx5_devlink_eth_params_register(struct devlink *devlink)
 	if (!mlx5_eth_supported(dev))
 		return 0;
 
-	err = devlink_params_register(devlink, mlx5_devlink_eth_params,
-				      ARRAY_SIZE(mlx5_devlink_eth_params));
+	err = devl_params_register(devlink, mlx5_devlink_eth_params,
+				   ARRAY_SIZE(mlx5_devlink_eth_params));
 	if (err)
 		return err;
 
 	value.vbool = true;
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
+					value);
 	return 0;
 }
 
@@ -657,8 +657,8 @@ static void mlx5_devlink_eth_params_unregister(struct devlink *devlink)
 	if (!mlx5_eth_supported(dev))
 		return;
 
-	devlink_params_unregister(devlink, mlx5_devlink_eth_params,
-				  ARRAY_SIZE(mlx5_devlink_eth_params));
+	devl_params_unregister(devlink, mlx5_devlink_eth_params,
+			       ARRAY_SIZE(mlx5_devlink_eth_params));
 }
 
 static int mlx5_devlink_enable_rdma_validate(struct devlink *devlink, u32 id,
@@ -686,15 +686,15 @@ static int mlx5_devlink_rdma_params_register(struct devlink *devlink)
 	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
 		return 0;
 
-	err = devlink_params_register(devlink, mlx5_devlink_rdma_params,
-				      ARRAY_SIZE(mlx5_devlink_rdma_params));
+	err = devl_params_register(devlink, mlx5_devlink_rdma_params,
+				   ARRAY_SIZE(mlx5_devlink_rdma_params));
 	if (err)
 		return err;
 
 	value.vbool = true;
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
+					value);
 	return 0;
 }
 
@@ -703,8 +703,8 @@ static void mlx5_devlink_rdma_params_unregister(struct devlink *devlink)
 	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
 		return;
 
-	devlink_params_unregister(devlink, mlx5_devlink_rdma_params,
-				  ARRAY_SIZE(mlx5_devlink_rdma_params));
+	devl_params_unregister(devlink, mlx5_devlink_rdma_params,
+			       ARRAY_SIZE(mlx5_devlink_rdma_params));
 }
 
 static const struct devlink_param mlx5_devlink_vnet_params[] = {
@@ -721,15 +721,15 @@ static int mlx5_devlink_vnet_params_register(struct devlink *devlink)
 	if (!mlx5_vnet_supported(dev))
 		return 0;
 
-	err = devlink_params_register(devlink, mlx5_devlink_vnet_params,
-				      ARRAY_SIZE(mlx5_devlink_vnet_params));
+	err = devl_params_register(devlink, mlx5_devlink_vnet_params,
+				   ARRAY_SIZE(mlx5_devlink_vnet_params));
 	if (err)
 		return err;
 
 	value.vbool = true;
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
+					value);
 	return 0;
 }
 
@@ -740,8 +740,8 @@ static void mlx5_devlink_vnet_params_unregister(struct devlink *devlink)
 	if (!mlx5_vnet_supported(dev))
 		return;
 
-	devlink_params_unregister(devlink, mlx5_devlink_vnet_params,
-				  ARRAY_SIZE(mlx5_devlink_vnet_params));
+	devl_params_unregister(devlink, mlx5_devlink_vnet_params,
+			       ARRAY_SIZE(mlx5_devlink_vnet_params));
 }
 
 static int mlx5_devlink_auxdev_params_register(struct devlink *devlink)
@@ -814,15 +814,15 @@ static int mlx5_devlink_max_uc_list_params_register(struct devlink *devlink)
 	if (!MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list_wr_supported))
 		return 0;
 
-	err = devlink_params_register(devlink, mlx5_devlink_max_uc_list_params,
-				      ARRAY_SIZE(mlx5_devlink_max_uc_list_params));
+	err = devl_params_register(devlink, mlx5_devlink_max_uc_list_params,
+				   ARRAY_SIZE(mlx5_devlink_max_uc_list_params));
 	if (err)
 		return err;
 
 	value.vu32 = 1 << MLX5_CAP_GEN(dev, log_max_current_uc_list);
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
+					value);
 	return 0;
 }
 
@@ -834,8 +834,8 @@ mlx5_devlink_max_uc_list_params_unregister(struct devlink *devlink)
 	if (!MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list_wr_supported))
 		return;
 
-	devlink_params_unregister(devlink, mlx5_devlink_max_uc_list_params,
-				  ARRAY_SIZE(mlx5_devlink_max_uc_list_params));
+	devl_params_unregister(devlink, mlx5_devlink_max_uc_list_params,
+			       ARRAY_SIZE(mlx5_devlink_max_uc_list_params));
 }
 
 #define MLX5_TRAP_DROP(_id, _group_id)					\
@@ -886,8 +886,8 @@ int mlx5_devlink_params_register(struct devlink *devlink)
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	int err;
 
-	err = devlink_params_register(devlink, mlx5_devlink_params,
-				      ARRAY_SIZE(mlx5_devlink_params));
+	err = devl_params_register(devlink, mlx5_devlink_params,
+				   ARRAY_SIZE(mlx5_devlink_params));
 	if (err)
 		return err;
 
@@ -909,8 +909,8 @@ int mlx5_devlink_params_register(struct devlink *devlink)
 max_uc_list_err:
 	mlx5_devlink_auxdev_params_unregister(devlink);
 auxdev_reg_err:
-	devlink_params_unregister(devlink, mlx5_devlink_params,
-				  ARRAY_SIZE(mlx5_devlink_params));
+	devl_params_unregister(devlink, mlx5_devlink_params,
+			       ARRAY_SIZE(mlx5_devlink_params));
 	return err;
 }
 
@@ -918,6 +918,6 @@ void mlx5_devlink_params_unregister(struct devlink *devlink)
 {
 	mlx5_devlink_max_uc_list_params_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
-	devlink_params_unregister(devlink, mlx5_devlink_params,
-				  ARRAY_SIZE(mlx5_devlink_params));
+	devl_params_unregister(devlink, mlx5_devlink_params,
+			       ARRAY_SIZE(mlx5_devlink_params));
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 8f7580fec193..9b44557e7271 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -629,9 +629,9 @@ static u16 async_eq_depth_devlink_param_get(struct mlx5_core_dev *dev)
 	union devlink_param_value val;
 	int err;
 
-	err = devlink_param_driverinit_value_get(devlink,
-						 DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
-						 &val);
+	err = devl_param_driverinit_value_get(devlink,
+					      DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+					      &val);
 	if (!err)
 		return val.vu32;
 	mlx5_core_dbg(dev, "Failed to get param. using default. err = %d\n", err);
@@ -874,9 +874,9 @@ static u16 comp_eq_depth_devlink_param_get(struct mlx5_core_dev *dev)
 	union devlink_param_value val;
 	int err;
 
-	err = devlink_param_driverinit_value_get(devlink,
-						 DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
-						 &val);
+	err = devl_param_driverinit_value_get(devlink,
+					      DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+					      &val);
 	if (!err)
 		return val.vu32;
 	mlx5_core_dbg(dev, "Failed to get param. using default. err = %d\n", err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index d809c9192496..0be01d702049 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1190,9 +1190,9 @@ static void mlx5_eswitch_get_devlink_param(struct mlx5_eswitch *esw)
 	union devlink_param_value val;
 	int err;
 
-	err = devlink_param_driverinit_value_get(devlink,
-						 MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
-						 &val);
+	err = devl_param_driverinit_value_get(devlink,
+					      MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
+					      &val);
 	if (!err) {
 		esw->params.large_group_num = val.vu32;
 	} else {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 65cd6c393c0a..8823f20d2122 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -484,9 +484,9 @@ static int max_uc_list_get_devlink_param(struct mlx5_core_dev *dev)
 	union devlink_param_value val;
 	int err;
 
-	err = devlink_param_driverinit_value_get(devlink,
-						 DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
-						 &val);
+	err = devl_param_driverinit_value_get(devlink,
+					      DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
+					      &val);
 	if (!err)
 		return val.vu32;
 	mlx5_core_dbg(dev, "Failed to get param. err = %d\n", err);
@@ -499,9 +499,9 @@ bool mlx5_is_roce_on(struct mlx5_core_dev *dev)
 	union devlink_param_value val;
 	int err;
 
-	err = devlink_param_driverinit_value_get(devlink,
-						 DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
-						 &val);
+	err = devl_param_driverinit_value_get(devlink,
+					      DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+					      &val);
 
 	if (!err)
 		return val.vbool;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index f952a6518ba9..f8623e8388c8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1243,9 +1243,9 @@ static int mlxsw_core_fw_rev_validate(struct mlxsw_core *mlxsw_core,
 		return 0;
 
 	/* Don't check if devlink 'fw_load_policy' param is 'flash' */
-	err = devlink_param_driverinit_value_get(priv_to_devlink(mlxsw_core),
-						 DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
-						 &value);
+	err = devl_param_driverinit_value_get(priv_to_devlink(mlxsw_core),
+					      DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
+					      &value);
 	if (err)
 		return err;
 	if (value.vu8 == DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH)
@@ -1316,20 +1316,22 @@ static int mlxsw_core_fw_params_register(struct mlxsw_core *mlxsw_core)
 	union devlink_param_value value;
 	int err;
 
-	err = devlink_params_register(devlink, mlxsw_core_fw_devlink_params,
-				      ARRAY_SIZE(mlxsw_core_fw_devlink_params));
+	err = devl_params_register(devlink, mlxsw_core_fw_devlink_params,
+				   ARRAY_SIZE(mlxsw_core_fw_devlink_params));
 	if (err)
 		return err;
 
 	value.vu8 = DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DRIVER;
-	devlink_param_driverinit_value_set(devlink, DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY, value);
+	devl_param_driverinit_value_set(devlink,
+					DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
+					value);
 	return 0;
 }
 
 static void mlxsw_core_fw_params_unregister(struct mlxsw_core *mlxsw_core)
 {
-	devlink_params_unregister(priv_to_devlink(mlxsw_core), mlxsw_core_fw_devlink_params,
-				  ARRAY_SIZE(mlxsw_core_fw_devlink_params));
+	devl_params_unregister(priv_to_devlink(mlxsw_core), mlxsw_core_fw_devlink_params,
+			       ARRAY_SIZE(mlxsw_core_fw_devlink_params));
 }
 
 static void *__dl_port(struct devlink_port *devlink_port)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3d15d3387aa2..b0bdb9640ebf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3898,23 +3898,23 @@ static int mlxsw_sp2_params_register(struct mlxsw_core *mlxsw_core)
 	union devlink_param_value value;
 	int err;
 
-	err = devlink_params_register(devlink, mlxsw_sp2_devlink_params,
-				      ARRAY_SIZE(mlxsw_sp2_devlink_params));
+	err = devl_params_register(devlink, mlxsw_sp2_devlink_params,
+				   ARRAY_SIZE(mlxsw_sp2_devlink_params));
 	if (err)
 		return err;
 
 	value.vu32 = 0;
-	devlink_param_driverinit_value_set(devlink,
-					   MLXSW_DEVLINK_PARAM_ID_ACL_REGION_REHASH_INTERVAL,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					MLXSW_DEVLINK_PARAM_ID_ACL_REGION_REHASH_INTERVAL,
+					value);
 	return 0;
 }
 
 static void mlxsw_sp2_params_unregister(struct mlxsw_core *mlxsw_core)
 {
-	devlink_params_unregister(priv_to_devlink(mlxsw_core),
-				  mlxsw_sp2_devlink_params,
-				  ARRAY_SIZE(mlxsw_sp2_devlink_params));
+	devl_params_unregister(priv_to_devlink(mlxsw_core),
+			       mlxsw_sp2_devlink_params,
+			       ARRAY_SIZE(mlxsw_sp2_devlink_params));
 }
 
 static void mlxsw_sp_ptp_transmitted(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/netronome/nfp/devlink_param.c b/drivers/net/ethernet/netronome/nfp/devlink_param.c
index db297ee4d7ad..a655f9e69a7b 100644
--- a/drivers/net/ethernet/netronome/nfp/devlink_param.c
+++ b/drivers/net/ethernet/netronome/nfp/devlink_param.c
@@ -233,8 +233,8 @@ int nfp_devlink_params_register(struct nfp_pf *pf)
 	if (err <= 0)
 		return err;
 
-	return devlink_params_register(devlink, nfp_devlink_params,
-				       ARRAY_SIZE(nfp_devlink_params));
+	return devl_params_register(devlink, nfp_devlink_params,
+				    ARRAY_SIZE(nfp_devlink_params));
 }
 
 void nfp_devlink_params_unregister(struct nfp_pf *pf)
@@ -245,6 +245,6 @@ void nfp_devlink_params_unregister(struct nfp_pf *pf)
 	if (err <= 0)
 		return;
 
-	devlink_params_unregister(priv_to_devlink(pf), nfp_devlink_params,
-				  ARRAY_SIZE(nfp_devlink_params));
+	devl_params_unregister(priv_to_devlink(pf), nfp_devlink_params,
+			       ARRAY_SIZE(nfp_devlink_params));
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index abfe788d558f..cbe4972ba104 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -754,11 +754,11 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	if (err)
 		goto err_devlink_unreg;
 
+	devl_lock(devlink);
 	err = nfp_devlink_params_register(pf);
 	if (err)
 		goto err_shared_buf_unreg;
 
-	devl_lock(devlink);
 	pf->ddir = nfp_net_debugfs_device_add(pf->pdev);
 
 	/* Allocate the vnics and do basic init */
@@ -791,9 +791,9 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	nfp_net_pf_free_vnics(pf);
 err_clean_ddir:
 	nfp_net_debugfs_dir_clean(&pf->ddir);
-	devl_unlock(devlink);
 	nfp_devlink_params_unregister(pf);
 err_shared_buf_unreg:
+	devl_unlock(devlink);
 	nfp_shared_buf_unregister(pf);
 err_devlink_unreg:
 	cancel_work_sync(&pf->port_refresh_work);
@@ -821,9 +821,10 @@ void nfp_net_pci_remove(struct nfp_pf *pf)
 	/* stop app first, to avoid double free of ctrl vNIC's ddir */
 	nfp_net_debugfs_dir_clean(&pf->ddir);
 
+	nfp_devlink_params_unregister(pf);
+
 	devl_unlock(devlink);
 
-	nfp_devlink_params_unregister(pf);
 	nfp_shared_buf_unregister(pf);
 
 	nfp_net_pf_free_irqs(pf);
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 738784fda117..f88095b0f836 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -527,13 +527,13 @@ static void nsim_devlink_set_params_init_values(struct nsim_dev *nsim_dev,
 	union devlink_param_value value;
 
 	value.vu32 = nsim_dev->max_macs;
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
+					value);
 	value.vbool = nsim_dev->test1;
-	devlink_param_driverinit_value_set(devlink,
-					   NSIM_DEVLINK_PARAM_ID_TEST1,
-					   value);
+	devl_param_driverinit_value_set(devlink,
+					NSIM_DEVLINK_PARAM_ID_TEST1,
+					value);
 }
 
 static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
@@ -542,14 +542,14 @@ static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
 	union devlink_param_value saved_value;
 	int err;
 
-	err = devlink_param_driverinit_value_get(devlink,
-						 DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
-						 &saved_value);
+	err = devl_param_driverinit_value_get(devlink,
+					      DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
+					      &saved_value);
 	if (!err)
 		nsim_dev->max_macs = saved_value.vu32;
-	err = devlink_param_driverinit_value_get(devlink,
-						 NSIM_DEVLINK_PARAM_ID_TEST1,
-						 &saved_value);
+	err = devl_param_driverinit_value_get(devlink,
+					      NSIM_DEVLINK_PARAM_ID_TEST1,
+					      &saved_value);
 	if (!err)
 		nsim_dev->test1 = saved_value.vbool;
 }
@@ -1564,8 +1564,8 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_dl_unregister;
 
-	err = devlink_params_register(devlink, nsim_devlink_params,
-				      ARRAY_SIZE(nsim_devlink_params));
+	err = devl_params_register(devlink, nsim_devlink_params,
+				   ARRAY_SIZE(nsim_devlink_params));
 	if (err)
 		goto err_resource_unregister;
 	nsim_devlink_set_params_init_values(nsim_dev, devlink);
@@ -1630,8 +1630,8 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 err_dummy_region_exit:
 	nsim_dev_dummy_region_exit(nsim_dev);
 err_params_unregister:
-	devlink_params_unregister(devlink, nsim_devlink_params,
-				  ARRAY_SIZE(nsim_devlink_params));
+	devl_params_unregister(devlink, nsim_devlink_params,
+			       ARRAY_SIZE(nsim_devlink_params));
 err_resource_unregister:
 	devl_resources_unregister(devlink);
 err_dl_unregister:
@@ -1678,8 +1678,8 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 
 	nsim_bpf_dev_exit(nsim_dev);
 	nsim_dev_debugfs_exit(nsim_dev);
-	devlink_params_unregister(devlink, nsim_devlink_params,
-				  ARRAY_SIZE(nsim_devlink_params));
+	devl_params_unregister(devlink, nsim_devlink_params,
+			       ARRAY_SIZE(nsim_devlink_params));
 	devl_resources_unregister(devlink);
 	devl_unregister(devlink);
 	kfree(nsim_dev->vfconfigs);
diff --git a/include/net/devlink.h b/include/net/devlink.h
index e0d773dfa637..ab654cf552b8 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1767,17 +1767,23 @@ void devl_resource_occ_get_unregister(struct devlink *devlink,
 
 void devlink_resource_occ_get_unregister(struct devlink *devlink,
 					 u64 resource_id);
+int devl_params_register(struct devlink *devlink,
+			 const struct devlink_param *params,
+			 size_t params_count);
 int devlink_params_register(struct devlink *devlink,
 			    const struct devlink_param *params,
 			    size_t params_count);
+void devl_params_unregister(struct devlink *devlink,
+			    const struct devlink_param *params,
+			    size_t params_count);
 void devlink_params_unregister(struct devlink *devlink,
 			       const struct devlink_param *params,
 			       size_t params_count);
-int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
-				       union devlink_param_value *init_val);
-void devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
-					union devlink_param_value init_val);
-void devlink_param_value_changed(struct devlink *devlink, u32 param_id);
+int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
+				    union devlink_param_value *init_val);
+void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
+				     union devlink_param_value init_val);
+void devl_param_value_changed(struct devlink *devlink, u32 param_id);
 struct devlink_region *devl_region_create(struct devlink *devlink,
 					  const struct devlink_region_ops *ops,
 					  u32 region_max_snapshots,
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 512ed4ccbdc7..bd4c5d2dd612 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -10832,7 +10832,7 @@ static void devlink_param_unregister(struct devlink *devlink,
 }
 
 /**
- *	devlink_params_register - register configuration parameters
+ *	devl_params_register - register configuration parameters
  *
  *	@devlink: devlink
  *	@params: configuration parameters array
@@ -10840,13 +10840,15 @@ static void devlink_param_unregister(struct devlink *devlink,
  *
  *	Register the configuration parameters supported by the driver.
  */
-int devlink_params_register(struct devlink *devlink,
-			    const struct devlink_param *params,
-			    size_t params_count)
+int devl_params_register(struct devlink *devlink,
+			 const struct devlink_param *params,
+			 size_t params_count)
 {
 	const struct devlink_param *param = params;
 	int i, err;
 
+	lockdep_assert_held(&devlink->lock);
+
 	for (i = 0; i < params_count; i++, param++) {
 		err = devlink_param_register(devlink, param);
 		if (err)
@@ -10862,29 +10864,54 @@ int devlink_params_register(struct devlink *devlink,
 		devlink_param_unregister(devlink, param);
 	return err;
 }
+EXPORT_SYMBOL_GPL(devl_params_register);
+
+int devlink_params_register(struct devlink *devlink,
+			    const struct devlink_param *params,
+			    size_t params_count)
+{
+	int err;
+
+	devl_lock(devlink);
+	err = devl_params_register(devlink, params, params_count);
+	devl_unlock(devlink);
+	return err;
+}
 EXPORT_SYMBOL_GPL(devlink_params_register);
 
 /**
- *	devlink_params_unregister - unregister configuration parameters
+ *	devl_params_unregister - unregister configuration parameters
  *	@devlink: devlink
  *	@params: configuration parameters to unregister
  *	@params_count: number of parameters provided
  */
-void devlink_params_unregister(struct devlink *devlink,
-			       const struct devlink_param *params,
-			       size_t params_count)
+void devl_params_unregister(struct devlink *devlink,
+			    const struct devlink_param *params,
+			    size_t params_count)
 {
 	const struct devlink_param *param = params;
 	int i;
 
+	lockdep_assert_held(&devlink->lock);
+
 	for (i = 0; i < params_count; i++, param++)
 		devlink_param_unregister(devlink, param);
 }
+EXPORT_SYMBOL_GPL(devl_params_unregister);
+
+void devlink_params_unregister(struct devlink *devlink,
+			       const struct devlink_param *params,
+			       size_t params_count)
+{
+	devl_lock(devlink);
+	devl_params_unregister(devlink, params, params_count);
+	devl_unlock(devlink);
+}
 EXPORT_SYMBOL_GPL(devlink_params_unregister);
 
 /**
- *	devlink_param_driverinit_value_get - get configuration parameter
- *					     value for driver initializing
+ *	devl_param_driverinit_value_get - get configuration parameter
+ *					  value for driver initializing
  *
  *	@devlink: devlink
  *	@param_id: parameter ID
@@ -10893,11 +10920,13 @@ EXPORT_SYMBOL_GPL(devlink_params_unregister);
  *	This function should be used by the driver to get driverinit
  *	configuration for initialization after reload command.
  */
-int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
-				       union devlink_param_value *init_val)
+int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
+				    union devlink_param_value *init_val)
 {
 	struct devlink_param_item *param_item;
 
+	lockdep_assert_held(&devlink->lock);
+
 	if (WARN_ON(!devlink_reload_supported(devlink->ops)))
 		return -EOPNOTSUPP;
 
@@ -10919,12 +10948,12 @@ int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(devlink_param_driverinit_value_get);
+EXPORT_SYMBOL_GPL(devl_param_driverinit_value_get);
 
 /**
- *	devlink_param_driverinit_value_set - set value of configuration
- *					     parameter for driverinit
- *					     configuration mode
+ *	devl_param_driverinit_value_set - set value of configuration
+ *					  parameter for driverinit
+ *					  configuration mode
  *
  *	@devlink: devlink
  *	@param_id: parameter ID
@@ -10933,8 +10962,8 @@ EXPORT_SYMBOL_GPL(devlink_param_driverinit_value_get);
  *	This function should be used by the driver to set driverinit
  *	configuration mode default value.
  */
-void devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
-					union devlink_param_value init_val)
+void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
+				     union devlink_param_value init_val)
 {
 	struct devlink_param_item *param_item;
 
@@ -10954,12 +10983,12 @@ void devlink_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 
 	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
 }
-EXPORT_SYMBOL_GPL(devlink_param_driverinit_value_set);
+EXPORT_SYMBOL_GPL(devl_param_driverinit_value_set);
 
 /**
- *	devlink_param_value_changed - notify devlink on a parameter's value
- *				      change. Should be called by the driver
- *				      right after the change.
+ *	devl_param_value_changed - notify devlink on a parameter's value
+ *				   change. Should be called by the driver
+ *				   right after the change.
  *
  *	@devlink: devlink
  *	@param_id: parameter ID
@@ -10968,7 +10997,7 @@ EXPORT_SYMBOL_GPL(devlink_param_driverinit_value_set);
  *	change, excluding driverinit configuration mode.
  *	For driverinit configuration mode driver should use the function
  */
-void devlink_param_value_changed(struct devlink *devlink, u32 param_id)
+void devl_param_value_changed(struct devlink *devlink, u32 param_id)
 {
 	struct devlink_param_item *param_item;
 
@@ -10977,7 +11006,7 @@ void devlink_param_value_changed(struct devlink *devlink, u32 param_id)
 
 	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
 }
-EXPORT_SYMBOL_GPL(devlink_param_value_changed);
+EXPORT_SYMBOL_GPL(devl_param_value_changed);
 
 /**
  * devl_region_create - create a new address region
-- 
2.39.0

