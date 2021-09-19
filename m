Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A15C410CDC
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 20:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhISS0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 14:26:03 -0400
Received: from mx3.wp.pl ([212.77.101.10]:18105 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhISS0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 14:26:01 -0400
Received: (wp-smtpd smtp.wp.pl 23801 invoked from network); 19 Sep 2021 20:24:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1632075874; bh=CQZ3Xz5ypEo5tNFJ1b6YMO9RonHFHaA+9AocsR6YEaY=;
          h=From:To:Cc:Subject;
          b=NDeXFEAhJ3O7/ABPPAp20QTN+Zvgu2STTLA0Ibut0X9UmNaNcpKgqdrhRhspI/exP
           OI8IZj4VMI3vjbQs6L0Rqp6pmAT7kGZE+w0aomk8S+PSdKkr35Jpw0DsejgcsN7mS6
           fmhdRuds+1uctckHJEg98D3TpLrAfPulW0QJmqyo=
Received: from ip-5-172-255-97.free.aero2.net.pl (HELO LAPTOP-OLEK.Free) (olek2@wp.pl@[5.172.255.97])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 19 Sep 2021 20:24:34 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [net-next] net: lantiq: add support for jumbo frames
Date:   Sun, 19 Sep 2021 20:24:28 +0200
Message-Id: <20210919182428.1075113-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: 17f12541ef02e16049d4fff3f964dc8f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [EcNk]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for jumbo frames. Full support for jumbo frames requires
changes in the DSA switch driver (lantiq_gswip.c).

Tested on BT Hone Hub 5A.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 64 +++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index fb78f17d734f..fd355e238ab6 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -14,13 +14,15 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 
+#include <linux/if_vlan.h>
+
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
 
 #include <xway_dma.h>
 
 /* DMA */
-#define XRX200_DMA_DATA_LEN	0x600
+#define XRX200_DMA_DATA_LEN	(SZ_64K - 1)
 #define XRX200_DMA_RX		0
 #define XRX200_DMA_TX		1
 
@@ -106,7 +108,8 @@ static void xrx200_flush_dma(struct xrx200_chan *ch)
 			break;
 
 		desc->ctl = LTQ_DMA_OWN | LTQ_DMA_RX_OFFSET(NET_IP_ALIGN) |
-			    XRX200_DMA_DATA_LEN;
+			    (ch->priv->net_dev->mtu + VLAN_ETH_HLEN +
+			     ETH_FCS_LEN);
 		ch->dma.desc++;
 		ch->dma.desc %= LTQ_DESC_NUM;
 	}
@@ -154,19 +157,20 @@ static int xrx200_close(struct net_device *net_dev)
 
 static int xrx200_alloc_skb(struct xrx200_chan *ch)
 {
+	int len = ch->priv->net_dev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
 	struct sk_buff *skb = ch->skb[ch->dma.desc];
 	dma_addr_t mapping;
 	int ret = 0;
 
 	ch->skb[ch->dma.desc] = netdev_alloc_skb_ip_align(ch->priv->net_dev,
-							  XRX200_DMA_DATA_LEN);
+							  len);
 	if (!ch->skb[ch->dma.desc]) {
 		ret = -ENOMEM;
 		goto skip;
 	}
 
 	mapping = dma_map_single(ch->priv->dev, ch->skb[ch->dma.desc]->data,
-				 XRX200_DMA_DATA_LEN, DMA_FROM_DEVICE);
+				 len, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(ch->priv->dev, mapping))) {
 		dev_kfree_skb_any(ch->skb[ch->dma.desc]);
 		ch->skb[ch->dma.desc] = skb;
@@ -179,8 +183,7 @@ static int xrx200_alloc_skb(struct xrx200_chan *ch)
 	wmb();
 skip:
 	ch->dma.desc_base[ch->dma.desc].ctl =
-		LTQ_DMA_OWN | LTQ_DMA_RX_OFFSET(NET_IP_ALIGN) |
-		XRX200_DMA_DATA_LEN;
+		LTQ_DMA_OWN | LTQ_DMA_RX_OFFSET(NET_IP_ALIGN) | len;
 
 	return ret;
 }
@@ -340,10 +343,57 @@ static netdev_tx_t xrx200_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static int
+xrx200_change_mtu(struct net_device *net_dev, int new_mtu)
+{
+	struct xrx200_priv *priv = netdev_priv(net_dev);
+	struct xrx200_chan *ch_rx = &priv->chan_rx;
+	int old_mtu = net_dev->mtu;
+	bool running = false;
+	struct sk_buff *skb;
+	int curr_desc;
+	int ret = 0;
+
+	net_dev->mtu = new_mtu;
+
+	if (new_mtu <= old_mtu)
+		return ret;
+
+	running = netif_running(net_dev);
+	if (running) {
+		napi_disable(&ch_rx->napi);
+		ltq_dma_close(&ch_rx->dma);
+	}
+
+	xrx200_poll_rx(&ch_rx->napi, LTQ_DESC_NUM);
+	curr_desc = ch_rx->dma.desc;
+
+	for (ch_rx->dma.desc = 0; ch_rx->dma.desc < LTQ_DESC_NUM;
+	     ch_rx->dma.desc++) {
+		skb = ch_rx->skb[ch_rx->dma.desc];
+		ret = xrx200_alloc_skb(ch_rx);
+		if (ret) {
+			net_dev->mtu = old_mtu;
+			break;
+		}
+		dev_kfree_skb_any(skb);
+	}
+
+	ch_rx->dma.desc = curr_desc;
+	if (running) {
+		napi_enable(&ch_rx->napi);
+		ltq_dma_open(&ch_rx->dma);
+		ltq_dma_enable_irq(&ch_rx->dma);
+	}
+
+	return ret;
+}
+
 static const struct net_device_ops xrx200_netdev_ops = {
 	.ndo_open		= xrx200_open,
 	.ndo_stop		= xrx200_close,
 	.ndo_start_xmit		= xrx200_start_xmit,
+	.ndo_change_mtu		= xrx200_change_mtu,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
@@ -453,7 +503,7 @@ static int xrx200_probe(struct platform_device *pdev)
 	net_dev->netdev_ops = &xrx200_netdev_ops;
 	SET_NETDEV_DEV(net_dev, dev);
 	net_dev->min_mtu = ETH_ZLEN;
-	net_dev->max_mtu = XRX200_DMA_DATA_LEN;
+	net_dev->max_mtu = XRX200_DMA_DATA_LEN - VLAN_ETH_HLEN - ETH_FCS_LEN;
 
 	/* load the memory ranges */
 	priv->pmac_reg = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
-- 
2.30.2

