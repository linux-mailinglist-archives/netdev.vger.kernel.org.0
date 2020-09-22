Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA00B273773
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbgIVAbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729127AbgIVAbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 20:31:15 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F205E23A9D;
        Tue, 22 Sep 2020 00:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600734675;
        bh=E220evvcOx7MEZQTuN8Z+/EOnQ8BXxluKHns/yAGIi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgKsurMr46cr2lVjLzflGWhPXF42mghxCW/cpvW/14tV22Ck6vKpXnumQ7HGPrCkk
         f34mes6P4ptk4O3tzIoslXEjkTUtYiJYhfzxVTZ7taFn6N9ZdGdHZSuli+TScLXoYy
         VfEShTAqC34vGECyj7RtKUpsNkqoequUxJvOTrOc=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ron Diskin <rondi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 08/15] net/mlx5e: Fix multicast counter not up-to-date in "ip -s"
Date:   Mon, 21 Sep 2020 17:30:54 -0700
Message-Id: <20200922003101.529117-9-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922003101.529117-1-saeed@kernel.org>
References: <20200922003101.529117-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ron Diskin <rondi@mellanox.com>

Currently the FW does not generate events for counters other than error
counters. Unlike ".get_ethtool_stats", ".ndo_get_stats64" (which ip -s
uses) might run in atomic context, while the FW interface is non atomic.
Thus, 'ip' is not allowed to issue FW commands, so it will only display
cached counters in the driver.

Add a SW counter (mcast_packets) in the driver to count rx multicast
packets. The counter also counts broadcast packets, as we consider it a
special case of multicast.
Use the counter value when calling "ip -s"/"ifconfig".

Fixes: f62b8bb8f2d3 ("net/mlx5: Extend mlx5_core to support ConnectX-4 Ethernet functionality")
Signed-off-by: Ron Diskin <rondi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 8 +-------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 4 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h | 2 ++
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 9334c9c3e208..24336c60123a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -20,6 +20,11 @@ enum mlx5e_icosq_wqe_type {
 };
 
 /* General */
+static inline bool mlx5e_skb_is_multicast(struct sk_buff *skb)
+{
+	return skb->pkt_type == PACKET_MULTICAST || skb->pkt_type == PACKET_BROADCAST;
+}
+
 void mlx5e_trigger_irq(struct mlx5e_icosq *sq);
 void mlx5e_completion_event(struct mlx5_core_cq *mcq, struct mlx5_eqe *eqe);
 void mlx5e_cq_error_event(struct mlx5_core_cq *mcq, enum mlx5_event event);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 917c28e7f29e..d46047235568 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3569,6 +3569,7 @@ void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s)
 
 		s->rx_packets   += rq_stats->packets + xskrq_stats->packets;
 		s->rx_bytes     += rq_stats->bytes + xskrq_stats->bytes;
+		s->multicast    += rq_stats->mcast_packets + xskrq_stats->mcast_packets;
 
 		for (j = 0; j < priv->max_opened_tc; j++) {
 			struct mlx5e_sq_stats *sq_stats = &channel_stats->sq[j];
@@ -3584,7 +3585,6 @@ void
 mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	struct mlx5e_vport_stats *vstats = &priv->stats.vport;
 	struct mlx5e_pport_stats *pstats = &priv->stats.pport;
 
 	/* In switchdev mode, monitor counters doesn't monitor
@@ -3619,12 +3619,6 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->rx_errors = stats->rx_length_errors + stats->rx_crc_errors +
 			   stats->rx_frame_errors;
 	stats->tx_errors = stats->tx_aborted_errors + stats->tx_carrier_errors;
-
-	/* vport multicast also counts packets that are dropped due to steering
-	 * or rx out of buffer
-	 */
-	stats->multicast =
-		VPORT_COUNTER_GET(vstats, received_eth_multicast.packets);
 }
 
 static void mlx5e_set_rx_mode(struct net_device *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 99d102c035b0..64c8ac5eabf6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -53,6 +53,7 @@
 #include "en/xsk/rx.h"
 #include "en/health.h"
 #include "en/params.h"
+#include "en/txrx.h"
 
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
@@ -1080,6 +1081,9 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 		mlx5e_enable_ecn(rq, skb);
 
 	skb->protocol = eth_type_trans(skb, netdev);
+
+	if (unlikely(mlx5e_skb_is_multicast(skb)))
+		stats->mcast_packets++;
 }
 
 static inline void mlx5e_complete_rx_cqe(struct mlx5e_rq *rq,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 2e1cca1923b9..be7cda283781 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -119,6 +119,7 @@ struct mlx5e_sw_stats {
 	u64 tx_nop;
 	u64 rx_lro_packets;
 	u64 rx_lro_bytes;
+	u64 rx_mcast_packets;
 	u64 rx_ecn_mark;
 	u64 rx_removed_vlan_packets;
 	u64 rx_csum_unnecessary;
@@ -298,6 +299,7 @@ struct mlx5e_rq_stats {
 	u64 csum_none;
 	u64 lro_packets;
 	u64 lro_bytes;
+	u64 mcast_packets;
 	u64 ecn_mark;
 	u64 removed_vlan_packets;
 	u64 xdp_drop;
-- 
2.26.2

