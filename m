Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7CF6A42FD
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjB0NhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjB0Ngu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:36:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB432195E;
        Mon, 27 Feb 2023 05:35:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A80D7B80D1F;
        Mon, 27 Feb 2023 13:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB1AC433EF;
        Mon, 27 Feb 2023 13:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677504952;
        bh=b9HrZOsZ0t1HTiFoX7ydm1tiygWOLP83zg9nAfNZ1yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pB5p/z8zHfkoobffWNCngXWOTxAEZxBf8BJR8ukTfFakmvaT5brl++TVnvCgLnqIz
         V0a0lbAKirRTFwqbTgUxIP99kEN36fP+v0w9leayMeqi+KDLnroY1rZksb3nEVpb4g
         Txoj5inxcnxhRcYF03mzK249tBVstnL+txTarvCp4Sy9PXCvWC1oPUim1+wN8Y0IRf
         HtBQ/EGSN6EfeCBudpB+caa4CLl1GiC1lVDXF3Qq0jCLsq4lncEjos3fm1d8raTQQI
         hWrD1dAyO5UtKEbMJ5xYXM4Wsnbp/VxPZLisb/EABgdhUgIZHG+0iX3kYie1AVkM5C
         fjp00cc2uzyPw==
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
Subject: [RFC 6/6] pci: hotplug: move cardbus code from drivers/pcmcia
Date:   Mon, 27 Feb 2023 14:34:57 +0100
Message-Id: <20230227133457.431729-7-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230227133457.431729-1-arnd@kernel.org>
References: <20230227133457.431729-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

16-bit pcmcia and 32-bit cardbus code are now completely separate
code bases, with the cardbus implementation just interfacig with
the PCI core for hotplugging cards, so move it to the same place
as the other PCI hotplug drivers.

The pcmcia/i82365.h header file is the only bit that contains shared
definitions for common registers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/Makefile                              |  2 +-
 drivers/pci/hotplug/Kconfig                   | 56 +++++++++++++++++++
 drivers/pci/hotplug/Makefile                  |  1 +
 .../{pcmcia => pci/hotplug}/yenta_socket.c    |  2 +-
 drivers/pcmcia/Kconfig                        | 56 -------------------
 drivers/pcmcia/Makefile                       |  3 -
 drivers/pcmcia/i82092.c                       |  2 +-
 drivers/pcmcia/i82365.c                       |  2 +-
 drivers/pcmcia/pd6729.c                       |  3 +-
 {drivers => include}/pcmcia/i82365.h          |  0
 10 files changed, 62 insertions(+), 65 deletions(-)
 rename drivers/{pcmcia => pci/hotplug}/yenta_socket.c (99%)
 rename {drivers => include}/pcmcia/i82365.h (100%)

diff --git a/drivers/Makefile b/drivers/Makefile
index bdf1c66141c9..900a37a1b401 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -93,7 +93,7 @@ obj-$(CONFIG_UIO)		+= uio/
 obj-$(CONFIG_VFIO)		+= vfio/
 obj-y				+= cdrom/
 obj-y				+= auxdisplay/
-obj-$(CONFIG_PCCARD)		+= pcmcia/
+obj-$(CONFIG_PCMCIA)		+= pcmcia/
 obj-$(CONFIG_DIO)		+= dio/
 obj-$(CONFIG_SBUS)		+= sbus/
 obj-$(CONFIG_ZORRO)		+= zorro/
diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
index 48113b210cf9..83941cb45291 100644
--- a/drivers/pci/hotplug/Kconfig
+++ b/drivers/pci/hotplug/Kconfig
@@ -161,4 +161,60 @@ config HOTPLUG_PCI_S390
 
 	  When in doubt, say Y.
 
+config CARDBUS
+	tristate "32-bit CardBus support"
+	depends on PCI
+	select YENTA
+	default PCCARD
+	help
+	  CardBus is a bus mastering architecture for PC-cards, which allows
+	  for 32 bit PC-cards (the original PCMCIA standard specifies only
+	  a 16 bit wide bus). Many newer PC-cards are actually CardBus cards.
+
+	  To use 32 bit PC-cards, you also need a CardBus compatible host
+	  bridge. Virtually all modern PCMCIA bridges do this, and most of
+	  them are "yenta-compatible", so say Y or M there, too.
+
+	  If unsure, say Y.
+
+config YENTA
+	tristate "CardBus yenta-compatible bridge support" if EXPERT
+	depends on PCI && CARDBUS
+	default y
+	help
+	  This option enables support for CardBus host bridges.  Virtually
+	  all modern PCMCIA bridges are CardBus compatible.  A "bridge" is
+	  the hardware inside your computer that PCMCIA cards are plugged
+	  into.
+
+	  To compile this driver as modules, choose M here: the
+	  module will be called yenta_socket.
+
+	  If unsure, say Y.
+
+config YENTA_O2
+	default y
+	bool "Special initialization for O2Micro bridges" if EXPERT
+	depends on YENTA
+
+config YENTA_RICOH
+	default y
+	bool "Special initialization for Ricoh bridges" if EXPERT
+	depends on YENTA
+
+config YENTA_TI
+	default y
+	bool "Special initialization for TI and EnE bridges" if EXPERT
+	depends on YENTA
+
+config YENTA_ENE_TUNE
+	default y
+	bool "Auto-tune EnE bridges for CB cards" if EXPERT
+	depends on YENTA_TI && CARDBUS
+
+config YENTA_TOSHIBA
+	default y
+	bool "Special initialization for Toshiba ToPIC bridges" if EXPERT
+	depends on YENTA
+
 endif # HOTPLUG_PCI
diff --git a/drivers/pci/hotplug/Makefile b/drivers/pci/hotplug/Makefile
index 5196983220df..8b655c283565 100644
--- a/drivers/pci/hotplug/Makefile
+++ b/drivers/pci/hotplug/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_HOTPLUG_PCI_RPA)		+= rpaphp.o
 obj-$(CONFIG_HOTPLUG_PCI_RPA_DLPAR)	+= rpadlpar_io.o
 obj-$(CONFIG_HOTPLUG_PCI_ACPI)		+= acpiphp.o
 obj-$(CONFIG_HOTPLUG_PCI_S390)		+= s390_pci_hpc.o
+obj-$(CONFIG_CARDBUS)			+= yenta_socket.o
 
 # acpiphp_ibm extends acpiphp, so should be linked afterwards.
 
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pci/hotplug/yenta_socket.c
similarity index 99%
rename from drivers/pcmcia/yenta_socket.c
rename to drivers/pci/hotplug/yenta_socket.c
index 68b852f18cbb..3b530ce76809 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pci/hotplug/yenta_socket.c
@@ -34,7 +34,7 @@
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <asm/irq.h>
-#include "i82365.h"
+#include <pcmcia/i82365.h>
 
 /* Definitions for card status flags for GetStatus */
 #define SS_WRPROT	0x0001
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index c05d95cf7d3e..3c4b895dba80 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -53,67 +53,11 @@ config PCMCIA_LOAD_CIS
 
 	  If unsure, say Y.
 
-config CARDBUS
-	tristate "32-bit CardBus support"
-	depends on PCI
-	select YENTA
-	default y
-	help
-	  CardBus is a bus mastering architecture for PC-cards, which allows
-	  for 32 bit PC-cards (the original PCMCIA standard specifies only
-	  a 16 bit wide bus). Many newer PC-cards are actually CardBus cards.
-
-	  To use 32 bit PC-cards, you also need a CardBus compatible host
-	  bridge. Virtually all modern PCMCIA bridges do this, and most of
-	  them are "yenta-compatible", so say Y or M there, too.
-
-	  If unsure, say Y.
-
 config PCMCIA_MAX1600
 	tristate
 
 comment "PC-card bridges"
 
-config YENTA
-	tristate "CardBus yenta-compatible bridge support" if EXPERT
-	depends on PCI && CARDBUS
-	default y
-	help
-	  This option enables support for CardBus host bridges.  Virtually
-	  all modern PCMCIA bridges are CardBus compatible.  A "bridge" is
-	  the hardware inside your computer that PCMCIA cards are plugged
-	  into.
-
-	  To compile this driver as modules, choose M here: the
-	  module will be called yenta_socket.
-
-	  If unsure, say Y.
-
-config YENTA_O2
-	default y
-	bool "Special initialization for O2Micro bridges" if EXPERT
-	depends on YENTA
-
-config YENTA_RICOH
-	default y
-	bool "Special initialization for Ricoh bridges" if EXPERT
-	depends on YENTA
-
-config YENTA_TI
-	default y
-	bool "Special initialization for TI and EnE bridges" if EXPERT
-	depends on YENTA
-
-config YENTA_ENE_TUNE
-	default y
-	bool "Auto-tune EnE bridges for CB cards" if EXPERT
-	depends on YENTA_TI && CARDBUS
-
-config YENTA_TOSHIBA
-	default y
-	bool "Special initialization for Toshiba ToPIC bridges" if EXPERT
-	depends on YENTA
-
 config PD6729
 	tristate "Cirrus PD6729 compatible bridge support"
 	depends on PCMCIA && PCI
diff --git a/drivers/pcmcia/Makefile b/drivers/pcmcia/Makefile
index 4d0af3e27c1c..481468778f46 100644
--- a/drivers/pcmcia/Makefile
+++ b/drivers/pcmcia/Makefile
@@ -14,9 +14,6 @@ obj-$(CONFIG_PCMCIA)				+= pcmcia_rsrc.o
 
 
 # socket drivers
-
-obj-$(CONFIG_YENTA) 				+= yenta_socket.o
-
 obj-$(CONFIG_PD6729)				+= pd6729.o
 obj-$(CONFIG_I82365)				+= i82365.o
 obj-$(CONFIG_I82092)				+= i82092.o
diff --git a/drivers/pcmcia/i82092.c b/drivers/pcmcia/i82092.c
index a335748bdef5..b74eb77e7489 100644
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -17,11 +17,11 @@
 #include <linux/device.h>
 
 #include <pcmcia/ss.h>
+#include <pcmcia/i82365.h>
 
 #include <linux/io.h>
 
 #include "i82092aa.h"
-#include "i82365.h"
 
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/pcmcia/i82365.c b/drivers/pcmcia/i82365.c
index 891ccea2cccb..bb4045b4613a 100644
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -54,7 +54,7 @@
 #include <linux/isapnp.h>
 
 /* ISA-bus controllers */
-#include "i82365.h"
+#include <pcmcia/i82365.h>
 #include "cirrus.h"
 #include "vg468.h"
 #include "ricoh.h"
diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index a0a2e7f18356..ec8c093e7fd0 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -18,10 +18,9 @@
 #include <linux/io.h>
 
 #include <pcmcia/ss.h>
-
+#include <pcmcia/i82365.h>
 
 #include "pd6729.h"
-#include "i82365.h"
 #include "cirrus.h"
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/pcmcia/i82365.h b/include/pcmcia/i82365.h
similarity index 100%
rename from drivers/pcmcia/i82365.h
rename to include/pcmcia/i82365.h
-- 
2.39.2

