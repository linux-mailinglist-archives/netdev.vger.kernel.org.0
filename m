Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2510267C547
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbjAZH7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235509AbjAZH7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:59:15 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1F767790
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:59 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id fl24so562626wmb.1
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1IR71lE6OY04fxneEMERlHQQ37Ua7KWa4ZHb7uI8TyA=;
        b=bdGzA4lL3EnGpG38zIh8mw93+68brQAHgQY+Sns4xMKuwE0dkjVeu8SssWjGnbE5ef
         c4jVaeRlY7BaJzMW+mnp1qEiWst/+hbWSg/IUKYj4mrr/GPR7KHuJ1j/wZVD82rQNcle
         Y7WbD6QSpgkItp4qW8MPSnZb4orF7RaQUYCnKz4z52pP16pi/gPSgTM/di0TqynIDNTf
         mqcoumZli12hksmnklxmGXcO5H99JxsjUJykMHJkDilj/2WTEVnXQLSxYfkffCnmaYQj
         h6QEO9Unh98dNbDiRTpOuA8dpRk6pInohT7hPtUuUr8S9ympQVGgdiFSB6pplyAS1KMe
         twYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1IR71lE6OY04fxneEMERlHQQ37Ua7KWa4ZHb7uI8TyA=;
        b=idMsjbpWUIiIQyT9xd9Ia0PIsa7ZYPN/XNwVEBGdMt5c9ScjZm7zh3RGjjnJM5AH8k
         Uor1rh5LcqfzbZPyuMzy60WQVD7T6imUb1sKSAjOFe5iFsgnpu2VrQH1IB8DlreT9RnT
         PWf5tlAPtsgS4P1A4PnNwhDhJ/79sqOxyIy2bNQhRPqCHIRvyfHN/g7KE8UrVkLui+Tt
         jf8Asd4PO5JiLYHCfjpMseNBD4fkRO2MBzSJOjOoaJp4KzrCcdvsD++5PeplYPhZvWTZ
         qoPh0dPObVUFEn2cw9hEFhY4DlGJoi7ZeZxhYCcPrRbi1mKIqQ61OzqDsO5YibbbFbxa
         OSAg==
X-Gm-Message-State: AFqh2ko4WWvXiXoIFLWK8diW0x3mBcnASoCiZExyjRw/F+w77wvwiMMo
        /Z2lthD0XOflHbBxJbHzQiSnIrb51JU/N+BJMJ17FQ==
X-Google-Smtp-Source: AMrXdXtjii6BEOWHRanXkotTlN4iIbR9+9ykGHKb1m4MDcS2Ulc7OfWz3kWaUYH91oUzJKmtzBf/gQ==
X-Received: by 2002:a05:600c:601c:b0:3d9:ee01:60a4 with SMTP id az28-20020a05600c601c00b003d9ee0160a4mr35179100wmb.1.1674719937773;
        Wed, 25 Jan 2023 23:58:57 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z14-20020a5d4c8e000000b002bfc2d0eff0sm559123wrs.47.2023.01.25.23.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 23:58:57 -0800 (PST)
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
Subject: [patch net-next v2 11/12] net/mlx5: Move flow steering devlink param to flow steering code
Date:   Thu, 26 Jan 2023 08:58:37 +0100
Message-Id: <20230126075838.1643665-12-jiri@resnulli.us>
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

Move the param registration and handling code into the flow steering
code as they are related to each other. No point in having the
devlink param registration done in separate file.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
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

