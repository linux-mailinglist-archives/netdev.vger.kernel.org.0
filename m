Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E1F46AC8F
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 23:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358512AbhLFWnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 17:43:14 -0500
Received: from mx3.wp.pl ([212.77.101.10]:49399 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358159AbhLFWmp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 17:42:45 -0500
Received: (wp-smtpd smtp.wp.pl 5899 invoked from network); 6 Dec 2021 23:39:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1638830353; bh=mU+1mb3rzb5nAuwm/PGXGncmn4G4PnOQh60E92j8DDs=;
          h=From:To:Subject;
          b=XfZbebjXcfcKaSzVE3SLMUtGHBZaHUpqrB4BnE96fZACGBY/7VV4qYWL70B+A/6LR
           28jZKusVtYXxbRkx8h4QN9c5G/4zxyR/t7BHT5tL9Vmbf7GG4oItYmRkqOxO2OH4WH
           arKU0xkEXnjoMIn+wC3j3vB3wSuDsuNoQ0BK3FPk=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 6 Dec 2021 23:39:13 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        olek2@wp.pl, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: lantiq_xrx200: increase buffer reservation
Date:   Mon,  6 Dec 2021 23:39:09 +0100
Message-Id: <20211206223909.749043-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 17398f0e9898bb00f8c513e1fe3b6b9d
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [geM0]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the user sets a smaller mtu on the CPU port than on the switch,
then DMA inserts a few more bytes than expected. In the worst case,
it may exceed the size of the buffer. The experiments showed that
the buffer should be a multiple of the burst length value. This patch
rounds the length of the rx buffer upwards and fixes this bug.

Fixes: 998ac358019e ("net: lantiq: add support for jumbo frames")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 38 ++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 0da09ea81980..d3423764da75 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -71,6 +71,9 @@ struct xrx200_priv {
 	struct xrx200_chan chan_tx;
 	struct xrx200_chan chan_rx;
 
+	u16 max_frame_len;
+	u16 rx_buf_size;
+
 	struct net_device *net_dev;
 	struct device *dev;
 
@@ -97,6 +100,16 @@ static void xrx200_pmac_mask(struct xrx200_priv *priv, u32 clear, u32 set,
 	xrx200_pmac_w32(priv, val, offset);
 }
 
+static int xrx200_max_frame_len(int mtu)
+{
+	return VLAN_ETH_HLEN + mtu + ETH_FCS_LEN;
+}
+
+static int xrx200_buffer_size(int mtu)
+{
+	return round_up(xrx200_max_frame_len(mtu) - 1, 4 * XRX200_DMA_BURST_LEN);
+}
+
 /* drop all the packets from the DMA ring */
 static void xrx200_flush_dma(struct xrx200_chan *ch)
 {
@@ -109,8 +122,7 @@ static void xrx200_flush_dma(struct xrx200_chan *ch)
 			break;
 
 		desc->ctl = LTQ_DMA_OWN | LTQ_DMA_RX_OFFSET(NET_IP_ALIGN) |
-			    (ch->priv->net_dev->mtu + VLAN_ETH_HLEN +
-			     ETH_FCS_LEN);
+			    ch->priv->max_frame_len;
 		ch->dma.desc++;
 		ch->dma.desc %= LTQ_DESC_NUM;
 	}
@@ -158,21 +170,21 @@ static int xrx200_close(struct net_device *net_dev)
 
 static int xrx200_alloc_skb(struct xrx200_chan *ch)
 {
-	int len = ch->priv->net_dev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
 	struct sk_buff *skb = ch->skb[ch->dma.desc];
+	struct xrx200_priv *priv = ch->priv;
 	dma_addr_t mapping;
 	int ret = 0;
 
-	ch->skb[ch->dma.desc] = netdev_alloc_skb_ip_align(ch->priv->net_dev,
-							  len);
+	ch->skb[ch->dma.desc] = netdev_alloc_skb_ip_align(priv->net_dev,
+							  priv->rx_buf_size);
 	if (!ch->skb[ch->dma.desc]) {
 		ret = -ENOMEM;
 		goto skip;
 	}
 
-	mapping = dma_map_single(ch->priv->dev, ch->skb[ch->dma.desc]->data,
-				 len, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(ch->priv->dev, mapping))) {
+	mapping = dma_map_single(priv->dev, ch->skb[ch->dma.desc]->data,
+				 priv->rx_buf_size, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(priv->dev, mapping))) {
 		dev_kfree_skb_any(ch->skb[ch->dma.desc]);
 		ch->skb[ch->dma.desc] = skb;
 		ret = -ENOMEM;
@@ -184,7 +196,7 @@ static int xrx200_alloc_skb(struct xrx200_chan *ch)
 	wmb();
 skip:
 	ch->dma.desc_base[ch->dma.desc].ctl =
-		LTQ_DMA_OWN | LTQ_DMA_RX_OFFSET(NET_IP_ALIGN) | len;
+		LTQ_DMA_OWN | LTQ_DMA_RX_OFFSET(NET_IP_ALIGN) | priv->max_frame_len;
 
 	return ret;
 }
@@ -356,6 +368,8 @@ xrx200_change_mtu(struct net_device *net_dev, int new_mtu)
 	int ret = 0;
 
 	net_dev->mtu = new_mtu;
+	priv->rx_buf_size = xrx200_buffer_size(new_mtu);
+	priv->max_frame_len = xrx200_max_frame_len(new_mtu);
 
 	if (new_mtu <= old_mtu)
 		return ret;
@@ -375,6 +389,8 @@ xrx200_change_mtu(struct net_device *net_dev, int new_mtu)
 		ret = xrx200_alloc_skb(ch_rx);
 		if (ret) {
 			net_dev->mtu = old_mtu;
+			priv->rx_buf_size = xrx200_buffer_size(old_mtu);
+			priv->max_frame_len = xrx200_max_frame_len(old_mtu);
 			break;
 		}
 		dev_kfree_skb_any(skb);
@@ -505,7 +521,9 @@ static int xrx200_probe(struct platform_device *pdev)
 	net_dev->netdev_ops = &xrx200_netdev_ops;
 	SET_NETDEV_DEV(net_dev, dev);
 	net_dev->min_mtu = ETH_ZLEN;
-	net_dev->max_mtu = XRX200_DMA_DATA_LEN - VLAN_ETH_HLEN - ETH_FCS_LEN;
+	net_dev->max_mtu = XRX200_DMA_DATA_LEN - xrx200_max_frame_len(0);
+	priv->rx_buf_size = xrx200_buffer_size(ETH_DATA_LEN);
+	priv->max_frame_len = xrx200_max_frame_len(ETH_DATA_LEN);
 
 	/* load the memory ranges */
 	priv->pmac_reg = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
-- 
2.30.2

