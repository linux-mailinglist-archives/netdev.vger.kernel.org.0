Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1988325CBB9
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgICVAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:00:44 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19835 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729348AbgICVAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:00:43 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5158f90002>; Thu, 03 Sep 2020 13:58:33 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 03 Sep 2020 14:00:42 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 03 Sep 2020 14:00:42 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Sep
 2020 21:00:36 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next 02/10] net/mlx5e: Refactor xmit functions
Date:   Thu, 3 Sep 2020 14:00:14 -0700
Message-ID: <20200903210022.22774-3-saeedm@nvidia.com>
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
        t=1599166713; bh=hd6XBGCYFZChOwxI4uOUKLCeTle+gst5PyqNCfzV38o=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=eBwxJcWgGiQyr/JCUXTnhidjEqod0B5LDA76THYoZgU59IUkjUbvYfn4kTOncWpv7
         3t/jiMhQ+YyVGXY+MRriokHyVo4Frwksc3g7CKAOecka+ZF/iQX4wOMhicPBbLSahO
         j9Qrk7a+AgsBEb+Yje9khx4E2TRTgYBwm9csuZc+rT/GJaxo6t+4cmHDws0vrpyO+E
         D+f4KwfCBIU1gZAJZiEyHiiYsQQI5P9C86W+d3rBQnRH/T1fuM0DJKt/5btfqvZS0G
         oDyeX2XW18cbscStrL8oOtc/Xts+3b7I4qGFy3MUEsFJn2tFQW8eWkZmwyMY2797jQ
         LaijIoP1m8cmg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

A huge function mlx5e_sq_xmit was split into several to achieve multiple
goals:

1. Reuse the code in IPoIB.

2. Better intergrate with TLS, IPSEC, GENEVE and checksum offloads. Now
it's possible to reserve space in the WQ before running eseg-based
offloads, so:

2.1. It's not needed to copy cseg and eseg after mlx5e_fill_sq_frag_edge
anymore.

2.2. mlx5e_txqsq_get_next_pi will be used instead of the legacy
mlx5e_fill_sq_frag_edge for better code maintainability and reuse.

3. Prepare for the upcoming TX MPWQE for SKBs. It will intervene after
mlx5e_sq_calc_wqe_attr to check if it's possible to use MPWQE, and the
code flow will split into two paths: MPWQE and non-MPWQE.

Two high-level functions are provided to send packets:

* mlx5e_xmit is called by the networking stack, runs offloads and sends
the packet. In one of the following patches, MPWQE support will be added
to this flow.

* mlx5e_sq_xmit_simple is called by the TLS offload, runs only the
checksum offload and sends the packet.

This change has no performance impact in TCP single stream test and
XDP_TX single stream test.

UDP pktgen (burst 32), single stream:
  Packet rate: 17.55 Mpps -> 19.23 Mpps
  Instructions per packet: 420 -> 360
  Cycles per packet: 165 -> 142

CPU: Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz (x86_64)
NIC: Mellanox ConnectX-6 Dx

To get this performance gain, manual optimizations of function inlining
were performed. It's important to have mlx5e_sq_xmit_wqe inline,
otherwise the packet rate will be 1 Mpps less in UDP pktgen test.
__always_inline is required, because gcc uninlines it when it's called
from two places (mlx5e_xmit and mlx5e_sq_xmit_simple).

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  63 +--
 .../mellanox/mlx5/core/en_accel/en_accel.h    |   5 +
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 391 ++++++++++--------
 4 files changed, 243 insertions(+), 222 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 9334c9c3e208..d4ee22789ab0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -41,8 +41,6 @@ void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq)=
;
 u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 		       struct net_device *sb_dev);
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
-void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-		   struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more);
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
=20
@@ -188,23 +186,6 @@ static inline u16 mlx5e_icosq_get_next_pi(struct mlx5e=
_icosq *sq, u16 size)
 	return pi;
 }
=20
-static inline void
-mlx5e_fill_sq_frag_edge(struct mlx5e_txqsq *sq, struct mlx5_wq_cyc *wq,
-			u16 pi, u16 nnops)
-{
-	struct mlx5e_tx_wqe_info *edge_wi, *wi =3D &sq->db.wqe_info[pi];
-
-	edge_wi =3D wi + nnops;
-
-	/* fill sq frag edge with nops to avoid wqe wrapping two pages */
-	for (; wi < edge_wi; wi++) {
-		memset(wi, 0, sizeof(*wi));
-		wi->num_wqebbs =3D 1;
-		mlx5e_post_nop(wq, sq->sqn, &sq->pc);
-	}
-	sq->stats->nop +=3D nnops;
-}
-
 static inline void
 mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
 		struct mlx5_wqe_ctrl_seg *ctrl)
@@ -223,29 +204,6 @@ mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void _=
_iomem *uar_map,
 	mlx5_write64((__be32 *)ctrl, uar_map);
 }
=20
-static inline bool mlx5e_transport_inline_tx_wqe(struct mlx5_wqe_ctrl_seg =
*cseg)
-{
-	return cseg && !!cseg->tis_tir_num;
-}
-
-static inline u8
-mlx5e_tx_wqe_inline_mode(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg =
*cseg,
-			 struct sk_buff *skb)
-{
-	u8 mode;
-
-	if (mlx5e_transport_inline_tx_wqe(cseg))
-		return MLX5_INLINE_MODE_TCP_UDP;
-
-	mode =3D sq->min_inline_mode;
-
-	if (skb_vlan_tag_present(skb) &&
-	    test_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state))
-		mode =3D max_t(u8, MLX5_INLINE_MODE_L2, mode);
-
-	return mode;
-}
-
 static inline void mlx5e_cq_arm(struct mlx5e_cq *cq)
 {
 	struct mlx5_core_cq *mcq;
@@ -286,6 +244,27 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_s=
q_dma *dma)
 	}
 }
=20
+static inline void mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq,
+					       struct sk_buff *skb,
+					       struct mlx5_wqe_eth_seg *eseg)
+{
+	if (likely(skb->ip_summed =3D=3D CHECKSUM_PARTIAL)) {
+		eseg->cs_flags =3D MLX5_ETH_WQE_L3_CSUM;
+		if (skb->encapsulation) {
+			eseg->cs_flags |=3D MLX5_ETH_WQE_L3_INNER_CSUM |
+					  MLX5_ETH_WQE_L4_INNER_CSUM;
+			sq->stats->csum_partial_inner++;
+		} else {
+			eseg->cs_flags |=3D MLX5_ETH_WQE_L4_CSUM;
+			sq->stats->csum_partial++;
+		}
+	} else {
+		sq->stats->csum_none++;
+	}
+}
+
+void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struct sk_buff *skb, boo=
l xmit_more);
+
 static inline void mlx5e_rqwq_reset(struct mlx5e_rq *rq)
 {
 	if (rq->wq_type =3D=3D MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 110476bdeffb..23d4ef5ab9c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -145,6 +145,11 @@ static inline bool mlx5e_accel_tx_finish(struct mlx5e_=
priv *priv,
 	}
 #endif
=20
+#if IS_ENABLED(CONFIG_GENEVE)
+	if (skb->encapsulation)
+		mlx5e_tx_tunnel_accel(skb, &wqe->eth);
+#endif
+
 	return true;
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index b0c31d49ff8d..c36560b3e93d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -189,12 +189,10 @@ static bool mlx5e_tls_handle_ooo(struct mlx5e_tls_off=
load_context_tx *context,
 				 struct mlx5e_tls *tls)
 {
 	u32 tcp_seq =3D ntohl(tcp_hdr(skb)->seq);
-	struct mlx5e_tx_wqe *wqe;
 	struct sync_info info;
 	struct sk_buff *nskb;
 	int linear_len =3D 0;
 	int headln;
-	u16 pi;
 	int i;
=20
 	sq->stats->tls_ooo++;
@@ -246,9 +244,7 @@ static bool mlx5e_tls_handle_ooo(struct mlx5e_tls_offlo=
ad_context_tx *context,
 	sq->stats->tls_resync_bytes +=3D nskb->len;
 	mlx5e_tls_complete_sync_skb(skb, nskb, tcp_seq, headln,
 				    cpu_to_be64(info.rcd_sn));
-	pi =3D mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
-	wqe =3D MLX5E_TX_FETCH_WQE(sq, pi);
-	mlx5e_sq_xmit(sq, nskb, wqe, pi, true);
+	mlx5e_sq_xmit_simple(sq, nskb, true);
=20
 	return true;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index e15aa53ff83e..f967bc0573c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -144,23 +144,6 @@ static inline void mlx5e_insert_vlan(void *start, stru=
ct sk_buff *skb, u16 ihs)
 	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
 }
=20
-static inline void
-mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb, s=
truct mlx5_wqe_eth_seg *eseg)
-{
-	if (likely(skb->ip_summed =3D=3D CHECKSUM_PARTIAL)) {
-		eseg->cs_flags =3D MLX5_ETH_WQE_L3_CSUM;
-		if (skb->encapsulation) {
-			eseg->cs_flags |=3D MLX5_ETH_WQE_L3_INNER_CSUM |
-					  MLX5_ETH_WQE_L4_INNER_CSUM;
-			sq->stats->csum_partial_inner++;
-		} else {
-			eseg->cs_flags |=3D MLX5_ETH_WQE_L4_CSUM;
-			sq->stats->csum_partial++;
-		}
-	} else
-		sq->stats->csum_none++;
-}
-
 static inline u16
 mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb)
 {
@@ -232,22 +215,121 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, stru=
ct sk_buff *skb,
 	return -ENOMEM;
 }
=20
+struct mlx5e_tx_attr {
+	u32 num_bytes;
+	u16 headlen;
+	u16 ihs;
+	__be16 mss;
+	u8 opcode;
+};
+
+struct mlx5e_tx_wqe_attr {
+	u16 ds_cnt;
+	u16 ds_cnt_inl;
+	u8 num_wqebbs;
+};
+
+static inline u8
+mlx5e_tx_wqe_inline_mode(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+			 struct mlx5e_accel_tx_state *accel)
+{
+	u8 mode;
+
+#ifdef CONFIG_MLX5_EN_TLS
+	if (accel && accel->tls.tls_tisn)
+		return MLX5_INLINE_MODE_TCP_UDP;
+#endif
+
+	mode =3D sq->min_inline_mode;
+
+	if (skb_vlan_tag_present(skb) &&
+	    test_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state))
+		mode =3D max_t(u8, MLX5_INLINE_MODE_L2, mode);
+
+	return mode;
+}
+
+static inline void mlx5e_sq_xmit_prepare(struct mlx5e_txqsq *sq, struct sk=
_buff *skb,
+					 struct mlx5e_accel_tx_state *accel,
+					 struct mlx5e_tx_attr *attr)
+{
+	struct mlx5e_sq_stats *stats =3D sq->stats;
+
+	if (skb_is_gso(skb)) {
+		u16 ihs =3D mlx5e_tx_get_gso_ihs(sq, skb);
+
+		*attr =3D (struct mlx5e_tx_attr) {
+			.opcode    =3D MLX5_OPCODE_LSO,
+			.mss       =3D cpu_to_be16(skb_shinfo(skb)->gso_size),
+			.ihs       =3D ihs,
+			.num_bytes =3D skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs,
+			.headlen   =3D skb_headlen(skb) - ihs,
+		};
+
+		stats->packets +=3D skb_shinfo(skb)->gso_segs;
+	} else {
+		u8 mode =3D mlx5e_tx_wqe_inline_mode(sq, skb, accel);
+		u16 ihs =3D mlx5e_calc_min_inline(mode, skb);
+
+		*attr =3D (struct mlx5e_tx_attr) {
+			.opcode    =3D MLX5_OPCODE_SEND,
+			.mss       =3D cpu_to_be16(0),
+			.ihs       =3D ihs,
+			.num_bytes =3D max_t(unsigned int, skb->len, ETH_ZLEN),
+			.headlen   =3D skb_headlen(skb) - ihs,
+		};
+
+		stats->packets++;
+	}
+
+	stats->bytes +=3D attr->num_bytes;
+}
+
+static inline void mlx5e_sq_calc_wqe_attr(struct sk_buff *skb,
+					  const struct mlx5e_tx_attr *attr,
+					  struct mlx5e_tx_wqe_attr *wqe_attr)
+{
+	u16 ds_cnt =3D sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS;
+	u16 ds_cnt_inl =3D 0;
+
+	ds_cnt +=3D !!attr->headlen + skb_shinfo(skb)->nr_frags;
+
+	if (attr->ihs) {
+		u16 inl =3D attr->ihs - INL_HDR_START_SZ;
+
+		if (skb_vlan_tag_present(skb))
+			inl +=3D VLAN_HLEN;
+
+		ds_cnt_inl =3D DIV_ROUND_UP(inl, MLX5_SEND_WQE_DS);
+		ds_cnt +=3D ds_cnt_inl;
+	}
+
+	*wqe_attr =3D (struct mlx5e_tx_wqe_attr) {
+		.ds_cnt     =3D ds_cnt,
+		.ds_cnt_inl =3D ds_cnt_inl,
+		.num_wqebbs =3D DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS),
+	};
+}
+
 static inline void
 mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-		     u8 opcode, u16 ds_cnt, u8 num_wqebbs, u32 num_bytes, u8 num_dma,
+		     const struct mlx5e_tx_attr *attr,
+		     const struct mlx5e_tx_wqe_attr *wqe_attr, u8 num_dma,
 		     struct mlx5e_tx_wqe_info *wi, struct mlx5_wqe_ctrl_seg *cseg,
 		     bool xmit_more)
 {
 	struct mlx5_wq_cyc *wq =3D &sq->wq;
 	bool send_doorbell;
=20
-	wi->num_bytes =3D num_bytes;
-	wi->num_dma =3D num_dma;
-	wi->num_wqebbs =3D num_wqebbs;
-	wi->skb =3D skb;
+	*wi =3D (struct mlx5e_tx_wqe_info) {
+		.skb =3D skb,
+		.num_bytes =3D attr->num_bytes,
+		.num_dma =3D num_dma,
+		.num_wqebbs =3D wqe_attr->num_wqebbs,
+	};
=20
-	cseg->opmod_idx_opcode =3D cpu_to_be32((sq->pc << 8) | opcode);
-	cseg->qpn_ds           =3D cpu_to_be32((sq->sqn << 8) | ds_cnt);
+	cseg->opmod_idx_opcode =3D cpu_to_be32((sq->pc << 8) | attr->opcode);
+	cseg->qpn_ds           =3D cpu_to_be32((sq->sqn << 8) | wqe_attr->ds_cnt)=
;
=20
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
 		skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;
@@ -258,105 +340,44 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct =
sk_buff *skb,
 		sq->stats->stopped++;
 	}
=20
-	send_doorbell =3D __netdev_tx_sent_queue(sq->txq, num_bytes,
-					       xmit_more);
+	send_doorbell =3D __netdev_tx_sent_queue(sq->txq, attr->num_bytes, xmit_m=
ore);
 	if (send_doorbell)
 		mlx5e_notify_hw(wq, sq->pc, sq->uar_map, cseg);
 }
=20
-void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-		   struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more)
+static __always_inline void
+mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+		  const struct mlx5e_tx_attr *attr, const struct mlx5e_tx_wqe_attr *wqe_=
attr,
+		  struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more)
 {
-	struct mlx5_wq_cyc *wq =3D &sq->wq;
 	struct mlx5_wqe_ctrl_seg *cseg;
 	struct mlx5_wqe_eth_seg  *eseg;
 	struct mlx5_wqe_data_seg *dseg;
 	struct mlx5e_tx_wqe_info *wi;
=20
 	struct mlx5e_sq_stats *stats =3D sq->stats;
-	u16 headlen, ihs, contig_wqebbs_room;
-	u16 ds_cnt, ds_cnt_inl =3D 0;
-	u8 num_wqebbs, opcode;
-	u32 num_bytes;
 	int num_dma;
-	__be16 mss;
=20
-	/* Calc ihs and ds cnt, no writes to wqe yet */
-	ds_cnt =3D sizeof(*wqe) / MLX5_SEND_WQE_DS;
-	if (skb_is_gso(skb)) {
-		opcode    =3D MLX5_OPCODE_LSO;
-		mss       =3D cpu_to_be16(skb_shinfo(skb)->gso_size);
-		ihs       =3D mlx5e_tx_get_gso_ihs(sq, skb);
-		num_bytes =3D skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs;
-		stats->packets +=3D skb_shinfo(skb)->gso_segs;
-	} else {
-		u8 mode =3D mlx5e_tx_wqe_inline_mode(sq, &wqe->ctrl, skb);
-
-		opcode    =3D MLX5_OPCODE_SEND;
-		mss       =3D 0;
-		ihs       =3D mlx5e_calc_min_inline(mode, skb);
-		num_bytes =3D max_t(unsigned int, skb->len, ETH_ZLEN);
-		stats->packets++;
-	}
-
-	stats->bytes     +=3D num_bytes;
 	stats->xmit_more +=3D xmit_more;
=20
-	headlen =3D skb->len - ihs - skb->data_len;
-	ds_cnt +=3D !!headlen;
-	ds_cnt +=3D skb_shinfo(skb)->nr_frags;
-
-	if (ihs) {
-		u16 inl =3D ihs + !!skb_vlan_tag_present(skb) * VLAN_HLEN - INL_HDR_STAR=
T_SZ;
-
-		ds_cnt_inl =3D DIV_ROUND_UP(inl, MLX5_SEND_WQE_DS);
-		ds_cnt +=3D ds_cnt_inl;
-	}
-
-	num_wqebbs =3D DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
-	contig_wqebbs_room =3D mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
-	if (unlikely(contig_wqebbs_room < num_wqebbs)) {
-#ifdef CONFIG_MLX5_EN_IPSEC
-		struct mlx5_wqe_eth_seg cur_eth =3D wqe->eth;
-#endif
-#ifdef CONFIG_MLX5_EN_TLS
-		struct mlx5_wqe_ctrl_seg cur_ctrl =3D wqe->ctrl;
-#endif
-		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
-		pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-		wqe =3D MLX5E_TX_FETCH_WQE(sq, pi);
-#ifdef CONFIG_MLX5_EN_IPSEC
-		wqe->eth =3D cur_eth;
-#endif
-#ifdef CONFIG_MLX5_EN_TLS
-		wqe->ctrl =3D cur_ctrl;
-#endif
-	}
-
 	/* fill wqe */
 	wi   =3D &sq->db.wqe_info[pi];
 	cseg =3D &wqe->ctrl;
 	eseg =3D &wqe->eth;
 	dseg =3D  wqe->data;
=20
-#if IS_ENABLED(CONFIG_GENEVE)
-	if (skb->encapsulation)
-		mlx5e_tx_tunnel_accel(skb, eseg);
-#endif
-	mlx5e_txwqe_build_eseg_csum(sq, skb, eseg);
-
-	eseg->mss =3D mss;
+	eseg->mss =3D attr->mss;
=20
-	if (ihs) {
+	if (attr->ihs) {
 		if (skb_vlan_tag_present(skb)) {
-			eseg->inline_hdr.sz =3D cpu_to_be16(ihs + VLAN_HLEN);
-			mlx5e_insert_vlan(eseg->inline_hdr.start, skb, ihs);
+			eseg->inline_hdr.sz =3D cpu_to_be16(attr->ihs + VLAN_HLEN);
+			mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs);
 			stats->added_vlan_packets++;
 		} else {
-			eseg->inline_hdr.sz =3D cpu_to_be16(ihs);
-			memcpy(eseg->inline_hdr.start, skb->data, ihs);
+			eseg->inline_hdr.sz =3D cpu_to_be16(attr->ihs);
+			memcpy(eseg->inline_hdr.start, skb->data, attr->ihs);
 		}
-		dseg +=3D ds_cnt_inl;
+		dseg +=3D wqe_attr->ds_cnt_inl;
 	} else if (skb_vlan_tag_present(skb)) {
 		eseg->insert.type =3D cpu_to_be16(MLX5_ETH_WQE_INSERT_VLAN);
 		if (skb->vlan_proto =3D=3D cpu_to_be16(ETH_P_8021AD))
@@ -365,12 +386,12 @@ void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_=
buff *skb,
 		stats->added_vlan_packets++;
 	}
=20
-	num_dma =3D mlx5e_txwqe_build_dsegs(sq, skb, skb->data + ihs, headlen, ds=
eg);
+	num_dma =3D mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs,
+					  attr->headlen, dseg);
 	if (unlikely(num_dma < 0))
 		goto err_drop;
=20
-	mlx5e_txwqe_complete(sq, skb, opcode, ds_cnt, num_wqebbs, num_bytes,
-			     num_dma, wi, cseg, xmit_more);
+	mlx5e_txwqe_complete(sq, skb, attr, wqe_attr, num_dma, wi, cseg, xmit_mor=
e);
=20
 	return;
=20
@@ -383,6 +404,8 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_=
device *dev)
 {
 	struct mlx5e_priv *priv =3D netdev_priv(dev);
 	struct mlx5e_accel_tx_state accel =3D {};
+	struct mlx5e_tx_wqe_attr wqe_attr;
+	struct mlx5e_tx_attr attr;
 	struct mlx5e_tx_wqe *wqe;
 	struct mlx5e_txqsq *sq;
 	u16 pi;
@@ -393,19 +416,64 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct ne=
t_device *dev)
 	if (unlikely(!mlx5e_accel_tx_begin(dev, sq, skb, &accel)))
 		goto out;
=20
-	pi =3D mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	mlx5e_sq_xmit_prepare(sq, skb, &accel, &attr);
+	mlx5e_sq_calc_wqe_attr(skb, &attr, &wqe_attr);
+	pi =3D mlx5e_txqsq_get_next_pi(sq, wqe_attr.num_wqebbs);
 	wqe =3D MLX5E_TX_FETCH_WQE(sq, pi);
=20
 	/* May update the WQE, but may not post other WQEs. */
 	if (unlikely(!mlx5e_accel_tx_finish(priv, sq, skb, wqe, &accel)))
 		goto out;
=20
-	mlx5e_sq_xmit(sq, skb, wqe, pi, netdev_xmit_more());
+	mlx5e_txwqe_build_eseg_csum(sq, skb, &wqe->eth);
+	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, netdev_xmit_more())=
;
=20
 out:
 	return NETDEV_TX_OK;
 }
=20
+void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struct sk_buff *skb, boo=
l xmit_more)
+{
+	struct mlx5e_tx_wqe_attr wqe_attr;
+	struct mlx5e_tx_attr attr;
+	struct mlx5e_tx_wqe *wqe;
+	u16 pi;
+
+	mlx5e_sq_xmit_prepare(sq, skb, NULL, &attr);
+	mlx5e_sq_calc_wqe_attr(skb, &attr, &wqe_attr);
+	pi =3D mlx5e_txqsq_get_next_pi(sq, wqe_attr.num_wqebbs);
+	wqe =3D MLX5E_TX_FETCH_WQE(sq, pi);
+	mlx5e_txwqe_build_eseg_csum(sq, skb, &wqe->eth);
+	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, xmit_more);
+}
+
+static inline void mlx5e_tx_wi_dma_unmap(struct mlx5e_txqsq *sq,
+					 struct mlx5e_tx_wqe_info *wi,
+					 u32 *dma_fifo_cc)
+{
+	int i;
+
+	for (i =3D 0; i < wi->num_dma; i++) {
+		struct mlx5e_sq_dma *dma =3D mlx5e_dma_get(sq, (*dma_fifo_cc)++);
+
+		mlx5e_tx_dma_unmap(sq->pdev, dma);
+	}
+}
+
+static inline void mlx5e_consume_skb(struct mlx5e_txqsq *sq, struct sk_buf=
f *skb,
+				     struct mlx5_cqe64 *cqe, int napi_budget)
+{
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
+		struct skb_shared_hwtstamps hwts =3D {};
+		u64 ts =3D get_cqe_ts(cqe);
+
+		hwts.hwtstamp =3D mlx5_timecounter_cyc2time(sq->clock, ts);
+		skb_tstamp_tx(skb, &hwts);
+	}
+
+	napi_consume_skb(skb, napi_budget);
+}
+
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 {
 	struct mlx5e_sq_stats *stats;
@@ -452,7 +520,6 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_bud=
get)
=20
 		do {
 			struct sk_buff *skb;
-			int j;
=20
 			last_wqe =3D (sqcc =3D=3D wqe_counter);
=20
@@ -460,33 +527,18 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_b=
udget)
 			wi =3D &sq->db.wqe_info[ci];
 			skb =3D wi->skb;
=20
+			sqcc +=3D wi->num_wqebbs;
+
 			if (unlikely(!skb)) {
 				mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
-				sqcc +=3D wi->num_wqebbs;
 				continue;
 			}
=20
-			if (unlikely(skb_shinfo(skb)->tx_flags &
-				     SKBTX_HW_TSTAMP)) {
-				struct skb_shared_hwtstamps hwts =3D {};
-
-				hwts.hwtstamp =3D
-					mlx5_timecounter_cyc2time(sq->clock,
-								  get_cqe_ts(cqe));
-				skb_tstamp_tx(skb, &hwts);
-			}
-
-			for (j =3D 0; j < wi->num_dma; j++) {
-				struct mlx5e_sq_dma *dma =3D
-					mlx5e_dma_get(sq, dma_fifo_cc++);
-
-				mlx5e_tx_dma_unmap(sq->pdev, dma);
-			}
+			mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
+			mlx5e_consume_skb(sq, wi->skb, cqe, napi_budget);
=20
 			npkts++;
 			nbytes +=3D wi->num_bytes;
-			sqcc +=3D wi->num_wqebbs;
-			napi_consume_skb(skb, napi_budget);
 		} while (!last_wqe);
=20
 		if (unlikely(get_cqe_opcode(cqe) =3D=3D MLX5_CQE_REQ_ERR)) {
@@ -531,7 +583,6 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 	u32 dma_fifo_cc, nbytes =3D 0;
 	u16 ci, sqcc, npkts =3D 0;
 	struct sk_buff *skb;
-	int i;
=20
 	sqcc =3D sq->cc;
 	dma_fifo_cc =3D sq->dma_fifo_cc;
@@ -541,23 +592,18 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 		wi =3D &sq->db.wqe_info[ci];
 		skb =3D wi->skb;
=20
+		sqcc +=3D wi->num_wqebbs;
+
 		if (!skb) {
 			mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
-			sqcc +=3D wi->num_wqebbs;
 			continue;
 		}
=20
-		for (i =3D 0; i < wi->num_dma; i++) {
-			struct mlx5e_sq_dma *dma =3D
-				mlx5e_dma_get(sq, dma_fifo_cc++);
-
-			mlx5e_tx_dma_unmap(sq->pdev, dma);
-		}
-
+		mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
 		dev_kfree_skb_any(skb);
+
 		npkts++;
 		nbytes +=3D wi->num_bytes;
-		sqcc +=3D wi->num_wqebbs;
 	}
=20
 	sq->dma_fifo_cc =3D dma_fifo_cc;
@@ -576,9 +622,34 @@ mlx5i_txwqe_build_datagram(struct mlx5_av *av, u32 dqp=
n, u32 dqkey,
 	dseg->av.key.qkey.qkey =3D cpu_to_be32(dqkey);
 }
=20
+static void mlx5i_sq_calc_wqe_attr(struct sk_buff *skb,
+				   const struct mlx5e_tx_attr *attr,
+				   struct mlx5e_tx_wqe_attr *wqe_attr)
+{
+	u16 ds_cnt =3D sizeof(struct mlx5i_tx_wqe) / MLX5_SEND_WQE_DS;
+	u16 ds_cnt_inl =3D 0;
+
+	ds_cnt +=3D !!attr->headlen + skb_shinfo(skb)->nr_frags;
+
+	if (attr->ihs) {
+		u16 inl =3D attr->ihs - INL_HDR_START_SZ;
+
+		ds_cnt_inl =3D DIV_ROUND_UP(inl, MLX5_SEND_WQE_DS);
+		ds_cnt +=3D ds_cnt_inl;
+	}
+
+	*wqe_attr =3D (struct mlx5e_tx_wqe_attr) {
+		.ds_cnt     =3D ds_cnt,
+		.ds_cnt_inl =3D ds_cnt_inl,
+		.num_wqebbs =3D DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS),
+	};
+}
+
 void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		   struct mlx5_av *av, u32 dqpn, u32 dqkey, bool xmit_more)
 {
+	struct mlx5e_tx_wqe_attr wqe_attr;
+	struct mlx5e_tx_attr attr;
 	struct mlx5i_tx_wqe *wqe;
=20
 	struct mlx5_wqe_datagram_seg *datagram;
@@ -588,47 +659,17 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_=
buff *skb,
 	struct mlx5e_tx_wqe_info *wi;
=20
 	struct mlx5e_sq_stats *stats =3D sq->stats;
-	u16 ds_cnt, ds_cnt_inl =3D 0;
-	u8 num_wqebbs, opcode;
-	u16 headlen, ihs, pi;
-	u32 num_bytes;
 	int num_dma;
-	__be16 mss;
+	u16 pi;
=20
-	/* Calc ihs and ds cnt, no writes to wqe yet */
-	ds_cnt =3D sizeof(*wqe) / MLX5_SEND_WQE_DS;
-	if (skb_is_gso(skb)) {
-		opcode    =3D MLX5_OPCODE_LSO;
-		mss       =3D cpu_to_be16(skb_shinfo(skb)->gso_size);
-		ihs       =3D mlx5e_tx_get_gso_ihs(sq, skb);
-		num_bytes =3D skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs;
-		stats->packets +=3D skb_shinfo(skb)->gso_segs;
-	} else {
-		u8 mode =3D mlx5e_tx_wqe_inline_mode(sq, NULL, skb);
+	mlx5e_sq_xmit_prepare(sq, skb, NULL, &attr);
+	mlx5i_sq_calc_wqe_attr(skb, &attr, &wqe_attr);
=20
-		opcode    =3D MLX5_OPCODE_SEND;
-		mss       =3D 0;
-		ihs       =3D mlx5e_calc_min_inline(mode, skb);
-		num_bytes =3D max_t(unsigned int, skb->len, ETH_ZLEN);
-		stats->packets++;
-	}
+	pi =3D mlx5e_txqsq_get_next_pi(sq, wqe_attr.num_wqebbs);
+	wqe =3D MLX5I_SQ_FETCH_WQE(sq, pi);
=20
-	stats->bytes     +=3D num_bytes;
 	stats->xmit_more +=3D xmit_more;
=20
-	headlen =3D skb->len - ihs - skb->data_len;
-	ds_cnt +=3D !!headlen;
-	ds_cnt +=3D skb_shinfo(skb)->nr_frags;
-
-	if (ihs) {
-		ds_cnt_inl =3D DIV_ROUND_UP(ihs - INL_HDR_START_SZ, MLX5_SEND_WQE_DS);
-		ds_cnt +=3D ds_cnt_inl;
-	}
-
-	num_wqebbs =3D DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
-	pi =3D mlx5e_txqsq_get_next_pi(sq, num_wqebbs);
-	wqe =3D MLX5I_SQ_FETCH_WQE(sq, pi);
-
 	/* fill wqe */
 	wi       =3D &sq->db.wqe_info[pi];
 	cseg     =3D &wqe->ctrl;
@@ -640,20 +681,20 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_=
buff *skb,
=20
 	mlx5e_txwqe_build_eseg_csum(sq, skb, eseg);
=20
-	eseg->mss =3D mss;
+	eseg->mss =3D attr.mss;
=20
-	if (ihs) {
-		memcpy(eseg->inline_hdr.start, skb->data, ihs);
-		eseg->inline_hdr.sz =3D cpu_to_be16(ihs);
-		dseg +=3D ds_cnt_inl;
+	if (attr.ihs) {
+		memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
+		eseg->inline_hdr.sz =3D cpu_to_be16(attr.ihs);
+		dseg +=3D wqe_attr.ds_cnt_inl;
 	}
=20
-	num_dma =3D mlx5e_txwqe_build_dsegs(sq, skb, skb->data + ihs, headlen, ds=
eg);
+	num_dma =3D mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr.ihs,
+					  attr.headlen, dseg);
 	if (unlikely(num_dma < 0))
 		goto err_drop;
=20
-	mlx5e_txwqe_complete(sq, skb, opcode, ds_cnt, num_wqebbs, num_bytes,
-			     num_dma, wi, cseg, xmit_more);
+	mlx5e_txwqe_complete(sq, skb, &attr, &wqe_attr, num_dma, wi, cseg, xmit_m=
ore);
=20
 	return;
=20
--=20
2.26.2

