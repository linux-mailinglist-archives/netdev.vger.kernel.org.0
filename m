Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D7F1B07B7
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgDTLm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTLm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:27 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD64F21744;
        Mon, 20 Apr 2020 11:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382946;
        bh=B9Ga07rwasCFMikckbkf9iUtVld5Ruirr2xyFO+TKPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIg2u9Ywu38/ZUUT++3oEKQ8DWSRTHSWb6ydMHUfslyqC5Y9AaRhWpj+A7i1xA6+M
         DIlbE4f+EIDJ+N7mrzPU0z58Vxk7WzNnNs1wyFlFXwJy5+kIBesGfo6Ms+uwXSPf+2
         IysdU/Sv/ecy8rmj+36M5HLV+XlLfmU3DjCNLKeU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 13/24] net/mlx5: Update mpfs.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:25 +0300
Message-Id: <20200420114136.264924-14-leon@kernel.org>
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

Do mass update of mpfs.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
index 3118e8d66407..fd8449ff9e17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
@@ -40,8 +40,7 @@
 /* HW L2 Table (MPFS) management */
 static int set_l2table_entry_cmd(struct mlx5_core_dev *dev, u32 index, u8 *mac)
 {
-	u32 in[MLX5_ST_SZ_DW(set_l2_table_entry_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(set_l2_table_entry_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(set_l2_table_entry_in)] = {};
 	u8 *in_mac_addr;
 
 	MLX5_SET(set_l2_table_entry_in, in, opcode, MLX5_CMD_OP_SET_L2_TABLE_ENTRY);
@@ -50,17 +49,16 @@ static int set_l2table_entry_cmd(struct mlx5_core_dev *dev, u32 index, u8 *mac)
 	in_mac_addr = MLX5_ADDR_OF(set_l2_table_entry_in, in, mac_address);
 	ether_addr_copy(&in_mac_addr[2], mac);
 
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, set_l2_table_entry, in);
 }
 
 static int del_l2table_entry_cmd(struct mlx5_core_dev *dev, u32 index)
 {
-	u32 in[MLX5_ST_SZ_DW(delete_l2_table_entry_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(delete_l2_table_entry_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(delete_l2_table_entry_in)] = {};
 
 	MLX5_SET(delete_l2_table_entry_in, in, opcode, MLX5_CMD_OP_DELETE_L2_TABLE_ENTRY);
 	MLX5_SET(delete_l2_table_entry_in, in, table_index, index);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, delete_l2_table_entry, in);
 }
 
 /* UC L2 table hash node */
-- 
2.25.2

