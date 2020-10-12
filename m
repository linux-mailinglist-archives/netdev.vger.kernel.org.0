Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D39528C4DD
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 00:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbgJLWmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 18:42:19 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9860 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730671AbgJLWmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 18:42:19 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f84db580000>; Mon, 12 Oct 2020 15:40:24 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 22:42:12 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Huy Nguyen" <huyn@mellanox.com>, Raed Salem <raeds@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 2/4] net/mlx5: Add NIC TX domain namespace
Date:   Mon, 12 Oct 2020 15:41:50 -0700
Message-ID: <20201012224152.191479-3-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012224152.191479-1-saeedm@nvidia.com>
References: <20201012224152.191479-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602542424; bh=8+JPL1qD+zfbcpL5F6LOqwcza2DvkEHE7UbP+oRSukI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=QvRUAgMgPNyNANSgg77l6PUDdacn7ui2EYk/XM6XPqQ5hn5ZSfEj1GXA1pRM6yg+v
         vrYNnLfI7Iad2hWKObdht3+y/LtS3sNcSJ2eW98bjF8EiKe1gqb47XUw+Ro0gDn+wU
         qETvPpgQDIrHIMRCY9AGHEAqs6sg4yLWd9ilz28L4x86teTV70he4EFr80j0ucDLXt
         qoSzZ3q5zR/8Ff4TqEEgTNv7Gip6/QhxK6rQsW7gUdds5oMEqJq6cEWcqmPXkdB46x
         QrAAN65Tp3RrePzV3dRWeQs661bgjg6mwOSOhdw6bQVYPa0jP8UOU8ziDi8akPae7h
         8f8rTnKqsRYvQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

Add new namespace that represents the NIC TX domain.

Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  1 +
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  3 +++
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 19 ++++++++++++++++++-
 include/linux/mlx5/fs.h                       |  1 +
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en/fs.h
index 6a97452dc60e..dc744702aee4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -236,6 +236,7 @@ struct mlx5e_accel_fs_tcp;
=20
 struct mlx5e_flow_steering {
 	struct mlx5_flow_namespace      *ns;
+	struct mlx5_flow_namespace      *egress_ns;
 #ifdef CONFIG_MLX5_EN_RXNFC
 	struct mlx5e_ethtool_steering   ethtool;
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net=
/ethernet/mellanox/mlx5/core/fs_cmd.c
index fee169732de7..babe3405132a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -776,6 +776,9 @@ static int mlx5_cmd_modify_header_alloc(struct mlx5_flo=
w_root_namespace *ns,
 		table_type =3D FS_FT_NIC_RX;
 		break;
 	case MLX5_FLOW_NAMESPACE_EGRESS:
+#ifdef CONFIG_MLX5_IPSEC
+	case MLX5_FLOW_NAMESPACE_EGRESS_KERNEL:
+#endif
 		max_actions =3D MLX5_CAP_FLOWTABLE_NIC_TX(dev, max_modify_header_actions=
);
 		table_type =3D FS_FT_NIC_TX;
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 6141e9ec8190..16091838bfcf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -126,6 +126,10 @@
 #define LAG_NUM_PRIOS 1
 #define LAG_MIN_LEVEL (OFFLOADS_MIN_LEVEL + 1)
=20
+#define KERNEL_TX_IPSEC_NUM_PRIOS  1
+#define KERNEL_TX_IPSEC_NUM_LEVELS 1
+#define KERNEL_TX_MIN_LEVEL        (KERNEL_TX_IPSEC_NUM_LEVELS)
+
 struct node_caps {
 	size_t	arr_sz;
 	long	*caps;
@@ -180,13 +184,24 @@ static struct init_tree_node {
=20
 static struct init_tree_node egress_root_fs =3D {
 	.type =3D FS_TYPE_NAMESPACE,
+#ifdef CONFIG_MLX5_IPSEC
+	.ar_size =3D 2,
+#else
 	.ar_size =3D 1,
+#endif
 	.children =3D (struct init_tree_node[]) {
 		ADD_PRIO(0, MLX5_BY_PASS_NUM_PRIOS, 0,
 			 FS_CHAINING_CAPS_EGRESS,
 			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				ADD_MULTIPLE_PRIO(MLX5_BY_PASS_NUM_PRIOS,
 						  BY_PASS_PRIO_NUM_LEVELS))),
+#ifdef CONFIG_MLX5_IPSEC
+		ADD_PRIO(0, KERNEL_TX_MIN_LEVEL, 0,
+			 FS_CHAINING_CAPS_EGRESS,
+			 ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				ADD_MULTIPLE_PRIO(KERNEL_TX_IPSEC_NUM_PRIOS,
+						  KERNEL_TX_IPSEC_NUM_LEVELS))),
+#endif
 	}
 };
=20
@@ -2165,8 +2180,10 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(=
struct mlx5_core_dev *dev,
 		break;
 	}
=20
-	if (type =3D=3D MLX5_FLOW_NAMESPACE_EGRESS) {
+	if (type =3D=3D MLX5_FLOW_NAMESPACE_EGRESS ||
+	    type =3D=3D MLX5_FLOW_NAMESPACE_EGRESS_KERNEL) {
 		root_ns =3D steering->egress_root_ns;
+		prio =3D type - MLX5_FLOW_NAMESPACE_EGRESS;
 	} else if (type =3D=3D MLX5_FLOW_NAMESPACE_RDMA_RX) {
 		root_ns =3D steering->rdma_rx_root_ns;
 		prio =3D RDMA_RX_BYPASS_PRIO;
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 92d991d93757..846d94ad04bc 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -76,6 +76,7 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_SNIFFER_RX,
 	MLX5_FLOW_NAMESPACE_SNIFFER_TX,
 	MLX5_FLOW_NAMESPACE_EGRESS,
+	MLX5_FLOW_NAMESPACE_EGRESS_KERNEL,
 	MLX5_FLOW_NAMESPACE_RDMA_RX,
 	MLX5_FLOW_NAMESPACE_RDMA_RX_KERNEL,
 	MLX5_FLOW_NAMESPACE_RDMA_TX,
--=20
2.26.2

