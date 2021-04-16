Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F8C362812
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236512AbhDPSzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236052AbhDPSzG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F00F6613C7;
        Fri, 16 Apr 2021 18:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599281;
        bh=omPJzVMNN83sZlslp3lQQqnp/NMUDWajs72aaxylq4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3mUI542m1wfXMnwdihXv0Omx77X4wdQ1qtXv1VSFfKenKdhZNkFGU+HDol5+IrV7
         Y6p/HLeTubqbyTUwv169jVM7PrDUQdiL3OBbHnvwNeZFsZ2nRtwHIszcxdFIjHw0ia
         Z809V4oAXn++RCv2Y8gYEtVTx8A4eotjTcVGjAJlJCqo0H5DDlv3Vn7E1ofnZV4KLB
         kMJrC6OBHLAW4/LV1mBKvx8fQ3y9WKn+gn9x+8sJMamQXGKjLJXiFB0IkaHzKyLaZa
         z5tXU/yMYK7U/s4y/HLv9/G6fEUoo8WvHiMJiq92ZXX8DirVLZ8egtHyUOdxPYoKs/
         fE7ophyBDWjHA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/14] net/mlx5e: TX, Inline TLS skb check
Date:   Fri, 16 Apr 2021 11:54:19 -0700
Message-Id: <20210416185430.62584-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

When TLS is supported and enabled, every transmitted packet is tested
to identify if TLS offload is required.

Take the early-return condition into an inline function, to save
the overhead of a function call for non-TLS packets.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h | 5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c | 3 ---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h | 6 ++++++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index cc2851ecd512..043c86c52798 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -124,8 +124,9 @@ static inline bool mlx5e_accel_tx_begin(struct net_device *dev,
 
 #ifdef CONFIG_MLX5_EN_TLS
 	/* May send SKBs and WQEs. */
-	if (unlikely(!mlx5e_tls_handle_tx_skb(dev, sq, skb, &state->tls)))
-		return false;
+	if (mlx5e_tls_skb_offloaded(skb))
+		if (unlikely(!mlx5e_tls_handle_tx_skb(dev, sq, skb, &state->tls)))
+			return false;
 #endif
 
 #ifdef CONFIG_MLX5_EN_IPSEC
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 2b51d3222ca1..97cbea7ed048 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -263,9 +263,6 @@ bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	int datalen;
 	u32 skb_seq;
 
-	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
-		return true;
-
 	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
 	if (!datalen)
 		return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
index 9923132c9440..5c3443200fd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
@@ -47,6 +47,12 @@ u16 mlx5e_tls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_params *par
 
 bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 			     struct sk_buff *skb, struct mlx5e_accel_tx_tls_state *state);
+
+static inline bool mlx5e_tls_skb_offloaded(struct sk_buff *skb)
+{
+	return skb->sk && tls_is_sk_tx_device_offloaded(skb->sk);
+}
+
 void mlx5e_tls_handle_tx_wqe(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
 			     struct mlx5e_accel_tx_tls_state *state);
 
-- 
2.30.2

