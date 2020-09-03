Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E310A25CBC1
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgICVBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:01:14 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2840 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729454AbgICVAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:00:55 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5159500009>; Thu, 03 Sep 2020 14:00:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 03 Sep 2020 14:00:47 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 03 Sep 2020 14:00:47 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Sep
 2020 21:00:37 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next 04/10] net/mlx5e: Unify constants for WQE_EMPTY_DS_COUNT
Date:   Thu, 3 Sep 2020 14:00:16 -0700
Message-ID: <20200903210022.22774-5-saeedm@nvidia.com>
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
        t=1599166800; bh=OTzGG1b4L8j+CYvHATXTpMZqKr1g1SSF7RXlzCZOu8w=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=Ba817FSzkCACTIytklcABPR/OrSjxx2b+aG9d/HxqV66+P7jJCZ2xz9Juccnt8V3Z
         2C6uSVC3zaPJvBEitAJLUeUn89T8zcEwzu0/dC388kpLLNyGFDQaNZF9GjsvfvKnk2
         PH2dg4sQeN5LBfSvEs0lMyczS+Lzm9b7oFcEYXttUbuXCPCeRHdRxw7L+dInY7TRL/
         M0htXwLWA+V0X5ZeWH8exNVLVlxmhjYxX/DarBMp+Q7O2dvrdVrfYLz9nssjzzuS4p
         Cq89Vwoqr6+xAhGFAOszWipnj6lSBiZ0YkB/UHewUtGnJ2kcxv25W+zBMhx3zupNRk
         9jSqiDx49RgLg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

A constant for the number of DS in an empty WQE (i.e. a WQE without data
segments) is needed in multiple places (normal TX data path, MPWQE in
XDP), but currently we have a constant for XDP and an inline formula in
normal TX. This patch introduces a common constant.

Additionally, mlx5e_xdp_mpwqe_session_start is converted to use struct
assignment, because the code nearby is touched.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 13 +++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 21 +++++++------------
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index d4ee22789ab0..155b89998891 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -7,6 +7,8 @@
 #include "en.h"
 #include <linux/indirect_call_wrapper.h>
=20
+#define MLX5E_TX_WQE_EMPTY_DS_COUNT (sizeof(struct mlx5e_tx_wqe) / MLX5_SE=
ND_WQE_DS)
+
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline=
_hdr.start))
=20
 enum mlx5e_icosq_wqe_type {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.c
index 7fccd2ea7dc9..81cd9a04bcb0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -196,16 +196,19 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5=
e_xdpsq *sq)
 {
 	struct mlx5e_xdp_mpwqe *session =3D &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats =3D sq->stats;
+	struct mlx5e_tx_wqe *wqe;
 	u16 pi;
=20
 	pi =3D mlx5e_xdpsq_get_next_pi(sq, MLX5E_XDP_MPW_MAX_WQEBBS);
-	session->wqe =3D MLX5E_TX_FETCH_WQE(sq, pi);
-
+	wqe =3D MLX5E_TX_FETCH_WQE(sq, pi);
 	net_prefetchw(session->wqe->data);
-	session->ds_count  =3D MLX5E_XDP_TX_EMPTY_DS_COUNT;
-	session->pkt_count =3D 0;
=20
-	mlx5e_xdp_update_inline_state(sq);
+	*session =3D (struct mlx5e_xdp_mpwqe) {
+		.wqe =3D wqe,
+		.ds_count =3D MLX5E_TX_WQE_EMPTY_DS_COUNT,
+		.pkt_count =3D 0,
+		.inline_on =3D mlx5e_xdp_get_inline_state(sq, session->inline_on),
+	};
=20
 	stats->mpwqe++;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.h
index 615bf04f4a54..96d6b1553bab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -38,9 +38,7 @@
 #include "en/txrx.h"
=20
 #define MLX5E_XDP_MIN_INLINE (ETH_HLEN + VLAN_HLEN)
-#define MLX5E_XDP_TX_EMPTY_DS_COUNT \
-	(sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
-#define MLX5E_XDP_TX_DS_COUNT (MLX5E_XDP_TX_EMPTY_DS_COUNT + 1 /* SG DS */=
)
+#define MLX5E_XDP_TX_DS_COUNT (MLX5E_TX_WQE_EMPTY_DS_COUNT + 1 /* SG DS */=
)
=20
 #define MLX5E_XDP_INLINE_WQE_MAX_DS_CNT 16
 #define MLX5E_XDP_INLINE_WQE_SZ_THRSD \
@@ -123,23 +121,20 @@ static inline void mlx5e_xmit_xdp_doorbell(struct mlx=
5e_xdpsq *sq)
 /* Enable inline WQEs to shift some load from a congested HCA (HW) to
  * a less congested cpu (SW).
  */
-static inline void mlx5e_xdp_update_inline_state(struct mlx5e_xdpsq *sq)
+static inline bool mlx5e_xdp_get_inline_state(struct mlx5e_xdpsq *sq, bool=
 cur)
 {
 	u16 outstanding =3D sq->xdpi_fifo_pc - sq->xdpi_fifo_cc;
-	struct mlx5e_xdp_mpwqe *session =3D &sq->mpwqe;
=20
 #define MLX5E_XDP_INLINE_WATERMARK_LOW	10
 #define MLX5E_XDP_INLINE_WATERMARK_HIGH 128
=20
-	if (session->inline_on) {
-		if (outstanding <=3D MLX5E_XDP_INLINE_WATERMARK_LOW)
-			session->inline_on =3D 0;
-		return;
-	}
+	if (cur && outstanding <=3D MLX5E_XDP_INLINE_WATERMARK_LOW)
+		return false;
+
+	if (!cur && outstanding >=3D MLX5E_XDP_INLINE_WATERMARK_HIGH)
+		return true;
=20
-	/* inline is false */
-	if (outstanding >=3D MLX5E_XDP_INLINE_WATERMARK_HIGH)
-		session->inline_on =3D 1;
+	return cur;
 }
=20
 static inline bool mlx5e_xdp_mpqwe_is_full(struct mlx5e_xdp_mpwqe *session=
)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index f967bc0573c0..46bdbbbfaf65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -289,7 +289,7 @@ static inline void mlx5e_sq_calc_wqe_attr(struct sk_buf=
f *skb,
 					  const struct mlx5e_tx_attr *attr,
 					  struct mlx5e_tx_wqe_attr *wqe_attr)
 {
-	u16 ds_cnt =3D sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS;
+	u16 ds_cnt =3D MLX5E_TX_WQE_EMPTY_DS_COUNT;
 	u16 ds_cnt_inl =3D 0;
=20
 	ds_cnt +=3D !!attr->headlen + skb_shinfo(skb)->nr_frags;
--=20
2.26.2

