Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BCC3380A8
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhCKWhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhCKWhf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D431F64F93;
        Thu, 11 Mar 2021 22:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502255;
        bh=xxiK1Uca0dLgX4TJF2xCvlp5pJ78/H/iPYM3EFhrG6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkcQ5SA1ATDg02GX0+TDOI/a2S/98Tx01ir9n76G9DiKFEtXSmV/l+cJJqRPD8zss
         qmPYFia7cpb0WzE4kPWXUoGLgqXZyNOrAKD3bt6/CXQTNB6nGeKX40hjxUvbwESLDc
         mQsROHaW++rqfnzo8LiLW9kOJEhIxeGqmM4E+E9lDoHmG49lQ2heNLuhvixcxV2naN
         RqqH4KOcqNdxfnehFpvqIaplTyIRlL5CCffaWfjemgeEKAKYzKl8kWZijG1gYq9T6n
         b5nU+pA7xSpuv3TTfSx2Bb48IA4y+fVapoIuQFgXvMDHlJPqsNYaml0q0bJWSSXEKg
         r2iFUS/eZL7fQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Separate probe vs. reload flows
Date:   Thu, 11 Mar 2021 14:37:11 -0800
Message-Id: <20210311223723.361301-4-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The mix between probe/unprobe and reload flows causes to have an extra
mutex lock intf_state_mutex that generates LOCKDEP warning between it
and devlink_mutex. As a preparation for the future removal, separate
those flows.

Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   6 +-
 .../ethernet/mellanox/mlx5/core/fw_reset.c    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 136 ++++++++++++------
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   6 +-
 .../mellanox/mlx5/core/sf/dev/driver.c        |  14 +-
 5 files changed, 107 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d7d8a68ef23d..6729720e1ab7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -148,7 +148,7 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
-		mlx5_unload_one(dev, false);
+		mlx5_unload_one(dev);
 		return 0;
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
 		if (limit == DEVLINK_RELOAD_LIMIT_NO_RESET)
@@ -170,13 +170,13 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 	*actions_performed = BIT(action);
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
-		return mlx5_load_one(dev, false);
+		return mlx5_load_one(dev);
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
 		if (limit == DEVLINK_RELOAD_LIMIT_NO_RESET)
 			break;
 		/* On fw_activate action, also driver is reloaded and reinit performed */
 		*actions_performed |= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
-		return mlx5_load_one(dev, false);
+		return mlx5_load_one(dev);
 	default:
 		/* Unsupported action should not get to this function */
 		WARN_ON(1);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index f9042e147c7f..255bd0059da1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -104,7 +104,7 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
 		complete(&fw_reset->done);
 	} else {
-		mlx5_load_one(dev, false);
+		mlx5_load_one(dev);
 		devlink_remote_reload_actions_performed(priv_to_devlink(dev), 0,
 							BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 							BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
@@ -119,7 +119,7 @@ static void mlx5_sync_reset_reload_work(struct work_struct *work)
 	int err;
 
 	mlx5_enter_error_state(dev, true);
-	mlx5_unload_one(dev, false);
+	mlx5_unload_one(dev);
 	err = mlx5_health_wait_pci_up(dev);
 	if (err)
 		mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
@@ -342,7 +342,7 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
 	}
 
 	mlx5_enter_error_state(dev, true);
-	mlx5_unload_one(dev, false);
+	mlx5_unload_one(dev);
 done:
 	fw_reset->ret = err;
 	mlx5_fw_reset_complete_reload(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c568896cfb23..363bc3e917c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1235,7 +1235,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_put_uars_page(dev, dev->priv.uar);
 }
 
-int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
+int mlx5_init_one(struct mlx5_core_dev *dev)
 {
 	int err = 0;
 
@@ -1247,16 +1247,14 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 	/* remove any previous indication of internal error */
 	dev->state = MLX5_DEVICE_STATE_UP;
 
-	err = mlx5_function_setup(dev, boot);
+	err = mlx5_function_setup(dev, true);
 	if (err)
 		goto err_function;
 
-	if (boot) {
-		err = mlx5_init_once(dev);
-		if (err) {
-			mlx5_core_err(dev, "sw objs init failed\n");
-			goto function_teardown;
-		}
+	err = mlx5_init_once(dev);
+	if (err) {
+		mlx5_core_err(dev, "sw objs init failed\n");
+		goto function_teardown;
 	}
 
 	err = mlx5_load(dev);
@@ -1265,16 +1263,11 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 
 	set_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 
-	if (boot) {
-		err = mlx5_devlink_register(priv_to_devlink(dev), dev->device);
-		if (err)
-			goto err_devlink_reg;
-
-		err = mlx5_register_device(dev);
-	} else {
-		err = mlx5_attach_device(dev);
-	}
+	err = mlx5_devlink_register(priv_to_devlink(dev), dev->device);
+	if (err)
+		goto err_devlink_reg;
 
+	err = mlx5_register_device(dev);
 	if (err)
 		goto err_register;
 
@@ -1282,16 +1275,14 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 	return 0;
 
 err_register:
-	if (boot)
-		mlx5_devlink_unregister(priv_to_devlink(dev));
+	mlx5_devlink_unregister(priv_to_devlink(dev));
 err_devlink_reg:
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
 err_load:
-	if (boot)
-		mlx5_cleanup_once(dev);
+	mlx5_cleanup_once(dev);
 function_teardown:
-	mlx5_function_teardown(dev, boot);
+	mlx5_function_teardown(dev, true);
 err_function:
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 out:
@@ -1299,33 +1290,84 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 	return err;
 }
 
-void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
+void mlx5_uninit_one(struct mlx5_core_dev *dev)
 {
 	mutex_lock(&dev->intf_state_mutex);
 
-	if (cleanup) {
-		mlx5_unregister_device(dev);
-		mlx5_devlink_unregister(priv_to_devlink(dev));
-	} else {
-		mlx5_detach_device(dev);
-	}
+	mlx5_unregister_device(dev);
+	mlx5_devlink_unregister(priv_to_devlink(dev));
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
 		mlx5_core_warn(dev, "%s: interface is down, NOP\n",
 			       __func__);
-		if (cleanup)
-			mlx5_cleanup_once(dev);
+		mlx5_cleanup_once(dev);
 		goto out;
 	}
 
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
+	mlx5_unload(dev);
+	mlx5_cleanup_once(dev);
+	mlx5_function_teardown(dev, true);
+out:
+	mutex_unlock(&dev->intf_state_mutex);
+}
+
+int mlx5_load_one(struct mlx5_core_dev *dev)
+{
+	int err = 0;
+
+	mutex_lock(&dev->intf_state_mutex);
+	if (test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
+		mlx5_core_warn(dev, "interface is up, NOP\n");
+		goto out;
+	}
+	/* remove any previous indication of internal error */
+	dev->state = MLX5_DEVICE_STATE_UP;
+
+	err = mlx5_function_setup(dev, false);
+	if (err)
+		goto err_function;
+
+	err = mlx5_load(dev);
+	if (err)
+		goto err_load;
+
+	set_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 
+	err = mlx5_attach_device(dev);
+	if (err)
+		goto err_attach;
+
+	mutex_unlock(&dev->intf_state_mutex);
+	return 0;
+
+err_attach:
+	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
+err_load:
+	mlx5_function_teardown(dev, false);
+err_function:
+	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
+out:
+	mutex_unlock(&dev->intf_state_mutex);
+	return err;
+}
 
-	if (cleanup)
-		mlx5_cleanup_once(dev);
+void mlx5_unload_one(struct mlx5_core_dev *dev)
+{
+	mutex_lock(&dev->intf_state_mutex);
+
+	mlx5_detach_device(dev);
+
+	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
+		mlx5_core_warn(dev, "%s: interface is down, NOP\n",
+			       __func__);
+		goto out;
+	}
 
-	mlx5_function_teardown(dev, cleanup);
+	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
+	mlx5_unload(dev);
+	mlx5_function_teardown(dev, false);
 out:
 	mutex_unlock(&dev->intf_state_mutex);
 }
@@ -1397,7 +1439,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mutex_destroy(&dev->intf_state_mutex);
 }
 
-static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
+static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct mlx5_core_dev *dev;
 	struct devlink *devlink;
@@ -1433,11 +1475,11 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto pci_init_err;
 	}
 
-	err = mlx5_load_one(dev, true);
+	err = mlx5_init_one(dev);
 	if (err) {
-		mlx5_core_err(dev, "mlx5_load_one failed with error code %d\n",
+		mlx5_core_err(dev, "mlx5_init_one failed with error code %d\n",
 			      err);
-		goto err_load_one;
+		goto err_init_one;
 	}
 
 	err = mlx5_crdump_enable(dev);
@@ -1449,7 +1491,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		devlink_reload_enable(devlink);
 	return 0;
 
-err_load_one:
+err_init_one:
 	mlx5_pci_close(dev);
 pci_init_err:
 	mlx5_mdev_uninit(dev);
@@ -1469,7 +1511,7 @@ static void remove_one(struct pci_dev *pdev)
 	devlink_reload_disable(devlink);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
-	mlx5_unload_one(dev, true);
+	mlx5_uninit_one(dev);
 	mlx5_pci_close(dev);
 	mlx5_mdev_uninit(dev);
 	mlx5_adev_idx_free(dev->priv.adev_idx);
@@ -1485,7 +1527,7 @@ static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 
 	mlx5_enter_error_state(dev, false);
 	mlx5_error_sw_reset(dev);
-	mlx5_unload_one(dev, false);
+	mlx5_unload_one(dev);
 	mlx5_drain_health_wq(dev);
 	mlx5_pci_disable_device(dev);
 
@@ -1555,7 +1597,7 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
 
 	mlx5_core_info(dev, "%s was called\n", __func__);
 
-	err = mlx5_load_one(dev, false);
+	err = mlx5_load_one(dev);
 	if (err)
 		mlx5_core_err(dev, "%s: mlx5_load_one failed with error code: %d\n",
 			      __func__, err);
@@ -1627,7 +1669,7 @@ static void shutdown(struct pci_dev *pdev)
 	mlx5_core_info(dev, "Shutdown was called\n");
 	err = mlx5_try_fast_unload(dev);
 	if (err)
-		mlx5_unload_one(dev, false);
+		mlx5_unload_one(dev);
 	mlx5_pci_disable_device(dev);
 }
 
@@ -1635,7 +1677,7 @@ static int mlx5_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 
-	mlx5_unload_one(dev, false);
+	mlx5_unload_one(dev);
 
 	return 0;
 }
@@ -1644,7 +1686,7 @@ static int mlx5_resume(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 
-	return mlx5_load_one(dev, false);
+	return mlx5_load_one(dev);
 }
 
 static const struct pci_device_id mlx5_core_pci_table[] = {
@@ -1676,7 +1718,7 @@ MODULE_DEVICE_TABLE(pci, mlx5_core_pci_table);
 void mlx5_disable_device(struct mlx5_core_dev *dev)
 {
 	mlx5_error_sw_reset(dev);
-	mlx5_unload_one(dev, false);
+	mlx5_unload_one(dev);
 }
 
 void mlx5_recover_device(struct mlx5_core_dev *dev)
@@ -1689,7 +1731,7 @@ void mlx5_recover_device(struct mlx5_core_dev *dev)
 static struct pci_driver mlx5_core_driver = {
 	.name           = KBUILD_MODNAME,
 	.id_table       = mlx5_core_pci_table,
-	.probe          = init_one,
+	.probe          = probe_one,
 	.remove         = remove_one,
 	.suspend        = mlx5_suspend,
 	.resume         = mlx5_resume,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index efe403c7e354..02993a51b114 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -267,8 +267,10 @@ static inline bool mlx5_core_is_sf(const struct mlx5_core_dev *dev)
 
 int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx);
 void mlx5_mdev_uninit(struct mlx5_core_dev *dev);
-void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup);
-int mlx5_load_one(struct mlx5_core_dev *dev, bool boot);
+int mlx5_init_one(struct mlx5_core_dev *dev);
+void mlx5_uninit_one(struct mlx5_core_dev *dev);
+void mlx5_unload_one(struct mlx5_core_dev *dev);
+int mlx5_load_one(struct mlx5_core_dev *dev);
 
 int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index c4bf555c25ea..42c8ee03fe3e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -41,14 +41,15 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 		goto remap_err;
 	}
 
-	err = mlx5_load_one(mdev, true);
+	err = mlx5_init_one(mdev);
 	if (err) {
-		mlx5_core_warn(mdev, "mlx5_load_one err=%d\n", err);
-		goto load_one_err;
+		mlx5_core_warn(mdev, "mlx5_init_one err=%d\n", err);
+		goto init_one_err;
 	}
+	devlink_reload_enable(devlink);
 	return 0;
 
-load_one_err:
+init_one_err:
 	iounmap(mdev->iseg);
 remap_err:
 	mlx5_mdev_uninit(mdev);
@@ -63,7 +64,8 @@ static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
 	struct devlink *devlink;
 
 	devlink = priv_to_devlink(sf_dev->mdev);
-	mlx5_unload_one(sf_dev->mdev, true);
+	devlink_reload_disable(devlink);
+	mlx5_uninit_one(sf_dev->mdev);
 	iounmap(sf_dev->mdev->iseg);
 	mlx5_mdev_uninit(sf_dev->mdev);
 	mlx5_devlink_free(devlink);
@@ -73,7 +75,7 @@ static void mlx5_sf_dev_shutdown(struct auxiliary_device *adev)
 {
 	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
 
-	mlx5_unload_one(sf_dev->mdev, false);
+	mlx5_unload_one(sf_dev->mdev);
 }
 
 static const struct auxiliary_device_id mlx5_sf_dev_id_table[] = {
-- 
2.29.2

