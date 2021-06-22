Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3CF3B03C3
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 14:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhFVMKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 08:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhFVMKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 08:10:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ACBE61164;
        Tue, 22 Jun 2021 12:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624363713;
        bh=QAglbyy57CIjFxJDu1gCKjVvgHmz1QX2yrNfp8busoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IDZV/AmgjSJ+dqGIl3QDCtv1QNcQ0YKr2S7CCZovpoBwSM7GY/mIxoiBcVDpMEkFG
         TsNJTGvLdv0EdYraxRBWRAhaeMRHYuf0+1Xp46ooQy/SWHoJ7DLfd+9S2is8xx0lhQ
         saUfs+c/F9W+g0nr5BqBU9T6uzqyW/z7t8A9mliXqtAItOyrUAkbkiy8XB4mnNFl7i
         +U6WXBPuCB9i0zQCoaGa8Bsjz0CNt7XQCqYef296lmD6cqjMRlzjfBpQKSJd55rAJ1
         QV+0uEIL3ABX8YCk9QwSxbxnc5oOcLxLhqIvAHjS+mCMvQD96WVSlHNQ2nYpkc5XeC
         zYGGrhTtM1wcw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH mlx5-next 2/5] RDMA/mlx5: Move struct mlx5_core_mkey to mlx5_ib
Date:   Tue, 22 Jun 2021 15:08:20 +0300
Message-Id: <db1e0478b61de2a051be2454065d41fd6c27a0d8.1624362290.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624362290.git.leonro@nvidia.com>
References: <cover.1624362290.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Moving mlx5_core_mkey struct to mlx5_ib as the mlx5_core doesn't use it
at this point.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c    |  2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 22 ++++++++++++++++------
 drivers/infiniband/hw/mlx5/mr.c      | 18 ++++++++----------
 drivers/infiniband/hw/mlx5/odp.c     |  8 ++++----
 include/linux/mlx5/driver.h          | 10 ----------
 5 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 3678b0a8710b..2562462a1df1 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1296,7 +1296,7 @@ static int devx_handle_mkey_indirect(struct devx_obj *obj,
 				     void *in, void *out)
 {
 	struct mlx5_ib_devx_mr *devx_mr = &obj->devx_mr;
-	struct mlx5_core_mkey *mkey;
+	struct mlx5r_mkey *mkey;
 	void *mkc;
 	u8 key;
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 7bb35a3d8004..af11a0d8ebc0 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -634,9 +634,19 @@ struct mlx5_user_mmap_entry {
 #define mlx5_update_odp_stats(mr, counter_name, value)		\
 	atomic64_add(value, &((mr)->odp_stats.counter_name))
 
+struct mlx5r_mkey {
+	u64			iova;
+	u64			size;
+	u32			key;
+	u32			pd;
+	u32			type;
+	struct wait_queue_head wait;
+	refcount_t usecount;
+};
+
 struct mlx5_ib_mr {
 	struct ib_mr ibmr;
-	struct mlx5_core_mkey mmkey;
+	struct mlx5r_mkey mmkey;
 
 	/* User MR data */
 	struct mlx5_cache_ent *cache_ent;
@@ -712,12 +722,12 @@ static inline bool is_dmabuf_mr(struct mlx5_ib_mr *mr)
 
 struct mlx5_ib_mw {
 	struct ib_mw		ibmw;
-	struct mlx5_core_mkey	mmkey;
+	struct mlx5r_mkey	mmkey;
 	int			ndescs;
 };
 
 struct mlx5_ib_devx_mr {
-	struct mlx5_core_mkey	mmkey;
+	struct mlx5r_mkey	mmkey;
 	int			ndescs;
 };
 
@@ -1581,7 +1591,7 @@ static inline bool mlx5_ib_can_reconfig_with_umr(struct mlx5_ib_dev *dev,
 }
 
 static inline int mlx5r_store_odp_mkey(struct mlx5_ib_dev *dev,
-				       struct mlx5_core_mkey *mmkey)
+				       struct mlx5r_mkey *mmkey)
 {
 	refcount_set(&mmkey->usecount, 1);
 
@@ -1590,14 +1600,14 @@ static inline int mlx5r_store_odp_mkey(struct mlx5_ib_dev *dev,
 }
 
 /* deref an mkey that can participate in ODP flow */
-static inline void mlx5r_deref_odp_mkey(struct mlx5_core_mkey *mmkey)
+static inline void mlx5r_deref_odp_mkey(struct mlx5r_mkey *mmkey)
 {
 	if (refcount_dec_and_test(&mmkey->usecount))
 		wake_up(&mmkey->wait);
 }
 
 /* deref an mkey that can participate in ODP flow and wait for relese */
-static inline void mlx5r_deref_wait_odp_mkey(struct mlx5_core_mkey *mmkey)
+static inline void mlx5r_deref_wait_odp_mkey(struct mlx5r_mkey *mmkey)
 {
 	mlx5r_deref_odp_mkey(mmkey);
 	wait_event(mmkey->wait, refcount_read(&mmkey->usecount) == 0);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index ae0472d92801..bb59ea9b0498 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -99,7 +99,7 @@ static void assign_mkey_variant(struct mlx5_ib_dev *dev, u32 *mkey, u32 *in)
 	*mkey = key;
 }
 
-static void set_mkey_fields(void *mkc, struct mlx5_core_mkey *mkey)
+static void set_mkey_fields(void *mkc, struct mlx5r_mkey *mkey)
 {
 	mkey->iova = MLX5_GET64(mkc, mkc, start_addr);
 	mkey->size = MLX5_GET64(mkc, mkc, len);
@@ -107,9 +107,8 @@ static void set_mkey_fields(void *mkc, struct mlx5_core_mkey *mkey)
 	init_waitqueue_head(&mkey->wait);
 }
 
-static int
-mlx5_ib_create_mkey(struct mlx5_ib_dev *dev, struct mlx5_core_mkey *mkey,
-		    u32 *in, int inlen)
+static int mlx5_ib_create_mkey(struct mlx5_ib_dev *dev, struct mlx5r_mkey *mkey,
+			       u32 *in, int inlen)
 {
 	int err;
 	void *mkc;
@@ -124,12 +123,11 @@ mlx5_ib_create_mkey(struct mlx5_ib_dev *dev, struct mlx5_core_mkey *mkey,
 	return 0;
 }
 
-static int
-mlx5_ib_create_mkey_cb(struct mlx5_ib_dev *dev,
-		       struct mlx5_core_mkey *mkey,
-		       struct mlx5_async_ctx *async_ctx,
-		       u32 *in, int inlen, u32 *out, int outlen,
-		       struct mlx5_async_work *context)
+static int mlx5_ib_create_mkey_cb(struct mlx5_ib_dev *dev,
+				  struct mlx5r_mkey *mkey,
+				  struct mlx5_async_ctx *async_ctx, u32 *in,
+				  int inlen, u32 *out, int outlen,
+				  struct mlx5_async_work *context)
 {
 	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
 	assign_mkey_variant(dev, &mkey->key, in);
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index b9f06c4d40ca..bc35900c6955 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -788,7 +788,7 @@ struct pf_frame {
 	int depth;
 };
 
-static bool mkey_is_eq(struct mlx5_core_mkey *mmkey, u32 key)
+static bool mkey_is_eq(struct mlx5r_mkey *mmkey, u32 key)
 {
 	if (!mmkey)
 		return false;
@@ -797,7 +797,7 @@ static bool mkey_is_eq(struct mlx5_core_mkey *mmkey, u32 key)
 	return mmkey->key == key;
 }
 
-static int get_indirect_num_descs(struct mlx5_core_mkey *mmkey)
+static int get_indirect_num_descs(struct mlx5r_mkey *mmkey)
 {
 	struct mlx5_ib_mw *mw;
 	struct mlx5_ib_devx_mr *devx_mr;
@@ -831,7 +831,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 {
 	int npages = 0, ret, i, outlen, cur_outlen = 0, depth = 0;
 	struct pf_frame *head = NULL, *frame;
-	struct mlx5_core_mkey *mmkey;
+	struct mlx5r_mkey *mmkey;
 	struct mlx5_ib_mr *mr;
 	struct mlx5_klm *pklm;
 	u32 *out = NULL;
@@ -1699,7 +1699,7 @@ get_prefetchable_mr(struct ib_pd *pd, enum ib_uverbs_advise_mr_advice advice,
 		    u32 lkey)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
-	struct mlx5_core_mkey *mmkey;
+	struct mlx5r_mkey *mmkey;
 	struct mlx5_ib_mr *mr = NULL;
 
 	xa_lock(&dev->odp_mkeys);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index cc60605c5531..5832d6614606 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -363,16 +363,6 @@ enum {
 	MLX5_MKEY_INDIRECT_DEVX,
 };
 
-struct mlx5_core_mkey {
-	u64			iova;
-	u64			size;
-	u32			key;
-	u32			pd;
-	u32			type;
-	struct wait_queue_head wait;
-	refcount_t usecount;
-};
-
 #define MLX5_24BIT_MASK		((1 << 24) - 1)
 
 enum mlx5_res_type {
-- 
2.31.1

