Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC151B07CC
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgDTLmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgDTLmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:42:52 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B89F821473;
        Mon, 20 Apr 2020 11:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382972;
        bh=pef/WsXoUdnUjbtEIc8a/IVelgb3ZdP9VYl8PY8OlV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugg9sKI6EhiJiBtep20uKtuXdqw0mPgsmNpUbe2Sycwaf3JSO6POEgwYpDEiGwfAk
         oEJ6Tyx1Dlz1yAvxUupzv7Xy5wewQlFp3OVLW7omRousrkviWZlVvS5d54SldtKIhW
         zLq8GJxd/TDsrC5ficF0d5nUyjCyzc2fhnVzYRGA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 14/24] net/mlx5: Update vxlan.c new cmd interface
Date:   Mon, 20 Apr 2020 14:41:26 +0300
Message-Id: <20200420114136.264924-15-leon@kernel.org>
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

Do mass update of vxlan.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
index 148b55c3db7a..82c766a95165 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
@@ -60,24 +60,22 @@ static inline u8 mlx5_vxlan_max_udp_ports(struct mlx5_core_dev *mdev)
 
 static int mlx5_vxlan_core_add_port_cmd(struct mlx5_core_dev *mdev, u16 port)
 {
-	u32 in[MLX5_ST_SZ_DW(add_vxlan_udp_dport_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(add_vxlan_udp_dport_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(add_vxlan_udp_dport_in)] = {};
 
 	MLX5_SET(add_vxlan_udp_dport_in, in, opcode,
 		 MLX5_CMD_OP_ADD_VXLAN_UDP_DPORT);
 	MLX5_SET(add_vxlan_udp_dport_in, in, vxlan_udp_port, port);
-	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(mdev, add_vxlan_udp_dport, in);
 }
 
 static int mlx5_vxlan_core_del_port_cmd(struct mlx5_core_dev *mdev, u16 port)
 {
-	u32 in[MLX5_ST_SZ_DW(delete_vxlan_udp_dport_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(delete_vxlan_udp_dport_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(delete_vxlan_udp_dport_in)] = {};
 
 	MLX5_SET(delete_vxlan_udp_dport_in, in, opcode,
 		 MLX5_CMD_OP_DELETE_VXLAN_UDP_DPORT);
 	MLX5_SET(delete_vxlan_udp_dport_in, in, vxlan_udp_port, port);
-	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(mdev, delete_vxlan_udp_dport, in);
 }
 
 static struct mlx5_vxlan_port*
-- 
2.25.2

