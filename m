Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407353372C8
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhCKMfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbhCKMfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:35:40 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3879C061574;
        Thu, 11 Mar 2021 04:35:39 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id k9so39469146lfo.12;
        Thu, 11 Mar 2021 04:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o5qxReKkHr2BQpWpdQQewWwnlKU+1BOZJGS75lh3+O8=;
        b=OEJQJ81a8fMvCeMtH3T+zcUWzyhdPfF4ervN4pHAm/h1fOAN2GEGq4vKtltItPqfi1
         QnKm+T6rDxwrwoHF1uWjP28b/czXgHWlmErujl/paSZIc/s8ngz3mXVPcQGfzpbfnm9T
         Pva+jQNjHye+zLHejHnIOoTPpu5Wm+xpGpVilnLkjnp/4yjQplrYUdpMAG39TuARTdv8
         TY+6+azCsBrwJ5eoSOPGC763rRHACIaNCD5POVjyh67hwT7LvvhVGabGi8Gntsh+wqbg
         y8dkRxBYvZbuL3dCcje4BJKZVyg6uU6eRjKkCxMj1XpwZb6xhk+K48qLRPWNPyegMx3E
         l0sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o5qxReKkHr2BQpWpdQQewWwnlKU+1BOZJGS75lh3+O8=;
        b=tKrXyspTeBKeN81lmoaqBDAuNmhYly5loDvbg9tvVaBH6IEORloqUtGXEv0caROvF3
         vl/DcN9wVWF8SPxX6KWIP9oPEcD+PrjcKmyVAsYvgCI3MxLU1DvAQ9WiGmd7mtASB2g+
         WF85RvssjJs4NGZfuIQkSibOURnnXlPwHpbHGNruugjxHjRaioThNGfJ8d6QuUbwX6so
         KAL1bQrD+ozbNK+wJkrRFeJTI3Y65KOCmTZ4YfvJbg5ATiCg0/T4ldmj5XlQTQ9NWdRk
         RkVUs9VEM8kt0V3DwkACE7fGsfJYqHfLOaAIZ+bJLT4qeaD2RFapT+1kIg0QaiGfbTrB
         1Vjw==
X-Gm-Message-State: AOAM5302tbe6UtN9GdpJNVv2n5oYtCLyBHnsBwgufKZQ8eDdAC3vyF9L
        6yMT4mQSVHB2kLF8gzYt0m4=
X-Google-Smtp-Source: ABdhPJw56Fbe1ylWkyxwkqz+ynZHR/AGEpUAYMPtL0xlg68uDo2C4KXrxGhpRPaFAG4ZMxmctWChdw==
X-Received: by 2002:ac2:51dc:: with SMTP id u28mr2134374lfm.322.1615466138353;
        Thu, 11 Mar 2021 04:35:38 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id j144sm774280lfj.241.2021.03.11.04.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 04:35:37 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 net-next 2/2] net: broadcom: bcm4908_enet: support TX interrupt
Date:   Thu, 11 Mar 2021 13:35:21 +0100
Message-Id: <20210311123521.22777-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311123521.22777-1-zajec5@gmail.com>
References: <20210310091410.10164-1-zajec5@gmail.com>
 <20210311123521.22777-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

It appears that each DMA channel has its own interrupt and both rings
can be configured (the same way) to handle interrupts.

1. Make ring interrupts code generic (make it operate on given ring)
2. Move napi to ring (so each has its own)
3. Make IRQ handler generic (match ring against received IRQ number)
4. Add (optional) support for TX interrupt

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Change (irq_tx >= 0) to (irq_tx > 0) for consistency. IRQ no can be
    1+. Thanks David!
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 138 ++++++++++++++-----
 1 file changed, 103 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 199da299cbd0..cbfed1d1477b 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -54,6 +54,7 @@ struct bcm4908_enet_dma_ring {
 	int length;
 	u16 cfg_block;
 	u16 st_ram_block;
+	struct napi_struct napi;
 
 	union {
 		void *cpu_addr;
@@ -67,8 +68,8 @@ struct bcm4908_enet_dma_ring {
 struct bcm4908_enet {
 	struct device *dev;
 	struct net_device *netdev;
-	struct napi_struct napi;
 	void __iomem *base;
+	int irq_tx;
 
 	struct bcm4908_enet_dma_ring tx_ring;
 	struct bcm4908_enet_dma_ring rx_ring;
@@ -123,24 +124,31 @@ static void enet_umac_set(struct bcm4908_enet *enet, u16 offset, u32 set)
  * Helpers
  */
 
-static void bcm4908_enet_intrs_on(struct bcm4908_enet *enet)
+static void bcm4908_enet_set_mtu(struct bcm4908_enet *enet, int mtu)
 {
-	enet_write(enet, ENET_DMA_CH_RX_CFG + ENET_DMA_CH_CFG_INT_MASK, ENET_DMA_INT_DEFAULTS);
+	enet_umac_write(enet, UMAC_MAX_FRAME_LEN, mtu + ENET_MAX_ETH_OVERHEAD);
 }
 
-static void bcm4908_enet_intrs_off(struct bcm4908_enet *enet)
+/***
+ * DMA ring ops
+ */
+
+static void bcm4908_enet_dma_ring_intrs_on(struct bcm4908_enet *enet,
+					   struct bcm4908_enet_dma_ring *ring)
 {
-	enet_write(enet, ENET_DMA_CH_RX_CFG + ENET_DMA_CH_CFG_INT_MASK, 0);
+	enet_write(enet, ring->cfg_block + ENET_DMA_CH_CFG_INT_MASK, ENET_DMA_INT_DEFAULTS);
 }
 
-static void bcm4908_enet_intrs_ack(struct bcm4908_enet *enet)
+static void bcm4908_enet_dma_ring_intrs_off(struct bcm4908_enet *enet,
+					    struct bcm4908_enet_dma_ring *ring)
 {
-	enet_write(enet, ENET_DMA_CH_RX_CFG + ENET_DMA_CH_CFG_INT_STAT, ENET_DMA_INT_DEFAULTS);
+	enet_write(enet, ring->cfg_block + ENET_DMA_CH_CFG_INT_MASK, 0);
 }
 
-static void bcm4908_enet_set_mtu(struct bcm4908_enet *enet, int mtu)
+static void bcm4908_enet_dma_ring_intrs_ack(struct bcm4908_enet *enet,
+					    struct bcm4908_enet_dma_ring *ring)
 {
-	enet_umac_write(enet, UMAC_MAX_FRAME_LEN, mtu + ENET_MAX_ETH_OVERHEAD);
+	enet_write(enet, ring->cfg_block + ENET_DMA_CH_CFG_INT_STAT, ENET_DMA_INT_DEFAULTS);
 }
 
 /***
@@ -414,11 +422,14 @@ static void bcm4908_enet_gmac_init(struct bcm4908_enet *enet)
 static irqreturn_t bcm4908_enet_irq_handler(int irq, void *dev_id)
 {
 	struct bcm4908_enet *enet = dev_id;
+	struct bcm4908_enet_dma_ring *ring;
 
-	bcm4908_enet_intrs_off(enet);
-	bcm4908_enet_intrs_ack(enet);
+	ring = (irq == enet->irq_tx) ? &enet->tx_ring : &enet->rx_ring;
 
-	napi_schedule(&enet->napi);
+	bcm4908_enet_dma_ring_intrs_off(enet, ring);
+	bcm4908_enet_dma_ring_intrs_ack(enet, ring);
+
+	napi_schedule(&ring->napi);
 
 	return IRQ_HANDLED;
 }
@@ -426,6 +437,8 @@ static irqreturn_t bcm4908_enet_irq_handler(int irq, void *dev_id)
 static int bcm4908_enet_open(struct net_device *netdev)
 {
 	struct bcm4908_enet *enet = netdev_priv(netdev);
+	struct bcm4908_enet_dma_ring *tx_ring = &enet->tx_ring;
+	struct bcm4908_enet_dma_ring *rx_ring = &enet->rx_ring;
 	struct device *dev = enet->dev;
 	int err;
 
@@ -435,6 +448,17 @@ static int bcm4908_enet_open(struct net_device *netdev)
 		return err;
 	}
 
+	if (enet->irq_tx > 0) {
+		err = request_irq(enet->irq_tx, bcm4908_enet_irq_handler, 0,
+				  "tx", enet);
+		if (err) {
+			dev_err(dev, "Failed to request IRQ %d: %d\n",
+				enet->irq_tx, err);
+			free_irq(netdev->irq, enet);
+			return err;
+		}
+	}
+
 	bcm4908_enet_gmac_init(enet);
 	bcm4908_enet_dma_reset(enet);
 	bcm4908_enet_dma_init(enet);
@@ -443,14 +467,19 @@ static int bcm4908_enet_open(struct net_device *netdev)
 
 	enet_set(enet, ENET_DMA_CONTROLLER_CFG, ENET_DMA_CTRL_CFG_MASTER_EN);
 	enet_maskset(enet, ENET_DMA_CONTROLLER_CFG, ENET_DMA_CTRL_CFG_FLOWC_CH1_EN, 0);
-	bcm4908_enet_dma_rx_ring_enable(enet, &enet->rx_ring);
 
-	napi_enable(&enet->napi);
+	if (enet->irq_tx > 0) {
+		napi_enable(&tx_ring->napi);
+		bcm4908_enet_dma_ring_intrs_ack(enet, tx_ring);
+		bcm4908_enet_dma_ring_intrs_on(enet, tx_ring);
+	}
+
+	bcm4908_enet_dma_rx_ring_enable(enet, rx_ring);
+	napi_enable(&rx_ring->napi);
 	netif_carrier_on(netdev);
 	netif_start_queue(netdev);
-
-	bcm4908_enet_intrs_ack(enet);
-	bcm4908_enet_intrs_on(enet);
+	bcm4908_enet_dma_ring_intrs_ack(enet, rx_ring);
+	bcm4908_enet_dma_ring_intrs_on(enet, rx_ring);
 
 	return 0;
 }
@@ -458,16 +487,20 @@ static int bcm4908_enet_open(struct net_device *netdev)
 static int bcm4908_enet_stop(struct net_device *netdev)
 {
 	struct bcm4908_enet *enet = netdev_priv(netdev);
+	struct bcm4908_enet_dma_ring *tx_ring = &enet->tx_ring;
+	struct bcm4908_enet_dma_ring *rx_ring = &enet->rx_ring;
 
 	netif_stop_queue(netdev);
 	netif_carrier_off(netdev);
-	napi_disable(&enet->napi);
+	napi_disable(&rx_ring->napi);
+	napi_disable(&tx_ring->napi);
 
 	bcm4908_enet_dma_rx_ring_disable(enet, &enet->rx_ring);
 	bcm4908_enet_dma_tx_ring_disable(enet, &enet->tx_ring);
 
 	bcm4908_enet_dma_uninit(enet);
 
+	free_irq(enet->irq_tx, enet);
 	free_irq(enet->netdev->irq, enet);
 
 	return 0;
@@ -484,25 +517,19 @@ static int bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_device *netde
 	u32 tmp;
 
 	/* Free transmitted skbs */
-	while (ring->read_idx != ring->write_idx) {
-		buf_desc = &ring->buf_desc[ring->read_idx];
-		if (le32_to_cpu(buf_desc->ctl) & DMA_CTL_STATUS_OWN)
-			break;
-		slot = &ring->slots[ring->read_idx];
-
-		dma_unmap_single(dev, slot->dma_addr, slot->len, DMA_TO_DEVICE);
-		dev_kfree_skb(slot->skb);
-		if (++ring->read_idx == ring->length)
-			ring->read_idx = 0;
-	}
+	if (enet->irq_tx < 0 &&
+	    !(le32_to_cpu(ring->buf_desc[ring->read_idx].ctl) & DMA_CTL_STATUS_OWN))
+		napi_schedule(&enet->tx_ring.napi);
 
 	/* Don't use the last empty buf descriptor */
 	if (ring->read_idx <= ring->write_idx)
 		free_buf_descs = ring->read_idx - ring->write_idx + ring->length;
 	else
 		free_buf_descs = ring->read_idx - ring->write_idx;
-	if (free_buf_descs < 2)
+	if (free_buf_descs < 2) {
+		netif_stop_queue(netdev);
 		return NETDEV_TX_BUSY;
+	}
 
 	/* Hardware removes OWN bit after sending data */
 	buf_desc = &ring->buf_desc[ring->write_idx];
@@ -539,9 +566,10 @@ static int bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_device *netde
 	return NETDEV_TX_OK;
 }
 
-static int bcm4908_enet_poll(struct napi_struct *napi, int weight)
+static int bcm4908_enet_poll_rx(struct napi_struct *napi, int weight)
 {
-	struct bcm4908_enet *enet = container_of(napi, struct bcm4908_enet, napi);
+	struct bcm4908_enet_dma_ring *rx_ring = container_of(napi, struct bcm4908_enet_dma_ring, napi);
+	struct bcm4908_enet *enet = container_of(rx_ring, struct bcm4908_enet, rx_ring);
 	struct device *dev = enet->dev;
 	int handled = 0;
 
@@ -590,7 +618,7 @@ static int bcm4908_enet_poll(struct napi_struct *napi, int weight)
 
 	if (handled < weight) {
 		napi_complete_done(napi, handled);
-		bcm4908_enet_intrs_on(enet);
+		bcm4908_enet_dma_ring_intrs_on(enet, rx_ring);
 	}
 
 	/* Hardware could disable ring if it run out of descriptors */
@@ -599,6 +627,42 @@ static int bcm4908_enet_poll(struct napi_struct *napi, int weight)
 	return handled;
 }
 
+static int bcm4908_enet_poll_tx(struct napi_struct *napi, int weight)
+{
+	struct bcm4908_enet_dma_ring *tx_ring = container_of(napi, struct bcm4908_enet_dma_ring, napi);
+	struct bcm4908_enet *enet = container_of(tx_ring, struct bcm4908_enet, tx_ring);
+	struct bcm4908_enet_dma_ring_bd *buf_desc;
+	struct bcm4908_enet_dma_ring_slot *slot;
+	struct device *dev = enet->dev;
+	unsigned int bytes = 0;
+	int handled = 0;
+
+	while (handled < weight && tx_ring->read_idx != tx_ring->write_idx) {
+		buf_desc = &tx_ring->buf_desc[tx_ring->read_idx];
+		if (le32_to_cpu(buf_desc->ctl) & DMA_CTL_STATUS_OWN)
+			break;
+		slot = &tx_ring->slots[tx_ring->read_idx];
+
+		dma_unmap_single(dev, slot->dma_addr, slot->len, DMA_TO_DEVICE);
+		dev_kfree_skb(slot->skb);
+		bytes += slot->len;
+		if (++tx_ring->read_idx == tx_ring->length)
+			tx_ring->read_idx = 0;
+
+		handled++;
+	}
+
+	if (handled < weight) {
+		napi_complete_done(napi, handled);
+		bcm4908_enet_dma_ring_intrs_on(enet, tx_ring);
+	}
+
+	if (netif_queue_stopped(enet->netdev))
+		netif_wake_queue(enet->netdev);
+
+	return handled;
+}
+
 static int bcm4908_enet_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct bcm4908_enet *enet = netdev_priv(netdev);
@@ -642,6 +706,8 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 	if (netdev->irq < 0)
 		return netdev->irq;
 
+	enet->irq_tx = platform_get_irq_byname(pdev, "tx");
+
 	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
 
 	err = bcm4908_enet_dma_alloc(enet);
@@ -658,7 +724,8 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 	netdev->min_mtu = ETH_ZLEN;
 	netdev->mtu = ETH_DATA_LEN;
 	netdev->max_mtu = ENET_MTU_MAX;
-	netif_napi_add(netdev, &enet->napi, bcm4908_enet_poll, 64);
+	netif_tx_napi_add(netdev, &enet->tx_ring.napi, bcm4908_enet_poll_tx, NAPI_POLL_WEIGHT);
+	netif_napi_add(netdev, &enet->rx_ring.napi, bcm4908_enet_poll_rx, NAPI_POLL_WEIGHT);
 
 	err = register_netdev(netdev);
 	if (err) {
@@ -676,7 +743,8 @@ static int bcm4908_enet_remove(struct platform_device *pdev)
 	struct bcm4908_enet *enet = platform_get_drvdata(pdev);
 
 	unregister_netdev(enet->netdev);
-	netif_napi_del(&enet->napi);
+	netif_napi_del(&enet->rx_ring.napi);
+	netif_napi_del(&enet->tx_ring.napi);
 	bcm4908_enet_dma_free(enet);
 
 	return 0;
-- 
2.26.2

