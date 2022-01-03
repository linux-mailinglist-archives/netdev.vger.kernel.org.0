Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B5B4837AC
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 20:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiACTnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 14:43:51 -0500
Received: from mx4.wp.pl ([212.77.101.11]:26654 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234493AbiACTnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 14:43:49 -0500
Received: (wp-smtpd smtp.wp.pl 12431 invoked from network); 3 Jan 2022 20:43:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1641239025; bh=NrtM609dj8n7GAZI7PYYNt+ewejExNxvIXFJGOX3cI0=;
          h=From:To:Cc:Subject;
          b=N4bOmxMBdzd8YZm0FIwxjTeW4Fqs/r15S8Lba6gm/YK9MS7QPqWIKU3BqIy6FOGgx
           cjw8UgNt1DYGyZ1dItXsIHqj6NVXwpegr2bvvl5FLHtqYBWRfOZ/5twFO+GrWBh1fm
           an1F/jdkstkcyLLA+otKmQx8dRmcZaQ47g8cCdYU=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 3 Jan 2022 20:43:45 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH net-next] net: lantiq_xrx200: add ingress SG DMA support
Date:   Mon,  3 Jan 2022 20:43:16 +0100
Message-Id: <20220103194316.1116630-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: d4b18146371331a0c4c4bfbc86a12314
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [MdOU]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for scatter gather DMA. DMA in PMAC splits
the packet into several buffers when the MTU on the CPU port is
less than the MTU of the switch. The first buffer starts at an
offset of NET_IP_ALIGN. In subsequent buffers, dma ignores the
offset. Thanks to this patch, the user can still connect to the
device in such a situation. For normal configurations, the patch
has no effect on performance.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 47 +++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 80bfaf2fec92..503fb99c5b90 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -27,6 +27,9 @@
 #define XRX200_DMA_TX		1
 #define XRX200_DMA_BURST_LEN	8
 
+#define XRX200_DMA_PACKET_COMPLETE	0
+#define XRX200_DMA_PACKET_IN_PROGRESS	1
+
 /* cpu port mac */
 #define PMAC_RX_IPG		0x0024
 #define PMAC_RX_IPG_MASK	0xf
@@ -62,6 +65,9 @@ struct xrx200_chan {
 	struct ltq_dma_channel dma;
 	struct sk_buff *skb[LTQ_DESC_NUM];
 
+	struct sk_buff *skb_head;
+	struct sk_buff *skb_tail;
+
 	struct xrx200_priv *priv;
 };
 
@@ -205,7 +211,8 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 	struct xrx200_priv *priv = ch->priv;
 	struct ltq_dma_desc *desc = &ch->dma.desc_base[ch->dma.desc];
 	struct sk_buff *skb = ch->skb[ch->dma.desc];
-	int len = (desc->ctl & LTQ_DMA_SIZE_MASK);
+	u32 ctl = desc->ctl;
+	int len = (ctl & LTQ_DMA_SIZE_MASK);
 	struct net_device *net_dev = priv->net_dev;
 	int ret;
 
@@ -221,12 +228,36 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 	}
 
 	skb_put(skb, len);
-	skb->protocol = eth_type_trans(skb, net_dev);
-	netif_receive_skb(skb);
-	net_dev->stats.rx_packets++;
-	net_dev->stats.rx_bytes += len;
 
-	return 0;
+	/* add buffers to skb via skb->frag_list */
+	if (ctl & LTQ_DMA_SOP) {
+		ch->skb_head = skb;
+		ch->skb_tail = skb;
+	} else if (ch->skb_head) {
+		if (ch->skb_head == ch->skb_tail)
+			skb_shinfo(ch->skb_tail)->frag_list = skb;
+		else
+			ch->skb_tail->next = skb;
+		ch->skb_tail = skb;
+		skb_reserve(ch->skb_tail, -NET_IP_ALIGN);
+		ch->skb_head->len += skb->len;
+		ch->skb_head->data_len += skb->len;
+		ch->skb_head->truesize += skb->truesize;
+	}
+
+	if (ctl & LTQ_DMA_EOP) {
+		ch->skb_head->protocol = eth_type_trans(ch->skb_head, net_dev);
+		netif_receive_skb(ch->skb_head);
+		net_dev->stats.rx_packets++;
+		net_dev->stats.rx_bytes += ch->skb_head->len;
+		ch->skb_head = NULL;
+		ch->skb_tail = NULL;
+		ret = XRX200_DMA_PACKET_COMPLETE;
+	} else {
+		ret = XRX200_DMA_PACKET_IN_PROGRESS;
+	}
+
+	return ret;
 }
 
 static int xrx200_poll_rx(struct napi_struct *napi, int budget)
@@ -241,7 +272,9 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
 
 		if ((desc->ctl & (LTQ_DMA_OWN | LTQ_DMA_C)) == LTQ_DMA_C) {
 			ret = xrx200_hw_receive(ch);
-			if (ret)
+			if (ret == XRX200_DMA_PACKET_IN_PROGRESS)
+				continue;
+			if (ret != XRX200_DMA_PACKET_COMPLETE)
 				return ret;
 			rx++;
 		} else {
-- 
2.30.2

