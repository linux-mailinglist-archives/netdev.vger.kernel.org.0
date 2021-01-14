Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1C02F5ED0
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbhANKcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:32:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbhANKck (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 05:32:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E88023A53;
        Thu, 14 Jan 2021 10:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610620320;
        bh=VsVf4idM5BrmgksBO9HleBJBpXijVbXMivAGlcSUC9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NC21mz0/UZI6v9hfNot36B4RSg2EAFffjHy+vIYgo8P1DOMRMibxh2FY++Wjn3bNR
         632wwInKE18FXn5gKwvLcWXpnSX8UqneWhylKWi7ZTxQLJGXld0G5Y8xV6FsZ7PxaI
         ZKo7wy+k4GZCQGCmDkpOQ8DsILUg1uCoZY3GklLsGF2bRrzS2Pa5q9EjfEeDIpWgK/
         iubS0OveNqHttyKwdiu3/6KpzUjxItLagmaGtDjpN0iUZZ8aQmvlechTMdYgta654P
         Bg9WjINA4bHC8kK3ZSYvj5IErYgij83ItGeqo3NYypzJTdWQBssjpiroUg5h9j0oTd
         r7Yr0NVQZWcHw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH mlx5-next v2 5/5] net/mlx5: Allow to the users to configure number of MSI-X vectors
Date:   Thu, 14 Jan 2021 12:31:40 +0200
Message-Id: <20210114103140.866141-6-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210114103140.866141-1-leon@kernel.org>
References: <20210114103140.866141-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Implement ability to configure MSI-X for the SR-IOV VFs.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    |  1 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  1 +
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  4 +-
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 38 +++++++++++++++++++
 4 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 8269cfbfc69d..334b3b5077c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1647,6 +1647,7 @@ static struct pci_driver mlx5_core_driver = {
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 135078e8dd55..65a761346385 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -59,7 +59,7 @@ int mlx5_get_default_msix_vec_count(struct mlx5_core_dev *dev, int num_vfs)
 {
 	int num_vf_msix, min_msix, max_msix;
 
-	num_vf_msix = MLX5_CAP_GEN(dev, num_total_dynamic_vf_msix);
+	num_vf_msix = MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix);
 	if (!num_vf_msix)
 		return 0;
 
@@ -83,7 +83,7 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 	void *hca_cap, *cap;
 	int ret;
 
-	num_vf_msix = MLX5_CAP_GEN(dev, num_total_dynamic_vf_msix);
+	num_vf_msix = MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix);
 	if (!num_vf_msix)
 		return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index c59efb1e7a26..adc7c8945b9d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -145,6 +145,7 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 {
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
+	u32 num_vf_msix;
 	int err;
 
 	err = mlx5_device_enable_sriov(dev, num_vfs);
@@ -153,6 +154,8 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 		return err;
 	}
 
+	num_vf_msix = MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix);
+	pci_sriov_set_vf_total_msix(pdev, num_vf_msix);
 	err = pci_enable_sriov(pdev, num_vfs);
 	if (err) {
 		mlx5_core_warn(dev, "pci_enable_sriov failed : %d\n", err);
@@ -188,6 +191,41 @@ int mlx5_core_sriov_configure(struct pci_dev *pdev, int num_vfs)
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

