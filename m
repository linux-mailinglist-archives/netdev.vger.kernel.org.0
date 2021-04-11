Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5883535B439
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 14:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbhDKMaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 08:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235531AbhDKMaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 08:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 240E860FF1;
        Sun, 11 Apr 2021 12:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618144193;
        bh=GZMmqpPdvU+m4feeQJfbUdupGoTlvZ75j3aqd5osECA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FEyVJ2V94NroaRFhfkZ93Z7s1otjV4vyz+akH72zgb0uEOOIZ/3EjvPfh0UCTy13F
         5Jo7KjSGnoTGnbbTpAW8yXpHM7rKzeYVMiBMN7Bt2cNtvN9M6GnVX1BT/n3KeDUuf3
         GuQ6h6bdNWuWkLPoFqNFeIDgM0i55KYo4F+B7aLsruQePEa5fOP9cY9lwKA6zLZqfu
         OPTTsms37xwWr2i/WAGU6ac1iaB/8zkrxll8TEEhi61+PjTAi3PvBjwRmfYrhWc64r
         4o6c2eDcykNw6wZ4uJO1dMLUGfqje7OaZRRW7ffnFuiZSiaBdjRJhvHZLM5A5HwKgR
         PU2MoFrHBPlNw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>, linux-api@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next v1 5/7] RDMA/mlx5: Add support to MODIFY_MEMIC command
Date:   Sun, 11 Apr 2021 15:29:22 +0300
Message-Id: <20210411122924.60230-6-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210411122924.60230-1-leon@kernel.org>
References: <20210411122924.60230-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Add two functions to allocate and deallocate MEMIC operations
by using the MODIFY_MEMIC command.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/dm.c | 36 +++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/dm.h |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index 29eb5c9df3a4..a648554210f8 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -111,6 +111,42 @@ void mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, phys_addr_t addr,
 	spin_unlock(&dm->lock);
 }
 
+void mlx5_cmd_dealloc_memic_op(struct mlx5_dm *dm, phys_addr_t addr,
+			       u8 operation)
+{
+	u32 in[MLX5_ST_SZ_DW(modify_memic_in)] = {};
+	struct mlx5_core_dev *dev = dm->dev;
+
+	MLX5_SET(modify_memic_in, in, opcode, MLX5_CMD_OP_MODIFY_MEMIC);
+	MLX5_SET(modify_memic_in, in, op_mod, MLX5_MODIFY_MEMIC_OP_MOD_DEALLOC);
+	MLX5_SET(modify_memic_in, in, memic_operation_type, operation);
+	MLX5_SET64(modify_memic_in, in, memic_start_addr, addr - dev->bar_addr);
+
+	mlx5_cmd_exec_in(dev, modify_memic, in);
+}
+
+static int mlx5_cmd_alloc_memic_op(struct mlx5_dm *dm, phys_addr_t addr,
+				   u8 operation, phys_addr_t *op_addr)
+{
+	u32 out[MLX5_ST_SZ_DW(modify_memic_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(modify_memic_in)] = {};
+	struct mlx5_core_dev *dev = dm->dev;
+	int err;
+
+	MLX5_SET(modify_memic_in, in, opcode, MLX5_CMD_OP_MODIFY_MEMIC);
+	MLX5_SET(modify_memic_in, in, op_mod, MLX5_MODIFY_MEMIC_OP_MOD_ALLOC);
+	MLX5_SET(modify_memic_in, in, memic_operation_type, operation);
+	MLX5_SET64(modify_memic_in, in, memic_start_addr, addr - dev->bar_addr);
+
+	err = mlx5_cmd_exec_inout(dev, modify_memic, in, out);
+	if (err)
+		return err;
+
+	*op_addr = dev->bar_addr +
+		   MLX5_GET64(modify_memic_out, out, memic_operation_addr);
+	return 0;
+}
+
 static int add_dm_mmap_entry(struct ib_ucontext *context,
 			     struct mlx5_ib_dm_memic *mdm, u64 address)
 {
diff --git a/drivers/infiniband/hw/mlx5/dm.h b/drivers/infiniband/hw/mlx5/dm.h
index 39e66b51264d..6857bbdb201c 100644
--- a/drivers/infiniband/hw/mlx5/dm.h
+++ b/drivers/infiniband/hw/mlx5/dm.h
@@ -49,5 +49,7 @@ struct ib_dm *mlx5_ib_alloc_dm(struct ib_device *ibdev,
 			       struct uverbs_attr_bundle *attrs);
 void mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, phys_addr_t addr,
 			    u64 length);
+void mlx5_cmd_dealloc_memic_op(struct mlx5_dm *dm, phys_addr_t addr,
+			       u8 operation);
 
 #endif /* _MLX5_IB_DM_H */
-- 
2.30.2

