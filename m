Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702F5315058
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 14:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhBINfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 08:35:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231366AbhBINfm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 08:35:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58C3664ED3;
        Tue,  9 Feb 2021 13:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612877701;
        bh=5UrSrnNscVpnQ6QiFa+BRdHDIDUqHAl3HAvZrkWu1bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1dJbvjGVX4F19Qfsn9BWW9HObeyv44PioLJqp2/uFDMTJWghqkfhM8UGdbPsjt+D
         FcwEMVgaaO2BNlSm1oYddBH7RkEyYeVGfl8woRJeJVpz3l2d4LnbBeAClWBCO5p4br
         EEuutMh901fGS2a+s6nfLNNp+ZYlNIp6Cs+oX47zHCmSsiXZXZPGmt9pxCassMi5jM
         OYYEfNUuvPWl/cc8yGmnik9Bgu+nMHNqGU4HwZ0fx0lklm6kH/MbnYn8BMO36F97mp
         oB8YQlO+WQs4CqNM9N346TajHxSGJGkHnvP/8SNvxGyBzLD7QarC4/sKrfqXuRhZy1
         W155lIOxxwirw==
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
Subject: [PATCH mlx5-next v6 4/4] net/mlx5: Allow to the users to configure number of MSI-X vectors
Date:   Tue,  9 Feb 2021 15:34:45 +0200
Message-Id: <20210209133445.700225-5-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210209133445.700225-1-leon@kernel.org>
References: <20210209133445.700225-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Implement ability to configure MSI-X for the SR-IOV VFs.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 13 ++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   | 22 +++++++++
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 45 +++++++++++++++++++
 3 files changed, 80 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 79cfcc844156..db59c51e148e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1395,6 +1395,14 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_load_one;
 	}
 
+	err = mlx5_enable_vf_overlay(dev);
+	if (err) {
+		mlx5_core_err(dev,
+			      "mlx5_enable_vf_overlay failed with error code %d\n",
+			      err);
+		goto err_vf_overlay;
+	}
+
 	err = mlx5_crdump_enable(dev);
 	if (err)
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
@@ -1403,6 +1411,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	devlink_reload_enable(devlink);
 	return 0;
 
+err_vf_overlay:
+	mlx5_unload_one(dev, true);
 err_load_one:
 	mlx5_pci_close(dev);
 pci_init_err:
@@ -1423,6 +1433,7 @@ static void remove_one(struct pci_dev *pdev)
 	devlink_reload_disable(devlink);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
+	mlx5_disable_vf_overlay(dev);
 	mlx5_unload_one(dev, true);
 	mlx5_pci_close(dev);
 	mlx5_mdev_uninit(dev);
@@ -1650,6 +1661,8 @@ static struct pci_driver mlx5_core_driver = {
 	.shutdown	= shutdown,
 	.err_handler	= &mlx5_err_handler,
 	.sriov_configure   = mlx5_core_sriov_configure,
+	.sriov_get_vf_total_msix = mlx5_sriov_get_vf_total_msix,
+	.sriov_set_msix_vec_count = mlx5_core_sriov_set_msix_vec_count,
 };
 
 static void mlx5_core_verify_params(void)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 5babb4434a87..e5c2fa558f77 100644
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
@@ -264,4 +265,25 @@ void mlx5_set_nic_state(struct mlx5_core_dev *dev, u8 state);
 
 void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup);
 int mlx5_load_one(struct mlx5_core_dev *dev, bool boot);
+
+static inline int mlx5_enable_vf_overlay(struct mlx5_core_dev *dev)
+{
+	if (MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix))
+		return pci_enable_vf_overlay(dev->pdev);
+
+	return 0;
+}
+
+static inline void mlx5_disable_vf_overlay(struct mlx5_core_dev *dev)
+{
+	if (MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix))
+		pci_disable_vf_overlay(dev->pdev);
+}
+
+static inline u32 mlx5_sriov_get_vf_total_msix(struct pci_dev *pdev)
+{
+	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+
+	return MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix);
+}
 #endif /* __MLX5_CORE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index f0ec86a1c8a6..446bfdfce4a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -156,6 +156,15 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	if (err) {
 		mlx5_core_warn(dev, "pci_enable_sriov failed : %d\n", err);
 		mlx5_device_disable_sriov(dev, num_vfs, true);
+		return err;
+	}
+
+	err = mlx5_enable_vf_overlay(dev);
+	if (err) {
+		mlx5_core_warn(dev, "mlx5_enable_vf_overlay failed : %d\n",
+			       err);
+		pci_disable_sriov(pdev);
+		mlx5_device_disable_sriov(dev, num_vfs, true);
 	}
 	return err;
 }
@@ -165,6 +174,7 @@ static void mlx5_sriov_disable(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	int num_vfs = pci_num_vf(dev->pdev);
 
+	mlx5_disable_vf_overlay(dev);
 	pci_disable_sriov(pdev);
 	mlx5_device_disable_sriov(dev, num_vfs, true);
 }
@@ -187,6 +197,41 @@ int mlx5_core_sriov_configure(struct pci_dev *pdev, int num_vfs)
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

