Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A15D31868F
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 09:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBKIzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 03:55:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:39860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229794AbhBKIzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 03:55:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 620E764E7D;
        Thu, 11 Feb 2021 08:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613033754;
        bh=8NBJxHBxVv0WCKh+7BdNwNIuaByUtC+9YiMRt+ZjXjo=;
        h=From:To:Cc:Subject:Date:From;
        b=IJMk7wZmj6fvu6Xcu5iZ4FWjWoFKEoOLbFeOriPpNAYo5O3qPVY1uq5mL1jpkpnNu
         KZxig/47KYCGMJrMBtkXdiIHxKUTytnk60IsVzKtEz33SZxFUB2rNtf5QniIxL0s2/
         1B1a28vx7uFyWswpJ36CNKqg1fu700gwSksu4AcALJYKbSAvtVnGZiiGfaLLhl0YB+
         sYiANjHrYWMAIPVBRAsKaLbwxRcAiLfE40o19n+Kout48sxq5dWDWEZoiOgIJUi8T9
         SKGcAoJSZDmOAFLMJ/oli6ILsJG9Ihg+RhCgad57jdMcz9Mk3SLD6yieUy5WvbLUpL
         s8ZUyLBSjttlw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Tal Gilboa <talgi@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next] RDMA/mlx5: Allow CQ creation without attached EQs
Date:   Thu, 11 Feb 2021 10:55:49 +0200
Message-Id: <20210211085549.1277674-1-leon@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tal Gilboa <talgi@nvidia.com>

The traditional DevX CQ creation flow goes through mlx5_core_create_cq()
which checks that the given EQN corresponds to an existing EQ. For some
mlx5 devices this behaviour is too strict, they expect EQN assignment
during modify CQ stage.

Allow them to create CQ through general command interface.

Signed-off-by: Tal Gilboa <talgi@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c | 13 ++++++++++++-
 include/linux/mlx5/mlx5_ifc.h     |  5 +++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 526057a33edb..8152d0ddac2d 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1439,6 +1439,16 @@ static void devx_cq_comp(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe)
 	rcu_read_unlock();
 }

+static bool is_apu_thread_cq(struct mlx5_ib_dev *dev, const void *in)
+{
+	if (!MLX5_CAP_GEN(dev->mdev, apu) ||
+	    !MLX5_GET(cqc, MLX5_ADDR_OF(create_cq_in, in, cq_context),
+		      apu_thread_cq))
+		return false;
+
+	return true;
+}
+
 static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 	struct uverbs_attr_bundle *attrs)
 {
@@ -1492,7 +1502,8 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_OBJ_CREATE)(
 		obj->flags |= DEVX_OBJ_FLAGS_DCT;
 		err = mlx5_core_create_dct(dev, &obj->core_dct, cmd_in,
 					   cmd_in_len, cmd_out, cmd_out_len);
-	} else if (opcode == MLX5_CMD_OP_CREATE_CQ) {
+	} else if (opcode == MLX5_CMD_OP_CREATE_CQ &&
+		   !is_apu_thread_cq(dev, cmd_in)) {
 		obj->flags |= DEVX_OBJ_FLAGS_CQ;
 		obj->core_cq.comp = devx_cq_comp;
 		err = mlx5_core_create_cq(dev->mdev, &obj->core_cq,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ffe2c7231ae4..816893f34e79 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1659,7 +1659,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         sf_set_partition[0x1];
 	u8         reserved_at_682[0x1];
 	u8         log_max_sf[0x5];
-	u8         reserved_at_688[0x8];
+	u8         apu[0x1];
+	u8         reserved_at_689[0x7];
 	u8         log_min_sf_size[0x8];
 	u8         max_num_sf_partitions[0x8];

@@ -3874,7 +3875,7 @@ struct mlx5_ifc_cqc_bits {
 	u8         status[0x4];
 	u8         reserved_at_4[0x2];
 	u8         dbr_umem_valid[0x1];
-	u8         reserved_at_7[0x1];
+	u8         apu_thread_cq[0x1];
 	u8         cqe_sz[0x3];
 	u8         cc[0x1];
 	u8         reserved_at_c[0x1];
--
2.29.2

