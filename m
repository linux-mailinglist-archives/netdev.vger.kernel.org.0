Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D60D38C979
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 16:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbhEUOtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 10:49:02 -0400
Received: from mx3.wp.pl ([212.77.101.9]:58566 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231538AbhEUOtB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 10:49:01 -0400
Received: (wp-smtpd smtp.wp.pl 4338 invoked from network); 21 May 2021 16:47:35 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1621608455; bh=dfCULmakDkIx4cGLB3BFf4t1ch+oTMJRPtLSywNNtDg=;
          h=From:To:Cc:Subject;
          b=MrTr7FYW+/gCADkz92XAK+TBSm4RUNPiVJUfyUJKY023o1WgDUpIHk9Kozm0dHURD
           y88AuoKbcVyGX8u4vg0ekgAIyv7DKTA0iF3rSSJ7KLDmRNJZnZ842jz2OmOGa8HAJh
           A4WQKrfjHoCXCpeiLS1SDJAtx0feG785djpi5Q2Q=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 21 May 2021 16:47:35 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH net v2] net: lantiq: fix memory corruption in RX ring
Date:   Fri, 21 May 2021 16:45:58 +0200
Message-Id: <20210521144558.2071-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                      
X-WP-MailID: 7f717d4d6c4e69ba60c6cda1b4de62a8
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [8QOU]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a situation where memory allocation or dma mapping fails, an
invalid address is programmed into the descriptor. This can lead
to memory corruption. If the memory allocation fails, DMA should
reuse the previous skb and mapping and drop the packet. This patch
also increments rx drop counter.

Fixes: fe1a56420cf2 ("net: lantiq: Add Lantiq / Intel VRX200 Ethernet driver ")
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

