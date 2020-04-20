Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EB21B07C5
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgDTLmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgDTLmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:38 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 253FA21473;
        Mon, 20 Apr 2020 11:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382957;
        bh=vtDJUvkcgEQB/Us/QhlFCIGwLPIDsJLArppbZPOiI7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W26K5Qpr63kCDFciqaUwIO0NvH3CKiGA6exxN5GQkZVSf7p2AlkFouOLlaRE6FE82
         UvTu+SQuJUGLZY9aiYx+hP6aKz6zZb3uWr583xz5h4oBVFZJDiUhqRjoDF9jSzq0LG
         Tq6OO6lxO8HrXcyP1IPV5RgG+b0VKKUEGfmVxGTs=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 16/24] net/mlx5: Update mcg.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:28 +0300
Message-Id: <20200420114136.264924-17-leon@kernel.org>
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

Do mass update of mcg.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/mcg.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mcg.c b/drivers/net/ethernet/mellanox/mlx5/core/mcg.c
index 6789fe658037..e019d68062d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mcg.c
@@ -38,28 +38,26 @@
 
 int mlx5_core_attach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid, u32 qpn)
 {
-	u32 out[MLX5_ST_SZ_DW(attach_to_mcg_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(attach_to_mcg_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(attach_to_mcg_in)] = {};
 	void *gid;
 
 	MLX5_SET(attach_to_mcg_in, in, opcode, MLX5_CMD_OP_ATTACH_TO_MCG);
 	MLX5_SET(attach_to_mcg_in, in, qpn, qpn);
 	gid = MLX5_ADDR_OF(attach_to_mcg_in, in, multicast_gid);
 	memcpy(gid, mgid, sizeof(*mgid));
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, attach_to_mcg, in);
 }
 EXPORT_SYMBOL(mlx5_core_attach_mcg);
 
 int mlx5_core_detach_mcg(struct mlx5_core_dev *dev, union ib_gid *mgid, u32 qpn)
 {
-	u32 out[MLX5_ST_SZ_DW(detach_from_mcg_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(detach_from_mcg_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(detach_from_mcg_in)] = {};
 	void *gid;
 
 	MLX5_SET(detach_from_mcg_in, in, opcode, MLX5_CMD_OP_DETACH_FROM_MCG);
 	MLX5_SET(detach_from_mcg_in, in, qpn, qpn);
 	gid = MLX5_ADDR_OF(detach_from_mcg_in, in, multicast_gid);
 	memcpy(gid, mgid, sizeof(*mgid));
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, detach_from_mcg, in);
 }
 EXPORT_SYMBOL(mlx5_core_detach_mcg);
-- 
2.25.2

