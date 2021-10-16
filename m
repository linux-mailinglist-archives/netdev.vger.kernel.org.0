Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7307342FF7D
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239376AbhJPAl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239347AbhJPAlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8767661248;
        Sat, 16 Oct 2021 00:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634344748;
        bh=C+2QwhJFo+eBLg2b98ZR0WRy+s4YWk9TjMlBQi9e5tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyDnW0qTSxTAkpbHY/14kHGX4QVNIjklOZpXWVVTOCMiJ0OdEPhc9/m02R4QFQ0hQ
         rjKglCnrDD1Ee57F6irk25XVwTQc4ni6DmFXqX7o6q7LZidVO+3+rvSCW9SscTkibj
         T6hMOkLpTO35zAJ861g2mGK12CRbSw29yzQ6DLTzEFui/sBpC5MY073t6fWyTFb6vm
         dwfPj1prIz8HpDLiz1EhjXIQI5i7/RO9eBGQfJXBqLJ7XrC6UarerBPVbp5RUxjq4+
         WC7q39BQl8wTtdEtgEFOHxXyMSiGBkUbcDxLx8d/l8gGzYyJ3yH9U7cBQrprLAH37T
         YtczBmOnVKp4g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Rongwei Liu <rongweil@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/13] net/mlx5: Introduce new device index wrapper
Date:   Fri, 15 Oct 2021 17:39:00 -0700
Message-Id: <20211016003902.57116-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211016003902.57116-1-saeed@kernel.org>
References: <20211016003902.57116-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rongwei Liu <rongweil@nvidia.com>

Downstream patches.

Signed-off-by: Rongwei Liu <rongweil@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c       | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c              | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c       | 2 +-
 include/linux/mlx5/driver.h                                | 5 +++++
 6 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index 86e079310ac3..ae52e7f38306 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -24,7 +24,7 @@ int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 
 	if (mlx5_core_is_pf(priv->mdev)) {
 		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
-		attrs.phys.port_number = PCI_FUNC(priv->mdev->pdev->devfn);
+		attrs.phys.port_number = mlx5_get_dev_index(priv->mdev);
 		if (MLX5_ESWITCH_MANAGER(priv->mdev)) {
 			mlx5e_devlink_get_port_parent_id(priv->mdev, &ppid);
 			memcpy(attrs.switch_id.id, ppid.id, ppid.id_len);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 20af557ae30c..7f9b96d9537e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -36,7 +36,7 @@ static struct devlink_port *mlx5_esw_dl_port_alloc(struct mlx5_eswitch *esw, u16
 		return NULL;
 
 	mlx5_esw_get_port_parent_id(dev, &ppid);
-	pfnum = PCI_FUNC(dev->pdev->devfn);
+	pfnum = mlx5_get_dev_index(dev);
 	external = mlx5_core_is_ecpf_esw_manager(dev);
 	if (external)
 		controller_num = dev->priv.eswitch->offloads.host_number + 1;
@@ -149,7 +149,7 @@ int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_p
 	if (IS_ERR(vport))
 		return PTR_ERR(vport);
 
-	pfnum = PCI_FUNC(dev->pdev->devfn);
+	pfnum = mlx5_get_dev_index(dev);
 	mlx5_esw_get_port_parent_id(dev, &ppid);
 	memcpy(dl_port->attrs.switch_id.id, &ppid.id[0], ppid.id_len);
 	dl_port->attrs.switch_id.id_len = ppid.id_len;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index ca7e31a1a431..3e5a7d74020b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2798,7 +2798,7 @@ u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
 	int id;
 
 	/* Only 4 bits of pf_num */
-	pf_num = PCI_FUNC(esw->dev->pdev->devfn);
+	pf_num = mlx5_get_dev_index(esw->dev);
 	if (pf_num > max_pf_num)
 		return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index ca5690b0a7ab..f35c8ba48aac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -688,7 +688,7 @@ static void mlx5_ldev_add_netdev(struct mlx5_lag *ldev,
 				 struct mlx5_core_dev *dev,
 				 struct net_device *netdev)
 {
-	unsigned int fn = PCI_FUNC(dev->pdev->devfn);
+	unsigned int fn = mlx5_get_dev_index(dev);
 
 	if (fn >= MLX5_MAX_PORTS)
 		return;
@@ -718,7 +718,7 @@ static void mlx5_ldev_remove_netdev(struct mlx5_lag *ldev,
 static void mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
 			       struct mlx5_core_dev *dev)
 {
-	unsigned int fn = PCI_FUNC(dev->pdev->devfn);
+	unsigned int fn = mlx5_get_dev_index(dev);
 
 	if (fn >= MLX5_MAX_PORTS)
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 13891fdc607e..e1bb3acf45e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -323,7 +323,7 @@ mlx5_sf_new_check_attr(struct mlx5_core_dev *dev, const struct devlink_port_new_
 		NL_SET_ERR_MSG_MOD(extack, "External controller is unsupported");
 		return -EOPNOTSUPP;
 	}
-	if (new_attr->pfnum != PCI_FUNC(dev->pdev->devfn)) {
+	if (new_attr->pfnum != mlx5_get_dev_index(dev)) {
 		NL_SET_ERR_MSG_MOD(extack, "Invalid pfnum supplied");
 		return -EOPNOTSUPP;
 	}
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 7c8b5f06c2cd..aecc38b90de5 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1243,6 +1243,11 @@ static inline int mlx5_core_native_port_num(struct mlx5_core_dev *dev)
 	return MLX5_CAP_GEN(dev, native_port_num);
 }
 
+static inline int mlx5_get_dev_index(struct mlx5_core_dev *dev)
+{
+	return PCI_FUNC(dev->pdev->devfn);
+}
+
 enum {
 	MLX5_TRIGGERED_CMD_COMP = (u64)1 << 32,
 };
-- 
2.31.1

