Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61EF30B875
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhBBHN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:13:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhBBHN4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 02:13:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37F8064D79;
        Tue,  2 Feb 2021 07:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612249994;
        bh=9gtXZZI5r32wURAU4nQLlCh6PZ4z6t6kAh8srncOjMY=;
        h=From:To:Cc:Subject:Date:From;
        b=nenX1gcvdHPoss6MZ4sUATD/Drm/ahEtFWH3vmdvg9CENrHX1WwBGXEszcsYCG99J
         bnPgEF0ST6xvwfkg3x5XFXRz5XN5/ggicGJ+yIrzzCO2LR+uq8wlAH5sz0GoVG8Cvy
         EiYBJXFR9bL91soTbAfWxo+6EnC1rO1rASsqrgzbw2I6XmEcUX5OKJeYLB0zqYFd5L
         2WwFjJOyJ4L+lYtx6G6Fl4/ciI68S8W880aAW1ZLzfM3mRWuq51iWqKr2OBHTwZaxM
         8Im+dVO2JaJF2yHd9c4MbiSPnvtNuhc5FvSri7zRsiOqU3wDb/j1tW7woiYHxJaCUN
         28OBYXeMSSpBQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next v2] RDMA/mlx5: Cleanup the synchronize_srcu() from the ODP flow
Date:   Tue,  2 Feb 2021 09:13:09 +0200
Message-Id: <20210202071309.2057998-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Cleanup the synchronize_srcu() from the ODP flow as it was found to be a
very heavy time consumer as part of dereg_mr.

For example de-registration of 10000 ODP MRs each with size of 2M
hugepage took 19.6 sec comparing de-registration of same number of non
ODP MRs that took 172 ms.

The new locking scheme uses the wait_event() mechanism which follows the
use count of the MR instead of using synchronize_srcu().

By that change, the time required for the above test took 95 ms which is
even better than the non ODP flow.

Once fully dropped the srcu usage, had to come with a lock to protect
the XA access.

As part of using the above mechanism we could also clean the
num_deferred_work stuff and follow the use count instead.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Changelog:
v2:
 * Add checks of xa_erase() result as an outcome of memory error injection tests.
 * Found extra place where we can change open-coded logic to use mlx5r_store_odp_mkey().
v1: https://lore.kernel.org/linux-rdma/20210128064812.1921519-1-leon@kernel.org
 * Deleted not-relevant comment implicit_get_child_mr(), I have no idea
   why wrong version of this patch was sent as v0.
 * Deleted two new break lines added by me to make code more uniformly
   in before "return ..." (sometimes it has new line, sometimes doesn't).
v0: https://lore.kernel.org/linux-rdma/20210127143051.1873866-1-leon@kernel.org
---
 drivers/infiniband/hw/mlx5/devx.c            |  13 +-
 drivers/infiniband/hw/mlx5/main.c            |   5 -
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  31 ++-
 drivers/infiniband/hw/mlx5/mr.c              |  26 +--
 drivers/infiniband/hw/mlx5/odp.c             | 224 +++++++------------
 drivers/net/ethernet/mellanox/mlx5/core/mr.c |   1 +
 include/linux/mlx5/driver.h                  |   2 +
 7 files changed, 127 insertions(+), 175 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index ef69541a5075..526057a33edb 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1310,9 +1310,9 @@ static int devx_handle_mkey_indirect(struct devx_obj *obj,
 	mkey->size = MLX5_GET64(mkc, mkc, len);
 	mkey->pd = MLX5_GET(mkc, mkc, pd);
 	devx_mr->ndescs = MLX5_GET(mkc, mkc, translations_octword_size);
+	init_waitqueue_head(&mkey->wait);

-	return xa_err(xa_store(&dev->odp_mkeys, mlx5_base_mkey(mkey->key), mkey,
-			       GFP_KERNEL));
+	return mlx5r_store_odp_mkey(dev, mkey);
 }

 static int devx_handle_mkey_create(struct mlx5_ib_dev *dev,
@@ -1385,16 +1385,15 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	int ret;

 	dev = mlx5_udata_to_mdev(&attrs->driver_udata);
-	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY) {
+	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY &&
+	    xa_erase(&obj->ib_dev->odp_mkeys,
+		     mlx5_base_mkey(obj->devx_mr.mmkey.key)))
 		/*
 		 * The pagefault_single_data_segment() does commands against
 		 * the mmkey, we must wait for that to stop before freeing the
 		 * mkey, as another allocation could get the same mkey #.
 		 */
-		xa_erase(&obj->ib_dev->odp_mkeys,
-			 mlx5_base_mkey(obj->devx_mr.mmkey.key));
-		synchronize_srcu(&dev->odp_srcu);
-	}
+		mlx5r_deref_wait_odp_mkey(&obj->devx_mr.mmkey);

 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
 		ret = mlx5_core_destroy_dct(obj->ib_dev, &obj->core_dct);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d15943b00c61..ac6bb4bd61d0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3953,7 +3953,6 @@ static void mlx5_ib_stage_init_cleanup(struct mlx5_ib_dev *dev)
 {
 	mlx5_ib_cleanup_multiport_master(dev);
 	WARN_ON(!xa_empty(&dev->odp_mkeys));
-	cleanup_srcu_struct(&dev->odp_srcu);
 	mutex_destroy(&dev->cap_mask_mutex);
 	WARN_ON(!xa_empty(&dev->sig_mrs));
 	WARN_ON(!bitmap_empty(dev->dm.memic_alloc_pages, MLX5_MAX_MEMIC_PAGES));
@@ -4005,10 +4004,6 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	dev->ib_dev.dev.parent		= mdev->device;
 	dev->ib_dev.lag_flags		= RDMA_LAG_FLAGS_HASH_ALL_SLAVES;

-	err = init_srcu_struct(&dev->odp_srcu);
-	if (err)
-		goto err_mp;
-
 	mutex_init(&dev->cap_mask_mutex);
 	INIT_LIST_HEAD(&dev->qp_list);
 	spin_lock_init(&dev->reset_flow_resource_lock);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2fd2927abe45..39cf7ccc8ed3 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -684,11 +684,8 @@ struct mlx5_ib_mr {
 	u64			pi_iova;

 	/* For ODP and implicit */
-	atomic_t		num_deferred_work;
-	wait_queue_head_t       q_deferred_work;
 	struct xarray		implicit_children;
 	union {
-		struct rcu_head rcu;
 		struct list_head elm;
 		struct work_struct work;
 	} odp_destroy;
@@ -1063,11 +1060,6 @@ struct mlx5_ib_dev {
 	u64			odp_max_size;
 	struct mlx5_ib_pf_eq	odp_pf_eq;

-	/*
-	 * Sleepable RCU that prevents destruction of MRs while they are still
-	 * being used by a page fault handler.
-	 */
-	struct srcu_struct      odp_srcu;
 	struct xarray		odp_mkeys;

 	u32			null_mkey;
@@ -1592,6 +1584,29 @@ static inline bool mlx5_ib_can_reconfig_with_umr(struct mlx5_ib_dev *dev,
 	return true;
 }

+static inline int mlx5r_store_odp_mkey(struct mlx5_ib_dev *dev,
+				       struct mlx5_core_mkey *mmkey)
+{
+	refcount_set(&mmkey->usecount, 1);
+
+	return xa_err(xa_store(&dev->odp_mkeys, mlx5_base_mkey(mmkey->key),
+			       mmkey, GFP_KERNEL));
+}
+
+/* deref an mkey that can participate in ODP flow */
+static inline void mlx5r_deref_odp_mkey(struct mlx5_core_mkey *mmkey)
+{
+	if (refcount_dec_and_test(&mmkey->usecount))
+		wake_up(&mmkey->wait);
+}
+
+/* deref an mkey that can participate in ODP flow and wait for relese */
+static inline void mlx5r_deref_wait_odp_mkey(struct mlx5_core_mkey *mmkey)
+{
+	mlx5r_deref_odp_mkey(mmkey);
+	wait_event(mmkey->wait, refcount_read(&mmkey->usecount) == 0);
+}
+
 int mlx5_ib_test_wc(struct mlx5_ib_dev *dev);

 static inline bool mlx5_ib_lag_should_assign_affinity(struct mlx5_ib_dev *dev)
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 211ffac4649a..8018ba138aab 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -159,6 +159,7 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 	mr->mmkey.type = MLX5_MKEY_MR;
 	mr->mmkey.key |= mlx5_idx_to_mkey(
 		MLX5_GET(create_mkey_out, mr->out, mkey_index));
+	init_waitqueue_head(&mr->mmkey.wait);

 	WRITE_ONCE(dev->cache.last_add, jiffies);

@@ -1558,10 +1559,7 @@ static struct ib_mr *create_user_odp_mr(struct ib_pd *pd, u64 start, u64 length,
 	}

 	odp->private = mr;
-	init_waitqueue_head(&mr->q_deferred_work);
-	atomic_set(&mr->num_deferred_work, 0);
-	err = xa_err(xa_store(&dev->odp_mkeys, mlx5_base_mkey(mr->mmkey.key),
-			      &mr->mmkey, GFP_KERNEL));
+	err = mlx5r_store_odp_mkey(dev, &mr->mmkey);
 	if (err)
 		goto err_dereg_mr;

@@ -1659,10 +1657,7 @@ struct ib_mr *mlx5_ib_reg_user_mr_dmabuf(struct ib_pd *pd, u64 offset,

 	atomic_add(ib_umem_num_pages(mr->umem), &dev->mdev->priv.reg_pages);
 	umem_dmabuf->private = mr;
-	init_waitqueue_head(&mr->q_deferred_work);
-	atomic_set(&mr->num_deferred_work, 0);
-	err = xa_err(xa_store(&dev->odp_mkeys, mlx5_base_mkey(mr->mmkey.key),
-			      &mr->mmkey, GFP_KERNEL));
+	err = mlx5r_store_odp_mkey(dev, &mr->mmkey);
 	if (err)
 		goto err_dereg_mr;

@@ -2343,9 +2338,7 @@ int mlx5_ib_alloc_mw(struct ib_mw *ibmw, struct ib_udata *udata)
 	}

 	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
-		err = xa_err(xa_store(&dev->odp_mkeys,
-				      mlx5_base_mkey(mw->mmkey.key), &mw->mmkey,
-				      GFP_KERNEL));
+		err = mlx5r_store_odp_mkey(dev, &mw->mmkey);
 		if (err)
 			goto free_mkey;
 	}
@@ -2365,14 +2358,13 @@ int mlx5_ib_dealloc_mw(struct ib_mw *mw)
 	struct mlx5_ib_dev *dev = to_mdev(mw->device);
 	struct mlx5_ib_mw *mmw = to_mmw(mw);

-	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
-		xa_erase(&dev->odp_mkeys, mlx5_base_mkey(mmw->mmkey.key));
+	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) &&
+	    xa_erase(&dev->odp_mkeys, mlx5_base_mkey(mmw->mmkey.key)))
 		/*
-		 * pagefault_single_data_segment() may be accessing mmw under
-		 * SRCU if the user bound an ODP MR to this MW.
+		 * pagefault_single_data_segment() may be accessing mmw
+		 * if the user bound an ODP MR to this MW.
 		 */
-		synchronize_srcu(&dev->odp_srcu);
-	}
+		mlx5r_deref_wait_odp_mkey(&mmw->mmkey);

 	return mlx5_core_destroy_mkey(dev->mdev, &mmw->mmkey);
 }
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index e77b1db73893..374698186662 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -115,7 +115,6 @@ static void populate_klm(struct mlx5_klm *pklm, size_t idx, size_t nentries,
 	 * xarray would be protected by the umem_mutex, however that is not
 	 * possible. Instead this uses a weaker update-then-lock pattern:
 	 *
-	 *  srcu_read_lock()
 	 *    xa_store()
 	 *    mutex_lock(umem_mutex)
 	 *     mlx5_ib_update_xlt()
@@ -126,12 +125,9 @@ static void populate_klm(struct mlx5_klm *pklm, size_t idx, size_t nentries,
 	 * before destroying.
 	 *
 	 * The umem_mutex provides the acquire/release semantic needed to make
-	 * the xa_store() visible to a racing thread. While SRCU is not
-	 * technically required, using it gives consistent use of the SRCU
-	 * locking around the xarray.
+	 * the xa_store() visible to a racing thread.
 	 */
 	lockdep_assert_held(&to_ib_umem_odp(imr->umem)->umem_mutex);
-	lockdep_assert_held(&mr_to_mdev(imr)->odp_srcu);

 	for (; pklm != end; pklm++, idx++) {
 		struct mlx5_ib_mr *mtt = xa_load(&imr->implicit_children, idx);
@@ -207,8 +203,8 @@ static void dma_fence_odp_mr(struct mlx5_ib_mr *mr)
 }

 /*
- * This must be called after the mr has been removed from implicit_children
- * and the SRCU synchronized.  NOTE: The MR does not necessarily have to be
+ * This must be called after the mr has been removed from implicit_children.
+ * NOTE: The MR does not necessarily have to be
  * empty here, parallel page faults could have raced with the free process and
  * added pages to it.
  */
@@ -218,19 +214,15 @@ static void free_implicit_child_mr(struct mlx5_ib_mr *mr, bool need_imr_xlt)
 	struct ib_umem_odp *odp_imr = to_ib_umem_odp(imr->umem);
 	struct ib_umem_odp *odp = to_ib_umem_odp(mr->umem);
 	unsigned long idx = ib_umem_start(odp) >> MLX5_IMR_MTT_SHIFT;
-	int srcu_key;

-	/* implicit_child_mr's are not allowed to have deferred work */
-	WARN_ON(atomic_read(&mr->num_deferred_work));
+	mlx5r_deref_wait_odp_mkey(&mr->mmkey);

 	if (need_imr_xlt) {
-		srcu_key = srcu_read_lock(&mr_to_mdev(mr)->odp_srcu);
 		mutex_lock(&odp_imr->umem_mutex);
 		mlx5_ib_update_xlt(mr->parent, idx, 1, 0,
 				   MLX5_IB_UPD_XLT_INDIRECT |
 				   MLX5_IB_UPD_XLT_ATOMIC);
 		mutex_unlock(&odp_imr->umem_mutex);
-		srcu_read_unlock(&mr_to_mdev(mr)->odp_srcu, srcu_key);
 	}

 	dma_fence_odp_mr(mr);
@@ -238,26 +230,16 @@ static void free_implicit_child_mr(struct mlx5_ib_mr *mr, bool need_imr_xlt)
 	mr->parent = NULL;
 	mlx5_mr_cache_free(mr_to_mdev(mr), mr);
 	ib_umem_odp_release(odp);
-	if (atomic_dec_and_test(&imr->num_deferred_work))
-		wake_up(&imr->q_deferred_work);
 }

 static void free_implicit_child_mr_work(struct work_struct *work)
 {
 	struct mlx5_ib_mr *mr =
 		container_of(work, struct mlx5_ib_mr, odp_destroy.work);
+	struct mlx5_ib_mr *imr = mr->parent;

 	free_implicit_child_mr(mr, true);
-}
-
-static void free_implicit_child_mr_rcu(struct rcu_head *head)
-{
-	struct mlx5_ib_mr *mr =
-		container_of(head, struct mlx5_ib_mr, odp_destroy.rcu);
-
-	/* Freeing a MR is a sleeping operation, so bounce to a work queue */
-	INIT_WORK(&mr->odp_destroy.work, free_implicit_child_mr_work);
-	queue_work(system_unbound_wq, &mr->odp_destroy.work);
+	mlx5r_deref_odp_mkey(&imr->mmkey);
 }

 static void destroy_unused_implicit_child_mr(struct mlx5_ib_mr *mr)
@@ -266,21 +248,14 @@ static void destroy_unused_implicit_child_mr(struct mlx5_ib_mr *mr)
 	unsigned long idx = ib_umem_start(odp) >> MLX5_IMR_MTT_SHIFT;
 	struct mlx5_ib_mr *imr = mr->parent;

-	xa_lock(&imr->implicit_children);
-	/*
-	 * This can race with mlx5_ib_free_implicit_mr(), the first one to
-	 * reach the xa lock wins the race and destroys the MR.
-	 */
-	if (__xa_cmpxchg(&imr->implicit_children, idx, mr, NULL, GFP_ATOMIC) !=
-	    mr)
-		goto out_unlock;
+	if (!refcount_inc_not_zero(&imr->mmkey.usecount))
+		return;

-	atomic_inc(&imr->num_deferred_work);
-	call_srcu(&mr_to_mdev(mr)->odp_srcu, &mr->odp_destroy.rcu,
-		  free_implicit_child_mr_rcu);
+	xa_erase(&imr->implicit_children, idx);

-out_unlock:
-	xa_unlock(&imr->implicit_children);
+	/* Freeing a MR is a sleeping operation, so bounce to a work queue */
+	INIT_WORK(&mr->odp_destroy.work, free_implicit_child_mr_work);
+	queue_work(system_unbound_wq, &mr->odp_destroy.work);
 }

 static bool mlx5_ib_invalidate_range(struct mmu_interval_notifier *mni,
@@ -492,6 +467,12 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 	mr->parent = imr;
 	odp->private = mr;

+	/*
+	 * First refcount is owned by the xarray and second refconut
+	 * is returned to the caller.
+	 */
+	refcount_set(&mr->mmkey.usecount, 2);
+
 	err = mlx5_ib_update_xlt(mr, 0,
 				 MLX5_IMR_MTT_ENTRIES,
 				 PAGE_SHIFT,
@@ -502,27 +483,28 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 		goto out_mr;
 	}

-	/*
-	 * Once the store to either xarray completes any error unwind has to
-	 * use synchronize_srcu(). Avoid this with xa_reserve()
-	 */
-	ret = xa_cmpxchg(&imr->implicit_children, idx, NULL, mr,
-			 GFP_KERNEL);
+	xa_lock(&imr->implicit_children);
+	ret = __xa_cmpxchg(&imr->implicit_children, idx, NULL, mr,
+			   GFP_KERNEL);
 	if (unlikely(ret)) {
 		if (xa_is_err(ret)) {
 			ret = ERR_PTR(xa_err(ret));
-			goto out_mr;
+			goto out_lock;
 		}
 		/*
 		 * Another thread beat us to creating the child mr, use
 		 * theirs.
 		 */
-		goto out_mr;
+		refcount_inc(&ret->mmkey.usecount);
+		goto out_lock;
 	}
+	xa_unlock(&imr->implicit_children);

 	mlx5_ib_dbg(mr_to_mdev(imr), "key %x mr %p\n", mr->mmkey.key, mr);
 	return mr;

+out_lock:
+	xa_unlock(&imr->implicit_children);
 out_mr:
 	mlx5_mr_cache_free(mr_to_mdev(imr), mr);
 out_umem:
@@ -561,8 +543,6 @@ struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
 	imr->ibmr.device = &dev->ib_dev;
 	imr->umem = &umem_odp->umem;
 	imr->is_odp_implicit = true;
-	atomic_set(&imr->num_deferred_work, 0);
-	init_waitqueue_head(&imr->q_deferred_work);
 	xa_init(&imr->implicit_children);

 	err = mlx5_ib_update_xlt(imr, 0,
@@ -574,8 +554,7 @@ struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
 	if (err)
 		goto out_mr;

-	err = xa_err(xa_store(&dev->odp_mkeys, mlx5_base_mkey(imr->mmkey.key),
-			      &imr->mmkey, GFP_KERNEL));
+	err = mlx5r_store_odp_mkey(dev, &imr->mmkey);
 	if (err)
 		goto out_mr;

@@ -593,51 +572,24 @@ void mlx5_ib_free_implicit_mr(struct mlx5_ib_mr *imr)
 {
 	struct ib_umem_odp *odp_imr = to_ib_umem_odp(imr->umem);
 	struct mlx5_ib_dev *dev = mr_to_mdev(imr);
-	struct list_head destroy_list;
 	struct mlx5_ib_mr *mtt;
-	struct mlx5_ib_mr *tmp;
 	unsigned long idx;

-	INIT_LIST_HEAD(&destroy_list);
-
 	xa_erase(&dev->odp_mkeys, mlx5_base_mkey(imr->mmkey.key));
-	/*
-	 * This stops the SRCU protected page fault path from touching either
-	 * the imr or any children. The page fault path can only reach the
-	 * children xarray via the imr.
-	 */
-	synchronize_srcu(&dev->odp_srcu);
-
 	/*
 	 * All work on the prefetch list must be completed, xa_erase() prevented
 	 * new work from being created.
 	 */
-	wait_event(imr->q_deferred_work, !atomic_read(&imr->num_deferred_work));
-
+	mlx5r_deref_wait_odp_mkey(&imr->mmkey);
 	/*
 	 * At this point it is forbidden for any other thread to enter
 	 * pagefault_mr() on this imr. It is already forbidden to call
 	 * pagefault_mr() on an implicit child. Due to this additions to
 	 * implicit_children are prevented.
+	 * In addition, any new call to destroy_unused_implicit_child_mr()
+	 * may return immediately.
 	 */

-	/*
-	 * Block destroy_unused_implicit_child_mr() from incrementing
-	 * num_deferred_work.
-	 */
-	xa_lock(&imr->implicit_children);
-	xa_for_each (&imr->implicit_children, idx, mtt) {
-		__xa_erase(&imr->implicit_children, idx);
-		list_add(&mtt->odp_destroy.elm, &destroy_list);
-	}
-	xa_unlock(&imr->implicit_children);
-
-	/*
-	 * Wait for any concurrent destroy_unused_implicit_child_mr() to
-	 * complete.
-	 */
-	wait_event(imr->q_deferred_work, !atomic_read(&imr->num_deferred_work));
-
 	/*
 	 * Fence the imr before we destroy the children. This allows us to
 	 * skip updating the XLT of the imr during destroy of the child mkey
@@ -645,8 +597,10 @@ void mlx5_ib_free_implicit_mr(struct mlx5_ib_mr *imr)
 	 */
 	mlx5_mr_cache_invalidate(imr);

-	list_for_each_entry_safe (mtt, tmp, &destroy_list, odp_destroy.elm)
+	xa_for_each(&imr->implicit_children, idx, mtt) {
+		xa_erase(&imr->implicit_children, idx);
 		free_implicit_child_mr(mtt, false);
+	}

 	mlx5_mr_cache_free(dev, imr);
 	ib_umem_odp_release(odp_imr);
@@ -665,9 +619,7 @@ void mlx5_ib_fence_odp_mr(struct mlx5_ib_mr *mr)
 	xa_erase(&mr_to_mdev(mr)->odp_mkeys, mlx5_base_mkey(mr->mmkey.key));

 	/* Wait for all running page-fault handlers to finish. */
-	synchronize_srcu(&mr_to_mdev(mr)->odp_srcu);
-
-	wait_event(mr->q_deferred_work, !atomic_read(&mr->num_deferred_work));
+	mlx5r_deref_wait_odp_mkey(&mr->mmkey);

 	dma_fence_odp_mr(mr);
 }
@@ -686,10 +638,7 @@ void mlx5_ib_fence_dmabuf_mr(struct mlx5_ib_mr *mr)
 	/* Prevent new page faults and prefetch requests from succeeding */
 	xa_erase(&mr_to_mdev(mr)->odp_mkeys, mlx5_base_mkey(mr->mmkey.key));

-	/* Wait for all running page-fault handlers to finish. */
-	synchronize_srcu(&mr_to_mdev(mr)->odp_srcu);
-
-	wait_event(mr->q_deferred_work, !atomic_read(&mr->num_deferred_work));
+	mlx5r_deref_wait_odp_mkey(&mr->mmkey);

 	dma_resv_lock(umem_dmabuf->attach->dmabuf->resv, NULL);
 	mlx5_mr_cache_invalidate(mr);
@@ -780,8 +729,10 @@ static int pagefault_implicit_mr(struct mlx5_ib_mr *imr,
 		struct mlx5_ib_mr *mtt;
 		u64 len;

+		xa_lock(&imr->implicit_children);
 		mtt = xa_load(&imr->implicit_children, idx);
 		if (unlikely(!mtt)) {
+			xa_unlock(&imr->implicit_children);
 			mtt = implicit_get_child_mr(imr, idx);
 			if (IS_ERR(mtt)) {
 				ret = PTR_ERR(mtt);
@@ -789,6 +740,9 @@ static int pagefault_implicit_mr(struct mlx5_ib_mr *imr,
 			}
 			upd_start_idx = min(upd_start_idx, idx);
 			upd_len = idx - upd_start_idx + 1;
+		} else {
+			refcount_inc(&mtt->mmkey.usecount);
+			xa_unlock(&imr->implicit_children);
 		}

 		umem_odp = to_ib_umem_odp(mtt->umem);
@@ -797,6 +751,9 @@ static int pagefault_implicit_mr(struct mlx5_ib_mr *imr,

 		ret = pagefault_real_mr(mtt, umem_odp, user_va, len,
 					bytes_mapped, flags);
+
+		mlx5r_deref_odp_mkey(&mtt->mmkey);
+
 		if (ret < 0)
 			goto out;
 		user_va += len;
@@ -888,7 +845,6 @@ static int pagefault_mr(struct mlx5_ib_mr *mr, u64 io_virt, size_t bcnt,
 {
 	struct ib_umem_odp *odp = to_ib_umem_odp(mr->umem);

-	lockdep_assert_held(&mr_to_mdev(mr)->odp_srcu);
 	if (unlikely(io_virt < mr->mmkey.iova))
 		return -EFAULT;

@@ -980,7 +936,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 					 u32 *bytes_committed,
 					 u32 *bytes_mapped)
 {
-	int npages = 0, srcu_key, ret, i, outlen, cur_outlen = 0, depth = 0;
+	int npages = 0, ret, i, outlen, cur_outlen = 0, depth = 0;
 	struct pf_frame *head = NULL, *frame;
 	struct mlx5_core_mkey *mmkey;
 	struct mlx5_ib_mr *mr;
@@ -989,14 +945,14 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 	size_t offset;
 	int ndescs;

-	srcu_key = srcu_read_lock(&dev->odp_srcu);
-
 	io_virt += *bytes_committed;
 	bcnt -= *bytes_committed;

 next_mr:
+	xa_lock(&dev->odp_mkeys);
 	mmkey = xa_load(&dev->odp_mkeys, mlx5_base_mkey(key));
 	if (!mmkey) {
+		xa_unlock(&dev->odp_mkeys);
 		mlx5_ib_dbg(
 			dev,
 			"skipping non ODP MR (lkey=0x%06x) in page fault handler.\n",
@@ -1009,12 +965,15 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 		 * faulted.
 		 */
 		ret = 0;
-		goto srcu_unlock;
+		goto end;
 	}
+	refcount_inc(&mmkey->usecount);
+	xa_unlock(&dev->odp_mkeys);
+
 	if (!mkey_is_eq(mmkey, key)) {
 		mlx5_ib_dbg(dev, "failed to find mkey %x\n", key);
 		ret = -EFAULT;
-		goto srcu_unlock;
+		goto end;
 	}

 	switch (mmkey->type) {
@@ -1023,7 +982,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,

 		ret = pagefault_mr(mr, io_virt, bcnt, bytes_mapped, 0);
 		if (ret < 0)
-			goto srcu_unlock;
+			goto end;

 		mlx5_update_odp_stats(mr, faults, ret);

@@ -1038,7 +997,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 		if (depth >= MLX5_CAP_GEN(dev->mdev, max_indirection)) {
 			mlx5_ib_dbg(dev, "indirection level exceeded\n");
 			ret = -EFAULT;
-			goto srcu_unlock;
+			goto end;
 		}

 		outlen = MLX5_ST_SZ_BYTES(query_mkey_out) +
@@ -1049,7 +1008,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 			out = kzalloc(outlen, GFP_KERNEL);
 			if (!out) {
 				ret = -ENOMEM;
-				goto srcu_unlock;
+				goto end;
 			}
 			cur_outlen = outlen;
 		}
@@ -1059,7 +1018,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,

 		ret = mlx5_core_query_mkey(dev->mdev, mmkey, out, outlen);
 		if (ret)
-			goto srcu_unlock;
+			goto end;

 		offset = io_virt - MLX5_GET64(query_mkey_out, out,
 					      memory_key_mkey_entry.start_addr);
@@ -1073,7 +1032,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 			frame = kzalloc(sizeof(*frame), GFP_KERNEL);
 			if (!frame) {
 				ret = -ENOMEM;
-				goto srcu_unlock;
+				goto end;
 			}

 			frame->key = be32_to_cpu(pklm->key);
@@ -1092,7 +1051,7 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 	default:
 		mlx5_ib_dbg(dev, "wrong mkey type %d\n", mmkey->type);
 		ret = -EFAULT;
-		goto srcu_unlock;
+		goto end;
 	}

 	if (head) {
@@ -1105,10 +1064,13 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 		depth = frame->depth;
 		kfree(frame);

+		mlx5r_deref_odp_mkey(mmkey);
 		goto next_mr;
 	}

-srcu_unlock:
+end:
+	if (mmkey)
+		mlx5r_deref_odp_mkey(mmkey);
 	while (head) {
 		frame = head;
 		head = frame->next;
@@ -1116,7 +1078,6 @@ static int pagefault_single_data_segment(struct mlx5_ib_dev *dev,
 	}
 	kfree(out);

-	srcu_read_unlock(&dev->odp_srcu, srcu_key);
 	*bytes_committed = 0;
 	return ret ? ret : npages;
 }
@@ -1824,8 +1785,8 @@ static void destroy_prefetch_work(struct prefetch_mr_work *work)
 	u32 i;

 	for (i = 0; i < work->num_sge; ++i)
-		if (atomic_dec_and_test(&work->frags[i].mr->num_deferred_work))
-			wake_up(&work->frags[i].mr->q_deferred_work);
+		mlx5r_deref_odp_mkey(&work->frags[i].mr->mmkey);
+
 	kvfree(work);
 }

@@ -1835,24 +1796,30 @@ get_prefetchable_mr(struct ib_pd *pd, enum ib_uverbs_advise_mr_advice advice,
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct mlx5_core_mkey *mmkey;
-	struct mlx5_ib_mr *mr;
-
-	lockdep_assert_held(&dev->odp_srcu);
+	struct mlx5_ib_mr *mr = NULL;

+	xa_lock(&dev->odp_mkeys);
 	mmkey = xa_load(&dev->odp_mkeys, mlx5_base_mkey(lkey));
 	if (!mmkey || mmkey->key != lkey || mmkey->type != MLX5_MKEY_MR)
-		return NULL;
+		goto end;

 	mr = container_of(mmkey, struct mlx5_ib_mr, mmkey);

-	if (mr->ibmr.pd != pd)
-		return NULL;
+	if (mr->ibmr.pd != pd) {
+		mr = NULL;
+		goto end;
+	}

 	/* prefetch with write-access must be supported by the MR */
 	if (advice == IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH_WRITE &&
-	    !mr->umem->writable)
-		return NULL;
+	    !mr->umem->writable) {
+		mr = NULL;
+		goto end;
+	}

+	refcount_inc(&mmkey->usecount);
+end:
+	xa_unlock(&dev->odp_mkeys);
 	return mr;
 }

@@ -1860,17 +1827,12 @@ static void mlx5_ib_prefetch_mr_work(struct work_struct *w)
 {
 	struct prefetch_mr_work *work =
 		container_of(w, struct prefetch_mr_work, work);
-	struct mlx5_ib_dev *dev;
 	u32 bytes_mapped = 0;
-	int srcu_key;
 	int ret;
 	u32 i;

 	/* We rely on IB/core that work is executed if we have num_sge != 0 only. */
 	WARN_ON(!work->num_sge);
-	dev = mr_to_mdev(work->frags[0].mr);
-	/* SRCU should be held when calling to mlx5_odp_populate_xlt() */
-	srcu_key = srcu_read_lock(&dev->odp_srcu);
 	for (i = 0; i < work->num_sge; ++i) {
 		ret = pagefault_mr(work->frags[i].mr, work->frags[i].io_virt,
 				   work->frags[i].length, &bytes_mapped,
@@ -1879,7 +1841,6 @@ static void mlx5_ib_prefetch_mr_work(struct work_struct *w)
 			continue;
 		mlx5_update_odp_stats(work->frags[i].mr, prefetch, ret);
 	}
-	srcu_read_unlock(&dev->odp_srcu, srcu_key);

 	destroy_prefetch_work(work);
 }
@@ -1903,9 +1864,6 @@ static bool init_prefetch_work(struct ib_pd *pd,
 			work->num_sge = i;
 			return false;
 		}
-
-		/* Keep the MR pointer will valid outside the SRCU */
-		atomic_inc(&work->frags[i].mr->num_deferred_work);
 	}
 	work->num_sge = num_sge;
 	return true;
@@ -1916,42 +1874,35 @@ static int mlx5_ib_prefetch_sg_list(struct ib_pd *pd,
 				    u32 pf_flags, struct ib_sge *sg_list,
 				    u32 num_sge)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	u32 bytes_mapped = 0;
-	int srcu_key;
 	int ret = 0;
 	u32 i;

-	srcu_key = srcu_read_lock(&dev->odp_srcu);
 	for (i = 0; i < num_sge; ++i) {
 		struct mlx5_ib_mr *mr;

 		mr = get_prefetchable_mr(pd, advice, sg_list[i].lkey);
-		if (!mr) {
-			ret = -ENOENT;
-			goto out;
-		}
+		if (!mr)
+			return -ENOENT;
 		ret = pagefault_mr(mr, sg_list[i].addr, sg_list[i].length,
 				   &bytes_mapped, pf_flags);
-		if (ret < 0)
-			goto out;
+		if (ret < 0) {
+			mlx5r_deref_odp_mkey(&mr->mmkey);
+			return ret;
+		}
 		mlx5_update_odp_stats(mr, prefetch, ret);
+		mlx5r_deref_odp_mkey(&mr->mmkey);
 	}
-	ret = 0;

-out:
-	srcu_read_unlock(&dev->odp_srcu, srcu_key);
-	return ret;
+	return 0;
 }

 int mlx5_ib_advise_mr_prefetch(struct ib_pd *pd,
 			       enum ib_uverbs_advise_mr_advice advice,
 			       u32 flags, struct ib_sge *sg_list, u32 num_sge)
 {
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	u32 pf_flags = 0;
 	struct prefetch_mr_work *work;
-	int srcu_key;

 	if (advice == IB_UVERBS_ADVISE_MR_ADVICE_PREFETCH)
 		pf_flags |= MLX5_PF_FLAGS_DOWNGRADE;
@@ -1967,13 +1918,10 @@ int mlx5_ib_advise_mr_prefetch(struct ib_pd *pd,
 	if (!work)
 		return -ENOMEM;

-	srcu_key = srcu_read_lock(&dev->odp_srcu);
 	if (!init_prefetch_work(pd, advice, pf_flags, work, sg_list, num_sge)) {
-		srcu_read_unlock(&dev->odp_srcu, srcu_key);
 		destroy_prefetch_work(work);
 		return -EINVAL;
 	}
 	queue_work(system_unbound_wq, &work->work);
-	srcu_read_unlock(&dev->odp_srcu, srcu_key);
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 9eb51f06d3ae..50af84e76fb6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -56,6 +56,7 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
 	mkey->size = MLX5_GET64(mkc, mkc, len);
 	mkey->key |= mlx5_idx_to_mkey(mkey_index);
 	mkey->pd = MLX5_GET(mkc, mkc, pd);
+	init_waitqueue_head(&mkey->wait);

 	mlx5_core_dbg(dev, "out 0x%x, mkey 0x%x\n", mkey_index, mkey->key);
 	return 0;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 4901b4fadabb..f9e7036ae5a5 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -373,6 +373,8 @@ struct mlx5_core_mkey {
 	u32			key;
 	u32			pd;
 	u32			type;
+	struct wait_queue_head wait;
+	refcount_t usecount;
 };

 #define MLX5_24BIT_MASK		((1 << 24) - 1)
--
2.29.2

