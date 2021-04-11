Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7AE35B42D
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 14:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbhDKM35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 08:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235482AbhDKM34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 08:29:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C823B610C8;
        Sun, 11 Apr 2021 12:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618144180;
        bh=tzT5vkcO8joaGE21p1DuB13TmPf4Wgo2/ZOy6nnQofw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4LINrIkP3BhE8w+botLGu1HnuG8q+f7h8zZHhgFgasibep0m7KhHGGO0PG5oF9+5
         QmvqFc6CeSWFeV7q2ooYTc6gjRZgJqBszihI7u8DHxNB5NE9F4SGrEuLGH7PvIcoyQ
         QofZ0+E4SziTqZXuzXWsy9mEbKWbwsJHRu2UTHbh39HO+fEuNLiJ86g+V8GCufze25
         PmJLE6wq98YjIKWyfEUhn+qzJqQrn3bAkntIdmsXWJWgtnnruM5LI1L0NERbYqbtDc
         +vFab+kiOZ0AjUPiPV4Ja6SoLlmc+E4ixrzJC5pqdTy1ny6RsApXoanoJxADw2bfoL
         MYeKJpLbgkAFg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>, linux-api@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next v1 4/7] RDMA/mlx5: Re-organize the DM code
Date:   Sun, 11 Apr 2021 15:29:21 +0300
Message-Id: <20210411122924.60230-5-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210411122924.60230-1-leon@kernel.org>
References: <20210411122924.60230-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

1. Inline the checks from check_dm_type_support() into their
   respective allocation functions.
2. Fix use after free when driver fails to copy the MEMIC address to the
   user by moving the allocation code into their respective functions,
   hence we avoid the explicit call to free the DM in the error flow.
3. Split mlx5_ib_dm struct to memic and icm proper typesafety
   throughout.

Fixes: dc2316eba73f ("IB/mlx5: Fix device memory flows")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/dm.c   | 193 ++++++++++++++----------------
 drivers/infiniband/hw/mlx5/dm.h   |  29 +++--
 drivers/infiniband/hw/mlx5/main.c |   8 +-
 3 files changed, 114 insertions(+), 116 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index 21fefcd405ef..29eb5c9df3a4 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -112,64 +112,50 @@ void mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, phys_addr_t addr,
 }
 
 static int add_dm_mmap_entry(struct ib_ucontext *context,
-			     struct mlx5_ib_dm *mdm, u64 address)
+			     struct mlx5_ib_dm_memic *mdm, u64 address)
 {
 	mdm->mentry.mmap_flag = MLX5_IB_MMAP_TYPE_MEMIC;
 	mdm->mentry.address = address;
 	return rdma_user_mmap_entry_insert_range(
-		context, &mdm->mentry.rdma_entry, mdm->size,
+		context, &mdm->mentry.rdma_entry, mdm->base.size,
 		MLX5_IB_MMAP_DEVICE_MEM << 16,
 		(MLX5_IB_MMAP_DEVICE_MEM << 16) + (1UL << 16) - 1);
 }
 
-static inline int check_dm_type_support(struct mlx5_ib_dev *dev, u32 type)
-{
-	switch (type) {
-	case MLX5_IB_UAPI_DM_TYPE_MEMIC:
-		if (!MLX5_CAP_DEV_MEM(dev->mdev, memic))
-			return -EOPNOTSUPP;
-		break;
-	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
-	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
-		if (!capable(CAP_SYS_RAWIO) || !capable(CAP_NET_RAW))
-			return -EPERM;
-
-		if (!(MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner) ||
-		      MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, sw_owner) ||
-		      MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, sw_owner_v2) ||
-		      MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, sw_owner_v2)))
-			return -EOPNOTSUPP;
-		break;
-	}
-
-	return 0;
-}
-
-static int handle_alloc_dm_memic(struct ib_ucontext *ctx, struct mlx5_ib_dm *dm,
-				 struct ib_dm_alloc_attr *attr,
-				 struct uverbs_attr_bundle *attrs)
+static struct ib_dm *handle_alloc_dm_memic(struct ib_ucontext *ctx,
+					   struct ib_dm_alloc_attr *attr,
+					   struct uverbs_attr_bundle *attrs)
 {
 	struct mlx5_dm *dm_db = &to_mdev(ctx->device)->dm;
+	struct mlx5_ib_dm_memic *dm;
 	u64 start_offset;
 	u16 page_idx;
 	int err;
 	u64 address;
 
-	dm->size = roundup(attr->length, MLX5_MEMIC_BASE_SIZE);
+	if (!MLX5_CAP_DEV_MEM(dm_db->dev, memic))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	dm = kzalloc(sizeof(*dm), GFP_KERNEL);
+	if (!dm)
+		return ERR_PTR(-ENOMEM);
+
+	dm->base.type = MLX5_IB_UAPI_DM_TYPE_MEMIC;
+	dm->base.size = roundup(attr->length, MLX5_MEMIC_BASE_SIZE);
 
-	err = mlx5_cmd_alloc_memic(dm_db, &dm->dev_addr,
-				   dm->size, attr->alignment);
+	err = mlx5_cmd_alloc_memic(dm_db, &dm->base.dev_addr,
+				   dm->base.size, attr->alignment);
 	if (err) {
 		kfree(dm);
-		return err;
+		return ERR_PTR(err);
 	}
 
-	address = dm->dev_addr & PAGE_MASK;
+	address = dm->base.dev_addr & PAGE_MASK;
 	err = add_dm_mmap_entry(ctx, dm, address);
 	if (err) {
-		mlx5_cmd_dealloc_memic(dm_db, dm->dev_addr, dm->size);
+		mlx5_cmd_dealloc_memic(dm_db, dm->base.dev_addr, dm->base.size);
 		kfree(dm);
-		return err;
+		return ERR_PTR(err);
 	}
 
 	page_idx = dm->mentry.rdma_entry.start_pgoff & 0xFFFF;
@@ -180,51 +166,74 @@ static int handle_alloc_dm_memic(struct ib_ucontext *ctx, struct mlx5_ib_dm *dm,
 	if (err)
 		goto err_copy;
 
-	start_offset = dm->dev_addr & ~PAGE_MASK;
+	start_offset = dm->base.dev_addr & ~PAGE_MASK;
 	err = uverbs_copy_to(attrs,
 			     MLX5_IB_ATTR_ALLOC_DM_RESP_START_OFFSET,
 			     &start_offset, sizeof(start_offset));
 	if (err)
 		goto err_copy;
 
-	return 0;
+	return &dm->base.ibdm;
 
 err_copy:
 	rdma_user_mmap_entry_remove(&dm->mentry.rdma_entry);
-
-	return err;
+	return ERR_PTR(err);
 }
 
-static int handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
-				  struct mlx5_ib_dm *dm,
-				  struct ib_dm_alloc_attr *attr,
-				  struct uverbs_attr_bundle *attrs, int type)
+static struct ib_dm *handle_alloc_dm_sw_icm(struct ib_ucontext *ctx,
+					    struct ib_dm_alloc_attr *attr,
+					    struct uverbs_attr_bundle *attrs,
+					    int type)
 {
 	struct mlx5_core_dev *dev = to_mdev(ctx->device)->mdev;
+	struct mlx5_ib_dm_icm *dm;
 	u64 act_size;
 	int err;
 
+	dm = kzalloc(sizeof(*dm), GFP_KERNEL);
+	if (!dm)
+		return ERR_PTR(-ENOMEM);
+
+	dm->base.type = type;
+
+	if (!capable(CAP_SYS_RAWIO) || !capable(CAP_NET_RAW)) {
+		err = -EPERM;
+		goto free;
+	}
+
+	if (!(MLX5_CAP_FLOWTABLE_NIC_RX(dev, sw_owner) ||
+	      MLX5_CAP_FLOWTABLE_NIC_TX(dev, sw_owner) ||
+	      MLX5_CAP_FLOWTABLE_NIC_RX(dev, sw_owner_v2) ||
+	      MLX5_CAP_FLOWTABLE_NIC_TX(dev, sw_owner_v2))) {
+		err = -EOPNOTSUPP;
+		goto free;
+	}
+
 	/* Allocation size must a multiple of the basic block size
 	 * and a power of 2.
 	 */
 	act_size = round_up(attr->length, MLX5_SW_ICM_BLOCK_SIZE(dev));
 	act_size = roundup_pow_of_two(act_size);
 
-	dm->size = act_size;
+	dm->base.size = act_size;
 	err = mlx5_dm_sw_icm_alloc(dev, type, act_size, attr->alignment,
-				   to_mucontext(ctx)->devx_uid, &dm->dev_addr,
-				   &dm->icm_dm.obj_id);
+				   to_mucontext(ctx)->devx_uid,
+				   &dm->base.dev_addr, &dm->obj_id);
 	if (err)
-		return err;
+		goto free;
 
 	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_ALLOC_DM_RESP_START_OFFSET,
-			     &dm->dev_addr, sizeof(dm->dev_addr));
-	if (err)
-		mlx5_dm_sw_icm_dealloc(dev, type, dm->size,
+			     &dm->base.dev_addr, sizeof(dm->base.dev_addr));
+	if (err) {
+		mlx5_dm_sw_icm_dealloc(dev, type, dm->base.size,
 				       to_mucontext(ctx)->devx_uid,
-				       dm->dev_addr, dm->icm_dm.obj_id);
-
-	return err;
+				       dm->base.dev_addr, dm->obj_id);
+		goto free;
+	}
+	return &dm->base.ibdm;
+free:
+	kfree(dm);
+	return ERR_PTR(err);
 }
 
 struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
@@ -232,7 +241,6 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
 			       struct ib_dm_alloc_attr *attr,
 			       struct uverbs_attr_bundle *attrs)
 {
-	struct mlx5_ib_dm *dm;
 	enum mlx5_ib_uapi_dm_type type;
 	int err;
 
@@ -245,80 +253,59 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
 	mlx5_ib_dbg(to_mdev(ibdev), "alloc_dm req: dm_type=%d user_length=0x%llx log_alignment=%d\n",
 		    type, attr->length, attr->alignment);
 
-	err = check_dm_type_support(to_mdev(ibdev), type);
-	if (err)
-		return ERR_PTR(err);
-
-	dm = kzalloc(sizeof(*dm), GFP_KERNEL);
-	if (!dm)
-		return ERR_PTR(-ENOMEM);
-
-	dm->type = type;
-
 	switch (type) {
 	case MLX5_IB_UAPI_DM_TYPE_MEMIC:
-		err = handle_alloc_dm_memic(context, dm,
-					    attr,
-					    attrs);
-		break;
+		return handle_alloc_dm_memic(context, attr, attrs);
 	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
-		err = handle_alloc_dm_sw_icm(context, dm,
-					     attr, attrs,
+		return handle_alloc_dm_sw_icm(context, attr, attrs,
 					     MLX5_SW_ICM_TYPE_STEERING);
-		break;
 	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
-		err = handle_alloc_dm_sw_icm(context, dm,
-					     attr, attrs,
-					     MLX5_SW_ICM_TYPE_HEADER_MODIFY);
-		break;
+		return handle_alloc_dm_sw_icm(context, attr, attrs,
+					      MLX5_SW_ICM_TYPE_HEADER_MODIFY);
 	default:
-		err = -EOPNOTSUPP;
+		return ERR_PTR(-EOPNOTSUPP);
 	}
+}
 
-	if (err)
-		goto err_free;
+static void mlx5_dm_memic_dealloc(struct mlx5_ib_dm_memic *dm)
+{
+	rdma_user_mmap_entry_remove(&dm->mentry.rdma_entry);
+}
 
-	return &dm->ibdm;
+static int mlx5_dm_icm_dealloc(struct mlx5_ib_ucontext *ctx,
+			       struct mlx5_ib_dm_icm *dm)
+{
+	enum mlx5_sw_icm_type type =
+		dm->base.type == MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM ?
+			MLX5_SW_ICM_TYPE_STEERING :
+			MLX5_SW_ICM_TYPE_HEADER_MODIFY;
+	struct mlx5_core_dev *dev = to_mdev(dm->base.ibdm.device)->mdev;
+	int err;
 
-err_free:
-	kfree(dm);
-	return ERR_PTR(err);
+	err = mlx5_dm_sw_icm_dealloc(dev, type, dm->base.size, ctx->devx_uid,
+				     dm->base.dev_addr, dm->obj_id);
+	if (!err)
+		kfree(dm);
+	return 0;
 }
 
-int mlx5_ib_dealloc_dm(struct ib_dm *ibdm, struct uverbs_attr_bundle *attrs)
+static int mlx5_ib_dealloc_dm(struct ib_dm *ibdm,
+			      struct uverbs_attr_bundle *attrs)
 {
 	struct mlx5_ib_ucontext *ctx = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
-	struct mlx5_core_dev *dev = to_mdev(ibdm->device)->mdev;
 	struct mlx5_ib_dm *dm = to_mdm(ibdm);
-	int ret;
 
 	switch (dm->type) {
 	case MLX5_IB_UAPI_DM_TYPE_MEMIC:
-		rdma_user_mmap_entry_remove(&dm->mentry.rdma_entry);
+		mlx5_dm_memic_dealloc(to_memic(ibdm));
 		return 0;
 	case MLX5_IB_UAPI_DM_TYPE_STEERING_SW_ICM:
-		ret = mlx5_dm_sw_icm_dealloc(dev, MLX5_SW_ICM_TYPE_STEERING,
-					     dm->size, ctx->devx_uid,
-					     dm->dev_addr, dm->icm_dm.obj_id);
-		if (ret)
-			return ret;
-		break;
 	case MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM:
-		ret = mlx5_dm_sw_icm_dealloc(dev,
-					     MLX5_SW_ICM_TYPE_HEADER_MODIFY,
-					     dm->size, ctx->devx_uid,
-					     dm->dev_addr, dm->icm_dm.obj_id);
-		if (ret)
-			return ret;
-		break;
+		return mlx5_dm_icm_dealloc(ctx, to_icm(ibdm));
 	default:
 		return -EOPNOTSUPP;
 	}
-
-	kfree(dm);
-
-	return 0;
 }
 
 ADD_UVERBS_ATTRIBUTES_SIMPLE(
diff --git a/drivers/infiniband/hw/mlx5/dm.h b/drivers/infiniband/hw/mlx5/dm.h
index f8ff5d7fd7c5..39e66b51264d 100644
--- a/drivers/infiniband/hw/mlx5/dm.h
+++ b/drivers/infiniband/hw/mlx5/dm.h
@@ -8,34 +8,45 @@
 
 #include "mlx5_ib.h"
 
-
 extern const struct ib_device_ops mlx5_ib_dev_dm_ops;
 extern const struct uapi_definition mlx5_ib_dm_defs[];
 
 struct mlx5_ib_dm {
 	struct ib_dm		ibdm;
-	phys_addr_t		dev_addr;
 	u32			type;
+	phys_addr_t		dev_addr;
 	size_t			size;
-	union {
-		struct {
-			u32	obj_id;
-		} icm_dm;
-		/* other dm types specific params should be added here */
-	};
+};
+
+struct mlx5_ib_dm_memic {
+	struct mlx5_ib_dm           base;
 	struct mlx5_user_mmap_entry mentry;
 };
 
+struct mlx5_ib_dm_icm {
+	struct mlx5_ib_dm      base;
+	u32                    obj_id;
+};
+
 static inline struct mlx5_ib_dm *to_mdm(struct ib_dm *ibdm)
 {
 	return container_of(ibdm, struct mlx5_ib_dm, ibdm);
 }
 
+static inline struct mlx5_ib_dm_memic *to_memic(struct ib_dm *ibdm)
+{
+	return container_of(ibdm, struct mlx5_ib_dm_memic, base.ibdm);
+}
+
+static inline struct mlx5_ib_dm_icm *to_icm(struct ib_dm *ibdm)
+{
+	return container_of(ibdm, struct mlx5_ib_dm_icm, base.ibdm);
+}
+
 struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
 			       struct ib_ucontext *context,
 			       struct ib_dm_alloc_attr *attr,
 			       struct uverbs_attr_bundle *attrs);
-int mlx5_ib_dealloc_dm(struct ib_dm *ibdm, struct uverbs_attr_bundle *attrs);
 void mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, phys_addr_t addr,
 			    u64 length);
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b069e2610bd0..dea3daa4d8d6 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2090,13 +2090,13 @@ static void mlx5_ib_mmap_free(struct rdma_user_mmap_entry *entry)
 	struct mlx5_user_mmap_entry *mentry = to_mmmap(entry);
 	struct mlx5_ib_dev *dev = to_mdev(entry->ucontext->device);
 	struct mlx5_var_table *var_table = &dev->var_table;
-	struct mlx5_ib_dm *mdm;
+	struct mlx5_ib_dm_memic *mdm;
 
 	switch (mentry->mmap_flag) {
 	case MLX5_IB_MMAP_TYPE_MEMIC:
-		mdm = container_of(mentry, struct mlx5_ib_dm, mentry);
-		mlx5_cmd_dealloc_memic(&dev->dm, mdm->dev_addr,
-				       mdm->size);
+		mdm = container_of(mentry, struct mlx5_ib_dm_memic, mentry);
+		mlx5_cmd_dealloc_memic(&dev->dm, mdm->base.dev_addr,
+				       mdm->base.size);
 		kfree(mdm);
 		break;
 	case MLX5_IB_MMAP_TYPE_VAR:
-- 
2.30.2

