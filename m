Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232982EBFC0
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbhAFOoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbhAFOoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 09:44:07 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A855C06135C;
        Wed,  6 Jan 2021 06:43:25 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x126so1823880pfc.7;
        Wed, 06 Jan 2021 06:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XftEdDCTyWGddNDIbdQhc19SIuraUjREfl71qMF7tjk=;
        b=L/TbdpbLXo2XcNE+MK8cUiQi2xRaIy8RYbnbBwDSmv5m/3CakH4SR80jIBeyrUv+Fc
         zHr5lEQ2U+Nzd2WmqSyo1Cskbv5jZTRQbkhOZbJ/c1MF64DJcIrGZMWVQ7oAV2SObgmD
         beQVLz5HHpGK1qB7HrKNFluiH7Sq7bzu0fTlM81Df/w2xAJSMXwIJpCsBgN9SrbgRuG9
         5LcqvC5xf3mbDmoh154SP1fdMZs12fVMLYdTs2Dn+fMjGZwYJ4bjvku+uvzgLw2Oa9zE
         FND4DNhneCQU8P1pE4njXMyFjzHidngl6ctUOeodBpHNt3BuKADnyfUwX3+jdfcaIWBh
         Vp8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XftEdDCTyWGddNDIbdQhc19SIuraUjREfl71qMF7tjk=;
        b=G23YhwrDvOC0R1vicI1oQYXGhDI54hwsdqkNEG9aPaZeVIYGSVMMmJTx912zIFWEXX
         CQF+B/7z4FoFYRmXGnnwdtRaBHciycxrW8CymHeU6q6EhNLuzTFqBIHD0jiLu6kX9gt8
         zy6z9G7uWcHGY7mpjqVJASiZMB3KC251EbnCyfJzDZIf4sa5l4mONxyzzn5tdiJ6wz7D
         WEh6zJu+vFeCIpNWmxzosownFE99XYnAfHcOsR/2Usu9cabe+TEJoazGbOkXTe7A06zt
         NB1hsjdBXgxq5jz3lB7frOup8z2ILUqrEfDfh7/njgPMbQzrR+UHaHiY7njgzEgByCJ2
         eFdQ==
X-Gm-Message-State: AOAM530SugYgIpK19pdQEz3OO5VzyyJvzbDYR8vAVeSgD+mNQGAmd9IP
        87P2ECHxqwOmKnCDWM6JV3t2xoFRKTE=
X-Google-Smtp-Source: ABdhPJyoyM3gNVTNy+Exywyho72xpwIy/5cwhBNnzWibG1ZCfUhQ/RpDbUkbzRUl+pn89MEP0dMPsw==
X-Received: by 2002:a62:7a91:0:b029:19e:55db:9ddc with SMTP id v139-20020a627a910000b029019e55db9ddcmr4418635pfc.68.1609944204566;
        Wed, 06 Jan 2021 06:43:24 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id h8sm3076774pjc.2.2021.01.06.06.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 06:43:24 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 6/7] bcm63xx_enet: convert to build_skb
Date:   Wed,  6 Jan 2021 22:42:07 +0800
Message-Id: <20210106144208.1935-7-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210106144208.1935-1-liew.s.piaw@gmail.com>
References: <20210106144208.1935-1-liew.s.piaw@gmail.com>
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
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 111 ++++++++++---------
 drivers/net/ethernet/broadcom/bcm63xx_enet.h |  14 ++-
 2 files changed, 71 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index e34b05b10e43..c11491429ed2 100644
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
@@ -860,22 +866,22 @@ static void bcm_enet_adjust_link(struct net_device *dev)
 		priv->pause_tx ? "tx" : "off");
 }
 
-static void bcm_enet_free_rx_skb_ring(struct device *kdev, struct bcm_enet_priv *priv)
+static void bcm_enet_free_rx_buf_ring(struct device *kdev, struct bcm_enet_priv *priv)
 {
 	int i;
 
 	for (i = 0; i < priv->rx_ring_size; i++) {
 		struct bcm_enet_desc *desc;
 
-		if (!priv->rx_skb[i])
+		if (!priv->rx_buf[i])
 			continue;
 
 		desc = &priv->rx_desc_cpu[i];
-		dma_unmap_single(kdev, desc->address, priv->rx_skb_size,
+		dma_unmap_single(kdev, desc->address, priv->rx_buf_size,
 				 DMA_FROM_DEVICE);
-		kfree_skb(priv->rx_skb[i]);
+		skb_free_frag(priv->rx_buf[i]);
 	}
-	kfree(priv->rx_skb);
+	kfree(priv->rx_buf);
 }
 
 /*
@@ -987,10 +993,10 @@ static int bcm_enet_open(struct net_device *dev)
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
@@ -1007,8 +1013,8 @@ static int bcm_enet_open(struct net_device *dev)
 		enet_dmac_writel(priv, ENETDMA_BUFALLOC_FORCE_MASK | 0,
 				ENETDMAC_BUFALLOC, priv->rx_chan);
 
-	if (bcm_enet_refill_rx(dev)) {
-		dev_err(kdev, "cannot allocate rx skb queue\n");
+	if (bcm_enet_refill_rx(dev, false)) {
+		dev_err(kdev, "cannot allocate rx buffer queue\n");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1102,7 +1108,7 @@ static int bcm_enet_open(struct net_device *dev)
 	return 0;
 
 out:
-	bcm_enet_free_rx_skb_ring(kdev, priv);
+	bcm_enet_free_rx_buf_ring(kdev, priv);
 
 out_free_tx_skb:
 	kfree(priv->tx_skb);
@@ -1208,8 +1214,8 @@ static int bcm_enet_stop(struct net_device *dev)
 	/* force reclaim of all tx buffers */
 	bcm_enet_tx_reclaim(dev, 1);
 
-	/* free the rx skb ring */
-	bcm_enet_free_rx_skb_ring(kdev, priv);
+	/* free the rx buffer ring */
+	bcm_enet_free_rx_buf_ring(kdev, priv);
 
 	/* free remaining allocated memory */
 	kfree(priv->tx_skb);
@@ -1633,9 +1639,12 @@ static int bcm_enet_change_mtu(struct net_device *dev, int new_mtu)
 	 * align rx buffer size to dma burst len, account FCS since
 	 * it's appended
 	 */
-	priv->rx_skb_size = ALIGN(actual_mtu + ETH_FCS_LEN,
+	priv->rx_buf_size = ALIGN(actual_mtu + ETH_FCS_LEN,
 				  priv->dma_maxburst * 4);
 
+	priv->rx_frag_size = SKB_DATA_ALIGN(priv->rx_buf_offset + priv->rx_buf_size) +
+					    SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
 	dev->mtu = new_mtu;
 	return 0;
 }
@@ -1720,6 +1729,7 @@ static int bcm_enet_probe(struct platform_device *pdev)
 
 	priv->enet_is_sw = false;
 	priv->dma_maxburst = BCMENET_DMA_MAXBURST;
+	priv->rx_buf_offset = NET_SKB_PAD;
 
 	ret = bcm_enet_change_mtu(dev, dev->mtu);
 	if (ret)
@@ -2137,7 +2147,7 @@ static int bcm_enetsw_open(struct net_device *dev)
 	priv->tx_skb = kcalloc(priv->tx_ring_size, sizeof(struct sk_buff *),
 			       GFP_KERNEL);
 	if (!priv->tx_skb) {
-		dev_err(kdev, "cannot allocate rx skb queue\n");
+		dev_err(kdev, "cannot allocate tx skb queue\n");
 		ret = -ENOMEM;
 		goto out_free_tx_ring;
 	}
@@ -2147,11 +2157,11 @@ static int bcm_enetsw_open(struct net_device *dev)
 	priv->tx_curr_desc = 0;
 	spin_lock_init(&priv->tx_lock);
 
-	/* init & fill rx ring with skbs */
-	priv->rx_skb = kcalloc(priv->rx_ring_size, sizeof(struct sk_buff *),
+	/* init & fill rx ring with buffers */
+	priv->rx_buf = kcalloc(priv->rx_ring_size, sizeof(void *),
 			       GFP_KERNEL);
-	if (!priv->rx_skb) {
-		dev_err(kdev, "cannot allocate rx skb queue\n");
+	if (!priv->rx_buf) {
+		dev_err(kdev, "cannot allocate rx buffer queue\n");
 		ret = -ENOMEM;
 		goto out_free_tx_skb;
 	}
@@ -2198,8 +2208,8 @@ static int bcm_enetsw_open(struct net_device *dev)
 	enet_dma_writel(priv, ENETDMA_BUFALLOC_FORCE_MASK | 0,
 			ENETDMA_BUFALLOC_REG(priv->rx_chan));
 
-	if (bcm_enet_refill_rx(dev)) {
-		dev_err(kdev, "cannot allocate rx skb queue\n");
+	if (bcm_enet_refill_rx(dev, false)) {
+		dev_err(kdev, "cannot allocate rx buffer queue\n");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -2298,7 +2308,7 @@ static int bcm_enetsw_open(struct net_device *dev)
 	return 0;
 
 out:
-	bcm_enet_free_rx_skb_ring(kdev, priv);
+	bcm_enet_free_rx_buf_ring(kdev, priv);
 
 out_free_tx_skb:
 	kfree(priv->tx_skb);
@@ -2348,8 +2358,8 @@ static int bcm_enetsw_stop(struct net_device *dev)
 	/* force reclaim of all tx buffers */
 	bcm_enet_tx_reclaim(dev, 1);
 
-	/* free the rx skb ring */
-	bcm_enet_free_rx_skb_ring(kdev, priv);
+	/* free the rx buffer ring */
+	bcm_enet_free_rx_buf_ring(kdev, priv);
 
 	/* free remaining allocated memory */
 	kfree(priv->tx_skb);
@@ -2648,6 +2658,7 @@ static int bcm_enetsw_probe(struct platform_device *pdev)
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

