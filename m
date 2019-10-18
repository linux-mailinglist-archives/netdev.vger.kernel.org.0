Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F43DD1DC
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 00:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731529AbfJRWG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 18:06:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731464AbfJRWG1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 18:06:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21C5A2245C;
        Fri, 18 Oct 2019 22:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436386;
        bh=UQ/uFpk4S7BzLMHs2yTm3rFt5SUAUbCRReh1EfkI7Xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mS2GIGsxpvt++A/ZP0JBZnQGBwOtH3DfGLqEtKYLa4qMSHEsBe1l9q7WlPzPKrDfu
         kmVtbce/FF6c2iqx8XBDfwKXJTF97vaLKkMCeB0IEMXpt7s/rdc7bO4xmWmZFIYmNH
         LNsFx1IlgX8ivSko6akFgFe6bxKkee0cS2HgTx8A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jose Abreu <jose.abreu@synopsys.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Joao Pinto <jpinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 038/100] net: stmmac: Fix NAPI poll in TX path when in multi-queue
Date:   Fri, 18 Oct 2019 18:04:23 -0400
Message-Id: <20191018220525.9042-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <jose.abreu@synopsys.com>

[ Upstream commit 4ccb45857c2c0776d0f72e39768295062c1a0de1 ]

Commit 8fce33317023 introduced the concept of NAPI per-channel and
independent cleaning of TX path.

This is currently breaking performance in some cases. The scenario
happens when all packets are being received in Queue 0 but the TX is
performed in Queue != 0.

Fix this by using different NAPI instances per each TX and RX queue, as
suggested by Florian.

Changes from v2:
	- Only force restart transmission if there are pending packets
Changes from v1:
	- Pass entire ring size to TX clean path (Florian)

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   5 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 115 ++++++++++--------
 2 files changed, 68 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 63e1064b27a24..e697ecd9b0a64 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -78,11 +78,10 @@ struct stmmac_rx_queue {
 };
 
 struct stmmac_channel {
-	struct napi_struct napi ____cacheline_aligned_in_smp;
+	struct napi_struct rx_napi ____cacheline_aligned_in_smp;
+	struct napi_struct tx_napi ____cacheline_aligned_in_smp;
 	struct stmmac_priv *priv_data;
 	u32 index;
-	int has_rx;
-	int has_tx;
 };
 
 struct stmmac_tc_entry {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0101ebaecf028..ab48d384166bc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -155,7 +155,10 @@ static void stmmac_disable_all_queues(struct stmmac_priv *priv)
 	for (queue = 0; queue < maxq; queue++) {
 		struct stmmac_channel *ch = &priv->channel[queue];
 
-		napi_disable(&ch->napi);
+		if (queue < rx_queues_cnt)
+			napi_disable(&ch->rx_napi);
+		if (queue < tx_queues_cnt)
+			napi_disable(&ch->tx_napi);
 	}
 }
 
@@ -173,7 +176,10 @@ static void stmmac_enable_all_queues(struct stmmac_priv *priv)
 	for (queue = 0; queue < maxq; queue++) {
 		struct stmmac_channel *ch = &priv->channel[queue];
 
-		napi_enable(&ch->napi);
+		if (queue < rx_queues_cnt)
+			napi_enable(&ch->rx_napi);
+		if (queue < tx_queues_cnt)
+			napi_enable(&ch->tx_napi);
 	}
 }
 
@@ -1946,6 +1952,10 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(eee_timer));
 	}
 
+	/* We still have pending packets, let's call for a new scheduling */
+	if (tx_q->dirty_tx != tx_q->cur_tx)
+		mod_timer(&tx_q->txtimer, STMMAC_COAL_TIMER(10));
+
 	__netif_tx_unlock_bh(netdev_get_tx_queue(priv->dev, queue));
 
 	return count;
@@ -2036,23 +2046,15 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan)
 	int status = stmmac_dma_interrupt_status(priv, priv->ioaddr,
 						 &priv->xstats, chan);
 	struct stmmac_channel *ch = &priv->channel[chan];
-	bool needs_work = false;
-
-	if ((status & handle_rx) && ch->has_rx) {
-		needs_work = true;
-	} else {
-		status &= ~handle_rx;
-	}
 
-	if ((status & handle_tx) && ch->has_tx) {
-		needs_work = true;
-	} else {
-		status &= ~handle_tx;
+	if ((status & handle_rx) && (chan < priv->plat->rx_queues_to_use)) {
+		stmmac_disable_dma_irq(priv, priv->ioaddr, chan);
+		napi_schedule_irqoff(&ch->rx_napi);
 	}
 
-	if (needs_work && napi_schedule_prep(&ch->napi)) {
+	if ((status & handle_tx) && (chan < priv->plat->tx_queues_to_use)) {
 		stmmac_disable_dma_irq(priv, priv->ioaddr, chan);
-		__napi_schedule(&ch->napi);
+		napi_schedule_irqoff(&ch->tx_napi);
 	}
 
 	return status;
@@ -2248,8 +2250,14 @@ static void stmmac_tx_timer(struct timer_list *t)
 
 	ch = &priv->channel[tx_q->queue_index];
 
-	if (likely(napi_schedule_prep(&ch->napi)))
-		__napi_schedule(&ch->napi);
+	/*
+	 * If NAPI is already running we can miss some events. Let's rearm
+	 * the timer and try again.
+	 */
+	if (likely(napi_schedule_prep(&ch->tx_napi)))
+		__napi_schedule(&ch->tx_napi);
+	else
+		mod_timer(&tx_q->txtimer, STMMAC_COAL_TIMER(10));
 }
 
 /**
@@ -3506,7 +3514,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			else
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 
-			napi_gro_receive(&ch->napi, skb);
+			napi_gro_receive(&ch->rx_napi, skb);
 
 			priv->dev->stats.rx_packets++;
 			priv->dev->stats.rx_bytes += frame_len;
@@ -3520,40 +3528,45 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 	return count;
 }
 
-/**
- *  stmmac_poll - stmmac poll method (NAPI)
- *  @napi : pointer to the napi structure.
- *  @budget : maximum number of packets that the current CPU can receive from
- *	      all interfaces.
- *  Description :
- *  To look at the incoming frames and clear the tx resources.
- */
-static int stmmac_napi_poll(struct napi_struct *napi, int budget)
+static int stmmac_napi_poll_rx(struct napi_struct *napi, int budget)
 {
 	struct stmmac_channel *ch =
-		container_of(napi, struct stmmac_channel, napi);
+		container_of(napi, struct stmmac_channel, rx_napi);
 	struct stmmac_priv *priv = ch->priv_data;
-	int work_done, rx_done = 0, tx_done = 0;
 	u32 chan = ch->index;
+	int work_done;
 
 	priv->xstats.napi_poll++;
 
-	if (ch->has_tx)
-		tx_done = stmmac_tx_clean(priv, budget, chan);
-	if (ch->has_rx)
-		rx_done = stmmac_rx(priv, budget, chan);
+	work_done = stmmac_rx(priv, budget, chan);
+	if (work_done < budget && napi_complete_done(napi, work_done))
+		stmmac_enable_dma_irq(priv, priv->ioaddr, chan);
+	return work_done;
+}
 
-	work_done = max(rx_done, tx_done);
-	work_done = min(work_done, budget);
+static int stmmac_napi_poll_tx(struct napi_struct *napi, int budget)
+{
+	struct stmmac_channel *ch =
+		container_of(napi, struct stmmac_channel, tx_napi);
+	struct stmmac_priv *priv = ch->priv_data;
+	struct stmmac_tx_queue *tx_q;
+	u32 chan = ch->index;
+	int work_done;
 
-	if (work_done < budget && napi_complete_done(napi, work_done)) {
-		int stat;
+	priv->xstats.napi_poll++;
+
+	work_done = stmmac_tx_clean(priv, DMA_TX_SIZE, chan);
+	work_done = min(work_done, budget);
 
+	if (work_done < budget && napi_complete_done(napi, work_done))
 		stmmac_enable_dma_irq(priv, priv->ioaddr, chan);
-		stat = stmmac_dma_interrupt_status(priv, priv->ioaddr,
-						   &priv->xstats, chan);
-		if (stat && napi_reschedule(napi))
-			stmmac_disable_dma_irq(priv, priv->ioaddr, chan);
+
+	/* Force transmission restart */
+	tx_q = &priv->tx_queue[chan];
+	if (tx_q->cur_tx != tx_q->dirty_tx) {
+		stmmac_enable_dma_transmission(priv, priv->ioaddr);
+		stmmac_set_tx_tail_ptr(priv, priv->ioaddr, tx_q->tx_tail_addr,
+				       chan);
 	}
 
 	return work_done;
@@ -4376,13 +4389,14 @@ int stmmac_dvr_probe(struct device *device,
 		ch->priv_data = priv;
 		ch->index = queue;
 
-		if (queue < priv->plat->rx_queues_to_use)
-			ch->has_rx = true;
-		if (queue < priv->plat->tx_queues_to_use)
-			ch->has_tx = true;
-
-		netif_napi_add(ndev, &ch->napi, stmmac_napi_poll,
-			       NAPI_POLL_WEIGHT);
+		if (queue < priv->plat->rx_queues_to_use) {
+			netif_napi_add(ndev, &ch->rx_napi, stmmac_napi_poll_rx,
+				       NAPI_POLL_WEIGHT);
+		}
+		if (queue < priv->plat->tx_queues_to_use) {
+			netif_napi_add(ndev, &ch->tx_napi, stmmac_napi_poll_tx,
+				       NAPI_POLL_WEIGHT);
+		}
 	}
 
 	mutex_init(&priv->lock);
@@ -4438,7 +4452,10 @@ int stmmac_dvr_probe(struct device *device,
 	for (queue = 0; queue < maxq; queue++) {
 		struct stmmac_channel *ch = &priv->channel[queue];
 
-		netif_napi_del(&ch->napi);
+		if (queue < priv->plat->rx_queues_to_use)
+			netif_napi_del(&ch->rx_napi);
+		if (queue < priv->plat->tx_queues_to_use)
+			netif_napi_del(&ch->tx_napi);
 	}
 error_hw_init:
 	destroy_workqueue(priv->wq);
-- 
2.20.1

