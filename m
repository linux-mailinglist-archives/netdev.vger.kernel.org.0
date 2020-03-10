Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB9017F1D0
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 09:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgCJIWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 04:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgCJIWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 04:22:49 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA4DD24677;
        Tue, 10 Mar 2020 08:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583828569;
        bh=wJ3/T6+tmJjOFxzSRoPkXeeiT35r4bpOGMRhZP0sbKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuLSeMWAmbCO9B8QLbyMfczZ7AhCamdmroxSI5558ZQV8peUGmkXLjfSV9RRiRmbF
         +BJasQQIAcXMBcQkxyZji0pQQWG5SL0SzpVyZRyvsLGlMXPsUzwxh2oyKvk7buZPyo
         Pm9rsx7gDmS9yAr25f8KDfJsDbOvr6S+T8yotZ20=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>, Eli Cohen <eli@mellanox.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH mlx5-next v1 01/12] {IB,net}/mlx5: Setup mkey variant before mr create command invocation
Date:   Tue, 10 Mar 2020 10:22:27 +0200
Message-Id: <20200310082238.239865-2-leon@kernel.org>
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

On reg_mr_callback() mlx5_ib is recalculating the mkey variant which is
wrong and will lead to using a different key variant than the one
submitted to firmware on create mkey command invocation.

To fix this, we store the mkey variant before invoking the firmware
command and use it later on completion (reg_mr_callback).

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mr.c              | 7 ++-----
 drivers/net/ethernet/mellanox/mlx5/core/mr.c | 3 ++-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 6fa0a83c19de..45c3282dd5e1 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -87,7 +87,6 @@ static void reg_mr_callback(int status, struct mlx5_async_work *context)
 	struct mlx5_mr_cache *cache = &dev->cache;
 	int c = order2idx(dev, mr->order);
 	struct mlx5_cache_ent *ent = &cache->ent[c];
-	u8 key;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ent->lock, flags);
@@ -102,10 +101,8 @@ static void reg_mr_callback(int status, struct mlx5_async_work *context)
 	}
 
 	mr->mmkey.type = MLX5_MKEY_MR;
-	spin_lock_irqsave(&dev->mdev->priv.mkey_lock, flags);
-	key = dev->mdev->priv.mkey_key++;
-	spin_unlock_irqrestore(&dev->mdev->priv.mkey_lock, flags);
-	mr->mmkey.key = mlx5_idx_to_mkey(MLX5_GET(create_mkey_out, mr->out, mkey_index)) | key;
+	mr->mmkey.key |= mlx5_idx_to_mkey(
+		MLX5_GET(create_mkey_out, mr->out, mkey_index));
 
 	cache->last_add = jiffies;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 42cc3c7ac5b6..770d13bb4f20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -56,6 +56,7 @@ int mlx5_core_create_mkey_cb(struct mlx5_core_dev *dev,
 
 	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
 	MLX5_SET(mkc, mkc, mkey_7_0, key);
+	mkey->key = key;
 
 	if (callback)
 		return mlx5_cmd_exec_cb(async_ctx, in, inlen, out, outlen,
@@ -68,7 +69,7 @@ int mlx5_core_create_mkey_cb(struct mlx5_core_dev *dev,
 	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
 	mkey->iova = MLX5_GET64(mkc, mkc, start_addr);
 	mkey->size = MLX5_GET64(mkc, mkc, len);
-	mkey->key = mlx5_idx_to_mkey(mkey_index) | key;
+	mkey->key |= mlx5_idx_to_mkey(mkey_index);
 	mkey->pd = MLX5_GET(mkc, mkc, pd);
 
 	mlx5_core_dbg(dev, "out 0x%x, key 0x%x, mkey 0x%x\n",
-- 
2.24.1

