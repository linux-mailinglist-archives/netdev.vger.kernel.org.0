Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0424DE1BE
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 20:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240358AbiCRTZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 15:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240346AbiCRTZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:25:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DA930CAB2
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 12:23:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 548B061BCE
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 19:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BBCC340EF;
        Fri, 18 Mar 2022 19:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647631435;
        bh=aPMxRoaqeQKGiZ9p7lM5SLOHPisiNexz0QgfkSk7Hsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aegtk6JEWBPLXrIjZBoD+CuXavV26VtxMXA9tywP2u4XlqX7p+xcxwPcGsVio8FHH
         XnNqm2uFzW1eQ2Bvr8jKtITs5pGlvUiZZqzPop776XGmc/yO9UNu+Ql99KQVvZnoFz
         R0iSnqFAK+otiJeVBnyHFB4KUlfp+DEyCRZaihGfHNmQ/5z7IArqy2gPSEoI4oR9rG
         aMnaV5bpELTcHFHMY+MdijqcXik8EeqhXWQw5pXwdTyiL/iLU2GEMs3n6lK0hXd0MP
         fcvhVh4xz9vXfIC26aocpRXQesVyk+Ca53L6uf+ViCMlLGd2myn+PshNNDuvS/5KM6
         TYBhLgX/R/BOg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, leonro@nvidia.com,
        saeedm@nvidia.com, idosch@idosch.org, michael.chan@broadcom.com,
        simon.horman@corigine.com, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 5/5] devlink: hold the instance lock during eswitch_mode callbacks
Date:   Fri, 18 Mar 2022 12:23:44 -0700
Message-Id: <20220318192344.1587891-6-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220318192344.1587891-1-kuba@kernel.org>
References: <20220318192344.1587891-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the devlink core hold the instance lock during eswitch_mode
callbacks. Cheat in case of mlx5 (see the cover letter).

Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 22 +++-----
 .../mellanox/mlx5/core/eswitch_offloads.c     | 54 ++++++++++++++-----
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  7 +--
 drivers/net/netdevsim/dev.c                   | 16 ++----
 net/core/devlink.c                            |  6 ---
 5 files changed, 54 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index b2a9528b456b..eb4803b11c0e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -559,44 +559,34 @@ int bnxt_dl_eswitch_mode_set(struct devlink *devlink, u16 mode,
 			     struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = bnxt_get_bp_from_dl(devlink);
-	int rc = 0;
 
-	devl_lock(devlink);
 	if (bp->eswitch_mode == mode) {
 		netdev_info(bp->dev, "already in %s eswitch mode\n",
 			    mode == DEVLINK_ESWITCH_MODE_LEGACY ?
 			    "legacy" : "switchdev");
-		rc = -EINVAL;
-		goto done;
+		return -EINVAL;
 	}
 
 	switch (mode) {
 	case DEVLINK_ESWITCH_MODE_LEGACY:
 		bnxt_vf_reps_destroy(bp);
-		break;
+		return 0;
 
 	case DEVLINK_ESWITCH_MODE_SWITCHDEV:
 		if (bp->hwrm_spec_code < 0x10803) {
 			netdev_warn(bp->dev, "FW does not support SRIOV E-Switch SWITCHDEV mode\n");
-			rc = -ENOTSUPP;
-			goto done;
+			return -ENOTSUPP;
 		}
 
 		if (pci_num_vf(bp->pdev) == 0) {
 			netdev_info(bp->dev, "Enable VFs before setting switchdev mode\n");
-			rc = -EPERM;
-			goto done;
+			return -EPERM;
 		}
-		rc = bnxt_vf_reps_create(bp);
-		break;
+		return bnxt_vf_reps_create(bp);
 
 	default:
-		rc = -EINVAL;
-		goto done;
+		return -EINVAL;
 	}
-done:
-	devl_unlock(devlink);
-	return rc;
 }
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 35cf4cb3098e..3f63df127091 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3337,6 +3337,27 @@ static int eswitch_devlink_esw_mode_check(const struct mlx5_eswitch *esw)
 		!mlx5_core_is_ecpf_esw_manager(esw->dev)) ? -EOPNOTSUPP : 0;
 }
 
+/* FIXME: devl_unlock() followed by devl_lock() inside driver callback
+ * is never correct and prone to races. It's a transitional workaround,
+ * never repeat this pattern.
+ *
+ * This code MUST be fixed before removing devlink_mutex as it is safe
+ * to do only because of that mutex.
+ */
+static void mlx5_eswtich_mode_callback_enter(struct devlink *devlink,
+					     struct mlx5_eswitch *esw)
+{
+	devl_unlock(devlink);
+	down_write(&esw->mode_lock);
+}
+
+static void mlx5_eswtich_mode_callback_exit(struct devlink *devlink,
+					    struct mlx5_eswitch *esw)
+{
+	up_write(&esw->mode_lock);
+	devl_lock(devlink);
+}
+
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 				  struct netlink_ext_ack *extack)
 {
@@ -3351,6 +3372,15 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
 		return -EINVAL;
 
+	/* FIXME: devl_unlock() followed by devl_lock() inside driver callback
+	 * is never correct and prone to races. It's a transitional workaround,
+	 * never repeat this pattern.
+	 *
+	 * This code MUST be fixed before removing devlink_mutex as it is safe
+	 * to do only because of that mutex.
+	 */
+	devl_unlock(devlink);
+
 	mlx5_lag_disable_change(esw->dev);
 	err = mlx5_esw_try_lock(esw);
 	if (err < 0) {
@@ -3381,6 +3411,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	mlx5_esw_unlock(esw);
 enable_lag:
 	mlx5_lag_enable_change(esw->dev);
+	devl_lock(devlink);
 	return err;
 }
 
@@ -3393,14 +3424,14 @@ int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	down_write(&esw->mode_lock);
+	mlx5_eswtich_mode_callback_enter(devlink, esw);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto unlock;
 
 	err = esw_mode_to_devlink(esw->mode, mode);
 unlock:
-	up_write(&esw->mode_lock);
+	mlx5_eswtich_mode_callback_exit(devlink, esw);
 	return err;
 }
 
@@ -3447,7 +3478,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	down_write(&esw->mode_lock);
+	mlx5_eswtich_mode_callback_enter(devlink, esw);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto out;
@@ -3484,11 +3515,11 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 		goto out;
 
 	esw->offloads.inline_mode = mlx5_mode;
-	up_write(&esw->mode_lock);
+	mlx5_eswtich_mode_callback_exit(devlink, esw);
 	return 0;
 
 out:
-	up_write(&esw->mode_lock);
+	mlx5_eswtich_mode_callback_exit(devlink, esw);
 	return err;
 }
 
@@ -3501,14 +3532,14 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	down_write(&esw->mode_lock);
+	mlx5_eswtich_mode_callback_enter(devlink, esw);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto unlock;
 
 	err = esw_inline_mode_to_devlink(esw->offloads.inline_mode, mode);
 unlock:
-	up_write(&esw->mode_lock);
+	mlx5_eswtich_mode_callback_exit(devlink, esw);
 	return err;
 }
 
@@ -3524,7 +3555,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	down_write(&esw->mode_lock);
+	mlx5_eswtich_mode_callback_enter(devlink, esw);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto unlock;
@@ -3570,7 +3601,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	}
 
 unlock:
-	up_write(&esw->mode_lock);
+	mlx5_eswtich_mode_callback_exit(devlink, esw);
 	return err;
 }
 
@@ -3584,15 +3615,14 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-
-	down_write(&esw->mode_lock);
+	mlx5_eswtich_mode_callback_enter(devlink, esw);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto unlock;
 
 	*encap = esw->offloads.encap;
 unlock:
-	up_write(&esw->mode_lock);
+	mlx5_eswtich_mode_callback_exit(devlink, esw);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 48b95566b52b..405786c00334 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -144,13 +144,8 @@ static int nfp_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 					struct netlink_ext_ack *extack)
 {
 	struct nfp_pf *pf = devlink_priv(devlink);
-	int ret;
-
-	devl_lock(devlink);
-	ret = nfp_app_eswitch_mode_set(pf->app, mode);
-	devl_unlock(devlink);
 
-	return ret;
+	return nfp_app_eswitch_mode_set(pf->app, mode);
 }
 
 static const struct nfp_devlink_versions_simple {
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 68cd1defe990..57a3ac893792 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -615,22 +615,16 @@ static int nsim_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 					 struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
-	int err = 0;
 
-	devl_lock(devlink);
 	if (mode == nsim_dev->esw_mode)
-		goto unlock;
+		return 0;
 
 	if (mode == DEVLINK_ESWITCH_MODE_LEGACY)
-		err = nsim_esw_legacy_enable(nsim_dev, extack);
-	else if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV)
-		err = nsim_esw_switchdev_enable(nsim_dev, extack);
-	else
-		err = -EINVAL;
+		return nsim_esw_legacy_enable(nsim_dev, extack);
+	if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV)
+		return nsim_esw_switchdev_enable(nsim_dev, extack);
 
-unlock:
-	devl_unlock(devlink);
-	return err;
+	return -EINVAL;
 }
 
 static int nsim_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5aac5370c136..aeca13b6e57b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2868,15 +2868,11 @@ static int devlink_rate_nodes_check(struct devlink *devlink, u16 mode,
 {
 	struct devlink_rate *devlink_rate;
 
-	/* Take the lock to sync with destroy */
-	mutex_lock(&devlink->lock);
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list)
 		if (devlink_rate_is_node(devlink_rate)) {
-			mutex_unlock(&devlink->lock);
 			NL_SET_ERR_MSG_MOD(extack, "Rate node(s) exists.");
 			return -EBUSY;
 		}
-	mutex_unlock(&devlink->lock);
 	return 0;
 }
 
@@ -8735,14 +8731,12 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_eswitch_get_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_ESWITCH_SET,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_eswitch_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NO_LOCK,
 	},
 	{
 		.cmd = DEVLINK_CMD_DPIPE_TABLE_GET,
-- 
2.34.1

