Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E2C2B6FA8
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbgKQUHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:07:51 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1936 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731631AbgKQUHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:07:47 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb42d960002>; Tue, 17 Nov 2020 12:07:50 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 20:07:39 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Huy Nguyen" <huyn@mellanox.com>, Raed Salem <raeds@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/9] net/mlx5e: Set IPsec WAs only in IP's non checksum partial case.
Date:   Tue, 17 Nov 2020 11:56:55 -0800
Message-ID: <20201117195702.386113-3-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201117195702.386113-1-saeedm@nvidia.com>
References: <20201117195702.386113-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605643670; bh=Yl8zIQ5UHW9PyKYdbiZwfijbYCDtrMWCNBMIn2MS0xE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=iZhTWZb4hxW44VV/y0DbseJFI2PW+b3a2qNWYvQ31FPgXPjYcrPxxYsibGvsRFPup
         MMFjpLgol8ui0N9O1Vcp3XpVWVXe9xFgl5ryWNqpU17pNNJTkUIlwMhX3Bl6TCF7d/
         MCjQoirzEIMAFNObgD1eGcf1Zg0VQIBSekVCLoZdKHu8m8OxVD4dqGJIZs2D8vtvcf
         CqSesLRXXVbLVAbeLj7jagPMDEPdPn0iND/MpOv9q1rYxFA9rQoDWW4zsLudNs0VDz
         f/UKjZgn5pt8I6DF388n/AbxBGV1a7qpkrYRZ6irzVH4qdKS7OLwhkIF7tRxqQmOhM
         Db5EqWDHjSEtQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

The IP's checksum partial still requires L4 csum flag on Ethernet WQE.
Make the IPsec WAs only for the IP's non checksum partial case
(for example icmd packet)

Fixes: 5be019040cb7 ("net/mlx5e: IPsec: Add Connect-X IPsec Tx data path of=
fload")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 82b4419af9d4..6dd3ea3cbbed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -144,7 +144,9 @@ static inline void mlx5e_insert_vlan(void *start, struc=
t sk_buff *skb, u16 ihs)
 	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
 }
=20
-/* RM 2311217: no L4 inner checksum for IPsec tunnel type packet */
+/* If packet is not IP's CHECKSUM_PARTIAL (e.g. icmd packet),
+ * need to set L3 checksum flag for IPsec
+ */
 static void
 ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			    struct mlx5_wqe_eth_seg *eseg)
@@ -154,7 +156,6 @@ ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, str=
uct sk_buff *skb,
 		eseg->cs_flags |=3D MLX5_ETH_WQE_L3_INNER_CSUM;
 		sq->stats->csum_partial_inner++;
 	} else {
-		eseg->cs_flags |=3D MLX5_ETH_WQE_L4_CSUM;
 		sq->stats->csum_partial++;
 	}
 }
@@ -162,11 +163,6 @@ ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, st=
ruct sk_buff *skb,
 static inline void
 mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb, s=
truct mlx5_wqe_eth_seg *eseg)
 {
-	if (unlikely(eseg->flow_table_metadata & cpu_to_be32(MLX5_ETH_WQE_FT_META=
_IPSEC))) {
-		ipsec_txwqe_build_eseg_csum(sq, skb, eseg);
-		return;
-	}
-
 	if (likely(skb->ip_summed =3D=3D CHECKSUM_PARTIAL)) {
 		eseg->cs_flags =3D MLX5_ETH_WQE_L3_CSUM;
 		if (skb->encapsulation) {
@@ -177,6 +173,9 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, str=
uct sk_buff *skb, struct
 			eseg->cs_flags |=3D MLX5_ETH_WQE_L4_CSUM;
 			sq->stats->csum_partial++;
 		}
+	} else if (unlikely(eseg->flow_table_metadata & cpu_to_be32(MLX5_ETH_WQE_=
FT_META_IPSEC))) {
+		ipsec_txwqe_build_eseg_csum(sq, skb, eseg);
+
 	} else
 		sq->stats->csum_none++;
 }
--=20
2.26.2

