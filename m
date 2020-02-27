Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1AF17174E
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 13:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbgB0MeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 07:34:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:35328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbgB0MeW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 07:34:22 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CD602468E;
        Thu, 27 Feb 2020 12:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582806861;
        bh=OKeM2ARY1JoA7ynsbsxCtljktnZCPCBjkUVPDslPK7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x47mwFi8+mUA5Iiaa8I7EwAxq78oujIMkLpq1G7cC8AvVca0LuWqsnkYk5SlzNAR6
         sSSued1QN4EQAYhXftNjsKzJVC4vYD3DWraVQlGlEBTn5Io5hIjj4VNwwbHzhkETP8
         rAcdnnLUVNUnJwVQIiRnBfQ8liEmxj9Q26JCSksE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Michael Guralnik <michaelgur@mellanox.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 1/9] RDMA/mlx5: Move asynchronous mkey creation to mlx5_ib
Date:   Thu, 27 Feb 2020 14:33:52 +0200
Message-Id: <20200227123400.97758-2-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227123400.97758-1-leon@kernel.org>
References: <20200227123400.97758-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

As mlx5_ib is the only user of the mlx5_core_create_mkey_cb, move the
logic inside mlx5_ib and cleanup the code in mlx5_core.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mr.c              | 25 ++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 22 +++--------------
 include/linux/mlx5/driver.h                  |  6 -----
 3 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 6fa0a83c19de..dea14477a676 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -79,6 +79,25 @@ static bool use_umr_mtt_update(struct mlx5_ib_mr *mr, u64 start, u64 length)
 		length + (start & (MLX5_ADAPTER_PAGE_SIZE - 1));
 }
 
+static int create_mkey_cb(struct mlx5_core_dev *dev, struct mlx5_ib_mr *mr,
+			  struct mlx5_async_ctx *async_ctx, u32 *in, int inlen,
+			  mlx5_async_cbk_t callback)
+{
+	void *mkc;
+	u8 key;
+
+	spin_lock_irq(&dev->priv.mkey_lock);
+	key = dev->priv.mkey_key++;
+	spin_unlock_irq(&dev->priv.mkey_lock);
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+
+	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
+	MLX5_SET(mkc, mkc, mkey_7_0, key);
+
+	return mlx5_cmd_exec_cb(async_ctx, in, inlen, mr->out, sizeof(mr->out),
+				callback, &mr->cb_work);
+}
+
 static void reg_mr_callback(int status, struct mlx5_async_work *context)
 {
 	struct mlx5_ib_mr *mr =
@@ -163,10 +182,8 @@ static int add_keys(struct mlx5_ib_dev *dev, int c, int num)
 		spin_lock_irq(&ent->lock);
 		ent->pending++;
 		spin_unlock_irq(&ent->lock);
-		err = mlx5_core_create_mkey_cb(dev->mdev, &mr->mmkey,
-					       &dev->async_ctx, in, inlen,
-					       mr->out, sizeof(mr->out),
-					       reg_mr_callback, &mr->cb_work);
+		err = create_mkey_cb(dev->mdev, mr, &dev->async_ctx, in, inlen,
+				     reg_mr_callback);
 		if (err) {
 			spin_lock_irq(&ent->lock);
 			ent->pending--;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 42cc3c7ac5b6..83841e4119d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -36,12 +36,9 @@
 #include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
 
-int mlx5_core_create_mkey_cb(struct mlx5_core_dev *dev,
-			     struct mlx5_core_mkey *mkey,
-			     struct mlx5_async_ctx *async_ctx, u32 *in,
-			     int inlen, u32 *out, int outlen,
-			     mlx5_async_cbk_t callback,
-			     struct mlx5_async_work *context)
+int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
+			  struct mlx5_core_mkey *mkey,
+			  u32 *in, int inlen)
 {
 	u32 lout[MLX5_ST_SZ_DW(create_mkey_out)] = {0};
 	u32 mkey_index;
@@ -57,10 +54,6 @@ int mlx5_core_create_mkey_cb(struct mlx5_core_dev *dev,
 	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
 	MLX5_SET(mkc, mkc, mkey_7_0, key);
 
-	if (callback)
-		return mlx5_cmd_exec_cb(async_ctx, in, inlen, out, outlen,
-					callback, context);
-
 	err = mlx5_cmd_exec(dev, in, inlen, lout, sizeof(lout));
 	if (err)
 		return err;
@@ -75,15 +68,6 @@ int mlx5_core_create_mkey_cb(struct mlx5_core_dev *dev,
 		      mkey_index, key, mkey->key);
 	return 0;
 }
-EXPORT_SYMBOL(mlx5_core_create_mkey_cb);
-
-int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
-			  struct mlx5_core_mkey *mkey,
-			  u32 *in, int inlen)
-{
-	return mlx5_core_create_mkey_cb(dev, mkey, NULL, in, inlen,
-					NULL, 0, NULL, NULL);
-}
 EXPORT_SYMBOL(mlx5_core_create_mkey);
 
 int mlx5_core_destroy_mkey(struct mlx5_core_dev *dev,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f2b4225ed650..7225e9ca0f25 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -947,12 +947,6 @@ struct mlx5_cmd_mailbox *mlx5_alloc_cmd_mailbox_chain(struct mlx5_core_dev *dev,
 						      gfp_t flags, int npages);
 void mlx5_free_cmd_mailbox_chain(struct mlx5_core_dev *dev,
 				 struct mlx5_cmd_mailbox *head);
-int mlx5_core_create_mkey_cb(struct mlx5_core_dev *dev,
-			     struct mlx5_core_mkey *mkey,
-			     struct mlx5_async_ctx *async_ctx, u32 *in,
-			     int inlen, u32 *out, int outlen,
-			     mlx5_async_cbk_t callback,
-			     struct mlx5_async_work *context);
 int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
 			  struct mlx5_core_mkey *mkey,
 			  u32 *in, int inlen);
-- 
2.24.1

