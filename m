Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E605AFC65
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 08:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiIGG3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 02:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiIGG3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 02:29:00 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A78095E77;
        Tue,  6 Sep 2022 23:28:57 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MMsgQ1q6Jz1P85j;
        Wed,  7 Sep 2022 14:25:06 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 7 Sep 2022 14:28:54 +0800
Received: from localhost.localdomain (10.67.165.2) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 7 Sep 2022 14:28:53 +0800
From:   Haoyue Xu <xuhaoyue1@hisilicon.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xuhaoyue1@hisilicon.com>, <pabeni@redhat.com>,
        <edumazet@google.com>, <huangdaode@huawei.com>,
        <liangwenpeng@huawei.com>, <liyangyang20@huawei.com>
Subject: [PATCH net-next 1/3] net: amd: Unified the comparison between pointers and NULL to the same writing
Date:   Wed, 7 Sep 2022 14:28:10 +0800
Message-ID: <20220907062812.2259309-2-xuhaoyue1@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20220907062812.2259309-1-xuhaoyue1@hisilicon.com>
References: <20220907062812.2259309-1-xuhaoyue1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guofeng Yue <yueguofeng@hisilicon.com>

Using the unified way to compare pointers and NULL, which cleans the static
warning.

eg:
	if (skb == NULL) --> if (!skb）
	if (skb != NULL) --> if (skb)

Signed-off-by: Guofeng Yue <yueguofeng@hisilicon.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
---
 drivers/net/ethernet/amd/a2065.c      |  2 +-
 drivers/net/ethernet/amd/amd8111e.c   |  4 ++--
 drivers/net/ethernet/amd/ariadne.c    |  4 ++--
 drivers/net/ethernet/amd/atarilance.c |  4 ++--
 drivers/net/ethernet/amd/au1000_eth.c |  6 +++---
 drivers/net/ethernet/amd/lance.c      |  4 ++--
 drivers/net/ethernet/amd/nmclan_cs.c  |  4 ++--
 drivers/net/ethernet/amd/pcnet32.c    | 12 ++++++------
 drivers/net/ethernet/amd/sun3lance.c  |  4 ++--
 drivers/net/ethernet/amd/sunlance.c   |  4 ++--
 10 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/amd/a2065.c b/drivers/net/ethernet/amd/a2065.c
index 3a351d3396bf..68983b717145 100644
--- a/drivers/net/ethernet/amd/a2065.c
+++ b/drivers/net/ethernet/amd/a2065.c
@@ -695,7 +695,7 @@ static int a2065_init_one(struct zorro_dev *z,
 	}
 
 	dev = alloc_etherdev(sizeof(struct lance_private));
-	if (dev == NULL) {
+	if (!dev) {
 		release_mem_region(base_addr, sizeof(struct lance_regs));
 		release_mem_region(mem_start, A2065_RAM_SIZE);
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index fb6a5f64d221..aaa527dc1b6f 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -237,7 +237,7 @@ static int amd8111e_free_skbs(struct net_device *dev)
 	/* Freeing previously allocated receive buffers */
 	for (i = 0; i < NUM_RX_BUFFERS; i++) {
 		rx_skbuff = lp->rx_skbuff[i];
-		if (rx_skbuff != NULL) {
+		if (rx_skbuff) {
 			dma_unmap_single(&lp->pci_dev->dev,
 					 lp->rx_dma_addr[i],
 					 lp->rx_buff_len - 2, DMA_FROM_DEVICE);
@@ -1084,7 +1084,7 @@ static irqreturn_t amd8111e_interrupt(int irq, void *dev_id)
 	unsigned int intr0, intren0;
 	unsigned int handled = 1;
 
-	if (unlikely(dev == NULL))
+	if (unlikely(!dev))
 		return IRQ_NONE;
 
 	spin_lock(&lp->lock);
diff --git a/drivers/net/ethernet/amd/ariadne.c b/drivers/net/ethernet/amd/ariadne.c
index 4ea7b9f3c424..38153e633231 100644
--- a/drivers/net/ethernet/amd/ariadne.c
+++ b/drivers/net/ethernet/amd/ariadne.c
@@ -193,7 +193,7 @@ static int ariadne_rx(struct net_device *dev)
 			struct sk_buff *skb;
 
 			skb = netdev_alloc_skb(dev, pkt_len + 2);
-			if (skb == NULL) {
+			if (!skb) {
 				for (i = 0; i < RX_RING_SIZE; i++)
 					if (lowb(priv->rx_ring[(entry + i) % RX_RING_SIZE]->RMD1) & RF_OWN)
 						break;
@@ -731,7 +731,7 @@ static int ariadne_init_one(struct zorro_dev *z,
 	}
 
 	dev = alloc_etherdev(sizeof(struct ariadne_private));
-	if (dev == NULL) {
+	if (!dev) {
 		release_mem_region(base_addr, sizeof(struct Am79C960));
 		release_mem_region(mem_start, ARIADNE_RAM_SIZE);
 		return -ENOMEM;
diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index 27869164c6e6..e5c6d99957cd 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -854,7 +854,7 @@ static irqreturn_t lance_interrupt( int irq, void *dev_id )
 	int csr0, boguscnt = 10;
 	int handled = 0;
 
-	if (dev == NULL) {
+	if (!dev) {
 		DPRINTK( 1, ( "lance_interrupt(): interrupt for unknown device.\n" ));
 		return IRQ_NONE;
 	}
@@ -995,7 +995,7 @@ static int lance_rx( struct net_device *dev )
 			}
 			else {
 				skb = netdev_alloc_skb(dev, pkt_len + 2);
-				if (skb == NULL) {
+				if (!skb) {
 					for( i = 0; i < RX_RING_SIZE; i++ )
 						if (MEM->rx_head[(entry+i) & RX_RING_MOD_MASK].flag &
 							RMD1_OWN_CHIP)
diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 81d5af00d30d..c5cec4e79489 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -786,7 +786,7 @@ static int au1000_rx(struct net_device *dev)
 			frmlen = (status & RX_FRAME_LEN_MASK);
 			frmlen -= 4; /* Remove FCS */
 			skb = netdev_alloc_skb(dev, frmlen + 2);
-			if (skb == NULL) {
+			if (!skb) {
 				dev->stats.rx_dropped++;
 				continue;
 			}
@@ -1199,7 +1199,7 @@ static int au1000_probe(struct platform_device *pdev)
 	}
 
 	aup->mii_bus = mdiobus_alloc();
-	if (aup->mii_bus == NULL) {
+	if (!aup->mii_bus) {
 		dev_err(&pdev->dev, "failed to allocate mdiobus structure\n");
 		err = -ENOMEM;
 		goto err_mdiobus_alloc;
@@ -1284,7 +1284,7 @@ static int au1000_probe(struct platform_device *pdev)
 	return 0;
 
 err_out:
-	if (aup->mii_bus != NULL)
+	if (aup->mii_bus)
 		mdiobus_unregister(aup->mii_bus);
 
 	/* here we should have a valid dev plus aup-> register addresses
diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
index 462016666752..fb8686214a32 100644
--- a/drivers/net/ethernet/amd/lance.c
+++ b/drivers/net/ethernet/amd/lance.c
@@ -880,7 +880,7 @@ lance_init_ring(struct net_device *dev, gfp_t gfp)
 			rx_buff = skb->data;
 		else
 			rx_buff = kmalloc(PKT_BUF_SZ, GFP_DMA | gfp);
-		if (rx_buff == NULL)
+		if (!rx_buff)
 			lp->rx_ring[i].base = 0;
 		else
 			lp->rx_ring[i].base = (u32)isa_virt_to_bus(rx_buff) | 0x80000000;
@@ -1186,7 +1186,7 @@ lance_rx(struct net_device *dev)
 			else
 			{
 				skb = dev_alloc_skb(pkt_len+2);
-				if (skb == NULL)
+				if (!skb)
 				{
 					printk("%s: Memory squeeze, deferring packet.\n", dev->name);
 					for (i=0; i < RX_RING_SIZE; i++)
diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
index df8874bd619a..684b412c77fd 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -918,7 +918,7 @@ static irqreturn_t mace_interrupt(int irq, void *dev_id)
   int status;
   int IntrCnt = MACE_MAX_IR_ITERATIONS;
 
-  if (dev == NULL) {
+  if (!dev) {
     pr_debug("mace_interrupt(): irq 0x%X for unknown device.\n",
 	  irq);
     return IRQ_NONE;
@@ -1102,7 +1102,7 @@ static int mace_rx(struct net_device *dev, unsigned char RxCnt)
 
       skb = netdev_alloc_skb(dev, pkt_len + 2);
 
-      if (skb != NULL) {
+      if (skb) {
 	skb_reserve(skb, 2);
 	insw(ioaddr + AM2150_RCV, skb_put(skb, pkt_len), pkt_len>>1);
 	if (pkt_len & 1)
diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index c9138175ec07..72db9f9e7bee 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -488,7 +488,7 @@ static void pcnet32_realloc_tx_ring(struct net_device *dev,
 		dma_alloc_coherent(&lp->pci_dev->dev,
 				   sizeof(struct pcnet32_tx_head) * entries,
 				   &new_ring_dma_addr, GFP_ATOMIC);
-	if (new_tx_ring == NULL)
+	if (!new_tx_ring)
 		return;
 
 	new_dma_addr_list = kcalloc(entries, sizeof(dma_addr_t), GFP_ATOMIC);
@@ -547,7 +547,7 @@ static void pcnet32_realloc_rx_ring(struct net_device *dev,
 		dma_alloc_coherent(&lp->pci_dev->dev,
 				   sizeof(struct pcnet32_rx_head) * entries,
 				   &new_ring_dma_addr, GFP_ATOMIC);
-	if (new_rx_ring == NULL)
+	if (!new_rx_ring)
 		return;
 
 	new_dma_addr_list = kcalloc(entries, sizeof(dma_addr_t), GFP_ATOMIC);
@@ -1249,7 +1249,7 @@ static void pcnet32_rx_entry(struct net_device *dev,
 	} else
 		skb = netdev_alloc_skb(dev, pkt_len + NET_IP_ALIGN);
 
-	if (skb == NULL) {
+	if (!skb) {
 		dev->stats.rx_dropped++;
 		return;
 	}
@@ -2018,7 +2018,7 @@ static int pcnet32_alloc_ring(struct net_device *dev, const char *name)
 	lp->tx_ring = dma_alloc_coherent(&lp->pci_dev->dev,
 					 sizeof(struct pcnet32_tx_head) * lp->tx_ring_size,
 					 &lp->tx_ring_dma_addr, GFP_KERNEL);
-	if (lp->tx_ring == NULL) {
+	if (!lp->tx_ring) {
 		netif_err(lp, drv, dev, "Coherent memory allocation failed\n");
 		return -ENOMEM;
 	}
@@ -2026,7 +2026,7 @@ static int pcnet32_alloc_ring(struct net_device *dev, const char *name)
 	lp->rx_ring = dma_alloc_coherent(&lp->pci_dev->dev,
 					 sizeof(struct pcnet32_rx_head) * lp->rx_ring_size,
 					 &lp->rx_ring_dma_addr, GFP_KERNEL);
-	if (lp->rx_ring == NULL) {
+	if (!lp->rx_ring) {
 		netif_err(lp, drv, dev, "Coherent memory allocation failed\n");
 		return -ENOMEM;
 	}
@@ -2365,7 +2365,7 @@ static int pcnet32_init_ring(struct net_device *dev)
 
 	for (i = 0; i < lp->rx_ring_size; i++) {
 		struct sk_buff *rx_skbuff = lp->rx_skbuff[i];
-		if (rx_skbuff == NULL) {
+		if (!rx_skbuff) {
 			lp->rx_skbuff[i] = netdev_alloc_skb(dev, PKT_BUF_SKB);
 			rx_skbuff = lp->rx_skbuff[i];
 			if (!rx_skbuff) {
diff --git a/drivers/net/ethernet/amd/sun3lance.c b/drivers/net/ethernet/amd/sun3lance.c
index 007bd7787291..246f34c43765 100644
--- a/drivers/net/ethernet/amd/sun3lance.c
+++ b/drivers/net/ethernet/amd/sun3lance.c
@@ -341,7 +341,7 @@ static int __init lance_probe( struct net_device *dev)
 
 	/* XXX - leak? */
 	MEM = dvma_malloc_align(sizeof(struct lance_memory), 0x10000);
-	if (MEM == NULL) {
+	if (!MEM) {
 #ifdef CONFIG_SUN3
 		iounmap((void __iomem *)ioaddr);
 #endif
@@ -796,7 +796,7 @@ static int lance_rx( struct net_device *dev )
 			}
 			else {
 				skb = netdev_alloc_skb(dev, pkt_len + 2);
-				if (skb == NULL) {
+				if (!skb) {
 					dev->stats.rx_dropped++;
 					head->msg_length = 0;
 					head->flag |= RMD1_OWN_CHIP;
diff --git a/drivers/net/ethernet/amd/sunlance.c b/drivers/net/ethernet/amd/sunlance.c
index 4ed2ebbf9ff7..68ca1225eedc 100644
--- a/drivers/net/ethernet/amd/sunlance.c
+++ b/drivers/net/ethernet/amd/sunlance.c
@@ -530,7 +530,7 @@ static void lance_rx_dvma(struct net_device *dev)
 			len = (rd->mblength & 0xfff) - 4;
 			skb = netdev_alloc_skb(dev, len + 2);
 
-			if (skb == NULL) {
+			if (!skb) {
 				dev->stats.rx_dropped++;
 				rd->mblength = 0;
 				rd->rmd1_bits = LE_R1_OWN;
@@ -700,7 +700,7 @@ static void lance_rx_pio(struct net_device *dev)
 			len = (sbus_readw(&rd->mblength) & 0xfff) - 4;
 			skb = netdev_alloc_skb(dev, len + 2);
 
-			if (skb == NULL) {
+			if (!skb) {
 				dev->stats.rx_dropped++;
 				sbus_writew(0, &rd->mblength);
 				sbus_writeb(LE_R1_OWN, &rd->rmd1_bits);
-- 
2.30.0

