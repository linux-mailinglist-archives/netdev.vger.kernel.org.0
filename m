Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8437A3D9E07
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 09:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbhG2HGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 03:06:16 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:7345 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbhG2HGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 03:06:16 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.5]) by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee26102533d58f-b1e24; Thu, 29 Jul 2021 15:05:34 +0800 (CST)
X-RM-TRANSID: 2ee26102533d58f-b1e24
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36102533b098-b11b7;
        Thu, 29 Jul 2021 15:05:34 +0800 (CST)
X-RM-TRANSID: 2ee36102533b098-b11b7
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, kuba@kernel.org, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH] bcm63xx_enet: simplify the code in bcm_enet_open()
Date:   Thu, 29 Jul 2021 15:06:27 +0800
Message-Id: <20210729070627.23776-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function bcm_enet_open(), 'ret = -ENOMEM' can be moved
outside the judgement statement, so redundant assignments can
be removed to simplify the code.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 509e10013..c5a3c5774 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -920,13 +920,13 @@ static int bcm_enet_open(struct net_device *dev)
 	memcpy(addr.sa_data, dev->dev_addr, ETH_ALEN);
 	bcm_enet_set_mac_address(dev, &addr);
 
+	ret = -ENOMEM;
+
 	/* allocate rx dma ring */
 	size = priv->rx_ring_size * sizeof(struct bcm_enet_desc);
 	p = dma_alloc_coherent(kdev, size, &priv->rx_desc_dma, GFP_KERNEL);
-	if (!p) {
-		ret = -ENOMEM;
+	if (!p)
 		goto out_freeirq_tx;
-	}
 
 	priv->rx_desc_alloc_size = size;
 	priv->rx_desc_cpu = p;
@@ -934,20 +934,16 @@ static int bcm_enet_open(struct net_device *dev)
 	/* allocate tx dma ring */
 	size = priv->tx_ring_size * sizeof(struct bcm_enet_desc);
 	p = dma_alloc_coherent(kdev, size, &priv->tx_desc_dma, GFP_KERNEL);
-	if (!p) {
-		ret = -ENOMEM;
+	if (!p)
 		goto out_free_rx_ring;
-	}
 
 	priv->tx_desc_alloc_size = size;
 	priv->tx_desc_cpu = p;
 
 	priv->tx_skb = kcalloc(priv->tx_ring_size, sizeof(struct sk_buff *),
 			       GFP_KERNEL);
-	if (!priv->tx_skb) {
-		ret = -ENOMEM;
+	if (!priv->tx_skb)
 		goto out_free_tx_ring;
-	}
 
 	priv->tx_desc_count = priv->tx_ring_size;
 	priv->tx_dirty_desc = 0;
@@ -957,10 +953,8 @@ static int bcm_enet_open(struct net_device *dev)
 	/* init & fill rx ring with skbs */
 	priv->rx_skb = kcalloc(priv->rx_ring_size, sizeof(struct sk_buff *),
 			       GFP_KERNEL);
-	if (!priv->rx_skb) {
-		ret = -ENOMEM;
+	if (!priv->rx_skb)
 		goto out_free_tx_skb;
-	}
 
 	priv->rx_desc_count = 0;
 	priv->rx_dirty_desc = 0;
@@ -976,7 +970,6 @@ static int bcm_enet_open(struct net_device *dev)
 
 	if (bcm_enet_refill_rx(dev)) {
 		dev_err(kdev, "cannot allocate rx skb queue\n");
-		ret = -ENOMEM;
 		goto out;
 	}
 
-- 
2.20.1.windows.1



