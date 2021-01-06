Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314E92EBFBC
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbhAFOoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbhAFOoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 09:44:07 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB67C06135B;
        Wed,  6 Jan 2021 06:43:22 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id iq13so1646304pjb.3;
        Wed, 06 Jan 2021 06:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d5vcGavR4PydjqkNXvyu8THbVXAEosqI/1jZwqLL0vk=;
        b=GYu6qkg+JpoEsxTAWQhgpr3Al9D3h56YGDPI5tnln1e6CEoIMSxWiTvrAwoOahlIno
         Rxwn6l0HHnRVzDYaHF0yR2C9QB3E0v6rqMcqvZ+U6yhjdZSq8ACpf405nSTAvTuZ0GZW
         bgJFz123BjLlRKJR0E4sWmIoC8mK0Ms8EHC5u402sborc+V2LDFXHvjaQ+ouUz8e0e6G
         tDqqPxqJ07fhIOeFQLb28cEDDvReJa12zwi1evOKo9GN6eL4q2Trs9EnbcPIn+SVQJqJ
         eR++caeE+ExKsGdBEdtO0ihCDK7t6pb3QuDdR4OeNj+2GqDy431yhbBGtWJup0ENbjGQ
         ABFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d5vcGavR4PydjqkNXvyu8THbVXAEosqI/1jZwqLL0vk=;
        b=oX2QRMqPjfOAmD/cqGlepjuIXgAT0LVidfxte9RWhMxReqFLlVGYNgmYX8eiv0z9Em
         Bmfx4KjxTW1v3ExTLwpiIEgF5TQi8Id7mXydmBenTW6VFmvcZh7rj5TH0WYhjHhJ9HKD
         dVGJ11nG83Pu4SktUenDA2QhQAKTsFWguu3jF/j+lIsqhSx0m/ycwhQTrr1NwobKSzrB
         AER8v6ckedhJtZEFVNIHBflOSve6kpqluik2sGYpu2Vu0ib+O0qH9WMfnJbJXXlHLRab
         SITXQNQql0HuqlDzjHEg3Yb364mj4rDRCsINwKJNIv1i9ajr8lnURk3isFRVXLmoyKtn
         etfw==
X-Gm-Message-State: AOAM5307H4WSuxAFq6fELePZFjIb3qKK3Z+eiYpNYWjrt9uCYRqfk6/H
        TH60TYW2YveBm85iZOe7PbM=
X-Google-Smtp-Source: ABdhPJw4i1kMKdzTxsDJaO0rPt7U1lhItGo5ZPMgO7u3ZT71armudO+xZGvfVINDdSuKY2AZqUR0cw==
X-Received: by 2002:a17:902:654f:b029:da:347d:7af3 with SMTP id d15-20020a170902654fb02900da347d7af3mr4873136pln.18.1609944201986;
        Wed, 06 Jan 2021 06:43:21 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id h8sm3076774pjc.2.2021.01.06.06.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 06:43:21 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 5/7] bcm63xx_enet: consolidate rx SKB ring cleanup code
Date:   Wed,  6 Jan 2021 22:42:06 +0800
Message-Id: <20210106144208.1935-6-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210106144208.1935-1-liew.s.piaw@gmail.com>
References: <20210106144208.1935-1-liew.s.piaw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rx SKB ring use the same code for cleanup at various points.
Combine them into a function to reduce lines of code.

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 72 ++++++--------------
 1 file changed, 22 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 96d56c3e2cc9..e34b05b10e43 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -860,6 +860,24 @@ static void bcm_enet_adjust_link(struct net_device *dev)
 		priv->pause_tx ? "tx" : "off");
 }
 
+static void bcm_enet_free_rx_skb_ring(struct device *kdev, struct bcm_enet_priv *priv)
+{
+	int i;
+
+	for (i = 0; i < priv->rx_ring_size; i++) {
+		struct bcm_enet_desc *desc;
+
+		if (!priv->rx_skb[i])
+			continue;
+
+		desc = &priv->rx_desc_cpu[i];
+		dma_unmap_single(kdev, desc->address, priv->rx_skb_size,
+				 DMA_FROM_DEVICE);
+		kfree_skb(priv->rx_skb[i]);
+	}
+	kfree(priv->rx_skb);
+}
+
 /*
  * open callback, allocate dma rings & buffers and start rx operation
  */
@@ -1084,18 +1102,7 @@ static int bcm_enet_open(struct net_device *dev)
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
+	bcm_enet_free_rx_skb_ring(kdev, priv);
 
 out_free_tx_skb:
 	kfree(priv->tx_skb);
@@ -1174,7 +1181,6 @@ static int bcm_enet_stop(struct net_device *dev)
 {
 	struct bcm_enet_priv *priv;
 	struct device *kdev;
-	int i;
 
 	priv = netdev_priv(dev);
 	kdev = &priv->pdev->dev;
@@ -1203,20 +1209,9 @@ static int bcm_enet_stop(struct net_device *dev)
 	bcm_enet_tx_reclaim(dev, 1);
 
 	/* free the rx skb ring */
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
+	bcm_enet_free_rx_skb_ring(kdev, priv);
 
 	/* free remaining allocated memory */
-	kfree(priv->rx_skb);
 	kfree(priv->tx_skb);
 	dma_free_coherent(kdev, priv->rx_desc_alloc_size,
 			  priv->rx_desc_cpu, priv->rx_desc_dma);
@@ -2303,18 +2298,7 @@ static int bcm_enetsw_open(struct net_device *dev)
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
+	bcm_enet_free_rx_skb_ring(kdev, priv);
 
 out_free_tx_skb:
 	kfree(priv->tx_skb);
@@ -2343,7 +2327,6 @@ static int bcm_enetsw_stop(struct net_device *dev)
 {
 	struct bcm_enet_priv *priv;
 	struct device *kdev;
-	int i;
 
 	priv = netdev_priv(dev);
 	kdev = &priv->pdev->dev;
@@ -2366,20 +2349,9 @@ static int bcm_enetsw_stop(struct net_device *dev)
 	bcm_enet_tx_reclaim(dev, 1);
 
 	/* free the rx skb ring */
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
+	bcm_enet_free_rx_skb_ring(kdev, priv);
 
 	/* free remaining allocated memory */
-	kfree(priv->rx_skb);
 	kfree(priv->tx_skb);
 	dma_free_coherent(kdev, priv->rx_desc_alloc_size,
 			  priv->rx_desc_cpu, priv->rx_desc_dma);
-- 
2.17.1

