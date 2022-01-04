Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDEF484454
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbiADPMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:12:03 -0500
Received: from mx3.wp.pl ([212.77.101.10]:57808 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234739AbiADPL7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 10:11:59 -0500
Received: (wp-smtpd smtp.wp.pl 13876 invoked from network); 4 Jan 2022 16:11:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1641309117; bh=IBQPtJJgqFmTTeqTQ6iLoG6P62J8Sjm9Lee/wKFSbLA=;
          h=From:To:Subject;
          b=b7UdyOcmgNooDZhXciJXZbokNECAmQRh1TIIRjka2kS1eFQKMvszBF1LGf4U7wltj
           gORpcLVR+xztjDYbDIRcP1x5nXPSXhFGPPX6O64612DhOEXTvpRX5ikZo4kegNf+YQ
           kWsl4gbjnLojfftV4czhr7v0JuQ5R1TT4Q2dO2PA=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <tsbogend@alpha.franken.de>; 4 Jan 2022 16:11:57 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     tsbogend@alpha.franken.de, olek2@wp.pl, hauke@hauke-m.de,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] net: lantiq_xrx200: convert to build_skb
Date:   Tue,  4 Jan 2022 16:11:44 +0100
Message-Id: <20220104151144.181736-4-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220104151144.181736-1-olek2@wp.pl>
References: <20220104151144.181736-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: ca3f7f8e16a039b894b9675397e9def4
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [IRN0]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can increase the efficiency of rx path by using buffers to receive
packets then build SKBs around them just before passing into the network
stack. In contrast, preallocating SKBs too early reduces CPU cache
efficiency.

NAT Performance results on BT Home Hub 5A (kernel 5.10.89, mtu 1500):

	Down		Up
Before	577 Mbps	648 Mbps
After	624 Mbps	695 Mbps

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 56 ++++++++++++++++++----------
 1 file changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 7cebf4a601bc..41d11137cde0 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -63,7 +63,11 @@ struct xrx200_chan {
 
 	struct napi_struct napi;
 	struct ltq_dma_channel dma;
-	struct sk_buff *skb[LTQ_DESC_NUM];
+
+	union {
+		struct sk_buff *skb[LTQ_DESC_NUM];
+		void *rx_buff[LTQ_DESC_NUM];
+	};
 
 	struct sk_buff *skb_head;
 	struct sk_buff *skb_tail;
@@ -78,6 +82,7 @@ struct xrx200_priv {
 	struct xrx200_chan chan_rx;
 
 	u16 rx_buf_size;
+	u16 rx_skb_size;
 
 	struct net_device *net_dev;
 	struct device *dev;
@@ -115,6 +120,12 @@ static int xrx200_buffer_size(int mtu)
 	return round_up(xrx200_max_frame_len(mtu), 4 * XRX200_DMA_BURST_LEN);
 }
 
+static int xrx200_skb_size(u16 buf_size)
+{
+	return SKB_DATA_ALIGN(buf_size + NET_SKB_PAD + NET_IP_ALIGN) +
+		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+}
+
 /* drop all the packets from the DMA ring */
 static void xrx200_flush_dma(struct xrx200_chan *ch)
 {
@@ -173,30 +184,29 @@ static int xrx200_close(struct net_device *net_dev)
 	return 0;
 }
 
-static int xrx200_alloc_skb(struct xrx200_chan *ch)
+static int xrx200_alloc_buf(struct xrx200_chan *ch, void *(*alloc)(unsigned int size))
 {
-	struct sk_buff *skb = ch->skb[ch->dma.desc];
+	void *buf = ch->rx_buff[ch->dma.desc];
 	struct xrx200_priv *priv = ch->priv;
 	dma_addr_t mapping;
 	int ret = 0;
 
-	ch->skb[ch->dma.desc] = netdev_alloc_skb_ip_align(priv->net_dev,
-							  priv->rx_buf_size);
-	if (!ch->skb[ch->dma.desc]) {
+	ch->rx_buff[ch->dma.desc] = alloc(priv->rx_skb_size);
+	if (!ch->rx_buff[ch->dma.desc]) {
 		ret = -ENOMEM;
 		goto skip;
 	}
 
-	mapping = dma_map_single(priv->dev, ch->skb[ch->dma.desc]->data,
+	mapping = dma_map_single(priv->dev, ch->rx_buff[ch->dma.desc],
 				 priv->rx_buf_size, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(priv->dev, mapping))) {
-		dev_kfree_skb_any(ch->skb[ch->dma.desc]);
-		ch->skb[ch->dma.desc] = skb;
+		skb_free_frag(ch->rx_buff[ch->dma.desc]);
+		ch->rx_buff[ch->dma.desc] = buf;
 		ret = -ENOMEM;
 		goto skip;
 	}
 
-	ch->dma.desc_base[ch->dma.desc].addr = mapping;
+	ch->dma.desc_base[ch->dma.desc].addr = mapping + NET_SKB_PAD + NET_IP_ALIGN;
 	/* Make sure the address is written before we give it to HW */
 	wmb();
 skip:
@@ -210,13 +220,14 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 {
 	struct xrx200_priv *priv = ch->priv;
 	struct ltq_dma_desc *desc = &ch->dma.desc_base[ch->dma.desc];
-	struct sk_buff *skb = ch->skb[ch->dma.desc];
+	void *buf = ch->rx_buff[ch->dma.desc];
 	u32 ctl = desc->ctl;
 	int len = (ctl & LTQ_DMA_SIZE_MASK);
 	struct net_device *net_dev = priv->net_dev;
+	struct sk_buff *skb;
 	int ret;
 
-	ret = xrx200_alloc_skb(ch);
+	ret = xrx200_alloc_buf(ch, napi_alloc_frag);
 
 	ch->dma.desc++;
 	ch->dma.desc %= LTQ_DESC_NUM;
@@ -227,19 +238,21 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 		return ret;
 	}
 
+	skb = build_skb(buf, priv->rx_skb_size);
+	skb_reserve(skb, NET_SKB_PAD);
 	skb_put(skb, len);
 
 	/* add buffers to skb via skb->frag_list */
 	if (ctl & LTQ_DMA_SOP) {
 		ch->skb_head = skb;
 		ch->skb_tail = skb;
+		skb_reserve(skb, NET_IP_ALIGN);
 	} else if (ch->skb_head) {
 		if (ch->skb_head == ch->skb_tail)
 			skb_shinfo(ch->skb_tail)->frag_list = skb;
 		else
 			ch->skb_tail->next = skb;
 		ch->skb_tail = skb;
-		skb_reserve(ch->skb_tail, -NET_IP_ALIGN);
 		ch->skb_head->len += skb->len;
 		ch->skb_head->data_len += skb->len;
 		ch->skb_head->truesize += skb->truesize;
@@ -395,12 +408,13 @@ xrx200_change_mtu(struct net_device *net_dev, int new_mtu)
 	struct xrx200_chan *ch_rx = &priv->chan_rx;
 	int old_mtu = net_dev->mtu;
 	bool running = false;
-	struct sk_buff *skb;
+	void *buff;
 	int curr_desc;
 	int ret = 0;
 
 	net_dev->mtu = new_mtu;
 	priv->rx_buf_size = xrx200_buffer_size(new_mtu);
+	priv->rx_skb_size = xrx200_skb_size(priv->rx_buf_size);
 
 	if (new_mtu <= old_mtu)
 		return ret;
@@ -416,14 +430,15 @@ xrx200_change_mtu(struct net_device *net_dev, int new_mtu)
 
 	for (ch_rx->dma.desc = 0; ch_rx->dma.desc < LTQ_DESC_NUM;
 	     ch_rx->dma.desc++) {
-		skb = ch_rx->skb[ch_rx->dma.desc];
-		ret = xrx200_alloc_skb(ch_rx);
+		buff = ch_rx->rx_buff[ch_rx->dma.desc];
+		ret = xrx200_alloc_buf(ch_rx, netdev_alloc_frag);
 		if (ret) {
 			net_dev->mtu = old_mtu;
 			priv->rx_buf_size = xrx200_buffer_size(old_mtu);
+			priv->rx_skb_size = xrx200_skb_size(priv->rx_buf_size);
 			break;
 		}
-		dev_kfree_skb_any(skb);
+		skb_free_frag(buff);
 	}
 
 	ch_rx->dma.desc = curr_desc;
@@ -476,7 +491,7 @@ static int xrx200_dma_init(struct xrx200_priv *priv)
 	ltq_dma_alloc_rx(&ch_rx->dma);
 	for (ch_rx->dma.desc = 0; ch_rx->dma.desc < LTQ_DESC_NUM;
 	     ch_rx->dma.desc++) {
-		ret = xrx200_alloc_skb(ch_rx);
+		ret = xrx200_alloc_buf(ch_rx, netdev_alloc_frag);
 		if (ret)
 			goto rx_free;
 	}
@@ -511,7 +526,7 @@ static int xrx200_dma_init(struct xrx200_priv *priv)
 	/* free the allocated RX ring */
 	for (i = 0; i < LTQ_DESC_NUM; i++) {
 		if (priv->chan_rx.skb[i])
-			dev_kfree_skb_any(priv->chan_rx.skb[i]);
+			skb_free_frag(priv->chan_rx.rx_buff[i]);
 	}
 
 rx_free:
@@ -528,7 +543,7 @@ static void xrx200_hw_cleanup(struct xrx200_priv *priv)
 
 	/* free the allocated RX ring */
 	for (i = 0; i < LTQ_DESC_NUM; i++)
-		dev_kfree_skb_any(priv->chan_rx.skb[i]);
+		skb_free_frag(priv->chan_rx.rx_buff[i]);
 }
 
 static int xrx200_probe(struct platform_device *pdev)
@@ -553,6 +568,7 @@ static int xrx200_probe(struct platform_device *pdev)
 	net_dev->min_mtu = ETH_ZLEN;
 	net_dev->max_mtu = XRX200_DMA_DATA_LEN - xrx200_max_frame_len(0);
 	priv->rx_buf_size = xrx200_buffer_size(ETH_DATA_LEN);
+	priv->rx_skb_size = xrx200_skb_size(priv->rx_buf_size);
 
 	/* load the memory ranges */
 	priv->pmac_reg = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
-- 
2.30.2

