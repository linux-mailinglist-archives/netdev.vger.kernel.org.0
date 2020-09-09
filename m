Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4BD26247B
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 03:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbgIIB2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 21:28:40 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19457 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbgIIB2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 21:28:30 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f582fa90006>; Tue, 08 Sep 2020 18:28:09 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 18:28:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 08 Sep 2020 18:28:23 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 01:28:15 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Tariq Toukan" <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 08/12] net/mlx5e: Support multiple SKBs in a TX WQE
Date:   Tue, 8 Sep 2020 18:27:53 -0700
Message-ID: <20200909012757.32677-9-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909012757.32677-1-saeedm@nvidia.com>
References: <20200909012757.32677-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599614889; bh=p4FpQvplA8kO0HUSgPwbUpWXnxtt1TCnroxWUvmzms8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=I680OycuTXzwsn7fdSZZMJL78d2dUNXV9uG6/IeYUPfAlHFBhUZb2hrlb6GWHTAzV
         JfF6XntV4YJUTRgZk79OMGBXrQyI78QTaQKrE1VZzrZh9kKJV3OYJmYg3eFkbjtVIY
         NHxOvDkwtjO+Z8jZrZ38lMG015AfmWgd3jbL7R58FrfT903sEgOR+iAisUAq99KNgh
         +kz51HyCRKnFFBC95LIuWNOYnzm/I0LZRfSxc9GKIhvpIvBde8iKxYNrAeeWuAmxeR
         TD+UwvnbE8d7A6OAFLp72MTW6IOdtyKk27GHzd14brFrc0CXkr2bPdfgyHcw4E9yTa
         wXJvfSkwvcDZw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

TX MPWQE support for SKBs is coming in one of the following patches, and
a single MPWQE can send multiple SKBs. This commit prepares the TX path
code to handle such cases:

1. An additional FIFO for SKBs is added, just like the FIFO for DMA
chunks.

2. struct mlx5e_tx_wqe_info will contain num_fifo_pkts. If a given WQE
contains only one packet, num_fifo_pkts will be zero, and the SKB will
be stored in mlx5e_tx_wqe_info, as usual. If num_fifo_pkts > 0, the SKB
pointer will be NULL, and the SKBs will be stored in the FIFO.

This change has no performance impact in TCP single stream test and
XDP_TX single stream test.

UDP pktgen (burst 32), single stream:
  Packet rate: 19.23 Mpps -> 19.12 Mpps
  Instructions per packet: 360 -> 354
  Cycles per packet: 142 -> 140

CPU: Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz (x86_64)
NIC: Mellanox ConnectX-6 Dx

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  4 ++
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 18 +++++
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   | 10 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  7 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 71 ++++++++++++++-----
 5 files changed, 89 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 4f33658da25a..6ab60074fca9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -317,11 +317,13 @@ struct mlx5e_txqsq {
=20
 	/* dirtied @completion */
 	u16                        cc;
+	u16                        skb_fifo_cc;
 	u32                        dma_fifo_cc;
 	struct dim                 dim; /* Adaptive Moderation */
=20
 	/* dirtied @xmit */
 	u16                        pc ____cacheline_aligned_in_smp;
+	u16                        skb_fifo_pc;
 	u32                        dma_fifo_pc;
=20
 	struct mlx5e_cq            cq;
@@ -329,9 +331,11 @@ struct mlx5e_txqsq {
 	/* read only */
 	struct mlx5_wq_cyc         wq;
 	u32                        dma_fifo_mask;
+	u16                        skb_fifo_mask;
 	struct mlx5e_sq_stats     *stats;
 	struct {
 		struct mlx5e_sq_dma       *dma_fifo;
+		struct sk_buff           **skb_fifo;
 		struct mlx5e_tx_wqe_info  *wqe_info;
 	} db;
 	void __iomem              *uar_map;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 277725c05de4..03fe92323f48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -105,6 +105,7 @@ struct mlx5e_tx_wqe_info {
 	u32 num_bytes;
 	u8 num_wqebbs;
 	u8 num_dma;
+	u8 num_fifo_pkts;
 #ifdef CONFIG_MLX5_EN_TLS
 	struct page *resync_dump_frag_page;
 #endif
@@ -231,6 +232,23 @@ mlx5e_dma_push(struct mlx5e_txqsq *sq, dma_addr_t addr=
, u32 size,
 	dma->type =3D map_type;
 }
=20
+static inline struct sk_buff **mlx5e_skb_fifo_get(struct mlx5e_txqsq *sq, =
u16 i)
+{
+	return &sq->db.skb_fifo[i & sq->skb_fifo_mask];
+}
+
+static inline void mlx5e_skb_fifo_push(struct mlx5e_txqsq *sq, struct sk_b=
uff *skb)
+{
+	struct sk_buff **skb_item =3D mlx5e_skb_fifo_get(sq, sq->skb_fifo_pc++);
+
+	*skb_item =3D skb;
+}
+
+static inline struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_txqsq *sq)
+{
+	return *mlx5e_skb_fifo_get(sq, sq->skb_fifo_cc++);
+}
+
 static inline void
 mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b=
/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index fcfb156cf09d..7521c9be735b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -29,20 +29,24 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_=
icosq_wqe_info *wi,
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
 					   u32 *dma_fifo_cc);
-static inline void
+static inline bool
 mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					  struct mlx5e_tx_wqe_info *wi,
 					  u32 *dma_fifo_cc)
 {
-	if (unlikely(wi->resync_dump_frag_page))
+	if (unlikely(wi->resync_dump_frag_page)) {
 		mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, dma_fifo_cc);
+		return true;
+	}
+	return false;
 }
 #else
-static inline void
+static inline bool
 mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					  struct mlx5e_tx_wqe_info *wi,
 					  u32 *dma_fifo_cc)
 {
+	return false;
 }
=20
 #endif /* CONFIG_MLX5_EN_TLS */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 26834625556d..b413aa168e4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1040,6 +1040,7 @@ static void mlx5e_free_icosq(struct mlx5e_icosq *sq)
 static void mlx5e_free_txqsq_db(struct mlx5e_txqsq *sq)
 {
 	kvfree(sq->db.wqe_info);
+	kvfree(sq->db.skb_fifo);
 	kvfree(sq->db.dma_fifo);
 }
=20
@@ -1051,15 +1052,19 @@ static int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq =
*sq, int numa)
 	sq->db.dma_fifo =3D kvzalloc_node(array_size(df_sz,
 						   sizeof(*sq->db.dma_fifo)),
 					GFP_KERNEL, numa);
+	sq->db.skb_fifo =3D kvzalloc_node(array_size(df_sz,
+						   sizeof(*sq->db.skb_fifo)),
+					GFP_KERNEL, numa);
 	sq->db.wqe_info =3D kvzalloc_node(array_size(wq_sz,
 						   sizeof(*sq->db.wqe_info)),
 					GFP_KERNEL, numa);
-	if (!sq->db.dma_fifo || !sq->db.wqe_info) {
+	if (!sq->db.dma_fifo || !sq->db.skb_fifo || !sq->db.wqe_info) {
 		mlx5e_free_txqsq_db(sq);
 		return -ENOMEM;
 	}
=20
 	sq->dma_fifo_mask =3D df_sz - 1;
+	sq->skb_fifo_mask =3D df_sz - 1;
=20
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index cabc84e71b2d..d42f3c1dfa26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -343,6 +343,7 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_=
buff *skb,
 		.num_bytes =3D attr->num_bytes,
 		.num_dma =3D num_dma,
 		.num_wqebbs =3D wqe_attr->num_wqebbs,
+		.num_fifo_pkts =3D 0,
 	};
=20
 	cseg->opmod_idx_opcode =3D cpu_to_be32((sq->pc << 8) | attr->opcode);
@@ -491,6 +492,20 @@ static inline void mlx5e_consume_skb(struct mlx5e_txqs=
q *sq, struct sk_buff *skb
 	napi_consume_skb(skb, napi_budget);
 }
=20
+static inline void mlx5e_tx_wi_consume_fifo_skbs(struct mlx5e_txqsq *sq,
+						 struct mlx5e_tx_wqe_info *wi,
+						 struct mlx5_cqe64 *cqe,
+						 int napi_budget)
+{
+	int i;
+
+	for (i =3D 0; i < wi->num_fifo_pkts; i++) {
+		struct sk_buff *skb =3D mlx5e_skb_fifo_pop(sq);
+
+		mlx5e_consume_skb(sq, skb, cqe, napi_budget);
+	}
+}
+
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 {
 	struct mlx5e_sq_stats *stats;
@@ -536,26 +551,33 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_b=
udget)
 		wqe_counter =3D be16_to_cpu(cqe->wqe_counter);
=20
 		do {
-			struct sk_buff *skb;
-
 			last_wqe =3D (sqcc =3D=3D wqe_counter);
=20
 			ci =3D mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 			wi =3D &sq->db.wqe_info[ci];
-			skb =3D wi->skb;
=20
 			sqcc +=3D wi->num_wqebbs;
=20
-			if (unlikely(!skb)) {
-				mlx5e_ktls_tx_try_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
+			if (likely(wi->skb)) {
+				mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
+				mlx5e_consume_skb(sq, wi->skb, cqe, napi_budget);
+
+				npkts++;
+				nbytes +=3D wi->num_bytes;
 				continue;
 			}
=20
-			mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
-			mlx5e_consume_skb(sq, wi->skb, cqe, napi_budget);
+			if (unlikely(mlx5e_ktls_tx_try_handle_resync_dump_comp(sq, wi,
+									       &dma_fifo_cc)))
+				continue;
=20
-			npkts++;
-			nbytes +=3D wi->num_bytes;
+			if (wi->num_fifo_pkts) {
+				mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
+				mlx5e_tx_wi_consume_fifo_skbs(sq, wi, cqe, napi_budget);
+
+				npkts +=3D wi->num_fifo_pkts;
+				nbytes +=3D wi->num_bytes;
+			}
 		} while (!last_wqe);
=20
 		if (unlikely(get_cqe_opcode(cqe) =3D=3D MLX5_CQE_REQ_ERR)) {
@@ -594,12 +616,19 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_b=
udget)
 	return (i =3D=3D MLX5E_TX_CQ_POLL_BUDGET);
 }
=20
+static void mlx5e_tx_wi_kfree_fifo_skbs(struct mlx5e_txqsq *sq, struct mlx=
5e_tx_wqe_info *wi)
+{
+	int i;
+
+	for (i =3D 0; i < wi->num_fifo_pkts; i++)
+		dev_kfree_skb_any(mlx5e_skb_fifo_pop(sq));
+}
+
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 {
 	struct mlx5e_tx_wqe_info *wi;
 	u32 dma_fifo_cc, nbytes =3D 0;
 	u16 ci, sqcc, npkts =3D 0;
-	struct sk_buff *skb;
=20
 	sqcc =3D sq->cc;
 	dma_fifo_cc =3D sq->dma_fifo_cc;
@@ -607,20 +636,28 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 	while (sqcc !=3D sq->pc) {
 		ci =3D mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 		wi =3D &sq->db.wqe_info[ci];
-		skb =3D wi->skb;
=20
 		sqcc +=3D wi->num_wqebbs;
=20
-		if (!skb) {
-			mlx5e_ktls_tx_try_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
+		if (likely(wi->skb)) {
+			mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
+			dev_kfree_skb_any(wi->skb);
+
+			npkts++;
+			nbytes +=3D wi->num_bytes;
 			continue;
 		}
=20
-		mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
-		dev_kfree_skb_any(skb);
+		if (unlikely(mlx5e_ktls_tx_try_handle_resync_dump_comp(sq, wi, &dma_fifo=
_cc)))
+			continue;
=20
-		npkts++;
-		nbytes +=3D wi->num_bytes;
+		if (wi->num_fifo_pkts) {
+			mlx5e_tx_wi_dma_unmap(sq, wi, &dma_fifo_cc);
+			mlx5e_tx_wi_kfree_fifo_skbs(sq, wi);
+
+			npkts +=3D wi->num_fifo_pkts;
+			nbytes +=3D wi->num_bytes;
+		}
 	}
=20
 	sq->dma_fifo_cc =3D dma_fifo_cc;
--=20
2.26.2

