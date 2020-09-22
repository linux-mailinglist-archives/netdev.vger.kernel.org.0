Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEAE2740FB
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 13:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgIVLfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 07:35:53 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45740 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726654AbgIVLfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 07:35:39 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with SMTP; 22 Sep 2020 14:35:35 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.234.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08MBZZaE014369;
        Tue, 22 Sep 2020 14:35:35 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id 08MBZZVu009509;
        Tue, 22 Sep 2020 14:35:35 +0300
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 08MBZZi5009508;
        Tue, 22 Sep 2020 14:35:35 +0300
From:   Aya Levin <ayal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        netdev <netdev@vger.kernel.org>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Aya Levin <ayal@mellanox.com>
Subject: [PATCH net-next RFC v2 repost 3/3] net/mlx5e: Add devlink
Date:   Tue, 22 Sep 2020 14:35:25 +0300
Message-Id: <1600774525-9461-4-git-send-email-ayal@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1600774525-9461-1-git-send-email-ayal@nvidia.com>
References: <1600774525-9461-1-git-send-email-ayal@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Register MTU error trap to allow visibility of oversize packets. Display
a naive use of devlink trap in devlink port context.

Signed-off-by: Aya Levin <ayal@mellanox.com>
---
Changelog:
v1->v2:
-Minor changes in trap's definition
-Adjustments to trap API and ops

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en/traps.c | 38 +++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/traps.h | 14 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 48 ++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 11 ++++-
 6 files changed, 112 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/traps.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/traps.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 9826a041e407..32436325725c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -25,7 +25,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/pool.o \
-		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o
+		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o en/traps.o
 
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0df40d24acb0..6e652a513a84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -824,6 +824,8 @@ struct mlx5e_priv {
 	struct mlx5e_hv_vhca_stats_agent stats_agent;
 #endif
 	struct mlx5e_scratchpad    scratchpad;
+	bool trap_oversize;
+	void *trap_mtu;
 };
 
 struct mlx5e_rx_handlers {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/traps.c b/drivers/net/ethernet/mellanox/mlx5/core/en/traps.c
new file mode 100644
index 000000000000..211407666c3a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/traps.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Mellanox Technologies.
+#include "traps.h"
+
+#define MLX5E_TRAP(_id, _type, _group_id)                               \
+	DEVLINK_TRAP_GENERIC(_type, DROP, _id,                          \
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id, \
+			     DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT)
+static struct devlink_trap mlx5e_traps_arr[] = {
+	MLX5E_TRAP(MTU_ERROR, EXCEPTION, L2_DROPS),
+};
+
+int mlx5e_devlink_traps_create(struct mlx5e_priv *priv)
+{
+	struct devlink_port *dl_port = &priv->dl_port;
+
+	return  devlink_port_traps_register(dl_port, mlx5e_traps_arr,
+					   ARRAY_SIZE(mlx5e_traps_arr),
+					   priv);
+}
+
+void mlx5e_devlink_traps_destroy(struct mlx5e_priv *priv)
+{
+	struct devlink_port *dl_port = &priv->dl_port;
+
+	devlink_port_traps_unregister(dl_port, mlx5e_traps_arr,
+				      ARRAY_SIZE(mlx5e_traps_arr));
+}
+
+struct devlink_trap *mlx5e_trap_lookup(u16 id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mlx5e_traps_arr); i++)
+		if (mlx5e_traps_arr[i].id == id)
+			return &mlx5e_traps_arr[i];
+	return NULL;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/traps.h b/drivers/net/ethernet/mellanox/mlx5/core/en/traps.h
new file mode 100644
index 000000000000..7d95cd4b571c
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/traps.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020 Mellanox Technologies.*/
+
+#ifndef __MLX5E_EN_TRAPS_H
+#define __MLX5E_EN_TRAPS_H
+
+#include "en.h"
+
+int mlx5e_devlink_traps_create(struct mlx5e_priv *priv);
+void mlx5e_devlink_traps_destroy(struct mlx5e_priv *priv);
+struct devlink_trap *mlx5e_trap_lookup(u16 id);
+
+#endif
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 472252ea67a1..81d1e6186bb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -64,6 +64,7 @@
 #include "en/hv_vhca_stats.h"
 #include "en/devlink.h"
 #include "lib/mlx5.h"
+#include "en/traps.h"
 
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
@@ -5003,6 +5004,50 @@ void mlx5e_destroy_q_counters(struct mlx5e_priv *priv)
 	}
 }
 
+static int mlx5e_devlink_trap_init(struct devlink_port *devlink_port,
+				   const struct devlink_trap *trap,
+				   void *trap_ctx)
+{
+	struct mlx5e_priv *priv = (struct mlx5e_priv *)devlink_trap_ctx_priv(trap_ctx);
+
+	if (!mlx5e_trap_lookup(trap->id))
+		return -EINVAL;
+	priv->trap_oversize = false;
+	priv->trap_mtu = trap_ctx;
+	return 0;
+}
+
+static void mlx5e_devlink_trap_fini(struct devlink_port *devlink_port,
+				    const struct devlink_trap *trap,
+				    void *trap_ctx)
+{
+	struct mlx5e_priv *priv = (struct mlx5e_priv *)devlink_trap_ctx_priv(trap_ctx);
+
+	if (!mlx5e_trap_lookup(trap->id))
+		return;
+	priv->trap_oversize = false;
+	priv->trap_mtu = NULL;
+}
+
+static int mlx5e_devlink_trap_action_set(struct devlink_port *devlink_port,
+					 const struct devlink_trap *trap,
+					 enum devlink_trap_action action,
+					 struct netlink_ext_ack *extack)
+{
+	struct mlx5e_priv *priv = container_of(devlink_port, struct mlx5e_priv, dl_port);
+
+	if (!mlx5e_trap_lookup(trap->id))
+		return -EINVAL;
+	priv->trap_oversize = !!action;
+	return 0;
+}
+
+static const struct devlink_port_ops mlx5e_devlink_port_ops = {
+	.trap_init		= mlx5e_devlink_trap_init,
+	.trap_fini		= mlx5e_devlink_trap_fini,
+	.trap_action_set	= mlx5e_devlink_trap_action_set,
+};
+
 static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 			  struct net_device *netdev,
 			  const struct mlx5e_profile *profile,
@@ -5032,12 +5077,15 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	if (err)
 		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
 	mlx5e_health_create_reporters(priv);
+	devlink_port_set_ops(&priv->dl_port, &mlx5e_devlink_port_ops);
+	mlx5e_devlink_traps_create(priv);
 
 	return 0;
 }
 
 static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
+	mlx5e_devlink_traps_destroy(priv);
 	mlx5e_health_destroy_reporters(priv);
 	mlx5e_devlink_port_unregister(priv);
 	mlx5e_tls_cleanup(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 85d545bb47be..ec2fd39a57d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1445,6 +1445,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
 	struct mlx5e_dma_info *di = &wi->umr.dma_info[page_idx];
+	struct mlx5e_priv *priv = rq->channel->priv;
 	u16 rx_headroom = rq->buff.headroom;
 	u32 cqe_bcnt32 = cqe_bcnt;
 	struct xdp_buff xdp;
@@ -1452,11 +1453,14 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	void *va, *data;
 	u32 frag_size;
 	bool consumed;
+	bool trap;
 
 	/* Check packet size. Note LRO doesn't use linear SKB */
 	if (unlikely(cqe_bcnt > rq->hw_mtu)) {
 		rq->stats->oversize_pkts_sw_drop++;
-		return NULL;
+		if (!priv->trap_oversize)
+			return NULL;
+		trap = true;
 	}
 
 	va             = page_address(di->page) + head_offset;
@@ -1483,7 +1487,10 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt32);
 	if (unlikely(!skb))
 		return NULL;
-
+	if (trap) {
+		devlink_port_trap_report(&priv->dl_port, skb, priv->trap_mtu, NULL);
+		return NULL;
+	}
 	/* queue up for recycling/reuse */
 	page_ref_inc(di->page);
 
-- 
2.14.1

