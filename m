Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A405B0A6
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfF3QYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbfF3QYi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 12:24:38 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0349D20673;
        Sun, 30 Jun 2019 16:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561911877;
        bh=lrcUkJ0Gtd6UBipS+mjdKit61DI16L9TqW5YQFOiF9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFPop87xQicuVwF+Ny5ONko4h1TH/4+iZmOvOup7A28RlHOF01lSnkR1kFXJidTdf
         6s7K75r3+MhBejcRsJ80z2HtNjClvgMEU2wa9/TBituRYvt1ofQ/qEUa7/g68KT21m
         hQJk0nig2MCIrFC/o75HtVq59Y1lJJ90TVYxjDDs=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 13/13] IB/mlx5: DEVX cleanup mdev
Date:   Sun, 30 Jun 2019 19:23:34 +0300
Message-Id: <20190630162334.22135-14-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190630162334.22135-1-leon@kernel.org>
References: <20190630162334.22135-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

No need any more to hold mlx5_core_dev on the devx_object, it can be
accessed from ib_dev.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 38064f4bfdf6..cb4f0fc79176 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -91,7 +91,6 @@ struct devx_async_event_file {
 
 #define MLX5_MAX_DESTROY_INBOX_SIZE_DW MLX5_ST_SZ_DW(delete_fte_in)
 struct devx_obj {
-	struct mlx5_core_dev	*mdev;
 	struct mlx5_ib_dev	*ib_dev;
 	u64			obj_id;
 	u32			dinlen; /* destroy inbox length */
@@ -1297,7 +1296,7 @@ static void devx_free_indirect_mkey(struct rcu_head *rcu)
  */
 static void devx_cleanup_mkey(struct devx_obj *obj)
 {
-	struct mlx5_mkey_table *table = &obj->mdev->priv.mkey_table;
+	struct mlx5_mkey_table *table = &obj->ib_dev->mdev->priv.mkey_table;
 	unsigned long flags;
 
 	write_lock_irqsave(&table->lock, flags);
@@ -1350,12 +1349,12 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 		devx_cleanup_mkey(obj);
 
 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
-		ret = mlx5_core_destroy_dct(obj->mdev, &obj->core_dct);
+		ret = mlx5_core_destroy_dct(obj->ib_dev->mdev, &obj->core_dct);
 	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
-		ret = mlx5_core_destroy_cq(obj->mdev, &obj->core_cq);
+		ret = mlx5_core_destroy_cq(obj->ib_dev->mdev, &obj->core_cq);
 	else
-		ret = mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out,
-				    sizeof(out));
+		ret = mlx5_cmd_exec(obj->ib_dev->mdev, obj->dinbox,
+				    obj->dinlen, out, sizeof(out));
 	if (ib_is_destroy_retryable(ret, why, uobject))
 		return ret;
 
@@ -1466,7 +1465,6 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 		goto obj_free;
 
 	uobj->object = obj;
-	obj->mdev = dev->mdev;
 	INIT_LIST_HEAD(&obj->event_sub);
 	obj->ib_dev = dev;
 	devx_obj_build_destroy_cmd(cmd_in, cmd_out, obj->dinbox, &obj->dinlen,
@@ -1495,11 +1493,11 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 		devx_cleanup_mkey(obj);
 obj_destroy:
 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
-		mlx5_core_destroy_dct(obj->mdev, &obj->core_dct);
+		mlx5_core_destroy_dct(obj->ib_dev->mdev, &obj->core_dct);
 	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
-		mlx5_core_destroy_cq(obj->mdev, &obj->core_cq);
+		mlx5_core_destroy_cq(obj->ib_dev->mdev, &obj->core_cq);
 	else
-		mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out,
+		mlx5_cmd_exec(obj->ib_dev->mdev, obj->dinbox, obj->dinlen, out,
 			      sizeof(out));
 obj_free:
 	kfree(obj);
-- 
2.20.1

