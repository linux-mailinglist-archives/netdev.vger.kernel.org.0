Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A182637268
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfFFLGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfFFLGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 07:06:18 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 023E520868;
        Thu,  6 Jun 2019 11:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559819177;
        bh=GNN4BTavBkMWC/h2dlbng8Esd9rfeuF4/BnkZGAgw1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zyd+mAEcuRWuCF1CGNhGBKMNQ8sC2Mro0/BlOYukQn6QkmdcQ7IB1nwZBUeZ/ljGL
         HZ7VS+jsremMcQmXG7onbB30G4XunocFyu2IYaCL31BSyUqCBJ/37+uIXWWqlCxvvV
         B/DZg7IZVhjqOsL2k0CwkE7lk5lt1okCU2IgYLQw=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 2/3] RDMA/mlx5: Consider eswitch encap mode
Date:   Thu,  6 Jun 2019 14:06:08 +0300
Message-Id: <20190606110609.11588-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190606110609.11588-1-leon@kernel.org>
References: <20190606110609.11588-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

When flow steering is created, then the encap support should
consider the eswitch encap mode. If the eswitch flow table (FDB)
supports encap then it shouldn't be supported on NIC RX flow tables.

Fixes: 4adda1122c490 ('RDMA/mlx5: Enable decap and packet reformat on flow tables')
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5fd5db2b397f..70d565283508 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -52,6 +52,7 @@
 #include <linux/mlx5/port.h>
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
+#include <linux/mlx5/eswitch.h>
 #include <linux/list.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
@@ -3247,9 +3248,12 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 	int num_groups;
 	u32 flags = 0;
 	int priority;
+	u8 esw_encap;
 
 	max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
 						       log_max_ft_size));
+	esw_encap = mlx5_eswitch_get_encap_mode(dev->mdev) !=
+		DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 	if (flow_attr->type == IB_FLOW_ATTR_NORMAL) {
 		enum mlx5_flow_namespace_type fn_type;
 
@@ -3262,10 +3266,10 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 		if (ft_type == MLX5_IB_FT_RX) {
 			fn_type = MLX5_FLOW_NAMESPACE_BYPASS;
 			prio = &dev->flow_db->prios[priority];
-			if (!dev->is_rep &&
+			if (!dev->is_rep && !esw_encap &&
 			    MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, decap))
 				flags |= MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
-			if (!dev->is_rep &&
+			if (!dev->is_rep && !esw_encap &&
 			    MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
 					reformat_l3_tunnel_to_l2))
 				flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
@@ -3275,7 +3279,7 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 							      log_max_ft_size));
 			fn_type = MLX5_FLOW_NAMESPACE_EGRESS;
 			prio = &dev->flow_db->egress_prios[priority];
-			if (!dev->is_rep &&
+			if (!dev->is_rep && !esw_encap &&
 			    MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, reformat))
 				flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 		}
@@ -3887,24 +3891,28 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 	int max_table_size = 0;
 	u32 flags = 0;
 	int priority;
+	u8 esw_encap;
 
 	if (mcast)
 		priority = MLX5_IB_FLOW_MCAST_PRIO;
 	else
 		priority = ib_prio_to_core_prio(fs_matcher->priority, false);
 
+	esw_encap = mlx5_eswitch_get_encap_mode(dev->mdev) !=
+		DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 	if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_BYPASS) {
 		max_table_size = BIT(MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
 					log_max_ft_size));
-		if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, decap))
+		if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, decap) && !esw_encap)
 			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
 		if (MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev,
-					      reformat_l3_tunnel_to_l2))
+					      reformat_l3_tunnel_to_l2) &&
+		    !esw_encap)
 			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 	} else if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_EGRESS) {
 		max_table_size = BIT(
 			MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, log_max_ft_size));
-		if (MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, reformat))
+		if (MLX5_CAP_FLOWTABLE_NIC_TX(dev->mdev, reformat) && !esw_encap)
 			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 	} else if (fs_matcher->ns_type == MLX5_FLOW_NAMESPACE_FDB) {
 		max_table_size = BIT(
-- 
2.20.1

