Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF6C692A02
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbjBJWTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbjBJWTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:19:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4BB7FEC3
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 14:18:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3C8061EB6
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 22:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DB1C4339E;
        Fri, 10 Feb 2023 22:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676067521;
        bh=Hu3APESDvm13KY1oAWhF+pzj27xEFWLfWQGKST5YSbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oSDxaULgiaCotM7jZ9LAqW4M0QFCD8MzVY6JbLpLmptVaVJGvLXJ3VNJ6rpLHsuQZ
         RS8WCzAL2vRJcItjHqygAozBM7vm3n5e87lZyAePXOxDCiS35+qNmHZ3wGBZ0x6aSg
         Et5HyUVNNTfxQ34ThdcpR7i34CLoEC14J2Ni6yysuYvZ6koL5Alb2VpqKyDpVNKfjx
         zmgmSZHj0cMYMbHLW/l72JxuS9Oj9x1EDKSmgE7fQCV6oEGYEVoQ90vDK2msKvJjMP
         rXXQFNDXea9rcgjQ1YuFyp7L54wvI7QwS44Bf3JIsroTByFl7qNMUgdBsFjzI/E930
         Fj56bnMFlZ3RA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [net-next 15/15] net/mlx5: Suspend auxiliary devices only in case of PCI device suspend
Date:   Fri, 10 Feb 2023 14:18:21 -0800
Message-Id: <20230210221821.271571-16-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210221821.271571-1-saeed@kernel.org>
References: <20230210221821.271571-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The original behavior introduced by commit c6acd629eec7 ("net/mlx5e: Add
support for devlink-port in non-representors mode") correctly
re-instantiated uplink devlink port and related netdevice during devlink
reload. However with migration to auxiliary devices, this behaviour
changed.

Restore the original behaviour and tear down auxiliary devices
completely during devlink reload.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c    |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/devlink.c    |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/fw_reset.c   |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/health.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c   | 16 ++++++++--------
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h  |  6 +++---
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c  |  2 +-
 7 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 49bbfadc8c64..445fe30c3d0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -396,7 +396,7 @@ int mlx5_attach_device(struct mlx5_core_dev *dev)
 	return ret;
 }
 
-void mlx5_detach_device(struct mlx5_core_dev *dev)
+void mlx5_detach_device(struct mlx5_core_dev *dev, bool suspend)
 {
 	struct mlx5_priv *priv = &dev->priv;
 	struct auxiliary_device *adev;
@@ -425,7 +425,7 @@ void mlx5_detach_device(struct mlx5_core_dev *dev)
 
 		adrv = to_auxiliary_drv(adev->dev.driver);
 
-		if (adrv->suspend) {
+		if (adrv->suspend && suspend) {
 			adrv->suspend(adev, pm);
 			continue;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 1bccc6c31460..7f8d518f7ced 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -105,7 +105,7 @@ static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netli
 	if (err)
 		return err;
 
-	mlx5_unload_one_devl_locked(dev);
+	mlx5_unload_one_devl_locked(dev, true);
 	err = mlx5_health_wait_pci_up(dev);
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "FW activate aborted, PCI reads fail after reset");
@@ -168,7 +168,7 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
-		mlx5_unload_one_devl_locked(dev);
+		mlx5_unload_one_devl_locked(dev, false);
 		break;
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
 		if (limit == DEVLINK_RELOAD_LIMIT_NO_RESET)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 7bde34a17165..4c2dad9d7cfb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -163,7 +163,7 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
 		complete(&fw_reset->done);
 	} else {
-		mlx5_unload_one(dev);
+		mlx5_unload_one(dev, false);
 		if (mlx5_health_wait_pci_up(dev))
 			mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
 		else
@@ -498,7 +498,7 @@ int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev)
 	}
 	err = fw_reset->ret;
 	if (test_and_clear_bit(MLX5_FW_RESET_FLAGS_RELOAD_REQUIRED, &fw_reset->reset_flags)) {
-		mlx5_unload_one_devl_locked(dev);
+		mlx5_unload_one_devl_locked(dev, false);
 		mlx5_load_one_devl_locked(dev, false);
 	}
 out:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 1e8bee906c31..f9438d4e43ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -699,7 +699,7 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 		 * requests from the kernel.
 		 */
 		mlx5_core_err(dev, "Driver is in error state. Unloading\n");
-		mlx5_unload_one(dev);
+		mlx5_unload_one(dev, false);
 	}
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 6997b29fdecc..540840e80493 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1520,12 +1520,12 @@ int mlx5_load_one(struct mlx5_core_dev *dev)
 	return ret;
 }
 
-void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev)
+void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev, bool suspend)
 {
 	devl_assert_locked(priv_to_devlink(dev));
 	mutex_lock(&dev->intf_state_mutex);
 
-	mlx5_detach_device(dev);
+	mlx5_detach_device(dev, suspend);
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
 		mlx5_core_warn(dev, "%s: interface is down, NOP\n",
@@ -1540,12 +1540,12 @@ void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev)
 	mutex_unlock(&dev->intf_state_mutex);
 }
 
-void mlx5_unload_one(struct mlx5_core_dev *dev)
+void mlx5_unload_one(struct mlx5_core_dev *dev, bool suspend)
 {
 	struct devlink *devlink = priv_to_devlink(dev);
 
 	devl_lock(devlink);
-	mlx5_unload_one_devl_locked(dev);
+	mlx5_unload_one_devl_locked(dev, suspend);
 	devl_unlock(devlink);
 }
 
@@ -1830,7 +1830,7 @@ static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 
 	mlx5_enter_error_state(dev, false);
 	mlx5_error_sw_reset(dev);
-	mlx5_unload_one(dev);
+	mlx5_unload_one(dev, true);
 	mlx5_drain_health_wq(dev);
 	mlx5_pci_disable_device(dev);
 
@@ -1986,7 +1986,7 @@ static void shutdown(struct pci_dev *pdev)
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
 	err = mlx5_try_fast_unload(dev);
 	if (err)
-		mlx5_unload_one(dev);
+		mlx5_unload_one(dev, false);
 	mlx5_pci_disable_device(dev);
 }
 
@@ -1994,7 +1994,7 @@ static int mlx5_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 
-	mlx5_unload_one(dev);
+	mlx5_unload_one(dev, true);
 
 	return 0;
 }
@@ -2037,7 +2037,7 @@ MODULE_DEVICE_TABLE(pci, mlx5_core_pci_table);
 void mlx5_disable_device(struct mlx5_core_dev *dev)
 {
 	mlx5_error_sw_reset(dev);
-	mlx5_unload_one_devl_locked(dev);
+	mlx5_unload_one_devl_locked(dev, false);
 }
 
 int mlx5_recover_device(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index d670b28a7323..be0785f83083 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -236,7 +236,7 @@ void mlx5_adev_cleanup(struct mlx5_core_dev *dev);
 int mlx5_adev_init(struct mlx5_core_dev *dev);
 
 int mlx5_attach_device(struct mlx5_core_dev *dev);
-void mlx5_detach_device(struct mlx5_core_dev *dev);
+void mlx5_detach_device(struct mlx5_core_dev *dev, bool suspend);
 int mlx5_register_device(struct mlx5_core_dev *dev);
 void mlx5_unregister_device(struct mlx5_core_dev *dev);
 struct mlx5_core_dev *mlx5_get_next_phys_dev_lag(struct mlx5_core_dev *dev);
@@ -319,8 +319,8 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx);
 void mlx5_mdev_uninit(struct mlx5_core_dev *dev);
 int mlx5_init_one(struct mlx5_core_dev *dev);
 void mlx5_uninit_one(struct mlx5_core_dev *dev);
-void mlx5_unload_one(struct mlx5_core_dev *dev);
-void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev);
+void mlx5_unload_one(struct mlx5_core_dev *dev, bool suspend);
+void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev, bool suspend);
 int mlx5_load_one(struct mlx5_core_dev *dev);
 int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 7b4783ce213e..a7377619ba6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -74,7 +74,7 @@ static void mlx5_sf_dev_shutdown(struct auxiliary_device *adev)
 {
 	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
 
-	mlx5_unload_one(sf_dev->mdev);
+	mlx5_unload_one(sf_dev->mdev, false);
 }
 
 static const struct auxiliary_device_id mlx5_sf_dev_id_table[] = {
-- 
2.39.1

