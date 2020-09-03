Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DE725CBBF
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgICVBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:01:05 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2780 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729448AbgICVAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:00:49 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5159500004>; Thu, 03 Sep 2020 14:00:00 -0700
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
Subject: [net-next 09/10] net/mlx5e: Move TX code into functions to be used by MPWQE
Date:   Thu, 3 Sep 2020 14:00:21 -0700
Message-ID: <20200903210022.22774-10-saeedm@nvidia.com>
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
        t=1599166800; bh=26w1MUmb1hnVFWjpMHoCn1gI2zfX15n9xSfkb/Cz5A8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=k3dE0a7ct6MqQZFCd/5JIqcjtgsjPk2hB3joAzSpystdMLXE3BVaKat37B6Jq862h
         ZblXNQ4eNJtN0xBnDAPHVMQrFT/46n0pVKgmnWSdmW3eAUb75GbpG9sg2+B8tkW72/
         lONJCOxerVoViNmz+f1pG9CMJ5rv6UShLpPfFz8bzlgARGuvhhny3dFmnJQ+22PVEt
         auKxDlCtMLVj1PUIwGumO/me2XEEm6HN5UcFj/aoHQD+dq1UUr/2qjv5jAgw3lckgG
         F6AAv70H0c+h5POeDIaECUvlZzG+uRN2Aqbt7DK9+ww1us4V5E5nSqat/KKQzITZ6J
         h8eK135CPD8mQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

mlx5e_txwqe_complete performs some actions that can be taken to separate
functions:

1. Update the flags needed for hardware timestamping.

2. Stop the TX queue if it's full.

Take these actions into separate functions to be reused by the MPWQE
code in the following commit and to maintain clear responsibilities of
functions.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 23 ++++++++++++++-----
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 9ced350150b3..3b68c8333875 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -311,6 +311,20 @@ static inline void mlx5e_sq_calc_wqe_attr(struct sk_bu=
ff *skb,
 	};
 }
=20
+static inline void mlx5e_tx_skb_update_hwts_flags(struct sk_buff *skb)
+{
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
+		skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;
+}
+
+static inline void mlx5e_tx_check_stop(struct mlx5e_txqsq *sq)
+{
+	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_ro=
om))) {
+		netif_tx_stop_queue(sq->txq);
+		sq->stats->stopped++;
+	}
+}
+
 static inline void
 mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		     const struct mlx5e_tx_attr *attr,
@@ -332,14 +346,11 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct s=
k_buff *skb,
 	cseg->opmod_idx_opcode =3D cpu_to_be32((sq->pc << 8) | attr->opcode);
 	cseg->qpn_ds           =3D cpu_to_be32((sq->sqn << 8) | wqe_attr->ds_cnt)=
;
=20
-	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
-		skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;
+	mlx5e_tx_skb_update_hwts_flags(skb);
=20
 	sq->pc +=3D wi->num_wqebbs;
-	if (unlikely(!mlx5e_wqc_has_room_for(wq, sq->cc, sq->pc, sq->stop_room)))=
 {
-		netif_tx_stop_queue(sq->txq);
-		sq->stats->stopped++;
-	}
+
+	mlx5e_tx_check_stop(sq);
=20
 	send_doorbell =3D __netdev_tx_sent_queue(sq->txq, attr->num_bytes, xmit_m=
ore);
 	if (send_doorbell)
--=20
2.26.2

