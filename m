Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E6D3278B9
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 08:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbhCAH4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 02:56:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232667AbhCAH40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 02:56:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86D1D64E07;
        Mon,  1 Mar 2021 07:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614585345;
        bh=6jbR/g8lnPSYfYd6clhLRSU3f9gv2FXW+ON1HPxHbvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjI085ZeP/hpPX/cwgr9O9qawfBqr+ON7rddcycbhu2OSu15f5q/95kXrGmTELK4d
         KfqCHjZUnnJ+g3i/oSJmDfn5bOTif0zpsDMbtyYYEDeApnXrUO8nrF1jCgBa+ItpCR
         7aklGRINJRwrFbOcXp1lj02GdOtSZQDelrLDiJ9Fi27prbiRHqiTX4Fnd4t94zpaNc
         vsKXKp0PzNB+tSJF40xP4i/XTyAAzDm/YxCoOoZiZD2vuZwCSxr8Qc8ZqXPXKKBvOO
         ydWrdXhmPazn3yJEj7QGDDOFt5MDZbXXE3SqwaqdZErgpZ4EUVSv5yAGA7nxRF+1sg
         yw2ycDIo2Vw3w==
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
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH mlx5-next v7 4/4] net/mlx5: Implement sriov_get_vf_total_msix/count() callbacks
Date:   Mon,  1 Mar 2021 09:55:24 +0200
Message-Id: <20210301075524.441609-5-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210301075524.441609-1-leon@kernel.org>
References: <20210301075524.441609-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The mlx5 implementation executes a firmware command on the PF to change
the configuration of the selected VF.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    |  2 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  7 ++++
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 35 +++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 0489712865b7..edca6bc87639 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1700,6 +1700,8 @@ static struct pci_driver mlx5_core_driver = {
 	.shutdown	= shutdown,
 	.err_handler	= &mlx5_err_handler,
 	.sriov_configure   = mlx5_core_sriov_configure,
+	.sriov_get_vf_total_msix = mlx5_sriov_get_vf_total_msix,
+	.sriov_set_msix_vec_count = mlx5_core_sriov_set_msix_vec_count,
 };

 static void mlx5_core_verify_params(void)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index f0aed664dd35..99007f2d0424 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -140,6 +140,7 @@ void mlx5_sriov_cleanup(struct mlx5_core_dev *dev);
 int mlx5_sriov_attach(struct mlx5_core_dev *dev);
 void mlx5_sriov_detach(struct mlx5_core_dev *dev);
 int mlx5_core_sriov_configure(struct pci_dev *dev, int num_vfs);
+int mlx5_core_sriov_set_msix_vec_count(struct pci_dev *vf, int msix_vec_count);
 int mlx5_core_enable_hca(struct mlx5_core_dev *dev, u16 func_id);
 int mlx5_core_disable_hca(struct mlx5_core_dev *dev, u16 func_id);
 int mlx5_create_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
@@ -278,4 +279,10 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot);
 int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out);

 void mlx5_events_work_enqueue(struct mlx5_core_dev *dev, struct work_struct *work);
+static inline u32 mlx5_sriov_get_vf_total_msix(struct pci_dev *pdev)
+{
+	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+
+	return MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix);
+}
 #endif /* __MLX5_CORE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index f0ec86a1c8a6..2338989d4403 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -187,6 +187,41 @@ int mlx5_core_sriov_configure(struct pci_dev *pdev, int num_vfs)
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

