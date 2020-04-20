Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369431B07DA
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgDTLnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbgDTLnL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:43:11 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 548622224F;
        Mon, 20 Apr 2020 11:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382991;
        bh=dORNRzQIGKKTXgUjmn0WjUDUejNiPh8ZCsxPY5NZQIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9qrfzyTCJ+m6CrBd58bbMe0zCHadf6/bGcogSf+ivYRy881JwLQC8Dgzb8C3FiDP
         2b6a7YjvOUDjP3Ryv+rNUOFNr9xMcP4dWK1mRIuFDNbgj6vCkfhdVMZxPaxObeCFym
         M+FeFrRSFrPHiOQq6ZGqdJo9cC3inTce9n42yvn4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 20/24] net/mlx5: Update uar.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:32 +0300
Message-Id: <20200420114136.264924-21-leon@kernel.org>
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

Do mass update of uar.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/uar.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/uar.c b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
index 816f9c434359..da481a7c12f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/uar.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/uar.c
@@ -38,12 +38,12 @@
 
 int mlx5_cmd_alloc_uar(struct mlx5_core_dev *dev, u32 *uarn)
 {
-	u32 out[MLX5_ST_SZ_DW(alloc_uar_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(alloc_uar_in)]   = {0};
+	u32 out[MLX5_ST_SZ_DW(alloc_uar_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(alloc_uar_in)] = {};
 	int err;
 
 	MLX5_SET(alloc_uar_in, in, opcode, MLX5_CMD_OP_ALLOC_UAR);
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(dev, alloc_uar, in, out);
 	if (!err)
 		*uarn = MLX5_GET(alloc_uar_out, out, uar);
 	return err;
@@ -52,12 +52,11 @@ EXPORT_SYMBOL(mlx5_cmd_alloc_uar);
 
 int mlx5_cmd_free_uar(struct mlx5_core_dev *dev, u32 uarn)
 {
-	u32 out[MLX5_ST_SZ_DW(dealloc_uar_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(dealloc_uar_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(dealloc_uar_in)] = {};
 
 	MLX5_SET(dealloc_uar_in, in, opcode, MLX5_CMD_OP_DEALLOC_UAR);
 	MLX5_SET(dealloc_uar_in, in, uar, uarn);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, dealloc_uar, in);
 }
 EXPORT_SYMBOL(mlx5_cmd_free_uar);
 
-- 
2.25.2

