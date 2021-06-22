Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F273B03D2
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 14:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhFVMLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 08:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231389AbhFVMK7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 08:10:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCB9F60FF1;
        Tue, 22 Jun 2021 12:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624363723;
        bh=//7jW/lXXGmn0EsA8WKHtcMbMG5Vgorq0Ij+CVN+3EQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kckhTUQ+F9oYbFVRfT3QR/+1CZPRzMDOtL+RbKPRtC+ScPaLT4ud/GKja+fErs2oJ
         UOkVkmtDSzMBuMNiNMPuQpCJDTfZ079KLk06D22EUyYMSPkrtU8UnN5yqM7sbH8NkN
         gWDopKsHieUrwKKrzBtOmdQXkERTHai66pa8n4+Wk9hdM3BFeQw57DQiFEEGGvzKAL
         Eklt1GUX7cDgaX0GRHlGBEAWQFgK1HW1MyRAquMflUiP1lRtRq43hZOO6NLlQaAtWQ
         u4E765IuYzVtpO0CD+yXY7SqEd6ViRdLmmi8HlaViRTSwThSEtn59+NDjE+LHPLFoX
         b9wgcJhzqHGdQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH rdma-next 5/5] RDMA/mlx5: Delay the deregistration of a non-cache mkey
Date:   Tue, 22 Jun 2021 15:08:23 +0300
Message-Id: <c5797f37888cd0a9b9ef742a222dfc4195802811.1624362290.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624362290.git.leonro@nvidia.com>
References: <cover.1624362290.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

When restarting an application with a large number of MRs with
non-cached mkeys, all the mkeys will be destroyed and then recreated.
This process takes a long time (about 1.4 for deregistration and 2.3
seconds for the registration of 10,000 MRs).

To shorten the restart runtime, insert the mkeys temporarily into the
cache and schedule a delayed work to destroy them later.
If an application is restarted, the mkeys will still be in the cache
when trying to reg them again, therefore, the registration will be faster
(about 0.7 for deregistration and 0.9 for registration of 10,000 MRs).

If 30 seconds have passed and no user reclaimed the temporarily cached
mkeys, the scheduled work will destroy them.

The above results are from a machine with:
Intel(R) Xeon(R) CPU E5-2620 v3 @ 2.40GHz 8 cores.
ConnectX-5 Ex VPI adapter card; EDR IB (100Gb/s).

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   1 +
 drivers/infiniband/hw/mlx5/mr.c      | 210 +++++++++++++++++++++------
 2 files changed, 163 insertions(+), 48 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e22eeceae9eb..6043a42e8dda 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -795,6 +795,7 @@ struct mlx5_mkey_cache_tree {
 	struct workqueue_struct *wq;
 	struct dentry		*root;
 	unsigned long		last_add;
+	struct delayed_work	remove_ent_dwork;
 };
 
 struct mlx5_ib_port_resources {
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 7c67aa4f1f1e..916e80a276fb 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -438,6 +438,35 @@ static bool is_special_ent(int ent_flags)
 	       (MLX5_CACHE_ENTRY_FLAG_IMR_MTT | MLX5_CACHE_ENTRY_FLAG_IMR_KSM);
 }
 
+#define ent_is_tmp(ent) (ent->limit == 0 && !is_special_ent(ent->entry_flags))
+
+static void clean_keys(struct mlx5_ib_dev *dev, struct mlx5_cache_ent *ent)
+{
+	struct mlx5r_cache_mkey *tmp_mkey, *mkey;
+	LIST_HEAD(del_list);
+
+	cancel_delayed_work(&ent->dwork);
+	while (1) {
+		spin_lock_irq(&ent->lock);
+		if (list_empty(&ent->head)) {
+			spin_unlock_irq(&ent->lock);
+			break;
+		}
+		mkey = list_first_entry(&ent->head, struct mlx5r_cache_mkey,
+					list);
+		list_move(&mkey->list, &del_list);
+		ent->available_mkeys--;
+		ent->total_mkeys--;
+		spin_unlock_irq(&ent->lock);
+		mlx5_core_destroy_mkey(dev->mdev, &mkey->key);
+	}
+
+	list_for_each_entry_safe(mkey, tmp_mkey, &del_list, list) {
+		list_del(&mkey->list);
+		kfree(mkey);
+	}
+}
+
 static bool someone_adding(struct mlx5_mkey_cache_tree *cache)
 {
 	struct mlx5_cache_ent *ent;
@@ -468,7 +497,7 @@ static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent)
 {
 	lockdep_assert_held(&ent->lock);
 
-	if (ent->disabled || READ_ONCE(ent->dev->fill_delay))
+	if (ent->disabled || READ_ONCE(ent->dev->fill_delay) || ent_is_tmp(ent))
 		return;
 	if (ent->available_mkeys < ent->limit) {
 		ent->fill_to_high_water = true;
@@ -573,6 +602,39 @@ static void cache_work_func(struct work_struct *work)
 	__cache_work_func(ent);
 }
 
+#define ent_is_default(ent) (ent->order != 0)
+
+static void remove_ent_work_func(struct work_struct *work)
+{
+	struct mlx5_mkey_cache_tree *cache;
+	struct mlx5_cache_ent *ent;
+	struct rb_node *cur, *next;
+
+	cache = container_of(work, struct mlx5_mkey_cache_tree,
+			     remove_ent_dwork.work);
+	mutex_lock(&cache->cache_lock);
+	cur = rb_last(&cache->cache_root);
+	while (cur) {
+		ent = container_of(cur, struct mlx5_cache_ent, node);
+
+		if (is_special_ent(ent->entry_flags) || ent->limit != 0) {
+			cur = rb_prev(cur);
+			continue;
+		}
+
+		cancel_work_sync(&ent->work);
+		cancel_delayed_work_sync(&ent->dwork);
+		next = rb_prev(cur);
+		clean_keys(ent->dev, ent);
+		if (!ent_is_default(ent)) {
+			rb_erase(&ent->node, &cache->cache_root);
+			kfree(ent);
+		}
+		cur = next;
+	}
+	mutex_unlock(&cache->cache_lock);
+}
+
 static int mlx5_ent_access_flags(struct mlx5_ib_dev *dev, int access_flags)
 {
 	int ret = 0;
@@ -792,33 +854,6 @@ static int mlx5_free_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 	return 0;
 }
 
-static void clean_keys(struct mlx5_ib_dev *dev, struct mlx5_cache_ent *ent)
-{
-	struct mlx5r_cache_mkey *tmp_mkey, *mkey;
-	LIST_HEAD(del_list);
-
-	cancel_delayed_work(&ent->dwork);
-	while (1) {
-		spin_lock_irq(&ent->lock);
-		if (list_empty(&ent->head)) {
-			spin_unlock_irq(&ent->lock);
-			break;
-		}
-		mkey = list_first_entry(&ent->head, struct mlx5r_cache_mkey,
-					list);
-		list_move(&mkey->list, &del_list);
-		ent->available_mkeys--;
-		ent->total_mkeys--;
-		spin_unlock_irq(&ent->lock);
-		mlx5_core_destroy_mkey(dev->mdev, &mkey->key);
-	}
-
-	list_for_each_entry_safe(mkey, tmp_mkey, &del_list, list) {
-		list_del(&mkey->list);
-		kfree(mkey);
-	}
-}
-
 static void mlx5_mkey_cache_tree_debugfs_cleanup(struct mlx5_ib_dev *dev)
 {
 	if (!mlx5_debugfs_root || dev->is_rep)
@@ -874,6 +909,7 @@ int mlx5_mkey_cache_tree_init(struct mlx5_ib_dev *dev)
 	mutex_init(&dev->slow_path_mutex);
 	mutex_init(&cache->cache_lock);
 	cache->cache_root = RB_ROOT;
+	INIT_DELAYED_WORK(&cache->remove_ent_dwork, remove_ent_work_func);
 	cache->wq = alloc_ordered_workqueue("mkey_cache", WQ_MEM_RECLAIM);
 	if (!cache->wq) {
 		mlx5_ib_warn(dev, "failed to create work queue\n");
@@ -925,6 +961,7 @@ int mlx5_mkey_cache_tree_cleanup(struct mlx5_ib_dev *dev)
 	if (!dev->cache.wq)
 		return 0;
 
+	cancel_delayed_work_sync(&dev->cache.remove_ent_dwork);
 	mutex_lock(&dev->cache.cache_lock);
 	for (node = rb_first(root); node; node = rb_next(node)) {
 		ent = container_of(node, struct mlx5_cache_ent, node);
@@ -1080,6 +1117,31 @@ static unsigned int mlx5_umem_dmabuf_default_pgsz(struct ib_umem *umem,
 	return PAGE_SIZE;
 }
 
+static bool get_temporary_cache_mkey(struct mlx5_cache_ent *ent,
+				     struct mlx5r_mkey *mkey)
+{
+	struct mlx5_ib_dev *dev = ent->dev;
+	struct mlx5r_cache_mkey *cmkey;
+
+	WARN_ON(!mutex_is_locked(&dev->cache.cache_lock));
+	spin_lock_irq(&ent->lock);
+	if (list_empty(&ent->head)) {
+		spin_unlock_irq(&ent->lock);
+		return false;
+	}
+
+	cmkey = list_first_entry(&ent->head, struct mlx5r_cache_mkey, list);
+	list_del(&cmkey->list);
+	ent->available_mkeys--;
+	ent->total_mkeys--;
+	spin_unlock_irq(&ent->lock);
+	queue_delayed_work(dev->cache.wq, &dev->cache.remove_ent_dwork,
+			   msecs_to_jiffies(30 * 1000));
+	mkey->key = cmkey->key;
+	kfree(cmkey);
+	return true;
+}
+
 static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 					     struct ib_umem *umem, u64 iova,
 					     int access_flags)
@@ -1104,36 +1166,45 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 	xlt_size = get_octo_len(iova, umem->length, order_base_2(page_size));
 	mutex_lock(&dev->cache.cache_lock);
 	ent = mkey_cache_ent_from_size(dev, ent_flags, xlt_size);
-	mutex_unlock(&dev->cache.cache_lock);
 	/*
 	 * Matches access in alloc_cache_mr(). If the MR can't come from the
 	 * cache then synchronously create an uncached one.
 	 */
-	if (!ent || ent->limit == 0) {
-		mutex_lock(&dev->slow_path_mutex);
-		mr = reg_create(pd, umem, iova, access_flags, page_size, false);
-		mutex_unlock(&dev->slow_path_mutex);
-		return mr;
+	if (!ent || (ent_is_tmp(ent) && ent->xlt != xlt_size)) {
+		mutex_unlock(&dev->cache.cache_lock);
+		goto slow_path;
 	}
 
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (!mr)
+	if (!mr) {
+		mutex_unlock(&dev->cache.cache_lock);
 		return ERR_PTR(-ENOMEM);
+	}
 
-	cmkey = get_cache_mkey(ent);
-	if (cmkey) {
-		mr->mmkey.key = cmkey->key;
-		mr->mmkey.cache_ent = cmkey->cache_ent;
-		kfree(cmkey);
-	} else {
-		ret = create_cacheable_mkey(ent, &mr->mmkey);
-		/*
-		 * The above already tried to do the same stuff as reg_create(),
-		 * no reason to try it again.
-		 */
-		if (ret) {
+	if (ent_is_tmp(ent)) {
+		ret = get_temporary_cache_mkey(ent, &mr->mmkey);
+		mutex_unlock(&dev->cache.cache_lock);
+		if (!ret) {
 			kfree(mr);
-			return ERR_PTR(ret);
+			goto slow_path;
+		}
+	} else {
+		mutex_unlock(&dev->cache.cache_lock);
+		cmkey = get_cache_mkey(ent);
+		if (cmkey) {
+			mr->mmkey.key = cmkey->key;
+			mr->mmkey.cache_ent = cmkey->cache_ent;
+			kfree(cmkey);
+		} else {
+			ret = create_cacheable_mkey(ent, &mr->mmkey);
+			/*
+			 * The above already tried to do the same stuff as
+			 * reg_create(), no reason to try it again.
+			 */
+			if (ret) {
+				kfree(mr);
+				return ERR_PTR(ret);
+			}
 		}
 	}
 	mr->ibmr.pd = pd;
@@ -1147,6 +1218,12 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 	set_mr_fields(dev, mr, umem->length, access_flags);
 
 	return mr;
+
+slow_path:
+	mutex_lock(&dev->slow_path_mutex);
+	mr = reg_create(pd, umem, iova, access_flags, page_size, false);
+	mutex_unlock(&dev->slow_path_mutex);
+	return mr;
 }
 
 #define MLX5_MAX_UMR_CHUNK ((1 << (MLX5_MAX_UMR_SHIFT + 4)) - \
@@ -2055,6 +2132,41 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 				   new_access_flags, udata);
 }
 
+static void insert_mkey_tmp_to_cache(struct mlx5_ib_dev *dev,
+				     struct mlx5_ib_mr *mr)
+{
+	struct mlx5_mkey_cache_tree *cache = &dev->cache;
+	struct ib_umem *umem = mr->umem;
+	struct mlx5_cache_ent *ent;
+	int ent_flags;
+	int xlt_size;
+
+	if (mr->mmkey.cache_ent)
+		return;
+	if (!umem || !mlx5_ib_can_load_pas_with_umr(dev, umem->length))
+		return;
+
+	ent_flags = mlx5_ent_access_flags(dev, mr->access_flags);
+	xlt_size = get_octo_len(umem->iova, umem->length, mr->page_shift);
+	mutex_lock(&cache->cache_lock);
+	queue_delayed_work(cache->wq, &cache->remove_ent_dwork,
+			   msecs_to_jiffies(30 * 1000));
+	ent = mkey_cache_ent_from_size(dev, ent_flags, xlt_size);
+	if (!ent || ent->xlt != xlt_size) {
+		mutex_unlock(&cache->cache_lock);
+		ent = mlx5_ib_create_cache_ent(dev, ent_flags, xlt_size, 0);
+		if (IS_ERR(ent))
+			return;
+		mutex_lock(&cache->cache_lock);
+	}
+
+	spin_lock_irq(&ent->lock);
+	ent->total_mkeys++;
+	spin_unlock_irq(&ent->lock);
+	mutex_unlock(&cache->cache_lock);
+	mr->mmkey.cache_ent = ent;
+}
+
 static int
 mlx5_alloc_priv_descs(struct ib_device *device,
 		      struct mlx5_ib_mr *mr,
@@ -2147,6 +2259,8 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 		mr->sig = NULL;
 	}
 
+	insert_mkey_tmp_to_cache(dev, mr);
+
 	/* Stop DMA */
 	if (mr->mmkey.cache_ent) {
 		if (revoke_mr(mr) || mlx5_free_mkey(dev, mr)) {
-- 
2.31.1

