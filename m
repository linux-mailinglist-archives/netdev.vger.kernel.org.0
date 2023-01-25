Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1B267B40C
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbjAYOPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235708AbjAYOPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:15:24 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DDB59559
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:42 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id hw16so47918967ejc.10
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bMxofvSpuuiakewAR7vYqmlInYg0fSZyJzDBOnhXCWo=;
        b=UgmVJ6qtuTKMSkVEYv4e5FQ2xtW7q3hVgp2DwbyPNtT20HYQbA8ns7xfrBe6fpeO+b
         dlF/NwNKvUjM8hjTlD7IU26078FDLNqtza4NJzasgqf95CoBy2DYSpM7R4QEJM7kHY9D
         gdDdejUTmqvCMRSc5Zd6t5GqGZTN0QSaCWLpTpcN3LZ4JaYUlUiJgMYm+l/H2Of4uuRo
         Vy9Z6oTbdYGxxeOySpPMsEXdLPJCXQ/lQYVQuAVKFkrneBWmY5ijpn5xs2NuBxD1VwgJ
         4m2x2Iclwc7mBsmMh7fYtbglqUkIcF9tYvGmEeieClBN2a5rp+YVxsSUtGuBXfky+f4d
         MMKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bMxofvSpuuiakewAR7vYqmlInYg0fSZyJzDBOnhXCWo=;
        b=un6ohdbxGNhf66As5rNDbhEsF7ebgRQxcJFlRdFoNokep+D+v9umSebXY/APfiiiC8
         eCthotcV2IhmwRuJ0U0rtkqld0lrhHTDqpXWYqsP++mqbiFyDruPTdg8bJdI4e9605sn
         E5aUfHiVkI/mZAS90X/5LboF7BFUi9MM7HIa04JNsKMyxpeSxKgJr4HiypFpctT+zKLw
         i+6ITVE0LwOzbuaOTTQfQ44G2z1qh2D9dPg2RYDxo6cpt/CnpiTKdvcLX/ClSDfisr6X
         RPF/p21bbQBLz1xEMDMp5RfP+Pk8HAuFMz/JkDL4nHWgu0J4vbcp3kTuFdTIuQ+vVyW+
         1JQw==
X-Gm-Message-State: AFqh2kpnzgBivpjmQ3PxgCpgzMzI5TY9KZlZ4txYk60flsFNTRsmwF9y
        fg/2qGMgYqeg87rtznK3FZ+lqx8KU8hIH7bDMys=
X-Google-Smtp-Source: AMrXdXtSfKyd3i4uAT5yX6ME0KXn8OlEKMQtOg6zpIt3HVgEjBCgJ1+R7uwo8A2GLxiqXXUmTWN0nA==
X-Received: by 2002:a17:906:c409:b0:863:73ee:bb67 with SMTP id u9-20020a170906c40900b0086373eebb67mr33486010ejz.73.1674656081875;
        Wed, 25 Jan 2023 06:14:41 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q25-20020a1709060e5900b008448d273670sm2424930eji.49.2023.01.25.06.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:14:41 -0800 (PST)
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
Subject: [patch net-next 12/12] net/mlx5: Move eswitch port metadata devlink param to flow eswitch code
Date:   Wed, 25 Jan 2023 15:14:12 +0100
Message-Id: <20230125141412.1592256-13-jiri@resnulli.us>
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

Move the param registration and handling code into the eswitch offloads
code as they are related to each other. No point in having the
devlink param registration done in separate file.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
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
index 5fb9d5e99734..9f69d48866d9 100644
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
+	int err;
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

