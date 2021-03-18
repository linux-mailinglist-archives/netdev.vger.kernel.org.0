Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A144340473
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 12:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhCRLQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 07:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230423AbhCRLQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 07:16:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0525464F2A;
        Thu, 18 Mar 2021 11:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616066180;
        bh=y5bVr3CLwxOKnnAgyk3ugA2uZLuzjazq0sr2+KOJOCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1VjPb4pXitAiJJocyV++w4wgg/KTkpf8u5NizGPnNfp2Jw7uq9mIr5UM+wLQljue
         uGz395ibr34HkL84XcT7pa+3lykNZrq/dtasblhTf625vUq3oGJOqp4lEID32U5vwQ
         ZdZ1i2VJkWX/ZGt4j6KNTDM5M6CHFMAtwLOj07BVkYiyi+zb8mFBVRWhpSKvqlfXdk
         IGNYznXw5qBeHGR7ArChWGqHWfIGY33PUBpjnb18qcv6nu0wtp8xJ00KCqoSdeW7fg
         nwwKqNwXo/DojNDK1EdSDfcMB4jlZ9SstpkMgNNu61CdWL+Op5xgcepJjTI/L6X/rS
         PlqPlhegsNOIg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next 7/7] RDMA/mlx5: Expose UAPI to query DM
Date:   Thu, 18 Mar 2021 13:15:48 +0200
Message-Id: <20210318111548.674749-8-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318111548.674749-1-leon@kernel.org>
References: <20210318111548.674749-1-leon@kernel.org>
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
 drivers/infiniband/hw/mlx5/dm.c          | 45 +++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h     |  1 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  8 +++++
 3 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index ee4ee197a626..41c158216f17 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -307,6 +307,7 @@ static int handle_alloc_dm_memic(struct ib_ucontext *ctx, struct mlx5_ib_dm *dm,
 	xa_init(&dm->memic.ops);
 	mutex_init(&dm->memic.ops_xa_lock);
 	dm->size = roundup(attr->length, MLX5_MEMIC_BASE_SIZE);
+	dm->memic.req_length = attr->length;

 	err = mlx5_cmd_alloc_memic(dm_db, &dm->dev_addr,
 				   dm->size, attr->alignment);
@@ -486,6 +487,36 @@ int mlx5_ib_dealloc_dm(struct ib_dm *ibdm, struct uverbs_attr_bundle *attrs)
 	return 0;
 }

+static int UVERBS_HANDLER(MLX5_IB_METHOD_DM_QUERY)(
+	struct uverbs_attr_bundle *attrs)
+{
+	struct ib_dm *ibdm =
+		uverbs_attr_get_obj(attrs, MLX5_IB_ATTR_QUERY_DM_REQ_HANDLE);
+	struct mlx5_ib_dm *dm = to_mdm(ibdm);
+	u64 start_offset;
+	u16 page_idx;
+	int err;
+
+	if (dm->type != MLX5_IB_UAPI_DM_TYPE_MEMIC)
+		return -EOPNOTSUPP;
+
+	page_idx = dm->memic.mentry.rdma_entry.start_pgoff & 0xFFFF;
+	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_QUERY_DM_RESP_PAGE_INDEX,
+			     &page_idx, sizeof(page_idx));
+	if (err)
+		return err;
+
+	start_offset = dm->dev_addr & ~PAGE_MASK;
+	err =  uverbs_copy_to(attrs, MLX5_IB_ATTR_QUERY_DM_RESP_START_OFFSET,
+			      &start_offset, sizeof(start_offset));
+	if (err)
+		return err;
+
+	return uverbs_copy_to(attrs, MLX5_IB_ATTR_QUERY_DM_RESP_LENGTH,
+			      &dm->memic.req_length,
+			      sizeof(dm->memic.req_length));
+}
+
 void mlx5_ib_dm_mmap_free(struct mlx5_ib_dev *dev,
 			  struct mlx5_user_mmap_entry *mentry)
 {
@@ -511,6 +542,17 @@ void mlx5_ib_dm_mmap_free(struct mlx5_ib_dev *dev,
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
@@ -537,7 +579,8 @@ DECLARE_UVERBS_NAMED_METHOD(
 			    UA_OPTIONAL));

 DECLARE_UVERBS_GLOBAL_METHODS(UVERBS_OBJECT_DM,
-			      &UVERBS_METHOD(MLX5_IB_METHOD_DM_MAP_OP_ADDR));
+			      &UVERBS_METHOD(MLX5_IB_METHOD_DM_MAP_OP_ADDR),
+			      &UVERBS_METHOD(MLX5_IB_METHOD_DM_QUERY));

 const struct uapi_definition mlx5_ib_dm_defs[] = {
 	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_DM, &mlx5_ib_dm),
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b714131f87b7..78099d95e8e9 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -637,6 +637,7 @@ struct mlx5_ib_dm {
 				struct xarray		ops;
 				struct mutex		ops_xa_lock;
 				struct kref		ref;
+				size_t			req_length;
 		} memic;
 		struct {
 			u32	obj_id;
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

