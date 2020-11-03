Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AB42A505B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgKCTsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:48:08 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9519 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729723AbgKCTsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:48:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1b3f80000>; Tue, 03 Nov 2020 11:48:08 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:48:03 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Yevgeny Kliteynik" <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/12] net/mlx5: DR, Add buddy allocator utilities
Date:   Tue, 3 Nov 2020 11:47:30 -0800
Message-ID: <20201103194738.64061-5-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103194738.64061-1-saeedm@nvidia.com>
References: <20201103194738.64061-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604432888; bh=KlqdsbI/oCX9bvKwmmS4+CRhJ5NZg4+fbnJFBSXnB6g=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=G7xht6sTvxcnc8r4WU0cvC8Zk/uzRmzRVgl1FUI0cJxfSIp1UGFnFEWIT5Leak/VT
         H6Cw+DPPJutnLYj6rL6yKcoVZN82VRLxjN0aSagTf+hYwn/K/zJ6qHXrt4eBReFJq9
         dsOTlBknxE1mnoy+BRnDhZKc0h17JC1okPRAAW91mdzZG1kHGLtUJaqHeglGKd3NeB
         AKH1XH+s8Qs2VFybrrOUC8+t2uBYkEPKQ/eAvWTfe8fWhJuIgD3s0mSH8T8rZe88K9
         8LJ66GLrenloS89+OhgMXSB7JstN1knaRaiTzQnRMWIaFC3oWow0jt3eb/ON85SoYS
         EKuOmpakK3tOQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Add implementation of SW Steering variation of buddy allocator.

The buddy system for ICM memory uses 2 main data structures:
- Bitmap per order, that keeps the current state of allocated
  blocks for this order
- Indicator for the number of available blocks per each order

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/steering/dr_buddy.c    | 170 ++++++++++++++++++
 .../mellanox/mlx5/core/steering/mlx5dr.h      |  33 ++++
 3 files changed, 204 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_bud=
dy.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index 2d477f9a8cb7..83a67ca43a41 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -81,7 +81,7 @@ mlx5_core-$(CONFIG_MLX5_EN_TLS) +=3D en_accel/tls.o en_ac=
cel/tls_rxtx.o en_accel/t
=20
 mlx5_core-$(CONFIG_MLX5_SW_STEERING) +=3D steering/dr_domain.o steering/dr=
_table.o \
 					steering/dr_matcher.o steering/dr_rule.o \
-					steering/dr_icm_pool.o \
+					steering/dr_icm_pool.o steering/dr_buddy.o \
 					steering/dr_ste.o steering/dr_send.o \
 					steering/dr_cmd.o steering/dr_fw.o \
 					steering/dr_action.o steering/fs_dr.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c
new file mode 100644
index 000000000000..7df11a019df9
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2004 Topspin Communications. All rights reserved.
+ * Copyright (c) 2005 - 2008 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2006 - 2007 Cisco Systems, Inc. All rights reserved.
+ * Copyright (c) 2020 NVIDIA CORPORATION. All rights reserved.
+ */
+
+#include "dr_types.h"
+
+int mlx5dr_buddy_init(struct mlx5dr_icm_buddy_mem *buddy,
+		      unsigned int max_order)
+{
+	int i;
+
+	buddy->max_order =3D max_order;
+
+	INIT_LIST_HEAD(&buddy->list_node);
+	INIT_LIST_HEAD(&buddy->used_list);
+	INIT_LIST_HEAD(&buddy->hot_list);
+
+	buddy->bitmap =3D kcalloc(buddy->max_order + 1,
+				sizeof(*buddy->bitmap),
+				GFP_KERNEL);
+	buddy->num_free =3D kcalloc(buddy->max_order + 1,
+				  sizeof(*buddy->num_free),
+				  GFP_KERNEL);
+
+	if (!buddy->bitmap || !buddy->num_free)
+		goto err_free_all;
+
+	/* Allocating max_order bitmaps, one for each order */
+
+	for (i =3D 0; i <=3D buddy->max_order; ++i) {
+		unsigned int size =3D 1 << (buddy->max_order - i);
+
+		buddy->bitmap[i] =3D bitmap_zalloc(size, GFP_KERNEL);
+		if (!buddy->bitmap[i])
+			goto err_out_free_each_bit_per_order;
+	}
+
+	/* In the beginning, we have only one order that is available for
+	 * use (the biggest one), so mark the first bit in both bitmaps.
+	 */
+
+	bitmap_set(buddy->bitmap[buddy->max_order], 0, 1);
+
+	buddy->num_free[buddy->max_order] =3D 1;
+
+	return 0;
+
+err_out_free_each_bit_per_order:
+	for (i =3D 0; i <=3D buddy->max_order; ++i)
+		bitmap_free(buddy->bitmap[i]);
+
+err_free_all:
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
+	for (i =3D 0; i <=3D buddy->max_order; ++i)
+		bitmap_free(buddy->bitmap[i]);
+
+	kfree(buddy->num_free);
+	kfree(buddy->bitmap);
+}
+
+static int dr_buddy_find_free_seg(struct mlx5dr_icm_buddy_mem *buddy,
+				  unsigned int start_order,
+				  unsigned int *segment,
+				  unsigned int *order)
+{
+	unsigned int seg, order_iter, m;
+
+	for (order_iter =3D start_order;
+	     order_iter <=3D buddy->max_order; ++order_iter) {
+		if (!buddy->num_free[order_iter])
+			continue;
+
+		m =3D 1 << (buddy->max_order - order_iter);
+		seg =3D find_first_bit(buddy->bitmap[order_iter], m);
+
+		if (WARN(seg >=3D m,
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
+	*segment =3D seg;
+	*order =3D order_iter;
+	return 0;
+}
+
+/**
+ * mlx5dr_buddy_alloc_mem() - Update second level bitmap.
+ * @buddy: Buddy to update.
+ * @order: Order of the buddy to update.
+ * @segment: Segment number.
+ *
+ * This function finds the first area of the ICM memory managed by this bu=
ddy.
+ * It uses the data structures of the buddy system in order to find the fi=
rst
+ * area of free place, starting from the current order till the maximum or=
der
+ * in the system.
+ *
+ * Return: 0 when segment is set, non-zero error status otherwise.
+ *
+ * The function returns the location (segment) in the whole buddy ICM memo=
ry
+ * area - the index of the memory segment that is available for use.
+ */
+int mlx5dr_buddy_alloc_mem(struct mlx5dr_icm_buddy_mem *buddy,
+			   unsigned int order,
+			   unsigned int *segment)
+{
+	unsigned int seg, order_iter;
+	int err;
+
+	err =3D dr_buddy_find_free_seg(buddy, order, &seg, &order_iter);
+	if (err)
+		return err;
+
+	bitmap_clear(buddy->bitmap[order_iter], seg, 1);
+	--buddy->num_free[order_iter];
+
+	/* If we found free memory in some order that is bigger than the
+	 * required order, we need to split every order between the required
+	 * order and the order that we found into two parts, and mark accordingly=
.
+	 */
+	while (order_iter > order) {
+		--order_iter;
+		seg <<=3D 1;
+		bitmap_set(buddy->bitmap[order_iter], seg ^ 1, 1);
+		++buddy->num_free[order_iter];
+	}
+
+	seg <<=3D order;
+	*segment =3D seg;
+
+	return 0;
+}
+
+void mlx5dr_buddy_free_mem(struct mlx5dr_icm_buddy_mem *buddy,
+			   unsigned int seg, unsigned int order)
+{
+	seg >>=3D order;
+
+	/* Whenever a segment is free,
+	 * the mem is added to the buddy that gave it.
+	 */
+	while (test_bit(seg ^ 1, buddy->bitmap[order])) {
+		bitmap_clear(buddy->bitmap[order], seg ^ 1, 1);
+		--buddy->num_free[order];
+		seg >>=3D 1;
+		++order;
+	}
+	bitmap_set(buddy->bitmap[order], seg, 1);
+
+	++buddy->num_free[order];
+}
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/dr=
ivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 7914fe3fc68d..25b7bda3ce4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -127,4 +127,37 @@ mlx5dr_is_supported(struct mlx5_core_dev *dev)
 	return MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner);
 }
=20
+/* buddy functions & structure */
+
+struct mlx5dr_icm_mr;
+
+struct mlx5dr_icm_buddy_mem {
+	unsigned long		**bitmap;
+	unsigned int		*num_free;
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
--=20
2.26.2

