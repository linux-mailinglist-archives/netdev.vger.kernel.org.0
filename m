Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7C0301C0E
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 14:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbhAXNMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 08:12:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726929AbhAXNMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 08:12:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D152B22D0A;
        Sun, 24 Jan 2021 13:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611493894;
        bh=LECEB+cDh+iV4QGXRsrdF1G4GB6HAY18qykra5sbqcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGJGjud7gl0+DJMXiew+c95XobkH3bIK15ktSBSnWXItEqc3u1zUEt/2d3UonH+IH
         0jizC1+T1whqBzEudBgjBww00NXKj3F3gpypqjBCvGM0oeiJzuCDOsTf/DZVFJJHhb
         FF8jNlCa+twhOoDu2YZYmvwu6CLlyBuA4L/JlvWNmaYuZ9xaDf9YrFsStsOUdEqZL1
         xxEed1i68WqGkzTaM3JAydi49yCq2EU7Y0H8x8qKD2defoeYQGSGgYSqgkJT6vE530
         BSJzTHzE+eGwl7ewdAUOVjGVuUpXnBtmaHVpADqBZRXcxqvl7ZJn1vaULXtOQbEQpl
         j/+A5uiA3dB/w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH mlx5-next v4 4/4] net/mlx5: Allow to the users to configure number of MSI-X vectors
Date:   Sun, 24 Jan 2021 15:11:19 +0200
Message-Id: <20210124131119.558563-5-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210124131119.558563-1-leon@kernel.org>
References: <20210124131119.558563-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Implement ability to configure MSI-X for the SR-IOV VFs.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 12 +++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  1 +
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 46 +++++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 79cfcc844156..228765c38cf8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1395,6 +1395,14 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_load_one;
 	}
 
+	err = pci_enable_vfs_overlay(pdev);
+	if (err) {
+		mlx5_core_err(dev,
+			      "pci_enable_vfs_overlay failed with error code %d\n",
+			      err);
+		goto err_vfs_overlay;
+	}
+
 	err = mlx5_crdump_enable(dev);
 	if (err)
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
@@ -1403,6 +1411,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	devlink_reload_enable(devlink);
 	return 0;
 
+err_vfs_overlay:
+	mlx5_unload_one(dev, true);
 err_load_one:
 	mlx5_pci_close(dev);
 pci_init_err:
@@ -1422,6 +1432,7 @@ static void remove_one(struct pci_dev *pdev)
 
 	devlink_reload_disable(devlink);
 	mlx5_crdump_disable(dev);
+	pci_disable_vfs_overlay(pdev);
 	mlx5_drain_health_wq(dev);
 	mlx5_unload_one(dev, true);
 	mlx5_pci_close(dev);
@@ -1650,6 +1661,7 @@ static struct pci_driver mlx5_core_driver = {
 	.shutdown	= shutdown,
 	.err_handler	= &mlx5_err_handler,
 	.sriov_configure   = mlx5_core_sriov_configure,
+	.sriov_set_msix_vec_count = mlx5_core_sriov_set_msix_vec_count,
 };
 
 static void mlx5_core_verify_params(void)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 5babb4434a87..8a2523d2d43a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -138,6 +138,7 @@ void mlx5_sriov_cleanup(struct mlx5_core_dev *dev);
 int mlx5_sriov_attach(struct mlx5_core_dev *dev);
 void mlx5_sriov_detach(struct mlx5_core_dev *dev);
 int mlx5_core_sriov_configure(struct pci_dev *dev, int num_vfs);
+int mlx5_core_sriov_set_msix_vec_count(struct pci_dev *vf, int msix_vec_count);
 int mlx5_core_enable_hca(struct mlx5_core_dev *dev, u16 func_id);
 int mlx5_core_disable_hca(struct mlx5_core_dev *dev, u16 func_id);
 int mlx5_create_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index f0ec86a1c8a6..252aa44ffbe3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -144,6 +144,7 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 {
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
+	u32 num_vf_msix;
 	int err;
 
 	err = mlx5_device_enable_sriov(dev, num_vfs);
@@ -152,11 +153,20 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 		return err;
 	}
 
+	num_vf_msix = MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix);
+	pci_sriov_set_vf_total_msix(pdev, num_vf_msix);
 	err = pci_enable_sriov(pdev, num_vfs);
 	if (err) {
 		mlx5_core_warn(dev, "pci_enable_sriov failed : %d\n", err);
 		mlx5_device_disable_sriov(dev, num_vfs, true);
 	}
+	err = pci_enable_vfs_overlay(pdev);
+	if (err) {
+		mlx5_core_warn(dev, "pci_enable_vfs_overlay failed : %d\n",
+			       err);
+		pci_disable_sriov(pdev);
+		mlx5_device_disable_sriov(dev, num_vfs, true);
+	}
 	return err;
 }
 
@@ -165,6 +175,7 @@ static void mlx5_sriov_disable(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	int num_vfs = pci_num_vf(dev->pdev);
 
+	pci_disable_vfs_overlay(pdev);
 	pci_disable_sriov(pdev);
 	mlx5_device_disable_sriov(dev, num_vfs, true);
 }
@@ -187,6 +198,41 @@ int mlx5_core_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	return err ? err : num_vfs;
 }
 
+int mlx5_core_sriov_set_msix_vec_count(struct pci_dev *vf, int msix_vec_count)
+{
+	struct pci_dev *pf = pci_physfn(vf);
+	struct mlx5_core_sriov *sriov;
+	struct mlx5_core_dev *dev;
+	int num_vf_msix, id;
+
+	dev = pci_get_drvdata(pf);
+	num_vf_msix = MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix);
+	if (!num_vf_msix)
+		return -EOPNOTSUPP;
+
+	if (!msix_vec_count)
+		msix_vec_count =
+			mlx5_get_default_msix_vec_count(dev, pci_num_vf(pf));
+
+	sriov = &dev->priv.sriov;
+
+	/* Reversed translation of PCI VF function number to the internal
+	 * function_id, which exists in the name of virtfn symlink.
+	 */
+	for (id = 0; id < pci_num_vf(pf); id++) {
+		if (!sriov->vfs_ctx[id].enabled)
+			continue;
+
+		if (vf->devfn == pci_iov_virtfn_devfn(pf, id))
+			break;
+	}
+
+	if (id == pci_num_vf(pf) || !sriov->vfs_ctx[id].enabled)
+		return -EINVAL;
+
+	return mlx5_set_msix_vec_count(dev, id + 1, msix_vec_count);
+}
+
 int mlx5_sriov_attach(struct mlx5_core_dev *dev)
 {
 	if (!mlx5_core_is_pf(dev) || !pci_num_vf(dev->pdev))
-- 
2.29.2

