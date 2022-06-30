Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF52560E7C
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 03:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiF3BAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 21:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiF3BAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 21:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029712657B
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82C8961F5A
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45D3C341CD;
        Thu, 30 Jun 2022 01:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656550816;
        bh=rhV7bZh2IT8DgFddnaMxsPbLVN9N8a08sYNshZuYqLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShPBMVlyxuvb0JPBMAB4hg5HogUg8xP0Ieg45/26IG2AfLhoHNDHUGiIxrmC5iqo/
         jfvfIm0uaehUKLbURiVbVmtFe1ttOEkbCh0dYGa+R38D2Tav18odhLz7xH0jMdG0IY
         B/MN14UuDsyhVQlUKAvabhpWiSqG5d/YNRi7T6THV6+7Pf1KOQrCFub98stBNtbSl8
         xkaX+42MOfp3rHvO6Ex4khbyFJwLUuQgECmx9TVSCxDMA6o11VquKU04J8QABI7pMN
         ig9nYS3ZPq7x8ojhhgJ0E2ZIodJqTApZVGGsbbaV7lbPGpdblKUqeqBpusSREuK5bP
         mCJpEKYJslFgg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Jianbo Liu <jianbol@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: [net-next 07/15] net/mlx5: Add support to create SQ and CQ for ASO
Date:   Wed, 29 Jun 2022 17:59:57 -0700
Message-Id: <20220630010005.145775-8-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630010005.145775-1-saeed@kernel.org>
References: <20220630010005.145775-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

Add a separate API to create SQ and CQ for advanced steering
operations (ASO).

Since the mlx5_en API to create these resources is strongly coupled
with netdev channels and datapath elements, this API provides an
alternative for creating send queues that are used for ASO.

Currently the API allows creating channels with 2 wqbbs only - meaning
the support will be for a single ACCESS_ASO wqe with data at a time.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/aso.c | 336 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/lib/aso.h |  13 +
 3 files changed, 350 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 9ea867a45764..a3381354a07d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -17,7 +17,7 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 		fs_counters.o fs_ft_pool.o rl.o lag/debugfs.o lag/lag.o dev.o events.o wq.o lib/gid.o \
 		lib/devcom.o lib/pci_vsc.o lib/dm.o lib/fs_ttc.o diag/fs_tracepoint.o \
 		diag/fw_tracer.o diag/crdump.o devlink.o diag/rsc_dump.o \
-		fw_reset.o qos.o lib/tout.o
+		fw_reset.o qos.o lib/tout.o lib/aso.o
 
 #
 # Netdev basic
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
new file mode 100644
index 000000000000..4195d54d0f51
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -0,0 +1,336 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+
+#include <linux/mlx5/device.h>
+#include <linux/mlx5/transobj.h>
+#include "aso.h"
+#include "wq.h"
+
+struct mlx5_aso_cq {
+	/* data path - accessed per cqe */
+	struct mlx5_cqwq           wq;
+
+	/* data path - accessed per napi poll */
+	struct mlx5_core_cq        mcq;
+
+	/* control */
+	struct mlx5_core_dev      *mdev;
+	struct mlx5_wq_ctrl        wq_ctrl;
+} ____cacheline_aligned_in_smp;
+
+struct mlx5_aso {
+	/* data path */
+	u16                        cc;
+	u16                        pc;
+
+	struct mlx5_wqe_ctrl_seg  *doorbell_cseg;
+	struct mlx5_aso_cq         cq;
+
+	/* read only */
+	struct mlx5_wq_cyc         wq;
+	void __iomem              *uar_map;
+	u32                        sqn;
+
+	/* control path */
+	struct mlx5_wq_ctrl        wq_ctrl;
+
+} ____cacheline_aligned_in_smp;
+
+static void mlx5_aso_free_cq(struct mlx5_aso_cq *cq)
+{
+	mlx5_wq_destroy(&cq->wq_ctrl);
+}
+
+static int mlx5_aso_alloc_cq(struct mlx5_core_dev *mdev, int numa_node,
+			     void *cqc_data, struct mlx5_aso_cq *cq)
+{
+	struct mlx5_core_cq *mcq = &cq->mcq;
+	struct mlx5_wq_param param;
+	int err;
+	u32 i;
+
+	param.buf_numa_node = numa_node;
+	param.db_numa_node = numa_node;
+
+	err = mlx5_cqwq_create(mdev, &param, cqc_data, &cq->wq, &cq->wq_ctrl);
+	if (err)
+		return err;
+
+	mcq->cqe_sz     = 64;
+	mcq->set_ci_db  = cq->wq_ctrl.db.db;
+	mcq->arm_db     = cq->wq_ctrl.db.db + 1;
+
+	for (i = 0; i < mlx5_cqwq_get_size(&cq->wq); i++) {
+		struct mlx5_cqe64 *cqe = mlx5_cqwq_get_wqe(&cq->wq, i);
+
+		cqe->op_own = 0xf1;
+	}
+
+	cq->mdev = mdev;
+
+	return 0;
+}
+
+static int create_aso_cq(struct mlx5_aso_cq *cq, void *cqc_data)
+{
+	u32 out[MLX5_ST_SZ_DW(create_cq_out)];
+	struct mlx5_core_dev *mdev = cq->mdev;
+	struct mlx5_core_cq *mcq = &cq->mcq;
+	void *in, *cqc;
+	int inlen, eqn;
+	int err;
+
+	err = mlx5_vector2eqn(mdev, 0, &eqn);
+	if (err)
+		return err;
+
+	inlen = MLX5_ST_SZ_BYTES(create_cq_in) +
+		sizeof(u64) * cq->wq_ctrl.buf.npages;
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	cqc = MLX5_ADDR_OF(create_cq_in, in, cq_context);
+
+	memcpy(cqc, cqc_data, MLX5_ST_SZ_BYTES(cqc));
+
+	mlx5_fill_page_frag_array(&cq->wq_ctrl.buf,
+				  (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas));
+
+	MLX5_SET(cqc,   cqc, cq_period_mode, DIM_CQ_PERIOD_MODE_START_FROM_EQE);
+	MLX5_SET(cqc,   cqc, c_eqn_or_apu_element, eqn);
+	MLX5_SET(cqc,   cqc, uar_page,      mdev->priv.uar->index);
+	MLX5_SET(cqc,   cqc, log_page_size, cq->wq_ctrl.buf.page_shift -
+					    MLX5_ADAPTER_PAGE_SHIFT);
+	MLX5_SET64(cqc, cqc, dbr_addr,      cq->wq_ctrl.db.dma);
+
+	err = mlx5_core_create_cq(mdev, mcq, in, inlen, out, sizeof(out));
+
+	kvfree(in);
+
+	return err;
+}
+
+static void mlx5_aso_destroy_cq(struct mlx5_aso_cq *cq)
+{
+	mlx5_core_destroy_cq(cq->mdev, &cq->mcq);
+	mlx5_wq_destroy(&cq->wq_ctrl);
+}
+
+static int mlx5_aso_create_cq(struct mlx5_core_dev *mdev, int numa_node,
+			      struct mlx5_aso_cq *cq)
+{
+	void *cqc_data;
+	int err;
+
+	cqc_data = kvzalloc(MLX5_ST_SZ_BYTES(cqc), GFP_KERNEL);
+	if (!cqc_data)
+		return -ENOMEM;
+
+	MLX5_SET(cqc, cqc_data, log_cq_size, 1);
+	MLX5_SET(cqc, cqc_data, uar_page, mdev->priv.uar->index);
+	if (MLX5_CAP_GEN(mdev, cqe_128_always) && cache_line_size() >= 128)
+		MLX5_SET(cqc, cqc_data, cqe_sz, CQE_STRIDE_128_PAD);
+
+	err = mlx5_aso_alloc_cq(mdev, numa_node, cqc_data, cq);
+	if (err) {
+		mlx5_core_err(mdev, "Failed to alloc aso wq cq, err=%d\n", err);
+		goto err_out;
+	}
+
+	err = create_aso_cq(cq, cqc_data);
+	if (err) {
+		mlx5_core_err(mdev, "Failed to create aso wq cq, err=%d\n", err);
+		goto err_free_cq;
+	}
+
+	kvfree(cqc_data);
+	return 0;
+
+err_free_cq:
+	mlx5_aso_free_cq(cq);
+err_out:
+	kvfree(cqc_data);
+	return err;
+}
+
+static int mlx5_aso_alloc_sq(struct mlx5_core_dev *mdev, int numa_node,
+			     void *sqc_data, struct mlx5_aso *sq)
+{
+	void *sqc_wq = MLX5_ADDR_OF(sqc, sqc_data, wq);
+	struct mlx5_wq_cyc *wq = &sq->wq;
+	struct mlx5_wq_param param;
+	int err;
+
+	sq->uar_map = mdev->mlx5e_res.hw_objs.bfreg.map;
+
+	param.db_numa_node = numa_node;
+	param.buf_numa_node = numa_node;
+	err = mlx5_wq_cyc_create(mdev, &param, sqc_wq, wq, &sq->wq_ctrl);
+	if (err)
+		return err;
+	wq->db = &wq->db[MLX5_SND_DBR];
+
+	return 0;
+}
+
+static int create_aso_sq(struct mlx5_core_dev *mdev, int pdn,
+			 void *sqc_data, struct mlx5_aso *sq)
+{
+	void *in, *sqc, *wq;
+	int inlen, err;
+
+	inlen = MLX5_ST_SZ_BYTES(create_sq_in) +
+		sizeof(u64) * sq->wq_ctrl.buf.npages;
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	sqc = MLX5_ADDR_OF(create_sq_in, in, ctx);
+	wq = MLX5_ADDR_OF(sqc, sqc, wq);
+
+	memcpy(sqc, sqc_data, MLX5_ST_SZ_BYTES(sqc));
+	MLX5_SET(sqc,  sqc, cqn, sq->cq.mcq.cqn);
+
+	MLX5_SET(sqc,  sqc, state, MLX5_SQC_STATE_RST);
+	MLX5_SET(sqc,  sqc, flush_in_error_en, 1);
+
+	MLX5_SET(wq,   wq, wq_type,       MLX5_WQ_TYPE_CYCLIC);
+	MLX5_SET(wq,   wq, uar_page,      mdev->mlx5e_res.hw_objs.bfreg.index);
+	MLX5_SET(wq,   wq, log_wq_pg_sz,  sq->wq_ctrl.buf.page_shift -
+					  MLX5_ADAPTER_PAGE_SHIFT);
+	MLX5_SET64(wq, wq, dbr_addr,      sq->wq_ctrl.db.dma);
+
+	mlx5_fill_page_frag_array(&sq->wq_ctrl.buf,
+				  (__be64 *)MLX5_ADDR_OF(wq, wq, pas));
+
+	err = mlx5_core_create_sq(mdev, in, inlen, &sq->sqn);
+
+	kvfree(in);
+
+	return err;
+}
+
+static int mlx5_aso_set_sq_rdy(struct mlx5_core_dev *mdev, u32 sqn)
+{
+	void *in, *sqc;
+	int inlen, err;
+
+	inlen = MLX5_ST_SZ_BYTES(modify_sq_in);
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(modify_sq_in, in, sq_state, MLX5_SQC_STATE_RST);
+	sqc = MLX5_ADDR_OF(modify_sq_in, in, ctx);
+	MLX5_SET(sqc, sqc, state, MLX5_SQC_STATE_RDY);
+
+	err = mlx5_core_modify_sq(mdev, sqn, in);
+
+	kvfree(in);
+
+	return err;
+}
+
+static int mlx5_aso_create_sq_rdy(struct mlx5_core_dev *mdev, u32 pdn,
+				  void *sqc_data, struct mlx5_aso *sq)
+{
+	int err;
+
+	err = create_aso_sq(mdev, pdn, sqc_data, sq);
+	if (err)
+		return err;
+
+	err = mlx5_aso_set_sq_rdy(mdev, sq->sqn);
+	if (err)
+		mlx5_core_destroy_sq(mdev, sq->sqn);
+
+	return err;
+}
+
+static void mlx5_aso_free_sq(struct mlx5_aso *sq)
+{
+	mlx5_wq_destroy(&sq->wq_ctrl);
+}
+
+static void mlx5_aso_destroy_sq(struct mlx5_aso *sq)
+{
+	mlx5_core_destroy_sq(sq->cq.mdev, sq->sqn);
+	mlx5_aso_free_sq(sq);
+}
+
+static int mlx5_aso_create_sq(struct mlx5_core_dev *mdev, int numa_node,
+			      u32 pdn, struct mlx5_aso *sq)
+{
+	void *sqc_data, *wq;
+	int err;
+
+	sqc_data = kvzalloc(MLX5_ST_SZ_BYTES(sqc), GFP_KERNEL);
+	if (!sqc_data)
+		return -ENOMEM;
+
+	wq = MLX5_ADDR_OF(sqc, sqc_data, wq);
+	MLX5_SET(wq, wq, log_wq_stride, ilog2(MLX5_SEND_WQE_BB));
+	MLX5_SET(wq, wq, pd, pdn);
+	MLX5_SET(wq, wq, log_wq_sz, 1);
+
+	err = mlx5_aso_alloc_sq(mdev, numa_node, sqc_data, sq);
+	if (err) {
+		mlx5_core_err(mdev, "Failed to alloc aso wq sq, err=%d\n", err);
+		goto err_out;
+	}
+
+	err = mlx5_aso_create_sq_rdy(mdev, pdn, sqc_data, sq);
+	if (err) {
+		mlx5_core_err(mdev, "Failed to open aso wq sq, err=%d\n", err);
+		goto err_free_asosq;
+	}
+
+	mlx5_core_dbg(mdev, "aso sq->sqn = 0x%x\n", sq->sqn);
+
+	kvfree(sqc_data);
+	return 0;
+
+err_free_asosq:
+	mlx5_aso_free_sq(sq);
+err_out:
+	kvfree(sqc_data);
+	return err;
+}
+
+struct mlx5_aso *mlx5_aso_create(struct mlx5_core_dev *mdev, u32 pdn)
+{
+	int numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
+	struct mlx5_aso *aso;
+	int err;
+
+	aso = kzalloc(sizeof(*aso), GFP_KERNEL);
+	if (!aso)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlx5_aso_create_cq(mdev, numa_node, &aso->cq);
+	if (err)
+		goto err_cq;
+
+	err = mlx5_aso_create_sq(mdev, numa_node, pdn, aso);
+	if (err)
+		goto err_sq;
+
+	return aso;
+
+err_sq:
+	mlx5_aso_destroy_cq(&aso->cq);
+err_cq:
+	kfree(aso);
+	return ERR_PTR(err);
+}
+
+void mlx5_aso_destroy(struct mlx5_aso *aso)
+{
+	if (IS_ERR_OR_NULL(aso))
+		return;
+
+	mlx5_aso_destroy_sq(aso);
+	mlx5_aso_destroy_cq(&aso->cq);
+	kfree(aso);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
new file mode 100644
index 000000000000..55496513d1f9
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_LIB_ASO_H__
+#define __MLX5_LIB_ASO_H__
+
+#include "mlx5_core.h"
+
+struct mlx5_aso;
+
+struct mlx5_aso *mlx5_aso_create(struct mlx5_core_dev *mdev, u32 pdn);
+void mlx5_aso_destroy(struct mlx5_aso *aso);
+#endif /* __MLX5_LIB_ASO_H__ */
-- 
2.36.1

