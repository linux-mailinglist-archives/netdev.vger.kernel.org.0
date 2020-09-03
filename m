Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C4625CBBE
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgICVBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:01:01 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2778 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729447AbgICVAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:00:49 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5159500002>; Thu, 03 Sep 2020 14:00:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 03 Sep 2020 14:00:47 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 03 Sep 2020 14:00:47 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Sep
 2020 21:00:40 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next 10/10] net/mlx5e: Enhanced TX MPWQE for SKBs
Date:   Thu, 3 Sep 2020 14:00:22 -0700
Message-ID: <20200903210022.22774-11-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200903210022.22774-1-saeedm@nvidia.com>
References: <20200903210022.22774-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599166800; bh=bLtge1re3pU0EKeTVltgIuziyp8QtXp5FmIq+YYhmQM=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=MDb1GEm6Rw9liZbCyaLWUIUpQXKN0suzO3WCJXaWa7vv+dl7uZo/WujZuIA1DDCft
         ZKiG7zCKhl1E2ouGiOiAX2fldQpEihdXcPodSYFvjJr1yYsDsLNNnIQXtrv66PqKP2
         bI0x/shYmvPf3he33PCB0d387JzM6WUgv3Scsh59YXLw8M4U/bbpXTtXNGj4R7Ca6C
         V+0p4gINbl9iRAeTqUnHK+A/wnLtSGxW0V00mNWzpC+YR5Vteyqg8C4mYX2w6yXS4h
         0sKjiczBYMmNMDko46Ng94ur0UK/BWgEX3cNb0wWzv4RaTdkNrul86tUBtTNUSRi1H
         RxBqUA9Ktr4Nw==
Sender: netdev-owner@vger.kernel.org
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
  Packet rate: 19.12 Mpps -> 20.02 Mpps
  Instructions per packet: 354 -> 347
  Cycles per packet: 140 -> 129

UDP pktgen, 64-byte packets, single stream, MPWQE on:
  Packet rate: 19.12 Mpps -> 20.67 Mpps
  Instructions per packet: 354 -> 335
  Cycles per packet: 140 -> 124

Enabling MPWQE can reduce PCI bandwidth:
  PCI Gen2, pktgen at fixed rate of 36864000 pps on 24 CPU cores:
    Inbound PCI utilization with MPWQE off: 81.3%
    Inbound PCI utilization with MPWQE on: 59.3%
  PCI Gen3, pktgen at fixed rate of 56064005 pps on 24 CPU cores:
    Inbound PCI utilization with MPWQE off: 65.8%
    Inbound PCI utilization with MPWQE on: 49.2%

Enabling MPWQE can also reduce CPU load, increasing the packet rate in
case of CPU bottleneck:
  PCI Gen2, pktgen at full rate on 24 CPU cores:
    Packet rate with MPWQE off: 37.4 Mpps
    Packet rate with MPWQE on: 49.1 Mpps
  PCI Gen3, pktgen at full rate on 24 CPU cores:
    Packet rate with MPWQE off: 56.2 Mpps
    Packet rate with MPWQE on: 67.0 Mpps

Burst size in all pktgen tests is 32.

CPU: Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz (x86_64)
NIC: Mellanox ConnectX-6 Dx

To avoid performance degradation when MPWQE is off, manual optimizations
of function inlining were performed. It's especially important to have
mlx5e_sq_xmit_mpwqe noinline, otherwise gcc inlines it automatically and
bloats mlx5e_xmit, slowing it down.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
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

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 3511836f0f4a..2abb0857ede0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -221,6 +221,7 @@ enum mlx5e_priv_flag {
 	MLX5E_PFLAG_RX_STRIDING_RQ,
 	MLX5E_PFLAG_RX_NO_CSUM_COMPLETE,
 	MLX5E_PFLAG_XDP_TX_MPWQE,
+	MLX5E_PFLAG_SKB_TX_MPWQE,
 	MLX5E_NUM_PFLAGS, /* Keep last */
 };
=20
@@ -304,6 +305,7 @@ struct mlx5e_sq_dma {
=20
 enum {
 	MLX5E_SQ_STATE_ENABLED,
+	MLX5E_SQ_STATE_MPWQE,
 	MLX5E_SQ_STATE_RECOVERING,
 	MLX5E_SQ_STATE_IPSEC,
 	MLX5E_SQ_STATE_AM,
@@ -315,6 +317,7 @@ enum {
 struct mlx5e_tx_mpwqe {
 	/* Current MPWQE session */
 	struct mlx5e_tx_wqe *wqe;
+	u32 bytes_count;
 	u8 ds_count;
 	u8 pkt_count;
 	u8 inline_on;
@@ -333,6 +336,7 @@ struct mlx5e_txqsq {
 	u16                        pc ____cacheline_aligned_in_smp;
 	u16                        skb_fifo_pc;
 	u32                        dma_fifo_pc;
+	struct mlx5e_tx_mpwqe      mpwqe;
=20
 	struct mlx5e_cq            cq;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 1ac4607fba08..749881987094 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -297,6 +297,7 @@ static inline void mlx5e_txwqe_build_eseg_csum(struct m=
lx5e_txqsq *sq,
 }
=20
 void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struct sk_buff *skb, boo=
l xmit_more);
+void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq *sq);
=20
 static inline bool mlx5e_tx_mpwqe_is_full(struct mlx5e_tx_mpwqe *session)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.c
index adacc4f9a3bf..307eb64889c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -205,6 +205,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_=
xdpsq *sq)
=20
 	*session =3D (struct mlx5e_tx_mpwqe) {
 		.wqe =3D wqe,
+		.bytes_count =3D 0,
 		.ds_count =3D MLX5E_TX_WQE_EMPTY_DS_COUNT,
 		.pkt_count =3D 0,
 		.inline_on =3D mlx5e_xdp_get_inline_state(sq, session->inline_on),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.h
index 4bd8af478a4a..d487e5e37162 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -147,6 +147,7 @@ mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq,
 	u32 dma_len =3D xdptxd->len;
=20
 	session->pkt_count++;
+	session->bytes_count +=3D dma_len;
=20
 	if (session->inline_on && dma_len <=3D MLX5E_XDP_INLINE_WQE_SZ_THRSD) {
 		struct mlx5_wqe_inline_seg *inline_dseg =3D
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 23d4ef5ab9c5..2ea1cdc1ca54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -128,31 +128,38 @@ static inline bool mlx5e_accel_tx_begin(struct net_de=
vice *dev,
 	return true;
 }
=20
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
=20
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
=20
 #if IS_ENABLED(CONFIG_GENEVE)
 	if (skb->encapsulation)
-		mlx5e_tx_tunnel_accel(skb, &wqe->eth);
+		mlx5e_tx_tunnel_accel(skb, eseg);
 #endif
=20
 	return true;
 }
=20
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index c36560b3e93d..6982b193ee8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -270,6 +270,8 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev,=
 struct mlx5e_txqsq *sq,
 	if (!datalen)
 		return true;
=20
+	mlx5e_tx_mpwqe_ensure_complete(sq);
+
 	tls_ctx =3D tls_get_ctx(skb->sk);
 	if (WARN_ON_ONCE(tls_ctx->netdev !=3D netdev))
 		goto err_out;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 5cb1e4839eb7..2c34bb57048c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1901,7 +1901,7 @@ static int set_pflag_rx_no_csum_complete(struct net_d=
evice *netdev, bool enable)
 	return 0;
 }
=20
-static int set_pflag_xdp_tx_mpwqe(struct net_device *netdev, bool enable)
+static int set_pflag_tx_mpwqe_common(struct net_device *netdev, u32 flag, =
bool enable)
 {
 	struct mlx5e_priv *priv =3D netdev_priv(netdev);
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -1913,7 +1913,7 @@ static int set_pflag_xdp_tx_mpwqe(struct net_device *=
netdev, bool enable)
=20
 	new_channels.params =3D priv->channels.params;
=20
-	MLX5E_SET_PFLAG(&new_channels.params, MLX5E_PFLAG_XDP_TX_MPWQE, enable);
+	MLX5E_SET_PFLAG(&new_channels.params, flag, enable);
=20
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		priv->channels.params =3D new_channels.params;
@@ -1924,6 +1924,16 @@ static int set_pflag_xdp_tx_mpwqe(struct net_device =
*netdev, bool enable)
 	return err;
 }
=20
+static int set_pflag_xdp_tx_mpwqe(struct net_device *netdev, bool enable)
+{
+	return set_pflag_tx_mpwqe_common(netdev, MLX5E_PFLAG_XDP_TX_MPWQE, enable=
);
+}
+
+static int set_pflag_skb_tx_mpwqe(struct net_device *netdev, bool enable)
+{
+	return set_pflag_tx_mpwqe_common(netdev, MLX5E_PFLAG_SKB_TX_MPWQE, enable=
);
+}
+
 static const struct pflag_desc mlx5e_priv_flags[MLX5E_NUM_PFLAGS] =3D {
 	{ "rx_cqe_moder",        set_pflag_rx_cqe_based_moder },
 	{ "tx_cqe_moder",        set_pflag_tx_cqe_based_moder },
@@ -1931,6 +1941,7 @@ static const struct pflag_desc mlx5e_priv_flags[MLX5E=
_NUM_PFLAGS] =3D {
 	{ "rx_striding_rq",      set_pflag_rx_striding_rq },
 	{ "rx_no_csum_complete", set_pflag_rx_no_csum_complete },
 	{ "xdp_tx_mpwqe",        set_pflag_xdp_tx_mpwqe },
+	{ "skb_tx_mpwqe",        set_pflag_skb_tx_mpwqe },
 };
=20
 static int mlx5e_handle_pflag(struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index b413aa168e4e..f8ad4a724a63 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1075,6 +1075,12 @@ static int mlx5e_calc_sq_stop_room(struct mlx5e_txqs=
q *sq, u8 log_sq_size)
=20
 	sq->stop_room  =3D mlx5e_tls_get_stop_room(sq);
 	sq->stop_room +=3D mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
+	if (test_bit(MLX5E_SQ_STATE_MPWQE, &sq->state))
+		/* A MPWQE can take up to the maximum-sized WQE + all the normal
+		 * stop room can be taken if a new packet breaks the active
+		 * MPWQE session and allocates its WQEs right away.
+		 */
+		sq->stop_room +=3D mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
=20
 	if (WARN_ON(sq->stop_room >=3D sq_size)) {
 		netdev_err(sq->channel->netdev, "Stop room %hu is bigger than the SQ siz=
e %d\n",
@@ -1116,6 +1122,8 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 		set_bit(MLX5E_SQ_STATE_IPSEC, &sq->state);
 	if (mlx5_accel_is_tls_device(c->priv->mdev))
 		set_bit(MLX5E_SQ_STATE_TLS, &sq->state);
+	if (param->is_mpw)
+		set_bit(MLX5E_SQ_STATE_MPWQE, &sq->state);
 	err =3D mlx5e_calc_sq_stop_room(sq, params->log_sq_size);
 	if (err)
 		return err;
@@ -2168,6 +2176,7 @@ static void mlx5e_build_sq_param(struct mlx5e_priv *p=
riv,
 	mlx5e_build_sq_param_common(priv, param);
 	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
 	MLX5_SET(sqc, sqc, allow_swp, allow_swp);
+	param->is_mpw =3D MLX5E_GET_PFLAG(params, MLX5E_PFLAG_SKB_TX_MPWQE);
 	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
 }
=20
@@ -4721,6 +4730,8 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv,
 	params->log_sq_size =3D is_kdump_kernel() ?
 		MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE :
 		MLX5E_PARAMS_DEFAULT_LOG_SQ_SIZE;
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_SKB_TX_MPWQE,
+			MLX5_CAP_ETH(mdev, enhanced_multi_pkt_send_wqe));
=20
 	/* XDP SQ */
 	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_XDP_TX_MPWQE,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index e3b2f59408e6..20d7815ffbf4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -98,6 +98,8 @@ static const struct counter_desc sw_stats_desc[] =3D {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tso_inner_bytes) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_added_vlan_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_nop) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_mpwqe_blks) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_mpwqe_pkts) },
=20
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_encrypted_packets) },
@@ -353,6 +355,8 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 			s->tx_tso_inner_bytes	+=3D sq_stats->tso_inner_bytes;
 			s->tx_added_vlan_packets +=3D sq_stats->added_vlan_packets;
 			s->tx_nop               +=3D sq_stats->nop;
+			s->tx_mpwqe_blks        +=3D sq_stats->mpwqe_blks;
+			s->tx_mpwqe_pkts        +=3D sq_stats->mpwqe_pkts;
 			s->tx_queue_stopped	+=3D sq_stats->stopped;
 			s->tx_queue_wake	+=3D sq_stats->wake;
 			s->tx_queue_dropped	+=3D sq_stats->dropped;
@@ -1527,6 +1531,8 @@ static const struct counter_desc sq_stats_desc[] =3D =
{
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, csum_partial_inner) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, added_vlan_packets) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, nop) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, mpwqe_blks) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, mpwqe_pkts) },
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_packets) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_bytes) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index 2e1cca1923b9..fd198965ba82 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -117,6 +117,8 @@ struct mlx5e_sw_stats {
 	u64 tx_tso_inner_bytes;
 	u64 tx_added_vlan_packets;
 	u64 tx_nop;
+	u64 tx_mpwqe_blks;
+	u64 tx_mpwqe_pkts;
 	u64 rx_lro_packets;
 	u64 rx_lro_bytes;
 	u64 rx_ecn_mark;
@@ -345,6 +347,8 @@ struct mlx5e_sq_stats {
 	u64 csum_partial_inner;
 	u64 added_vlan_packets;
 	u64 nop;
+	u64 mpwqe_blks;
+	u64 mpwqe_pkts;
 #ifdef CONFIG_MLX5_EN_TLS
 	u64 tls_encrypted_packets;
 	u64 tls_encrypted_bytes;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 3b68c8333875..d8f1acca37f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -412,6 +412,166 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_b=
uff *skb,
 	dev_kfree_skb_any(skb);
 }
=20
+static inline bool mlx5e_tx_skb_supports_mpwqe(struct sk_buff *skb, struct=
 mlx5e_tx_attr *attr)
+{
+	return !skb_is_nonlinear(skb) && !skb_vlan_tag_present(skb) && !attr->ihs=
;
+}
+
+static inline bool mlx5e_tx_mpwqe_same_eseg(struct mlx5e_txqsq *sq, struct=
 mlx5_wqe_eth_seg *eseg)
+{
+	struct mlx5e_tx_mpwqe *session =3D &sq->mpwqe;
+
+	/* Assumes the session is already running and has at least one packet. */
+	return !memcmp(&session->wqe->eth, eseg, MLX5E_ACCEL_ESEG_LEN);
+}
+
+static void mlx5e_tx_mpwqe_session_start(struct mlx5e_txqsq *sq,
+					 struct mlx5_wqe_eth_seg *eseg)
+{
+	struct mlx5e_tx_mpwqe *session =3D &sq->mpwqe;
+	struct mlx5e_tx_wqe *wqe;
+	u16 pi;
+
+	pi =3D mlx5e_txqsq_get_next_pi(sq, MLX5E_TX_MPW_MAX_WQEBBS);
+	wqe =3D MLX5E_TX_FETCH_WQE(sq, pi);
+	prefetchw(wqe->data);
+
+	*session =3D (struct mlx5e_tx_mpwqe) {
+		.wqe =3D wqe,
+		.bytes_count =3D 0,
+		.ds_count =3D MLX5E_TX_WQE_EMPTY_DS_COUNT,
+		.pkt_count =3D 0,
+		.inline_on =3D 0,
+	};
+
+	memcpy(&session->wqe->eth, eseg, MLX5E_ACCEL_ESEG_LEN);
+
+	sq->stats->mpwqe_blks++;
+}
+
+static inline bool mlx5e_tx_mpwqe_session_is_active(struct mlx5e_txqsq *sq=
)
+{
+	return sq->mpwqe.wqe;
+}
+
+static inline void mlx5e_tx_mpwqe_add_dseg(struct mlx5e_txqsq *sq, struct =
mlx5e_xmit_data *txd)
+{
+	struct mlx5e_tx_mpwqe *session =3D &sq->mpwqe;
+	struct mlx5_wqe_data_seg *dseg;
+
+	dseg =3D (struct mlx5_wqe_data_seg *)session->wqe + session->ds_count;
+
+	session->pkt_count++;
+	session->bytes_count +=3D txd->len;
+
+	dseg->addr =3D cpu_to_be64(txd->dma_addr);
+	dseg->byte_count =3D cpu_to_be32(txd->len);
+	dseg->lkey =3D sq->mkey_be;
+	session->ds_count++;
+
+	sq->stats->mpwqe_pkts++;
+}
+
+static struct mlx5_wqe_ctrl_seg *mlx5e_tx_mpwqe_session_complete(struct ml=
x5e_txqsq *sq)
+{
+	struct mlx5e_tx_mpwqe *session =3D &sq->mpwqe;
+	u8 ds_count =3D session->ds_count;
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5e_tx_wqe_info *wi;
+	u16 pi;
+
+	cseg =3D &session->wqe->ctrl;
+	cseg->opmod_idx_opcode =3D cpu_to_be32((sq->pc << 8) | MLX5_OPCODE_ENHANC=
ED_MPSW);
+	cseg->qpn_ds =3D cpu_to_be32((sq->sqn << 8) | ds_count);
+
+	pi =3D mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	wi =3D &sq->db.wqe_info[pi];
+	*wi =3D (struct mlx5e_tx_wqe_info) {
+		.skb =3D NULL,
+		.num_bytes =3D session->bytes_count,
+		.num_wqebbs =3D DIV_ROUND_UP(ds_count, MLX5_SEND_WQEBB_NUM_DS),
+		.num_dma =3D session->pkt_count,
+		.num_fifo_pkts =3D session->pkt_count,
+	};
+
+	sq->pc +=3D wi->num_wqebbs;
+
+	session->wqe =3D NULL;
+
+	mlx5e_tx_check_stop(sq);
+
+	return cseg;
+}
+
+static noinline void
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
+	sq->stats->xmit_more +=3D xmit_more;
+
+	txd.data =3D skb->data;
+	txd.len =3D skb->len;
+
+	txd.dma_addr =3D dma_map_single(sq->pdev, txd.data, txd.len, DMA_TO_DEVIC=
E);
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
+		/* Might stop the queue and affect the retval of __netdev_tx_sent_queue.=
 */
+		cseg =3D mlx5e_tx_mpwqe_session_complete(sq);
+
+		if (__netdev_tx_sent_queue(sq->txq, txd.len, xmit_more))
+			mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, cseg);
+	} else if (__netdev_tx_sent_queue(sq->txq, txd.len, xmit_more)) {
+		/* Might stop the queue, but we were asked to ring the doorbell anyway. =
*/
+		cseg =3D mlx5e_tx_mpwqe_session_complete(sq);
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
+static inline bool mlx5e_txwqe_build_eseg(struct mlx5e_priv *priv, struct =
mlx5e_txqsq *sq,
+					  struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg)
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
 	struct mlx5e_priv *priv =3D netdev_priv(dev);
@@ -426,21 +586,35 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct ne=
t_device *dev)
=20
 	/* May send SKBs and WQEs. */
 	if (unlikely(!mlx5e_accel_tx_begin(dev, sq, skb, &accel)))
-		goto out;
+		return NETDEV_TX_OK;
=20
 	mlx5e_sq_xmit_prepare(sq, skb, &accel, &attr);
+
+	if (test_bit(MLX5E_SQ_STATE_MPWQE, &sq->state)) {
+		if (mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
+			struct mlx5_wqe_eth_seg eseg =3D {};
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
 	pi =3D mlx5e_txqsq_get_next_pi(sq, wqe_attr.num_wqebbs);
 	wqe =3D MLX5E_TX_FETCH_WQE(sq, pi);
=20
 	/* May update the WQE, but may not post other WQEs. */
-	if (unlikely(!mlx5e_accel_tx_finish(priv, sq, skb, wqe, &accel)))
-		goto out;
+	mlx5e_accel_tx_finish(sq, wqe, &accel);
+	if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &wqe->eth)))
+		return NETDEV_TX_OK;
=20
-	mlx5e_txwqe_build_eseg_csum(sq, skb, &wqe->eth);
 	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, netdev_xmit_more())=
;
=20
-out:
 	return NETDEV_TX_OK;
 }
=20
--=20
2.26.2

