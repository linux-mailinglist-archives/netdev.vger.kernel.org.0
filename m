Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258C427F8B5
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 06:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730501AbgJAEdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 00:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgJAEdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 00:33:20 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DABCF2220D;
        Thu,  1 Oct 2020 04:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601526799;
        bh=SR8/wHw7T9v0P1CbabLOyb0SP7MieB+tVRR4jnRJ8hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJyuUUT1qtJ7DRff+WnMDvbah0Izb6cspwm+sYFXYsIoj1oqwGow+v1obbPFJ7iML
         SzVt0StYdsfknmlnaczl/PBTl/GOP13wWQfIxLN6wP9sDXCbJY28yK/VmoCySA5vVf
         PMwN+SHvXEXIuAAtpqp8hxERmY0TXw6WfvbhgpGQ=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5: Use dma device access helper
Date:   Wed, 30 Sep 2020 21:32:59 -0700
Message-Id: <20201001043302.48113-13-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001043302.48113-1-saeed@kernel.org>
References: <20201001043302.48113-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Use the PCI device directly for dma accesses as non PCI device unlikely
support IOMMU and dma mappings.
Introduce and use helper routine to access DMA device.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c    | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 14 +++++---------
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  6 ++++--
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |  2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 12 ++++++------
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  2 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  5 +++++
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  4 ++--
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  4 ++--
 12 files changed, 37 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
index 8db4b5f0f963..291e427e9e4f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
@@ -56,8 +56,8 @@ static void *mlx5_dma_zalloc_coherent_node(struct mlx5_core_dev *dev,
 					   size_t size, dma_addr_t *dma_handle,
 					   int node)
 {
+	struct device *device = mlx5_core_dma_dev(dev);
 	struct mlx5_priv *priv = &dev->priv;
-	struct device *device = dev->device;
 	int original_node;
 	void *cpu_handle;
 
@@ -111,7 +111,7 @@ EXPORT_SYMBOL(mlx5_buf_alloc);
 
 void mlx5_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf)
 {
-	dma_free_coherent(dev->device, buf->size, buf->frags->buf,
+	dma_free_coherent(mlx5_core_dma_dev(dev), buf->size, buf->frags->buf,
 			  buf->frags->map);
 
 	kfree(buf->frags);
@@ -140,7 +140,7 @@ int mlx5_frag_buf_alloc_node(struct mlx5_core_dev *dev, int size,
 		if (!frag->buf)
 			goto err_free_buf;
 		if (frag->map & ((1 << buf->page_shift) - 1)) {
-			dma_free_coherent(dev->device, frag_sz,
+			dma_free_coherent(mlx5_core_dma_dev(dev), frag_sz,
 					  buf->frags[i].buf, buf->frags[i].map);
 			mlx5_core_warn(dev, "unexpected map alignment: %pad, page_shift=%d\n",
 				       &frag->map, buf->page_shift);
@@ -153,7 +153,7 @@ int mlx5_frag_buf_alloc_node(struct mlx5_core_dev *dev, int size,
 
 err_free_buf:
 	while (i--)
-		dma_free_coherent(dev->device, PAGE_SIZE, buf->frags[i].buf,
+		dma_free_coherent(mlx5_core_dma_dev(dev), PAGE_SIZE, buf->frags[i].buf,
 				  buf->frags[i].map);
 	kfree(buf->frags);
 err_out:
@@ -169,7 +169,7 @@ void mlx5_frag_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf)
 	for (i = 0; i < buf->npages; i++) {
 		int frag_sz = min_t(int, size, PAGE_SIZE);
 
-		dma_free_coherent(dev->device, frag_sz, buf->frags[i].buf,
+		dma_free_coherent(mlx5_core_dma_dev(dev), frag_sz, buf->frags[i].buf,
 				  buf->frags[i].map);
 		size -= frag_sz;
 	}
@@ -275,7 +275,7 @@ void mlx5_db_free(struct mlx5_core_dev *dev, struct mlx5_db *db)
 	__set_bit(db->index, db->u.pgdir->bitmap);
 
 	if (bitmap_full(db->u.pgdir->bitmap, db_per_page)) {
-		dma_free_coherent(dev->device, PAGE_SIZE,
+		dma_free_coherent(mlx5_core_dma_dev(dev), PAGE_SIZE,
 				  db->u.pgdir->db_page, db->u.pgdir->db_dma);
 		list_del(&db->u.pgdir->list);
 		bitmap_free(db->u.pgdir->bitmap);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 1d91a0d0ab1d..1ccae653319f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1899,9 +1899,7 @@ static void create_msg_cache(struct mlx5_core_dev *dev)
 
 static int alloc_cmd_page(struct mlx5_core_dev *dev, struct mlx5_cmd *cmd)
 {
-	struct device *ddev = dev->device;
-
-	cmd->cmd_alloc_buf = dma_alloc_coherent(ddev, MLX5_ADAPTER_PAGE_SIZE,
+	cmd->cmd_alloc_buf = dma_alloc_coherent(mlx5_core_dma_dev(dev), MLX5_ADAPTER_PAGE_SIZE,
 						&cmd->alloc_dma, GFP_KERNEL);
 	if (!cmd->cmd_alloc_buf)
 		return -ENOMEM;
@@ -1914,9 +1912,9 @@ static int alloc_cmd_page(struct mlx5_core_dev *dev, struct mlx5_cmd *cmd)
 		return 0;
 	}
 
-	dma_free_coherent(ddev, MLX5_ADAPTER_PAGE_SIZE, cmd->cmd_alloc_buf,
+	dma_free_coherent(mlx5_core_dma_dev(dev), MLX5_ADAPTER_PAGE_SIZE, cmd->cmd_alloc_buf,
 			  cmd->alloc_dma);
-	cmd->cmd_alloc_buf = dma_alloc_coherent(ddev,
+	cmd->cmd_alloc_buf = dma_alloc_coherent(mlx5_core_dma_dev(dev),
 						2 * MLX5_ADAPTER_PAGE_SIZE - 1,
 						&cmd->alloc_dma, GFP_KERNEL);
 	if (!cmd->cmd_alloc_buf)
@@ -1930,9 +1928,7 @@ static int alloc_cmd_page(struct mlx5_core_dev *dev, struct mlx5_cmd *cmd)
 
 static void free_cmd_page(struct mlx5_core_dev *dev, struct mlx5_cmd *cmd)
 {
-	struct device *ddev = dev->device;
-
-	dma_free_coherent(ddev, cmd->alloc_size, cmd->cmd_alloc_buf,
+	dma_free_coherent(mlx5_core_dma_dev(dev), cmd->alloc_size, cmd->cmd_alloc_buf,
 			  cmd->alloc_dma);
 }
 
@@ -1964,7 +1960,7 @@ int mlx5_cmd_init(struct mlx5_core_dev *dev)
 	if (!cmd->stats)
 		return -ENOMEM;
 
-	cmd->pool = dma_pool_create("mlx5_cmd", dev->device, size, align, 0);
+	cmd->pool = dma_pool_create("mlx5_cmd", mlx5_core_dma_dev(dev), size, align, 0);
 	if (!cmd->pool) {
 		err = -ENOMEM;
 		goto dma_pool_err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index ad3594c4afcb..ede4640b8428 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -124,7 +124,7 @@ static void mlx5_fw_tracer_ownership_release(struct mlx5_fw_tracer *tracer)
 static int mlx5_fw_tracer_create_log_buf(struct mlx5_fw_tracer *tracer)
 {
 	struct mlx5_core_dev *dev = tracer->dev;
-	struct device *ddev = &dev->pdev->dev;
+	struct device *ddev;
 	dma_addr_t dma;
 	void *buff;
 	gfp_t gfp;
@@ -142,6 +142,7 @@ static int mlx5_fw_tracer_create_log_buf(struct mlx5_fw_tracer *tracer)
 	}
 	tracer->buff.log_buf = buff;
 
+	ddev = mlx5_core_dma_dev(dev);
 	dma = dma_map_single(ddev, buff, tracer->buff.size, DMA_FROM_DEVICE);
 	if (dma_mapping_error(ddev, dma)) {
 		mlx5_core_warn(dev, "FWTracer: Unable to map DMA: %d\n",
@@ -162,11 +163,12 @@ static int mlx5_fw_tracer_create_log_buf(struct mlx5_fw_tracer *tracer)
 static void mlx5_fw_tracer_destroy_log_buf(struct mlx5_fw_tracer *tracer)
 {
 	struct mlx5_core_dev *dev = tracer->dev;
-	struct device *ddev = &dev->pdev->dev;
+	struct device *ddev;
 
 	if (!tracer->buff.log_buf)
 		return;
 
+	ddev = mlx5_core_dma_dev(dev);
 	dma_unmap_single(ddev, tracer->buff.dma, tracer->buff.size, DMA_FROM_DEVICE);
 	free_pages((unsigned long)tracer->buff.log_buf, get_order(tracer->buff.size));
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
index 4924a5658853..ed4fb79b4db7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -78,7 +78,7 @@ static int mlx5_rsc_dump_trigger(struct mlx5_core_dev *dev, struct mlx5_rsc_dump
 				 struct page *page)
 {
 	struct mlx5_rsc_dump *rsc_dump = dev->rsc_dump;
-	struct device *ddev = &dev->pdev->dev;
+	struct device *ddev = mlx5_core_dma_dev(dev);
 	u32 out_seq_num;
 	u32 in_seq_num;
 	dma_addr_t dma;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
index 3503e7711178..71e8d66fa150 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
@@ -9,7 +9,7 @@
 static int mlx5e_xsk_map_pool(struct mlx5e_priv *priv,
 			      struct xsk_buff_pool *pool)
 {
-	struct device *dev = priv->mdev->device;
+	struct device *dev = mlx5_core_dma_dev(priv->mdev);
 
 	return xsk_pool_dma_map(pool, dev, 0);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 6bbfcf18107d..ccaccb9fc2f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -253,7 +253,7 @@ resync_post_get_progress_params(struct mlx5e_icosq *sq,
 		goto err_out;
 	}
 
-	pdev = sq->channel->priv->mdev->device;
+	pdev = mlx5_core_dma_dev(sq->channel->priv->mdev);
 	buf->dma_addr = dma_map_single(pdev, &buf->progress,
 				       PROGRESS_PARAMS_PADDED_SIZE, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(pdev, buf->dma_addr))) {
@@ -390,7 +390,7 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 
 	priv_rx = buf->priv_rx;
 	resync = &priv_rx->resync;
-	dev = resync->priv->mdev->device;
+	dev = mlx5_core_dma_dev(resync->priv->mdev);
 	if (unlikely(test_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags)))
 		goto out;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 961cdce37cc4..2c3c594a8621 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1943,7 +1943,7 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	c->tstamp   = &priv->tstamp;
 	c->ix       = ix;
 	c->cpu      = cpu;
-	c->pdev     = priv->mdev->device;
+	c->pdev     = mlx5_core_dma_dev(priv->mdev);
 	c->netdev   = priv->netdev;
 	c->mkey_be  = cpu_to_be32(priv->mdev->mlx5e_res.mkey.key);
 	c->num_tc   = params->num_tc;
@@ -2131,7 +2131,7 @@ void mlx5e_build_rq_param(struct mlx5e_priv *priv,
 	MLX5_SET(rqc, rqc, vsd,            params->vlan_strip_disable);
 	MLX5_SET(rqc, rqc, scatter_fcs,    params->scatter_fcs_en);
 
-	param->wq.buf_numa_node = dev_to_node(mdev->device);
+	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
 	mlx5e_build_rx_cq_param(priv, params, xsk, &param->cqp);
 }
 
@@ -2147,7 +2147,7 @@ static void mlx5e_build_drop_rq_param(struct mlx5e_priv *priv,
 		 mlx5e_get_rqwq_log_stride(MLX5_WQ_TYPE_CYCLIC, 1));
 	MLX5_SET(rqc, rqc, counter_set_id, priv->drop_rq_q_counter);
 
-	param->wq.buf_numa_node = dev_to_node(mdev->device);
+	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
 }
 
 void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
@@ -2159,7 +2159,7 @@ void mlx5e_build_sq_param_common(struct mlx5e_priv *priv,
 	MLX5_SET(wq, wq, log_wq_stride, ilog2(MLX5_SEND_WQE_BB));
 	MLX5_SET(wq, wq, pd,            priv->mdev->mlx5e_res.pdn);
 
-	param->wq.buf_numa_node = dev_to_node(priv->mdev->device);
+	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(priv->mdev));
 }
 
 static void mlx5e_build_sq_param(struct mlx5e_priv *priv,
@@ -3197,8 +3197,8 @@ static int mlx5e_alloc_drop_cq(struct mlx5_core_dev *mdev,
 			       struct mlx5e_cq *cq,
 			       struct mlx5e_cq_param *param)
 {
-	param->wq.buf_numa_node = dev_to_node(mdev->device);
-	param->wq.db_numa_node  = dev_to_node(mdev->device);
+	param->wq.buf_numa_node = dev_to_node(mlx5_core_dma_dev(mdev));
+	param->wq.db_numa_node  = dev_to_node(mlx5_core_dma_dev(mdev));
 
 	return mlx5e_alloc_cq_common(mdev, param, cq);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 9f6d97eae0ae..80da50e12915 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -54,7 +54,7 @@ static int mlx5_fpga_conn_map_buf(struct mlx5_fpga_conn *conn,
 	if (unlikely(!buf->sg[0].data))
 		goto out;
 
-	dma_device = &conn->fdev->mdev->pdev->dev;
+	dma_device = mlx5_core_dma_dev(conn->fdev->mdev);
 	buf->sg[0].dma_addr = dma_map_single(dma_device, buf->sg[0].data,
 					     buf->sg[0].size, buf->dma_dir);
 	err = dma_mapping_error(dma_device, buf->sg[0].dma_addr);
@@ -86,7 +86,7 @@ static void mlx5_fpga_conn_unmap_buf(struct mlx5_fpga_conn *conn,
 {
 	struct device *dma_device;
 
-	dma_device = &conn->fdev->mdev->pdev->dev;
+	dma_device = mlx5_core_dma_dev(conn->fdev->mdev);
 	if (buf->sg[1].data)
 		dma_unmap_single(dma_device, buf->sg[1].dma_addr,
 				 buf->sg[1].size, buf->dma_dir);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index ce43e3feccd9..3bd32c05ae71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -739,7 +739,7 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct pci_dev *pdev,
 	pci_set_drvdata(dev->pdev, dev);
 
 	dev->bar_addr = pci_resource_start(pdev, 0);
-	priv->numa_node = dev_to_node(&dev->pdev->dev);
+	priv->numa_node = dev_to_node(mlx5_core_dma_dev(dev));
 
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index fc1649dac11b..e994f84f50b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -100,6 +100,11 @@ do {								\
 			     __func__, __LINE__, current->pid,	\
 			     ##__VA_ARGS__)
 
+static inline struct device *mlx5_core_dma_dev(struct mlx5_core_dev *dev)
+{
+	return &dev->pdev->dev;
+}
+
 enum {
 	MLX5_CMD_DATA, /* print command payload only */
 	MLX5_CMD_TIME, /* print command execution time */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index f9b798af6335..0809b2a14319 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -238,7 +238,7 @@ static void free_fwp(struct mlx5_core_dev *dev, struct fw_page *fwp,
 	rb_erase(&fwp->rb_node, root);
 	if (in_free_list)
 		list_del(&fwp->list);
-	dma_unmap_page(dev->device, fwp->addr & MLX5_U64_4K_PAGE_MASK,
+	dma_unmap_page(mlx5_core_dma_dev(dev), fwp->addr & MLX5_U64_4K_PAGE_MASK,
 		       PAGE_SIZE, DMA_BIDIRECTIONAL);
 	__free_page(fwp->page);
 	kfree(fwp);
@@ -265,7 +265,7 @@ static void free_4k(struct mlx5_core_dev *dev, u64 addr, u32 func_id)
 
 static int alloc_system_page(struct mlx5_core_dev *dev, u16 func_id)
 {
-	struct device *device = dev->device;
+	struct device *device = mlx5_core_dma_dev(dev);
 	int nid = dev_to_node(device);
 	struct page *page;
 	u64 zero_addr = 1;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 3d77f7d9fbdf..24dede1b0a20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -831,7 +831,7 @@ static struct mlx5dr_mr *dr_reg_mr(struct mlx5_core_dev *mdev,
 	if (!mr)
 		return NULL;
 
-	dma_device = &mdev->pdev->dev;
+	dma_device = mlx5_core_dma_dev(mdev);
 	dma_addr = dma_map_single(dma_device, buf, size,
 				  DMA_BIDIRECTIONAL);
 	err = dma_mapping_error(dma_device, dma_addr);
@@ -860,7 +860,7 @@ static struct mlx5dr_mr *dr_reg_mr(struct mlx5_core_dev *mdev,
 static void dr_dereg_mr(struct mlx5_core_dev *mdev, struct mlx5dr_mr *mr)
 {
 	mlx5_core_destroy_mkey(mdev, &mr->mkey);
-	dma_unmap_single(&mdev->pdev->dev, mr->dma_addr, mr->size,
+	dma_unmap_single(mlx5_core_dma_dev(mdev), mr->dma_addr, mr->size,
 			 DMA_BIDIRECTIONAL);
 	kfree(mr);
 }
-- 
2.26.2

