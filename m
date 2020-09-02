Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3D925AF0A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgIBPdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:33:07 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52313 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728378AbgIBPch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 11:32:37 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with SMTP; 2 Sep 2020 18:32:29 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.234.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 082FWTlq014707;
        Wed, 2 Sep 2020 18:32:29 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id 082FWTDo026695;
        Wed, 2 Sep 2020 18:32:29 +0300
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 082FWTjE026694;
        Wed, 2 Sep 2020 18:32:29 +0300
From:   Aya Levin <ayal@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        linux-kernel@vger.kernel.org, Aya Levin <ayal@mellanox.com>
Subject: [PATCH net-next RFC v1 4/4] net/mlx5e: Add devlink trap to catch oversize packets
Date:   Wed,  2 Sep 2020 18:32:14 +0300
Message-Id: <1599060734-26617-5-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
References: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register MTU error trap to allow visibility of oversize packets. Display
a naive use of devlink trap in devlink port context.

Signed-off-by: Aya Levin <ayal@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  2 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/traps.c | 32 +++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/traps.h | 13 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 41 ++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 11 ++++--
 6 files changed, 98 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/traps.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/traps.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 94268a697e1c..78e2e9107986 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -25,7 +25,7 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
 		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/umem.o \
-		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o
+		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o en/traps.o
 
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0cc2080fd847..7e5581ed9311 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -814,6 +814,8 @@ struct mlx5e_priv {
 	struct mlx5e_hv_vhca_stats_agent stats_agent;
 #endif
 	struct mlx5e_scratchpad    scratchpad;
+	void *trap_mtu;
+	bool trap_oversize;
 };
 
 struct mlx5e_rx_handlers {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/traps.c b/drivers/net/ethernet/mellanox/mlx5/core/en/traps.c
new file mode 100644
index 000000000000..e365e8dbd6ff
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/traps.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Mellanox Technologies.
+#include "en.h"
+#include "traps.h"
+#include <linux/kernel.h>
+#include <uapi/linux/devlink.h>
+
+#define MLX5E_TRAP(_id, _group_id)                                      \
+	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,                           \
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id, \
+			     DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT)
+static struct devlink_trap mlx5e_traps_arr[] = {
+	MLX5E_TRAP(MTU_ERROR, L2_DROPS),
+};
+
+int mlx5e_devlink_traps_create(struct mlx5e_priv *priv)
+{
+	struct devlink_port *dl_port = &priv->dl_port;
+
+	return devlink_port_traps_register(dl_port, mlx5e_traps_arr,
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/traps.h b/drivers/net/ethernet/mellanox/mlx5/core/en/traps.h
new file mode 100644
index 000000000000..14a32b6968ee
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/traps.h
@@ -0,0 +1,13 @@
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
+
+#endif
+
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index aebcf73f8546..056f34326b3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -64,6 +64,7 @@
 #include "en/hv_vhca_stats.h"
 #include "en/devlink.h"
 #include "lib/mlx5.h"
+#include "en/traps.h"
 
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
@@ -4976,6 +4977,43 @@ void mlx5e_destroy_q_counters(struct mlx5e_priv *priv)
 	}
 }
 
+static int mlx5e_devlink_trap_init(struct devlink *devlink,
+				   const struct devlink_trap *trap,
+				   void *trap_ctx)
+{
+	struct mlx5e_priv *priv = (struct mlx5e_priv *)devlink_trap_ctx_priv(trap_ctx);
+
+	priv->trap_mtu = trap_ctx;
+	return 0;
+}
+
+static void mlx5e_devlink_trap_fini(struct devlink *devlink,
+				    const struct devlink_trap *trap,
+				    void *trap_ctx)
+{
+	struct mlx5e_priv *priv = (struct mlx5e_priv *)devlink_trap_ctx_priv(trap_ctx);
+
+	priv->trap_mtu = NULL;
+}
+
+static int mlx5e_devlink_trap_action_set(struct devlink *devlink,
+					 const struct devlink_trap *trap,
+					 enum devlink_trap_action action,
+					 void *trap_ctx,
+					 struct netlink_ext_ack *extack)
+{
+	struct mlx5e_priv *priv = (struct mlx5e_priv *)devlink_trap_ctx_priv(trap_ctx);
+
+	priv->trap_oversize = !!action;
+	return 0;
+}
+
+static const struct devlink_trap_ops mlx5e_devlink_traps_ops = {
+	.trap_init		= mlx5e_devlink_trap_init,
+	.trap_fini		= mlx5e_devlink_trap_fini,
+	.trap_action_set	= mlx5e_devlink_trap_action_set,
+};
+
 static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 			  struct net_device *netdev,
 			  const struct mlx5e_profile *profile,
@@ -5005,12 +5043,15 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mdev,
 	if (err)
 		mlx5_core_err(mdev, "mlx5e_devlink_port_register failed, %d\n", err);
 	mlx5e_health_create_reporters(priv);
+	devlink_port_traps_ops(&priv->dl_port, &mlx5e_devlink_traps_ops);
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
index 1e42e27eae26..4fe20a6e6d6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1437,6 +1437,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
 	struct mlx5e_dma_info *di = &wi->umr.dma_info[page_idx];
+	struct mlx5e_priv *priv = rq->channel->priv;
 	u16 rx_headroom = rq->buff.headroom;
 	u32 cqe_bcnt32 = cqe_bcnt;
 	struct xdp_buff xdp;
@@ -1444,11 +1445,14 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
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
@@ -1475,7 +1479,10 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
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

