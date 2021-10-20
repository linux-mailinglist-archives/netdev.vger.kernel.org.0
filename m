Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6B2435217
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhJTR6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230401AbhJTR6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:58:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A2686138B;
        Wed, 20 Oct 2021 17:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634752591;
        bh=1JvVXm4iR7MkQ4g/b66o0yzqr4vX/0AOVJi+nKnppbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAq14sTkZokyvXccRbOPv4zCMus5wNfLq2wiOXGexvgYzOOTVrI5IxjpyDvUHfPU6
         PtzKBGjkyb6uNpxjv9l5lP0+pOqp1I2h3KvG5GQ/nfH0IRJFrO2d4FHjITUh/WT6mO
         lc1tGvHVUO2wor5oPQmCLnCSpGZytJ03QqIg0iNWATUaBqTlLpxJRlrqajog3///2O
         HG/Xd2MSd0EhMb429Z+drC/rAIcUG8wbhqd8PSOauZhxJeEMkwWEEkfw2cVhSLNkUR
         1Ge1NozBUvjIb8FCz2nHn5TsSF74GIp6v5SNE320i5BDf2wlUEgWGtNv50haa+0KZX
         ew2pq4+2kxSgA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Emeel Hakim <ehakim@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/5] net/mlx5e: IPsec: Fix work queue entry ethernet segment checksum flags
Date:   Wed, 20 Oct 2021 10:56:27 -0700
Message-Id: <20211020175627.269138-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020175627.269138-1-saeed@kernel.org>
References: <20211020175627.269138-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Current Work Queue Entry (WQE) checksum (csum) flags in the ethernet
segment (eseg) in case of IPsec crypto offload datapath are not aligned
with PRM/HW expectations.

Currently the driver always sets the l3_inner_csum flag in case of IPsec
because of the wrong usage of skb->encapsulation as indicator for inner
IPsec header since skb->encapsulation is always ON for IPsec packets
since IPsec itself is an encapsulation protocol. The above forced a
failing attempts of calculating csum of non-existing segments (like in
the IP|ESP|TCP packet case which does not have an l3_inner) which led
to lots of packet drops hence the low throughput.

Fix by using xo->inner_ipproto as indicator for inner IPsec header
instead of skb->encapsulation in addition to setting the csum flags
as following:
* Tunnel Mode:
* Pkt: MAC  IP     ESP  IP    L4
* CSUM: l3_cs | l3_inner_cs | l4_inner_cs
*
* Transport Mode:
* Pkt: MAC  IP     ESP  L4
* CSUM: l3_cs [ | l4_cs (checksum partial case)]
*
* Tunnel(VXLAN TCP/UDP) over Transport Mode
* Pkt: MAC  IP     ESP  UDP  VXLAN  IP    L4
* CSUM: l3_cs | l3_inner_cs | l4_inner_cs

Fixes: f1267798c980 ("net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index c63d78eda606..188994d091c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -213,19 +213,18 @@ static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
 	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
 }
 
-/* If packet is not IP's CHECKSUM_PARTIAL (e.g. icmd packet),
- * need to set L3 checksum flag for IPsec
- */
 static void
 ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			    struct mlx5_wqe_eth_seg *eseg)
 {
+	struct xfrm_offload *xo = xfrm_offload(skb);
+
 	eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
-	if (skb->encapsulation) {
-		eseg->cs_flags |= MLX5_ETH_WQE_L3_INNER_CSUM;
+	if (xo->inner_ipproto) {
+		eseg->cs_flags |= MLX5_ETH_WQE_L4_INNER_CSUM | MLX5_ETH_WQE_L3_INNER_CSUM;
+	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
+		eseg->cs_flags |= MLX5_ETH_WQE_L4_CSUM;
 		sq->stats->csum_partial_inner++;
-	} else {
-		sq->stats->csum_partial++;
 	}
 }
 
@@ -234,6 +233,11 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			    struct mlx5e_accel_tx_state *accel,
 			    struct mlx5_wqe_eth_seg *eseg)
 {
+	if (unlikely(mlx5e_ipsec_eseg_meta(eseg))) {
+		ipsec_txwqe_build_eseg_csum(sq, skb, eseg);
+		return;
+	}
+
 	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
 		eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
 		if (skb->encapsulation) {
@@ -249,8 +253,6 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM | MLX5_ETH_WQE_L4_CSUM;
 		sq->stats->csum_partial++;
 #endif
-	} else if (unlikely(mlx5e_ipsec_eseg_meta(eseg))) {
-		ipsec_txwqe_build_eseg_csum(sq, skb, eseg);
 	} else
 		sq->stats->csum_none++;
 }
-- 
2.31.1

