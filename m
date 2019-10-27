Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F41DE6317
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 15:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfJ0Oja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 10:39:30 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40687 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726674AbfJ0Oj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 10:39:29 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 Oct 2019 16:39:27 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.134.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9REdRUH019598;
        Sun, 27 Oct 2019 16:39:27 +0200
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net] net/mlx4_core: Dynamically set guaranteed amount of counters per VF
Date:   Sun, 27 Oct 2019 16:39:15 +0200
Message-Id: <20191027143915.5232-1-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Prior to this patch, the amount of counters guaranteed per VF in the
resource tracker was MLX4_VF_COUNTERS_PER_PORT * MLX4_MAX_PORTS. It was
set regardless if the VF was single or dual port.
This caused several VFs to have no guaranteed counters although the
system could satisfy their request.

The fix is to dynamically guarantee counters, based on each VF
specification.

Fixes: 9de92c60beaa ("net/mlx4_core: Adjust counter grant policy in the resource tracker")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 .../ethernet/mellanox/mlx4/resource_tracker.c | 42 ++++++++++++-------
 1 file changed, 26 insertions(+), 16 deletions(-)

Please queue to -stable >= v4.2.

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 4356f3a58002..1187ef1375e2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -471,12 +471,31 @@ void mlx4_init_quotas(struct mlx4_dev *dev)
 		priv->mfunc.master.res_tracker.res_alloc[RES_MPT].quota[pf];
 }
 
-static int get_max_gauranteed_vfs_counter(struct mlx4_dev *dev)
+static int
+mlx4_calc_res_counter_guaranteed(struct mlx4_dev *dev,
+				 struct resource_allocator *res_alloc,
+				 int vf)
 {
-	/* reduce the sink counter */
-	return (dev->caps.max_counters - 1 -
-		(MLX4_PF_COUNTERS_PER_PORT * MLX4_MAX_PORTS))
-		/ MLX4_MAX_PORTS;
+	struct mlx4_active_ports actv_ports;
+	int ports, counters_guaranteed;
+
+	/* For master, only allocate according to the number of phys ports */
+	if (vf == mlx4_master_func_num(dev))
+		return MLX4_PF_COUNTERS_PER_PORT * dev->caps.num_ports;
+
+	/* calculate real number of ports for the VF */
+	actv_ports = mlx4_get_active_ports(dev, vf);
+	ports = bitmap_weight(actv_ports.ports, dev->caps.num_ports);
+	counters_guaranteed = ports * MLX4_VF_COUNTERS_PER_PORT;
+
+	/* If we do not have enough counters for this VF, do not
+	 * allocate any for it. '-1' to reduce the sink counter.
+	 */
+	if ((res_alloc->res_reserved + counters_guaranteed) >
+	    (dev->caps.max_counters - 1))
+		return 0;
+
+	return counters_guaranteed;
 }
 
 int mlx4_init_resource_tracker(struct mlx4_dev *dev)
@@ -484,7 +503,6 @@ int mlx4_init_resource_tracker(struct mlx4_dev *dev)
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	int i, j;
 	int t;
-	int max_vfs_guarantee_counter = get_max_gauranteed_vfs_counter(dev);
 
 	priv->mfunc.master.res_tracker.slave_list =
 		kcalloc(dev->num_slaves, sizeof(struct slave_list),
@@ -603,16 +621,8 @@ int mlx4_init_resource_tracker(struct mlx4_dev *dev)
 				break;
 			case RES_COUNTER:
 				res_alloc->quota[t] = dev->caps.max_counters;
-				if (t == mlx4_master_func_num(dev))
-					res_alloc->guaranteed[t] =
-						MLX4_PF_COUNTERS_PER_PORT *
-						MLX4_MAX_PORTS;
-				else if (t <= max_vfs_guarantee_counter)
-					res_alloc->guaranteed[t] =
-						MLX4_VF_COUNTERS_PER_PORT *
-						MLX4_MAX_PORTS;
-				else
-					res_alloc->guaranteed[t] = 0;
+				res_alloc->guaranteed[t] =
+					mlx4_calc_res_counter_guaranteed(dev, res_alloc, t);
 				break;
 			default:
 				break;
-- 
2.21.0

