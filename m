Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17938262477
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 03:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgIIB2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 21:28:31 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5203 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIIB2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 21:28:18 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f582f7f0002>; Tue, 08 Sep 2020 18:27:27 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 18:28:18 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 08 Sep 2020 18:28:18 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 01:28:12 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Tariq Toukan" <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 03/12] net/mlx5e: Move mlx5e_tx_wqe_inline_mode to en_tx.c
Date:   Tue, 8 Sep 2020 18:27:48 -0700
Message-ID: <20200909012757.32677-4-saeedm@nvidia.com>
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
        t=1599614847; bh=6+JABo6YOQStqksrrSV/YQDMRsdJmTUlt2bSdlaiw44=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=kyWZSm7Pujp014UWbBmUgbHow0l1xYdweCRU1+f4bd6tzq6hflfWzXyUHeIO0Fwyn
         nh49BE6dCWbW7otFQtYLCTYy56AcaHSipa7g5jnDLOyA4aBZi5eMbT922k94KtHATr
         gAANWLzKAMe/wgOMf2Kvs127ROeyLeE3IkcHAAi+fZXuIUXRpGJKYzCeMhDszdN7bu
         Mu1mXwNXEH9kJNCquMUTrz4cbkrjJjeCSCY0ZuWRGVHR7GQO5vyCjpg1hC3lYPE5VU
         d/p105t3oXq22e6L9BoFbqZTzvwgl8Hoj6LQAR6+m1A5mwHptUy3pAefChseyj/6uD
         /l04DJsYbZt3Q==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Move mlx5e_tx_wqe_inline_mode from en/txrx.h to en_tx.c as it's only
used there.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 23 -------------------
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 23 +++++++++++++++++++
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 9334c9c3e208..6be04a236017 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -223,29 +223,6 @@ mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void _=
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index c064657dde13..be76ae14d186 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -232,6 +232,29 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct=
 sk_buff *skb,
 	return -ENOMEM;
 }
=20
+static inline bool mlx5e_transport_inline_tx_wqe(struct mlx5_wqe_ctrl_seg =
*cseg)
+{
+	return cseg && !!cseg->tis_tir_num;
+}
+
+static inline u8
+mlx5e_tx_wqe_inline_mode(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg =
*cseg,
+			 struct sk_buff *skb)
+{
+	u8 mode;
+
+	if (mlx5e_transport_inline_tx_wqe(cseg))
+		return MLX5_INLINE_MODE_TCP_UDP;
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
 static inline void
 mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		     u8 opcode, u16 ds_cnt, u8 num_wqebbs, u32 num_bytes, u8 num_dma,
--=20
2.26.2

