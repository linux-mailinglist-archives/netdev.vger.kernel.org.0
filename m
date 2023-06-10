Return-Path: <netdev+bounces-9774-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DF1C72A7C2
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:47:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC4911C21199
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E4BC122;
	Sat, 10 Jun 2023 01:43:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96206BA4E
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4491CC433B4;
	Sat, 10 Jun 2023 01:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361400;
	bh=H9/ILK8D5gXkqVH0FuS9GbTGGMOXDlyN2YlNb0bc/8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAtGrfOMl98ojfscfEpogFSY7TY0dDIJlfNpi8qjAggijKrsCn/wGjkQsQBH7VPOb
	 OUAkHFaVORhjBnZIhIMpkHG+RiOK1X8Nj3uE0nq7/j15anjgXxF1TL7si7tyMzF6jo
	 UAPu+pBvN9ToAdd4tvVae24MhiuXCwaEsm9fbCdR1em8d938+aeAd5CSZgXzZm3lyV
	 KGvJlkKdORh2E4wNvMBr53nEURAEGET6N1T+9XtZAEC930C+n9c7uu2TwRr8cE9SKg
	 RLpul1arISbBOjkR8YRtLrl5Gw4p7EEeo8X2eI0i5nCZ8cRYJvZfqouRz01XXiHskH
	 dQpp5/LPKOOWw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 13/15] net/mlx5: Move esw multiport devlink param to eswitch code
Date: Fri,  9 Jun 2023 18:42:52 -0700
Message-Id: <20230610014254.343576-14-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230610014254.343576-1-saeed@kernel.org>
References: <20230610014254.343576-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

Move the param registration and handling code into the eswitch
code as they are related to each other. No point in having the
devlink param registration done in separate file.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 34 -------------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 49 ++++++++++++++++++-
 2 files changed, 47 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 63635cc44479..27197acdb4d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -7,7 +7,6 @@
 #include "fw_reset.h"
 #include "fs_core.h"
 #include "eswitch.h"
-#include "lag/lag.h"
 #include "esw/qos.h"
 #include "sf/dev/dev.h"
 #include "sf/sf.h"
@@ -427,33 +426,6 @@ static int mlx5_devlink_large_group_num_validate(struct devlink *devlink, u32 id
 
 	return 0;
 }
-
-static int mlx5_devlink_esw_multiport_set(struct devlink *devlink, u32 id,
-					  struct devlink_param_gset_ctx *ctx)
-{
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-
-	if (!MLX5_ESWITCH_MANAGER(dev))
-		return -EOPNOTSUPP;
-
-	if (ctx->val.vbool)
-		return mlx5_lag_mpesw_enable(dev);
-
-	mlx5_lag_mpesw_disable(dev);
-	return 0;
-}
-
-static int mlx5_devlink_esw_multiport_get(struct devlink *devlink, u32 id,
-					  struct devlink_param_gset_ctx *ctx)
-{
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-
-	if (!MLX5_ESWITCH_MANAGER(dev))
-		return -EOPNOTSUPP;
-
-	ctx->val.vbool = mlx5_lag_is_mpesw(dev);
-	return 0;
-}
 #endif
 
 static int mlx5_devlink_eq_depth_validate(struct devlink *devlink, u32 id,
@@ -527,12 +499,6 @@ static const struct devlink_param mlx5_devlink_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			     NULL, NULL,
 			     mlx5_devlink_large_group_num_validate),
-	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_ESW_MULTIPORT,
-			     "esw_multiport", DEVLINK_PARAM_TYPE_BOOL,
-			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
-			     mlx5_devlink_esw_multiport_get,
-			     mlx5_devlink_esw_multiport_set,
-			     NULL),
 #endif
 	DEVLINK_PARAM_GENERIC(IO_EQ_SIZE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			      NULL, NULL, mlx5_devlink_eq_depth_validate),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index b33d852aae34..2af9c4646bc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -41,6 +41,7 @@
 #include "esw/qos.h"
 #include "mlx5_core.h"
 #include "lib/eq.h"
+#include "lag/lag.h"
 #include "eswitch.h"
 #include "fs_core.h"
 #include "devlink.h"
@@ -1709,6 +1710,38 @@ static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
 	return err;
 }
 
+static int mlx5_devlink_esw_multiport_set(struct devlink *devlink, u32 id,
+					  struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (!MLX5_ESWITCH_MANAGER(dev))
+		return -EOPNOTSUPP;
+
+	if (ctx->val.vbool)
+		return mlx5_lag_mpesw_enable(dev);
+
+	mlx5_lag_mpesw_disable(dev);
+	return 0;
+}
+
+static int mlx5_devlink_esw_multiport_get(struct devlink *devlink, u32 id,
+					  struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	ctx->val.vbool = mlx5_lag_is_mpesw(dev);
+	return 0;
+}
+
+static const struct devlink_param mlx5_eswitch_params[] = {
+	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_ESW_MULTIPORT,
+			     "esw_multiport", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     mlx5_devlink_esw_multiport_get,
+			     mlx5_devlink_esw_multiport_set, NULL),
+};
+
 int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eswitch *esw;
@@ -1717,9 +1750,16 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	if (!MLX5_VPORT_MANAGER(dev) && !MLX5_ESWITCH_MANAGER(dev))
 		return 0;
 
+	err = devl_params_register(priv_to_devlink(dev), mlx5_eswitch_params,
+				   ARRAY_SIZE(mlx5_eswitch_params));
+	if (err)
+		return err;
+
 	esw = kzalloc(sizeof(*esw), GFP_KERNEL);
-	if (!esw)
-		return -ENOMEM;
+	if (!esw) {
+		err = -ENOMEM;
+		goto unregister_param;
+	}
 
 	esw->dev = dev;
 	esw->manager_vport = mlx5_eswitch_manager_vport(dev);
@@ -1779,6 +1819,9 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	if (esw->work_queue)
 		destroy_workqueue(esw->work_queue);
 	kfree(esw);
+unregister_param:
+	devl_params_unregister(priv_to_devlink(dev), mlx5_eswitch_params,
+			       ARRAY_SIZE(mlx5_eswitch_params));
 	return err;
 }
 
@@ -1802,6 +1845,8 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	esw_offloads_cleanup(esw);
 	mlx5_esw_vports_cleanup(esw);
 	kfree(esw);
+	devl_params_unregister(priv_to_devlink(esw->dev), mlx5_eswitch_params,
+			       ARRAY_SIZE(mlx5_eswitch_params));
 }
 
 /* Vport Administration */
-- 
2.40.1


