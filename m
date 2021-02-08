Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E31A31350E
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 15:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbhBHOXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 09:23:21 -0500
Received: from mail.baikalelectronics.com ([87.245.175.226]:57768 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbhBHOK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 09:10:56 -0500
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Vyacheslav Mitrofanov 
        <Vyacheslav.Mitrofanov@baikalelectronics.ru>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCH 14/16] net: stmmac: Add Generic DW MAC GPIO port driver
Date:   Mon, 8 Feb 2021 17:08:18 +0300
Message-ID: <20210208140820.10410-15-Sergey.Semin@baikalelectronics.ru>
In-Reply-To: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
References: <20210208140820.10410-1-Sergey.Semin@baikalelectronics.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synopsys DesignWare Ethernet controllers can be synthesized with
General-Purpose IOs support. GPIOs can work either as inputs or as outputs
thus belong to the gpi_i and gpo_o ports respectively. The ports width
(number of possible inputs/outputs) and the configuration registers layout
depend on the IP-core version. For instance, DW GMAC can have from 0 to 4
GPIs and from 0 to 4 GPOs, while DW xGMAC have a wider ports width up to
16 pins of each one. In the framework of this driver both implementation
can be supported as soon as the GPIO registers accessors are defined for
the particular IP-core.

Total number of GPIOs MAC supports can be passed via the platform
descriptor. If it's a OF-based platform, then the standard "ngpios"
DT-property will be parsed for it.

Before registering the GPIO-chip in the kernel, the driver will try to
auto-detect the number of GPIs and GPOs by writing 1s into the GPI type
config register. Reading the written value back and calculating the number
of actually set bits will give the GPI port width the device has been
synthesized with.

If GPIs have been detected then GPIO IRQ-chip will be also initialized and
Only in that case the GPIO IRQs handling will be activated. Since the
pending events are cleared just be reading from the GPI event status
register, only the edged IRQs type can be implemented. For the same reason
and for the reason of having the rest of GPIO configs reside in the same
CSR, we had no choice but to define the GPI type, GPI mask and GPO state
cache. So we wouldn't need to perform reading from the config register and
accidentally clear pending GPI events in order to update these fields
values.

Note In case of GPIOs being available we can't reset the core otherwise
the GPIO configs will be reset to the initial state too. Instead we
suggest to at least restore the DMA/MAC registers to the initial state,
when the software reset were supposed to happen.

Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
---
 .../ethernet/stmicro/stmmac.rst               |   4 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   2 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h  |   1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.c    |   2 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  14 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  19 +
 .../net/ethernet/stmicro/stmmac/stmmac_gpio.c | 400 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  22 +-
 .../ethernet/stmicro/stmmac/stmmac_platform.c |   5 +
 include/linux/stmmac.h                        |   1 +
 11 files changed, 470 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_gpio.c

diff --git a/Documentation/networking/device_drivers/ethernet/stmicro/stmmac.rst b/Documentation/networking/device_drivers/ethernet/stmicro/stmmac.rst
index 5d46e5036129..c0e6f1e7538c 100644
--- a/Documentation/networking/device_drivers/ethernet/stmicro/stmmac.rst
+++ b/Documentation/networking/device_drivers/ethernet/stmicro/stmmac.rst
@@ -495,6 +495,10 @@ is used to configure the AMBA bridge to generate more efficient STBus traffic::
 
         int has_xgmac;
 
+37) Total number of supported GPIOs::
+
+        u32 ngpios;
+
 ::
 
     }
diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index 53f14c5a9e02..1d34672d4501 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -9,6 +9,8 @@ config STMMAC_ETH
 	select CRC32
 	imply PTP_1588_CLOCK
 	select RESET_CONTROLLER
+	select GPIOLIB
+	select GPIOLIB_IRQCHIP
 	help
 	  This is the driver for the Ethernet IPs built around a
 	  Synopsys IP Core.
diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index 24e6145d4eae..71a59b513381 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -6,7 +6,7 @@ stmmac-objs:= stmmac_main.o stmmac_ethtool.o stmmac_mdio.o ring_mode.o	\
 	      mmc_core.o stmmac_hwtstamp.o stmmac_ptp.o dwmac4_descs.o	\
 	      dwmac4_dma.o dwmac4_lib.o dwmac4_core.o dwmac5.o hwif.o \
 	      stmmac_tc.o dwxgmac2_core.o dwxgmac2_dma.o dwxgmac2_descs.o \
-	      $(stmmac-y)
+	      stmmac_gpio.o $(stmmac-y)
 
 stmmac-$(CONFIG_STMMAC_SELFTESTS) += stmmac_selftests.o
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 6f271c46368d..7d18ab71edd1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -466,6 +466,7 @@ struct mac_device_info {
 	const struct stmmac_hwtimestamp *ptp;
 	const struct stmmac_tc_ops *tc;
 	const struct stmmac_mmc_ops *mmc;
+	const struct stmmac_gpio_ops *gpio;
 	const struct mdio_xpcs_ops *xpcs;
 	struct mdio_xpcs_args xpcs_args;
 	struct mii_regs mii;	/* MII register Addresses */
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
index bb7114f970f8..067420059c11 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
@@ -101,6 +101,7 @@ static const struct stmmac_hwif_entry {
 	const void *mode;
 	const void *tc;
 	const void *mmc;
+	const void *gpio;
 	int (*setup)(struct stmmac_priv *priv);
 	int (*quirks)(struct stmmac_priv *priv);
 } stmmac_hw[] = {
@@ -319,6 +320,7 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 		mac->mode = mac->mode ? : entry->mode;
 		mac->tc = mac->tc ? : entry->tc;
 		mac->mmc = mac->mmc ? : entry->mmc;
+		mac->gpio = mac->gpio ? : entry->gpio;
 
 		priv->hw = mac;
 		priv->ptpaddr = priv->ioaddr + entry->regs.ptp_off;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index fc26169e24f8..99c5841f1060 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -626,6 +626,20 @@ struct stmmac_mmc_ops {
 #define stmmac_mmc_read(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mmc, read, __args)
 
+/* Helpers for multi-core GPIO settings access */
+struct stmmac_gpio_ops {
+	void (*set_ctrl)(struct stmmac_priv *priv, u32 gpie, u32 gpit, u32 gpo);
+	void (*get_ctrl)(struct stmmac_priv *priv, u32 *gpie, u32 *gpit, u32 *gpo);
+	int (*get_gpi)(struct stmmac_priv *priv);
+};
+
+#define stmmac_gpio_set_ctrl(__priv, __args...) \
+	stmmac_do_void_callback(__priv, gpio, set_ctrl, priv, __args)
+#define stmmac_gpio_get_ctrl(__priv, __args...) \
+	stmmac_do_void_callback(__priv, gpio, get_ctrl, priv, __args)
+#define stmmac_gpio_get_gpi(__priv) \
+	stmmac_do_callback(__priv, gpio, get_gpi, priv)
+
 /* XPCS callbacks */
 #define stmmac_xpcs_validate(__priv, __args...) \
 	stmmac_do_callback(__priv, xpcs, validate, __args)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index c993dcd1c7d9..c5b1150e2f66 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -22,6 +22,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/net_tstamp.h>
 #include <linux/reset.h>
+#include <linux/gpio/driver.h>
 #include <net/page_pool.h>
 
 struct stmmac_resources {
@@ -97,6 +98,18 @@ struct stmmac_channel {
 	u32 index;
 };
 
+struct stmmac_gpio {
+	struct gpio_chip gc;
+	u32 ngpis;
+	u32 ngpos;
+	struct {
+		u32 gpie;
+		u32 gpit;
+		u32 gpo;
+	} cache;
+	spinlock_t lock;
+};
+
 struct stmmac_tc_entry {
 	bool in_use;
 	bool in_hw;
@@ -231,6 +244,9 @@ struct stmmac_priv {
 	struct workqueue_struct *wq;
 	struct work_struct service_task;
 
+	/* General Purpose IO */
+	struct stmmac_gpio gpio;
+
 	/* TC Handling */
 	unsigned int tc_entries_max;
 	unsigned int tc_off_max;
@@ -250,6 +266,9 @@ enum stmmac_state {
 	STMMAC_RESET_REQUESTED,
 };
 
+int stmmac_gpio_add(struct stmmac_priv *priv);
+bool stmmac_gpio_interrupt(struct stmmac_priv *priv);
+void stmmac_gpio_remove(struct stmmac_priv *priv);
 int stmmac_mdio_unregister(struct net_device *ndev);
 int stmmac_mdio_register(struct net_device *ndev);
 int stmmac_mdio_reset(struct mii_bus *mii);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_gpio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_gpio.c
new file mode 100644
index 000000000000..101e934a382b
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_gpio.c
@@ -0,0 +1,400 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*******************************************************************************
+  STMMAC Ethernet Driver -- GPI/GPO ports implementation
+
+  Copyright (C) 2020 BAIKAL ELECTRONICS, JSC
+
+  Author: Serge Semin <Sergey.Semin@baikalelectronics.ru>
+  Maintainer: Giuseppe Cavallaro <peppe.cavallaro@st.com>
+*******************************************************************************/
+
+#include <linux/bitfield.h>
+#include <linux/bitops.h>
+#include <linux/device.h>
+#include <linux/gpio/driver.h>
+#include <linux/irq.h>
+#include <linux/stmmac.h>
+
+#include "common.h"
+#include "hwif.h"
+#include "stmmac.h"
+
+/* Synopsys DesignWare Ethernet controllers can be synthesized with
+ * General-Purpose IOs support. GPIOs can work either as inputs or as
+ * outputs thus belong to the gpi_i and gpo_o ports respectively.
+ * The ports width (number of possible inputs/outputs) and the configuration
+ * registers layout depend on the IP-core version. For instance, DW GMAC can
+ * have from 0 to 4 GPIs and from 0 to 4 GPOs, while DW xGMAC have a wider
+ * ports width up to 16 pins of each one.
+ *
+ * Note 1. DW Ethernet IP-core GPIs implementation is a bit weird. First of all
+ * the GPIs state is multiplexed with the edge-triggered interrupt status in
+ * the GPIO control/status register. That is in case of the falling or rising
+ * edge event the GPI status register field gets to preserve the latched state
+ * of the input pin until the next read from the register. So in order to read
+ * the actual state of the input pin we'd need to read the GPIO status register
+ * twice. But that also cause the race condition from the GPI IRQ handler and
+ * the GPIs get state callback to the GPI state field value, which alas can't
+ * be resolved. So it's highly recommended to use all the DW *MAC GPIs either
+ * as just inputs or as the source of IRQs.
+ *
+ * Note 2. Moreover the GPIs state configuration fields are mapped either to
+ * the GPIO control or the GPIO status register, which other than that also
+ * provides the settings like GPOs state, GPIs IRQ type/mask/unmask. Due to
+ * that we have no choice but to cache the registers state and use the cached
+ * values to update the denoted settings, so to prevent the racy reads of the
+ * GPIs.
+ *
+ * Note 3. Due to the multiplexed GPIs state and interrupt status, the
+ * driver may experience false repeated IRQs detection. That is if after
+ * reading the GPI status register and calling the interrupt handler a client
+ * device doesn't revert the IRQ lane state and some other GPI raises an
+ * interrupt, the driver will get to detect the previous IRQ again. Alas we
+ * can't do much about it, but to have a hardware designed in a way so the
+ * device causing the IRQs would get the input pin state back after the IRQ
+ * is handled.
+ *
+ * Note 4. The GPIOs state is cleared together with the DW *MAC controller
+ * reset. So if IP-core isn't fixed to prevent that behavior the core resets
+ * mustn't be performed to have a stable GPIs/GPOs interface.
+ */
+
+static void stmmac_gpio_irq_mask(struct irq_data *d)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct stmmac_priv *priv = gpiochip_get_data(gc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->gpio.lock, flags);
+	priv->gpio.cache.gpie &= ~BIT(irqd_to_hwirq(d));
+	stmmac_gpio_set_ctrl(priv, priv->gpio.cache.gpie,
+			     priv->gpio.cache.gpit, priv->gpio.cache.gpo);
+	spin_unlock_irqrestore(&priv->gpio.lock, flags);
+}
+
+static void stmmac_gpio_irq_unmask(struct irq_data *d)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct stmmac_priv *priv = gpiochip_get_data(gc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->gpio.lock, flags);
+	priv->gpio.cache.gpie |= BIT(irqd_to_hwirq(d));
+	stmmac_gpio_set_ctrl(priv, priv->gpio.cache.gpie,
+			     priv->gpio.cache.gpit, priv->gpio.cache.gpo);
+	spin_unlock_irqrestore(&priv->gpio.lock, flags);
+}
+
+static int stmmac_gpio_irq_set_type(struct irq_data *d, u32 type)
+{
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct stmmac_priv *priv = gpiochip_get_data(gc);
+	irq_hw_number_t offset = irqd_to_hwirq(d);
+	unsigned long flags;
+	int ret = 0;
+
+	if (offset >= priv->gpio.ngpis)
+		return -EINVAL;
+
+	spin_lock_irqsave(&priv->gpio.lock, flags);
+
+	switch (type) {
+	case IRQ_TYPE_EDGE_RISING:
+		priv->gpio.cache.gpit &= ~BIT(offset);
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		priv->gpio.cache.gpit |= BIT(offset);
+		break;
+	default:
+		ret = -EINVAL;
+		goto err_unlock;
+	}
+
+	stmmac_gpio_set_ctrl(priv, priv->gpio.cache.gpie,
+			     priv->gpio.cache.gpit, priv->gpio.cache.gpo);
+
+err_unlock:
+	spin_unlock_irqrestore(&priv->gpio.lock, flags);
+
+	return ret;
+}
+
+/**
+ * stmmac_gpio_interrupt - handle DW MAC GPIO interrupt
+ * @ndev: driver private structure
+ * Description: checks the latched-low and -high events status for each GPIs
+ * detected in the MAC and raises the generic IRQ-chip handler.
+ * Return:
+ * returns true if any enabled event has been detected, false otherwise.
+ */
+bool stmmac_gpio_interrupt(struct stmmac_priv *priv)
+{
+	struct gpio_chip *gc = &priv->gpio.gc;
+	irq_hw_number_t hwirq;
+	unsigned long status;
+
+	/* Make sure we get to handle only the GPIs with unmasked
+	 * latched-low/-high events and the GPI is latched in accordance with
+	 * the type of the event. If for some reason the IRQ cause hasn't been
+	 * cleared on the previous IRQ handler execution or the client device
+	 * hasn't got the GPI state back, here we'll get a repeated false IRQ.
+	 */
+	spin_lock(&priv->gpio.lock);
+
+	status = stmmac_gpio_get_gpi(priv) ^ priv->gpio.cache.gpit;
+	status &= priv->gpio.cache.gpie;
+
+	spin_unlock(&priv->gpio.lock);
+
+	for_each_set_bit(hwirq, &status, priv->gpio.ngpis)
+		generic_handle_irq(irq_find_mapping(gc->irq.domain, hwirq));
+
+	return !!status;
+}
+
+static int stmmac_gpio_get_direction(struct gpio_chip *gc, unsigned int offset)
+{
+	struct stmmac_priv *priv = gpiochip_get_data(gc);
+
+	if (offset < priv->gpio.ngpis)
+		return  GPIO_LINE_DIRECTION_IN;
+	else if (offset < priv->plat->ngpios)
+		return GPIO_LINE_DIRECTION_OUT;
+
+	return -EINVAL;
+}
+
+static int stmmac_gpio_direction_input(struct gpio_chip *gc, unsigned int offset)
+{
+	struct stmmac_priv *priv = gpiochip_get_data(gc);
+
+	if (offset >= priv->gpio.ngpis)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int stmmac_gpio_direction_output(struct gpio_chip *gc, unsigned int offset,
+					int value)
+{
+	struct stmmac_priv *priv = gpiochip_get_data(gc);
+
+	if (offset < priv->gpio.ngpis || offset >= priv->plat->ngpios)
+		return -EINVAL;
+
+	gc->set(gc, offset, value);
+
+	return 0;
+}
+
+static int stmmac_gpio_get(struct gpio_chip *gc, unsigned int offset)
+{
+	struct stmmac_priv *priv = gpiochip_get_data(gc);
+	unsigned long flags;
+	int ret;
+
+	if (offset >= priv->plat->ngpios)
+		return -EINVAL;
+
+	spin_lock_irqsave(&priv->gpio.lock, flags);
+
+	if (offset < priv->gpio.ngpis) {
+		if (priv->gpio.cache.gpie)
+			dev_warn_once(priv->device,
+				      "Reading GPIs may cause IRQ missing\n");
+
+		/* Read twice to clear the latched state out and get the
+		 * current input pin state.
+		 */
+		(void)stmmac_gpio_get_gpi(priv);
+		ret = stmmac_gpio_get_gpi(priv);
+	} else {
+		offset -= priv->gpio.ngpis;
+		ret = priv->gpio.cache.gpo;
+	}
+
+	spin_unlock_irqrestore(&priv->gpio.lock, flags);
+
+	return !!(ret & BIT(offset));
+}
+
+static int stmmac_gpio_get_multiple(struct gpio_chip *gc, unsigned long *mask,
+				    unsigned long *bits)
+{
+	struct stmmac_priv *priv = gpiochip_get_data(gc);
+	unsigned long flags, fs, val = 0;
+
+	fs = __ffs(*mask);
+
+	spin_lock_irqsave(&priv->gpio.lock, flags);
+
+	if (fs <= priv->gpio.ngpis) {
+		if (priv->gpio.cache.gpie)
+			dev_warn_once(priv->device,
+				      "Reading GPIs may cause IRQ missing\n");
+
+		/* Read twice to clear the latched state out and get the
+		 * current input pin state.
+		 */
+		(void)stmmac_gpio_get_gpi(priv);
+		val = stmmac_gpio_get_gpi(priv);
+	}
+
+	val |= (priv->gpio.cache.gpo << priv->gpio.ngpis);
+
+	spin_unlock_irqrestore(&priv->gpio.lock, flags);
+
+	bitmap_replace(bits, bits, &val, mask, priv->plat->ngpios);
+
+	return 0;
+}
+
+static void stmmac_gpio_set(struct gpio_chip *gc, unsigned int offset, int value)
+{
+	struct stmmac_priv *priv = gpiochip_get_data(gc);
+	unsigned long flags;
+
+	if (offset < priv->gpio.ngpis || offset >= priv->plat->ngpios)
+		return;
+
+	offset -= priv->gpio.ngpis;
+
+	spin_lock_irqsave(&priv->gpio.lock, flags);
+
+	if (value)
+		priv->gpio.cache.gpo |= BIT(offset);
+	else
+		priv->gpio.cache.gpo &= ~BIT(offset);
+
+	stmmac_gpio_set_ctrl(priv, priv->gpio.cache.gpie,
+			     priv->gpio.cache.gpit, priv->gpio.cache.gpo);
+
+	spin_unlock_irqrestore(&priv->gpio.lock, flags);
+}
+
+static void stmmac_gpio_set_multiple(struct gpio_chip *gc, unsigned long *mask,
+				     unsigned long *bits)
+{
+	struct stmmac_priv *priv = gpiochip_get_data(gc);
+	unsigned long flags, gpom, gpob;
+
+	gpom = *mask >> priv->gpio.ngpis;
+	gpob = *bits >> priv->gpio.ngpis;
+
+	spin_lock_irqsave(&priv->gpio.lock, flags);
+
+	priv->gpio.cache.gpo = (priv->gpio.cache.gpo & ~gpom) | gpob;
+
+	stmmac_gpio_set_ctrl(priv, priv->gpio.cache.gpie,
+			     priv->gpio.cache.gpit, priv->gpio.cache.gpo);
+
+	spin_unlock_irqrestore(&priv->gpio.lock, flags);
+}
+
+static int stmmac_gpio_data_init(struct stmmac_priv *priv)
+{
+	u32 tmp;
+
+	/* GPIs auto-detection: save GPO state, set as many GPI type bits
+	 * as possible, then read the written value back. The number of set
+	 * bits will be the actual number of GPIs. Leave the GPI type field
+	 * being initialized with ones (i.e. the inputs having latched-low
+	 * type) to have the falling-edge IRQs by default.
+	 */
+	priv->gpio.cache.gpit = ~0;
+	stmmac_gpio_get_ctrl(priv, &tmp, &tmp, &priv->gpio.cache.gpo);
+	stmmac_gpio_set_ctrl(priv, priv->gpio.cache.gpie,
+			     priv->gpio.cache.gpit, priv->gpio.cache.gpo);
+	stmmac_gpio_get_ctrl(priv, &priv->gpio.cache.gpie,
+			     &priv->gpio.cache.gpit, &priv->gpio.cache.gpo);
+
+	priv->gpio.ngpis = hweight_long(priv->gpio.cache.gpit);
+
+	if (priv->gpio.ngpis > priv->plat->ngpios) {
+		dev_err(priv->device, "Invalid ngpios specified\n");
+		return -EINVAL;
+	}
+
+	priv->gpio.ngpos = priv->plat->ngpios - priv->gpio.ngpis;
+
+	spin_lock_init(&priv->gpio.lock);
+
+	dev_info(priv->device, "GPI: %u, GPO: %u\n", priv->gpio.ngpis,
+		 priv->gpio.ngpos);
+
+	return 0;
+}
+
+/**
+ * stmmac_gpio_add - add DW MAC GPIO chip
+ * @ndev: driver private structure
+ * Description: register GPIO-chip handling the DW *MAC GPIs and GPOs
+ * Return:
+ * returns 0 on success, otherwise errno.
+ */
+int stmmac_gpio_add(struct stmmac_priv *priv)
+{
+	struct gpio_chip *gc = &priv->gpio.gc;
+	struct gpio_irq_chip *girq = &gc->irq;
+	int ret;
+
+	if (!priv->plat->ngpios)
+		return 0;
+
+	ret = stmmac_gpio_data_init(priv);
+	if (ret)
+		return ret;
+
+	gc->label = dev_name(priv->device);
+	gc->parent = priv->device;
+	gc->owner = THIS_MODULE;
+	gc->base = -1;
+	gc->ngpio = priv->plat->ngpios;
+	gc->get_direction = stmmac_gpio_get_direction;
+	gc->direction_input = stmmac_gpio_direction_input;
+	gc->direction_output = stmmac_gpio_direction_output;
+	gc->get = stmmac_gpio_get;
+	gc->get_multiple = stmmac_gpio_get_multiple;
+	gc->set = stmmac_gpio_set;
+	gc->set_multiple = stmmac_gpio_set_multiple;
+
+	if (priv->gpio.ngpis) {
+		girq = &gc->irq;
+		girq->chip = devm_kzalloc(priv->device, sizeof(*girq->chip),
+					  GFP_KERNEL);
+		if (!girq->chip)
+			return -ENOMEM;
+
+		girq->chip->irq_ack = dummy_irq_chip.irq_ack;
+		girq->chip->irq_mask = stmmac_gpio_irq_mask;
+		girq->chip->irq_unmask = stmmac_gpio_irq_unmask;
+		girq->chip->irq_set_type = stmmac_gpio_irq_set_type;
+		girq->chip->name = dev_name(priv->device);
+		girq->chip->flags = IRQCHIP_MASK_ON_SUSPEND;
+
+		girq->handler = handle_edge_irq;
+		girq->default_type = IRQ_TYPE_NONE;
+		girq->num_parents = 0;
+		girq->parents = NULL;
+		girq->parent_handler = NULL;
+	}
+
+	ret = gpiochip_add_data(gc, priv);
+	if (ret)
+		dev_err(priv->device, "Failed to register GPIO-chip\n");
+
+	return ret;
+}
+
+/**
+ * stmmac_gpio_remove - remove DW MAC GPIO-chip
+ * @ndev: driver private structure
+ * Description: remove GPIO-chip registered for the DW *MAC GPIs and GPOs
+ */
+void stmmac_gpio_remove(struct stmmac_priv *priv)
+{
+	if (!priv->plat->ngpios)
+		return;
+
+	gpiochip_remove(&priv->gpio.gc);
+}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d75c851721f7..0e89bd6a10a1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1841,7 +1841,16 @@ static int stmmac_sw_reset(struct stmmac_priv *priv)
 	 */
 	disable_irq(priv->dev->irq);
 
-	ret = stmmac_reset(priv, priv->ioaddr);
+	/* In case of GPIOs being available we can't reset the core otherwise
+	 * GPOs will be reset to the initial state too. Instead let's at least
+	 * restore the DMA/MAC registers to the initial state.
+	 */
+	if (priv->plat->ngpios) {
+		ret = stmmac_core_clean(priv, priv->ioaddr) ?:
+		      stmmac_dma_clean(priv, priv->ioaddr);
+	} else {
+		ret = stmmac_reset(priv, priv->ioaddr);
+	}
 
 	/* Make sure all IRQs are disabled by default. Some DW MAC IP-cores
 	 * like early versions of DW GMAC have MAC and MMC interrupts enabled
@@ -4199,6 +4208,10 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 	u32 queue;
 	bool xmac;
 
+	/* To handle MAC GPIO interrupts */
+	if (priv->gpio.ngpis)
+		stmmac_gpio_interrupt(priv);
+
 	/* Check if adapter is up */
 	if (!stmmac_is_up(priv))
 		return IRQ_HANDLED;
@@ -5220,6 +5233,10 @@ int stmmac_dvr_probe(struct device *device,
 	if (ret)
 		goto error_request_irq;
 
+	ret = stmmac_gpio_add(priv);
+	if (ret)
+		goto error_gpio_add;
+
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI) {
 		/* MDIO bus Registration */
@@ -5268,6 +5285,8 @@ int stmmac_dvr_probe(struct device *device,
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
 error_mdio_register:
+	stmmac_gpio_remove(priv);
+error_gpio_add:
 	stmmac_free_irq(priv);
 error_request_irq:
 	stmmac_napi_del(ndev);
@@ -5306,6 +5325,7 @@ int stmmac_dvr_remove(struct device *dev)
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
+	stmmac_gpio_remove(priv);
 	stmmac_free_irq(priv);
 	reset_control_assert(priv->plat->stmmac_rst);
 	destroy_workqueue(priv->wq);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 7cbde9d99133..2a9952b64c31 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -566,6 +566,11 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
 	if (rc)
 		goto error_dma_cfg_alloc;
 
+	/* Retrieve total number of supported GPIOs from the STMMAC DT-node.
+	 * Amount of GPIs and GPOs will be auto-detected by the driver later.
+	 */
+	of_property_read_u32(np, "ngpios", &plat->ngpios);
+
 	/* All clocks are optional since the sub-drivers may use the platform
 	 * clocks pointers to preserve their own clock-descriptors.
 	 */
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index cec970adaf2e..35f7a59e730a 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -204,5 +204,6 @@ struct plat_stmmacenet_data {
 	bool vlan_fail_q_en;
 	u8 vlan_fail_q;
 	unsigned int eee_usecs_rate;
+	u32 ngpios;
 };
 #endif
-- 
2.29.2

