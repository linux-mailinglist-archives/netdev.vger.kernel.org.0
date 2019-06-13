Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B37954455F
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733215AbfFMQnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:43:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:59770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730446AbfFMG1Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 02:27:24 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D4BB2084D;
        Thu, 13 Jun 2019 06:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560407242;
        bh=fgjcb64i4b3Pi9V4wVD3/0gEPhWHM+BcKKx9hlC4Ous=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPF3L1wl9DN4Z2OREYDlUNNUEd2JBYAm3OqASfmzZC5DW2pjlLJaolo8qwTpytnDZ
         icM+aKZToysW7s+N1a7n39cNr13amb5arAmuUHEUNk/v7r8Bk6riPJxhvqi5fFIi7B
         ZuhYjxnUaBIa4+sh+YFFjrNwIr8twU+iKA+Lzw3s=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 12/12] IB/mlx5: Add DEVX support for CQ events
Date:   Thu, 13 Jun 2019 09:26:40 +0300
Message-Id: <20190613062640.28958-13-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613062640.28958-1-leon@kernel.org>
References: <20190613062640.28958-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Add DEVX support for CQ events by creating and destroying the CQ via
mlx5_core and set an handler to manage its completions.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 40 +++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index b96420021b1d..c24c483d0d95 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -19,9 +19,12 @@
 #define UVERBS_MODULE_NAME mlx5_ib
 #include <rdma/uverbs_named_ioctl.h>
 
+static void dispatch_event_fd(struct list_head *fd_list, const void *data);
+
 enum devx_obj_flags {
 	DEVX_OBJ_FLAGS_INDIRECT_MKEY = 1 << 0,
 	DEVX_OBJ_FLAGS_DCT = 1 << 1,
+	DEVX_OBJ_FLAGS_CQ = 1 << 2,
 };
 
 struct devx_async_data {
@@ -92,6 +95,7 @@ struct devx_async_event_file {
 #define MLX5_MAX_DESTROY_INBOX_SIZE_DW MLX5_ST_SZ_DW(delete_fte_in)
 struct devx_obj {
 	struct mlx5_core_dev	*mdev;
+	struct mlx5_ib_dev	*ib_dev;
 	u64			obj_id;
 	u32			dinlen; /* destroy inbox length */
 	u32			dinbox[MLX5_MAX_DESTROY_INBOX_SIZE_DW];
@@ -99,6 +103,7 @@ struct devx_obj {
 	union {
 		struct mlx5_ib_devx_mr	devx_mr;
 		struct mlx5_core_dct	core_dct;
+		struct mlx5_core_cq	core_cq;
 	};
 	struct list_head event_sub; /* holds devx_event_subscription entries */
 };
@@ -1341,6 +1346,8 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 
 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
 		ret = mlx5_core_destroy_dct(obj->mdev, &obj->core_dct);
+	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
+		ret = mlx5_core_destroy_cq(obj->mdev, &obj->core_cq);
 	else
 		ret = mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out,
 				    sizeof(out));
@@ -1383,6 +1390,30 @@ static int devx_obj_cleanup(struct ib_uobject *uobject,
 	return ret;
 }
 
+static void devx_cq_comp(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe)
+{
+	struct devx_obj *obj = container_of(mcq, struct devx_obj, core_cq);
+	struct mlx5_devx_event_table *table;
+	struct devx_event *event;
+	struct devx_obj_event *obj_event;
+	u32 obj_id = mcq->cqn;
+
+	table = &obj->ib_dev->devx_event_table;
+	event = xa_load(&table->event_xa, MLX5_EVENT_TYPE_COMP);
+	if (!event)
+		return;
+
+	rcu_read_lock();
+	obj_event = xa_load(&event->object_ids, obj_id);
+	if (!obj_event) {
+		rcu_read_unlock();
+		return;
+	}
+
+	dispatch_event_fd(&obj_event->obj_sub_list, eqe);
+	rcu_read_unlock();
+}
+
 static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	struct uverbs_attr_bundle *attrs)
 {
@@ -1434,6 +1465,12 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 		err = mlx5_core_create_dct(dev->mdev, &obj->core_dct,
 					   cmd_in, cmd_in_len,
 					   cmd_out, cmd_out_len);
+	} else if (opcode == MLX5_CMD_OP_CREATE_CQ) {
+		obj->flags |= DEVX_OBJ_FLAGS_CQ;
+		obj->core_cq.comp = devx_cq_comp;
+		err = mlx5_core_create_cq(dev->mdev, &obj->core_cq,
+					  cmd_in, cmd_in_len, cmd_out,
+					  cmd_out_len);
 	} else {
 		err = mlx5_cmd_exec(dev->mdev, cmd_in,
 				    cmd_in_len,
@@ -1446,6 +1483,7 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	uobj->object = obj;
 	obj->mdev = dev->mdev;
 	INIT_LIST_HEAD(&obj->event_sub);
+	obj->ib_dev = dev;
 	devx_obj_build_destroy_cmd(cmd_in, cmd_out, obj->dinbox, &obj->dinlen,
 				   &obj_id);
 	WARN_ON(obj->dinlen > MLX5_MAX_DESTROY_INBOX_SIZE_DW * sizeof(u32));
@@ -1473,6 +1511,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 obj_destroy:
 	if (obj->flags & DEVX_OBJ_FLAGS_DCT)
 		mlx5_core_destroy_dct(obj->mdev, &obj->core_dct);
+	else if (obj->flags & DEVX_OBJ_FLAGS_CQ)
+		mlx5_core_destroy_cq(obj->mdev, &obj->core_cq);
 	else
 		mlx5_cmd_exec(obj->mdev, obj->dinbox, obj->dinlen, out,
 			      sizeof(out));
-- 
2.20.1

