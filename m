Return-Path: <netdev+bounces-9775-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F5A572A7C6
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:47:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 268FF281A90
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA686BA4E;
	Sat, 10 Jun 2023 01:43:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB2FBE7D
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BE2C433AE;
	Sat, 10 Jun 2023 01:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361401;
	bh=Nh2CcizcFX0AOY9PWixEOCKSQkAvv+X7bsVn/wlLO4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSFiW3aaoXUWIpANKguuqni+lO6wqz+9ibrVn0FE0a0OZmcMNjz3ohC42GDGzmI9D
	 cUg/TiZP6bYDw9+8JQhjczTIcv5dk/XIgMftOoANSHC1Rpv90KJo/19UV/jMjlqJ36
	 QBmHqXXtGx+sQQ0BMksgoLwmTfqZp44Mr5r14ImWhAfat0Wiu9AJo6G9kTndNaQ6X8
	 z6oZk5dWpM7dJ9ecf/IcYz7SVXTY3FV5kWq/BanCeLFPzk38dleNREw+sHmtltEnZM
	 Xp5LbrIEDbrzIIIewWNrzSfoEn3YbyP9y7Xc6j0u/GK+e8MS/uaQLgT0T6wbY8fQva
	 DuLAZkZ61hnZA==
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
Subject: [net-next 14/15] net/mlx5: Light probe local SFs
Date: Fri,  9 Jun 2023 18:42:53 -0700
Message-Id: <20230610014254.343576-15-saeed@kernel.org>
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

In case user wants to configure the SFs, for example: to use only vdpa
functionality, he needs to fully probe a SF, configure what he wants,
and afterward reload the SF.

In order to save the time of the reload, local SFs will probe without
any auxiliary sub-device, so that the SFs can be configured prior to
its full probe.

The defaults of the enable_* devlink params of these SFs are set to
false.

Usage example:
Create SF:
$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
$ devlink port function set pci/0000:08:00.0/32768 \
               hw_addr 00:00:00:00:00:11 state active

Enable ETH auxiliary device:
$ devlink dev param set auxiliary/mlx5_core.sf.1 \
              name enable_eth value true cmode driverinit

Now, in order to fully probe the SF, use devlink reload:
$ devlink dev reload auxiliary/mlx5_core.sf.1

At this point the user have SF devlink instance with auxiliary device
for the Ethernet functionality only.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/switchdev.rst      |  20 +++
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  16 +++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  20 ++-
 .../net/ethernet/mellanox/mlx5/core/health.c  |  24 ++--
 .../net/ethernet/mellanox/mlx5/core/main.c    | 124 ++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   7 +
 .../mellanox/mlx5/core/sf/dev/driver.c        |  15 ++-
 7 files changed, 203 insertions(+), 23 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
index 01deedb71597..db62187eebce 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
@@ -45,6 +45,26 @@ Following bridge VLAN functions are supported by mlx5:
 Subfunction
 ===========
 
+Subfunction which are spawned over the E-switch are created only with devlink
+device, and by default all the SF auxiliary devices are disabled.
+This will allow user to configure the SF before the SF have been fully probed,
+which will save time.
+
+Usage example:
+Create SF:
+$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
+$ devlink port function set pci/0000:08:00.0/32768 \
+               hw_addr 00:00:00:00:00:11 state active
+
+Enable ETH auxiliary device:
+$ devlink dev param set auxiliary/mlx5_core.sf.1 \
+              name enable_eth value true cmode driverinit
+
+Now, in order to fully probe the SF, use devlink reload:
+$ devlink dev reload auxiliary/mlx5_core.sf.1
+
+mlx5 supports ETH,rdma and vdpa (vnet) auxiliary devices devlink params (see :ref:`Documentation/networking/devlink/devlink-params.rst`)
+
 mlx5 supports subfunction management using devlink port (see :ref:`Documentation/networking/devlink/devlink-port.rst <devlink_port>`) interface.
 
 A subfunction has its own function capabilities and its own resources. This
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 1b33533b15de..617ac7e5d75c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -323,6 +323,18 @@ static void del_adev(struct auxiliary_device *adev)
 	auxiliary_device_uninit(adev);
 }
 
+void mlx5_dev_set_lightweight(struct mlx5_core_dev *dev)
+{
+	mutex_lock(&mlx5_intf_mutex);
+	dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
+	mutex_unlock(&mlx5_intf_mutex);
+}
+
+bool mlx5_dev_is_lightweight(struct mlx5_core_dev *dev)
+{
+	return dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
+}
+
 int mlx5_attach_device(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
@@ -457,6 +469,10 @@ static int add_drivers(struct mlx5_core_dev *dev)
 		if (priv->adev[i])
 			continue;
 
+		if (mlx5_adev_devices[i].is_enabled &&
+		    !(mlx5_adev_devices[i].is_enabled(dev)))
+			continue;
+
 		if (mlx5_adev_devices[i].is_supported)
 			is_supported = mlx5_adev_devices[i].is_supported(dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 27197acdb4d8..3d82ec890666 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -141,6 +141,13 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 	bool sf_dev_allocated;
 	int ret = 0;
 
+	if (mlx5_dev_is_lightweight(dev)) {
+		if (action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT)
+			return -EOPNOTSUPP;
+		mlx5_unload_one_light(dev);
+		return 0;
+	}
+
 	sf_dev_allocated = mlx5_sf_dev_allocated(dev);
 	if (sf_dev_allocated) {
 		/* Reload results in deleting SF device which further results in
@@ -193,6 +200,10 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 	*actions_performed = BIT(action);
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+		if (mlx5_dev_is_lightweight(dev)) {
+			mlx5_fw_reporters_create(dev);
+			return mlx5_init_one_devl_locked(dev);
+		}
 		ret = mlx5_load_one_devl_locked(dev, false);
 		break;
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
@@ -511,7 +522,7 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	union devlink_param_value value;
 
-	value.vbool = MLX5_CAP_GEN(dev, roce);
+	value.vbool = MLX5_CAP_GEN(dev, roce) && !mlx5_dev_is_lightweight(dev);
 	devl_param_driverinit_value_set(devlink,
 					DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
 					value);
@@ -561,7 +572,7 @@ static int mlx5_devlink_eth_params_register(struct devlink *devlink)
 	if (err)
 		return err;
 
-	value.vbool = true;
+	value.vbool = !mlx5_dev_is_lightweight(dev);
 	devl_param_driverinit_value_set(devlink,
 					DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
 					value);
@@ -601,6 +612,7 @@ static const struct devlink_param mlx5_devlink_rdma_params[] = {
 
 static int mlx5_devlink_rdma_params_register(struct devlink *devlink)
 {
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	union devlink_param_value value;
 	int err;
 
@@ -612,7 +624,7 @@ static int mlx5_devlink_rdma_params_register(struct devlink *devlink)
 	if (err)
 		return err;
 
-	value.vbool = true;
+	value.vbool = !mlx5_dev_is_lightweight(dev);
 	devl_param_driverinit_value_set(devlink,
 					DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
 					value);
@@ -647,7 +659,7 @@ static int mlx5_devlink_vnet_params_register(struct devlink *devlink)
 	if (err)
 		return err;
 
-	value.vbool = true;
+	value.vbool = !mlx5_dev_is_lightweight(dev);
 	devl_param_driverinit_value_set(devlink,
 					DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
 					value);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 871c32dda66e..210100a4064a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -719,7 +719,7 @@ static const struct devlink_health_reporter_ops mlx5_fw_fatal_reporter_ops = {
 #define MLX5_FW_REPORTER_VF_GRACEFUL_PERIOD 30000
 #define MLX5_FW_REPORTER_DEFAULT_GRACEFUL_PERIOD MLX5_FW_REPORTER_VF_GRACEFUL_PERIOD
 
-static void mlx5_fw_reporters_create(struct mlx5_core_dev *dev)
+void mlx5_fw_reporters_create(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
 	struct devlink *devlink = priv_to_devlink(dev);
@@ -735,17 +735,17 @@ static void mlx5_fw_reporters_create(struct mlx5_core_dev *dev)
 	}
 
 	health->fw_reporter =
-		devlink_health_reporter_create(devlink, &mlx5_fw_reporter_ops,
-					       0, dev);
+		devl_health_reporter_create(devlink, &mlx5_fw_reporter_ops,
+					    0, dev);
 	if (IS_ERR(health->fw_reporter))
 		mlx5_core_warn(dev, "Failed to create fw reporter, err = %ld\n",
 			       PTR_ERR(health->fw_reporter));
 
 	health->fw_fatal_reporter =
-		devlink_health_reporter_create(devlink,
-					       &mlx5_fw_fatal_reporter_ops,
-					       grace_period,
-					       dev);
+		devl_health_reporter_create(devlink,
+					    &mlx5_fw_fatal_reporter_ops,
+					    grace_period,
+					    dev);
 	if (IS_ERR(health->fw_fatal_reporter))
 		mlx5_core_warn(dev, "Failed to create fw fatal reporter, err = %ld\n",
 			       PTR_ERR(health->fw_fatal_reporter));
@@ -777,7 +777,8 @@ void mlx5_trigger_health_work(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
 
-	queue_work(health->wq, &health->fatal_report_work);
+	if (!mlx5_dev_is_lightweight(dev))
+		queue_work(health->wq, &health->fatal_report_work);
 }
 
 #define MLX5_MSEC_PER_HOUR (MSEC_PER_SEC * 60 * 60)
@@ -905,10 +906,15 @@ void mlx5_health_cleanup(struct mlx5_core_dev *dev)
 
 int mlx5_health_init(struct mlx5_core_dev *dev)
 {
+	struct devlink *devlink = priv_to_devlink(dev);
 	struct mlx5_core_health *health;
 	char *name;
 
-	mlx5_fw_reporters_create(dev);
+	if (!mlx5_dev_is_lightweight(dev)) {
+		devl_lock(devlink);
+		mlx5_fw_reporters_create(dev);
+		devl_unlock(devlink);
+	}
 	mlx5_reporter_vnic_create(dev);
 
 	health = &dev->priv.health;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 0faae77d84e6..6fa314f8e5ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1424,12 +1424,11 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_put_uars_page(dev, dev->priv.uar);
 }
 
-int mlx5_init_one(struct mlx5_core_dev *dev)
+int mlx5_init_one_devl_locked(struct mlx5_core_dev *dev)
 {
-	struct devlink *devlink = priv_to_devlink(dev);
+	bool light_probe = mlx5_dev_is_lightweight(dev);
 	int err = 0;
 
-	devl_lock(devlink);
 	mutex_lock(&dev->intf_state_mutex);
 	dev->state = MLX5_DEVICE_STATE_UP;
 
@@ -1443,9 +1442,14 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 		goto function_teardown;
 	}
 
-	err = mlx5_devlink_params_register(priv_to_devlink(dev));
-	if (err)
-		goto err_devlink_params_reg;
+	/* In case of light_probe, mlx5_devlink is already registered.
+	 * Hence, don't register devlink again.
+	 */
+	if (!light_probe) {
+		err = mlx5_devlink_params_register(priv_to_devlink(dev));
+		if (err)
+			goto err_devlink_params_reg;
+	}
 
 	err = mlx5_load(dev);
 	if (err)
@@ -1458,14 +1462,14 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 		goto err_register;
 
 	mutex_unlock(&dev->intf_state_mutex);
-	devl_unlock(devlink);
 	return 0;
 
 err_register:
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
 err_load:
-	mlx5_devlink_params_unregister(priv_to_devlink(dev));
+	if (!light_probe)
+		mlx5_devlink_params_unregister(priv_to_devlink(dev));
 err_devlink_params_reg:
 	mlx5_cleanup_once(dev);
 function_teardown:
@@ -1473,6 +1477,16 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 err_function:
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 	mutex_unlock(&dev->intf_state_mutex);
+	return err;
+}
+
+int mlx5_init_one(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	int err;
+
+	devl_lock(devlink);
+	err = mlx5_init_one_devl_locked(dev);
 	devl_unlock(devlink);
 	return err;
 }
@@ -1590,6 +1604,100 @@ void mlx5_unload_one(struct mlx5_core_dev *dev, bool suspend)
 	devl_unlock(devlink);
 }
 
+/* In case of light probe, we don't need a full query of hca_caps, but only the bellow caps.
+ * A full query of hca_caps will be done when the device will reload.
+ */
+static int mlx5_query_hca_caps_light(struct mlx5_core_dev *dev)
+{
+	int err;
+
+	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
+	if (err)
+		return err;
+
+	if (MLX5_CAP_GEN(dev, eth_net_offloads)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_ETHERNET_OFFLOADS);
+		if (err)
+			return err;
+	}
+
+	if (MLX5_CAP_GEN(dev, nic_flow_table) ||
+	    MLX5_CAP_GEN(dev, ipoib_enhanced_offloads)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_FLOW_TABLE);
+		if (err)
+			return err;
+	}
+
+	if (MLX5_CAP_GEN_64(dev, general_obj_types) &
+		MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_VDPA_EMULATION);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int mlx5_init_one_light(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	int err;
+
+	dev->state = MLX5_DEVICE_STATE_UP;
+	err = mlx5_function_enable(dev, true, mlx5_tout_ms(dev, FW_PRE_INIT_TIMEOUT));
+	if (err) {
+		mlx5_core_warn(dev, "mlx5_function_enable err=%d\n", err);
+		goto out;
+	}
+
+	err = mlx5_query_hca_caps_light(dev);
+	if (err) {
+		mlx5_core_warn(dev, "mlx5_query_hca_caps_light err=%d\n", err);
+		goto query_hca_caps_err;
+	}
+
+	devl_lock(devlink);
+	err = mlx5_devlink_params_register(priv_to_devlink(dev));
+	devl_unlock(devlink);
+	if (err) {
+		mlx5_core_warn(dev, "mlx5_devlink_param_reg err = %d\n", err);
+		goto query_hca_caps_err;
+	}
+
+	return 0;
+
+query_hca_caps_err:
+	mlx5_function_disable(dev, true);
+out:
+	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
+	return err;
+}
+
+void mlx5_uninit_one_light(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+
+	devl_lock(devlink);
+	mlx5_devlink_params_unregister(priv_to_devlink(dev));
+	devl_unlock(devlink);
+	if (dev->state != MLX5_DEVICE_STATE_UP)
+		return;
+	mlx5_function_disable(dev, true);
+}
+
+/* xxx_light() function are used in order to configure the device without full
+ * init (light init). e.g.: There isn't a point in reload a device to light state.
+ * Hence, mlx5_load_one_light() isn't needed.
+ */
+
+void mlx5_unload_one_light(struct mlx5_core_dev *dev)
+{
+	if (dev->state != MLX5_DEVICE_STATE_UP)
+		return;
+	mlx5_function_disable(dev, false);
+	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
+}
+
 static const int types[] = {
 	MLX5_CAP_GENERAL,
 	MLX5_CAP_GENERAL_2,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 7a5f04082058..464c6885a01c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -240,11 +240,14 @@ int mlx5_attach_device(struct mlx5_core_dev *dev);
 void mlx5_detach_device(struct mlx5_core_dev *dev, bool suspend);
 int mlx5_register_device(struct mlx5_core_dev *dev);
 void mlx5_unregister_device(struct mlx5_core_dev *dev);
+void mlx5_dev_set_lightweight(struct mlx5_core_dev *dev);
+bool mlx5_dev_is_lightweight(struct mlx5_core_dev *dev);
 struct mlx5_core_dev *mlx5_get_next_phys_dev_lag(struct mlx5_core_dev *dev);
 void mlx5_dev_list_lock(void);
 void mlx5_dev_list_unlock(void);
 int mlx5_dev_list_trylock(void);
 
+void mlx5_fw_reporters_create(struct mlx5_core_dev *dev);
 int mlx5_query_mtpps(struct mlx5_core_dev *dev, u32 *mtpps, u32 mtpps_size);
 int mlx5_set_mtpps(struct mlx5_core_dev *mdev, u32 *mtpps, u32 mtpps_size);
 int mlx5_query_mtppse(struct mlx5_core_dev *mdev, u8 pin, u8 *arm, u8 *mode);
@@ -319,11 +322,15 @@ static inline bool mlx5_core_is_sf(const struct mlx5_core_dev *dev)
 int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx);
 void mlx5_mdev_uninit(struct mlx5_core_dev *dev);
 int mlx5_init_one(struct mlx5_core_dev *dev);
+int mlx5_init_one_devl_locked(struct mlx5_core_dev *dev);
 void mlx5_uninit_one(struct mlx5_core_dev *dev);
 void mlx5_unload_one(struct mlx5_core_dev *dev, bool suspend);
 void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev, bool suspend);
 int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery);
 int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery);
+int mlx5_init_one_light(struct mlx5_core_dev *dev);
+void mlx5_uninit_one_light(struct mlx5_core_dev *dev);
+void mlx5_unload_one_light(struct mlx5_core_dev *dev);
 
 int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap, u16 vport,
 				  u16 opmod);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 0692363cf80e..8fe82f1191bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -3,6 +3,7 @@
 
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/device.h>
+#include <linux/mlx5/eswitch.h>
 #include "mlx5_core.h"
 #include "dev.h"
 #include "devlink.h"
@@ -28,6 +29,10 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 	mdev->priv.adev_idx = adev->id;
 	sf_dev->mdev = mdev;
 
+	/* Only local SFs do light probe */
+	if (MLX5_ESWITCH_MANAGER(sf_dev->parent_mdev))
+		mlx5_dev_set_lightweight(mdev);
+
 	err = mlx5_mdev_init(mdev, MLX5_SF_PROF);
 	if (err) {
 		mlx5_core_warn(mdev, "mlx5_mdev_init on err=%d\n", err);
@@ -41,7 +46,10 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 		goto remap_err;
 	}
 
-	err = mlx5_init_one(mdev);
+	if (MLX5_ESWITCH_MANAGER(sf_dev->parent_mdev))
+		err = mlx5_init_one_light(mdev);
+	else
+		err = mlx5_init_one(mdev);
 	if (err) {
 		mlx5_core_warn(mdev, "mlx5_init_one err=%d\n", err);
 		goto init_one_err;
@@ -65,7 +73,10 @@ static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
 
 	mlx5_drain_health_wq(sf_dev->mdev);
 	devlink_unregister(devlink);
-	mlx5_uninit_one(sf_dev->mdev);
+	if (mlx5_dev_is_lightweight(sf_dev->mdev))
+		mlx5_uninit_one_light(sf_dev->mdev);
+	else
+		mlx5_uninit_one(sf_dev->mdev);
 	iounmap(sf_dev->mdev->iseg);
 	mlx5_mdev_uninit(sf_dev->mdev);
 	mlx5_devlink_free(devlink);
-- 
2.40.1


