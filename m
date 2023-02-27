Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4590C6A42DE
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjB0Nfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjB0Nff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:35:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B73520555;
        Mon, 27 Feb 2023 05:35:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCBC060E17;
        Mon, 27 Feb 2023 13:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2063C433EF;
        Mon, 27 Feb 2023 13:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677504932;
        bh=Zv8ORgdDsS7B5O2XiDMznU7S4fAx8H8PpVhPSwVfp3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhtSdaR+FYSeTHkufcxyX4XvV21Ekd4UKn7a+Ntf7kHkAJUO1QzuuhPggAqrpk9LZ
         9nb8XxqxdFWek3aBpHsvv/MyU5VNbsVCpq9kseca5txU5NmFk++qjGeVTsDWWPZ6hp
         jX/XLJxI1DdDTr9CuZPQTdJvyuwTZJEM/u03zPcsOEtAO2BYr0TxDQzM8mjtQ9MzBs
         ibye9Rpgv+z2lY754OsXm08xDblLU4Y2MZ6F6fWbtohXWM+yVxMqcTtW14WZ7qPbxu
         u8J4Vh3ah0SmZkeVTimt2kxH/fvbfpw7M+vJT0iqBBMR2vs1F/fXfGPNZzzWXJ3OVI
         dmtzLTFlwg7uA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Olof Johansson <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC 2/6] pccard: split cardbus support from pcmcia
Date:   Mon, 27 Feb 2023 14:34:53 +0100
Message-Id: <20230227133457.431729-3-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230227133457.431729-1-arnd@kernel.org>
References: <20230227133457.431729-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

All pccard related technologies are obsolete, but there are a couple
that are still used occasionally. Most importantly this includes
32-bit PCI/Cardbus devices on Laptop PCs built between 1997 and 2006
(Pentium MMX through Core Duo) and embedded systems using 16-bit
PCMCIA/Compactflash slots for CF storage with the pata_pcmcia driver,
but usually not the combination of the two.

Separate the two configuration options for simplification and build the
common code into both the pcmcia and cardbus layers, but only allow one
of the two to be enabled in a kernel configuration, in order to allow
further cleanups on top.

This breaks the use of any 16-bit PCMCIA cards in a 32-bit capable
cardbus slot. If anyone relies on support for this configuration
and cannot use a cardbus compatible card instead, this should not
be applied. In almost all cases, a cardbus or USB based card is
superior and available cheaply compared to the older PCMCIA cards.
In particular, CompactFlash cards now require an active card
reader instead of a slow PCMCIA passthrough adapter.

The CONFIG_PCMCIA option is now limited to platforms that actually
shipped with PCMCIA or CF controllers, which is mostly x86 laptops
from the i486 and Pentium eras as well as a couple of embedded
systems. The Apple Powerbook is not included here, because all
models with PCI support have Cardbus controllers and the earlier
ones can not run Linux any more.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/pcmcia/Kconfig        | 13 +++++++-----
 drivers/pcmcia/Makefile       | 10 ++++-----
 drivers/pcmcia/cardbus.c      |  1 +
 drivers/pcmcia/cs.c           | 25 +++++-----------------
 drivers/pcmcia/cs_internal.h  |  1 +
 drivers/pcmcia/ds.c           | 14 ++++++++++---
 drivers/pcmcia/ricoh.h        |  2 +-
 drivers/pcmcia/yenta_socket.c | 39 +++++++++++++++++++++++------------
 include/pcmcia/ss.h           |  4 ++--
 9 files changed, 60 insertions(+), 49 deletions(-)

diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 26c89eefa18e..7b449d40da5e 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -21,6 +21,9 @@ if PCCARD
 config PCMCIA
 	tristate "16-bit PCMCIA support"
 	select CRC32
+	depends on X86_32 || ARCH_PXA || ARCH_SA1100 || ARCH_OMAP1 || \
+		   MIPS_ALCHEMY || PPC_PASEMI || COMPILE_TEST
+	depends on CARDBUS=n
 	default y
 	help
 	   This option enables support for 16-bit PCMCIA cards. Most older
@@ -51,8 +54,9 @@ config PCMCIA_LOAD_CIS
 	  If unsure, say Y.
 
 config CARDBUS
-	bool "32-bit CardBus support"
+	tristate "32-bit CardBus support"
 	depends on PCI
+	select YENTA
 	default y
 	help
 	  CardBus is a bus mastering architecture for PC-cards, which allows
@@ -71,10 +75,9 @@ config PCMCIA_MAX1600
 comment "PC-card bridges"
 
 config YENTA
-	tristate "CardBus yenta-compatible bridge support"
-	depends on PCI
-	select CARDBUS if !EXPERT
-	select PCCARD_NONSTATIC if PCMCIA != n
+	tristate "CardBus yenta-compatible bridge support" if EXPERT
+	depends on PCI && CARDBUS
+	default y
 	help
 	  This option enables support for CardBus host bridges.  Virtually
 	  all modern PCMCIA bridges are CardBus compatible.  A "bridge" is
diff --git a/drivers/pcmcia/Makefile b/drivers/pcmcia/Makefile
index 67d447c62b8d..0f090543cefe 100644
--- a/drivers/pcmcia/Makefile
+++ b/drivers/pcmcia/Makefile
@@ -3,17 +3,17 @@
 # Makefile for the kernel pcmcia subsystem (c/o David Hinds)
 #
 
-pcmcia_core-y					+= cs.o socket_sysfs.o
-pcmcia_core-$(CONFIG_CARDBUS)			+= cardbus.o
-obj-$(CONFIG_PCCARD)				+= pcmcia_core.o
+cardbus_core-y					+= cardbus.o cs.o socket_sysfs.o rsrc_mgr.o
+obj-$(CONFIG_CARDBUS)				+= cardbus_core.o
 
-pcmcia-y					+= ds.o pcmcia_resource.o cistpl.o pcmcia_cis.o
+pcmcia-y					+= ds.o pcmcia_resource.o cistpl.o pcmcia_cis.o \
+						   cs.o socket_sysfs.o
 obj-$(CONFIG_PCMCIA)				+= pcmcia.o
 
 pcmcia_rsrc-y					+= rsrc_mgr.o
 pcmcia_rsrc-$(CONFIG_PCCARD_NONSTATIC)		+= rsrc_nonstatic.o
 pcmcia_rsrc-$(CONFIG_PCCARD_IODYN)		+= rsrc_iodyn.o
-obj-$(CONFIG_PCCARD)				+= pcmcia_rsrc.o
+obj-$(CONFIG_PCMCIA)				+= pcmcia_rsrc.o
 
 
 # socket drivers
diff --git a/drivers/pcmcia/cardbus.c b/drivers/pcmcia/cardbus.c
index 45c8252c8edc..2c5673ae58ba 100644
--- a/drivers/pcmcia/cardbus.c
+++ b/drivers/pcmcia/cardbus.c
@@ -121,4 +121,5 @@ void cb_free(struct pcmcia_socket *s)
 		pci_stop_and_remove_bus_device(dev);
 
 	pci_unlock_rescan_remove();
+
 }
diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index e3224e49c43f..8ed89d7cfc94 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -133,7 +133,7 @@ int pcmcia_register_socket(struct pcmcia_socket *socket)
 	list_add_tail(&socket->socket_list, &pcmcia_socket_list);
 	up_write(&pcmcia_socket_list_rwsem);
 
-#ifndef CONFIG_CARDBUS
+#if !IS_ENABLED(CONFIG_CARDBUS)
 	/*
 	 * If we do not support Cardbus, ensure that
 	 * the Cardbus socket capability is disabled.
@@ -313,7 +313,7 @@ static void socket_shutdown(struct pcmcia_socket *s)
 	 */
 	mutex_unlock(&s->ops_mutex);
 
-#ifdef CONFIG_CARDBUS
+#if IS_ENABLED(CONFIG_CARDBUS)
 	cb_free(s);
 #endif
 
@@ -428,7 +428,7 @@ static int socket_insert(struct pcmcia_socket *skt)
 			   (skt->state & SOCKET_CARDBUS) ? "CardBus" : "PCMCIA",
 			   skt->sock);
 
-#ifdef CONFIG_CARDBUS
+#if IS_ENABLED(CONFIG_CARDBUS)
 		if (skt->state & SOCKET_CARDBUS) {
 			cb_alloc(skt);
 			skt->state |= SOCKET_CARDBUS_CONFIG;
@@ -522,7 +522,7 @@ static int socket_late_resume(struct pcmcia_socket *skt)
 static int socket_complete_resume(struct pcmcia_socket *skt)
 {
 	int ret = 0;
-#ifdef CONFIG_CARDBUS
+#if IS_ENABLED(CONFIG_CARDBUS)
 	if (skt->state & SOCKET_CARDBUS) {
 		/* We can't be sure the CardBus card is the same
 		 * as the one previously inserted. Therefore, remove
@@ -822,7 +822,7 @@ static int pcmcia_socket_uevent(const struct device *dev,
 }
 
 
-static struct completion pcmcia_unload;
+static DECLARE_COMPLETION(pcmcia_unload);
 
 static void pcmcia_release_socket_class(struct class *data)
 {
@@ -901,18 +901,3 @@ struct class pcmcia_socket_class = {
 EXPORT_SYMBOL(pcmcia_socket_class);
 
 
-static int __init init_pcmcia_cs(void)
-{
-	init_completion(&pcmcia_unload);
-	return class_register(&pcmcia_socket_class);
-}
-
-static void __exit exit_pcmcia_cs(void)
-{
-	class_unregister(&pcmcia_socket_class);
-	wait_for_completion(&pcmcia_unload);
-}
-
-subsys_initcall(init_pcmcia_cs);
-module_exit(exit_pcmcia_cs);
-
diff --git a/drivers/pcmcia/cs_internal.h b/drivers/pcmcia/cs_internal.h
index 580369f3c0b0..1fc527fd06c3 100644
--- a/drivers/pcmcia/cs_internal.h
+++ b/drivers/pcmcia/cs_internal.h
@@ -18,6 +18,7 @@
 #define _LINUX_CS_INTERNAL_H
 
 #include <linux/kref.h>
+#include <pcmcia/cistpl.h>
 
 /* Flags in client state */
 #define CLIENT_WIN_REQ(i)	(0x1<<(i))
diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index ace133b9f7d4..d68acd1ceabb 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -1419,9 +1419,16 @@ static int __init init_pcmcia_bus(void)
 {
 	int ret;
 
+	ret = class_register(&pcmcia_socket_class);
+	if (ret < 0) {
+		printk(KERN_WARNING "pcmcia: class register error %d\n", ret);
+		return ret;
+	}
+
 	ret = bus_register(&pcmcia_bus_type);
 	if (ret < 0) {
 		printk(KERN_WARNING "pcmcia: bus_register error: %d\n", ret);
+		class_unregister(&pcmcia_socket_class);
 		return ret;
 	}
 	ret = class_interface_register(&pcmcia_bus_interface);
@@ -1429,20 +1436,21 @@ static int __init init_pcmcia_bus(void)
 		printk(KERN_WARNING
 			"pcmcia: class_interface_register error: %d\n", ret);
 		bus_unregister(&pcmcia_bus_type);
+		class_unregister(&pcmcia_socket_class);
 		return ret;
 	}
 
 	return 0;
 }
-fs_initcall(init_pcmcia_bus); /* one level after subsys_initcall so that
-			       * pcmcia_socket_class is already registered */
-
+subsys_initcall(init_pcmcia_bus);
 
 static void __exit exit_pcmcia_bus(void)
 {
 	class_interface_unregister(&pcmcia_bus_interface);
 
 	bus_unregister(&pcmcia_bus_type);
+
+	class_unregister(&pcmcia_socket_class);
 }
 module_exit(exit_pcmcia_bus);
 
diff --git a/drivers/pcmcia/ricoh.h b/drivers/pcmcia/ricoh.h
index 8ac7b138c094..bca3ebffb5c4 100644
--- a/drivers/pcmcia/ricoh.h
+++ b/drivers/pcmcia/ricoh.h
@@ -123,7 +123,7 @@
 #define RL5C4XX_MISC3			0x00A2 /* 16 bit */
 #define  RL5C47X_MISC3_CB_CLKRUN_DIS	BIT(1)
 
-#ifdef __YENTA_H
+#if IS_ENABLED(CONFIG_CARDBUS)
 
 #define rl_misc(socket)		((socket)->private[0])
 #define rl_ctl(socket)		((socket)->private[1])
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 1365eaa20ff4..ac98d9bb8349 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -24,6 +24,7 @@
 
 #include "yenta_socket.h"
 #include "i82365.h"
+#include "cs_internal.h"
 
 static bool disable_clkrun;
 module_param(disable_clkrun, bool, 0444);
@@ -228,17 +229,8 @@ static int yenta_get_status(struct pcmcia_socket *sock, unsigned int *value)
 		val |= (state & (CB_CDETECT1 | CB_CDETECT2)) ? 0 : SS_DETECT;
 		val |= (state & CB_PWRCYCLE) ? SS_POWERON | SS_READY : 0;
 	} else if (state & CB_16BITCARD) {
-		u8 status = exca_readb(socket, I365_STATUS);
-		val |= ((status & I365_CS_DETECT) == I365_CS_DETECT) ? SS_DETECT : 0;
-		if (exca_readb(socket, I365_INTCTL) & I365_PC_IOCARD) {
-			val |= (status & I365_CS_STSCHG) ? 0 : SS_STSCHG;
-		} else {
-			val |= (status & I365_CS_BVD1) ? 0 : SS_BATDEAD;
-			val |= (status & I365_CS_BVD2) ? 0 : SS_BATWARN;
-		}
-		val |= (status & I365_CS_WRPROT) ? SS_WRPROT : 0;
-		val |= (status & I365_CS_READY) ? SS_READY : 0;
-		val |= (status & I365_CS_POWERON) ? SS_POWERON : 0;
+		dev_warn_once(&socket->dev->dev,
+			      "16-bit PCMCIA cards are no longer supported\n");
 	}
 
 	*value = val;
@@ -1176,7 +1168,7 @@ static int yenta_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	/* prepare pcmcia_socket */
 	socket->socket.ops = &yenta_socket_operations;
-	socket->socket.resource_ops = &pccard_nonstatic_ops;
+	socket->socket.resource_ops = &pccard_static_ops;
 	socket->socket.dev.parent = &dev->dev;
 	socket->socket.driver_data = socket;
 	socket->socket.owner = THIS_MODULE;
@@ -1450,6 +1442,27 @@ static struct pci_driver yenta_cardbus_driver = {
 	.driver.pm	= YENTA_PM_OPS,
 };
 
-module_pci_driver(yenta_cardbus_driver);
+static int __init yenta_init(void)
+{
+	int ret;
+
+	ret = class_register(&pcmcia_socket_class);
+	if (ret)
+		return ret;
+
+	ret = pci_register_driver(&yenta_cardbus_driver);
+	if (ret)
+		class_unregister(&pcmcia_socket_class);
+
+	return ret;
+}
+module_init(yenta_init);
+
+static void __exit yenta_exit(void)
+{
+	pci_unregister_driver(&yenta_cardbus_driver);
+	class_unregister(&pcmcia_socket_class);
+}
+module_exit(yenta_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/include/pcmcia/ss.h b/include/pcmcia/ss.h
index 7cf7dbbfa131..b905f5248fc6 100644
--- a/include/pcmcia/ss.h
+++ b/include/pcmcia/ss.h
@@ -16,7 +16,7 @@
 #include <linux/sched.h>	/* task_struct, completion */
 #include <linux/mutex.h>
 
-#ifdef CONFIG_CARDBUS
+#if IS_ENABLED(CONFIG_CARDBUS)
 #include <linux/pci.h>
 #endif
 
@@ -176,7 +176,7 @@ struct pcmcia_socket {
 	int (*power_hook)(struct pcmcia_socket *sock, int operation);
 
 	/* allows tuning the CB bridge before loading driver for the CB card */
-#ifdef CONFIG_CARDBUS
+#if IS_ENABLED(CONFIG_CARDBUS)
 	void (*tune_bridge)(struct pcmcia_socket *sock, struct pci_bus *bus);
 #endif
 
-- 
2.39.2

