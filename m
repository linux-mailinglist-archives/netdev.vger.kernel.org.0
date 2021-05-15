Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF51381B5D
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 00:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbhEOWQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 18:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235245AbhEOWQA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 18:16:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 446B7613C1;
        Sat, 15 May 2021 22:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621116886;
        bh=TDa4KynTjSRQDLPX3zLvKR+TyRs3v/stT8QCil662T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7xNMDpQz//oQI+vHy1UJfvseYwUJBkBT/DDvEBC5S43nHFrcv2ccUD0l1JC+U9SH
         /5+dgNCX2n5s0aZheiIOR7S+2+tCtnvwoEvikisMKHpkcFz82Uv7YgyUCbIupMi2TO
         gPr8G7oYt5f3VWH4XQAV6Qa92mZpJg4UL8mFgE71YRGMv0U38egTHllj04TW3/CX8b
         8FU7WIwSQ95scEMjAqWzNhRJTbqxHLEA81MdTocwJuBzB+mGjCZh9UWyOeWDbpCQdV
         CMb1s7pEFZM71KqwI0th8s4m6mFYxsq8J8om2fSEbgKHpwcGwhbo/ayyelCMHddXhn
         Y5eiguGUQ2SCA==
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
Subject: [RFC 05/13] [net-next] cs89x0: rework driver configuration
Date:   Sun, 16 May 2021 00:13:12 +0200
Message-Id: <20210515221320.1255291-6-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210515221320.1255291-1-arnd@kernel.org>
References: <20210515221320.1255291-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There are two drivers in the cs89x0 file, with the CONFIG_CS89x0_PLATFORM
symbol deciding which one is getting built. This is somewhat confusing
and makes it more likely ton configure a driver that works nowhere.

Split up the Kconfig option into separate ISA and PLATFORM drivers,
with the ISA symbol explicitly connecting to the static probing in
drivers/net/Space.c

The two drivers are still mutually incompatible at compile time,
which could be lifted by splitting them into multiple files,
but in practice this will make no difference.

The platform driver can now be enabled for compile-testing on
non-ARM machines.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/Space.c                  |  4 +---
 drivers/net/ethernet/cirrus/Kconfig  | 26 ++++++++++++++++----------
 drivers/net/ethernet/cirrus/cs89x0.c | 24 +++++++++++-------------
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/Space.c b/drivers/net/Space.c
index 9196a26615cc..9f573f7ded3c 100644
--- a/drivers/net/Space.c
+++ b/drivers/net/Space.c
@@ -77,11 +77,9 @@ static struct devprobe2 isa_probes[] __initdata = {
 #ifdef CONFIG_SMC9194
 	{smc_init, 0},
 #endif
-#ifdef CONFIG_CS89x0
-#ifndef CONFIG_CS89x0_PLATFORM
+#ifdef CONFIG_CS89x0_ISA
 	{cs89x0_probe, 0},
 #endif
-#endif
 #if defined(CONFIG_MVME16x_NET) || defined(CONFIG_BVME6000_NET)	/* Intel */
 	{i82596_probe, 0},					/* I82596 */
 #endif
diff --git a/drivers/net/ethernet/cirrus/Kconfig b/drivers/net/ethernet/cirrus/Kconfig
index d8af9e64dd1e..7141340a8b0e 100644
--- a/drivers/net/ethernet/cirrus/Kconfig
+++ b/drivers/net/ethernet/cirrus/Kconfig
@@ -6,7 +6,7 @@
 config NET_VENDOR_CIRRUS
 	bool "Cirrus devices"
 	default y
-	depends on ISA || EISA || ARM || MAC
+	depends on ISA || EISA || ARM || MAC || COMPILE_TEST
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -18,9 +18,15 @@ config NET_VENDOR_CIRRUS
 if NET_VENDOR_CIRRUS
 
 config CS89x0
-	tristate "CS89x0 support"
-	depends on ISA || EISA || ARM
+	tristate
+
+config CS89x0_ISA
+	tristate "CS89x0 ISA driver support"
+	depends on HAS_IOPORT_MAP
+	depends on ISA
 	depends on !PPC32
+	depends on CS89x0_PLATFORM=n
+	select CS89x0
 	help
 	  Support for CS89x0 chipset based Ethernet cards. If you have a
 	  network (Ethernet) card of this type, say Y and read the file
@@ -30,15 +36,15 @@ config CS89x0
 	  will be called cs89x0.
 
 config CS89x0_PLATFORM
-	bool "CS89x0 platform driver support" if HAS_IOPORT_MAP
-	default !HAS_IOPORT_MAP
-	depends on CS89x0
+	tristate "CS89x0 platform driver support"
+	depends on ARM || COMPILE_TEST
+	select CS89x0
 	help
-	  Say Y to compile the cs89x0 driver as a platform driver. This
-	  makes this driver suitable for use on certain evaluation boards
-	  such as the iMX21ADS.
+	  Say Y to compile the cs89x0 platform driver. This makes this driver
+	  suitable for use on certain evaluation boards such as the iMX21ADS.
 
-	  If you are unsure, say N.
+	  To compile this driver as a module, choose M here. The module
+	  will be called cs89x0.
 
 config EP93XX_ETH
 	tristate "EP93xx Ethernet support"
diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
index 33ace3307059..3b08cd943b7b 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -104,7 +104,7 @@ static char version[] __initdata =
  * them to system IRQ numbers. This mapping is card specific and is set to
  * the configuration of the Cirrus Eval board for this chip.
  */
-#ifndef CONFIG_CS89x0_PLATFORM
+#if IS_ENABLED(CONFIG_CS89x0_ISA)
 static unsigned int netcard_portlist[] __used __initdata = {
 	0x300, 0x320, 0x340, 0x360, 0x200, 0x220, 0x240,
 	0x260, 0x280, 0x2a0, 0x2c0, 0x2e0, 0
@@ -292,7 +292,7 @@ write_irq(struct net_device *dev, int chip_type, int irq)
 	int i;
 
 	if (chip_type == CS8900) {
-#ifndef CONFIG_CS89x0_PLATFORM
+#if IS_ENABLED(CONFIG_CS89x0_ISA)
 		/* Search the mapping table for the corresponding IRQ pin. */
 		for (i = 0; i != ARRAY_SIZE(cs8900_irq_map); i++)
 			if (cs8900_irq_map[i] == irq)
@@ -859,7 +859,7 @@ net_open(struct net_device *dev)
 			goto bad_out;
 		}
 	} else {
-#if !defined(CONFIG_CS89x0_PLATFORM)
+#if IS_ENABLED(CONFIG_CS89x0_ISA)
 		if (((1 << dev->irq) & lp->irq_map) == 0) {
 			pr_err("%s: IRQ %d is not in our map of allowable IRQs, which is %x\n",
 			       dev->name, dev->irq, lp->irq_map);
@@ -1523,7 +1523,7 @@ cs89x0_probe1(struct net_device *dev, void __iomem *ioaddr, int modular)
 			dev->irq = i;
 	} else {
 		i = lp->isa_config & INT_NO_MASK;
-#ifndef CONFIG_CS89x0_PLATFORM
+#if IS_ENABLED(CONFIG_CS89x0_ISA)
 		if (lp->chip_type == CS8900) {
 			/* Translate the IRQ using the IRQ mapping table. */
 			if (i >= ARRAY_SIZE(cs8900_irq_map))
@@ -1576,7 +1576,7 @@ cs89x0_probe1(struct net_device *dev, void __iomem *ioaddr, int modular)
 	return retval;
 }
 
-#ifndef CONFIG_CS89x0_PLATFORM
+#if IS_ENABLED(CONFIG_CS89x0_ISA)
 /*
  * This function converts the I/O port address used by the cs89x0_probe() and
  * init_module() functions to the I/O memory address used by the
@@ -1682,11 +1682,7 @@ struct net_device * __init cs89x0_probe(int unit)
 	pr_warn("no cs8900 or cs8920 detected.  Be sure to disable PnP with SETUP\n");
 	return ERR_PTR(err);
 }
-#endif
-#endif
-
-#if defined(MODULE) && !defined(CONFIG_CS89x0_PLATFORM)
-
+#else
 static struct net_device *dev_cs89x0;
 
 /* Support the 'debug' module parm even if we're compiled for non-debug to
@@ -1759,7 +1755,7 @@ MODULE_LICENSE("GPL");
 
 int __init init_module(void)
 {
-	struct net_device *dev = alloc_etherdev(sizeof(struct net_local));
+	struct net_device *dev;
 	struct net_local *lp;
 	int ret = 0;
 
@@ -1768,6 +1764,7 @@ int __init init_module(void)
 #else
 	debug = 0;
 #endif
+	dev = alloc_etherdev(sizeof(struct net_local));
 	if (!dev)
 		return -ENOMEM;
 
@@ -1838,9 +1835,10 @@ cleanup_module(void)
 	release_region(dev_cs89x0->base_addr, NETCARD_IO_EXTENT);
 	free_netdev(dev_cs89x0);
 }
-#endif /* MODULE && !CONFIG_CS89x0_PLATFORM */
+#endif /* MODULE */
+#endif /* CONFIG_CS89x0_ISA */
 
-#ifdef CONFIG_CS89x0_PLATFORM
+#if IS_ENABLED(CONFIG_CS89x0_PLATFORM)
 static int __init cs89x0_platform_probe(struct platform_device *pdev)
 {
 	struct net_device *dev = alloc_etherdev(sizeof(struct net_local));
-- 
2.29.2

