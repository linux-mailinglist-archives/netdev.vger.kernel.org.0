Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5842517F1D9
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 09:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgCJIXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 04:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgCJIXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 04:23:11 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F4662467D;
        Tue, 10 Mar 2020 08:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583828590;
        bh=f3RW8JQ3TBsAVo4v1BkqMBDNqR/3LDXAY26Fyo/+8cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgugW1D/iiDhCx7THb1DclLTv08WrhJ22zQhHOcgANOI0n7oKpvzN2fOMGPdsqxuX
         JwwIOiyCl4tonPFCkuQeozBW7zk6ciQOtcr832+7tE0SLhGIqKhUBAa5y4EHHR+rjA
         jrPYiuSMI7y6O7RasfpHdJHj8IoR52K9F6BBSJQc=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Michael Guralnik <michaelgur@mellanox.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next v1 04/12] {IB,net}/mlx5: Move asynchronous mkey creation to mlx5_ib
Date:   Tue, 10 Mar 2020 10:22:30 +0200
Message-Id: <20200310082238.239865-5-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310082238.239865-1-leon@kernel.org>
References: <20200310082238.239865-1-leon@kernel.org>
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
 drivers/infiniband/hw/mlx5/mr.c              |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 22 +++-----------------
 include/linux/mlx5/driver.h                  |  6 ------
 3 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 70ae3372411a..a1e6ab9b0bed 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -77,10 +77,10 @@ mlx5_ib_create_mkey_cb(struct mlx5_ib_dev *dev,
 		       u32 *in, int inlen, u32 *out, int outlen,
 		       struct mlx5_async_work *context)
 {
+	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
 	assign_mkey_variant(dev, mkey, in);
-	return mlx5_core_create_mkey_cb(dev->mdev, mkey, async_ctx,
-					in, inlen, out, outlen,
-					create_mkey_callback, context);
+	return mlx5_cmd_exec_cb(async_ctx, in, inlen, out, outlen,
+				create_mkey_callback, context);
 }
 
 static void clean_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 51814d023efb..fd3e6d217c3b 100644
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
@@ -51,10 +48,6 @@ int mlx5_core_create_mkey_cb(struct mlx5_core_dev *dev,
 
 	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
 
-	if (callback)
-		return mlx5_cmd_exec_cb(async_ctx, in, inlen, out, outlen,
-					callback, context);
-
 	err = mlx5_cmd_exec(dev, in, inlen, lout, sizeof(lout));
 	if (err)
 		return err;
@@ -70,15 +63,6 @@ int mlx5_core_create_mkey_cb(struct mlx5_core_dev *dev,
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
index cdae66a0c021..3f10a9633012 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -943,12 +943,6 @@ struct mlx5_cmd_mailbox *mlx5_alloc_cmd_mailbox_chain(struct mlx5_core_dev *dev,
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

