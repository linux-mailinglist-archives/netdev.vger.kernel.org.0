Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAC835B436
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 14:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbhDKMaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 08:30:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:51584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235531AbhDKMaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 08:30:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF0E560FF1;
        Sun, 11 Apr 2021 12:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618144190;
        bh=z9CBGyAh7zyEaDjGnleco1PXy+Wz1Vf3AA0ontwVqDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kquAPUa2vilFuhhyZvVEK2NAYD5KUOLaFkJFqPvIoG26sEX1b8wOarXXWAMxKH+hY
         6Lg9ER/geo22Lf7DjVdoklZYWW3lqlQUrkdiNRw4SPtx435wdBT3bciqjD688CVg4K
         HJsZ98IZAjL22qpggp12CBw2TQ1iH9B4KaUhiSFzq0QeGSsv44UdXuFDAoPgqDQ2eU
         msIjvhrvOYEbqzXWVkOxuZx/xwyJtEBf/TSDi8ktBelD5P0WrgcU5Zg6CnafKb33gK
         WYBPnoURe4kvhYHep9uYqamXl+zFrzwSbsP1ZcfBJCJrVq60v9UWy5mKb/ZHznOo4U
         hGPXeE/9LDSGw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>, linux-api@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next v1 7/7] RDMA/mlx5: Expose UAPI to query DM
Date:   Sun, 11 Apr 2021 15:29:24 +0300
Message-Id: <20210411122924.60230-8-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210411122924.60230-1-leon@kernel.org>
References: <20210411122924.60230-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Expose UAPI to query MEMIC DM, this will let user space application
that didn't allocate the DM but has access to by owning the matching
command FD to retrieve its information.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/dm.c          | 47 +++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/dm.h          |  1 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  8 ++++
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index bec0489428f8..235aad6beacb 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -293,6 +293,7 @@ static struct ib_dm *handle_alloc_dm_memic(struct ib_ucontext *ctx,
 	kref_init(&dm->ref);
 	xa_init(&dm->ops);
 	mutex_init(&dm->ops_xa_lock);
+	dm->req_length = attr->length;
 
 	err = mlx5_cmd_alloc_memic(dm_db, &dm->base.dev_addr,
 				   dm->base.size, attr->alignment);
@@ -473,6 +474,38 @@ static int mlx5_ib_dealloc_dm(struct ib_dm *ibdm,
 	}
 }
 
+static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_QUERY)(
+	struct uverbs_attr_bundle *attrs)
+{
+	struct ib_dm *ibdm =
+		uverbs_attr_get_obj(attrs, MLX5_IB_ATTR_QUERY_DM_REQ_HANDLE);
+	struct mlx5_ib_dm *dm = to_mdm(ibdm);
+	struct mlx5_ib_dm_memic *memic;
+	u64 start_offset;
+	u16 page_idx;
+	int err;
+
+	if (dm->type != MLX5_IB_UAPI_DM_TYPE_MEMIC)
+		return -EOPNOTSUPP;
+
+	memic = to_memic(ibdm);
+	page_idx = memic->mentry.rdma_entry.start_pgoff & 0xFFFF;
+	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_QUERY_DM_RESP_PAGE_INDEX,
+			     &page_idx, sizeof(page_idx));
+	if (err)
+		return err;
+
+	start_offset = memic->base.dev_addr & ~PAGE_MASK;
+	err =  uverbs_copy_to(attrs, MLX5_IB_ATTR_QUERY_DM_RESP_START_OFFSET,
+			      &start_offset, sizeof(start_offset));
+	if (err)
+		return err;
+
+	return uverbs_copy_to(attrs, MLX5_IB_ATTR_QUERY_DM_RESP_LENGTH,
+			      &memic->req_length,
+			      sizeof(memic->req_length));
+}
+
 void mlx5_ib_dm_mmap_free(struct mlx5_ib_dev *dev,
 			  struct mlx5_user_mmap_entry *mentry)
 {
@@ -498,6 +531,17 @@ void mlx5_ib_dm_mmap_free(struct mlx5_ib_dev *dev,
 	}
 }
 
+DECLARE_UVERBS_NAMED_METHOD(
+	MLX5_IB_METHOD_DM_QUERY,
+	UVERBS_ATTR_IDR(MLX5_IB_ATTR_QUERY_DM_REQ_HANDLE, UVERBS_OBJECT_DM,
+			UVERBS_ACCESS_READ, UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_QUERY_DM_RESP_START_OFFSET,
+			    UVERBS_ATTR_TYPE(u64), UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_QUERY_DM_RESP_PAGE_INDEX,
+			    UVERBS_ATTR_TYPE(u16), UA_MANDATORY),
+	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_QUERY_DM_RESP_LENGTH,
+			    UVERBS_ATTR_TYPE(u64), UA_MANDATORY));
+
 ADD_UVERBS_ATTRIBUTES_SIMPLE(
 	mlx5_ib_dm, UVERBS_OBJECT_DM, UVERBS_METHOD_DM_ALLOC,
 	UVERBS_ATTR_PTR_OUT(MLX5_IB_ATTR_ALLOC_DM_RESP_START_OFFSET,
@@ -524,7 +568,8 @@ DECLARE_UVERBS_NAMED_METHOD(
 			    UA_OPTIONAL));
 
 DECLARE_UVERBS_GLOBAL_METHODS(UVERBS_OBJECT_DM,
-			      &UVERBS_METHOD(MLX5_IB_METHOD_DM_MAP_OP_ADDR));
+			      &UVERBS_METHOD(MLX5_IB_METHOD_DM_MAP_OP_ADDR),
+			      &UVERBS_METHOD(MLX5_IB_METHOD_DM_QUERY));
 
 const struct uapi_definition mlx5_ib_dm_defs[] = {
 	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_DM, &mlx5_ib_dm),
diff --git a/drivers/infiniband/hw/mlx5/dm.h b/drivers/infiniband/hw/mlx5/dm.h
index 4d0ffad29d8f..9674a80d8d70 100644
--- a/drivers/infiniband/hw/mlx5/dm.h
+++ b/drivers/infiniband/hw/mlx5/dm.h
@@ -31,6 +31,7 @@ struct mlx5_ib_dm_memic {
 	struct xarray               ops;
 	struct mutex                ops_xa_lock;
 	struct kref                 ref;
+	size_t                      req_length;
 };
 
 struct mlx5_ib_dm_icm {
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index c6fbc5211717..3798cbcb9021 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -43,6 +43,7 @@ enum mlx5_ib_create_flow_action_attrs {
 
 enum mlx5_ib_dm_methods {
 	MLX5_IB_METHOD_DM_MAP_OP_ADDR  = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_METHOD_DM_QUERY,
 };
 
 enum mlx5_ib_dm_map_op_addr_attrs {
@@ -52,6 +53,13 @@ enum mlx5_ib_dm_map_op_addr_attrs {
 	MLX5_IB_ATTR_DM_MAP_OP_ADDR_RESP_PAGE_INDEX,
 };
 
+enum mlx5_ib_query_dm_attrs {
+	MLX5_IB_ATTR_QUERY_DM_REQ_HANDLE = (1U << UVERBS_ID_NS_SHIFT),
+	MLX5_IB_ATTR_QUERY_DM_RESP_START_OFFSET,
+	MLX5_IB_ATTR_QUERY_DM_RESP_PAGE_INDEX,
+	MLX5_IB_ATTR_QUERY_DM_RESP_LENGTH,
+};
+
 enum mlx5_ib_alloc_dm_attrs {
 	MLX5_IB_ATTR_ALLOC_DM_RESP_START_OFFSET = (1U << UVERBS_ID_NS_SHIFT),
 	MLX5_IB_ATTR_ALLOC_DM_RESP_PAGE_INDEX,
-- 
2.30.2

