Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7659298BC0
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 12:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773447AbgJZLTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 07:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1747080AbgJZLTf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 07:19:35 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E7E222460;
        Mon, 26 Oct 2020 11:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603711174;
        bh=ECLdZtZi2ZiOf9v9nodXdxHO9s/+UDT9bsbzqmbZ1B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxOr+Z9qI2rXrmjPgKu6fHJYkS4h8AYdk/UN1r18CGYQGd4G7hZuG9nCQ60iVSdyB
         Q3KVFdRdJKR2dcMcIEJfOcZRP/1Z/OdKF4QulAz1VxwjviDG9j3xFhrvpyVQM4qxpt
         MveqhpaozPeXZCfhf5hg/L+NahN7ubqDQacO3teM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        shiraz.saleem@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH mlx5-next 11/11] RDMA/mlx5: Remove IB representors dead code
Date:   Mon, 26 Oct 2020 13:18:49 +0200
Message-Id: <20201026111849.1035786-12-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201026111849.1035786-1-leon@kernel.org>
References: <20201026111849.1035786-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Delete dead code.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c           | 31 +++++--------------
 drivers/infiniband/hw/mlx5/ib_rep.h           | 31 -------------------
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  4 +--
 3 files changed, 9 insertions(+), 57 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 9810bdd7f3bc..a1a9450ed92c 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -13,7 +13,7 @@ mlx5_ib_set_vport_rep(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	struct mlx5_ib_dev *ibdev;
 	int vport_index;

-	ibdev = mlx5_ib_get_uplink_ibdev(dev->priv.eswitch);
+	ibdev = mlx5_eswitch_uplink_get_proto_dev(dev->priv.eswitch, REP_IB);
 	vport_index = rep->vport_index;

 	ibdev->port[vport_index].rep = rep;
@@ -74,6 +74,11 @@ mlx5_ib_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 	return ret;
 }

+static void *mlx5_ib_rep_to_dev(struct mlx5_eswitch_rep *rep)
+{
+	return rep->rep_data[REP_IB].priv;
+}
+
 static void
 mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 {
@@ -91,40 +96,18 @@ mlx5_ib_vport_rep_unload(struct mlx5_eswitch_rep *rep)
 		__mlx5_ib_remove(dev, dev->profile, MLX5_IB_STAGE_MAX);
 }

-static void *mlx5_ib_vport_get_proto_dev(struct mlx5_eswitch_rep *rep)
-{
-	return mlx5_ib_rep_to_dev(rep);
-}
-
 static const struct mlx5_eswitch_rep_ops rep_ops = {
 	.load = mlx5_ib_vport_rep_load,
 	.unload = mlx5_ib_vport_rep_unload,
-	.get_proto_dev = mlx5_ib_vport_get_proto_dev,
+	.get_proto_dev = mlx5_ib_rep_to_dev,
 };

-struct mlx5_ib_dev *mlx5_ib_get_rep_ibdev(struct mlx5_eswitch *esw,
-					  u16 vport_num)
-{
-	return mlx5_eswitch_get_proto_dev(esw, vport_num, REP_IB);
-}
-
 struct net_device *mlx5_ib_get_rep_netdev(struct mlx5_eswitch *esw,
 					  u16 vport_num)
 {
 	return mlx5_eswitch_get_proto_dev(esw, vport_num, REP_ETH);
 }

-struct mlx5_ib_dev *mlx5_ib_get_uplink_ibdev(struct mlx5_eswitch *esw)
-{
-	return mlx5_eswitch_uplink_get_proto_dev(esw, REP_IB);
-}
-
-struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct mlx5_eswitch *esw,
-					   u16 vport_num)
-{
-	return mlx5_eswitch_vport_rep(esw, vport_num);
-}
-
 struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 						   struct mlx5_ib_sq *sq,
 						   u16 port)
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.h b/drivers/infiniband/hw/mlx5/ib_rep.h
index 93f562735e89..ce1dcb105dbd 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.h
+++ b/drivers/infiniband/hw/mlx5/ib_rep.h
@@ -12,11 +12,6 @@
 extern const struct mlx5_ib_profile raw_eth_profile;

 #ifdef CONFIG_MLX5_ESWITCH
-struct mlx5_ib_dev *mlx5_ib_get_rep_ibdev(struct mlx5_eswitch *esw,
-					  u16 vport_num);
-struct mlx5_ib_dev *mlx5_ib_get_uplink_ibdev(struct mlx5_eswitch *esw);
-struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct mlx5_eswitch *esw,
-					   u16 vport_num);
 int mlx5r_rep_init(void);
 void mlx5r_rep_cleanup(void);
 struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
@@ -25,26 +20,6 @@ struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 struct net_device *mlx5_ib_get_rep_netdev(struct mlx5_eswitch *esw,
 					  u16 vport_num);
 #else /* CONFIG_MLX5_ESWITCH */
-static inline
-struct mlx5_ib_dev *mlx5_ib_get_rep_ibdev(struct mlx5_eswitch *esw,
-					  u16 vport_num)
-{
-	return NULL;
-}
-
-static inline
-struct mlx5_ib_dev *mlx5_ib_get_uplink_ibdev(struct mlx5_eswitch *esw)
-{
-	return NULL;
-}
-
-static inline
-struct mlx5_eswitch_rep *mlx5_ib_vport_rep(struct mlx5_eswitch *esw,
-					   u16 vport_num)
-{
-	return NULL;
-}
-
 static inline int mlx5r_rep_init(void) { return 0; }
 static inline void mlx5r_rep_cleanup(void) {}
 static inline
@@ -62,10 +37,4 @@ struct net_device *mlx5_ib_get_rep_netdev(struct mlx5_eswitch *esw,
 	return NULL;
 }
 #endif
-
-static inline
-struct mlx5_ib_dev *mlx5_ib_rep_to_dev(struct mlx5_eswitch_rep *rep)
-{
-	return rep->rep_data[REP_IB].priv;
-}
 #endif /* __MLX5_IB_REP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 842b6f8ae457..ca65a143e4ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -198,14 +198,14 @@ enum {
 	MLX5_INTERFACE_PROTOCOL_MPIB,
 	MLX5_INTERFACE_PROTOCOL_IB,

-	MLX5_INTERFACE_PROTOCOL_VDPA,
+	MLX5_INTERFACE_PROTOCOL_VNET,
 };

 static const struct mlx5_adev_device {
 	const char *suffix;
 	bool (*is_supported)(struct mlx5_core_dev *dev);
 } mlx5_adev_devices[] = {
-	[MLX5_INTERFACE_PROTOCOL_VDPA] = { .suffix = "vnet",
+	[MLX5_INTERFACE_PROTOCOL_VNET] = { .suffix = "vnet",
 					   .is_supported = &is_vnet_supported },
 	[MLX5_INTERFACE_PROTOCOL_IB] = { .suffix = "rdma",
 					 .is_supported = &is_ib_supported },
--
2.26.2

