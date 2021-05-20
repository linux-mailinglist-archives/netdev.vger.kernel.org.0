Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1270238B64E
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 20:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbhETStV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 14:49:21 -0400
Received: from mx4.wp.pl ([212.77.101.11]:35925 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236084AbhETStU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 14:49:20 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2021 14:49:20 EDT
Received: (wp-smtpd smtp.wp.pl 17612 invoked from network); 20 May 2021 20:41:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1621536071; bh=fY5+omcrJznCtWB0A7TnS3SUznVJFzPnJ8BdRvY4bI4=;
          h=From:To:Cc:Subject;
          b=FiQb62MERkmGuBpgdlk+wBtKomPT2ou75/JX9K9CIAfpaT0NYv0/fGX+yz5/I1XlU
           i9qRCHnYhKsyfQRimdAYHotHWILMdxv8eIN9zwfii7UFo7+UT/oxdovRUUZao9fJJN
           f7i6bgxPhvu50PYea+M6PJktrFCRjBFnQAUAyn24=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 20 May 2021 20:41:11 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH net] net: lantiq: fix memory corruption in RX ring
Date:   Thu, 20 May 2021 20:40:54 +0200
Message-Id: <20210520184054.38477-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: 41c3d39c9522285ac9aafd1fc8d36e5f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [IUP0]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a situation where memory allocation or dma mapping fails, an
invalid address is programmed into the descriptor. This can lead
to memory corruption. If the memory allocation fails, DMA should
reuse the previous skb and mapping and drop the packet. This patch
also increments rx drop counter.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 drivers/net/ethernet/lantiq_xrx200.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 41c2ad210bc9..36dc3e5f6218 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -154,6 +154,7 @@ static int xrx200_close(struct net_device *net_dev)
 
 static int xrx200_alloc_skb(struct xrx200_chan *ch)
 {
+	dma_addr_t mapping;
 	int ret = 0;
 
 	ch->skb[ch->dma.desc] = netdev_alloc_skb_ip_align(ch->priv->net_dev,
@@ -163,16 +164,17 @@ static int xrx200_alloc_skb(struct xrx200_chan *ch)
 		goto skip;
 	}
 
-	ch->dma.desc_base[ch->dma.desc].addr = dma_map_single(ch->priv->dev,
-			ch->skb[ch->dma.desc]->data, XRX200_DMA_DATA_LEN,
-			DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(ch->priv->dev,
-				       ch->dma.desc_base[ch->dma.desc].addr))) {
+	mapping = dma_map_single(ch->priv->dev, ch->skb[ch->dma.desc]->data,
+				 XRX200_DMA_DATA_LEN, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(ch->priv->dev, mapping))) {
 		dev_kfree_skb_any(ch->skb[ch->dma.desc]);
 		ret = -ENOMEM;
 		goto skip;
 	}
 
+	ch->dma.desc_base[ch->dma.desc].addr = mapping;
+	/* Make sure the address is written before we give it to HW */
+	wmb();
 skip:
 	ch->dma.desc_base[ch->dma.desc].ctl =
 		LTQ_DMA_OWN | LTQ_DMA_RX_OFFSET(NET_IP_ALIGN) |
@@ -196,6 +198,8 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
 	ch->dma.desc %= LTQ_DESC_NUM;
 
 	if (ret) {
+		ch->skb[ch->dma.desc] = skb;
+		net_dev->stats.rx_dropped++;
 		netdev_err(net_dev, "failed to allocate new rx buffer\n");
 		return ret;
 	}
-- 
2.30.2

