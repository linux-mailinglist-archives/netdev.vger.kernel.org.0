Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0414C340463
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 12:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhCRLQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 07:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhCRLQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 07:16:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 680F064F2B;
        Thu, 18 Mar 2021 11:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616066169;
        bh=+Pt0XqK+3EAXj1buSHZGoDdNgxitVYYsZ/ujynONCoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q32zq0B3RHsuXNiBU0/R6Afk56IQuccmRoDipX0OUuP1oBVW+6OsS0QAotqResUcq
         igkqBbvG9I+Zm4s2O2HezwdFJpuBiiP5gi60PuaVYFY8K+sNS4iuoTT8EwFxJTrBfr
         uz+9+uHMfhzAL0oATgFyVHxwOlCc+1mvUzrh0iLtT5xN69a+TR4XYp6MbOQIx2RjPC
         VFOreOlgypFbo4Mfe8dEmaJj5LxSt9eyWQ+btcRoyxBixmslD70HF4i16z+I73UA/R
         5LECZBrIunxnxDPtl1AiZmHoHq8zKobCCGNAlZHAAKJRZRUyMiXi18Y6BhA6xE9w+T
         jabCg2G94jdDA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Maor Gottlieb <maorg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@mellanox.com>
Subject: [PATCH rdma-next 5/7] RDMA/mlx5: Add support to MODIFY_MEMIC command
Date:   Thu, 18 Mar 2021 13:15:46 +0200
Message-Id: <20210318111548.674749-6-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318111548.674749-1-leon@kernel.org>
References: <20210318111548.674749-1-leon@kernel.org>
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
 drivers/infiniband/hw/mlx5/dm.c | 38 +++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/dm.h |  2 ++
 2 files changed, 40 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/dm.c b/drivers/infiniband/hw/mlx5/dm.c
index 3d39d93625ad..97a925d43312 100644
--- a/drivers/infiniband/hw/mlx5/dm.c
+++ b/drivers/infiniband/hw/mlx5/dm.c
@@ -111,6 +111,44 @@ void mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, phys_addr_t addr,
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
+	MLX5_SET(modify_memic_in, in, memic_operation_type,
+		 MLX5_MODIFY_MEMIC_OP_MOD_ALLOC);
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
+	MLX5_SET(modify_memic_in, in, memic_operation_type,
+		 MLX5_MODIFY_MEMIC_OP_MOD_ALLOC);
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
 			     struct mlx5_ib_dm *mdm, u64 address)
 {
diff --git a/drivers/infiniband/hw/mlx5/dm.h b/drivers/infiniband/hw/mlx5/dm.h
index dbef67e38731..adb39d3d8131 100644
--- a/drivers/infiniband/hw/mlx5/dm.h
+++ b/drivers/infiniband/hw/mlx5/dm.h
@@ -10,5 +10,7 @@

 void mlx5_cmd_dealloc_memic(struct mlx5_dm *dm, phys_addr_t addr,
 			    u64 length);
+void mlx5_cmd_dealloc_memic_op(struct mlx5_dm *dm, phys_addr_t addr,
+			       u8 operation);

 #endif /* _MLX5_IB_DM_H */
--
2.30.2

