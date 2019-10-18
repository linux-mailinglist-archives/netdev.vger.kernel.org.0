Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28339DD4A9
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 00:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfJRWET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 18:04:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbfJRWER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D1C4222C2;
        Fri, 18 Oct 2019 22:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436256;
        bh=5RupvgqrhiR7b2bC5jkQu0HYTD4pAZcvifxzJliiyUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxlCkBibqANFYIeGFv6JM05wHq1KASzgiqtSTxHma4i08h4RBPxeQHYRhBVUnlPVq
         xnr53x86xvGgq3eLlDRL8+XtJZ52RWZye1DsC8UxGzDFYCSCX1VjdPSonmPafRAWNN
         xK64cZS5tqoQNRFXo1bBpfDKwSrn2mejYJ6wD+no=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 39/89] RDMA/mlx5: Add missing synchronize_srcu() for MW cases
Date:   Fri, 18 Oct 2019 18:02:34 -0400
Message-Id: <20191018220324.8165-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit 0417791536ae1e28d7f0418f1d20048ec4d3c6cf ]

While MR uses live as the SRCU 'update', the MW case uses the xarray
directly, xa_erase() causes the MW to become inaccessible to the pagefault
thread.

Thus whenever a MW is removed from the xarray we must synchronize_srcu()
before freeing it.

This must be done before freeing the mkey as re-use of the mkey while the
pagefault thread is using the stale mkey is undesirable.

Add the missing synchronizes to MW and DEVX indirect mkey and delete the
bogus protection against double destroy in mlx5_core_destroy_mkey()

Fixes: 534fd7aac56a ("IB/mlx5: Manage indirection mkey upon DEVX flow for ODP")
Fixes: 6aec21f6a832 ("IB/mlx5: Page faults handling infrastructure")
Link: https://lore.kernel.org/r/20191001153821.23621-7-jgg@ziepe.ca
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c            | 58 ++++++--------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  1 -
 drivers/infiniband/hw/mlx5/mr.c              | 21 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/mr.c |  8 +--
 4 files changed, 33 insertions(+), 55 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index af5bbb35c0589..ef7ba0133d28a 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1275,29 +1275,6 @@ static int devx_handle_mkey_create(struct mlx5_ib_dev *dev,
 	return 0;
 }
 
-static void devx_free_indirect_mkey(struct rcu_head *rcu)
-{
-	kfree(container_of(rcu, struct devx_obj, devx_mr.rcu));
-}
-
-/* This function to delete from the radix tree needs to be called before
- * destroying the underlying mkey. Otherwise a race might occur in case that
- * other thread will get the same mkey before this one will be deleted,
- * in that case it will fail via inserting to the tree its own data.
- *
- * Note:
- * An error in the destroy is not expected unless there is some other indirect
- * mkey which points to this one. In a kernel cleanup flow it will be just
- * destroyed in the iterative destruction call. In a user flow, in case
- * the application didn't close in the expected order it's its own problem,
- * the mkey won't be part of the tree, in both cases the kernel is safe.
- */
-static void devx_cleanup_mkey(struct devx_obj *obj)
-{
-	xa_erase(&obj->ib_dev->mdev->priv.mkey_table,
-		 mlx5_base_mkey(obj->devx_mr.mmkey.key));
-}
-
 static void devx_cleanup_subscription(struct mlx5_ib_dev *dev,
 				      struct devx_event_subscription *sub)
 {
@@ -1339,8 +1316,16 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	int ret;
 
 	dev = mlx5_udata_to_mdev(&attrs->driver_udata);
-	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY)
-		devx_cleanup_mkey(obj);
+	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY) {
+		/*
+		 * The pagefault_single_data_segment() does commands against
+		 * the mmkey, we must wait for that to stop before freeing the
+		 * mkey, as another allocation could get the same mkey #.
+		 */
+		xa_erase(&obj->ib_dev->mdev->priv.mkey_table,
+			 mlx5_base_mkey(obj->devx_mr.mmkey.key));
+		synchronize_srcu(&dev->mr_srcu);
+	}
 
 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
 		ret = mlx5_core_destroy_dct(obj->ib_dev->mdev, &obj->core_dct);
@@ -1359,12 +1344,6 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 		devx_cleanup_subscription(dev, sub_entry);
 	mutex_unlock(&devx_event_table->event_xa_lock);
 
-	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY) {
-		call_srcu(&dev->mr_srcu, &obj->devx_mr.rcu,
-			  devx_free_indirect_mkey);
-		return ret;
-	}
-
 	kfree(obj);
 	return ret;
 }
@@ -1468,26 +1447,21 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 				   &obj_id);
 	WARN_ON(obj->dinlen > MLX5_MAX_DESTROY_INBOX_SIZE_DW * sizeof(u32));
 
-	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY) {
-		err = devx_handle_mkey_indirect(obj, dev, cmd_in, cmd_out);
-		if (err)
-			goto obj_destroy;
-	}
-
 	err = uverbs_copy_to(attrs, MLX5_IB_ATTR_DEVX_OBJ_CREATE_CMD_OUT, cmd_out, cmd_out_len);
 	if (err)
-		goto err_copy;
+		goto obj_destroy;
 
 	if (opcode == MLX5_CMD_OP_CREATE_GENERAL_OBJECT)
 		obj_type = MLX5_GET(general_obj_in_cmd_hdr, cmd_in, obj_type);
-
 	obj->obj_id = get_enc_obj_id(opcode | obj_type << 16, obj_id);
 
+	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY) {
+		err = devx_handle_mkey_indirect(obj, dev, cmd_in, cmd_out);
+		if (err)
+			goto obj_destroy;
+	}
 	return 0;
 
-err_copy:
-	if (obj->flags & DEVX_OBJ_FLAGS_INDIRECT_MKEY)
-		devx_cleanup_mkey(obj);
 obj_destroy:
 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
 		mlx5_core_destroy_dct(obj->ib_dev->mdev, &obj->core_dct);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 9ae587b74b121..43c7353b98123 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -638,7 +638,6 @@ struct mlx5_ib_mw {
 struct mlx5_ib_devx_mr {
 	struct mlx5_core_mkey	mmkey;
 	int			ndescs;
-	struct rcu_head		rcu;
 };
 
 struct mlx5_ib_umr_context {
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 96c8a6835592d..c15d05f61cc7b 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1970,14 +1970,25 @@ struct ib_mw *mlx5_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
 
 int mlx5_ib_dealloc_mw(struct ib_mw *mw)
 {
+	struct mlx5_ib_dev *dev = to_mdev(mw->device);
 	struct mlx5_ib_mw *mmw = to_mmw(mw);
 	int err;
 
-	err =  mlx5_core_destroy_mkey((to_mdev(mw->device))->mdev,
-				      &mmw->mmkey);
-	if (!err)
-		kfree(mmw);
-	return err;
+	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)) {
+		xa_erase(&dev->mdev->priv.mkey_table,
+			 mlx5_base_mkey(mmw->mmkey.key));
+		/*
+		 * pagefault_single_data_segment() may be accessing mmw under
+		 * SRCU if the user bound an ODP MR to this MW.
+		 */
+		synchronize_srcu(&dev->mr_srcu);
+	}
+
+	err = mlx5_core_destroy_mkey(dev->mdev, &mmw->mmkey);
+	if (err)
+		return err;
+	kfree(mmw);
+	return 0;
 }
 
 int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 9231b39d18b21..c501bf2a02521 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -112,17 +112,11 @@ int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev,
 	u32 out[MLX5_ST_SZ_DW(destroy_mkey_out)] = {0};
 	u32 in[MLX5_ST_SZ_DW(destroy_mkey_in)]   = {0};
 	struct xarray *mkeys = &dev->priv.mkey_table;
-	struct mlx5_core_mkey *deleted_mkey;
 	unsigned long flags;
 
 	xa_lock_irqsave(mkeys, flags);
-	deleted_mkey = __xa_erase(mkeys, mlx5_base_mkey(mkey->key));
+	__xa_erase(mkeys, mlx5_base_mkey(mkey->key));
 	xa_unlock_irqrestore(mkeys, flags);
-	if (!deleted_mkey) {
-		mlx5_core_dbg(dev, "failed xarray delete of mkey 0x%x\n",
-			      mlx5_base_mkey(mkey->key));
-		return -ENOENT;
-	}
 
 	MLX5_SET(destroy_mkey_in, in, opcode, MLX5_CMD_OP_DESTROY_MKEY);
 	MLX5_SET(destroy_mkey_in, in, mkey_index, mlx5_mkey_to_idx(mkey->key));
-- 
2.20.1

