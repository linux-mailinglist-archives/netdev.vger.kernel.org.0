Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEB685B09E
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfF3QYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbfF3QYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 12:24:18 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2368420828;
        Sun, 30 Jun 2019 16:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561911856;
        bh=Xo9gpK67TjgbWGpDqXHmR59dcR2JE7Zv53GjZwlcsa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISALtin7wF2yijNJF6HrtUZ/ODjlc51nO+sCSbrUjOIjwS3fF7ROiLe6eeVQr2777
         QNjz40fKZZ8/8oE2IB5NbYACL8cnXuMAh+B00Ijnjee01WDaeWcTS8ckC6r102N7NX
         ny763eYscbzaFJWc7Mt75hlJdGkQSyNQsAPpjZkA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next v2 02/13] net/mlx5: Use event mask based on device capabilities
Date:   Sun, 30 Jun 2019 19:23:23 +0300
Message-Id: <20190630162334.22135-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190630162334.22135-1-leon@kernel.org>
References: <20190630162334.22135-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Use the reported device capabilities for the supported user events (i.e.
affiliated and un-affiliated) to set the EQ mask.

As the event mask can be up to 256 defined by 4 entries of u64 change
the applicable code to work accordingly.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c             |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 40 ++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/fw.c |  6 +++
 include/linux/mlx5/device.h                  |  6 ++-
 include/linux/mlx5/eq.h                      |  2 +-
 include/linux/mlx5/mlx5_ifc.h                | 13 +++++--
 6 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 600fe23e2eae..346a7ffd63aa 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1559,9 +1559,9 @@ mlx5_ib_create_pf_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 	eq->irq_nb.notifier_call = mlx5_ib_eq_pf_int;
 	param = (struct mlx5_eq_param) {
 		.irq_index = 0,
-		.mask = 1 << MLX5_EVENT_TYPE_PAGE_FAULT,
 		.nent = MLX5_IB_NUM_PF_EQE,
 	};
+	param.mask[0] = 1ull << MLX5_EVENT_TYPE_PAGE_FAULT;
 	eq->core = mlx5_eq_create_generic(dev->mdev, &param);
 	if (IS_ERR(eq->core)) {
 		err = PTR_ERR(eq->core);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 8000d2a4a7e2..33f78d4d3724 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -256,6 +256,7 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	int inlen;
 	u32 *in;
 	int err;
+	int i;
 
 	/* Init CQ table */
 	memset(cq_table, 0, sizeof(*cq_table));
@@ -283,10 +284,12 @@ create_map_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	mlx5_fill_page_array(&eq->buf, pas);
 
 	MLX5_SET(create_eq_in, in, opcode, MLX5_CMD_OP_CREATE_EQ);
-	if (!param->mask && MLX5_CAP_GEN(dev, log_max_uctx))
+	if (!param->mask[0] && MLX5_CAP_GEN(dev, log_max_uctx))
 		MLX5_SET(create_eq_in, in, uid, MLX5_SHARED_RESOURCE_UID);
 
-	MLX5_SET64(create_eq_in, in, event_bitmask, param->mask);
+	for (i = 0; i < 4; i++)
+		MLX5_ARRAY_SET64(create_eq_in, in, event_bitmask, i,
+				 param->mask[i]);
 
 	eqc = MLX5_ADDR_OF(create_eq_in, in, eq_context_entry);
 	MLX5_SET(eqc, eqc, log_eq_size, ilog2(eq->nent));
@@ -507,7 +510,23 @@ static int cq_err_event_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-static u64 gather_async_events_mask(struct mlx5_core_dev *dev)
+static void gather_user_async_events(struct mlx5_core_dev *dev, u64 mask[4])
+{
+	__be64 *user_unaffiliated_events;
+	__be64 *user_affiliated_events;
+	int i;
+
+	user_affiliated_events =
+		MLX5_CAP_DEV_EVENT(dev, user_affiliated_events);
+	user_unaffiliated_events =
+		MLX5_CAP_DEV_EVENT(dev, user_unaffiliated_events);
+
+	for (i = 0; i < 4; i++)
+		mask[i] |= be64_to_cpu(user_affiliated_events[i] |
+				       user_unaffiliated_events[i]);
+}
+
+static void gather_async_events_mask(struct mlx5_core_dev *dev, u64 mask[4])
 {
 	u64 async_event_mask = MLX5_ASYNC_EVENT_MASK;
 
@@ -544,7 +563,10 @@ static u64 gather_async_events_mask(struct mlx5_core_dev *dev)
 		async_event_mask |=
 			(1ull << MLX5_EVENT_TYPE_ESW_FUNCTIONS_CHANGED);
 
-	return async_event_mask;
+	mask[0] = async_event_mask;
+
+	if (MLX5_CAP_GEN(dev, event_cap))
+		gather_user_async_events(dev, mask);
 }
 
 static int create_async_eqs(struct mlx5_core_dev *dev)
@@ -559,9 +581,10 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	table->cmd_eq.irq_nb.notifier_call = mlx5_eq_async_int;
 	param = (struct mlx5_eq_param) {
 		.irq_index = 0,
-		.mask = 1ull << MLX5_EVENT_TYPE_CMD,
 		.nent = MLX5_NUM_CMD_EQE,
 	};
+
+	param.mask[0] = 1ull << MLX5_EVENT_TYPE_CMD;
 	err = create_async_eq(dev, &table->cmd_eq.core, &param);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create cmd EQ %d\n", err);
@@ -577,9 +600,10 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	table->async_eq.irq_nb.notifier_call = mlx5_eq_async_int;
 	param = (struct mlx5_eq_param) {
 		.irq_index = 0,
-		.mask = gather_async_events_mask(dev),
 		.nent = MLX5_NUM_ASYNC_EQE,
 	};
+
+	gather_async_events_mask(dev, param.mask);
 	err = create_async_eq(dev, &table->async_eq.core, &param);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create async EQ %d\n", err);
@@ -595,9 +619,10 @@ static int create_async_eqs(struct mlx5_core_dev *dev)
 	table->pages_eq.irq_nb.notifier_call = mlx5_eq_async_int;
 	param = (struct mlx5_eq_param) {
 		.irq_index = 0,
-		.mask =  1 << MLX5_EVENT_TYPE_PAGE_REQUEST,
 		.nent = /* TODO: sriov max_vf + */ 1,
 	};
+
+	param.mask[0] = 1ull << MLX5_EVENT_TYPE_PAGE_REQUEST;
 	err = create_async_eq(dev, &table->pages_eq.core, &param);
 	if (err) {
 		mlx5_core_warn(dev, "failed to create pages EQ %d\n", err);
@@ -789,7 +814,6 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 		eq->irq_nb.notifier_call = mlx5_eq_comp_int;
 		param = (struct mlx5_eq_param) {
 			.irq_index = vecidx,
-			.mask = 0,
 			.nent = nent,
 		};
 		err = create_map_eq(dev, &eq->core, &param);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 1ab6f7e3bec6..05367f15c3a7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -202,6 +202,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
+	if (MLX5_CAP_GEN(dev, event_cap)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_DEV_EVENT);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 5e760067ac41..0d1abe097627 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -351,7 +351,7 @@ enum mlx5_event {
 
 	MLX5_EVENT_TYPE_DEVICE_TRACER      = 0x26,
 
-	MLX5_EVENT_TYPE_MAX                = MLX5_EVENT_TYPE_DEVICE_TRACER + 1,
+	MLX5_EVENT_TYPE_MAX                = 0x100,
 };
 
 enum {
@@ -1077,6 +1077,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_DEBUG,
 	MLX5_CAP_RESERVED_14,
 	MLX5_CAP_DEV_MEM,
+	MLX5_CAP_DEV_EVENT = 0x14,
 	/* NUM OF CAP Types */
 	MLX5_CAP_NUM
 };
@@ -1255,6 +1256,9 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP64_DEV_MEM(mdev, cap)\
 	MLX5_GET64(device_mem_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_MEM], cap)
 
+#define MLX5_CAP_DEV_EVENT(mdev, cap)\
+	MLX5_ADDR_OF(device_event_cap, (mdev)->caps.hca_cur[MLX5_CAP_DEV_EVENT], cap)
+
 enum {
 	MLX5_CMD_STAT_OK			= 0x0,
 	MLX5_CMD_STAT_INT_ERR			= 0x1,
diff --git a/include/linux/mlx5/eq.h b/include/linux/mlx5/eq.h
index 70e16dcfb4c4..e49d8c0d4f26 100644
--- a/include/linux/mlx5/eq.h
+++ b/include/linux/mlx5/eq.h
@@ -15,7 +15,7 @@ struct mlx5_core_dev;
 struct mlx5_eq_param {
 	u8             irq_index;
 	int            nent;
-	u64            mask;
+	u64            mask[4];
 };
 
 struct mlx5_eq *
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 16348528fef6..3ef716c054c2 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -823,6 +823,12 @@ struct mlx5_ifc_device_mem_cap_bits {
 	u8         reserved_at_180[0x680];
 };
 
+struct mlx5_ifc_device_event_cap_bits {
+	u8         user_affiliated_events[4][0x40];
+
+	u8         user_unaffiliated_events[4][0x40];
+};
+
 enum {
 	MLX5_ATOMIC_CAPS_ATOMIC_SIZE_QP_1_BYTE     = 0x0,
 	MLX5_ATOMIC_CAPS_ATOMIC_SIZE_QP_2_BYTES    = 0x2,
@@ -980,7 +986,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         log_max_srq_sz[0x8];
 	u8         log_max_qp_sz[0x8];
-	u8         reserved_at_90[0x8];
+	u8         event_cap[0x1];
+	u8         reserved_at_91[0x7];
 	u8         prio_tag_required[0x1];
 	u8         reserved_at_99[0x2];
 	u8         log_max_qp[0x5];
@@ -7364,9 +7371,9 @@ struct mlx5_ifc_create_eq_in_bits {
 
 	u8         reserved_at_280[0x40];
 
-	u8         event_bitmask[0x40];
+	u8         event_bitmask[4][0x40];
 
-	u8         reserved_at_300[0x580];
+	u8         reserved_at_3c0[0x4c0];
 
 	u8         pas[0][0x40];
 };
-- 
2.20.1

