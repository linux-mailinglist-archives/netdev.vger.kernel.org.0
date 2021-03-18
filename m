Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7145A34046E
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 12:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhCRLQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 07:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230378AbhCRLQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 07:16:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17E5964F04;
        Thu, 18 Mar 2021 11:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616066172;
        bh=W3ZFc64nHv6+IIOkpDILi0Wxhe/19bf5Dkgmbjperlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=muA2DD4KFlGYrP/4D7z02Kfb0Sl22HAZ4SFCx9+jybNPt+AfhQmLb2SKMH0OResld
         z5YuQIH/4bm+4MY6gl/nKaZXqZMxmL5bGmmp0761yzOOt3YjJsQO/9QMMqkgjU0Taj
         BfQr60HklyyBQogkbnzH5A0jjaPgFEBUsxw/6SKiV3NyYboe2PzF8qed+eq5tq1Dp5
         zQo01F1WCgIWr6HE7fdVlq4CyXpLQj1t5mmXQOx844lJEVBBMc8xXCvYJyq+UPgTxK
         GZLkgm8FDGEaqULOVq9yaFnLeZACnyVnGKDLFIet+jauUkU44Nh0j2FBlOEq1yUFTy
         2e4xX4aisU7HA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next 6/7] RDMA/mlx5: Add support in MEMIC operations
Date:   Thu, 18 Mar 2021 13:15:47 +0200
Message-Id: <20210318111548.674749-7-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318111548.674749-1-leon@kernel.org>
References: <20210318111548.674749-1-leon@kernel.org>
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
 drivers/infiniband/hw/mlx5/dm.c          | 196 +++++++++++++++++++++--
 drivers/infiniband/hw/mlx5/dm.h          |   2 +
 drivers/infiniband/hw/mlx5/main.c        |   7 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  16 +-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  11 ++
 5 files changed, 214 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index 97a925d43312..ee4ee197a626 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -150,12 +150,14 @@ static int mlx5_cmd_alloc_memic_op(struct mlx5_dm *dm, phys_addr_t addr,
 }

 static int add_dm_mmap_entry(struct ib_ucontext *context,
-			     struct mlx5_ib_dm *mdm, u64 address)
+			     struct mlx5_user_mmap_entry *mentry, u8 mmap_flag,
+			     size_t size, u64 address)
 {
-	mdm->mentry.mmap_flag = MLX5_IB_MMAP_TYPE_MEMIC;
-	mdm->mentry.address = address;
+	mentry->mmap_flag = mmap_flag;
+	mentry->address = address;
+
 	return rdma_user_mmap_entry_insert_range(
-		context, &mdm->mentry.rdma_entry, mdm->size,
+		context, &mentry->rdma_entry, size,
 		MLX5_IB_MMAP_DEVICE_MEM << 16,
 		(MLX5_IB_MMAP_DEVICE_MEM << 16) + (1UL << 16) - 1);
 }
@@ -183,6 +185,114 @@ static inline int check_dm_type_support(struct mlx5_ib_dev *dev, u32 type)
 	return 0;
 }

+void mlx5_ib_dm_memic_free(struct kref *kref)
+{
+	struct mlx5_ib_dm *dm =
+		container_of(kref, struct mlx5_ib_dm, memic.ref);
+	struct mlx5_ib_dev *dev = to_mdev(dm->ibdm.device);
+
+	mlx5_cmd_dealloc_memic(&dev->dm, dm->dev_addr, dm->size);
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
+static int map_existing_op(struct mlx5_ib_dm *dm, u8 op,
+			   struct uverbs_attr_bundle *attrs)
+{
+	struct mlx5_ib_dm_op_entry *op_entry;
+
+	op_entry = xa_load(&dm->memic.ops, op);
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
+	struct mlx5_ib_dm *dm = to_mdm(ibdm);
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
+	mutex_lock(&dm->memic.ops_xa_lock);
+	err = map_existing_op(dm, op, attrs);
+	if (!err || err != -ENOENT)
+		goto err_unlock;
+
+	op_entry = kzalloc(sizeof(*op_entry), GFP_KERNEL);
+	if (!op_entry)
+		goto err_unlock;
+
+	err = mlx5_cmd_alloc_memic_op(&dev->dm, dm->dev_addr, op,
+				      &op_entry->op_addr);
+	if (err) {
+		kfree(op_entry);
+		goto err_unlock;
+	}
+	op_entry->op = op;
+	op_entry->dm = dm;
+
+	err = add_dm_mmap_entry(uobj->context, &op_entry->mentry,
+				MLX5_IB_MMAP_TYPE_MEMIC_OP, dm->size,
+				op_entry->op_addr & PAGE_MASK);
+	if (err) {
+		mlx5_cmd_dealloc_memic_op(&dev->dm, dm->dev_addr, op);
+		kfree(op_entry);
+		goto err_unlock;
+	}
+	/* From this point, entry will be freed by mmap_free */
+	kref_get(&dm->memic.ref);
+
+	err = copy_op_to_user(op_entry, attrs);
+	if (err)
+		goto err_remove;
+
+	err = xa_insert(&dm->memic.ops, op, op_entry, GFP_KERNEL);
+	if (err)
+		goto err_remove;
+	mutex_unlock(&dm->memic.ops_xa_lock);
+
+	return 0;
+
+err_remove:
+	rdma_user_mmap_entry_remove(&op_entry->mentry.rdma_entry);
+err_unlock:
+	mutex_unlock(&dm->memic.ops_xa_lock);
+
+	return err;
+}
+
 static int handle_alloc_dm_memic(struct ib_ucontext *ctx, struct mlx5_ib_dm *dm,
 				 struct ib_dm_alloc_attr *attr,
 				 struct uverbs_attr_bundle *attrs)
@@ -193,6 +303,9 @@ static int handle_alloc_dm_memic(struct ib_ucontext *ctx, struct mlx5_ib_dm *dm,
 	int err;
 	u64 address;

+	kref_init(&dm->memic.ref);
+	xa_init(&dm->memic.ops);
+	mutex_init(&dm->memic.ops_xa_lock);
 	dm->size = roundup(attr->length, MLX5_MEMIC_BASE_SIZE);

 	err = mlx5_cmd_alloc_memic(dm_db, &dm->dev_addr,
@@ -203,18 +316,17 @@ static int handle_alloc_dm_memic(struct ib_ucontext *ctx, struct mlx5_ib_dm *dm,
 	}

 	address = dm->dev_addr & PAGE_MASK;
-	err = add_dm_mmap_entry(ctx, dm, address);
+	err = add_dm_mmap_entry(ctx, &dm->memic.mentry, MLX5_IB_MMAP_TYPE_MEMIC,
+				dm->size, address);
 	if (err) {
 		mlx5_cmd_dealloc_memic(dm_db, dm->dev_addr, dm->size);
 		kfree(dm);
 		return err;
 	}

-	page_idx = dm->mentry.rdma_entry.start_pgoff & 0xFFFF;
-	err = uverbs_copy_to(attrs,
-			     MLX5_IB_ATTR_ALLOC_DM_RESP_PAGE_INDEX,
-			     &page_idx,
-			     sizeof(page_idx));
+	page_idx = dm->memic.mentry.rdma_entry.start_pgoff & 0xFFFF;
+	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_ALLOC_DM_RESP_PAGE_INDEX,
+			     &page_idx, sizeof(page_idx));
 	if (err)
 		goto err_copy;

@@ -228,7 +340,7 @@ static int handle_alloc_dm_memic(struct ib_ucontext *ctx, struct mlx5_ib_dm *dm,
 	return 0;

 err_copy:
-	rdma_user_mmap_entry_remove(&dm->mentry.rdma_entry);
+	rdma_user_mmap_entry_remove(&dm->memic.mentry.rdma_entry);

 	return err;
 }
@@ -292,6 +404,7 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
 		return ERR_PTR(-ENOMEM);

 	dm->type = type;
+	dm->ibdm.device = ibdev;

 	switch (type) {
 	case MLX5_IB_UAPI_DM_TYPE_MEMIC:
@@ -323,6 +436,19 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
 	return ERR_PTR(err);
 }

+static void dm_memic_remove_ops(struct mlx5_ib_dm *dm)
+{
+	struct mlx5_ib_dm_op_entry *entry;
+	unsigned long idx;
+
+	mutex_lock(&dm->memic.ops_xa_lock);
+	xa_for_each(&dm->memic.ops, idx, entry) {
+		xa_erase(&dm->memic.ops, idx);
+		rdma_user_mmap_entry_remove(&entry->mentry.rdma_entry);
+	}
+	mutex_unlock(&dm->memic.ops_xa_lock);
+}
+
 int mlx5_ib_dealloc_dm(struct ib_dm *ibdm, struct uverbs_attr_bundle *attrs)
 {
 	struct mlx5_ib_ucontext *ctx = rdma_udata_to_drv_context(
@@ -333,7 +459,8 @@ int mlx5_ib_dealloc_dm(struct ib_dm *ibdm, struct uverbs_attr_bundle *attrs)

 	switch (dm->type) {
 	case MLX5_IB_UAPI_DM_TYPE_MEMIC:
-		rdma_user_mmap_entry_remove(&dm->mentry.rdma_entry);
+		dm_memic_remove_ops(dm);
+		rdma_user_mmap_entry_remove(&dm->memic.mentry.rdma_entry);
 		return 0;
 	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
 		ret = mlx5_dm_sw_icm_dealloc(dev, MLX5_SW_ICM_TYPE_STEERING,
@@ -359,6 +486,31 @@ int mlx5_ib_dealloc_dm(struct ib_dm *ibdm, struct uverbs_attr_bundle *attrs)
 	return 0;
 }

+void mlx5_ib_dm_mmap_free(struct mlx5_ib_dev *dev,
+			  struct mlx5_user_mmap_entry *mentry)
+{
+	struct mlx5_ib_dm_op_entry *op_entry;
+	struct mlx5_ib_dm *mdm;
+
+	switch (mentry->mmap_flag) {
+	case MLX5_IB_MMAP_TYPE_MEMIC:
+		mdm = container_of(mentry, struct mlx5_ib_dm, memic.mentry);
+		kref_put(&mdm->memic.ref, mlx5_ib_dm_memic_free);
+		break;
+	case MLX5_IB_MMAP_TYPE_MEMIC_OP:
+		op_entry = container_of(mentry, struct mlx5_ib_dm_op_entry,
+					mentry);
+		mdm = op_entry->dm;
+		mlx5_cmd_dealloc_memic_op(&dev->dm, mdm->dev_addr,
+					  op_entry->op);
+		kfree(op_entry);
+		kref_put(&mdm->memic.ref, mlx5_ib_dm_memic_free);
+		break;
+	default:
+		WARN_ON(true);
+	}
+}
+
 ADD_UVERBS_ATTRIBUTES_SIMPLE(
 	mlx5_ib_dm, UVERBS_OBJECT_DM, UVERBS_METHOD_DM_ALLOC,
 	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_ALLOC_DM_RESP_START_OFFSET,
@@ -368,8 +520,28 @@ ADD_UVERBS_ATTRIBUTES_SIMPLE(
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
index adb39d3d8131..56cf1ba9c985 100644
--- a/drivers/infiniband/hw/mlx5/dm.h
+++ b/drivers/infiniband/hw/mlx5/dm.h
@@ -8,6 +8,8 @@

 #include "mlx5_ib.h"

+void mlx5_ib_dm_mmap_free(struct mlx5_ib_dev *dev,
+			  struct mlx5_user_mmap_entry *mentry);
 void mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, phys_addr_t addr,
 			    u64 length);
 void mlx5_cmd_dealloc_memic_op(struct mlx5_dm *dm, phys_addr_t addr,
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 49c8c60d9520..6908db28b796 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2090,14 +2090,11 @@ static void mlx5_ib_mmap_free(struct rdma_user_mmap_entry *entry)
 	struct mlx5_user_mmap_entry *mentry = to_mmmap(entry);
 	struct mlx5_ib_dev *dev = to_mdev(entry->ucontext->device);
 	struct mlx5_var_table *var_table = &dev->var_table;
-	struct mlx5_ib_dm *mdm;

 	switch (mentry->mmap_flag) {
 	case MLX5_IB_MMAP_TYPE_MEMIC:
-		mdm = container_of(mentry, struct mlx5_ib_dm, mentry);
-		mlx5_cmd_dealloc_memic(&dev->dm, mdm->dev_addr,
-				       mdm->size);
-		kfree(mdm);
+	case MLX5_IB_MMAP_TYPE_MEMIC_OP:
+		mlx5_ib_dm_mmap_free(dev, mentry);
 		break;
 	case MLX5_IB_MMAP_TYPE_VAR:
 		mutex_lock(&var_table->bitmap_lock);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index ae971de6e934..b714131f87b7 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -166,6 +166,7 @@ enum mlx5_ib_mmap_type {
 	MLX5_IB_MMAP_TYPE_VAR = 2,
 	MLX5_IB_MMAP_TYPE_UAR_WC = 3,
 	MLX5_IB_MMAP_TYPE_UAR_NC = 4,
+	MLX5_IB_MMAP_TYPE_MEMIC_OP = 5,
 };

 struct mlx5_bfreg_info {
@@ -618,18 +619,30 @@ struct mlx5_user_mmap_entry {
 	u32 page_idx;
 };

+struct mlx5_ib_dm_op_entry {
+	struct mlx5_user_mmap_entry	mentry;
+	phys_addr_t			op_addr;
+	struct mlx5_ib_dm		*dm;
+	u8				op;
+};
+
 struct mlx5_ib_dm {
 	struct ib_dm		ibdm;
 	phys_addr_t		dev_addr;
 	u32			type;
 	size_t			size;
 	union {
+		struct {
+				struct mlx5_user_mmap_entry mentry;
+				struct xarray		ops;
+				struct mutex		ops_xa_lock;
+				struct kref		ref;
+		} memic;
 		struct {
 			u32	obj_id;
 		} icm_dm;
 		/* other dm types specific params should be added here */
 	};
-	struct mlx5_user_mmap_entry mentry;
 };

 #define MLX5_IB_MTT_PRESENT (MLX5_IB_MTT_READ | MLX5_IB_MTT_WRITE)
@@ -1352,6 +1365,7 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
 			       struct ib_dm_alloc_attr *attr,
 			       struct uverbs_attr_bundle *attrs);
 int mlx5_ib_dealloc_dm(struct ib_dm *ibdm, struct uverbs_attr_bundle *attrs);
+void mlx5_ib_dm_memic_free(struct kref *kref);
 struct ib_mr *mlx5_ib_reg_dm_mr(struct ib_pd *pd, struct ib_dm *dm,
 				struct ib_dm_mr_attr *attr,
 				struct uverbs_attr_bundle *attrs);
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

