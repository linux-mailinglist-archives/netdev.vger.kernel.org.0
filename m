Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC9C67B40B
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbjAYOPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235696AbjAYOPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:15:23 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2AD59744
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:41 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y11so21874173edd.6
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iQYuuxmdPZo1LjfvwwLGbJy3o66zLzedFnyh2nC+4Lc=;
        b=Nsf4/OoK/WyM98RJ9icIo3FnCo7f8ITDJHCQoe6iFlEFgU/mvHmQBtBqyWZmeumfJU
         1xSrDpeYhAHAbH3jTFyDPPvl75U30n4iuQ9gH3ud4F+3BIoGhf5ed6LLeP858ed1v2ED
         UF6VdrPnTkOxcMsJpaEU8P+C41f9BdjW/izC5n1Pf+ts0p8ihVIexdoDhu/jQiNJSK7a
         yysqu4USnSQuKd9xt2uM6Jx5oidx5vr6YxsPZQScJLSdq2c/A9QhvYIlpSj8U3N3U6cc
         Y6d9r4OdQEsfup7aOfeqbQH2vX3oDuR2MnEdVC+RjCyRp8UJIt4JaikzRU99Xzdv9TEH
         Qbcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iQYuuxmdPZo1LjfvwwLGbJy3o66zLzedFnyh2nC+4Lc=;
        b=fDXJjtjEDQlvVcRE4mWLQ70SDoPtEkkMvtv6onhzCcIxDeEdrWvTMJpgMctKCZcsNx
         odJV9FQzSnPCSmMb1wTNbaDT4F9Z6AyqBuqzitAZJpdA+YQNEg63UFpX34rbUjKFBLGr
         lMbkkDiaVZQYGzawKX4AStn2J0neQBUiZhsbQA2uHRM8Xrhd+K53oMZ3uh9LfWafhBDG
         nalqr5kuxRCSdkSvlEwAbpOzL5iDe8rbXLe1hVgeU/OvsbZgv1DiBxyI/BQC/n+YXf90
         mjRWtYs/4jxGajEKK/XdPjC07utM7zRDfcZGlhMIkMK794e447jyDMcRbaVCuIWtagzx
         A5kw==
X-Gm-Message-State: AO0yUKVgbJi9bbBTbcjEFgGzhdLvcPsGj23hexKlI1ma02O6s7UfBnfc
        H22OSD+lqBoZVdhSnXCzz9R0d8cDgmUGWvs16Ww=
X-Google-Smtp-Source: AK7set98DFgAPUKc8WeDztqeMD/oxRdX1t/SxZ8hrP0wDh9ukWOA3Fg98doBqcTyWUQiiQfWqwbEAQ==
X-Received: by 2002:a05:6402:31f8:b0:4a0:8eb8:bb8 with SMTP id dy24-20020a05640231f800b004a08eb80bb8mr5249960edb.18.1674656079601;
        Wed, 25 Jan 2023 06:14:39 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id em1-20020a056402364100b00483dd234ac6sm2372314edb.96.2023.01.25.06.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:14:38 -0800 (PST)
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
Subject: [patch net-next 11/12] net/mlx5: Move flow steering devlink param to flow steering code
Date:   Wed, 25 Jan 2023 15:14:11 +0100
Message-Id: <20230125141412.1592256-12-jiri@resnulli.us>
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

Move the param registration and handling code into the flow steering
code as they are related to each other. No point in having the
devlink param registration done in separate file.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 69 ---------------
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 84 ++++++++++++++++++-
 2 files changed, 83 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 8bda15dda0d7..5918c8c3e943 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -396,70 +396,6 @@ void mlx5_devlink_free(struct devlink *devlink)
 	devlink_free(devlink);
 }
 
-static int mlx5_devlink_fs_mode_validate(struct devlink *devlink, u32 id,
-					 union devlink_param_value val,
-					 struct netlink_ext_ack *extack)
-{
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-	char *value = val.vstr;
-	int err = 0;
-
-	if (!strcmp(value, "dmfs")) {
-		return 0;
-	} else if (!strcmp(value, "smfs")) {
-		u8 eswitch_mode;
-		bool smfs_cap;
-
-		eswitch_mode = mlx5_eswitch_mode(dev);
-		smfs_cap = mlx5_fs_dr_is_supported(dev);
-
-		if (!smfs_cap) {
-			err = -EOPNOTSUPP;
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Software managed steering is not supported by current device");
-		}
-
-		else if (eswitch_mode == MLX5_ESWITCH_OFFLOADS) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Software managed steering is not supported when eswitch offloads enabled.");
-			err = -EOPNOTSUPP;
-		}
-	} else {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Bad parameter: supported values are [\"dmfs\", \"smfs\"]");
-		err = -EINVAL;
-	}
-
-	return err;
-}
-
-static int mlx5_devlink_fs_mode_set(struct devlink *devlink, u32 id,
-				    struct devlink_param_gset_ctx *ctx)
-{
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-	enum mlx5_flow_steering_mode mode;
-
-	if (!strcmp(ctx->val.vstr, "smfs"))
-		mode = MLX5_FLOW_STEERING_MODE_SMFS;
-	else
-		mode = MLX5_FLOW_STEERING_MODE_DMFS;
-	dev->priv.steering->mode = mode;
-
-	return 0;
-}
-
-static int mlx5_devlink_fs_mode_get(struct devlink *devlink, u32 id,
-				    struct devlink_param_gset_ctx *ctx)
-{
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-
-	if (dev->priv.steering->mode == MLX5_FLOW_STEERING_MODE_SMFS)
-		strcpy(ctx->val.vstr, "smfs");
-	else
-		strcpy(ctx->val.vstr, "dmfs");
-	return 0;
-}
-
 static int mlx5_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
 					     union devlink_param_value val,
 					     struct netlink_ext_ack *extack)
@@ -549,11 +485,6 @@ static int mlx5_devlink_eq_depth_validate(struct devlink *devlink, u32 id,
 }
 
 static const struct devlink_param mlx5_devlink_params[] = {
-	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
-			     "flow_steering_mode", DEVLINK_PARAM_TYPE_STRING,
-			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
-			     mlx5_devlink_fs_mode_get, mlx5_devlink_fs_mode_set,
-			     mlx5_devlink_fs_mode_validate),
 	DEVLINK_PARAM_GENERIC(ENABLE_ROCE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			      NULL, NULL, mlx5_devlink_enable_roce_validate),
 #ifdef CONFIG_MLX5_ESWITCH
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 5a85d8c1e797..dd43a940499b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -34,12 +34,14 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/eswitch.h>
+#include <net/devlink.h>
 
 #include "mlx5_core.h"
 #include "fs_core.h"
 #include "fs_cmd.h"
 #include "fs_ft_pool.h"
 #include "diag/fs_tracepoint.h"
+#include "devlink.h"
 
 #define INIT_TREE_NODE_ARRAY_SIZE(...)	(sizeof((struct init_tree_node[]){__VA_ARGS__}) /\
 					 sizeof(struct init_tree_node))
@@ -3143,6 +3145,78 @@ static int init_egress_root_ns(struct mlx5_flow_steering *steering)
 	return err;
 }
 
+static int mlx5_fs_mode_validate(struct devlink *devlink, u32 id,
+				 union devlink_param_value val,
+				 struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	char *value = val.vstr;
+	int err = 0;
+
+	if (!strcmp(value, "dmfs")) {
+		return 0;
+	} else if (!strcmp(value, "smfs")) {
+		u8 eswitch_mode;
+		bool smfs_cap;
+
+		eswitch_mode = mlx5_eswitch_mode(dev);
+		smfs_cap = mlx5_fs_dr_is_supported(dev);
+
+		if (!smfs_cap) {
+			err = -EOPNOTSUPP;
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Software managed steering is not supported by current device");
+		}
+
+		else if (eswitch_mode == MLX5_ESWITCH_OFFLOADS) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Software managed steering is not supported when eswitch offloads enabled.");
+			err = -EOPNOTSUPP;
+		}
+	} else {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Bad parameter: supported values are [\"dmfs\", \"smfs\"]");
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+static int mlx5_fs_mode_set(struct devlink *devlink, u32 id,
+			    struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	enum mlx5_flow_steering_mode mode;
+
+	if (!strcmp(ctx->val.vstr, "smfs"))
+		mode = MLX5_FLOW_STEERING_MODE_SMFS;
+	else
+		mode = MLX5_FLOW_STEERING_MODE_DMFS;
+	dev->priv.steering->mode = mode;
+
+	return 0;
+}
+
+static int mlx5_fs_mode_get(struct devlink *devlink, u32 id,
+			    struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (dev->priv.steering->mode == MLX5_FLOW_STEERING_MODE_SMFS)
+		strcpy(ctx->val.vstr, "smfs");
+	else
+		strcpy(ctx->val.vstr, "dmfs");
+	return 0;
+}
+
+static const struct devlink_param mlx5_fs_params[] = {
+	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
+			     "flow_steering_mode", DEVLINK_PARAM_TYPE_STRING,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     mlx5_fs_mode_get, mlx5_fs_mode_set,
+			     mlx5_fs_mode_validate),
+};
+
 void mlx5_fs_core_cleanup(struct mlx5_core_dev *dev)
 {
 	struct mlx5_flow_steering *steering = dev->priv.steering;
@@ -3155,12 +3229,20 @@ void mlx5_fs_core_cleanup(struct mlx5_core_dev *dev)
 	cleanup_root_ns(steering->rdma_rx_root_ns);
 	cleanup_root_ns(steering->rdma_tx_root_ns);
 	cleanup_root_ns(steering->egress_root_ns);
+
+	devl_params_unregister(priv_to_devlink(dev), mlx5_fs_params,
+			       ARRAY_SIZE(mlx5_fs_params));
 }
 
 int mlx5_fs_core_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_flow_steering *steering = dev->priv.steering;
-	int err = 0;
+	int err;
+
+	err = devl_params_register(priv_to_devlink(dev), mlx5_fs_params,
+				   ARRAY_SIZE(mlx5_fs_params));
+	if (err)
+		return err;
 
 	if ((((MLX5_CAP_GEN(dev, port_type) == MLX5_CAP_PORT_TYPE_ETH) &&
 	      (MLX5_CAP_GEN(dev, nic_flow_table))) ||
-- 
2.39.0

