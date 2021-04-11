Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C31935B433
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 14:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbhDKMaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 08:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:51538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235557AbhDKMaD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 08:30:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B57F60FF1;
        Sun, 11 Apr 2021 12:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618144187;
        bh=vdEKiQr5UMjMh9WW+eSmS2Lw2eZ4qYO7d5k7HCd/SyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2ordb0uP5eUTOIWeZe6AGFau2ic6K+GiAPz5QUcEvElNeW8SyBQxnhbouRn6QZ3t
         ko9VEdpIvadgL7gfNGub/3+pQ8UIclFx3IX8uHDKpLcgATKURTSl8xyeaShe5148eJ
         Qt9G2JsWa/UMEY5j5AjdF7yGhWaHInT/eZkieFkQj5DkcDCsNvACIBhg6qckj+YS2n
         y4UpzieVhyMy5Nw1Dt1So5dOwLA1twn2oSUOIhUZo6kk7+wLT78cp3fXnrIMvCkHvE
         8ZPOJHRLW+X+QmMK8AViamNvbWKzyonqQ/WfnPEO3H1nMP6nGOEbqcAWDa1LG5DJzp
         iAnOAsWy6Cbog==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>, linux-api@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next v1 6/7] RDMA/mlx5: Add support in MEMIC operations
Date:   Sun, 11 Apr 2021 15:29:23 +0300
Message-Id: <20210411122924.60230-7-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210411122924.60230-1-leon@kernel.org>
References: <20210411122924.60230-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

MEMIC buffer, in addition to regular read and write operations, can
support atomic operations from the host.

Introduce and implement new UAPI to allocate address space for MEMIC
operations such as atomic. This includes:

1. Expose new IOCTL for request mapping of MEMIC operation.
2. Hold the operations address in a list, so same operation to same DM
   will be allocated only once.
3. Manage refcount on the mlx5_ib_dm object, so it would be keep valid
   until all addresses were unmapped.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/dm.c          | 192 +++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/dm.h          |  12 ++
 drivers/infiniband/hw/mlx5/main.c        |   7 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |   1 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  11 ++
 5 files changed, 209 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index a648554210f8..bec0489428f8 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -148,16 +148,126 @@ static int mlx5_cmd_alloc_memic_op(struct mlx5_dm *dm, phys_addr_t addr,
 }
 
 static int add_dm_mmap_entry(struct ib_ucontext *context,
-			     struct mlx5_ib_dm_memic *mdm, u64 address)
+			     struct mlx5_user_mmap_entry *mentry, u8 mmap_flag,
+			     size_t size, u64 address)
 {
-	mdm->mentry.mmap_flag = MLX5_IB_MMAP_TYPE_MEMIC;
-	mdm->mentry.address = address;
+	mentry->mmap_flag = mmap_flag;
+	mentry->address = address;
+
 	return rdma_user_mmap_entry_insert_range(
-		context, &mdm->mentry.rdma_entry, mdm->base.size,
+		context, &mentry->rdma_entry, size,
 		MLX5_IB_MMAP_DEVICE_MEM << 16,
 		(MLX5_IB_MMAP_DEVICE_MEM << 16) + (1UL << 16) - 1);
 }
 
+static void mlx5_ib_dm_memic_free(struct kref *kref)
+{
+	struct mlx5_ib_dm_memic *dm =
+		container_of(kref, struct mlx5_ib_dm_memic, ref);
+	struct mlx5_ib_dev *dev = to_mdev(dm->base.ibdm.device);
+
+	mlx5_cmd_dealloc_memic(&dev->dm, dm->base.dev_addr, dm->base.size);
+	kfree(dm);
+}
+
+static int copy_op_to_user(struct mlx5_ib_dm_op_entry *op_entry,
+			   struct uverbs_attr_bundle *attrs)
+{
+	u64 start_offset;
+	u16 page_idx;
+	int err;
+
+	page_idx = op_entry->mentry.rdma_entry.start_pgoff & 0xFFFF;
+	start_offset = op_entry->op_addr & ~PAGE_MASK;
+	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_RESP_PAGE_INDEX,
+			     &page_idx, sizeof(page_idx));
+	if (err)
+		return err;
+
+	return uverbs_copy_to(attrs,
+			      MLX5_IB_ATTR_DM_MAP_OP_ADDR_RESP_START_OFFSET,
+			      &start_offset, sizeof(start_offset));
+}
+
+static int map_existing_op(struct mlx5_ib_dm_memic *dm, u8 op,
+			   struct uverbs_attr_bundle *attrs)
+{
+	struct mlx5_ib_dm_op_entry *op_entry;
+
+	op_entry = xa_load(&dm->ops, op);
+	if (!op_entry)
+		return -ENOENT;
+
+	return copy_op_to_user(op_entry, attrs);
+}
+
+static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_MAP_OP_ADDR)(
+	struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *uobj = uverbs_attr_get_uobject(
+		attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_HANDLE);
+	struct mlx5_ib_dev *dev = to_mdev(uobj->context->device);
+	struct ib_dm *ibdm = uobj->object;
+	struct mlx5_ib_dm_memic *dm = to_memic(ibdm);
+	struct mlx5_ib_dm_op_entry *op_entry;
+	int err;
+	u8 op;
+
+	err = uverbs_copy_from(&op, attrs, MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_OP);
+	if (err)
+		return err;
+
+	if (!(MLX5_CAP_DEV_MEM(dev->mdev, memic_operations) & BIT(op)))
+		return -EOPNOTSUPP;
+
+	mutex_lock(&dm->ops_xa_lock);
+	err = map_existing_op(dm, op, attrs);
+	if (!err || err != -ENOENT)
+		goto err_unlock;
+
+	op_entry = kzalloc(sizeof(*op_entry), GFP_KERNEL);
+	if (!op_entry)
+		goto err_unlock;
+
+	err = mlx5_cmd_alloc_memic_op(&dev->dm, dm->base.dev_addr, op,
+				      &op_entry->op_addr);
+	if (err) {
+		kfree(op_entry);
+		goto err_unlock;
+	}
+	op_entry->op = op;
+	op_entry->dm = dm;
+
+	err = add_dm_mmap_entry(uobj->context, &op_entry->mentry,
+				MLX5_IB_MMAP_TYPE_MEMIC_OP, dm->base.size,
+				op_entry->op_addr & PAGE_MASK);
+	if (err) {
+		mlx5_cmd_dealloc_memic_op(&dev->dm, dm->base.dev_addr, op);
+		kfree(op_entry);
+		goto err_unlock;
+	}
+	/* From this point, entry will be freed by mmap_free */
+	kref_get(&dm->ref);
+
+	err = copy_op_to_user(op_entry, attrs);
+	if (err)
+		goto err_remove;
+
+	err = xa_insert(&dm->ops, op, op_entry, GFP_KERNEL);
+	if (err)
+		goto err_remove;
+	mutex_unlock(&dm->ops_xa_lock);
+
+	return 0;
+
+err_remove:
+	rdma_user_mmap_entry_remove(&op_entry->mentry.rdma_entry);
+err_unlock:
+	mutex_unlock(&dm->ops_xa_lock);
+
+	return err;
+}
+
 static struct ib_dm *handle_alloc_dm_memic(struct ib_ucontext *ctx,
 					   struct ib_dm_alloc_attr *attr,
 					   struct uverbs_attr_bundle *attrs)
@@ -178,6 +288,11 @@ static struct ib_dm *handle_alloc_dm_memic(struct ib_ucontext *ctx,
 
 	dm->base.type = MLX5_IB_UAPI_DM_TYPE_MEMIC;
 	dm->base.size = roundup(attr->length, MLX5_MEMIC_BASE_SIZE);
+	dm->base.ibdm.device = ctx->device;
+
+	kref_init(&dm->ref);
+	xa_init(&dm->ops);
+	mutex_init(&dm->ops_xa_lock);
 
 	err = mlx5_cmd_alloc_memic(dm_db, &dm->base.dev_addr,
 				   dm->base.size, attr->alignment);
@@ -187,7 +302,8 @@ static struct ib_dm *handle_alloc_dm_memic(struct ib_ucontext *ctx,
 	}
 
 	address = dm->base.dev_addr & PAGE_MASK;
-	err = add_dm_mmap_entry(ctx, dm, address);
+	err = add_dm_mmap_entry(ctx, &dm->mentry, MLX5_IB_MMAP_TYPE_MEMIC,
+				dm->base.size, address);
 	if (err) {
 		mlx5_cmd_dealloc_memic(dm_db, dm->base.dev_addr, dm->base.size);
 		kfree(dm);
@@ -195,10 +311,8 @@ static struct ib_dm *handle_alloc_dm_memic(struct ib_ucontext *ctx,
 	}
 
 	page_idx = dm->mentry.rdma_entry.start_pgoff & 0xFFFF;
-	err = uverbs_copy_to(attrs,
-			     MLX5_IB_ATTR_ALLOC_DM_RESP_PAGE_INDEX,
-			     &page_idx,
-			     sizeof(page_idx));
+	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_ALLOC_DM_RESP_PAGE_INDEX,
+			     &page_idx, sizeof(page_idx));
 	if (err)
 		goto err_copy;
 
@@ -231,6 +345,7 @@ static struct ib_dm *handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
 		return ERR_PTR(-ENOMEM);
 
 	dm->base.type = type;
+	dm->base.ibdm.device = ctx->device;
 
 	if (!capable(CAP_SYS_RAWIO) || !capable(CAP_NET_RAW)) {
 		err = -EPERM;
@@ -303,8 +418,22 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
 	}
 }
 
+static void dm_memic_remove_ops(struct mlx5_ib_dm_memic *dm)
+{
+	struct mlx5_ib_dm_op_entry *entry;
+	unsigned long idx;
+
+	mutex_lock(&dm->ops_xa_lock);
+	xa_for_each(&dm->ops, idx, entry) {
+		xa_erase(&dm->ops, idx);
+		rdma_user_mmap_entry_remove(&entry->mentry.rdma_entry);
+	}
+	mutex_unlock(&dm->ops_xa_lock);
+}
+
 static void mlx5_dm_memic_dealloc(struct mlx5_ib_dm_memic *dm)
 {
+	dm_memic_remove_ops(dm);
 	rdma_user_mmap_entry_remove(&dm->mentry.rdma_entry);
 }
 
@@ -344,6 +473,31 @@ static int mlx5_ib_dealloc_dm(struct ib_dm *ibdm,
 	}
 }
 
+void mlx5_ib_dm_mmap_free(struct mlx5_ib_dev *dev,
+			  struct mlx5_user_mmap_entry *mentry)
+{
+	struct mlx5_ib_dm_op_entry *op_entry;
+	struct mlx5_ib_dm_memic *mdm;
+
+	switch (mentry->mmap_flag) {
+	case MLX5_IB_MMAP_TYPE_MEMIC:
+		mdm = container_of(mentry, struct mlx5_ib_dm_memic, mentry);
+		kref_put(&mdm->ref, mlx5_ib_dm_memic_free);
+		break;
+	case MLX5_IB_MMAP_TYPE_MEMIC_OP:
+		op_entry = container_of(mentry, struct mlx5_ib_dm_op_entry,
+					mentry);
+		mdm = op_entry->dm;
+		mlx5_cmd_dealloc_memic_op(&dev->dm, mdm->base.dev_addr,
+					  op_entry->op);
+		kfree(op_entry);
+		kref_put(&mdm->ref, mlx5_ib_dm_memic_free);
+		break;
+	default:
+		WARN_ON(true);
+	}
+}
+
 ADD_UVERBS_ATTRIBUTES_SIMPLE(
 	mlx5_ib_dm, UVERBS_OBJECT_DM, UVERBS_METHOD_DM_ALLOC,
 	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_ALLOC_DM_RESP_START_OFFSET,
@@ -353,8 +507,28 @@ ADD_UVERBS_ATTRIBUTES_SIMPLE(
 	UVERBS_ATTR_CONST_IN(MLX5_IB_ATTR_ALLOC_DM_REQ_TYPE,
 			     enum mlx5_ib_uapi_dm_type, UA_OPTIONAL));
 
+DECLARE_UVERBS_NAMED_METHOD(
+	MLX5_IB_METHOD_DM_MAP_OP_ADDR,
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_HANDLE,
+			UVERBS_OBJECT_DM,
+			UVERBS_ACCESS_READ,
+			UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_OP,
+			   UVERBS_ATTR_TYPE(u8),
+			   UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_DM_MAP_OP_ADDR_RESP_START_OFFSET,
+			    UVERBS_ATTR_TYPE(u64),
+			    UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_DM_MAP_OP_ADDR_RESP_PAGE_INDEX,
+			    UVERBS_ATTR_TYPE(u16),
+			    UA_OPTIONAL));
+
+DECLARE_UVERBS_GLOBAL_METHODS(UVERBS_OBJECT_DM,
+			      &UVERBS_METHOD(MLX5_IB_METHOD_DM_MAP_OP_ADDR));
+
 const struct uapi_definition mlx5_ib_dm_defs[] = {
 	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_DM, &mlx5_ib_dm),
+	UAPI_DEF_CHAIN_OBJ_TREE_NAMED(UVERBS_OBJECT_DM),
 	{},
 };
 
diff --git a/drivers/infiniband/hw/mlx5/dm.h b/drivers/infiniband/hw/mlx5/dm.h
index 6857bbdb201c..4d0ffad29d8f 100644
--- a/drivers/infiniband/hw/mlx5/dm.h
+++ b/drivers/infiniband/hw/mlx5/dm.h
@@ -18,9 +18,19 @@ struct mlx5_ib_dm {
 	size_t			size;
 };
 
+struct mlx5_ib_dm_op_entry {
+	struct mlx5_user_mmap_entry	mentry;
+	phys_addr_t			op_addr;
+	struct mlx5_ib_dm_memic		*dm;
+	u8				op;
+};
+
 struct mlx5_ib_dm_memic {
 	struct mlx5_ib_dm           base;
 	struct mlx5_user_mmap_entry mentry;
+	struct xarray               ops;
+	struct mutex                ops_xa_lock;
+	struct kref                 ref;
 };
 
 struct mlx5_ib_dm_icm {
@@ -47,6 +57,8 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
 			       struct ib_ucontext *context,
 			       struct ib_dm_alloc_attr *attr,
 			       struct uverbs_attr_bundle *attrs);
+void mlx5_ib_dm_mmap_free(struct mlx5_ib_dev *dev,
+			  struct mlx5_user_mmap_entry *mentry);
 void mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, phys_addr_t addr,
 			    u64 length);
 void mlx5_cmd_dealloc_memic_op(struct mlx5_dm *dm, phys_addr_t addr,
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index dea3daa4d8d6..5f1c76b8dcb1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2090,14 +2090,11 @@ static void mlx5_ib_mmap_free(struct rdma_user_mmap_entry *entry)
 	struct mlx5_user_mmap_entry *mentry = to_mmmap(entry);
 	struct mlx5_ib_dev *dev = to_mdev(entry->ucontext->device);
 	struct mlx5_var_table *var_table = &dev->var_table;
-	struct mlx5_ib_dm_memic *mdm;
 
 	switch (mentry->mmap_flag) {
 	case MLX5_IB_MMAP_TYPE_MEMIC:
-		mdm = container_of(mentry, struct mlx5_ib_dm_memic, mentry);
-		mlx5_cmd_dealloc_memic(&dev->dm, mdm->base.dev_addr,
-				       mdm->base.size);
-		kfree(mdm);
+	case MLX5_IB_MMAP_TYPE_MEMIC_OP:
+		mlx5_ib_dm_mmap_free(dev, mentry);
 		break;
 	case MLX5_IB_MMAP_TYPE_VAR:
 		mutex_lock(&var_table->bitmap_lock);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 1c6dbaec22c7..e9a3f34a30b8 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -166,6 +166,7 @@ enum mlx5_ib_mmap_type {
 	MLX5_IB_MMAP_TYPE_VAR = 2,
 	MLX5_IB_MMAP_TYPE_UAR_WC = 3,
 	MLX5_IB_MMAP_TYPE_UAR_NC = 4,
+	MLX5_IB_MMAP_TYPE_MEMIC_OP = 5,
 };
 
 struct mlx5_bfreg_info {
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index 3f0bc7597ba7..c6fbc5211717 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -41,6 +41,17 @@ enum mlx5_ib_create_flow_action_attrs {
 	MLX5_IB_ATTR_CREATE_FLOW_ACTION_FLAGS = (1U << UVERBS_ID_NS_SHIFT),
 };
 
+enum mlx5_ib_dm_methods {
+	MLX5_IB_METHOD_DM_MAP_OP_ADDR  = (1U << UVERBS_ID_NS_SHIFT),
+};
+
+enum mlx5_ib_dm_map_op_addr_attrs {
+	MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_ATTR_DM_MAP_OP_ADDR_REQ_OP,
+	MLX5_IB_ATTR_DM_MAP_OP_ADDR_RESP_START_OFFSET,
+	MLX5_IB_ATTR_DM_MAP_OP_ADDR_RESP_PAGE_INDEX,
+};
+
 enum mlx5_ib_alloc_dm_attrs {
 	MLX5_IB_ATTR_ALLOC_DM_RESP_START_OFFSET = (1U << UVERBS_ID_NS_SHIFT),
 	MLX5_IB_ATTR_ALLOC_DM_RESP_PAGE_INDEX,
-- 
2.30.2

