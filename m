Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E384146AB
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbhIVKlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235101AbhIVKks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 06:40:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0009F61283;
        Wed, 22 Sep 2021 10:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632307158;
        bh=TGRBrptdrH21ZWPUeUsU1Gvcbh1WTC12wznn0duabtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6UqKdS79BZGJpxKnISgIIta7TLK71zJva+RzSCoIuSyj/obIJxmiyuB8Fudz3bfJ
         JfyLdfKBiB3FsAE1T8qM0BRLSYLqnweQZVMBCC7RiG+EHlJzYSljbSASqnpKrErZ/U
         ESyK6vE6GtUQEUsckyjJWzdIfOW3rFMThthd4f7AuubUH6reDtsoiJc6kqdP27CouP
         te/cULlK1eGjN9gZf4TTrCfFhVcEspxtBjcAjZ3HSLObYlCab5mIdPbptVQ/dyrEBb
         nZvz3XieljnhLrCAklG87zb3sQdjPoK5YBOVpWrO2pX/pm39ou5wHzks32IdH+w1Fd
         Kfw8IfywwPapw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 6/7] mlx5_vfio_pci: Expose migration commands over mlx5 device
Date:   Wed, 22 Sep 2021 13:38:55 +0300
Message-Id: <7fc0cf0d76bb6df4679b55974959f5494e48f54d.1632305919.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632305919.git.leonro@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Expose migration commands over the device, it includes: suspend, resume,
get vhca id, query/save/load state.

As part of this adds the APIs and data structure that are needed to
manage the migration data.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5_vfio_pci_cmd.c | 358 +++++++++++++++++++++++++++
 drivers/vfio/pci/mlx5_vfio_pci_cmd.h |  43 ++++
 2 files changed, 401 insertions(+)
 create mode 100644 drivers/vfio/pci/mlx5_vfio_pci_cmd.c
 create mode 100644 drivers/vfio/pci/mlx5_vfio_pci_cmd.h

diff --git a/drivers/vfio/pci/mlx5_vfio_pci_cmd.c b/drivers/vfio/pci/mlx5_vfio_pci_cmd.c
new file mode 100644
index 000000000000..7e4f83d196a8
--- /dev/null
+++ b/drivers/vfio/pci/mlx5_vfio_pci_cmd.c
@@ -0,0 +1,358 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include "mlx5_vfio_pci_cmd.h"
+
+int mlx5vf_cmd_suspend_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod)
+{
+	struct mlx5_core_dev *mdev = mlx5_get_core_dev(pci_physfn(pdev));
+	u32 out[MLX5_ST_SZ_DW(suspend_vhca_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(suspend_vhca_in)] = {};
+	int ret;
+
+	if (!mdev)
+		return -ENOTCONN;
+
+	MLX5_SET(suspend_vhca_in, in, opcode, MLX5_CMD_OP_SUSPEND_VHCA);
+	MLX5_SET(suspend_vhca_in, in, vhca_id, vhca_id);
+	MLX5_SET(suspend_vhca_in, in, op_mod, op_mod);
+
+	ret = mlx5_cmd_exec_inout(mdev, suspend_vhca, in, out);
+	mlx5_put_core_dev(mdev);
+	return ret;
+}
+
+int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod)
+{
+	struct mlx5_core_dev *mdev = mlx5_get_core_dev(pci_physfn(pdev));
+	u32 out[MLX5_ST_SZ_DW(resume_vhca_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(resume_vhca_in)] = {};
+	int ret;
+
+	if (!mdev)
+		return -ENOTCONN;
+
+	MLX5_SET(resume_vhca_in, in, opcode, MLX5_CMD_OP_RESUME_VHCA);
+	MLX5_SET(resume_vhca_in, in, vhca_id, vhca_id);
+	MLX5_SET(resume_vhca_in, in, op_mod, op_mod);
+
+	ret = mlx5_cmd_exec_inout(mdev, resume_vhca, in, out);
+	mlx5_put_core_dev(mdev);
+	return ret;
+}
+
+int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
+					  u32 *state_size)
+{
+	struct mlx5_core_dev *mdev = mlx5_get_core_dev(pci_physfn(pdev));
+	u32 out[MLX5_ST_SZ_DW(query_vhca_migration_state_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_vhca_migration_state_in)] = {};
+	int ret;
+
+	if (!mdev)
+		return -ENOTCONN;
+
+	MLX5_SET(query_vhca_migration_state_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE);
+	MLX5_SET(query_vhca_migration_state_in, in, vhca_id, vhca_id);
+	MLX5_SET(query_vhca_migration_state_in, in, op_mod, 0);
+
+	ret = mlx5_cmd_exec_inout(mdev, query_vhca_migration_state, in, out);
+	if (ret)
+		goto end;
+
+	*state_size = MLX5_GET(query_vhca_migration_state_out, out,
+			       required_umem_size);
+
+end:
+	mlx5_put_core_dev(mdev);
+	return ret;
+}
+
+int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id)
+{
+	struct mlx5_core_dev *mdev = mlx5_get_core_dev(pci_physfn(pdev));
+	u32 in[MLX5_ST_SZ_DW(query_hca_cap_in)] = {};
+	int out_size;
+	void *out;
+	int ret;
+
+	if (!mdev)
+		return -ENOTCONN;
+
+	out_size = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	out = kzalloc(out_size, GFP_KERNEL);
+	if (!out) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
+	MLX5_SET(query_hca_cap_in, in, other_function, 1);
+	MLX5_SET(query_hca_cap_in, in, function_id, function_id);
+	MLX5_SET(query_hca_cap_in, in, op_mod,
+		 MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE << 1 |
+		 HCA_CAP_OPMOD_GET_CUR);
+
+	ret = mlx5_cmd_exec_inout(mdev, query_hca_cap, in, out);
+	if (ret)
+		goto err_exec;
+
+	*vhca_id = MLX5_GET(query_hca_cap_out, out, capability.cmd_hca_cap.vhca_id);
+
+err_exec:
+	kfree(out);
+end:
+	mlx5_put_core_dev(mdev);
+	return ret;
+}
+
+static int _create_state_mkey(struct mlx5_core_dev *mdev, u32 pdn,
+			      struct mlx5_vhca_state_data *state,
+			      struct mlx5_core_mkey *mkey)
+{
+	struct sg_dma_page_iter dma_iter;
+	int err = 0, inlen;
+	__be64 *mtt;
+	void *mkc;
+	u32 *in;
+
+	inlen = MLX5_ST_SZ_BYTES(create_mkey_in) +
+			sizeof(*mtt) * round_up(state->num_pages, 2);
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
+		 DIV_ROUND_UP(state->num_pages, 2));
+	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
+
+	for_each_sgtable_dma_page(&state->mig_data.table.sgt, &dma_iter, 0)
+		*mtt++ = cpu_to_be64(sg_page_iter_dma_address(&dma_iter));
+
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
+	MLX5_SET(mkc, mkc, lr, 1);
+	MLX5_SET(mkc, mkc, lw, 1);
+	MLX5_SET(mkc, mkc, pd, pdn);
+	MLX5_SET(mkc, mkc, bsf_octword_size, 0);
+	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+	MLX5_SET(mkc, mkc, log_page_size, PAGE_SHIFT);
+	MLX5_SET(mkc, mkc, translations_octword_size,
+		 DIV_ROUND_UP(state->num_pages, 2));
+	MLX5_SET64(mkc, mkc, start_addr, mkey->iova);
+	MLX5_SET64(mkc, mkc, len, state->num_pages * PAGE_SIZE);
+	err = mlx5_core_create_mkey(mdev, mkey, in, inlen);
+
+	kvfree(in);
+
+	return err;
+}
+
+struct page *mlx5vf_get_migration_page(struct migration_data *data,
+				       unsigned long offset)
+{
+	unsigned long cur_offset = 0;
+	struct scatterlist *sg;
+	unsigned int i;
+
+	if (offset < data->last_offset || !data->last_offset_sg) {
+		data->last_offset = 0;
+		data->last_offset_sg = data->table.sgt.sgl;
+		data->sg_last_entry = 0;
+	}
+
+	cur_offset = data->last_offset;
+
+	for_each_sg(data->last_offset_sg, sg,
+			data->table.sgt.orig_nents - data->sg_last_entry, i) {
+		if (offset < sg->length + cur_offset) {
+			data->last_offset_sg = sg;
+			data->sg_last_entry += i;
+			data->last_offset = cur_offset;
+			return nth_page(sg_page(sg),
+					(offset - cur_offset) / PAGE_SIZE);
+		}
+		cur_offset += sg->length;
+	}
+	return NULL;
+}
+
+void mlx5vf_reset_vhca_state(struct mlx5_vhca_state_data *state)
+{
+	struct migration_data *data = &state->mig_data;
+	struct sg_page_iter sg_iter;
+
+	if (!data->table.prv)
+		goto end;
+
+	/* Undo alloc_pages_bulk_array() */
+	for_each_sgtable_page(&data->table.sgt, &sg_iter, 0)
+		__free_page(sg_page_iter_page(&sg_iter));
+	sg_free_append_table(&data->table);
+end:
+	memset(state, 0, sizeof(*state));
+}
+
+int mlx5vf_add_migration_pages(struct mlx5_vhca_state_data *state,
+			       unsigned int npages)
+{
+	unsigned int to_alloc = npages;
+	struct page **page_list;
+	unsigned long filled;
+	unsigned int to_fill;
+	int ret = 0;
+
+	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
+	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL);
+	if (!page_list)
+		return -ENOMEM;
+
+	do {
+		filled = alloc_pages_bulk_array(GFP_KERNEL, to_fill,
+						page_list);
+		if (!filled) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		to_alloc -= filled;
+		ret = sg_alloc_append_table_from_pages(
+			&state->mig_data.table, page_list, filled, 0,
+			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
+			GFP_KERNEL);
+
+		if (ret)
+			goto err;
+		/* clean input for another bulk allocation */
+		memset(page_list, 0, filled * sizeof(*page_list));
+		to_fill = min_t(unsigned int, to_alloc,
+				PAGE_SIZE / sizeof(*page_list));
+	} while (to_alloc > 0);
+
+	kvfree(page_list);
+	state->num_pages += npages;
+
+	return 0;
+
+err:
+	kvfree(page_list);
+	return ret;
+}
+
+int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+			       u64 state_size,
+			       struct mlx5_vhca_state_data *state)
+{
+	struct mlx5_core_dev *mdev = mlx5_get_core_dev(pci_physfn(pdev));
+	u32 out[MLX5_ST_SZ_DW(save_vhca_state_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
+	struct mlx5_core_mkey mkey = {};
+	u32 pdn;
+	int err;
+
+	if (!mdev)
+		return -ENOTCONN;
+
+	err = mlx5_core_alloc_pd(mdev, &pdn);
+	if (err)
+		goto end;
+
+	err = mlx5vf_add_migration_pages(state,
+				DIV_ROUND_UP_ULL(state_size, PAGE_SIZE));
+	if (err < 0)
+		goto err_alloc_pages;
+
+	err = dma_map_sgtable(mdev->device, &state->mig_data.table.sgt,
+			      DMA_FROM_DEVICE, 0);
+	if (err)
+		goto err_reg_dma;
+
+	err = _create_state_mkey(mdev, pdn, state, &mkey);
+	if (err)
+		goto err_create_mkey;
+
+	MLX5_SET(save_vhca_state_in, in, opcode,
+		 MLX5_CMD_OP_SAVE_VHCA_STATE);
+	MLX5_SET(save_vhca_state_in, in, op_mod, 0);
+	MLX5_SET(save_vhca_state_in, in, vhca_id, vhca_id);
+
+	MLX5_SET64(save_vhca_state_in, in, va, mkey.iova);
+	MLX5_SET(save_vhca_state_in, in, mkey, mkey.key);
+	MLX5_SET(save_vhca_state_in, in, size, mkey.size);
+
+	err = mlx5_cmd_exec_inout(mdev, save_vhca_state, in, out);
+	if (err)
+		goto err_exec;
+
+	state->state_size = state_size;
+
+	mlx5_core_destroy_mkey(mdev, &mkey);
+	mlx5_core_dealloc_pd(mdev, pdn);
+	dma_unmap_sgtable(mdev->device, &state->mig_data.table.sgt,
+			  DMA_FROM_DEVICE, 0);
+	mlx5_put_core_dev(mdev);
+
+	return 0;
+
+err_exec:
+	mlx5_core_destroy_mkey(mdev, &mkey);
+err_create_mkey:
+	dma_unmap_sgtable(mdev->device, &state->mig_data.table.sgt,
+			  DMA_FROM_DEVICE, 0);
+err_reg_dma:
+	mlx5vf_reset_vhca_state(state);
+err_alloc_pages:
+	mlx5_core_dealloc_pd(mdev, pdn);
+end:
+	mlx5_put_core_dev(mdev);
+	return err;
+}
+
+int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+			       struct mlx5_vhca_state_data *state)
+{
+	struct mlx5_core_dev *mdev = mlx5_get_core_dev(pci_physfn(pdev));
+	u32 out[MLX5_ST_SZ_DW(save_vhca_state_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
+	struct mlx5_core_mkey mkey = {};
+	u32 pdn;
+	int err;
+
+	if (!mdev)
+		return -ENOTCONN;
+
+	err = mlx5_core_alloc_pd(mdev, &pdn);
+	if (err)
+		goto end;
+
+	err = dma_map_sgtable(mdev->device, &state->mig_data.table.sgt,
+			      DMA_TO_DEVICE, 0);
+	if (err)
+		goto err_reg;
+
+	err = _create_state_mkey(mdev, pdn, state, &mkey);
+	if (err)
+		goto err_mkey;
+
+	MLX5_SET(load_vhca_state_in, in, opcode,
+		 MLX5_CMD_OP_LOAD_VHCA_STATE);
+	MLX5_SET(load_vhca_state_in, in, op_mod, 0);
+	MLX5_SET(load_vhca_state_in, in, vhca_id, vhca_id);
+	MLX5_SET64(load_vhca_state_in, in, va, mkey.iova);
+	MLX5_SET(load_vhca_state_in, in, mkey, mkey.key);
+	MLX5_SET(load_vhca_state_in, in, size, state->state_size);
+
+	err = mlx5_cmd_exec_inout(mdev, load_vhca_state, in, out);
+	mlx5_core_destroy_mkey(mdev, &mkey);
+err_mkey:
+	dma_unmap_sgtable(mdev->device, &state->mig_data.table.sgt,
+			  DMA_TO_DEVICE, 0);
+err_reg:
+	mlx5_core_dealloc_pd(mdev, pdn);
+end:
+	mlx5_put_core_dev(mdev);
+	return err;
+}
diff --git a/drivers/vfio/pci/mlx5_vfio_pci_cmd.h b/drivers/vfio/pci/mlx5_vfio_pci_cmd.h
new file mode 100644
index 000000000000..66221df24b19
--- /dev/null
+++ b/drivers/vfio/pci/mlx5_vfio_pci_cmd.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+ */
+
+#ifndef MLX5_VFIO_CMD_H
+#define MLX5_VFIO_CMD_H
+
+#include <linux/kernel.h>
+#include <linux/mlx5/driver.h>
+
+struct migration_data {
+	struct sg_append_table table;
+
+	struct scatterlist *last_offset_sg;
+	unsigned int sg_last_entry;
+	unsigned long last_offset;
+};
+
+/* state data of vhca to be used as part of migration flow */
+struct mlx5_vhca_state_data {
+	u64 state_size;
+	u64 num_pages;
+	u32 win_start_offset;
+	struct migration_data mig_data;
+};
+
+int mlx5vf_cmd_suspend_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
+int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
+int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
+					  uint32_t *state_size);
+int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id);
+int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+			       u64 state_size,
+			       struct mlx5_vhca_state_data *state);
+void mlx5vf_reset_vhca_state(struct mlx5_vhca_state_data *state);
+int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+			       struct mlx5_vhca_state_data *state);
+int mlx5vf_add_migration_pages(struct mlx5_vhca_state_data *state,
+			       unsigned int npages);
+struct page *mlx5vf_get_migration_page(struct migration_data *data,
+				       unsigned long offset);
+#endif /* MLX5_VFIO_CMD_H */
-- 
2.31.1

