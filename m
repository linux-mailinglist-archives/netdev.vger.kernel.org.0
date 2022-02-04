Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2826B4AA439
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 00:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377932AbiBDXV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 18:21:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60040 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235330AbiBDXV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 18:21:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90D71B83970;
        Fri,  4 Feb 2022 23:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E3EC004E1;
        Fri,  4 Feb 2022 23:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644016915;
        bh=dNQlXe8yFAAudNMC9z/zBan2SRh+F26p++tT+7IHG2o=;
        h=Date:From:To:Cc:Subject:From;
        b=t1TGHu40hFiDfZvEEd1lIZiV6ovwel07U5OW2t/FskDZ8I416zduyN4FnDKTKbD6S
         bd3igbmkybKpQ58MoaZ7G906Vuvx3s5l/Qz4Z3s9qm2a2UPYPDMgbU8tjE4zY1nmYs
         M7GqknNhjGf2/YqlAysES4dzIoPvnpQkB4szhyZIErVRLC//0SsEdg1kqG1SPVvd3A
         OV3rukzB63/XLYIWEE09XvH1LisJKVFFvPbVkWAd4DZhPQK4IS/MQ83JXZwtpxFAis
         MQmUnvYHjX1lELAAAJcN83l84hGnN9h4oh/AUDSVgpBvHcHBVSQfntTT2TMxDGfXWd
         2khiN7OXY1hxA==
Date:   Fri, 4 Feb 2022 17:29:06 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: sundance: Replace one-element array with
 non-array object
Message-ID: <20220204232906.GA442985@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems this one-element array is not actually being used as an
array of variable size, so we can just replace it with just a
non-array object of type struct desc_frag and refactor a bit the
rest of the code.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

This issue was found with the help of Coccinelle and audited and fixed,
manually.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/dlink/sundance.c | 60 +++++++++++++--------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index c710dc17be90..8dd7bf9014ec 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -340,7 +340,7 @@ enum wake_event_bits {
 struct netdev_desc {
 	__le32 next_desc;
 	__le32 status;
-	struct desc_frag { __le32 addr, length; } frag[1];
+	struct desc_frag { __le32 addr, length; } frag;
 };
 
 /* Bits in netdev_desc.status */
@@ -980,8 +980,8 @@ static void tx_timeout(struct net_device *dev, unsigned int txqueue)
 				le32_to_cpu(np->tx_ring[i].next_desc),
 				le32_to_cpu(np->tx_ring[i].status),
 				(le32_to_cpu(np->tx_ring[i].status) >> 2) & 0xff,
-				le32_to_cpu(np->tx_ring[i].frag[0].addr),
-				le32_to_cpu(np->tx_ring[i].frag[0].length));
+				le32_to_cpu(np->tx_ring[i].frag.addr),
+				le32_to_cpu(np->tx_ring[i].frag.length));
 		}
 		printk(KERN_DEBUG "TxListPtr=%08x netif_queue_stopped=%d\n",
 			ioread32(np->base + TxListPtr),
@@ -1027,7 +1027,7 @@ static void init_ring(struct net_device *dev)
 		np->rx_ring[i].next_desc = cpu_to_le32(np->rx_ring_dma +
 			((i+1)%RX_RING_SIZE)*sizeof(*np->rx_ring));
 		np->rx_ring[i].status = 0;
-		np->rx_ring[i].frag[0].length = 0;
+		np->rx_ring[i].frag.length = 0;
 		np->rx_skbuff[i] = NULL;
 	}
 
@@ -1039,16 +1039,16 @@ static void init_ring(struct net_device *dev)
 		if (skb == NULL)
 			break;
 		skb_reserve(skb, 2);	/* 16 byte align the IP header. */
-		np->rx_ring[i].frag[0].addr = cpu_to_le32(
+		np->rx_ring[i].frag.addr = cpu_to_le32(
 			dma_map_single(&np->pci_dev->dev, skb->data,
 				np->rx_buf_sz, DMA_FROM_DEVICE));
 		if (dma_mapping_error(&np->pci_dev->dev,
-					np->rx_ring[i].frag[0].addr)) {
+					np->rx_ring[i].frag.addr)) {
 			dev_kfree_skb(skb);
 			np->rx_skbuff[i] = NULL;
 			break;
 		}
-		np->rx_ring[i].frag[0].length = cpu_to_le32(np->rx_buf_sz | LastFrag);
+		np->rx_ring[i].frag.length = cpu_to_le32(np->rx_buf_sz | LastFrag);
 	}
 	np->dirty_rx = (unsigned int)(i - RX_RING_SIZE);
 
@@ -1097,12 +1097,12 @@ start_tx (struct sk_buff *skb, struct net_device *dev)
 
 	txdesc->next_desc = 0;
 	txdesc->status = cpu_to_le32 ((entry << 2) | DisableAlign);
-	txdesc->frag[0].addr = cpu_to_le32(dma_map_single(&np->pci_dev->dev,
+	txdesc->frag.addr = cpu_to_le32(dma_map_single(&np->pci_dev->dev,
 				skb->data, skb->len, DMA_TO_DEVICE));
 	if (dma_mapping_error(&np->pci_dev->dev,
-				txdesc->frag[0].addr))
+				txdesc->frag.addr))
 			goto drop_frame;
-	txdesc->frag[0].length = cpu_to_le32 (skb->len | LastFrag);
+	txdesc->frag.length = cpu_to_le32 (skb->len | LastFrag);
 
 	/* Increment cur_tx before tasklet_schedule() */
 	np->cur_tx++;
@@ -1151,7 +1151,7 @@ reset_tx (struct net_device *dev)
 		skb = np->tx_skbuff[i];
 		if (skb) {
 			dma_unmap_single(&np->pci_dev->dev,
-				le32_to_cpu(np->tx_ring[i].frag[0].addr),
+				le32_to_cpu(np->tx_ring[i].frag.addr),
 				skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
 			np->tx_skbuff[i] = NULL;
@@ -1271,12 +1271,12 @@ static irqreturn_t intr_handler(int irq, void *dev_instance)
 				skb = np->tx_skbuff[entry];
 				/* Free the original skb. */
 				dma_unmap_single(&np->pci_dev->dev,
-					le32_to_cpu(np->tx_ring[entry].frag[0].addr),
+					le32_to_cpu(np->tx_ring[entry].frag.addr),
 					skb->len, DMA_TO_DEVICE);
 				dev_consume_skb_irq(np->tx_skbuff[entry]);
 				np->tx_skbuff[entry] = NULL;
-				np->tx_ring[entry].frag[0].addr = 0;
-				np->tx_ring[entry].frag[0].length = 0;
+				np->tx_ring[entry].frag.addr = 0;
+				np->tx_ring[entry].frag.length = 0;
 			}
 			spin_unlock(&np->lock);
 		} else {
@@ -1290,12 +1290,12 @@ static irqreturn_t intr_handler(int irq, void *dev_instance)
 				skb = np->tx_skbuff[entry];
 				/* Free the original skb. */
 				dma_unmap_single(&np->pci_dev->dev,
-					le32_to_cpu(np->tx_ring[entry].frag[0].addr),
+					le32_to_cpu(np->tx_ring[entry].frag.addr),
 					skb->len, DMA_TO_DEVICE);
 				dev_consume_skb_irq(np->tx_skbuff[entry]);
 				np->tx_skbuff[entry] = NULL;
-				np->tx_ring[entry].frag[0].addr = 0;
-				np->tx_ring[entry].frag[0].length = 0;
+				np->tx_ring[entry].frag.addr = 0;
+				np->tx_ring[entry].frag.length = 0;
 			}
 			spin_unlock(&np->lock);
 		}
@@ -1372,16 +1372,16 @@ static void rx_poll(struct tasklet_struct *t)
 			    (skb = netdev_alloc_skb(dev, pkt_len + 2)) != NULL) {
 				skb_reserve(skb, 2);	/* 16 byte align the IP header */
 				dma_sync_single_for_cpu(&np->pci_dev->dev,
-						le32_to_cpu(desc->frag[0].addr),
+						le32_to_cpu(desc->frag.addr),
 						np->rx_buf_sz, DMA_FROM_DEVICE);
 				skb_copy_to_linear_data(skb, np->rx_skbuff[entry]->data, pkt_len);
 				dma_sync_single_for_device(&np->pci_dev->dev,
-						le32_to_cpu(desc->frag[0].addr),
+						le32_to_cpu(desc->frag.addr),
 						np->rx_buf_sz, DMA_FROM_DEVICE);
 				skb_put(skb, pkt_len);
 			} else {
 				dma_unmap_single(&np->pci_dev->dev,
-					le32_to_cpu(desc->frag[0].addr),
+					le32_to_cpu(desc->frag.addr),
 					np->rx_buf_sz, DMA_FROM_DEVICE);
 				skb_put(skb = np->rx_skbuff[entry], pkt_len);
 				np->rx_skbuff[entry] = NULL;
@@ -1427,18 +1427,18 @@ static void refill_rx (struct net_device *dev)
 			if (skb == NULL)
 				break;		/* Better luck next round. */
 			skb_reserve(skb, 2);	/* Align IP on 16 byte boundaries */
-			np->rx_ring[entry].frag[0].addr = cpu_to_le32(
+			np->rx_ring[entry].frag.addr = cpu_to_le32(
 				dma_map_single(&np->pci_dev->dev, skb->data,
 					np->rx_buf_sz, DMA_FROM_DEVICE));
 			if (dma_mapping_error(&np->pci_dev->dev,
-				    np->rx_ring[entry].frag[0].addr)) {
+				    np->rx_ring[entry].frag.addr)) {
 			    dev_kfree_skb_irq(skb);
 			    np->rx_skbuff[entry] = NULL;
 			    break;
 			}
 		}
 		/* Perhaps we need not reset this field. */
-		np->rx_ring[entry].frag[0].length =
+		np->rx_ring[entry].frag.length =
 			cpu_to_le32(np->rx_buf_sz | LastFrag);
 		np->rx_ring[entry].status = 0;
 		cnt++;
@@ -1870,14 +1870,14 @@ static int netdev_close(struct net_device *dev)
 			   (int)(np->tx_ring_dma));
 		for (i = 0; i < TX_RING_SIZE; i++)
 			printk(KERN_DEBUG " #%d desc. %4.4x %8.8x %8.8x.\n",
-				   i, np->tx_ring[i].status, np->tx_ring[i].frag[0].addr,
-				   np->tx_ring[i].frag[0].length);
+				   i, np->tx_ring[i].status, np->tx_ring[i].frag.addr,
+				   np->tx_ring[i].frag.length);
 		printk(KERN_DEBUG "  Rx ring %8.8x:\n",
 			   (int)(np->rx_ring_dma));
 		for (i = 0; i < /*RX_RING_SIZE*/4 ; i++) {
 			printk(KERN_DEBUG " #%d desc. %4.4x %4.4x %8.8x\n",
-				   i, np->rx_ring[i].status, np->rx_ring[i].frag[0].addr,
-				   np->rx_ring[i].frag[0].length);
+				   i, np->rx_ring[i].status, np->rx_ring[i].frag.addr,
+				   np->rx_ring[i].frag.length);
 		}
 	}
 #endif /* __i386__ debugging only */
@@ -1892,19 +1892,19 @@ static int netdev_close(struct net_device *dev)
 		skb = np->rx_skbuff[i];
 		if (skb) {
 			dma_unmap_single(&np->pci_dev->dev,
-				le32_to_cpu(np->rx_ring[i].frag[0].addr),
+				le32_to_cpu(np->rx_ring[i].frag.addr),
 				np->rx_buf_sz, DMA_FROM_DEVICE);
 			dev_kfree_skb(skb);
 			np->rx_skbuff[i] = NULL;
 		}
-		np->rx_ring[i].frag[0].addr = cpu_to_le32(0xBADF00D0); /* poison */
+		np->rx_ring[i].frag.addr = cpu_to_le32(0xBADF00D0); /* poison */
 	}
 	for (i = 0; i < TX_RING_SIZE; i++) {
 		np->tx_ring[i].next_desc = 0;
 		skb = np->tx_skbuff[i];
 		if (skb) {
 			dma_unmap_single(&np->pci_dev->dev,
-				le32_to_cpu(np->tx_ring[i].frag[0].addr),
+				le32_to_cpu(np->tx_ring[i].frag.addr),
 				skb->len, DMA_TO_DEVICE);
 			dev_kfree_skb(skb);
 			np->tx_skbuff[i] = NULL;
-- 
2.27.0

