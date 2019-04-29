Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7506DDD5
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfD2Iew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:34:52 -0400
Received: from first.geanix.com ([116.203.34.67]:49916 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727747AbfD2Iev (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:34:51 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 646E2308E87;
        Mon, 29 Apr 2019 08:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556526806; bh=nLvjSdN2gWk2zh30cbdeHbH36aBkY5GGEHONEfGRhu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=mdUYsViAg2ZJj4LFp+pqnVy1TXjJyUMiR4PfMtAsnRTS+XemTQIjpyg6Ep3ifLk8p
         mRZhN3EyC4mwcTl44fZJOnGz/WEiDkNzNO4LhfgXzLLfIWIH2g4lR/qTj5kRG1VCFk
         BglOm5fGjP0FRMXNljQ4GOKUYQqJRq+DOryk71e3kIDI3Tv7LPoiWiKu5C5U7ySOkD
         tuybn3riwkZ8GeSYMw28DFPXIvCUEA5GT4xrAYqXXrkXUktzq0Sg0FaffTfGvAlfls
         Fe8xiZ/XrYFrI2rt2i9PUcKf6J7+GX2UUW1E7GHVM+h2K7mH+9hmySRqwLt44rDL43
         3dcRtrtNgkrxg==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] net: ll_temac: Fix support for little-endian platforms
Date:   Mon, 29 Apr 2019 10:34:15 +0200
Message-Id: <20190429083422.4356-6-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429083422.4356-1-esben@geanix.com>
References: <20190426073231.4008-1-esben@geanix.com>
 <20190429083422.4356-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 3e0c63300934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both TEMAC and SDMA is big-endian, so make sure that all values in SDMA
buffer descriptors (cmdac_bd) are handled as big-endian, independent of the
host endianness. With all currently supported platforms being big-endian,
this change does not make a change for any of them.

Note, when using app3 and app4 for piggybacking skb pointers there is no
need to care about endianness, as neither TEMAC nor SDMA access app3 and
app4 in TX buffer descriptors.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 90 ++++++++++++++++-------------
 1 file changed, 51 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 58c6713..25d9a35 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -258,6 +258,7 @@ static int temac_dma_bd_init(struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
 	struct sk_buff *skb;
+	dma_addr_t skb_dma_addr;
 	int i;
 
 	lp->rx_skb = devm_kcalloc(&ndev->dev, RX_BD_NUM, sizeof(*lp->rx_skb),
@@ -280,13 +281,15 @@ static int temac_dma_bd_init(struct net_device *ndev)
 		goto out;
 
 	for (i = 0; i < TX_BD_NUM; i++) {
-		lp->tx_bd_v[i].next = lp->tx_bd_p +
-				sizeof(*lp->tx_bd_v) * ((i + 1) % TX_BD_NUM);
+		lp->tx_bd_v[i].next = cpu_to_be32(
+			lp->tx_bd_p
+			+ sizeof(*lp->tx_bd_v) * ((i + 1) % TX_BD_NUM));
 	}
 
 	for (i = 0; i < RX_BD_NUM; i++) {
-		lp->rx_bd_v[i].next = lp->rx_bd_p +
-				sizeof(*lp->rx_bd_v) * ((i + 1) % RX_BD_NUM);
+		lp->rx_bd_v[i].next = cpu_to_be32(
+			lp->rx_bd_p
+			+ sizeof(*lp->rx_bd_v) * ((i + 1) % RX_BD_NUM));
 
 		skb = netdev_alloc_skb_ip_align(ndev,
 						XTE_MAX_JUMBO_FRAME_SIZE);
@@ -295,12 +298,12 @@ static int temac_dma_bd_init(struct net_device *ndev)
 
 		lp->rx_skb[i] = skb;
 		/* returns physical address of skb->data */
-		lp->rx_bd_v[i].phys = dma_map_single(ndev->dev.parent,
-						     skb->data,
-						     XTE_MAX_JUMBO_FRAME_SIZE,
-						     DMA_FROM_DEVICE);
-		lp->rx_bd_v[i].len = XTE_MAX_JUMBO_FRAME_SIZE;
-		lp->rx_bd_v[i].app0 = STS_CTRL_APP0_IRQONEND;
+		skb_dma_addr = dma_map_single(ndev->dev.parent, skb->data,
+					      XTE_MAX_JUMBO_FRAME_SIZE,
+					      DMA_FROM_DEVICE);
+		lp->rx_bd_v[i].phys = cpu_to_be32(skb_dma_addr);
+		lp->rx_bd_v[i].len = cpu_to_be32(XTE_MAX_JUMBO_FRAME_SIZE);
+		lp->rx_bd_v[i].app0 = cpu_to_be32(STS_CTRL_APP0_IRQONEND);
 	}
 
 	lp->dma_out(lp, TX_CHNL_CTRL, 0x10220400 |
@@ -676,11 +679,11 @@ static void temac_start_xmit_done(struct net_device *ndev)
 	struct sk_buff *skb;
 
 	cur_p = &lp->tx_bd_v[lp->tx_bd_ci];
-	stat = cur_p->app0;
+	stat = be32_to_cpu(cur_p->app0);
 
 	while (stat & STS_CTRL_APP0_CMPLT) {
-		dma_unmap_single(ndev->dev.parent, cur_p->phys, cur_p->len,
-				 DMA_TO_DEVICE);
+		dma_unmap_single(ndev->dev.parent, be32_to_cpu(cur_p->phys),
+				 be32_to_cpu(cur_p->len), DMA_TO_DEVICE);
 		skb = (struct sk_buff *)ptr_from_txbd(cur_p);
 		if (skb)
 			dev_consume_skb_irq(skb);
@@ -691,14 +694,14 @@ static void temac_start_xmit_done(struct net_device *ndev)
 		cur_p->app4 = 0;
 
 		ndev->stats.tx_packets++;
-		ndev->stats.tx_bytes += cur_p->len;
+		ndev->stats.tx_bytes += be32_to_cpu(cur_p->len);
 
 		lp->tx_bd_ci++;
 		if (lp->tx_bd_ci >= TX_BD_NUM)
 			lp->tx_bd_ci = 0;
 
 		cur_p = &lp->tx_bd_v[lp->tx_bd_ci];
-		stat = cur_p->app0;
+		stat = be32_to_cpu(cur_p->app0);
 	}
 
 	netif_wake_queue(ndev);
@@ -732,7 +735,7 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
 	struct cdmac_bd *cur_p;
-	dma_addr_t start_p, tail_p;
+	dma_addr_t start_p, tail_p, skb_dma_addr;
 	int ii;
 	unsigned long num_frag;
 	skb_frag_t *frag;
@@ -753,15 +756,17 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		unsigned int csum_start_off = skb_checksum_start_offset(skb);
 		unsigned int csum_index_off = csum_start_off + skb->csum_offset;
 
-		cur_p->app0 |= 1; /* TX Checksum Enabled */
-		cur_p->app1 = (csum_start_off << 16) | csum_index_off;
+		cur_p->app0 |= cpu_to_be32(0x000001); /* TX Checksum Enabled */
+		cur_p->app1 = cpu_to_be32((csum_start_off << 16)
+					  | csum_index_off);
 		cur_p->app2 = 0;  /* initial checksum seed */
 	}
 
-	cur_p->app0 |= STS_CTRL_APP0_SOP;
-	cur_p->len = skb_headlen(skb);
-	cur_p->phys = dma_map_single(ndev->dev.parent, skb->data,
-				     skb_headlen(skb), DMA_TO_DEVICE);
+	cur_p->app0 |= cpu_to_be32(STS_CTRL_APP0_SOP);
+	skb_dma_addr = dma_map_single(ndev->dev.parent, skb->data,
+				      skb_headlen(skb), DMA_TO_DEVICE);
+	cur_p->len = cpu_to_be32(skb_headlen(skb));
+	cur_p->phys = cpu_to_be32(skb_dma_addr);
 	ptr_to_txbd((void *)skb, cur_p);
 
 	for (ii = 0; ii < num_frag; ii++) {
@@ -770,14 +775,15 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 			lp->tx_bd_tail = 0;
 
 		cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
-		cur_p->phys = dma_map_single(ndev->dev.parent,
-					     skb_frag_address(frag),
-					     skb_frag_size(frag), DMA_TO_DEVICE);
-		cur_p->len = skb_frag_size(frag);
+		skb_dma_addr = dma_map_single(
+			ndev->dev.parent, skb_frag_address(frag),
+			skb_frag_size(frag), DMA_TO_DEVICE);
+		cur_p->phys = cpu_to_be32(skb_dma_addr);
+		cur_p->len = cpu_to_be32(skb_frag_size(frag));
 		cur_p->app0 = 0;
 		frag++;
 	}
-	cur_p->app0 |= STS_CTRL_APP0_EOP;
+	cur_p->app0 |= cpu_to_be32(STS_CTRL_APP0_EOP);
 
 	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	lp->tx_bd_tail++;
@@ -799,7 +805,7 @@ static void ll_temac_recv(struct net_device *ndev)
 	struct sk_buff *skb, *new_skb;
 	unsigned int bdstat;
 	struct cdmac_bd *cur_p;
-	dma_addr_t tail_p;
+	dma_addr_t tail_p, skb_dma_addr;
 	int length;
 	unsigned long flags;
 
@@ -808,14 +814,14 @@ static void ll_temac_recv(struct net_device *ndev)
 	tail_p = lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
 	cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
 
-	bdstat = cur_p->app0;
+	bdstat = be32_to_cpu(cur_p->app0);
 	while ((bdstat & STS_CTRL_APP0_CMPLT)) {
 
 		skb = lp->rx_skb[lp->rx_bd_ci];
-		length = cur_p->app4 & 0x3FFF;
+		length = be32_to_cpu(cur_p->app4) & 0x3FFF;
 
-		dma_unmap_single(ndev->dev.parent, cur_p->phys, length,
-				 DMA_FROM_DEVICE);
+		dma_unmap_single(ndev->dev.parent, be32_to_cpu(cur_p->phys),
+				 length, DMA_FROM_DEVICE);
 
 		skb_put(skb, length);
 		skb->protocol = eth_type_trans(skb, ndev);
@@ -826,7 +832,12 @@ static void ll_temac_recv(struct net_device *ndev)
 		    (skb->protocol == htons(ETH_P_IP)) &&
 		    (skb->len > 64)) {
 
-			skb->csum = cur_p->app3 & 0xFFFF;
+			/* Convert from device endianness (be32) to cpu
+			 * endiannes, and if necessary swap the bytes
+			 * (back) for proper IP checksum byte order
+			 * (be16).
+			 */
+			skb->csum = htons(be32_to_cpu(cur_p->app3) & 0xFFFF);
 			skb->ip_summed = CHECKSUM_COMPLETE;
 		}
 
@@ -843,11 +854,12 @@ static void ll_temac_recv(struct net_device *ndev)
 			return;
 		}
 
-		cur_p->app0 = STS_CTRL_APP0_IRQONEND;
-		cur_p->phys = dma_map_single(ndev->dev.parent, new_skb->data,
-					     XTE_MAX_JUMBO_FRAME_SIZE,
-					     DMA_FROM_DEVICE);
-		cur_p->len = XTE_MAX_JUMBO_FRAME_SIZE;
+		cur_p->app0 = cpu_to_be32(STS_CTRL_APP0_IRQONEND);
+		skb_dma_addr = dma_map_single(ndev->dev.parent, new_skb->data,
+					      XTE_MAX_JUMBO_FRAME_SIZE,
+					      DMA_FROM_DEVICE);
+		cur_p->phys = cpu_to_be32(skb_dma_addr);
+		cur_p->len = cpu_to_be32(XTE_MAX_JUMBO_FRAME_SIZE);
 		lp->rx_skb[lp->rx_bd_ci] = new_skb;
 
 		lp->rx_bd_ci++;
@@ -855,7 +867,7 @@ static void ll_temac_recv(struct net_device *ndev)
 			lp->rx_bd_ci = 0;
 
 		cur_p = &lp->rx_bd_v[lp->rx_bd_ci];
-		bdstat = cur_p->app0;
+		bdstat = be32_to_cpu(cur_p->app0);
 	}
 	lp->dma_out(lp, RX_TAILDESC_PTR, tail_p);
 
-- 
2.4.11

