Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4F22E27AB
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 15:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgLXO0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 09:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgLXO0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 09:26:49 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B4AC061282;
        Thu, 24 Dec 2020 06:26:08 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id b5so1249323pjk.2;
        Thu, 24 Dec 2020 06:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jAEXiqW9yG35s2MZldq2yVN2iK/ftCn1750/UR2O//A=;
        b=bUokllJDv1jJ44Wl4s7fmy6dYY1y2xrjsHXmViJ923GU1tQuG02nrg7728Od79nw0i
         Xi+0qFz9zMmVxxFPiW0KpayaYtu1PCxTBfixSz/NIS38miHs071RlA9lvad3/nZJ6TAu
         R9drvxZNmACu8c10+oAqgPB+RMFvHlaZgSRgZqijqeXMQ9DUDXNvnA02558HsYHDBfFf
         wzgHIZbRlKf4cSudDRlh5EZ7sWFkzTUVN9QxLUrCifHt2S1qHj1ZK8agm/21ZSTgwGZE
         nCaDa2q0f9C8ZC5RwPYdYEMdRYRamhsicajc9kkUdviJPqqnuyjFyvJ7mM5eQT8xOP4O
         QmpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jAEXiqW9yG35s2MZldq2yVN2iK/ftCn1750/UR2O//A=;
        b=rO5/hkPcSysyeoIunwshO/pmWdj2eZeA5hh0RhY4aZGd2n67ZZoIbk1yBPZRg8oj/9
         cxnXHgrsLtKDm3FvDrO7FGIZP4TKEA2ChULsHI+1MVOrKOpv2eyssJ1CNz1UBfoNaHov
         pJyujtcyN0WfqJV/9RAzu0r6YwZx+UdYdFpZlBd/HJYTocjtqCh8vWom2ggg2ZnCquOm
         WsvbtazCQBexvkK5ZOdo/g9vuFYlDZuBOhQ6WVrckthGR5/2FK4Xejztm4KyZYWPRpA7
         9dJD4hkkT3910TYc3YHyUMtC/OTURCwrlzXYzzEc5dGvgrz4CwyotlQa/zXPs0A0Kzu1
         tmHA==
X-Gm-Message-State: AOAM531ujhZ0tubHTIJzxkvya6n8Uh5qVVcuhVivpTC/P8j5eQbHQWfn
        QLkqDG6DEUfKWk64es26464=
X-Google-Smtp-Source: ABdhPJxjtElVhM2/u1mxmIJnlcyEQWH3vflNey+wvaLv+kl08UDmpfG+tF0kfMQvkGfNy9bB5UIkBA==
X-Received: by 2002:a17:902:7292:b029:dc:ac9:25b5 with SMTP id d18-20020a1709027292b02900dc0ac925b5mr30440767pll.2.1608819968481;
        Thu, 24 Dec 2020 06:26:08 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id r185sm26936351pfc.53.2020.12.24.06.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 06:26:08 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/6] bcm63xx_enet: convert to build_skb
Date:   Thu, 24 Dec 2020 22:24:20 +0800
Message-Id: <20201224142421.32350-6-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201224142421.32350-1-liew.s.piaw@gmail.com>
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can increase the efficiency of rx path by using buffers to receive
packets then build SKBs around them just before passing into the network
stack. In contrast, preallocating SKBs too early reduces CPU cache
efficiency.

Check if we're in NAPI context when refilling RX. Normally we're almost
always running in NAPI context. Dispatch to napi_alloc_frag directly
instead of relying on netdev_alloc_frag which does the same but
with the overhead of local_bh_disable/enable.

Tested on BCM6328 320 MHz and iperf3 -M 512 to measure packet/sec
performance. Included netif_receive_skb_list and NET_IP_ALIGN
optimizations.

Before:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-10.00  sec  49.9 MBytes  41.9 Mbits/sec  197         sender
[  4]   0.00-10.00  sec  49.3 MBytes  41.3 Mbits/sec            receiver

After:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec   171 MBytes  47.8 Mbits/sec  272         sender
[  4]   0.00-30.00  sec   170 MBytes  47.6 Mbits/sec            receiver

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 157 +++++++++----------
 drivers/net/ethernet/broadcom/bcm63xx_enet.h |  14 +-
 2 files changed, 80 insertions(+), 91 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 51976ed87d2d..8c2e97311a2c 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -220,7 +220,7 @@ static void bcm_enet_mdio_write_mii(struct net_device *dev, int mii_id,
 /*
  * refill rx queue
  */
-static int bcm_enet_refill_rx(struct net_device *dev)
+static int bcm_enet_refill_rx(struct net_device *dev, bool napi_mode)
 {
 	struct bcm_enet_priv *priv;
 
@@ -228,29 +228,29 @@ static int bcm_enet_refill_rx(struct net_device *dev)
 
 	while (priv->rx_desc_count < priv->rx_ring_size) {
 		struct bcm_enet_desc *desc;
-		struct sk_buff *skb;
-		dma_addr_t p;
 		int desc_idx;
 		u32 len_stat;
 
 		desc_idx = priv->rx_dirty_desc;
 		desc = &priv->rx_desc_cpu[desc_idx];
 
-		if (!priv->rx_skb[desc_idx]) {
-			if (priv->enet_is_sw)
-				skb = netdev_alloc_skb_ip_align(dev, priv->rx_skb_size);
+		if (!priv->rx_buf[desc_idx]) {
+			void *buf;
+
+			if (likely(napi_mode))
+				buf = napi_alloc_frag(priv->rx_frag_size);
 			else
-				skb = netdev_alloc_skb(dev, priv->rx_skb_size);
-			if (!skb)
+				buf = netdev_alloc_frag(priv->rx_frag_size);
+			if (unlikely(!buf))
 				break;
-			priv->rx_skb[desc_idx] = skb;
-			p = dma_map_single(&priv->pdev->dev, skb->data,
-					   priv->rx_skb_size,
-					   DMA_FROM_DEVICE);
-			desc->address = p;
+			priv->rx_buf[desc_idx] = buf;
+			desc->address = dma_map_single(&priv->pdev->dev,
+						       buf + priv->rx_buf_offset,
+						       priv->rx_buf_size,
+						       DMA_FROM_DEVICE);
 		}
 
-		len_stat = priv->rx_skb_size << DMADESC_LENGTH_SHIFT;
+		len_stat = priv->rx_buf_size << DMADESC_LENGTH_SHIFT;
 		len_stat |= DMADESC_OWNER_MASK;
 		if (priv->rx_dirty_desc == priv->rx_ring_size - 1) {
 			len_stat |= (DMADESC_WRAP_MASK >> priv->dma_desc_shift);
@@ -290,7 +290,7 @@ static void bcm_enet_refill_rx_timer(struct timer_list *t)
 	struct net_device *dev = priv->net_dev;
 
 	spin_lock(&priv->rx_lock);
-	bcm_enet_refill_rx(dev);
+	bcm_enet_refill_rx(dev, false);
 	spin_unlock(&priv->rx_lock);
 }
 
@@ -320,6 +320,7 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 		int desc_idx;
 		u32 len_stat;
 		unsigned int len;
+		void *buf;
 
 		desc_idx = priv->rx_curr_desc;
 		desc = &priv->rx_desc_cpu[desc_idx];
@@ -365,16 +366,14 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 		}
 
 		/* valid packet */
-		skb = priv->rx_skb[desc_idx];
+		buf = priv->rx_buf[desc_idx];
 		len = (len_stat & DMADESC_LENGTH_MASK) >> DMADESC_LENGTH_SHIFT;
 		/* don't include FCS */
 		len -= 4;
 
 		if (len < copybreak) {
-			struct sk_buff *nskb;
-
-			nskb = napi_alloc_skb(&priv->napi, len);
-			if (!nskb) {
+			skb = napi_alloc_skb(&priv->napi, len);
+			if (unlikely(!skb)) {
 				/* forget packet, just rearm desc */
 				dev->stats.rx_dropped++;
 				continue;
@@ -382,14 +381,21 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 
 			dma_sync_single_for_cpu(kdev, desc->address,
 						len, DMA_FROM_DEVICE);
-			memcpy(nskb->data, skb->data, len);
+			memcpy(skb->data, buf + priv->rx_buf_offset, len);
 			dma_sync_single_for_device(kdev, desc->address,
 						   len, DMA_FROM_DEVICE);
-			skb = nskb;
 		} else {
-			dma_unmap_single(&priv->pdev->dev, desc->address,
-					 priv->rx_skb_size, DMA_FROM_DEVICE);
-			priv->rx_skb[desc_idx] = NULL;
+			dma_unmap_single(kdev, desc->address,
+					 priv->rx_buf_size, DMA_FROM_DEVICE);
+			priv->rx_buf[desc_idx] = NULL;
+
+			skb = build_skb(buf, priv->rx_frag_size);
+			if (unlikely(!skb)) {
+				skb_free_frag(buf);
+				dev->stats.rx_dropped++;
+				continue;
+			}
+			skb_reserve(skb, priv->rx_buf_offset);
 		}
 
 		skb_put(skb, len);
@@ -403,7 +409,7 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 	netif_receive_skb_list(&rx_list);
 
 	if (processed || !priv->rx_desc_count) {
-		bcm_enet_refill_rx(dev);
+		bcm_enet_refill_rx(dev, true);
 
 		/* kick rx dma */
 		enet_dmac_writel(priv, priv->dma_chan_en_mask,
@@ -862,6 +868,24 @@ static void bcm_enet_adjust_link(struct net_device *dev)
 		priv->pause_tx ? "tx" : "off");
 }
 
+static void bcm_enet_free_rx_buf_ring(struct device *kdev, struct bcm_enet_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->rx_ring_size; i++) {
+		struct bcm_enet_desc *desc;
+
+		if (!priv->rx_buf[i])
+			continue;
+
+		desc = &priv->rx_desc_cpu[i];
+		dma_unmap_single(kdev, desc->address, priv->rx_buf_size,
+				 DMA_FROM_DEVICE);
+		skb_free_frag(priv->rx_buf[i]);
+	}
+	kfree(priv->rx_buf);
+}
+
 /*
  * open callback, allocate dma rings & buffers and start rx operation
  */
@@ -971,10 +995,10 @@ static int bcm_enet_open(struct net_device *dev)
 	priv->tx_curr_desc = 0;
 	spin_lock_init(&priv->tx_lock);
 
-	/* init & fill rx ring with skbs */
-	priv->rx_skb = kcalloc(priv->rx_ring_size, sizeof(struct sk_buff *),
+	/* init & fill rx ring with buffers */
+	priv->rx_buf = kcalloc(priv->rx_ring_size, sizeof(void *),
 			       GFP_KERNEL);
-	if (!priv->rx_skb) {
+	if (!priv->rx_buf) {
 		ret = -ENOMEM;
 		goto out_free_tx_skb;
 	}
@@ -991,7 +1015,7 @@ static int bcm_enet_open(struct net_device *dev)
 		enet_dmac_writel(priv, ENETDMA_BUFALLOC_FORCE_MASK | 0,
 				ENETDMAC_BUFALLOC, priv->rx_chan);
 
-	if (bcm_enet_refill_rx(dev)) {
+	if (bcm_enet_refill_rx(dev, false)) {
 		dev_err(kdev, "cannot allocate rx skb queue\n");
 		ret = -ENOMEM;
 		goto out;
@@ -1086,18 +1110,7 @@ static int bcm_enet_open(struct net_device *dev)
 	return 0;
 
 out:
-	for (i = 0; i < priv->rx_ring_size; i++) {
-		struct bcm_enet_desc *desc;
-
-		if (!priv->rx_skb[i])
-			continue;
-
-		desc = &priv->rx_desc_cpu[i];
-		dma_unmap_single(kdev, desc->address, priv->rx_skb_size,
-				 DMA_FROM_DEVICE);
-		kfree_skb(priv->rx_skb[i]);
-	}
-	kfree(priv->rx_skb);
+	bcm_enet_free_rx_buf_ring(kdev, priv);
 
 out_free_tx_skb:
 	kfree(priv->tx_skb);
@@ -1176,7 +1189,6 @@ static int bcm_enet_stop(struct net_device *dev)
 {
 	struct bcm_enet_priv *priv;
 	struct device *kdev;
-	int i;
 
 	priv = netdev_priv(dev);
 	kdev = &priv->pdev->dev;
@@ -1204,21 +1216,10 @@ static int bcm_enet_stop(struct net_device *dev)
 	/* force reclaim of all tx buffers */
 	bcm_enet_tx_reclaim(dev, 1);
 
-	/* free the rx skb ring */
-	for (i = 0; i < priv->rx_ring_size; i++) {
-		struct bcm_enet_desc *desc;
-
-		if (!priv->rx_skb[i])
-			continue;
-
-		desc = &priv->rx_desc_cpu[i];
-		dma_unmap_single(kdev, desc->address, priv->rx_skb_size,
-				 DMA_FROM_DEVICE);
-		kfree_skb(priv->rx_skb[i]);
-	}
+	/* free the rx buffer ring */
+	bcm_enet_free_rx_buf_ring(kdev, priv);
 
 	/* free remaining allocated memory */
-	kfree(priv->rx_skb);
 	kfree(priv->tx_skb);
 	dma_free_coherent(kdev, priv->rx_desc_alloc_size,
 			  priv->rx_desc_cpu, priv->rx_desc_dma);
@@ -1640,9 +1641,12 @@ static int bcm_enet_change_mtu(struct net_device *dev, int new_mtu)
 	 * align rx buffer size to dma burst len, account FCS since
 	 * it's appended
 	 */
-	priv->rx_skb_size = ALIGN(actual_mtu + ETH_FCS_LEN,
+	priv->rx_buf_size = ALIGN(actual_mtu + ETH_FCS_LEN,
 				  priv->dma_maxburst * 4);
 
+	priv->rx_frag_size = SKB_DATA_ALIGN(priv->rx_buf_offset + priv->rx_buf_size)
+						+ SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
 	dev->mtu = new_mtu;
 	return 0;
 }
@@ -1727,6 +1731,7 @@ static int bcm_enet_probe(struct platform_device *pdev)
 
 	priv->enet_is_sw = false;
 	priv->dma_maxburst = BCMENET_DMA_MAXBURST;
+	priv->rx_buf_offset = NET_SKB_PAD;
 
 	ret = bcm_enet_change_mtu(dev, dev->mtu);
 	if (ret)
@@ -2154,10 +2159,10 @@ static int bcm_enetsw_open(struct net_device *dev)
 	priv->tx_curr_desc = 0;
 	spin_lock_init(&priv->tx_lock);
 
-	/* init & fill rx ring with skbs */
-	priv->rx_skb = kcalloc(priv->rx_ring_size, sizeof(struct sk_buff *),
+	/* init & fill rx ring with buffers */
+	priv->rx_buf = kcalloc(priv->rx_ring_size, sizeof(void *),
 			       GFP_KERNEL);
-	if (!priv->rx_skb) {
+	if (!priv->rx_buf) {
 		dev_err(kdev, "cannot allocate rx skb queue\n");
 		ret = -ENOMEM;
 		goto out_free_tx_skb;
@@ -2205,7 +2210,7 @@ static int bcm_enetsw_open(struct net_device *dev)
 	enet_dma_writel(priv, ENETDMA_BUFALLOC_FORCE_MASK | 0,
 			ENETDMA_BUFALLOC_REG(priv->rx_chan));
 
-	if (bcm_enet_refill_rx(dev)) {
+	if (bcm_enet_refill_rx(dev, false)) {
 		dev_err(kdev, "cannot allocate rx skb queue\n");
 		ret = -ENOMEM;
 		goto out;
@@ -2305,18 +2310,7 @@ static int bcm_enetsw_open(struct net_device *dev)
 	return 0;
 
 out:
-	for (i = 0; i < priv->rx_ring_size; i++) {
-		struct bcm_enet_desc *desc;
-
-		if (!priv->rx_skb[i])
-			continue;
-
-		desc = &priv->rx_desc_cpu[i];
-		dma_unmap_single(kdev, desc->address, priv->rx_skb_size,
-				 DMA_FROM_DEVICE);
-		kfree_skb(priv->rx_skb[i]);
-	}
-	kfree(priv->rx_skb);
+	bcm_enet_free_rx_buf_ring(kdev, priv);
 
 out_free_tx_skb:
 	kfree(priv->tx_skb);
@@ -2345,7 +2339,6 @@ static int bcm_enetsw_stop(struct net_device *dev)
 {
 	struct bcm_enet_priv *priv;
 	struct device *kdev;
-	int i;
 
 	priv = netdev_priv(dev);
 	kdev = &priv->pdev->dev;
@@ -2367,21 +2360,10 @@ static int bcm_enetsw_stop(struct net_device *dev)
 	/* force reclaim of all tx buffers */
 	bcm_enet_tx_reclaim(dev, 1);
 
-	/* free the rx skb ring */
-	for (i = 0; i < priv->rx_ring_size; i++) {
-		struct bcm_enet_desc *desc;
-
-		if (!priv->rx_skb[i])
-			continue;
-
-		desc = &priv->rx_desc_cpu[i];
-		dma_unmap_single(kdev, desc->address, priv->rx_skb_size,
-				 DMA_FROM_DEVICE);
-		kfree_skb(priv->rx_skb[i]);
-	}
+	/* free the rx buffer ring */
+	bcm_enet_free_rx_buf_ring(kdev, priv);
 
 	/* free remaining allocated memory */
-	kfree(priv->rx_skb);
 	kfree(priv->tx_skb);
 	dma_free_coherent(kdev, priv->rx_desc_alloc_size,
 			  priv->rx_desc_cpu, priv->rx_desc_dma);
@@ -2678,6 +2660,7 @@ static int bcm_enetsw_probe(struct platform_device *pdev)
 	priv->rx_ring_size = BCMENET_DEF_RX_DESC;
 	priv->tx_ring_size = BCMENET_DEF_TX_DESC;
 	priv->dma_maxburst = BCMENETSW_DMA_MAXBURST;
+	priv->rx_buf_offset = NET_SKB_PAD + NET_IP_ALIGN;
 
 	pd = dev_get_platdata(&pdev->dev);
 	if (pd) {
diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.h b/drivers/net/ethernet/broadcom/bcm63xx_enet.h
index 1d3c917eb830..78f1830fb3cb 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.h
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.h
@@ -230,11 +230,17 @@ struct bcm_enet_priv {
 	/* next dirty rx descriptor to refill */
 	int rx_dirty_desc;
 
-	/* size of allocated rx skbs */
-	unsigned int rx_skb_size;
+	/* size of allocated rx buffers */
+	unsigned int rx_buf_size;
 
-	/* list of skb given to hw for rx */
-	struct sk_buff **rx_skb;
+	/* allocated rx buffer offset */
+	unsigned int rx_buf_offset;
+
+	/* size of allocated rx frag */
+	unsigned int rx_frag_size;
+
+	/* list of buffer given to hw for rx */
+	void **rx_buf;
 
 	/* used when rx skb allocation failed, so we defer rx queue
 	 * refill */
-- 
2.17.1

