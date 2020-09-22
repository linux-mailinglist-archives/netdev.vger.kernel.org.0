Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03022738D9
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgIVCro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:47:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729071AbgIVCrn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 22:47:43 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0363F22262;
        Tue, 22 Sep 2020 02:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600742862;
        bh=bc0FfhG+5+bsgX0oWDsc8rym25qsjjsu4YU3nIiJTQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xzc3+MlyKDjZv60WT5i9OwIg9e3lIHdMXABEMPSwQf181He4XSLvs2tNuI4WfERS7
         zczcUbghOzY28XWVL/9UsZ4+IeuXXhr2l+zTP1u509oRkXxKHiMlTniGV8L4OTpHni
         rz/HYZn1fvBJ171wscH3QWJVuHvqZOF8SxLQ3GoY=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 04/12] net/mlx5e: Refactor xmit functions
Date:   Mon, 21 Sep 2020 19:46:56 -0700
Message-Id: <20200922024704.544482-5-saeed@kernel.org>
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

When compiled with a recent GCC, this change shows no visible
performance impact on UDP pktgen (burst 32) single stream test either:
  Packet rate: 16.86 Mpps (±0.15 Mpps) -> 16.95 Mpps (±0.15 Mpps)
  Instructions per packet: 434 -> 429
  Cycles per packet: 158 -> 160
  Instructions per cycle: 2.75 -> 2.69

CPU: Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz (x86_64)
NIC: Mellanox ConnectX-6 Dx
GCC 10.2.0

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  21 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h    |   5 +
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 357 ++++++++++--------
 4 files changed, 202 insertions(+), 187 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 6be04a236017..9931a605eed9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -41,8 +41,6 @@ void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq);
 u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 		       struct net_device *sb_dev);
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
-void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-		   struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more);
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
 
@@ -188,23 +186,6 @@ static inline u16 mlx5e_icosq_get_next_pi(struct mlx5e_icosq *sq, u16 size)
 	return pi;
 }
 
-static inline void
-mlx5e_fill_sq_frag_edge(struct mlx5e_txqsq *sq, struct mlx5_wq_cyc *wq,
-			u16 pi, u16 nnops)
-{
-	struct mlx5e_tx_wqe_info *edge_wi, *wi = &sq->db.wqe_info[pi];
-
-	edge_wi = wi + nnops;
-
-	/* fill sq frag edge with nops to avoid wqe wrapping two pages */
-	for (; wi < edge_wi; wi++) {
-		memset(wi, 0, sizeof(*wi));
-		wi->num_wqebbs = 1;
-		mlx5e_post_nop(wq, sq->sqn, &sq->pc);
-	}
-	sq->stats->nop += nnops;
-}
-
 static inline void
 mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
 		struct mlx5_wqe_ctrl_seg *ctrl)
@@ -263,6 +244,8 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
 	}
 }
 
+void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struct sk_buff *skb, bool xmit_more);
+
 static inline void mlx5e_rqwq_reset(struct mlx5e_rq *rq)
 {
 	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 110476bdeffb..23d4ef5ab9c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -145,6 +145,11 @@ static inline bool mlx5e_accel_tx_finish(struct mlx5e_priv *priv,
 	}
 #endif
 
+#if IS_ENABLED(CONFIG_GENEVE)
+	if (skb->encapsulation)
+		mlx5e_tx_tunnel_accel(skb, &wqe->eth);
+#endif
+
 	return true;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index b0c31d49ff8d..c36560b3e93d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -189,12 +189,10 @@ static bool mlx5e_tls_handle_ooo(struct mlx5e_tls_offload_context_tx *context,
 				 struct mlx5e_tls *tls)
 {
 	u32 tcp_seq = ntohl(tcp_hdr(skb)->seq);
-	struct mlx5e_tx_wqe *wqe;
 	struct sync_info info;
 	struct sk_buff *nskb;
 	int linear_len = 0;
 	int headln;
-	u16 pi;
 	int i;
 
 	sq->stats->tls_ooo++;
@@ -246,9 +244,7 @@ static bool mlx5e_tls_handle_ooo(struct mlx5e_tls_offload_context_tx *context,
 	sq->stats->tls_resync_bytes += nskb->len;
 	mlx5e_tls_complete_sync_skb(skb, nskb, tcp_seq, headln,
 				    cpu_to_be64(info.rcd_sn));
-	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
-	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
-	mlx5e_sq_xmit(sq, nskb, wqe, pi, true);
+	mlx5e_sq_xmit_simple(sq, nskb, true);
 
 	return true;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 69afda1f7bb9..939bbf0aa2c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -232,19 +232,30 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	return -ENOMEM;
 }
 
-static bool mlx5e_transport_inline_tx_wqe(struct mlx5_wqe_ctrl_seg *cseg)
-{
-	return cseg && !!cseg->tis_tir_num;
-}
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
 
 static u8
-mlx5e_tx_wqe_inline_mode(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
-			 struct sk_buff *skb)
+mlx5e_tx_wqe_inline_mode(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+			 struct mlx5e_accel_tx_state *accel)
 {
 	u8 mode;
 
-	if (mlx5e_transport_inline_tx_wqe(cseg))
+#ifdef CONFIG_MLX5_EN_TLS
+	if (accel && accel->tls.tls_tisn)
 		return MLX5_INLINE_MODE_TCP_UDP;
+#endif
 
 	mode = sq->min_inline_mode;
 
@@ -255,9 +266,71 @@ mlx5e_tx_wqe_inline_mode(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
 	return mode;
 }
 
+static void mlx5e_sq_xmit_prepare(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+				  struct mlx5e_accel_tx_state *accel,
+				  struct mlx5e_tx_attr *attr)
+{
+	struct mlx5e_sq_stats *stats = sq->stats;
+
+	if (skb_is_gso(skb)) {
+		u16 ihs = mlx5e_tx_get_gso_ihs(sq, skb);
+
+		*attr = (struct mlx5e_tx_attr) {
+			.opcode    = MLX5_OPCODE_LSO,
+			.mss       = cpu_to_be16(skb_shinfo(skb)->gso_size),
+			.ihs       = ihs,
+			.num_bytes = skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs,
+			.headlen   = skb_headlen(skb) - ihs,
+		};
+
+		stats->packets += skb_shinfo(skb)->gso_segs;
+	} else {
+		u8 mode = mlx5e_tx_wqe_inline_mode(sq, skb, accel);
+		u16 ihs = mlx5e_calc_min_inline(mode, skb);
+
+		*attr = (struct mlx5e_tx_attr) {
+			.opcode    = MLX5_OPCODE_SEND,
+			.mss       = cpu_to_be16(0),
+			.ihs       = ihs,
+			.num_bytes = max_t(unsigned int, skb->len, ETH_ZLEN),
+			.headlen   = skb_headlen(skb) - ihs,
+		};
+
+		stats->packets++;
+	}
+
+	stats->bytes += attr->num_bytes;
+}
+
+static void mlx5e_sq_calc_wqe_attr(struct sk_buff *skb, const struct mlx5e_tx_attr *attr,
+				   struct mlx5e_tx_wqe_attr *wqe_attr)
+{
+	u16 ds_cnt = sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS;
+	u16 ds_cnt_inl = 0;
+
+	ds_cnt += !!attr->headlen + skb_shinfo(skb)->nr_frags;
+
+	if (attr->ihs) {
+		u16 inl = attr->ihs - INL_HDR_START_SZ;
+
+		if (skb_vlan_tag_present(skb))
+			inl += VLAN_HLEN;
+
+		ds_cnt_inl = DIV_ROUND_UP(inl, MLX5_SEND_WQE_DS);
+		ds_cnt += ds_cnt_inl;
+	}
+
+	*wqe_attr = (struct mlx5e_tx_wqe_attr) {
+		.ds_cnt     = ds_cnt,
+		.ds_cnt_inl = ds_cnt_inl,
+		.num_wqebbs = DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS),
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
@@ -266,13 +339,13 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 	*wi = (struct mlx5e_tx_wqe_info) {
 		.skb = skb,
-		.num_bytes = num_bytes,
+		.num_bytes = attr->num_bytes,
 		.num_dma = num_dma,
-		.num_wqebbs = num_wqebbs,
+		.num_wqebbs = wqe_attr->num_wqebbs,
 	};
 
-	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | opcode);
-	cseg->qpn_ds           = cpu_to_be32((sq->sqn << 8) | ds_cnt);
+	cseg->opmod_idx_opcode = cpu_to_be32((sq->pc << 8) | attr->opcode);
+	cseg->qpn_ds           = cpu_to_be32((sq->sqn << 8) | wqe_attr->ds_cnt);
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
@@ -283,105 +356,44 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		sq->stats->stopped++;
 	}
 
-	send_doorbell = __netdev_tx_sent_queue(sq->txq, num_bytes,
-					       xmit_more);
+	send_doorbell = __netdev_tx_sent_queue(sq->txq, attr->num_bytes, xmit_more);
 	if (send_doorbell)
 		mlx5e_notify_hw(wq, sq->pc, sq->uar_map, cseg);
 }
 
-void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-		   struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more)
+static void
+mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+		  const struct mlx5e_tx_attr *attr, const struct mlx5e_tx_wqe_attr *wqe_attr,
+		  struct mlx5e_tx_wqe *wqe, u16 pi, bool xmit_more)
 {
-	struct mlx5_wq_cyc *wq = &sq->wq;
 	struct mlx5_wqe_ctrl_seg *cseg;
 	struct mlx5_wqe_eth_seg  *eseg;
 	struct mlx5_wqe_data_seg *dseg;
 	struct mlx5e_tx_wqe_info *wi;
 
 	struct mlx5e_sq_stats *stats = sq->stats;
-	u16 headlen, ihs, contig_wqebbs_room;
-	u16 ds_cnt, ds_cnt_inl = 0;
-	u8 num_wqebbs, opcode;
-	u32 num_bytes;
 	int num_dma;
-	__be16 mss;
-
-	/* Calc ihs and ds cnt, no writes to wqe yet */
-	ds_cnt = sizeof(*wqe) / MLX5_SEND_WQE_DS;
-	if (skb_is_gso(skb)) {
-		opcode    = MLX5_OPCODE_LSO;
-		mss       = cpu_to_be16(skb_shinfo(skb)->gso_size);
-		ihs       = mlx5e_tx_get_gso_ihs(sq, skb);
-		num_bytes = skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs;
-		stats->packets += skb_shinfo(skb)->gso_segs;
-	} else {
-		u8 mode = mlx5e_tx_wqe_inline_mode(sq, &wqe->ctrl, skb);
-
-		opcode    = MLX5_OPCODE_SEND;
-		mss       = 0;
-		ihs       = mlx5e_calc_min_inline(mode, skb);
-		num_bytes = max_t(unsigned int, skb->len, ETH_ZLEN);
-		stats->packets++;
-	}
 
-	stats->bytes     += num_bytes;
 	stats->xmit_more += xmit_more;
 
-	headlen = skb->len - ihs - skb->data_len;
-	ds_cnt += !!headlen;
-	ds_cnt += skb_shinfo(skb)->nr_frags;
-
-	if (ihs) {
-		u16 inl = ihs + !!skb_vlan_tag_present(skb) * VLAN_HLEN - INL_HDR_START_SZ;
-
-		ds_cnt_inl = DIV_ROUND_UP(inl, MLX5_SEND_WQE_DS);
-		ds_cnt += ds_cnt_inl;
-	}
-
-	num_wqebbs = DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
-	contig_wqebbs_room = mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
-	if (unlikely(contig_wqebbs_room < num_wqebbs)) {
-#ifdef CONFIG_MLX5_EN_IPSEC
-		struct mlx5_wqe_eth_seg cur_eth = wqe->eth;
-#endif
-#ifdef CONFIG_MLX5_EN_TLS
-		struct mlx5_wqe_ctrl_seg cur_ctrl = wqe->ctrl;
-#endif
-		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
-		pi = mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-		wqe = MLX5E_TX_FETCH_WQE(sq, pi);
-#ifdef CONFIG_MLX5_EN_IPSEC
-		wqe->eth = cur_eth;
-#endif
-#ifdef CONFIG_MLX5_EN_TLS
-		wqe->ctrl = cur_ctrl;
-#endif
-	}
-
 	/* fill wqe */
 	wi   = &sq->db.wqe_info[pi];
 	cseg = &wqe->ctrl;
 	eseg = &wqe->eth;
 	dseg =  wqe->data;
 
-#if IS_ENABLED(CONFIG_GENEVE)
-	if (skb->encapsulation)
-		mlx5e_tx_tunnel_accel(skb, eseg);
-#endif
-	mlx5e_txwqe_build_eseg_csum(sq, skb, eseg);
-
-	eseg->mss = mss;
+	eseg->mss = attr->mss;
 
-	if (ihs) {
+	if (attr->ihs) {
 		if (skb_vlan_tag_present(skb)) {
-			eseg->inline_hdr.sz = cpu_to_be16(ihs + VLAN_HLEN);
-			mlx5e_insert_vlan(eseg->inline_hdr.start, skb, ihs);
+			eseg->inline_hdr.sz = cpu_to_be16(attr->ihs + VLAN_HLEN);
+			mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs);
 			stats->added_vlan_packets++;
 		} else {
-			eseg->inline_hdr.sz = cpu_to_be16(ihs);
-			memcpy(eseg->inline_hdr.start, skb->data, ihs);
+			eseg->inline_hdr.sz = cpu_to_be16(attr->ihs);
+			memcpy(eseg->inline_hdr.start, skb->data, attr->ihs);
 		}
-		dseg += ds_cnt_inl;
+		dseg += wqe_attr->ds_cnt_inl;
 	} else if (skb_vlan_tag_present(skb)) {
 		eseg->insert.type = cpu_to_be16(MLX5_ETH_WQE_INSERT_VLAN);
 		if (skb->vlan_proto == cpu_to_be16(ETH_P_8021AD))
@@ -390,12 +402,12 @@ void mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		stats->added_vlan_packets++;
 	}
 
-	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + ihs, headlen, dseg);
+	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs,
+					  attr->headlen, dseg);
 	if (unlikely(num_dma < 0))
 		goto err_drop;
 
-	mlx5e_txwqe_complete(sq, skb, opcode, ds_cnt, num_wqebbs, num_bytes,
-			     num_dma, wi, cseg, xmit_more);
+	mlx5e_txwqe_complete(sq, skb, attr, wqe_attr, num_dma, wi, cseg, xmit_more);
 
 	return;
 
@@ -408,6 +420,8 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_accel_tx_state accel = {};
+	struct mlx5e_tx_wqe_attr wqe_attr;
+	struct mlx5e_tx_attr attr;
 	struct mlx5e_tx_wqe *wqe;
 	struct mlx5e_txqsq *sq;
 	u16 pi;
@@ -418,19 +432,63 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(!mlx5e_accel_tx_begin(dev, sq, skb, &accel)))
 		goto out;
 
-	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	mlx5e_sq_xmit_prepare(sq, skb, &accel, &attr);
+	mlx5e_sq_calc_wqe_attr(skb, &attr, &wqe_attr);
+	pi = mlx5e_txqsq_get_next_pi(sq, wqe_attr.num_wqebbs);
 	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
 
 	/* May update the WQE, but may not post other WQEs. */
 	if (unlikely(!mlx5e_accel_tx_finish(priv, sq, skb, wqe, &accel)))
 		goto out;
 
-	mlx5e_sq_xmit(sq, skb, wqe, pi, netdev_xmit_more());
+	mlx5e_txwqe_build_eseg_csum(sq, skb, &wqe->eth);
+	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, netdev_xmit_more());
 
 out:
 	return NETDEV_TX_OK;
 }
 
+void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struct sk_buff *skb, bool xmit_more)
+{
+	struct mlx5e_tx_wqe_attr wqe_attr;
+	struct mlx5e_tx_attr attr;
+	struct mlx5e_tx_wqe *wqe;
+	u16 pi;
+
+	mlx5e_sq_xmit_prepare(sq, skb, NULL, &attr);
+	mlx5e_sq_calc_wqe_attr(skb, &attr, &wqe_attr);
+	pi = mlx5e_txqsq_get_next_pi(sq, wqe_attr.num_wqebbs);
+	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
+	mlx5e_txwqe_build_eseg_csum(sq, skb, &wqe->eth);
+	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, xmit_more);
+}
+
+static void mlx5e_tx_wi_dma_unmap(struct mlx5e_txqsq *sq, struct mlx5e_tx_wqe_info *wi,
+				  u32 *dma_fifo_cc)
+{
+	int i;
+
+	for (i = 0; i < wi->num_dma; i++) {
+		struct mlx5e_sq_dma *dma = mlx5e_dma_get(sq, (*dma_fifo_cc)++);
+
+		mlx5e_tx_dma_unmap(sq->pdev, dma);
+	}
+}
+
+static void mlx5e_consume_skb(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+			      struct mlx5_cqe64 *cqe, int napi_budget)
+{
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
+		struct skb_shared_hwtstamps hwts = {};
+		u64 ts = get_cqe_ts(cqe);
+
+		hwts.hwtstamp = mlx5_timecounter_cyc2time(sq->clock, ts);
+		skb_tstamp_tx(skb, &hwts);
+	}
+
+	napi_consume_skb(skb, napi_budget);
+}
+
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 {
 	struct mlx5e_sq_stats *stats;
@@ -477,7 +535,6 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 
 		do {
 			struct sk_buff *skb;
-			int j;
 
 			last_wqe = (sqcc == wqe_counter);
 
@@ -485,33 +542,18 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 			wi = &sq->db.wqe_info[ci];
 			skb = wi->skb;
 
+			sqcc += wi->num_wqebbs;
+
 			if (unlikely(!skb)) {
 				mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
-				sqcc += wi->num_wqebbs;
 				continue;
 			}
 
-			if (unlikely(skb_shinfo(skb)->tx_flags &
-				     SKBTX_HW_TSTAMP)) {
-				struct skb_shared_hwtstamps hwts = {};
-
-				hwts.hwtstamp =
-					mlx5_timecounter_cyc2time(sq->clock,
-								  get_cqe_ts(cqe));
-				skb_tstamp_tx(skb, &hwts);
-			}
-
-			for (j = 0; j < wi->num_dma; j++) {
-				struct mlx5e_sq_dma *dma =
-					mlx5e_dma_get(sq, dma_fifo_cc++);
-
-				mlx5e_tx_dma_unmap(sq->pdev, dma);
-			}
+			mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
+			mlx5e_consume_skb(sq, wi->skb, cqe, napi_budget);
 
 			npkts++;
 			nbytes += wi->num_bytes;
-			sqcc += wi->num_wqebbs;
-			napi_consume_skb(skb, napi_budget);
 		} while (!last_wqe);
 
 		if (unlikely(get_cqe_opcode(cqe) == MLX5_CQE_REQ_ERR)) {
@@ -556,7 +598,6 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 	u32 dma_fifo_cc, nbytes = 0;
 	u16 ci, sqcc, npkts = 0;
 	struct sk_buff *skb;
-	int i;
 
 	sqcc = sq->cc;
 	dma_fifo_cc = sq->dma_fifo_cc;
@@ -566,23 +607,18 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 		wi = &sq->db.wqe_info[ci];
 		skb = wi->skb;
 
+		sqcc += wi->num_wqebbs;
+
 		if (!skb) {
 			mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
-			sqcc += wi->num_wqebbs;
 			continue;
 		}
 
-		for (i = 0; i < wi->num_dma; i++) {
-			struct mlx5e_sq_dma *dma =
-				mlx5e_dma_get(sq, dma_fifo_cc++);
-
-			mlx5e_tx_dma_unmap(sq->pdev, dma);
-		}
-
+		mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
 		dev_kfree_skb_any(skb);
+
 		npkts++;
 		nbytes += wi->num_bytes;
-		sqcc += wi->num_wqebbs;
 	}
 
 	sq->dma_fifo_cc = dma_fifo_cc;
@@ -601,9 +637,34 @@ mlx5i_txwqe_build_datagram(struct mlx5_av *av, u32 dqpn, u32 dqkey,
 	dseg->av.key.qkey.qkey = cpu_to_be32(dqkey);
 }
 
+static void mlx5i_sq_calc_wqe_attr(struct sk_buff *skb,
+				   const struct mlx5e_tx_attr *attr,
+				   struct mlx5e_tx_wqe_attr *wqe_attr)
+{
+	u16 ds_cnt = sizeof(struct mlx5i_tx_wqe) / MLX5_SEND_WQE_DS;
+	u16 ds_cnt_inl = 0;
+
+	ds_cnt += !!attr->headlen + skb_shinfo(skb)->nr_frags;
+
+	if (attr->ihs) {
+		u16 inl = attr->ihs - INL_HDR_START_SZ;
+
+		ds_cnt_inl = DIV_ROUND_UP(inl, MLX5_SEND_WQE_DS);
+		ds_cnt += ds_cnt_inl;
+	}
+
+	*wqe_attr = (struct mlx5e_tx_wqe_attr) {
+		.ds_cnt     = ds_cnt,
+		.ds_cnt_inl = ds_cnt_inl,
+		.num_wqebbs = DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS),
+	};
+}
+
 void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		   struct mlx5_av *av, u32 dqpn, u32 dqkey, bool xmit_more)
 {
+	struct mlx5e_tx_wqe_attr wqe_attr;
+	struct mlx5e_tx_attr attr;
 	struct mlx5i_tx_wqe *wqe;
 
 	struct mlx5_wqe_datagram_seg *datagram;
@@ -613,47 +674,17 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	struct mlx5e_tx_wqe_info *wi;
 
 	struct mlx5e_sq_stats *stats = sq->stats;
-	u16 ds_cnt, ds_cnt_inl = 0;
-	u8 num_wqebbs, opcode;
-	u16 headlen, ihs, pi;
-	u32 num_bytes;
 	int num_dma;
-	__be16 mss;
+	u16 pi;
 
-	/* Calc ihs and ds cnt, no writes to wqe yet */
-	ds_cnt = sizeof(*wqe) / MLX5_SEND_WQE_DS;
-	if (skb_is_gso(skb)) {
-		opcode    = MLX5_OPCODE_LSO;
-		mss       = cpu_to_be16(skb_shinfo(skb)->gso_size);
-		ihs       = mlx5e_tx_get_gso_ihs(sq, skb);
-		num_bytes = skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs;
-		stats->packets += skb_shinfo(skb)->gso_segs;
-	} else {
-		u8 mode = mlx5e_tx_wqe_inline_mode(sq, NULL, skb);
+	mlx5e_sq_xmit_prepare(sq, skb, NULL, &attr);
+	mlx5i_sq_calc_wqe_attr(skb, &attr, &wqe_attr);
 
-		opcode    = MLX5_OPCODE_SEND;
-		mss       = 0;
-		ihs       = mlx5e_calc_min_inline(mode, skb);
-		num_bytes = max_t(unsigned int, skb->len, ETH_ZLEN);
-		stats->packets++;
-	}
+	pi = mlx5e_txqsq_get_next_pi(sq, wqe_attr.num_wqebbs);
+	wqe = MLX5I_SQ_FETCH_WQE(sq, pi);
 
-	stats->bytes     += num_bytes;
 	stats->xmit_more += xmit_more;
 
-	headlen = skb->len - ihs - skb->data_len;
-	ds_cnt += !!headlen;
-	ds_cnt += skb_shinfo(skb)->nr_frags;
-
-	if (ihs) {
-		ds_cnt_inl = DIV_ROUND_UP(ihs - INL_HDR_START_SZ, MLX5_SEND_WQE_DS);
-		ds_cnt += ds_cnt_inl;
-	}
-
-	num_wqebbs = DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
-	pi = mlx5e_txqsq_get_next_pi(sq, num_wqebbs);
-	wqe = MLX5I_SQ_FETCH_WQE(sq, pi);
-
 	/* fill wqe */
 	wi       = &sq->db.wqe_info[pi];
 	cseg     = &wqe->ctrl;
@@ -665,20 +696,20 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 	mlx5e_txwqe_build_eseg_csum(sq, skb, eseg);
 
-	eseg->mss = mss;
+	eseg->mss = attr.mss;
 
-	if (ihs) {
-		memcpy(eseg->inline_hdr.start, skb->data, ihs);
-		eseg->inline_hdr.sz = cpu_to_be16(ihs);
-		dseg += ds_cnt_inl;
+	if (attr.ihs) {
+		memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
+		eseg->inline_hdr.sz = cpu_to_be16(attr.ihs);
+		dseg += wqe_attr.ds_cnt_inl;
 	}
 
-	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + ihs, headlen, dseg);
+	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr.ihs,
+					  attr.headlen, dseg);
 	if (unlikely(num_dma < 0))
 		goto err_drop;
 
-	mlx5e_txwqe_complete(sq, skb, opcode, ds_cnt, num_wqebbs, num_bytes,
-			     num_dma, wi, cseg, xmit_more);
+	mlx5e_txwqe_complete(sq, skb, &attr, &wqe_attr, num_dma, wi, cseg, xmit_more);
 
 	return;
 
-- 
2.26.2

