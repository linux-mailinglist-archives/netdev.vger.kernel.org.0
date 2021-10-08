Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EC3426FD4
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 19:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239674AbhJHSBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 14:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239006AbhJHSBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 14:01:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD4D961058;
        Fri,  8 Oct 2021 17:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633715958;
        bh=nYimCnQYFgA+YTYef2Y3PDdqcBAMM99sV5iYsXwDMDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hprVtJIpTegjgdxDP6/xQqZJEBP2HbaRS4Qi9S6bHWu9J9hB4+rAlF/cCkyarnQJU
         Vx8EOV80uUVXHRbTrzKvvRZstfFymv1xGz58OEuhzkxmBoYzqpg+ko5frWxxQ8KdaO
         p39TmvuACC4zYQLsBcXIKT3LLpmgHtF3zWVm938SfyqwmIDFQsY9BHu2GCQMh9bh+O
         PvNBcMHnoiOyxcCkFXi9ZxE7UqvL+7U+hCtnvC/N2f6sei9zfqrWfYT5lM8+gBL+UF
         w6OoyE1QroHWiqb63mjoHKdlIj3KjqD88RRq7KkotPRnwxRIObLrkX0qj5KijSlloE
         tOHpd3S8Ci/xQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/5] ethernet: 8390: remove direct netdev->dev_addr writes
Date:   Fri,  8 Oct 2021 10:59:13 -0700
Message-Id: <20211008175913.3754184-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008175913.3754184-1-kuba@kernel.org>
References: <20211008175913.3754184-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

8390 contains a lot of loops assigning netdev->dev_addr
byte by byte. Convert what's possible directly to
eth_hw_addr_set(), use local buf in other places.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/8390/apne.c      |  3 +--
 drivers/net/ethernet/8390/ax88796.c   |  6 ++++--
 drivers/net/ethernet/8390/axnet_cs.c  |  7 +++++--
 drivers/net/ethernet/8390/mcf8390.c   |  3 +--
 drivers/net/ethernet/8390/ne.c        |  4 +---
 drivers/net/ethernet/8390/pcnet_cs.c  | 22 ++++++++++++++++------
 drivers/net/ethernet/8390/stnic.c     |  5 ++---
 drivers/net/ethernet/8390/zorro8390.c |  3 +--
 8 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index da1ae37a9d73..991ad953aa79 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -320,8 +320,7 @@ static int __init apne_probe1(struct net_device *dev, int ioaddr)
     i = request_irq(dev->irq, apne_interrupt, IRQF_SHARED, DRV_NAME, dev);
     if (i) return i;
 
-    for (i = 0; i < ETH_ALEN; i++)
-	dev->dev_addr[i] = SA_prom[i];
+    eth_hw_addr_set(dev, SA_prom);
 
     pr_cont(" %pM\n", dev->dev_addr);
 
diff --git a/drivers/net/ethernet/8390/ax88796.c b/drivers/net/ethernet/8390/ax88796.c
index b3e612b18abd..1f8acbba5b6b 100644
--- a/drivers/net/ethernet/8390/ax88796.c
+++ b/drivers/net/ethernet/8390/ax88796.c
@@ -748,11 +748,13 @@ static int ax_init_dev(struct net_device *dev)
 
 	/* load the mac-address from the device */
 	if (ax->plat->flags & AXFLG_MAC_FROMDEV) {
+		u8 addr[ETH_ALEN];
+
 		ei_outb(E8390_NODMA + E8390_PAGE1 + E8390_STOP,
 			ei_local->mem + E8390_CMD); /* 0x61 */
 		for (i = 0; i < ETH_ALEN; i++)
-			dev->dev_addr[i] =
-				ei_inb(ioaddr + EN1_PHYS_SHIFT(i));
+			addr[i] = ei_inb(ioaddr + EN1_PHYS_SHIFT(i));
+		eth_hw_addr_set(dev, addr);
 	}
 
 	if ((ax->plat->flags & AXFLG_MAC_FROMPLATFORM) &&
diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
index 3c370e686ec3..3aef959fc25b 100644
--- a/drivers/net/ethernet/8390/axnet_cs.c
+++ b/drivers/net/ethernet/8390/axnet_cs.c
@@ -187,6 +187,7 @@ static int get_prom(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
     unsigned int ioaddr = dev->base_addr;
+    u8 addr[ETH_ALEN];
     int i, j;
 
     /* This is based on drivers/net/ethernet/8390/ne.c */
@@ -220,9 +221,11 @@ static int get_prom(struct pcmcia_device *link)
 
     for (i = 0; i < 6; i += 2) {
 	j = inw(ioaddr + AXNET_DATAPORT);
-	dev->dev_addr[i] = j & 0xff;
-	dev->dev_addr[i+1] = j >> 8;
+	addr[i] = j & 0xff;
+	addr[i+1] = j >> 8;
     }
+    eth_hw_addr_set(dev, addr);
+
     return 1;
 } /* get_prom */
 
diff --git a/drivers/net/ethernet/8390/mcf8390.c b/drivers/net/ethernet/8390/mcf8390.c
index 4ad8031ab669..e320cccba61a 100644
--- a/drivers/net/ethernet/8390/mcf8390.c
+++ b/drivers/net/ethernet/8390/mcf8390.c
@@ -374,8 +374,7 @@ static int mcf8390_init(struct net_device *dev)
 	if (ret)
 		return ret;
 
-	for (i = 0; i < ETH_ALEN; i++)
-		dev->dev_addr[i] = SA_prom[i];
+	eth_hw_addr_set(dev, SA_prom);
 
 	netdev_dbg(dev, "Found ethernet address: %pM\n", dev->dev_addr);
 
diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.c
index 9afc712f5948..0a9118b8be0c 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -500,9 +500,7 @@ static int __init ne_probe1(struct net_device *dev, unsigned long ioaddr)
 
 	dev->base_addr = ioaddr;
 
-	for (i = 0; i < ETH_ALEN; i++) {
-		dev->dev_addr[i] = SA_prom[i];
-	}
+	eth_hw_addr_set(dev, SA_prom);
 
 	pr_cont("%pM\n", dev->dev_addr);
 
diff --git a/drivers/net/ethernet/8390/pcnet_cs.c b/drivers/net/ethernet/8390/pcnet_cs.c
index 96ad72abd373..0f07fe03da98 100644
--- a/drivers/net/ethernet/8390/pcnet_cs.c
+++ b/drivers/net/ethernet/8390/pcnet_cs.c
@@ -278,6 +278,7 @@ static struct hw_info *get_hwinfo(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
     u_char __iomem *base, *virt;
+    u8 addr[ETH_ALEN];
     int i, j;
 
     /* Allocate a small memory window */
@@ -302,7 +303,8 @@ static struct hw_info *get_hwinfo(struct pcmcia_device *link)
 	    (readb(base+2) == hw_info[i].a1) &&
 	    (readb(base+4) == hw_info[i].a2)) {
 		for (j = 0; j < 6; j++)
-		    dev->dev_addr[j] = readb(base + (j<<1));
+			addr[j] = readb(base + (j<<1));
+		eth_hw_addr_set(dev, addr);
 		break;
 	}
     }
@@ -324,6 +326,7 @@ static struct hw_info *get_prom(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
     unsigned int ioaddr = dev->base_addr;
+    u8 addr[ETH_ALEN];
     u_char prom[32];
     int i, j;
 
@@ -362,7 +365,8 @@ static struct hw_info *get_prom(struct pcmcia_device *link)
     }
     if ((i < NR_INFO) || ((prom[28] == 0x57) && (prom[30] == 0x57))) {
 	for (j = 0; j < 6; j++)
-	    dev->dev_addr[j] = prom[j<<1];
+	    addr[j] = prom[j<<1];
+	eth_hw_addr_set(dev, addr);
 	return (i < NR_INFO) ? hw_info+i : &default_info;
     }
     return NULL;
@@ -377,6 +381,7 @@ static struct hw_info *get_prom(struct pcmcia_device *link)
 static struct hw_info *get_dl10019(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
+    u8 addr[ETH_ALEN];
     int i;
     u_char sum;
 
@@ -385,7 +390,8 @@ static struct hw_info *get_dl10019(struct pcmcia_device *link)
     if (sum != 0xff)
 	return NULL;
     for (i = 0; i < 6; i++)
-	dev->dev_addr[i] = inb_p(dev->base_addr + 0x14 + i);
+	addr[i] = inb_p(dev->base_addr + 0x14 + i);
+    eth_hw_addr_set(dev, addr);
     i = inb(dev->base_addr + 0x1f);
     return ((i == 0x91)||(i == 0x99)) ? &dl10022_info : &dl10019_info;
 }
@@ -400,6 +406,7 @@ static struct hw_info *get_ax88190(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
     unsigned int ioaddr = dev->base_addr;
+    u8 addr[ETH_ALEN];
     int i, j;
 
     /* Not much of a test, but the alternatives are messy */
@@ -413,9 +420,10 @@ static struct hw_info *get_ax88190(struct pcmcia_device *link)
 
     for (i = 0; i < 6; i += 2) {
 	j = inw(ioaddr + PCNET_DATAPORT);
-	dev->dev_addr[i] = j & 0xff;
-	dev->dev_addr[i+1] = j >> 8;
+	addr[i] = j & 0xff;
+	addr[i+1] = j >> 8;
     }
+    eth_hw_addr_set(dev, addr);
     return NULL;
 }
 
@@ -430,6 +438,7 @@ static struct hw_info *get_ax88190(struct pcmcia_device *link)
 static struct hw_info *get_hwired(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
+    u8 addr[ETH_ALEN];
     int i;
 
     for (i = 0; i < 6; i++)
@@ -438,7 +447,8 @@ static struct hw_info *get_hwired(struct pcmcia_device *link)
 	return NULL;
 
     for (i = 0; i < 6; i++)
-	dev->dev_addr[i] = hw_addr[i];
+	addr[i] = hw_addr[i];
+    eth_hw_addr_set(dev, addr);
 
     return &default_info;
 } /* get_hwired */
diff --git a/drivers/net/ethernet/8390/stnic.c b/drivers/net/ethernet/8390/stnic.c
index fbbd7f22c142..bd89ca8a92df 100644
--- a/drivers/net/ethernet/8390/stnic.c
+++ b/drivers/net/ethernet/8390/stnic.c
@@ -104,8 +104,8 @@ STNIC_WRITE (int reg, byte val)
 static int __init stnic_probe(void)
 {
   struct net_device *dev;
-  int i, err;
   struct ei_device *ei_local;
+  int err;
 
   /* If we are not running on a SolutionEngine, give up now */
   if (! MACH_SE)
@@ -119,8 +119,7 @@ static int __init stnic_probe(void)
 #ifdef CONFIG_SH_STANDARD_BIOS
   sh_bios_get_node_addr (stnic_eadr);
 #endif
-  for (i = 0; i < ETH_ALEN; i++)
-    dev->dev_addr[i] = stnic_eadr[i];
+  eth_hw_addr_set(dev, stnic_eadr);
 
   /* Set the base address to point to the NIC, not the "real" base! */
   dev->base_addr = 0x1000;
diff --git a/drivers/net/ethernet/8390/zorro8390.c b/drivers/net/ethernet/8390/zorro8390.c
index 35a500a21521..e8b4fe813a08 100644
--- a/drivers/net/ethernet/8390/zorro8390.c
+++ b/drivers/net/ethernet/8390/zorro8390.c
@@ -364,8 +364,7 @@ static int zorro8390_init(struct net_device *dev, unsigned long board,
 	if (i)
 		return i;
 
-	for (i = 0; i < ETH_ALEN; i++)
-		dev->dev_addr[i] = SA_prom[i];
+	eth_hw_addr_set(dev, SA_prom);
 
 	pr_debug("Found ethernet address: %pM\n", dev->dev_addr);
 
-- 
2.31.1

