Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FAF25CBBD
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbgICVA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:00:58 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2814 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729449AbgICVAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:00:51 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5159500005>; Thu, 03 Sep 2020 14:00:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 03 Sep 2020 14:00:47 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 03 Sep 2020 14:00:47 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Sep
 2020 21:00:38 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next 07/10] net/mlx5e: Generalize TX MPWQE checks for full session
Date:   Thu, 3 Sep 2020 14:00:19 -0700
Message-ID: <20200903210022.22774-8-saeedm@nvidia.com>
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
        t=1599166800; bh=IRAsK0q/VT6xdFgJA5ifh1u97DnzT3mL+Y2QrMBfitQ=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=sPnEb2hcEMzY91QVbc3GpvPfHL0RnxYun4K1BsY9L3E2eN1r9mtssVUZo4WeHEAhC
         Nk5qNph5unhWPkHMt2BZ1N+IRwyg03i4SC+q9Mja8KOB1OwB6fg9obbSIHWKJa9kWJ
         Z2hJHs4uhutS5+a9as8UpcMJMJ/yhOvWUvWb5XarEPrNYcBEsSn4mr2XQeeMHfuYBZ
         3QixXjRUAma+h5W3P5ugbLs5OETvZBfT3r8+oqCXRSX5BrQlg75icFwMHb88uGea+D
         fbdzBX72qVjjd2PoNtslBeHKPYJBoUl0GyUZWg6u1TAlx6B+WjuB9WuCX6ohYtddGL
         TcJHTNNh3jQKg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

As preparation for the upcoming TX MPWQE for SKBs, create a function
(mlx5e_tx_mpwqe_is_full) to check whether an MPWQE session is full. This
function will be shared by MPWQE code for XDP and for SKBs. Defines are
renamed and moved to make them not XDP-specific.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h  | 18 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h   | 18 ++----------------
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 7baac2971758..09cf4236439e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -9,6 +9,19 @@
=20
 #define MLX5E_TX_WQE_EMPTY_DS_COUNT (sizeof(struct mlx5e_tx_wqe) / MLX5_SE=
ND_WQE_DS)
=20
+/* The mult of MLX5_SEND_WQE_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS
+ * (16 * 4 =3D=3D 64) does not fit in the 6-bit DS field of Ctrl Segment.
+ * We use a bound lower that MLX5_SEND_WQE_MAX_WQEBBS to let a
+ * full-session WQE be cache-aligned.
+ */
+#if L1_CACHE_BYTES < 128
+#define MLX5E_TX_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 1)
+#else
+#define MLX5E_TX_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 2)
+#endif
+
+#define MLX5E_TX_MPW_MAX_NUM_DS (MLX5E_TX_MPW_MAX_WQEBBS * MLX5_SEND_WQEBB=
_NUM_DS)
+
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline=
_hdr.start))
=20
 enum mlx5e_icosq_wqe_type {
@@ -285,6 +298,11 @@ static inline void mlx5e_txwqe_build_eseg_csum(struct =
mlx5e_txqsq *sq,
=20
 void mlx5e_sq_xmit_simple(struct mlx5e_txqsq *sq, struct sk_buff *skb, boo=
l xmit_more);
=20
+static inline bool mlx5e_tx_mpwqe_is_full(struct mlx5e_xdp_mpwqe *session)
+{
+	return session->ds_count =3D=3D MLX5E_TX_MPW_MAX_NUM_DS;
+}
+
 static inline void mlx5e_rqwq_reset(struct mlx5e_rq *rq)
 {
 	if (rq->wq_type =3D=3D MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.c
index 81cd9a04bcb0..0edd4ebeb90c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -199,7 +199,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_=
xdpsq *sq)
 	struct mlx5e_tx_wqe *wqe;
 	u16 pi;
=20
-	pi =3D mlx5e_xdpsq_get_next_pi(sq, MLX5E_XDP_MPW_MAX_WQEBBS);
+	pi =3D mlx5e_xdpsq_get_next_pi(sq, MLX5E_TX_MPW_MAX_WQEBBS);
 	wqe =3D MLX5E_TX_FETCH_WQE(sq, pi);
 	net_prefetchw(session->wqe->data);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.h
index 96d6b1553bab..0dc38acab5a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -45,20 +45,6 @@
 	(MLX5E_XDP_INLINE_WQE_MAX_DS_CNT * MLX5_SEND_WQE_DS - \
 	 sizeof(struct mlx5_wqe_inline_seg))
=20
-/* The mult of MLX5_SEND_WQE_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS
- * (16 * 4 =3D=3D 64) does not fit in the 6-bit DS field of Ctrl Segment.
- * We use a bound lower that MLX5_SEND_WQE_MAX_WQEBBS to let a
- * full-session WQE be cache-aligned.
- */
-#if L1_CACHE_BYTES < 128
-#define MLX5E_XDP_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 1)
-#else
-#define MLX5E_XDP_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 2)
-#endif
-
-#define MLX5E_XDP_MPW_MAX_NUM_DS \
-	(MLX5E_XDP_MPW_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS)
-
 struct mlx5e_xsk_param;
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param =
*xsk);
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
@@ -141,8 +127,8 @@ static inline bool mlx5e_xdp_mpqwe_is_full(struct mlx5e=
_xdp_mpwqe *session)
 {
 	if (session->inline_on)
 		return session->ds_count + MLX5E_XDP_INLINE_WQE_MAX_DS_CNT >
-		       MLX5E_XDP_MPW_MAX_NUM_DS;
-	return session->ds_count =3D=3D MLX5E_XDP_MPW_MAX_NUM_DS;
+		       MLX5E_TX_MPW_MAX_NUM_DS;
+	return mlx5e_tx_mpwqe_is_full(session);
 }
=20
 struct mlx5e_xdp_wqe_info {
--=20
2.26.2

