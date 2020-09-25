Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957802791EE
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 22:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgIYUTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 16:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727709AbgIYURc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 16:17:32 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52FFD235FD;
        Fri, 25 Sep 2020 19:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601062697;
        bh=3ayZ2mCwYpS+cGBhyQeNrGrVmK4jQ49pkx0by9Qlg3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEQQePEy+XfWN9B0Ii9Nztq+RFLj1yyNJ8YuvuKQXD7Y83DBIcWlueIWaQBJdnDe8
         6B5jY6DVLZ981tgcmaiYEVdz7b69xVTnp09ltGSsSx37ccUw+o1NgB1rDZTZZ5MUA6
         SSo5+jcWA3FS4Jf75ih+dHd+S4tbI9+lN0aPeDtk=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5: DR, Add buddy allocator utilities
Date:   Fri, 25 Sep 2020 12:37:55 -0700
Message-Id: <20200925193809.463047-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925193809.463047-1-saeed@kernel.org>
References: <20200925193809.463047-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add implementation of SW Steering variation of buddy allocator.

The buddy system for ICM memory uses 2 main data structures:
  - Bitmap per order, that keeps the current state of allocated
    blocks for this order
  - Indicator for the number of available blocks per each order

In addition, there is one more hierarchy of searching in the bitmaps
in order to accelerate the search of the next free block which done
via find-first function:
The buddy system spends lots of its time in searching the next free
space using function find_first_bit, which scans a big array of long
values in order to find the first bit. We added one more array of
longs, where each bit indicates a long value in the original array,
that way there is a need for much less searches for the next free area.

For example, for the following bits array of 128 bits where all
bits are zero except for the last bit  :  0000........00001
the corresponding bits-per-long array is:  0001

The search will be done over the bits-per-long array first, and after
the first bit is found, we will use it as a start pointer in the
bigger array (bits array).

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/steering/dr_buddy.c    | 255 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  34 +++
 3 files changed, 290 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 9826a041e407..132786e853aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -80,7 +80,7 @@ mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/tls.o en_accel/tls_rxtx.o en_accel/t
 
 mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o \
 					steering/dr_matcher.o steering/dr_rule.o \
-					steering/dr_icm_pool.o \
+					steering/dr_icm_pool.o steering/dr_buddy.o \
 					steering/dr_ste.o steering/dr_send.o \
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c
new file mode 100644
index 000000000000..9cabf968ac11
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c
@@ -0,0 +1,255 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2004 Topspin Communications. All rights reserved.
+ * Copyright (c) 2005 - 2008 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2006 - 2007 Cisco Systems, Inc. All rights reserved.
+ * Copyright (c) 2020 NVIDIA CORPORATION. All rights reserved.
+ */
+
+#include "dr_types.h"
+
+static unsigned long dr_find_first_bit(const unsigned long *bitmap_per_long,
+				       const unsigned long *bitmap,
+				       unsigned long size)
+{
+	unsigned int bit_per_long_size = DIV_ROUND_UP(size, BITS_PER_LONG);
+	unsigned int bitmap_idx;
+
+	/* find the first free in the first level */
+	bitmap_idx = find_first_bit(bitmap_per_long, bit_per_long_size);
+	/* find the next level */
+	return find_next_bit(bitmap, size, bitmap_idx * BITS_PER_LONG);
+}
+
+int mlx5dr_buddy_init(struct mlx5dr_icm_buddy_mem *buddy,
+		      unsigned int max_order)
+{
+	int i;
+
+	buddy->max_order = max_order;
+
+	INIT_LIST_HEAD(&buddy->list_node);
+	INIT_LIST_HEAD(&buddy->used_list);
+	INIT_LIST_HEAD(&buddy->hot_list);
+
+	buddy->bitmap = kcalloc(buddy->max_order + 1,
+				sizeof(*buddy->bitmap),
+				GFP_KERNEL);
+	buddy->num_free = kcalloc(buddy->max_order + 1,
+				  sizeof(*buddy->num_free),
+				  GFP_KERNEL);
+	buddy->bitmap_per_long = kcalloc(buddy->max_order + 1,
+					 sizeof(*buddy->bitmap_per_long),
+					 GFP_KERNEL);
+
+	if (!buddy->bitmap || !buddy->num_free || !buddy->bitmap_per_long)
+		goto err_free_all;
+
+	/* Allocating max_order bitmaps, one for each order */
+
+	for (i = 0; i <= buddy->max_order; ++i) {
+		unsigned int size = 1 << (buddy->max_order - i);
+
+		buddy->bitmap[i] = bitmap_zalloc(size, GFP_KERNEL);
+		if (!buddy->bitmap[i])
+			goto err_out_free_each_bit_per_order;
+	}
+
+	for (i = 0; i <= buddy->max_order; ++i) {
+		unsigned int size = BITS_TO_LONGS(1 << (buddy->max_order - i));
+
+		buddy->bitmap_per_long[i] = bitmap_zalloc(size, GFP_KERNEL);
+		if (!buddy->bitmap_per_long[i])
+			goto err_out_free_set;
+	}
+
+	/* In the beginning, we have only one order that is available for
+	 * use (the biggest one), so mark the first bit in both bitmaps.
+	 */
+
+	bitmap_set(buddy->bitmap[buddy->max_order], 0, 1);
+	bitmap_set(buddy->bitmap_per_long[buddy->max_order], 0, 1);
+
+	buddy->num_free[buddy->max_order] = 1;
+
+	return 0;
+
+err_out_free_set:
+	for (i = 0; i <= buddy->max_order; ++i)
+		bitmap_free(buddy->bitmap_per_long[i]);
+
+err_out_free_each_bit_per_order:
+	kfree(buddy->bitmap_per_long);
+
+	for (i = 0; i <= buddy->max_order; ++i)
+		bitmap_free(buddy->bitmap[i]);
+
+err_free_all:
+	kfree(buddy->bitmap_per_long);
+	kfree(buddy->num_free);
+	kfree(buddy->bitmap);
+	return -ENOMEM;
+}
+
+void mlx5dr_buddy_cleanup(struct mlx5dr_icm_buddy_mem *buddy)
+{
+	int i;
+
+	list_del(&buddy->list_node);
+
+	for (i = 0; i <= buddy->max_order; ++i) {
+		bitmap_free(buddy->bitmap[i]);
+		bitmap_free(buddy->bitmap_per_long[i]);
+	}
+
+	kfree(buddy->bitmap_per_long);
+	kfree(buddy->num_free);
+	kfree(buddy->bitmap);
+}
+
+/**
+ * dr_buddy_get_seg_borders() - Find the borders of specific segment.
+ * @seg: Segment number.
+ * @low: Pointer to hold the low border of the provided segment.
+ * @high: Pointer to hold the high border of the provided segment.
+ *
+ * Find the borders (high and low) of specific seg (segment location)
+ * of the lower level of the bitmap in order to mark the upper layer
+ * of bitmap.
+ */
+static void dr_buddy_get_seg_borders(unsigned int seg,
+				     unsigned int *low,
+				     unsigned int *high)
+{
+	*low = (seg / BITS_PER_LONG) * BITS_PER_LONG;
+	*high = ((seg / BITS_PER_LONG) + 1) * BITS_PER_LONG;
+}
+
+/**
+ * dr_buddy_update_upper_bitmap() - Update second level bitmap.
+ * @buddy: Buddy to update.
+ * @seg: Segment number.
+ * @order: Order of the buddy to update.
+ *
+ * We have two layers of searching in the bitmaps, so when
+ * needed update the second layer of search.
+ */
+static void dr_buddy_update_upper_bitmap(struct mlx5dr_icm_buddy_mem *buddy,
+					 unsigned long seg,
+					 unsigned int order)
+{
+	unsigned int h, l, m;
+
+	/* clear upper layer of search if needed */
+	dr_buddy_get_seg_borders(seg, &l, &h);
+	m = find_next_bit(buddy->bitmap[order], h, l);
+	if (m == h) /* nothing in the long that includes seg */
+		bitmap_clear(buddy->bitmap_per_long[order],
+			     seg / BITS_PER_LONG, 1);
+}
+
+static int dr_buddy_find_free_seg(struct mlx5dr_icm_buddy_mem *buddy,
+				  unsigned int start_order,
+				  unsigned int *segment,
+				  unsigned int *order)
+{
+	unsigned int seg, order_iter, m;
+
+	for (order_iter = start_order;
+	     order_iter <= buddy->max_order; ++order_iter) {
+		if (!buddy->num_free[order_iter])
+			continue;
+
+		m = 1 << (buddy->max_order - order_iter);
+		seg = dr_find_first_bit(buddy->bitmap_per_long[order_iter],
+					buddy->bitmap[order_iter], m);
+
+		if (WARN(seg >= m,
+			 "ICM Buddy: failed finding free mem for order %d\n",
+			 order_iter))
+			return -ENOMEM;
+
+		break;
+	}
+
+	if (order_iter > buddy->max_order)
+		return -ENOMEM;
+
+	*segment = seg;
+	*order = order_iter;
+	return 0;
+}
+
+/**
+ * mlx5dr_buddy_alloc_mem() - Update second level bitmap.
+ * @buddy: Buddy to update.
+ * @order: Order of the buddy to update.
+ * @segment: Segment number.
+ *
+ * This function finds the first area of the ICM memory managed by this buddy.
+ * It uses the data structures of the buddy system in order to find the first
+ * area of free place, starting from the current order till the maximum order
+ * in the system.
+ *
+ * Return: 0 when segment is set, non-zero error status otherwise.
+ *
+ * The function returns the location (segment) in the whole buddy ICM memory
+ * area - the index of the memory segment that is available for use.
+ */
+int mlx5dr_buddy_alloc_mem(struct mlx5dr_icm_buddy_mem *buddy,
+			   unsigned int order,
+			   unsigned int *segment)
+{
+	unsigned int seg, order_iter;
+	int err;
+
+	err = dr_buddy_find_free_seg(buddy, order, &seg, &order_iter);
+	if (err)
+		return err;
+
+	bitmap_clear(buddy->bitmap[order_iter], seg, 1);
+	/* clear upper layer of search if needed */
+	dr_buddy_update_upper_bitmap(buddy, seg, order_iter);
+	--buddy->num_free[order_iter];
+
+	/* If we found free memory in some order that is bigger than the
+	 * required order, we need to split every order between the required
+	 * order and the order that we found into two parts, and mark accordingly.
+	 */
+	while (order_iter > order) {
+		--order_iter;
+		seg <<= 1;
+		bitmap_set(buddy->bitmap[order_iter], seg ^ 1, 1);
+		bitmap_set(buddy->bitmap_per_long[order_iter],
+			   (seg ^ 1) / BITS_PER_LONG, 1);
+
+		++buddy->num_free[order_iter];
+	}
+
+	seg <<= order;
+	*segment = seg;
+
+	return 0;
+}
+
+void mlx5dr_buddy_free_mem(struct mlx5dr_icm_buddy_mem *buddy,
+			   unsigned int seg, unsigned int order)
+{
+	seg >>= order;
+
+	/* Whenever a segment is free,
+	 * the mem is added to the buddy that gave it.
+	 */
+	while (test_bit(seg ^ 1, buddy->bitmap[order])) {
+		bitmap_clear(buddy->bitmap[order], seg ^ 1, 1);
+		dr_buddy_update_upper_bitmap(buddy, seg ^ 1, order);
+		--buddy->num_free[order];
+		seg >>= 1;
+		++order;
+	}
+	bitmap_set(buddy->bitmap[order], seg, 1);
+	bitmap_set(buddy->bitmap_per_long[order],
+		   seg / BITS_PER_LONG, 1);
+
+	++buddy->num_free[order];
+}
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 7deaca9ade3b..40bdbdc6e3f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -126,4 +126,38 @@ mlx5dr_is_supported(struct mlx5_core_dev *dev)
 	return MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner);
 }
 
+/* buddy functions & structure */
+
+struct mlx5dr_icm_mr;
+
+struct mlx5dr_icm_buddy_mem {
+	unsigned long		**bitmap;
+	unsigned int		*num_free;
+	unsigned long		**bitmap_per_long;
+	u32			max_order;
+	struct list_head	list_node;
+	struct mlx5dr_icm_mr	*icm_mr;
+	struct mlx5dr_icm_pool	*pool;
+
+	/* This is the list of used chunks. HW may be accessing this memory */
+	struct list_head	used_list;
+
+	/* Hardware may be accessing this memory but at some future,
+	 * undetermined time, it might cease to do so.
+	 * sync_ste command sets them free.
+	 */
+	struct list_head	hot_list;
+	/* indicates the byte size of hot mem */
+	unsigned int		hot_memory_size;
+};
+
+int mlx5dr_buddy_init(struct mlx5dr_icm_buddy_mem *buddy,
+		      unsigned int max_order);
+void mlx5dr_buddy_cleanup(struct mlx5dr_icm_buddy_mem *buddy);
+int mlx5dr_buddy_alloc_mem(struct mlx5dr_icm_buddy_mem *buddy,
+			   unsigned int order,
+			   unsigned int *segment);
+void mlx5dr_buddy_free_mem(struct mlx5dr_icm_buddy_mem *buddy,
+			   unsigned int seg, unsigned int order);
+
 #endif /* _MLX5DR_H_ */
-- 
2.26.2

