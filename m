Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4800B3E5BDB
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241691AbhHJNi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241610AbhHJNiJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:38:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1521360EE9;
        Tue, 10 Aug 2021 13:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628602667;
        bh=3F30XzjiCuima9za1pGO/IygpzGxwpDwxQ6IcD1Gfqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d54uKdcqBwcVwNJbDlLrnz2TlsCXGwlG8wR4ZEm2SsHEPFrNjJrAV85HQO1ZXwQL0
         OQe1UZ9LMq4XIBhyot87XoiSlofZayKJIBbt2ZczO97lIJiO7/Gp1NGRFO0DfpVMIH
         QSTt0jQKq0E+HdZAlGIHX6uyv2ebM2G2UJijsgCq77edwgtKEsCs93uin6hna/HSQC
         gS3c60cHuxKepUazPDccTAtfhFyHhE6RGDzbDq/GZvynZ2irVLJob/QMp6DQej3k7V
         PlhuWK0P1e5e3tC8PnbaWMK4jeIOak50QhFi405pn5NXy4Kr0EWA3GzNbxZlcAUGnY
         T1wpFedrQ4eoQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: [PATCH net-next 2/5] net/mlx4: Move devlink_register to be the last initialization command
Date:   Tue, 10 Aug 2021 16:37:32 +0300
Message-Id: <9fe3b30cc86f80881e4a1fa161dc58d4a6a2a9f1.1628599239.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628599239.git.leonro@nvidia.com>
References: <cover.1628599239.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Refactor the code to make sure that devlink_register() is the last
command during initialization stage.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 38 ++++++++++++++++-------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 7267c6c6d2e2..7005c32195a3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3996,6 +3996,8 @@ static const struct devlink_ops mlx4_devlink_ops = {
 	.reload_up	= mlx4_devlink_reload_up,
 };
 
+static void _mlx4_remove_one(struct pci_dev *pdev);
+
 static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct devlink *devlink;
@@ -4024,28 +4026,29 @@ static int mlx4_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&dev->persist->interface_state_mutex);
 	mutex_init(&dev->persist->pci_status_mutex);
 
-	ret = devlink_register(devlink);
-	if (ret)
-		goto err_persist_free;
 	ret = devlink_params_register(devlink, mlx4_devlink_params,
 				      ARRAY_SIZE(mlx4_devlink_params));
 	if (ret)
-		goto err_devlink_unregister;
+		goto err_persist_free;
 	mlx4_devlink_set_params_init_values(devlink);
 	ret =  __mlx4_init_one(pdev, id->driver_data, priv);
 	if (ret)
 		goto err_params_unregister;
 
 	devlink_params_publish(devlink);
-	devlink_reload_enable(devlink);
 	pci_save_state(pdev);
+
+	ret = devlink_register(devlink);
+	if (ret) {
+		_mlx4_remove_one(pdev);
+		return ret;
+	}
+	devlink_reload_enable(devlink);
 	return 0;
 
 err_params_unregister:
 	devlink_params_unregister(devlink, mlx4_devlink_params,
 				  ARRAY_SIZE(mlx4_devlink_params));
-err_devlink_unregister:
-	devlink_unregister(devlink);
 err_persist_free:
 	kfree(dev->persist);
 err_devlink_free:
@@ -4141,7 +4144,7 @@ static void mlx4_unload_one(struct pci_dev *pdev)
 	priv->removed = 1;
 }
 
-static void mlx4_remove_one(struct pci_dev *pdev)
+static void _mlx4_remove_one(struct pci_dev *pdev)
 {
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
 	struct mlx4_dev  *dev  = persist->dev;
@@ -4149,8 +4152,6 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(priv);
 	int active_vfs = 0;
 
-	devlink_reload_disable(devlink);
-
 	if (mlx4_is_slave(dev))
 		persist->interface_state |= MLX4_INTERFACE_STATE_NOWAIT;
 
@@ -4185,11 +4186,26 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	mlx4_pci_disable_device(dev);
 	devlink_params_unregister(devlink, mlx4_devlink_params,
 				  ARRAY_SIZE(mlx4_devlink_params));
-	devlink_unregister(devlink);
 	kfree(dev->persist);
 	devlink_free(devlink);
 }
 
+static void mlx4_remove_one(struct pci_dev *pdev)
+{
+	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
+	struct devlink *devlink;
+	struct mlx4_priv *priv;
+	struct mlx4_dev *dev;
+
+	dev = persist->dev;
+	priv = mlx4_priv(dev);
+	devlink = priv_to_devlink(priv);
+
+	devlink_reload_disable(devlink);
+	devlink_unregister(devlink);
+	_mlx4_remove_one(pdev);
+}
+
 static int restore_current_port_types(struct mlx4_dev *dev,
 				      enum mlx4_port_type *types,
 				      enum mlx4_port_type *poss_types)
-- 
2.31.1

