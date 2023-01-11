Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7E66653CD
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbjAKFjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbjAKFhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:37:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DE5B4E
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:30:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4ADBB81AD8
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E354C433F1;
        Wed, 11 Jan 2023 05:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673415051;
        bh=4A2wGE7DVRNHfZM2T2xTqEl/hOJZl/hggCorngRSHBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5nDdhbCo2hdRfr4COMC8Jhg4E3aKeSoTys8O0UjfifvX058so5VJ5W6yAc3PTHzs
         Lkuu7aLF93Hbz83YPHJv6FL42Wd/6OqmBtjubsACwci0xpVLCGBvYny95URJ21fw3L
         DCU8hW57OkCAjntKJBSFYiuEVjlOpRKZr3FYFkq4hh7DxGlEhRkxF1Xbsz7WGTmPHD
         wzF8gXrw1guFCrWeHcat83g01/rX92EpAxHd03ewCe4dkx+7UKcsBCKbztE2NIahQn
         Llt3/IzbTQEL29B4DGJBZa2QYgf0ty846q9KQDbWQCGSiUHfuYQqHRcxfyBtsnJU+h
         4ykzrLBDKg6Cg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: Update shared buffer along with device buffer changes
Date:   Tue, 10 Jan 2023 21:30:33 -0800
Message-Id: <20230111053045.413133-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111053045.413133-1-saeed@kernel.org>
References: <20230111053045.413133-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

Currently, the user can modify device's receive buffer size, modify the
mapping between QoS priority groups to buffers and change the buffer
state to become lossy/lossless via pfc command.

However, the shared receive buffer pool alignments, as a result of
such commands, is performed only when the shared buffer is in FW ownership.
When a user changes the mapping of priority groups or buffer size,
the shared buffer is moved to SW ownership.

Therefore, for devices that support shared buffer, handle the shared buffer
alignments in accordance to user's desired configurations.

Meaning, the following will be performed:
1. For every change of buffer's headroom, recalculate the size of shared
   buffer to be equal to "total_buffer_size" - "new_headroom_size".
   The new shared buffer size will be split in ratio of 3:1 between
   lossy and lossless pools, respectively.

2. For each port buffer change, count the number of lossless buffers.
   If there is only one lossless buffer, then set its lossless pool
   usage threshold to be infinite. Otherwise, if there is more than
   one lossless buffer, set a usage threshold for each lossless buffer.

While at it, add more verbosity to debug prints when handling user
commands, to assist in future debug.

Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/port_buffer.c       | 222 +++++++++++++++++-
 .../mellanox/mlx5/core/en/port_buffer.h       |   1 +
 2 files changed, 219 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index c9d5d8d93994..57f4b1b50421 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -73,6 +73,7 @@ int mlx5e_port_query_buffer(struct mlx5e_priv *priv,
 			  port_buffer->buffer[i].lossy);
 	}
 
+	port_buffer->headroom_size = total_used;
 	port_buffer->port_buffer_size =
 		MLX5_GET(pbmc_reg, out, port_buffer_size) * port_buff_cell_sz;
 	port_buffer->spare_buffer_size =
@@ -86,16 +87,204 @@ int mlx5e_port_query_buffer(struct mlx5e_priv *priv,
 	return err;
 }
 
+struct mlx5e_buffer_pool {
+	u32 infi_size;
+	u32 size;
+	u32 buff_occupancy;
+};
+
+static int mlx5e_port_query_pool(struct mlx5_core_dev *mdev,
+				 struct mlx5e_buffer_pool *buffer_pool,
+				 u32 desc, u8 dir, u8 pool_idx)
+{
+	u32 out[MLX5_ST_SZ_DW(sbpr_reg)] = {};
+	int err;
+
+	err = mlx5e_port_query_sbpr(mdev, desc, dir, pool_idx, out,
+				    sizeof(out));
+	if (err)
+		return err;
+
+	buffer_pool->size = MLX5_GET(sbpr_reg, out, size);
+	buffer_pool->infi_size = MLX5_GET(sbpr_reg, out, infi_size);
+	buffer_pool->buff_occupancy = MLX5_GET(sbpr_reg, out, buff_occupancy);
+
+	return err;
+}
+
+enum {
+	MLX5_INGRESS_DIR = 0,
+	MLX5_EGRESS_DIR = 1,
+};
+
+enum {
+	MLX5_LOSSY_POOL = 0,
+	MLX5_LOSSLESS_POOL = 1,
+};
+
+/* No limit on usage of shared buffer pool (max_buff=0) */
+#define MLX5_SB_POOL_NO_THRESHOLD  0
+/* Shared buffer pool usage threshold when calculated
+ * dynamically in alpha units. alpha=13 is equivalent to
+ * HW_alpha of  [(1/128) * 2 ^ (alpha-1)] = 32, where HW_alpha
+ * equates to the following portion of the shared buffer pool:
+ * [32 / (1 + n * 32)] While *n* is the number of buffers
+ * that are using the shared buffer pool.
+ */
+#define MLX5_SB_POOL_THRESHOLD 13
+
+/* Shared buffer class management parameters */
+struct mlx5_sbcm_params {
+	u8 pool_idx;
+	u8 max_buff;
+	u8 infi_size;
+};
+
+static const struct mlx5_sbcm_params sbcm_default = {
+	.pool_idx = MLX5_LOSSY_POOL,
+	.max_buff = MLX5_SB_POOL_NO_THRESHOLD,
+	.infi_size = 0,
+};
+
+static const struct mlx5_sbcm_params sbcm_lossy = {
+	.pool_idx = MLX5_LOSSY_POOL,
+	.max_buff = MLX5_SB_POOL_NO_THRESHOLD,
+	.infi_size = 1,
+};
+
+static const struct mlx5_sbcm_params sbcm_lossless = {
+	.pool_idx = MLX5_LOSSLESS_POOL,
+	.max_buff = MLX5_SB_POOL_THRESHOLD,
+	.infi_size = 0,
+};
+
+static const struct mlx5_sbcm_params sbcm_lossless_no_threshold = {
+	.pool_idx = MLX5_LOSSLESS_POOL,
+	.max_buff = MLX5_SB_POOL_NO_THRESHOLD,
+	.infi_size = 1,
+};
+
+/**
+ * select_sbcm_params() - selects the shared buffer pool configuration
+ *
+ * @buffer: <input> port buffer to retrieve params of
+ * @lossless_buff_count: <input> number of lossless buffers in total
+ *
+ * The selection is based on the following rules:
+ * 1. If buffer size is 0, no shared buffer pool is used.
+ * 2. If buffer is lossy, use lossy shared buffer pool.
+ * 3. If there are more than 1 lossless buffers, use lossless shared buffer pool
+ *    with threshold.
+ * 4. If there is only 1 lossless buffer, use lossless shared buffer pool
+ *    without threshold.
+ *
+ * @return const struct mlx5_sbcm_params* selected values
+ */
+static const struct mlx5_sbcm_params *
+select_sbcm_params(struct mlx5e_bufferx_reg *buffer, u8 lossless_buff_count)
+{
+	if (buffer->size == 0)
+		return &sbcm_default;
+
+	if (buffer->lossy)
+		return &sbcm_lossy;
+
+	if (lossless_buff_count > 1)
+		return &sbcm_lossless;
+
+	return &sbcm_lossless_no_threshold;
+}
+
+static int port_update_pool_cfg(struct mlx5_core_dev *mdev,
+				struct mlx5e_port_buffer *port_buffer)
+{
+	const struct mlx5_sbcm_params *p;
+	u8 lossless_buff_count = 0;
+	int err;
+	int i;
+
+	if (!MLX5_CAP_GEN(mdev, sbcam_reg))
+		return 0;
+
+	for (i = 0; i < MLX5E_MAX_BUFFER; i++)
+		lossless_buff_count += ((port_buffer->buffer[i].size) &&
+				       (!(port_buffer->buffer[i].lossy)));
+
+	for (i = 0; i < MLX5E_MAX_BUFFER; i++) {
+		p = select_sbcm_params(&port_buffer->buffer[i], lossless_buff_count);
+		err = mlx5e_port_set_sbcm(mdev, 0, i,
+					  MLX5_INGRESS_DIR,
+					  p->infi_size,
+					  p->max_buff,
+					  p->pool_idx);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int port_update_shared_buffer(struct mlx5_core_dev *mdev,
+				     u32 current_headroom_size,
+				     u32 new_headroom_size)
+{
+	struct mlx5e_buffer_pool lossless_ipool;
+	struct mlx5e_buffer_pool lossy_epool;
+	u32 lossless_ipool_size;
+	u32 shared_buffer_size;
+	u32 total_buffer_size;
+	u32 lossy_epool_size;
+	int err;
+
+	if (!MLX5_CAP_GEN(mdev, sbcam_reg))
+		return 0;
+
+	err = mlx5e_port_query_pool(mdev, &lossy_epool, 0, MLX5_EGRESS_DIR,
+				    MLX5_LOSSY_POOL);
+	if (err)
+		return err;
+
+	err = mlx5e_port_query_pool(mdev, &lossless_ipool, 0, MLX5_INGRESS_DIR,
+				    MLX5_LOSSLESS_POOL);
+	if (err)
+		return err;
+
+	total_buffer_size = current_headroom_size + lossy_epool.size +
+			    lossless_ipool.size;
+	shared_buffer_size = total_buffer_size - new_headroom_size;
+
+	if (shared_buffer_size < 4) {
+		pr_err("Requested port buffer is too large, not enough space left for shared buffer\n");
+		return -EINVAL;
+	}
+
+	/* Total shared buffer size is split in a ratio of 3:1 between
+	 * lossy and lossless pools respectively.
+	 */
+	lossy_epool_size = (shared_buffer_size / 4) * 3;
+	lossless_ipool_size = shared_buffer_size / 4;
+
+	mlx5e_port_set_sbpr(mdev, 0, MLX5_EGRESS_DIR, MLX5_LOSSY_POOL, 0,
+			    lossy_epool_size);
+	mlx5e_port_set_sbpr(mdev, 0, MLX5_INGRESS_DIR, MLX5_LOSSLESS_POOL, 0,
+			    lossless_ipool_size);
+	return 0;
+}
+
 static int port_set_buffer(struct mlx5e_priv *priv,
 			   struct mlx5e_port_buffer *port_buffer)
 {
 	u16 port_buff_cell_sz = priv->dcbx.port_buff_cell_sz;
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int sz = MLX5_ST_SZ_BYTES(pbmc_reg);
+	u32 new_headroom_size = 0;
+	u32 current_headroom_size;
 	void *in;
 	int err;
 	int i;
 
+	current_headroom_size = port_buffer->headroom_size;
+
 	in = kzalloc(sz, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
@@ -110,6 +299,7 @@ static int port_set_buffer(struct mlx5e_priv *priv,
 		u64 xoff = port_buffer->buffer[i].xoff;
 		u64 xon = port_buffer->buffer[i].xon;
 
+		new_headroom_size += size;
 		do_div(size, port_buff_cell_sz);
 		do_div(xoff, port_buff_cell_sz);
 		do_div(xon, port_buff_cell_sz);
@@ -119,6 +309,17 @@ static int port_set_buffer(struct mlx5e_priv *priv,
 		MLX5_SET(bufferx_reg, buffer, xon_threshold, xon);
 	}
 
+	new_headroom_size /= port_buff_cell_sz;
+	current_headroom_size /= port_buff_cell_sz;
+	err = port_update_shared_buffer(priv->mdev, current_headroom_size,
+					new_headroom_size);
+	if (err)
+		return err;
+
+	err = port_update_pool_cfg(priv->mdev, port_buffer);
+	if (err)
+		return err;
+
 	err = mlx5e_port_set_pbmc(mdev, in);
 out:
 	kfree(in);
@@ -174,6 +375,7 @@ static int update_xoff_threshold(struct mlx5e_port_buffer *port_buffer,
 
 /**
  *	update_buffer_lossy	- Update buffer configuration based on pfc
+ *	@mdev: port function core device
  *	@max_mtu: netdev's max_mtu
  *	@pfc_en: <input> current pfc configuration
  *	@buffer: <input> current prio to buffer mapping
@@ -192,7 +394,8 @@ static int update_xoff_threshold(struct mlx5e_port_buffer *port_buffer,
  *	@return: 0 if no error,
  *	sets change to true if buffer configuration was modified.
  */
-static int update_buffer_lossy(unsigned int max_mtu,
+static int update_buffer_lossy(struct mlx5_core_dev *mdev,
+			       unsigned int max_mtu,
 			       u8 pfc_en, u8 *buffer, u32 xoff, u16 port_buff_cell_sz,
 			       struct mlx5e_port_buffer *port_buffer,
 			       bool *change)
@@ -229,6 +432,10 @@ static int update_buffer_lossy(unsigned int max_mtu,
 	}
 
 	if (changed) {
+		err = port_update_pool_cfg(mdev, port_buffer);
+		if (err)
+			return err;
+
 		err = update_xoff_threshold(port_buffer, xoff, max_mtu, port_buff_cell_sz);
 		if (err)
 			return err;
@@ -293,23 +500,30 @@ int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 	}
 
 	if (change & MLX5E_PORT_BUFFER_PFC) {
+		mlx5e_dbg(HW, priv, "%s: requested PFC per priority bitmask: 0x%x\n",
+			  __func__, pfc->pfc_en);
 		err = mlx5e_port_query_priority2buffer(priv->mdev, buffer);
 		if (err)
 			return err;
 
-		err = update_buffer_lossy(max_mtu, pfc->pfc_en, buffer, xoff, port_buff_cell_sz,
-					  &port_buffer, &update_buffer);
+		err = update_buffer_lossy(priv->mdev, max_mtu, pfc->pfc_en, buffer, xoff,
+					  port_buff_cell_sz, &port_buffer,
+					  &update_buffer);
 		if (err)
 			return err;
 	}
 
 	if (change & MLX5E_PORT_BUFFER_PRIO2BUFFER) {
 		update_prio2buffer = true;
+		for (i = 0; i < MLX5E_MAX_BUFFER; i++)
+			mlx5e_dbg(HW, priv, "%s: requested to map prio[%d] to buffer %d\n",
+				  __func__, i, prio2buffer[i]);
+
 		err = fill_pfc_en(priv->mdev, &curr_pfc_en);
 		if (err)
 			return err;
 
-		err = update_buffer_lossy(max_mtu, curr_pfc_en, prio2buffer, xoff,
+		err = update_buffer_lossy(priv->mdev, max_mtu, curr_pfc_en, prio2buffer, xoff,
 					  port_buff_cell_sz, &port_buffer, &update_buffer);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
index 80af7a5ac604..a6ef118de758 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.h
@@ -60,6 +60,7 @@ struct mlx5e_bufferx_reg {
 struct mlx5e_port_buffer {
 	u32                       port_buffer_size;
 	u32                       spare_buffer_size;
+	u32                       headroom_size;
 	struct mlx5e_bufferx_reg  buffer[MLX5E_MAX_BUFFER];
 };
 
-- 
2.39.0

