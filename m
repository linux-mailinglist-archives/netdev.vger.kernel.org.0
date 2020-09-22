Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665502738DF
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgIVCsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbgIVCr6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 22:47:58 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1678523A9D;
        Tue, 22 Sep 2020 02:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600742872;
        bh=ZVikgCSW795KG8GhILb4uwwTdqxp+Qv2oB3wcIhfowk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6S9mFuAvw5sj35G3igU2tjTLbqKhO837VmrE52pj8yO0MRUM3KDxyRerOqCB+FQC
         uuKyLA7ueh2Noipkt9vPh/Wi0reMNndBASAPV9PK/FetBVnpPoKf7IoouywugPwqM7
         sREiroHAQ14sB86gT1cm8sFJjGkdmegNe8himYrU=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 12/12] net/mlx5e: Enhanced TX MPWQE for SKBs
Date:   Mon, 21 Sep 2020 19:47:04 -0700
Message-Id: <20200922024704.544482-13-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922024704.544482-1-saeed@kernel.org>
References: <20200922024704.544482-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

This commit adds support for Enhanced TX MPWQE feature in the regular
(SKB) data path. A MPWQE (multi-packet work queue element) can serve
multiple packets, reducing the PCI bandwidth on control traffic.

Two new stats (tx*_mpwqe_blks and tx*_mpwqe_pkts) are added. The feature
is on by default and controlled by the skb_tx_mpwqe private flag.

In a MPWQE, eseg is shared among all packets, so eseg-based offloads
(IPSEC, GENEVE, checksum) run on a separate eseg that is compared to the
eseg of the current MPWQE session to decide if the new packet can be
added to the same session.

MPWQE is not compatible with certain offloads and features, such as TLS
offload, TSO, nonlinear SKBs. If such incompatible features are in use,
the driver gracefully falls back to non-MPWQE.

This change has no performance impact in TCP single stream test and
XDP_TX single stream test.

UDP pktgen, 64-byte packets, single stream, MPWQE off:
  Packet rate: 16.96 Mpps (±0.12 Mpps) -> 17.01 Mpps (±0.20 Mpps)
  Instructions per packet: 421 -> 429
  Cycles per packet: 156 -> 161
  Instructions per cycle: 2.70 -> 2.67

UDP pktgen, 64-byte packets, single stream, MPWQE on:
  Packet rate: 16.96 Mpps (±0.12 Mpps) -> 20.94 Mpps (±0.33 Mpps)
  Instructions per packet: 421 -> 329
  Cycles per packet: 156 -> 123
  Instructions per cycle: 2.70 -> 2.67

Enabling MPWQE can reduce PCI bandwidth:
  PCI Gen2, pktgen at fixed rate of 36864000 pps on 24 CPU cores:
    Inbound PCI utilization with MPWQE off: 80.3%
    Inbound PCI utilization with MPWQE on: 59.0%
  PCI Gen3, pktgen at fixed rate of 56064000 pps on 24 CPU cores:
    Inbound PCI utilization with MPWQE off: 65.4%
    Inbound PCI utilization with MPWQE on: 49.3%

Enabling MPWQE can also reduce CPU load, increasing the packet rate in
case of CPU bottleneck:
  PCI Gen2, pktgen at full rate on 24 CPU cores:
    Packet rate with MPWQE off: 37.5 Mpps
    Packet rate with MPWQE on: 49.0 Mpps
  PCI Gen3, pktgen at full rate on 24 CPU cores:
    Packet rate with MPWQE off: 57.0 Mpps
    Packet rate with MPWQE on: 66.8 Mpps

Burst size in all pktgen tests is 32.

CPU: Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz (x86_64)
NIC: Mellanox ConnectX-6 Dx
GCC 10.2.0

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   4 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |   1 +
 .../mellanox/mlx5/core/en_accel/en_accel.h    |  29 +--
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |   2 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  15 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  11 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   6 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   4 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 184 +++++++++++++++++-
 11 files changed, 240 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 252cc0277475..0df40d24acb0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -221,6 +221,7 @@ enum mlx5e_priv_flag {
 	MLX5E_PFLAG_RX_STRIDING_RQ,
 	MLX5E_PFLAG_RX_NO_CSUM_COMPLETE,
 	MLX5E_PFLAG_XDP_TX_MPWQE,
+	MLX5E_PFLAG_SKB_TX_MPWQE,
 	MLX5E_NUM_PFLAGS, /* Keep last */
 };
 
@@ -305,6 +306,7 @@ struct mlx5e_sq_dma {
 
 enum {
 	MLX5E_SQ_STATE_ENABLED,
+	MLX5E_SQ_STATE_MPWQE,
 	MLX5E_SQ_STATE_RECOVERING,
 	MLX5E_SQ_STATE_IPSEC,
 	MLX5E_SQ_STATE_AM,
@@ -316,6 +318,7 @@ enum {
 struct mlx5e_tx_mpwqe {
 	/* Current MPWQE session */
 	struct mlx5e_tx_wqe *wqe;
+	u32 bytes_count;
 	u8 ds_count;
 	u8 pkt_count;
 	u8 inline_on;
@@ -334,6 +337,7 @@ struct mlx5e_txqsq {
 	u16                        pc ____cacheline_aligned_in_smp;
 	u16                        skb_fifo_pc;
 	u32                        dma_fifo_pc;
+	struct mlx5e_tx_mpwqe      mpwqe;
 
 	struct mlx5e_cq            cq;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 06dbfd6cd82a..8ccd0b661a7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -278,6 +278,7 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
 }
 
 void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struct sk_buff *skb, bool xmit_more);
+void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq *sq);
 
 static inline bool mlx5e_tx_mpwqe_is_full(struct mlx5e_tx_mpwqe *session)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f0a102763de6..0b201e66f191 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -205,6 +205,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
 
 	*session = (struct mlx5e_tx_mpwqe) {
 		.wqe = wqe,
+		.bytes_count = 0,
 		.ds_count = MLX5E_TX_WQE_EMPTY_DS_COUNT,
 		.pkt_count = 0,
 		.inline_on = mlx5e_xdp_get_inline_state(sq, session->inline_on),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 4bd8af478a4a..d487e5e37162 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -147,6 +147,7 @@ mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq,
 	u32 dma_len = xdptxd->len;
 
 	session->pkt_count++;
+	session->bytes_count += dma_len;
 
 	if (session->inline_on && dma_len <= MLX5E_XDP_INLINE_WQE_SZ_THRSD) {
 		struct mlx5_wqe_inline_seg *inline_dseg =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 23d4ef5ab9c5..2ea1cdc1ca54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -128,31 +128,38 @@ static inline bool mlx5e_accel_tx_begin(struct net_device *dev,
 	return true;
 }
 
-static inline bool mlx5e_accel_tx_finish(struct mlx5e_priv *priv,
-					 struct mlx5e_txqsq *sq,
-					 struct sk_buff *skb,
-					 struct mlx5e_tx_wqe *wqe,
-					 struct mlx5e_accel_tx_state *state)
-{
-#ifdef CONFIG_MLX5_EN_TLS
-	mlx5e_tls_handle_tx_wqe(sq, &wqe->ctrl, &state->tls);
-#endif
+/* Part of the eseg touched by TX offloads */
+#define MLX5E_ACCEL_ESEG_LEN offsetof(struct mlx5_wqe_eth_seg, mss)
 
+static inline bool mlx5e_accel_tx_eseg(struct mlx5e_priv *priv,
+				       struct mlx5e_txqsq *sq,
+				       struct sk_buff *skb,
+				       struct mlx5_wqe_eth_seg *eseg)
+{
 #ifdef CONFIG_MLX5_EN_IPSEC
 	if (test_bit(MLX5E_SQ_STATE_IPSEC, &sq->state)) {
-		if (unlikely(!mlx5e_ipsec_handle_tx_skb(priv, &wqe->eth, skb)))
+		if (unlikely(!mlx5e_ipsec_handle_tx_skb(priv, eseg, skb)))
 			return false;
 	}
 #endif
 
 #if IS_ENABLED(CONFIG_GENEVE)
 	if (skb->encapsulation)
-		mlx5e_tx_tunnel_accel(skb, &wqe->eth);
+		mlx5e_tx_tunnel_accel(skb, eseg);
 #endif
 
 	return true;
 }
 
+static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
+					 struct mlx5e_tx_wqe *wqe,
+					 struct mlx5e_accel_tx_state *state)
+{
+#ifdef CONFIG_MLX5_EN_TLS
+	mlx5e_tls_handle_tx_wqe(sq, &wqe->ctrl, &state->tls);
+#endif
+}
+
 static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
 {
 	return mlx5e_ktls_init_rx(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index c36560b3e93d..6982b193ee8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -270,6 +270,8 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	if (!datalen)
 		return true;
 
+	mlx5e_tx_mpwqe_ensure_complete(sq);
+
 	tls_ctx = tls_get_ctx(skb->sk);
 	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
 		goto err_out;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 0dda80d8bdca..d25a56ec6876 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1908,7 +1908,7 @@ static int set_pflag_rx_no_csum_complete(struct net_device *netdev, bool enable)
 	return 0;
 }
 
-static int set_pflag_xdp_tx_mpwqe(struct net_device *netdev, bool enable)
+static int set_pflag_tx_mpwqe_common(struct net_device *netdev, u32 flag, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -1920,7 +1920,7 @@ static int set_pflag_xdp_tx_mpwqe(struct net_device *netdev, bool enable)
 
 	new_channels.params = priv->channels.params;
 
-	MLX5E_SET_PFLAG(&new_channels.params, MLX5E_PFLAG_XDP_TX_MPWQE, enable);
+	MLX5E_SET_PFLAG(&new_channels.params, flag, enable);
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		priv->channels.params = new_channels.params;
@@ -1931,6 +1931,16 @@ static int set_pflag_xdp_tx_mpwqe(struct net_device *netdev, bool enable)
 	return err;
 }
 
+static int set_pflag_xdp_tx_mpwqe(struct net_device *netdev, bool enable)
+{
+	return set_pflag_tx_mpwqe_common(netdev, MLX5E_PFLAG_XDP_TX_MPWQE, enable);
+}
+
+static int set_pflag_skb_tx_mpwqe(struct net_device *netdev, bool enable)
+{
+	return set_pflag_tx_mpwqe_common(netdev, MLX5E_PFLAG_SKB_TX_MPWQE, enable);
+}
+
 static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] = {
 	{ "rx_cqe_moder",        set_pflag_rx_cqe_based_moder },
 	{ "tx_cqe_moder",        set_pflag_tx_cqe_based_moder },
@@ -1938,6 +1948,7 @@ static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] = {
 	{ "rx_striding_rq",      set_pflag_rx_striding_rq },
 	{ "rx_no_csum_complete", set_pflag_rx_no_csum_complete },
 	{ "xdp_tx_mpwqe",        set_pflag_xdp_tx_mpwqe },
+	{ "skb_tx_mpwqe",        set_pflag_skb_tx_mpwqe },
 };
 
 static int mlx5e_handle_pflag(struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c331aa9714f8..472252ea67a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1082,6 +1082,12 @@ static int mlx5e_calc_sq_stop_room(struct mlx5e_txqsq *sq, u8 log_sq_size)
 
 	sq->stop_room  = mlx5e_tls_get_stop_room(sq);
 	sq->stop_room += mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
+	if (test_bit(MLX5E_SQ_STATE_MPWQE, &sq->state))
+		/* A MPWQE can take up to the maximum-sized WQE + all the normal
+		 * stop room can be taken if a new packet breaks the active
+		 * MPWQE session and allocates its WQEs right away.
+		 */
+		sq->stop_room += mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
 
 	if (WARN_ON(sq->stop_room >= sq_size)) {
 		netdev_err(sq->channel->netdev, "Stop room %hu is bigger than the SQ size %d\n",
@@ -1123,6 +1129,8 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 		set_bit(MLX5E_SQ_STATE_IPSEC, &sq->state);
 	if (mlx5_accel_is_tls_device(c->priv->mdev))
 		set_bit(MLX5E_SQ_STATE_TLS, &sq->state);
+	if (param->is_mpw)
+		set_bit(MLX5E_SQ_STATE_MPWQE, &sq->state);
 	err = mlx5e_calc_sq_stop_room(sq, params->log_sq_size);
 	if (err)
 		return err;
@@ -2175,6 +2183,7 @@ static void mlx5e_build_sq_param(struct mlx5e_priv *priv,
 	mlx5e_build_sq_param_common(priv, param);
 	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
 	MLX5_SET(sqc, sqc, allow_swp, allow_swp);
+	param->is_mpw = MLX5E_GET_PFLAG(params, MLX5E_PFLAG_SKB_TX_MPWQE);
 	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
 }
 
@@ -4731,6 +4740,8 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv,
 	params->log_sq_size = is_kdump_kernel() ?
 		MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE :
 		MLX5E_PARAMS_DEFAULT_LOG_SQ_SIZE;
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_SKB_TX_MPWQE,
+			MLX5_CAP_ETH(mdev, enhanced_multi_pkt_send_wqe));
 
 	/* XDP SQ */
 	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_XDP_TX_MPWQE,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 6d5e54b964c0..c580f8b8c242 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -98,6 +98,8 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tso_inner_bytes) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_added_vlan_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_nop) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_mpwqe_blks) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_mpwqe_pkts) },
 
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_encrypted_packets) },
@@ -353,6 +355,8 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 			s->tx_tso_inner_bytes	+= sq_stats->tso_inner_bytes;
 			s->tx_added_vlan_packets += sq_stats->added_vlan_packets;
 			s->tx_nop               += sq_stats->nop;
+			s->tx_mpwqe_blks        += sq_stats->mpwqe_blks;
+			s->tx_mpwqe_pkts        += sq_stats->mpwqe_pkts;
 			s->tx_queue_stopped	+= sq_stats->stopped;
 			s->tx_queue_wake	+= sq_stats->wake;
 			s->tx_queue_dropped	+= sq_stats->dropped;
@@ -1556,6 +1560,8 @@ static const struct counter_desc sq_stats_desc[] = {
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, csum_partial_inner) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, added_vlan_packets) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, nop) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, mpwqe_blks) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, mpwqe_pkts) },
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_packets) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_bytes) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 9d9ee269a041..1e46e0ed04aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -120,6 +120,8 @@ struct mlx5e_sw_stats {
 	u64 tx_tso_inner_bytes;
 	u64 tx_added_vlan_packets;
 	u64 tx_nop;
+	u64 tx_mpwqe_blks;
+	u64 tx_mpwqe_pkts;
 	u64 rx_lro_packets;
 	u64 rx_lro_bytes;
 	u64 rx_ecn_mark;
@@ -348,6 +350,8 @@ struct mlx5e_sq_stats {
 	u64 csum_partial_inner;
 	u64 added_vlan_packets;
 	u64 nop;
+	u64 mpwqe_blks;
+	u64 mpwqe_pkts;
 #ifdef CONFIG_MLX5_EN_TLS
 	u64 tls_encrypted_packets;
 	u64 tls_encrypted_bytes;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index f5af35c5ecc8..13bd4f254ed7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -428,6 +428,166 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	dev_kfree_skb_any(skb);
 }
 
+static bool mlx5e_tx_skb_supports_mpwqe(struct sk_buff *skb, struct mlx5e_tx_attr *attr)
+{
+	return !skb_is_nonlinear(skb) && !skb_vlan_tag_present(skb) && !attr->ihs;
+}
+
+static bool mlx5e_tx_mpwqe_same_eseg(struct mlx5e_txqsq *sq, struct mlx5_wqe_eth_seg *eseg)
+{
+	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
+
+	/* Assumes the session is already running and has at least one packet. */
+	return !memcmp(&session->wqe->eth, eseg, MLX5E_ACCEL_ESEG_LEN);
+}
+
+static void mlx5e_tx_mpwqe_session_start(struct mlx5e_txqsq *sq,
+					 struct mlx5_wqe_eth_seg *eseg)
+{
+	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
+	struct mlx5e_tx_wqe *wqe;
+	u16 pi;
+
+	pi = mlx5e_txqsq_get_next_pi(sq, MLX5E_TX_MPW_MAX_WQEBBS);
+	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
+	prefetchw(wqe->data);
+
+	*session = (struct mlx5e_tx_mpwqe) {
+		.wqe = wqe,
+		.bytes_count = 0,
+		.ds_count = MLX5E_TX_WQE_EMPTY_DS_COUNT,
+		.pkt_count = 0,
+		.inline_on = 0,
+	};
+
+	memcpy(&session->wqe->eth, eseg, MLX5E_ACCEL_ESEG_LEN);
+
+	sq->stats->mpwqe_blks++;
+}
+
+static bool mlx5e_tx_mpwqe_session_is_active(struct mlx5e_txqsq *sq)
+{
+	return sq->mpwqe.wqe;
+}
+
+static void mlx5e_tx_mpwqe_add_dseg(struct mlx5e_txqsq *sq, struct mlx5e_xmit_data *txd)
+{
+	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
+	struct mlx5_wqe_data_seg *dseg;
+
+	dseg = (struct mlx5_wqe_data_seg *)session->wqe + session->ds_count;
+
+	session->pkt_count++;
+	session->bytes_count += txd->len;
+
+	dseg->addr = cpu_to_be64(txd->dma_addr);
+	dseg->byte_count = cpu_to_be32(txd->len);
+	dseg->lkey = sq->mkey_be;
+	session->ds_count++;
+
+	sq->stats->mpwqe_pkts++;
+}
+
+static struct mlx5_wqe_ctrl_seg *mlx5e_tx_mpwqe_session_complete(struct mlx5e_txqsq *sq)
+{
+	struct mlx5e_tx_mpwqe *session = &sq->mpwqe;
+	u8 ds_count = session->ds_count;
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5e_tx_wqe_info *wi;
+	u16 pi;
+
+	cseg = &session->wqe->ctrl;
+	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | MLX5_OPCODE_ENHANCED_MPSW);
+	cseg->qpn_ds = cpu_to_be32((sq->sqn << 8) | ds_count);
+
+	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	wi = &sq->db.wqe_info[pi];
+	*wi = (struct mlx5e_tx_wqe_info) {
+		.skb = NULL,
+		.num_bytes = session->bytes_count,
+		.num_wqebbs = DIV_ROUND_UP(ds_count, MLX5_SEND_WQEBB_NUM_DS),
+		.num_dma = session->pkt_count,
+		.num_fifo_pkts = session->pkt_count,
+	};
+
+	sq->pc += wi->num_wqebbs;
+
+	session->wqe = NULL;
+
+	mlx5e_tx_check_stop(sq);
+
+	return cseg;
+}
+
+static void
+mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+		    struct mlx5_wqe_eth_seg *eseg, bool xmit_more)
+{
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5e_xmit_data txd;
+
+	if (!mlx5e_tx_mpwqe_session_is_active(sq)) {
+		mlx5e_tx_mpwqe_session_start(sq, eseg);
+	} else if (!mlx5e_tx_mpwqe_same_eseg(sq, eseg)) {
+		mlx5e_tx_mpwqe_session_complete(sq);
+		mlx5e_tx_mpwqe_session_start(sq, eseg);
+	}
+
+	sq->stats->xmit_more += xmit_more;
+
+	txd.data = skb->data;
+	txd.len = skb->len;
+
+	txd.dma_addr = dma_map_single(sq->pdev, txd.data, txd.len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sq->pdev, txd.dma_addr)))
+		goto err_unmap;
+	mlx5e_dma_push(sq, txd.dma_addr, txd.len, MLX5E_DMA_MAP_SINGLE);
+
+	mlx5e_skb_fifo_push(sq, skb);
+
+	mlx5e_tx_mpwqe_add_dseg(sq, &txd);
+
+	mlx5e_tx_skb_update_hwts_flags(skb);
+
+	if (unlikely(mlx5e_tx_mpwqe_is_full(&sq->mpwqe))) {
+		/* Might stop the queue and affect the retval of __netdev_tx_sent_queue. */
+		cseg = mlx5e_tx_mpwqe_session_complete(sq);
+
+		if (__netdev_tx_sent_queue(sq->txq, txd.len, xmit_more))
+			mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
+	} else if (__netdev_tx_sent_queue(sq->txq, txd.len, xmit_more)) {
+		/* Might stop the queue, but we were asked to ring the doorbell anyway. */
+		cseg = mlx5e_tx_mpwqe_session_complete(sq);
+
+		mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
+	}
+
+	return;
+
+err_unmap:
+	mlx5e_dma_unmap_wqe_err(sq, 1);
+	sq->stats->dropped++;
+	dev_kfree_skb_any(skb);
+}
+
+void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq *sq)
+{
+	/* Unlikely in non-MPWQE workloads; not important in MPWQE workloads. */
+	if (unlikely(mlx5e_tx_mpwqe_session_is_active(sq)))
+		mlx5e_tx_mpwqe_session_complete(sq);
+}
+
+static bool mlx5e_txwqe_build_eseg(struct mlx5e_priv *priv, struct mlx5e_txqsq *sq,
+				   struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg)
+{
+	if (unlikely(!mlx5e_accel_tx_eseg(priv, sq, skb, eseg)))
+		return false;
+
+	mlx5e_txwqe_build_eseg_csum(sq, skb, eseg);
+
+	return true;
+}
+
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
@@ -442,21 +602,35 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* May send SKBs and WQEs. */
 	if (unlikely(!mlx5e_accel_tx_begin(dev, sq, skb, &accel)))
-		goto out;
+		return NETDEV_TX_OK;
 
 	mlx5e_sq_xmit_prepare(sq, skb, &accel, &attr);
+
+	if (test_bit(MLX5E_SQ_STATE_MPWQE, &sq->state)) {
+		if (mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
+			struct mlx5_wqe_eth_seg eseg = {};
+
+			if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &eseg)))
+				return NETDEV_TX_OK;
+
+			mlx5e_sq_xmit_mpwqe(sq, skb, &eseg, netdev_xmit_more());
+			return NETDEV_TX_OK;
+		}
+
+		mlx5e_tx_mpwqe_ensure_complete(sq);
+	}
+
 	mlx5e_sq_calc_wqe_attr(skb, &attr, &wqe_attr);
 	pi = mlx5e_txqsq_get_next_pi(sq, wqe_attr.num_wqebbs);
 	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 
 	/* May update the WQE, but may not post other WQEs. */
-	if (unlikely(!mlx5e_accel_tx_finish(priv, sq, skb, wqe, &accel)))
-		goto out;
+	mlx5e_accel_tx_finish(sq, wqe, &accel);
+	if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &wqe->eth)))
+		return NETDEV_TX_OK;
 
-	mlx5e_txwqe_build_eseg_csum(sq, skb, &wqe->eth);
 	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, netdev_xmit_more());
 
-out:
 	return NETDEV_TX_OK;
 }
 
-- 
2.26.2

