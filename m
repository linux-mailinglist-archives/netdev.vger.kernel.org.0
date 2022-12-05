Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C928F642B9E
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiLEP0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbiLEPZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:25:57 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0771D12B
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 07:23:13 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id fc4so21682077ejc.12
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 07:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1fQOzQmdtJtJphV1WnJCoypGLDQ/TQpRvNat9pQyTmA=;
        b=auPwTUmpjzATv6rnR72FLaYGmGZvyQ5Z61dWRmYm63PpPAZDZ99+9iyNSWMh3Vrk/A
         W88RDAuOjVuHH8ddvR0h1F/PcyITXx+vxUXnAmCZwswnO52Cfqb+6Nb7VCG+7lXWXPqJ
         dU/Fn8y08UfpcRQUC5xvb7TNz7aXZr63pKAaA8OMaI6zWLrRiDJ+ZwArF0lmVdzLGsn3
         izfWzFCuaXECa9pAutJn7XRy+yDZV4mDOzt7ngf8XWhzGWaTLQh+r1/EZzkYpci7Uoof
         5Eczfx64Go6vuVxna+h4r2wlzSdQiwGH+eOMmpIJNnNRldahrVle9AqSQmYSJVFa+/Fd
         y4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1fQOzQmdtJtJphV1WnJCoypGLDQ/TQpRvNat9pQyTmA=;
        b=qpfR3VGlCsjzt+aCgarFU1yTCZzAXEjOG8xvVvaQGihzg2L0GPlRQeJzraHqa3qx7p
         BtwQO+KIAc4hGvevagzWeE7TaORmNdjqg6udlNmuQ4VPhW/g5dSEi811HC0yDg7Fn61q
         OUn6OM/d/k2rb5TsMhfIyA32dL3+5i0EkGTUg3CuzTcORkd1F2lv18Hp7NEULYvsFQ1y
         znepOZL5yI7eKrXI38Cgk8EEUhiTvkxNnp0L4yFsUU/PXG/u43k29cGrUB1aSr3nIjqO
         Eu0xJHGRiEJY2apJYtKhplZ27s2BmzrfTO4gIzM2urvKcFMydQtwdyW9Dh9QgiX3Zc8z
         sITg==
X-Gm-Message-State: ANoB5pkcImPlxY9KYem910XdK0lwd8oWyGjnFZ8GwFp9QOjfBSUJW/pJ
        xZteiShvqci+Wv6bvdt/Tc7OjtVLDyYW2urZl7GoDA==
X-Google-Smtp-Source: AA0mqf7xFLWAKOTZAQA7+bM2vJp0uu8oSAkXzQ43ZzOngA/RmL2stXpBWf7aFoGGzbCUOE+l7l+J1g==
X-Received: by 2002:a17:906:2851:b0:78d:88c7:c1bf with SMTP id s17-20020a170906285100b0078d88c7c1bfmr54349568ejc.299.1670253792222;
        Mon, 05 Dec 2022 07:23:12 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id fi22-20020a1709073ad600b007c0d4d3a0c1sm3151745ejc.32.2022.12.05.07.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 07:23:11 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
Subject: [patch net-next 6/8] mlx5: call devl_port_register/unregister() on registered instance
Date:   Mon,  5 Dec 2022 16:22:55 +0100
Message-Id: <20221205152257.454610-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205152257.454610-1-jiri@resnulli.us>
References: <20221205152257.454610-1-jiri@resnulli.us>
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

Move the code so devl_port_register/unregister() are called only
then devlink is registered.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->v1:
- shortened patch subject
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c   | 10 ++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c  | 17 ++++++++++-------
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c |  9 +++++++++
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 0571e40c6ee5..dd3801198898 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -444,11 +444,14 @@ int mlx5_register_device(struct mlx5_core_dev *dev)
 {
 	int ret;
 
-	devl_assert_locked(priv_to_devlink(dev));
+	devl_lock(priv_to_devlink(dev));
+	mutex_lock(&dev->intf_state_mutex);
 	mutex_lock(&mlx5_intf_mutex);
 	dev->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
 	ret = mlx5_rescan_drivers_locked(dev);
 	mutex_unlock(&mlx5_intf_mutex);
+	mutex_unlock(&dev->intf_state_mutex);
+	devl_unlock(priv_to_devlink(dev));
 	if (ret)
 		mlx5_unregister_device(dev);
 
@@ -457,11 +460,14 @@ int mlx5_register_device(struct mlx5_core_dev *dev)
 
 void mlx5_unregister_device(struct mlx5_core_dev *dev)
 {
-	devl_assert_locked(priv_to_devlink(dev));
+	devl_lock(priv_to_devlink(dev));
+	mutex_lock(&dev->intf_state_mutex);
 	mutex_lock(&mlx5_intf_mutex);
 	dev->priv.flags = MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
 	mlx5_rescan_drivers_locked(dev);
 	mutex_unlock(&mlx5_intf_mutex);
+	mutex_unlock(&dev->intf_state_mutex);
+	devl_unlock(priv_to_devlink(dev));
 }
 
 static int add_drivers(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 7f5db13e3550..f6f37289b49d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1392,16 +1392,10 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 	if (err)
 		goto err_devlink_reg;
 
-	err = mlx5_register_device(dev);
-	if (err)
-		goto err_register;
-
 	mutex_unlock(&dev->intf_state_mutex);
 	devl_unlock(devlink);
 	return 0;
 
-err_register:
-	mlx5_devlink_unregister(priv_to_devlink(dev));
 err_devlink_reg:
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
@@ -1423,7 +1417,6 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 	devl_lock(devlink);
 	mutex_lock(&dev->intf_state_mutex);
 
-	mlx5_unregister_device(dev);
 	mlx5_devlink_unregister(priv_to_devlink(dev));
 
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
@@ -1747,8 +1740,17 @@ static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_save_state(pdev);
 	devlink_register(devlink);
+	err = mlx5_register_device(dev);
+	if (err) {
+		mlx5_core_err(dev, "mlx5_register_device failed with error code %d\n",
+			      err);
+		goto err_register_device;
+	}
+
 	return 0;
 
+err_register_device:
+	devlink_unregister(devlink);
 err_init_one:
 	mlx5_pci_close(dev);
 pci_init_err:
@@ -1771,6 +1773,7 @@ static void remove_one(struct pci_dev *pdev)
 	 */
 	mlx5_drain_fw_reset(dev);
 	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
+	mlx5_unregister_device(dev);
 	devlink_unregister(devlink);
 	mlx5_sriov_disable(pdev);
 	mlx5_crdump_disable(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 7b4783ce213e..90fcb30f7481 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -46,9 +46,17 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 		mlx5_core_warn(mdev, "mlx5_init_one err=%d\n", err);
 		goto init_one_err;
 	}
+
 	devlink_register(devlink);
+
+	err = mlx5_register_device(mdev);
+	if (err)
+		goto register_device_err;
+
 	return 0;
 
+register_device_err:
+	devlink_unregister(devlink);
 init_one_err:
 	iounmap(mdev->iseg);
 remap_err:
@@ -63,6 +71,7 @@ static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
 	struct mlx5_sf_dev *sf_dev = container_of(adev, struct mlx5_sf_dev, adev);
 	struct devlink *devlink = priv_to_devlink(sf_dev->mdev);
 
+	mlx5_unregister_device(sf_dev->mdev);
 	devlink_unregister(devlink);
 	mlx5_uninit_one(sf_dev->mdev);
 	iounmap(sf_dev->mdev->iseg);
-- 
2.37.3

