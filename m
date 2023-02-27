Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740646A42D7
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjB0Nfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjB0Nfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:35:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6229295;
        Mon, 27 Feb 2023 05:35:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B112FB80B1E;
        Mon, 27 Feb 2023 13:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADB3C4339E;
        Mon, 27 Feb 2023 13:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677504927;
        bh=evm2cwWmLNjJku1CkjApAKe7ySgjWdCrvoejhcV8Ygo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gBvKUCyOMQNZu5Y+VWnElXF/PkzKxZOhC0o7Mi+eWns4RIARyKXwPdyCEiPSjh3Rp
         7kj31CcJY/PET0xQVARgmVRpeqoa69ro3ipk7Arfx2bDokOudFg8KUKLOQB2ljrkx4
         y/P7ZZ0uSuN70jreXkkiw3IqfYNyTBiSIBWK82ZKb6TkdGD4lQzmIVYxdL1ZvTAEFv
         cG7/XfGtN10abT9SG9U73EksBlPd6JvS7bQ4tfboHiiSjqcbZaFBUqX78MldN7RLXS
         rp3eoZzLWMVHD04Dhfmhf1xFFowUY/gjBAckoAlcoeSNSuZNMIYGtSPF7jKsZPVEzk
         T59UdO+y+LyEg==
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
Subject: [RFC 1/6] pccard: remove bcm63xx socket driver
Date:   Mon, 27 Feb 2023 14:34:52 +0100
Message-Id: <20230227133457.431729-2-arnd@kernel.org>
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

The bcm63xx pcmcia driver is the only nonstandard cardbus implementation,
everything else is handled by the yenta_socket driver. Upon a closer
look, this seems entirely unused, because:

 - There are two ports for bcm63xx in arch/mips, both of which
   support the bcm6358 hardware, but the newer one does not
   use this driver at all.

 - The only distro I could find for bcm63xx is OpenWRT, but they
   do not enable pcmcia support. However they have 130 patches,
   a lot of which are likely required to run anything at all.

 - The device list at https://deviwiki.com/wiki/Broadcom only
   lists machines using mini-PCI cards rather than PCMCIA or
   Cardbus devices.

 - The cardbus support is entirely made up to work with the
   kernel subsystem, but the hardware appears to just be a normal
   PCI host that should work fine after removing all the cardbus
   code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/mips/bcm63xx/Makefile                    |   2 +-
 arch/mips/bcm63xx/boards/board_bcm963xx.c     |  14 -
 arch/mips/bcm63xx/dev-pcmcia.c                | 144 -----
 arch/mips/configs/bcm63xx_defconfig           |   1 -
 .../asm/mach-bcm63xx/bcm63xx_dev_pcmcia.h     |  14 -
 arch/mips/pci/ops-bcm63xx.c                   | 294 ----------
 arch/mips/pci/pci-bcm63xx.c                   |  44 --
 drivers/pcmcia/Kconfig                        |   4 -
 drivers/pcmcia/Makefile                       |   1 -
 drivers/pcmcia/bcm63xx_pcmcia.c               | 538 ------------------
 drivers/pcmcia/bcm63xx_pcmcia.h               |  61 --
 11 files changed, 1 insertion(+), 1116 deletions(-)
 delete mode 100644 arch/mips/bcm63xx/dev-pcmcia.c
 delete mode 100644 arch/mips/include/asm/mach-bcm63xx/bcm63xx_dev_pcmcia.h
 delete mode 100644 drivers/pcmcia/bcm63xx_pcmcia.c
 delete mode 100644 drivers/pcmcia/bcm63xx_pcmcia.h

diff --git a/arch/mips/bcm63xx/Makefile b/arch/mips/bcm63xx/Makefile
index d89651e538f6..fccaeeee757d 100644
--- a/arch/mips/bcm63xx/Makefile
+++ b/arch/mips/bcm63xx/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y		+= clk.o cpu.o cs.o gpio.o irq.o nvram.o prom.o reset.o \
-		   setup.o timer.o dev-enet.o dev-flash.o dev-pcmcia.o \
+		   setup.o timer.o dev-enet.o dev-flash.o \
 		   dev-rng.o dev-spi.o dev-hsspi.o dev-uart.o dev-wdt.o \
 		   dev-usb-usbd.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
diff --git a/arch/mips/bcm63xx/boards/board_bcm963xx.c b/arch/mips/bcm63xx/boards/board_bcm963xx.c
index 01aff80a5967..d88d3043a288 100644
--- a/arch/mips/bcm63xx/boards/board_bcm963xx.c
+++ b/arch/mips/bcm63xx/boards/board_bcm963xx.c
@@ -22,7 +22,6 @@
 #include <bcm63xx_dev_enet.h>
 #include <bcm63xx_dev_flash.h>
 #include <bcm63xx_dev_hsspi.h>
-#include <bcm63xx_dev_pcmcia.h>
 #include <bcm63xx_dev_spi.h>
 #include <bcm63xx_dev_usb_usbd.h>
 #include <board_bcm963xx.h>
@@ -266,7 +265,6 @@ static struct board_info __initdata board_96348gw_10 = {
 	.expected_cpu_id = 0x6348,
 
 	.has_ohci0 = 1,
-	.has_pccard = 1,
 	.has_pci = 1,
 	.has_uart0 = 1,
 
@@ -317,7 +315,6 @@ static struct board_info __initdata board_96348gw_11 = {
 	.expected_cpu_id = 0x6348,
 
 	.has_ohci0 = 1,
-	.has_pccard = 1,
 	.has_pci = 1,
 	.has_uart0 = 1,
 
@@ -418,7 +415,6 @@ static struct board_info __initdata board_FAST2404 = {
 	.expected_cpu_id = 0x6348,
 
 	.has_ohci0 = 1,
-	.has_pccard = 1,
 	.has_pci = 1,
 	.has_uart0 = 1,
 
@@ -507,7 +503,6 @@ static struct board_info __initdata board_96358vw = {
 
 	.has_ehci0 = 1,
 	.has_ohci0 = 1,
-	.has_pccard = 1,
 	.has_pci = 1,
 	.has_uart0 = 1,
 
@@ -557,7 +552,6 @@ static struct board_info __initdata board_96358vw2 = {
 
 	.has_ehci0 = 1,
 	.has_ohci0 = 1,
-	.has_pccard = 1,
 	.has_pci = 1,
 	.has_uart0 = 1,
 
@@ -807,11 +801,6 @@ void __init board_prom_init(void)
 	}
 #endif /* CONFIG_PCI */
 
-	if (board.has_pccard) {
-		if (BCMCPU_IS_6348())
-			val |= GPIO_MODE_6348_G1_MII_PCCARD;
-	}
-
 	if (board.has_enet0 && !board.enet0.use_internal_phy) {
 		if (BCMCPU_IS_6348())
 			val |= GPIO_MODE_6348_G3_EXT_MII |
@@ -861,9 +850,6 @@ int __init board_register_devices(void)
 	if (board.has_uart1)
 		bcm63xx_uart_register(1);
 
-	if (board.has_pccard)
-		bcm63xx_pcmcia_register();
-
 	if (board.has_enet0 &&
 	    !bcm63xx_nvram_get_mac_address(board.enet0.mac_addr))
 		bcm63xx_enet_register(0, &board.enet0);
diff --git a/arch/mips/bcm63xx/dev-pcmcia.c b/arch/mips/bcm63xx/dev-pcmcia.c
deleted file mode 100644
index 9496cd236951..000000000000
--- a/arch/mips/bcm63xx/dev-pcmcia.c
+++ /dev/null
@@ -1,144 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2008 Maxime Bizon <mbizon@freebox.fr>
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <asm/bootinfo.h>
-#include <linux/platform_device.h>
-#include <bcm63xx_cs.h>
-#include <bcm63xx_cpu.h>
-#include <bcm63xx_dev_pcmcia.h>
-#include <bcm63xx_io.h>
-#include <bcm63xx_regs.h>
-
-static struct resource pcmcia_resources[] = {
-	/* pcmcia registers */
-	{
-		/* start & end filled at runtime */
-		.flags		= IORESOURCE_MEM,
-	},
-
-	/* pcmcia memory zone resources */
-	{
-		.start		= BCM_PCMCIA_COMMON_BASE_PA,
-		.end		= BCM_PCMCIA_COMMON_END_PA,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= BCM_PCMCIA_ATTR_BASE_PA,
-		.end		= BCM_PCMCIA_ATTR_END_PA,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= BCM_PCMCIA_IO_BASE_PA,
-		.end		= BCM_PCMCIA_IO_END_PA,
-		.flags		= IORESOURCE_MEM,
-	},
-
-	/* PCMCIA irq */
-	{
-		/* start filled at runtime */
-		.flags		= IORESOURCE_IRQ,
-	},
-
-	/* declare PCMCIA IO resource also */
-	{
-		.start		= BCM_PCMCIA_IO_BASE_PA,
-		.end		= BCM_PCMCIA_IO_END_PA,
-		.flags		= IORESOURCE_IO,
-	},
-};
-
-static struct bcm63xx_pcmcia_platform_data pd;
-
-static struct platform_device bcm63xx_pcmcia_device = {
-	.name		= "bcm63xx_pcmcia",
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(pcmcia_resources),
-	.resource	= pcmcia_resources,
-	.dev		= {
-		.platform_data = &pd,
-	},
-};
-
-static int __init config_pcmcia_cs(unsigned int cs,
-				   u32 base, unsigned int size)
-{
-	int ret;
-
-	ret = bcm63xx_set_cs_status(cs, 0);
-	if (!ret)
-		ret = bcm63xx_set_cs_base(cs, base, size);
-	if (!ret)
-		ret = bcm63xx_set_cs_status(cs, 1);
-	return ret;
-}
-
-static const struct {
-	unsigned int	cs;
-	unsigned int	base;
-	unsigned int	size;
-} pcmcia_cs[3] __initconst = {
-	{
-		.cs	= MPI_CS_PCMCIA_COMMON,
-		.base	= BCM_PCMCIA_COMMON_BASE_PA,
-		.size	= BCM_PCMCIA_COMMON_SIZE
-	},
-	{
-		.cs	= MPI_CS_PCMCIA_ATTR,
-		.base	= BCM_PCMCIA_ATTR_BASE_PA,
-		.size	= BCM_PCMCIA_ATTR_SIZE
-	},
-	{
-		.cs	= MPI_CS_PCMCIA_IO,
-		.base	= BCM_PCMCIA_IO_BASE_PA,
-		.size	= BCM_PCMCIA_IO_SIZE
-	},
-};
-
-int __init bcm63xx_pcmcia_register(void)
-{
-	int ret, i;
-
-	if (!BCMCPU_IS_6348() && !BCMCPU_IS_6358())
-		return 0;
-
-	/* use correct pcmcia ready gpio depending on processor */
-	switch (bcm63xx_get_cpu_id()) {
-	case BCM6348_CPU_ID:
-		pd.ready_gpio = 22;
-		break;
-
-	case BCM6358_CPU_ID:
-		pd.ready_gpio = 18;
-		break;
-
-	default:
-		return -ENODEV;
-	}
-
-	pcmcia_resources[0].start = bcm63xx_regset_address(RSET_PCMCIA);
-	pcmcia_resources[0].end = pcmcia_resources[0].start +
-		RSET_PCMCIA_SIZE - 1;
-	pcmcia_resources[4].start = bcm63xx_get_irq_number(IRQ_PCMCIA);
-
-	/* configure pcmcia chip selects */
-	for (i = 0; i < 3; i++) {
-		ret = config_pcmcia_cs(pcmcia_cs[i].cs,
-				       pcmcia_cs[i].base,
-				       pcmcia_cs[i].size);
-		if (ret)
-			goto out_err;
-	}
-
-	return platform_device_register(&bcm63xx_pcmcia_device);
-
-out_err:
-	pr_err("unable to set pcmcia chip select\n");
-	return ret;
-}
diff --git a/arch/mips/configs/bcm63xx_defconfig b/arch/mips/configs/bcm63xx_defconfig
index 34d0ca638ef0..d1a185c20f00 100644
--- a/arch/mips/configs/bcm63xx_defconfig
+++ b/arch/mips/configs/bcm63xx_defconfig
@@ -19,7 +19,6 @@ CONFIG_BCM63XX_CPU_6358=y
 # CONFIG_SECCOMP is not set
 CONFIG_PCI=y
 CONFIG_PCCARD=y
-CONFIG_PCMCIA_BCM63XX=y
 # CONFIG_BLK_DEV_BSG is not set
 CONFIG_NET=y
 CONFIG_UNIX=y
diff --git a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_dev_pcmcia.h b/arch/mips/include/asm/mach-bcm63xx/bcm63xx_dev_pcmcia.h
deleted file mode 100644
index 01674ac58bb5..000000000000
--- a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_dev_pcmcia.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef BCM63XX_DEV_PCMCIA_H_
-#define BCM63XX_DEV_PCMCIA_H_
-
-/*
- * PCMCIA driver platform data
- */
-struct bcm63xx_pcmcia_platform_data {
-	unsigned int ready_gpio;
-};
-
-int bcm63xx_pcmcia_register(void);
-
-#endif /* BCM63XX_DEV_PCMCIA_H_ */
diff --git a/arch/mips/pci/ops-bcm63xx.c b/arch/mips/pci/ops-bcm63xx.c
index dc6dc2741272..4cb6185a9f66 100644
--- a/arch/mips/pci/ops-bcm63xx.c
+++ b/arch/mips/pci/ops-bcm63xx.c
@@ -151,9 +151,6 @@ static int bcm63xx_pci_read(struct pci_bus *bus, unsigned int devfn,
 
 	type = bus->parent ? 1 : 0;
 
-	if (type == 0 && PCI_SLOT(devfn) == CARDBUS_PCI_IDSEL)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
 	return bcm63xx_do_cfg_read(type, bus->number, devfn,
 				    where, size, val);
 }
@@ -165,9 +162,6 @@ static int bcm63xx_pci_write(struct pci_bus *bus, unsigned int devfn,
 
 	type = bus->parent ? 1 : 0;
 
-	if (type == 0 && PCI_SLOT(devfn) == CARDBUS_PCI_IDSEL)
-		return PCIBIOS_DEVICE_NOT_FOUND;
-
 	return bcm63xx_do_cfg_write(type, bus->number, devfn,
 				     where, size, val);
 }
@@ -177,294 +171,6 @@ struct pci_ops bcm63xx_pci_ops = {
 	.write	= bcm63xx_pci_write
 };
 
-#ifdef CONFIG_CARDBUS
-/*
- * emulate configuration read access on a cardbus bridge
- */
-#define FAKE_CB_BRIDGE_SLOT	0x1e
-
-static int fake_cb_bridge_bus_number = -1;
-
-static struct {
-	u16 pci_command;
-	u8 cb_latency;
-	u8 subordinate_busn;
-	u8 cardbus_busn;
-	u8 pci_busn;
-	int bus_assigned;
-	u16 bridge_control;
-
-	u32 mem_base0;
-	u32 mem_limit0;
-	u32 mem_base1;
-	u32 mem_limit1;
-
-	u32 io_base0;
-	u32 io_limit0;
-	u32 io_base1;
-	u32 io_limit1;
-} fake_cb_bridge_regs;
-
-static int fake_cb_bridge_read(int where, int size, u32 *val)
-{
-	unsigned int reg;
-	u32 data;
-
-	data = 0;
-	reg = where >> 2;
-	switch (reg) {
-	case (PCI_VENDOR_ID >> 2):
-	case (PCI_CB_SUBSYSTEM_VENDOR_ID >> 2):
-		/* create dummy vendor/device id from our cpu id */
-		data = (bcm63xx_get_cpu_id() << 16) | PCI_VENDOR_ID_BROADCOM;
-		break;
-
-	case (PCI_COMMAND >> 2):
-		data = (PCI_STATUS_DEVSEL_SLOW << 16);
-		data |= fake_cb_bridge_regs.pci_command;
-		break;
-
-	case (PCI_CLASS_REVISION >> 2):
-		data = (PCI_CLASS_BRIDGE_CARDBUS << 16);
-		break;
-
-	case (PCI_CACHE_LINE_SIZE >> 2):
-		data = (PCI_HEADER_TYPE_CARDBUS << 16);
-		break;
-
-	case (PCI_INTERRUPT_LINE >> 2):
-		/* bridge control */
-		data = (fake_cb_bridge_regs.bridge_control << 16);
-		/* pin:intA line:0xff */
-		data |= (0x1 << 8) | 0xff;
-		break;
-
-	case (PCI_CB_PRIMARY_BUS >> 2):
-		data = (fake_cb_bridge_regs.cb_latency << 24);
-		data |= (fake_cb_bridge_regs.subordinate_busn << 16);
-		data |= (fake_cb_bridge_regs.cardbus_busn << 8);
-		data |= fake_cb_bridge_regs.pci_busn;
-		break;
-
-	case (PCI_CB_MEMORY_BASE_0 >> 2):
-		data = fake_cb_bridge_regs.mem_base0;
-		break;
-
-	case (PCI_CB_MEMORY_LIMIT_0 >> 2):
-		data = fake_cb_bridge_regs.mem_limit0;
-		break;
-
-	case (PCI_CB_MEMORY_BASE_1 >> 2):
-		data = fake_cb_bridge_regs.mem_base1;
-		break;
-
-	case (PCI_CB_MEMORY_LIMIT_1 >> 2):
-		data = fake_cb_bridge_regs.mem_limit1;
-		break;
-
-	case (PCI_CB_IO_BASE_0 >> 2):
-		/* | 1 for 32bits io support */
-		data = fake_cb_bridge_regs.io_base0 | 0x1;
-		break;
-
-	case (PCI_CB_IO_LIMIT_0 >> 2):
-		data = fake_cb_bridge_regs.io_limit0;
-		break;
-
-	case (PCI_CB_IO_BASE_1 >> 2):
-		/* | 1 for 32bits io support */
-		data = fake_cb_bridge_regs.io_base1 | 0x1;
-		break;
-
-	case (PCI_CB_IO_LIMIT_1 >> 2):
-		data = fake_cb_bridge_regs.io_limit1;
-		break;
-	}
-
-	*val = postprocess_read(data, where, size);
-	return PCIBIOS_SUCCESSFUL;
-}
-
-/*
- * emulate configuration write access on a cardbus bridge
- */
-static int fake_cb_bridge_write(int where, int size, u32 val)
-{
-	unsigned int reg;
-	u32 data, tmp;
-	int ret;
-
-	ret = fake_cb_bridge_read((where & ~0x3), 4, &data);
-	if (ret != PCIBIOS_SUCCESSFUL)
-		return ret;
-
-	data = preprocess_write(data, val, where, size);
-
-	reg = where >> 2;
-	switch (reg) {
-	case (PCI_COMMAND >> 2):
-		fake_cb_bridge_regs.pci_command = (data & 0xffff);
-		break;
-
-	case (PCI_CB_PRIMARY_BUS >> 2):
-		fake_cb_bridge_regs.cb_latency = (data >> 24) & 0xff;
-		fake_cb_bridge_regs.subordinate_busn = (data >> 16) & 0xff;
-		fake_cb_bridge_regs.cardbus_busn = (data >> 8) & 0xff;
-		fake_cb_bridge_regs.pci_busn = data & 0xff;
-		if (fake_cb_bridge_regs.cardbus_busn)
-			fake_cb_bridge_regs.bus_assigned = 1;
-		break;
-
-	case (PCI_INTERRUPT_LINE >> 2):
-		tmp = (data >> 16) & 0xffff;
-		/* disable memory prefetch support */
-		tmp &= ~PCI_CB_BRIDGE_CTL_PREFETCH_MEM0;
-		tmp &= ~PCI_CB_BRIDGE_CTL_PREFETCH_MEM1;
-		fake_cb_bridge_regs.bridge_control = tmp;
-		break;
-
-	case (PCI_CB_MEMORY_BASE_0 >> 2):
-		fake_cb_bridge_regs.mem_base0 = data;
-		break;
-
-	case (PCI_CB_MEMORY_LIMIT_0 >> 2):
-		fake_cb_bridge_regs.mem_limit0 = data;
-		break;
-
-	case (PCI_CB_MEMORY_BASE_1 >> 2):
-		fake_cb_bridge_regs.mem_base1 = data;
-		break;
-
-	case (PCI_CB_MEMORY_LIMIT_1 >> 2):
-		fake_cb_bridge_regs.mem_limit1 = data;
-		break;
-
-	case (PCI_CB_IO_BASE_0 >> 2):
-		fake_cb_bridge_regs.io_base0 = data;
-		break;
-
-	case (PCI_CB_IO_LIMIT_0 >> 2):
-		fake_cb_bridge_regs.io_limit0 = data;
-		break;
-
-	case (PCI_CB_IO_BASE_1 >> 2):
-		fake_cb_bridge_regs.io_base1 = data;
-		break;
-
-	case (PCI_CB_IO_LIMIT_1 >> 2):
-		fake_cb_bridge_regs.io_limit1 = data;
-		break;
-	}
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static int bcm63xx_cb_read(struct pci_bus *bus, unsigned int devfn,
-			   int where, int size, u32 *val)
-{
-	/* snoop access to slot 0x1e on root bus, we fake a cardbus
-	 * bridge at this location */
-	if (!bus->parent && PCI_SLOT(devfn) == FAKE_CB_BRIDGE_SLOT) {
-		fake_cb_bridge_bus_number = bus->number;
-		return fake_cb_bridge_read(where, size, val);
-	}
-
-	/* a  configuration  cycle for	the  device  behind the	 cardbus
-	 * bridge is  actually done as a  type 0 cycle	on the primary
-	 * bus. This means that only  one device can be on the cardbus
-	 * bus */
-	if (fake_cb_bridge_regs.bus_assigned &&
-	    bus->number == fake_cb_bridge_regs.cardbus_busn &&
-	    PCI_SLOT(devfn) == 0)
-		return bcm63xx_do_cfg_read(0, 0,
-					   PCI_DEVFN(CARDBUS_PCI_IDSEL, 0),
-					   where, size, val);
-
-	return PCIBIOS_DEVICE_NOT_FOUND;
-}
-
-static int bcm63xx_cb_write(struct pci_bus *bus, unsigned int devfn,
-			    int where, int size, u32 val)
-{
-	if (!bus->parent && PCI_SLOT(devfn) == FAKE_CB_BRIDGE_SLOT) {
-		fake_cb_bridge_bus_number = bus->number;
-		return fake_cb_bridge_write(where, size, val);
-	}
-
-	if (fake_cb_bridge_regs.bus_assigned &&
-	    bus->number == fake_cb_bridge_regs.cardbus_busn &&
-	    PCI_SLOT(devfn) == 0)
-		return bcm63xx_do_cfg_write(0, 0,
-					    PCI_DEVFN(CARDBUS_PCI_IDSEL, 0),
-					    where, size, val);
-
-	return PCIBIOS_DEVICE_NOT_FOUND;
-}
-
-struct pci_ops bcm63xx_cb_ops = {
-	.read	= bcm63xx_cb_read,
-	.write	 = bcm63xx_cb_write,
-};
-
-/*
- * only one IO window, so it  cannot be shared by PCI and cardbus, use
- * fixup to choose and detect unhandled configuration
- */
-static void bcm63xx_fixup(struct pci_dev *dev)
-{
-	static int io_window = -1;
-	int i, found, new_io_window;
-	u32 val;
-
-	/* look for any io resource */
-	found = 0;
-	for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-		if (pci_resource_flags(dev, i) & IORESOURCE_IO) {
-			found = 1;
-			break;
-		}
-	}
-
-	if (!found)
-		return;
-
-	/* skip our fake bus with only cardbus bridge on it */
-	if (dev->bus->number == fake_cb_bridge_bus_number)
-		return;
-
-	/* find on which bus the device is */
-	if (fake_cb_bridge_regs.bus_assigned &&
-	    dev->bus->number == fake_cb_bridge_regs.cardbus_busn &&
-	    PCI_SLOT(dev->devfn) == 0)
-		new_io_window = 1;
-	else
-		new_io_window = 0;
-
-	if (new_io_window == io_window)
-		return;
-
-	if (io_window != -1) {
-		printk(KERN_ERR "bcm63xx: both PCI and cardbus devices "
-		       "need IO, which hardware cannot do\n");
-		return;
-	}
-
-	printk(KERN_INFO "bcm63xx: PCI IO window assigned to %s\n",
-	       (new_io_window == 0) ? "PCI" : "cardbus");
-
-	val = bcm_mpi_readl(MPI_L2PIOREMAP_REG);
-	if (io_window)
-		val |= MPI_L2PREMAP_IS_CARDBUS_MASK;
-	else
-		val &= ~MPI_L2PREMAP_IS_CARDBUS_MASK;
-	bcm_mpi_writel(val, MPI_L2PIOREMAP_REG);
-
-	io_window = new_io_window;
-}
-
-DECLARE_PCI_FIXUP_ENABLE(PCI_ANY_ID, PCI_ANY_ID, bcm63xx_fixup);
-#endif
-
 static int bcm63xx_pcie_can_access(struct pci_bus *bus, int devfn)
 {
 	switch (bus->number) {
diff --git a/arch/mips/pci/pci-bcm63xx.c b/arch/mips/pci/pci-bcm63xx.c
index ac83243772d2..ebe062b149f6 100644
--- a/arch/mips/pci/pci-bcm63xx.c
+++ b/arch/mips/pci/pci-bcm63xx.c
@@ -34,11 +34,7 @@ static struct resource bcm_pci_mem_resource = {
 static struct resource bcm_pci_io_resource = {
 	.name	= "bcm63xx PCI IO space",
 	.start	= BCM_PCI_IO_BASE_PA,
-#ifdef CONFIG_CARDBUS
-	.end	= BCM_PCI_IO_HALF_PA,
-#else
 	.end	= BCM_PCI_IO_END_PA,
-#endif
 	.flags	= IORESOURCE_IO
 };
 
@@ -48,33 +44,6 @@ struct pci_controller bcm63xx_controller = {
 	.mem_resource	= &bcm_pci_mem_resource,
 };
 
-/*
- * We handle cardbus  via a fake Cardbus bridge,  memory and io spaces
- * have to be  clearly separated from PCI one  since we have different
- * memory decoder.
- */
-#ifdef CONFIG_CARDBUS
-static struct resource bcm_cb_mem_resource = {
-	.name	= "bcm63xx Cardbus memory space",
-	.start	= BCM_CB_MEM_BASE_PA,
-	.end	= BCM_CB_MEM_END_PA,
-	.flags	= IORESOURCE_MEM
-};
-
-static struct resource bcm_cb_io_resource = {
-	.name	= "bcm63xx Cardbus IO space",
-	.start	= BCM_PCI_IO_HALF_PA + 1,
-	.end	= BCM_PCI_IO_END_PA,
-	.flags	= IORESOURCE_IO
-};
-
-struct pci_controller bcm63xx_cb_controller = {
-	.pci_ops	= &bcm63xx_cb_ops,
-	.io_resource	= &bcm_cb_io_resource,
-	.mem_resource	= &bcm_cb_mem_resource,
-};
-#endif
-
 static struct resource bcm_pcie_mem_resource = {
 	.name	= "bcm63xx PCIe memory space",
 	.start	= BCM_PCIE_MEM_BASE_PA,
@@ -238,17 +207,8 @@ static int __init bcm63xx_register_pci(void)
 	val |= (CARDBUS_PCI_IDSEL << PCMCIA_C1_CBIDSEL_SHIFT);
 	bcm_pcmcia_writel(val, PCMCIA_C1_REG);
 
-#ifdef CONFIG_CARDBUS
-	/* setup local bus to PCI access (Cardbus memory) */
-	val = BCM_CB_MEM_BASE_PA & MPI_L2P_BASE_MASK;
-	bcm_mpi_writel(val, MPI_L2PMEMBASE2_REG);
-	bcm_mpi_writel(~(BCM_CB_MEM_SIZE - 1), MPI_L2PMEMRANGE2_REG);
-	val |= MPI_L2PREMAP_ENABLED_MASK | MPI_L2PREMAP_IS_CARDBUS_MASK;
-	bcm_mpi_writel(val, MPI_L2PMEMREMAP2_REG);
-#else
 	/* disable second access windows */
 	bcm_mpi_writel(0, MPI_L2PMEMREMAP2_REG);
-#endif
 
 	/* setup local bus  to PCI access (IO memory),	we have only 1
 	 * IO window  for both PCI  and cardbus, but it	 cannot handle
@@ -318,10 +278,6 @@ static int __init bcm63xx_register_pci(void)
 
 	register_pci_controller(&bcm63xx_controller);
 
-#ifdef CONFIG_CARDBUS
-	register_pci_controller(&bcm63xx_cb_controller);
-#endif
-
 	/* mark memory space used for IO mapping as reserved */
 	request_mem_region(BCM_PCI_IO_BASE_PA, BCM_PCI_IO_SIZE,
 			   "bcm63xx PCI IO space");
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 1525023e49b6..26c89eefa18e 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -168,10 +168,6 @@ config PCMCIA_XXS1500
 
 	  This driver is also available as a module called xxs1500_ss.ko
 
-config PCMCIA_BCM63XX
-	tristate "bcm63xx pcmcia support"
-	depends on BCM63XX && PCMCIA
-
 config PCMCIA_SOC_COMMON
 	tristate
 
diff --git a/drivers/pcmcia/Makefile b/drivers/pcmcia/Makefile
index b3a2accf47af..67d447c62b8d 100644
--- a/drivers/pcmcia/Makefile
+++ b/drivers/pcmcia/Makefile
@@ -28,7 +28,6 @@ obj-$(CONFIG_PCMCIA_SOC_COMMON)			+= soc_common.o
 obj-$(CONFIG_PCMCIA_SA11XX_BASE)		+= sa11xx_base.o
 obj-$(CONFIG_PCMCIA_SA1100)			+= sa1100_cs.o
 obj-$(CONFIG_PCMCIA_SA1111)			+= sa1111_cs.o
-obj-$(CONFIG_PCMCIA_BCM63XX)			+= bcm63xx_pcmcia.o
 obj-$(CONFIG_OMAP_CF)				+= omap_cf.o
 obj-$(CONFIG_ELECTRA_CF)			+= electra_cf.o
 obj-$(CONFIG_PCMCIA_ALCHEMY_DEVBOARD)		+= db1xxx_ss.o
diff --git a/drivers/pcmcia/bcm63xx_pcmcia.c b/drivers/pcmcia/bcm63xx_pcmcia.c
deleted file mode 100644
index dd3c26099048..000000000000
--- a/drivers/pcmcia/bcm63xx_pcmcia.c
+++ /dev/null
@@ -1,538 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2008 Maxime Bizon <mbizon@freebox.fr>
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/ioport.h>
-#include <linux/timer.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-#include <linux/delay.h>
-#include <linux/pci.h>
-#include <linux/gpio.h>
-
-#include <bcm63xx_regs.h>
-#include <bcm63xx_io.h>
-#include "bcm63xx_pcmcia.h"
-
-#define PFX	"bcm63xx_pcmcia: "
-
-#ifdef CONFIG_CARDBUS
-/* if cardbus is used, platform device needs reference to actual pci
- * device */
-static struct pci_dev *bcm63xx_cb_dev;
-#endif
-
-/*
- * read/write helper for pcmcia regs
- */
-static inline u32 pcmcia_readl(struct bcm63xx_pcmcia_socket *skt, u32 off)
-{
-	return bcm_readl(skt->base + off);
-}
-
-static inline void pcmcia_writel(struct bcm63xx_pcmcia_socket *skt,
-				 u32 val, u32 off)
-{
-	bcm_writel(val, skt->base + off);
-}
-
-/*
- * This callback should (re-)initialise the socket, turn on status
- * interrupts and PCMCIA bus, and wait for power to stabilise so that
- * the card status signals report correctly.
- *
- * Hardware cannot do that.
- */
-static int bcm63xx_pcmcia_sock_init(struct pcmcia_socket *sock)
-{
-	return 0;
-}
-
-/*
- * This callback should remove power on the socket, disable IRQs from
- * the card, turn off status interrupts, and disable the PCMCIA bus.
- *
- * Hardware cannot do that.
- */
-static int bcm63xx_pcmcia_suspend(struct pcmcia_socket *sock)
-{
-	return 0;
-}
-
-/*
- * Implements the set_socket() operation for the in-kernel PCMCIA
- * service (formerly SS_SetSocket in Card Services). We more or
- * less punt all of this work and let the kernel handle the details
- * of power configuration, reset, &c. We also record the value of
- * `state' in order to regurgitate it to the PCMCIA core later.
- */
-static int bcm63xx_pcmcia_set_socket(struct pcmcia_socket *sock,
-				     socket_state_t *state)
-{
-	struct bcm63xx_pcmcia_socket *skt;
-	unsigned long flags;
-	u32 val;
-
-	skt = sock->driver_data;
-
-	spin_lock_irqsave(&skt->lock, flags);
-
-	/* note: hardware cannot control socket power, so we will
-	 * always report SS_POWERON */
-
-	/* apply socket reset */
-	val = pcmcia_readl(skt, PCMCIA_C1_REG);
-	if (state->flags & SS_RESET)
-		val |= PCMCIA_C1_RESET_MASK;
-	else
-		val &= ~PCMCIA_C1_RESET_MASK;
-
-	/* reverse reset logic for cardbus card */
-	if (skt->card_detected && (skt->card_type & CARD_CARDBUS))
-		val ^= PCMCIA_C1_RESET_MASK;
-
-	pcmcia_writel(skt, val, PCMCIA_C1_REG);
-
-	/* keep requested state for event reporting */
-	skt->requested_state = *state;
-
-	spin_unlock_irqrestore(&skt->lock, flags);
-
-	return 0;
-}
-
-/*
- * identity cardtype from VS[12] input, CD[12] input while only VS2 is
- * floating, and CD[12] input while only VS1 is floating
- */
-enum {
-	IN_VS1 = (1 << 0),
-	IN_VS2 = (1 << 1),
-	IN_CD1_VS2H = (1 << 2),
-	IN_CD2_VS2H = (1 << 3),
-	IN_CD1_VS1H = (1 << 4),
-	IN_CD2_VS1H = (1 << 5),
-};
-
-static const u8 vscd_to_cardtype[] = {
-
-	/* VS1 float, VS2 float */
-	[IN_VS1 | IN_VS2] = (CARD_PCCARD | CARD_5V),
-
-	/* VS1 grounded, VS2 float */
-	[IN_VS2] = (CARD_PCCARD | CARD_5V | CARD_3V),
-
-	/* VS1 grounded, VS2 grounded */
-	[0] = (CARD_PCCARD | CARD_5V | CARD_3V | CARD_XV),
-
-	/* VS1 tied to CD1, VS2 float */
-	[IN_VS1 | IN_VS2 | IN_CD1_VS1H] = (CARD_CARDBUS | CARD_3V),
-
-	/* VS1 grounded, VS2 tied to CD2 */
-	[IN_VS2 | IN_CD2_VS2H] = (CARD_CARDBUS | CARD_3V | CARD_XV),
-
-	/* VS1 tied to CD2, VS2 grounded */
-	[IN_VS1 | IN_CD2_VS1H] = (CARD_CARDBUS | CARD_3V | CARD_XV | CARD_YV),
-
-	/* VS1 float, VS2 grounded */
-	[IN_VS1] = (CARD_PCCARD | CARD_XV),
-
-	/* VS1 float, VS2 tied to CD2 */
-	[IN_VS1 | IN_VS2 | IN_CD2_VS2H] = (CARD_CARDBUS | CARD_3V),
-
-	/* VS1 float, VS2 tied to CD1 */
-	[IN_VS1 | IN_VS2 | IN_CD1_VS2H] = (CARD_CARDBUS | CARD_XV | CARD_YV),
-
-	/* VS1 tied to CD2, VS2 float */
-	[IN_VS1 | IN_VS2 | IN_CD2_VS1H] = (CARD_CARDBUS | CARD_YV),
-
-	/* VS2 grounded, VS1 is tied to CD1, CD2 is grounded */
-	[IN_VS1 | IN_CD1_VS1H] = 0, /* ignore cardbay */
-};
-
-/*
- * poll hardware to check card insertion status
- */
-static unsigned int __get_socket_status(struct bcm63xx_pcmcia_socket *skt)
-{
-	unsigned int stat;
-	u32 val;
-
-	stat = 0;
-
-	/* check CD for card presence */
-	val = pcmcia_readl(skt, PCMCIA_C1_REG);
-
-	if (!(val & PCMCIA_C1_CD1_MASK) && !(val & PCMCIA_C1_CD2_MASK))
-		stat |= SS_DETECT;
-
-	/* if new insertion, detect cardtype */
-	if ((stat & SS_DETECT) && !skt->card_detected) {
-		unsigned int stat = 0;
-
-		/* float VS1, float VS2 */
-		val |= PCMCIA_C1_VS1OE_MASK;
-		val |= PCMCIA_C1_VS2OE_MASK;
-		pcmcia_writel(skt, val, PCMCIA_C1_REG);
-
-		/* wait for output to stabilize and read VS[12] */
-		udelay(10);
-		val = pcmcia_readl(skt, PCMCIA_C1_REG);
-		stat |= (val & PCMCIA_C1_VS1_MASK) ? IN_VS1 : 0;
-		stat |= (val & PCMCIA_C1_VS2_MASK) ? IN_VS2 : 0;
-
-		/* drive VS1 low, float VS2 */
-		val &= ~PCMCIA_C1_VS1OE_MASK;
-		val |= PCMCIA_C1_VS2OE_MASK;
-		pcmcia_writel(skt, val, PCMCIA_C1_REG);
-
-		/* wait for output to stabilize and read CD[12] */
-		udelay(10);
-		val = pcmcia_readl(skt, PCMCIA_C1_REG);
-		stat |= (val & PCMCIA_C1_CD1_MASK) ? IN_CD1_VS2H : 0;
-		stat |= (val & PCMCIA_C1_CD2_MASK) ? IN_CD2_VS2H : 0;
-
-		/* float VS1, drive VS2 low */
-		val |= PCMCIA_C1_VS1OE_MASK;
-		val &= ~PCMCIA_C1_VS2OE_MASK;
-		pcmcia_writel(skt, val, PCMCIA_C1_REG);
-
-		/* wait for output to stabilize and read CD[12] */
-		udelay(10);
-		val = pcmcia_readl(skt, PCMCIA_C1_REG);
-		stat |= (val & PCMCIA_C1_CD1_MASK) ? IN_CD1_VS1H : 0;
-		stat |= (val & PCMCIA_C1_CD2_MASK) ? IN_CD2_VS1H : 0;
-
-		/* guess cardtype from all this */
-		skt->card_type = vscd_to_cardtype[stat];
-		if (!skt->card_type)
-			dev_err(&skt->socket.dev, "unsupported card type\n");
-
-		/* drive both VS pin to 0 again */
-		val &= ~(PCMCIA_C1_VS1OE_MASK | PCMCIA_C1_VS2OE_MASK);
-
-		/* enable correct logic */
-		val &= ~(PCMCIA_C1_EN_PCMCIA_MASK | PCMCIA_C1_EN_CARDBUS_MASK);
-		if (skt->card_type & CARD_PCCARD)
-			val |= PCMCIA_C1_EN_PCMCIA_MASK;
-		else
-			val |= PCMCIA_C1_EN_CARDBUS_MASK;
-
-		pcmcia_writel(skt, val, PCMCIA_C1_REG);
-	}
-	skt->card_detected = (stat & SS_DETECT) ? 1 : 0;
-
-	/* report card type/voltage */
-	if (skt->card_type & CARD_CARDBUS)
-		stat |= SS_CARDBUS;
-	if (skt->card_type & CARD_3V)
-		stat |= SS_3VCARD;
-	if (skt->card_type & CARD_XV)
-		stat |= SS_XVCARD;
-	stat |= SS_POWERON;
-
-	if (gpio_get_value(skt->pd->ready_gpio))
-		stat |= SS_READY;
-
-	return stat;
-}
-
-/*
- * core request to get current socket status
- */
-static int bcm63xx_pcmcia_get_status(struct pcmcia_socket *sock,
-				     unsigned int *status)
-{
-	struct bcm63xx_pcmcia_socket *skt;
-
-	skt = sock->driver_data;
-
-	spin_lock_bh(&skt->lock);
-	*status = __get_socket_status(skt);
-	spin_unlock_bh(&skt->lock);
-
-	return 0;
-}
-
-/*
- * socket polling timer callback
- */
-static void bcm63xx_pcmcia_poll(struct timer_list *t)
-{
-	struct bcm63xx_pcmcia_socket *skt;
-	unsigned int stat, events;
-
-	skt = from_timer(skt, t, timer);
-
-	spin_lock_bh(&skt->lock);
-
-	stat = __get_socket_status(skt);
-
-	/* keep only changed bits, and mask with required one from the
-	 * core */
-	events = (stat ^ skt->old_status) & skt->requested_state.csc_mask;
-	skt->old_status = stat;
-	spin_unlock_bh(&skt->lock);
-
-	if (events)
-		pcmcia_parse_events(&skt->socket, events);
-
-	mod_timer(&skt->timer,
-		  jiffies + msecs_to_jiffies(BCM63XX_PCMCIA_POLL_RATE));
-}
-
-static int bcm63xx_pcmcia_set_io_map(struct pcmcia_socket *sock,
-				     struct pccard_io_map *map)
-{
-	/* this doesn't seem to be called by pcmcia layer if static
-	 * mapping is used */
-	return 0;
-}
-
-static int bcm63xx_pcmcia_set_mem_map(struct pcmcia_socket *sock,
-				      struct pccard_mem_map *map)
-{
-	struct bcm63xx_pcmcia_socket *skt;
-	struct resource *res;
-
-	skt = sock->driver_data;
-	if (map->flags & MAP_ATTRIB)
-		res = skt->attr_res;
-	else
-		res = skt->common_res;
-
-	map->static_start = res->start + map->card_start;
-	return 0;
-}
-
-static struct pccard_operations bcm63xx_pcmcia_operations = {
-	.init			= bcm63xx_pcmcia_sock_init,
-	.suspend		= bcm63xx_pcmcia_suspend,
-	.get_status		= bcm63xx_pcmcia_get_status,
-	.set_socket		= bcm63xx_pcmcia_set_socket,
-	.set_io_map		= bcm63xx_pcmcia_set_io_map,
-	.set_mem_map		= bcm63xx_pcmcia_set_mem_map,
-};
-
-/*
- * register pcmcia socket to core
- */
-static int bcm63xx_drv_pcmcia_probe(struct platform_device *pdev)
-{
-	struct bcm63xx_pcmcia_socket *skt;
-	struct pcmcia_socket *sock;
-	struct resource *res;
-	unsigned int regmem_size = 0, iomem_size = 0;
-	u32 val;
-	int ret;
-	int irq;
-
-	skt = kzalloc(sizeof(*skt), GFP_KERNEL);
-	if (!skt)
-		return -ENOMEM;
-	spin_lock_init(&skt->lock);
-	sock = &skt->socket;
-	sock->driver_data = skt;
-
-	/* make sure we have all resources we need */
-	skt->common_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	skt->attr_res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
-	irq = platform_get_irq(pdev, 0);
-	skt->pd = pdev->dev.platform_data;
-	if (!skt->common_res || !skt->attr_res || (irq < 0) || !skt->pd) {
-		ret = -EINVAL;
-		goto err;
-	}
-
-	/* remap pcmcia registers */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	regmem_size = resource_size(res);
-	if (!request_mem_region(res->start, regmem_size, "bcm63xx_pcmcia")) {
-		ret = -EINVAL;
-		goto err;
-	}
-	skt->reg_res = res;
-
-	skt->base = ioremap(res->start, regmem_size);
-	if (!skt->base) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	/* remap io registers */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 3);
-	iomem_size = resource_size(res);
-	skt->io_base = ioremap(res->start, iomem_size);
-	if (!skt->io_base) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	/* resources are static */
-	sock->resource_ops = &pccard_static_ops;
-	sock->ops = &bcm63xx_pcmcia_operations;
-	sock->owner = THIS_MODULE;
-	sock->dev.parent = &pdev->dev;
-	sock->features = SS_CAP_STATIC_MAP | SS_CAP_PCCARD;
-	sock->io_offset = (unsigned long)skt->io_base;
-	sock->pci_irq = irq;
-
-#ifdef CONFIG_CARDBUS
-	sock->cb_dev = bcm63xx_cb_dev;
-	if (bcm63xx_cb_dev)
-		sock->features |= SS_CAP_CARDBUS;
-#endif
-
-	/* assume common & attribute memory have the same size */
-	sock->map_size = resource_size(skt->common_res);
-
-	/* initialize polling timer */
-	timer_setup(&skt->timer, bcm63xx_pcmcia_poll, 0);
-
-	/* initialize  pcmcia  control register,  drive  VS[12] to  0,
-	 * leave CB IDSEL to the old  value since it is set by the PCI
-	 * layer */
-	val = pcmcia_readl(skt, PCMCIA_C1_REG);
-	val &= PCMCIA_C1_CBIDSEL_MASK;
-	val |= PCMCIA_C1_EN_PCMCIA_GPIO_MASK;
-	pcmcia_writel(skt, val, PCMCIA_C1_REG);
-
-	/*
-	 * Hardware has only one set of timings registers, not one for
-	 * each memory access type, so we configure them for the
-	 * slowest one: attribute memory.
-	 */
-	val = PCMCIA_C2_DATA16_MASK;
-	val |= 10 << PCMCIA_C2_RWCOUNT_SHIFT;
-	val |= 6 << PCMCIA_C2_INACTIVE_SHIFT;
-	val |= 3 << PCMCIA_C2_SETUP_SHIFT;
-	val |= 3 << PCMCIA_C2_HOLD_SHIFT;
-	pcmcia_writel(skt, val, PCMCIA_C2_REG);
-
-	ret = pcmcia_register_socket(sock);
-	if (ret)
-		goto err;
-
-	/* start polling socket */
-	mod_timer(&skt->timer,
-		  jiffies + msecs_to_jiffies(BCM63XX_PCMCIA_POLL_RATE));
-
-	platform_set_drvdata(pdev, skt);
-	return 0;
-
-err:
-	if (skt->io_base)
-		iounmap(skt->io_base);
-	if (skt->base)
-		iounmap(skt->base);
-	if (skt->reg_res)
-		release_mem_region(skt->reg_res->start, regmem_size);
-	kfree(skt);
-	return ret;
-}
-
-static int bcm63xx_drv_pcmcia_remove(struct platform_device *pdev)
-{
-	struct bcm63xx_pcmcia_socket *skt;
-	struct resource *res;
-
-	skt = platform_get_drvdata(pdev);
-	timer_shutdown_sync(&skt->timer);
-	iounmap(skt->base);
-	iounmap(skt->io_base);
-	res = skt->reg_res;
-	release_mem_region(res->start, resource_size(res));
-	kfree(skt);
-	return 0;
-}
-
-struct platform_driver bcm63xx_pcmcia_driver = {
-	.probe	= bcm63xx_drv_pcmcia_probe,
-	.remove	= bcm63xx_drv_pcmcia_remove,
-	.driver	= {
-		.name	= "bcm63xx_pcmcia",
-		.owner  = THIS_MODULE,
-	},
-};
-
-#ifdef CONFIG_CARDBUS
-static int bcm63xx_cb_probe(struct pci_dev *dev,
-				      const struct pci_device_id *id)
-{
-	/* keep pci device */
-	bcm63xx_cb_dev = dev;
-	return platform_driver_register(&bcm63xx_pcmcia_driver);
-}
-
-static void bcm63xx_cb_exit(struct pci_dev *dev)
-{
-	platform_driver_unregister(&bcm63xx_pcmcia_driver);
-	bcm63xx_cb_dev = NULL;
-}
-
-static const struct pci_device_id bcm63xx_cb_table[] = {
-	{
-		.vendor		= PCI_VENDOR_ID_BROADCOM,
-		.device		= BCM6348_CPU_ID,
-		.subvendor	= PCI_VENDOR_ID_BROADCOM,
-		.subdevice	= PCI_ANY_ID,
-		.class		= PCI_CLASS_BRIDGE_CARDBUS << 8,
-		.class_mask	= ~0,
-	},
-
-	{
-		.vendor		= PCI_VENDOR_ID_BROADCOM,
-		.device		= BCM6358_CPU_ID,
-		.subvendor	= PCI_VENDOR_ID_BROADCOM,
-		.subdevice	= PCI_ANY_ID,
-		.class		= PCI_CLASS_BRIDGE_CARDBUS << 8,
-		.class_mask	= ~0,
-	},
-
-	{ },
-};
-
-MODULE_DEVICE_TABLE(pci, bcm63xx_cb_table);
-
-static struct pci_driver bcm63xx_cardbus_driver = {
-	.name		= "bcm63xx_cardbus",
-	.id_table	= bcm63xx_cb_table,
-	.probe		= bcm63xx_cb_probe,
-	.remove		= bcm63xx_cb_exit,
-};
-#endif
-
-/*
- * if cardbus support is enabled, register our platform device after
- * our fake cardbus bridge has been registered
- */
-static int __init bcm63xx_pcmcia_init(void)
-{
-#ifdef CONFIG_CARDBUS
-	return pci_register_driver(&bcm63xx_cardbus_driver);
-#else
-	return platform_driver_register(&bcm63xx_pcmcia_driver);
-#endif
-}
-
-static void __exit bcm63xx_pcmcia_exit(void)
-{
-#ifdef CONFIG_CARDBUS
-	return pci_unregister_driver(&bcm63xx_cardbus_driver);
-#else
-	platform_driver_unregister(&bcm63xx_pcmcia_driver);
-#endif
-}
-
-module_init(bcm63xx_pcmcia_init);
-module_exit(bcm63xx_pcmcia_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Maxime Bizon <mbizon@freebox.fr>");
-MODULE_DESCRIPTION("Linux PCMCIA Card Services: bcm63xx Socket Controller");
diff --git a/drivers/pcmcia/bcm63xx_pcmcia.h b/drivers/pcmcia/bcm63xx_pcmcia.h
deleted file mode 100644
index 2122c59a1c4a..000000000000
--- a/drivers/pcmcia/bcm63xx_pcmcia.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef BCM63XX_PCMCIA_H_
-#define BCM63XX_PCMCIA_H_
-
-#include <linux/types.h>
-#include <linux/timer.h>
-#include <pcmcia/ss.h>
-#include <bcm63xx_dev_pcmcia.h>
-
-/* socket polling rate in ms */
-#define BCM63XX_PCMCIA_POLL_RATE	500
-
-enum {
-	CARD_CARDBUS = (1 << 0),
-	CARD_PCCARD = (1 << 1),
-	CARD_5V = (1 << 2),
-	CARD_3V = (1 << 3),
-	CARD_XV = (1 << 4),
-	CARD_YV = (1 << 5),
-};
-
-struct bcm63xx_pcmcia_socket {
-	struct pcmcia_socket socket;
-
-	/* platform specific data */
-	struct bcm63xx_pcmcia_platform_data *pd;
-
-	/* all regs access are protected by this spinlock */
-	spinlock_t lock;
-
-	/* pcmcia registers resource */
-	struct resource *reg_res;
-
-	/* base remapped address of registers */
-	void __iomem *base;
-
-	/* whether a card is detected at the moment */
-	int card_detected;
-
-	/* type of detected card (mask of above enum) */
-	u8 card_type;
-
-	/* keep last socket status to implement event reporting */
-	unsigned int old_status;
-
-	/* backup of requested socket state */
-	socket_state_t requested_state;
-
-	/* timer used for socket status polling */
-	struct timer_list timer;
-
-	/* attribute/common memory resources */
-	struct resource *attr_res;
-	struct resource *common_res;
-	struct resource *io_res;
-
-	/* base address of io memory */
-	void __iomem *io_base;
-};
-
-#endif /* BCM63XX_PCMCIA_H_ */
-- 
2.39.2

