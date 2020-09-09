Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C152926247D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 03:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgIIB2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 21:28:41 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19438 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728442AbgIIB2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 21:28:25 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f582fa90005>; Tue, 08 Sep 2020 18:28:09 -0700
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
Subject: [net-next V2 09/12] net/mlx5e: Generalize TX MPWQE checks for full session
Date:   Tue, 8 Sep 2020 18:27:54 -0700
Message-ID: <20200909012757.32677-10-saeedm@nvidia.com>
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
        t=1599614889; bh=W0pBSa8AaGm475z2yDXWwUTwNOeNtLOzq0sSsrL4mZU=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=XS8SXkoi93OskBQAuJBbMz6R2ITn5a0/dx+s80MZr1nEiUHM7ww3g8TYZlRI8K0/m
         qNlDh6ik7nZWVlMm+BUTJ5T3YGsAcgYjcrMNYkwrkCQwf2/Ked4rMx+ikhWAE/u3Au
         Ipefdc60LKIjN4ys3zA8oapRwG8P5fEg5bGJQJaDJEc1GEuC22X3fZUPe7VVb/yY+L
         aRItnXBt5AMGIHzsBs1iMHXhm4WNsNpKIeRxXnC4slciJdsOk8xVIPC4MZPmSZbIZx
         bnRbOogQAJlaAtwdn2P6HMApfNBtAYljWoBOADLKjt++TPTW7xLQc9jPaJZT7aUeWV
         nXJTOPwESQ48A==
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
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h  | 18 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h   | 18 ++----------------
 3 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 03fe92323f48..b4ee1f2f1746 100644
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
@@ -266,6 +279,11 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_s=
q_dma *dma)
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
index 737e88d49e89..2a72496ceda9 100644
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
 	net_prefetchw(wqe->data);
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

