Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2646A42E7
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjB0NgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjB0NgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:36:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A2020681;
        Mon, 27 Feb 2023 05:35:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2438B80B1E;
        Mon, 27 Feb 2023 13:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8803C4339C;
        Mon, 27 Feb 2023 13:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677504937;
        bh=DOg34Cm8woaVdediIpUCSmPi0NEHlTYs3h/HwqS+Vro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFpcRBEi1Konil0DqdFZOVc5OqzFR9YR9A2J/RugVJjhgRYo9mZRp+QLzvPq9hXsr
         UEX/vdYubOf2yHNiwyUm0jprDrtrgpAEbLRkfRjVcZ6Dx15gw5weCJs+RVimmjenh2
         Gsxz2ynFEiBsKG7rUfF4Ke221Cj5uCtniS61+wtmIsQNAz4X0fivjkU8QfYszT9KaL
         GT7KbIS4bQOWfRmLkcDvJ3iC5mz1+GCobX0nRzIfpI+DXDh+usXbal3/mlTEFbBbJo
         /cKo8byzMr7pP8gwzXVnhvRlY3PywCUZDt23jUwXa6eJMa0wbyIIDVCMhmkQ9KsrKQ
         tVRDnGTJVXcSQ==
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
Subject: [RFC 3/6] yenta_socket: copy pccard core code into driver
Date:   Mon, 27 Feb 2023 14:34:54 +0100
Message-Id: <20230227133457.431729-4-arnd@kernel.org>
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

To allow further cleanups, move all pccard specific code that
yenta_socket.c depends on into the file itself, making it a concatenation
of ss.h, cs_internal.h, cs.c, socket_sysfs.c, cardbus.c, rsrc_mgr.c and
the original contents. Only the minimal additonal changes are done to
ensure this still compiles.

The files that are not shared with pcmcia drivers can be removed now.
Note that ricoh.h contains separate definitions for pcmcia and cardbus,
so only the second half is moved.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/pcmcia/Makefile       |    3 -
 drivers/pcmcia/cardbus.c      |  125 -
 drivers/pcmcia/o2micro.h      |  183 --
 drivers/pcmcia/ricoh.h        |  169 --
 drivers/pcmcia/ti113x.h       |  978 -------
 drivers/pcmcia/topic.h        |  168 --
 drivers/pcmcia/yenta_socket.c | 4546 ++++++++++++++++++++++++++++-----
 drivers/pcmcia/yenta_socket.h |  136 -
 8 files changed, 3908 insertions(+), 2400 deletions(-)
 delete mode 100644 drivers/pcmcia/cardbus.c
 delete mode 100644 drivers/pcmcia/o2micro.h
 delete mode 100644 drivers/pcmcia/ti113x.h
 delete mode 100644 drivers/pcmcia/topic.h
 delete mode 100644 drivers/pcmcia/yenta_socket.h

diff --git a/drivers/pcmcia/Makefile b/drivers/pcmcia/Makefile
index 0f090543cefe..4d0af3e27c1c 100644
--- a/drivers/pcmcia/Makefile
+++ b/drivers/pcmcia/Makefile
@@ -3,9 +3,6 @@
 # Makefile for the kernel pcmcia subsystem (c/o David Hinds)
 #
 
-cardbus_core-y					+= cardbus.o cs.o socket_sysfs.o rsrc_mgr.o
-obj-$(CONFIG_CARDBUS)				+= cardbus_core.o
-
 pcmcia-y					+= ds.o pcmcia_resource.o cistpl.o pcmcia_cis.o \
 						   cs.o socket_sysfs.o
 obj-$(CONFIG_PCMCIA)				+= pcmcia.o
diff --git a/drivers/pcmcia/cardbus.c b/drivers/pcmcia/cardbus.c
deleted file mode 100644
index 2c5673ae58ba..000000000000
--- a/drivers/pcmcia/cardbus.c
+++ /dev/null
@@ -1,125 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * cardbus.c -- 16-bit PCMCIA core support
- *
- * The initial developer of the original code is David A. Hinds
- * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
- * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
- *
- * (C) 1999		David A. Hinds
- */
-
-/*
- * Cardbus handling has been re-written to be more of a PCI bridge thing,
- * and the PCI code basically does all the resource handling.
- *
- *		Linus, Jan 2000
- */
-
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-
-#include <pcmcia/ss.h>
-#include <pcmcia/cistpl.h>
-
-#include "cs_internal.h"
-
-static void cardbus_config_irq_and_cls(struct pci_bus *bus, int irq)
-{
-	struct pci_dev *dev;
-
-	list_for_each_entry(dev, &bus->devices, bus_list) {
-		u8 irq_pin;
-
-		/*
-		 * Since there is only one interrupt available to
-		 * CardBus devices, all devices downstream of this
-		 * device must be using this IRQ.
-		 */
-		pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &irq_pin);
-		if (irq_pin) {
-			dev->irq = irq;
-			pci_write_config_byte(dev, PCI_INTERRUPT_LINE, dev->irq);
-		}
-
-		/*
-		 * Some controllers transfer very slowly with 0 CLS.
-		 * Configure it.  This may fail as CLS configuration
-		 * is mandatory only for MWI.
-		 */
-		pci_set_cacheline_size(dev);
-
-		if (dev->subordinate)
-			cardbus_config_irq_and_cls(dev->subordinate, irq);
-	}
-}
-
-/**
- * cb_alloc() - add CardBus device
- * @s:		the pcmcia_socket where the CardBus device is located
- *
- * cb_alloc() allocates the kernel data structures for a Cardbus device
- * and handles the lowest level PCI device setup issues.
- */
-int __ref cb_alloc(struct pcmcia_socket *s)
-{
-	struct pci_bus *bus = s->cb_dev->subordinate;
-	struct pci_dev *dev;
-	unsigned int max, pass;
-
-	pci_lock_rescan_remove();
-
-	s->functions = pci_scan_slot(bus, PCI_DEVFN(0, 0));
-	pci_fixup_cardbus(bus);
-
-	max = bus->busn_res.start;
-	for (pass = 0; pass < 2; pass++)
-		for_each_pci_bridge(dev, bus)
-			max = pci_scan_bridge(bus, dev, max, pass);
-
-	/*
-	 * Size all resources below the CardBus controller.
-	 */
-	pci_bus_size_bridges(bus);
-	pci_bus_assign_resources(bus);
-	cardbus_config_irq_and_cls(bus, s->pci_irq);
-
-	/* socket specific tune function */
-	if (s->tune_bridge)
-		s->tune_bridge(s, bus);
-
-	pci_bus_add_devices(bus);
-
-	pci_unlock_rescan_remove();
-	return 0;
-}
-
-/**
- * cb_free() - remove CardBus device
- * @s:		the pcmcia_socket where the CardBus device was located
- *
- * cb_free() handles the lowest level PCI device cleanup.
- */
-void cb_free(struct pcmcia_socket *s)
-{
-	struct pci_dev *bridge, *dev, *tmp;
-	struct pci_bus *bus;
-
-	bridge = s->cb_dev;
-	if (!bridge)
-		return;
-
-	bus = bridge->subordinate;
-	if (!bus)
-		return;
-
-	pci_lock_rescan_remove();
-
-	list_for_each_entry_safe(dev, tmp, &bus->devices, bus_list)
-		pci_stop_and_remove_bus_device(dev);
-
-	pci_unlock_rescan_remove();
-
-}
diff --git a/drivers/pcmcia/o2micro.h b/drivers/pcmcia/o2micro.h
deleted file mode 100644
index 5096e92c7a4c..000000000000
--- a/drivers/pcmcia/o2micro.h
+++ /dev/null
@@ -1,183 +0,0 @@
-/*
- * o2micro.h 1.13 1999/10/25 20:03:34
- *
- * The contents of this file are subject to the Mozilla Public License
- * Version 1.1 (the "License"); you may not use this file except in
- * compliance with the License. You may obtain a copy of the License
- * at http://www.mozilla.org/MPL/
- *
- * Software distributed under the License is distributed on an "AS IS"
- * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
- * the License for the specific language governing rights and
- * limitations under the License. 
- *
- * The initial developer of the original code is David A. Hinds
- * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
- * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
- *
- * Alternatively, the contents of this file may be used under the
- * terms of the GNU General Public License version 2 (the "GPL"), in which
- * case the provisions of the GPL are applicable instead of the
- * above.  If you wish to allow the use of your version of this file
- * only under the terms of the GPL and not to allow others to use
- * your version of this file under the MPL, indicate your decision by
- * deleting the provisions above and replace them with the notice and
- * other provisions required by the GPL.  If you do not delete the
- * provisions above, a recipient may use your version of this file
- * under either the MPL or the GPL.
- */
-
-#ifndef _LINUX_O2MICRO_H
-#define _LINUX_O2MICRO_H
-
-/* Additional PCI configuration registers */
-
-#define O2_MUX_CONTROL		0x90	/* 32 bit */
-#define  O2_MUX_RING_OUT	0x0000000f
-#define  O2_MUX_SKTB_ACTV	0x000000f0
-#define  O2_MUX_SCTA_ACTV_ENA	0x00000100
-#define  O2_MUX_SCTB_ACTV_ENA	0x00000200
-#define  O2_MUX_SER_IRQ_ROUTE	0x0000e000
-#define  O2_MUX_SER_PCI		0x00010000
-
-#define  O2_MUX_SKTA_TURBO	0x000c0000	/* for 6833, 6860 */
-#define  O2_MUX_SKTB_TURBO	0x00300000
-#define  O2_MUX_AUX_VCC_3V	0x00400000
-#define  O2_MUX_PCI_VCC_5V	0x00800000
-#define  O2_MUX_PME_MUX		0x0f000000
-
-/* Additional ExCA registers */
-
-#define O2_MODE_A		0x38
-#define O2_MODE_A_2		0x26	/* for 6833B, 6860C */
-#define  O2_MODE_A_CD_PULSE	0x04
-#define  O2_MODE_A_SUSP_EDGE	0x08
-#define  O2_MODE_A_HOST_SUSP	0x10
-#define  O2_MODE_A_PWR_MASK	0x60
-#define  O2_MODE_A_QUIET	0x80
-
-#define O2_MODE_B		0x39
-#define O2_MODE_B_2		0x2e	/* for 6833B, 6860C */
-#define  O2_MODE_B_IDENT	0x03
-#define  O2_MODE_B_ID_BSTEP	0x00
-#define  O2_MODE_B_ID_CSTEP	0x01
-#define  O2_MODE_B_ID_O2	0x02
-#define  O2_MODE_B_VS1		0x04
-#define  O2_MODE_B_VS2		0x08
-#define  O2_MODE_B_IRQ15_RI	0x80
-
-#define O2_MODE_C		0x3a
-#define  O2_MODE_C_DREQ_MASK	0x03
-#define  O2_MODE_C_DREQ_INPACK	0x01
-#define  O2_MODE_C_DREQ_WP	0x02
-#define  O2_MODE_C_DREQ_BVD2	0x03
-#define  O2_MODE_C_ZVIDEO	0x08
-#define  O2_MODE_C_IREQ_SEL	0x30
-#define  O2_MODE_C_MGMT_SEL	0xc0
-
-#define O2_MODE_D		0x3b
-#define  O2_MODE_D_IRQ_MODE	0x03
-#define  O2_MODE_D_PCI_CLKRUN	0x04
-#define  O2_MODE_D_CB_CLKRUN	0x08
-#define  O2_MODE_D_SKT_ACTV	0x20
-#define  O2_MODE_D_PCI_FIFO	0x40	/* for OZ6729, OZ6730 */
-#define  O2_MODE_D_W97_IRQ	0x40
-#define  O2_MODE_D_ISA_IRQ	0x80
-
-#define O2_MHPG_DMA		0x3c
-#define  O2_MHPG_CHANNEL	0x07
-#define  O2_MHPG_CINT_ENA	0x08
-#define  O2_MHPG_CSC_ENA	0x10
-
-#define O2_FIFO_ENA		0x3d
-#define  O2_FIFO_ZVIDEO_3	0x08
-#define  O2_FIFO_PCI_FIFO	0x10
-#define  O2_FIFO_POSTWR		0x40
-#define  O2_FIFO_BUFFER		0x80
-
-#define O2_MODE_E		0x3e
-#define  O2_MODE_E_MHPG_DMA	0x01
-#define  O2_MODE_E_SPKR_OUT	0x02
-#define  O2_MODE_E_LED_OUT	0x08
-#define  O2_MODE_E_SKTA_ACTV	0x10
-
-#define O2_RESERVED1		0x94
-#define O2_RESERVED2		0xD4
-#define O2_RES_READ_PREFETCH	0x02
-#define O2_RES_WRITE_BURST	0x08
-
-static int o2micro_override(struct yenta_socket *socket)
-{
-	/*
-	 * 'reserved' register at 0x94/D4. allows setting read prefetch and write
-	 * bursting. read prefetching for example makes the RME Hammerfall DSP
-	 * working. for some bridges it is at 0x94, for others at 0xD4. it's
-	 * ok to write to both registers on all O2 bridges.
-	 * from Eric Still, 02Micro.
-	 */
-	u8 a, b;
-	bool use_speedup;
-
-	if (PCI_FUNC(socket->dev->devfn) == 0) {
-		a = config_readb(socket, O2_RESERVED1);
-		b = config_readb(socket, O2_RESERVED2);
-		dev_dbg(&socket->dev->dev, "O2: 0x94/0xD4: %02x/%02x\n", a, b);
-
-		switch (socket->dev->device) {
-		/*
-		 * older bridges have problems with both read prefetch and write
-		 * bursting depending on the combination of the chipset, bridge
-		 * and the cardbus card. so disable them to be on the safe side.
-		 */
-		case PCI_DEVICE_ID_O2_6729:
-		case PCI_DEVICE_ID_O2_6730:
-		case PCI_DEVICE_ID_O2_6812:
-		case PCI_DEVICE_ID_O2_6832:
-		case PCI_DEVICE_ID_O2_6836:
-		case PCI_DEVICE_ID_O2_6933:
-			use_speedup = false;
-			break;
-		default:
-			use_speedup = true;
-			break;
-		}
-
-		/* the user may override our decision */
-		if (strcasecmp(o2_speedup, "on") == 0)
-			use_speedup = true;
-		else if (strcasecmp(o2_speedup, "off") == 0)
-			use_speedup = false;
-		else if (strcasecmp(o2_speedup, "default") != 0)
-			dev_warn(&socket->dev->dev,
-				"O2: Unknown parameter, using 'default'");
-
-		if (use_speedup) {
-			dev_info(&socket->dev->dev,
-				"O2: enabling read prefetch/write burst. If you experience problems or performance issues, use the yenta_socket parameter 'o2_speedup=off'\n");
-			config_writeb(socket, O2_RESERVED1,
-				      a | O2_RES_READ_PREFETCH | O2_RES_WRITE_BURST);
-			config_writeb(socket, O2_RESERVED2,
-				      b | O2_RES_READ_PREFETCH | O2_RES_WRITE_BURST);
-		} else {
-			dev_info(&socket->dev->dev,
-				"O2: disabling read prefetch/write burst. If you experience problems or performance issues, use the yenta_socket parameter 'o2_speedup=on'\n");
-			config_writeb(socket, O2_RESERVED1,
-				      a & ~(O2_RES_READ_PREFETCH | O2_RES_WRITE_BURST));
-			config_writeb(socket, O2_RESERVED2,
-				      b & ~(O2_RES_READ_PREFETCH | O2_RES_WRITE_BURST));
-		}
-	}
-
-	return 0;
-}
-
-static void o2micro_restore_state(struct yenta_socket *socket)
-{
-	/*
-	 * as long as read prefetch is the only thing in
-	 * o2micro_override, it's safe to call it from here
-	 */
-	o2micro_override(socket);
-}
-
-#endif /* _LINUX_O2MICRO_H */
diff --git a/drivers/pcmcia/ricoh.h b/drivers/pcmcia/ricoh.h
index bca3ebffb5c4..e94ae2c29098 100644
--- a/drivers/pcmcia/ricoh.h
+++ b/drivers/pcmcia/ricoh.h
@@ -69,173 +69,4 @@
 #define RF5C_MCTL3_DISABLE	0x01	/* Disable PCMCIA interface */
 #define RF5C_MCTL3_DMA_ENA	0x02
 
-/* Register definitions for Ricoh PCI-to-CardBus bridges */
-
-/* Extra bits in CB_BRIDGE_CONTROL */
-#define RL5C46X_BCR_3E0_ENA		0x0800
-#define RL5C46X_BCR_3E2_ENA		0x1000
-
-/* Bridge Configuration Register */
-#define RL5C4XX_CONFIG			0x80	/* 16 bit */
-#define  RL5C4XX_CONFIG_IO_1_MODE	0x0200
-#define  RL5C4XX_CONFIG_IO_0_MODE	0x0100
-#define  RL5C4XX_CONFIG_PREFETCH	0x0001
-
-/* Misc Control Register */
-#define RL5C4XX_MISC			0x0082	/* 16 bit */
-#define  RL5C4XX_MISC_HW_SUSPEND_ENA	0x0002
-#define  RL5C4XX_MISC_VCCEN_POL		0x0100
-#define  RL5C4XX_MISC_VPPEN_POL		0x0200
-#define  RL5C46X_MISC_SUSPEND		0x0001
-#define  RL5C46X_MISC_PWR_SAVE_2	0x0004
-#define  RL5C46X_MISC_IFACE_BUSY	0x0008
-#define  RL5C46X_MISC_B_LOCK		0x0010
-#define  RL5C46X_MISC_A_LOCK		0x0020
-#define  RL5C46X_MISC_PCI_LOCK		0x0040
-#define  RL5C47X_MISC_IFACE_BUSY	0x0004
-#define  RL5C47X_MISC_PCI_INT_MASK	0x0018
-#define  RL5C47X_MISC_PCI_INT_DIS	0x0020
-#define  RL5C47X_MISC_SUBSYS_WR		0x0040
-#define  RL5C47X_MISC_SRIRQ_ENA		0x0080
-#define  RL5C47X_MISC_5V_DISABLE	0x0400
-#define  RL5C47X_MISC_LED_POL		0x0800
-
-/* 16-bit Interface Control Register */
-#define RL5C4XX_16BIT_CTL		0x0084	/* 16 bit */
-#define  RL5C4XX_16CTL_IO_TIMING	0x0100
-#define  RL5C4XX_16CTL_MEM_TIMING	0x0200
-#define  RL5C46X_16CTL_LEVEL_1		0x0010
-#define  RL5C46X_16CTL_LEVEL_2		0x0020
-
-/* 16-bit IO and memory timing registers */
-#define RL5C4XX_16BIT_IO_0		0x0088	/* 16 bit */
-#define RL5C4XX_16BIT_MEM_0		0x008a	/* 16 bit */
-#define  RL5C4XX_SETUP_MASK		0x0007
-#define  RL5C4XX_SETUP_SHIFT		0
-#define  RL5C4XX_CMD_MASK		0x01f0
-#define  RL5C4XX_CMD_SHIFT		4
-#define  RL5C4XX_HOLD_MASK		0x1c00
-#define  RL5C4XX_HOLD_SHIFT		10
-#define  RL5C4XX_MISC_CONTROL           0x2F /* 8 bit */
-#define  RL5C4XX_ZV_ENABLE              0x08
-
-/* Misc Control 3 Register */
-#define RL5C4XX_MISC3			0x00A2 /* 16 bit */
-#define  RL5C47X_MISC3_CB_CLKRUN_DIS	BIT(1)
-
-#if IS_ENABLED(CONFIG_CARDBUS)
-
-#define rl_misc(socket)		((socket)->private[0])
-#define rl_ctl(socket)		((socket)->private[1])
-#define rl_io(socket)		((socket)->private[2])
-#define rl_mem(socket)		((socket)->private[3])
-#define rl_config(socket)	((socket)->private[4])
-
-static void ricoh_zoom_video(struct pcmcia_socket *sock, int onoff)
-{
-        u8 reg;
-	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
-
-        reg = config_readb(socket, RL5C4XX_MISC_CONTROL);
-        if (onoff)
-                /* Zoom zoom, we will all go together, zoom zoom, zoom zoom */
-                reg |=  RL5C4XX_ZV_ENABLE;
-        else
-                reg &= ~RL5C4XX_ZV_ENABLE;
-	
-        config_writeb(socket, RL5C4XX_MISC_CONTROL, reg);
-}
-
-static void ricoh_set_zv(struct yenta_socket *socket)
-{
-        if(socket->dev->vendor == PCI_VENDOR_ID_RICOH)
-        {
-                switch(socket->dev->device)
-                {
-                        /* There may be more .. */
-		case  PCI_DEVICE_ID_RICOH_RL5C478:
-			socket->socket.zoom_video = ricoh_zoom_video;
-			break;  
-                }
-        }
-}
-
-static void ricoh_set_clkrun(struct yenta_socket *socket, bool quiet)
-{
-	u16 misc3;
-
-	/*
-	 * RL5C475II likely has this setting, too, however no datasheet
-	 * is publicly available for this chip
-	 */
-	if (socket->dev->device != PCI_DEVICE_ID_RICOH_RL5C476 &&
-	    socket->dev->device != PCI_DEVICE_ID_RICOH_RL5C478)
-		return;
-
-	if (socket->dev->revision < 0x80)
-		return;
-
-	misc3 = config_readw(socket, RL5C4XX_MISC3);
-	if (misc3 & RL5C47X_MISC3_CB_CLKRUN_DIS) {
-		if (!quiet)
-			dev_dbg(&socket->dev->dev,
-				"CLKRUN feature already disabled\n");
-	} else if (disable_clkrun) {
-		if (!quiet)
-			dev_info(&socket->dev->dev,
-				 "Disabling CLKRUN feature\n");
-		misc3 |= RL5C47X_MISC3_CB_CLKRUN_DIS;
-		config_writew(socket, RL5C4XX_MISC3, misc3);
-	}
-}
-
-static void ricoh_save_state(struct yenta_socket *socket)
-{
-	rl_misc(socket) = config_readw(socket, RL5C4XX_MISC);
-	rl_ctl(socket) = config_readw(socket, RL5C4XX_16BIT_CTL);
-	rl_io(socket) = config_readw(socket, RL5C4XX_16BIT_IO_0);
-	rl_mem(socket) = config_readw(socket, RL5C4XX_16BIT_MEM_0);
-	rl_config(socket) = config_readw(socket, RL5C4XX_CONFIG);
-}
-
-static void ricoh_restore_state(struct yenta_socket *socket)
-{
-	config_writew(socket, RL5C4XX_MISC, rl_misc(socket));
-	config_writew(socket, RL5C4XX_16BIT_CTL, rl_ctl(socket));
-	config_writew(socket, RL5C4XX_16BIT_IO_0, rl_io(socket));
-	config_writew(socket, RL5C4XX_16BIT_MEM_0, rl_mem(socket));
-	config_writew(socket, RL5C4XX_CONFIG, rl_config(socket));
-	ricoh_set_clkrun(socket, true);
-}
-
-
-/*
- * Magic Ricoh initialization code..
- */
-static int ricoh_override(struct yenta_socket *socket)
-{
-	u16 config, ctl;
-
-	config = config_readw(socket, RL5C4XX_CONFIG);
-
-	/* Set the default timings, don't trust the original values */
-	ctl = RL5C4XX_16CTL_IO_TIMING | RL5C4XX_16CTL_MEM_TIMING;
-
-	if(socket->dev->device < PCI_DEVICE_ID_RICOH_RL5C475) {
-		ctl |= RL5C46X_16CTL_LEVEL_1 | RL5C46X_16CTL_LEVEL_2;
-	} else {
-		config |= RL5C4XX_CONFIG_PREFETCH;
-	}
-
-	config_writew(socket, RL5C4XX_16BIT_CTL, ctl);
-	config_writew(socket, RL5C4XX_CONFIG, config);
-
-	ricoh_set_zv(socket);
-	ricoh_set_clkrun(socket, false);
-
-	return 0;
-}
-
-#endif /* CONFIG_CARDBUS */
-
 #endif /* _LINUX_RICOH_H */
diff --git a/drivers/pcmcia/ti113x.h b/drivers/pcmcia/ti113x.h
deleted file mode 100644
index 5cb670e037a0..000000000000
--- a/drivers/pcmcia/ti113x.h
+++ /dev/null
@@ -1,978 +0,0 @@
-/*
- * ti113x.h 1.16 1999/10/25 20:03:34
- *
- * The contents of this file are subject to the Mozilla Public License
- * Version 1.1 (the "License"); you may not use this file except in
- * compliance with the License. You may obtain a copy of the License
- * at http://www.mozilla.org/MPL/
- *
- * Software distributed under the License is distributed on an "AS IS"
- * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
- * the License for the specific language governing rights and
- * limitations under the License. 
- *
- * The initial developer of the original code is David A. Hinds
- * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
- * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
- *
- * Alternatively, the contents of this file may be used under the
- * terms of the GNU General Public License version 2 (the "GPL"), in which
- * case the provisions of the GPL are applicable instead of the
- * above.  If you wish to allow the use of your version of this file
- * only under the terms of the GPL and not to allow others to use
- * your version of this file under the MPL, indicate your decision by
- * deleting the provisions above and replace them with the notice and
- * other provisions required by the GPL.  If you do not delete the
- * provisions above, a recipient may use your version of this file
- * under either the MPL or the GPL.
- */
-
-#ifndef _LINUX_TI113X_H
-#define _LINUX_TI113X_H
-
-
-/* Register definitions for TI 113X PCI-to-CardBus bridges */
-
-/* System Control Register */
-#define TI113X_SYSTEM_CONTROL		0x0080	/* 32 bit */
-#define  TI113X_SCR_SMIROUTE		0x04000000
-#define  TI113X_SCR_SMISTATUS		0x02000000
-#define  TI113X_SCR_SMIENB		0x01000000
-#define  TI113X_SCR_VCCPROT		0x00200000
-#define  TI113X_SCR_REDUCEZV		0x00100000
-#define  TI113X_SCR_CDREQEN		0x00080000
-#define  TI113X_SCR_CDMACHAN		0x00070000
-#define  TI113X_SCR_SOCACTIVE		0x00002000
-#define  TI113X_SCR_PWRSTREAM		0x00000800
-#define  TI113X_SCR_DELAYUP		0x00000400
-#define  TI113X_SCR_DELAYDOWN		0x00000200
-#define  TI113X_SCR_INTERROGATE		0x00000100
-#define  TI113X_SCR_CLKRUN_SEL		0x00000080
-#define  TI113X_SCR_PWRSAVINGS		0x00000040
-#define  TI113X_SCR_SUBSYSRW		0x00000020
-#define  TI113X_SCR_CB_DPAR		0x00000010
-#define  TI113X_SCR_CDMA_EN		0x00000008
-#define  TI113X_SCR_ASYNC_IRQ		0x00000004
-#define  TI113X_SCR_KEEPCLK		0x00000002
-#define  TI113X_SCR_CLKRUN_ENA		0x00000001  
-
-#define  TI122X_SCR_SER_STEP		0xc0000000
-#define  TI122X_SCR_INTRTIE		0x20000000
-#define  TIXX21_SCR_TIEALL		0x10000000
-#define  TI122X_SCR_CBRSVD		0x00400000
-#define  TI122X_SCR_MRBURSTDN		0x00008000
-#define  TI122X_SCR_MRBURSTUP		0x00004000
-#define  TI122X_SCR_RIMUX		0x00000001
-
-/* Multimedia Control Register */
-#define TI1250_MULTIMEDIA_CTL		0x0084	/* 8 bit */
-#define  TI1250_MMC_ZVOUTEN		0x80
-#define  TI1250_MMC_PORTSEL		0x40
-#define  TI1250_MMC_ZVEN1		0x02
-#define  TI1250_MMC_ZVEN0		0x01
-
-#define TI1250_GENERAL_STATUS		0x0085	/* 8 bit */
-#define TI1250_GPIO0_CONTROL		0x0088	/* 8 bit */
-#define TI1250_GPIO1_CONTROL		0x0089	/* 8 bit */
-#define TI1250_GPIO2_CONTROL		0x008a	/* 8 bit */
-#define TI1250_GPIO3_CONTROL		0x008b	/* 8 bit */
-#define TI1250_GPIO_MODE_MASK		0xc0
-
-/* IRQMUX/MFUNC Register */
-#define TI122X_MFUNC			0x008c	/* 32 bit */
-#define TI122X_MFUNC0_MASK		0x0000000f
-#define TI122X_MFUNC1_MASK		0x000000f0
-#define TI122X_MFUNC2_MASK		0x00000f00
-#define TI122X_MFUNC3_MASK		0x0000f000
-#define TI122X_MFUNC4_MASK		0x000f0000
-#define TI122X_MFUNC5_MASK		0x00f00000
-#define TI122X_MFUNC6_MASK		0x0f000000
-
-#define TI122X_MFUNC0_INTA		0x00000002
-#define TI125X_MFUNC0_INTB		0x00000001
-#define TI122X_MFUNC1_INTB		0x00000020
-#define TI122X_MFUNC3_IRQSER		0x00001000
-
-
-/* Retry Status Register */
-#define TI113X_RETRY_STATUS		0x0090	/* 8 bit */
-#define  TI113X_RSR_PCIRETRY		0x80
-#define  TI113X_RSR_CBRETRY		0x40
-#define  TI113X_RSR_TEXP_CBB		0x20
-#define  TI113X_RSR_MEXP_CBB		0x10
-#define  TI113X_RSR_TEXP_CBA		0x08
-#define  TI113X_RSR_MEXP_CBA		0x04
-#define  TI113X_RSR_TEXP_PCI		0x02
-#define  TI113X_RSR_MEXP_PCI		0x01
-
-/* Card Control Register */
-#define TI113X_CARD_CONTROL		0x0091	/* 8 bit */
-#define  TI113X_CCR_RIENB		0x80
-#define  TI113X_CCR_ZVENABLE		0x40
-#define  TI113X_CCR_PCI_IRQ_ENA		0x20
-#define  TI113X_CCR_PCI_IREQ		0x10
-#define  TI113X_CCR_PCI_CSC		0x08
-#define  TI113X_CCR_SPKROUTEN		0x02
-#define  TI113X_CCR_IFG			0x01
-
-#define  TI1220_CCR_PORT_SEL		0x20
-#define  TI122X_CCR_AUD2MUX		0x04
-
-/* Device Control Register */
-#define TI113X_DEVICE_CONTROL		0x0092	/* 8 bit */
-#define  TI113X_DCR_5V_FORCE		0x40
-#define  TI113X_DCR_3V_FORCE		0x20
-#define  TI113X_DCR_IMODE_MASK		0x06
-#define  TI113X_DCR_IMODE_ISA		0x02
-#define  TI113X_DCR_IMODE_SERIAL	0x04
-
-#define  TI12XX_DCR_IMODE_PCI_ONLY	0x00
-#define  TI12XX_DCR_IMODE_ALL_SERIAL	0x06
-
-/* Buffer Control Register */
-#define TI113X_BUFFER_CONTROL		0x0093	/* 8 bit */
-#define  TI113X_BCR_CB_READ_DEPTH	0x08
-#define  TI113X_BCR_CB_WRITE_DEPTH	0x04
-#define  TI113X_BCR_PCI_READ_DEPTH	0x02
-#define  TI113X_BCR_PCI_WRITE_DEPTH	0x01
-
-/* Diagnostic Register */
-#define TI1250_DIAGNOSTIC		0x0093	/* 8 bit */
-#define  TI1250_DIAG_TRUE_VALUE		0x80
-#define  TI1250_DIAG_PCI_IREQ		0x40
-#define  TI1250_DIAG_PCI_CSC		0x20
-#define  TI1250_DIAG_ASYNC_CSC		0x01
-
-/* DMA Registers */
-#define TI113X_DMA_0			0x0094	/* 32 bit */
-#define TI113X_DMA_1			0x0098	/* 32 bit */
-
-/* ExCA IO offset registers */
-#define TI113X_IO_OFFSET(map)		(0x36+((map)<<1))
-
-/* EnE test register */
-#define ENE_TEST_C9			0xc9	/* 8bit */
-#define ENE_TEST_C9_TLTENABLE		0x02
-#define ENE_TEST_C9_PFENABLE_F0		0x04
-#define ENE_TEST_C9_PFENABLE_F1		0x08
-#define ENE_TEST_C9_PFENABLE		(ENE_TEST_C9_PFENABLE_F0 | ENE_TEST_C9_PFENABLE_F1)
-#define ENE_TEST_C9_WPDISALBLE_F0	0x40
-#define ENE_TEST_C9_WPDISALBLE_F1	0x80
-#define ENE_TEST_C9_WPDISALBLE		(ENE_TEST_C9_WPDISALBLE_F0 | ENE_TEST_C9_WPDISALBLE_F1)
-
-/*
- * Texas Instruments CardBus controller overrides.
- */
-#define ti_sysctl(socket)	((socket)->private[0])
-#define ti_cardctl(socket)	((socket)->private[1])
-#define ti_devctl(socket)	((socket)->private[2])
-#define ti_diag(socket)		((socket)->private[3])
-#define ti_mfunc(socket)	((socket)->private[4])
-#define ene_test_c9(socket)	((socket)->private[5])
-
-/*
- * These are the TI specific power management handlers.
- */
-static void ti_save_state(struct yenta_socket *socket)
-{
-	ti_sysctl(socket) = config_readl(socket, TI113X_SYSTEM_CONTROL);
-	ti_mfunc(socket) = config_readl(socket, TI122X_MFUNC);
-	ti_cardctl(socket) = config_readb(socket, TI113X_CARD_CONTROL);
-	ti_devctl(socket) = config_readb(socket, TI113X_DEVICE_CONTROL);
-	ti_diag(socket) = config_readb(socket, TI1250_DIAGNOSTIC);
-
-	if (socket->dev->vendor == PCI_VENDOR_ID_ENE)
-		ene_test_c9(socket) = config_readb(socket, ENE_TEST_C9);
-}
-
-static void ti_restore_state(struct yenta_socket *socket)
-{
-	config_writel(socket, TI113X_SYSTEM_CONTROL, ti_sysctl(socket));
-	config_writel(socket, TI122X_MFUNC, ti_mfunc(socket));
-	config_writeb(socket, TI113X_CARD_CONTROL, ti_cardctl(socket));
-	config_writeb(socket, TI113X_DEVICE_CONTROL, ti_devctl(socket));
-	config_writeb(socket, TI1250_DIAGNOSTIC, ti_diag(socket));
-
-	if (socket->dev->vendor == PCI_VENDOR_ID_ENE)
-		config_writeb(socket, ENE_TEST_C9, ene_test_c9(socket));
-}
-
-/*
- *	Zoom video control for TI122x/113x chips
- */
-
-static void ti_zoom_video(struct pcmcia_socket *sock, int onoff)
-{
-	u8 reg;
-	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
-
-	/* If we don't have a Zoom Video switch this is harmless,
-	   we just tristate the unused (ZV) lines */
-	reg = config_readb(socket, TI113X_CARD_CONTROL);
-	if (onoff)
-		/* Zoom zoom, we will all go together, zoom zoom, zoom zoom */
-		reg |= TI113X_CCR_ZVENABLE;
-	else
-		reg &= ~TI113X_CCR_ZVENABLE;
-	config_writeb(socket, TI113X_CARD_CONTROL, reg);
-}
-
-/*
- *	The 145x series can also use this. They have an additional
- *	ZV autodetect mode we don't use but don't actually need.
- *	FIXME: manual says its in func0 and func1 but disagrees with
- *	itself about this - do we need to force func0, if so we need
- *	to know a lot more about socket pairings in pcmcia_socket than
- *	we do now.. uggh.
- */
- 
-static void ti1250_zoom_video(struct pcmcia_socket *sock, int onoff)
-{	
-	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
-	int shift = 0;
-	u8 reg;
-
-	ti_zoom_video(sock, onoff);
-
-	reg = config_readb(socket, TI1250_MULTIMEDIA_CTL);
-	reg |= TI1250_MMC_ZVOUTEN;	/* ZV bus enable */
-
-	if(PCI_FUNC(socket->dev->devfn)==1)
-		shift = 1;
-	
-	if(onoff)
-	{
-		reg &= ~(1<<6); 	/* Clear select bit */
-		reg |= shift<<6;	/* Favour our socket */
-		reg |= 1<<shift;	/* Socket zoom video on */
-	}
-	else
-	{
-		reg &= ~(1<<6); 	/* Clear select bit */
-		reg |= (1^shift)<<6;	/* Favour other socket */
-		reg &= ~(1<<shift);	/* Socket zoon video off */
-	}
-
-	config_writeb(socket, TI1250_MULTIMEDIA_CTL, reg);
-}
-
-static void ti_set_zv(struct yenta_socket *socket)
-{
-	if(socket->dev->vendor == PCI_VENDOR_ID_TI)
-	{
-		switch(socket->dev->device)
-		{
-			/* There may be more .. */
-			case PCI_DEVICE_ID_TI_1220:
-			case PCI_DEVICE_ID_TI_1221:
-			case PCI_DEVICE_ID_TI_1225:
-			case PCI_DEVICE_ID_TI_4510:
-				socket->socket.zoom_video = ti_zoom_video;
-				break;	
-			case PCI_DEVICE_ID_TI_1250:
-			case PCI_DEVICE_ID_TI_1251A:
-			case PCI_DEVICE_ID_TI_1251B:
-			case PCI_DEVICE_ID_TI_1450:
-				socket->socket.zoom_video = ti1250_zoom_video;
-		}
-	}
-}
-
-
-/*
- * Generic TI init - TI has an extension for the
- * INTCTL register that sets the PCI CSC interrupt.
- * Make sure we set it correctly at open and init
- * time
- * - override: disable the PCI CSC interrupt. This makes
- *   it possible to use the CSC interrupt to probe the
- *   ISA interrupts.
- * - init: set the interrupt to match our PCI state.
- *   This makes us correctly get PCI CSC interrupt
- *   events.
- */
-static int ti_init(struct yenta_socket *socket)
-{
-	u8 new, reg = exca_readb(socket, I365_INTCTL);
-
-	new = reg & ~I365_INTR_ENA;
-	if (socket->dev->irq)
-		new |= I365_INTR_ENA;
-	if (new != reg)
-		exca_writeb(socket, I365_INTCTL, new);
-	return 0;
-}
-
-static int ti_override(struct yenta_socket *socket)
-{
-	u8 new, reg = exca_readb(socket, I365_INTCTL);
-
-	new = reg & ~I365_INTR_ENA;
-	if (new != reg)
-		exca_writeb(socket, I365_INTCTL, new);
-
-	ti_set_zv(socket);
-
-	return 0;
-}
-
-static void ti113x_use_isa_irq(struct yenta_socket *socket)
-{
-	int isa_irq = -1;
-	u8 intctl;
-	u32 isa_irq_mask = 0;
-
-	if (!isa_probe)
-		return;
-
-	/* get a free isa int */
-	isa_irq_mask = yenta_probe_irq(socket, isa_interrupts);
-	if (!isa_irq_mask)
-		return; /* no useable isa irq found */
-
-	/* choose highest available */
-	for (; isa_irq_mask; isa_irq++)
-		isa_irq_mask >>= 1;
-	socket->cb_irq = isa_irq;
-
-	exca_writeb(socket, I365_CSCINT, (isa_irq << 4));
-
-	intctl = exca_readb(socket, I365_INTCTL);
-	intctl &= ~(I365_INTR_ENA | I365_IRQ_MASK);     /* CSC Enable */
-	exca_writeb(socket, I365_INTCTL, intctl);
-
-	dev_info(&socket->dev->dev,
-		"Yenta TI113x: using isa irq %d for CardBus\n", isa_irq);
-}
-
-
-static int ti113x_override(struct yenta_socket *socket)
-{
-	u8 cardctl;
-
-	cardctl = config_readb(socket, TI113X_CARD_CONTROL);
-	cardctl &= ~(TI113X_CCR_PCI_IRQ_ENA | TI113X_CCR_PCI_IREQ | TI113X_CCR_PCI_CSC);
-	if (socket->dev->irq)
-		cardctl |= TI113X_CCR_PCI_IRQ_ENA | TI113X_CCR_PCI_CSC | TI113X_CCR_PCI_IREQ;
-	else
-		ti113x_use_isa_irq(socket);
-
-	config_writeb(socket, TI113X_CARD_CONTROL, cardctl);
-
-	return ti_override(socket);
-}
-
-
-/* irqrouting for func0, probes PCI interrupt and ISA interrupts */
-static void ti12xx_irqroute_func0(struct yenta_socket *socket)
-{
-	u32 mfunc, mfunc_old, devctl;
-	u8 gpio3, gpio3_old;
-	int pci_irq_status;
-
-	mfunc = mfunc_old = config_readl(socket, TI122X_MFUNC);
-	devctl = config_readb(socket, TI113X_DEVICE_CONTROL);
-	dev_info(&socket->dev->dev, "TI: mfunc 0x%08x, devctl 0x%02x\n",
-		 mfunc, devctl);
-
-	/* make sure PCI interrupts are enabled before probing */
-	ti_init(socket);
-
-	/* test PCI interrupts first. only try fixing if return value is 0! */
-	pci_irq_status = yenta_probe_cb_irq(socket);
-	if (pci_irq_status)
-		goto out;
-
-	/*
-	 * We're here which means PCI interrupts are _not_ delivered. try to
-	 * find the right setting (all serial or parallel)
-	 */
-	dev_info(&socket->dev->dev,
-		 "TI: probing PCI interrupt failed, trying to fix\n");
-
-	/* for serial PCI make sure MFUNC3 is set to IRQSER */
-	if ((devctl & TI113X_DCR_IMODE_MASK) == TI12XX_DCR_IMODE_ALL_SERIAL) {
-		switch (socket->dev->device) {
-		case PCI_DEVICE_ID_TI_1250:
-		case PCI_DEVICE_ID_TI_1251A:
-		case PCI_DEVICE_ID_TI_1251B:
-		case PCI_DEVICE_ID_TI_1450:
-		case PCI_DEVICE_ID_TI_1451A:
-		case PCI_DEVICE_ID_TI_4450:
-		case PCI_DEVICE_ID_TI_4451:
-			/* these chips have no IRQSER setting in MFUNC3  */
-			break;
-
-		default:
-			mfunc = (mfunc & ~TI122X_MFUNC3_MASK) | TI122X_MFUNC3_IRQSER;
-
-			/* write down if changed, probe */
-			if (mfunc != mfunc_old) {
-				config_writel(socket, TI122X_MFUNC, mfunc);
-
-				pci_irq_status = yenta_probe_cb_irq(socket);
-				if (pci_irq_status == 1) {
-					dev_info(&socket->dev->dev,
-						 "TI: all-serial interrupts ok\n");
-					mfunc_old = mfunc;
-					goto out;
-				}
-
-				/* not working, back to old value */
-				mfunc = mfunc_old;
-				config_writel(socket, TI122X_MFUNC, mfunc);
-
-				if (pci_irq_status == -1)
-					goto out;
-			}
-		}
-
-		/* serial PCI interrupts not working fall back to parallel */
-		dev_info(&socket->dev->dev,
-			 "TI: falling back to parallel PCI interrupts\n");
-		devctl &= ~TI113X_DCR_IMODE_MASK;
-		devctl |= TI113X_DCR_IMODE_SERIAL; /* serial ISA could be right */
-		config_writeb(socket, TI113X_DEVICE_CONTROL, devctl);
-	}
-
-	/* parallel PCI interrupts: route INTA */
-	switch (socket->dev->device) {
-	case PCI_DEVICE_ID_TI_1250:
-	case PCI_DEVICE_ID_TI_1251A:
-	case PCI_DEVICE_ID_TI_1251B:
-	case PCI_DEVICE_ID_TI_1450:
-		/* make sure GPIO3 is set to INTA */
-		gpio3 = gpio3_old = config_readb(socket, TI1250_GPIO3_CONTROL);
-		gpio3 &= ~TI1250_GPIO_MODE_MASK;
-		if (gpio3 != gpio3_old)
-			config_writeb(socket, TI1250_GPIO3_CONTROL, gpio3);
-		break;
-
-	default:
-		gpio3 = gpio3_old = 0;
-
-		mfunc = (mfunc & ~TI122X_MFUNC0_MASK) | TI122X_MFUNC0_INTA;
-		if (mfunc != mfunc_old)
-			config_writel(socket, TI122X_MFUNC, mfunc);
-	}
-
-	/* time to probe again */
-	pci_irq_status = yenta_probe_cb_irq(socket);
-	if (pci_irq_status == 1) {
-		mfunc_old = mfunc;
-		dev_info(&socket->dev->dev, "TI: parallel PCI interrupts ok\n");
-	} else {
-		/* not working, back to old value */
-		mfunc = mfunc_old;
-		config_writel(socket, TI122X_MFUNC, mfunc);
-		if (gpio3 != gpio3_old)
-			config_writeb(socket, TI1250_GPIO3_CONTROL, gpio3_old);
-	}
-
-out:
-	if (pci_irq_status < 1) {
-		socket->cb_irq = 0;
-		dev_info(&socket->dev->dev,
-			 "Yenta TI: no PCI interrupts. Fish. Please report.\n");
-	}
-}
-
-
-/* changes the irq of func1 to match that of func0 */
-static int ti12xx_align_irqs(struct yenta_socket *socket, int *old_irq)
-{
-	struct pci_dev *func0;
-
-	/* find func0 device */
-	func0 = pci_get_slot(socket->dev->bus, socket->dev->devfn & ~0x07);
-	if (!func0)
-		return 0;
-
-	if (old_irq)
-		*old_irq = socket->cb_irq;
-	socket->cb_irq = socket->dev->irq = func0->irq;
-
-	pci_dev_put(func0);
-
-	return 1;
-}
-
-/*
- * ties INTA and INTB together. also changes the devices irq to that of
- * the function 0 device. call from func1 only.
- * returns 1 if INTRTIE changed, 0 otherwise.
- */
-static int ti12xx_tie_interrupts(struct yenta_socket *socket, int *old_irq)
-{
-	u32 sysctl;
-	int ret;
-
-	sysctl = config_readl(socket, TI113X_SYSTEM_CONTROL);
-	if (sysctl & TI122X_SCR_INTRTIE)
-		return 0;
-
-	/* align */
-	ret = ti12xx_align_irqs(socket, old_irq);
-	if (!ret)
-		return 0;
-
-	/* tie */
-	sysctl |= TI122X_SCR_INTRTIE;
-	config_writel(socket, TI113X_SYSTEM_CONTROL, sysctl);
-
-	return 1;
-}
-
-/* undo what ti12xx_tie_interrupts() did */
-static void ti12xx_untie_interrupts(struct yenta_socket *socket, int old_irq)
-{
-	u32 sysctl = config_readl(socket, TI113X_SYSTEM_CONTROL);
-	sysctl &= ~TI122X_SCR_INTRTIE;
-	config_writel(socket, TI113X_SYSTEM_CONTROL, sysctl);
-
-	socket->cb_irq = socket->dev->irq = old_irq;
-}
-
-/* 
- * irqrouting for func1, plays with INTB routing
- * only touches MFUNC for INTB routing. all other bits are taken
- * care of in func0 already.
- */
-static void ti12xx_irqroute_func1(struct yenta_socket *socket)
-{
-	u32 mfunc, mfunc_old, devctl, sysctl;
-	int pci_irq_status;
-
-	mfunc = mfunc_old = config_readl(socket, TI122X_MFUNC);
-	devctl = config_readb(socket, TI113X_DEVICE_CONTROL);
-	dev_info(&socket->dev->dev, "TI: mfunc 0x%08x, devctl 0x%02x\n",
-		 mfunc, devctl);
-
-	/* if IRQs are configured as tied, align irq of func1 with func0 */
-	sysctl = config_readl(socket, TI113X_SYSTEM_CONTROL);
-	if (sysctl & TI122X_SCR_INTRTIE)
-		ti12xx_align_irqs(socket, NULL);
-
-	/* make sure PCI interrupts are enabled before probing */
-	ti_init(socket);
-
-	/* test PCI interrupts first. only try fixing if return value is 0! */
-	pci_irq_status = yenta_probe_cb_irq(socket);
-	if (pci_irq_status)
-		goto out;
-
-	/*
-	 * We're here which means PCI interrupts are _not_ delivered. try to
-	 * find the right setting
-	 */
-	dev_info(&socket->dev->dev,
-		 "TI: probing PCI interrupt failed, trying to fix\n");
-
-	/* if all serial: set INTRTIE, probe again */
-	if ((devctl & TI113X_DCR_IMODE_MASK) == TI12XX_DCR_IMODE_ALL_SERIAL) {
-		int old_irq;
-
-		if (ti12xx_tie_interrupts(socket, &old_irq)) {
-			pci_irq_status = yenta_probe_cb_irq(socket);
-			if (pci_irq_status == 1) {
-				dev_info(&socket->dev->dev,
-					 "TI: all-serial interrupts, tied ok\n");
-				goto out;
-			}
-
-			ti12xx_untie_interrupts(socket, old_irq);
-		}
-	}
-	/* parallel PCI: route INTB, probe again */
-	else {
-		int old_irq;
-
-		switch (socket->dev->device) {
-		case PCI_DEVICE_ID_TI_1250:
-			/* the 1250 has one pin for IRQSER/INTB depending on devctl */
-			break;
-
-		case PCI_DEVICE_ID_TI_1251A:
-		case PCI_DEVICE_ID_TI_1251B:
-		case PCI_DEVICE_ID_TI_1450:
-			/*
-			 *  those have a pin for IRQSER/INTB plus INTB in MFUNC0
-			 *  we alread probed the shared pin, now go for MFUNC0
-			 */
-			mfunc = (mfunc & ~TI122X_MFUNC0_MASK) | TI125X_MFUNC0_INTB;
-			break;
-
-		default:
-			mfunc = (mfunc & ~TI122X_MFUNC1_MASK) | TI122X_MFUNC1_INTB;
-			break;
-		}
-
-		/* write, probe */
-		if (mfunc != mfunc_old) {
-			config_writel(socket, TI122X_MFUNC, mfunc);
-
-			pci_irq_status = yenta_probe_cb_irq(socket);
-			if (pci_irq_status == 1) {
-				dev_info(&socket->dev->dev,
-					 "TI: parallel PCI interrupts ok\n");
-				goto out;
-			}
-
-			mfunc = mfunc_old;
-			config_writel(socket, TI122X_MFUNC, mfunc);
-
-			if (pci_irq_status == -1)
-				goto out;
-		}
-
-		/* still nothing: set INTRTIE */
-		if (ti12xx_tie_interrupts(socket, &old_irq)) {
-			pci_irq_status = yenta_probe_cb_irq(socket);
-			if (pci_irq_status == 1) {
-				dev_info(&socket->dev->dev,
-					 "TI: parallel PCI interrupts, tied ok\n");
-				goto out;
-			}
-
-			ti12xx_untie_interrupts(socket, old_irq);
-		}
-	}
-
-out:
-	if (pci_irq_status < 1) {
-		socket->cb_irq = 0;
-		dev_info(&socket->dev->dev,
-			 "TI: no PCI interrupts. Fish. Please report.\n");
-	}
-}
-
-
-/* Returns true value if the second slot of a two-slot controller is empty */
-static int ti12xx_2nd_slot_empty(struct yenta_socket *socket)
-{
-	struct pci_dev *func;
-	struct yenta_socket *slot2;
-	int devfn;
-	unsigned int state;
-	int ret = 1;
-	u32 sysctl;
-
-	/* catch the two-slot controllers */
-	switch (socket->dev->device) {
-	case PCI_DEVICE_ID_TI_1220:
-	case PCI_DEVICE_ID_TI_1221:
-	case PCI_DEVICE_ID_TI_1225:
-	case PCI_DEVICE_ID_TI_1251A:
-	case PCI_DEVICE_ID_TI_1251B:
-	case PCI_DEVICE_ID_TI_1420:
-	case PCI_DEVICE_ID_TI_1450:
-	case PCI_DEVICE_ID_TI_1451A:
-	case PCI_DEVICE_ID_TI_1520:
-	case PCI_DEVICE_ID_TI_1620:
-	case PCI_DEVICE_ID_TI_4520:
-	case PCI_DEVICE_ID_TI_4450:
-	case PCI_DEVICE_ID_TI_4451:
-		/*
-		 * there are way more, but they need to be added in yenta_socket.c
-		 * and pci_ids.h first anyway.
-		 */
-		break;
-
-	case PCI_DEVICE_ID_TI_XX12:
-	case PCI_DEVICE_ID_TI_X515:
-	case PCI_DEVICE_ID_TI_X420:
-	case PCI_DEVICE_ID_TI_X620:
-	case PCI_DEVICE_ID_TI_XX21_XX11:
-	case PCI_DEVICE_ID_TI_7410:
-	case PCI_DEVICE_ID_TI_7610:
-		/*
-		 * those are either single or dual slot CB with additional functions
-		 * like 1394, smartcard reader, etc. check the TIEALL flag for them
-		 * the TIEALL flag binds the IRQ of all functions together.
-		 * we catch the single slot variants later.
-		 */
-		sysctl = config_readl(socket, TI113X_SYSTEM_CONTROL);
-		if (sysctl & TIXX21_SCR_TIEALL)
-			return 0;
-
-		break;
-
-	/* single-slot controllers have the 2nd slot empty always :) */
-	default:
-		return 1;
-	}
-
-	/* get other slot */
-	devfn = socket->dev->devfn & ~0x07;
-	func = pci_get_slot(socket->dev->bus,
-	                    (socket->dev->devfn & 0x07) ? devfn : devfn | 0x01);
-	if (!func)
-		return 1;
-
-	/*
-	 * check that the device id of both slots match. this is needed for the
-	 * XX21 and the XX11 controller that share the same device id for single
-	 * and dual slot controllers. return '2nd slot empty'. we already checked
-	 * if the interrupt is tied to another function.
-	 */
-	if (socket->dev->device != func->device)
-		goto out;
-
-	slot2 = pci_get_drvdata(func);
-	if (!slot2)
-		goto out;
-
-	/* check state */
-	yenta_get_status(&slot2->socket, &state);
-	if (state & SS_DETECT) {
-		ret = 0;
-		goto out;
-	}
-
-out:
-	pci_dev_put(func);
-	return ret;
-}
-
-/*
- * TI specifiy parts for the power hook.
- *
- * some TI's with some CB's produces interrupt storm on power on. it has been
- * seen with atheros wlan cards on TI1225 and TI1410. solution is simply to
- * disable any CB interrupts during this time.
- */
-static int ti12xx_power_hook(struct pcmcia_socket *sock, int operation)
-{
-	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
-	u32 mfunc, devctl, sysctl;
-	u8 gpio3;
-
-	/* only POWER_PRE and POWER_POST are interesting */
-	if ((operation != HOOK_POWER_PRE) && (operation != HOOK_POWER_POST))
-		return 0;
-
-	devctl = config_readb(socket, TI113X_DEVICE_CONTROL);
-	sysctl = config_readl(socket, TI113X_SYSTEM_CONTROL);
-	mfunc = config_readl(socket, TI122X_MFUNC);
-
-	/*
-	 * all serial/tied: only disable when modparm set. always doing it
-	 * would mean a regression for working setups 'cos it disables the
-	 * interrupts for both both slots on 2-slot controllers
-	 * (and users of single slot controllers where it's save have to
-	 * live with setting the modparm, most don't have to anyway)
-	 */
-	if (((devctl & TI113X_DCR_IMODE_MASK) == TI12XX_DCR_IMODE_ALL_SERIAL) &&
-	    (pwr_irqs_off || ti12xx_2nd_slot_empty(socket))) {
-		switch (socket->dev->device) {
-		case PCI_DEVICE_ID_TI_1250:
-		case PCI_DEVICE_ID_TI_1251A:
-		case PCI_DEVICE_ID_TI_1251B:
-		case PCI_DEVICE_ID_TI_1450:
-		case PCI_DEVICE_ID_TI_1451A:
-		case PCI_DEVICE_ID_TI_4450:
-		case PCI_DEVICE_ID_TI_4451:
-			/* these chips have no IRQSER setting in MFUNC3  */
-			break;
-
-		default:
-			if (operation == HOOK_POWER_PRE)
-				mfunc = (mfunc & ~TI122X_MFUNC3_MASK);
-			else
-				mfunc = (mfunc & ~TI122X_MFUNC3_MASK) | TI122X_MFUNC3_IRQSER;
-		}
-
-		return 0;
-	}
-
-	/* do the job differently for func0/1 */
-	if ((PCI_FUNC(socket->dev->devfn) == 0) ||
-	    ((sysctl & TI122X_SCR_INTRTIE) &&
-	     (pwr_irqs_off || ti12xx_2nd_slot_empty(socket)))) {
-		/* some bridges are different */
-		switch (socket->dev->device) {
-		case PCI_DEVICE_ID_TI_1250:
-		case PCI_DEVICE_ID_TI_1251A:
-		case PCI_DEVICE_ID_TI_1251B:
-		case PCI_DEVICE_ID_TI_1450:
-			/* those oldies use gpio3 for INTA */
-			gpio3 = config_readb(socket, TI1250_GPIO3_CONTROL);
-			if (operation == HOOK_POWER_PRE)
-				gpio3 = (gpio3 & ~TI1250_GPIO_MODE_MASK) | 0x40;
-			else
-				gpio3 &= ~TI1250_GPIO_MODE_MASK;
-			config_writeb(socket, TI1250_GPIO3_CONTROL, gpio3);
-			break;
-
-		default:
-			/* all new bridges are the same */
-			if (operation == HOOK_POWER_PRE)
-				mfunc &= ~TI122X_MFUNC0_MASK;
-			else
-				mfunc |= TI122X_MFUNC0_INTA;
-			config_writel(socket, TI122X_MFUNC, mfunc);
-		}
-	} else {
-		switch (socket->dev->device) {
-		case PCI_DEVICE_ID_TI_1251A:
-		case PCI_DEVICE_ID_TI_1251B:
-		case PCI_DEVICE_ID_TI_1450:
-			/* those have INTA elsewhere and INTB in MFUNC0 */
-			if (operation == HOOK_POWER_PRE)
-				mfunc &= ~TI122X_MFUNC0_MASK;
-			else
-				mfunc |= TI125X_MFUNC0_INTB;
-			config_writel(socket, TI122X_MFUNC, mfunc);
-
-			break;
-
-		default:
-			/* all new bridges are the same */
-			if (operation == HOOK_POWER_PRE)
-				mfunc &= ~TI122X_MFUNC1_MASK;
-			else
-				mfunc |= TI122X_MFUNC1_INTB;
-			config_writel(socket, TI122X_MFUNC, mfunc);
-		}
-	}
-
-	return 0;
-}
-
-static int ti12xx_override(struct yenta_socket *socket)
-{
-	u32 val, val_orig;
-
-	/* make sure that memory burst is active */
-	val_orig = val = config_readl(socket, TI113X_SYSTEM_CONTROL);
-	if (disable_clkrun && PCI_FUNC(socket->dev->devfn) == 0) {
-		dev_info(&socket->dev->dev, "Disabling CLKRUN feature\n");
-		val |= TI113X_SCR_KEEPCLK;
-	}
-	if (!(val & TI122X_SCR_MRBURSTUP)) {
-		dev_info(&socket->dev->dev,
-			 "Enabling burst memory read transactions\n");
-		val |= TI122X_SCR_MRBURSTUP;
-	}
-	if (val_orig != val)
-		config_writel(socket, TI113X_SYSTEM_CONTROL, val);
-
-	/*
-	 * Yenta expects controllers to use CSCINT to route
-	 * CSC interrupts to PCI rather than INTVAL.
-	 */
-	val = config_readb(socket, TI1250_DIAGNOSTIC);
-	dev_info(&socket->dev->dev, "Using %s to route CSC interrupts to PCI\n",
-		 (val & TI1250_DIAG_PCI_CSC) ? "CSCINT" : "INTVAL");
-	dev_info(&socket->dev->dev, "Routing CardBus interrupts to %s\n",
-		 (val & TI1250_DIAG_PCI_IREQ) ? "PCI" : "ISA");
-
-	/* do irqrouting, depending on function */
-	if (PCI_FUNC(socket->dev->devfn) == 0)
-		ti12xx_irqroute_func0(socket);
-	else
-		ti12xx_irqroute_func1(socket);
-
-	/* install power hook */
-	socket->socket.power_hook = ti12xx_power_hook;
-
-	return ti_override(socket);
-}
-
-
-static int ti1250_override(struct yenta_socket *socket)
-{
-	u8 old, diag;
-
-	old = config_readb(socket, TI1250_DIAGNOSTIC);
-	diag = old & ~(TI1250_DIAG_PCI_CSC | TI1250_DIAG_PCI_IREQ);
-	if (socket->cb_irq)
-		diag |= TI1250_DIAG_PCI_CSC | TI1250_DIAG_PCI_IREQ;
-
-	if (diag != old) {
-		dev_info(&socket->dev->dev,
-			 "adjusting diagnostic: %02x -> %02x\n",
-			 old, diag);
-		config_writeb(socket, TI1250_DIAGNOSTIC, diag);
-	}
-
-	return ti12xx_override(socket);
-}
-
-
-/**
- * EnE specific part. EnE bridges are register compatible with TI bridges but
- * have their own test registers and more important their own little problems.
- * Some fixup code to make everybody happy (TM).
- */
-
-#ifdef CONFIG_YENTA_ENE_TUNE
-/*
- * set/clear various test bits:
- * Defaults to clear the bit.
- * - mask (u8) defines what bits to change
- * - bits (u8) is the values to change them to
- * -> it's
- * 	current = (current & ~mask) | bits
- */
-/* pci ids of devices that wants to have the bit set */
-#define DEVID(_vend,_dev,_subvend,_subdev,mask,bits) {		\
-		.vendor		= _vend,			\
-		.device		= _dev,				\
-		.subvendor	= _subvend,			\
-		.subdevice	= _subdev,			\
-		.driver_data	= ((mask) << 8 | (bits)),	\
-	}
-static struct pci_device_id ene_tune_tbl[] = {
-	/* Echo Audio products based on motorola DSP56301 and DSP56361 */
-	DEVID(PCI_VENDOR_ID_MOTOROLA, 0x1801, 0xECC0, PCI_ANY_ID,
-		ENE_TEST_C9_TLTENABLE | ENE_TEST_C9_PFENABLE, ENE_TEST_C9_TLTENABLE),
-	DEVID(PCI_VENDOR_ID_MOTOROLA, 0x3410, 0xECC0, PCI_ANY_ID,
-		ENE_TEST_C9_TLTENABLE | ENE_TEST_C9_PFENABLE, ENE_TEST_C9_TLTENABLE),
-
-	{}
-};
-
-static void ene_tune_bridge(struct pcmcia_socket *sock, struct pci_bus *bus)
-{
-	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
-	struct pci_dev *dev;
-	struct pci_device_id *id = NULL;
-	u8 test_c9, old_c9, mask, bits;
-
-	list_for_each_entry(dev, &bus->devices, bus_list) {
-		id = (struct pci_device_id *) pci_match_id(ene_tune_tbl, dev);
-		if (id)
-			break;
-	}
-
-	test_c9 = old_c9 = config_readb(socket, ENE_TEST_C9);
-	if (id) {
-		mask = (id->driver_data >> 8) & 0xFF;
-		bits = id->driver_data & 0xFF;
-
-		test_c9 = (test_c9 & ~mask) | bits;
-	}
-	else
-		/* default to clear TLTEnable bit, old behaviour */
-		test_c9 &= ~ENE_TEST_C9_TLTENABLE;
-
-	dev_info(&socket->dev->dev,
-		 "EnE: changing testregister 0xC9, %02x -> %02x\n",
-		 old_c9, test_c9);
-	config_writeb(socket, ENE_TEST_C9, test_c9);
-}
-
-static int ene_override(struct yenta_socket *socket)
-{
-	/* install tune_bridge() function */
-	socket->socket.tune_bridge = ene_tune_bridge;
-
-	return ti1250_override(socket);
-}
-#else
-#  define ene_override ti1250_override
-#endif /* !CONFIG_YENTA_ENE_TUNE */
-
-#endif /* _LINUX_TI113X_H */
-
diff --git a/drivers/pcmcia/topic.h b/drivers/pcmcia/topic.h
deleted file mode 100644
index 582688fe7505..000000000000
--- a/drivers/pcmcia/topic.h
+++ /dev/null
@@ -1,168 +0,0 @@
-/*
- * topic.h 1.8 1999/08/28 04:01:47
- *
- * The contents of this file are subject to the Mozilla Public License
- * Version 1.1 (the "License"); you may not use this file except in
- * compliance with the License. You may obtain a copy of the License
- * at http://www.mozilla.org/MPL/
- *
- * Software distributed under the License is distributed on an "AS IS"
- * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
- * the License for the specific language governing rights and
- * limitations under the License. 
- *
- * The initial developer of the original code is David A. Hinds
- * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
- * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
- *
- * Alternatively, the contents of this file may be used under the
- * terms of the GNU General Public License version 2 (the "GPL"), in which
- * case the provisions of the GPL are applicable instead of the
- * above.  If you wish to allow the use of your version of this file
- * only under the terms of the GPL and not to allow others to use
- * your version of this file under the MPL, indicate your decision by
- * deleting the provisions above and replace them with the notice and
- * other provisions required by the GPL.  If you do not delete the
- * provisions above, a recipient may use your version of this file
- * under either the MPL or the GPL.
- * topic.h $Release$ 1999/08/28 04:01:47
- */
-
-#ifndef _LINUX_TOPIC_H
-#define _LINUX_TOPIC_H
-
-/* Register definitions for Toshiba ToPIC95/97/100 controllers */
-
-#define TOPIC_SOCKET_CONTROL		0x0090	/* 32 bit */
-#define  TOPIC_SCR_IRQSEL		0x00000001
-
-#define TOPIC_SLOT_CONTROL		0x00a0	/* 8 bit */
-#define  TOPIC_SLOT_SLOTON		0x80
-#define  TOPIC_SLOT_SLOTEN		0x40
-#define  TOPIC_SLOT_ID_LOCK		0x20
-#define  TOPIC_SLOT_ID_WP		0x10
-#define  TOPIC_SLOT_PORT_MASK		0x0c
-#define  TOPIC_SLOT_PORT_SHIFT		2
-#define  TOPIC_SLOT_OFS_MASK		0x03
-
-#define TOPIC_CARD_CONTROL		0x00a1	/* 8 bit */
-#define  TOPIC_CCR_INTB			0x20
-#define  TOPIC_CCR_INTA			0x10
-#define  TOPIC_CCR_CLOCK		0x0c
-#define  TOPIC_CCR_PCICLK		0x0c
-#define  TOPIC_CCR_PCICLK_2		0x08
-#define  TOPIC_CCR_CCLK			0x04
-
-#define TOPIC97_INT_CONTROL		0x00a1	/* 8 bit */
-#define  TOPIC97_ICR_INTB		0x20
-#define  TOPIC97_ICR_INTA		0x10
-#define  TOPIC97_ICR_STSIRQNP		0x04
-#define  TOPIC97_ICR_IRQNP		0x02
-#define  TOPIC97_ICR_IRQSEL		0x01
-
-#define TOPIC_CARD_DETECT		0x00a3	/* 8 bit */
-#define  TOPIC_CDR_MODE_PC32		0x80
-#define  TOPIC_CDR_VS1			0x04
-#define  TOPIC_CDR_VS2			0x02
-#define  TOPIC_CDR_SW_DETECT		0x01
-
-#define TOPIC_REGISTER_CONTROL		0x00a4	/* 32 bit */
-#define  TOPIC_RCR_RESUME_RESET		0x80000000
-#define  TOPIC_RCR_REMOVE_RESET		0x40000000
-#define  TOPIC97_RCR_CLKRUN_ENA		0x20000000
-#define  TOPIC97_RCR_TESTMODE		0x10000000
-#define  TOPIC97_RCR_IOPLUP		0x08000000
-#define  TOPIC_RCR_BUFOFF_PWROFF	0x02000000
-#define  TOPIC_RCR_BUFOFF_SIGOFF	0x01000000
-#define  TOPIC97_RCR_CB_DEV_MASK	0x0000f800
-#define  TOPIC97_RCR_CB_DEV_SHIFT	11
-#define  TOPIC97_RCR_RI_DISABLE		0x00000004
-#define  TOPIC97_RCR_CAUDIO_OFF		0x00000002
-#define  TOPIC_RCR_CAUDIO_INVERT	0x00000001
-
-#define TOPIC97_MISC1			0x00ad  /* 8bit */
-#define  TOPIC97_MISC1_CLOCKRUN_ENABLE	0x80
-#define  TOPIC97_MISC1_CLOCKRUN_MODE	0x40
-#define  TOPIC97_MISC1_DETECT_REQ_ENA	0x10
-#define  TOPIC97_MISC1_SCK_CLEAR_DIS	0x04
-#define  TOPIC97_MISC1_R2_LOW_ENABLE	0x10
-
-#define TOPIC97_MISC2			0x00ae  /* 8 bit */
-#define  TOPIC97_MISC2_SPWRCLK_MASK	0x70
-#define  TOPIC97_MISC2_SPWRMOD		0x08
-#define  TOPIC97_MISC2_SPWR_ENABLE	0x04
-#define  TOPIC97_MISC2_ZV_MODE		0x02
-#define  TOPIC97_MISC2_ZV_ENABLE	0x01
-
-#define TOPIC97_ZOOM_VIDEO_CONTROL	0x009c  /* 8 bit */
-#define  TOPIC97_ZV_CONTROL_ENABLE	0x01
-
-#define TOPIC97_AUDIO_VIDEO_SWITCH	0x003c  /* 8 bit */
-#define  TOPIC97_AVS_AUDIO_CONTROL	0x02
-#define  TOPIC97_AVS_VIDEO_CONTROL	0x01
-
-#define TOPIC_EXCA_IF_CONTROL		0x3e	/* 8 bit */
-#define TOPIC_EXCA_IFC_33V_ENA		0x01
-
-#define TOPIC_PCI_CFG_PPBCN		0x3e	/* 16-bit */
-#define TOPIC_PCI_CFG_PPBCN_WBEN	0x0400
-
-static void topic97_zoom_video(struct pcmcia_socket *sock, int onoff)
-{
-	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
-	u8 reg_zv, reg;
-
-	reg_zv = config_readb(socket, TOPIC97_ZOOM_VIDEO_CONTROL);
-	if (onoff) {
-		reg_zv |= TOPIC97_ZV_CONTROL_ENABLE;
-		config_writeb(socket, TOPIC97_ZOOM_VIDEO_CONTROL, reg_zv);
-
-		reg = config_readb(socket, TOPIC97_AUDIO_VIDEO_SWITCH);
-		reg |= TOPIC97_AVS_AUDIO_CONTROL | TOPIC97_AVS_VIDEO_CONTROL;
-		config_writeb(socket, TOPIC97_AUDIO_VIDEO_SWITCH, reg);
-	} else {
-		reg_zv &= ~TOPIC97_ZV_CONTROL_ENABLE;
-		config_writeb(socket, TOPIC97_ZOOM_VIDEO_CONTROL, reg_zv);
-
-		reg = config_readb(socket, TOPIC97_AUDIO_VIDEO_SWITCH);
-		reg &= ~(TOPIC97_AVS_AUDIO_CONTROL | TOPIC97_AVS_VIDEO_CONTROL);
-		config_writeb(socket, TOPIC97_AUDIO_VIDEO_SWITCH, reg);
-	}
-}
-
-static int topic97_override(struct yenta_socket *socket)
-{
-	/* ToPIC97/100 support ZV */
-	socket->socket.zoom_video = topic97_zoom_video;
-	return 0;
-}
-
-
-static int topic95_override(struct yenta_socket *socket)
-{
-	u8 fctrl;
-	u16 ppbcn;
-
-	/* enable 3.3V support for 16bit cards */
-	fctrl = exca_readb(socket, TOPIC_EXCA_IF_CONTROL);
-	exca_writeb(socket, TOPIC_EXCA_IF_CONTROL, fctrl | TOPIC_EXCA_IFC_33V_ENA);
-
-	/* tell yenta to use exca registers to power 16bit cards */
-	socket->flags |= YENTA_16BIT_POWER_EXCA | YENTA_16BIT_POWER_DF;
-
-	/* Disable write buffers to prevent lockups under load with numerous
-	   Cardbus cards, observed on Tecra 500CDT and reported elsewhere on the
-	   net.  This is not a power-on default according to the datasheet
-	   but some BIOSes seem to set it. */
-	if (pci_read_config_word(socket->dev, TOPIC_PCI_CFG_PPBCN, &ppbcn) == 0
-	    && socket->dev->revision <= 7
-	    && (ppbcn & TOPIC_PCI_CFG_PPBCN_WBEN)) {
-		ppbcn &= ~TOPIC_PCI_CFG_PPBCN_WBEN;
-		pci_write_config_word(socket->dev, TOPIC_PCI_CFG_PPBCN, ppbcn);
-		dev_info(&socket->dev->dev, "Disabled ToPIC95 Cardbus write buffers.\n");
-	}
-
-	return 0;
-}
-
-#endif /* _LINUX_TOPIC_H */
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index ac98d9bb8349..64d11592bd99 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -1,844 +1,4112 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Regular cardbus driver ("yenta_socket")
- *
- * (C) Copyright 1999, 2000 Linus Torvalds
+ * ss.h
  *
- * Changelog:
- * Aug 2002: Manfred Spraul <manfred@colorfullife.com>
- * 	Dynamically adjust the size of the bridge resource
+ * The initial developer of the original code is David A. Hinds
+ * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+ * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
  *
- * May 2003: Dominik Brodowski <linux@brodo.de>
- * 	Merge pci_socket.c and yenta.c into one file
+ * (C) 1999             David A. Hinds
  */
-#include <linux/init.h>
+
+#ifndef _LINUX_SS_H
+#define _LINUX_SS_H
+
+#include <linux/device.h>
+#include <linux/sched.h>	/* task_struct, completion */
+#include <linux/mutex.h>
+
+#if IS_ENABLED(CONFIG_CARDBUS)
 #include <linux/pci.h>
-#include <linux/workqueue.h>
-#include <linux/interrupt.h>
-#include <linux/delay.h>
-#include <linux/module.h>
-#include <linux/io.h>
-#include <linux/slab.h>
+#endif
 
-#include <pcmcia/ss.h>
+/* Definitions for card status flags for GetStatus */
+#define SS_WRPROT	0x0001
+#define SS_CARDLOCK	0x0002
+#define SS_EJECTION	0x0004
+#define SS_INSERTION	0x0008
+#define SS_BATDEAD	0x0010
+#define SS_BATWARN	0x0020
+#define SS_READY	0x0040
+#define SS_DETECT	0x0080
+#define SS_POWERON	0x0100
+#define SS_GPI		0x0200
+#define SS_STSCHG	0x0400
+#define SS_CARDBUS	0x0800
+#define SS_3VCARD	0x1000
+#define SS_XVCARD	0x2000
+#define SS_PENDING	0x4000
+#define SS_ZVCARD	0x8000
+
+/* InquireSocket capabilities */
+#define SS_CAP_PAGE_REGS	0x0001
+#define SS_CAP_VIRTUAL_BUS	0x0002
+#define SS_CAP_MEM_ALIGN	0x0004
+#define SS_CAP_STATIC_MAP	0x0008
+#define SS_CAP_PCCARD		0x4000
+#define SS_CAP_CARDBUS		0x8000
+
+/* for GetSocket, SetSocket */
+typedef struct socket_state_t {
+	u_int	flags;
+	u_int	csc_mask;
+	u_char	Vcc, Vpp;
+	u_char	io_irq;
+} socket_state_t;
+
+extern socket_state_t dead_socket;
+
+/* Socket configuration flags */
+#define SS_PWR_AUTO	0x0010
+#define SS_IOCARD	0x0020
+#define SS_RESET	0x0040
+#define SS_DMA_MODE	0x0080
+#define SS_SPKR_ENA	0x0100
+#define SS_OUTPUT_ENA	0x0200
+
+/* Flags for I/O port and memory windows */
+#define MAP_ACTIVE	0x01
+#define MAP_16BIT	0x02
+#define MAP_AUTOSZ	0x04
+#define MAP_0WS		0x08
+#define MAP_WRPROT	0x10
+#define MAP_ATTRIB	0x20
+#define MAP_USE_WAIT	0x40
+#define MAP_PREFETCH	0x80
+
+/* Use this just for bridge windows */
+#define MAP_IOSPACE	0x20
+
+/* power hook operations */
+#define HOOK_POWER_PRE	0x01
+#define HOOK_POWER_POST	0x02
+
+typedef struct pccard_io_map {
+	u_char	map;
+	u_char	flags;
+	u_short	speed;
+	phys_addr_t start, stop;
+} pccard_io_map;
+
+typedef struct pccard_mem_map {
+	u_char		map;
+	u_char		flags;
+	u_short		speed;
+	phys_addr_t	static_start;
+	u_int		card_start;
+	struct resource	*res;
+} pccard_mem_map;
+
+typedef struct io_window_t {
+	u_int			InUse, Config;
+	struct resource		*res;
+} io_window_t;
+
+/* Maximum number of IO windows per socket */
+#define MAX_IO_WIN 2
+
+/* Maximum number of memory windows per socket */
+#define MAX_WIN 4
 
-#include "yenta_socket.h"
-#include "i82365.h"
-#include "cs_internal.h"
 
-static bool disable_clkrun;
-module_param(disable_clkrun, bool, 0444);
-MODULE_PARM_DESC(disable_clkrun,
-		 "If PC card doesn't function properly, please try this option (TI and Ricoh bridges only)");
+/*
+ * Socket operations.
+ */
+struct pcmcia_socket;
+struct pccard_resource_ops;
+struct config_t;
+struct pcmcia_callback;
+struct user_info_t;
+
+struct pccard_operations {
+	int (*init)(struct pcmcia_socket *s);
+	int (*suspend)(struct pcmcia_socket *s);
+	int (*get_status)(struct pcmcia_socket *s, u_int *value);
+	int (*set_socket)(struct pcmcia_socket *s, socket_state_t *state);
+	int (*set_io_map)(struct pcmcia_socket *s, struct pccard_io_map *io);
+	int (*set_mem_map)(struct pcmcia_socket *s, struct pccard_mem_map *mem);
+};
 
-static bool isa_probe = 1;
-module_param(isa_probe, bool, 0444);
-MODULE_PARM_DESC(isa_probe, "If set ISA interrupts are probed (default). Set to N to disable probing");
+struct pcmcia_socket {
+	struct module			*owner;
+	socket_state_t			socket;
+	u_int				state;
+	u_int				suspended_state;	/* state before suspend */
+	u_short				functions;
+	u_short				lock_count;
+	pccard_mem_map			cis_mem;
+	void __iomem 			*cis_virt;
+	io_window_t			io[MAX_IO_WIN];
+	pccard_mem_map			win[MAX_WIN];
+	struct list_head		cis_cache;
+	size_t				fake_cis_len;
+	u8				*fake_cis;
+
+	struct list_head		socket_list;
+	struct completion		socket_released;
+
+	/* deprecated */
+	unsigned int			sock;		/* socket number */
+
+
+	/* socket capabilities */
+	u_int				features;
+	u_int				irq_mask;
+	u_int				map_size;
+	u_int				io_offset;
+	u_int				pci_irq;
+	struct pci_dev			*cb_dev;
+
+	/* socket setup is done so resources should be able to be allocated.
+	 * Only if set to 1, calls to find_{io,mem}_region are handled, and
+	 * insertio events are actually managed by the PCMCIA layer.*/
+	u8				resource_setup_done;
+
+	/* socket operations */
+	struct pccard_operations	*ops;
+	struct pccard_resource_ops	*resource_ops;
+	void				*resource_data;
+
+	/* Zoom video behaviour is so chip specific its not worth adding
+	   this to _ops */
+	void 				(*zoom_video)(struct pcmcia_socket *,
+						      int);
+
+	/* so is power hook */
+	int (*power_hook)(struct pcmcia_socket *sock, int operation);
+
+	/* allows tuning the CB bridge before loading driver for the CB card */
+#if IS_ENABLED(CONFIG_CARDBUS)
+	void (*tune_bridge)(struct pcmcia_socket *sock, struct pci_bus *bus);
+#endif
 
-static bool pwr_irqs_off;
-module_param(pwr_irqs_off, bool, 0644);
-MODULE_PARM_DESC(pwr_irqs_off, "Force IRQs off during power-on of slot. Use only when seeing IRQ storms!");
+	/* state thread */
+	struct task_struct		*thread;
+	struct completion		thread_done;
+	unsigned int			thread_events;
+	unsigned int			sysfs_events;
 
-static char o2_speedup[] = "default";
-module_param_string(o2_speedup, o2_speedup, sizeof(o2_speedup), 0444);
-MODULE_PARM_DESC(o2_speedup, "Use prefetch/burst for O2-bridges: 'on', 'off' "
-	"or 'default' (uses recommended behaviour for the detected bridge)");
+	/* For the non-trivial interaction between these locks,
+	 * see Documentation/pcmcia/locking.rst */
+	struct mutex			skt_mutex;
+	struct mutex			ops_mutex;
 
-/*
- * Only probe "regular" interrupts, don't
- * touch dangerous spots like the mouse irq,
- * because there are mice that apparently
- * get really confused if they get fondled
- * too intimately.
+	/* protects thread_events and sysfs_events */
+	spinlock_t			thread_lock;
+
+	/* pcmcia (16-bit) */
+	struct pcmcia_callback		*callback;
+
+#if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
+	/* The following elements refer to 16-bit PCMCIA devices inserted
+	 * into the socket */
+	struct list_head		devices_list;
+
+	/* the number of devices, used only internally and subject to
+	 * incorrectness and change */
+	u8				device_count;
+
+	/* does the PCMCIA card consist of two pseudo devices? */
+	u8				pcmcia_pfc;
+
+	/* non-zero if PCMCIA card is present */
+	atomic_t			present;
+
+	/* IRQ to be used by PCMCIA devices. May not be IRQ 0. */
+	unsigned int			pcmcia_irq;
+
+#endif /* CONFIG_PCMCIA */
+
+	/* socket device */
+	struct device			dev;
+	/* data internal to the socket driver */
+	void				*driver_data;
+	/* status of the card during resume from a system sleep state */
+	int				resume_status;
+};
+
+
+/* socket drivers must define the resource operations type they use. There
+ * are three options:
+ * - pccard_static_ops		iomem and ioport areas are assigned statically
+ * - pccard_iodyn_ops		iomem areas is assigned statically, ioport
+ *				areas dynamically
+ *				If this option is selected, use
+ *				"select PCCARD_IODYN" in Kconfig.
+ * - pccard_nonstatic_ops	iomem and ioport areas are assigned dynamically.
+ *				If this option is selected, use
+ *				"select PCCARD_NONSTATIC" in Kconfig.
  *
- * Default to 11, 10, 9, 7, 6, 5, 4, 3.
  */
-static u32 isa_interrupts = 0x0ef8;
+extern struct pccard_resource_ops pccard_static_ops;
+#if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
+extern struct pccard_resource_ops pccard_iodyn_ops;
+extern struct pccard_resource_ops pccard_nonstatic_ops;
+#else
+/* If PCMCIA is not used, but only CARDBUS, these functions are not used
+ * at all. Therefore, do not use the large (240K!) rsrc_nonstatic module
+ */
+#define pccard_iodyn_ops pccard_static_ops
+#define pccard_nonstatic_ops pccard_static_ops
+#endif
 
 
-#define debug(x, s, args...) dev_dbg(&s->dev->dev, x, ##args)
+/* socket drivers use this callback in their IRQ handler */
+extern void pcmcia_parse_events(struct pcmcia_socket *socket,
+				unsigned int events);
+
+/* to register and unregister a socket */
+extern int pcmcia_register_socket(struct pcmcia_socket *socket);
+extern void pcmcia_unregister_socket(struct pcmcia_socket *socket);
+
+#endif /* _LINUX_SS_H */
+
+#define CB_SOCKET_EVENT		0x00
+#define    CB_CSTSEVENT		0x00000001	/* Card status event */
+#define    CB_CD1EVENT		0x00000002	/* Card detect 1 change event */
+#define    CB_CD2EVENT		0x00000004	/* Card detect 2 change event */
+#define    CB_PWREVENT		0x00000008	/* PWRCYCLE change event */
+
+#define CB_SOCKET_MASK		0x04
+#define    CB_CSTSMASK		0x00000001	/* Card status mask */
+#define    CB_CDMASK		0x00000006	/* Card detect 1&2 mask */
+#define    CB_PWRMASK		0x00000008	/* PWRCYCLE change mask */
+
+#define CB_SOCKET_STATE		0x08
+#define    CB_CARDSTS		0x00000001	/* CSTSCHG status */
+#define    CB_CDETECT1		0x00000002	/* Card detect status 1 */
+#define    CB_CDETECT2		0x00000004	/* Card detect status 2 */
+#define    CB_PWRCYCLE		0x00000008	/* Socket powered */
+#define    CB_16BITCARD		0x00000010	/* 16-bit card detected */
+#define    CB_CBCARD		0x00000020	/* CardBus card detected */
+#define    CB_IREQCINT		0x00000040	/* READY(xIRQ)/xCINT high */
+#define    CB_NOTACARD		0x00000080	/* Unrecognizable PC card detected */
+#define    CB_DATALOST		0x00000100	/* Potential data loss due to card removal */
+#define    CB_BADVCCREQ		0x00000200	/* Invalid Vcc request by host software */
+#define    CB_5VCARD		0x00000400	/* Card Vcc at 5.0 volts? */
+#define    CB_3VCARD		0x00000800	/* Card Vcc at 3.3 volts? */
+#define    CB_XVCARD		0x00001000	/* Card Vcc at X.X volts? */
+#define    CB_YVCARD		0x00002000	/* Card Vcc at Y.Y volts? */
+#define    CB_5VSOCKET		0x10000000	/* Socket Vcc at 5.0 volts? */
+#define    CB_3VSOCKET		0x20000000	/* Socket Vcc at 3.3 volts? */
+#define    CB_XVSOCKET		0x40000000	/* Socket Vcc at X.X volts? */
+#define    CB_YVSOCKET		0x80000000	/* Socket Vcc at Y.Y volts? */
+
+#define CB_SOCKET_FORCE		0x0C
+#define    CB_FCARDSTS		0x00000001	/* Force CSTSCHG */
+#define    CB_FCDETECT1		0x00000002	/* Force CD1EVENT */
+#define    CB_FCDETECT2		0x00000004	/* Force CD2EVENT */
+#define    CB_FPWRCYCLE		0x00000008	/* Force PWREVENT */
+#define    CB_F16BITCARD	0x00000010	/* Force 16-bit PCMCIA card */
+#define    CB_FCBCARD		0x00000020	/* Force CardBus line */
+#define    CB_FNOTACARD		0x00000080	/* Force NOTACARD */
+#define    CB_FDATALOST		0x00000100	/* Force data lost */
+#define    CB_FBADVCCREQ	0x00000200	/* Force bad Vcc request */
+#define    CB_F5VCARD		0x00000400	/* Force 5.0 volt card */
+#define    CB_F3VCARD		0x00000800	/* Force 3.3 volt card */
+#define    CB_FXVCARD		0x00001000	/* Force X.X volt card */
+#define    CB_FYVCARD		0x00002000	/* Force Y.Y volt card */
+#define    CB_CVSTEST		0x00004000	/* Card VS test */
+
+#define CB_SOCKET_CONTROL	0x10
+#define  CB_SC_VPP_MASK		0x00000007
+#define   CB_SC_VPP_OFF		0x00000000
+#define   CB_SC_VPP_12V		0x00000001
+#define   CB_SC_VPP_5V		0x00000002
+#define   CB_SC_VPP_3V		0x00000003
+#define   CB_SC_VPP_XV		0x00000004
+#define   CB_SC_VPP_YV		0x00000005
+#define  CB_SC_VCC_MASK		0x00000070
+#define   CB_SC_VCC_OFF		0x00000000
+#define   CB_SC_VCC_5V		0x00000020
+#define   CB_SC_VCC_3V		0x00000030
+#define   CB_SC_VCC_XV		0x00000040
+#define   CB_SC_VCC_YV		0x00000050
+#define  CB_SC_CCLK_STOP	0x00000080
+
+#define CB_SOCKET_POWER		0x20
+#define    CB_SKTACCES		0x02000000	/* A PC card access has occurred (clear on read) */
+#define    CB_SKTMODE		0x01000000	/* Clock frequency has changed (clear on read) */
+#define    CB_CLKCTRLEN		0x00010000	/* Clock control enabled (RW) */
+#define    CB_CLKCTRL		0x00000001	/* Stop(0) or slow(1) CB clock (RW) */
 
-/* Don't ask.. */
-#define to_cycles(ns)	((ns)/120)
-#define to_ns(cycles)	((cycles)*120)
+/*
+ * Cardbus configuration space
+ */
+#define CB_BRIDGE_BASE(m)	(0x1c + 8*(m))
+#define CB_BRIDGE_LIMIT(m)	(0x20 + 8*(m))
+#define CB_BRIDGE_CONTROL	0x3e
+#define   CB_BRIDGE_CPERREN	0x00000001
+#define   CB_BRIDGE_CSERREN	0x00000002
+#define   CB_BRIDGE_ISAEN	0x00000004
+#define   CB_BRIDGE_VGAEN	0x00000008
+#define   CB_BRIDGE_MABTMODE	0x00000020
+#define   CB_BRIDGE_CRST	0x00000040
+#define   CB_BRIDGE_INTR	0x00000080
+#define   CB_BRIDGE_PREFETCH0	0x00000100
+#define   CB_BRIDGE_PREFETCH1	0x00000200
+#define   CB_BRIDGE_POSTEN	0x00000400
+#define CB_LEGACY_MODE_BASE	0x44
 
 /*
- * yenta PCI irq probing.
- * currently only used in the TI/EnE initialization code
+ * ExCA area extensions in Yenta
  */
-#ifdef CONFIG_YENTA_TI
-static int yenta_probe_cb_irq(struct yenta_socket *socket);
-static unsigned int yenta_probe_irq(struct yenta_socket *socket,
-				u32 isa_irq_mask);
-#endif
+#define CB_MEM_PAGE(map)	(0x40 + (map))
 
 
-static unsigned int override_bios;
-module_param(override_bios, uint, 0000);
-MODULE_PARM_DESC(override_bios, "yenta ignore bios resource allocation");
+/* control how 16bit cards are powered */
+#define YENTA_16BIT_POWER_EXCA	0x00000001
+#define YENTA_16BIT_POWER_DF	0x00000002
+
+
+struct yenta_socket;
+
+struct cardbus_type {
+	int	(*override)(struct yenta_socket *);
+	void	(*save_state)(struct yenta_socket *);
+	void	(*restore_state)(struct yenta_socket *);
+	int	(*sock_init)(struct yenta_socket *);
+};
+
+struct yenta_socket {
+	struct pci_dev *dev;
+	int cb_irq, io_irq;
+	void __iomem *base;
+	struct timer_list poll_timer;
+
+	struct pcmcia_socket socket;
+	struct cardbus_type *type;
+
+	u32 flags;
+
+	/* for PCI interrupt probing */
+	unsigned int probe_status;
+
+	/* A few words of private data for special stuff of overrides... */
+	unsigned int private[8];
+
+	/* PCI saved state */
+	u32 saved_state[2];
+};
 
 /*
- * Generate easy-to-use ways of reading a cardbus sockets
- * regular memory space ("cb_xxx"), configuration space
- * ("config_xxx") and compatibility space ("exca_xxxx")
+ * cs_internal.h -- definitions internal to the PCMCIA core modules
+ *
+ * The initial developer of the original code is David A. Hinds
+ * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+ * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+ *
+ * (C) 1999		David A. Hinds
+ * (C) 2003 - 2010	Dominik Brodowski
+ *
+ * This file contains definitions _only_ needed by the PCMCIA core modules.
+ * It must not be included by PCMCIA socket drivers or by PCMCIA device
+ * drivers.
  */
-static inline u32 cb_readl(struct yenta_socket *socket, unsigned reg)
-{
-	u32 val = readl(socket->base + reg);
-	debug("%04x %08x\n", socket, reg, val);
-	return val;
-}
 
-static inline void cb_writel(struct yenta_socket *socket, unsigned reg, u32 val)
-{
-	debug("%04x %08x\n", socket, reg, val);
-	writel(val, socket->base + reg);
-	readl(socket->base + reg); /* avoid problems with PCI write posting */
-}
+#ifndef _LINUX_CS_INTERNAL_H
+#define _LINUX_CS_INTERNAL_H
 
-static inline u8 config_readb(struct yenta_socket *socket, unsigned offset)
-{
-	u8 val;
-	pci_read_config_byte(socket->dev, offset, &val);
-	debug("%04x %02x\n", socket, offset, val);
-	return val;
-}
+#include <linux/kref.h>
+#include <pcmcia/cistpl.h>
 
-static inline u16 config_readw(struct yenta_socket *socket, unsigned offset)
-{
-	u16 val;
-	pci_read_config_word(socket->dev, offset, &val);
-	debug("%04x %04x\n", socket, offset, val);
-	return val;
-}
+/* Flags in client state */
+#define CLIENT_WIN_REQ(i)	(0x1<<(i))
 
-static inline u32 config_readl(struct yenta_socket *socket, unsigned offset)
-{
-	u32 val;
-	pci_read_config_dword(socket->dev, offset, &val);
-	debug("%04x %08x\n", socket, offset, val);
-	return val;
-}
+/* Flag to access all functions */
+#define BIND_FN_ALL	0xff
 
-static inline void config_writeb(struct yenta_socket *socket, unsigned offset, u8 val)
-{
-	debug("%04x %02x\n", socket, offset, val);
-	pci_write_config_byte(socket->dev, offset, val);
-}
+/* Each card function gets one of these guys */
+typedef struct config_t {
+	struct kref	ref;
+	unsigned int	state;
 
-static inline void config_writew(struct yenta_socket *socket, unsigned offset, u16 val)
-{
-	debug("%04x %04x\n", socket, offset, val);
-	pci_write_config_word(socket->dev, offset, val);
-}
+	struct resource io[MAX_IO_WIN]; /* io ports */
+	struct resource mem[MAX_WIN];   /* mem areas */
+} config_t;
 
-static inline void config_writel(struct yenta_socket *socket, unsigned offset, u32 val)
-{
-	debug("%04x %08x\n", socket, offset, val);
-	pci_write_config_dword(socket->dev, offset, val);
-}
 
-static inline u8 exca_readb(struct yenta_socket *socket, unsigned reg)
-{
-	u8 val = readb(socket->base + 0x800 + reg);
-	debug("%04x %02x\n", socket, reg, val);
-	return val;
-}
+struct cis_cache_entry {
+	struct list_head	node;
+	unsigned int		addr;
+	unsigned int		len;
+	unsigned int		attr;
+	unsigned char		cache[];
+};
+
+struct pccard_resource_ops {
+	int	(*validate_mem)		(struct pcmcia_socket *s);
+	int	(*find_io)		(struct pcmcia_socket *s,
+					 unsigned int attr,
+					 unsigned int *base,
+					 unsigned int num,
+					 unsigned int align,
+					 struct resource **parent);
+	struct resource* (*find_mem)	(unsigned long base, unsigned long num,
+					 unsigned long align, int low,
+					 struct pcmcia_socket *s);
+	int	(*init)			(struct pcmcia_socket *s);
+	void	(*exit)			(struct pcmcia_socket *s);
+};
+
+/* Flags in config state */
+#define CONFIG_LOCKED		0x01
+#define CONFIG_IRQ_REQ		0x02
+#define CONFIG_IO_REQ		0x04
+
+/* Flags in socket state */
+#define SOCKET_PRESENT		0x0008
+#define SOCKET_INUSE		0x0010
+#define SOCKET_IN_RESUME	0x0040
+#define SOCKET_SUSPEND		0x0080
+#define SOCKET_WIN_REQ(i)	(0x0100<<(i))
+#define SOCKET_CARDBUS		0x8000
+#define SOCKET_CARDBUS_CONFIG	0x10000
+
 
 /*
-static inline u8 exca_readw(struct yenta_socket *socket, unsigned reg)
+ * Stuff internal to module "pcmcia_rsrc":
+ */
+extern int static_init(struct pcmcia_socket *s);
+extern struct resource *pcmcia_make_resource(resource_size_t start,
+					resource_size_t end,
+					unsigned long flags, const char *name);
+
+/*
+ * Stuff internal to module "pcmcia_core":
+ */
+
+/* socket_sysfs.c */
+extern int pccard_sysfs_add_socket(struct device *dev);
+extern void pccard_sysfs_remove_socket(struct device *dev);
+
+/* cardbus.c */
+int cb_alloc(struct pcmcia_socket *s);
+void cb_free(struct pcmcia_socket *s);
+
+
+
+/*
+ * Stuff exported by module "pcmcia_core" to module "pcmcia"
+ */
+
+struct pcmcia_callback{
+	struct module	*owner;
+	int		(*add) (struct pcmcia_socket *s);
+	int		(*remove) (struct pcmcia_socket *s);
+	void		(*requery) (struct pcmcia_socket *s);
+	int		(*validate) (struct pcmcia_socket *s, unsigned int *i);
+	int		(*suspend) (struct pcmcia_socket *s);
+	int		(*early_resume) (struct pcmcia_socket *s);
+	int		(*resume) (struct pcmcia_socket *s);
+};
+
+/* cs.c */
+extern struct rw_semaphore pcmcia_socket_list_rwsem;
+extern struct list_head pcmcia_socket_list;
+extern struct class pcmcia_socket_class;
+
+int pccard_register_pcmcia(struct pcmcia_socket *s, struct pcmcia_callback *c);
+struct pcmcia_socket *pcmcia_get_socket_by_nr(unsigned int nr);
+
+void pcmcia_parse_uevents(struct pcmcia_socket *socket, unsigned int events);
+#define PCMCIA_UEVENT_EJECT	0x0001
+#define PCMCIA_UEVENT_INSERT	0x0002
+#define PCMCIA_UEVENT_SUSPEND	0x0004
+#define PCMCIA_UEVENT_RESUME	0x0008
+#define PCMCIA_UEVENT_REQUERY	0x0010
+
+struct pcmcia_socket *pcmcia_get_socket(struct pcmcia_socket *skt);
+void pcmcia_put_socket(struct pcmcia_socket *skt);
+
+/*
+ * Stuff internal to module "pcmcia".
+ */
+/* ds.c */
+extern struct bus_type pcmcia_bus_type;
+
+struct pcmcia_device;
+
+/* pcmcia_resource.c */
+extern int pcmcia_release_configuration(struct pcmcia_device *p_dev);
+extern int pcmcia_validate_mem(struct pcmcia_socket *s);
+extern struct resource *pcmcia_find_mem_region(u_long base,
+					       u_long num,
+					       u_long align,
+					       int low,
+					       struct pcmcia_socket *s);
+
+void pcmcia_cleanup_irq(struct pcmcia_socket *s);
+int pcmcia_setup_irq(struct pcmcia_device *p_dev);
+
+/* cistpl.c */
+extern const struct bin_attribute pccard_cis_attr;
+
+int pcmcia_read_cis_mem(struct pcmcia_socket *s, int attr,
+			u_int addr, u_int len, void *ptr);
+int pcmcia_write_cis_mem(struct pcmcia_socket *s, int attr,
+			u_int addr, u_int len, void *ptr);
+void release_cis_mem(struct pcmcia_socket *s);
+void destroy_cis_cache(struct pcmcia_socket *s);
+int pccard_read_tuple(struct pcmcia_socket *s, unsigned int function,
+		      cisdata_t code, void *parse);
+int pcmcia_replace_cis(struct pcmcia_socket *s,
+		       const u8 *data, const size_t len);
+int pccard_validate_cis(struct pcmcia_socket *s, unsigned int *count);
+int verify_cis_cache(struct pcmcia_socket *s);
+
+int pccard_get_first_tuple(struct pcmcia_socket *s, unsigned int function,
+			tuple_t *tuple);
+
+int pccard_get_next_tuple(struct pcmcia_socket *s, unsigned int function,
+			tuple_t *tuple);
+
+int pccard_get_tuple_data(struct pcmcia_socket *s, tuple_t *tuple);
+
+#endif /* _LINUX_CS_INTERNAL_H */
+/*
+ * cs.c -- Kernel Card Services - core services
+ *
+ * The initial developer of the original code is David A. Hinds
+ * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+ * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+ *
+ * (C) 1999		David A. Hinds
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/major.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/timer.h>
+#include <linux/ioport.h>
+#include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/device.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <asm/irq.h>
+
+#include <pcmcia/cisreg.h>
+
+/* Module parameters */
+
+#define INT_MODULE_PARM(n, v) static int n = v; module_param(n, int, 0444)
+
+INT_MODULE_PARM(setup_delay,	10);		/* centiseconds */
+INT_MODULE_PARM(resume_delay,	20);		/* centiseconds */
+INT_MODULE_PARM(shutdown_delay,	3);		/* centiseconds */
+INT_MODULE_PARM(vcc_settle,	40);		/* centiseconds */
+INT_MODULE_PARM(reset_time,	10);		/* usecs */
+INT_MODULE_PARM(unreset_delay,	10);		/* centiseconds */
+INT_MODULE_PARM(unreset_check,	10);		/* centiseconds */
+INT_MODULE_PARM(unreset_limit,	30);		/* unreset_check's */
+
+/* Access speed for attribute memory windows */
+INT_MODULE_PARM(cis_speed,	300);		/* ns */
+
+
+socket_state_t dead_socket = {
+	.csc_mask	= SS_DETECT,
+};
+EXPORT_SYMBOL(dead_socket);
+
+
+/* List of all sockets, protected by a rwsem */
+LIST_HEAD(pcmcia_socket_list);
+EXPORT_SYMBOL(pcmcia_socket_list);
+
+DECLARE_RWSEM(pcmcia_socket_list_rwsem);
+EXPORT_SYMBOL(pcmcia_socket_list_rwsem);
+
+
+struct pcmcia_socket *pcmcia_get_socket(struct pcmcia_socket *skt)
 {
-	u16 val;
-	val = readb(socket->base + 0x800 + reg);
-	val |= readb(socket->base + 0x800 + reg + 1) << 8;
-	debug("%04x %04x\n", socket, reg, val);
-	return val;
+	struct device *dev = get_device(&skt->dev);
+	if (!dev)
+		return NULL;
+	return dev_get_drvdata(dev);
 }
-*/
+EXPORT_SYMBOL(pcmcia_get_socket);
 
-static inline void exca_writeb(struct yenta_socket *socket, unsigned reg, u8 val)
+
+void pcmcia_put_socket(struct pcmcia_socket *skt)
 {
-	debug("%04x %02x\n", socket, reg, val);
-	writeb(val, socket->base + 0x800 + reg);
-	readb(socket->base + 0x800 + reg); /* PCI write posting... */
+	put_device(&skt->dev);
 }
+EXPORT_SYMBOL(pcmcia_put_socket);
 
-static void exca_writew(struct yenta_socket *socket, unsigned reg, u16 val)
+
+static void pcmcia_release_socket(struct device *dev)
 {
-	debug("%04x %04x\n", socket, reg, val);
-	writeb(val, socket->base + 0x800 + reg);
-	writeb(val >> 8, socket->base + 0x800 + reg + 1);
+	struct pcmcia_socket *socket = dev_get_drvdata(dev);
 
-	/* PCI write posting... */
-	readb(socket->base + 0x800 + reg);
-	readb(socket->base + 0x800 + reg + 1);
+	complete(&socket->socket_released);
 }
 
-static ssize_t show_yenta_registers(struct device *yentadev, struct device_attribute *attr, char *buf)
+static int pccardd(void *__skt);
+
+/**
+ * pcmcia_register_socket - add a new pcmcia socket device
+ * @socket: the &socket to register
+ */
+int pcmcia_register_socket(struct pcmcia_socket *socket)
 {
-	struct yenta_socket *socket = dev_get_drvdata(yentadev);
-	int offset = 0, i;
+	struct task_struct *tsk;
+	int ret;
 
-	offset = sysfs_emit(buf, "CB registers:");
-	for (i = 0; i < 0x24; i += 4) {
-		unsigned val;
-		if (!(i & 15))
-			offset += sysfs_emit_at(buf, offset, "\n%02x:", i);
-		val = cb_readl(socket, i);
-		offset += sysfs_emit_at(buf, offset, " %08x", val);
+	if (!socket || !socket->ops || !socket->dev.parent || !socket->resource_ops)
+		return -EINVAL;
+
+	dev_dbg(&socket->dev, "pcmcia_register_socket(0x%p)\n", socket->ops);
+
+	/* try to obtain a socket number [yes, it gets ugly if we
+	 * register more than 2^sizeof(unsigned int) pcmcia
+	 * sockets... but the socket number is deprecated
+	 * anyways, so I don't care] */
+	down_write(&pcmcia_socket_list_rwsem);
+	if (list_empty(&pcmcia_socket_list))
+		socket->sock = 0;
+	else {
+		unsigned int found, i = 1;
+		struct pcmcia_socket *tmp;
+		do {
+			found = 1;
+			list_for_each_entry(tmp, &pcmcia_socket_list, socket_list) {
+				if (tmp->sock == i)
+					found = 0;
+			}
+			i++;
+		} while (!found);
+		socket->sock = i - 1;
 	}
+	list_add_tail(&socket->socket_list, &pcmcia_socket_list);
+	up_write(&pcmcia_socket_list_rwsem);
 
-	offset += sysfs_emit_at(buf, offset, "\n\nExCA registers:");
-	for (i = 0; i < 0x45; i++) {
-		unsigned char val;
-		if (!(i & 7)) {
-			if (i & 8) {
-				memcpy(buf + offset, " -", 2);
-				offset += 2;
-			} else
-				offset += sysfs_emit_at(buf, offset, "\n%02x:", i);
-		}
-		val = exca_readb(socket, i);
-		offset += sysfs_emit_at(buf, offset, " %02x", val);
+#if !IS_ENABLED(CONFIG_CARDBUS)
+	/*
+	 * If we do not support Cardbus, ensure that
+	 * the Cardbus socket capability is disabled.
+	 */
+	socket->features &= ~SS_CAP_CARDBUS;
+#endif
+
+	/* set proper values in socket->dev */
+	dev_set_drvdata(&socket->dev, socket);
+	socket->dev.class = &pcmcia_socket_class;
+	dev_set_name(&socket->dev, "pcmcia_socket%u", socket->sock);
+
+	/* base address = 0, map = 0 */
+	socket->cis_mem.flags = 0;
+	socket->cis_mem.speed = cis_speed;
+
+	INIT_LIST_HEAD(&socket->cis_cache);
+
+	init_completion(&socket->socket_released);
+	init_completion(&socket->thread_done);
+	mutex_init(&socket->skt_mutex);
+	mutex_init(&socket->ops_mutex);
+	spin_lock_init(&socket->thread_lock);
+
+	if (socket->resource_ops->init) {
+		mutex_lock(&socket->ops_mutex);
+		ret = socket->resource_ops->init(socket);
+		mutex_unlock(&socket->ops_mutex);
+		if (ret)
+			goto err;
 	}
-	sysfs_emit_at(buf, offset, "\n");
-	return offset;
-}
 
-static DEVICE_ATTR(yenta_registers, S_IRUSR, show_yenta_registers, NULL);
+	tsk = kthread_run(pccardd, socket, "pccardd");
+	if (IS_ERR(tsk)) {
+		ret = PTR_ERR(tsk);
+		goto err;
+	}
+
+	wait_for_completion(&socket->thread_done);
+	if (!socket->thread) {
+		dev_warn(&socket->dev,
+			 "PCMCIA: warning: socket thread did not start\n");
+		return -EIO;
+	}
+
+	pcmcia_parse_events(socket, SS_DETECT);
+
+	/*
+	 * Let's try to get the PCMCIA module for 16-bit PCMCIA support.
+	 * If it fails, it doesn't matter -- we still have 32-bit CardBus
+	 * support to offer, so this is not a failure mode.
+	 */
+	request_module_nowait("pcmcia");
+
+	return 0;
+
+ err:
+	down_write(&pcmcia_socket_list_rwsem);
+	list_del(&socket->socket_list);
+	up_write(&pcmcia_socket_list_rwsem);
+	return ret;
+} /* pcmcia_register_socket */
+EXPORT_SYMBOL(pcmcia_register_socket);
+
+
+/**
+ * pcmcia_unregister_socket - remove a pcmcia socket device
+ * @socket: the &socket to unregister
+ */
+void pcmcia_unregister_socket(struct pcmcia_socket *socket)
+{
+	if (!socket)
+		return;
+
+	dev_dbg(&socket->dev, "pcmcia_unregister_socket(0x%p)\n", socket->ops);
+
+	if (socket->thread)
+		kthread_stop(socket->thread);
+
+	/* remove from our own list */
+	down_write(&pcmcia_socket_list_rwsem);
+	list_del(&socket->socket_list);
+	up_write(&pcmcia_socket_list_rwsem);
+
+	/* wait for sysfs to drop all references */
+	if (socket->resource_ops->exit) {
+		mutex_lock(&socket->ops_mutex);
+		socket->resource_ops->exit(socket);
+		mutex_unlock(&socket->ops_mutex);
+	}
+	wait_for_completion(&socket->socket_released);
+} /* pcmcia_unregister_socket */
+EXPORT_SYMBOL(pcmcia_unregister_socket);
+
+
+struct pcmcia_socket *pcmcia_get_socket_by_nr(unsigned int nr)
+{
+	struct pcmcia_socket *s;
+
+	down_read(&pcmcia_socket_list_rwsem);
+	list_for_each_entry(s, &pcmcia_socket_list, socket_list)
+		if (s->sock == nr) {
+			up_read(&pcmcia_socket_list_rwsem);
+			return s;
+		}
+	up_read(&pcmcia_socket_list_rwsem);
+
+	return NULL;
+
+}
+EXPORT_SYMBOL(pcmcia_get_socket_by_nr);
+
+static int socket_reset(struct pcmcia_socket *skt)
+{
+	int status, i;
+
+	dev_dbg(&skt->dev, "reset\n");
+
+	skt->socket.flags |= SS_OUTPUT_ENA | SS_RESET;
+	skt->ops->set_socket(skt, &skt->socket);
+	udelay((long)reset_time);
+
+	skt->socket.flags &= ~SS_RESET;
+	skt->ops->set_socket(skt, &skt->socket);
+
+	msleep(unreset_delay * 10);
+	for (i = 0; i < unreset_limit; i++) {
+		skt->ops->get_status(skt, &status);
+
+		if (!(status & SS_DETECT))
+			return -ENODEV;
+
+		if (status & SS_READY)
+			return 0;
+
+		msleep(unreset_check * 10);
+	}
+
+	dev_err(&skt->dev, "time out after reset\n");
+	return -ETIMEDOUT;
+}
 
 /*
- * Ugh, mixed-mode cardbus and 16-bit pccard state: things depend
- * on what kind of card is inserted..
+ * socket_setup() and socket_shutdown() are called by the main event handler
+ * when card insertion and removal events are received.
+ * socket_setup() turns on socket power and resets the socket, in two stages.
+ * socket_shutdown() unconfigures a socket and turns off socket power.
  */
-static int yenta_get_status(struct pcmcia_socket *sock, unsigned int *value)
+static void socket_shutdown(struct pcmcia_socket *s)
 {
-	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
-	unsigned int val;
-	u32 state = cb_readl(socket, CB_SOCKET_STATE);
+	int status;
+
+	dev_dbg(&s->dev, "shutdown\n");
+
+	if (s->callback)
+		s->callback->remove(s);
+
+	mutex_lock(&s->ops_mutex);
+	s->state &= SOCKET_INUSE | SOCKET_PRESENT;
+	msleep(shutdown_delay * 10);
+	s->state &= SOCKET_INUSE;
+
+	/* Blank out the socket state */
+	s->socket = dead_socket;
+	s->ops->init(s);
+	s->ops->set_socket(s, &s->socket);
+	s->lock_count = 0;
+	kfree(s->fake_cis);
+	s->fake_cis = NULL;
+	s->functions = 0;
+
+	/* From here on we can be sure that only we (that is, the
+	 * pccardd thread) accesses this socket, and all (16-bit)
+	 * PCMCIA interactions are gone. Therefore, release
+	 * ops_mutex so that we don't get a sysfs-related lockdep
+	 * warning.
+	 */
+	mutex_unlock(&s->ops_mutex);
 
-	val  = (state & CB_3VCARD) ? SS_3VCARD : 0;
-	val |= (state & CB_XVCARD) ? SS_XVCARD : 0;
-	val |= (state & (CB_5VCARD | CB_3VCARD | CB_XVCARD | CB_YVCARD)) ? 0 : SS_PENDING;
-	val |= (state & (CB_CDETECT1 | CB_CDETECT2)) ? SS_PENDING : 0;
+#if IS_ENABLED(CONFIG_CARDBUS)
+	cb_free(s);
+#endif
 
+	/* give socket some time to power down */
+	msleep(100);
 
-	if (state & CB_CBCARD) {
-		val |= SS_CARDBUS;
-		val |= (state & CB_CARDSTS) ? SS_STSCHG : 0;
-		val |= (state & (CB_CDETECT1 | CB_CDETECT2)) ? 0 : SS_DETECT;
-		val |= (state & CB_PWRCYCLE) ? SS_POWERON | SS_READY : 0;
-	} else if (state & CB_16BITCARD) {
-		dev_warn_once(&socket->dev->dev,
-			      "16-bit PCMCIA cards are no longer supported\n");
+	s->ops->get_status(s, &status);
+	if (status & SS_POWERON) {
+		dev_err(&s->dev,
+			"*** DANGER *** unable to remove socket power\n");
 	}
 
-	*value = val;
-	return 0;
+	s->state &= ~SOCKET_INUSE;
 }
 
-static void yenta_set_power(struct yenta_socket *socket, socket_state_t *state)
+static int socket_setup(struct pcmcia_socket *skt, int initial_delay)
 {
-	/* some birdges require to use the ExCA registers to power 16bit cards */
-	if (!(cb_readl(socket, CB_SOCKET_STATE) & CB_CBCARD) &&
-	    (socket->flags & YENTA_16BIT_POWER_EXCA)) {
-		u8 reg, old;
-		reg = old = exca_readb(socket, I365_POWER);
-		reg &= ~(I365_VCC_MASK | I365_VPP1_MASK | I365_VPP2_MASK);
+	int status, i;
 
-		/* i82365SL-DF style */
-		if (socket->flags & YENTA_16BIT_POWER_DF) {
-			switch (state->Vcc) {
-			case 33:
-				reg |= I365_VCC_3V;
-				break;
-			case 50:
-				reg |= I365_VCC_5V;
-				break;
-			default:
-				reg = 0;
-				break;
-			}
-			switch (state->Vpp) {
-			case 33:
-			case 50:
-				reg |= I365_VPP1_5V;
-				break;
-			case 120:
-				reg |= I365_VPP1_12V;
-				break;
-			}
-		} else {
-			/* i82365SL-B style */
-			switch (state->Vcc) {
-			case 50:
-				reg |= I365_VCC_5V;
-				break;
-			default:
-				reg = 0;
-				break;
-			}
-			switch (state->Vpp) {
-			case 50:
-				reg |= I365_VPP1_5V | I365_VPP2_5V;
-				break;
-			case 120:
-				reg |= I365_VPP1_12V | I365_VPP2_12V;
-				break;
-			}
-		}
+	dev_dbg(&skt->dev, "setup\n");
 
-		if (reg != old)
-			exca_writeb(socket, I365_POWER, reg);
-	} else {
-		u32 reg = 0;	/* CB_SC_STPCLK? */
-		switch (state->Vcc) {
-		case 33:
-			reg = CB_SC_VCC_3V;
-			break;
-		case 50:
-			reg = CB_SC_VCC_5V;
-			break;
-		default:
-			reg = 0;
-			break;
-		}
-		switch (state->Vpp) {
-		case 33:
-			reg |= CB_SC_VPP_3V;
-			break;
-		case 50:
-			reg |= CB_SC_VPP_5V;
-			break;
-		case 120:
-			reg |= CB_SC_VPP_12V;
+	skt->ops->get_status(skt, &status);
+	if (!(status & SS_DETECT))
+		return -ENODEV;
+
+	msleep(initial_delay * 10);
+
+	for (i = 0; i < 100; i++) {
+		skt->ops->get_status(skt, &status);
+		if (!(status & SS_DETECT))
+			return -ENODEV;
+
+		if (!(status & SS_PENDING))
 			break;
+
+		msleep(100);
+	}
+
+	if (status & SS_PENDING) {
+		dev_err(&skt->dev, "voltage interrogation timed out\n");
+		return -ETIMEDOUT;
+	}
+
+	if (status & SS_CARDBUS) {
+		if (!(skt->features & SS_CAP_CARDBUS)) {
+			dev_err(&skt->dev, "cardbus cards are not supported\n");
+			return -EINVAL;
 		}
-		if (reg != cb_readl(socket, CB_SOCKET_CONTROL))
-			cb_writel(socket, CB_SOCKET_CONTROL, reg);
+		skt->state |= SOCKET_CARDBUS;
+	} else
+		skt->state &= ~SOCKET_CARDBUS;
+
+	/*
+	 * Decode the card voltage requirements, and apply power to the card.
+	 */
+	if (status & SS_3VCARD)
+		skt->socket.Vcc = skt->socket.Vpp = 33;
+	else if (!(status & SS_XVCARD))
+		skt->socket.Vcc = skt->socket.Vpp = 50;
+	else {
+		dev_err(&skt->dev, "unsupported voltage key\n");
+		return -EIO;
+	}
+
+	if (skt->power_hook)
+		skt->power_hook(skt, HOOK_POWER_PRE);
+
+	skt->socket.flags = 0;
+	skt->ops->set_socket(skt, &skt->socket);
+
+	/*
+	 * Wait "vcc_settle" for the supply to stabilise.
+	 */
+	msleep(vcc_settle * 10);
+
+	skt->ops->get_status(skt, &status);
+	if (!(status & SS_POWERON)) {
+		dev_err(&skt->dev, "unable to apply power\n");
+		return -EIO;
 	}
+
+	status = socket_reset(skt);
+
+	if (skt->power_hook)
+		skt->power_hook(skt, HOOK_POWER_POST);
+
+	return status;
 }
 
-static int yenta_set_socket(struct pcmcia_socket *sock, socket_state_t *state)
+/*
+ * Handle card insertion.  Setup the socket, reset the card,
+ * and then tell the rest of PCMCIA that a card is present.
+ */
+static int socket_insert(struct pcmcia_socket *skt)
 {
-	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
-	u16 bridge;
+	int ret;
 
-	/* if powering down: do it immediately */
-	if (state->Vcc == 0)
-		yenta_set_power(socket, state);
+	dev_dbg(&skt->dev, "insert\n");
 
-	socket->io_irq = state->io_irq;
-	bridge = config_readw(socket, CB_BRIDGE_CONTROL) & ~(CB_BRIDGE_CRST | CB_BRIDGE_INTR);
-	if (cb_readl(socket, CB_SOCKET_STATE) & CB_CBCARD) {
-		u8 intr;
-		bridge |= (state->flags & SS_RESET) ? CB_BRIDGE_CRST : 0;
+	mutex_lock(&skt->ops_mutex);
+	if (skt->state & SOCKET_INUSE) {
+		mutex_unlock(&skt->ops_mutex);
+		return -EINVAL;
+	}
+	skt->state |= SOCKET_INUSE;
 
-		/* ISA interrupt control? */
-		intr = exca_readb(socket, I365_INTCTL);
-		intr = (intr & ~0xf);
-		if (!socket->dev->irq) {
-			intr |= socket->cb_irq ? socket->cb_irq : state->io_irq;
-			bridge |= CB_BRIDGE_INTR;
-		}
-		exca_writeb(socket, I365_INTCTL, intr);
-	}  else {
-		u8 reg;
+	ret = socket_setup(skt, setup_delay);
+	if (ret == 0) {
+		skt->state |= SOCKET_PRESENT;
 
-		reg = exca_readb(socket, I365_INTCTL) & (I365_RING_ENA | I365_INTR_ENA);
-		reg |= (state->flags & SS_RESET) ? 0 : I365_PC_RESET;
-		reg |= (state->flags & SS_IOCARD) ? I365_PC_IOCARD : 0;
-		if (state->io_irq != socket->dev->irq) {
-			reg |= state->io_irq;
-			bridge |= CB_BRIDGE_INTR;
+		dev_notice(&skt->dev, "pccard: %s card inserted into slot %d\n",
+			   (skt->state & SOCKET_CARDBUS) ? "CardBus" : "PCMCIA",
+			   skt->sock);
+
+#if IS_ENABLED(CONFIG_CARDBUS)
+		if (skt->state & SOCKET_CARDBUS) {
+			cb_alloc(skt);
+			skt->state |= SOCKET_CARDBUS_CONFIG;
 		}
-		exca_writeb(socket, I365_INTCTL, reg);
+#endif
+		dev_dbg(&skt->dev, "insert done\n");
+		mutex_unlock(&skt->ops_mutex);
 
-		reg = exca_readb(socket, I365_POWER) & (I365_VCC_MASK|I365_VPP1_MASK);
-		reg |= I365_PWR_NORESET;
-		if (state->flags & SS_PWR_AUTO)
-			reg |= I365_PWR_AUTO;
-		if (state->flags & SS_OUTPUT_ENA)
-			reg |= I365_PWR_OUT;
-		if (exca_readb(socket, I365_POWER) != reg)
-			exca_writeb(socket, I365_POWER, reg);
+		if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
+			skt->callback->add(skt);
+	} else {
+		mutex_unlock(&skt->ops_mutex);
+		socket_shutdown(skt);
+	}
 
-		/* CSC interrupt: no ISA irq for CSC */
-		reg = exca_readb(socket, I365_CSCINT);
-		reg &= I365_CSC_IRQ_MASK;
-		reg |= I365_CSC_DETECT;
-		if (state->flags & SS_IOCARD) {
-			if (state->csc_mask & SS_STSCHG)
-				reg |= I365_CSC_STSCHG;
-		} else {
-			if (state->csc_mask & SS_BATDEAD)
-				reg |= I365_CSC_BVD1;
-			if (state->csc_mask & SS_BATWARN)
-				reg |= I365_CSC_BVD2;
-			if (state->csc_mask & SS_READY)
-				reg |= I365_CSC_READY;
-		}
-		exca_writeb(socket, I365_CSCINT, reg);
-		exca_readb(socket, I365_CSC);
-		if (sock->zoom_video)
-			sock->zoom_video(sock, state->flags & SS_ZVCARD);
+	return ret;
+}
+
+static int socket_suspend(struct pcmcia_socket *skt)
+{
+	if ((skt->state & SOCKET_SUSPEND) && !(skt->state & SOCKET_IN_RESUME))
+		return -EBUSY;
+
+	mutex_lock(&skt->ops_mutex);
+	/* store state on first suspend, but not after spurious wakeups */
+	if (!(skt->state & SOCKET_IN_RESUME))
+		skt->suspended_state = skt->state;
+
+	skt->socket = dead_socket;
+	skt->ops->set_socket(skt, &skt->socket);
+	if (skt->ops->suspend)
+		skt->ops->suspend(skt);
+	skt->state |= SOCKET_SUSPEND;
+	skt->state &= ~SOCKET_IN_RESUME;
+	mutex_unlock(&skt->ops_mutex);
+	return 0;
+}
+
+static int socket_early_resume(struct pcmcia_socket *skt)
+{
+	mutex_lock(&skt->ops_mutex);
+	skt->socket = dead_socket;
+	skt->ops->init(skt);
+	skt->ops->set_socket(skt, &skt->socket);
+	if (skt->state & SOCKET_PRESENT)
+		skt->resume_status = socket_setup(skt, resume_delay);
+	skt->state |= SOCKET_IN_RESUME;
+	mutex_unlock(&skt->ops_mutex);
+	return 0;
+}
+
+static int socket_late_resume(struct pcmcia_socket *skt)
+{
+	int ret = 0;
+
+	mutex_lock(&skt->ops_mutex);
+	skt->state &= ~(SOCKET_SUSPEND | SOCKET_IN_RESUME);
+	mutex_unlock(&skt->ops_mutex);
+
+	if (!(skt->state & SOCKET_PRESENT)) {
+		ret = socket_insert(skt);
+		if (ret == -ENODEV)
+			ret = 0;
+		return ret;
 	}
-	config_writew(socket, CB_BRIDGE_CONTROL, bridge);
-	/* Socket event mask: get card insert/remove events.. */
-	cb_writel(socket, CB_SOCKET_EVENT, -1);
-	cb_writel(socket, CB_SOCKET_MASK, CB_CDMASK);
 
-	/* if powering up: do it as the last step when the socket is configured */
-	if (state->Vcc != 0)
-		yenta_set_power(socket, state);
+	if (skt->resume_status) {
+		socket_shutdown(skt);
+		return 0;
+	}
+
+	if (skt->suspended_state != skt->state) {
+		dev_dbg(&skt->dev,
+			"suspend state 0x%x != resume state 0x%x\n",
+			skt->suspended_state, skt->state);
+
+		socket_shutdown(skt);
+		return socket_insert(skt);
+	}
+
+	if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
+		ret = skt->callback->early_resume(skt);
+	return ret;
+}
+
+/*
+ * Finalize the resume. In case of a cardbus socket, we have
+ * to rebind the devices as we can't be certain that it has been
+ * replaced, or not.
+ */
+static int socket_complete_resume(struct pcmcia_socket *skt)
+{
+	int ret = 0;
+#if IS_ENABLED(CONFIG_CARDBUS)
+	if (skt->state & SOCKET_CARDBUS) {
+		/* We can't be sure the CardBus card is the same
+		 * as the one previously inserted. Therefore, remove
+		 * and re-add... */
+		cb_free(skt);
+		ret = cb_alloc(skt);
+		if (ret)
+			cb_free(skt);
+	}
+#endif
+	return ret;
+}
+
+/*
+ * Resume a socket.  If a card is present, verify its CIS against
+ * our cached copy.  If they are different, the card has been
+ * replaced, and we need to tell the drivers.
+ */
+static int socket_resume(struct pcmcia_socket *skt)
+{
+	int err;
+	if (!(skt->state & SOCKET_SUSPEND))
+		return -EBUSY;
+
+	socket_early_resume(skt);
+	err = socket_late_resume(skt);
+	if (!err)
+		err = socket_complete_resume(skt);
+	return err;
+}
+
+static void socket_remove(struct pcmcia_socket *skt)
+{
+	dev_notice(&skt->dev, "pccard: card ejected from slot %d\n", skt->sock);
+	socket_shutdown(skt);
+}
+
+/*
+ * Process a socket card detect status change.
+ *
+ * If we don't have a card already present, delay the detect event for
+ * about 20ms (to be on the safe side) before reading the socket status.
+ *
+ * Some i82365-based systems send multiple SS_DETECT events during card
+ * insertion, and the "card present" status bit seems to bounce.  This
+ * will probably be true with GPIO-based card detection systems after
+ * the product has aged.
+ */
+static void socket_detect_change(struct pcmcia_socket *skt)
+{
+	if (!(skt->state & SOCKET_SUSPEND)) {
+		int status;
+
+		if (!(skt->state & SOCKET_PRESENT))
+			msleep(20);
+
+		skt->ops->get_status(skt, &status);
+		if ((skt->state & SOCKET_PRESENT) &&
+		     !(status & SS_DETECT))
+			socket_remove(skt);
+		if (!(skt->state & SOCKET_PRESENT) &&
+		    (status & SS_DETECT))
+			socket_insert(skt);
+	}
+}
+
+static int pccardd(void *__skt)
+{
+	struct pcmcia_socket *skt = __skt;
+	int ret;
+
+	skt->thread = current;
+	skt->socket = dead_socket;
+	skt->ops->init(skt);
+	skt->ops->set_socket(skt, &skt->socket);
+
+	/* register with the device core */
+	ret = device_register(&skt->dev);
+	if (ret) {
+		dev_warn(&skt->dev, "PCMCIA: unable to register socket\n");
+		skt->thread = NULL;
+		complete(&skt->thread_done);
+		return 0;
+	}
+	ret = pccard_sysfs_add_socket(&skt->dev);
+	if (ret)
+		dev_warn(&skt->dev, "err %d adding socket attributes\n", ret);
+
+	complete(&skt->thread_done);
+
+	/* wait for userspace to catch up */
+	msleep(250);
+
+	set_freezable();
+	for (;;) {
+		unsigned long flags;
+		unsigned int events;
+		unsigned int sysfs_events;
+
+		spin_lock_irqsave(&skt->thread_lock, flags);
+		events = skt->thread_events;
+		skt->thread_events = 0;
+		sysfs_events = skt->sysfs_events;
+		skt->sysfs_events = 0;
+		spin_unlock_irqrestore(&skt->thread_lock, flags);
+
+		mutex_lock(&skt->skt_mutex);
+		if (events & SS_DETECT)
+			socket_detect_change(skt);
+
+		if (sysfs_events) {
+			if (sysfs_events & PCMCIA_UEVENT_EJECT)
+				socket_remove(skt);
+			if (sysfs_events & PCMCIA_UEVENT_INSERT)
+				socket_insert(skt);
+			if ((sysfs_events & PCMCIA_UEVENT_SUSPEND) &&
+				!(skt->state & SOCKET_CARDBUS)) {
+				if (skt->callback)
+					ret = skt->callback->suspend(skt);
+				else
+					ret = 0;
+				if (!ret) {
+					socket_suspend(skt);
+					msleep(100);
+				}
+			}
+			if ((sysfs_events & PCMCIA_UEVENT_RESUME) &&
+				!(skt->state & SOCKET_CARDBUS)) {
+				ret = socket_resume(skt);
+				if (!ret && skt->callback)
+					skt->callback->resume(skt);
+			}
+			if ((sysfs_events & PCMCIA_UEVENT_REQUERY) &&
+				!(skt->state & SOCKET_CARDBUS)) {
+				if (!ret && skt->callback)
+					skt->callback->requery(skt);
+			}
+		}
+		mutex_unlock(&skt->skt_mutex);
+
+		if (events || sysfs_events)
+			continue;
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (kthread_should_stop())
+			break;
+
+		schedule();
+
+		try_to_freeze();
+	}
+	/* make sure we are running before we exit */
+	__set_current_state(TASK_RUNNING);
+
+	/* shut down socket, if a device is still present */
+	if (skt->state & SOCKET_PRESENT) {
+		mutex_lock(&skt->skt_mutex);
+		socket_remove(skt);
+		mutex_unlock(&skt->skt_mutex);
+	}
+
+	/* remove from the device core */
+	pccard_sysfs_remove_socket(&skt->dev);
+	device_unregister(&skt->dev);
+
+	return 0;
+}
+
+/*
+ * Yenta (at least) probes interrupts before registering the socket and
+ * starting the handler thread.
+ */
+void pcmcia_parse_events(struct pcmcia_socket *s, u_int events)
+{
+	unsigned long flags;
+	dev_dbg(&s->dev, "parse_events: events %08x\n", events);
+	if (s->thread) {
+		spin_lock_irqsave(&s->thread_lock, flags);
+		s->thread_events |= events;
+		spin_unlock_irqrestore(&s->thread_lock, flags);
+
+		wake_up_process(s->thread);
+	}
+} /* pcmcia_parse_events */
+EXPORT_SYMBOL(pcmcia_parse_events);
+
+/**
+ * pcmcia_parse_uevents() - tell pccardd to issue manual commands
+ * @s:		the PCMCIA socket we wan't to command
+ * @events:	events to pass to pccardd
+ *
+ * userspace-issued insert, eject, suspend and resume commands must be
+ * handled by pccardd to avoid any sysfs-related deadlocks. Valid events
+ * are PCMCIA_UEVENT_EJECT (for eject), PCMCIA_UEVENT__INSERT (for insert),
+ * PCMCIA_UEVENT_RESUME (for resume), PCMCIA_UEVENT_SUSPEND (for suspend)
+ * and PCMCIA_UEVENT_REQUERY (for re-querying the PCMCIA card).
+ */
+void pcmcia_parse_uevents(struct pcmcia_socket *s, u_int events)
+{
+	unsigned long flags;
+	dev_dbg(&s->dev, "parse_uevents: events %08x\n", events);
+	if (s->thread) {
+		spin_lock_irqsave(&s->thread_lock, flags);
+		s->sysfs_events |= events;
+		spin_unlock_irqrestore(&s->thread_lock, flags);
+
+		wake_up_process(s->thread);
+	}
+}
+EXPORT_SYMBOL(pcmcia_parse_uevents);
+
+
+/* register pcmcia_callback */
+int pccard_register_pcmcia(struct pcmcia_socket *s, struct pcmcia_callback *c)
+{
+	int ret = 0;
+
+	/* s->skt_mutex also protects s->callback */
+	mutex_lock(&s->skt_mutex);
+
+	if (c) {
+		/* registration */
+		if (s->callback) {
+			ret = -EBUSY;
+			goto err;
+		}
+
+		s->callback = c;
+
+		if ((s->state & (SOCKET_PRESENT|SOCKET_CARDBUS)) == SOCKET_PRESENT)
+			s->callback->add(s);
+	} else
+		s->callback = NULL;
+ err:
+	mutex_unlock(&s->skt_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL(pccard_register_pcmcia);
+
+
+/* I'm not sure which "reset" function this is supposed to use,
+ * but for now, it uses the low-level interface's reset, not the
+ * CIS register.
+ */
+
+int pcmcia_reset_card(struct pcmcia_socket *skt)
+{
+	int ret;
+
+	dev_dbg(&skt->dev, "resetting socket\n");
+
+	mutex_lock(&skt->skt_mutex);
+	do {
+		if (!(skt->state & SOCKET_PRESENT)) {
+			dev_dbg(&skt->dev, "can't reset, not present\n");
+			ret = -ENODEV;
+			break;
+		}
+		if (skt->state & SOCKET_SUSPEND) {
+			dev_dbg(&skt->dev, "can't reset, suspended\n");
+			ret = -EBUSY;
+			break;
+		}
+		if (skt->state & SOCKET_CARDBUS) {
+			dev_dbg(&skt->dev, "can't reset, is cardbus\n");
+			ret = -EPERM;
+			break;
+		}
+
+		if (skt->callback)
+			skt->callback->suspend(skt);
+		mutex_lock(&skt->ops_mutex);
+		ret = socket_reset(skt);
+		mutex_unlock(&skt->ops_mutex);
+		if ((ret == 0) && (skt->callback))
+			skt->callback->resume(skt);
+
+		ret = 0;
+	} while (0);
+	mutex_unlock(&skt->skt_mutex);
+
+	return ret;
+} /* reset_card */
+EXPORT_SYMBOL(pcmcia_reset_card);
+
+
+static int pcmcia_socket_uevent(const struct device *dev,
+				struct kobj_uevent_env *env)
+{
+	const struct pcmcia_socket *s = container_of(dev, struct pcmcia_socket, dev);
+
+	if (add_uevent_var(env, "SOCKET_NO=%u", s->sock))
+		return -ENOMEM;
+
+	return 0;
+}
+
+
+static DECLARE_COMPLETION(pcmcia_unload);
+
+static void pcmcia_release_socket_class(struct class *data)
+{
+	complete(&pcmcia_unload);
+}
+
+
+#ifdef CONFIG_PM
+
+static int __pcmcia_pm_op(struct device *dev,
+			  int (*callback) (struct pcmcia_socket *skt))
+{
+	struct pcmcia_socket *s = container_of(dev, struct pcmcia_socket, dev);
+	int ret;
+
+	mutex_lock(&s->skt_mutex);
+	ret = callback(s);
+	mutex_unlock(&s->skt_mutex);
+
+	return ret;
+}
+
+static int pcmcia_socket_dev_suspend_noirq(struct device *dev)
+{
+	return __pcmcia_pm_op(dev, socket_suspend);
+}
+
+static int pcmcia_socket_dev_resume_noirq(struct device *dev)
+{
+	return __pcmcia_pm_op(dev, socket_early_resume);
+}
+
+static int __used pcmcia_socket_dev_resume(struct device *dev)
+{
+	return __pcmcia_pm_op(dev, socket_late_resume);
+}
+
+static void __used pcmcia_socket_dev_complete(struct device *dev)
+{
+	WARN(__pcmcia_pm_op(dev, socket_complete_resume),
+		"failed to complete resume");
+}
+
+static const struct dev_pm_ops pcmcia_socket_pm_ops = {
+	/* dev_resume may be called with IRQs enabled */
+	SET_SYSTEM_SLEEP_PM_OPS(NULL,
+				pcmcia_socket_dev_resume)
+
+	/* late suspend must be called with IRQs disabled */
+	.suspend_noirq = pcmcia_socket_dev_suspend_noirq,
+	.freeze_noirq = pcmcia_socket_dev_suspend_noirq,
+	.poweroff_noirq = pcmcia_socket_dev_suspend_noirq,
+
+	/* early resume must be called with IRQs disabled */
+	.resume_noirq = pcmcia_socket_dev_resume_noirq,
+	.thaw_noirq = pcmcia_socket_dev_resume_noirq,
+	.restore_noirq = pcmcia_socket_dev_resume_noirq,
+	.complete = pcmcia_socket_dev_complete,
+};
+
+#define PCMCIA_SOCKET_CLASS_PM_OPS (&pcmcia_socket_pm_ops)
+
+#else /* CONFIG_PM */
+
+#define PCMCIA_SOCKET_CLASS_PM_OPS NULL
+
+#endif /* CONFIG_PM */
+
+struct class pcmcia_socket_class = {
+	.name = "pcmcia_socket",
+	.dev_uevent = pcmcia_socket_uevent,
+	.dev_release = pcmcia_release_socket,
+	.class_release = pcmcia_release_socket_class,
+	.pm = PCMCIA_SOCKET_CLASS_PM_OPS,
+};
+EXPORT_SYMBOL(pcmcia_socket_class);
+
+/*
+ * socket_sysfs.c -- most of socket-related sysfs output
+ *
+ * (C) 2003 - 2004		Dominik Brodowski
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/major.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/timer.h>
+#include <linux/ioport.h>
+#include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <asm/irq.h>
+
+#include <pcmcia/ss.h>
+#include <pcmcia/cisreg.h>
+#include <pcmcia/ds.h>
+
+#define to_socket(_dev) container_of(_dev, struct pcmcia_socket, dev)
+
+static ssize_t pccard_show_type(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct pcmcia_socket *s = to_socket(dev);
+
+	if (!(s->state & SOCKET_PRESENT))
+		return -ENODEV;
+	if (s->state & SOCKET_CARDBUS)
+		return sysfs_emit(buf, "32-bit\n");
+	return sysfs_emit(buf, "16-bit\n");
+}
+static DEVICE_ATTR(card_type, 0444, pccard_show_type, NULL);
+
+static ssize_t pccard_show_voltage(struct device *dev, struct device_attribute *attr,
+				   char *buf)
+{
+	struct pcmcia_socket *s = to_socket(dev);
+
+	if (!(s->state & SOCKET_PRESENT))
+		return -ENODEV;
+	if (s->socket.Vcc)
+		return sysfs_emit(buf, "%d.%dV\n", s->socket.Vcc / 10,
+			       s->socket.Vcc % 10);
+	return sysfs_emit(buf, "X.XV\n");
+}
+static DEVICE_ATTR(card_voltage, 0444, pccard_show_voltage, NULL);
+
+static ssize_t pccard_show_vpp(struct device *dev, struct device_attribute *attr,
+			       char *buf)
+{
+	struct pcmcia_socket *s = to_socket(dev);
+	if (!(s->state & SOCKET_PRESENT))
+		return -ENODEV;
+	return sysfs_emit(buf, "%d.%dV\n", s->socket.Vpp / 10, s->socket.Vpp % 10);
+}
+static DEVICE_ATTR(card_vpp, 0444, pccard_show_vpp, NULL);
+
+static ssize_t pccard_show_vcc(struct device *dev, struct device_attribute *attr,
+			       char *buf)
+{
+	struct pcmcia_socket *s = to_socket(dev);
+	if (!(s->state & SOCKET_PRESENT))
+		return -ENODEV;
+	return sysfs_emit(buf, "%d.%dV\n", s->socket.Vcc / 10, s->socket.Vcc % 10);
+}
+static DEVICE_ATTR(card_vcc, 0444, pccard_show_vcc, NULL);
+
+
+static ssize_t pccard_store_insert(struct device *dev, struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	struct pcmcia_socket *s = to_socket(dev);
+
+	if (!count)
+		return -EINVAL;
+
+	pcmcia_parse_uevents(s, PCMCIA_UEVENT_INSERT);
+
+	return count;
+}
+static DEVICE_ATTR(card_insert, 0200, NULL, pccard_store_insert);
+
+
+static ssize_t pccard_show_card_pm_state(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct pcmcia_socket *s = to_socket(dev);
+	return sysfs_emit(buf, "%s\n", s->state & SOCKET_SUSPEND ? "off" : "on");
+}
+
+static ssize_t pccard_store_card_pm_state(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct pcmcia_socket *s = to_socket(dev);
+	ssize_t ret = count;
+
+	if (!count)
+		return -EINVAL;
+
+	if (!strncmp(buf, "off", 3))
+		pcmcia_parse_uevents(s, PCMCIA_UEVENT_SUSPEND);
+	else {
+		if (!strncmp(buf, "on", 2))
+			pcmcia_parse_uevents(s, PCMCIA_UEVENT_RESUME);
+		else
+			ret = -EINVAL;
+	}
+
+	return ret;
+}
+static DEVICE_ATTR(card_pm_state, 0644, pccard_show_card_pm_state, pccard_store_card_pm_state);
+
+static ssize_t pccard_store_eject(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct pcmcia_socket *s = to_socket(dev);
+
+	if (!count)
+		return -EINVAL;
+
+	pcmcia_parse_uevents(s, PCMCIA_UEVENT_EJECT);
+
+	return count;
+}
+static DEVICE_ATTR(card_eject, 0200, NULL, pccard_store_eject);
+
+
+static ssize_t pccard_show_irq_mask(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct pcmcia_socket *s = to_socket(dev);
+	return sysfs_emit(buf, "0x%04x\n", s->irq_mask);
+}
+
+static ssize_t pccard_store_irq_mask(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	ssize_t ret;
+	struct pcmcia_socket *s = to_socket(dev);
+	u32 mask;
+
+	if (!count)
+		return -EINVAL;
+
+	ret = sscanf(buf, "0x%x\n", &mask);
+
+	if (ret == 1) {
+		mutex_lock(&s->ops_mutex);
+		s->irq_mask &= mask;
+		mutex_unlock(&s->ops_mutex);
+		ret = 0;
+	}
+
+	return ret ? ret : count;
+}
+static DEVICE_ATTR(card_irq_mask, 0600, pccard_show_irq_mask, pccard_store_irq_mask);
+
+
+static ssize_t pccard_show_resource(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct pcmcia_socket *s = to_socket(dev);
+	return sysfs_emit(buf, "%s\n", s->resource_setup_done ? "yes" : "no");
+}
+
+static ssize_t pccard_store_resource(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct pcmcia_socket *s = to_socket(dev);
+
+	if (!count)
+		return -EINVAL;
+
+	mutex_lock(&s->ops_mutex);
+	if (!s->resource_setup_done)
+		s->resource_setup_done = 1;
+	mutex_unlock(&s->ops_mutex);
+
+	pcmcia_parse_uevents(s, PCMCIA_UEVENT_REQUERY);
+
+	return count;
+}
+static DEVICE_ATTR(available_resources_setup_done, 0600, pccard_show_resource, pccard_store_resource);
+
+static struct attribute *pccard_socket_attributes[] = {
+	&dev_attr_card_type.attr,
+	&dev_attr_card_voltage.attr,
+	&dev_attr_card_vpp.attr,
+	&dev_attr_card_vcc.attr,
+	&dev_attr_card_insert.attr,
+	&dev_attr_card_pm_state.attr,
+	&dev_attr_card_eject.attr,
+	&dev_attr_card_irq_mask.attr,
+	&dev_attr_available_resources_setup_done.attr,
+	NULL,
+};
+
+static const struct attribute_group socket_attrs = {
+	.attrs = pccard_socket_attributes,
+};
+
+int pccard_sysfs_add_socket(struct device *dev)
+{
+	return sysfs_create_group(&dev->kobj, &socket_attrs);
+}
+
+void pccard_sysfs_remove_socket(struct device *dev)
+{
+	sysfs_remove_group(&dev->kobj, &socket_attrs);
+}
+
+/*
+ * cardbus.c -- 16-bit PCMCIA core support
+ *
+ * The initial developer of the original code is David A. Hinds
+ * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+ * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+ *
+ * (C) 1999		David A. Hinds
+ */
+
+/*
+ * Cardbus handling has been re-written to be more of a PCI bridge thing,
+ * and the PCI code basically does all the resource handling.
+ *
+ *		Linus, Jan 2000
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include <pcmcia/ss.h>
+#include <pcmcia/cistpl.h>
+
+#include "cs_internal.h"
+
+static void cardbus_config_irq_and_cls(struct pci_bus *bus, int irq)
+{
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		u8 irq_pin;
+
+		/*
+		 * Since there is only one interrupt available to
+		 * CardBus devices, all devices downstream of this
+		 * device must be using this IRQ.
+		 */
+		pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &irq_pin);
+		if (irq_pin) {
+			dev->irq = irq;
+			pci_write_config_byte(dev, PCI_INTERRUPT_LINE, dev->irq);
+		}
+
+		/*
+		 * Some controllers transfer very slowly with 0 CLS.
+		 * Configure it.  This may fail as CLS configuration
+		 * is mandatory only for MWI.
+		 */
+		pci_set_cacheline_size(dev);
+
+		if (dev->subordinate)
+			cardbus_config_irq_and_cls(dev->subordinate, irq);
+	}
+}
+
+/**
+ * cb_alloc() - add CardBus device
+ * @s:		the pcmcia_socket where the CardBus device is located
+ *
+ * cb_alloc() allocates the kernel data structures for a Cardbus device
+ * and handles the lowest level PCI device setup issues.
+ */
+int __ref cb_alloc(struct pcmcia_socket *s)
+{
+	struct pci_bus *bus = s->cb_dev->subordinate;
+	struct pci_dev *dev;
+	unsigned int max, pass;
+
+	pci_lock_rescan_remove();
+
+	s->functions = pci_scan_slot(bus, PCI_DEVFN(0, 0));
+	pci_fixup_cardbus(bus);
+
+	max = bus->busn_res.start;
+	for (pass = 0; pass < 2; pass++)
+		for_each_pci_bridge(dev, bus)
+			max = pci_scan_bridge(bus, dev, max, pass);
+
+	/*
+	 * Size all resources below the CardBus controller.
+	 */
+	pci_bus_size_bridges(bus);
+	pci_bus_assign_resources(bus);
+	cardbus_config_irq_and_cls(bus, s->pci_irq);
+
+	/* socket specific tune function */
+	if (s->tune_bridge)
+		s->tune_bridge(s, bus);
+
+	pci_bus_add_devices(bus);
+
+	pci_unlock_rescan_remove();
+	return 0;
+}
+
+/**
+ * cb_free() - remove CardBus device
+ * @s:		the pcmcia_socket where the CardBus device was located
+ *
+ * cb_free() handles the lowest level PCI device cleanup.
+ */
+void cb_free(struct pcmcia_socket *s)
+{
+	struct pci_dev *bridge, *dev, *tmp;
+	struct pci_bus *bus;
+
+	bridge = s->cb_dev;
+	if (!bridge)
+		return;
+
+	bus = bridge->subordinate;
+	if (!bus)
+		return;
+
+	pci_lock_rescan_remove();
+
+	list_for_each_entry_safe(dev, tmp, &bus->devices, bus_list)
+		pci_stop_and_remove_bus_device(dev);
+
+	pci_unlock_rescan_remove();
+
+}
+
+/*
+ * rsrc_mgr.c -- Resource management routines and/or wrappers
+ *
+ * The initial developer of the original code is David A. Hinds
+ * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
+ * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+ *
+ * (C) 1999		David A. Hinds
+ */
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+
+#include <pcmcia/ss.h>
+#include <pcmcia/cistpl.h>
+#include "cs_internal.h"
+
+int static_init(struct pcmcia_socket *s)
+{
+	/* the good thing about SS_CAP_STATIC_MAP sockets is
+	 * that they don't need a resource database */
+
+	s->resource_setup_done = 1;
+
+	return 0;
+}
+
+struct resource *pcmcia_make_resource(resource_size_t start,
+					resource_size_t end,
+					unsigned long flags, const char *name)
+{
+	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
+
+	if (res) {
+		res->name = name;
+		res->start = start;
+		res->end = start + end - 1;
+		res->flags = flags;
+	}
+	return res;
+}
+
+static int static_find_io(struct pcmcia_socket *s, unsigned int attr,
+			unsigned int *base, unsigned int num,
+			unsigned int align, struct resource **parent)
+{
+	if (!s->io_offset)
+		return -EINVAL;
+	*base = s->io_offset | (*base & 0x0fff);
+	*parent = NULL;
+
+	return 0;
+}
+
+struct pccard_resource_ops pccard_static_ops = {
+	.validate_mem = NULL,
+	.find_io = static_find_io,
+	.find_mem = NULL,
+	.init = static_init,
+	.exit = NULL,
+};
+EXPORT_SYMBOL(pccard_static_ops);
+
+
+/*
+ * Regular cardbus driver ("yenta_socket")
+ *
+ * (C) Copyright 1999, 2000 Linus Torvalds
+ *
+ * Changelog:
+ * Aug 2002: Manfred Spraul <manfred@colorfullife.com>
+ * 	Dynamically adjust the size of the bridge resource
+ *
+ * May 2003: Dominik Brodowski <linux@brodo.de>
+ * 	Merge pci_socket.c and yenta.c into one file
+ */
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+
+#include <pcmcia/ss.h>
+
+#include "i82365.h"
+#include "cs_internal.h"
+
+static bool disable_clkrun;
+module_param(disable_clkrun, bool, 0444);
+MODULE_PARM_DESC(disable_clkrun,
+		 "If PC card doesn't function properly, please try this option (TI and Ricoh bridges only)");
+
+static bool isa_probe = 1;
+module_param(isa_probe, bool, 0444);
+MODULE_PARM_DESC(isa_probe, "If set ISA interrupts are probed (default). Set to N to disable probing");
+
+static bool pwr_irqs_off;
+module_param(pwr_irqs_off, bool, 0644);
+MODULE_PARM_DESC(pwr_irqs_off, "Force IRQs off during power-on of slot. Use only when seeing IRQ storms!");
+
+static char o2_speedup[] = "default";
+module_param_string(o2_speedup, o2_speedup, sizeof(o2_speedup), 0444);
+MODULE_PARM_DESC(o2_speedup, "Use prefetch/burst for O2-bridges: 'on', 'off' "
+	"or 'default' (uses recommended behaviour for the detected bridge)");
+
+/*
+ * Only probe "regular" interrupts, don't
+ * touch dangerous spots like the mouse irq,
+ * because there are mice that apparently
+ * get really confused if they get fondled
+ * too intimately.
+ *
+ * Default to 11, 10, 9, 7, 6, 5, 4, 3.
+ */
+static u32 isa_interrupts = 0x0ef8;
+
+
+#define debug(x, s, args...) dev_dbg(&s->dev->dev, x, ##args)
+
+/* Don't ask.. */
+#define to_cycles(ns)	((ns)/120)
+#define to_ns(cycles)	((cycles)*120)
+
+/*
+ * yenta PCI irq probing.
+ * currently only used in the TI/EnE initialization code
+ */
+#ifdef CONFIG_YENTA_TI
+static int yenta_probe_cb_irq(struct yenta_socket *socket);
+static unsigned int yenta_probe_irq(struct yenta_socket *socket,
+				u32 isa_irq_mask);
+#endif
+
+
+static unsigned int override_bios;
+module_param(override_bios, uint, 0000);
+MODULE_PARM_DESC(override_bios, "yenta ignore bios resource allocation");
+
+/*
+ * Generate easy-to-use ways of reading a cardbus sockets
+ * regular memory space ("cb_xxx"), configuration space
+ * ("config_xxx") and compatibility space ("exca_xxxx")
+ */
+static inline u32 cb_readl(struct yenta_socket *socket, unsigned reg)
+{
+	u32 val = readl(socket->base + reg);
+	debug("%04x %08x\n", socket, reg, val);
+	return val;
+}
+
+static inline void cb_writel(struct yenta_socket *socket, unsigned reg, u32 val)
+{
+	debug("%04x %08x\n", socket, reg, val);
+	writel(val, socket->base + reg);
+	readl(socket->base + reg); /* avoid problems with PCI write posting */
+}
+
+static inline u8 config_readb(struct yenta_socket *socket, unsigned offset)
+{
+	u8 val;
+	pci_read_config_byte(socket->dev, offset, &val);
+	debug("%04x %02x\n", socket, offset, val);
+	return val;
+}
+
+static inline u16 config_readw(struct yenta_socket *socket, unsigned offset)
+{
+	u16 val;
+	pci_read_config_word(socket->dev, offset, &val);
+	debug("%04x %04x\n", socket, offset, val);
+	return val;
+}
+
+static inline u32 config_readl(struct yenta_socket *socket, unsigned offset)
+{
+	u32 val;
+	pci_read_config_dword(socket->dev, offset, &val);
+	debug("%04x %08x\n", socket, offset, val);
+	return val;
+}
+
+static inline void config_writeb(struct yenta_socket *socket, unsigned offset, u8 val)
+{
+	debug("%04x %02x\n", socket, offset, val);
+	pci_write_config_byte(socket->dev, offset, val);
+}
+
+static inline void config_writew(struct yenta_socket *socket, unsigned offset, u16 val)
+{
+	debug("%04x %04x\n", socket, offset, val);
+	pci_write_config_word(socket->dev, offset, val);
+}
+
+static inline void config_writel(struct yenta_socket *socket, unsigned offset, u32 val)
+{
+	debug("%04x %08x\n", socket, offset, val);
+	pci_write_config_dword(socket->dev, offset, val);
+}
+
+static inline u8 exca_readb(struct yenta_socket *socket, unsigned reg)
+{
+	u8 val = readb(socket->base + 0x800 + reg);
+	debug("%04x %02x\n", socket, reg, val);
+	return val;
+}
+
+/*
+static inline u8 exca_readw(struct yenta_socket *socket, unsigned reg)
+{
+	u16 val;
+	val = readb(socket->base + 0x800 + reg);
+	val |= readb(socket->base + 0x800 + reg + 1) << 8;
+	debug("%04x %04x\n", socket, reg, val);
+	return val;
+}
+*/
+
+static inline void exca_writeb(struct yenta_socket *socket, unsigned reg, u8 val)
+{
+	debug("%04x %02x\n", socket, reg, val);
+	writeb(val, socket->base + 0x800 + reg);
+	readb(socket->base + 0x800 + reg); /* PCI write posting... */
+}
+
+static void exca_writew(struct yenta_socket *socket, unsigned reg, u16 val)
+{
+	debug("%04x %04x\n", socket, reg, val);
+	writeb(val, socket->base + 0x800 + reg);
+	writeb(val >> 8, socket->base + 0x800 + reg + 1);
+
+	/* PCI write posting... */
+	readb(socket->base + 0x800 + reg);
+	readb(socket->base + 0x800 + reg + 1);
+}
+
+static ssize_t show_yenta_registers(struct device *yentadev, struct device_attribute *attr, char *buf)
+{
+	struct yenta_socket *socket = dev_get_drvdata(yentadev);
+	int offset = 0, i;
+
+	offset = sysfs_emit(buf, "CB registers:");
+	for (i = 0; i < 0x24; i += 4) {
+		unsigned val;
+		if (!(i & 15))
+			offset += sysfs_emit_at(buf, offset, "\n%02x:", i);
+		val = cb_readl(socket, i);
+		offset += sysfs_emit_at(buf, offset, " %08x", val);
+	}
+
+	offset += sysfs_emit_at(buf, offset, "\n\nExCA registers:");
+	for (i = 0; i < 0x45; i++) {
+		unsigned char val;
+		if (!(i & 7)) {
+			if (i & 8) {
+				memcpy(buf + offset, " -", 2);
+				offset += 2;
+			} else
+				offset += sysfs_emit_at(buf, offset, "\n%02x:", i);
+		}
+		val = exca_readb(socket, i);
+		offset += sysfs_emit_at(buf, offset, " %02x", val);
+	}
+	sysfs_emit_at(buf, offset, "\n");
+	return offset;
+}
+
+static DEVICE_ATTR(yenta_registers, S_IRUSR, show_yenta_registers, NULL);
+
+/*
+ * Ugh, mixed-mode cardbus and 16-bit pccard state: things depend
+ * on what kind of card is inserted..
+ */
+static int yenta_get_status(struct pcmcia_socket *sock, unsigned int *value)
+{
+	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
+	unsigned int val;
+	u32 state = cb_readl(socket, CB_SOCKET_STATE);
+
+	val  = (state & CB_3VCARD) ? SS_3VCARD : 0;
+	val |= (state & CB_XVCARD) ? SS_XVCARD : 0;
+	val |= (state & (CB_5VCARD | CB_3VCARD | CB_XVCARD | CB_YVCARD)) ? 0 : SS_PENDING;
+	val |= (state & (CB_CDETECT1 | CB_CDETECT2)) ? SS_PENDING : 0;
+
+
+	if (state & CB_CBCARD) {
+		val |= SS_CARDBUS;
+		val |= (state & CB_CARDSTS) ? SS_STSCHG : 0;
+		val |= (state & (CB_CDETECT1 | CB_CDETECT2)) ? 0 : SS_DETECT;
+		val |= (state & CB_PWRCYCLE) ? SS_POWERON | SS_READY : 0;
+	} else if (state & CB_16BITCARD) {
+		dev_warn_once(&socket->dev->dev,
+			      "16-bit PCMCIA cards are no longer supported\n");
+	}
+
+	*value = val;
+	return 0;
+}
+
+static void yenta_set_power(struct yenta_socket *socket, socket_state_t *state)
+{
+	/* some birdges require to use the ExCA registers to power 16bit cards */
+	if (!(cb_readl(socket, CB_SOCKET_STATE) & CB_CBCARD) &&
+	    (socket->flags & YENTA_16BIT_POWER_EXCA)) {
+		u8 reg, old;
+		reg = old = exca_readb(socket, I365_POWER);
+		reg &= ~(I365_VCC_MASK | I365_VPP1_MASK | I365_VPP2_MASK);
+
+		/* i82365SL-DF style */
+		if (socket->flags & YENTA_16BIT_POWER_DF) {
+			switch (state->Vcc) {
+			case 33:
+				reg |= I365_VCC_3V;
+				break;
+			case 50:
+				reg |= I365_VCC_5V;
+				break;
+			default:
+				reg = 0;
+				break;
+			}
+			switch (state->Vpp) {
+			case 33:
+			case 50:
+				reg |= I365_VPP1_5V;
+				break;
+			case 120:
+				reg |= I365_VPP1_12V;
+				break;
+			}
+		} else {
+			/* i82365SL-B style */
+			switch (state->Vcc) {
+			case 50:
+				reg |= I365_VCC_5V;
+				break;
+			default:
+				reg = 0;
+				break;
+			}
+			switch (state->Vpp) {
+			case 50:
+				reg |= I365_VPP1_5V | I365_VPP2_5V;
+				break;
+			case 120:
+				reg |= I365_VPP1_12V | I365_VPP2_12V;
+				break;
+			}
+		}
+
+		if (reg != old)
+			exca_writeb(socket, I365_POWER, reg);
+	} else {
+		u32 reg = 0;	/* CB_SC_STPCLK? */
+		switch (state->Vcc) {
+		case 33:
+			reg = CB_SC_VCC_3V;
+			break;
+		case 50:
+			reg = CB_SC_VCC_5V;
+			break;
+		default:
+			reg = 0;
+			break;
+		}
+		switch (state->Vpp) {
+		case 33:
+			reg |= CB_SC_VPP_3V;
+			break;
+		case 50:
+			reg |= CB_SC_VPP_5V;
+			break;
+		case 120:
+			reg |= CB_SC_VPP_12V;
+			break;
+		}
+		if (reg != cb_readl(socket, CB_SOCKET_CONTROL))
+			cb_writel(socket, CB_SOCKET_CONTROL, reg);
+	}
+}
+
+static int yenta_set_socket(struct pcmcia_socket *sock, socket_state_t *state)
+{
+	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
+	u16 bridge;
+
+	/* if powering down: do it immediately */
+	if (state->Vcc == 0)
+		yenta_set_power(socket, state);
+
+	socket->io_irq = state->io_irq;
+	bridge = config_readw(socket, CB_BRIDGE_CONTROL) & ~(CB_BRIDGE_CRST | CB_BRIDGE_INTR);
+	if (cb_readl(socket, CB_SOCKET_STATE) & CB_CBCARD) {
+		u8 intr;
+		bridge |= (state->flags & SS_RESET) ? CB_BRIDGE_CRST : 0;
+
+		/* ISA interrupt control? */
+		intr = exca_readb(socket, I365_INTCTL);
+		intr = (intr & ~0xf);
+		if (!socket->dev->irq) {
+			intr |= socket->cb_irq ? socket->cb_irq : state->io_irq;
+			bridge |= CB_BRIDGE_INTR;
+		}
+		exca_writeb(socket, I365_INTCTL, intr);
+	}  else {
+		u8 reg;
+
+		reg = exca_readb(socket, I365_INTCTL) & (I365_RING_ENA | I365_INTR_ENA);
+		reg |= (state->flags & SS_RESET) ? 0 : I365_PC_RESET;
+		reg |= (state->flags & SS_IOCARD) ? I365_PC_IOCARD : 0;
+		if (state->io_irq != socket->dev->irq) {
+			reg |= state->io_irq;
+			bridge |= CB_BRIDGE_INTR;
+		}
+		exca_writeb(socket, I365_INTCTL, reg);
+
+		reg = exca_readb(socket, I365_POWER) & (I365_VCC_MASK|I365_VPP1_MASK);
+		reg |= I365_PWR_NORESET;
+		if (state->flags & SS_PWR_AUTO)
+			reg |= I365_PWR_AUTO;
+		if (state->flags & SS_OUTPUT_ENA)
+			reg |= I365_PWR_OUT;
+		if (exca_readb(socket, I365_POWER) != reg)
+			exca_writeb(socket, I365_POWER, reg);
+
+		/* CSC interrupt: no ISA irq for CSC */
+		reg = exca_readb(socket, I365_CSCINT);
+		reg &= I365_CSC_IRQ_MASK;
+		reg |= I365_CSC_DETECT;
+		if (state->flags & SS_IOCARD) {
+			if (state->csc_mask & SS_STSCHG)
+				reg |= I365_CSC_STSCHG;
+		} else {
+			if (state->csc_mask & SS_BATDEAD)
+				reg |= I365_CSC_BVD1;
+			if (state->csc_mask & SS_BATWARN)
+				reg |= I365_CSC_BVD2;
+			if (state->csc_mask & SS_READY)
+				reg |= I365_CSC_READY;
+		}
+		exca_writeb(socket, I365_CSCINT, reg);
+		exca_readb(socket, I365_CSC);
+		if (sock->zoom_video)
+			sock->zoom_video(sock, state->flags & SS_ZVCARD);
+	}
+	config_writew(socket, CB_BRIDGE_CONTROL, bridge);
+	/* Socket event mask: get card insert/remove events.. */
+	cb_writel(socket, CB_SOCKET_EVENT, -1);
+	cb_writel(socket, CB_SOCKET_MASK, CB_CDMASK);
+
+	/* if powering up: do it as the last step when the socket is configured */
+	if (state->Vcc != 0)
+		yenta_set_power(socket, state);
+	return 0;
+}
+
+static int yenta_set_io_map(struct pcmcia_socket *sock, struct pccard_io_map *io)
+{
+	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
+	int map;
+	unsigned char ioctl, addr, enable;
+
+	map = io->map;
+
+	if (map > 1)
+		return -EINVAL;
+
+	enable = I365_ENA_IO(map);
+	addr = exca_readb(socket, I365_ADDRWIN);
+
+	/* Disable the window before changing it.. */
+	if (addr & enable) {
+		addr &= ~enable;
+		exca_writeb(socket, I365_ADDRWIN, addr);
+	}
+
+	exca_writew(socket, I365_IO(map)+I365_W_START, io->start);
+	exca_writew(socket, I365_IO(map)+I365_W_STOP, io->stop);
+
+	ioctl = exca_readb(socket, I365_IOCTL) & ~I365_IOCTL_MASK(map);
+	if (io->flags & MAP_0WS)
+		ioctl |= I365_IOCTL_0WS(map);
+	if (io->flags & MAP_16BIT)
+		ioctl |= I365_IOCTL_16BIT(map);
+	if (io->flags & MAP_AUTOSZ)
+		ioctl |= I365_IOCTL_IOCS16(map);
+	exca_writeb(socket, I365_IOCTL, ioctl);
+
+	if (io->flags & MAP_ACTIVE)
+		exca_writeb(socket, I365_ADDRWIN, addr | enable);
+	return 0;
+}
+
+static int yenta_set_mem_map(struct pcmcia_socket *sock, struct pccard_mem_map *mem)
+{
+	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
+	struct pci_bus_region region;
+	int map;
+	unsigned char addr, enable;
+	unsigned int start, stop, card_start;
+	unsigned short word;
+
+	pcibios_resource_to_bus(socket->dev->bus, &region, mem->res);
+
+	map = mem->map;
+	start = region.start;
+	stop = region.end;
+	card_start = mem->card_start;
+
+	if (map > 4 || start > stop || ((start ^ stop) >> 24) ||
+	    (card_start >> 26) || mem->speed > 1000)
+		return -EINVAL;
+
+	enable = I365_ENA_MEM(map);
+	addr = exca_readb(socket, I365_ADDRWIN);
+	if (addr & enable) {
+		addr &= ~enable;
+		exca_writeb(socket, I365_ADDRWIN, addr);
+	}
+
+	exca_writeb(socket, CB_MEM_PAGE(map), start >> 24);
+
+	word = (start >> 12) & 0x0fff;
+	if (mem->flags & MAP_16BIT)
+		word |= I365_MEM_16BIT;
+	if (mem->flags & MAP_0WS)
+		word |= I365_MEM_0WS;
+	exca_writew(socket, I365_MEM(map) + I365_W_START, word);
+
+	word = (stop >> 12) & 0x0fff;
+	switch (to_cycles(mem->speed)) {
+	case 0:
+		break;
+	case 1:
+		word |= I365_MEM_WS0;
+		break;
+	case 2:
+		word |= I365_MEM_WS1;
+		break;
+	default:
+		word |= I365_MEM_WS1 | I365_MEM_WS0;
+		break;
+	}
+	exca_writew(socket, I365_MEM(map) + I365_W_STOP, word);
+
+	word = ((card_start - start) >> 12) & 0x3fff;
+	if (mem->flags & MAP_WRPROT)
+		word |= I365_MEM_WRPROT;
+	if (mem->flags & MAP_ATTRIB)
+		word |= I365_MEM_REG;
+	exca_writew(socket, I365_MEM(map) + I365_W_OFF, word);
+
+	if (mem->flags & MAP_ACTIVE)
+		exca_writeb(socket, I365_ADDRWIN, addr | enable);
+	return 0;
+}
+
+
+
+static irqreturn_t yenta_interrupt(int irq, void *dev_id)
+{
+	unsigned int events;
+	struct yenta_socket *socket = (struct yenta_socket *) dev_id;
+	u8 csc;
+	u32 cb_event;
+
+	/* Clear interrupt status for the event */
+	cb_event = cb_readl(socket, CB_SOCKET_EVENT);
+	cb_writel(socket, CB_SOCKET_EVENT, cb_event);
+
+	csc = exca_readb(socket, I365_CSC);
+
+	if (!(cb_event || csc))
+		return IRQ_NONE;
+
+	events = (cb_event & (CB_CD1EVENT | CB_CD2EVENT)) ? SS_DETECT : 0 ;
+	events |= (csc & I365_CSC_DETECT) ? SS_DETECT : 0;
+	if (exca_readb(socket, I365_INTCTL) & I365_PC_IOCARD) {
+		events |= (csc & I365_CSC_STSCHG) ? SS_STSCHG : 0;
+	} else {
+		events |= (csc & I365_CSC_BVD1) ? SS_BATDEAD : 0;
+		events |= (csc & I365_CSC_BVD2) ? SS_BATWARN : 0;
+		events |= (csc & I365_CSC_READY) ? SS_READY : 0;
+	}
+
+	if (events)
+		pcmcia_parse_events(&socket->socket, events);
+
+	return IRQ_HANDLED;
+}
+
+static void yenta_interrupt_wrapper(struct timer_list *t)
+{
+	struct yenta_socket *socket = from_timer(socket, t, poll_timer);
+
+	yenta_interrupt(0, (void *)socket);
+	socket->poll_timer.expires = jiffies + HZ;
+	add_timer(&socket->poll_timer);
+}
+
+static void yenta_clear_maps(struct yenta_socket *socket)
+{
+	int i;
+	struct resource res = { .start = 0, .end = 0x0fff };
+	pccard_io_map io = { 0, 0, 0, 0, 1 };
+	pccard_mem_map mem = { .res = &res, };
+
+	yenta_set_socket(&socket->socket, &dead_socket);
+	for (i = 0; i < 2; i++) {
+		io.map = i;
+		yenta_set_io_map(&socket->socket, &io);
+	}
+	for (i = 0; i < 5; i++) {
+		mem.map = i;
+		yenta_set_mem_map(&socket->socket, &mem);
+	}
+}
+
+/* redoes voltage interrogation if required */
+static void yenta_interrogate(struct yenta_socket *socket)
+{
+	u32 state;
+
+	state = cb_readl(socket, CB_SOCKET_STATE);
+	if (!(state & (CB_5VCARD | CB_3VCARD | CB_XVCARD | CB_YVCARD)) ||
+	    (state & (CB_CDETECT1 | CB_CDETECT2 | CB_NOTACARD | CB_BADVCCREQ)) ||
+	    ((state & (CB_16BITCARD | CB_CBCARD)) == (CB_16BITCARD | CB_CBCARD)))
+		cb_writel(socket, CB_SOCKET_FORCE, CB_CVSTEST);
+}
+
+/* Called at resume and initialization events */
+static int yenta_sock_init(struct pcmcia_socket *sock)
+{
+	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
+
+	exca_writeb(socket, I365_GBLCTL, 0x00);
+	exca_writeb(socket, I365_GENCTL, 0x00);
+
+	/* Redo card voltage interrogation */
+	yenta_interrogate(socket);
+
+	yenta_clear_maps(socket);
+
+	if (socket->type && socket->type->sock_init)
+		socket->type->sock_init(socket);
+
+	/* Re-enable CSC interrupts */
+	cb_writel(socket, CB_SOCKET_MASK, CB_CDMASK);
+
+	return 0;
+}
+
+static int yenta_sock_suspend(struct pcmcia_socket *sock)
+{
+	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
+
+	/* Disable CSC interrupts */
+	cb_writel(socket, CB_SOCKET_MASK, 0x0);
+
+	return 0;
+}
+
+/*
+ * Use an adaptive allocation for the memory resource,
+ * sometimes the memory behind pci bridges is limited:
+ * 1/8 of the size of the io window of the parent.
+ * max 4 MB, min 16 kB. We try very hard to not get below
+ * the "ACC" values, though.
+ */
+#define BRIDGE_MEM_MAX (4*1024*1024)
+#define BRIDGE_MEM_ACC (128*1024)
+#define BRIDGE_MEM_MIN (16*1024)
+
+#define BRIDGE_IO_MAX 512
+#define BRIDGE_IO_ACC 256
+#define BRIDGE_IO_MIN 32
+
+#ifndef PCIBIOS_MIN_CARDBUS_IO
+#define PCIBIOS_MIN_CARDBUS_IO PCIBIOS_MIN_IO
+#endif
+
+static int yenta_search_one_res(struct resource *root, struct resource *res,
+				u32 min)
+{
+	u32 align, size, start, end;
+
+	if (res->flags & IORESOURCE_IO) {
+		align = 1024;
+		size = BRIDGE_IO_MAX;
+		start = PCIBIOS_MIN_CARDBUS_IO;
+		end = ~0U;
+	} else {
+		unsigned long avail = root->end - root->start;
+		int i;
+		size = BRIDGE_MEM_MAX;
+		if (size > avail/8) {
+			size = (avail+1)/8;
+			/* round size down to next power of 2 */
+			i = 0;
+			while ((size /= 2) != 0)
+				i++;
+			size = 1 << i;
+		}
+		if (size < min)
+			size = min;
+		align = size;
+		start = PCIBIOS_MIN_MEM;
+		end = ~0U;
+	}
+
+	do {
+		if (allocate_resource(root, res, size, start, end, align,
+				      NULL, NULL) == 0) {
+			return 1;
+		}
+		size = size/2;
+		align = size;
+	} while (size >= min);
+
+	return 0;
+}
+
+
+static int yenta_search_res(struct yenta_socket *socket, struct resource *res,
+			    u32 min)
+{
+	struct resource *root;
+	int i;
+
+	pci_bus_for_each_resource(socket->dev->bus, root, i) {
+		if (!root)
+			continue;
+
+		if ((res->flags ^ root->flags) &
+		    (IORESOURCE_IO | IORESOURCE_MEM | IORESOURCE_PREFETCH))
+			continue; /* Wrong type */
+
+		if (yenta_search_one_res(root, res, min))
+			return 1;
+	}
+	return 0;
+}
+
+static int yenta_allocate_res(struct yenta_socket *socket, int nr, unsigned type, int addr_start, int addr_end)
+{
+	struct pci_dev *dev = socket->dev;
+	struct resource *res;
+	struct pci_bus_region region;
+	unsigned mask;
+
+	res = &dev->resource[nr];
+	/* Already allocated? */
+	if (res->parent)
+		return 0;
+
+	/* The granularity of the memory limit is 4kB, on IO it's 4 bytes */
+	mask = ~0xfff;
+	if (type & IORESOURCE_IO)
+		mask = ~3;
+
+	res->name = dev->subordinate->name;
+	res->flags = type;
+
+	region.start = config_readl(socket, addr_start) & mask;
+	region.end = config_readl(socket, addr_end) | ~mask;
+	if (region.start && region.end > region.start && !override_bios) {
+		pcibios_bus_to_resource(dev->bus, res, &region);
+		if (pci_claim_resource(dev, nr) == 0)
+			return 0;
+		dev_info(&dev->dev,
+			 "Preassigned resource %d busy or not available, reconfiguring...\n",
+			 nr);
+	}
+
+	if (type & IORESOURCE_IO) {
+		if ((yenta_search_res(socket, res, BRIDGE_IO_MAX)) ||
+		    (yenta_search_res(socket, res, BRIDGE_IO_ACC)) ||
+		    (yenta_search_res(socket, res, BRIDGE_IO_MIN)))
+			return 1;
+	} else {
+		if (type & IORESOURCE_PREFETCH) {
+			if ((yenta_search_res(socket, res, BRIDGE_MEM_MAX)) ||
+			    (yenta_search_res(socket, res, BRIDGE_MEM_ACC)) ||
+			    (yenta_search_res(socket, res, BRIDGE_MEM_MIN)))
+				return 1;
+			/* Approximating prefetchable by non-prefetchable */
+			res->flags = IORESOURCE_MEM;
+		}
+		if ((yenta_search_res(socket, res, BRIDGE_MEM_MAX)) ||
+		    (yenta_search_res(socket, res, BRIDGE_MEM_ACC)) ||
+		    (yenta_search_res(socket, res, BRIDGE_MEM_MIN)))
+			return 1;
+	}
+
+	dev_info(&dev->dev,
+		 "no resource of type %x available, trying to continue...\n",
+		 type);
+	res->start = res->end = res->flags = 0;
+	return 0;
+}
+
+static void yenta_free_res(struct yenta_socket *socket, int nr)
+{
+	struct pci_dev *dev = socket->dev;
+	struct resource *res;
+
+	res = &dev->resource[nr];
+	if (res->start != 0 && res->end != 0)
+		release_resource(res);
+
+	res->start = res->end = res->flags = 0;
+}
+
+/*
+ * Allocate the bridge mappings for the device..
+ */
+static void yenta_allocate_resources(struct yenta_socket *socket)
+{
+	int program = 0;
+	program += yenta_allocate_res(socket, PCI_CB_BRIDGE_IO_0_WINDOW,
+			   IORESOURCE_IO,
+			   PCI_CB_IO_BASE_0, PCI_CB_IO_LIMIT_0);
+	program += yenta_allocate_res(socket, PCI_CB_BRIDGE_IO_1_WINDOW,
+			   IORESOURCE_IO,
+			   PCI_CB_IO_BASE_1, PCI_CB_IO_LIMIT_1);
+	program += yenta_allocate_res(socket, PCI_CB_BRIDGE_MEM_0_WINDOW,
+			   IORESOURCE_MEM | IORESOURCE_PREFETCH,
+			   PCI_CB_MEMORY_BASE_0, PCI_CB_MEMORY_LIMIT_0);
+	program += yenta_allocate_res(socket, PCI_CB_BRIDGE_MEM_1_WINDOW,
+			   IORESOURCE_MEM,
+			   PCI_CB_MEMORY_BASE_1, PCI_CB_MEMORY_LIMIT_1);
+	if (program)
+		pci_setup_cardbus(socket->dev->subordinate);
+}
+
+
+/*
+ * Free the bridge mappings for the device..
+ */
+static void yenta_free_resources(struct yenta_socket *socket)
+{
+	yenta_free_res(socket, PCI_CB_BRIDGE_IO_0_WINDOW);
+	yenta_free_res(socket, PCI_CB_BRIDGE_IO_1_WINDOW);
+	yenta_free_res(socket, PCI_CB_BRIDGE_MEM_0_WINDOW);
+	yenta_free_res(socket, PCI_CB_BRIDGE_MEM_1_WINDOW);
+}
+
+
+/*
+ * Close it down - release our resources and go home..
+ */
+static void yenta_close(struct pci_dev *dev)
+{
+	struct yenta_socket *sock = pci_get_drvdata(dev);
+
+	/* Remove the register attributes */
+	device_remove_file(&dev->dev, &dev_attr_yenta_registers);
+
+	/* we don't want a dying socket registered */
+	pcmcia_unregister_socket(&sock->socket);
+
+	/* Disable all events so we don't die in an IRQ storm */
+	cb_writel(sock, CB_SOCKET_MASK, 0x0);
+	exca_writeb(sock, I365_CSCINT, 0);
+
+	if (sock->cb_irq)
+		free_irq(sock->cb_irq, sock);
+	else
+		timer_shutdown_sync(&sock->poll_timer);
+
+	iounmap(sock->base);
+	yenta_free_resources(sock);
+
+	pci_release_regions(dev);
+	pci_disable_device(dev);
+	pci_set_drvdata(dev, NULL);
+	kfree(sock);
+}
+
+
+static struct pccard_operations yenta_socket_operations = {
+	.init			= yenta_sock_init,
+	.suspend		= yenta_sock_suspend,
+	.get_status		= yenta_get_status,
+	.set_socket		= yenta_set_socket,
+	.set_io_map		= yenta_set_io_map,
+	.set_mem_map		= yenta_set_mem_map,
+};
+
+#ifdef CONFIG_YENTA_TI
+/*
+ * ti113x.h 1.16 1999/10/25 20:03:34
+ */
+/* Register definitions for TI 113X PCI-to-CardBus bridges */
+
+/* System Control Register */
+#define TI113X_SYSTEM_CONTROL		0x0080	/* 32 bit */
+#define  TI113X_SCR_SMIROUTE		0x04000000
+#define  TI113X_SCR_SMISTATUS		0x02000000
+#define  TI113X_SCR_SMIENB		0x01000000
+#define  TI113X_SCR_VCCPROT		0x00200000
+#define  TI113X_SCR_REDUCEZV		0x00100000
+#define  TI113X_SCR_CDREQEN		0x00080000
+#define  TI113X_SCR_CDMACHAN		0x00070000
+#define  TI113X_SCR_SOCACTIVE		0x00002000
+#define  TI113X_SCR_PWRSTREAM		0x00000800
+#define  TI113X_SCR_DELAYUP		0x00000400
+#define  TI113X_SCR_DELAYDOWN		0x00000200
+#define  TI113X_SCR_INTERROGATE		0x00000100
+#define  TI113X_SCR_CLKRUN_SEL		0x00000080
+#define  TI113X_SCR_PWRSAVINGS		0x00000040
+#define  TI113X_SCR_SUBSYSRW		0x00000020
+#define  TI113X_SCR_CB_DPAR		0x00000010
+#define  TI113X_SCR_CDMA_EN		0x00000008
+#define  TI113X_SCR_ASYNC_IRQ		0x00000004
+#define  TI113X_SCR_KEEPCLK		0x00000002
+#define  TI113X_SCR_CLKRUN_ENA		0x00000001  
+
+#define  TI122X_SCR_SER_STEP		0xc0000000
+#define  TI122X_SCR_INTRTIE		0x20000000
+#define  TIXX21_SCR_TIEALL		0x10000000
+#define  TI122X_SCR_CBRSVD		0x00400000
+#define  TI122X_SCR_MRBURSTDN		0x00008000
+#define  TI122X_SCR_MRBURSTUP		0x00004000
+#define  TI122X_SCR_RIMUX		0x00000001
+
+/* Multimedia Control Register */
+#define TI1250_MULTIMEDIA_CTL		0x0084	/* 8 bit */
+#define  TI1250_MMC_ZVOUTEN		0x80
+#define  TI1250_MMC_PORTSEL		0x40
+#define  TI1250_MMC_ZVEN1		0x02
+#define  TI1250_MMC_ZVEN0		0x01
+
+#define TI1250_GENERAL_STATUS		0x0085	/* 8 bit */
+#define TI1250_GPIO0_CONTROL		0x0088	/* 8 bit */
+#define TI1250_GPIO1_CONTROL		0x0089	/* 8 bit */
+#define TI1250_GPIO2_CONTROL		0x008a	/* 8 bit */
+#define TI1250_GPIO3_CONTROL		0x008b	/* 8 bit */
+#define TI1250_GPIO_MODE_MASK		0xc0
+
+/* IRQMUX/MFUNC Register */
+#define TI122X_MFUNC			0x008c	/* 32 bit */
+#define TI122X_MFUNC0_MASK		0x0000000f
+#define TI122X_MFUNC1_MASK		0x000000f0
+#define TI122X_MFUNC2_MASK		0x00000f00
+#define TI122X_MFUNC3_MASK		0x0000f000
+#define TI122X_MFUNC4_MASK		0x000f0000
+#define TI122X_MFUNC5_MASK		0x00f00000
+#define TI122X_MFUNC6_MASK		0x0f000000
+
+#define TI122X_MFUNC0_INTA		0x00000002
+#define TI125X_MFUNC0_INTB		0x00000001
+#define TI122X_MFUNC1_INTB		0x00000020
+#define TI122X_MFUNC3_IRQSER		0x00001000
+
+
+/* Retry Status Register */
+#define TI113X_RETRY_STATUS		0x0090	/* 8 bit */
+#define  TI113X_RSR_PCIRETRY		0x80
+#define  TI113X_RSR_CBRETRY		0x40
+#define  TI113X_RSR_TEXP_CBB		0x20
+#define  TI113X_RSR_MEXP_CBB		0x10
+#define  TI113X_RSR_TEXP_CBA		0x08
+#define  TI113X_RSR_MEXP_CBA		0x04
+#define  TI113X_RSR_TEXP_PCI		0x02
+#define  TI113X_RSR_MEXP_PCI		0x01
+
+/* Card Control Register */
+#define TI113X_CARD_CONTROL		0x0091	/* 8 bit */
+#define  TI113X_CCR_RIENB		0x80
+#define  TI113X_CCR_ZVENABLE		0x40
+#define  TI113X_CCR_PCI_IRQ_ENA		0x20
+#define  TI113X_CCR_PCI_IREQ		0x10
+#define  TI113X_CCR_PCI_CSC		0x08
+#define  TI113X_CCR_SPKROUTEN		0x02
+#define  TI113X_CCR_IFG			0x01
+
+#define  TI1220_CCR_PORT_SEL		0x20
+#define  TI122X_CCR_AUD2MUX		0x04
+
+/* Device Control Register */
+#define TI113X_DEVICE_CONTROL		0x0092	/* 8 bit */
+#define  TI113X_DCR_5V_FORCE		0x40
+#define  TI113X_DCR_3V_FORCE		0x20
+#define  TI113X_DCR_IMODE_MASK		0x06
+#define  TI113X_DCR_IMODE_ISA		0x02
+#define  TI113X_DCR_IMODE_SERIAL	0x04
+
+#define  TI12XX_DCR_IMODE_PCI_ONLY	0x00
+#define  TI12XX_DCR_IMODE_ALL_SERIAL	0x06
+
+/* Buffer Control Register */
+#define TI113X_BUFFER_CONTROL		0x0093	/* 8 bit */
+#define  TI113X_BCR_CB_READ_DEPTH	0x08
+#define  TI113X_BCR_CB_WRITE_DEPTH	0x04
+#define  TI113X_BCR_PCI_READ_DEPTH	0x02
+#define  TI113X_BCR_PCI_WRITE_DEPTH	0x01
+
+/* Diagnostic Register */
+#define TI1250_DIAGNOSTIC		0x0093	/* 8 bit */
+#define  TI1250_DIAG_TRUE_VALUE		0x80
+#define  TI1250_DIAG_PCI_IREQ		0x40
+#define  TI1250_DIAG_PCI_CSC		0x20
+#define  TI1250_DIAG_ASYNC_CSC		0x01
+
+/* DMA Registers */
+#define TI113X_DMA_0			0x0094	/* 32 bit */
+#define TI113X_DMA_1			0x0098	/* 32 bit */
+
+/* ExCA IO offset registers */
+#define TI113X_IO_OFFSET(map)		(0x36+((map)<<1))
+
+/* EnE test register */
+#define ENE_TEST_C9			0xc9	/* 8bit */
+#define ENE_TEST_C9_TLTENABLE		0x02
+#define ENE_TEST_C9_PFENABLE_F0		0x04
+#define ENE_TEST_C9_PFENABLE_F1		0x08
+#define ENE_TEST_C9_PFENABLE		(ENE_TEST_C9_PFENABLE_F0 | ENE_TEST_C9_PFENABLE_F1)
+#define ENE_TEST_C9_WPDISALBLE_F0	0x40
+#define ENE_TEST_C9_WPDISALBLE_F1	0x80
+#define ENE_TEST_C9_WPDISALBLE		(ENE_TEST_C9_WPDISALBLE_F0 | ENE_TEST_C9_WPDISALBLE_F1)
+
+/*
+ * Texas Instruments CardBus controller overrides.
+ */
+#define ti_sysctl(socket)	((socket)->private[0])
+#define ti_cardctl(socket)	((socket)->private[1])
+#define ti_devctl(socket)	((socket)->private[2])
+#define ti_diag(socket)		((socket)->private[3])
+#define ti_mfunc(socket)	((socket)->private[4])
+#define ene_test_c9(socket)	((socket)->private[5])
+
+/*
+ * These are the TI specific power management handlers.
+ */
+static void ti_save_state(struct yenta_socket *socket)
+{
+	ti_sysctl(socket) = config_readl(socket, TI113X_SYSTEM_CONTROL);
+	ti_mfunc(socket) = config_readl(socket, TI122X_MFUNC);
+	ti_cardctl(socket) = config_readb(socket, TI113X_CARD_CONTROL);
+	ti_devctl(socket) = config_readb(socket, TI113X_DEVICE_CONTROL);
+	ti_diag(socket) = config_readb(socket, TI1250_DIAGNOSTIC);
+
+	if (socket->dev->vendor == PCI_VENDOR_ID_ENE)
+		ene_test_c9(socket) = config_readb(socket, ENE_TEST_C9);
+}
+
+static void ti_restore_state(struct yenta_socket *socket)
+{
+	config_writel(socket, TI113X_SYSTEM_CONTROL, ti_sysctl(socket));
+	config_writel(socket, TI122X_MFUNC, ti_mfunc(socket));
+	config_writeb(socket, TI113X_CARD_CONTROL, ti_cardctl(socket));
+	config_writeb(socket, TI113X_DEVICE_CONTROL, ti_devctl(socket));
+	config_writeb(socket, TI1250_DIAGNOSTIC, ti_diag(socket));
+
+	if (socket->dev->vendor == PCI_VENDOR_ID_ENE)
+		config_writeb(socket, ENE_TEST_C9, ene_test_c9(socket));
+}
+
+/*
+ *	Zoom video control for TI122x/113x chips
+ */
+
+static void ti_zoom_video(struct pcmcia_socket *sock, int onoff)
+{
+	u8 reg;
+	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
+
+	/* If we don't have a Zoom Video switch this is harmless,
+	   we just tristate the unused (ZV) lines */
+	reg = config_readb(socket, TI113X_CARD_CONTROL);
+	if (onoff)
+		/* Zoom zoom, we will all go together, zoom zoom, zoom zoom */
+		reg |= TI113X_CCR_ZVENABLE;
+	else
+		reg &= ~TI113X_CCR_ZVENABLE;
+	config_writeb(socket, TI113X_CARD_CONTROL, reg);
+}
+
+/*
+ *	The 145x series can also use this. They have an additional
+ *	ZV autodetect mode we don't use but don't actually need.
+ *	FIXME: manual says its in func0 and func1 but disagrees with
+ *	itself about this - do we need to force func0, if so we need
+ *	to know a lot more about socket pairings in pcmcia_socket than
+ *	we do now.. uggh.
+ */
+ 
+static void ti1250_zoom_video(struct pcmcia_socket *sock, int onoff)
+{	
+	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
+	int shift = 0;
+	u8 reg;
+
+	ti_zoom_video(sock, onoff);
+
+	reg = config_readb(socket, TI1250_MULTIMEDIA_CTL);
+	reg |= TI1250_MMC_ZVOUTEN;	/* ZV bus enable */
+
+	if(PCI_FUNC(socket->dev->devfn)==1)
+		shift = 1;
+	
+	if(onoff)
+	{
+		reg &= ~(1<<6); 	/* Clear select bit */
+		reg |= shift<<6;	/* Favour our socket */
+		reg |= 1<<shift;	/* Socket zoom video on */
+	}
+	else
+	{
+		reg &= ~(1<<6); 	/* Clear select bit */
+		reg |= (1^shift)<<6;	/* Favour other socket */
+		reg &= ~(1<<shift);	/* Socket zoon video off */
+	}
+
+	config_writeb(socket, TI1250_MULTIMEDIA_CTL, reg);
+}
+
+static void ti_set_zv(struct yenta_socket *socket)
+{
+	if(socket->dev->vendor == PCI_VENDOR_ID_TI)
+	{
+		switch(socket->dev->device)
+		{
+			/* There may be more .. */
+			case PCI_DEVICE_ID_TI_1220:
+			case PCI_DEVICE_ID_TI_1221:
+			case PCI_DEVICE_ID_TI_1225:
+			case PCI_DEVICE_ID_TI_4510:
+				socket->socket.zoom_video = ti_zoom_video;
+				break;	
+			case PCI_DEVICE_ID_TI_1250:
+			case PCI_DEVICE_ID_TI_1251A:
+			case PCI_DEVICE_ID_TI_1251B:
+			case PCI_DEVICE_ID_TI_1450:
+				socket->socket.zoom_video = ti1250_zoom_video;
+		}
+	}
+}
+
+
+/*
+ * Generic TI init - TI has an extension for the
+ * INTCTL register that sets the PCI CSC interrupt.
+ * Make sure we set it correctly at open and init
+ * time
+ * - override: disable the PCI CSC interrupt. This makes
+ *   it possible to use the CSC interrupt to probe the
+ *   ISA interrupts.
+ * - init: set the interrupt to match our PCI state.
+ *   This makes us correctly get PCI CSC interrupt
+ *   events.
+ */
+static int ti_init(struct yenta_socket *socket)
+{
+	u8 new, reg = exca_readb(socket, I365_INTCTL);
+
+	new = reg & ~I365_INTR_ENA;
+	if (socket->dev->irq)
+		new |= I365_INTR_ENA;
+	if (new != reg)
+		exca_writeb(socket, I365_INTCTL, new);
 	return 0;
 }
 
-static int yenta_set_io_map(struct pcmcia_socket *sock, struct pccard_io_map *io)
+static int ti_override(struct yenta_socket *socket)
 {
-	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
-	int map;
-	unsigned char ioctl, addr, enable;
+	u8 new, reg = exca_readb(socket, I365_INTCTL);
 
-	map = io->map;
+	new = reg & ~I365_INTR_ENA;
+	if (new != reg)
+		exca_writeb(socket, I365_INTCTL, new);
 
-	if (map > 1)
-		return -EINVAL;
+	ti_set_zv(socket);
 
-	enable = I365_ENA_IO(map);
-	addr = exca_readb(socket, I365_ADDRWIN);
+	return 0;
+}
 
-	/* Disable the window before changing it.. */
-	if (addr & enable) {
-		addr &= ~enable;
-		exca_writeb(socket, I365_ADDRWIN, addr);
-	}
+static void ti113x_use_isa_irq(struct yenta_socket *socket)
+{
+	int isa_irq = -1;
+	u8 intctl;
+	u32 isa_irq_mask = 0;
 
-	exca_writew(socket, I365_IO(map)+I365_W_START, io->start);
-	exca_writew(socket, I365_IO(map)+I365_W_STOP, io->stop);
+	if (!isa_probe)
+		return;
 
-	ioctl = exca_readb(socket, I365_IOCTL) & ~I365_IOCTL_MASK(map);
-	if (io->flags & MAP_0WS)
-		ioctl |= I365_IOCTL_0WS(map);
-	if (io->flags & MAP_16BIT)
-		ioctl |= I365_IOCTL_16BIT(map);
-	if (io->flags & MAP_AUTOSZ)
-		ioctl |= I365_IOCTL_IOCS16(map);
-	exca_writeb(socket, I365_IOCTL, ioctl);
+	/* get a free isa int */
+	isa_irq_mask = yenta_probe_irq(socket, isa_interrupts);
+	if (!isa_irq_mask)
+		return; /* no useable isa irq found */
 
-	if (io->flags & MAP_ACTIVE)
-		exca_writeb(socket, I365_ADDRWIN, addr | enable);
-	return 0;
+	/* choose highest available */
+	for (; isa_irq_mask; isa_irq++)
+		isa_irq_mask >>= 1;
+	socket->cb_irq = isa_irq;
+
+	exca_writeb(socket, I365_CSCINT, (isa_irq << 4));
+
+	intctl = exca_readb(socket, I365_INTCTL);
+	intctl &= ~(I365_INTR_ENA | I365_IRQ_MASK);     /* CSC Enable */
+	exca_writeb(socket, I365_INTCTL, intctl);
+
+	dev_info(&socket->dev->dev,
+		"Yenta TI113x: using isa irq %d for CardBus\n", isa_irq);
 }
 
-static int yenta_set_mem_map(struct pcmcia_socket *sock, struct pccard_mem_map *mem)
-{
-	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
-	struct pci_bus_region region;
-	int map;
-	unsigned char addr, enable;
-	unsigned int start, stop, card_start;
-	unsigned short word;
 
-	pcibios_resource_to_bus(socket->dev->bus, &region, mem->res);
+static int ti113x_override(struct yenta_socket *socket)
+{
+	u8 cardctl;
 
-	map = mem->map;
-	start = region.start;
-	stop = region.end;
-	card_start = mem->card_start;
+	cardctl = config_readb(socket, TI113X_CARD_CONTROL);
+	cardctl &= ~(TI113X_CCR_PCI_IRQ_ENA | TI113X_CCR_PCI_IREQ | TI113X_CCR_PCI_CSC);
+	if (socket->dev->irq)
+		cardctl |= TI113X_CCR_PCI_IRQ_ENA | TI113X_CCR_PCI_CSC | TI113X_CCR_PCI_IREQ;
+	else
+		ti113x_use_isa_irq(socket);
 
-	if (map > 4 || start > stop || ((start ^ stop) >> 24) ||
-	    (card_start >> 26) || mem->speed > 1000)
-		return -EINVAL;
+	config_writeb(socket, TI113X_CARD_CONTROL, cardctl);
 
-	enable = I365_ENA_MEM(map);
-	addr = exca_readb(socket, I365_ADDRWIN);
-	if (addr & enable) {
-		addr &= ~enable;
-		exca_writeb(socket, I365_ADDRWIN, addr);
-	}
+	return ti_override(socket);
+}
 
-	exca_writeb(socket, CB_MEM_PAGE(map), start >> 24);
 
-	word = (start >> 12) & 0x0fff;
-	if (mem->flags & MAP_16BIT)
-		word |= I365_MEM_16BIT;
-	if (mem->flags & MAP_0WS)
-		word |= I365_MEM_0WS;
-	exca_writew(socket, I365_MEM(map) + I365_W_START, word);
+/* irqrouting for func0, probes PCI interrupt and ISA interrupts */
+static void ti12xx_irqroute_func0(struct yenta_socket *socket)
+{
+	u32 mfunc, mfunc_old, devctl;
+	u8 gpio3, gpio3_old;
+	int pci_irq_status;
 
-	word = (stop >> 12) & 0x0fff;
-	switch (to_cycles(mem->speed)) {
-	case 0:
-		break;
-	case 1:
-		word |= I365_MEM_WS0;
-		break;
-	case 2:
-		word |= I365_MEM_WS1;
-		break;
-	default:
-		word |= I365_MEM_WS1 | I365_MEM_WS0;
-		break;
-	}
-	exca_writew(socket, I365_MEM(map) + I365_W_STOP, word);
+	mfunc = mfunc_old = config_readl(socket, TI122X_MFUNC);
+	devctl = config_readb(socket, TI113X_DEVICE_CONTROL);
+	dev_info(&socket->dev->dev, "TI: mfunc 0x%08x, devctl 0x%02x\n",
+		 mfunc, devctl);
 
-	word = ((card_start - start) >> 12) & 0x3fff;
-	if (mem->flags & MAP_WRPROT)
-		word |= I365_MEM_WRPROT;
-	if (mem->flags & MAP_ATTRIB)
-		word |= I365_MEM_REG;
-	exca_writew(socket, I365_MEM(map) + I365_W_OFF, word);
+	/* make sure PCI interrupts are enabled before probing */
+	ti_init(socket);
 
-	if (mem->flags & MAP_ACTIVE)
-		exca_writeb(socket, I365_ADDRWIN, addr | enable);
-	return 0;
-}
+	/* test PCI interrupts first. only try fixing if return value is 0! */
+	pci_irq_status = yenta_probe_cb_irq(socket);
+	if (pci_irq_status)
+		goto out;
 
+	/*
+	 * We're here which means PCI interrupts are _not_ delivered. try to
+	 * find the right setting (all serial or parallel)
+	 */
+	dev_info(&socket->dev->dev,
+		 "TI: probing PCI interrupt failed, trying to fix\n");
+
+	/* for serial PCI make sure MFUNC3 is set to IRQSER */
+	if ((devctl & TI113X_DCR_IMODE_MASK) == TI12XX_DCR_IMODE_ALL_SERIAL) {
+		switch (socket->dev->device) {
+		case PCI_DEVICE_ID_TI_1250:
+		case PCI_DEVICE_ID_TI_1251A:
+		case PCI_DEVICE_ID_TI_1251B:
+		case PCI_DEVICE_ID_TI_1450:
+		case PCI_DEVICE_ID_TI_1451A:
+		case PCI_DEVICE_ID_TI_4450:
+		case PCI_DEVICE_ID_TI_4451:
+			/* these chips have no IRQSER setting in MFUNC3  */
+			break;
 
+		default:
+			mfunc = (mfunc & ~TI122X_MFUNC3_MASK) | TI122X_MFUNC3_IRQSER;
+
+			/* write down if changed, probe */
+			if (mfunc != mfunc_old) {
+				config_writel(socket, TI122X_MFUNC, mfunc);
+
+				pci_irq_status = yenta_probe_cb_irq(socket);
+				if (pci_irq_status == 1) {
+					dev_info(&socket->dev->dev,
+						 "TI: all-serial interrupts ok\n");
+					mfunc_old = mfunc;
+					goto out;
+				}
+
+				/* not working, back to old value */
+				mfunc = mfunc_old;
+				config_writel(socket, TI122X_MFUNC, mfunc);
+
+				if (pci_irq_status == -1)
+					goto out;
+			}
+		}
 
-static irqreturn_t yenta_interrupt(int irq, void *dev_id)
-{
-	unsigned int events;
-	struct yenta_socket *socket = (struct yenta_socket *) dev_id;
-	u8 csc;
-	u32 cb_event;
+		/* serial PCI interrupts not working fall back to parallel */
+		dev_info(&socket->dev->dev,
+			 "TI: falling back to parallel PCI interrupts\n");
+		devctl &= ~TI113X_DCR_IMODE_MASK;
+		devctl |= TI113X_DCR_IMODE_SERIAL; /* serial ISA could be right */
+		config_writeb(socket, TI113X_DEVICE_CONTROL, devctl);
+	}
 
-	/* Clear interrupt status for the event */
-	cb_event = cb_readl(socket, CB_SOCKET_EVENT);
-	cb_writel(socket, CB_SOCKET_EVENT, cb_event);
+	/* parallel PCI interrupts: route INTA */
+	switch (socket->dev->device) {
+	case PCI_DEVICE_ID_TI_1250:
+	case PCI_DEVICE_ID_TI_1251A:
+	case PCI_DEVICE_ID_TI_1251B:
+	case PCI_DEVICE_ID_TI_1450:
+		/* make sure GPIO3 is set to INTA */
+		gpio3 = gpio3_old = config_readb(socket, TI1250_GPIO3_CONTROL);
+		gpio3 &= ~TI1250_GPIO_MODE_MASK;
+		if (gpio3 != gpio3_old)
+			config_writeb(socket, TI1250_GPIO3_CONTROL, gpio3);
+		break;
 
-	csc = exca_readb(socket, I365_CSC);
+	default:
+		gpio3 = gpio3_old = 0;
 
-	if (!(cb_event || csc))
-		return IRQ_NONE;
+		mfunc = (mfunc & ~TI122X_MFUNC0_MASK) | TI122X_MFUNC0_INTA;
+		if (mfunc != mfunc_old)
+			config_writel(socket, TI122X_MFUNC, mfunc);
+	}
 
-	events = (cb_event & (CB_CD1EVENT | CB_CD2EVENT)) ? SS_DETECT : 0 ;
-	events |= (csc & I365_CSC_DETECT) ? SS_DETECT : 0;
-	if (exca_readb(socket, I365_INTCTL) & I365_PC_IOCARD) {
-		events |= (csc & I365_CSC_STSCHG) ? SS_STSCHG : 0;
+	/* time to probe again */
+	pci_irq_status = yenta_probe_cb_irq(socket);
+	if (pci_irq_status == 1) {
+		mfunc_old = mfunc;
+		dev_info(&socket->dev->dev, "TI: parallel PCI interrupts ok\n");
 	} else {
-		events |= (csc & I365_CSC_BVD1) ? SS_BATDEAD : 0;
-		events |= (csc & I365_CSC_BVD2) ? SS_BATWARN : 0;
-		events |= (csc & I365_CSC_READY) ? SS_READY : 0;
+		/* not working, back to old value */
+		mfunc = mfunc_old;
+		config_writel(socket, TI122X_MFUNC, mfunc);
+		if (gpio3 != gpio3_old)
+			config_writeb(socket, TI1250_GPIO3_CONTROL, gpio3_old);
 	}
 
-	if (events)
-		pcmcia_parse_events(&socket->socket, events);
-
-	return IRQ_HANDLED;
+out:
+	if (pci_irq_status < 1) {
+		socket->cb_irq = 0;
+		dev_info(&socket->dev->dev,
+			 "Yenta TI: no PCI interrupts. Fish. Please report.\n");
+	}
 }
 
-static void yenta_interrupt_wrapper(struct timer_list *t)
+
+/* changes the irq of func1 to match that of func0 */
+static int ti12xx_align_irqs(struct yenta_socket *socket, int *old_irq)
 {
-	struct yenta_socket *socket = from_timer(socket, t, poll_timer);
+	struct pci_dev *func0;
 
-	yenta_interrupt(0, (void *)socket);
-	socket->poll_timer.expires = jiffies + HZ;
-	add_timer(&socket->poll_timer);
+	/* find func0 device */
+	func0 = pci_get_slot(socket->dev->bus, socket->dev->devfn & ~0x07);
+	if (!func0)
+		return 0;
+
+	if (old_irq)
+		*old_irq = socket->cb_irq;
+	socket->cb_irq = socket->dev->irq = func0->irq;
+
+	pci_dev_put(func0);
+
+	return 1;
 }
 
-static void yenta_clear_maps(struct yenta_socket *socket)
+/*
+ * ties INTA and INTB together. also changes the devices irq to that of
+ * the function 0 device. call from func1 only.
+ * returns 1 if INTRTIE changed, 0 otherwise.
+ */
+static int ti12xx_tie_interrupts(struct yenta_socket *socket, int *old_irq)
 {
-	int i;
-	struct resource res = { .start = 0, .end = 0x0fff };
-	pccard_io_map io = { 0, 0, 0, 0, 1 };
-	pccard_mem_map mem = { .res = &res, };
+	u32 sysctl;
+	int ret;
 
-	yenta_set_socket(&socket->socket, &dead_socket);
-	for (i = 0; i < 2; i++) {
-		io.map = i;
-		yenta_set_io_map(&socket->socket, &io);
-	}
-	for (i = 0; i < 5; i++) {
-		mem.map = i;
-		yenta_set_mem_map(&socket->socket, &mem);
-	}
+	sysctl = config_readl(socket, TI113X_SYSTEM_CONTROL);
+	if (sysctl & TI122X_SCR_INTRTIE)
+		return 0;
+
+	/* align */
+	ret = ti12xx_align_irqs(socket, old_irq);
+	if (!ret)
+		return 0;
+
+	/* tie */
+	sysctl |= TI122X_SCR_INTRTIE;
+	config_writel(socket, TI113X_SYSTEM_CONTROL, sysctl);
+
+	return 1;
 }
 
-/* redoes voltage interrogation if required */
-static void yenta_interrogate(struct yenta_socket *socket)
+/* undo what ti12xx_tie_interrupts() did */
+static void ti12xx_untie_interrupts(struct yenta_socket *socket, int old_irq)
 {
-	u32 state;
+	u32 sysctl = config_readl(socket, TI113X_SYSTEM_CONTROL);
+	sysctl &= ~TI122X_SCR_INTRTIE;
+	config_writel(socket, TI113X_SYSTEM_CONTROL, sysctl);
 
-	state = cb_readl(socket, CB_SOCKET_STATE);
-	if (!(state & (CB_5VCARD | CB_3VCARD | CB_XVCARD | CB_YVCARD)) ||
-	    (state & (CB_CDETECT1 | CB_CDETECT2 | CB_NOTACARD | CB_BADVCCREQ)) ||
-	    ((state & (CB_16BITCARD | CB_CBCARD)) == (CB_16BITCARD | CB_CBCARD)))
-		cb_writel(socket, CB_SOCKET_FORCE, CB_CVSTEST);
+	socket->cb_irq = socket->dev->irq = old_irq;
 }
 
-/* Called at resume and initialization events */
-static int yenta_sock_init(struct pcmcia_socket *sock)
+/* 
+ * irqrouting for func1, plays with INTB routing
+ * only touches MFUNC for INTB routing. all other bits are taken
+ * care of in func0 already.
+ */
+static void ti12xx_irqroute_func1(struct yenta_socket *socket)
 {
-	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
-
-	exca_writeb(socket, I365_GBLCTL, 0x00);
-	exca_writeb(socket, I365_GENCTL, 0x00);
+	u32 mfunc, mfunc_old, devctl, sysctl;
+	int pci_irq_status;
 
-	/* Redo card voltage interrogation */
-	yenta_interrogate(socket);
+	mfunc = mfunc_old = config_readl(socket, TI122X_MFUNC);
+	devctl = config_readb(socket, TI113X_DEVICE_CONTROL);
+	dev_info(&socket->dev->dev, "TI: mfunc 0x%08x, devctl 0x%02x\n",
+		 mfunc, devctl);
 
-	yenta_clear_maps(socket);
+	/* if IRQs are configured as tied, align irq of func1 with func0 */
+	sysctl = config_readl(socket, TI113X_SYSTEM_CONTROL);
+	if (sysctl & TI122X_SCR_INTRTIE)
+		ti12xx_align_irqs(socket, NULL);
 
-	if (socket->type && socket->type->sock_init)
-		socket->type->sock_init(socket);
+	/* make sure PCI interrupts are enabled before probing */
+	ti_init(socket);
 
-	/* Re-enable CSC interrupts */
-	cb_writel(socket, CB_SOCKET_MASK, CB_CDMASK);
+	/* test PCI interrupts first. only try fixing if return value is 0! */
+	pci_irq_status = yenta_probe_cb_irq(socket);
+	if (pci_irq_status)
+		goto out;
 
-	return 0;
-}
+	/*
+	 * We're here which means PCI interrupts are _not_ delivered. try to
+	 * find the right setting
+	 */
+	dev_info(&socket->dev->dev,
+		 "TI: probing PCI interrupt failed, trying to fix\n");
+
+	/* if all serial: set INTRTIE, probe again */
+	if ((devctl & TI113X_DCR_IMODE_MASK) == TI12XX_DCR_IMODE_ALL_SERIAL) {
+		int old_irq;
+
+		if (ti12xx_tie_interrupts(socket, &old_irq)) {
+			pci_irq_status = yenta_probe_cb_irq(socket);
+			if (pci_irq_status == 1) {
+				dev_info(&socket->dev->dev,
+					 "TI: all-serial interrupts, tied ok\n");
+				goto out;
+			}
 
-static int yenta_sock_suspend(struct pcmcia_socket *sock)
-{
-	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
+			ti12xx_untie_interrupts(socket, old_irq);
+		}
+	}
+	/* parallel PCI: route INTB, probe again */
+	else {
+		int old_irq;
 
-	/* Disable CSC interrupts */
-	cb_writel(socket, CB_SOCKET_MASK, 0x0);
+		switch (socket->dev->device) {
+		case PCI_DEVICE_ID_TI_1250:
+			/* the 1250 has one pin for IRQSER/INTB depending on devctl */
+			break;
 
-	return 0;
-}
+		case PCI_DEVICE_ID_TI_1251A:
+		case PCI_DEVICE_ID_TI_1251B:
+		case PCI_DEVICE_ID_TI_1450:
+			/*
+			 *  those have a pin for IRQSER/INTB plus INTB in MFUNC0
+			 *  we alread probed the shared pin, now go for MFUNC0
+			 */
+			mfunc = (mfunc & ~TI122X_MFUNC0_MASK) | TI125X_MFUNC0_INTB;
+			break;
 
-/*
- * Use an adaptive allocation for the memory resource,
- * sometimes the memory behind pci bridges is limited:
- * 1/8 of the size of the io window of the parent.
- * max 4 MB, min 16 kB. We try very hard to not get below
- * the "ACC" values, though.
- */
-#define BRIDGE_MEM_MAX (4*1024*1024)
-#define BRIDGE_MEM_ACC (128*1024)
-#define BRIDGE_MEM_MIN (16*1024)
+		default:
+			mfunc = (mfunc & ~TI122X_MFUNC1_MASK) | TI122X_MFUNC1_INTB;
+			break;
+		}
 
-#define BRIDGE_IO_MAX 512
-#define BRIDGE_IO_ACC 256
-#define BRIDGE_IO_MIN 32
+		/* write, probe */
+		if (mfunc != mfunc_old) {
+			config_writel(socket, TI122X_MFUNC, mfunc);
 
-#ifndef PCIBIOS_MIN_CARDBUS_IO
-#define PCIBIOS_MIN_CARDBUS_IO PCIBIOS_MIN_IO
-#endif
+			pci_irq_status = yenta_probe_cb_irq(socket);
+			if (pci_irq_status == 1) {
+				dev_info(&socket->dev->dev,
+					 "TI: parallel PCI interrupts ok\n");
+				goto out;
+			}
 
-static int yenta_search_one_res(struct resource *root, struct resource *res,
-				u32 min)
-{
-	u32 align, size, start, end;
+			mfunc = mfunc_old;
+			config_writel(socket, TI122X_MFUNC, mfunc);
 
-	if (res->flags & IORESOURCE_IO) {
-		align = 1024;
-		size = BRIDGE_IO_MAX;
-		start = PCIBIOS_MIN_CARDBUS_IO;
-		end = ~0U;
-	} else {
-		unsigned long avail = root->end - root->start;
-		int i;
-		size = BRIDGE_MEM_MAX;
-		if (size > avail/8) {
-			size = (avail+1)/8;
-			/* round size down to next power of 2 */
-			i = 0;
-			while ((size /= 2) != 0)
-				i++;
-			size = 1 << i;
+			if (pci_irq_status == -1)
+				goto out;
 		}
-		if (size < min)
-			size = min;
-		align = size;
-		start = PCIBIOS_MIN_MEM;
-		end = ~0U;
-	}
 
-	do {
-		if (allocate_resource(root, res, size, start, end, align,
-				      NULL, NULL) == 0) {
-			return 1;
+		/* still nothing: set INTRTIE */
+		if (ti12xx_tie_interrupts(socket, &old_irq)) {
+			pci_irq_status = yenta_probe_cb_irq(socket);
+			if (pci_irq_status == 1) {
+				dev_info(&socket->dev->dev,
+					 "TI: parallel PCI interrupts, tied ok\n");
+				goto out;
+			}
+
+			ti12xx_untie_interrupts(socket, old_irq);
 		}
-		size = size/2;
-		align = size;
-	} while (size >= min);
+	}
 
-	return 0;
+out:
+	if (pci_irq_status < 1) {
+		socket->cb_irq = 0;
+		dev_info(&socket->dev->dev,
+			 "TI: no PCI interrupts. Fish. Please report.\n");
+	}
 }
 
 
-static int yenta_search_res(struct yenta_socket *socket, struct resource *res,
-			    u32 min)
+/* Returns true value if the second slot of a two-slot controller is empty */
+static int ti12xx_2nd_slot_empty(struct yenta_socket *socket)
 {
-	struct resource *root;
-	int i;
+	struct pci_dev *func;
+	struct yenta_socket *slot2;
+	int devfn;
+	unsigned int state;
+	int ret = 1;
+	u32 sysctl;
+
+	/* catch the two-slot controllers */
+	switch (socket->dev->device) {
+	case PCI_DEVICE_ID_TI_1220:
+	case PCI_DEVICE_ID_TI_1221:
+	case PCI_DEVICE_ID_TI_1225:
+	case PCI_DEVICE_ID_TI_1251A:
+	case PCI_DEVICE_ID_TI_1251B:
+	case PCI_DEVICE_ID_TI_1420:
+	case PCI_DEVICE_ID_TI_1450:
+	case PCI_DEVICE_ID_TI_1451A:
+	case PCI_DEVICE_ID_TI_1520:
+	case PCI_DEVICE_ID_TI_1620:
+	case PCI_DEVICE_ID_TI_4520:
+	case PCI_DEVICE_ID_TI_4450:
+	case PCI_DEVICE_ID_TI_4451:
+		/*
+		 * there are way more, but they need to be added in yenta_socket.c
+		 * and pci_ids.h first anyway.
+		 */
+		break;
 
-	pci_bus_for_each_resource(socket->dev->bus, root, i) {
-		if (!root)
-			continue;
+	case PCI_DEVICE_ID_TI_XX12:
+	case PCI_DEVICE_ID_TI_X515:
+	case PCI_DEVICE_ID_TI_X420:
+	case PCI_DEVICE_ID_TI_X620:
+	case PCI_DEVICE_ID_TI_XX21_XX11:
+	case PCI_DEVICE_ID_TI_7410:
+	case PCI_DEVICE_ID_TI_7610:
+		/*
+		 * those are either single or dual slot CB with additional functions
+		 * like 1394, smartcard reader, etc. check the TIEALL flag for them
+		 * the TIEALL flag binds the IRQ of all functions together.
+		 * we catch the single slot variants later.
+		 */
+		sysctl = config_readl(socket, TI113X_SYSTEM_CONTROL);
+		if (sysctl & TIXX21_SCR_TIEALL)
+			return 0;
 
-		if ((res->flags ^ root->flags) &
-		    (IORESOURCE_IO | IORESOURCE_MEM | IORESOURCE_PREFETCH))
-			continue; /* Wrong type */
+		break;
 
-		if (yenta_search_one_res(root, res, min))
-			return 1;
+	/* single-slot controllers have the 2nd slot empty always :) */
+	default:
+		return 1;
 	}
-	return 0;
+
+	/* get other slot */
+	devfn = socket->dev->devfn & ~0x07;
+	func = pci_get_slot(socket->dev->bus,
+	                    (socket->dev->devfn & 0x07) ? devfn : devfn | 0x01);
+	if (!func)
+		return 1;
+
+	/*
+	 * check that the device id of both slots match. this is needed for the
+	 * XX21 and the XX11 controller that share the same device id for single
+	 * and dual slot controllers. return '2nd slot empty'. we already checked
+	 * if the interrupt is tied to another function.
+	 */
+	if (socket->dev->device != func->device)
+		goto out;
+
+	slot2 = pci_get_drvdata(func);
+	if (!slot2)
+		goto out;
+
+	/* check state */
+	yenta_get_status(&slot2->socket, &state);
+	if (state & SS_DETECT) {
+		ret = 0;
+		goto out;
+	}
+
+out:
+	pci_dev_put(func);
+	return ret;
 }
 
-static int yenta_allocate_res(struct yenta_socket *socket, int nr, unsigned type, int addr_start, int addr_end)
+/*
+ * TI specifiy parts for the power hook.
+ *
+ * some TI's with some CB's produces interrupt storm on power on. it has been
+ * seen with atheros wlan cards on TI1225 and TI1410. solution is simply to
+ * disable any CB interrupts during this time.
+ */
+static int ti12xx_power_hook(struct pcmcia_socket *sock, int operation)
 {
-	struct pci_dev *dev = socket->dev;
-	struct resource *res;
-	struct pci_bus_region region;
-	unsigned mask;
+	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
+	u32 mfunc, devctl, sysctl;
+	u8 gpio3;
 
-	res = &dev->resource[nr];
-	/* Already allocated? */
-	if (res->parent)
+	/* only POWER_PRE and POWER_POST are interesting */
+	if ((operation != HOOK_POWER_PRE) && (operation != HOOK_POWER_POST))
 		return 0;
 
-	/* The granularity of the memory limit is 4kB, on IO it's 4 bytes */
-	mask = ~0xfff;
-	if (type & IORESOURCE_IO)
-		mask = ~3;
+	devctl = config_readb(socket, TI113X_DEVICE_CONTROL);
+	sysctl = config_readl(socket, TI113X_SYSTEM_CONTROL);
+	mfunc = config_readl(socket, TI122X_MFUNC);
 
-	res->name = dev->subordinate->name;
-	res->flags = type;
+	/*
+	 * all serial/tied: only disable when modparm set. always doing it
+	 * would mean a regression for working setups 'cos it disables the
+	 * interrupts for both both slots on 2-slot controllers
+	 * (and users of single slot controllers where it's save have to
+	 * live with setting the modparm, most don't have to anyway)
+	 */
+	if (((devctl & TI113X_DCR_IMODE_MASK) == TI12XX_DCR_IMODE_ALL_SERIAL) &&
+	    (pwr_irqs_off || ti12xx_2nd_slot_empty(socket))) {
+		switch (socket->dev->device) {
+		case PCI_DEVICE_ID_TI_1250:
+		case PCI_DEVICE_ID_TI_1251A:
+		case PCI_DEVICE_ID_TI_1251B:
+		case PCI_DEVICE_ID_TI_1450:
+		case PCI_DEVICE_ID_TI_1451A:
+		case PCI_DEVICE_ID_TI_4450:
+		case PCI_DEVICE_ID_TI_4451:
+			/* these chips have no IRQSER setting in MFUNC3  */
+			break;
 
-	region.start = config_readl(socket, addr_start) & mask;
-	region.end = config_readl(socket, addr_end) | ~mask;
-	if (region.start && region.end > region.start && !override_bios) {
-		pcibios_bus_to_resource(dev->bus, res, &region);
-		if (pci_claim_resource(dev, nr) == 0)
-			return 0;
-		dev_info(&dev->dev,
-			 "Preassigned resource %d busy or not available, reconfiguring...\n",
-			 nr);
+		default:
+			if (operation == HOOK_POWER_PRE)
+				mfunc = (mfunc & ~TI122X_MFUNC3_MASK);
+			else
+				mfunc = (mfunc & ~TI122X_MFUNC3_MASK) | TI122X_MFUNC3_IRQSER;
+		}
+
+		return 0;
 	}
 
-	if (type & IORESOURCE_IO) {
-		if ((yenta_search_res(socket, res, BRIDGE_IO_MAX)) ||
-		    (yenta_search_res(socket, res, BRIDGE_IO_ACC)) ||
-		    (yenta_search_res(socket, res, BRIDGE_IO_MIN)))
-			return 1;
+	/* do the job differently for func0/1 */
+	if ((PCI_FUNC(socket->dev->devfn) == 0) ||
+	    ((sysctl & TI122X_SCR_INTRTIE) &&
+	     (pwr_irqs_off || ti12xx_2nd_slot_empty(socket)))) {
+		/* some bridges are different */
+		switch (socket->dev->device) {
+		case PCI_DEVICE_ID_TI_1250:
+		case PCI_DEVICE_ID_TI_1251A:
+		case PCI_DEVICE_ID_TI_1251B:
+		case PCI_DEVICE_ID_TI_1450:
+			/* those oldies use gpio3 for INTA */
+			gpio3 = config_readb(socket, TI1250_GPIO3_CONTROL);
+			if (operation == HOOK_POWER_PRE)
+				gpio3 = (gpio3 & ~TI1250_GPIO_MODE_MASK) | 0x40;
+			else
+				gpio3 &= ~TI1250_GPIO_MODE_MASK;
+			config_writeb(socket, TI1250_GPIO3_CONTROL, gpio3);
+			break;
+
+		default:
+			/* all new bridges are the same */
+			if (operation == HOOK_POWER_PRE)
+				mfunc &= ~TI122X_MFUNC0_MASK;
+			else
+				mfunc |= TI122X_MFUNC0_INTA;
+			config_writel(socket, TI122X_MFUNC, mfunc);
+		}
 	} else {
-		if (type & IORESOURCE_PREFETCH) {
-			if ((yenta_search_res(socket, res, BRIDGE_MEM_MAX)) ||
-			    (yenta_search_res(socket, res, BRIDGE_MEM_ACC)) ||
-			    (yenta_search_res(socket, res, BRIDGE_MEM_MIN)))
-				return 1;
-			/* Approximating prefetchable by non-prefetchable */
-			res->flags = IORESOURCE_MEM;
+		switch (socket->dev->device) {
+		case PCI_DEVICE_ID_TI_1251A:
+		case PCI_DEVICE_ID_TI_1251B:
+		case PCI_DEVICE_ID_TI_1450:
+			/* those have INTA elsewhere and INTB in MFUNC0 */
+			if (operation == HOOK_POWER_PRE)
+				mfunc &= ~TI122X_MFUNC0_MASK;
+			else
+				mfunc |= TI125X_MFUNC0_INTB;
+			config_writel(socket, TI122X_MFUNC, mfunc);
+
+			break;
+
+		default:
+			/* all new bridges are the same */
+			if (operation == HOOK_POWER_PRE)
+				mfunc &= ~TI122X_MFUNC1_MASK;
+			else
+				mfunc |= TI122X_MFUNC1_INTB;
+			config_writel(socket, TI122X_MFUNC, mfunc);
 		}
-		if ((yenta_search_res(socket, res, BRIDGE_MEM_MAX)) ||
-		    (yenta_search_res(socket, res, BRIDGE_MEM_ACC)) ||
-		    (yenta_search_res(socket, res, BRIDGE_MEM_MIN)))
-			return 1;
 	}
 
-	dev_info(&dev->dev,
-		 "no resource of type %x available, trying to continue...\n",
-		 type);
-	res->start = res->end = res->flags = 0;
 	return 0;
 }
 
-static void yenta_free_res(struct yenta_socket *socket, int nr)
+static int ti12xx_override(struct yenta_socket *socket)
 {
-	struct pci_dev *dev = socket->dev;
-	struct resource *res;
+	u32 val, val_orig;
 
-	res = &dev->resource[nr];
-	if (res->start != 0 && res->end != 0)
-		release_resource(res);
+	/* make sure that memory burst is active */
+	val_orig = val = config_readl(socket, TI113X_SYSTEM_CONTROL);
+	if (disable_clkrun && PCI_FUNC(socket->dev->devfn) == 0) {
+		dev_info(&socket->dev->dev, "Disabling CLKRUN feature\n");
+		val |= TI113X_SCR_KEEPCLK;
+	}
+	if (!(val & TI122X_SCR_MRBURSTUP)) {
+		dev_info(&socket->dev->dev,
+			 "Enabling burst memory read transactions\n");
+		val |= TI122X_SCR_MRBURSTUP;
+	}
+	if (val_orig != val)
+		config_writel(socket, TI113X_SYSTEM_CONTROL, val);
 
-	res->start = res->end = res->flags = 0;
+	/*
+	 * Yenta expects controllers to use CSCINT to route
+	 * CSC interrupts to PCI rather than INTVAL.
+	 */
+	val = config_readb(socket, TI1250_DIAGNOSTIC);
+	dev_info(&socket->dev->dev, "Using %s to route CSC interrupts to PCI\n",
+		 (val & TI1250_DIAG_PCI_CSC) ? "CSCINT" : "INTVAL");
+	dev_info(&socket->dev->dev, "Routing CardBus interrupts to %s\n",
+		 (val & TI1250_DIAG_PCI_IREQ) ? "PCI" : "ISA");
+
+	/* do irqrouting, depending on function */
+	if (PCI_FUNC(socket->dev->devfn) == 0)
+		ti12xx_irqroute_func0(socket);
+	else
+		ti12xx_irqroute_func1(socket);
+
+	/* install power hook */
+	socket->socket.power_hook = ti12xx_power_hook;
+
+	return ti_override(socket);
 }
 
-/*
- * Allocate the bridge mappings for the device..
- */
-static void yenta_allocate_resources(struct yenta_socket *socket)
+
+static int ti1250_override(struct yenta_socket *socket)
 {
-	int program = 0;
-	program += yenta_allocate_res(socket, PCI_CB_BRIDGE_IO_0_WINDOW,
-			   IORESOURCE_IO,
-			   PCI_CB_IO_BASE_0, PCI_CB_IO_LIMIT_0);
-	program += yenta_allocate_res(socket, PCI_CB_BRIDGE_IO_1_WINDOW,
-			   IORESOURCE_IO,
-			   PCI_CB_IO_BASE_1, PCI_CB_IO_LIMIT_1);
-	program += yenta_allocate_res(socket, PCI_CB_BRIDGE_MEM_0_WINDOW,
-			   IORESOURCE_MEM | IORESOURCE_PREFETCH,
-			   PCI_CB_MEMORY_BASE_0, PCI_CB_MEMORY_LIMIT_0);
-	program += yenta_allocate_res(socket, PCI_CB_BRIDGE_MEM_1_WINDOW,
-			   IORESOURCE_MEM,
-			   PCI_CB_MEMORY_BASE_1, PCI_CB_MEMORY_LIMIT_1);
-	if (program)
-		pci_setup_cardbus(socket->dev->subordinate);
+	u8 old, diag;
+
+	old = config_readb(socket, TI1250_DIAGNOSTIC);
+	diag = old & ~(TI1250_DIAG_PCI_CSC | TI1250_DIAG_PCI_IREQ);
+	if (socket->cb_irq)
+		diag |= TI1250_DIAG_PCI_CSC | TI1250_DIAG_PCI_IREQ;
+
+	if (diag != old) {
+		dev_info(&socket->dev->dev,
+			 "adjusting diagnostic: %02x -> %02x\n",
+			 old, diag);
+		config_writeb(socket, TI1250_DIAGNOSTIC, diag);
+	}
+
+	return ti12xx_override(socket);
 }
 
 
+/**
+ * EnE specific part. EnE bridges are register compatible with TI bridges but
+ * have their own test registers and more important their own little problems.
+ * Some fixup code to make everybody happy (TM).
+ */
+
+#ifdef CONFIG_YENTA_ENE_TUNE
 /*
- * Free the bridge mappings for the device..
+ * set/clear various test bits:
+ * Defaults to clear the bit.
+ * - mask (u8) defines what bits to change
+ * - bits (u8) is the values to change them to
+ * -> it's
+ * 	current = (current & ~mask) | bits
  */
-static void yenta_free_resources(struct yenta_socket *socket)
+/* pci ids of devices that wants to have the bit set */
+#define DEVID(_vend,_dev,_subvend,_subdev,mask,bits) {		\
+		.vendor		= _vend,			\
+		.device		= _dev,				\
+		.subvendor	= _subvend,			\
+		.subdevice	= _subdev,			\
+		.driver_data	= ((mask) << 8 | (bits)),	\
+	}
+static struct pci_device_id ene_tune_tbl[] = {
+	/* Echo Audio products based on motorola DSP56301 and DSP56361 */
+	DEVID(PCI_VENDOR_ID_MOTOROLA, 0x1801, 0xECC0, PCI_ANY_ID,
+		ENE_TEST_C9_TLTENABLE | ENE_TEST_C9_PFENABLE, ENE_TEST_C9_TLTENABLE),
+	DEVID(PCI_VENDOR_ID_MOTOROLA, 0x3410, 0xECC0, PCI_ANY_ID,
+		ENE_TEST_C9_TLTENABLE | ENE_TEST_C9_PFENABLE, ENE_TEST_C9_TLTENABLE),
+
+	{}
+};
+
+static void ene_tune_bridge(struct pcmcia_socket *sock, struct pci_bus *bus)
 {
-	yenta_free_res(socket, PCI_CB_BRIDGE_IO_0_WINDOW);
-	yenta_free_res(socket, PCI_CB_BRIDGE_IO_1_WINDOW);
-	yenta_free_res(socket, PCI_CB_BRIDGE_MEM_0_WINDOW);
-	yenta_free_res(socket, PCI_CB_BRIDGE_MEM_1_WINDOW);
+	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
+	struct pci_dev *dev;
+	struct pci_device_id *id = NULL;
+	u8 test_c9, old_c9, mask, bits;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		id = (struct pci_device_id *) pci_match_id(ene_tune_tbl, dev);
+		if (id)
+			break;
+	}
+
+	test_c9 = old_c9 = config_readb(socket, ENE_TEST_C9);
+	if (id) {
+		mask = (id->driver_data >> 8) & 0xFF;
+		bits = id->driver_data & 0xFF;
+
+		test_c9 = (test_c9 & ~mask) | bits;
+	}
+	else
+		/* default to clear TLTEnable bit, old behaviour */
+		test_c9 &= ~ENE_TEST_C9_TLTENABLE;
+
+	dev_info(&socket->dev->dev,
+		 "EnE: changing testregister 0xC9, %02x -> %02x\n",
+		 old_c9, test_c9);
+	config_writeb(socket, ENE_TEST_C9, test_c9);
 }
 
+static int ene_override(struct yenta_socket *socket)
+{
+	/* install tune_bridge() function */
+	socket->socket.tune_bridge = ene_tune_bridge;
+
+	return ti1250_override(socket);
+}
+#else
+#  define ene_override ti1250_override
+#endif /* !CONFIG_YENTA_ENE_TUNE */
 
+#endif
+#ifdef CONFIG_YENTA_RICOH
 /*
- * Close it down - release our resources and go home..
+ * ricoh.h 1.9 1999/10/25 20:03:34
  */
-static void yenta_close(struct pci_dev *dev)
+/* Register definitions for Ricoh PCI-to-CardBus bridges */
+
+/* Extra bits in CB_BRIDGE_CONTROL */
+#define RL5C46X_BCR_3E0_ENA		0x0800
+#define RL5C46X_BCR_3E2_ENA		0x1000
+
+/* Bridge Configuration Register */
+#define RL5C4XX_CONFIG			0x80	/* 16 bit */
+#define  RL5C4XX_CONFIG_IO_1_MODE	0x0200
+#define  RL5C4XX_CONFIG_IO_0_MODE	0x0100
+#define  RL5C4XX_CONFIG_PREFETCH	0x0001
+
+/* Misc Control Register */
+#define RL5C4XX_MISC			0x0082	/* 16 bit */
+#define  RL5C4XX_MISC_HW_SUSPEND_ENA	0x0002
+#define  RL5C4XX_MISC_VCCEN_POL		0x0100
+#define  RL5C4XX_MISC_VPPEN_POL		0x0200
+#define  RL5C46X_MISC_SUSPEND		0x0001
+#define  RL5C46X_MISC_PWR_SAVE_2	0x0004
+#define  RL5C46X_MISC_IFACE_BUSY	0x0008
+#define  RL5C46X_MISC_B_LOCK		0x0010
+#define  RL5C46X_MISC_A_LOCK		0x0020
+#define  RL5C46X_MISC_PCI_LOCK		0x0040
+#define  RL5C47X_MISC_IFACE_BUSY	0x0004
+#define  RL5C47X_MISC_PCI_INT_MASK	0x0018
+#define  RL5C47X_MISC_PCI_INT_DIS	0x0020
+#define  RL5C47X_MISC_SUBSYS_WR		0x0040
+#define  RL5C47X_MISC_SRIRQ_ENA		0x0080
+#define  RL5C47X_MISC_5V_DISABLE	0x0400
+#define  RL5C47X_MISC_LED_POL		0x0800
+
+/* 16-bit Interface Control Register */
+#define RL5C4XX_16BIT_CTL		0x0084	/* 16 bit */
+#define  RL5C4XX_16CTL_IO_TIMING	0x0100
+#define  RL5C4XX_16CTL_MEM_TIMING	0x0200
+#define  RL5C46X_16CTL_LEVEL_1		0x0010
+#define  RL5C46X_16CTL_LEVEL_2		0x0020
+
+/* 16-bit IO and memory timing registers */
+#define RL5C4XX_16BIT_IO_0		0x0088	/* 16 bit */
+#define RL5C4XX_16BIT_MEM_0		0x008a	/* 16 bit */
+#define  RL5C4XX_SETUP_MASK		0x0007
+#define  RL5C4XX_SETUP_SHIFT		0
+#define  RL5C4XX_CMD_MASK		0x01f0
+#define  RL5C4XX_CMD_SHIFT		4
+#define  RL5C4XX_HOLD_MASK		0x1c00
+#define  RL5C4XX_HOLD_SHIFT		10
+#define  RL5C4XX_MISC_CONTROL           0x2F /* 8 bit */
+#define  RL5C4XX_ZV_ENABLE              0x08
+
+/* Misc Control 3 Register */
+#define RL5C4XX_MISC3			0x00A2 /* 16 bit */
+#define  RL5C47X_MISC3_CB_CLKRUN_DIS	BIT(1)
+
+#define rl_misc(socket)		((socket)->private[0])
+#define rl_ctl(socket)		((socket)->private[1])
+#define rl_io(socket)		((socket)->private[2])
+#define rl_mem(socket)		((socket)->private[3])
+#define rl_config(socket)	((socket)->private[4])
+
+static void ricoh_zoom_video(struct pcmcia_socket *sock, int onoff)
 {
-	struct yenta_socket *sock = pci_get_drvdata(dev);
+        u8 reg;
+	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
 
-	/* Remove the register attributes */
-	device_remove_file(&dev->dev, &dev_attr_yenta_registers);
+        reg = config_readb(socket, RL5C4XX_MISC_CONTROL);
+        if (onoff)
+                /* Zoom zoom, we will all go together, zoom zoom, zoom zoom */
+                reg |=  RL5C4XX_ZV_ENABLE;
+        else
+                reg &= ~RL5C4XX_ZV_ENABLE;
+	
+        config_writeb(socket, RL5C4XX_MISC_CONTROL, reg);
+}
 
-	/* we don't want a dying socket registered */
-	pcmcia_unregister_socket(&sock->socket);
+static void ricoh_set_zv(struct yenta_socket *socket)
+{
+        if(socket->dev->vendor == PCI_VENDOR_ID_RICOH)
+        {
+                switch(socket->dev->device)
+                {
+                        /* There may be more .. */
+		case  PCI_DEVICE_ID_RICOH_RL5C478:
+			socket->socket.zoom_video = ricoh_zoom_video;
+			break;  
+                }
+        }
+}
 
-	/* Disable all events so we don't die in an IRQ storm */
-	cb_writel(sock, CB_SOCKET_MASK, 0x0);
-	exca_writeb(sock, I365_CSCINT, 0);
+static void ricoh_set_clkrun(struct yenta_socket *socket, bool quiet)
+{
+	u16 misc3;
 
-	if (sock->cb_irq)
-		free_irq(sock->cb_irq, sock);
-	else
-		timer_shutdown_sync(&sock->poll_timer);
+	/*
+	 * RL5C475II likely has this setting, too, however no datasheet
+	 * is publicly available for this chip
+	 */
+	if (socket->dev->device != PCI_DEVICE_ID_RICOH_RL5C476 &&
+	    socket->dev->device != PCI_DEVICE_ID_RICOH_RL5C478)
+		return;
+
+	if (socket->dev->revision < 0x80)
+		return;
+
+	misc3 = config_readw(socket, RL5C4XX_MISC3);
+	if (misc3 & RL5C47X_MISC3_CB_CLKRUN_DIS) {
+		if (!quiet)
+			dev_dbg(&socket->dev->dev,
+				"CLKRUN feature already disabled\n");
+	} else if (disable_clkrun) {
+		if (!quiet)
+			dev_info(&socket->dev->dev,
+				 "Disabling CLKRUN feature\n");
+		misc3 |= RL5C47X_MISC3_CB_CLKRUN_DIS;
+		config_writew(socket, RL5C4XX_MISC3, misc3);
+	}
+}
 
-	iounmap(sock->base);
-	yenta_free_resources(sock);
+static void ricoh_save_state(struct yenta_socket *socket)
+{
+	rl_misc(socket) = config_readw(socket, RL5C4XX_MISC);
+	rl_ctl(socket) = config_readw(socket, RL5C4XX_16BIT_CTL);
+	rl_io(socket) = config_readw(socket, RL5C4XX_16BIT_IO_0);
+	rl_mem(socket) = config_readw(socket, RL5C4XX_16BIT_MEM_0);
+	rl_config(socket) = config_readw(socket, RL5C4XX_CONFIG);
+}
 
-	pci_release_regions(dev);
-	pci_disable_device(dev);
-	pci_set_drvdata(dev, NULL);
-	kfree(sock);
+static void ricoh_restore_state(struct yenta_socket *socket)
+{
+	config_writew(socket, RL5C4XX_MISC, rl_misc(socket));
+	config_writew(socket, RL5C4XX_16BIT_CTL, rl_ctl(socket));
+	config_writew(socket, RL5C4XX_16BIT_IO_0, rl_io(socket));
+	config_writew(socket, RL5C4XX_16BIT_MEM_0, rl_mem(socket));
+	config_writew(socket, RL5C4XX_CONFIG, rl_config(socket));
+	ricoh_set_clkrun(socket, true);
 }
 
 
-static struct pccard_operations yenta_socket_operations = {
-	.init			= yenta_sock_init,
-	.suspend		= yenta_sock_suspend,
-	.get_status		= yenta_get_status,
-	.set_socket		= yenta_set_socket,
-	.set_io_map		= yenta_set_io_map,
-	.set_mem_map		= yenta_set_mem_map,
-};
+/*
+ * Magic Ricoh initialization code..
+ */
+static int ricoh_override(struct yenta_socket *socket)
+{
+	u16 config, ctl;
 
+	config = config_readw(socket, RL5C4XX_CONFIG);
 
-#ifdef CONFIG_YENTA_TI
-#include "ti113x.h"
-#endif
-#ifdef CONFIG_YENTA_RICOH
-#include "ricoh.h"
+	/* Set the default timings, don't trust the original values */
+	ctl = RL5C4XX_16CTL_IO_TIMING | RL5C4XX_16CTL_MEM_TIMING;
+
+	if(socket->dev->device < PCI_DEVICE_ID_RICOH_RL5C475) {
+		ctl |= RL5C46X_16CTL_LEVEL_1 | RL5C46X_16CTL_LEVEL_2;
+	} else {
+		config |= RL5C4XX_CONFIG_PREFETCH;
+	}
+
+	config_writew(socket, RL5C4XX_16BIT_CTL, ctl);
+	config_writew(socket, RL5C4XX_CONFIG, config);
+
+	ricoh_set_zv(socket);
+	ricoh_set_clkrun(socket, false);
+
+	return 0;
+}
 #endif
 #ifdef CONFIG_YENTA_TOSHIBA
-#include "topic.h"
+/*
+ * topic.h 1.8 1999/08/28 04:01:47
+ */
+/* Register definitions for Toshiba ToPIC95/97/100 controllers */
+
+#define TOPIC_SOCKET_CONTROL		0x0090	/* 32 bit */
+#define  TOPIC_SCR_IRQSEL		0x00000001
+
+#define TOPIC_SLOT_CONTROL		0x00a0	/* 8 bit */
+#define  TOPIC_SLOT_SLOTON		0x80
+#define  TOPIC_SLOT_SLOTEN		0x40
+#define  TOPIC_SLOT_ID_LOCK		0x20
+#define  TOPIC_SLOT_ID_WP		0x10
+#define  TOPIC_SLOT_PORT_MASK		0x0c
+#define  TOPIC_SLOT_PORT_SHIFT		2
+#define  TOPIC_SLOT_OFS_MASK		0x03
+
+#define TOPIC_CARD_CONTROL		0x00a1	/* 8 bit */
+#define  TOPIC_CCR_INTB			0x20
+#define  TOPIC_CCR_INTA			0x10
+#define  TOPIC_CCR_CLOCK		0x0c
+#define  TOPIC_CCR_PCICLK		0x0c
+#define  TOPIC_CCR_PCICLK_2		0x08
+#define  TOPIC_CCR_CCLK			0x04
+
+#define TOPIC97_INT_CONTROL		0x00a1	/* 8 bit */
+#define  TOPIC97_ICR_INTB		0x20
+#define  TOPIC97_ICR_INTA		0x10
+#define  TOPIC97_ICR_STSIRQNP		0x04
+#define  TOPIC97_ICR_IRQNP		0x02
+#define  TOPIC97_ICR_IRQSEL		0x01
+
+#define TOPIC_CARD_DETECT		0x00a3	/* 8 bit */
+#define  TOPIC_CDR_MODE_PC32		0x80
+#define  TOPIC_CDR_VS1			0x04
+#define  TOPIC_CDR_VS2			0x02
+#define  TOPIC_CDR_SW_DETECT		0x01
+
+#define TOPIC_REGISTER_CONTROL		0x00a4	/* 32 bit */
+#define  TOPIC_RCR_RESUME_RESET		0x80000000
+#define  TOPIC_RCR_REMOVE_RESET		0x40000000
+#define  TOPIC97_RCR_CLKRUN_ENA		0x20000000
+#define  TOPIC97_RCR_TESTMODE		0x10000000
+#define  TOPIC97_RCR_IOPLUP		0x08000000
+#define  TOPIC_RCR_BUFOFF_PWROFF	0x02000000
+#define  TOPIC_RCR_BUFOFF_SIGOFF	0x01000000
+#define  TOPIC97_RCR_CB_DEV_MASK	0x0000f800
+#define  TOPIC97_RCR_CB_DEV_SHIFT	11
+#define  TOPIC97_RCR_RI_DISABLE		0x00000004
+#define  TOPIC97_RCR_CAUDIO_OFF		0x00000002
+#define  TOPIC_RCR_CAUDIO_INVERT	0x00000001
+
+#define TOPIC97_MISC1			0x00ad  /* 8bit */
+#define  TOPIC97_MISC1_CLOCKRUN_ENABLE	0x80
+#define  TOPIC97_MISC1_CLOCKRUN_MODE	0x40
+#define  TOPIC97_MISC1_DETECT_REQ_ENA	0x10
+#define  TOPIC97_MISC1_SCK_CLEAR_DIS	0x04
+#define  TOPIC97_MISC1_R2_LOW_ENABLE	0x10
+
+#define TOPIC97_MISC2			0x00ae  /* 8 bit */
+#define  TOPIC97_MISC2_SPWRCLK_MASK	0x70
+#define  TOPIC97_MISC2_SPWRMOD		0x08
+#define  TOPIC97_MISC2_SPWR_ENABLE	0x04
+#define  TOPIC97_MISC2_ZV_MODE		0x02
+#define  TOPIC97_MISC2_ZV_ENABLE	0x01
+
+#define TOPIC97_ZOOM_VIDEO_CONTROL	0x009c  /* 8 bit */
+#define  TOPIC97_ZV_CONTROL_ENABLE	0x01
+
+#define TOPIC97_AUDIO_VIDEO_SWITCH	0x003c  /* 8 bit */
+#define  TOPIC97_AVS_AUDIO_CONTROL	0x02
+#define  TOPIC97_AVS_VIDEO_CONTROL	0x01
+
+#define TOPIC_EXCA_IF_CONTROL		0x3e	/* 8 bit */
+#define TOPIC_EXCA_IFC_33V_ENA		0x01
+
+#define TOPIC_PCI_CFG_PPBCN		0x3e	/* 16-bit */
+#define TOPIC_PCI_CFG_PPBCN_WBEN	0x0400
+
+static void topic97_zoom_video(struct pcmcia_socket *sock, int onoff)
+{
+	struct yenta_socket *socket = container_of(sock, struct yenta_socket, socket);
+	u8 reg_zv, reg;
+
+	reg_zv = config_readb(socket, TOPIC97_ZOOM_VIDEO_CONTROL);
+	if (onoff) {
+		reg_zv |= TOPIC97_ZV_CONTROL_ENABLE;
+		config_writeb(socket, TOPIC97_ZOOM_VIDEO_CONTROL, reg_zv);
+
+		reg = config_readb(socket, TOPIC97_AUDIO_VIDEO_SWITCH);
+		reg |= TOPIC97_AVS_AUDIO_CONTROL | TOPIC97_AVS_VIDEO_CONTROL;
+		config_writeb(socket, TOPIC97_AUDIO_VIDEO_SWITCH, reg);
+	} else {
+		reg_zv &= ~TOPIC97_ZV_CONTROL_ENABLE;
+		config_writeb(socket, TOPIC97_ZOOM_VIDEO_CONTROL, reg_zv);
+
+		reg = config_readb(socket, TOPIC97_AUDIO_VIDEO_SWITCH);
+		reg &= ~(TOPIC97_AVS_AUDIO_CONTROL | TOPIC97_AVS_VIDEO_CONTROL);
+		config_writeb(socket, TOPIC97_AUDIO_VIDEO_SWITCH, reg);
+	}
+}
+
+static int topic97_override(struct yenta_socket *socket)
+{
+	/* ToPIC97/100 support ZV */
+	socket->socket.zoom_video = topic97_zoom_video;
+	return 0;
+}
+
+
+static int topic95_override(struct yenta_socket *socket)
+{
+	u8 fctrl;
+	u16 ppbcn;
+
+	/* enable 3.3V support for 16bit cards */
+	fctrl = exca_readb(socket, TOPIC_EXCA_IF_CONTROL);
+	exca_writeb(socket, TOPIC_EXCA_IF_CONTROL, fctrl | TOPIC_EXCA_IFC_33V_ENA);
+
+	/* tell yenta to use exca registers to power 16bit cards */
+	socket->flags |= YENTA_16BIT_POWER_EXCA | YENTA_16BIT_POWER_DF;
+
+	/* Disable write buffers to prevent lockups under load with numerous
+	   Cardbus cards, observed on Tecra 500CDT and reported elsewhere on the
+	   net.  This is not a power-on default according to the datasheet
+	   but some BIOSes seem to set it. */
+	if (pci_read_config_word(socket->dev, TOPIC_PCI_CFG_PPBCN, &ppbcn) == 0
+	    && socket->dev->revision <= 7
+	    && (ppbcn & TOPIC_PCI_CFG_PPBCN_WBEN)) {
+		ppbcn &= ~TOPIC_PCI_CFG_PPBCN_WBEN;
+		pci_write_config_word(socket->dev, TOPIC_PCI_CFG_PPBCN, ppbcn);
+		dev_info(&socket->dev->dev, "Disabled ToPIC95 Cardbus write buffers.\n");
+	}
+
+	return 0;
+}
 #endif
 #ifdef CONFIG_YENTA_O2
-#include "o2micro.h"
+/* 
+ * o2micro.h 1.13 1999/10/25 20:03:34
+ */
+/* Additional PCI configuration registers */
+
+#define O2_MUX_CONTROL		0x90	/* 32 bit */
+#define  O2_MUX_RING_OUT	0x0000000f
+#define  O2_MUX_SKTB_ACTV	0x000000f0
+#define  O2_MUX_SCTA_ACTV_ENA	0x00000100
+#define  O2_MUX_SCTB_ACTV_ENA	0x00000200
+#define  O2_MUX_SER_IRQ_ROUTE	0x0000e000
+#define  O2_MUX_SER_PCI		0x00010000
+
+#define  O2_MUX_SKTA_TURBO	0x000c0000	/* for 6833, 6860 */
+#define  O2_MUX_SKTB_TURBO	0x00300000
+#define  O2_MUX_AUX_VCC_3V	0x00400000
+#define  O2_MUX_PCI_VCC_5V	0x00800000
+#define  O2_MUX_PME_MUX		0x0f000000
+
+/* Additional ExCA registers */
+
+#define O2_MODE_A		0x38
+#define O2_MODE_A_2		0x26	/* for 6833B, 6860C */
+#define  O2_MODE_A_CD_PULSE	0x04
+#define  O2_MODE_A_SUSP_EDGE	0x08
+#define  O2_MODE_A_HOST_SUSP	0x10
+#define  O2_MODE_A_PWR_MASK	0x60
+#define  O2_MODE_A_QUIET	0x80
+
+#define O2_MODE_B		0x39
+#define O2_MODE_B_2		0x2e	/* for 6833B, 6860C */
+#define  O2_MODE_B_IDENT	0x03
+#define  O2_MODE_B_ID_BSTEP	0x00
+#define  O2_MODE_B_ID_CSTEP	0x01
+#define  O2_MODE_B_ID_O2	0x02
+#define  O2_MODE_B_VS1		0x04
+#define  O2_MODE_B_VS2		0x08
+#define  O2_MODE_B_IRQ15_RI	0x80
+
+#define O2_MODE_C		0x3a
+#define  O2_MODE_C_DREQ_MASK	0x03
+#define  O2_MODE_C_DREQ_INPACK	0x01
+#define  O2_MODE_C_DREQ_WP	0x02
+#define  O2_MODE_C_DREQ_BVD2	0x03
+#define  O2_MODE_C_ZVIDEO	0x08
+#define  O2_MODE_C_IREQ_SEL	0x30
+#define  O2_MODE_C_MGMT_SEL	0xc0
+
+#define O2_MODE_D		0x3b
+#define  O2_MODE_D_IRQ_MODE	0x03
+#define  O2_MODE_D_PCI_CLKRUN	0x04
+#define  O2_MODE_D_CB_CLKRUN	0x08
+#define  O2_MODE_D_SKT_ACTV	0x20
+#define  O2_MODE_D_PCI_FIFO	0x40	/* for OZ6729, OZ6730 */
+#define  O2_MODE_D_W97_IRQ	0x40
+#define  O2_MODE_D_ISA_IRQ	0x80
+
+#define O2_MHPG_DMA		0x3c
+#define  O2_MHPG_CHANNEL	0x07
+#define  O2_MHPG_CINT_ENA	0x08
+#define  O2_MHPG_CSC_ENA	0x10
+
+#define O2_FIFO_ENA		0x3d
+#define  O2_FIFO_ZVIDEO_3	0x08
+#define  O2_FIFO_PCI_FIFO	0x10
+#define  O2_FIFO_POSTWR		0x40
+#define  O2_FIFO_BUFFER		0x80
+
+#define O2_MODE_E		0x3e
+#define  O2_MODE_E_MHPG_DMA	0x01
+#define  O2_MODE_E_SPKR_OUT	0x02
+#define  O2_MODE_E_LED_OUT	0x08
+#define  O2_MODE_E_SKTA_ACTV	0x10
+
+#define O2_RESERVED1		0x94
+#define O2_RESERVED2		0xD4
+#define O2_RES_READ_PREFETCH	0x02
+#define O2_RES_WRITE_BURST	0x08
+
+static int o2micro_override(struct yenta_socket *socket)
+{
+	/*
+	 * 'reserved' register at 0x94/D4. allows setting read prefetch and write
+	 * bursting. read prefetching for example makes the RME Hammerfall DSP
+	 * working. for some bridges it is at 0x94, for others at 0xD4. it's
+	 * ok to write to both registers on all O2 bridges.
+	 * from Eric Still, 02Micro.
+	 */
+	u8 a, b;
+	bool use_speedup;
+
+	if (PCI_FUNC(socket->dev->devfn) == 0) {
+		a = config_readb(socket, O2_RESERVED1);
+		b = config_readb(socket, O2_RESERVED2);
+		dev_dbg(&socket->dev->dev, "O2: 0x94/0xD4: %02x/%02x\n", a, b);
+
+		switch (socket->dev->device) {
+		/*
+		 * older bridges have problems with both read prefetch and write
+		 * bursting depending on the combination of the chipset, bridge
+		 * and the cardbus card. so disable them to be on the safe side.
+		 */
+		case PCI_DEVICE_ID_O2_6729:
+		case PCI_DEVICE_ID_O2_6730:
+		case PCI_DEVICE_ID_O2_6812:
+		case PCI_DEVICE_ID_O2_6832:
+		case PCI_DEVICE_ID_O2_6836:
+		case PCI_DEVICE_ID_O2_6933:
+			use_speedup = false;
+			break;
+		default:
+			use_speedup = true;
+			break;
+		}
+
+		/* the user may override our decision */
+		if (strcasecmp(o2_speedup, "on") == 0)
+			use_speedup = true;
+		else if (strcasecmp(o2_speedup, "off") == 0)
+			use_speedup = false;
+		else if (strcasecmp(o2_speedup, "default") != 0)
+			dev_warn(&socket->dev->dev,
+				"O2: Unknown parameter, using 'default'");
+
+		if (use_speedup) {
+			dev_info(&socket->dev->dev,
+				"O2: enabling read prefetch/write burst. If you experience problems or performance issues, use the yenta_socket parameter 'o2_speedup=off'\n");
+			config_writeb(socket, O2_RESERVED1,
+				      a | O2_RES_READ_PREFETCH | O2_RES_WRITE_BURST);
+			config_writeb(socket, O2_RESERVED2,
+				      b | O2_RES_READ_PREFETCH | O2_RES_WRITE_BURST);
+		} else {
+			dev_info(&socket->dev->dev,
+				"O2: disabling read prefetch/write burst. If you experience problems or performance issues, use the yenta_socket parameter 'o2_speedup=on'\n");
+			config_writeb(socket, O2_RESERVED1,
+				      a & ~(O2_RES_READ_PREFETCH | O2_RES_WRITE_BURST));
+			config_writeb(socket, O2_RESERVED2,
+				      b & ~(O2_RES_READ_PREFETCH | O2_RES_WRITE_BURST));
+		}
+	}
+
+	return 0;
+}
+
+static void o2micro_restore_state(struct yenta_socket *socket)
+{
+	/*
+	 * as long as read prefetch is the only thing in
+	 * o2micro_override, it's safe to call it from here
+	 */
+	o2micro_override(socket);
+}
 #endif
 
 enum {
@@ -1465,4 +4733,6 @@ static void __exit yenta_exit(void)
 }
 module_exit(yenta_exit);
 
+MODULE_AUTHOR("David Hinds <dahinds@users.sourceforge.net>");
+MODULE_AUTHOR("Dominik Brodowski <linux@dominikbrodowski.net>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/pcmcia/yenta_socket.h b/drivers/pcmcia/yenta_socket.h
deleted file mode 100644
index efeed19e28c7..000000000000
--- a/drivers/pcmcia/yenta_socket.h
+++ /dev/null
@@ -1,136 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __YENTA_H
-#define __YENTA_H
-
-#include <asm/io.h>
-
-#define CB_SOCKET_EVENT		0x00
-#define    CB_CSTSEVENT		0x00000001	/* Card status event */
-#define    CB_CD1EVENT		0x00000002	/* Card detect 1 change event */
-#define    CB_CD2EVENT		0x00000004	/* Card detect 2 change event */
-#define    CB_PWREVENT		0x00000008	/* PWRCYCLE change event */
-
-#define CB_SOCKET_MASK		0x04
-#define    CB_CSTSMASK		0x00000001	/* Card status mask */
-#define    CB_CDMASK		0x00000006	/* Card detect 1&2 mask */
-#define    CB_PWRMASK		0x00000008	/* PWRCYCLE change mask */
-
-#define CB_SOCKET_STATE		0x08
-#define    CB_CARDSTS		0x00000001	/* CSTSCHG status */
-#define    CB_CDETECT1		0x00000002	/* Card detect status 1 */
-#define    CB_CDETECT2		0x00000004	/* Card detect status 2 */
-#define    CB_PWRCYCLE		0x00000008	/* Socket powered */
-#define    CB_16BITCARD		0x00000010	/* 16-bit card detected */
-#define    CB_CBCARD		0x00000020	/* CardBus card detected */
-#define    CB_IREQCINT		0x00000040	/* READY(xIRQ)/xCINT high */
-#define    CB_NOTACARD		0x00000080	/* Unrecognizable PC card detected */
-#define    CB_DATALOST		0x00000100	/* Potential data loss due to card removal */
-#define    CB_BADVCCREQ		0x00000200	/* Invalid Vcc request by host software */
-#define    CB_5VCARD		0x00000400	/* Card Vcc at 5.0 volts? */
-#define    CB_3VCARD		0x00000800	/* Card Vcc at 3.3 volts? */
-#define    CB_XVCARD		0x00001000	/* Card Vcc at X.X volts? */
-#define    CB_YVCARD		0x00002000	/* Card Vcc at Y.Y volts? */
-#define    CB_5VSOCKET		0x10000000	/* Socket Vcc at 5.0 volts? */
-#define    CB_3VSOCKET		0x20000000	/* Socket Vcc at 3.3 volts? */
-#define    CB_XVSOCKET		0x40000000	/* Socket Vcc at X.X volts? */
-#define    CB_YVSOCKET		0x80000000	/* Socket Vcc at Y.Y volts? */
-
-#define CB_SOCKET_FORCE		0x0C
-#define    CB_FCARDSTS		0x00000001	/* Force CSTSCHG */
-#define    CB_FCDETECT1		0x00000002	/* Force CD1EVENT */
-#define    CB_FCDETECT2		0x00000004	/* Force CD2EVENT */
-#define    CB_FPWRCYCLE		0x00000008	/* Force PWREVENT */
-#define    CB_F16BITCARD	0x00000010	/* Force 16-bit PCMCIA card */
-#define    CB_FCBCARD		0x00000020	/* Force CardBus line */
-#define    CB_FNOTACARD		0x00000080	/* Force NOTACARD */
-#define    CB_FDATALOST		0x00000100	/* Force data lost */
-#define    CB_FBADVCCREQ	0x00000200	/* Force bad Vcc request */
-#define    CB_F5VCARD		0x00000400	/* Force 5.0 volt card */
-#define    CB_F3VCARD		0x00000800	/* Force 3.3 volt card */
-#define    CB_FXVCARD		0x00001000	/* Force X.X volt card */
-#define    CB_FYVCARD		0x00002000	/* Force Y.Y volt card */
-#define    CB_CVSTEST		0x00004000	/* Card VS test */
-
-#define CB_SOCKET_CONTROL	0x10
-#define  CB_SC_VPP_MASK		0x00000007
-#define   CB_SC_VPP_OFF		0x00000000
-#define   CB_SC_VPP_12V		0x00000001
-#define   CB_SC_VPP_5V		0x00000002
-#define   CB_SC_VPP_3V		0x00000003
-#define   CB_SC_VPP_XV		0x00000004
-#define   CB_SC_VPP_YV		0x00000005
-#define  CB_SC_VCC_MASK		0x00000070
-#define   CB_SC_VCC_OFF		0x00000000
-#define   CB_SC_VCC_5V		0x00000020
-#define   CB_SC_VCC_3V		0x00000030
-#define   CB_SC_VCC_XV		0x00000040
-#define   CB_SC_VCC_YV		0x00000050
-#define  CB_SC_CCLK_STOP	0x00000080
-
-#define CB_SOCKET_POWER		0x20
-#define    CB_SKTACCES		0x02000000	/* A PC card access has occurred (clear on read) */
-#define    CB_SKTMODE		0x01000000	/* Clock frequency has changed (clear on read) */
-#define    CB_CLKCTRLEN		0x00010000	/* Clock control enabled (RW) */
-#define    CB_CLKCTRL		0x00000001	/* Stop(0) or slow(1) CB clock (RW) */
-
-/*
- * Cardbus configuration space
- */
-#define CB_BRIDGE_BASE(m)	(0x1c + 8*(m))
-#define CB_BRIDGE_LIMIT(m)	(0x20 + 8*(m))
-#define CB_BRIDGE_CONTROL	0x3e
-#define   CB_BRIDGE_CPERREN	0x00000001
-#define   CB_BRIDGE_CSERREN	0x00000002
-#define   CB_BRIDGE_ISAEN	0x00000004
-#define   CB_BRIDGE_VGAEN	0x00000008
-#define   CB_BRIDGE_MABTMODE	0x00000020
-#define   CB_BRIDGE_CRST	0x00000040
-#define   CB_BRIDGE_INTR	0x00000080
-#define   CB_BRIDGE_PREFETCH0	0x00000100
-#define   CB_BRIDGE_PREFETCH1	0x00000200
-#define   CB_BRIDGE_POSTEN	0x00000400
-#define CB_LEGACY_MODE_BASE	0x44
-
-/*
- * ExCA area extensions in Yenta
- */
-#define CB_MEM_PAGE(map)	(0x40 + (map))
-
-
-/* control how 16bit cards are powered */
-#define YENTA_16BIT_POWER_EXCA	0x00000001
-#define YENTA_16BIT_POWER_DF	0x00000002
-
-
-struct yenta_socket;
-
-struct cardbus_type {
-	int	(*override)(struct yenta_socket *);
-	void	(*save_state)(struct yenta_socket *);
-	void	(*restore_state)(struct yenta_socket *);
-	int	(*sock_init)(struct yenta_socket *);
-};
-
-struct yenta_socket {
-	struct pci_dev *dev;
-	int cb_irq, io_irq;
-	void __iomem *base;
-	struct timer_list poll_timer;
-
-	struct pcmcia_socket socket;
-	struct cardbus_type *type;
-
-	u32 flags;
-
-	/* for PCI interrupt probing */
-	unsigned int probe_status;
-
-	/* A few words of private data for special stuff of overrides... */
-	unsigned int private[8];
-
-	/* PCI saved state */
-	u32 saved_state[2];
-};
-
-
-#endif
-- 
2.39.2

