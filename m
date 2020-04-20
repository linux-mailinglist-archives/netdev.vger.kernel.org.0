Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A5C1B07CA
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgDTLmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgDTLmt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:49 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 055B4218AC;
        Mon, 20 Apr 2020 11:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382968;
        bh=5TmrNYiaefA+Z1G7FEN87dMSkYeVx7Ef2uPYCzZKXs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBPFJ+fK83tnnHRLfUZLQxX7ZMk/SjcuCSbOe27M8oxiH7O13j1LvhgmS6innwirm
         lxlr0/uVazkowcfBBDQUqCU2L2BIaqRIcROjSTxPzV/WAOUGGo5Li2KDfRjfQ15QQk
         Ty6+cM8WqM/W+SkVaX8eRo47uXnm1DjA82mHWGE8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 19/24] net/mlx5: Update pd.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:31 +0300
Message-Id: <20200420114136.264924-20-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200420114136.264924-1-leon@kernel.org>
References: <20200420114136.264924-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Do mass update of pd.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pd.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pd.c b/drivers/net/ethernet/mellanox/mlx5/core/pd.c
index b92d6f621c83..aabc53ad8bdd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pd.c
@@ -37,12 +37,12 @@
 
 int mlx5_core_alloc_pd(struct mlx5_core_dev *dev, u32 *pdn)
 {
-	u32 out[MLX5_ST_SZ_DW(alloc_pd_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(alloc_pd_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(alloc_pd_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(alloc_pd_in)] = {};
 	int err;
 
 	MLX5_SET(alloc_pd_in, in, opcode, MLX5_CMD_OP_ALLOC_PD);
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(dev, alloc_pd, in, out);
 	if (!err)
 		*pdn = MLX5_GET(alloc_pd_out, out, pd);
 	return err;
@@ -51,11 +51,10 @@ EXPORT_SYMBOL(mlx5_core_alloc_pd);
 
 int mlx5_core_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn)
 {
-	u32 out[MLX5_ST_SZ_DW(dealloc_pd_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(dealloc_pd_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(dealloc_pd_in)] = {};
 
 	MLX5_SET(dealloc_pd_in, in, opcode, MLX5_CMD_OP_DEALLOC_PD);
 	MLX5_SET(dealloc_pd_in, in, pd, pdn);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, dealloc_pd, in);
 }
 EXPORT_SYMBOL(mlx5_core_dealloc_pd);
-- 
2.25.2

