Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE19C25CBBA
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbgICVAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:00:43 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19838 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbgICVAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:00:43 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5158f90004>; Thu, 03 Sep 2020 13:58:33 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 03 Sep 2020 14:00:42 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 03 Sep 2020 14:00:42 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Sep
 2020 21:00:36 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next 03/10] net/mlx5e: Small improvements for XDP TX MPWQE logic
Date:   Thu, 3 Sep 2020 14:00:15 -0700
Message-ID: <20200903210022.22774-4-saeedm@nvidia.com>
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
        t=1599166713; bh=gPBqA9QPyfhf2ASD4MqSQTU10ahA16V3+gFJLFCX7R0=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=dRMueQffhMIZ4pQ4YtXRL2kkRQOUsv8HHRE/H66SexuuKW+XLHSzz3k976puY0L6l
         pCxJViztE08GTU5vRZx1wlAFmp56T04NbfKZ+Pz+TlV9cSSGR8046F51oQbARRFDG1
         NjEXR5K8PqNo8pCG+x4JmYjEZy62kJeeENdDY6dXigV6Sx1Sjp9x/Mt0rh7bDX6s/i
         MMooTqcYOXtAlZA+7apMhJ8yPGbZ7rR+kbn7I9mIQOa7jRRwPFn4xAUAyoqhk6c7LG
         tescyInot0eCs3iwfgjcaGwN9n7yGJeJjNwbYjpTUNDLkme1T5c4vqYVMOCwD9Dgha
         b8iYwobWkGW+w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Use MLX5E_XDP_MPW_MAX_WQEBBS to reserve space for a MPWQE, because it's
actually the maximal size a MPWQE can take.

Reorganize the logic that checks when to close the MPWQE session:

1. Put all checks into a single function.

2. When inline is on, make only one comparison - if it's false, the less
strict one will also be false. The compiler probably optimized it out
anyway, but it's clearer to also reflect it in the code.

The MLX5E_XDP_INLINE_WQE_* defines are also changed to make the
calculations more correct from the logical point of view. Though
MLX5E_XDP_INLINE_WQE_MAX_DS_CNT used to be 16 and didn't change its
value, the calculation used to be DIV_ROUND_UP(max inline packet size,
MLX5_SEND_WQE_DS), and the numerator should have included sizeof(struct
mlx5_wqe_inline_seg).

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |  5 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h | 16 +++++++++-------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.c
index 145592788de5..7fccd2ea7dc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -198,7 +198,7 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_=
xdpsq *sq)
 	struct mlx5e_xdpsq_stats *stats =3D sq->stats;
 	u16 pi;
=20
-	pi =3D mlx5e_xdpsq_get_next_pi(sq, MLX5_SEND_WQE_MAX_WQEBBS);
+	pi =3D mlx5e_xdpsq_get_next_pi(sq, MLX5E_XDP_MPW_MAX_WQEBBS);
 	session->wqe =3D MLX5E_TX_FETCH_WQE(sq, pi);
=20
 	net_prefetchw(session->wqe->data);
@@ -284,8 +284,7 @@ mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq, stru=
ct mlx5e_xdp_xmit_data *x
=20
 	mlx5e_xdp_mpwqe_add_dseg(sq, xdptxd, stats);
=20
-	if (unlikely(mlx5e_xdp_no_room_for_inline_pkt(session) ||
-		     session->ds_count =3D=3D MLX5E_XDP_MPW_MAX_NUM_DS))
+	if (unlikely(mlx5e_xdp_mpqwe_is_full(session)))
 		mlx5e_xdp_mpwqe_complete(sq);
=20
 	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, xdpi);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.h
index e806c13d491f..615bf04f4a54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -42,9 +42,10 @@
 	(sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
 #define MLX5E_XDP_TX_DS_COUNT (MLX5E_XDP_TX_EMPTY_DS_COUNT + 1 /* SG DS */=
)
=20
-#define MLX5E_XDP_INLINE_WQE_SZ_THRSD (256 - sizeof(struct mlx5_wqe_inline=
_seg))
-#define MLX5E_XDP_INLINE_WQE_MAX_DS_CNT \
-	DIV_ROUND_UP(MLX5E_XDP_INLINE_WQE_SZ_THRSD, MLX5_SEND_WQE_DS)
+#define MLX5E_XDP_INLINE_WQE_MAX_DS_CNT 16
+#define MLX5E_XDP_INLINE_WQE_SZ_THRSD \
+	(MLX5E_XDP_INLINE_WQE_MAX_DS_CNT * MLX5_SEND_WQE_DS - \
+	 sizeof(struct mlx5_wqe_inline_seg))
=20
 /* The mult of MLX5_SEND_WQE_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS
  * (16 * 4 =3D=3D 64) does not fit in the 6-bit DS field of Ctrl Segment.
@@ -141,11 +142,12 @@ static inline void mlx5e_xdp_update_inline_state(stru=
ct mlx5e_xdpsq *sq)
 		session->inline_on =3D 1;
 }
=20
-static inline bool
-mlx5e_xdp_no_room_for_inline_pkt(struct mlx5e_xdp_mpwqe *session)
+static inline bool mlx5e_xdp_mpqwe_is_full(struct mlx5e_xdp_mpwqe *session=
)
 {
-	return session->inline_on &&
-	       session->ds_count + MLX5E_XDP_INLINE_WQE_MAX_DS_CNT > MLX5E_XDP_MP=
W_MAX_NUM_DS;
+	if (session->inline_on)
+		return session->ds_count + MLX5E_XDP_INLINE_WQE_MAX_DS_CNT >
+		       MLX5E_XDP_MPW_MAX_NUM_DS;
+	return session->ds_count =3D=3D MLX5E_XDP_MPW_MAX_NUM_DS;
 }
=20
 struct mlx5e_xdp_wqe_info {
--=20
2.26.2

