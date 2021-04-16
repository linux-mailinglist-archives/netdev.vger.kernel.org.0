Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A043D362810
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbhDPSzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235801AbhDPSzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 564BB613BB;
        Fri, 16 Apr 2021 18:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599279;
        bh=iapv7FcEvcSOr8mKPGIUxRXmV+kmZSdMbNExURsdE/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThrMS3Y3Hwk3Y39qXjRvNiM5natsINAJiJGsFBwaD7k+bnyyImj5RUrkoU/oOztYj
         78utBhYo/UQAkpBJvTcgD4BkRcF4PR2tuUf9qlWjf6IYkidnbARw1V8lcwikDfyzzV
         vDHkAXKvBtDcMEMzD7M9TGmt+3LwmYLRxWWq2TuZTWvTEL0+qhJzLYUAVsUrNKaef+
         NFykodtClmIDIgI39Whq/iARFv00VJRF2apc419GC4Y/gV7cs9AQBe4h4MV4da5hah
         U510aoclRCV784Y9b+v2Rb3RQ8uRg3FpJuUe2HrKh2yiIP+R7xv/q3hJpVwDwBb5VL
         wqbuO9sTBEFwg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/14] net/mlx5e: Remove non-essential TLS SQ state bit
Date:   Fri, 16 Apr 2021 11:54:17 -0700
Message-Id: <20210416185430.62584-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Maintaining an SQ state bit to indicate TLS support
has no real need, a simple and fast test [1] for the SKB is
almost equally good.

[1] !skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk)

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h              | 1 -
 .../net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h   | 8 +++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c         | 2 --
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index e1c51eabe8fe..cb4e7aaa4f8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -325,7 +325,6 @@ enum {
 	MLX5E_SQ_STATE_RECOVERING,
 	MLX5E_SQ_STATE_IPSEC,
 	MLX5E_SQ_STATE_AM,
-	MLX5E_SQ_STATE_TLS,
 	MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE,
 	MLX5E_SQ_STATE_PENDING_XSK_TX,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index cc0efac7b812..cc2851ecd512 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -123,11 +123,9 @@ static inline bool mlx5e_accel_tx_begin(struct net_device *dev,
 		mlx5e_udp_gso_handle_tx_skb(skb);
 
 #ifdef CONFIG_MLX5_EN_TLS
-	if (test_bit(MLX5E_SQ_STATE_TLS, &sq->state)) {
-		/* May send SKBs and WQEs. */
-		if (unlikely(!mlx5e_tls_handle_tx_skb(dev, sq, skb, &state->tls)))
-			return false;
-	}
+	/* May send SKBs and WQEs. */
+	if (unlikely(!mlx5e_tls_handle_tx_skb(dev, sq, skb, &state->tls)))
+		return false;
 #endif
 
 #ifdef CONFIG_MLX5_EN_IPSEC
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6847e7b909a5..64d6c0fd92bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1134,8 +1134,6 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
 	if (MLX5_IPSEC_DEV(c->priv->mdev))
 		set_bit(MLX5E_SQ_STATE_IPSEC, &sq->state);
-	if (mlx5_accel_is_tls_device(c->priv->mdev))
-		set_bit(MLX5E_SQ_STATE_TLS, &sq->state);
 	if (param->is_mpw)
 		set_bit(MLX5E_SQ_STATE_MPWQE, &sq->state);
 	sq->stop_room = param->stop_room;
-- 
2.30.2

