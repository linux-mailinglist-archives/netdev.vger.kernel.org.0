Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E527817F1D2
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 09:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCJIWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 04:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgCJIWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 04:22:53 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA0A524677;
        Tue, 10 Mar 2020 08:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583828572;
        bh=alQc/oUpRowIN50fInd8eIFbuFI40HlW/Yyy9L+0Yn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgaLm7ReNvIqO6t5bnx09o59rHqkBA/TB+/CWrnf8Mhm8nk63FGWlbxR5Zz4Yp5rr
         zt2uMrMtTPpBnfAcCn5w7l7yXQr02SLG9LvqKDW+03asFrfT28yerpsO6U0BY5NGtf
         DlcTKiRB/vL40SKQKXwuQmMQkkiCBeOsR4nWftkU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH mlx5-next v1 02/12] {IB,net}/mlx5: Assign mkey variant in mlx5_ib only
Date:   Tue, 10 Mar 2020 10:22:28 +0200
Message-Id: <20200310082238.239865-3-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310082238.239865-1-leon@kernel.org>
References: <20200310082238.239865-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>

mkey variant is not required for mlx5_core use, move the mkey variant
counter to mlx5_ib.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c             |  1 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  5 ++
 drivers/infiniband/hw/mlx5/mr.c               | 58 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/main.c    |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/mr.c  |  8 +--
 include/linux/mlx5/driver.h                   |  4 --
 6 files changed, 55 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c89a81e89095..73127c52958f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -6393,6 +6393,7 @@ static int mlx5_ib_stage_init_init(struct mlx5_ib_dev *dev)
 	spin_lock_init(&dev->reset_flow_resource_lock);
 	xa_init(&dev->odp_mkeys);
 	xa_init(&dev->sig_mrs);
+	spin_lock_init(&dev->mkey_lock);
 
 	spin_lock_init(&dev->dm.lock);
 	dev->dm.dev = mdev;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 559070c8e234..9d00cf9ccb08 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -999,6 +999,11 @@ struct mlx5_ib_dev {
 	/* sync used page count stats
 	 */
 	struct mlx5_ib_resources	devr;
+
+	/* protect mkey key part */
+	spinlock_t			mkey_lock;
+	u8				mkey_key;
+
 	struct mlx5_mr_cache		cache;
 	struct timer_list		delay_timer;
 	/* Prevents soft lock on massive reg MRs */
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 45c3282dd5e1..1b83d00e8ecd 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -47,6 +47,46 @@ enum {
 
 #define MLX5_UMR_ALIGN 2048
 
+static void
+create_mkey_callback(int status, struct mlx5_async_work *context);
+
+static void
+assign_mkey_variant(struct mlx5_ib_dev *dev, struct mlx5_core_mkey *mkey,
+		    u32 *in)
+{
+	void *mkc;
+	u8 key;
+
+	spin_lock_irq(&dev->mkey_lock);
+	key = dev->mkey_key++;
+	spin_unlock_irq(&dev->mkey_lock);
+
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	MLX5_SET(mkc, mkc, mkey_7_0, key);
+	mkey->key = key;
+}
+
+static int
+mlx5_ib_create_mkey(struct mlx5_ib_dev *dev, struct mlx5_core_mkey *mkey,
+		    u32 *in, int inlen)
+{
+	assign_mkey_variant(dev, mkey, in);
+	return mlx5_core_create_mkey(dev->mdev, mkey, in, inlen);
+}
+
+static int
+mlx5_ib_create_mkey_cb(struct mlx5_ib_dev *dev,
+		       struct mlx5_core_mkey *mkey,
+		       struct mlx5_async_ctx *async_ctx,
+		       u32 *in, int inlen, u32 *out, int outlen,
+		       struct mlx5_async_work *context)
+{
+	assign_mkey_variant(dev, mkey, in);
+	return mlx5_core_create_mkey_cb(dev->mdev, mkey, async_ctx,
+					in, inlen, out, outlen,
+					create_mkey_callback, context);
+}
+
 static void clean_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
 static void dereg_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
 static int mr_cache_max_order(struct mlx5_ib_dev *dev);
@@ -79,7 +119,7 @@ static bool use_umr_mtt_update(struct mlx5_ib_mr *mr, u64 start, u64 length)
 		length + (start & (MLX5_ADAPTER_PAGE_SIZE - 1));
 }
 
-static void reg_mr_callback(int status, struct mlx5_async_work *context)
+static void create_mkey_callback(int status, struct mlx5_async_work *context)
 {
 	struct mlx5_ib_mr *mr =
 		container_of(context, struct mlx5_ib_mr, cb_work);
@@ -160,10 +200,10 @@ static int add_keys(struct mlx5_ib_dev *dev, int c, int num)
 		spin_lock_irq(&ent->lock);
 		ent->pending++;
 		spin_unlock_irq(&ent->lock);
-		err = mlx5_core_create_mkey_cb(dev->mdev, &mr->mmkey,
+		err = mlx5_ib_create_mkey_cb(dev, &mr->mmkey,
 					       &dev->async_ctx, in, inlen,
 					       mr->out, sizeof(mr->out),
-					       reg_mr_callback, &mr->cb_work);
+					       &mr->cb_work);
 		if (err) {
 			spin_lock_irq(&ent->lock);
 			ent->pending--;
@@ -682,7 +722,6 @@ struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
-	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_ib_mr *mr;
 	void *mkc;
 	u32 *in;
@@ -704,7 +743,7 @@ struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc)
 	MLX5_SET(mkc, mkc, length64, 1);
 	set_mkc_access_pd_addr_fields(mkc, acc, 0, pd);
 
-	err = mlx5_core_create_mkey(mdev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
 	if (err)
 		goto err_in;
 
@@ -1094,7 +1133,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_mr *ibmr, struct ib_pd *pd,
 			 get_octo_len(virt_addr, length, page_shift));
 	}
 
-	err = mlx5_core_create_mkey(dev->mdev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
 	if (err) {
 		mlx5_ib_warn(dev, "create mkey failed\n");
 		goto err_2;
@@ -1134,7 +1173,6 @@ static struct ib_mr *mlx5_ib_get_dm_mr(struct ib_pd *pd, u64 start_addr,
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
-	struct mlx5_core_dev *mdev = dev->mdev;
 	struct mlx5_ib_mr *mr;
 	void *mkc;
 	u32 *in;
@@ -1157,7 +1195,7 @@ static struct ib_mr *mlx5_ib_get_dm_mr(struct ib_pd *pd, u64 start_addr,
 	MLX5_SET64(mkc, mkc, len, length);
 	set_mkc_access_pd_addr_fields(mkc, acc, start_addr, pd);
 
-	err = mlx5_core_create_mkey(mdev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
 	if (err)
 		goto err_in;
 
@@ -1635,7 +1673,7 @@ static int _mlx5_alloc_mkey_descs(struct ib_pd *pd, struct mlx5_ib_mr *mr,
 
 	mlx5_set_umr_free_mkey(pd, in, ndescs, access_mode, page_shift);
 
-	err = mlx5_core_create_mkey(dev->mdev, &mr->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, &mr->mmkey, in, inlen);
 	if (err)
 		goto err_free_descs;
 
@@ -1902,7 +1940,7 @@ struct ib_mw *mlx5_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
 	MLX5_SET(mkc, mkc, en_rinval, !!((type == IB_MW_TYPE_2)));
 	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 
-	err = mlx5_core_create_mkey(dev->mdev, &mw->mmkey, in, inlen);
+	err = mlx5_ib_create_mkey(dev, &mw->mmkey, in, inlen);
 	if (err)
 		goto free;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f554cfddcf4e..6b38ec72215a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1282,7 +1282,6 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	mutex_init(&priv->alloc_mutex);
 	mutex_init(&priv->pgdir_mutex);
 	INIT_LIST_HEAD(&priv->pgdir_list);
-	spin_lock_init(&priv->mkey_lock);
 
 	priv->dbg_root = debugfs_create_dir(dev_name(dev->device),
 					    mlx5_debugfs_root);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 770d13bb4f20..51814d023efb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -49,14 +49,7 @@ int mlx5_core_create_mkey_cb(struct mlx5_core_dev *dev,
 	int err;
 	u8 key;
 
-	spin_lock_irq(&dev->priv.mkey_lock);
-	key = dev->priv.mkey_key++;
-	spin_unlock_irq(&dev->priv.mkey_lock);
-	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
-
 	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
-	MLX5_SET(mkc, mkc, mkey_7_0, key);
-	mkey->key = key;
 
 	if (callback)
 		return mlx5_cmd_exec_cb(async_ctx, in, inlen, out, outlen,
@@ -66,6 +59,7 @@ int mlx5_core_create_mkey_cb(struct mlx5_core_dev *dev,
 	if (err)
 		return err;
 
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
 	mkey->iova = MLX5_GET64(mkc, mkc, start_addr);
 	mkey->size = MLX5_GET64(mkc, mkc, len);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index be2f3689095e..cdae66a0c021 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -575,10 +575,6 @@ struct mlx5_priv {
 	/* end: alloc staff */
 	struct dentry	       *dbg_root;
 
-	/* protect mkey key part */
-	spinlock_t		mkey_lock;
-	u8			mkey_key;
-
 	struct list_head        dev_list;
 	struct list_head        ctx_list;
 	spinlock_t              ctx_lock;
-- 
2.24.1

