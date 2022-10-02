Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183015F215F
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiJBFOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJBFOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:14:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA265072C
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:14:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFB6C60DF1
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A30C433D6;
        Sun,  2 Oct 2022 05:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687639;
        bh=bp4apwkRdM/7E35vx3icWWDxeG5guxOKFc552bYI9Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMOoijqK0SBa3rzwWkTsWv8dnSXa0+B1gb7iFGqjAXWvW+FyoROAvUaBZHVQ6b7oN
         +LqkX2NSum1rCJ8CmMN4hyv8GLcZEd4ceb5u29+MeauLhmy/23WrIASgstjvdP+YQL
         S3IbGP7fEu3BBEX55C0QtWmt2B1XRLTvV5kGAqi24G1i+jd+7X7bRRSwRzg6WKB1Xa
         Q4N5CQz1IKwDT1GMT4iEXUsJfZI+LndeEIKaveRBGDggfq5iYgFT6beAq+vU1POqT3
         fvS3x4ynZyqBXPTLQ/ZWLt5ckVir04K36dBup/Uo+zgJoLWMx8HA3FBR4pu34YmWfw
         BKVCfILQhi48A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 04/15] net/mlx5e: xsk: Improve need_wakeup logic
Date:   Sat,  1 Oct 2022 21:56:21 -0700
Message-Id: <20221002045632.291612-5-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221002045632.291612-1-saeed@kernel.org>
References: <20221002045632.291612-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

XSK need_wakeup mechanism allows the driver to stop busy waiting for
buffers when the fill ring is empty, yield to the application and signal
it that the driver needs to be waken up after the application refills
the fill ring.

Add protection against the race condition on the RX (refill) side: if
the application refills buffers after xskrq->post_wqes is called, but
before mlx5e_xsk_update_rx_wakeup, NAPI will exit, skipping taking these
buffers to the hardware WQ, and the application won't wake it up again.

Optimize the whole need_wakeup logic, removing unneeded flows, to
compensate for this new check.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   | 14 --------
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.h   | 12 -------
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c | 33 ++++++++++++-------
 4 files changed, 23 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index 84a496a8d72f..087c943bd8e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -5,7 +5,6 @@
 #define __MLX5_EN_XSK_RX_H__
 
 #include "en.h"
-#include <net/xdp_sock_drv.h>
 
 /* RX data path */
 
@@ -21,17 +20,4 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      struct mlx5e_wqe_frag_info *wi,
 					      u32 cqe_bcnt);
 
-static inline bool mlx5e_xsk_update_rx_wakeup(struct mlx5e_rq *rq, bool alloc_err)
-{
-	if (!xsk_uses_need_wakeup(rq->xsk_pool))
-		return alloc_err;
-
-	if (unlikely(alloc_err))
-		xsk_set_rx_need_wakeup(rq->xsk_pool);
-	else
-		xsk_clear_rx_need_wakeup(rq->xsk_pool);
-
-	return false;
-}
-
 #endif /* __MLX5_EN_XSK_RX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
index a05085035f23..9c505158b975 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
@@ -5,7 +5,6 @@
 #define __MLX5_EN_XSK_TX_H__
 
 #include "en.h"
-#include <net/xdp_sock_drv.h>
 
 /* TX data path */
 
@@ -13,15 +12,4 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags);
 
 bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget);
 
-static inline void mlx5e_xsk_update_tx_wakeup(struct mlx5e_xdpsq *sq)
-{
-	if (!xsk_uses_need_wakeup(sq->xsk_pool))
-		return;
-
-	if (sq->pc != sq->cc)
-		xsk_clear_tx_need_wakeup(sq->xsk_pool);
-	else
-		xsk_set_tx_need_wakeup(sq->xsk_pool);
-}
-
 #endif /* __MLX5_EN_XSK_TX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 5835d86be8d8..b61604d87701 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -41,6 +41,7 @@
 #include <net/gro.h>
 #include <net/udp.h>
 #include <net/tcp.h>
+#include <net/xdp_sock_drv.h>
 #include "en.h"
 #include "en/txrx.h"
 #include "en_tc.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 833be29170a1..9a458a5d9853 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/irq.h>
+#include <net/xdp_sock_drv.h>
 #include "en.h"
 #include "en/txrx.h"
 #include "en/xdp.h"
@@ -86,26 +87,36 @@ void mlx5e_trigger_irq(struct mlx5e_icosq *sq)
 
 static bool mlx5e_napi_xsk_post(struct mlx5e_xdpsq *xsksq, struct mlx5e_rq *xskrq)
 {
+	bool need_wakeup = xsk_uses_need_wakeup(xskrq->xsk_pool);
 	bool busy_xsk = false, xsk_rx_alloc_err;
 
-	/* Handle the race between the application querying need_wakeup and the
-	 * driver setting it:
-	 * 1. Update need_wakeup both before and after the TX. If it goes to
-	 * "yes", it can only happen with the first update.
-	 * 2. If the application queried need_wakeup before we set it, the
-	 * packets will be transmitted anyway, even w/o a wakeup.
-	 * 3. Give a chance to clear need_wakeup after new packets were queued
-	 * for TX.
+	/* If SQ is empty, there are no TX completions to trigger NAPI, so set
+	 * need_wakeup. Do it before queuing packets for TX to avoid race
+	 * condition with userspace.
 	 */
-	mlx5e_xsk_update_tx_wakeup(xsksq);
+	if (need_wakeup && xsksq->pc == xsksq->cc)
+		xsk_set_tx_need_wakeup(xsksq->xsk_pool);
 	busy_xsk |= mlx5e_xsk_tx(xsksq, MLX5E_TX_XSK_POLL_BUDGET);
-	mlx5e_xsk_update_tx_wakeup(xsksq);
+	/* If we queued some packets for TX, no need for wakeup anymore. */
+	if (need_wakeup && xsksq->pc != xsksq->cc)
+		xsk_clear_tx_need_wakeup(xsksq->xsk_pool);
 
+	/* If WQ is empty, RX won't trigger NAPI, so set need_wakeup. Do it
+	 * before refilling to avoid race condition with userspace.
+	 */
+	if (need_wakeup && !mlx5e_rqwq_get_cur_sz(xskrq))
+		xsk_set_rx_need_wakeup(xskrq->xsk_pool);
 	xsk_rx_alloc_err = INDIRECT_CALL_2(xskrq->post_wqes,
 					   mlx5e_post_rx_mpwqes,
 					   mlx5e_post_rx_wqes,
 					   xskrq);
-	busy_xsk |= mlx5e_xsk_update_rx_wakeup(xskrq, xsk_rx_alloc_err);
+	/* Ask for wakeup if WQ is not full after refill. */
+	if (!need_wakeup)
+		busy_xsk |= xsk_rx_alloc_err;
+	else if (xsk_rx_alloc_err)
+		xsk_set_rx_need_wakeup(xskrq->xsk_pool);
+	else
+		xsk_clear_rx_need_wakeup(xskrq->xsk_pool);
 
 	return busy_xsk;
 }
-- 
2.37.3

