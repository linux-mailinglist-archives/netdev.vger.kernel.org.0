Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9301B07D3
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgDTLnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgDTLnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:43:00 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EBF521473;
        Mon, 20 Apr 2020 11:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382979;
        bh=1lK7Nv+RtwIzGIhaOx8/3uzzwvG4vYmSZoXBSNpt4jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KAl9sy47ije0S42EB0m8hATis22mSbphc8aqUXSpefBu0MaNiyFciLiBNezLIM98a
         SFElTZzoyuqNNjkF5zblPF/l6X8N2tkApEIgUz15Ce+21oorGGF3+W5+Pv3BMIGTAl
         KAlTTa5+9Lgl8lcku8KUWg4P39Nu5S1m9AptTU1s=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 22/24] net/mlx5: Update port.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:34 +0300
Message-Id: <20200420114136.264924-23-leon@kernel.org>
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

Do mass update of port.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index cc262b30aed5..9f829e68fc73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -763,24 +763,23 @@ EXPORT_SYMBOL_GPL(mlx5_query_port_ets_rate_limit);
 
 int mlx5_set_port_wol(struct mlx5_core_dev *mdev, u8 wol_mode)
 {
-	u32 in[MLX5_ST_SZ_DW(set_wol_rol_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(set_wol_rol_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(set_wol_rol_in)] = {};
 
 	MLX5_SET(set_wol_rol_in, in, opcode, MLX5_CMD_OP_SET_WOL_ROL);
 	MLX5_SET(set_wol_rol_in, in, wol_mode_valid, 1);
 	MLX5_SET(set_wol_rol_in, in, wol_mode, wol_mode);
-	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(mdev, set_wol_rol, in);
 }
 EXPORT_SYMBOL_GPL(mlx5_set_port_wol);
 
 int mlx5_query_port_wol(struct mlx5_core_dev *mdev, u8 *wol_mode)
 {
-	u32 in[MLX5_ST_SZ_DW(query_wol_rol_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(query_wol_rol_out)] = {0};
+	u32 out[MLX5_ST_SZ_DW(query_wol_rol_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_wol_rol_in)] = {};
 	int err;
 
 	MLX5_SET(query_wol_rol_in, in, opcode, MLX5_CMD_OP_QUERY_WOL_ROL);
-	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(mdev, query_wol_rol, in, out);
 	if (!err)
 		*wol_mode = MLX5_GET(query_wol_rol_out, out, wol_mode);
 
-- 
2.25.2

