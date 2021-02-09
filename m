Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAE4315055
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 14:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhBINfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 08:35:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231347AbhBINfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 08:35:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E831664ED5;
        Tue,  9 Feb 2021 13:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612877697;
        bh=9lDu3DmFqXRm5A+A6HYfkgkN6t0kzXRQ3a3T6gFHNm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jDnxPuIasKzBOxdlDI8GWMKGPtau38aFJy4k7tTrt8cejUeeJSXEql7j0NL+2HBYB
         qcyxDKEE4JGaI0RHXDDd3unUbrA9R9V1JpBjuZ3tq+tZ7BEpniy3fUs7GKnmPUu065
         rZWNUUB27mmemlvZpHRrbleXhOylEjIKcRGsevRmzWKVAO9sQjYGrTWD7cTzCVBG6L
         gFk/ANtlBcuToWik2p/KCStV/sFru3vTxROd4N8BtOMh/xQh8H/ekOtCI8GK3xQRlt
         OWo71PUfFmHBNp+JuMdvMk9QshBpzn3Q1N0Ij0eTL0P+5fGc5KTE97VDQ/3TNqQdGa
         GzwMkl0zkn3iw==
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
Subject: [PATCH mlx5-next v6 3/4] net/mlx5: Dynamically assign MSI-X vectors count
Date:   Tue,  9 Feb 2021 15:34:44 +0200
Message-Id: <20210209133445.700225-4-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210209133445.700225-1-leon@kernel.org>
References: <20210209133445.700225-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The number of MSI-X vectors is PCI property visible through lspci that
field is read-only and configured by the device. The mlx5 devices work
in two possible modes: static assignment or dynamic.

Static assignment means that all newly created VFs have a stable number of
MSI-X vectors. Such partitioning doesn't utilize the newly created VF
because it is unknown to the device the future load and configuration
where that VF will be used.

The second mode is a dynamic assignment and provided to overcome the
inefficiency in the spread of such MSI-X vectors. It allows the kernel
to convey a new number of vectors based on the administrator's knowledge.

For example: if VF is bound to a powerful VM with many CPUs, the administrator
will configure a larger number of MSI-X vectors than in static mode. It will
utilize the mlx5 device efficiently.

The assignment is performed before the driver is probed on that VF.

Due to the internal to mlx5 implementation, the device provides more dynamic
vectors than static vectors. In this patch, we enable this feature, and such
change immediately increases the amount of MSI-X vectors for the system with
2 VFs from 12 vectors, to be 32 vectors per-VF.

Before this patch:
[root@server ~]# lspci -vs 0000:08:00.2
08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
....
	Capabilities: [9c] MSI-X: Enable- Count=12 Masked-

After this patch:
[root@server ~]# lspci -vs 0000:08:00.2
08:00.2 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5 Virtual Function]
....
	Capabilities: [9c] MSI-X: Enable- Count=32 Masked-

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    |  4 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  5 ++
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 72 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 13 +++-
 4 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index ca6f2fc39ea0..79cfcc844156 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -567,6 +567,10 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 	if (MLX5_CAP_GEN_MAX(dev, mkey_by_name))
 		MLX5_SET(cmd_hca_cap, set_hca_cap, mkey_by_name, 1);
 
+	if (MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix))
+		MLX5_SET(cmd_hca_cap, set_hca_cap, num_total_dynamic_vf_msix,
+			 MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix));
+
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 0a0302ce7144..5babb4434a87 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -172,6 +172,11 @@ int mlx5_irq_attach_nb(struct mlx5_irq_table *irq_table, int vecidx,
 		       struct notifier_block *nb);
 int mlx5_irq_detach_nb(struct mlx5_irq_table *irq_table, int vecidx,
 		       struct notifier_block *nb);
+
+int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int devfn,
+			    int msix_vec_count);
+int mlx5_get_default_msix_vec_count(struct mlx5_core_dev *dev, int num_vfs);
+
 struct cpumask *
 mlx5_irq_get_affinity_mask(struct mlx5_irq_table *irq_table, int vecidx);
 struct cpu_rmap *mlx5_irq_get_rmap(struct mlx5_irq_table *table);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 6fd974920394..715c801ae865 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -55,6 +55,78 @@ static struct mlx5_irq *mlx5_irq_get(struct mlx5_core_dev *dev, int vecidx)
 	return &irq_table->irq[vecidx];
 }
 
+/**
+ * mlx5_get_default_msix_vec_count - Get default number of MSI-X vectors
+ * to be ssigned to each VF.
+ * @dev: PF to work on
+ * @num_vfs: Number of enabled VFs/
+ */
+int mlx5_get_default_msix_vec_count(struct mlx5_core_dev *dev, int num_vfs)
+{
+	int num_vf_msix, min_msix, max_msix;
+
+	num_vf_msix = MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix);
+	if (!num_vf_msix)
+		return 0;
+
+	min_msix = MLX5_CAP_GEN(dev, min_dynamic_vf_msix_table_size);
+	max_msix = MLX5_CAP_GEN(dev, max_dynamic_vf_msix_table_size);
+
+	/* Limit maximum number of MSI-X vectors to leave some of them free
+	 * in the pool and ready to be assigned by the users without need to
+	 * resize other Vfs.
+	 */
+	return max(min(num_vf_msix / num_vfs, max_msix / 2), min_msix);
+}
+
+/**
+ * mlx5_set_msix_vec_count - Set dynamically allocated MSI-X to the VF
+ * @dev: PF to work on
+ * @function_id: Internal PCI VF function IDd
+ * @msix_vec_count: Number of MSI-X vectors to set
+ */
+int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
+			    int msix_vec_count)
+{
+	int sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
+	int num_vf_msix, min_msix, max_msix;
+	void *hca_cap, *cap;
+	int ret;
+
+	num_vf_msix = MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix);
+	if (!num_vf_msix)
+		return 0;
+
+	if (!MLX5_CAP_GEN(dev, vport_group_manager) || !mlx5_core_is_pf(dev))
+		return -EOPNOTSUPP;
+
+	min_msix = MLX5_CAP_GEN(dev, min_dynamic_vf_msix_table_size);
+	max_msix = MLX5_CAP_GEN(dev, max_dynamic_vf_msix_table_size);
+
+	if (msix_vec_count < min_msix)
+		return -EINVAL;
+
+	if (msix_vec_count > max_msix)
+		return -EOVERFLOW;
+
+	hca_cap = kzalloc(sz, GFP_KERNEL);
+	if (!hca_cap)
+		return -ENOMEM;
+
+	cap = MLX5_ADDR_OF(set_hca_cap_in, hca_cap, capability);
+	MLX5_SET(cmd_hca_cap, cap, dynamic_msix_table_size, msix_vec_count);
+
+	MLX5_SET(set_hca_cap_in, hca_cap, opcode, MLX5_CMD_OP_SET_HCA_CAP);
+	MLX5_SET(set_hca_cap_in, hca_cap, other_function, 1);
+	MLX5_SET(set_hca_cap_in, hca_cap, function_id, function_id);
+
+	MLX5_SET(set_hca_cap_in, hca_cap, op_mod,
+		 MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE << 1);
+	ret = mlx5_cmd_exec_in(dev, set_hca_cap, hca_cap);
+	kfree(hca_cap);
+	return ret;
+}
+
 int mlx5_irq_attach_nb(struct mlx5_irq_table *irq_table, int vecidx,
 		       struct notifier_block *nb)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 3094d20297a9..f0ec86a1c8a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -71,8 +71,7 @@ static int sriov_restore_guids(struct mlx5_core_dev *dev, int vf)
 static int mlx5_device_enable_sriov(struct mlx5_core_dev *dev, int num_vfs)
 {
 	struct mlx5_core_sriov *sriov = &dev->priv.sriov;
-	int err;
-	int vf;
+	int err, vf, num_msix_count;
 
 	if (!MLX5_ESWITCH_MANAGER(dev))
 		goto enable_vfs_hca;
@@ -85,12 +84,22 @@ static int mlx5_device_enable_sriov(struct mlx5_core_dev *dev, int num_vfs)
 	}
 
 enable_vfs_hca:
+	num_msix_count = mlx5_get_default_msix_vec_count(dev, num_vfs);
 	for (vf = 0; vf < num_vfs; vf++) {
 		err = mlx5_core_enable_hca(dev, vf + 1);
 		if (err) {
 			mlx5_core_warn(dev, "failed to enable VF %d (%d)\n", vf, err);
 			continue;
 		}
+
+		err = mlx5_set_msix_vec_count(dev, vf + 1, num_msix_count);
+		if (err) {
+			mlx5_core_warn(dev,
+				       "failed to set MSI-X vector counts VF %d, err %d\n",
+				       vf, err);
+			continue;
+		}
+
 		sriov->vfs_ctx[vf].enabled = 1;
 		if (MLX5_CAP_GEN(dev, port_type) == MLX5_CAP_PORT_TYPE_IB) {
 			err = sriov_restore_guids(dev, vf);
-- 
2.29.2

