Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0531B07A3
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgDTLl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTLl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:41:57 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 499D021473;
        Mon, 20 Apr 2020 11:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382917;
        bh=NClxMV5TJF9NIFrSO+nmB+zvGA3g9zWAMe9u+2ahcWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0zwA4Z0fFe04n2pek3nmyZBvDUTOV3QGQNXinkDZ0yjPl1xSM3CcssbnRpJnkcTgX
         buD/MTHJa8RFi8bv36Tke5MZApaYye45ppnfIsT6rqYclVxCYir/237qcggLMMwwPP
         T8idJ7hdZnScuGwFlxNfWYuWsglM8bWM+DBurmxQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 05/24] net/mlx5: Update eq.c to new cmd interface
Date:   Mon, 20 Apr 2020 14:41:17 +0300
Message-Id: <20200420114136.264924-6-leon@kernel.org>
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

Do mass update of eq.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index bee419d01af2..4d974b5405b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -101,12 +101,11 @@ struct mlx5_eq_table {
 
 static int mlx5_cmd_destroy_eq(struct mlx5_core_dev *dev, u8 eqn)
 {
-	u32 out[MLX5_ST_SZ_DW(destroy_eq_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(destroy_eq_in)]   = {0};
+	u32 in[MLX5_ST_SZ_DW(destroy_eq_in)] = {};
 
 	MLX5_SET(destroy_eq_in, in, opcode, MLX5_CMD_OP_DESTROY_EQ);
 	MLX5_SET(destroy_eq_in, in, eq_number, eqn);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, destroy_eq, in);
 }
 
 /* caller must eventually call mlx5_cq_put on the returned cq */
-- 
2.25.2

