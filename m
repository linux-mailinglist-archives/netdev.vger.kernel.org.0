Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274C760E2A5
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbiJZNxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbiJZNwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:52:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F6C108270
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:52:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7E95B82256
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 13:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F75C433D6;
        Wed, 26 Oct 2022 13:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666792337;
        bh=aFDC2HMC7UG4EKnf24gSUjOEuAo2DxfdolmB9hCG9U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=It90NoewEWzFp+OiiZn+7BMv3VuLfDxbGplHcQoUiBzijKuEK/g2tPH52lNXSsZWE
         Skrc4eXc0ddAl0RO1nuovAP+GFl3GptWO5/+bX97D/d75pIaRKt1LH/JuJc/dRyn5k
         YrQTFvO6z6lCCyDDqvTsRlOL/q4OsWeEajfGts1hmwRh0V1v/W6/vKLUtqrYhUZt6h
         vlVko3zpDoAHI9Qnw19eL0Y9G6lcpfQjV09DecZ1QRLJgr+YjIH425tYyC4jN3zjtq
         qu5/gUVbPrQ9v/R4HXSwxmgcSalUhahJgkK/zVOs4BKp51DGQZdZHMjZ5oLjNUikx2
         HgDBNz3mR4AMg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [V4 net 04/15] net/mlx5e: Extend SKB room check to include PTP-SQ
Date:   Wed, 26 Oct 2022 14:51:42 +0100
Message-Id: <20221026135153.154807-5-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221026135153.154807-1-saeed@kernel.org>
References: <20221026135153.154807-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When tx_port_ts is set, the driver diverts all UPD traffic over PTP port
to a dedicated PTP-SQ. The SKBs are cached until the wire-CQE arrives.
When the packet size is greater then MTU, the firmware might drop it and
the packet won't be transmitted to the wire, hence the wire-CQE won't
reach the driver. In this case the SKBs are accumulated in the SKB fifo.
Add room check to consider the PTP-SQ SKB fifo, when the SKB fifo is
full, driver stops the queue resulting in a TX timeout. Devlink
TX-reporter can recover from it.

Fixes: 1880bc4e4a96 ("net/mlx5e: Add TX port timestamp support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h  | 9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c   | 6 ++++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index 5bce554e131a..cc7efde88ac3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -6,6 +6,7 @@
 
 #include "en.h"
 #include "en_stats.h"
+#include "en/txrx.h"
 #include <linux/ptp_classify.h>
 
 #define MLX5E_PTP_CHANNEL_IX 0
@@ -68,6 +69,14 @@ static inline bool mlx5e_use_ptpsq(struct sk_buff *skb)
 		fk.ports.dst == htons(PTP_EV_PORT));
 }
 
+static inline bool mlx5e_ptpsq_fifo_has_room(struct mlx5e_txqsq *sq)
+{
+	if (!sq->ptpsq)
+		return true;
+
+	return mlx5e_skb_fifo_has_room(&sq->ptpsq->skb_fifo);
+}
+
 int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   u8 lag_port, struct mlx5e_ptp **cp);
 void mlx5e_ptp_close(struct mlx5e_ptp *c);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 4456ad5cedf1..cb164b62f543 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -57,6 +57,12 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
 
+static inline bool
+mlx5e_skb_fifo_has_room(struct mlx5e_skb_fifo *fifo)
+{
+	return (*fifo->pc - *fifo->cc) < fifo->mask;
+}
+
 static inline bool
 mlx5e_wqc_has_room_for(struct mlx5_wq_cyc *wq, u16 cc, u16 pc, u16 n)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index bf2232a2a836..6adca01fbdc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -392,6 +392,11 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	if (unlikely(sq->ptpsq)) {
 		mlx5e_skb_cb_hwtstamp_init(skb);
 		mlx5e_skb_fifo_push(&sq->ptpsq->skb_fifo, skb);
+		if (!netif_tx_queue_stopped(sq->txq) &&
+		    !mlx5e_skb_fifo_has_room(&sq->ptpsq->skb_fifo)) {
+			netif_tx_stop_queue(sq->txq);
+			sq->stats->stopped++;
+		}
 		skb_get(skb);
 	}
 
@@ -868,6 +873,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 
 	if (netif_tx_queue_stopped(sq->txq) &&
 	    mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room) &&
+	    mlx5e_ptpsq_fifo_has_room(sq) &&
 	    !test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state)) {
 		netif_tx_wake_queue(sq->txq);
 		stats->wake++;
-- 
2.37.3

