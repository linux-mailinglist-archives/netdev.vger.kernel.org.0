Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2393B03CD
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 14:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhFVMLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 08:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231381AbhFVMKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 08:10:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F97761164;
        Tue, 22 Jun 2021 12:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624363720;
        bh=Dpnf+xk9YV/U8fPlXQhQAYB1jVSas8+Lm0AZhun+xEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qsCx5Q5GjWAQqPaGdk07vDs1Srwh9vBsvxaDvEx96Wj/tEemOtKTWsFLZA3FVqT5O
         cEX0qzJkSMDLhwLZgoAf7VJOYLNCsd4WPf64pmrFg96QrHpM1L93FZZsKG/VhXxPze
         H8dhqEi6BWW8l9nbn0CabaKw92WHHMVqzuzIkEDMIwC/LjoXY8YIEQJI0fI4BVseWf
         NEqRbAogu58i2NpwKW9zVwgtKwH9VbnDt7H2nso62j1XQGRD7AI0c0Lxs/cy7bJgMK
         Q45W3AKwO+AVzK8PHuKA93DEQkM+8zU7tEd678xY1N9UguLqGDh3OT3ymLfwBeZw5S
         UrlfrhLcE1RcQ==
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
Subject: [PATCH mlx5-next 4/5] RDMA/mlx5: Change the cache structure to an rbtree
Date:   Tue, 22 Jun 2021 15:08:22 +0300
Message-Id: <f4dbb2d090b2d97ac6ba3d88605069fa2e83fff8.1624362290.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624362290.git.leonro@nvidia.com>
References: <cover.1624362290.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Currently, the cache structure is a linear array held within
mlx5_ib_dev. Each entry in the array holds a list_head of mkeys whose
sizes are the order of the entry they are in (i.e. in entry number 2
there will be mkeys of size 4, at entry 3 mkeys of size 8, and so on).
The access flags of all cached mkeys are
IB_ACCESS_DISABLE_RELAXED_ORDERING.

This structure does not allow adding new entries to the cache.
Therefore, the cache can only hold mkeys that meet the above conditions
(size of some power of 2 and access_flag =
IB_ACCESS_DISABLE_RELAXED_ORDERING).
Later in the series, we would like to allow caching mkeys with different
sizes and different access_flag. Adapting the cache structure for this
purpose.

Change the cache structure to an RB-tree, where every node is an entry
that holds an mkeys list. The tree key is the access_flag as MSB and the
size of mkey as LSB. mlx5_ib_dev will hold the root of the tree.
When initializing a device, the default entries will be generated, that
is, entries for mkeys' size = 2^x and access_flag =
IB_ACCESS_DISABLE_RELAXED_ORDERING.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c    |   4 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  34 +++-
 drivers/infiniband/hw/mlx5/mr.c      | 271 ++++++++++++++++++++-------
 drivers/infiniband/hw/mlx5/odp.c     |  43 +++--
 include/linux/mlx5/driver.h          |   4 +-
 5 files changed, 261 insertions(+), 95 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 849bf016d8ae..c46581686258 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4051,7 +4051,7 @@ static void mlx5_ib_stage_pre_ib_reg_umr_cleanup(struct mlx5_ib_dev *dev)
 {
 	int err;
 
-	err = mlx5_mkey_cache_cleanup(dev);
+	err = mlx5_mkey_cache_tree_cleanup(dev);
 	if (err)
 		mlx5_ib_warn(dev, "mr cache cleanup failed\n");
 
@@ -4154,7 +4154,7 @@ static int mlx5_ib_stage_post_ib_reg_umr_init(struct mlx5_ib_dev *dev)
 	dev->umrc.pd = pd;
 
 	sema_init(&dev->umrc.sem, MAX_UMR_WR);
-	ret = mlx5_mkey_cache_init(dev);
+	ret = mlx5_mkey_cache_tree_init(dev);
 	if (ret) {
 		mlx5_ib_warn(dev, "mr cache init failed %d\n", ret);
 		goto error_4;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index ffb6f1d41f3d..e22eeceae9eb 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -749,7 +749,7 @@ struct mlx5_cache_ent {
 
 
 	char                    name[4];
-	u32                     order;
+	u32			order;
 	u32			xlt;
 	u32			access_mode;
 	u32			page;
@@ -777,11 +777,22 @@ struct mlx5_cache_ent {
 	struct mlx5_ib_dev     *dev;
 	struct work_struct	work;
 	struct delayed_work	dwork;
+
+	struct rb_node		node;
+	unsigned int		entry_flags;
+};
+
+enum {
+	MLX5_CACHE_ENTRY_FLAG_IMR_MTT = (1 << 0),
+	MLX5_CACHE_ENTRY_FLAG_IMR_KSM = (1 << 1),
+	MLX5_CACHE_ENTRY_FLAG_REMOTE_ATOMIC = (1 << 2),
+	MLX5_CACHE_ENTRY_FLAG_RELAXED_ORDERING = (1 << 3),
 };
 
-struct mlx5_mkey_cache {
+struct mlx5_mkey_cache_tree {
+	struct rb_root		cache_root;
+	struct mutex		cache_lock;
 	struct workqueue_struct *wq;
-	struct mlx5_cache_ent	ent[MAX_MKEY_CACHE_ENTRIES];
 	struct dentry		*root;
 	unsigned long		last_add;
 };
@@ -1065,7 +1076,7 @@ struct mlx5_ib_dev {
 	struct mlx5_ib_resources	devr;
 
 	atomic_t			mkey_var;
-	struct mlx5_mkey_cache		cache;
+	struct mlx5_mkey_cache_tree	cache;
 	struct timer_list		delay_timer;
 	/* Prevents soft lock on massive reg MRs */
 	struct mutex			slow_path_mutex;
@@ -1313,8 +1324,8 @@ void mlx5_ib_populate_pas(struct ib_umem *umem, size_t page_size, __be64 *pas,
 			  u64 access_flags);
 void mlx5_ib_copy_pas(u64 *old, u64 *new, int step, int num);
 int mlx5_ib_get_cqe_size(struct ib_cq *ibcq);
-int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev);
-int mlx5_mkey_cache_cleanup(struct mlx5_ib_dev *dev);
+int mlx5_mkey_cache_tree_init(struct mlx5_ib_dev *dev);
+int mlx5_mkey_cache_tree_cleanup(struct mlx5_ib_dev *dev);
 
 struct mlx5_ib_mr *mlx5_alloc_special_mkey(struct mlx5_ib_dev *dev,
 					   unsigned int entry,
@@ -1335,6 +1346,9 @@ int mlx5_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *wq_ind_table);
 struct ib_mr *mlx5_ib_reg_dm_mr(struct ib_pd *pd, struct ib_dm *dm,
 				struct ib_dm_mr_attr *attr,
 				struct uverbs_attr_bundle *attrs);
+struct mlx5_cache_ent *mlx5_ib_create_cache_ent(struct mlx5_ib_dev *dev,
+						int entry_flags, int size,
+						int order);
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 int mlx5_ib_odp_init_one(struct mlx5_ib_dev *ibdev);
@@ -1342,7 +1356,7 @@ int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq);
 void mlx5_ib_odp_cleanup_one(struct mlx5_ib_dev *ibdev);
 int __init mlx5_ib_odp_init(void);
 void mlx5_ib_odp_cleanup(void);
-void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent);
+int mlx5_odp_init_mkey_cache_entry(struct mlx5_ib_dev *dev, int ent_num);
 void mlx5_odp_populate_xlt(void *xlt, size_t idx, size_t nentries,
 			   struct mlx5_ib_mr *mr, int flags);
 
@@ -1361,7 +1375,11 @@ static inline int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev,
 static inline void mlx5_ib_odp_cleanup_one(struct mlx5_ib_dev *ibdev) {}
 static inline int mlx5_ib_odp_init(void) { return 0; }
 static inline void mlx5_ib_odp_cleanup(void)				    {}
-static inline void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent) {}
+static inline int mlx5_odp_init_mkey_cache_entry(struct mlx5_ib_dev *dev,
+						 int ent_num)
+{
+	return 0;
+}
 static inline void mlx5_odp_populate_xlt(void *xlt, size_t idx, size_t nentries,
 					 struct mlx5_ib_mr *mr, int flags) {}
 
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 8d7de4eddc11..7c67aa4f1f1e 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -432,20 +432,30 @@ static const struct file_operations limit_fops = {
 	.read	= limit_read,
 };
 
-static bool someone_adding(struct mlx5_mkey_cache *cache)
+static bool is_special_ent(int ent_flags)
 {
-	unsigned int i;
+	return ent_flags &
+	       (MLX5_CACHE_ENTRY_FLAG_IMR_MTT | MLX5_CACHE_ENTRY_FLAG_IMR_KSM);
+}
 
-	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
-		struct mlx5_cache_ent *ent = &cache->ent[i];
-		bool ret;
+static bool someone_adding(struct mlx5_mkey_cache_tree *cache)
+{
+	struct mlx5_cache_ent *ent;
+	struct rb_node *node;
+	bool ret;
 
+	mutex_lock(&cache->cache_lock);
+	for (node = rb_first(&cache->cache_root); node; node = rb_next(node)) {
+		ent = container_of(node, struct mlx5_cache_ent, node);
 		spin_lock_irq(&ent->lock);
 		ret = ent->available_mkeys < ent->limit;
 		spin_unlock_irq(&ent->lock);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&cache->cache_lock);
 			return true;
+		}
 	}
+	mutex_unlock(&cache->cache_lock);
 	return false;
 }
 
@@ -486,7 +496,7 @@ static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent)
 static void __cache_work_func(struct mlx5_cache_ent *ent)
 {
 	struct mlx5_ib_dev *dev = ent->dev;
-	struct mlx5_mkey_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache_tree *cache = &dev->cache;
 	int err;
 
 	spin_lock_irq(&ent->lock);
@@ -563,29 +573,142 @@ static void cache_work_func(struct work_struct *work)
 	__cache_work_func(ent);
 }
 
+static int mlx5_ent_access_flags(struct mlx5_ib_dev *dev, int access_flags)
+{
+	int ret = 0;
+
+	if ((access_flags & IB_ACCESS_REMOTE_ATOMIC) &&
+	    MLX5_CAP_GEN(dev->mdev, atomic) &&
+	    MLX5_CAP_GEN(dev->mdev, umr_modify_atomic_disabled))
+		ret |= MLX5_CACHE_ENTRY_FLAG_REMOTE_ATOMIC;
+
+	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
+	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write) &&
+	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write_umr))
+		ret |= MLX5_CACHE_ENTRY_FLAG_RELAXED_ORDERING;
+
+	if ((access_flags & IB_ACCESS_RELAXED_ORDERING) &&
+	    MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read) &&
+	    !MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read_umr))
+		ret |= MLX5_CACHE_ENTRY_FLAG_RELAXED_ORDERING;
+
+	return ret;
+
+}
+
+static int ent_insert(struct mlx5_mkey_cache_tree *cache,
+		      struct mlx5_cache_ent *ent)
+{
+	struct rb_node **new = &cache->cache_root.rb_node, *parent = NULL;
+	struct mlx5_cache_ent *this;
+
+	/* Figure out where to put new node */
+	while (*new) {
+		this = container_of(*new, struct mlx5_cache_ent, node);
+		parent = *new;
+		if (ent->entry_flags < this->entry_flags)
+			new = &((*new)->rb_left);
+		else if (ent->entry_flags > this->entry_flags)
+			new = &((*new)->rb_right);
+		else {
+			if (ent->xlt < this->xlt)
+				new = &((*new)->rb_left);
+			else if (ent->xlt > this->xlt)
+				new = &((*new)->rb_right);
+			else
+				return -EEXIST;
+		}
+	}
+
+	/* Add new node and rebalance tree. */
+	rb_link_node(&ent->node, parent, new);
+	rb_insert_color(&ent->node, &cache->cache_root);
+
+	return 0;
+}
+
+struct mlx5_cache_ent *mlx5_ib_create_cache_ent(struct mlx5_ib_dev *dev,
+						int entry_flags, int xlt_size,
+						int order)
+{
+	struct mlx5_cache_ent *ent;
+	int ret;
+
+	ent = kzalloc(sizeof(*ent), GFP_KERNEL);
+	if (!ent)
+		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&ent->head);
+	spin_lock_init(&ent->lock);
+	ent->entry_flags = entry_flags;
+	ent->xlt = xlt_size;
+	ent->order = order;
+	ent->dev = dev;
+
+	INIT_WORK(&ent->work, cache_work_func);
+	INIT_DELAYED_WORK(&ent->dwork, delayed_cache_work_func);
+
+	mutex_lock(&dev->cache.cache_lock);
+	ret = ent_insert(&dev->cache, ent);
+	mutex_unlock(&dev->cache.cache_lock);
+	if (ret) {
+		kfree(ent);
+		return ERR_PTR(ret);
+	}
+	return ent;
+}
+
+static struct mlx5_cache_ent *mkey_cache_ent_from_size(struct mlx5_ib_dev *dev,
+						       int ent_flags, int size)
+{
+	struct rb_node *node = dev->cache.cache_root.rb_node;
+	struct mlx5_cache_ent *cur, *prev = NULL;
+
+	WARN_ON(!mutex_is_locked(&dev->cache.cache_lock));
+	while (node) {
+		cur = container_of(node, struct mlx5_cache_ent, node);
+
+		if (cur->entry_flags > ent_flags)
+			node = node->rb_left;
+		else if (cur->entry_flags < ent_flags)
+			node = node->rb_right;
+		else {
+			if (cur->xlt > size) {
+				prev = cur;
+				node = node->rb_left;
+			} else if (cur->xlt < size)
+				node = node->rb_right;
+			else
+				return cur;
+		}
+	}
+	return prev;
+}
+
 /* Get an Mkey from a special cache entry */
 struct mlx5_ib_mr *mlx5_alloc_special_mkey(struct mlx5_ib_dev *dev,
 					   unsigned int entry, int access_flags)
 {
-	struct mlx5_mkey_cache *cache = &dev->cache;
 	struct mlx5r_cache_mkey *cmkey;
 	struct mlx5_cache_ent *ent;
 	struct mlx5_ib_mr *mr;
+	int ent_flags;
 	int err;
 
-	if (WARN_ON(entry <= MKEY_CACHE_LAST_STD_ENTRY ||
-		    entry >= ARRAY_SIZE(cache->ent)))
+	if (WARN_ON(!is_special_ent(entry)))
 		return ERR_PTR(-EINVAL);
 
-	/* Matches access in alloc_cache_mr() */
-	if (!mlx5_ib_can_reconfig_with_umr(dev, 0, access_flags))
+	ent_flags = entry | mlx5_ent_access_flags(dev, access_flags);
+
+	mutex_lock(&dev->cache.cache_lock);
+	ent = mkey_cache_ent_from_size(dev, ent_flags, 0);
+	mutex_unlock(&dev->cache.cache_lock);
+	if (!ent)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
 	if (!mr)
 		return ERR_PTR(-ENOMEM);
 
-	ent = &cache->ent[entry];
 	spin_lock_irq(&ent->lock);
 	if (list_empty(&ent->head)) {
 		spin_unlock_irq(&ent->lock);
@@ -616,13 +739,18 @@ struct mlx5_ib_mr *mlx5_alloc_special_mkey(struct mlx5_ib_dev *dev,
 static struct mlx5r_cache_mkey *get_cache_mkey(struct mlx5_cache_ent *req_ent)
 {
 	struct mlx5_ib_dev *dev = req_ent->dev;
-	struct mlx5_cache_ent *ent = req_ent;
 	struct mlx5r_cache_mkey *cmkey;
+	struct mlx5_cache_ent *ent;
+	struct rb_node *node;
 
 	/* Try larger Mkey pools from the cache to satisfy the allocation */
-	for (; ent != &dev->cache.ent[MKEY_CACHE_LAST_STD_ENTRY + 1]; ent++) {
-		mlx5_ib_dbg(dev, "order %u, cache index %zu\n", ent->order,
-			    ent - dev->cache.ent);
+	mutex_lock(&dev->cache.cache_lock);
+	for (node = &req_ent->node; node; node = rb_next(node)) {
+		ent = container_of(node, struct mlx5_cache_ent, node);
+
+		if (ent->entry_flags != req_ent->entry_flags)
+			break;
+		mlx5_ib_dbg(dev, "size %d\n", ent->xlt);
 
 		spin_lock_irq(&ent->lock);
 		if (!list_empty(&ent->head)) {
@@ -632,11 +760,13 @@ static struct mlx5r_cache_mkey *get_cache_mkey(struct mlx5_cache_ent *req_ent)
 			ent->available_mkeys--;
 			queue_adjust_cache_locked(ent);
 			spin_unlock_irq(&ent->lock);
+			mutex_unlock(&dev->cache.cache_lock);
 			return cmkey;
 		}
 		queue_adjust_cache_locked(ent);
 		spin_unlock_irq(&ent->lock);
 	}
+	mutex_unlock(&dev->cache.cache_lock);
 	req_ent->miss++;
 	return NULL;
 }
@@ -662,10 +792,8 @@ static int mlx5_free_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 	return 0;
 }
 
-static void clean_keys(struct mlx5_ib_dev *dev, int c)
+static void clean_keys(struct mlx5_ib_dev *dev, struct mlx5_cache_ent *ent)
 {
-	struct mlx5_mkey_cache *cache = &dev->cache;
-	struct mlx5_cache_ent *ent = &cache->ent[c];
 	struct mlx5r_cache_mkey *tmp_mkey, *mkey;
 	LIST_HEAD(del_list);
 
@@ -691,7 +819,7 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 	}
 }
 
-static void mlx5_mkey_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
+static void mlx5_mkey_cache_tree_debugfs_cleanup(struct mlx5_ib_dev *dev)
 {
 	if (!mlx5_debugfs_root || dev->is_rep)
 		return;
@@ -700,20 +828,25 @@ static void mlx5_mkey_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
 	dev->cache.root = NULL;
 }
 
-static void mlx5_mkey_cache_debugfs_init(struct mlx5_ib_dev *dev)
+static void mlx5_mkey_cache_tree_debugfs_init(struct mlx5_ib_dev *dev)
 {
-	struct mlx5_mkey_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache_tree *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
+	struct rb_node *node;
 	struct dentry *dir;
-	int i;
 
 	if (!mlx5_debugfs_root || dev->is_rep)
 		return;
 
 	cache->root = debugfs_create_dir("mr_cache", dev->mdev->priv.dbg_root);
 
-	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
-		ent = &cache->ent[i];
+	mutex_lock(&dev->cache.cache_lock);
+	for (node = rb_first(&cache->cache_root); node; node = rb_next(node)) {
+		ent = container_of(node, struct mlx5_cache_ent, node);
+
+		if (!ent->order)
+			continue;
+
 		sprintf(ent->name, "%d", ent->order);
 		dir = debugfs_create_dir(ent->name, cache->root);
 		debugfs_create_file("size", 0600, dir, ent, &size_fops);
@@ -721,6 +854,7 @@ static void mlx5_mkey_cache_debugfs_init(struct mlx5_ib_dev *dev)
 		debugfs_create_u32("cur", 0400, dir, &ent->available_mkeys);
 		debugfs_create_u32("miss", 0600, dir, &ent->miss);
 	}
+	mutex_unlock(&dev->cache.cache_lock);
 }
 
 static void delay_time_func(struct timer_list *t)
@@ -730,13 +864,16 @@ static void delay_time_func(struct timer_list *t)
 	WRITE_ONCE(dev->fill_delay, 0);
 }
 
-int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
+int mlx5_mkey_cache_tree_init(struct mlx5_ib_dev *dev)
 {
-	struct mlx5_mkey_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache_tree *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
+	int err;
 	int i;
 
 	mutex_init(&dev->slow_path_mutex);
+	mutex_init(&cache->cache_lock);
+	cache->cache_root = RB_ROOT;
 	cache->wq = alloc_ordered_workqueue("mkey_cache", WQ_MEM_RECLAIM);
 	if (!cache->wq) {
 		mlx5_ib_warn(dev, "failed to create work queue\n");
@@ -745,28 +882,25 @@ int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 
 	mlx5_cmd_init_async_ctx(dev->mdev, &dev->async_ctx);
 	timer_setup(&dev->delay_timer, delay_time_func, 0);
-	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
-		ent = &cache->ent[i];
-		INIT_LIST_HEAD(&ent->head);
-		spin_lock_init(&ent->lock);
-		ent->order = i + 2;
-		ent->dev = dev;
-		ent->limit = 0;
-
-		INIT_WORK(&ent->work, cache_work_func);
-		INIT_DELAYED_WORK(&ent->dwork, delayed_cache_work_func);
+	for (i = 0; i < MAX_MKEY_CACHE_DEFAULT_ENTRIES; i++) {
+		u8 order = i + 2;
+		u32 xlt_size = (1 << order) * sizeof(struct mlx5_mtt) /
+			       MLX5_IB_UMR_OCTOWORD;
 
 		if (i > MKEY_CACHE_LAST_STD_ENTRY) {
-			mlx5_odp_init_mkey_cache_entry(ent);
+			err = mlx5_odp_init_mkey_cache_entry(dev, i);
+			if (err)
+				return err;
 			continue;
 		}
 
-		if (ent->order > mkey_cache_max_order(dev))
+		ent = mlx5_ib_create_cache_ent(dev, 0, xlt_size, order);
+		if (IS_ERR(ent))
+			return PTR_ERR(ent);
+		if (order > mkey_cache_max_order(dev))
 			continue;
 
 		ent->page = PAGE_SHIFT;
-		ent->xlt = (1 << ent->order) * sizeof(struct mlx5_mtt) /
-			   MLX5_IB_UMR_OCTOWORD;
 		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
 		if ((dev->mdev->profile->mask & MLX5_PROF_MASK_MR_CACHE) &&
 		    !dev->is_rep && mlx5_core_is_pf(dev->mdev) &&
@@ -778,22 +912,22 @@ int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 		queue_adjust_cache_locked(ent);
 		spin_unlock_irq(&ent->lock);
 	}
-
-	mlx5_mkey_cache_debugfs_init(dev);
-
+	mlx5_mkey_cache_tree_debugfs_init(dev);
 	return 0;
 }
 
-int mlx5_mkey_cache_cleanup(struct mlx5_ib_dev *dev)
+int mlx5_mkey_cache_tree_cleanup(struct mlx5_ib_dev *dev)
 {
-	unsigned int i;
+	struct rb_root *root = &dev->cache.cache_root;
+	struct mlx5_cache_ent *ent, *tmp;
+	struct rb_node *node;
 
 	if (!dev->cache.wq)
 		return 0;
 
-	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
-		struct mlx5_cache_ent *ent = &dev->cache.ent[i];
-
+	mutex_lock(&dev->cache.cache_lock);
+	for (node = rb_first(root); node; node = rb_next(node)) {
+		ent = container_of(node, struct mlx5_cache_ent, node);
 		spin_lock_irq(&ent->lock);
 		ent->disabled = true;
 		spin_unlock_irq(&ent->lock);
@@ -801,11 +935,15 @@ int mlx5_mkey_cache_cleanup(struct mlx5_ib_dev *dev)
 		cancel_delayed_work_sync(&ent->dwork);
 	}
 
-	mlx5_mkey_cache_debugfs_cleanup(dev);
+	mlx5_mkey_cache_tree_debugfs_cleanup(dev);
 	mlx5_cmd_cleanup_async_ctx(&dev->async_ctx);
 
-	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++)
-		clean_keys(dev, i);
+	rbtree_postorder_for_each_entry_safe(ent, tmp, root, node) {
+		clean_keys(dev, ent);
+		rb_erase(&ent->node, root);
+		kfree(ent);
+	}
+	mutex_unlock(&dev->cache.cache_lock);
 
 	destroy_workqueue(dev->cache.wq);
 	del_timer_sync(&dev->delay_timer);
@@ -921,19 +1059,6 @@ static int mlx5_ib_post_send_wait(struct mlx5_ib_dev *dev,
 	return err;
 }
 
-static struct mlx5_cache_ent *mkey_cache_ent_from_order(struct mlx5_ib_dev *dev,
-							unsigned int order)
-{
-	struct mlx5_mkey_cache *cache = &dev->cache;
-
-	if (order < cache->ent[0].order)
-		return &cache->ent[0];
-	order = order - cache->ent[0].order;
-	if (order > MKEY_CACHE_LAST_STD_ENTRY)
-		return NULL;
-	return &cache->ent[order];
-}
-
 static void set_mr_fields(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
 			  u64 length, int access_flags)
 {
@@ -964,6 +1089,8 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 	struct mlx5_cache_ent *ent;
 	struct mlx5_ib_mr *mr;
 	unsigned int page_size;
+	int ent_flags;
+	int xlt_size;
 	int ret;
 
 	if (umem->is_dmabuf)
@@ -973,14 +1100,16 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 						     0, iova);
 	if (WARN_ON(!page_size))
 		return ERR_PTR(-EINVAL);
-	ent = mkey_cache_ent_from_order(
-		dev, order_base_2(ib_umem_num_dma_blocks(umem, page_size)));
+	ent_flags = mlx5_ent_access_flags(dev, access_flags);
+	xlt_size = get_octo_len(iova, umem->length, order_base_2(page_size));
+	mutex_lock(&dev->cache.cache_lock);
+	ent = mkey_cache_ent_from_size(dev, ent_flags, xlt_size);
+	mutex_unlock(&dev->cache.cache_lock);
 	/*
 	 * Matches access in alloc_cache_mr(). If the MR can't come from the
 	 * cache then synchronously create an uncached one.
 	 */
-	if (!ent || ent->limit == 0 ||
-	    !mlx5_ib_can_reconfig_with_umr(dev, 0, access_flags)) {
+	if (!ent || ent->limit == 0) {
 		mutex_lock(&dev->slow_path_mutex);
 		mr = reg_create(pd, umem, iova, access_flags, page_size, false);
 		mutex_unlock(&dev->slow_path_mutex);
@@ -1774,7 +1903,7 @@ static bool can_use_umr_rereg_pas(struct mlx5_ib_mr *mr,
 	if (WARN_ON(!*page_size))
 		return false;
 	return (1ULL << mr->mmkey.cache_ent->order) >=
-	       ib_umem_num_dma_blocks(new_umem, *page_size);
+			       ib_umem_num_dma_blocks(new_umem, *page_size);
 }
 
 static int umr_rereg_pas(struct mlx5_ib_mr *mr, struct ib_pd *pd,
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 9c7942118d2c..e4a78b4c6034 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -418,7 +418,8 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 	if (IS_ERR(odp))
 		return ERR_CAST(odp);
 
-	mr = mlx5_alloc_special_mkey(mr_to_mdev(imr), MLX5_IMR_MTT_CACHE_ENTRY,
+	mr = mlx5_alloc_special_mkey(mr_to_mdev(imr),
+				     MLX5_CACHE_ENTRY_FLAG_IMR_MTT,
 				     imr->access_flags);
 	if (IS_ERR(mr)) {
 		ib_umem_odp_release(odp);
@@ -493,7 +494,7 @@ struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
 	if (IS_ERR(umem_odp))
 		return ERR_CAST(umem_odp);
 
-	imr = mlx5_alloc_special_mkey(dev, MLX5_IMR_KSM_CACHE_ENTRY,
+	imr = mlx5_alloc_special_mkey(dev, MLX5_CACHE_ENTRY_FLAG_IMR_KSM,
 				      access_flags);
 	if (IS_ERR(imr)) {
 		ib_umem_odp_release(umem_odp);
@@ -1605,30 +1606,48 @@ mlx5_ib_odp_destroy_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 	return err;
 }
 
-void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent)
+int mlx5_odp_init_mkey_cache_entry(struct mlx5_ib_dev *dev, int ent_num)
 {
-	if (!(ent->dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
-		return;
+	struct mlx5_cache_ent *ent;
+	int ent_flags;
+	u32 xlt_size;
+
+	if (!(dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
+		return 0;
 
-	switch (ent->order - 2) {
+	switch (ent_num) {
 	case MLX5_IMR_MTT_CACHE_ENTRY:
-		ent->page = PAGE_SHIFT;
-		ent->xlt = MLX5_IMR_MTT_ENTRIES *
-			   sizeof(struct mlx5_mtt) /
+		xlt_size = MLX5_IMR_MTT_ENTRIES * sizeof(struct mlx5_mtt) /
 			   MLX5_IB_UMR_OCTOWORD;
+		ent_flags = MLX5_CACHE_ENTRY_FLAG_IMR_MTT;
+
+		ent = mlx5_ib_create_cache_ent(dev, ent_flags, xlt_size,
+					       ent_num + 2);
+		if (IS_ERR(ent))
+			return PTR_ERR(ent);
+
+		ent->page = PAGE_SHIFT;
 		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
 		ent->limit = 0;
 		break;
 
 	case MLX5_IMR_KSM_CACHE_ENTRY:
-		ent->page = MLX5_KSM_PAGE_SHIFT;
-		ent->xlt = mlx5_imr_ksm_entries *
-			   sizeof(struct mlx5_klm) /
+		xlt_size = mlx5_imr_ksm_entries * sizeof(struct mlx5_klm) /
 			   MLX5_IB_UMR_OCTOWORD;
+		ent_flags = MLX5_CACHE_ENTRY_FLAG_IMR_KSM;
+
+		ent = mlx5_ib_create_cache_ent(dev, ent_flags, xlt_size,
+					       ent_num + 2);
+		if (IS_ERR(ent))
+			return PTR_ERR(ent);
+
+		ent->page = MLX5_KSM_PAGE_SHIFT;
 		ent->access_mode = MLX5_MKC_ACCESS_MODE_KSM;
 		ent->limit = 0;
 		break;
 	}
+
+	return 0;
 }
 
 static const struct ib_device_ops mlx5_ib_dev_odp_ops = {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 8191140454e1..bb459a2ca18c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1080,7 +1080,7 @@ enum {
 	MKEY_CACHE_LAST_STD_ENTRY = 20,
 	MLX5_IMR_MTT_CACHE_ENTRY,
 	MLX5_IMR_KSM_CACHE_ENTRY,
-	MAX_MKEY_CACHE_ENTRIES
+	MAX_MKEY_CACHE_DEFAULT_ENTRIES
 };
 
 /* Async-atomic event notifier used by mlx5 core to forward FW
@@ -1142,7 +1142,7 @@ struct mlx5_profile {
 	struct {
 		int	size;
 		int	limit;
-	} mr_cache[MAX_MKEY_CACHE_ENTRIES];
+	} mr_cache[MAX_MKEY_CACHE_DEFAULT_ENTRIES];
 };
 
 enum {
-- 
2.31.1

