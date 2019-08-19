Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F182294A2E
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbfHSQdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:33:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:55542 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727957AbfHSQcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:32:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1D557B620;
        Mon, 19 Aug 2019 16:32:05 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH v5 12/17] net: sgi: ioc3-eth: use dma-direct for dma allocations
Date:   Mon, 19 Aug 2019 18:31:35 +0200
Message-Id: <20190819163144.3478-13-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190819163144.3478-1-tbogendoerfer@suse.de>
References: <20190819163144.3478-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the homegrown DMA memory allocation, which only works on
SGI-IP27 machines, with the generic dma allocations.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 107 ++++++++++++++++++++++++++----------
 1 file changed, 77 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 7f85a3bfef14..647e3926bd71 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -38,7 +38,6 @@
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
-#include <linux/dma-mapping.h>
 #include <linux/gfp.h>
 
 #ifdef CONFIG_SERIAL_8250
@@ -51,6 +50,8 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
+#include <linux/dma-direct.h>
+
 #include <net/ip.h>
 
 #include <asm/byteorder.h>
@@ -66,10 +67,12 @@
 #define RX_BUFFS		64
 #define RX_RING_ENTRIES		512		/* fixed in hardware */
 #define RX_RING_MASK		(RX_RING_ENTRIES - 1)
+#define RX_RING_SIZE		(RX_RING_ENTRIES * sizeof(u64))
 
 /* 128 TX buffers (not tunable) */
 #define TX_RING_ENTRIES		128
 #define TX_RING_MASK		(TX_RING_ENTRIES - 1)
+#define TX_RING_SIZE		(TX_RING_ENTRIES * sizeof(struct ioc3_etxd))
 
 /* BEWARE: The IOC3 documentation documents the size of rx buffers as
  * 1644 while it's actually 1664.  This one was nasty to track down...
@@ -84,9 +87,12 @@
 struct ioc3_private {
 	struct ioc3_ethregs *regs;
 	struct ioc3 *all_regs;
+	struct device *dma_dev;
 	u32 *ssram;
 	unsigned long *rxr;		/* pointer to receiver ring */
 	struct ioc3_etxd *txr;
+	dma_addr_t rxr_dma;
+	dma_addr_t txr_dma;
 	struct sk_buff *rx_skbs[RX_RING_ENTRIES];
 	struct sk_buff *tx_skbs[TX_RING_ENTRIES];
 	int rx_ci;			/* RX consumer index */
@@ -116,18 +122,22 @@ static void ioc3_init(struct net_device *dev);
 static const char ioc3_str[] = "IOC3 Ethernet";
 static const struct ethtool_ops ioc3_ethtool_ops;
 
-static inline unsigned long ioc3_map(void *ptr, unsigned long vdev)
+#ifdef CONFIG_PCI_XTALK_BRIDGE
+static inline unsigned long ioc3_map(dma_addr_t addr, unsigned long attr)
 {
-#ifdef CONFIG_SGI_IP27
-	vdev <<= 57;   /* Shift to PCI64_ATTR_VIRTUAL */
+	return (addr & ~PCI64_ATTR_BAR) | attr;
+}
 
-	return vdev | (0xaUL << PCI64_ATTR_TARG_SHFT) | PCI64_ATTR_PREF |
-	       ((unsigned long)ptr & TO_PHYS_MASK);
+#define ERBAR_VAL	(ERBAR_BARRIER_BIT << ERBAR_RXBARR_SHIFT)
 #else
-	return virt_to_bus(ptr);
-#endif
+static inline unsigned long ioc3_map(dma_addr_t addr, unsigned long attr)
+{
+	return addr;
 }
 
+#define ERBAR_VAL	0
+#endif
+
 #define IOC3_SIZE 0x100000
 
 static inline u32 mcr_pack(u32 pulse, u32 sample)
@@ -494,6 +504,7 @@ static inline void ioc3_rx(struct net_device *dev)
 	int rx_entry, n_entry, len;
 	struct ioc3_erxbuf *rxb;
 	unsigned long *rxr;
+	dma_addr_t d;
 	u32 w0, err;
 
 	rxr = ip->rxr;		/* Ring base */
@@ -550,7 +561,9 @@ static inline void ioc3_rx(struct net_device *dev)
 			dev->stats.rx_frame_errors++;
 next:
 		ip->rx_skbs[n_entry] = new_skb;
-		rxr[n_entry] = cpu_to_be64(ioc3_map(rxb, 1));
+		d = dma_map_single(ip->dma_dev, rxb, RX_BUF_SIZE,
+				   DMA_FROM_DEVICE);
+		rxr[n_entry] = cpu_to_be64(ioc3_map(d, PCI64_ATTR_BAR));
 		rxb->w0 = 0;				/* Clear valid flag */
 		n_entry = (n_entry + 1) & RX_RING_MASK;	/* Update erpir */
 
@@ -754,6 +767,26 @@ static inline void ioc3_clean_rx_ring(struct ioc3_private *ip)
 	}
 }
 
+static inline void ioc3_tx_unmap(struct ioc3_private *ip, int entry)
+{
+	struct ioc3_etxd *desc;
+	u32 cmd, bufcnt, len;
+
+	desc = &ip->txr[entry];
+	cmd = be32_to_cpu(desc->cmd);
+	bufcnt = be32_to_cpu(desc->bufcnt);
+	if (cmd & ETXD_B1V) {
+		len = (bufcnt & ETXD_B1CNT_MASK) >> ETXD_B1CNT_SHIFT;
+		dma_unmap_single(ip->dma_dev, be64_to_cpu(desc->p1),
+				 len, DMA_TO_DEVICE);
+	}
+	if (cmd & ETXD_B2V) {
+		len = (bufcnt & ETXD_B2CNT_MASK) >> ETXD_B2CNT_SHIFT;
+		dma_unmap_single(ip->dma_dev, be64_to_cpu(desc->p2),
+				 len, DMA_TO_DEVICE);
+	}
+}
+
 static inline void ioc3_clean_tx_ring(struct ioc3_private *ip)
 {
 	struct sk_buff *skb;
@@ -762,6 +795,7 @@ static inline void ioc3_clean_tx_ring(struct ioc3_private *ip)
 	for (i = 0; i < TX_RING_ENTRIES; i++) {
 		skb = ip->tx_skbs[i];
 		if (skb) {
+			ioc3_tx_unmap(ip, i);
 			ip->tx_skbs[i] = NULL;
 			dev_kfree_skb_any(skb);
 		}
@@ -778,7 +812,8 @@ static void ioc3_free_rings(struct ioc3_private *ip)
 
 	if (ip->txr) {
 		ioc3_clean_tx_ring(ip);
-		free_pages((unsigned long)ip->txr, 2);
+		dma_direct_free_pages(ip->dma_dev, TX_RING_SIZE, ip->txr,
+				      ip->txr_dma, 0);
 		ip->txr = NULL;
 	}
 
@@ -788,12 +823,17 @@ static void ioc3_free_rings(struct ioc3_private *ip)
 
 		while (n_entry != rx_entry) {
 			skb = ip->rx_skbs[n_entry];
-			if (skb)
+			if (skb) {
+				dma_unmap_single(ip->dma_dev,
+						 be64_to_cpu(ip->rxr[n_entry]),
+						 RX_BUF_SIZE, DMA_FROM_DEVICE);
 				dev_kfree_skb_any(skb);
+			}
 
 			n_entry = (n_entry + 1) & RX_RING_MASK;
 		}
-		free_page((unsigned long)ip->rxr);
+		dma_direct_free_pages(ip->dma_dev, RX_RING_SIZE, ip->rxr,
+				      ip->rxr_dma, 0);
 		ip->rxr = NULL;
 	}
 }
@@ -801,16 +841,19 @@ static void ioc3_free_rings(struct ioc3_private *ip)
 static void ioc3_alloc_rings(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
-	struct ioc3_erxbuf *rxb;
 	unsigned long *rxr;
+	dma_addr_t rxb;
 	int i;
 
 	if (!ip->rxr) {
 		/* Allocate and initialize rx ring.  4kb = 512 entries  */
-		ip->rxr = (unsigned long *)get_zeroed_page(GFP_ATOMIC);
+		ip->rxr = dma_direct_alloc_pages(ip->dma_dev, RX_RING_SIZE,
+						 &ip->rxr_dma, GFP_ATOMIC, 0);
 		rxr = ip->rxr;
-		if (!rxr)
+		if (!rxr) {
 			pr_err("%s: get_zeroed_page() failed!\n", __func__);
+			return;
+		}
 
 		/* Now the rx buffers.  The RX ring may be larger but
 		 * we only allocate 16 buffers for now.  Need to tune
@@ -828,8 +871,9 @@ static void ioc3_alloc_rings(struct net_device *dev)
 
 			ip->rx_skbs[i] = skb;
 
-			rxb = (struct ioc3_erxbuf *)skb->data;
-			rxr[i] = cpu_to_be64(ioc3_map(rxb, 1));
+			rxb = dma_map_single(ip->dma_dev, skb->data,
+					     RX_BUF_SIZE, DMA_BIDIRECTIONAL);
+			rxr[i] = cpu_to_be64(ioc3_map(rxb, PCI64_ATTR_BAR));
 			skb_reserve(skb, RX_OFFSET);
 		}
 		ip->rx_ci = 0;
@@ -838,7 +882,9 @@ static void ioc3_alloc_rings(struct net_device *dev)
 
 	if (!ip->txr) {
 		/* Allocate and initialize tx rings.  16kb = 128 bufs.  */
-		ip->txr = (struct ioc3_etxd *)__get_free_pages(GFP_KERNEL, 2);
+		ip->txr = dma_direct_alloc_pages(ip->dma_dev, TX_RING_SIZE,
+						 &ip->txr_dma,
+						 GFP_KERNEL | __GFP_ZERO, 0);
 		if (!ip->txr)
 			pr_err("%s: __get_free_pages() failed!\n", __func__);
 		ip->tx_pi = 0;
@@ -859,13 +905,13 @@ static void ioc3_init_rings(struct net_device *dev)
 	ioc3_clean_tx_ring(ip);
 
 	/* Now the rx ring base, consume & produce registers.  */
-	ring = ioc3_map(ip->rxr, 0);
+	ring = ioc3_map(ip->rxr_dma, PCI64_ATTR_PREC);
 	writel(ring >> 32, &regs->erbr_h);
 	writel(ring & 0xffffffff, &regs->erbr_l);
 	writel(ip->rx_ci << 3, &regs->ercir);
 	writel((ip->rx_pi << 3) | ERPIR_ARM, &regs->erpir);
 
-	ring = ioc3_map(ip->txr, 0);
+	ring = ioc3_map(ip->txr_dma, PCI64_ATTR_PREC);
 
 	ip->txqlen = 0;					/* nothing queued  */
 
@@ -915,13 +961,7 @@ static void ioc3_init(struct net_device *dev)
 	readl(&regs->emcr);
 
 	/* Misc registers  */
-#ifdef CONFIG_SGI_IP27
-	/* Barrier on last store */
-	writel(PCI64_ATTR_BAR >> 32, &regs->erbar);
-#else
-	/* Let PCI API get it right */
-	writel(0, &regs->erbar);
-#endif
+	writel(ERBAR_VAL, &regs->erbar);
 	readl(&regs->etcdc);			/* Clear on read */
 	writel(15, &regs->ercsr);		/* RX low watermark  */
 	writel(0, &regs->ertr);			/* Interrupt immediately */
@@ -1187,6 +1227,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ip = netdev_priv(dev);
 	ip->dev = dev;
+	ip->dma_dev = &pdev->dev;
 
 	dev->irq = pdev->irq;
 
@@ -1386,18 +1427,24 @@ static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		unsigned long b2 = (data | 0x3fffUL) + 1UL;
 		unsigned long s1 = b2 - data;
 		unsigned long s2 = data + len - b2;
+		dma_addr_t d;
 
 		desc->cmd    = cpu_to_be32(len | ETXD_INTWHENDONE |
 					   ETXD_B1V | ETXD_B2V | w0);
 		desc->bufcnt = cpu_to_be32((s1 << ETXD_B1CNT_SHIFT) |
 					   (s2 << ETXD_B2CNT_SHIFT));
-		desc->p1     = cpu_to_be64(ioc3_map(skb->data, 1));
-		desc->p2     = cpu_to_be64(ioc3_map((void *)b2, 1));
+		d = dma_map_single(ip->dma_dev, skb->data, s1, DMA_TO_DEVICE);
+		desc->p1     = cpu_to_be64(ioc3_map(d, PCI64_ATTR_PREF));
+		d = dma_map_single(ip->dma_dev, (void *)b2, s1, DMA_TO_DEVICE);
+		desc->p2     = cpu_to_be64(ioc3_map(d, PCI64_ATTR_PREF));
 	} else {
+		dma_addr_t d;
+
 		/* Normal sized packet that doesn't cross a page boundary. */
 		desc->cmd = cpu_to_be32(len | ETXD_INTWHENDONE | ETXD_B1V | w0);
 		desc->bufcnt = cpu_to_be32(len << ETXD_B1CNT_SHIFT);
-		desc->p1     = cpu_to_be64(ioc3_map(skb->data, 1));
+		d = dma_map_single(ip->dma_dev, skb->data, len, DMA_TO_DEVICE);
+		desc->p1     = cpu_to_be64(ioc3_map(d, PCI64_ATTR_PREF));
 	}
 
 	mb(); /* make sure all descriptor changes are visible */
-- 
2.13.7

