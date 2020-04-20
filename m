Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE36B1B07B5
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgDTLmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTLmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:23 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17D9121744;
        Mon, 20 Apr 2020 11:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382942;
        bh=y9aNNmd2bqYZUtvuidS2zLELX5Dvs8o+bARSGSem6jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2t2lseI8SI0BqhdYBMVu7kVcvBhz2cOkaajNstGdRzEZBmuplZVzRrCrhma7OL0UA
         lyC6l4pIog7AohGuYzZT64kIQsWDm/VDrLyv4JZ3EW9SBwcPeBa7If4fWR32jP7xpY
         uMz9I40cV6MCFvKuM7X4eORTtxrz60VvfeC+Ge0M=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 12/24] net/mlx5: Update gid.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:24 +0300
Message-Id: <20200420114136.264924-13-leon@kernel.org>
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

Do mass update of gid.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
index 7722a3f9bb68..a68738c8f4bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
@@ -124,8 +124,7 @@ int mlx5_core_roce_gid_set(struct mlx5_core_dev *dev, unsigned int index,
 			   const u8 *mac, bool vlan, u16 vlan_id, u8 port_num)
 {
 #define MLX5_SET_RA(p, f, v) MLX5_SET(roce_addr_layout, p, f, v)
-	u32  in[MLX5_ST_SZ_DW(set_roce_address_in)] = {0};
-	u32 out[MLX5_ST_SZ_DW(set_roce_address_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(set_roce_address_in)] = {};
 	void *in_addr = MLX5_ADDR_OF(set_roce_address_in, in, roce_address);
 	char *addr_l3_addr = MLX5_ADDR_OF(roce_addr_layout, in_addr,
 					  source_l3_address);
@@ -153,6 +152,6 @@ int mlx5_core_roce_gid_set(struct mlx5_core_dev *dev, unsigned int index,
 
 	MLX5_SET(set_roce_address_in, in, roce_address_index, index);
 	MLX5_SET(set_roce_address_in, in, opcode, MLX5_CMD_OP_SET_ROCE_ADDRESS);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(dev, set_roce_address, in);
 }
 EXPORT_SYMBOL(mlx5_core_roce_gid_set);
-- 
2.25.2

