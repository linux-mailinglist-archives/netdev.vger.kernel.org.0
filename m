Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D54294A3A
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfHSQdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:33:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:55492 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727906AbfHSQcH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:32:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 88AAAB618;
        Mon, 19 Aug 2019 16:32:04 +0000 (UTC)
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
Subject: [PATCH v5 10/17] net: sgi: ioc3-eth: rework skb rx handling
Date:   Mon, 19 Aug 2019 18:31:33 +0200
Message-Id: <20190819163144.3478-11-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190819163144.3478-1-tbogendoerfer@suse.de>
References: <20190819163144.3478-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Buffers alloacted by alloc_skb() are already cache aligned so there
is no need for an extra align done by ioc3_alloc_skb. And instead
of skb_put/skb_trim simply use one skb_put after frame size is known
during receive.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 50 ++++++++-----------------------------
 1 file changed, 11 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index c875640926d6..d862f28887f9 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -11,7 +11,6 @@
  *
  * To do:
  *
- *  o Handle allocation failures in ioc3_alloc_skb() more gracefully.
  *  o Handle allocation failures in ioc3_init_rings().
  *  o Use prefetching for large packets.  What is a good lower limit for
  *    prefetching?
@@ -72,6 +71,12 @@
 #define TX_RING_ENTRIES		128
 #define TX_RING_MASK		(TX_RING_ENTRIES - 1)
 
+/* BEWARE: The IOC3 documentation documents the size of rx buffers as
+ * 1644 while it's actually 1664.  This one was nasty to track down...
+ */
+#define RX_OFFSET		10
+#define RX_BUF_SIZE		1664
+
 #define ETCSR_FD   ((17 << ETCSR_IPGR2_SHIFT) | (11 << ETCSR_IPGR1_SHIFT) | 21)
 #define ETCSR_HD   ((21 << ETCSR_IPGR2_SHIFT) | (21 << ETCSR_IPGR1_SHIFT) | 21)
 
@@ -111,31 +116,6 @@ static void ioc3_init(struct net_device *dev);
 static const char ioc3_str[] = "IOC3 Ethernet";
 static const struct ethtool_ops ioc3_ethtool_ops;
 
-/* We use this to acquire receive skb's that we can DMA directly into. */
-
-#define IOC3_CACHELINE	128UL
-
-static inline unsigned long aligned_rx_skb_addr(unsigned long addr)
-{
-	return (~addr + 1) & (IOC3_CACHELINE - 1UL);
-}
-
-static inline struct sk_buff *ioc3_alloc_skb(unsigned long length,
-					     unsigned int gfp_mask)
-{
-	struct sk_buff *skb;
-
-	skb = alloc_skb(length + IOC3_CACHELINE - 1, gfp_mask);
-	if (likely(skb)) {
-		int offset = aligned_rx_skb_addr((unsigned long)skb->data);
-
-		if (offset)
-			skb_reserve(skb, offset);
-	}
-
-	return skb;
-}
-
 static inline unsigned long ioc3_map(void *ptr, unsigned long vdev)
 {
 #ifdef CONFIG_SGI_IP27
@@ -148,12 +128,6 @@ static inline unsigned long ioc3_map(void *ptr, unsigned long vdev)
 #endif
 }
 
-/* BEWARE: The IOC3 documentation documents the size of rx buffers as
- * 1644 while it's actually 1664.  This one was nasty to track down ...
- */
-#define RX_OFFSET		10
-#define RX_BUF_ALLOC_SIZE	(1664 + RX_OFFSET + IOC3_CACHELINE)
-
 #define IOC3_SIZE 0x100000
 
 static inline u32 mcr_pack(u32 pulse, u32 sample)
@@ -534,10 +508,10 @@ static inline void ioc3_rx(struct net_device *dev)
 		err = be32_to_cpu(rxb->err);		/* It's valid ...  */
 		if (err & ERXBUF_GOODPKT) {
 			len = ((w0 >> ERXBUF_BYTECNT_SHIFT) & 0x7ff) - 4;
-			skb_trim(skb, len);
+			skb_put(skb, len);
 			skb->protocol = eth_type_trans(skb, dev);
 
-			new_skb = ioc3_alloc_skb(RX_BUF_ALLOC_SIZE, GFP_ATOMIC);
+			new_skb = alloc_skb(RX_BUF_SIZE, GFP_ATOMIC);
 			if (!new_skb) {
 				/* Ouch, drop packet and just recycle packet
 				 * to keep the ring filled.
@@ -546,6 +520,7 @@ static inline void ioc3_rx(struct net_device *dev)
 				new_skb = skb;
 				goto next;
 			}
+			new_skb->dev = dev;
 
 			if (likely(dev->features & NETIF_F_RXCSUM))
 				ioc3_tcpudp_checksum(skb,
@@ -556,8 +531,6 @@ static inline void ioc3_rx(struct net_device *dev)
 
 			ip->rx_skbs[rx_entry] = NULL;	/* Poison  */
 
-			/* Because we reserve afterwards. */
-			skb_put(new_skb, (1664 + RX_OFFSET));
 			rxb = (struct ioc3_erxbuf *)new_skb->data;
 			skb_reserve(new_skb, RX_OFFSET);
 
@@ -846,16 +819,15 @@ static void ioc3_alloc_rings(struct net_device *dev)
 		for (i = 0; i < RX_BUFFS; i++) {
 			struct sk_buff *skb;
 
-			skb = ioc3_alloc_skb(RX_BUF_ALLOC_SIZE, GFP_ATOMIC);
+			skb = alloc_skb(RX_BUF_SIZE, GFP_ATOMIC);
 			if (!skb) {
 				show_free_areas(0, NULL);
 				continue;
 			}
+			skb->dev = dev;
 
 			ip->rx_skbs[i] = skb;
 
-			/* Because we reserve afterwards. */
-			skb_put(skb, (1664 + RX_OFFSET));
 			rxb = (struct ioc3_erxbuf *)skb->data;
 			rxr[i] = cpu_to_be64(ioc3_map(rxb, 1));
 			skb_reserve(skb, RX_OFFSET);
-- 
2.13.7

