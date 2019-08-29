Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4879A1FC8
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 17:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbfH2Puj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 11:50:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:60980 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728238AbfH2Pug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 11:50:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3CCA4B626;
        Thu, 29 Aug 2019 15:50:34 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 03/15] net: sgi: ioc3-eth: remove checkpatch errors/warning
Date:   Thu, 29 Aug 2019 17:50:01 +0200
Message-Id: <20190829155014.9229-4-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190829155014.9229-1-tbogendoerfer@suse.de>
References: <20190829155014.9229-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before massaging the driver further fix oddities found by checkpatch like
- wrong indention
- comment formatting
- use of printk instead or netdev_xxx/pr_xxx

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 275 +++++++++++++++++-------------------
 1 file changed, 130 insertions(+), 145 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 713d2472cb97..51cc1389e204 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -1,9 +1,5 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Driver for SGI's IOC3 based Ethernet cards as found in the PCI card.
+// SPDX-License-Identifier: GPL-2.0
+/* Driver for SGI's IOC3 based Ethernet cards as found in the PCI card.
  *
  * Copyright (C) 1999, 2000, 01, 03, 06 Ralf Baechle
  * Copyright (C) 1995, 1999, 2000, 2001 by Silicon Graphics, Inc.
@@ -39,6 +35,7 @@
 #include <linux/crc32.h>
 #include <linux/mii.h>
 #include <linux/in.h>
+#include <linux/io.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
@@ -58,21 +55,19 @@
 #include <net/ip.h>
 
 #include <asm/byteorder.h>
-#include <asm/io.h>
 #include <asm/pgtable.h>
 #include <linux/uaccess.h>
 #include <asm/sn/types.h>
 #include <asm/sn/ioc3.h>
 #include <asm/pci/bridge.h>
 
-/*
- * 64 RX buffers.  This is tunable in the range of 16 <= x < 512.  The
+/* 64 RX buffers.  This is tunable in the range of 16 <= x < 512.  The
  * value must be a power of two.
  */
 #define RX_BUFFS 64
 
-#define ETCSR_FD	((17<<ETCSR_IPGR2_SHIFT) | (11<<ETCSR_IPGR1_SHIFT) | 21)
-#define ETCSR_HD	((21<<ETCSR_IPGR2_SHIFT) | (21<<ETCSR_IPGR1_SHIFT) | 21)
+#define ETCSR_FD   ((17 << ETCSR_IPGR2_SHIFT) | (11 << ETCSR_IPGR1_SHIFT) | 21)
+#define ETCSR_HD   ((21 << ETCSR_IPGR2_SHIFT) | (21 << ETCSR_IPGR1_SHIFT) | 21)
 
 /* Private per NIC data of the driver.  */
 struct ioc3_private {
@@ -119,14 +114,15 @@ static inline unsigned long aligned_rx_skb_addr(unsigned long addr)
 	return (~addr + 1) & (IOC3_CACHELINE - 1UL);
 }
 
-static inline struct sk_buff * ioc3_alloc_skb(unsigned long length,
-	unsigned int gfp_mask)
+static inline struct sk_buff *ioc3_alloc_skb(unsigned long length,
+					     unsigned int gfp_mask)
 {
 	struct sk_buff *skb;
 
 	skb = alloc_skb(length + IOC3_CACHELINE - 1, gfp_mask);
 	if (likely(skb)) {
-		int offset = aligned_rx_skb_addr((unsigned long) skb->data);
+		int offset = aligned_rx_skb_addr((unsigned long)skb->data);
+
 		if (offset)
 			skb_reserve(skb, offset);
 	}
@@ -147,15 +143,11 @@ static inline unsigned long ioc3_map(void *ptr, unsigned long vdev)
 }
 
 /* BEWARE: The IOC3 documentation documents the size of rx buffers as
-   1644 while it's actually 1664.  This one was nasty to track down ...  */
+ * 1644 while it's actually 1664.  This one was nasty to track down ...
+ */
 #define RX_OFFSET		10
 #define RX_BUF_ALLOC_SIZE	(1664 + RX_OFFSET + IOC3_CACHELINE)
 
-/* DMA barrier to separate cached and uncached accesses.  */
-#define BARRIER()							\
-	__asm__("sync" ::: "memory")
-
-
 #define IOC3_SIZE 0x100000
 
 static inline u32 mcr_pack(u32 pulse, u32 sample)
@@ -176,7 +168,7 @@ static int nic_wait(u32 __iomem *mcr)
 
 static int nic_reset(u32 __iomem *mcr)
 {
-        int presence;
+	int presence;
 
 	writel(mcr_pack(500, 65), mcr);
 	presence = nic_wait(mcr);
@@ -184,7 +176,7 @@ static int nic_reset(u32 __iomem *mcr)
 	writel(mcr_pack(0, 500), mcr);
 	nic_wait(mcr);
 
-        return presence;
+	return presence;
 }
 
 static inline int nic_read_bit(u32 __iomem *mcr)
@@ -209,8 +201,7 @@ static inline void nic_write_bit(u32 __iomem *mcr, int bit)
 	nic_wait(mcr);
 }
 
-/*
- * Read a byte from an iButton device
+/* Read a byte from an iButton device
  */
 static u32 nic_read_byte(u32 __iomem *mcr)
 {
@@ -223,8 +214,7 @@ static u32 nic_read_byte(u32 __iomem *mcr)
 	return result;
 }
 
-/*
- * Write a byte to an iButton device
+/* Write a byte to an iButton device
  */
 static void nic_write_byte(u32 __iomem *mcr, int byte)
 {
@@ -253,7 +243,7 @@ static u64 nic_find(u32 __iomem *mcr, int *last)
 		b = nic_read_bit(mcr);
 
 		if (a && b) {
-			printk("NIC search failed (not fatal).\n");
+			pr_warn("NIC search failed (not fatal).\n");
 			*last = 0;
 			return 0;
 		}
@@ -264,8 +254,9 @@ static u64 nic_find(u32 __iomem *mcr, int *last)
 			} else if (index > *last) {
 				address &= ~(1UL << index);
 				disc = index;
-			} else if ((address & (1UL << index)) == 0)
+			} else if ((address & (1UL << index)) == 0) {
 				disc = index;
+			}
 			nic_write_bit(mcr, address & (1UL << index));
 			continue;
 		} else {
@@ -293,6 +284,7 @@ static int nic_init(u32 __iomem *mcr)
 
 	while (1) {
 		u64 reg;
+
 		reg = nic_find(mcr, &save);
 
 		switch (reg & 0xff) {
@@ -323,16 +315,15 @@ static int nic_init(u32 __iomem *mcr)
 		break;
 	}
 
-	printk("Found %s NIC", type);
+	pr_info("Found %s NIC", type);
 	if (type != unknown)
-		printk (" registration number %pM, CRC %02x", serial, crc);
-	printk(".\n");
+		pr_cont(" registration number %pM, CRC %02x", serial, crc);
+	pr_cont(".\n");
 
 	return 0;
 }
 
-/*
- * Read the NIC (Number-In-a-Can) device used to store the MAC address on
+/* Read the NIC (Number-In-a-Can) device used to store the MAC address on
  * SN0 / SN00 nodeboards and PCI cards.
  */
 static void ioc3_get_eaddr_nic(struct ioc3_private *ip)
@@ -351,7 +342,7 @@ static void ioc3_get_eaddr_nic(struct ioc3_private *ip)
 	}
 
 	if (tries < 0) {
-		printk("Failed to read MAC address\n");
+		pr_err("Failed to read MAC address\n");
 		return;
 	}
 
@@ -367,8 +358,7 @@ static void ioc3_get_eaddr_nic(struct ioc3_private *ip)
 		ip->dev->dev_addr[i - 2] = nic[i];
 }
 
-/*
- * Ok, this is hosed by design.  It's necessary to know what machine the
+/* Ok, this is hosed by design.  It's necessary to know what machine the
  * NIC is in in order to know how to read the NIC address.  We also have
  * to know if it's a PCI card or a NIC in on the node board ...
  */
@@ -376,7 +366,7 @@ static void ioc3_get_eaddr(struct ioc3_private *ip)
 {
 	ioc3_get_eaddr_nic(ip);
 
-	printk("Ethernet address is %pM.\n", ip->dev->dev_addr);
+	pr_info("Ethernet address is %pM.\n", ip->dev->dev_addr);
 }
 
 static void __ioc3_set_mac_address(struct net_device *dev)
@@ -407,8 +397,7 @@ static int ioc3_set_mac_address(struct net_device *dev, void *addr)
 	return 0;
 }
 
-/*
- * Caller must hold the ioc3_lock ever for MII readers.  This is also
+/* Caller must hold the ioc3_lock ever for MII readers.  This is also
  * used to protect the transmitter side but it's low contention.
  */
 static int ioc3_mdio_read(struct net_device *dev, int phy, int reg)
@@ -450,17 +439,16 @@ static struct net_device_stats *ioc3_get_stats(struct net_device *dev)
 	return &dev->stats;
 }
 
-static void ioc3_tcpudp_checksum(struct sk_buff *skb, uint32_t hwsum, int len)
+static void ioc3_tcpudp_checksum(struct sk_buff *skb, u32 hwsum, int len)
 {
 	struct ethhdr *eh = eth_hdr(skb);
-	uint32_t csum, ehsum;
 	unsigned int proto;
-	struct iphdr *ih;
-	uint16_t *ew;
 	unsigned char *cp;
+	struct iphdr *ih;
+	u32 csum, ehsum;
+	u16 *ew;
 
-	/*
-	 * Did hardware handle the checksum at all?  The cases we can handle
+	/* Did hardware handle the checksum at all?  The cases we can handle
 	 * are:
 	 *
 	 * - TCP and UDP checksums of IPv4 only.
@@ -476,7 +464,7 @@ static void ioc3_tcpudp_checksum(struct sk_buff *skb, uint32_t hwsum, int len)
 	if (eh->h_proto != htons(ETH_P_IP))
 		return;
 
-	ih = (struct iphdr *) ((char *)eh + ETH_HLEN);
+	ih = (struct iphdr *)((char *)eh + ETH_HLEN);
 	if (ip_is_fragment(ih))
 		return;
 
@@ -487,12 +475,12 @@ static void ioc3_tcpudp_checksum(struct sk_buff *skb, uint32_t hwsum, int len)
 	/* Same as tx - compute csum of pseudo header  */
 	csum = hwsum +
 	       (ih->tot_len - (ih->ihl << 2)) +
-	       htons((uint16_t)ih->protocol) +
+	       htons((u16)ih->protocol) +
 	       (ih->saddr >> 16) + (ih->saddr & 0xffff) +
 	       (ih->daddr >> 16) + (ih->daddr & 0xffff);
 
 	/* Sum up ethernet dest addr, src addr and protocol  */
-	ew = (uint16_t *) eh;
+	ew = (u16 *)eh;
 	ehsum = ew[0] + ew[1] + ew[2] + ew[3] + ew[4] + ew[5] + ew[6];
 
 	ehsum = (ehsum & 0xffff) + (ehsum >> 16);
@@ -501,14 +489,15 @@ static void ioc3_tcpudp_checksum(struct sk_buff *skb, uint32_t hwsum, int len)
 	csum += 0xffff ^ ehsum;
 
 	/* In the next step we also subtract the 1's complement
-	   checksum of the trailing ethernet CRC.  */
+	 * checksum of the trailing ethernet CRC.
+	 */
 	cp = (char *)eh + len;	/* points at trailing CRC */
 	if (len & 1) {
-		csum += 0xffff ^ (uint16_t) ((cp[1] << 8) | cp[0]);
-		csum += 0xffff ^ (uint16_t) ((cp[3] << 8) | cp[2]);
+		csum += 0xffff ^ (u16)((cp[1] << 8) | cp[0]);
+		csum += 0xffff ^ (u16)((cp[3] << 8) | cp[2]);
 	} else {
-		csum += 0xffff ^ (uint16_t) ((cp[0] << 8) | cp[1]);
-		csum += 0xffff ^ (uint16_t) ((cp[2] << 8) | cp[3]);
+		csum += 0xffff ^ (u16)((cp[0] << 8) | cp[1]);
+		csum += 0xffff ^ (u16)((cp[2] << 8) | cp[3]);
 	}
 
 	csum = (csum & 0xffff) + (csum >> 16);
@@ -532,7 +521,7 @@ static inline void ioc3_rx(struct net_device *dev)
 	n_entry = ip->rx_pi;
 
 	skb = ip->rx_skbs[rx_entry];
-	rxb = (struct ioc3_erxbuf *) (skb->data - RX_OFFSET);
+	rxb = (struct ioc3_erxbuf *)(skb->data - RX_OFFSET);
 	w0 = be32_to_cpu(rxb->w0);
 
 	while (w0 & ERXBUF_V) {
@@ -545,7 +534,8 @@ static inline void ioc3_rx(struct net_device *dev)
 			new_skb = ioc3_alloc_skb(RX_BUF_ALLOC_SIZE, GFP_ATOMIC);
 			if (!new_skb) {
 				/* Ouch, drop packet and just recycle packet
-				   to keep the ring filled.  */
+				 * to keep the ring filled.
+				 */
 				dev->stats.rx_dropped++;
 				new_skb = skb;
 				goto next;
@@ -553,7 +543,8 @@ static inline void ioc3_rx(struct net_device *dev)
 
 			if (likely(dev->features & NETIF_F_RXCSUM))
 				ioc3_tcpudp_checksum(skb,
-					w0 & ERXBUF_IPCKSUM_MASK, len);
+						     w0 & ERXBUF_IPCKSUM_MASK,
+						     len);
 
 			netif_rx(skb);
 
@@ -561,15 +552,16 @@ static inline void ioc3_rx(struct net_device *dev)
 
 			/* Because we reserve afterwards. */
 			skb_put(new_skb, (1664 + RX_OFFSET));
-			rxb = (struct ioc3_erxbuf *) new_skb->data;
+			rxb = (struct ioc3_erxbuf *)new_skb->data;
 			skb_reserve(new_skb, RX_OFFSET);
 
 			dev->stats.rx_packets++;		/* Statistics */
 			dev->stats.rx_bytes += len;
 		} else {
 			/* The frame is invalid and the skb never
-			   reached the network layer so we can just
-			   recycle it.  */
+			 * reached the network layer so we can just
+			 * recycle it.
+			 */
 			new_skb = skb;
 			dev->stats.rx_errors++;
 		}
@@ -586,7 +578,7 @@ static inline void ioc3_rx(struct net_device *dev)
 		/* Now go on to the next ring entry.  */
 		rx_entry = (rx_entry + 1) & 511;
 		skb = ip->rx_skbs[rx_entry];
-		rxb = (struct ioc3_erxbuf *) (skb->data - RX_OFFSET);
+		rxb = (struct ioc3_erxbuf *)(skb->data - RX_OFFSET);
 		w0 = be32_to_cpu(rxb->w0);
 	}
 	writel((n_entry << 3) | ERPIR_ARM, &ip->regs->erpir);
@@ -635,8 +627,7 @@ static inline void ioc3_tx(struct net_device *dev)
 	spin_unlock(&ip->ioc3_lock);
 }
 
-/*
- * Deal with fatal IOC3 errors.  This condition might be caused by a hard or
+/* Deal with fatal IOC3 errors.  This condition might be caused by a hard or
  * software problems, so we should try to recover
  * more gracefully if this ever happens.  In theory we might be flooded
  * with such error interrupts if something really goes wrong, so we might
@@ -645,22 +636,21 @@ static inline void ioc3_tx(struct net_device *dev)
 static void ioc3_error(struct net_device *dev, u32 eisr)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
-	unsigned char *iface = dev->name;
 
 	spin_lock(&ip->ioc3_lock);
 
 	if (eisr & EISR_RXOFLO)
-		printk(KERN_ERR "%s: RX overflow.\n", iface);
+		net_err_ratelimited("%s: RX overflow.\n", dev->name);
 	if (eisr & EISR_RXBUFOFLO)
-		printk(KERN_ERR "%s: RX buffer overflow.\n", iface);
+		net_err_ratelimited("%s: RX buffer overflow.\n", dev->name);
 	if (eisr & EISR_RXMEMERR)
-		printk(KERN_ERR "%s: RX PCI error.\n", iface);
+		net_err_ratelimited("%s: RX PCI error.\n", dev->name);
 	if (eisr & EISR_RXPARERR)
-		printk(KERN_ERR "%s: RX SSRAM parity error.\n", iface);
+		net_err_ratelimited("%s: RX SSRAM parity error.\n", dev->name);
 	if (eisr & EISR_TXBUFUFLO)
-		printk(KERN_ERR "%s: TX buffer underflow.\n", iface);
+		net_err_ratelimited("%s: TX buffer underflow.\n", dev->name);
 	if (eisr & EISR_TXMEMERR)
-		printk(KERN_ERR "%s: TX PCI error.\n", iface);
+		net_err_ratelimited("%s: TX PCI error.\n", dev->name);
 
 	ioc3_stop(ip);
 	ioc3_init(dev);
@@ -672,7 +662,8 @@ static void ioc3_error(struct net_device *dev, u32 eisr)
 }
 
 /* The interrupt handler does all of the Rx thread work and cleans up
-   after the Tx thread.  */
+ * after the Tx thread.
+ */
 static irqreturn_t ioc3_interrupt(int irq, void *dev_id)
 {
 	struct ioc3_private *ip = netdev_priv(dev_id);
@@ -684,7 +675,7 @@ static irqreturn_t ioc3_interrupt(int irq, void *dev_id)
 	readl(&regs->eisr);				/* Flush */
 
 	if (eisr & (EISR_RXOFLO | EISR_RXBUFOFLO | EISR_RXMEMERR |
-	            EISR_RXPARERR | EISR_TXBUFUFLO | EISR_TXMEMERR))
+		    EISR_RXPARERR | EISR_TXBUFUFLO | EISR_TXMEMERR))
 		ioc3_error(dev_id, eisr);
 	if (eisr & EISR_RXTIMERINT)
 		ioc3_rx(dev_id);
@@ -716,12 +707,11 @@ static void ioc3_timer(struct timer_list *t)
 	mii_check_media(&ip->mii, 1, 0);
 	ioc3_setup_duplex(ip);
 
-	ip->ioc3_timer.expires = jiffies + ((12 * HZ)/10); /* 1.2s */
+	ip->ioc3_timer.expires = jiffies + ((12 * HZ) / 10); /* 1.2s */
 	add_timer(&ip->ioc3_timer);
 }
 
-/*
- * Try to find a PHY.  There is no apparent relation between the MII addresses
+/* Try to find a PHY.  There is no apparent relation between the MII addresses
  * in the SGI documentation and what we find in reality, so we simply probe
  * for the PHY.  It seems IOC3 PHYs usually live on address 31.  One of my
  * onboard IOC3s has the special oddity that probing doesn't seem to find it
@@ -730,8 +720,8 @@ static void ioc3_timer(struct timer_list *t)
  */
 static int ioc3_mii_init(struct ioc3_private *ip)
 {
-	int i, found = 0, res = 0;
 	int ioc3_phy_workaround = 1;
+	int i, found = 0, res = 0;
 	u16 word;
 
 	for (i = 0; i < 32; i++) {
@@ -744,9 +734,9 @@ static int ioc3_mii_init(struct ioc3_private *ip)
 	}
 
 	if (!found) {
-		if (ioc3_phy_workaround)
+		if (ioc3_phy_workaround) {
 			i = 31;
-		else {
+		} else {
 			ip->mii.phy_id = -1;
 			res = -ENODEV;
 			goto out;
@@ -761,12 +751,13 @@ static int ioc3_mii_init(struct ioc3_private *ip)
 
 static void ioc3_mii_start(struct ioc3_private *ip)
 {
-	ip->ioc3_timer.expires = jiffies + (12 * HZ)/10;  /* 1.2 sec. */
+	ip->ioc3_timer.expires = jiffies + (12 * HZ) / 10;  /* 1.2 sec. */
 	add_timer(&ip->ioc3_timer);
 }
 
 static inline void ioc3_clean_rx_ring(struct ioc3_private *ip)
 {
+	struct ioc3_erxbuf *rxb;
 	struct sk_buff *skb;
 	int i;
 
@@ -777,10 +768,9 @@ static inline void ioc3_clean_rx_ring(struct ioc3_private *ip)
 	ip->rx_pi &= 511;
 	ip->rx_ci &= 511;
 
-	for (i = ip->rx_ci; i != ip->rx_pi; i = (i+1) & 511) {
-		struct ioc3_erxbuf *rxb;
+	for (i = ip->rx_ci; i != ip->rx_pi; i = (i + 1) & 511) {
 		skb = ip->rx_skbs[i];
-		rxb = (struct ioc3_erxbuf *) (skb->data - RX_OFFSET);
+		rxb = (struct ioc3_erxbuf *)(skb->data - RX_OFFSET);
 		rxb->w0 = 0;
 	}
 }
@@ -790,7 +780,7 @@ static inline void ioc3_clean_tx_ring(struct ioc3_private *ip)
 	struct sk_buff *skb;
 	int i;
 
-	for (i=0; i < 128; i++) {
+	for (i = 0; i < 128; i++) {
 		skb = ip->tx_skbs[i];
 		if (skb) {
 			ip->tx_skbs[i] = NULL;
@@ -836,16 +826,17 @@ static void ioc3_alloc_rings(struct net_device *dev)
 	unsigned long *rxr;
 	int i;
 
-	if (ip->rxr == NULL) {
+	if (!ip->rxr) {
 		/* Allocate and initialize rx ring.  4kb = 512 entries  */
-		ip->rxr = (unsigned long *) get_zeroed_page(GFP_ATOMIC);
+		ip->rxr = (unsigned long *)get_zeroed_page(GFP_ATOMIC);
 		rxr = ip->rxr;
 		if (!rxr)
-			printk("ioc3_alloc_rings(): get_zeroed_page() failed!\n");
+			pr_err("%s: get_zeroed_page() failed!\n", __func__);
 
 		/* Now the rx buffers.  The RX ring may be larger but
-		   we only allocate 16 buffers for now.  Need to tune
-		   this for performance and memory later.  */
+		 * we only allocate 16 buffers for now.  Need to tune
+		 * this for performance and memory later.
+		 */
 		for (i = 0; i < RX_BUFFS; i++) {
 			struct sk_buff *skb;
 
@@ -859,7 +850,7 @@ static void ioc3_alloc_rings(struct net_device *dev)
 
 			/* Because we reserve afterwards. */
 			skb_put(skb, (1664 + RX_OFFSET));
-			rxb = (struct ioc3_erxbuf *) skb->data;
+			rxb = (struct ioc3_erxbuf *)skb->data;
 			rxr[i] = cpu_to_be64(ioc3_map(rxb, 1));
 			skb_reserve(skb, RX_OFFSET);
 		}
@@ -867,11 +858,11 @@ static void ioc3_alloc_rings(struct net_device *dev)
 		ip->rx_pi = RX_BUFFS;
 	}
 
-	if (ip->txr == NULL) {
+	if (!ip->txr) {
 		/* Allocate and initialize tx rings.  16kb = 128 bufs.  */
 		ip->txr = (struct ioc3_etxd *)__get_free_pages(GFP_KERNEL, 2);
 		if (!ip->txr)
-			printk("ioc3_alloc_rings(): __get_free_pages() failed!\n");
+			pr_err("%s: __get_free_pages() failed!\n", __func__);
 		ip->tx_pi = 0;
 		ip->tx_ci = 0;
 	}
@@ -964,7 +955,7 @@ static void ioc3_init(struct net_device *dev)
 	ioc3_init_rings(dev);
 
 	ip->emcr |= ((RX_OFFSET / 2) << EMCR_RXOFF_SHIFT) | EMCR_TXDMAEN |
-	             EMCR_TXEN | EMCR_RXDMAEN | EMCR_RXEN | EMCR_PADEN;
+		    EMCR_TXEN | EMCR_RXDMAEN | EMCR_RXEN | EMCR_PADEN;
 	writel(ip->emcr, &regs->emcr);
 	writel(EISR_RXTIMERINT | EISR_RXOFLO | EISR_RXBUFOFLO |
 	       EISR_RXMEMERR | EISR_RXPARERR | EISR_TXBUFUFLO |
@@ -986,7 +977,7 @@ static int ioc3_open(struct net_device *dev)
 	struct ioc3_private *ip = netdev_priv(dev);
 
 	if (request_irq(dev->irq, ioc3_interrupt, IRQF_SHARED, ioc3_str, dev)) {
-		printk(KERN_ERR "%s: Can't get irq %d\n", dev->name, dev->irq);
+		netdev_err(dev, "Can't get irq %d\n", dev->irq);
 
 		return -EAGAIN;
 	}
@@ -1015,8 +1006,7 @@ static int ioc3_close(struct net_device *dev)
 	return 0;
 }
 
-/*
- * MENET cards have four IOC3 chips, which are attached to two sets of
+/* MENET cards have four IOC3 chips, which are attached to two sets of
  * PCI slot resources each: the primary connections are on slots
  * 0..3 and the secondaries are on 4..7
  *
@@ -1033,7 +1023,7 @@ static int ioc3_adjacent_is_ioc3(struct pci_dev *pdev, int slot)
 
 	if (dev) {
 		if (dev->vendor == PCI_VENDOR_ID_SGI &&
-			dev->device == PCI_DEVICE_ID_SGI_IOC3)
+		    dev->device == PCI_DEVICE_ID_SGI_IOC3)
 			ret = 1;
 		pci_dev_put(dev);
 	}
@@ -1043,15 +1033,14 @@ static int ioc3_adjacent_is_ioc3(struct pci_dev *pdev, int slot)
 
 static int ioc3_is_menet(struct pci_dev *pdev)
 {
-	return pdev->bus->parent == NULL &&
+	return !pdev->bus->parent &&
 	       ioc3_adjacent_is_ioc3(pdev, 0) &&
 	       ioc3_adjacent_is_ioc3(pdev, 1) &&
 	       ioc3_adjacent_is_ioc3(pdev, 2);
 }
 
 #ifdef CONFIG_SERIAL_8250
-/*
- * Note about serial ports and consoles:
+/* Note about serial ports and consoles:
  * For console output, everyone uses the IOC3 UARTA (offset 0x178)
  * connected to the master node (look in ip27_setup_console() and
  * ip27prom_console_write()).
@@ -1088,16 +1077,16 @@ static void ioc3_8250_register(struct ioc3_uartregs __iomem *uart)
 #define COSMISC_CONSTANT 6
 
 	struct uart_8250_port port = {
-	        .port = {
+		.port = {
 			.irq		= 0,
 			.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
 			.iotype		= UPIO_MEM,
 			.regshift	= 0,
 			.uartclk	= (22000000 << 1) / COSMISC_CONSTANT,
 
-			.membase	= (unsigned char __iomem *) uart,
-			.mapbase	= (unsigned long) uart,
-                }
+			.membase	= (unsigned char __iomem *)uart,
+			.mapbase	= (unsigned long)uart,
+		}
 	};
 	unsigned char lcr;
 
@@ -1113,8 +1102,7 @@ static void ioc3_serial_probe(struct pci_dev *pdev, struct ioc3 *ioc3)
 {
 	u32 sio_iec;
 
-	/*
-	 * We need to recognice and treat the fourth MENET serial as it
+	/* We need to recognice and treat the fourth MENET serial as it
 	 * does not have an SuperIO chip attached to it, therefore attempting
 	 * to access it will result in bus errors.  We call something an
 	 * MENET if PCI slot 0, 1, 2 and 3 of a master PCI bus all have an IOC3
@@ -1125,8 +1113,7 @@ static void ioc3_serial_probe(struct pci_dev *pdev, struct ioc3 *ioc3)
 	if (ioc3_is_menet(pdev) && PCI_SLOT(pdev->devfn) == 3)
 		return;
 
-	/*
-	 * Switch IOC3 to PIO mode.  It probably already was but let's be
+	/* Switch IOC3 to PIO mode.  It probably already was but let's be
 	 * paranoid
 	 */
 	writel(GPCR_UARTA_MODESEL | GPCR_UARTB_MODESEL, &ioc3->gpcr_s);
@@ -1188,15 +1175,15 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pci_using_dac = 1;
 		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (err < 0) {
-			printk(KERN_ERR "%s: Unable to obtain 64 bit DMA "
-			       "for consistent allocations\n", pci_name(pdev));
+			pr_err("%s: Unable to obtain 64 bit DMA for consistent allocations\n",
+			       pci_name(pdev));
 			goto out;
 		}
 	} else {
 		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (err) {
-			printk(KERN_ERR "%s: No usable DMA configuration, "
-			       "aborting.\n", pci_name(pdev));
+			pr_err("%s: No usable DMA configuration, aborting.\n",
+			       pci_name(pdev));
 			goto out;
 		}
 		pci_using_dac = 0;
@@ -1227,9 +1214,9 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ioc3_base = pci_resource_start(pdev, 0);
 	ioc3_size = pci_resource_len(pdev, 0);
-	ioc3 = (struct ioc3 *) ioremap(ioc3_base, ioc3_size);
+	ioc3 = (struct ioc3 *)ioremap(ioc3_base, ioc3_size);
 	if (!ioc3) {
-		printk(KERN_CRIT "ioc3eth(%s): ioremap failed, goodbye.\n",
+		pr_err("ioc3eth(%s): ioremap failed, goodbye.\n",
 		       pci_name(pdev));
 		err = -ENOMEM;
 		goto out_res;
@@ -1259,7 +1246,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ioc3_mii_init(ip);
 
 	if (ip->mii.phy_id == -1) {
-		printk(KERN_CRIT "ioc3-eth(%s): Didn't find a PHY, goodbye.\n",
+		pr_err("ioc3-eth(%s): Didn't find a PHY, goodbye.\n",
 		       pci_name(pdev));
 		err = -ENODEV;
 		goto out_stop;
@@ -1289,10 +1276,10 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	vendor = (sw_physid1 << 12) | (sw_physid2 >> 4);
 	model  = (sw_physid2 >> 4) & 0x3f;
 	rev    = sw_physid2 & 0xf;
-	printk(KERN_INFO "%s: Using PHY %d, vendor 0x%x, model %d, "
-	       "rev %d.\n", dev->name, ip->mii.phy_id, vendor, model, rev);
-	printk(KERN_INFO "%s: IOC3 SSRAM has %d kbyte.\n", dev->name,
-	       ip->emcr & EMCR_BUFSIZ ? 128 : 64);
+	netdev_info(dev, "Using PHY %d, vendor 0x%x, model %d, rev %d.\n",
+		    ip->mii.phy_id, vendor, model, rev);
+	netdev_info(dev, "IOC3 SSRAM has %d kbyte.\n",
+		    ip->emcr & EMCR_BUFSIZ ? 128 : 64);
 
 	return 0;
 
@@ -1305,8 +1292,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_free:
 	free_netdev(dev);
 out_disable:
-	/*
-	 * We should call pci_disable_device(pdev); here if the IOC3 wasn't
+	/* We should call pci_disable_device(pdev); here if the IOC3 wasn't
 	 * such a weird device ...
 	 */
 out:
@@ -1324,8 +1310,7 @@ static void ioc3_remove_one(struct pci_dev *pdev)
 	iounmap(ip->all_regs);
 	pci_release_regions(pdev);
 	free_netdev(dev);
-	/*
-	 * We should call pci_disable_device(pdev); here if the IOC3 wasn't
+	/* We should call pci_disable_device(pdev); here if the IOC3 wasn't
 	 * such a weird device ...
 	 */
 }
@@ -1349,11 +1334,10 @@ static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct ioc3_etxd *desc;
 	unsigned long data;
 	unsigned int len;
-	uint32_t w0 = 0;
 	int produce;
+	u32 w0 = 0;
 
-	/*
-	 * IOC3 has a fairly simple minded checksumming hardware which simply
+	/* IOC3 has a fairly simple minded checksumming hardware which simply
 	 * adds up the 1's complement checksum for the entire packet and
 	 * inserts it at an offset which can be specified in the descriptor
 	 * into the transmit packet.  This means we have to compensate for the
@@ -1364,12 +1348,13 @@ static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		const struct iphdr *ih = ip_hdr(skb);
 		const int proto = ntohs(ih->protocol);
 		unsigned int csoff;
-		uint32_t csum, ehsum;
-		uint16_t *eh;
+		u32 csum, ehsum;
+		u16 *eh;
 
 		/* The MAC header.  skb->mac seem the logic approach
-		   to find the MAC header - except it's a NULL pointer ...  */
-		eh = (uint16_t *) skb->data;
+		 * to find the MAC header - except it's a NULL pointer ...
+		 */
+		eh = (u16 *)skb->data;
 
 		/* Sum up dest addr, src addr and protocol  */
 		ehsum = eh[0] + eh[1] + eh[2] + eh[3] + eh[4] + eh[5] + eh[6];
@@ -1379,10 +1364,11 @@ static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		ehsum = (ehsum & 0xffff) + (ehsum >> 16);
 
 		/* Skip IP header; it's sum is always zero and was
-		   already filled in by ip_output.c */
+		 * already filled in by ip_output.c
+		 */
 		csum = csum_tcpudp_nofold(ih->saddr, ih->daddr,
-		                          ih->tot_len - (ih->ihl << 2),
-		                          proto, 0xffff ^ ehsum);
+					  ih->tot_len - (ih->ihl << 2),
+					  proto, 0xffff ^ ehsum);
 
 		csum = (csum & 0xffff) + (csum >> 16);	/* Fold again */
 		csum = (csum & 0xffff) + (csum >> 16);
@@ -1402,7 +1388,7 @@ static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	spin_lock_irq(&ip->ioc3_lock);
 
-	data = (unsigned long) skb->data;
+	data = (unsigned long)skb->data;
 	len = skb->len;
 
 	produce = ip->tx_pi;
@@ -1424,11 +1410,11 @@ static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		unsigned long s2 = data + len - b2;
 
 		desc->cmd    = cpu_to_be32(len | ETXD_INTWHENDONE |
-		                           ETXD_B1V | ETXD_B2V | w0);
+					   ETXD_B1V | ETXD_B2V | w0);
 		desc->bufcnt = cpu_to_be32((s1 << ETXD_B1CNT_SHIFT) |
-		                           (s2 << ETXD_B2CNT_SHIFT));
+					   (s2 << ETXD_B2CNT_SHIFT));
 		desc->p1     = cpu_to_be64(ioc3_map(skb->data, 1));
-		desc->p2     = cpu_to_be64(ioc3_map((void *) b2, 1));
+		desc->p2     = cpu_to_be64(ioc3_map((void *)b2, 1));
 	} else {
 		/* Normal sized packet that doesn't cross a page boundary. */
 		desc->cmd = cpu_to_be32(len | ETXD_INTWHENDONE | ETXD_B1V | w0);
@@ -1436,7 +1422,7 @@ static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		desc->p1     = cpu_to_be64(ioc3_map(skb->data, 1));
 	}
 
-	BARRIER();
+	mb(); /* make sure all descriptor changes are visible */
 
 	ip->tx_skbs[produce] = skb;			/* Remember skb */
 	produce = (produce + 1) & 127;
@@ -1457,7 +1443,7 @@ static void ioc3_timeout(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
 
-	printk(KERN_ERR "%s: transmit timed out, resetting\n", dev->name);
+	netdev_err(dev, "transmit timed out, resetting\n");
 
 	spin_lock_irq(&ip->ioc3_lock);
 
@@ -1471,16 +1457,14 @@ static void ioc3_timeout(struct net_device *dev)
 	netif_wake_queue(dev);
 }
 
-/*
- * Given a multicast ethernet address, this routine calculates the
+/* Given a multicast ethernet address, this routine calculates the
  * address's bit index in the logical address filter mask
  */
-
 static inline unsigned int ioc3_hash(const unsigned char *addr)
 {
 	unsigned int temp = 0;
-	u32 crc;
 	int bits;
+	u32 crc;
 
 	crc = ether_crc_le(ETH_ALEN, addr);
 
@@ -1494,8 +1478,8 @@ static inline unsigned int ioc3_hash(const unsigned char *addr)
 	return temp;
 }
 
-static void ioc3_get_drvinfo (struct net_device *dev,
-	struct ethtool_drvinfo *info)
+static void ioc3_get_drvinfo(struct net_device *dev,
+			     struct ethtool_drvinfo *info)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
 
@@ -1594,8 +1578,9 @@ static void ioc3_set_multicast_list(struct net_device *dev)
 		if ((dev->flags & IFF_ALLMULTI) ||
 		    (netdev_mc_count(dev) > 64)) {
 			/* Too many for hashing to make sense or we want all
-			   multicast packets anyway,  so skip computing all the
-			   hashes and just accept all packets.  */
+			 * multicast packets anyway,  so skip computing all the
+			 * hashes and just accept all packets.
+			 */
 			ip->ehar_h = 0xffffffff;
 			ip->ehar_l = 0xffffffff;
 		} else {
-- 
2.13.7

