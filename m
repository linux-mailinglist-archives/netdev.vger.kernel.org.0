Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCCD2CE7CE
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 06:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgLDFtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 00:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgLDFtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 00:49:14 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD8AC061A55
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 21:48:28 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w16so2856995pga.9
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 21:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MYtDPZ0ZgubMcf7gzoslCdTpA8We1EfJtpn/Ol0OXwY=;
        b=DgNWdvkCyvwIKYZqqlxyemRoeaEB+WQcX/IPOEo6gi2MVCMGrt/4JqhDETgDNrCyHG
         qb+XKHTSQwzz1nefSNXEDad9gqQvF7Y13c8g+YJgWCkLYetFMlRDOiH5iud4CzvQdeyy
         x6XgZHaBtHd88RWAiyrjckfXxNwU61/LSeCaYuU7+W1bR+WRSnbf6+kj0kNfVpI+Hca3
         IvD+H08/ALbgxKbBekQMynQqCLadeADeWRebbuaZayJbvyZvwqGd8ybCjSHtSLjUsCXV
         bp1r+QjD/ZmmmPKsOJvSRe9+fm6UF03jke9WOTCl+xjMGF6OvoKX/dlsMoQa2/q0jGHq
         Yg/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MYtDPZ0ZgubMcf7gzoslCdTpA8We1EfJtpn/Ol0OXwY=;
        b=dxbusZnnMDrkzoUa9p7hDUl7qTAeo8qNNfDqfqHshsQpbzwo7n+1fKnZ1NEc0cH4uo
         iitXWU9CFjAng4Y8k9bDIleV71cAQZagJsDIAq17cc75ybBOQeqSJ0V3PEkqje1tgLwv
         iFtLkoOxkU/NDEIyyqNWIl5CuTDsFNu+sxh1LWRWB0PRr+Eq+1RW23TQW4wEBE6sgsS2
         A2Yx2Mfn/+pkmxz/rJTgBB1jElGy9iWEEdp2eKKoZe7Amzp8c8VQ3RsAcHvH4fd0doB7
         72NtFxVMph7Ila9pJ7H7QC1Vn8DT1TMy2xQ8YBCfrPsHvA4VX/ibt1F4XOIYmgJ/hHp0
         TdpA==
X-Gm-Message-State: AOAM532qk0tpHlF6wcbsWPOSxVbmaLgys9n+0mc5Xj8L1U7rZ8wIkEJ6
        mijN3Ags1IYfJxZFEcMl+HE=
X-Google-Smtp-Source: ABdhPJxR1z0HzG37ENCM6NvveURynHAnAR9JxXjarCT+/39J/T/kO2G3wTa6Hlu4RYnaIytm69hgdw==
X-Received: by 2002:a63:561f:: with SMTP id k31mr6070036pgb.227.1607060908194;
        Thu, 03 Dec 2020 21:48:28 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id u205sm3542134pfc.146.2020.12.03.21.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 21:48:27 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next] bcm63xx_enet: convert to build_skb
Date:   Fri,  4 Dec 2020 13:46:16 +0800
Message-Id: <20201204054616.26876-4-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201204054616.26876-1-liew.s.piaw@gmail.com>
References: <20201204054616.26876-1-liew.s.piaw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can increase the efficiency of rx path by using buffers to receive
packets then build SKBs around them just before passing into the network
stack. In contrast, preallocating SKBs too early reduces CPU cache
efficiency.

Check if we're in NAPI context when refilling RX. Normally we're almost
always running in NAPI context. Dispatch to napi_alloc_frag directly
instead of relying on netdev_alloc_frag which still runs
local_bh_disable/enable.

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
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 156 ++++++++-----------
 drivers/net/ethernet/broadcom/bcm63xx_enet.h |  14 +-
 2 files changed, 79 insertions(+), 91 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 92bff4758216..4ace540f0c92 100644
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
@@ -382,14 +381,20 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 
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
+			skb = build_skb(buf, priv->rx_frag_size);
+			if (unlikely(!skb)) {
+				skb_free_frag(buf);
+				dev->stats.rx_dropped++;
+				continue;
+			}
+			priv->rx_buf[desc_idx] = NULL;
+			skb_reserve(skb, priv->rx_buf_offset);
 		}
 
 		skb_put(skb, len);
@@ -403,7 +408,7 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 	netif_receive_skb_list(&rx_list);
 
 	if (processed || !priv->rx_desc_count) {
-		bcm_enet_refill_rx(dev);
+		bcm_enet_refill_rx(dev, true);
 
 		/* kick rx dma */
 		enet_dmac_writel(priv, priv->dma_chan_en_mask,
@@ -859,6 +864,24 @@ static void bcm_enet_adjust_link(struct net_device *dev)
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
@@ -968,10 +991,10 @@ static int bcm_enet_open(struct net_device *dev)
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
@@ -988,7 +1011,7 @@ static int bcm_enet_open(struct net_device *dev)
 		enet_dmac_writel(priv, ENETDMA_BUFALLOC_FORCE_MASK | 0,
 				ENETDMAC_BUFALLOC, priv->rx_chan);
 
-	if (bcm_enet_refill_rx(dev)) {
+	if (bcm_enet_refill_rx(dev, false)) {
 		dev_err(kdev, "cannot allocate rx skb queue\n");
 		ret = -ENOMEM;
 		goto out;
@@ -1084,18 +1107,7 @@ static int bcm_enet_open(struct net_device *dev)
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
@@ -1174,7 +1186,6 @@ static int bcm_enet_stop(struct net_device *dev)
 {
 	struct bcm_enet_priv *priv;
 	struct device *kdev;
-	int i;
 
 	priv = netdev_priv(dev);
 	kdev = &priv->pdev->dev;
@@ -1201,21 +1212,10 @@ static int bcm_enet_stop(struct net_device *dev)
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
@@ -1637,9 +1637,12 @@ static int bcm_enet_change_mtu(struct net_device *dev, int new_mtu)
 	 * align rx buffer size to dma burst len, account FCS since
 	 * it's appended
 	 */
-	priv->rx_skb_size = ALIGN(actual_mtu + ETH_FCS_LEN,
+	priv->rx_buf_size = ALIGN(actual_mtu + ETH_FCS_LEN,
 				  priv->dma_maxburst * 4);
 
+	priv->rx_frag_size = SKB_DATA_ALIGN(priv->rx_buf_size + priv->rx_buf_offset)
+						+ SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
 	dev->mtu = new_mtu;
 	return 0;
 }
@@ -1724,6 +1727,7 @@ static int bcm_enet_probe(struct platform_device *pdev)
 
 	priv->enet_is_sw = false;
 	priv->dma_maxburst = BCMENET_DMA_MAXBURST;
+	priv->rx_buf_offset = NET_SKB_PAD;
 
 	ret = bcm_enet_change_mtu(dev, dev->mtu);
 	if (ret)
@@ -2151,10 +2155,10 @@ static int bcm_enetsw_open(struct net_device *dev)
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
@@ -2202,7 +2206,7 @@ static int bcm_enetsw_open(struct net_device *dev)
 	enet_dma_writel(priv, ENETDMA_BUFALLOC_FORCE_MASK | 0,
 			ENETDMA_BUFALLOC_REG(priv->rx_chan));
 
-	if (bcm_enet_refill_rx(dev)) {
+	if (bcm_enet_refill_rx(dev, false)) {
 		dev_err(kdev, "cannot allocate rx skb queue\n");
 		ret = -ENOMEM;
 		goto out;
@@ -2303,18 +2307,7 @@ static int bcm_enetsw_open(struct net_device *dev)
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
@@ -2343,7 +2336,6 @@ static int bcm_enetsw_stop(struct net_device *dev)
 {
 	struct bcm_enet_priv *priv;
 	struct device *kdev;
-	int i;
 
 	priv = netdev_priv(dev);
 	kdev = &priv->pdev->dev;
@@ -2364,21 +2356,10 @@ static int bcm_enetsw_stop(struct net_device *dev)
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
@@ -2675,6 +2656,7 @@ static int bcm_enetsw_probe(struct platform_device *pdev)
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

