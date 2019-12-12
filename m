Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E99111CBE5
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 12:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbfLLLJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 06:09:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728613AbfLLLJj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 06:09:39 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BC88227BF;
        Thu, 12 Dec 2019 11:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576148979;
        bh=E5dfRrxP+7Q9Hb6wTtFwVFVtFkeTB9X7d+7CThz+1ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nl/CQC/CjHoWLG2bsnKgW4p1A3GGevZxwDj8K/REMzJ+F08SC40FxomYry4AF5wvg
         cjQg99BsE+uG5MMae4lZXHQZVxPW4gNQTUlot0hB5QCZ9eZY6bCfskh308m3RnFAL7
         5kkNqo9fAVPSAM/i0oD8vynMFWO18dAyFZuorTw4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Shahaf Shuler <shahafs@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 3/5] IB/mlx5: Extend caps stage to handle VAR capabilities
Date:   Thu, 12 Dec 2019 13:09:26 +0200
Message-Id: <20191212110928.334995-4-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191212110928.334995-1-leon@kernel.org>
References: <20191212110928.334995-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Extend caps stage to handle VAR capabilities.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 40 ++++++++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 10 +++++++
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4d89d85226c2..79a5b8824b9d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6335,6 +6335,35 @@ static const struct ib_device_ops mlx5_ib_dev_dm_ops = {
 	.reg_dm_mr = mlx5_ib_reg_dm_mr,
 };
 
+static int mlx5_ib_init_var_table(struct mlx5_ib_dev *dev)
+{
+	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_var_table *var_table = &dev->var_table;
+	u8 log_doorbell_bar_size;
+	u8 log_doorbell_stride;
+	u64 bar_size;
+
+	log_doorbell_bar_size = MLX5_CAP_DEV_VDPA_EMULATION(mdev,
+					log_doorbell_bar_size);
+	log_doorbell_stride = MLX5_CAP_DEV_VDPA_EMULATION(mdev,
+					log_doorbell_stride);
+	var_table->hw_start_addr = dev->mdev->bar_addr +
+				MLX5_CAP64_DEV_VDPA_EMULATION(mdev,
+					doorbell_bar_offset);
+	bar_size = (1ULL << log_doorbell_bar_size) * 4096;
+	var_table->stride_size = 1ULL << log_doorbell_stride;
+	var_table->num_var_hw_entries = bar_size / var_table->stride_size;
+	mutex_init(&var_table->bitmap_lock);
+	var_table->bitmap = bitmap_zalloc(var_table->num_var_hw_entries,
+					  GFP_KERNEL);
+	return (var_table->bitmap) ? 0 : -ENOMEM;
+}
+
+static void mlx5_ib_stage_caps_cleanup(struct mlx5_ib_dev *dev)
+{
+	bitmap_free(dev->var_table.bitmap);
+}
+
 static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_core_dev *mdev = dev->mdev;
@@ -6422,6 +6451,13 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	     MLX5_CAP_GEN(dev->mdev, disable_local_lb_mc)))
 		mutex_init(&dev->lb.mutex);
 
+	if (MLX5_CAP_GEN_64(dev->mdev, general_obj_types) &
+			MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q) {
+		err = mlx5_ib_init_var_table(dev);
+		if (err)
+			return err;
+	}
+
 	dev->ib_dev.use_cq_dim = true;
 
 	return 0;
@@ -6770,7 +6806,7 @@ static const struct mlx5_ib_profile pf_profile = {
 		     mlx5_ib_stage_flow_db_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_CAPS,
 		     mlx5_ib_stage_caps_init,
-		     NULL),
+		     mlx5_ib_stage_caps_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_NON_DEFAULT_CB,
 		     mlx5_ib_stage_non_default_cb,
 		     NULL),
@@ -6827,7 +6863,7 @@ const struct mlx5_ib_profile raw_eth_profile = {
 		     mlx5_ib_stage_flow_db_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_CAPS,
 		     mlx5_ib_stage_caps_init,
-		     NULL),
+		     mlx5_ib_stage_caps_cleanup),
 	STAGE_CREATE(MLX5_IB_STAGE_NON_DEFAULT_CB,
 		     mlx5_ib_stage_raw_eth_non_default_cb,
 		     NULL),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b06f32ff5748..23ad949e247f 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -959,6 +959,15 @@ struct mlx5_devx_event_table {
 	struct xarray event_xa;
 };
 
+struct mlx5_var_table {
+	/* serialize updating the bitmap */
+	struct mutex bitmap_lock;
+	unsigned long *bitmap;
+	u64 hw_start_addr;
+	u32 stride_size;
+	u64 num_var_hw_entries;
+};
+
 struct mlx5_ib_dev {
 	struct ib_device		ib_dev;
 	struct mlx5_core_dev		*mdev;
@@ -1013,6 +1022,7 @@ struct mlx5_ib_dev {
 	struct mlx5_srq_table   srq_table;
 	struct mlx5_async_ctx   async_ctx;
 	struct mlx5_devx_event_table devx_event_table;
+	struct mlx5_var_table var_table;
 
 	struct xarray sig_mrs;
 };
-- 
2.20.1

