Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8E12BB997
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgKTXEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:04:14 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1195 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728637AbgKTXEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:04:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b5f0008>; Fri, 20 Nov 2020 15:03:59 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:04:02 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: [PATCH mlx5-next 11/16] net/mlx5: Add VDPA priority to NIC RX namespace
Date:   Fri, 20 Nov 2020 15:03:34 -0800
Message-ID: <20201120230339.651609-12-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120230339.651609-1-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605913439; bh=eg0ty2XIBWAlcNzqBJzl8yq+DWBoIz5UKxtR3ZdS74M=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=OsJxFjtvMm5GvaL8HMu3oUpp4zdkx/I0kYXI3Rees8TTUjDMAZ1aSi8/BFrssdQ9D
         O9iyDm6ivz4kS+a/SWPIITzdOY2mQq4c5VgTHPEjqg2THzNuluXhTkscUyGlax95px
         CL86dl5dfqDID1VXuDIarL2s0JE+wWZqX/WCPCJEpRhnX+lgebwo9yFDvWYb8Nxkjr
         kcg1g+GawqQc8ef0nyMtChWvyL8vQn8I/1MFWQjSt4rEU8dZeHuGaKvfxaj7YzZiSH
         9zaGbe63WOt6Q5+5fU1t+auvIql2MgDvGQWD4ZvqCSFW1GOOAt3SgAhI2VKGnUGg68
         aimzxH+/S+fdQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Add a new namespace type to the NIC RX root namespace to allow for
inserting VDPA rules before regular NIC but after bypass, thus allowing
DPDK to have precedence in packet processing.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 10 +++++++++-
 include/linux/mlx5/fs.h                           |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 16091838bfcf..e095c5968e67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -118,6 +118,10 @@
 #define ANCHOR_NUM_PRIOS 1
 #define ANCHOR_MIN_LEVEL (BY_PASS_MIN_LEVEL + 1)
=20
+#define VDPA_PRIO_NUM_LEVELS 1
+#define VDPA_NUM_PRIOS 1
+#define VDPA_MIN_LEVEL 1
+
 #define OFFLOADS_MAX_FT 2
 #define OFFLOADS_NUM_PRIOS 2
 #define OFFLOADS_MIN_LEVEL (ANCHOR_MIN_LEVEL + OFFLOADS_NUM_PRIOS)
@@ -147,7 +151,7 @@ static struct init_tree_node {
 	enum mlx5_flow_table_miss_action def_miss_action;
 } root_fs =3D {
 	.type =3D FS_TYPE_NAMESPACE,
-	.ar_size =3D 7,
+	.ar_size =3D 8,
 	  .children =3D (struct init_tree_node[]){
 		  ADD_PRIO(0, BY_PASS_MIN_LEVEL, 0, FS_CHAINING_CAPS,
 			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
@@ -165,6 +169,10 @@ static struct init_tree_node {
 			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				  ADD_MULTIPLE_PRIO(ETHTOOL_NUM_PRIOS,
 						    ETHTOOL_PRIO_NUM_LEVELS))),
+		  ADD_PRIO(0, VDPA_MIN_LEVEL, 0, FS_CHAINING_CAPS,
+			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
+				  ADD_MULTIPLE_PRIO(VDPA_NUM_PRIOS,
+						    VDPA_PRIO_NUM_LEVELS))),
 		  ADD_PRIO(0, KERNEL_MIN_LEVEL, 0, {},
 			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				  ADD_MULTIPLE_PRIO(KERNEL_NIC_TC_NUM_PRIOS,
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 35d2cc1646d3..97176d623d74 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -67,6 +67,7 @@ enum mlx5_flow_namespace_type {
 	MLX5_FLOW_NAMESPACE_LAG,
 	MLX5_FLOW_NAMESPACE_OFFLOADS,
 	MLX5_FLOW_NAMESPACE_ETHTOOL,
+	MLX5_FLOW_NAMESPACE_VDPA,
 	MLX5_FLOW_NAMESPACE_KERNEL,
 	MLX5_FLOW_NAMESPACE_LEFTOVERS,
 	MLX5_FLOW_NAMESPACE_ANCHOR,
--=20
2.26.2

