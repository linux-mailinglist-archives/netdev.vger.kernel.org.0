Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112C72F07DD
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbhAJPI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:08:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbhAJPI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 10:08:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66C6C2376F;
        Sun, 10 Jan 2021 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610291270;
        bh=DgJ+DRd9s1+JT9CSIpA0ZmO+Ye6+Ufzeym0pWE+e8V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZQLZ5Gh4NpYdvhsCmEyJPaSYHHFrQqyE7TklHuhQjiXGxDJSV6Vij1auwwoMt4CY
         ofn+avlLghb3wKUVBf1+nmYU10BvheGKJWqkPa7h8k7q+LnoS7UDYHjGt2tREgmS9k
         5SgiXGcb06unEfmklcpDHJLNiFckHEGY4+Zvg3pnkB3I4HNNFN/mRdqKngKR9Nm/k2
         R2wP9sgx3eCrm4uC1PunoiBqzZ679Ui/C5ZUz2+EoI6i0/g8Eoofyyv+Im9Qkq/+Gk
         c6ytsqDBH2rMDMyas88N0SfmJNkb/E8gz9oOudWUGynhoIBKGIJMqq9lu6UzsunNju
         EK9uNMaeooAtg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH mlx5-next v1 5/5] net/mlx5: Allow to the users to configure number of MSI-X vectors
Date:   Sun, 10 Jan 2021 17:07:27 +0200
Message-Id: <20210110150727.1965295-6-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210110150727.1965295-1-leon@kernel.org>
References: <20210110150727.1965295-1-leon@kernel.org>
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
index c59efb1e7a26..88b271ca34c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -145,6 +145,7 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 {
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
+	int num_vf_msix;
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

