Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63AF74A800
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbfFRRPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:15:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfFRRPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:15:49 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2B332147A;
        Tue, 18 Jun 2019 17:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878148;
        bh=3tDbIn0RjATV1bHjBccDEJ/i50nnkZyWf4zgBSHNMag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMiV8i83xgOc/cFNwkcMq8gIaIsBeoKd6v8gxhUqNGOv1Q9tpka/RynpvA5MVyEAW
         ZZRl3nNkaFwlWBSOnaqdoWOYTJeffzT+v9pQjHQxaYaTMAR3Vd/F1KeU/w/yLCi+Oz
         Atd+9bllmsG21fpni6R+mS9JjmFIcm27I9lfaaNk=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next v1 01/12] net/mlx5: Fix mlx5_core_destroy_cq() error flow
Date:   Tue, 18 Jun 2019 20:15:29 +0300
Message-Id: <20190618171540.11729-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190618171540.11729-1-leon@kernel.org>
References: <20190618171540.11729-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

The firmware command to destroy a CQ might fail when the object is
referenced by other object and the ref count is managed by the firmware.

To enable a second successful destruction post the first failure need to
change  mlx5_eq_del_cq() to be a void function.

As an error in mlx5_eq_del_cq() is quite fatal from the option to
recover, a debug message inside it should be good enougth and it was
changed to be void.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cq.c     |  9 ++-------
 drivers/net/ethernet/mellanox/mlx5/core/eq.c     | 16 +++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h |  2 +-
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 713a17ee3751..703d88332bc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -158,13 +158,8 @@ int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
 	u32 in[MLX5_ST_SZ_DW(destroy_cq_in)] = {0};
 	int err;
 
-	err = mlx5_eq_del_cq(mlx5_get_async_eq(dev), cq);
-	if (err)
-		return err;
-
-	err = mlx5_eq_del_cq(&cq->eq->core, cq);
-	if (err)
-		return err;
+	mlx5_eq_del_cq(mlx5_get_async_eq(dev), cq);
+	mlx5_eq_del_cq(&cq->eq->core, cq);
 
 	MLX5_SET(destroy_cq_in, in, opcode, MLX5_CMD_OP_DESTROY_CQ);
 	MLX5_SET(destroy_cq_in, in, cqn, cq->cqn);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 58fff2f39b38..8000d2a4a7e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -389,7 +389,7 @@ int mlx5_eq_add_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
 	return err;
 }
 
-int mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
+void mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
 {
 	struct mlx5_cq_table *table = &eq->cq_table;
 	struct mlx5_core_cq *tmp;
@@ -399,16 +399,14 @@ int mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq)
 	spin_unlock(&table->lock);
 
 	if (!tmp) {
-		mlx5_core_warn(eq->dev, "cq 0x%x not found in eq 0x%x tree\n", eq->eqn, cq->cqn);
-		return -ENOENT;
+		mlx5_core_dbg(eq->dev, "cq 0x%x not found in eq 0x%x tree\n",
+			      eq->eqn, cq->cqn);
+		return;
 	}
 
-	if (tmp != cq) {
-		mlx5_core_warn(eq->dev, "corruption on cqn 0x%x in eq 0x%x\n", eq->eqn, cq->cqn);
-		return -EINVAL;
-	}
-
-	return 0;
+	if (tmp != cq)
+		mlx5_core_dbg(eq->dev, "corruption on cqn 0x%x in eq 0x%x\n",
+			      eq->eqn, cq->cqn);
 }
 
 int mlx5_eq_table_init(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index 24bd991a727e..d826e63d5a17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -75,7 +75,7 @@ int mlx5_eq_table_create(struct mlx5_core_dev *dev);
 void mlx5_eq_table_destroy(struct mlx5_core_dev *dev);
 
 int mlx5_eq_add_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
-int mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
+void mlx5_eq_del_cq(struct mlx5_eq *eq, struct mlx5_core_cq *cq);
 struct mlx5_eq_comp *mlx5_eqn2comp_eq(struct mlx5_core_dev *dev, int eqn);
 struct mlx5_eq *mlx5_get_async_eq(struct mlx5_core_dev *dev);
 void mlx5_cq_tasklet_cb(unsigned long data);
-- 
2.20.1

