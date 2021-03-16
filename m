Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9D5833E269
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbhCPXvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhCPXvV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC92664F92;
        Tue, 16 Mar 2021 23:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938681;
        bh=zOhw2lHgzqAFSWgCP9TSo/mWxUD//tSyuvdhYxyt/Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtzmStsaZdpsXDsx5wdKCk0cyjQ+HKNg3s4SVXFvOJ2JvDx3RMDYUUwdzrnMb926q
         oFU7CyfKv6+Zk47P0+A9YAjs3dbcguPxCRDr1sbyepg+jhuBR0sEwADhoFe+i3HqP/
         Qamc0dUHpsxcHT6VRg/jeIUK/wmQkBhuWpy8zo4yhYHw9IQf2xzECHKEe/Fe3NQ2Kp
         3BFcpyMxVjI4M2wxJJrPgrWtPo6x1nXXnrkl+XiLHxzLn7ZjTjqKFKzGgQ3wr3Y0+M
         TSLqVs62NCqWKY3fz361aozM+4vHjkJo+D4xLHO4Jk3/1Rgi0kOFC2pXmOLcG4+pJ9
         irCopNflwxVhQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5: Move devlink port from mlx5e priv to mlx5e resources
Date:   Tue, 16 Mar 2021 16:51:08 -0700
Message-Id: <20210316235112.72626-12-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

We re-use the native NIC port net device instance for the Uplink
representor, and the devlink port.
When changing profiles we reset the mlx5e priv but we should still
use the devlink port so move it to mlx5e resources.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h    |  1 -
 .../ethernet/mellanox/mlx5/core/en/devlink.c    | 17 ++++++++++++-----
 .../ethernet/mellanox/mlx5/core/en/devlink.h    |  6 ++++++
 .../mellanox/mlx5/core/en/reporter_rx.c         |  4 +++-
 .../mellanox/mlx5/core/en/reporter_tx.c         |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |  5 ++++-
 include/linux/mlx5/driver.h                     |  1 +
 7 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 7435fe6829b6..4d621d142f76 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -880,7 +880,6 @@ struct mlx5e_priv {
 #endif
 	struct devlink_health_reporter *tx_reporter;
 	struct devlink_health_reporter *rx_reporter;
-	struct devlink_port            dl_port;
 	struct mlx5e_xsk           xsk;
 #if IS_ENABLED(CONFIG_PCI_HYPERV_INTERFACE)
 	struct mlx5e_hv_vhca_stats_agent stats_agent;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
index 054bc2fc0520..765f3064689d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
@@ -19,6 +19,7 @@ int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 	struct devlink *devlink = priv_to_devlink(priv->mdev);
 	struct devlink_port_attrs attrs = {};
 	struct netdev_phys_item_id ppid = {};
+	struct devlink_port *dl_port;
 	unsigned int dl_port_index;
 
 	if (mlx5_core_is_pf(priv->mdev)) {
@@ -36,24 +37,30 @@ int mlx5e_devlink_port_register(struct mlx5e_priv *priv)
 		dl_port_index = mlx5_esw_vport_to_devlink_port_index(priv->mdev, 0);
 	}
 
-	devlink_port_attrs_set(&priv->dl_port, &attrs);
+	dl_port = mlx5e_devlink_get_dl_port(priv);
+	memset(dl_port, 0, sizeof(*dl_port));
+	devlink_port_attrs_set(dl_port, &attrs);
 
-	return devlink_port_register(devlink, &priv->dl_port, dl_port_index);
+	return devlink_port_register(devlink, dl_port, dl_port_index);
 }
 
 void mlx5e_devlink_port_type_eth_set(struct mlx5e_priv *priv)
 {
-	devlink_port_type_eth_set(&priv->dl_port, priv->netdev);
+	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
+
+	devlink_port_type_eth_set(dl_port, priv->netdev);
 }
 
 void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv)
 {
-	devlink_port_unregister(&priv->dl_port);
+	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
+
+	devlink_port_unregister(dl_port);
 }
 
 struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
-	return &priv->dl_port;
+	return mlx5e_devlink_get_dl_port(priv);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
index 83123a801adc..10b50feb9883 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
@@ -12,4 +12,10 @@ void mlx5e_devlink_port_unregister(struct mlx5e_priv *priv);
 void mlx5e_devlink_port_type_eth_set(struct mlx5e_priv *priv);
 struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev);
 
+static inline struct devlink_port *
+mlx5e_devlink_get_dl_port(struct mlx5e_priv *priv)
+{
+	return &priv->mdev->mlx5e_res.dl_port;
+}
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index d80bbd17e5f8..f0a419fc4adf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -4,6 +4,7 @@
 #include "health.h"
 #include "params.h"
 #include "txrx.h"
+#include "devlink.h"
 
 static int mlx5e_query_rq_state(struct mlx5_core_dev *dev, u32 rqn, u8 *state)
 {
@@ -615,9 +616,10 @@ static const struct devlink_health_reporter_ops mlx5_rx_reporter_ops = {
 
 void mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
 {
+	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
 	struct devlink_health_reporter *reporter;
 
-	reporter = devlink_port_health_reporter_create(&priv->dl_port, &mlx5_rx_reporter_ops,
+	reporter = devlink_port_health_reporter_create(dl_port, &mlx5_rx_reporter_ops,
 						       MLX5E_REPORTER_RX_GRACEFUL_PERIOD, priv);
 	if (IS_ERR(reporter)) {
 		netdev_warn(priv->netdev, "Failed to create rx reporter, err = %ld\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index d7275c84313e..db64fa2620c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -3,6 +3,7 @@
 
 #include "health.h"
 #include "en/ptp.h"
+#include "en/devlink.h"
 
 static int mlx5e_wait_for_sq_flush(struct mlx5e_txqsq *sq)
 {
@@ -572,9 +573,10 @@ static const struct devlink_health_reporter_ops mlx5_tx_reporter_ops = {
 
 void mlx5e_reporter_tx_create(struct mlx5e_priv *priv)
 {
+	struct devlink_port *dl_port = mlx5e_devlink_get_dl_port(priv);
 	struct devlink_health_reporter *reporter;
 
-	reporter = devlink_port_health_reporter_create(&priv->dl_port, &mlx5_tx_reporter_ops,
+	reporter = devlink_port_health_reporter_create(dl_port, &mlx5_tx_reporter_ops,
 						       MLX5_REPORTER_TX_GRACEFUL_PERIOD, priv);
 	if (IS_ERR(reporter)) {
 		netdev_warn(priv->netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1f15c6183dc1..b0604b113530 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -52,6 +52,7 @@
 #include "en/health.h"
 #include "en/params.h"
 #include "devlink.h"
+#include "en/devlink.h"
 
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
@@ -1823,6 +1824,7 @@ static void mlx5e_trap_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe
 	struct mlx5e_priv *priv = netdev_priv(rq->netdev);
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
 	struct mlx5e_wqe_frag_info *wi;
+	struct devlink_port *dl_port;
 	struct sk_buff *skb;
 	u32 cqe_bcnt;
 	u16 trap_id;
@@ -1845,7 +1847,8 @@ static void mlx5e_trap_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 	skb_push(skb, ETH_HLEN);
 
-	mlx5_devlink_trap_report(rq->mdev, trap_id, skb, &priv->dl_port);
+	dl_port = mlx5e_devlink_get_dl_port(priv);
+	mlx5_devlink_trap_report(rq->mdev, trap_id, skb, dl_port);
 	dev_kfree_skb_any(skb);
 
 free_wqe:
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 9887181dea5f..f1d0340e46a7 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -650,6 +650,7 @@ struct mlx5e_resources {
 		struct mlx5_core_mkey      mkey;
 		struct mlx5_sq_bfreg       bfreg;
 	} hw_objs;
+	struct devlink_port dl_port;
 };
 
 enum mlx5_sw_icm_type {
-- 
2.30.2

