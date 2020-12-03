Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487832CCDDF
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgLCEWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:22:14 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16507 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgLCEWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:22:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc867c50001>; Wed, 02 Dec 2020 20:21:25 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:21:25 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Eran Ben Elisha" <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next V2 05/15] net/mlx5e: Change skb fifo push/pop API to be used without SQ
Date:   Wed, 2 Dec 2020 20:20:58 -0800
Message-ID: <20201203042108.232706-6-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201203042108.232706-1-saeedm@nvidia.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606969285; bh=YGrZLGIDyouZ+CFeGnY3ajDL8iM1pEOQPSB7fhM1btU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=cZLbRvmlFmLVbl7w+7eTW3P9vN4XCLrpOxVW39s2qvOYxRrz2HHW7J352+WRLie8u
         Q1WNveTxGWZquSDVJ2TtMgnplgCUdwhsFxHvV2/B4ZmfKx17QBsy/sQ1xpJPqcJsXS
         9hV7mXgyNPNfoZ2g3eplOTmmRnSZ3VfY56U0vH1A/wJYHCX3G00Ub93mojTCBx1BrX
         TOgKUQlmB4K08cmcEYu2t/NiWxMXodUdAwxIs5dUHR815B6693H8+iI+46PAvxtTr6
         zdPSGHNMKkmFGCRlkJmRef4e6uyr8k8J+ybqbbv/DQPniEqFs1CQsnPQDZtdWGBSiD
         iBf16jLfL+e3A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

The skb fifo push/pop API used pre-defined attributes within the
mlx5e_txqsq.
In order to share the skb fifo API with other non-SQ use cases,
change the API input to get newly defined mlx5e_skb_fifo struct.

Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 10 ++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 15 +++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 13 ++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   |  6 +++---
 4 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index c014e8ff66aa..7f3bd3d406b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -331,6 +331,13 @@ struct mlx5e_tx_mpwqe {
 	u8 inline_on;
 };
=20
+struct mlx5e_skb_fifo {
+	struct sk_buff **fifo;
+	u16 *pc;
+	u16 *cc;
+	u16 mask;
+};
+
 struct mlx5e_txqsq {
 	/* data path */
=20
@@ -351,11 +358,10 @@ struct mlx5e_txqsq {
 	/* read only */
 	struct mlx5_wq_cyc         wq;
 	u32                        dma_fifo_mask;
-	u16                        skb_fifo_mask;
 	struct mlx5e_sq_stats     *stats;
 	struct {
 		struct mlx5e_sq_dma       *dma_fifo;
-		struct sk_buff           **skb_fifo;
+		struct mlx5e_skb_fifo      skb_fifo;
 		struct mlx5e_tx_wqe_info  *wqe_info;
 	} db;
 	void __iomem              *uar_map;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index ac47efaaebd5..115ab19ffab1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -250,21 +250,24 @@ mlx5e_dma_push(struct mlx5e_txqsq *sq, dma_addr_t add=
r, u32 size,
 	dma->type =3D map_type;
 }
=20
-static inline struct sk_buff **mlx5e_skb_fifo_get(struct mlx5e_txqsq *sq, =
u16 i)
+static inline
+struct sk_buff **mlx5e_skb_fifo_get(struct mlx5e_skb_fifo *fifo, u16 i)
 {
-	return &sq->db.skb_fifo[i & sq->skb_fifo_mask];
+	return &fifo->fifo[i & fifo->mask];
 }
=20
-static inline void mlx5e_skb_fifo_push(struct mlx5e_txqsq *sq, struct sk_b=
uff *skb)
+static inline
+void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
 {
-	struct sk_buff **skb_item =3D mlx5e_skb_fifo_get(sq, sq->skb_fifo_pc++);
+	struct sk_buff **skb_item =3D mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
=20
 	*skb_item =3D skb;
 }
=20
-static inline struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_txqsq *sq)
+static inline
+struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_skb_fifo *fifo)
 {
-	return *mlx5e_skb_fifo_get(sq, sq->skb_fifo_cc++);
+	return *mlx5e_skb_fifo_get(fifo, (*fifo->cc)++);
 }
=20
 static inline void
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 38506b8b6f82..3ea15d62acd9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1086,7 +1086,7 @@ static void mlx5e_free_icosq(struct mlx5e_icosq *sq)
 static void mlx5e_free_txqsq_db(struct mlx5e_txqsq *sq)
 {
 	kvfree(sq->db.wqe_info);
-	kvfree(sq->db.skb_fifo);
+	kvfree(sq->db.skb_fifo.fifo);
 	kvfree(sq->db.dma_fifo);
 }
=20
@@ -1098,19 +1098,22 @@ static int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq =
*sq, int numa)
 	sq->db.dma_fifo =3D kvzalloc_node(array_size(df_sz,
 						   sizeof(*sq->db.dma_fifo)),
 					GFP_KERNEL, numa);
-	sq->db.skb_fifo =3D kvzalloc_node(array_size(df_sz,
-						   sizeof(*sq->db.skb_fifo)),
+	sq->db.skb_fifo.fifo =3D kvzalloc_node(array_size(df_sz,
+							sizeof(*sq->db.skb_fifo.fifo)),
 					GFP_KERNEL, numa);
 	sq->db.wqe_info =3D kvzalloc_node(array_size(wq_sz,
 						   sizeof(*sq->db.wqe_info)),
 					GFP_KERNEL, numa);
-	if (!sq->db.dma_fifo || !sq->db.skb_fifo || !sq->db.wqe_info) {
+	if (!sq->db.dma_fifo || !sq->db.skb_fifo.fifo || !sq->db.wqe_info) {
 		mlx5e_free_txqsq_db(sq);
 		return -ENOMEM;
 	}
=20
 	sq->dma_fifo_mask =3D df_sz - 1;
-	sq->skb_fifo_mask =3D df_sz - 1;
+
+	sq->db.skb_fifo.pc   =3D &sq->skb_fifo_pc;
+	sq->db.skb_fifo.cc   =3D &sq->skb_fifo_cc;
+	sq->db.skb_fifo.mask =3D df_sz - 1;
=20
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 14af7488cc4f..c6b20b77a0f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -572,7 +572,7 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_b=
uff *skb,
 		goto err_unmap;
 	mlx5e_dma_push(sq, txd.dma_addr, txd.len, MLX5E_DMA_MAP_SINGLE);
=20
-	mlx5e_skb_fifo_push(sq, skb);
+	mlx5e_skb_fifo_push(&sq->db.skb_fifo, skb);
=20
 	mlx5e_tx_mpwqe_add_dseg(sq, &txd);
=20
@@ -711,7 +711,7 @@ static void mlx5e_tx_wi_consume_fifo_skbs(struct mlx5e_=
txqsq *sq, struct mlx5e_t
 	int i;
=20
 	for (i =3D 0; i < wi->num_fifo_pkts; i++) {
-		struct sk_buff *skb =3D mlx5e_skb_fifo_pop(sq);
+		struct sk_buff *skb =3D mlx5e_skb_fifo_pop(&sq->db.skb_fifo);
=20
 		mlx5e_consume_skb(sq, skb, cqe, napi_budget);
 	}
@@ -831,7 +831,7 @@ static void mlx5e_tx_wi_kfree_fifo_skbs(struct mlx5e_tx=
qsq *sq, struct mlx5e_tx_
 	int i;
=20
 	for (i =3D 0; i < wi->num_fifo_pkts; i++)
-		dev_kfree_skb_any(mlx5e_skb_fifo_pop(sq));
+		dev_kfree_skb_any(mlx5e_skb_fifo_pop(&sq->db.skb_fifo));
 }
=20
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
--=20
2.26.2

