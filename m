Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBD133A4D0
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbhCNMnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235248AbhCNMnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 08:43:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD78D64EE2;
        Sun, 14 Mar 2021 12:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615725788;
        bh=LMnpBtsuxcrPZPszbArennzniOm6Hpc+4XNwbYWffYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9KXqelOq7qK+R/TlTnijXRgiwUcBsyFLSHj+/FTqh1qrxSUhPK+PoQJ3G09hY4ZL
         y3nR9mQtH86Im6NTb0dr0GUCV/mdIxuOQ+EdJzNppOpTj8FJsh+NOBmqaAgJS38I6h
         aKi/ai67pFEIkyyEhvpUKjoArFyskoeMHTx0Gn0jXv/YrLUQWwsgtb5WrjSqrtR2wY
         fk/BrrHSYO9O0nUaOJTB/GWN5vJRbaICPa2nndPhPlG0oBUlEol1o5Mtdf5NK09J/2
         kBLo03Vi/ysGzq1/qeAZe6dlsP3z4urM+KBz+SUVHd0durOJOyWnnOK9KiE2mQXVRH
         xVvr4nbdxPy0A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH mlx5-next v8 3/4] net/mlx5: Dynamically assign MSI-X vectors count
Date:   Sun, 14 Mar 2021 14:42:55 +0200
Message-Id: <20210314124256.70253-4-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210314124256.70253-1-leon@kernel.org>
References: <20210314124256.70253-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The number of MSI-X vectors is a PCI property visible through lspci. The
field is read-only and configured by the device. The mlx5 devices work in
a static or dynamic assignment mode.

Static assignment means that all newly created VFs have a preset number of
MSI-X vectors determined by device configuration parameters. This can
result in some VFs having too many or too few MSI-X vectors. Till now this
has been the only means of fine-tuning the MSI-X vector count and it was
acceptable for small numbers of VFs.

With dynamic assignment the inefficiency of having a fixed number of MSI-X
vectors can be avoided with each VF having exactly the required
vectors. Userspace will provide this information while provisioning the VF
for use, based on the intended use. For instance if being used with a VM,
the MSI-X vector count might be matched to the CPU count of the VM.

For compatibility mlx5 continues to start up with MSI-X vector assignment,
but the kernel can now access a larger dynamic vector pool and assign more
vectors to created VFs.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    |  4 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  5 ++
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 73 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 13 +++-
 4 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c568896cfb23..0489712865b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -571,6 +571,10 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)

 	mlx5_vhca_state_cap_handle(dev, set_hca_cap);

+	if (MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix))
+		MLX5_SET(cmd_hca_cap, set_hca_cap, num_total_dynamic_vf_msix,
+			 MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix));
+
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 }

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index efe403c7e354..f0aed664dd35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -174,6 +174,11 @@ int mlx5_irq_attach_nb(struct mlx5_irq_table *irq_table, int vecidx,
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
index a61e09aff152..19e3e978267e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -61,6 +61,79 @@ static struct mlx5_irq *mlx5_irq_get(struct mlx5_core_dev *dev, int vecidx)
 	return &irq_table->irq[vecidx];
 }

+/**
+ * mlx5_get_default_msix_vec_count - Get the default number of MSI-X vectors
+ *                                   to be ssigned to each VF.
+ * @dev: PF to work on
+ * @num_vfs: Number of enabled VFs
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
+	/* Limit maximum number of MSI-X vectors so the default configuration
+	 * has some available in the pool. This will allow the user to increase
+	 * the number of vectors in a VF without having to first size-down other
+	 * VFs.
+	 */
+	return max(min(num_vf_msix / num_vfs, max_msix / 2), min_msix);
+}
+
+/**
+ * mlx5_set_msix_vec_count - Set dynamically allocated MSI-X on the VF
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
2.30.2

