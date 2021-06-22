Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE813B03D6
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 14:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhFVMLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 08:11:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231460AbhFVMLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 08:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 178E661164;
        Tue, 22 Jun 2021 12:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624363727;
        bh=KKUQ7IiHDXcT/11pS2xknv3eOOuE3/nwYOaT6bL+Q+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcanBhapnWEcolSuERVYQ14QZF41D51Nu1EYs/+8es/Zq1v0Qc8GuiEATciYRt/U7
         mKe4Qm/1whF9MWPNAU+XVF0cdBdx6VKEaSbbkn/a6EyBBSlP9nmg27j0Fu2g38tcM5
         mFxoIfImFke5p/bfpLMm/Opw3MZgXyxtFnKP8zeS7GBVqrojL6+ce2PKBlDF8l7Sbv
         vUnKcqGRZWV9YhqyRQeKYY/EyoKIlDjBqgQpmw3xzdcL+iJ/5KLg++OAg17pUI8niL
         VEpVS4694uMtf7X6aEN8kWaeICBB+qmj5GGR2lDBwJI/B31XTSocc+gqGtwpmXcJWb
         nFPmpGXPxmZzg==
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
Subject: [PATCH mlx5-next 3/5] RDMA/mlx5: Change the cache to hold mkeys instead of MRs
Date:   Tue, 22 Jun 2021 15:08:21 +0300
Message-Id: <d14d051add7957f72d93fe8a9aa148d3fad20024.1624362290.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624362290.git.leonro@nvidia.com>
References: <cover.1624362290.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Today the cache is an MR-cache, however, all members of MR, except for
mkey, are not being used in the cache.
Therefore, changing it to an mkey-cache so that the cache has its own
memory and holds only the values needed for the cache.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c    |   4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  56 ++--
 drivers/infiniband/hw/mlx5/mr.c      | 378 ++++++++++++++-------------
 drivers/infiniband/hw/mlx5/odp.c     |   9 +-
 include/linux/mlx5/driver.h          |   6 +-
 5 files changed, 235 insertions(+), 218 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c12517b63a8d..849bf016d8ae 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4051,7 +4051,7 @@ static void mlx5_ib_stage_pre_ib_reg_umr_cleanup(struct mlx5_ib_dev *dev)
 {
 	int err;
 
-	err = mlx5_mr_cache_cleanup(dev);
+	err = mlx5_mkey_cache_cleanup(dev);
 	if (err)
 		mlx5_ib_warn(dev, "mr cache cleanup failed\n");
 
@@ -4154,7 +4154,7 @@ static int mlx5_ib_stage_post_ib_reg_umr_init(struct mlx5_ib_dev *dev)
 	dev->umrc.pd = pd;
 
 	sema_init(&dev->umrc.sem, MAX_UMR_WR);
-	ret = mlx5_mr_cache_init(dev);
+	ret = mlx5_mkey_cache_init(dev);
 	if (ret) {
 		mlx5_ib_warn(dev, "mr cache init failed %d\n", ret);
 		goto error_4;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index af11a0d8ebc0..ffb6f1d41f3d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -634,6 +634,15 @@ struct mlx5_user_mmap_entry {
 #define mlx5_update_odp_stats(mr, counter_name, value)		\
 	atomic64_add(value, &((mr)->odp_stats.counter_name))
 
+struct mlx5r_cache_mkey {
+	u32 key;
+	struct mlx5_cache_ent *cache_ent;
+	u32 out[MLX5_ST_SZ_DW(create_mkey_out)];
+	struct mlx5_async_work cb_work;
+	/* Cache list element */
+	struct list_head list;
+};
+
 struct mlx5r_mkey {
 	u64			iova;
 	u64			size;
@@ -642,6 +651,7 @@ struct mlx5r_mkey {
 	u32			type;
 	struct wait_queue_head wait;
 	refcount_t usecount;
+	struct mlx5_cache_ent *cache_ent;
 };
 
 struct mlx5_ib_mr {
@@ -649,19 +659,10 @@ struct mlx5_ib_mr {
 	struct mlx5r_mkey mmkey;
 
 	/* User MR data */
-	struct mlx5_cache_ent *cache_ent;
 	struct ib_umem *umem;
 
 	/* This is zero'd when the MR is allocated */
 	union {
-		/* Used only while the MR is in the cache */
-		struct {
-			u32 out[MLX5_ST_SZ_DW(create_mkey_out)];
-			struct mlx5_async_work cb_work;
-			/* Cache list element */
-			struct list_head list;
-		};
-
 		/* Used only by kernel MRs (umem == NULL) */
 		struct {
 			void *descs;
@@ -702,12 +703,6 @@ struct mlx5_ib_mr {
 	};
 };
 
-/* Zero the fields in the mr that are variant depending on usage */
-static inline void mlx5_clear_mr(struct mlx5_ib_mr *mr)
-{
-	memset(mr->out, 0, sizeof(*mr) - offsetof(struct mlx5_ib_mr, out));
-}
-
 static inline bool is_odp_mr(struct mlx5_ib_mr *mr)
 {
 	return IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && mr->umem &&
@@ -763,16 +758,16 @@ struct mlx5_cache_ent {
 	u8 fill_to_high_water:1;
 
 	/*
-	 * - available_mrs is the length of list head, ie the number of MRs
+	 * - available_mkeys is the length of list head, ie the number of Mkeys
 	 *   available for immediate allocation.
-	 * - total_mrs is available_mrs plus all in use MRs that could be
+	 * - total_mkeys is available_mkeys plus all in use Mkeys that could be
 	 *   returned to the cache.
-	 * - limit is the low water mark for available_mrs, 2* limit is the
+	 * - limit is the low water mark for available_mkeys, 2* limit is the
 	 *   upper water mark.
-	 * - pending is the number of MRs currently being created
+	 * - pending is the number of Mkeys currently being created
 	 */
-	u32 total_mrs;
-	u32 available_mrs;
+	u32 total_mkeys;
+	u32 available_mkeys;
 	u32 limit;
 	u32 pending;
 
@@ -784,9 +779,9 @@ struct mlx5_cache_ent {
 	struct delayed_work	dwork;
 };
 
-struct mlx5_mr_cache {
+struct mlx5_mkey_cache {
 	struct workqueue_struct *wq;
-	struct mlx5_cache_ent	ent[MAX_MR_CACHE_ENTRIES];
+	struct mlx5_cache_ent	ent[MAX_MKEY_CACHE_ENTRIES];
 	struct dentry		*root;
 	unsigned long		last_add;
 };
@@ -1070,7 +1065,7 @@ struct mlx5_ib_dev {
 	struct mlx5_ib_resources	devr;
 
 	atomic_t			mkey_var;
-	struct mlx5_mr_cache		cache;
+	struct mlx5_mkey_cache		cache;
 	struct timer_list		delay_timer;
 	/* Prevents soft lock on massive reg MRs */
 	struct mutex			slow_path_mutex;
@@ -1318,11 +1313,12 @@ void mlx5_ib_populate_pas(struct ib_umem *umem, size_t page_size, __be64 *pas,
 			  u64 access_flags);
 void mlx5_ib_copy_pas(u64 *old, u64 *new, int step, int num);
 int mlx5_ib_get_cqe_size(struct ib_cq *ibcq);
-int mlx5_mr_cache_init(struct mlx5_ib_dev *dev);
-int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev);
+int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev);
+int mlx5_mkey_cache_cleanup(struct mlx5_ib_dev *dev);
 
-struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
-				       unsigned int entry, int access_flags);
+struct mlx5_ib_mr *mlx5_alloc_special_mkey(struct mlx5_ib_dev *dev,
+					   unsigned int entry,
+					   int access_flags);
 
 int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
 			    struct ib_mr_status *mr_status);
@@ -1346,7 +1342,7 @@ int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq);
 void mlx5_ib_odp_cleanup_one(struct mlx5_ib_dev *ibdev);
 int __init mlx5_ib_odp_init(void);
 void mlx5_ib_odp_cleanup(void);
-void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent);
+void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent);
 void mlx5_odp_populate_xlt(void *xlt, size_t idx, size_t nentries,
 			   struct mlx5_ib_mr *mr, int flags);
 
@@ -1365,7 +1361,7 @@ static inline int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev,
 static inline void mlx5_ib_odp_cleanup_one(struct mlx5_ib_dev *ibdev) {}
 static inline int mlx5_ib_odp_init(void) { return 0; }
 static inline void mlx5_ib_odp_cleanup(void)				    {}
-static inline void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent) {}
+static inline void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent) {}
 static inline void mlx5_odp_populate_xlt(void *xlt, size_t idx, size_t nentries,
 					 struct mlx5_ib_mr *mr, int flags) {}
 
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index bb59ea9b0498..8d7de4eddc11 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -54,13 +54,13 @@ static DEFINE_MUTEX(xlt_emergency_page_mutex);
 static void mlx5_invalidate_umem(struct ib_umem *umem, void *priv);
 
 enum {
-	MAX_PENDING_REG_MR = 8,
+	MAX_PENDING_CREATE_MKEY = 8,
 };
 
 #define MLX5_UMR_ALIGN 2048
 
-static void
-create_mkey_callback(int status, struct mlx5_async_work *context);
+static void create_cache_mkey_callback(int status,
+				       struct mlx5_async_work *context);
 static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 				     u64 iova, int access_flags,
 				     unsigned int page_size, bool populate);
@@ -104,7 +104,6 @@ static void set_mkey_fields(void *mkc, struct mlx5r_mkey *mkey)
 	mkey->iova = MLX5_GET64(mkc, mkc, start_addr);
 	mkey->size = MLX5_GET64(mkc, mkc, len);
 	mkey->pd = MLX5_GET(mkc, mkc, pd);
-	init_waitqueue_head(&mkey->wait);
 }
 
 static int mlx5_ib_create_mkey(struct mlx5_ib_dev *dev, struct mlx5r_mkey *mkey,
@@ -120,22 +119,24 @@ static int mlx5_ib_create_mkey(struct mlx5_ib_dev *dev, struct mlx5r_mkey *mkey,
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	set_mkey_fields(mkc, mkey);
+	init_waitqueue_head(&mkey->wait);
 	return 0;
 }
 
-static int mlx5_ib_create_mkey_cb(struct mlx5_ib_dev *dev,
-				  struct mlx5r_mkey *mkey,
-				  struct mlx5_async_ctx *async_ctx, u32 *in,
-				  int inlen, u32 *out, int outlen,
-				  struct mlx5_async_work *context)
+static int mlx5_ib_create_cache_mkey_cb(struct mlx5_ib_dev *dev,
+					struct mlx5r_cache_mkey *cmkey,
+					struct mlx5_async_ctx *async_ctx,
+					u32 *in, int inlen, u32 *out,
+					int outlen,
+					struct mlx5_async_work *context)
 {
 	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
-	assign_mkey_variant(dev, &mkey->key, in);
+	assign_mkey_variant(dev, &cmkey->key, in);
 	return mlx5_cmd_exec_cb(async_ctx, in, inlen, out, outlen,
-				create_mkey_callback, context);
+				create_cache_mkey_callback, context);
 }
 
-static int mr_cache_max_order(struct mlx5_ib_dev *dev);
+static int mkey_cache_max_order(struct mlx5_ib_dev *dev);
 static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent);
 
 static bool umr_can_use_indirect_mkey(struct mlx5_ib_dev *dev)
@@ -150,17 +151,19 @@ static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 	return mlx5_core_destroy_mkey(dev->mdev, &mr->mmkey.key);
 }
 
-static void create_mkey_callback(int status, struct mlx5_async_work *context)
+static void create_cache_mkey_callback(int status,
+				       struct mlx5_async_work *context)
 {
-	struct mlx5_ib_mr *mr =
-		container_of(context, struct mlx5_ib_mr, cb_work);
-	struct mlx5_cache_ent *ent = mr->cache_ent;
+	struct mlx5r_cache_mkey *cmkey =
+		container_of(context, struct mlx5r_cache_mkey, cb_work);
+	struct mlx5_cache_ent *ent = cmkey->cache_ent;
 	struct mlx5_ib_dev *dev = ent->dev;
 	unsigned long flags;
 
 	if (status) {
-		mlx5_ib_warn(dev, "async reg mr failed. status %d\n", status);
-		kfree(mr);
+		mlx5_ib_warn(dev, "async create mkey failed. status %d\n",
+			     status);
+		kfree(cmkey);
 		spin_lock_irqsave(&ent->lock, flags);
 		ent->pending--;
 		WRITE_ONCE(dev->fill_delay, 1);
@@ -169,32 +172,23 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 		return;
 	}
 
-	mr->mmkey.type = MLX5_MKEY_MR;
-	mr->mmkey.key |= mlx5_idx_to_mkey(
-		MLX5_GET(create_mkey_out, mr->out, mkey_index));
-	init_waitqueue_head(&mr->mmkey.wait);
+	cmkey->key |= mlx5_idx_to_mkey(
+		MLX5_GET(create_mkey_out, cmkey->out, mkey_index));
 
 	WRITE_ONCE(dev->cache.last_add, jiffies);
 
 	spin_lock_irqsave(&ent->lock, flags);
-	list_add_tail(&mr->list, &ent->head);
-	ent->available_mrs++;
-	ent->total_mrs++;
+	list_add_tail(&cmkey->list, &ent->head);
+	ent->available_mkeys++;
+	ent->total_mkeys++;
 	/* If we are doing fill_to_high_water then keep going. */
 	queue_adjust_cache_locked(ent);
 	ent->pending--;
 	spin_unlock_irqrestore(&ent->lock, flags);
 }
 
-static struct mlx5_ib_mr *alloc_cache_mr(struct mlx5_cache_ent *ent, void *mkc)
+static void set_cache_mkc(struct mlx5_cache_ent *ent, void *mkc)
 {
-	struct mlx5_ib_mr *mr;
-
-	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (!mr)
-		return NULL;
-	mr->cache_ent = ent;
-
 	set_mkc_access_pd_addr_fields(mkc, 0, 0, ent->dev->umrc.pd);
 	MLX5_SET(mkc, mkc, free, 1);
 	MLX5_SET(mkc, mkc, umr_en, 1);
@@ -203,14 +197,13 @@ static struct mlx5_ib_mr *alloc_cache_mr(struct mlx5_cache_ent *ent, void *mkc)
 
 	MLX5_SET(mkc, mkc, translations_octword_size, ent->xlt);
 	MLX5_SET(mkc, mkc, log_page_size, ent->page);
-	return mr;
 }
 
 /* Asynchronously schedule new MRs to be populated in the cache. */
 static int add_keys(struct mlx5_cache_ent *ent, unsigned int num)
 {
 	size_t inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
-	struct mlx5_ib_mr *mr;
+	struct mlx5r_cache_mkey *cmkey;
 	void *mkc;
 	u32 *in;
 	int err = 0;
@@ -221,31 +214,33 @@ static int add_keys(struct mlx5_cache_ent *ent, unsigned int num)
 		return -ENOMEM;
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	set_cache_mkc(ent, mkc);
 	for (i = 0; i < num; i++) {
-		mr = alloc_cache_mr(ent, mkc);
-		if (!mr) {
+		cmkey = kzalloc(sizeof(*cmkey), GFP_KERNEL);
+		if (!cmkey) {
 			err = -ENOMEM;
 			break;
 		}
+		cmkey->cache_ent = ent;
+
 		spin_lock_irq(&ent->lock);
-		if (ent->pending >= MAX_PENDING_REG_MR) {
+		if (ent->pending >= MAX_PENDING_CREATE_MKEY) {
 			err = -EAGAIN;
 			spin_unlock_irq(&ent->lock);
-			kfree(mr);
+			kfree(cmkey);
 			break;
 		}
 		ent->pending++;
 		spin_unlock_irq(&ent->lock);
-		err = mlx5_ib_create_mkey_cb(ent->dev, &mr->mmkey,
-					     &ent->dev->async_ctx, in, inlen,
-					     mr->out, sizeof(mr->out),
-					     &mr->cb_work);
+		err = mlx5_ib_create_cache_mkey_cb(
+			ent->dev, cmkey, &ent->dev->async_ctx, in, inlen,
+			cmkey->out, sizeof(cmkey->out), &cmkey->cb_work);
 		if (err) {
 			spin_lock_irq(&ent->lock);
 			ent->pending--;
 			spin_unlock_irq(&ent->lock);
 			mlx5_ib_warn(ent->dev, "create mkey failed %d\n", err);
-			kfree(mr);
+			kfree(cmkey);
 			break;
 		}
 	}
@@ -255,63 +250,54 @@ static int add_keys(struct mlx5_cache_ent *ent, unsigned int num)
 }
 
 /* Synchronously create a MR in the cache */
-static struct mlx5_ib_mr *create_cache_mr(struct mlx5_cache_ent *ent)
+static int create_cacheable_mkey(struct mlx5_cache_ent *ent,
+				 struct mlx5r_mkey *mkey)
 {
 	size_t inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
-	struct mlx5_ib_mr *mr;
 	void *mkc;
 	u32 *in;
 	int err;
 
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
-
-	mr = alloc_cache_mr(ent, mkc);
-	if (!mr) {
-		err = -ENOMEM;
-		goto free_in;
+	set_cache_mkc(ent, mkc);
+	err = mlx5_core_create_mkey(ent->dev->mdev, &mkey->key, in, inlen);
+	if (err) {
+		kfree(in);
+		return err;
 	}
+	set_mkey_fields(mkc, mkey);
+	mkey->cache_ent = ent;
 
-	err = mlx5_core_create_mkey(ent->dev->mdev, &mr->mmkey.key, in, inlen);
-	if (err)
-		goto free_mr;
-	set_mkey_fields(mkc, &mr->mmkey);
-
-	mr->mmkey.type = MLX5_MKEY_MR;
 	WRITE_ONCE(ent->dev->cache.last_add, jiffies);
 	spin_lock_irq(&ent->lock);
-	ent->total_mrs++;
+	ent->total_mkeys++;
 	spin_unlock_irq(&ent->lock);
 	kfree(in);
-	return mr;
-free_mr:
-	kfree(mr);
-free_in:
-	kfree(in);
-	return ERR_PTR(err);
+	return 0;
 }
 
-static void remove_cache_mr_locked(struct mlx5_cache_ent *ent)
+static void remove_cache_mkey_locked(struct mlx5_cache_ent *ent)
 {
-	struct mlx5_ib_mr *mr;
+	struct mlx5r_cache_mkey *cmkey;
 
 	lockdep_assert_held(&ent->lock);
 	if (list_empty(&ent->head))
 		return;
-	mr = list_first_entry(&ent->head, struct mlx5_ib_mr, list);
-	list_del(&mr->list);
-	ent->available_mrs--;
-	ent->total_mrs--;
+	cmkey = list_first_entry(&ent->head, struct mlx5r_cache_mkey, list);
+	list_del(&cmkey->list);
+	ent->available_mkeys--;
+	ent->total_mkeys--;
 	spin_unlock_irq(&ent->lock);
-	mlx5_core_destroy_mkey(ent->dev->mdev, &mr->mmkey.key);
-	kfree(mr);
+	mlx5_core_destroy_mkey(ent->dev->mdev, &cmkey->key);
+	kfree(cmkey);
 	spin_lock_irq(&ent->lock);
 }
 
-static int resize_available_mrs(struct mlx5_cache_ent *ent, unsigned int target,
-				bool limit_fill)
+static int resize_available_mkeys(struct mlx5_cache_ent *ent,
+				  unsigned int target, bool limit_fill)
 {
 	int err;
 
@@ -320,10 +306,11 @@ static int resize_available_mrs(struct mlx5_cache_ent *ent, unsigned int target,
 	while (true) {
 		if (limit_fill)
 			target = ent->limit * 2;
-		if (target == ent->available_mrs + ent->pending)
+		if (target == ent->available_mkeys + ent->pending)
 			return 0;
-		if (target > ent->available_mrs + ent->pending) {
-			u32 todo = target - (ent->available_mrs + ent->pending);
+		if (target > ent->available_mkeys + ent->pending) {
+			u32 todo =
+				target - (ent->available_mkeys + ent->pending);
 
 			spin_unlock_irq(&ent->lock);
 			err = add_keys(ent, todo);
@@ -336,7 +323,7 @@ static int resize_available_mrs(struct mlx5_cache_ent *ent, unsigned int target,
 			} else
 				return 0;
 		} else {
-			remove_cache_mr_locked(ent);
+			remove_cache_mkey_locked(ent);
 		}
 	}
 }
@@ -353,21 +340,21 @@ static ssize_t size_write(struct file *filp, const char __user *buf,
 		return err;
 
 	/*
-	 * Target is the new value of total_mrs the user requests, however we
-	 * cannot free MRs that are in use. Compute the target value for
-	 * available_mrs.
+	 * Target is the new value of total_mkeys the user requests, however we
+	 * cannot free Mkeys that are in use. Compute the target value for
+	 * available_mkeys.
 	 */
 	spin_lock_irq(&ent->lock);
-	if (target < ent->total_mrs - ent->available_mrs) {
+	if (target < ent->total_mkeys - ent->available_mkeys) {
 		err = -EINVAL;
 		goto err_unlock;
 	}
-	target = target - (ent->total_mrs - ent->available_mrs);
+	target = target - (ent->total_mkeys - ent->available_mkeys);
 	if (target < ent->limit || target > ent->limit*2) {
 		err = -EINVAL;
 		goto err_unlock;
 	}
-	err = resize_available_mrs(ent, target, false);
+	err = resize_available_mkeys(ent, target, false);
 	if (err)
 		goto err_unlock;
 	spin_unlock_irq(&ent->lock);
@@ -386,7 +373,7 @@ static ssize_t size_read(struct file *filp, char __user *buf, size_t count,
 	char lbuf[20];
 	int err;
 
-	err = snprintf(lbuf, sizeof(lbuf), "%d\n", ent->total_mrs);
+	err = snprintf(lbuf, sizeof(lbuf), "%d\n", ent->total_mkeys);
 	if (err < 0)
 		return err;
 
@@ -417,7 +404,7 @@ static ssize_t limit_write(struct file *filp, const char __user *buf,
 	 */
 	spin_lock_irq(&ent->lock);
 	ent->limit = var;
-	err = resize_available_mrs(ent, 0, true);
+	err = resize_available_mkeys(ent, 0, true);
 	spin_unlock_irq(&ent->lock);
 	if (err)
 		return err;
@@ -445,16 +432,16 @@ static const struct file_operations limit_fops = {
 	.read	= limit_read,
 };
 
-static bool someone_adding(struct mlx5_mr_cache *cache)
+static bool someone_adding(struct mlx5_mkey_cache *cache)
 {
 	unsigned int i;
 
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
 		struct mlx5_cache_ent *ent = &cache->ent[i];
 		bool ret;
 
 		spin_lock_irq(&ent->lock);
-		ret = ent->available_mrs < ent->limit;
+		ret = ent->available_mkeys < ent->limit;
 		spin_unlock_irq(&ent->lock);
 		if (ret)
 			return true;
@@ -473,19 +460,19 @@ static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent)
 
 	if (ent->disabled || READ_ONCE(ent->dev->fill_delay))
 		return;
-	if (ent->available_mrs < ent->limit) {
+	if (ent->available_mkeys < ent->limit) {
 		ent->fill_to_high_water = true;
 		queue_work(ent->dev->cache.wq, &ent->work);
 	} else if (ent->fill_to_high_water &&
-		   ent->available_mrs + ent->pending < 2 * ent->limit) {
+		   ent->available_mkeys + ent->pending < 2 * ent->limit) {
 		/*
 		 * Once we start populating due to hitting a low water mark
 		 * continue until we pass the high water mark.
 		 */
 		queue_work(ent->dev->cache.wq, &ent->work);
-	} else if (ent->available_mrs == 2 * ent->limit) {
+	} else if (ent->available_mkeys == 2 * ent->limit) {
 		ent->fill_to_high_water = false;
-	} else if (ent->available_mrs > 2 * ent->limit) {
+	} else if (ent->available_mkeys > 2 * ent->limit) {
 		/* Queue deletion of excess entries */
 		ent->fill_to_high_water = false;
 		if (ent->pending)
@@ -499,7 +486,7 @@ static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent)
 static void __cache_work_func(struct mlx5_cache_ent *ent)
 {
 	struct mlx5_ib_dev *dev = ent->dev;
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 	int err;
 
 	spin_lock_irq(&ent->lock);
@@ -507,7 +494,7 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 		goto out;
 
 	if (ent->fill_to_high_water &&
-	    ent->available_mrs + ent->pending < 2 * ent->limit &&
+	    ent->available_mkeys + ent->pending < 2 * ent->limit &&
 	    !READ_ONCE(dev->fill_delay)) {
 		spin_unlock_irq(&ent->lock);
 		err = add_keys(ent, 1);
@@ -529,7 +516,7 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 						   msecs_to_jiffies(1000));
 			}
 		}
-	} else if (ent->available_mrs > 2 * ent->limit) {
+	} else if (ent->available_mkeys > 2 * ent->limit) {
 		bool need_delay;
 
 		/*
@@ -553,7 +540,7 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 			goto out;
 		if (need_delay)
 			queue_delayed_work(cache->wq, &ent->dwork, 300 * HZ);
-		remove_cache_mr_locked(ent);
+		remove_cache_mkey_locked(ent);
 		queue_adjust_cache_locked(ent);
 	}
 out:
@@ -576,15 +563,17 @@ static void cache_work_func(struct work_struct *work)
 	__cache_work_func(ent);
 }
 
-/* Allocate a special entry from the cache */
-struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
-				       unsigned int entry, int access_flags)
+/* Get an Mkey from a special cache entry */
+struct mlx5_ib_mr *mlx5_alloc_special_mkey(struct mlx5_ib_dev *dev,
+					   unsigned int entry, int access_flags)
 {
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
+	struct mlx5r_cache_mkey *cmkey;
 	struct mlx5_cache_ent *ent;
 	struct mlx5_ib_mr *mr;
+	int err;
 
-	if (WARN_ON(entry <= MR_CACHE_LAST_STD_ENTRY ||
+	if (WARN_ON(entry <= MKEY_CACHE_LAST_STD_ENTRY ||
 		    entry >= ARRAY_SIZE(cache->ent)))
 		return ERR_PTR(-EINVAL);
 
@@ -592,48 +581,58 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 	if (!mlx5_ib_can_reconfig_with_umr(dev, 0, access_flags))
 		return ERR_PTR(-EOPNOTSUPP);
 
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
 	ent = &cache->ent[entry];
 	spin_lock_irq(&ent->lock);
 	if (list_empty(&ent->head)) {
 		spin_unlock_irq(&ent->lock);
-		mr = create_cache_mr(ent);
-		if (IS_ERR(mr))
-			return mr;
+		err = create_cacheable_mkey(ent, &mr->mmkey);
+		if (err) {
+			kfree(mr);
+			return ERR_PTR(err);
+		}
 	} else {
-		mr = list_first_entry(&ent->head, struct mlx5_ib_mr, list);
-		list_del(&mr->list);
-		ent->available_mrs--;
+		cmkey = list_first_entry(&ent->head, struct mlx5r_cache_mkey,
+					 list);
+		list_del(&cmkey->list);
+		ent->available_mkeys--;
 		queue_adjust_cache_locked(ent);
 		spin_unlock_irq(&ent->lock);
 
-		mlx5_clear_mr(mr);
+		mr->mmkey.key = cmkey->key;
+		mr->mmkey.cache_ent = ent;
+		kfree(cmkey);
 	}
+	init_waitqueue_head(&mr->mmkey.wait);
+	mr->mmkey.type = MLX5_MKEY_MR;
 	mr->access_flags = access_flags;
 	return mr;
 }
 
-/* Return a MR already available in the cache */
-static struct mlx5_ib_mr *get_cache_mr(struct mlx5_cache_ent *req_ent)
+/* Return a Mkey already available in the cache */
+static struct mlx5r_cache_mkey *get_cache_mkey(struct mlx5_cache_ent *req_ent)
 {
 	struct mlx5_ib_dev *dev = req_ent->dev;
-	struct mlx5_ib_mr *mr = NULL;
 	struct mlx5_cache_ent *ent = req_ent;
+	struct mlx5r_cache_mkey *cmkey;
 
-	/* Try larger MR pools from the cache to satisfy the allocation */
-	for (; ent != &dev->cache.ent[MR_CACHE_LAST_STD_ENTRY + 1]; ent++) {
+	/* Try larger Mkey pools from the cache to satisfy the allocation */
+	for (; ent != &dev->cache.ent[MKEY_CACHE_LAST_STD_ENTRY + 1]; ent++) {
 		mlx5_ib_dbg(dev, "order %u, cache index %zu\n", ent->order,
 			    ent - dev->cache.ent);
 
 		spin_lock_irq(&ent->lock);
 		if (!list_empty(&ent->head)) {
-			mr = list_first_entry(&ent->head, struct mlx5_ib_mr,
-					      list);
-			list_del(&mr->list);
-			ent->available_mrs--;
+			cmkey = list_first_entry(&ent->head,
+						 struct mlx5r_cache_mkey, list);
+			list_del(&cmkey->list);
+			ent->available_mkeys--;
 			queue_adjust_cache_locked(ent);
 			spin_unlock_irq(&ent->lock);
-			mlx5_clear_mr(mr);
-			return mr;
+			return cmkey;
 		}
 		queue_adjust_cache_locked(ent);
 		spin_unlock_irq(&ent->lock);
@@ -642,23 +641,32 @@ static struct mlx5_ib_mr *get_cache_mr(struct mlx5_cache_ent *req_ent)
 	return NULL;
 }
 
-static void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
+static int mlx5_free_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
-	struct mlx5_cache_ent *ent = mr->cache_ent;
+	struct mlx5_cache_ent *ent = mr->mmkey.cache_ent;
+	struct mlx5r_mkey *mkey = &mr->mmkey;
+	struct mlx5r_cache_mkey *cmkey;
+
+	cmkey = kzalloc(sizeof(*cmkey), GFP_KERNEL);
+	if (!cmkey)
+		return -ENOMEM;
+
+	cmkey->key = mkey->key;
+	cmkey->cache_ent = ent;
 
 	spin_lock_irq(&ent->lock);
-	list_add_tail(&mr->list, &ent->head);
-	ent->available_mrs++;
+	list_add_tail(&cmkey->list, &ent->head);
+	ent->available_mkeys++;
 	queue_adjust_cache_locked(ent);
 	spin_unlock_irq(&ent->lock);
+	return 0;
 }
 
 static void clean_keys(struct mlx5_ib_dev *dev, int c)
 {
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent = &cache->ent[c];
-	struct mlx5_ib_mr *tmp_mr;
-	struct mlx5_ib_mr *mr;
+	struct mlx5r_cache_mkey *tmp_mkey, *mkey;
 	LIST_HEAD(del_list);
 
 	cancel_delayed_work(&ent->dwork);
@@ -668,21 +676,22 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 			spin_unlock_irq(&ent->lock);
 			break;
 		}
-		mr = list_first_entry(&ent->head, struct mlx5_ib_mr, list);
-		list_move(&mr->list, &del_list);
-		ent->available_mrs--;
-		ent->total_mrs--;
+		mkey = list_first_entry(&ent->head, struct mlx5r_cache_mkey,
+					list);
+		list_move(&mkey->list, &del_list);
+		ent->available_mkeys--;
+		ent->total_mkeys--;
 		spin_unlock_irq(&ent->lock);
-		mlx5_core_destroy_mkey(dev->mdev, &mr->mmkey.key);
+		mlx5_core_destroy_mkey(dev->mdev, &mkey->key);
 	}
 
-	list_for_each_entry_safe(mr, tmp_mr, &del_list, list) {
-		list_del(&mr->list);
-		kfree(mr);
+	list_for_each_entry_safe(mkey, tmp_mkey, &del_list, list) {
+		list_del(&mkey->list);
+		kfree(mkey);
 	}
 }
 
-static void mlx5_mr_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
+static void mlx5_mkey_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
 {
 	if (!mlx5_debugfs_root || dev->is_rep)
 		return;
@@ -691,9 +700,9 @@ static void mlx5_mr_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
 	dev->cache.root = NULL;
 }
 
-static void mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
+static void mlx5_mkey_cache_debugfs_init(struct mlx5_ib_dev *dev)
 {
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
 	struct dentry *dir;
 	int i;
@@ -703,13 +712,13 @@ static void mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
 
 	cache->root = debugfs_create_dir("mr_cache", dev->mdev->priv.dbg_root);
 
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
 		ent = &cache->ent[i];
 		sprintf(ent->name, "%d", ent->order);
 		dir = debugfs_create_dir(ent->name, cache->root);
 		debugfs_create_file("size", 0600, dir, ent, &size_fops);
 		debugfs_create_file("limit", 0600, dir, ent, &limit_fops);
-		debugfs_create_u32("cur", 0400, dir, &ent->available_mrs);
+		debugfs_create_u32("cur", 0400, dir, &ent->available_mkeys);
 		debugfs_create_u32("miss", 0600, dir, &ent->miss);
 	}
 }
@@ -721,9 +730,9 @@ static void delay_time_func(struct timer_list *t)
 	WRITE_ONCE(dev->fill_delay, 0);
 }
 
-int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
+int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 {
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
 	int i;
 
@@ -736,7 +745,7 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 
 	mlx5_cmd_init_async_ctx(dev->mdev, &dev->async_ctx);
 	timer_setup(&dev->delay_timer, delay_time_func, 0);
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
 		ent = &cache->ent[i];
 		INIT_LIST_HEAD(&ent->head);
 		spin_lock_init(&ent->lock);
@@ -747,12 +756,12 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 		INIT_WORK(&ent->work, cache_work_func);
 		INIT_DELAYED_WORK(&ent->dwork, delayed_cache_work_func);
 
-		if (i > MR_CACHE_LAST_STD_ENTRY) {
-			mlx5_odp_init_mr_cache_entry(ent);
+		if (i > MKEY_CACHE_LAST_STD_ENTRY) {
+			mlx5_odp_init_mkey_cache_entry(ent);
 			continue;
 		}
 
-		if (ent->order > mr_cache_max_order(dev))
+		if (ent->order > mkey_cache_max_order(dev))
 			continue;
 
 		ent->page = PAGE_SHIFT;
@@ -770,19 +779,19 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 		spin_unlock_irq(&ent->lock);
 	}
 
-	mlx5_mr_cache_debugfs_init(dev);
+	mlx5_mkey_cache_debugfs_init(dev);
 
 	return 0;
 }
 
-int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
+int mlx5_mkey_cache_cleanup(struct mlx5_ib_dev *dev)
 {
 	unsigned int i;
 
 	if (!dev->cache.wq)
 		return 0;
 
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
 		struct mlx5_cache_ent *ent = &dev->cache.ent[i];
 
 		spin_lock_irq(&ent->lock);
@@ -792,10 +801,10 @@ int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
 		cancel_delayed_work_sync(&ent->dwork);
 	}
 
-	mlx5_mr_cache_debugfs_cleanup(dev);
+	mlx5_mkey_cache_debugfs_cleanup(dev);
 	mlx5_cmd_cleanup_async_ctx(&dev->async_ctx);
 
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++)
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++)
 		clean_keys(dev, i);
 
 	destroy_workqueue(dev->cache.wq);
@@ -862,10 +871,10 @@ static int get_octo_len(u64 addr, u64 len, int page_shift)
 	return (npages + 1) / 2;
 }
 
-static int mr_cache_max_order(struct mlx5_ib_dev *dev)
+static int mkey_cache_max_order(struct mlx5_ib_dev *dev)
 {
 	if (MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))
-		return MR_CACHE_LAST_STD_ENTRY + 2;
+		return MKEY_CACHE_LAST_STD_ENTRY + 2;
 	return MLX5_MAX_UMR_SHIFT;
 }
 
@@ -912,15 +921,15 @@ static int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
 	return err;
 }
 
-static struct mlx5_cache_ent *mr_cache_ent_from_order(struct mlx5_ib_dev *dev,
-						      unsigned int order)
+static struct mlx5_cache_ent *mkey_cache_ent_from_order(struct mlx5_ib_dev *dev,
+							unsigned int order)
 {
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 
 	if (order < cache->ent[0].order)
 		return &cache->ent[0];
 	order = order - cache->ent[0].order;
-	if (order > MR_CACHE_LAST_STD_ENTRY)
+	if (order > MKEY_CACHE_LAST_STD_ENTRY)
 		return NULL;
 	return &cache->ent[order];
 }
@@ -951,9 +960,11 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 					     int access_flags)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5r_cache_mkey *cmkey;
 	struct mlx5_cache_ent *ent;
 	struct mlx5_ib_mr *mr;
 	unsigned int page_size;
+	int ret;
 
 	if (umem->is_dmabuf)
 		page_size = mlx5_umem_dmabuf_default_pgsz(umem, iova);
@@ -962,7 +973,7 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 						     0, iova);
 	if (WARN_ON(!page_size))
 		return ERR_PTR(-EINVAL);
-	ent = mr_cache_ent_from_order(
+	ent = mkey_cache_ent_from_order(
 		dev, order_base_2(ib_umem_num_dma_blocks(umem, page_size)));
 	/*
 	 * Matches access in alloc_cache_mr(). If the MR can't come from the
@@ -976,22 +987,33 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 		return mr;
 	}
 
-	mr = get_cache_mr(ent);
-	if (!mr) {
-		mr = create_cache_mr(ent);
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	cmkey = get_cache_mkey(ent);
+	if (cmkey) {
+		mr->mmkey.key = cmkey->key;
+		mr->mmkey.cache_ent = cmkey->cache_ent;
+		kfree(cmkey);
+	} else {
+		ret = create_cacheable_mkey(ent, &mr->mmkey);
 		/*
 		 * The above already tried to do the same stuff as reg_create(),
 		 * no reason to try it again.
 		 */
-		if (IS_ERR(mr))
-			return mr;
+		if (ret) {
+			kfree(mr);
+			return ERR_PTR(ret);
+		}
 	}
-
 	mr->ibmr.pd = pd;
 	mr->umem = umem;
 	mr->mmkey.iova = iova;
+	mr->mmkey.type = MLX5_MKEY_MR;
 	mr->mmkey.size = umem->length;
 	mr->mmkey.pd = to_mpd(pd)->pdn;
+	init_waitqueue_head(&mr->mmkey.wait);
 	mr->page_shift = order_base_2(page_size);
 	set_mr_fields(dev, mr, umem->length, access_flags);
 
@@ -1742,7 +1764,7 @@ static bool can_use_umr_rereg_pas(struct mlx5_ib_mr *mr,
 	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
 
 	/* We only track the allocated sizes of MRs from the cache */
-	if (!mr->cache_ent)
+	if (!mr->mmkey.cache_ent)
 		return false;
 	if (!mlx5_ib_can_load_pas_with_umr(dev, new_umem->length))
 		return false;
@@ -1751,7 +1773,7 @@ static bool can_use_umr_rereg_pas(struct mlx5_ib_mr *mr,
 		mlx5_umem_find_best_pgsz(new_umem, mkc, log_page_size, 0, iova);
 	if (WARN_ON(!*page_size))
 		return false;
-	return (1ULL << mr->cache_ent->order) >=
+	return (1ULL << mr->mmkey.cache_ent->order) >=
 	       ib_umem_num_dma_blocks(new_umem, *page_size);
 }
 
@@ -1997,15 +2019,15 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 	}
 
 	/* Stop DMA */
-	if (mr->cache_ent) {
-		if (revoke_mr(mr)) {
-			spin_lock_irq(&mr->cache_ent->lock);
-			mr->cache_ent->total_mrs--;
-			spin_unlock_irq(&mr->cache_ent->lock);
-			mr->cache_ent = NULL;
+	if (mr->mmkey.cache_ent) {
+		if (revoke_mr(mr) || mlx5_free_mkey(dev, mr)) {
+			spin_lock_irq(&mr->mmkey.cache_ent->lock);
+			mr->mmkey.cache_ent->total_mkeys--;
+			spin_unlock_irq(&mr->mmkey.cache_ent->lock);
+			mr->mmkey.cache_ent = NULL;
 		}
 	}
-	if (!mr->cache_ent) {
+	if (!mr->mmkey.cache_ent) {
 		rc = destroy_mkey(to_mdev(mr->ibmr.device), mr);
 		if (rc)
 			return rc;
@@ -2022,12 +2044,10 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 			mlx5_ib_free_odp_mr(mr);
 	}
 
-	if (mr->cache_ent) {
-		mlx5_mr_cache_free(dev, mr);
-	} else {
+	if (!mr->mmkey.cache_ent)
 		mlx5_free_priv_descs(mr);
-		kfree(mr);
-	}
+
+	kfree(mr);
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index bc35900c6955..9c7942118d2c 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -418,8 +418,8 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 	if (IS_ERR(odp))
 		return ERR_CAST(odp);
 
-	mr = mlx5_mr_cache_alloc(
-		mr_to_mdev(imr), MLX5_IMR_MTT_CACHE_ENTRY, imr->access_flags);
+	mr = mlx5_alloc_special_mkey(mr_to_mdev(imr), MLX5_IMR_MTT_CACHE_ENTRY,
+				     imr->access_flags);
 	if (IS_ERR(mr)) {
 		ib_umem_odp_release(odp);
 		return mr;
@@ -493,7 +493,8 @@ struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
 	if (IS_ERR(umem_odp))
 		return ERR_CAST(umem_odp);
 
-	imr = mlx5_mr_cache_alloc(dev, MLX5_IMR_KSM_CACHE_ENTRY, access_flags);
+	imr = mlx5_alloc_special_mkey(dev, MLX5_IMR_KSM_CACHE_ENTRY,
+				      access_flags);
 	if (IS_ERR(imr)) {
 		ib_umem_odp_release(umem_odp);
 		return imr;
@@ -1604,7 +1605,7 @@ mlx5_ib_odp_destroy_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 	return err;
 }
 
-void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent)
+void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent)
 {
 	if (!(ent->dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
 		return;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 5832d6614606..8191140454e1 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1077,10 +1077,10 @@ enum {
 };
 
 enum {
-	MR_CACHE_LAST_STD_ENTRY = 20,
+	MKEY_CACHE_LAST_STD_ENTRY = 20,
 	MLX5_IMR_MTT_CACHE_ENTRY,
 	MLX5_IMR_KSM_CACHE_ENTRY,
-	MAX_MR_CACHE_ENTRIES
+	MAX_MKEY_CACHE_ENTRIES
 };
 
 /* Async-atomic event notifier used by mlx5 core to forward FW
@@ -1142,7 +1142,7 @@ struct mlx5_profile {
 	struct {
 		int	size;
 		int	limit;
-	} mr_cache[MAX_MR_CACHE_ENTRIES];
+	} mr_cache[MAX_MKEY_CACHE_ENTRIES];
 };
 
 enum {
-- 
2.31.1

