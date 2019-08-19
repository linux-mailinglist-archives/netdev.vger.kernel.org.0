Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A4C949F0
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfHSQcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:32:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:55450 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728009AbfHSQcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:32:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DD143B62E;
        Mon, 19 Aug 2019 16:32:06 +0000 (UTC)
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
Subject: [PATCH v5 15/17] mfd: ioc3: Add driver for SGI IOC3 chip
Date:   Mon, 19 Aug 2019 18:31:38 +0200
Message-Id: <20190819163144.3478-16-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190819163144.3478-1-tbogendoerfer@suse.de>
References: <20190819163144.3478-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGI IOC3 chip has integrated ethernet, keyboard and mouse interface.
It also supports connecting a SuperIO chip for serial and parallel
interfaces. IOC3 is used inside various SGI systemboards and add-on
cards with different equipped external interfaces.

Support for ethernet and serial interfaces were implemented inside
the network driver. This patchset moves out the not network related
parts to a new MFD driver, which takes care of card detection,
setup of platform devices and interrupt distribution for the subdevices.

Serial portion: Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 arch/mips/sgi-ip27/ip27-timer.c     |  20 -
 drivers/mfd/Kconfig                 |  13 +
 drivers/mfd/Makefile                |   1 +
 drivers/mfd/ioc3.c                  | 586 +++++++++++++++++++++++++++
 drivers/net/ethernet/sgi/Kconfig    |   4 +-
 drivers/net/ethernet/sgi/ioc3-eth.c | 782 +++++++++---------------------------
 drivers/tty/serial/8250/8250_ioc3.c |  98 +++++
 drivers/tty/serial/8250/Kconfig     |  11 +
 drivers/tty/serial/8250/Makefile    |   1 +
 9 files changed, 913 insertions(+), 603 deletions(-)
 create mode 100644 drivers/mfd/ioc3.c
 create mode 100644 drivers/tty/serial/8250/8250_ioc3.c

diff --git a/arch/mips/sgi-ip27/ip27-timer.c b/arch/mips/sgi-ip27/ip27-timer.c
index 9b4b9ac621a3..5631e93ea350 100644
--- a/arch/mips/sgi-ip27/ip27-timer.c
+++ b/arch/mips/sgi-ip27/ip27-timer.c
@@ -188,23 +188,3 @@ void hub_rtc_init(cnodeid_t cnode)
 		LOCAL_HUB_S(PI_RT_PEND_B, 0);
 	}
 }
-
-static int __init sgi_ip27_rtc_devinit(void)
-{
-	struct resource res;
-
-	memset(&res, 0, sizeof(res));
-	res.start = XPHYSADDR(KL_CONFIG_CH_CONS_INFO(master_nasid)->memory_base +
-			      IOC3_BYTEBUS_DEV0);
-	res.end = res.start + 32767;
-	res.flags = IORESOURCE_MEM;
-
-	return IS_ERR(platform_device_register_simple("rtc-m48t35", -1,
-						      &res, 1));
-}
-
-/*
- * kludge make this a device_initcall after ioc3 resource conflicts
- * are resolved
- */
-late_initcall(sgi_ip27_rtc_devinit);
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f129f9678940..6d3908267a6a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -2019,5 +2019,18 @@ config RAVE_SP_CORE
 	  Select this to get support for the Supervisory Processor
 	  device found on several devices in RAVE line of hardware.
 
+config SGI_MFD_IOC3
+	tristate "SGI IOC3 core driver"
+	depends on PCI && MIPS
+	select MFD_CORE
+	help
+	  This option enables basic support for the SGI IOC3-based
+	  controller cards.  This option does not enable any specific
+	  functions on such a card, but provides necessary infrastructure
+	  for other drivers to utilize.
+
+	  If you have an SGI Origin, Octane, or a PCI IOC3 card,
+	  then say Y. Otherwise say N.
+
 endmenu
 endif
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index f026ada68f6a..fb523eaa358a 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -257,3 +257,4 @@ obj-$(CONFIG_MFD_ROHM_BD70528)	+= rohm-bd70528.o
 obj-$(CONFIG_MFD_ROHM_BD718XX)	+= rohm-bd718x7.o
 obj-$(CONFIG_MFD_STMFX) 	+= stmfx.o
 
+obj-$(CONFIG_SGI_MFD_IOC3)	+= ioc3.o
diff --git a/drivers/mfd/ioc3.c b/drivers/mfd/ioc3.c
new file mode 100644
index 000000000000..5bcb3461a189
--- /dev/null
+++ b/drivers/mfd/ioc3.c
@@ -0,0 +1,586 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * SGI IOC3 multifunction device driver
+ *
+ * Copyright (C) 2018, 2019 Thomas Bogendoerfer <tbogendoerfer@suse.de>
+ *
+ * Based on work by:
+ *   Stanislaw Skowronek <skylark@unaligned.org>
+ *   Joshua Kinard <kumba@gentoo.org>
+ *   Brent Casavant <bcasavan@sgi.com> - IOC4 master driver
+ *   Pat Gefre <pfg@sgi.com> - IOC3 serial port IRQ demuxer
+ */
+
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/core.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/sgi-w1.h>
+#include <linux/rtc/ds1685.h>
+
+#include <asm/pci/bridge.h>
+#include <asm/sn/ioc3.h>
+
+#define IOC3_IRQ_SERIAL_A	6
+#define IOC3_IRQ_SERIAL_B	15
+#define IOC3_IRQ_KBD		22
+#define IOC3_IRQ_ETH_DOMAIN	23
+
+/* Bitmask for selecting which IRQs are level triggered */
+#define IOC3_LVL_MASK	(BIT(IOC3_IRQ_SERIAL_A) | BIT(IOC3_IRQ_SERIAL_B))
+
+#define M48T35_REG_SIZE	32768	/* size of m48t35 registers */
+
+/* 1.2 us latency timer (40 cycles at 33 MHz) */
+#define IOC3_LATENCY	40
+
+struct ioc3_priv_data {
+	struct irq_domain *domain;
+	struct ioc3 __iomem *regs;
+	struct pci_dev *pdev;
+	int domain_irq;
+};
+
+static void ioc3_irq_ack(struct irq_data *d)
+{
+	struct ioc3_priv_data *ipd = irq_data_get_irq_chip_data(d);
+	unsigned int hwirq = irqd_to_hwirq(d);
+
+	writel(BIT(hwirq), &ipd->regs->sio_ir);
+}
+
+static void ioc3_irq_mask(struct irq_data *d)
+{
+	struct ioc3_priv_data *ipd = irq_data_get_irq_chip_data(d);
+	unsigned int hwirq = irqd_to_hwirq(d);
+
+	writel(BIT(hwirq), &ipd->regs->sio_iec);
+}
+
+static void ioc3_irq_unmask(struct irq_data *d)
+{
+	struct ioc3_priv_data *ipd = irq_data_get_irq_chip_data(d);
+	unsigned int hwirq = irqd_to_hwirq(d);
+
+	writel(BIT(hwirq), &ipd->regs->sio_ies);
+}
+
+static struct irq_chip ioc3_irq_chip = {
+	.name		= "IOC3",
+	.irq_ack	= ioc3_irq_ack,
+	.irq_mask	= ioc3_irq_mask,
+	.irq_unmask	= ioc3_irq_unmask,
+};
+
+static int ioc3_irq_domain_map(struct irq_domain *d, unsigned int irq,
+			      irq_hw_number_t hwirq)
+{
+	/* Set level IRQs for every interrupt contained in IOC3_LVL_MASK */
+	if (BIT(hwirq) & IOC3_LVL_MASK)
+		irq_set_chip_and_handler(irq, &ioc3_irq_chip, handle_level_irq);
+	else
+		irq_set_chip_and_handler(irq, &ioc3_irq_chip, handle_edge_irq);
+
+	irq_set_chip_data(irq, d->host_data);
+	return 0;
+}
+
+static const struct irq_domain_ops ioc3_irq_domain_ops = {
+	.map = ioc3_irq_domain_map,
+};
+
+static void ioc3_irq_handler(struct irq_desc *desc)
+{
+	struct irq_domain *domain = irq_desc_get_handler_data(desc);
+	struct ioc3_priv_data *ipd = domain->host_data;
+	struct ioc3 __iomem *regs = ipd->regs;
+	u32 pending, mask;
+	unsigned int irq;
+
+	pending = readl(&regs->sio_ir);
+	mask = readl(&regs->sio_ies);
+	pending &= mask; /* mask off not enabled but pending irqs */
+
+	if (mask & BIT(IOC3_IRQ_ETH_DOMAIN))
+		/* if eth irq is enabled we need to check in eth irq regs */
+		if (readl(&regs->eth.eisr) & readl(&regs->eth.eier))
+			pending |= IOC3_IRQ_ETH_DOMAIN;
+
+	if (pending) {
+		irq = irq_find_mapping(domain, __ffs(pending));
+		if (irq)
+			generic_handle_irq(irq);
+	} else  {
+		spurious_interrupt();
+	}
+}
+
+/*
+ * System boards/BaseIOs use more interrupt pins of the bridge ASIC
+ * to which the IOC3 is connected. Since the IOC3 MFD driver
+ * knows wiring of these extra pins, we use the map_irq function
+ * to get interrupts activated
+ */
+static int ioc3_map_irq(struct pci_dev *pdev, int pin)
+{
+	struct pci_host_bridge *hbrg = pci_find_host_bridge(pdev->bus);
+
+	return hbrg->map_irq(pdev, pin, 0);
+}
+
+static int ioc3_irq_domain_setup(struct ioc3_priv_data *ipd, int irq)
+{
+	struct irq_domain *domain;
+	struct fwnode_handle *fn;
+
+	fn = irq_domain_alloc_named_fwnode("IOC3");
+	if (!fn)
+		goto err;
+
+	domain = irq_domain_create_linear(fn, 24, &ioc3_irq_domain_ops, ipd);
+	if (!domain)
+		goto err;
+
+	irq_domain_free_fwnode(fn);
+	ipd->domain = domain;
+
+	irq_set_chained_handler_and_data(irq, ioc3_irq_handler, domain);
+	ipd->domain_irq = irq;
+	return 0;
+
+err:
+	dev_err(&ipd->pdev->dev, "irq domain setup failed\n");
+	return -ENOMEM;
+}
+
+static struct resource ioc3_uarta_resources[] = {
+	DEFINE_RES_MEM(offsetof(struct ioc3, sregs.uarta),
+		       sizeof_field(struct ioc3, sregs.uarta)),
+	DEFINE_RES_IRQ(IOC3_IRQ_SERIAL_A)
+};
+
+static struct resource ioc3_uartb_resources[] = {
+	DEFINE_RES_MEM(offsetof(struct ioc3, sregs.uartb),
+		       sizeof_field(struct ioc3, sregs.uartb)),
+	DEFINE_RES_IRQ(IOC3_IRQ_SERIAL_B)
+};
+
+static struct mfd_cell ioc3_serial_cells[] = {
+	{
+		.name = "ioc3-serial8250",
+		.resources = ioc3_uarta_resources,
+		.num_resources = ARRAY_SIZE(ioc3_uarta_resources),
+	},
+	{
+		.name = "ioc3-serial8250",
+		.resources = ioc3_uartb_resources,
+		.num_resources = ARRAY_SIZE(ioc3_uartb_resources),
+	}
+};
+
+static int ioc3_serial_setup(struct ioc3_priv_data *ipd)
+{
+	int ret;
+
+	/* set gpio pins for RS232/RS422 mode selection */
+	writel(GPCR_UARTA_MODESEL | GPCR_UARTB_MODESEL,
+		&ipd->regs->gpcr_s);
+	/* select RS232 mode for uart a */
+	writel(0, &ipd->regs->gppr[6]);
+	/* select RS232 mode for uart b */
+	writel(0, &ipd->regs->gppr[7]);
+
+	/* switch both ports to 16650 mode */
+	writel(readl(&ipd->regs->port_a.sscr) & ~SSCR_DMA_EN,
+	       &ipd->regs->port_a.sscr);
+	writel(readl(&ipd->regs->port_b.sscr) & ~SSCR_DMA_EN,
+	       &ipd->regs->port_b.sscr);
+	udelay(1000); /* wait until mode switch is done */
+
+	ret = mfd_add_devices(&ipd->pdev->dev, PLATFORM_DEVID_AUTO,
+			      ioc3_serial_cells, ARRAY_SIZE(ioc3_serial_cells),
+			      &ipd->pdev->resource[0], 0, ipd->domain);
+	if (ret) {
+		dev_err(&ipd->pdev->dev, "Failed to add 16550 subdevs\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct resource ioc3_kbd_resources[] = {
+	DEFINE_RES_MEM(offsetof(struct ioc3, serio),
+		       sizeof_field(struct ioc3, serio)),
+	DEFINE_RES_IRQ(IOC3_IRQ_KBD)
+};
+
+static struct mfd_cell ioc3_kbd_cells[] = {
+	{
+		.name = "ioc3-kbd",
+		.resources = ioc3_kbd_resources,
+		.num_resources = ARRAY_SIZE(ioc3_kbd_resources),
+	}
+};
+
+static int ioc3_kbd_setup(struct ioc3_priv_data *ipd)
+{
+	int ret;
+
+	ret = mfd_add_devices(&ipd->pdev->dev, PLATFORM_DEVID_AUTO,
+			      ioc3_kbd_cells, ARRAY_SIZE(ioc3_kbd_cells),
+			      &ipd->pdev->resource[0], 0, ipd->domain);
+	if (ret) {
+		dev_err(&ipd->pdev->dev, "Failed to add 16550 subdevs\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct resource ioc3_eth_resources[] = {
+	DEFINE_RES_MEM(offsetof(struct ioc3, eth),
+		       sizeof_field(struct ioc3, eth)),
+	DEFINE_RES_MEM(offsetof(struct ioc3, ssram),
+		       sizeof_field(struct ioc3, ssram)),
+	DEFINE_RES_IRQ(0)
+};
+
+static struct resource ioc3_w1_resources[] = {
+	DEFINE_RES_MEM(offsetof(struct ioc3, mcr),
+		       sizeof_field(struct ioc3, mcr)),
+};
+static struct sgi_w1_platform_data ioc3_w1_platform_data;
+
+static struct mfd_cell ioc3_eth_cells[] = {
+	{
+		.name = "ioc3-eth",
+		.resources = ioc3_eth_resources,
+		.num_resources = ARRAY_SIZE(ioc3_eth_resources),
+	},
+	{
+		.name = "sgi_w1",
+		.resources = ioc3_w1_resources,
+		.num_resources = ARRAY_SIZE(ioc3_w1_resources),
+		.platform_data = &ioc3_w1_platform_data,
+		.pdata_size = sizeof(ioc3_w1_platform_data),
+	}
+};
+
+static int ioc3_eth_setup(struct ioc3_priv_data *ipd, bool use_domain)
+{
+	int irq = ipd->pdev->irq;
+	int ret;
+
+	/* enable One-Wire bus */
+	writel(GPCR_MLAN_EN, &ipd->regs->gpcr_s);
+
+	/* generate unique identifier */
+	snprintf(ioc3_w1_platform_data.dev_id,
+		 sizeof(ioc3_w1_platform_data.dev_id), "ioc3-%012llx",
+		 ipd->pdev->resource->start);
+
+	if (use_domain)
+		irq = irq_create_mapping(ipd->domain, IOC3_IRQ_ETH_DOMAIN);
+
+	ret = mfd_add_devices(&ipd->pdev->dev, PLATFORM_DEVID_AUTO,
+			      ioc3_eth_cells, ARRAY_SIZE(ioc3_eth_cells),
+			      &ipd->pdev->resource[0], irq, NULL);
+	if (ret) {
+		dev_err(&ipd->pdev->dev, "Failed to add ETH/W1 subdev\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct resource ioc3_m48t35_resources[] = {
+	DEFINE_RES_MEM(IOC3_BYTEBUS_DEV0, M48T35_REG_SIZE)
+};
+
+static struct mfd_cell ioc3_m48t35_cells[] = {
+	{
+		.name = "rtc-m48t35",
+		.resources = ioc3_m48t35_resources,
+		.num_resources = ARRAY_SIZE(ioc3_m48t35_resources),
+	}
+};
+
+static int ioc3_m48t35_setup(struct ioc3_priv_data *ipd)
+{
+	int ret;
+
+	ret = mfd_add_devices(&ipd->pdev->dev, PLATFORM_DEVID_AUTO,
+			      ioc3_m48t35_cells, ARRAY_SIZE(ioc3_m48t35_cells),
+			      &ipd->pdev->resource[0], 0, ipd->domain);
+	if (ret)
+		dev_err(&ipd->pdev->dev, "Failed to add M48T35 subdev\n");
+
+	return ret;
+}
+
+static int ip27_baseio_setup(struct ioc3_priv_data *ipd)
+{
+	int ret, io_irq;
+
+	io_irq = ioc3_map_irq(ipd->pdev, PCI_SLOT(ipd->pdev->devfn) + 2);
+	ret = ioc3_irq_domain_setup(ipd, io_irq);
+	if (ret)
+		return ret;
+
+	ret = ioc3_eth_setup(ipd, false);
+	if (ret)
+		return ret;
+
+	ret = ioc3_serial_setup(ipd);
+	if (ret)
+		return ret;
+
+	return ioc3_m48t35_setup(ipd);
+}
+
+static int ip27_baseio6g_setup(struct ioc3_priv_data *ipd)
+{
+	int ret, io_irq;
+
+	io_irq = ioc3_map_irq(ipd->pdev, PCI_SLOT(ipd->pdev->devfn) + 2);
+	ret = ioc3_irq_domain_setup(ipd, io_irq);
+	if (ret)
+		return ret;
+
+	ret = ioc3_eth_setup(ipd, false);
+	if (ret)
+		return ret;
+
+	ret = ioc3_serial_setup(ipd);
+	if (ret)
+		return ret;
+
+	ret = ioc3_m48t35_setup(ipd);
+	if (ret)
+		return ret;
+
+	return ioc3_kbd_setup(ipd);
+}
+
+static int ip27_mio_setup(struct ioc3_priv_data *ipd)
+{
+	int ret;
+
+	ret = ioc3_irq_domain_setup(ipd, ipd->pdev->irq);
+	if (ret)
+		return ret;
+
+	ret = ioc3_serial_setup(ipd);
+	if (ret)
+		return ret;
+
+	return ioc3_kbd_setup(ipd);
+}
+
+static int ip29_sysboard_setup(struct ioc3_priv_data *ipd)
+{
+	int ret, io_irq;
+
+	io_irq = ioc3_map_irq(ipd->pdev, PCI_SLOT(ipd->pdev->devfn) + 1);
+	ret = ioc3_irq_domain_setup(ipd, io_irq);
+	if (ret)
+		return ret;
+
+	ret = ioc3_eth_setup(ipd, false);
+	if (ret)
+		return ret;
+
+	ret = ioc3_serial_setup(ipd);
+	if (ret)
+		return ret;
+
+	ret = ioc3_m48t35_setup(ipd);
+	if (ret)
+		return ret;
+
+	return ioc3_kbd_setup(ipd);
+}
+
+static int ioc3_menet_setup(struct ioc3_priv_data *ipd)
+{
+	int ret, io_irq;
+
+	io_irq = ioc3_map_irq(ipd->pdev, PCI_SLOT(ipd->pdev->devfn) + 4);
+	ret = ioc3_irq_domain_setup(ipd, io_irq);
+	if (ret)
+		return ret;
+
+	ret = ioc3_eth_setup(ipd, false);
+	if (ret)
+		return ret;
+
+	return ioc3_serial_setup(ipd);
+}
+
+static int ioc3_menet4_setup(struct ioc3_priv_data *ipd)
+{
+	return ioc3_eth_setup(ipd, false);
+}
+
+static int ioc3_cad_duo_setup(struct ioc3_priv_data *ipd)
+{
+	int ret;
+
+	ret = ioc3_irq_domain_setup(ipd, ipd->pdev->irq);
+	if (ret)
+		return ret;
+
+	ret = ioc3_eth_setup(ipd, true);
+	if (ret)
+		return ret;
+
+	return ioc3_kbd_setup(ipd);
+}
+
+/* Helper macro for filling ioc3_info array */
+#define IOC3_SID(_name, _sid, _setup) \
+	{								   \
+		.name = _name,						   \
+		.sid = (PCI_VENDOR_ID_SGI << 16) | IOC3_SUBSYS_ ## _sid,   \
+		.setup = _setup,					   \
+	}
+
+static struct {
+	const char *name;
+	u32 sid;
+	int (*setup)(struct ioc3_priv_data *ipd);
+} ioc3_infos[] = {
+	IOC3_SID("IP27 BaseIO6G", IP27_BASEIO6G, &ip27_baseio6g_setup),
+	IOC3_SID("IP27 MIO", IP27_MIO, &ip27_mio_setup),
+	IOC3_SID("IP27 BaseIO", IP27_BASEIO, &ip27_baseio_setup),
+	IOC3_SID("IP29 System Board", IP29_SYSBOARD, &ip29_sysboard_setup),
+	IOC3_SID("MENET", MENET, &ioc3_menet_setup),
+	IOC3_SID("MENET4", MENET4, &ioc3_menet4_setup)
+};
+#undef IOC3_SID
+
+static int ioc3_setup(struct ioc3_priv_data *ipd)
+{
+	u32 sid;
+	int i;
+
+	/* Clear IRQs */
+	writel(~0, &ipd->regs->sio_iec);
+	writel(~0, &ipd->regs->sio_ir);
+	writel(0, &ipd->regs->eth.eier);
+	writel(~0, &ipd->regs->eth.eisr);
+
+	/* read subsystem vendor id and subsystem id */
+	pci_read_config_dword(ipd->pdev, PCI_SUBSYSTEM_VENDOR_ID, &sid);
+
+	for (i = 0; i < ARRAY_SIZE(ioc3_infos); i++)
+		if (sid == ioc3_infos[i].sid) {
+			pr_info("ioc3: %s\n", ioc3_infos[i].name);
+			return ioc3_infos[i].setup(ipd);
+		}
+
+	/* treat everything not identified by PCI subid as CAD DUO */
+	pr_info("ioc3: CAD DUO\n");
+	return ioc3_cad_duo_setup(ipd);
+}
+
+static int ioc3_mfd_probe(struct pci_dev *pdev,
+			  const struct pci_device_id *pci_id)
+{
+	struct ioc3_priv_data *ipd;
+	struct ioc3 __iomem *regs;
+	int ret;
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, IOC3_LATENCY);
+	pci_set_master(pdev);
+
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_warn(&pdev->dev,
+			 "Failed to set 64-bit DMA mask, trying 32-bit\n");
+		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+		if (ret) {
+			dev_err(&pdev->dev, "Can't set DMA mask, aborting\n");
+			return ret;
+		}
+	}
+
+	/* Set up per-IOC3 data */
+	ipd = devm_kzalloc(&pdev->dev, sizeof(struct ioc3_priv_data),
+			   GFP_KERNEL);
+	if (!ipd) {
+		ret = -ENOMEM;
+		goto out_disable_device;
+	}
+	ipd->pdev = pdev;
+
+	/*
+	 * Map all IOC3 registers.  These are shared between subdevices
+	 * so the main IOC3 module manages them.
+	 */
+	regs = pci_ioremap_bar(pdev, 0);
+	if (!regs) {
+		dev_warn(&pdev->dev, "ioc3: Unable to remap PCI BAR for %s.\n",
+			 pci_name(pdev));
+		ret = -ENOMEM;
+		goto out_disable_device;
+	}
+	ipd->regs = regs;
+
+	/* Track PCI-device specific data */
+	pci_set_drvdata(pdev, ipd);
+
+	ret = ioc3_setup(ipd);
+	if (ret)
+		goto out_disable_device;
+
+	return 0;
+
+out_disable_device:
+	pci_disable_device(pdev);
+	return ret;
+}
+
+static void ioc3_mfd_remove(struct pci_dev *pdev)
+{
+	struct ioc3_priv_data *ipd;
+
+	ipd = pci_get_drvdata(pdev);
+
+	/* Clear and disable all IRQs */
+	writel(~0, &ipd->regs->sio_iec);
+	writel(~0, &ipd->regs->sio_ir);
+
+	/* Release resources */
+	if (ipd->domain) {
+		irq_domain_remove(ipd->domain);
+		free_irq(ipd->domain_irq, (void *)ipd);
+	}
+	pci_disable_device(pdev);
+}
+
+static struct pci_device_id ioc3_mfd_id_table[] = {
+	{ PCI_VENDOR_ID_SGI, PCI_DEVICE_ID_SGI_IOC3, PCI_ANY_ID, PCI_ANY_ID },
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, ioc3_mfd_id_table);
+
+static struct pci_driver ioc3_mfd_driver = {
+	.name = "IOC3",
+	.id_table = ioc3_mfd_id_table,
+	.probe = ioc3_mfd_probe,
+	.remove = ioc3_mfd_remove,
+};
+
+module_pci_driver(ioc3_mfd_driver);
+
+MODULE_AUTHOR("Thomas Bogendoerfer <tbogendoerfer@suse.de>");
+MODULE_DESCRIPTION("SGI IOC3 MFD driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/sgi/Kconfig b/drivers/net/ethernet/sgi/Kconfig
index 37f048e1230c..32a72b532605 100644
--- a/drivers/net/ethernet/sgi/Kconfig
+++ b/drivers/net/ethernet/sgi/Kconfig
@@ -6,7 +6,7 @@
 config NET_VENDOR_SGI
 	bool "SGI devices"
 	default y
-	depends on (PCI && SGI_IP27) || SGI_IP32
+	depends on (PCI && SGI_MFD_IOC3) ||  SGI_IP32
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -19,7 +19,7 @@ if NET_VENDOR_SGI
 
 config SGI_IOC3_ETH
 	bool "SGI IOC3 Ethernet"
-	depends on PCI && SGI_IP27
+	depends on PCI && SGI_MFD_IOC3
 	select CRC32
 	select MII
 	---help---
diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 25597c6194d9..1f98b381774a 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -15,8 +15,6 @@
  *  o Use prefetching for large packets.  What is a good lower limit for
  *    prefetching?
  *  o We're probably allocating a bit too much memory.
- *  o Use hardware checksums.
- *  o Convert to using a IOC3 meta driver.
  *  o Which PHYs might possibly be attached to the IOC3 in real live,
  *    which workarounds are required for them?  Do we ever have Lucent's?
  *  o For the 2.5 branch kill the mii-tool ioctls.
@@ -30,7 +28,8 @@
 #include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/module.h>
-#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/crc16.h>
 #include <linux/crc32.h>
 #include <linux/mii.h>
 #include <linux/in.h>
@@ -39,28 +38,22 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/gfp.h>
-
-#ifdef CONFIG_SERIAL_8250
-#include <linux/serial_core.h>
-#include <linux/serial_8250.h>
-#include <linux/serial_reg.h>
-#endif
-
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
 #include <linux/dma-direct.h>
+#include <linux/platform_device.h>
+#include <linux/nvmem-consumer.h>
 
 #include <net/ip.h>
 
-#include <asm/byteorder.h>
-#include <asm/pgtable.h>
-#include <linux/uaccess.h>
-#include <asm/sn/types.h>
 #include <asm/sn/ioc3.h>
 #include <asm/pci/bridge.h>
 
+#define CRC16_INIT	0
+#define CRC16_VALID	0xb001
+
 /* Number of RX buffers.  This is tunable in the range of 16 <= x < 512.
  * The value must be a power of two.
  */
@@ -86,7 +79,6 @@
 /* Private per NIC data of the driver.  */
 struct ioc3_private {
 	struct ioc3_ethregs *regs;
-	struct ioc3 *all_regs;
 	struct device *dma_dev;
 	u32 *ssram;
 	unsigned long *rxr;		/* pointer to receiver ring */
@@ -104,24 +96,15 @@ struct ioc3_private {
 	spinlock_t ioc3_lock;
 	struct mii_if_info mii;
 
-	struct net_device *dev;
-	struct pci_dev *pdev;
-
 	/* Members used by autonegotiation  */
 	struct timer_list ioc3_timer;
 };
 
 static int ioc3_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static void ioc3_set_multicast_list(struct net_device *dev);
-static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static void ioc3_timeout(struct net_device *dev);
-static inline unsigned int ioc3_hash(const unsigned char *addr);
 static inline void ioc3_stop(struct ioc3_private *ip);
 static void ioc3_init(struct net_device *dev);
 
-static const char ioc3_str[] = "IOC3 Ethernet";
-static const struct ethtool_ops ioc3_ethtool_ops;
-
 #ifdef CONFIG_PCI_XTALK_BRIDGE
 static inline unsigned long ioc3_map(dma_addr_t addr, unsigned long attr)
 {
@@ -138,227 +121,6 @@ static inline unsigned long ioc3_map(dma_addr_t addr, unsigned long attr)
 #define ERBAR_VAL	0
 #endif
 
-#define IOC3_SIZE 0x100000
-
-static inline u32 mcr_pack(u32 pulse, u32 sample)
-{
-	return (pulse << 10) | (sample << 2);
-}
-
-static int nic_wait(u32 __iomem *mcr)
-{
-	u32 m;
-
-	do {
-		m = readl(mcr);
-	} while (!(m & 2));
-
-	return m & 1;
-}
-
-static int nic_reset(u32 __iomem *mcr)
-{
-	int presence;
-
-	writel(mcr_pack(500, 65), mcr);
-	presence = nic_wait(mcr);
-
-	writel(mcr_pack(0, 500), mcr);
-	nic_wait(mcr);
-
-	return presence;
-}
-
-static inline int nic_read_bit(u32 __iomem *mcr)
-{
-	int result;
-
-	writel(mcr_pack(6, 13), mcr);
-	result = nic_wait(mcr);
-	writel(mcr_pack(0, 100), mcr);
-	nic_wait(mcr);
-
-	return result;
-}
-
-static inline void nic_write_bit(u32 __iomem *mcr, int bit)
-{
-	if (bit)
-		writel(mcr_pack(6, 110), mcr);
-	else
-		writel(mcr_pack(80, 30), mcr);
-
-	nic_wait(mcr);
-}
-
-/* Read a byte from an iButton device
- */
-static u32 nic_read_byte(u32 __iomem *mcr)
-{
-	u32 result = 0;
-	int i;
-
-	for (i = 0; i < 8; i++)
-		result = (result >> 1) | (nic_read_bit(mcr) << 7);
-
-	return result;
-}
-
-/* Write a byte to an iButton device
- */
-static void nic_write_byte(u32 __iomem *mcr, int byte)
-{
-	int i, bit;
-
-	for (i = 8; i; i--) {
-		bit = byte & 1;
-		byte >>= 1;
-
-		nic_write_bit(mcr, bit);
-	}
-}
-
-static u64 nic_find(u32 __iomem *mcr, int *last)
-{
-	int a, b, index, disc;
-	u64 address = 0;
-
-	nic_reset(mcr);
-	/* Search ROM.  */
-	nic_write_byte(mcr, 0xf0);
-
-	/* Algorithm from ``Book of iButton Standards''.  */
-	for (index = 0, disc = 0; index < 64; index++) {
-		a = nic_read_bit(mcr);
-		b = nic_read_bit(mcr);
-
-		if (a && b) {
-			pr_warn("NIC search failed (not fatal).\n");
-			*last = 0;
-			return 0;
-		}
-
-		if (!a && !b) {
-			if (index == *last) {
-				address |= 1UL << index;
-			} else if (index > *last) {
-				address &= ~(1UL << index);
-				disc = index;
-			} else if ((address & (1UL << index)) == 0) {
-				disc = index;
-			}
-			nic_write_bit(mcr, address & (1UL << index));
-			continue;
-		} else {
-			if (a)
-				address |= 1UL << index;
-			else
-				address &= ~(1UL << index);
-			nic_write_bit(mcr, a);
-			continue;
-		}
-	}
-
-	*last = disc;
-
-	return address;
-}
-
-static int nic_init(u32 __iomem *mcr)
-{
-	const char *unknown = "unknown";
-	const char *type = unknown;
-	u8 crc;
-	u8 serial[6];
-	int save = 0, i;
-
-	while (1) {
-		u64 reg;
-
-		reg = nic_find(mcr, &save);
-
-		switch (reg & 0xff) {
-		case 0x91:
-			type = "DS1981U";
-			break;
-		default:
-			if (save == 0) {
-				/* Let the caller try again.  */
-				return -1;
-			}
-			continue;
-		}
-
-		nic_reset(mcr);
-
-		/* Match ROM.  */
-		nic_write_byte(mcr, 0x55);
-		for (i = 0; i < 8; i++)
-			nic_write_byte(mcr, (reg >> (i << 3)) & 0xff);
-
-		reg >>= 8; /* Shift out type.  */
-		for (i = 0; i < 6; i++) {
-			serial[i] = reg & 0xff;
-			reg >>= 8;
-		}
-		crc = reg & 0xff;
-		break;
-	}
-
-	pr_info("Found %s NIC", type);
-	if (type != unknown)
-		pr_cont(" registration number %pM, CRC %02x", serial, crc);
-	pr_cont(".\n");
-
-	return 0;
-}
-
-/* Read the NIC (Number-In-a-Can) device used to store the MAC address on
- * SN0 / SN00 nodeboards and PCI cards.
- */
-static void ioc3_get_eaddr_nic(struct ioc3_private *ip)
-{
-	u32 __iomem *mcr = &ip->all_regs->mcr;
-	int tries = 2; /* There may be some problem with the battery?  */
-	u8 nic[14];
-	int i;
-
-	writel(1 << 21, &ip->all_regs->gpcr_s);
-
-	while (tries--) {
-		if (!nic_init(mcr))
-			break;
-		udelay(500);
-	}
-
-	if (tries < 0) {
-		pr_err("Failed to read MAC address\n");
-		return;
-	}
-
-	/* Read Memory.  */
-	nic_write_byte(mcr, 0xf0);
-	nic_write_byte(mcr, 0x00);
-	nic_write_byte(mcr, 0x00);
-
-	for (i = 13; i >= 0; i--)
-		nic[i] = nic_read_byte(mcr);
-
-	for (i = 2; i < 8; i++)
-		ip->dev->dev_addr[i - 2] = nic[i];
-}
-
-/* Ok, this is hosed by design.  It's necessary to know what machine the
- * NIC is in in order to know how to read the NIC address.  We also have
- * to know if it's a PCI card or a NIC in on the node board ...
- */
-static void ioc3_get_eaddr(struct ioc3_private *ip)
-{
-	ioc3_get_eaddr_nic(ip);
-
-	pr_info("Ethernet address is %pM.\n", ip->dev->dev_addr);
-}
-
 static void __ioc3_set_mac_address(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
@@ -717,7 +479,7 @@ static int ioc3_mii_init(struct ioc3_private *ip)
 	u16 word;
 
 	for (i = 0; i < 32; i++) {
-		word = ioc3_mdio_read(ip->dev, i, MII_PHYSID1);
+		word = ioc3_mdio_read(ip->mii.dev, i, MII_PHYSID1);
 
 		if (word != 0xffff && word != 0x0000) {
 			found = 1;
@@ -994,15 +756,10 @@ static int ioc3_open(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
 
-	if (request_irq(dev->irq, ioc3_interrupt, IRQF_SHARED, ioc3_str, dev)) {
-		netdev_err(dev, "Can't get irq %d\n", dev->irq);
-
-		return -EAGAIN;
-	}
-
 	ip->ehar_h = 0;
 	ip->ehar_l = 0;
 	ioc3_init(dev);
+	ioc3_mii_init(ip);
 	ioc3_mii_start(ip);
 
 	netif_start_queue(dev);
@@ -1018,335 +775,10 @@ static int ioc3_close(struct net_device *dev)
 	netif_stop_queue(dev);
 
 	ioc3_stop(ip);
-	free_irq(dev->irq, dev);
-
 	ioc3_free_rings(ip);
 	return 0;
 }
 
-/* MENET cards have four IOC3 chips, which are attached to two sets of
- * PCI slot resources each: the primary connections are on slots
- * 0..3 and the secondaries are on 4..7
- *
- * All four ethernets are brought out to connectors; six serial ports
- * (a pair from each of the first three IOC3s) are brought out to
- * MiniDINs; all other subdevices are left swinging in the wind, leave
- * them disabled.
- */
-
-static int ioc3_adjacent_is_ioc3(struct pci_dev *pdev, int slot)
-{
-	struct pci_dev *dev = pci_get_slot(pdev->bus, PCI_DEVFN(slot, 0));
-	int ret = 0;
-
-	if (dev) {
-		if (dev->vendor == PCI_VENDOR_ID_SGI &&
-		    dev->device == PCI_DEVICE_ID_SGI_IOC3)
-			ret = 1;
-		pci_dev_put(dev);
-	}
-
-	return ret;
-}
-
-static int ioc3_is_menet(struct pci_dev *pdev)
-{
-	return !pdev->bus->parent &&
-	       ioc3_adjacent_is_ioc3(pdev, 0) &&
-	       ioc3_adjacent_is_ioc3(pdev, 1) &&
-	       ioc3_adjacent_is_ioc3(pdev, 2);
-}
-
-#ifdef CONFIG_SERIAL_8250
-/* Note about serial ports and consoles:
- * For console output, everyone uses the IOC3 UARTA (offset 0x178)
- * connected to the master node (look in ip27_setup_console() and
- * ip27prom_console_write()).
- *
- * For serial (/dev/ttyS0 etc), we can not have hardcoded serial port
- * addresses on a partitioned machine. Since we currently use the ioc3
- * serial ports, we use dynamic serial port discovery that the serial.c
- * driver uses for pci/pnp ports (there is an entry for the SGI ioc3
- * boards in pci_boards[]). Unfortunately, UARTA's pio address is greater
- * than UARTB's, although UARTA on o200s has traditionally been known as
- * port 0. So, we just use one serial port from each ioc3 (since the
- * serial driver adds addresses to get to higher ports).
- *
- * The first one to do a register_console becomes the preferred console
- * (if there is no kernel command line console= directive). /dev/console
- * (ie 5, 1) is then "aliased" into the device number returned by the
- * "device" routine referred to in this console structure
- * (ip27prom_console_dev).
- *
- * Also look in ip27-pci.c:pci_fixup_ioc3() for some comments on working
- * around ioc3 oddities in this respect.
- *
- * The IOC3 serials use a 22MHz clock rate with an additional divider which
- * can be programmed in the SCR register if the DLAB bit is set.
- *
- * Register to interrupt zero because we share the interrupt with
- * the serial driver which we don't properly support yet.
- *
- * Can't use UPF_IOREMAP as the whole of IOC3 resources have already been
- * registered.
- */
-static void ioc3_8250_register(struct ioc3_uartregs __iomem *uart)
-{
-#define COSMISC_CONSTANT 6
-
-	struct uart_8250_port port = {
-		.port = {
-			.irq		= 0,
-			.flags		= UPF_SKIP_TEST | UPF_BOOT_AUTOCONF,
-			.iotype		= UPIO_MEM,
-			.regshift	= 0,
-			.uartclk	= (22000000 << 1) / COSMISC_CONSTANT,
-
-			.membase	= (unsigned char __iomem *)uart,
-			.mapbase	= (unsigned long)uart,
-		}
-	};
-	unsigned char lcr;
-
-	lcr = readb(&uart->iu_lcr);
-	writeb(lcr | UART_LCR_DLAB, &uart->iu_lcr);
-	writeb(COSMISC_CONSTANT, &uart->iu_scr);
-	writeb(lcr, &uart->iu_lcr);
-	readb(&uart->iu_lcr);
-	serial8250_register_8250_port(&port);
-}
-
-static void ioc3_serial_probe(struct pci_dev *pdev, struct ioc3 *ioc3)
-{
-	u32 sio_iec;
-
-	/* We need to recognice and treat the fourth MENET serial as it
-	 * does not have an SuperIO chip attached to it, therefore attempting
-	 * to access it will result in bus errors.  We call something an
-	 * MENET if PCI slot 0, 1, 2 and 3 of a master PCI bus all have an IOC3
-	 * in it.  This is paranoid but we want to avoid blowing up on a
-	 * showhorn PCI box that happens to have 4 IOC3 cards in it so it's
-	 * not paranoid enough ...
-	 */
-	if (ioc3_is_menet(pdev) && PCI_SLOT(pdev->devfn) == 3)
-		return;
-
-	/* Switch IOC3 to PIO mode.  It probably already was but let's be
-	 * paranoid
-	 */
-	writel(GPCR_UARTA_MODESEL | GPCR_UARTB_MODESEL, &ioc3->gpcr_s);
-	readl(&ioc3->gpcr_s);
-	writel(0, &ioc3->gppr[6]);
-	readl(&ioc3->gppr[6]);
-	writel(0, &ioc3->gppr[7]);
-	readl(&ioc3->gppr[7]);
-	writel(readl(&ioc3->port_a.sscr) & ~SSCR_DMA_EN, &ioc3->port_a.sscr);
-	readl(&ioc3->port_a.sscr);
-	writel(readl(&ioc3->port_b.sscr) & ~SSCR_DMA_EN, &ioc3->port_b.sscr);
-	readl(&ioc3->port_b.sscr);
-	/* Disable all SA/B interrupts except for SA/B_INT in SIO_IEC. */
-	sio_iec = readl(&ioc3->sio_iec);
-	sio_iec &= ~(SIO_IR_SA_TX_MT | SIO_IR_SA_RX_FULL |
-		     SIO_IR_SA_RX_HIGH | SIO_IR_SA_RX_TIMER |
-		     SIO_IR_SA_DELTA_DCD | SIO_IR_SA_DELTA_CTS |
-		     SIO_IR_SA_TX_EXPLICIT | SIO_IR_SA_MEMERR);
-	sio_iec |= SIO_IR_SA_INT;
-	sio_iec &= ~(SIO_IR_SB_TX_MT | SIO_IR_SB_RX_FULL |
-		     SIO_IR_SB_RX_HIGH | SIO_IR_SB_RX_TIMER |
-		     SIO_IR_SB_DELTA_DCD | SIO_IR_SB_DELTA_CTS |
-		     SIO_IR_SB_TX_EXPLICIT | SIO_IR_SB_MEMERR);
-	sio_iec |= SIO_IR_SB_INT;
-	writel(sio_iec, &ioc3->sio_iec);
-	writel(0, &ioc3->port_a.sscr);
-	writel(0, &ioc3->port_b.sscr);
-
-	ioc3_8250_register(&ioc3->sregs.uarta);
-	ioc3_8250_register(&ioc3->sregs.uartb);
-}
-#endif
-
-static const struct net_device_ops ioc3_netdev_ops = {
-	.ndo_open		= ioc3_open,
-	.ndo_stop		= ioc3_close,
-	.ndo_start_xmit		= ioc3_start_xmit,
-	.ndo_tx_timeout		= ioc3_timeout,
-	.ndo_get_stats		= ioc3_get_stats,
-	.ndo_set_rx_mode	= ioc3_set_multicast_list,
-	.ndo_do_ioctl		= ioc3_ioctl,
-	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_set_mac_address	= ioc3_set_mac_address,
-};
-
-static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
-{
-	unsigned int sw_physid1, sw_physid2;
-	struct net_device *dev = NULL;
-	struct ioc3_private *ip;
-	struct ioc3 *ioc3;
-	unsigned long ioc3_base, ioc3_size;
-	u32 vendor, model, rev;
-	int err, pci_using_dac;
-
-	/* Configure DMA attributes. */
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
-	if (!err) {
-		pci_using_dac = 1;
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-		if (err < 0) {
-			pr_err("%s: Unable to obtain 64 bit DMA for consistent allocations\n",
-			       pci_name(pdev));
-			goto out;
-		}
-	} else {
-		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-		if (err) {
-			pr_err("%s: No usable DMA configuration, aborting.\n",
-			       pci_name(pdev));
-			goto out;
-		}
-		pci_using_dac = 0;
-	}
-
-	if (pci_enable_device(pdev))
-		return -ENODEV;
-
-	dev = alloc_etherdev(sizeof(struct ioc3_private));
-	if (!dev) {
-		err = -ENOMEM;
-		goto out_disable;
-	}
-
-	if (pci_using_dac)
-		dev->features |= NETIF_F_HIGHDMA;
-
-	err = pci_request_regions(pdev, "ioc3");
-	if (err)
-		goto out_free;
-
-	SET_NETDEV_DEV(dev, &pdev->dev);
-
-	ip = netdev_priv(dev);
-	ip->dev = dev;
-	ip->dma_dev = &pdev->dev;
-
-	dev->irq = pdev->irq;
-
-	ioc3_base = pci_resource_start(pdev, 0);
-	ioc3_size = pci_resource_len(pdev, 0);
-	ioc3 = (struct ioc3 *)ioremap(ioc3_base, ioc3_size);
-	if (!ioc3) {
-		pr_err("ioc3eth(%s): ioremap failed, goodbye.\n",
-		       pci_name(pdev));
-		err = -ENOMEM;
-		goto out_res;
-	}
-	ip->regs = &ioc3->eth;
-	ip->ssram = ioc3->ssram;
-	ip->all_regs = ioc3;
-
-#ifdef CONFIG_SERIAL_8250
-	ioc3_serial_probe(pdev, ioc3);
-#endif
-
-	spin_lock_init(&ip->ioc3_lock);
-	timer_setup(&ip->ioc3_timer, ioc3_timer, 0);
-
-	ioc3_stop(ip);
-	ioc3_init(dev);
-
-	ip->pdev = pdev;
-
-	ip->mii.phy_id_mask = 0x1f;
-	ip->mii.reg_num_mask = 0x1f;
-	ip->mii.dev = dev;
-	ip->mii.mdio_read = ioc3_mdio_read;
-	ip->mii.mdio_write = ioc3_mdio_write;
-
-	ioc3_mii_init(ip);
-
-	if (ip->mii.phy_id == -1) {
-		pr_err("ioc3-eth(%s): Didn't find a PHY, goodbye.\n",
-		       pci_name(pdev));
-		err = -ENODEV;
-		goto out_stop;
-	}
-
-	ioc3_mii_start(ip);
-	ioc3_ssram_disc(ip);
-	ioc3_get_eaddr(ip);
-
-	/* The IOC3-specific entries in the device structure. */
-	dev->watchdog_timeo	= 5 * HZ;
-	dev->netdev_ops		= &ioc3_netdev_ops;
-	dev->ethtool_ops	= &ioc3_ethtool_ops;
-	dev->hw_features	= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
-	dev->features		= NETIF_F_IP_CSUM;
-
-	sw_physid1 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID1);
-	sw_physid2 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID2);
-
-	err = register_netdev(dev);
-	if (err)
-		goto out_stop;
-
-	mii_check_media(&ip->mii, 1, 1);
-	ioc3_setup_duplex(ip);
-
-	vendor = (sw_physid1 << 12) | (sw_physid2 >> 4);
-	model  = (sw_physid2 >> 4) & 0x3f;
-	rev    = sw_physid2 & 0xf;
-	netdev_info(dev, "Using PHY %d, vendor 0x%x, model %d, rev %d.\n",
-		    ip->mii.phy_id, vendor, model, rev);
-	netdev_info(dev, "IOC3 SSRAM has %d kbyte.\n",
-		    ip->emcr & EMCR_BUFSIZ ? 128 : 64);
-
-	return 0;
-
-out_stop:
-	ioc3_stop(ip);
-	del_timer_sync(&ip->ioc3_timer);
-	ioc3_free_rings(ip);
-out_res:
-	pci_release_regions(pdev);
-out_free:
-	free_netdev(dev);
-out_disable:
-	/* We should call pci_disable_device(pdev); here if the IOC3 wasn't
-	 * such a weird device ...
-	 */
-out:
-	return err;
-}
-
-static void ioc3_remove_one(struct pci_dev *pdev)
-{
-	struct net_device *dev = pci_get_drvdata(pdev);
-	struct ioc3_private *ip = netdev_priv(dev);
-
-	unregister_netdev(dev);
-	del_timer_sync(&ip->ioc3_timer);
-
-	iounmap(ip->all_regs);
-	pci_release_regions(pdev);
-	free_netdev(dev);
-	/* We should call pci_disable_device(pdev); here if the IOC3 wasn't
-	 * such a weird device ...
-	 */
-}
-
-static const struct pci_device_id ioc3_pci_tbl[] = {
-	{ PCI_VENDOR_ID_SGI, PCI_DEVICE_ID_SGI_IOC3, PCI_ANY_ID, PCI_ANY_ID },
-	{ 0 }
-};
-MODULE_DEVICE_TABLE(pci, ioc3_pci_tbl);
-
-static struct pci_driver ioc3_driver = {
-	.name		= "ioc3-eth",
-	.id_table	= ioc3_pci_tbl,
-	.probe		= ioc3_probe,
-	.remove		= ioc3_remove_one,
-};
-
 static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
@@ -1478,6 +910,18 @@ static void ioc3_timeout(struct net_device *dev)
 	netif_wake_queue(dev);
 }
 
+static const struct net_device_ops ioc3_netdev_ops = {
+	.ndo_open		= ioc3_open,
+	.ndo_stop		= ioc3_close,
+	.ndo_start_xmit		= ioc3_start_xmit,
+	.ndo_tx_timeout		= ioc3_timeout,
+	.ndo_get_stats		= ioc3_get_stats,
+	.ndo_set_rx_mode	= ioc3_set_multicast_list,
+	.ndo_do_ioctl		= ioc3_ioctl,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_set_mac_address	= ioc3_set_mac_address,
+};
+
 /* Given a multicast ethernet address, this routine calculates the
  * address's bit index in the logical address filter mask
  */
@@ -1502,11 +946,10 @@ static inline unsigned int ioc3_hash(const unsigned char *addr)
 static void ioc3_get_drvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
-	struct ioc3_private *ip = netdev_priv(dev);
-
 	strlcpy(info->driver, IOC3_NAME, sizeof(info->driver));
 	strlcpy(info->version, IOC3_VERSION, sizeof(info->version));
-	strlcpy(info->bus_info, pci_name(ip->pdev), sizeof(info->bus_info));
+	strlcpy(info->bus_info, pci_name(to_pci_dev(dev->dev.parent)),
+		sizeof(info->bus_info));
 }
 
 static int ioc3_get_link_ksettings(struct net_device *dev,
@@ -1617,7 +1060,184 @@ static void ioc3_set_multicast_list(struct net_device *dev)
 	spin_unlock_irq(&ip->ioc3_lock);
 }
 
-module_pci_driver(ioc3_driver);
+static int ioc3eth_nvmem_match(struct device *dev, const void *data)
+{
+	const char *name = dev_name(dev);
+	const char *prefix = data;
+	int prefix_len;
+
+	prefix_len = strlen(prefix);
+	if (strlen(name) < (prefix_len + 3))
+		return 0;
+
+	if (memcmp(prefix, name, prefix_len) != 0)
+		return 0;
+
+	/* found nvmem device which is attached to our ioc3
+	 * now check for one wire family code 09, 89 and 91
+	 */
+	if (memcmp(name + prefix_len, "09-", 3) == 0)
+		return 1;
+	if (memcmp(name + prefix_len, "89-", 3) == 0)
+		return 1;
+	if (memcmp(name + prefix_len, "91-", 3) == 0)
+		return 1;
+
+	return 0;
+}
+
+static int ioc3eth_get_mac_addr(struct resource *res, u8 mac_addr[6])
+{
+	struct nvmem_device *nvmem;
+	char prefix[24];
+	u8 prom[16];
+	int ret;
+	int i;
+
+	snprintf(prefix, sizeof(prefix), "ioc3-%012llx-",
+		 res->start & ~0xffff);
+
+	nvmem = nvmem_device_find(prefix, ioc3eth_nvmem_match);
+	if (IS_ERR(nvmem))
+		return PTR_ERR(nvmem);
+
+	ret = nvmem_device_read(nvmem, 0, 16, prom);
+	nvmem_device_put(nvmem);
+	if (ret < 0)
+		return ret;
+
+	/* check, if content is valid */
+	if (prom[0] != 0x0a ||
+	    crc16(CRC16_INIT, prom, 13) != CRC16_VALID)
+		return -EINVAL;
+
+	for (i = 0; i < 6; i++)
+		mac_addr[i] = prom[10 - i];
+
+	return 0;
+}
+
+static int ioc3eth_probe(struct platform_device *pdev)
+{
+	u32 sw_physid1, sw_physid2, vendor, model, rev;
+	struct ioc3_private *ip;
+	struct net_device *dev;
+	struct resource *regs;
+	u8 mac_addr[6];
+	int err;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	/* get mac addr from one wire prom */
+	if (ioc3eth_get_mac_addr(regs, mac_addr))
+		return -EPROBE_DEFER; /* not available yet */
+
+	dev = alloc_etherdev(sizeof(struct ioc3_private));
+	if (!dev)
+		return -ENOMEM;
+
+	/* The IOC3-specific entries in the device structure. */
+	dev->watchdog_timeo	= 5 * HZ;
+	dev->netdev_ops		= &ioc3_netdev_ops;
+	dev->ethtool_ops	= &ioc3_ethtool_ops;
+	dev->features		= NETIF_F_IP_CSUM | NETIF_F_HIGHDMA;
+
+	SET_NETDEV_DEV(dev, &pdev->dev);
+	ip = netdev_priv(dev);
+	ip->regs = devm_platform_ioremap_resource(pdev, 0);
+	if (!ip->regs)
+		return -ENOMEM;
+
+	ip->ssram = devm_platform_ioremap_resource(pdev, 1);
+	if (!ip->ssram)
+		return -ENOMEM;
+
+	ip->dma_dev = pdev->dev.parent;
+
+	dev->irq = platform_get_irq(pdev, 0);
+	if (dev->irq < 0)
+		return dev->irq;
+
+	if (devm_request_irq(&pdev->dev, dev->irq, ioc3_interrupt,
+			     IRQF_SHARED, "ioc3-eth", dev)) {
+		dev_err(&pdev->dev, "Can't get irq %d\n", dev->irq);
+		return -ENODEV;
+	}
+
+	spin_lock_init(&ip->ioc3_lock);
+	timer_setup(&ip->ioc3_timer, ioc3_timer, 0);
+
+	ioc3_stop(ip);
+	ioc3_init(dev);
+
+	ip->mii.phy_id_mask = 0x1f;
+	ip->mii.reg_num_mask = 0x1f;
+	ip->mii.dev = dev;
+	ip->mii.mdio_read = ioc3_mdio_read;
+	ip->mii.mdio_write = ioc3_mdio_write;
+
+	ioc3_mii_init(ip);
+
+	if (ip->mii.phy_id == -1) {
+		netdev_err(dev, "Didn't find a PHY, goodbye.\n");
+		err = -ENODEV;
+		goto out_stop;
+	}
+
+	ioc3_mii_start(ip);
+	ioc3_ssram_disc(ip);
+	memcpy(dev->dev_addr, mac_addr, ETH_ALEN);
+
+	sw_physid1 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID1);
+	sw_physid2 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID2);
+
+	err = register_netdev(dev);
+	if (err)
+		goto out_stop;
+
+	mii_check_media(&ip->mii, 1, 1);
+	ioc3_setup_duplex(ip);
+
+	vendor = (sw_physid1 << 12) | (sw_physid2 >> 4);
+	model  = (sw_physid2 >> 4) & 0x3f;
+	rev    = sw_physid2 & 0xf;
+	netdev_info(dev, "Using PHY %d, vendor 0x%x, model %d, rev %d.\n",
+		    ip->mii.phy_id, vendor, model, rev);
+	netdev_info(dev, "IOC3 SSRAM has %d kbyte.\n",
+		    (ip->emcr & EMCR_BUFSIZ ? 128 : 64));
+
+	return 0;
+
+out_stop:
+	ioc3_stop(ip);
+	del_timer_sync(&ip->ioc3_timer);
+	ioc3_free_rings(ip);
+	free_netdev(dev);
+	return err;
+}
+
+static int ioc3eth_remove(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+	struct ioc3_private *ip = netdev_priv(dev);
+
+	unregister_netdev(dev);
+	del_timer_sync(&ip->ioc3_timer);
+	ioc3_free_rings(ip);
+	free_netdev(dev);
+
+	return 0;
+}
+
+static struct platform_driver ioc3eth_driver = {
+	.probe  = ioc3eth_probe,
+	.remove = ioc3eth_remove,
+	.driver = {
+		.name = "ioc3-eth",
+	}
+};
+
+module_platform_driver(ioc3eth_driver);
+
 MODULE_AUTHOR("Ralf Baechle <ralf@linux-mips.org>");
 MODULE_DESCRIPTION("SGI IOC3 Ethernet driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/tty/serial/8250/8250_ioc3.c b/drivers/tty/serial/8250/8250_ioc3.c
new file mode 100644
index 000000000000..2be6ed2967e0
--- /dev/null
+++ b/drivers/tty/serial/8250/8250_ioc3.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * SGI IOC3 8250 UART driver
+ *
+ * Copyright (C) 2019 Thomas Bogendoerfer <tbogendoerfer@suse.de>
+ *
+ * based on code Copyright (C) 2005 Stanislaw Skowronek <skylark@unaligned.org>
+ *               Copyright (C) 2014 Joshua Kinard <kumba@gentoo.org>
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+
+#include "8250.h"
+
+#define IOC3_UARTCLK (22000000 / 3)
+
+struct ioc3_8250_data {
+	int line;
+};
+
+static unsigned int ioc3_serial_in(struct uart_port *p, int offset)
+{
+	return readb(p->membase + offset);
+}
+
+static void ioc3_serial_out(struct uart_port *p, int offset, int value)
+{
+	writeb(value, p->membase + offset);
+}
+
+static int serial8250_ioc3_probe(struct platform_device *pdev)
+{
+	struct ioc3_8250_data *data;
+	struct uart_8250_port up;
+	struct resource *r;
+	void __iomem *membase;
+	int irq, line;
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r)
+		return -ENODEV;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	membase = devm_ioremap_nocache(&pdev->dev, r->start, resource_size(r));
+	if (!membase)
+		return -ENOMEM;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		irq = 0; /* no interrupt -> use polling */
+
+	/* Register serial ports with 8250.c */
+	memset(&up, 0, sizeof(struct uart_8250_port));
+	up.port.iotype = UPIO_MEM;
+	up.port.uartclk = IOC3_UARTCLK;
+	up.port.type = PORT_16550A;
+	up.port.irq = irq;
+	up.port.flags = (UPF_BOOT_AUTOCONF | UPF_SHARE_IRQ);
+	up.port.dev = &pdev->dev;
+	up.port.membase = membase;
+	up.port.mapbase = r->start;
+	up.port.serial_in = ioc3_serial_in;
+	up.port.serial_out = ioc3_serial_out;
+	line = serial8250_register_8250_port(&up);
+	if (line < 0)
+		return line;
+
+	platform_set_drvdata(pdev, data);
+	return 0;
+}
+
+static int serial8250_ioc3_remove(struct platform_device *pdev)
+{
+	struct ioc3_8250_data *data = platform_get_drvdata(pdev);
+
+	serial8250_unregister_port(data->line);
+	return 0;
+}
+
+static struct platform_driver serial8250_ioc3_driver = {
+	.probe  = serial8250_ioc3_probe,
+	.remove = serial8250_ioc3_remove,
+	.driver = {
+		.name = "ioc3-serial8250",
+	}
+};
+
+module_platform_driver(serial8250_ioc3_driver);
+
+MODULE_AUTHOR("Thomas Bogendoerfer <tbogendoerfer@suse.de>");
+MODULE_DESCRIPTION("SGI IOC3 8250 UART driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 509f6a3bb9ff..7ed0a63a3a71 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -366,6 +366,17 @@ config SERIAL_8250_EM
 	  port hardware found on the Emma Mobile line of processors.
 	  If unsure, say N.
 
+config SERIAL_8250_IOC3
+	tristate "SGI IOC3 8250 UART support"
+	depends on SGI_MFD_IOC3 && SERIAL_8250
+	select SERIAL_8250_EXTENDED
+	select SERIAL_8250_SHARE_IRQ
+	help
+	  Enable this if you have a SGI Origin or Octane machine. This module
+	  provides basic serial support by directly driving the UART chip
+	  behind the IOC3 device on those systems.  Maximum baud speed is
+	  38400bps using this driver.
+
 config SERIAL_8250_RT288X
 	bool "Ralink RT288x/RT305x/RT3662/RT3883 serial port support"
 	depends on SERIAL_8250
diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/Makefile
index 18751bc63a84..79f74b4d57e5 100644
--- a/drivers/tty/serial/8250/Makefile
+++ b/drivers/tty/serial/8250/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
 obj-$(CONFIG_SERIAL_8250_MEN_MCB)	+= 8250_men_mcb.o
 obj-$(CONFIG_SERIAL_8250_DW)		+= 8250_dw.o
 obj-$(CONFIG_SERIAL_8250_EM)		+= 8250_em.o
+obj-$(CONFIG_SERIAL_8250_IOC3)		+= 8250_ioc3.o
 obj-$(CONFIG_SERIAL_8250_OMAP)		+= 8250_omap.o
 obj-$(CONFIG_SERIAL_8250_LPC18XX)	+= 8250_lpc18xx.o
 obj-$(CONFIG_SERIAL_8250_MT6577)	+= 8250_mtk.o
-- 
2.13.7

