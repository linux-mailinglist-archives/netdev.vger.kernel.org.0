Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0964B2735D0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgIUWbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727447AbgIUWbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 18:31:40 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E552C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 15:31:40 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4BwK1510fVzKmTj;
        Tue, 22 Sep 2020 00:31:37 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id KCgOXmbfBGBj; Tue, 22 Sep 2020 00:31:32 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] net: lantiq: Add locking for TX DMA channel
Date:   Tue, 22 Sep 2020 00:31:13 +0200
Message-Id: <20200921223113.8750-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 2.70 / 15.00 / 15.00
X-Rspamd-Queue-Id: EB690274
X-Rspamd-UID: 3d63d6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TX DMA channel data is accessed by the xrx200_start_xmit() and the
xrx200_tx_housekeeping() function from different threads. Make sure the
accesses are synchronized by using locking around the accesses.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/ethernet/lantiq_xrx200.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 635ff3a5dcfb..f4de09d1f582 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -59,6 +59,7 @@ struct xrx200_chan {
 	struct ltq_dma_channel dma;
 	struct sk_buff *skb[LTQ_DESC_NUM];
 
+	spinlock_t lock;
 	struct xrx200_priv *priv;
 };
 
@@ -242,9 +243,11 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
 	struct xrx200_chan *ch = container_of(napi,
 				struct xrx200_chan, napi);
 	struct net_device *net_dev = ch->priv->net_dev;
+	unsigned long flags;
 	int pkts = 0;
 	int bytes = 0;
 
+	spin_lock_irqsave(&ch->lock, flags);
 	while (pkts < budget) {
 		struct ltq_dma_desc *desc = &ch->dma.desc_base[ch->tx_free];
 
@@ -268,6 +271,8 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
 	net_dev->stats.tx_bytes += bytes;
 	netdev_completed_queue(ch->priv->net_dev, pkts, bytes);
 
+	spin_unlock_irqrestore(&ch->lock, flags);
+
 	if (netif_queue_stopped(net_dev))
 		netif_wake_queue(net_dev);
 
@@ -284,7 +289,8 @@ static netdev_tx_t xrx200_start_xmit(struct sk_buff *skb,
 {
 	struct xrx200_priv *priv = netdev_priv(net_dev);
 	struct xrx200_chan *ch = &priv->chan_tx;
-	struct ltq_dma_desc *desc = &ch->dma.desc_base[ch->dma.desc];
+	struct ltq_dma_desc *desc;
+	unsigned long flags;
 	u32 byte_offset;
 	dma_addr_t mapping;
 	int len;
@@ -297,8 +303,11 @@ static netdev_tx_t xrx200_start_xmit(struct sk_buff *skb,
 
 	len = skb->len;
 
+	spin_lock_irqsave(&ch->lock, flags);
+	desc = &ch->dma.desc_base[ch->dma.desc];
 	if ((desc->ctl & (LTQ_DMA_OWN | LTQ_DMA_C)) || ch->skb[ch->dma.desc]) {
 		netdev_err(net_dev, "tx ring full\n");
+		spin_unlock_irqrestore(&ch->lock, flags);
 		netif_stop_queue(net_dev);
 		return NETDEV_TX_BUSY;
 	}
@@ -306,8 +315,10 @@ static netdev_tx_t xrx200_start_xmit(struct sk_buff *skb,
 	ch->skb[ch->dma.desc] = skb;
 
 	mapping = dma_map_single(priv->dev, skb->data, len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(priv->dev, mapping)))
+	if (unlikely(dma_mapping_error(priv->dev, mapping))) {
+		spin_unlock_irqrestore(&ch->lock, flags);
 		goto err_drop;
+	}
 
 	/* dma needs to start on a 16 byte aligned address */
 	byte_offset = mapping % 16;
@@ -324,6 +335,8 @@ static netdev_tx_t xrx200_start_xmit(struct sk_buff *skb,
 
 	netdev_sent_queue(net_dev, len);
 
+	spin_unlock_irqrestore(&ch->lock, flags);
+
 	return NETDEV_TX_OK;
 
 err_drop:
@@ -367,6 +380,7 @@ static int xrx200_dma_init(struct xrx200_priv *priv)
 	ch_rx->dma.nr = XRX200_DMA_RX;
 	ch_rx->dma.dev = priv->dev;
 	ch_rx->priv = priv;
+	spin_lock_init(&ch_rx->lock);
 
 	ltq_dma_alloc_rx(&ch_rx->dma);
 	for (ch_rx->dma.desc = 0; ch_rx->dma.desc < LTQ_DESC_NUM;
@@ -387,6 +401,7 @@ static int xrx200_dma_init(struct xrx200_priv *priv)
 	ch_tx->dma.nr = XRX200_DMA_TX;
 	ch_tx->dma.dev = priv->dev;
 	ch_tx->priv = priv;
+	spin_lock_init(&ch_tx->lock);
 
 	ltq_dma_alloc_tx(&ch_tx->dma);
 	ret = devm_request_irq(priv->dev, ch_tx->dma.irq, xrx200_dma_irq, 0,
-- 
2.20.1

