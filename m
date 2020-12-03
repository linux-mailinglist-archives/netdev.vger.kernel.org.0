Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2AA2CCE08
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgLCElV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:41:21 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18158 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgLCElV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:41:21 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc86c480000>; Wed, 02 Dec 2020 20:40:40 -0800
Received: from sx1.vdiclient.nvidia.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:40:33 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Boris Pismenny" <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 3/4] net/mlx5e: kTLS, Enforce HW TX csum offload with kTLS
Date:   Wed, 2 Dec 2020 20:39:45 -0800
Message-ID: <20201203043946.235385-4-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201203043946.235385-1-saeedm@nvidia.com>
References: <20201203043946.235385-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606970440; bh=kPBOYXriEvmQZGk6qIM+VjxGgCTYl+4PiNUkIxCnawA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Z7l24Efc0XGrL3xpERQTKDyAjv7t54zIuHuLUydTHGKmUHpN8iZkohszcIdWyV7eW
         0rPUa2e993aiPac5BK8RyJOBd2dJp9DMPZAqXzxD7trhMvOy+SBiZw8OmjPHLDNrC5
         6mtFCQA1TzwJccZkQk6Fxgy9Mc3Y1b0VNoUKoxvFb0a8Fakzx+uLx6W6h2KOeUZszd
         PYMdsa5MrpqU3IGBvzKpXmzocwmUmUeJ4lnSDBVa8HKJAzeu6vl0OoEj+krxLyl0CK
         AC7v0PJ+dX9YM0V2Oj4EawhkFl3jMSuejVDHcXjnoKl1I7bengAT1vjMRC9ce1jz68
         6L3xYDtZmyuLA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Checksum calculation cannot be done in SW for TX kTLS HW offloaded
packets.
Offload it to the device, disregard the declared state of the TX
csum offload feature.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 22 +++++++++++++------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 6dd3ea3cbbed..d97203cf6a00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -161,7 +161,9 @@ ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, str=
uct sk_buff *skb,
 }
=20
 static inline void
-mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb, s=
truct mlx5_wqe_eth_seg *eseg)
+mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+			    struct mlx5e_accel_tx_state *accel,
+			    struct mlx5_wqe_eth_seg *eseg)
 {
 	if (likely(skb->ip_summed =3D=3D CHECKSUM_PARTIAL)) {
 		eseg->cs_flags =3D MLX5_ETH_WQE_L3_CSUM;
@@ -173,6 +175,11 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, st=
ruct sk_buff *skb, struct
 			eseg->cs_flags |=3D MLX5_ETH_WQE_L4_CSUM;
 			sq->stats->csum_partial++;
 		}
+#ifdef CONFIG_MLX5_EN_TLS
+	} else if (unlikely(accel && accel->tls.tls_tisn)) {
+		eseg->cs_flags =3D MLX5_ETH_WQE_L3_CSUM | MLX5_ETH_WQE_L4_CSUM;
+		sq->stats->csum_partial++;
+#endif
 	} else if (unlikely(eseg->flow_table_metadata & cpu_to_be32(MLX5_ETH_WQE_=
FT_META_IPSEC))) {
 		ipsec_txwqe_build_eseg_csum(sq, skb, eseg);
=20
@@ -607,12 +614,13 @@ void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqs=
q *sq)
 }
=20
 static bool mlx5e_txwqe_build_eseg(struct mlx5e_priv *priv, struct mlx5e_t=
xqsq *sq,
-				   struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg)
+				   struct sk_buff *skb, struct mlx5e_accel_tx_state *accel,
+				   struct mlx5_wqe_eth_seg *eseg)
 {
 	if (unlikely(!mlx5e_accel_tx_eseg(priv, skb, eseg)))
 		return false;
=20
-	mlx5e_txwqe_build_eseg_csum(sq, skb, eseg);
+	mlx5e_txwqe_build_eseg_csum(sq, skb, accel, eseg);
=20
 	return true;
 }
@@ -639,7 +647,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_=
device *dev)
 		if (mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
 			struct mlx5_wqe_eth_seg eseg =3D {};
=20
-			if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &eseg)))
+			if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &eseg)))
 				return NETDEV_TX_OK;
=20
 			mlx5e_sq_xmit_mpwqe(sq, skb, &eseg, netdev_xmit_more());
@@ -656,7 +664,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_=
device *dev)
 	/* May update the WQE, but may not post other WQEs. */
 	mlx5e_accel_tx_finish(sq, wqe, &accel,
 			      (struct mlx5_wqe_inline_seg *)(wqe->data + wqe_attr.ds_cnt_inl));
-	if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &wqe->eth)))
+	if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &wqe->eth)))
 		return NETDEV_TX_OK;
=20
 	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, netdev_xmit_more())=
;
@@ -675,7 +683,7 @@ void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struc=
t sk_buff *skb, bool xmit
 	mlx5e_sq_calc_wqe_attr(skb, &attr, &wqe_attr);
 	pi =3D mlx5e_txqsq_get_next_pi(sq, wqe_attr.num_wqebbs);
 	wqe =3D MLX5E_TX_FETCH_WQE(sq, pi);
-	mlx5e_txwqe_build_eseg_csum(sq, skb, &wqe->eth);
+	mlx5e_txwqe_build_eseg_csum(sq, skb, NULL, &wqe->eth);
 	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, xmit_more);
 }
=20
@@ -944,7 +952,7 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_bu=
ff *skb,
=20
 	mlx5i_txwqe_build_datagram(av, dqpn, dqkey, datagram);
=20
-	mlx5e_txwqe_build_eseg_csum(sq, skb, eseg);
+	mlx5e_txwqe_build_eseg_csum(sq, skb, NULL, eseg);
=20
 	eseg->mss =3D attr.mss;
=20
--=20
2.26.2

