Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2117F67C549
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbjAZH7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236174AbjAZH7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:59:17 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A57D69B32
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:59:01 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id fl24so562662wmb.1
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=711hkH0MYRM5ILELB/4eoA/18VzXn4eFEw0ADhGfdeA=;
        b=Or0ac9ZCDEdlW1szh4IaStIbD48UxX3B3TMY+YdHWWzyLuB9RbZXyVfCJvih9Jht6I
         qcB1lDBpYItppZpiIyftGoDdLDkfc9S5X+Ahy5ltu1PvGGnMqsj/NSVcvWlg1OWuFX6w
         A82MEbk/JuB02IVKjhoVaoE+ftPZIM0rmPhkAyYGNzW4YxL1PBu1LIbzFAJfef0AKQB2
         GqHurrZBukDb57duaLrbEIePloaWVEEtvdB9W+nrZDlPikRTluP2wHPlZ5DjRrkJzfhM
         g2zDjKaK1REDBYdscWH07qHR+j7IKErpQCjH4qWSGKw8y3rGhkbHs9vAgfocmX1EYhk+
         oatQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=711hkH0MYRM5ILELB/4eoA/18VzXn4eFEw0ADhGfdeA=;
        b=xiAsVvX9Qr6Wt531qMlgYnBYZs2MXZ3dHNMbmAUhEArfXVvPBDPHVF7FTk+Z1IB96X
         lqYZnjTEujxRjrsfTCLV//q9Hkm+37rHg1zcRaoJeJJ50KxiTqHPD4a0ZognxPyYcm8h
         8timPBsQuWZoOIssdmeo8+ICjaHTu/aBKAqlbHMKGekfDMYXdEPjfU+TBGhN6bfDST23
         TQh6463wbHShB9T+K8IZa8J2vZ69FOFbv54QYj4VV2t5owWOLhjJTnZSXwaeD25OJCXD
         1cu1xchJr93+o4yBn7CvoCT7wIVUCdcPwT3N9fefu1NP2SzGEi54FhvrS8k6DuOIAVu0
         igVg==
X-Gm-Message-State: AFqh2krmnNmITRzuI53kBt2+qgWkELm92lUEeV0uBIehucqyBBOHhmTe
        9SfDZpJ680Igve9cbHubyZPudEVmeg1XB1B2HF2XhA==
X-Google-Smtp-Source: AMrXdXt6fDUW8WvIorIL+8i9KQgTUFDujpbOXV9XluuhMgRyy1cYs9bGBloTgtVQUNAKS4vdP6gAuw==
X-Received: by 2002:a05:600c:1e09:b0:3d1:f16d:5848 with SMTP id ay9-20020a05600c1e0900b003d1f16d5848mr34365996wmb.26.1674719939377;
        Wed, 25 Jan 2023 23:58:59 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n10-20020a05600c180a00b003daf672a616sm712293wmp.22.2023.01.25.23.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 23:58:58 -0800 (PST)
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
Subject: [patch net-next v2 12/12] net/mlx5: Move eswitch port metadata devlink param to flow eswitch code
Date:   Thu, 26 Jan 2023 08:58:38 +0100
Message-Id: <20230126075838.1643665-13-jiri@resnulli.us>
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

Move the param registration and handling code into the eswitch offloads
code as they are related to each other. No point in having the
devlink param registration done in separate file.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- fixed uninitialized variable issue in esw_port_metadata_set()
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 49 ----------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  4 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  4 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 92 ++++++++++++++++++-
 4 files changed, 94 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 5918c8c3e943..95a69544a685 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -432,49 +432,6 @@ static int mlx5_devlink_large_group_num_validate(struct devlink *devlink, u32 id
 	return 0;
 }
 
-static int mlx5_devlink_esw_port_metadata_set(struct devlink *devlink, u32 id,
-					      struct devlink_param_gset_ctx *ctx)
-{
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-
-	if (!MLX5_ESWITCH_MANAGER(dev))
-		return -EOPNOTSUPP;
-
-	return mlx5_esw_offloads_vport_metadata_set(dev->priv.eswitch, ctx->val.vbool);
-}
-
-static int mlx5_devlink_esw_port_metadata_get(struct devlink *devlink, u32 id,
-					      struct devlink_param_gset_ctx *ctx)
-{
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-
-	if (!MLX5_ESWITCH_MANAGER(dev))
-		return -EOPNOTSUPP;
-
-	ctx->val.vbool = mlx5_eswitch_vport_match_metadata_enabled(dev->priv.eswitch);
-	return 0;
-}
-
-static int mlx5_devlink_esw_port_metadata_validate(struct devlink *devlink, u32 id,
-						   union devlink_param_value val,
-						   struct netlink_ext_ack *extack)
-{
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-	u8 esw_mode;
-
-	if (!MLX5_ESWITCH_MANAGER(dev)) {
-		NL_SET_ERR_MSG_MOD(extack, "E-Switch is unsupported");
-		return -EOPNOTSUPP;
-	}
-	esw_mode = mlx5_eswitch_mode(dev);
-	if (esw_mode == MLX5_ESWITCH_OFFLOADS) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "E-Switch must either disabled or non switchdev mode");
-		return -EBUSY;
-	}
-	return 0;
-}
-
 #endif
 
 static int mlx5_devlink_eq_depth_validate(struct devlink *devlink, u32 id,
@@ -493,12 +450,6 @@ static const struct devlink_param mlx5_devlink_params[] = {
 			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			     NULL, NULL,
 			     mlx5_devlink_large_group_num_validate),
-	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_ESW_PORT_METADATA,
-			     "esw_port_metadata", DEVLINK_PARAM_TYPE_BOOL,
-			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
-			     mlx5_devlink_esw_port_metadata_get,
-			     mlx5_devlink_esw_port_metadata_set,
-			     mlx5_devlink_esw_port_metadata_validate),
 #endif
 	DEVLINK_PARAM_GENERIC(IO_EQ_SIZE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
 			      NULL, NULL, mlx5_devlink_eq_depth_validate),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 0be01d702049..0f052513fefa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1640,7 +1640,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	if (err)
 		goto abort;
 
-	err = esw_offloads_init_reps(esw);
+	err = esw_offloads_init(esw);
 	if (err)
 		goto reps_err;
 
@@ -1706,7 +1706,7 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	mlx5e_mod_hdr_tbl_destroy(&esw->offloads.mod_hdr);
 	mutex_destroy(&esw->offloads.encap_tbl_lock);
 	mutex_destroy(&esw->offloads.decap_tbl_lock);
-	esw_offloads_cleanup_reps(esw);
+	esw_offloads_cleanup(esw);
 	mlx5_esw_vports_cleanup(esw);
 	kfree(esw);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 92644fbb5081..5b5a215a7dc5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -346,8 +346,8 @@ struct mlx5_eswitch {
 
 void esw_offloads_disable(struct mlx5_eswitch *esw);
 int esw_offloads_enable(struct mlx5_eswitch *esw);
-void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw);
-int esw_offloads_init_reps(struct mlx5_eswitch *esw);
+void esw_offloads_cleanup(struct mlx5_eswitch *esw);
+int esw_offloads_init(struct mlx5_eswitch *esw);
 
 struct mlx5_flow_handle *
 mlx5_eswitch_add_send_to_vport_meta_rule(struct mlx5_eswitch *esw, u16 vport_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 5fb9d5e99734..3a82e385544d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2403,7 +2403,7 @@ static void mlx5_esw_offloads_rep_cleanup(struct mlx5_eswitch *esw,
 	kfree(rep);
 }
 
-void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw)
+static void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw)
 {
 	struct mlx5_eswitch_rep *rep;
 	unsigned long i;
@@ -2413,7 +2413,7 @@ void esw_offloads_cleanup_reps(struct mlx5_eswitch *esw)
 	xa_destroy(&esw->offloads.vport_reps);
 }
 
-int esw_offloads_init_reps(struct mlx5_eswitch *esw)
+static int esw_offloads_init_reps(struct mlx5_eswitch *esw)
 {
 	struct mlx5_vport *vport;
 	unsigned long i;
@@ -2433,6 +2433,94 @@ int esw_offloads_init_reps(struct mlx5_eswitch *esw)
 	return err;
 }
 
+static int esw_port_metadata_set(struct devlink *devlink, u32 id,
+				 struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
+	int err = 0;
+
+	down_write(&esw->mode_lock);
+	if (mlx5_esw_is_fdb_created(esw)) {
+		err = -EBUSY;
+		goto done;
+	}
+	if (!mlx5_esw_vport_match_metadata_supported(esw)) {
+		err = -EOPNOTSUPP;
+		goto done;
+	}
+	if (ctx->val.vbool)
+		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
+	else
+		esw->flags &= ~MLX5_ESWITCH_VPORT_MATCH_METADATA;
+done:
+	up_write(&esw->mode_lock);
+	return err;
+}
+
+static int esw_port_metadata_get(struct devlink *devlink, u32 id,
+				 struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	ctx->val.vbool = mlx5_eswitch_vport_match_metadata_enabled(dev->priv.eswitch);
+	return 0;
+}
+
+static int esw_port_metadata_validate(struct devlink *devlink, u32 id,
+				      union devlink_param_value val,
+				      struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	u8 esw_mode;
+
+	esw_mode = mlx5_eswitch_mode(dev);
+	if (esw_mode == MLX5_ESWITCH_OFFLOADS) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "E-Switch must either disabled or non switchdev mode");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+static const struct devlink_param esw_devlink_params[] = {
+	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_ESW_PORT_METADATA,
+			     "esw_port_metadata", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     esw_port_metadata_get,
+			     esw_port_metadata_set,
+			     esw_port_metadata_validate),
+};
+
+int esw_offloads_init(struct mlx5_eswitch *esw)
+{
+	int err;
+
+	err = esw_offloads_init_reps(esw);
+	if (err)
+		return err;
+
+	err = devl_params_register(priv_to_devlink(esw->dev),
+				   esw_devlink_params,
+				   ARRAY_SIZE(esw_devlink_params));
+	if (err)
+		goto err_params;
+
+	return 0;
+
+err_params:
+	esw_offloads_cleanup_reps(esw);
+	return err;
+}
+
+void esw_offloads_cleanup(struct mlx5_eswitch *esw)
+{
+	devl_params_unregister(priv_to_devlink(esw->dev),
+			       esw_devlink_params,
+			       ARRAY_SIZE(esw_devlink_params));
+	esw_offloads_cleanup_reps(esw);
+}
+
 static void __esw_offloads_unload_rep(struct mlx5_eswitch *esw,
 				      struct mlx5_eswitch_rep *rep, u8 rep_type)
 {
-- 
2.39.0

