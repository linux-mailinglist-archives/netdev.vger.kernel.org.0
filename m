Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137563E977B
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhHKSSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230320AbhHKSSl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:18:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1F5460F46;
        Wed, 11 Aug 2021 18:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628705897;
        bh=SJ62LKjMYcrT7sA7hn3QzJ4cZHwbO2H182K13h5duEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXWE2yhyr2JW9GGpWn4PBgApROaE+pZqyU/E0E1YbpayUUNaOmYsJOqqbwjfa824D
         TfcYEDlIF3AJhTMVGRkYJCXcsfDgs0wiMNk+wkixicecYPXhhzDRrweg3EBs3WmNwy
         w4SRjKqWpOM0CDxjSx2ccyKzQOI8XaBBBAvumRSBQRHk/hoDl9Ip+RnIL7XUXrMoyM
         yEuAM99jvlI4gUTUBc/fTp/F4wT9Azs2u1tzCr1V5rBrCohFlnalSc7VTPdAdn4AsK
         eYqtknIEoeQ6StoAY9rkKtHMhUWtTo9sZmH/yFXcEXuBAGW/CbGOvBVT0GwW8CTBei
         /xoa1gLJk69Kg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/12] net/mlx5: Initialize numa node for all core devices
Date:   Wed, 11 Aug 2021 11:16:56 -0700
Message-Id: <20210811181658.492548-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811181658.492548-1-saeed@kernel.org>
References: <20210811181658.492548-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Subsequent patches make use of numa node affinity for memory
allocations. Initialize it for PCI PF, VF and SF devices.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 20f693cf58cc..6df4b940473b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -748,14 +748,12 @@ static int mlx5_core_set_issi(struct mlx5_core_dev *dev)
 static int mlx5_pci_init(struct mlx5_core_dev *dev, struct pci_dev *pdev,
 			 const struct pci_device_id *id)
 {
-	struct mlx5_priv *priv = &dev->priv;
 	int err = 0;
 
 	mutex_init(&dev->pci_status_mutex);
 	pci_set_drvdata(dev->pdev, dev);
 
 	dev->bar_addr = pci_resource_start(pdev, 0);
-	priv->numa_node = dev_to_node(mlx5_core_dma_dev(dev));
 
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
@@ -1448,6 +1446,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	mutex_init(&priv->pgdir_mutex);
 	INIT_LIST_HEAD(&priv->pgdir_list);
 
+	priv->numa_node = dev_to_node(mlx5_core_dma_dev(dev));
 	priv->dbg_root = debugfs_create_dir(dev_name(dev->device),
 					    mlx5_debugfs_root);
 	INIT_LIST_HEAD(&priv->traps);
-- 
2.31.1

