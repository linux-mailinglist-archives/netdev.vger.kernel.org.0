Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3EB468DB3
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 23:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239594AbhLEW1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 17:27:31 -0500
Received: from mx4.wp.pl ([212.77.101.11]:46202 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230153AbhLEW1b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 17:27:31 -0500
Received: (wp-smtpd smtp.wp.pl 14404 invoked from network); 5 Dec 2021 23:24:01 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1638743041; bh=hn/wVfvuI/n02J0fYi4KT6VvBCq9VK8hjDxkQWp5pMI=;
          h=From:To:Subject;
          b=MV/9Uefq2EeOEKx3C1kNg9LMMz6iGsXzetCmLDDuOSl6hnzcpR6pYiEcxe5eNuYQ3
           06EkRudqHg/jl0v/SfxV1nQI9PzdW1gOwwqTgwWI77KFoit3bmP8nAKBRMwBhm7tL3
           6OHdkp96G6/StnFeMQi2sNEUyFwIeoZy+KXfIsWY=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 5 Dec 2021 23:24:01 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        olek2@wp.pl, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: lantiq_xrx200: increase buffer reservation
Date:   Sun,  5 Dec 2021 23:23:59 +0100
Message-Id: <20211205222359.42913-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 257a14861c527810459a7a07d2600b30
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [kUMk]                               
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
index 0da09ea81980..90442d4a9e6e 100644
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
 
+static inline int xrx200_max_frame_len(int mtu)
+{
+	return VLAN_ETH_HLEN + mtu + ETH_FCS_LEN;
+}
+
+static inline int xrx200_buffer_size(int mtu)
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

