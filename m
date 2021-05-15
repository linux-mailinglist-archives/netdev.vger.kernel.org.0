Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E0E381B60
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 00:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbhEOWQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 18:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235265AbhEOWQE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 18:16:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00AC060C3F;
        Sat, 15 May 2021 22:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621116890;
        bh=RE/MLEgKsxt8jCH1NZApxy8pXJsla8iD61kMkT6eokQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6gjgEShPUoHqI5cD+fyMP5mO5XDSjRGxR92Z8O+93ILYCfQT4wF+qEGBNeI8Cdzr
         yqNfu+q4WI/h7jEsLMTYZWd1ISHCxC0HfRoyhUs7TLn9p5ofiKDoMeS3s9YDyiqTTY
         R5H+zBGmLMrUajK8HDHGd39yO1g5r6VyZ7qxGtDH7kUv/+YutCAFHz62+y5+WwndhF
         hinbCqT47b2Gtst2wJXND7VzQlziym/R1hyZLYAZlWgG0tnbVk1kzGcrBO8CuQL1EF
         22LX9koFaFohZugv4nH2clVK6LizmRKAdc0xp1x9l/GmZZ6Q/ccX30+rSIVfOiZ/KL
         Z+LD/acfr9Ehg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC 06/13] [net-next] m68k: remove legacy probing
Date:   Sun, 16 May 2021 00:13:13 +0200
Message-Id: <20210515221320.1255291-7-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210515221320.1255291-1-arnd@kernel.org>
References: <20210515221320.1255291-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There are six m68k specific drivers that use the legacy probe method
in drivers/net/Space.c. However, all of these only support a single
device, and they completely ignore the command line settings from
netdev_boot_setup_check, so there is really no point at all.

Aside from sun3_82586, these already have a module_init function that
can be used for built-in mode as well, simply by removing the #ifdef.

Note that the 82596 driver was previously used on ISA as well, but
that got dropped long ago.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/Space.c                      | 25 +-----------------------
 drivers/net/ethernet/8390/apne.c         | 11 ++---------
 drivers/net/ethernet/amd/atarilance.c    | 11 ++---------
 drivers/net/ethernet/amd/mvme147.c       | 16 ++++++---------
 drivers/net/ethernet/amd/sun3lance.c     | 19 ++++++------------
 drivers/net/ethernet/i825xx/82596.c      | 24 ++++++-----------------
 drivers/net/ethernet/i825xx/sun3_82586.c | 17 +++++++---------
 include/net/Space.h                      |  6 ------
 8 files changed, 30 insertions(+), 99 deletions(-)

diff --git a/drivers/net/Space.c b/drivers/net/Space.c
index 9f573f7ded3c..a03559f23295 100644
--- a/drivers/net/Space.c
+++ b/drivers/net/Space.c
@@ -80,34 +80,12 @@ static struct devprobe2 isa_probes[] __initdata = {
 #ifdef CONFIG_CS89x0_ISA
 	{cs89x0_probe, 0},
 #endif
-#if defined(CONFIG_MVME16x_NET) || defined(CONFIG_BVME6000_NET)	/* Intel */
-	{i82596_probe, 0},					/* I82596 */
-#endif
 #ifdef CONFIG_NI65
 	{ni65_probe, 0},
 #endif
 	{NULL, 0},
 };
 
-static struct devprobe2 m68k_probes[] __initdata = {
-#ifdef CONFIG_ATARILANCE	/* Lance-based Atari ethernet boards */
-	{atarilance_probe, 0},
-#endif
-#ifdef CONFIG_SUN3LANCE         /* sun3 onboard Lance chip */
-	{sun3lance_probe, 0},
-#endif
-#ifdef CONFIG_SUN3_82586        /* sun3 onboard Intel 82586 chip */
-	{sun3_82586_probe, 0},
-#endif
-#ifdef CONFIG_APNE		/* A1200 PCMCIA NE2000 */
-	{apne_probe, 0},
-#endif
-#ifdef CONFIG_MVME147_NET	/* MVME147 internal Ethernet */
-	{mvme147lance_probe, 0},
-#endif
-	{NULL, 0},
-};
-
 /* Unified ethernet device probe, segmented per architecture and
  * per bus interface. This drives the legacy devices only for now.
  */
@@ -119,8 +97,7 @@ static void __init ethif_probe2(int unit)
 	if (base_addr == 1)
 		return;
 
-	(void)(probe_list2(unit, m68k_probes, base_addr == 0) &&
-		probe_list2(unit, isa_probes, base_addr == 0));
+	probe_list2(unit, isa_probes, base_addr == 0);
 }
 
 /*  Statically configured drivers -- order matters here. */
diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index fe6c834c422e..da1ae37a9d73 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -75,7 +75,6 @@
 #define NESM_STOP_PG	0x80	/* Last page +1 of RX ring */
 
 
-struct net_device * __init apne_probe(int unit);
 static int apne_probe1(struct net_device *dev, int ioaddr);
 
 static void apne_reset_8390(struct net_device *dev);
@@ -120,7 +119,7 @@ static u32 apne_msg_enable;
 module_param_named(msg_enable, apne_msg_enable, uint, 0444);
 MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
 
-struct net_device * __init apne_probe(int unit)
+static struct net_device * __init apne_probe(void)
 {
 	struct net_device *dev;
 	struct ei_device *ei_local;
@@ -150,10 +149,6 @@ struct net_device * __init apne_probe(int unit)
 	dev = alloc_ei_netdev();
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
-	if (unit >= 0) {
-		sprintf(dev->name, "eth%d", unit);
-		netdev_boot_setup_check(dev);
-	}
 	ei_local = netdev_priv(dev);
 	ei_local->msg_enable = apne_msg_enable;
 
@@ -554,12 +549,11 @@ static irqreturn_t apne_interrupt(int irq, void *dev_id)
     return IRQ_HANDLED;
 }
 
-#ifdef MODULE
 static struct net_device *apne_dev;
 
 static int __init apne_module_init(void)
 {
-	apne_dev = apne_probe(-1);
+	apne_dev = apne_probe();
 	return PTR_ERR_OR_ZERO(apne_dev);
 }
 
@@ -579,7 +573,6 @@ static void __exit apne_module_exit(void)
 }
 module_init(apne_module_init);
 module_exit(apne_module_exit);
-#endif
 
 static int init_pcmcia(void)
 {
diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index c1eab916438f..83012a1ef3cf 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -367,7 +367,7 @@ static void *slow_memcpy( void *dst, const void *src, size_t len )
 }
 
 
-struct net_device * __init atarilance_probe(int unit)
+struct net_device * __init atarilance_probe(void)
 {
 	int i;
 	static int found;
@@ -382,10 +382,6 @@ struct net_device * __init atarilance_probe(int unit)
 	dev = alloc_etherdev(sizeof(struct lance_private));
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
-	if (unit >= 0) {
-		sprintf(dev->name, "eth%d", unit);
-		netdev_boot_setup_check(dev);
-	}
 
 	for( i = 0; i < N_LANCE_ADDR; ++i ) {
 		if (lance_probe1( dev, &lance_addr_list[i] )) {
@@ -1137,13 +1133,11 @@ static int lance_set_mac_address( struct net_device *dev, void *addr )
 	return 0;
 }
 
-
-#ifdef MODULE
 static struct net_device *atarilance_dev;
 
 static int __init atarilance_module_init(void)
 {
-	atarilance_dev = atarilance_probe(-1);
+	atarilance_dev = atarilance_probe();
 	return PTR_ERR_OR_ZERO(atarilance_dev);
 }
 
@@ -1155,4 +1149,3 @@ static void __exit atarilance_module_exit(void)
 }
 module_init(atarilance_module_init);
 module_exit(atarilance_module_exit);
-#endif /* MODULE */
diff --git a/drivers/net/ethernet/amd/mvme147.c b/drivers/net/ethernet/amd/mvme147.c
index 3f2e4cdd0b83..da97fccea9ea 100644
--- a/drivers/net/ethernet/amd/mvme147.c
+++ b/drivers/net/ethernet/amd/mvme147.c
@@ -68,7 +68,7 @@ static const struct net_device_ops lance_netdev_ops = {
 };
 
 /* Initialise the one and only on-board 7990 */
-struct net_device * __init mvme147lance_probe(int unit)
+static struct net_device * __init mvme147lance_probe(void)
 {
 	struct net_device *dev;
 	static int called;
@@ -86,9 +86,6 @@ struct net_device * __init mvme147lance_probe(int unit)
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-	if (unit >= 0)
-		sprintf(dev->name, "eth%d", unit);
-
 	/* Fill the dev fields */
 	dev->base_addr = (unsigned long)MVME147_LANCE_BASE;
 	dev->netdev_ops = &lance_netdev_ops;
@@ -179,22 +176,21 @@ static int m147lance_close(struct net_device *dev)
 	return 0;
 }
 
-#ifdef MODULE
 MODULE_LICENSE("GPL");
 
 static struct net_device *dev_mvme147_lance;
-int __init init_module(void)
+static int __init m147lance_init(void)
 {
-	dev_mvme147_lance = mvme147lance_probe(-1);
+	dev_mvme147_lance = mvme147lance_probe();
 	return PTR_ERR_OR_ZERO(dev_mvme147_lance);
 }
+module_init(m147lance_init);
 
-void __exit cleanup_module(void)
+static void __exit m147lance_exit(void)
 {
 	struct m147lance_private *lp = netdev_priv(dev_mvme147_lance);
 	unregister_netdev(dev_mvme147_lance);
 	free_pages(lp->ram, 3);
 	free_netdev(dev_mvme147_lance);
 }
-
-#endif /* MODULE */
+module_exit(m147lance_exit);
diff --git a/drivers/net/ethernet/amd/sun3lance.c b/drivers/net/ethernet/amd/sun3lance.c
index 00ae1081254d..73724b082bdb 100644
--- a/drivers/net/ethernet/amd/sun3lance.c
+++ b/drivers/net/ethernet/amd/sun3lance.c
@@ -245,7 +245,7 @@ static void set_multicast_list( struct net_device *dev );
 
 /************************* End of Prototypes **************************/
 
-struct net_device * __init sun3lance_probe(int unit)
+static struct net_device * __init sun3lance_probe(void)
 {
 	struct net_device *dev;
 	static int found;
@@ -272,10 +272,6 @@ struct net_device * __init sun3lance_probe(int unit)
 	dev = alloc_etherdev(sizeof(struct lance_private));
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
-	if (unit >= 0) {
-		sprintf(dev->name, "eth%d", unit);
-		netdev_boot_setup_check(dev);
-	}
 
 	if (!lance_probe(dev))
 		goto out;
@@ -924,17 +920,16 @@ static void set_multicast_list( struct net_device *dev )
 }
 
 
-#ifdef MODULE
-
 static struct net_device *sun3lance_dev;
 
-int __init init_module(void)
+static int __init sun3lance_init(void)
 {
-	sun3lance_dev = sun3lance_probe(-1);
+	sun3lance_dev = sun3lance_probe();
 	return PTR_ERR_OR_ZERO(sun3lance_dev);
 }
+module_init(sun3lance_init);
 
-void __exit cleanup_module(void)
+static void __exit sun3lance_cleanup(void)
 {
 	unregister_netdev(sun3lance_dev);
 #ifdef CONFIG_SUN3
@@ -942,6 +937,4 @@ void __exit cleanup_module(void)
 #endif
 	free_netdev(sun3lance_dev);
 }
-
-#endif /* MODULE */
-
+module_exit(sun3lance_cleanup);
diff --git a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i825xx/82596.c
index fc8c7cd67471..b8a40146b895 100644
--- a/drivers/net/ethernet/i825xx/82596.c
+++ b/drivers/net/ethernet/i825xx/82596.c
@@ -1110,9 +1110,6 @@ static void print_eth(unsigned char *add, char *str)
 	       add, add + 6, add, add[12], add[13], str);
 }
 
-static int io = 0x300;
-static int irq = 10;
-
 static const struct net_device_ops i596_netdev_ops = {
 	.ndo_open 		= i596_open,
 	.ndo_stop		= i596_close,
@@ -1123,7 +1120,7 @@ static const struct net_device_ops i596_netdev_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
-struct net_device * __init i82596_probe(int unit)
+static struct net_device * __init i82596_probe(void)
 {
 	struct net_device *dev;
 	int i;
@@ -1140,14 +1137,6 @@ struct net_device * __init i82596_probe(int unit)
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
-	if (unit >= 0) {
-		sprintf(dev->name, "eth%d", unit);
-		netdev_boot_setup_check(dev);
-	} else {
-		dev->base_addr = io;
-		dev->irq = irq;
-	}
-
 #ifdef ENABLE_MVME16x_NET
 	if (MACH_IS_MVME16x) {
 		if (mvme16x_config & MVME16x_CONFIG_NO_ETHERNET) {
@@ -1515,22 +1504,22 @@ static void set_multicast_list(struct net_device *dev)
 	}
 }
 
-#ifdef MODULE
 static struct net_device *dev_82596;
 
 static int debug = -1;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "i82596 debug mask");
 
-int __init init_module(void)
+static int __init i82596_init(void)
 {
 	if (debug >= 0)
 		i596_debug = debug;
-	dev_82596 = i82596_probe(-1);
+	dev_82596 = i82596_probe();
 	return PTR_ERR_OR_ZERO(dev_82596);
 }
+module_init(i82596_init);
 
-void __exit cleanup_module(void)
+static void __exit i82596_cleanup(void)
 {
 	unregister_netdev(dev_82596);
 #ifdef __mc68000__
@@ -1544,5 +1533,4 @@ void __exit cleanup_module(void)
 	free_page ((u32)(dev_82596->mem_start));
 	free_netdev(dev_82596);
 }
-
-#endif				/* MODULE */
+module_exit(i82596_cleanup);
diff --git a/drivers/net/ethernet/i825xx/sun3_82586.c b/drivers/net/ethernet/i825xx/sun3_82586.c
index 4564ee02c95f..893e0ddcb611 100644
--- a/drivers/net/ethernet/i825xx/sun3_82586.c
+++ b/drivers/net/ethernet/i825xx/sun3_82586.c
@@ -29,6 +29,7 @@ static int rfdadd = 0; /* rfdadd=1 may be better for 8K MEM cards */
 static int fifo=0x8;	/* don't change */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
@@ -276,7 +277,7 @@ static void alloc586(struct net_device *dev)
 	memset((char *)p->scb,0,sizeof(struct scb_struct));
 }
 
-struct net_device * __init sun3_82586_probe(int unit)
+static int __init sun3_82586_probe(void)
 {
 	struct net_device *dev;
 	unsigned long ioaddr;
@@ -291,25 +292,20 @@ struct net_device * __init sun3_82586_probe(int unit)
 		break;
 
 	default:
-		return ERR_PTR(-ENODEV);
+		return -ENODEV;
 	}
 
 	if (found)
-		return ERR_PTR(-ENODEV);
+		return -ENODEV;
 
 	ioaddr = (unsigned long)ioremap(IE_OBIO, SUN3_82586_TOTAL_SIZE);
 	if (!ioaddr)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	found = 1;
 
 	dev = alloc_etherdev(sizeof(struct priv));
 	if (!dev)
 		goto out;
-	if (unit >= 0) {
-		sprintf(dev->name, "eth%d", unit);
-		netdev_boot_setup_check(dev);
-	}
-
 	dev->irq = IE_IRQ;
 	dev->base_addr = ioaddr;
 	err = sun3_82586_probe1(dev, ioaddr);
@@ -326,8 +322,9 @@ struct net_device * __init sun3_82586_probe(int unit)
 	free_netdev(dev);
 out:
 	iounmap((void __iomem *)ioaddr);
-	return ERR_PTR(err);
+	return err;
 }
+module_init(sun3_82586_probe);
 
 static const struct net_device_ops sun3_82586_netdev_ops = {
 	.ndo_open		= sun3_82586_open,
diff --git a/include/net/Space.h b/include/net/Space.h
index e30e7a70ea99..93fd6caa4bad 100644
--- a/include/net/Space.h
+++ b/include/net/Space.h
@@ -8,16 +8,10 @@ struct net_device *ultra_probe(int unit);
 struct net_device *wd_probe(int unit);
 struct net_device *ne_probe(int unit);
 struct net_device *fmv18x_probe(int unit);
-struct net_device *i82596_probe(int unit);
 struct net_device *ni65_probe(int unit);
 struct net_device *sonic_probe(int unit);
 struct net_device *smc_init(int unit);
-struct net_device *atarilance_probe(int unit);
-struct net_device *sun3lance_probe(int unit);
-struct net_device *sun3_82586_probe(int unit);
-struct net_device *apne_probe(int unit);
 struct net_device *cs89x0_probe(int unit);
-struct net_device *mvme147lance_probe(int unit);
 struct net_device *tc515_probe(int unit);
 struct net_device *lance_probe(int unit);
 struct net_device *cops_probe(int unit);
-- 
2.29.2

