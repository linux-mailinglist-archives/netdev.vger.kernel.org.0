Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D70B2A2162
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 21:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbgKAUQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 15:16:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727289AbgKAUQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 15:16:24 -0500
Received: from localhost (host-213-179-129-39.customer.m-online.net [213.179.129.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1A5A22253;
        Sun,  1 Nov 2020 20:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604261783;
        bh=Q9+DNPy01/d6QOTNLTpXmnb96hr2wRSaRSliuVZgSfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HuM41gDsnUSP+oOKwGhvqCR8H8RP66Er0wiLHxdgacfs+Gpf9awx8liietvFpcOOk
         MxaypMf0W+Y5cv14JFrH03yAeA87saQiAmXDqQiSlPJoXafF6nFNnXrVlxihv3dXNz
         hGoki06zj7bh2hXPgvc/ArR1dcSypdVPpu3MfidA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        gregkh <gregkh@linuxfoundation.org>
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
Subject: [PATCH mlx5-next v1 11/11] RDMA/mlx5: Remove IB representors dead code
Date:   Sun,  1 Nov 2020 22:15:42 +0200
Message-Id: <20201101201542.2027568-12-leon@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101201542.2027568-1-leon@kernel.org>
References: <20201101201542.2027568-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Delete dead code.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/ib_rep.c | 31 +++++++----------------------
 drivers/infiniband/hw/mlx5/ib_rep.h | 31 -----------------------------
 2 files changed, 7 insertions(+), 55 deletions(-)

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
--
2.28.0

