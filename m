Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21182738DB
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgIVCr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729188AbgIVCrp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 22:47:45 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8487021D91;
        Tue, 22 Sep 2020 02:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600742864;
        bh=vzz/AsLJWJTXlwPpaEeMYr0OM9addSojVHv0waUCOfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5Qz6pMrEFuo/NjtXrAWqC8NzeOe+te1xyv7OurjIpO3ZPSzGswvyczqD3ZlCjtHC
         ic0KX2Irr3UmAJtPM/eiISjBCmup7Buwlxy6836j7tC7MkmgZxb2u9aiVPsE6QlRP8
         /24DMJK1cWilBLsa/8e58S95qrTf6nsr06cL8EVI=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 06/12] net/mlx5e: Unify constants for WQE_EMPTY_DS_COUNT
Date:   Mon, 21 Sep 2020 19:46:58 -0700
Message-Id: <20200922024704.544482-7-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922024704.544482-1-saeed@kernel.org>
References: <20200922024704.544482-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 17 ++++++++-------
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 21 +++++++------------
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 9931a605eed9..277725c05de4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -7,6 +7,8 @@
 #include "en.h"
 #include <linux/indirect_call_wrapper.h>
 
+#define MLX5E_TX_WQE_EMPTY_DS_COUNT (sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
+
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline_hdr.start))
 
 enum mlx5e_icosq_wqe_type {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 7fccd2ea7dc9..737e88d49e89 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -196,16 +196,19 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5e_xdpsq *sq)
 {
 	struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats = sq->stats;
+	struct mlx5e_tx_wqe *wqe;
 	u16 pi;
 
 	pi = mlx5e_xdpsq_get_next_pi(sq, MLX5E_XDP_MPW_MAX_WQEBBS);
-	session->wqe = MLX5E_TX_FETCH_WQE(sq, pi);
-
-	net_prefetchw(session->wqe->data);
-	session->ds_count  = MLX5E_XDP_TX_EMPTY_DS_COUNT;
-	session->pkt_count = 0;
-
-	mlx5e_xdp_update_inline_state(sq);
+	wqe = MLX5E_TX_FETCH_WQE(sq, pi);
+	net_prefetchw(wqe->data);
+
+	*session = (struct mlx5e_xdp_mpwqe) {
+		.wqe = wqe,
+		.ds_count = MLX5E_TX_WQE_EMPTY_DS_COUNT,
+		.pkt_count = 0,
+		.inline_on = mlx5e_xdp_get_inline_state(sq, session->inline_on),
+	};
 
 	stats->mpwqe++;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index 615bf04f4a54..96d6b1553bab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -38,9 +38,7 @@
 #include "en/txrx.h"
 
 #define MLX5E_XDP_MIN_INLINE (ETH_HLEN + VLAN_HLEN)
-#define MLX5E_XDP_TX_EMPTY_DS_COUNT \
-	(sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
-#define MLX5E_XDP_TX_DS_COUNT (MLX5E_XDP_TX_EMPTY_DS_COUNT + 1 /* SG DS */)
+#define MLX5E_XDP_TX_DS_COUNT (MLX5E_TX_WQE_EMPTY_DS_COUNT + 1 /* SG DS */)
 
 #define MLX5E_XDP_INLINE_WQE_MAX_DS_CNT 16
 #define MLX5E_XDP_INLINE_WQE_SZ_THRSD \
@@ -123,23 +121,20 @@ static inline void mlx5e_xmit_xdp_doorbell(struct mlx5e_xdpsq *sq)
 /* Enable inline WQEs to shift some load from a congested HCA (HW) to
  * a less congested cpu (SW).
  */
-static inline void mlx5e_xdp_update_inline_state(struct mlx5e_xdpsq *sq)
+static inline bool mlx5e_xdp_get_inline_state(struct mlx5e_xdpsq *sq, bool cur)
 {
 	u16 outstanding = sq->xdpi_fifo_pc - sq->xdpi_fifo_cc;
-	struct mlx5e_xdp_mpwqe *session = &sq->mpwqe;
 
 #define MLX5E_XDP_INLINE_WATERMARK_LOW	10
 #define MLX5E_XDP_INLINE_WATERMARK_HIGH 128
 
-	if (session->inline_on) {
-		if (outstanding <= MLX5E_XDP_INLINE_WATERMARK_LOW)
-			session->inline_on = 0;
-		return;
-	}
+	if (cur && outstanding <= MLX5E_XDP_INLINE_WATERMARK_LOW)
+		return false;
+
+	if (!cur && outstanding >= MLX5E_XDP_INLINE_WATERMARK_HIGH)
+		return true;
 
-	/* inline is false */
-	if (outstanding >= MLX5E_XDP_INLINE_WATERMARK_HIGH)
-		session->inline_on = 1;
+	return cur;
 }
 
 static inline bool mlx5e_xdp_mpqwe_is_full(struct mlx5e_xdp_mpwqe *session)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 939bbf0aa2c3..e458a0ab8740 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -305,7 +305,7 @@ static void mlx5e_sq_xmit_prepare(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 static void mlx5e_sq_calc_wqe_attr(struct sk_buff *skb, const struct mlx5e_tx_attr *attr,
 				   struct mlx5e_tx_wqe_attr *wqe_attr)
 {
-	u16 ds_cnt = sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS;
+	u16 ds_cnt = MLX5E_TX_WQE_EMPTY_DS_COUNT;
 	u16 ds_cnt_inl = 0;
 
 	ds_cnt += !!attr->headlen + skb_shinfo(skb)->nr_frags;
-- 
2.26.2

