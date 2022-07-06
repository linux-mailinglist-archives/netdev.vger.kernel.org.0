Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE535695CE
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiGFXYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbiGFXYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:24:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7512C109
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:24:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB96861EC1
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E02C341CB;
        Wed,  6 Jul 2022 23:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149872;
        bh=JZ5JDeLwdavccmf9dp69ILOu2H3dhUsI87J3uOuJdXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvWjy72cGaFO2niIJdbcLwDpwfcvSkCT8J4neCFdpuwU3scBxQedeaqbxSLs31trr
         S6vN3g2pwDDYj2xL+jZIzFQY6DhZMQj1KEZLgkPzFLvrdpvHitEOXHDljC27S02uSa
         C8OTQ0hpOHDUnwJxrwUbY/95IuD21enG5wj8yS6BQf1lIvHVzgg1Czyobnr5kVFoQH
         jyRPcFz3Ijd07Y+xzooI50IyprtOy0minAv0rlZYb7gv4/3f5JL8rh9mymkrD42o+P
         QUv/DS5wk9XOi/ckKty1A/maGmUlcuI8CkD27DoOrK4uAfIwft8Bgklw67wS15OuPY
         OVhj4sCfc0Q7w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 07/15] net/mlx5: Use devl_ API in mlx5e_devlink_port_register
Date:   Wed,  6 Jul 2022 16:24:13 -0700
Message-Id: <20220706232421.41269-8-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706232421.41269-1-saeed@kernel.org>
References: <20220706232421.41269-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

As part of the flows invoked by mlx5_devlink_eswitch_mode_set() get to
mlx5_rescan_drivers_locked() which can call mlx5e_probe()/mlx5e_remove
and register/unregister mlx5e driver ports accordingly. This can lead to
deadlock once mlx5_devlink_eswitch_mode_set() will use devlink lock.
Use devl_port_register/unregister() instead of
devlink_port_register/unregister() and add devlink instance locks in the
driver paths to this function to have it locked while calling devl_ API
function.

If remove or probe were called by module init or module cleanup flows,
need to lock devlink just before calling devl_port_register(), otherwise
it is called by attach/detach or register/unregister flow and we can
have the flow locked. Added flag to distinguish between these cases.

This will be used by the downstream patch to invoke
mlx5_devlink_eswitch_mode_set() with devlink locked.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 29 +++++++++++++++++--
 .../ethernet/mellanox/mlx5/core/en/devlink.c  | 16 ++++++++--
 .../mellanox/mlx5/core/eswitch_offloads.c     |  2 ++
 include/linux/mlx5/driver.h                   |  4 +++
 4 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 50422b56a64d..ccf2068d2e79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -335,13 +335,16 @@ static void del_adev(struct auxiliary_device *adev)
 
 int mlx5_attach_device(struct mlx5_core_dev *dev)
 {
+	struct devlink *devlink = priv_to_devlink(dev);
 	struct mlx5_priv *priv = &dev->priv;
 	struct auxiliary_device *adev;
 	struct auxiliary_driver *adrv;
 	int ret = 0, i;
 
+	devl_lock(devlink);
 	mutex_lock(&mlx5_intf_mutex);
 	priv->flags &= ~MLX5_PRIV_FLAGS_DETACH;
+	priv->flags |= MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
 	for (i = 0; i < ARRAY_SIZE(mlx5_adev_devices); i++) {
 		if (!priv->adev[i]) {
 			bool is_supported = false;
@@ -389,19 +392,24 @@ int mlx5_attach_device(struct mlx5_core_dev *dev)
 			break;
 		}
 	}
+	priv->flags &= ~MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
 	mutex_unlock(&mlx5_intf_mutex);
+	devl_unlock(devlink);
 	return ret;
 }
 
 void mlx5_detach_device(struct mlx5_core_dev *dev)
 {
+	struct devlink *devlink = priv_to_devlink(dev);
 	struct mlx5_priv *priv = &dev->priv;
 	struct auxiliary_device *adev;
 	struct auxiliary_driver *adrv;
 	pm_message_t pm = {};
 	int i;
 
+	devl_lock(devlink);
 	mutex_lock(&mlx5_intf_mutex);
+	priv->flags |= MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
 	for (i = ARRAY_SIZE(mlx5_adev_devices) - 1; i >= 0; i--) {
 		if (!priv->adev[i])
 			continue;
@@ -430,18 +438,24 @@ void mlx5_detach_device(struct mlx5_core_dev *dev)
 		del_adev(&priv->adev[i]->adev);
 		priv->adev[i] = NULL;
 	}
+	priv->flags &= ~MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
 	priv->flags |= MLX5_PRIV_FLAGS_DETACH;
 	mutex_unlock(&mlx5_intf_mutex);
+	devl_unlock(devlink);
 }
 
 int mlx5_register_device(struct mlx5_core_dev *dev)
 {
+	struct devlink *devlink;
 	int ret;
 
+	devlink = priv_to_devlink(dev);
+	devl_lock(devlink);
 	mutex_lock(&mlx5_intf_mutex);
 	dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
 	ret = mlx5_rescan_drivers_locked(dev);
 	mutex_unlock(&mlx5_intf_mutex);
+	devl_unlock(devlink);
 	if (ret)
 		mlx5_unregister_device(dev);
 
@@ -450,10 +464,15 @@ int mlx5_register_device(struct mlx5_core_dev *dev)
 
 void mlx5_unregister_device(struct mlx5_core_dev *dev)
 {
+	struct devlink *devlink;
+
+	devlink = priv_to_devlink(dev);
+	devl_lock(devlink);
 	mutex_lock(&mlx5_intf_mutex);
 	dev->priv.flags = MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
 	mlx5_rescan_drivers_locked(dev);
 	mutex_unlock(&mlx5_intf_mutex);
+	devl_unlock(devlink);
 }
 
 static int add_drivers(struct mlx5_core_dev *dev)
@@ -526,16 +545,22 @@ static void delete_drivers(struct mlx5_core_dev *dev)
 int mlx5_rescan_drivers_locked(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
+	int err = 0;
 
 	lockdep_assert_held(&mlx5_intf_mutex);
 	if (priv->flags & MLX5_PRIV_FLAGS_DETACH)
 		return 0;
 
+	priv->flags |= MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
 	delete_drivers(dev);
 	if (priv->flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV)
-		return 0;
+		goto out;
+
+	err = add_drivers(dev);
 
-	return add_drivers(dev);
+out:
+	priv->flags &= ~MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW;
+	return err;
 }
 
 bool mlx5_same_hw_devs(struct mlx5_core_dev *dev, struct mlx5_core_dev *peer_dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index ae52e7f38306..b69f9d10ccbd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -21,6 +21,7 @@ int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 	struct netdev_phys_item_id ppid = {};
 	struct devlink_port *dl_port;
 	unsigned int dl_port_index;
+	int ret;
 
 	if (mlx5_core_is_pf(priv->mdev)) {
 		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
@@ -41,7 +42,13 @@ int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 	memset(dl_port, 0, sizeof(*dl_port));
 	devlink_port_attrs_set(dl_port, &attrs);
 
-	return devlink_port_register(devlink, dl_port, dl_port_index);
+	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW))
+		devl_lock(devlink);
+	ret = devl_port_register(devlink, dl_port, dl_port_index);
+	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW))
+		devl_unlock(devlink);
+
+	return ret;
 }
 
 void mlx5e_devlink_port_type_eth_set(struct mlx5e_priv *priv)
@@ -54,8 +61,13 @@ void mlx5e_devlink_port_type_eth_set(struct mlx5e_priv *priv)
 void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv)
 {
 	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
+	struct devlink *devlink = priv_to_devlink(priv->mdev);
 
-	devlink_port_unregister(dl_port);
+	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW))
+		devl_lock(devlink);
+	devl_port_unregister(dl_port);
+	if (!(priv->mdev->priv.flags & MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW))
+		devl_unlock(devlink);
 }
 
 struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 1bfbc88f513f..ccda3a0a2594 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3400,7 +3400,9 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		err = esw_offloads_start(esw, extack);
 	} else if (mode == DEVLINK_ESWITCH_MODE_LEGACY) {
 		err = esw_offloads_stop(esw, extack);
+		devl_lock(devlink);
 		mlx5_rescan_drivers(esw->dev);
+		devl_unlock(devlink);
 	} else {
 		err = -EINVAL;
 	}
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 76d7661e3e63..bd882884b23c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -551,6 +551,10 @@ enum {
 	 * creation/deletion on drivers rescan. Unset during device attach.
 	 */
 	MLX5_PRIV_FLAGS_DETACH = 1 << 2,
+	/* Distinguish between mlx5e_probe/remove called by module init/cleanup
+	 * and called by other flows which can already hold devlink lock
+	 */
+	MLX5_PRIV_FLAGS_MLX5E_LOCKED_FLOW = 1 << 3,
 };
 
 struct mlx5_adev {
-- 
2.36.1

