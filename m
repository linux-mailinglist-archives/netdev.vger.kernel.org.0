Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10C11B07AF
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbgDTLmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTLmM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:12 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 442E821473;
        Mon, 20 Apr 2020 11:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382932;
        bh=Pe/TEi579V4QmCZPBzz1nttELCtPcHwDo+KtnP3mhyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7FsestIgoBng4mS8nrs8TDm3QkNYo6TiCUxa90sHH+ea71j4tGRlVuLsw4PDSiQS
         Bfu8TUYcoq0AlqSrzb0Qbj/3quV6isAmiFeOEuTAla49PzAZ1M0vDz/Gbt7bp+oVB+
         GL6px6YBjdGD1tcF1Ub6mtAjyYn5twFPUFg+OTdI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 03/24] net/mlx5: Update debugfs.c to new cmd interface
Date:   Mon, 20 Apr 2020 14:41:15 +0300
Message-Id: <20200420114136.264924-4-leon@kernel.org>
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

Do mass update of debugfs.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index c05e6a2c9126..6409090b3ec5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -273,20 +273,11 @@ static u64 qp_read_field(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 	return param;
 }
 
-static int mlx5_core_eq_query(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
-			      u32 *out, int outlen)
-{
-	u32 in[MLX5_ST_SZ_DW(query_eq_in)] = {};
-
-	MLX5_SET(query_eq_in, in, opcode, MLX5_CMD_OP_QUERY_EQ);
-	MLX5_SET(query_eq_in, in, eq_number, eq->eqn);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
-}
-
 static u64 eq_read_field(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 			 int index)
 {
 	int outlen = MLX5_ST_SZ_BYTES(query_eq_out);
+	u32 in[MLX5_ST_SZ_DW(query_eq_in)] = {};
 	u64 param = 0;
 	void *ctx;
 	u32 *out;
@@ -296,7 +287,9 @@ static u64 eq_read_field(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 	if (!out)
 		return param;
 
-	err = mlx5_core_eq_query(dev, eq, out, outlen);
+	MLX5_SET(query_eq_in, in, opcode, MLX5_CMD_OP_QUERY_EQ);
+	MLX5_SET(query_eq_in, in, eq_number, eq->eqn);
+	err = mlx5_cmd_exec_inout(dev, query_eq, in, out);
 	if (err) {
 		mlx5_core_warn(dev, "failed to query eq\n");
 		goto out;
-- 
2.25.2

