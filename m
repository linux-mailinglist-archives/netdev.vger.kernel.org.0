Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC2518DB7
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 18:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfEIQLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 12:11:19 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:44874 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfEIQLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 12:11:18 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x49GB3m2074541;
        Thu, 9 May 2019 11:11:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1557418263;
        bh=me+L0Kz+06bAJ8Ka92+cYhhFG8e+zOryoFMTqy46Abc=;
        h=From:To:CC:Subject:Date;
        b=pMz+0V4IX2oWT39ETs8Es33V0XxQXPVI58WLcJXlS789KS5B6Ur6mrL6P0I1oRXSc
         aY/urFRZvPs+dM2qNWxO8+4vRx/hGf7Pyf7xPryR+dN+hEF2nMZ7XaIr5JIkhFEI67
         v2LQswCnYqZc9YM8tga89fezWDfwdFkeSPHu9EGs=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x49GB3qi030224
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 9 May 2019 11:11:03 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 9 May
 2019 11:11:02 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 9 May 2019 11:11:02 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x49GB2gj003859;
        Thu, 9 May 2019 11:11:02 -0500
From:   Dan Murphy <dmurphy@ti.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH v12 1/5] can: m_can: Create a m_can platform framework
Date:   Thu, 9 May 2019 11:11:05 -0500
Message-ID: <20190509161109.10499-1-dmurphy@ti.com>
X-Mailer: git-send-email 2.21.0.5.gaeb582a983
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a m_can platform framework that peripheral
devices can register to and use common code and register sets.
The peripheral devices may provide read/write and configuration
support of the IP.

Acked-by: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
---

v12 - Update the m_can_read/write functions to create a backtrace if the callback
pointer is NULL. - https://lore.kernel.org/patchwork/patch/1052302/

v11 - Fixed final checkpatch issue add comment on needed skb queue as future
enhancement - https://lore.kernel.org/patchwork/patch/1051179/
v10 - Fixed misspelled peripheral, moved index declaration, and added back stop
queue on TX_BUSY in hard_xmit - https://lore.kernel.org/patchwork/patch/1050487/
v9 - Added back the CSR clearing as this is needed for TCAN device, fixed clean
function to clean index for version > 30, removed extra skb free and fixed work
handler to handle FIFO full for perpheral devices - https://lore.kernel.org/patchwork/patch/1050120/
v8 - Added a clean function for the tx_skb, cleaned up skb on BUS_OFF and on xmit
BUSY - https://lore.kernel.org/patchwork/patch/1047980/
v7 - Fixed remaining new checkpatch issues, removed CSR setting, fixed tx hard
start function to return tx_busy, and renamed device callbacks - https://lore.kernel.org/patchwork/patch/1047220/
v6 - Squashed platform patch to this patch for bissectablity, fixed coding style
issues, updated Kconfig help, placed mcan reg offsets back into c file, renamed
priv->skb to priv->tx_skb and cleared perp interrupts at ISR start -
Patch 1 comments - https://lore.kernel.org/patchwork/patch/1042446/
Patch 2 comments - https://lore.kernel.org/patchwork/patch/1042442/

 drivers/net/can/m_can/Kconfig          |  13 +-
 drivers/net/can/m_can/Makefile         |   1 +
 drivers/net/can/m_can/m_can.c          | 723 +++++++++++++------------
 drivers/net/can/m_can/m_can.h          | 110 ++++
 drivers/net/can/m_can/m_can_platform.c | 202 +++++++
 5 files changed, 704 insertions(+), 345 deletions(-)
 create mode 100644 drivers/net/can/m_can/m_can.h
 create mode 100644 drivers/net/can/m_can/m_can_platform.c

diff --git a/drivers/net/can/m_can/Kconfig b/drivers/net/can/m_can/Kconfig
index 04f20dd39007..f7119fd72df4 100644
--- a/drivers/net/can/m_can/Kconfig
+++ b/drivers/net/can/m_can/Kconfig
@@ -1,5 +1,14 @@
 config CAN_M_CAN
+	tristate "Bosch M_CAN support"
+	---help---
+	  Say Y here if you want support for Bosch M_CAN controller framework.
+	  This is common support for devices that embed the Bosch M_CAN IP.
+
+config CAN_M_CAN_PLATFORM
+	tristate "Bosch M_CAN support for io-mapped devices"
 	depends on HAS_IOMEM
-	tristate "Bosch M_CAN devices"
+	depends on CAN_M_CAN
 	---help---
-	  Say Y here if you want to support for Bosch M_CAN controller.
+	  Say Y here if you want support for IO Mapped Bosch M_CAN controller.
+	  This support is for devices that have the Bosch M_CAN controller
+	  IP embedded into the device and the IP is IO Mapped to the processor.
diff --git a/drivers/net/can/m_can/Makefile b/drivers/net/can/m_can/Makefile
index 8bbd7f24f5be..057bbcdb3c74 100644
--- a/drivers/net/can/m_can/Makefile
+++ b/drivers/net/can/m_can/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_CAN_M_CAN) += m_can.o
+obj-$(CONFIG_CAN_M_CAN_PLATFORM) += m_can_platform.o
diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 9b449400376b..5f88ff605341 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1,20 +1,14 @@
-/*
- * CAN bus driver for Bosch M_CAN controller
- *
- * Copyright (C) 2014 Freescale Semiconductor, Inc.
- *	Dong Aisheng <b29396@freescale.com>
- *
- * Bosch M_CAN user manual can be obtained from:
+// SPDX-License-Identifier: GPL-2.0
+// CAN bus driver for Bosch M_CAN controller
+// Copyright (C) 2014 Freescale Semiconductor, Inc.
+//      Dong Aisheng <b29396@freescale.com>
+// Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
+
+/* Bosch M_CAN user manual can be obtained from:
  * http://www.bosch-semiconductors.de/media/pdf_1/ipmodules_1/m_can/
  * mcan_users_manual_v302.pdf
- *
- * This file is licensed under the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
  */
 
-#include <linux/clk.h>
-#include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
@@ -28,11 +22,7 @@
 #include <linux/can/dev.h>
 #include <linux/pinctrl/consumer.h>
 
-/* napi related */
-#define M_CAN_NAPI_WEIGHT	64
-
-/* message ram configuration data length */
-#define MRAM_CFG_LEN	8
+#include "m_can.h"
 
 /* registers definition */
 enum m_can_reg {
@@ -86,28 +76,11 @@ enum m_can_reg {
 	M_CAN_TXEFA	= 0xf8,
 };
 
-/* m_can lec values */
-enum m_can_lec_type {
-	LEC_NO_ERROR = 0,
-	LEC_STUFF_ERROR,
-	LEC_FORM_ERROR,
-	LEC_ACK_ERROR,
-	LEC_BIT1_ERROR,
-	LEC_BIT0_ERROR,
-	LEC_CRC_ERROR,
-	LEC_UNUSED,
-};
+/* napi related */
+#define M_CAN_NAPI_WEIGHT	64
 
-enum m_can_mram_cfg {
-	MRAM_SIDF = 0,
-	MRAM_XIDF,
-	MRAM_RXF0,
-	MRAM_RXF1,
-	MRAM_RXB,
-	MRAM_TXE,
-	MRAM_TXB,
-	MRAM_CFG_NUM,
-};
+/* message ram configuration data length */
+#define MRAM_CFG_LEN	8
 
 /* Core Release Register (CREL) */
 #define CREL_REL_SHIFT		28
@@ -347,74 +320,69 @@ enum m_can_mram_cfg {
 #define TX_EVENT_MM_SHIFT	TX_BUF_MM_SHIFT
 #define TX_EVENT_MM_MASK	(0xff << TX_EVENT_MM_SHIFT)
 
-/* address offset and element number for each FIFO/Buffer in the Message RAM */
-struct mram_cfg {
-	u16 off;
-	u8  num;
-};
-
-/* m_can private data structure */
-struct m_can_priv {
-	struct can_priv can;	/* must be the first member */
-	struct napi_struct napi;
-	struct net_device *dev;
-	struct device *device;
-	struct clk *hclk;
-	struct clk *cclk;
-	void __iomem *base;
-	u32 irqstatus;
-	int version;
-
-	/* message ram configuration */
-	void __iomem *mram_base;
-	struct mram_cfg mcfg[MRAM_CFG_NUM];
-};
+static inline u32 m_can_read(struct m_can_priv *priv, enum m_can_reg reg)
+{
+	return priv->ops->read_reg(priv, reg);
+}
 
-static inline u32 m_can_read(const struct m_can_priv *priv, enum m_can_reg reg)
+static inline void m_can_write(struct m_can_priv *priv, enum m_can_reg reg,
+			       u32 val)
 {
-	return readl(priv->base + reg);
+	priv->ops->write_reg(priv, reg, val);
 }
 
-static inline void m_can_write(const struct m_can_priv *priv,
-			       enum m_can_reg reg, u32 val)
+static u32 m_can_fifo_read(struct m_can_priv *priv,
+			   u32 fgi, unsigned int offset)
 {
-	writel(val, priv->base + reg);
+	u32 addr_offset = priv->mcfg[MRAM_RXF0].off + fgi * RXF0_ELEMENT_SIZE +
+			  offset;
+
+	return priv->ops->read_fifo(priv, addr_offset);
 }
 
-static inline u32 m_can_fifo_read(const struct m_can_priv *priv,
-				  u32 fgi, unsigned int offset)
+static void m_can_fifo_write(struct m_can_priv *priv,
+			    u32 fpi, unsigned int offset, u32 val)
 {
-	return readl(priv->mram_base + priv->mcfg[MRAM_RXF0].off +
-		     fgi * RXF0_ELEMENT_SIZE + offset);
+	u32 addr_offset = priv->mcfg[MRAM_TXB].off + fpi * TXB_ELEMENT_SIZE +
+			  offset;
+
+	priv->ops->write_fifo(priv, addr_offset, val);
 }
 
-static inline void m_can_fifo_write(const struct m_can_priv *priv,
-				    u32 fpi, unsigned int offset, u32 val)
+static inline void m_can_fifo_write_no_off(struct m_can_priv *priv,
+				   u32 fpi, u32 val)
 {
-	writel(val, priv->mram_base + priv->mcfg[MRAM_TXB].off +
-	       fpi * TXB_ELEMENT_SIZE + offset);
+	priv->ops->write_fifo(priv, fpi, val);
 }
 
-static inline u32 m_can_txe_fifo_read(const struct m_can_priv *priv,
-				      u32 fgi,
-				      u32 offset) {
-	return readl(priv->mram_base + priv->mcfg[MRAM_TXE].off +
-			fgi * TXE_ELEMENT_SIZE + offset);
+static u32 m_can_txe_fifo_read(struct m_can_priv *priv, u32 fgi, u32 offset)
+{
+	u32 addr_offset = priv->mcfg[MRAM_TXE].off + fgi * TXE_ELEMENT_SIZE +
+			  offset;
+
+	return priv->ops->read_fifo(priv, addr_offset);
 }
 
-static inline bool m_can_tx_fifo_full(const struct m_can_priv *priv)
+static inline bool m_can_tx_fifo_full(struct m_can_priv *priv)
 {
 		return !!(m_can_read(priv, M_CAN_TXFQS) & TXFQS_TFQF);
 }
 
-static inline void m_can_config_endisable(const struct m_can_priv *priv,
-					  bool enable)
+void m_can_config_endisable(struct m_can_priv *priv, bool enable)
 {
 	u32 cccr = m_can_read(priv, M_CAN_CCCR);
 	u32 timeout = 10;
 	u32 val = 0;
 
+	/* Clear the Clock stop request if it was set */
+	if (cccr & CCCR_CSR)
+		cccr &= ~CCCR_CSR;
+
 	if (enable) {
+		/* Clear the Clock stop request if it was set */
+		if (cccr & CCCR_CSR)
+			cccr &= ~CCCR_CSR;
+
 		/* enable m_can configuration */
 		m_can_write(priv, M_CAN_CCCR, cccr | CCCR_INIT);
 		udelay(5);
@@ -430,7 +398,7 @@ static inline void m_can_config_endisable(const struct m_can_priv *priv,
 
 	while ((m_can_read(priv, M_CAN_CCCR) & (CCCR_INIT | CCCR_CCE)) != val) {
 		if (timeout == 0) {
-			netdev_warn(priv->dev, "Failed to init module\n");
+			netdev_warn(priv->net, "Failed to init module\n");
 			return;
 		}
 		timeout--;
@@ -438,17 +406,34 @@ static inline void m_can_config_endisable(const struct m_can_priv *priv,
 	}
 }
 
-static inline void m_can_enable_all_interrupts(const struct m_can_priv *priv)
+static inline void m_can_enable_all_interrupts(struct m_can_priv *priv)
 {
 	/* Only interrupt line 0 is used in this driver */
 	m_can_write(priv, M_CAN_ILE, ILE_EINT0);
 }
 
-static inline void m_can_disable_all_interrupts(const struct m_can_priv *priv)
+static inline void m_can_disable_all_interrupts(struct m_can_priv *priv)
 {
 	m_can_write(priv, M_CAN_ILE, 0x0);
 }
 
+static void m_can_clean(struct net_device *net)
+{
+	struct m_can_priv *priv = netdev_priv(net);
+
+	if (priv->tx_skb) {
+		int putidx = 0;
+
+		net->stats.tx_errors++;
+		if (priv->version > 30)
+			putidx = ((m_can_read(priv, M_CAN_TXFQS) &
+				   TXFQS_TFQPI_MASK) >> TXFQS_TFQPI_SHIFT);
+
+		can_free_echo_skb(priv->net, putidx);
+		priv->tx_skb = NULL;
+	}
+}
+
 static void m_can_read_fifo(struct net_device *dev, u32 rxfs)
 {
 	struct net_device_stats *stats = &dev->stats;
@@ -633,9 +618,12 @@ static int m_can_clk_start(struct m_can_priv *priv)
 {
 	int err;
 
-	err = pm_runtime_get_sync(priv->device);
+	if (priv->pm_clock_support == 0)
+		return 0;
+
+	err = pm_runtime_get_sync(priv->dev);
 	if (err < 0) {
-		pm_runtime_put_noidle(priv->device);
+		pm_runtime_put_noidle(priv->dev);
 		return err;
 	}
 
@@ -644,7 +632,8 @@ static int m_can_clk_start(struct m_can_priv *priv)
 
 static void m_can_clk_stop(struct m_can_priv *priv)
 {
-	pm_runtime_put_sync(priv->device);
+	if (priv->pm_clock_support)
+		pm_runtime_put_sync(priv->dev);
 }
 
 static int m_can_get_berr_counter(const struct net_device *dev,
@@ -811,9 +800,8 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 	return work_done;
 }
 
-static int m_can_poll(struct napi_struct *napi, int quota)
+static int m_can_rx_handler(struct net_device *dev, int quota)
 {
-	struct net_device *dev = napi->dev;
 	struct m_can_priv *priv = netdev_priv(dev);
 	int work_done = 0;
 	u32 irqstatus, psr;
@@ -831,13 +819,33 @@ static int m_can_poll(struct napi_struct *napi, int quota)
 
 	if (irqstatus & IR_RF0N)
 		work_done += m_can_do_rx_poll(dev, (quota - work_done));
+end:
+	return work_done;
+}
 
+static int m_can_rx_peripheral(struct net_device *dev)
+{
+	struct m_can_priv *priv = netdev_priv(dev);
+
+	m_can_rx_handler(dev, 1);
+
+	m_can_enable_all_interrupts(priv);
+
+	return 0;
+}
+
+static int m_can_poll(struct napi_struct *napi, int quota)
+{
+	struct net_device *dev = napi->dev;
+	struct m_can_priv *priv = netdev_priv(dev);
+	int work_done;
+
+	work_done = m_can_rx_handler(dev, quota);
 	if (work_done < quota) {
 		napi_complete_done(napi, work_done);
 		m_can_enable_all_interrupts(priv);
 	}
 
-end:
 	return work_done;
 }
 
@@ -894,6 +902,9 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	if (ir & IR_ALL_INT)
 		m_can_write(priv, M_CAN_IR, ir);
 
+	if (priv->ops->clear_interrupts)
+		priv->ops->clear_interrupts(priv);
+
 	/* schedule NAPI in case of
 	 * - rx IRQ
 	 * - state change IRQ
@@ -902,7 +913,10 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	if ((ir & IR_RF0N) || (ir & IR_ERR_ALL_30X)) {
 		priv->irqstatus = ir;
 		m_can_disable_all_interrupts(priv);
-		napi_schedule(&priv->napi);
+		if (!priv->is_peripheral)
+			napi_schedule(&priv->napi);
+		else
+			m_can_rx_peripheral(dev);
 	}
 
 	if (priv->version == 30) {
@@ -1155,6 +1169,9 @@ static void m_can_chip_config(struct net_device *dev)
 	m_can_set_bittiming(dev);
 
 	m_can_config_endisable(priv, false);
+
+	if (priv->ops->init)
+		priv->ops->init(priv);
 }
 
 static void m_can_start(struct net_device *dev)
@@ -1173,6 +1190,7 @@ static int m_can_set_mode(struct net_device *dev, enum can_mode mode)
 {
 	switch (mode) {
 	case CAN_MODE_START:
+		m_can_clean(dev);
 		m_can_start(dev);
 		netif_wake_queue(dev);
 		break;
@@ -1188,20 +1206,17 @@ static int m_can_set_mode(struct net_device *dev, enum can_mode mode)
  * else it returns the release and step coded as:
  * return value = 10 * <release> + 1 * <step>
  */
-static int m_can_check_core_release(void __iomem *m_can_base)
+static int m_can_check_core_release(struct m_can_priv *priv)
 {
 	u32 crel_reg;
 	u8 rel;
 	u8 step;
 	int res;
-	struct m_can_priv temp_priv = {
-		.base = m_can_base
-	};
 
 	/* Read Core Release Version and split into version number
 	 * Example: Version 3.2.1 => rel = 3; step = 2; substep = 1;
 	 */
-	crel_reg = m_can_read(&temp_priv, M_CAN_CREL);
+	crel_reg = m_can_read(priv, M_CAN_CREL);
 	rel = (u8)((crel_reg & CREL_REL_MASK) >> CREL_REL_SHIFT);
 	step = (u8)((crel_reg & CREL_STEP_MASK) >> CREL_STEP_SHIFT);
 
@@ -1219,18 +1234,26 @@ static int m_can_check_core_release(void __iomem *m_can_base)
 /* Selectable Non ISO support only in version 3.2.x
  * This function checks if the bit is writable.
  */
-static bool m_can_niso_supported(const struct m_can_priv *priv)
+static bool m_can_niso_supported(struct m_can_priv *priv)
 {
-	u32 cccr_reg, cccr_poll;
-	int niso_timeout;
+	u32 cccr_reg, cccr_poll = 0;
+	int niso_timeout = -ETIMEDOUT;
+	int i;
 
 	m_can_config_endisable(priv, true);
 	cccr_reg = m_can_read(priv, M_CAN_CCCR);
 	cccr_reg |= CCCR_NISO;
 	m_can_write(priv, M_CAN_CCCR, cccr_reg);
 
-	niso_timeout = readl_poll_timeout((priv->base + M_CAN_CCCR), cccr_poll,
-					  (cccr_poll == cccr_reg), 0, 10);
+	for (i = 0; i <= 10; i++) {
+		cccr_poll = m_can_read(priv, M_CAN_CCCR);
+		if (cccr_poll == cccr_reg) {
+			niso_timeout = 0;
+			break;
+		}
+
+		usleep_range(1, 5);
+	}
 
 	/* Clear NISO */
 	cccr_reg &= ~(CCCR_NISO);
@@ -1242,107 +1265,79 @@ static bool m_can_niso_supported(const struct m_can_priv *priv)
 	return !niso_timeout;
 }
 
-static int m_can_dev_setup(struct platform_device *pdev, struct net_device *dev,
-			   void __iomem *addr)
+static int m_can_dev_setup(struct m_can_priv *m_can_dev)
 {
-	struct m_can_priv *priv;
+	struct net_device *dev = m_can_dev->net;
 	int m_can_version;
 
-	m_can_version = m_can_check_core_release(addr);
+	m_can_version = m_can_check_core_release(m_can_dev);
 	/* return if unsupported version */
 	if (!m_can_version) {
-		dev_err(&pdev->dev, "Unsupported version number: %2d",
+		dev_err(m_can_dev->dev, "Unsupported version number: %2d",
 			m_can_version);
 		return -EINVAL;
 	}
 
-	priv = netdev_priv(dev);
-	netif_napi_add(dev, &priv->napi, m_can_poll, M_CAN_NAPI_WEIGHT);
+	if (!m_can_dev->is_peripheral)
+		netif_napi_add(dev, &m_can_dev->napi,
+			       m_can_poll, M_CAN_NAPI_WEIGHT);
 
 	/* Shared properties of all M_CAN versions */
-	priv->version = m_can_version;
-	priv->dev = dev;
-	priv->base = addr;
-	priv->can.do_set_mode = m_can_set_mode;
-	priv->can.do_get_berr_counter = m_can_get_berr_counter;
+	m_can_dev->version = m_can_version;
+	m_can_dev->can.do_set_mode = m_can_set_mode;
+	m_can_dev->can.do_get_berr_counter = m_can_get_berr_counter;
 
 	/* Set M_CAN supported operations */
-	priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
+	m_can_dev->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
 					CAN_CTRLMODE_LISTENONLY |
 					CAN_CTRLMODE_BERR_REPORTING |
 					CAN_CTRLMODE_FD;
 
 	/* Set properties depending on M_CAN version */
-	switch (priv->version) {
+	switch (m_can_dev->version) {
 	case 30:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.0.x */
 		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
-		priv->can.bittiming_const = &m_can_bittiming_const_30X;
-		priv->can.data_bittiming_const =
-				&m_can_data_bittiming_const_30X;
+		m_can_dev->can.bittiming_const = m_can_dev->bit_timing ?
+			m_can_dev->bit_timing : &m_can_bittiming_const_30X;
+
+		m_can_dev->can.data_bittiming_const = m_can_dev->data_timing ?
+						m_can_dev->data_timing :
+						&m_can_data_bittiming_const_30X;
 		break;
 	case 31:
 		/* CAN_CTRLMODE_FD_NON_ISO is fixed with M_CAN IP v3.1.x */
 		can_set_static_ctrlmode(dev, CAN_CTRLMODE_FD_NON_ISO);
-		priv->can.bittiming_const = &m_can_bittiming_const_31X;
-		priv->can.data_bittiming_const =
-				&m_can_data_bittiming_const_31X;
+		m_can_dev->can.bittiming_const = m_can_dev->bit_timing ?
+			m_can_dev->bit_timing : &m_can_bittiming_const_31X;
+
+		m_can_dev->can.data_bittiming_const = m_can_dev->data_timing ?
+						m_can_dev->data_timing :
+						&m_can_data_bittiming_const_31X;
 		break;
 	case 32:
-		priv->can.bittiming_const = &m_can_bittiming_const_31X;
-		priv->can.data_bittiming_const =
-				&m_can_data_bittiming_const_31X;
-		priv->can.ctrlmode_supported |= (m_can_niso_supported(priv)
+		m_can_dev->can.bittiming_const = m_can_dev->bit_timing ?
+			m_can_dev->bit_timing : &m_can_bittiming_const_31X;
+
+		m_can_dev->can.data_bittiming_const = m_can_dev->data_timing ?
+						m_can_dev->data_timing :
+						&m_can_data_bittiming_const_31X;
+
+		m_can_dev->can.ctrlmode_supported |=
+						(m_can_niso_supported(m_can_dev)
 						? CAN_CTRLMODE_FD_NON_ISO
 						: 0);
 		break;
 	default:
-		dev_err(&pdev->dev, "Unsupported version number: %2d",
-			priv->version);
+		dev_err(m_can_dev->dev, "Unsupported version number: %2d",
+			m_can_dev->version);
 		return -EINVAL;
 	}
 
-	return 0;
-}
-
-static int m_can_open(struct net_device *dev)
-{
-	struct m_can_priv *priv = netdev_priv(dev);
-	int err;
-
-	err = m_can_clk_start(priv);
-	if (err)
-		return err;
-
-	/* open the can device */
-	err = open_candev(dev);
-	if (err) {
-		netdev_err(dev, "failed to open can device\n");
-		goto exit_disable_clks;
-	}
-
-	/* register interrupt handler */
-	err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
-			  dev);
-	if (err < 0) {
-		netdev_err(dev, "failed to request interrupt\n");
-		goto exit_irq_fail;
-	}
-
-	/* start the m_can controller */
-	m_can_start(dev);
-
-	can_led_event(dev, CAN_LED_EVENT_OPEN);
-	napi_enable(&priv->napi);
-	netif_start_queue(dev);
+	if (m_can_dev->ops->init)
+		m_can_dev->ops->init(m_can_dev);
 
 	return 0;
-
-exit_irq_fail:
-	close_candev(dev);
-exit_disable_clks:
-	m_can_clk_stop(priv);
-	return err;
 }
 
 static void m_can_stop(struct net_device *dev)
@@ -1361,10 +1356,18 @@ static int m_can_close(struct net_device *dev)
 	struct m_can_priv *priv = netdev_priv(dev);
 
 	netif_stop_queue(dev);
-	napi_disable(&priv->napi);
+	if (!priv->is_peripheral)
+		napi_disable(&priv->napi);
 	m_can_stop(dev);
 	m_can_clk_stop(priv);
 	free_irq(dev->irq, dev);
+
+	if (priv->is_peripheral) {
+		priv->tx_skb = NULL;
+		destroy_workqueue(priv->tx_wq);
+		priv->tx_wq = NULL;
+	}
+
 	close_candev(dev);
 	can_led_event(dev, CAN_LED_EVENT_STOP);
 
@@ -1385,18 +1388,15 @@ static int m_can_next_echo_skb_occupied(struct net_device *dev, int putidx)
 	return !!priv->can.echo_skb[next_idx];
 }
 
-static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
-				    struct net_device *dev)
+static netdev_tx_t m_can_tx_handler(struct m_can_priv *priv)
 {
-	struct m_can_priv *priv = netdev_priv(dev);
-	struct canfd_frame *cf = (struct canfd_frame *)skb->data;
+	struct canfd_frame *cf = (struct canfd_frame *)priv->tx_skb->data;
+	struct net_device *dev = priv->net;
+	struct sk_buff *skb = priv->tx_skb;
 	u32 id, cccr, fdflags;
 	int i;
 	int putidx;
 
-	if (can_dropped_invalid_skb(dev, skb))
-		return NETDEV_TX_OK;
-
 	/* Generate ID field for TX buffer Element */
 	/* Common to all supported M_CAN versions */
 	if (cf->can_id & CAN_EFF_FLAG) {
@@ -1451,7 +1451,13 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 			netif_stop_queue(dev);
 			netdev_warn(dev,
 				    "TX queue active although FIFO is full.");
-			return NETDEV_TX_BUSY;
+			if (priv->is_peripheral) {
+				kfree_skb(skb);
+				dev->stats.tx_dropped++;
+				return NETDEV_TX_OK;
+			} else {
+				return NETDEV_TX_BUSY;
+			}
 		}
 
 		/* get put index for frame */
@@ -1492,14 +1498,119 @@ static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
 		m_can_write(priv, M_CAN_TXBAR, (1 << putidx));
 
 		/* stop network queue if fifo full */
-			if (m_can_tx_fifo_full(priv) ||
-			    m_can_next_echo_skb_occupied(dev, putidx))
-				netif_stop_queue(dev);
+		if (m_can_tx_fifo_full(priv) ||
+		    m_can_next_echo_skb_occupied(dev, putidx))
+			netif_stop_queue(dev);
 	}
 
 	return NETDEV_TX_OK;
 }
 
+static void m_can_tx_work_queue(struct work_struct *ws)
+{
+	struct m_can_priv *priv = container_of(ws, struct m_can_priv,
+						tx_work);
+	m_can_tx_handler(priv);
+	priv->tx_skb = NULL;
+}
+
+static netdev_tx_t m_can_start_xmit(struct sk_buff *skb,
+				    struct net_device *dev)
+{
+	struct m_can_priv *priv = netdev_priv(dev);
+
+	if (can_dropped_invalid_skb(dev, skb))
+		return NETDEV_TX_OK;
+
+	if (priv->is_peripheral) {
+		if (priv->tx_skb) {
+			netdev_err(dev, "hard_xmit called while tx busy\n");
+			return NETDEV_TX_BUSY;
+		}
+
+		if (priv->can.state == CAN_STATE_BUS_OFF) {
+			m_can_clean(dev);
+		} else {
+			/* Need to stop the queue to avoid numerous requests
+			 * from being sent.  Suggested improvement is to create
+			 * a queueing mechanism that will queue the skbs and
+			 * process them in order.
+			 */
+			priv->tx_skb = skb;
+			netif_stop_queue(priv->net);
+			queue_work(priv->tx_wq, &priv->tx_work);
+		}
+	} else {
+		priv->tx_skb = skb;
+		return m_can_tx_handler(priv);
+	}
+
+	return NETDEV_TX_OK;
+}
+
+static int m_can_open(struct net_device *dev)
+{
+	struct m_can_priv *priv = netdev_priv(dev);
+	int err;
+
+	err = m_can_clk_start(priv);
+	if (err)
+		return err;
+
+	/* open the can device */
+	err = open_candev(dev);
+	if (err) {
+		netdev_err(dev, "failed to open can device\n");
+		goto exit_disable_clks;
+	}
+
+	/* register interrupt handler */
+	if (priv->is_peripheral) {
+		priv->tx_skb = NULL;
+		priv->tx_wq = alloc_workqueue("mcan_wq",
+					      WQ_FREEZABLE | WQ_MEM_RECLAIM, 0);
+		if (!priv->tx_wq) {
+			err = -ENOMEM;
+			goto out_wq_fail;
+		}
+
+		INIT_WORK(&priv->tx_work, m_can_tx_work_queue);
+
+		err = request_threaded_irq(dev->irq, NULL, m_can_isr,
+					   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
+					   dev->name, dev);
+	} else {
+		err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
+				  dev);
+	}
+
+	if (err < 0) {
+		netdev_err(dev, "failed to request interrupt\n");
+		goto exit_irq_fail;
+	}
+
+	/* start the m_can controller */
+	m_can_start(dev);
+
+	can_led_event(dev, CAN_LED_EVENT_OPEN);
+
+	if (!priv->is_peripheral)
+		napi_enable(&priv->napi);
+
+	netif_start_queue(dev);
+
+	return 0;
+
+exit_irq_fail:
+	if (priv->is_peripheral)
+		destroy_workqueue(priv->tx_wq);
+out_wq_fail:
+	close_candev(dev);
+exit_disable_clks:
+	m_can_clk_stop(priv);
+	return err;
+}
+
 static const struct net_device_ops m_can_netdev_ops = {
 	.ndo_open = m_can_open,
 	.ndo_stop = m_can_close,
@@ -1515,20 +1626,6 @@ static int register_m_can_dev(struct net_device *dev)
 	return register_candev(dev);
 }
 
-static void m_can_init_ram(struct m_can_priv *priv)
-{
-	int end, i, start;
-
-	/* initialize the entire Message RAM in use to avoid possible
-	 * ECC/parity checksum errors when reading an uninitialized buffer
-	 */
-	start = priv->mcfg[MRAM_SIDF].off;
-	end = priv->mcfg[MRAM_TXB].off +
-		priv->mcfg[MRAM_TXB].num * TXB_ELEMENT_SIZE;
-	for (i = start; i < end; i += 4)
-		writel(0x0, priv->mram_base + i);
-}
-
 static void m_can_of_parse_mram(struct m_can_priv *priv,
 				const u32 *mram_config_vals)
 {
@@ -1556,9 +1653,8 @@ static void m_can_of_parse_mram(struct m_can_priv *priv,
 	priv->mcfg[MRAM_TXB].num = mram_config_vals[7] &
 			(TXBC_NDTB_MASK >> TXBC_NDTB_SHIFT);
 
-	dev_dbg(priv->device,
-		"mram_base %p sidf 0x%x %d xidf 0x%x %d rxf0 0x%x %d rxf1 0x%x %d rxb 0x%x %d txe 0x%x %d txb 0x%x %d\n",
-		priv->mram_base,
+	dev_dbg(priv->dev,
+		"sidf 0x%x %d xidf 0x%x %d rxf0 0x%x %d rxf1 0x%x %d rxb 0x%x %d txe 0x%x %d txb 0x%x %d\n",
 		priv->mcfg[MRAM_SIDF].off, priv->mcfg[MRAM_SIDF].num,
 		priv->mcfg[MRAM_XIDF].off, priv->mcfg[MRAM_XIDF].num,
 		priv->mcfg[MRAM_RXF0].off, priv->mcfg[MRAM_RXF0].num,
@@ -1566,63 +1662,55 @@ static void m_can_of_parse_mram(struct m_can_priv *priv,
 		priv->mcfg[MRAM_RXB].off, priv->mcfg[MRAM_RXB].num,
 		priv->mcfg[MRAM_TXE].off, priv->mcfg[MRAM_TXE].num,
 		priv->mcfg[MRAM_TXB].off, priv->mcfg[MRAM_TXB].num);
-
-	m_can_init_ram(priv);
 }
 
-static int m_can_plat_probe(struct platform_device *pdev)
+void m_can_init_ram(struct m_can_priv *priv)
 {
-	struct net_device *dev;
-	struct m_can_priv *priv;
-	struct resource *res;
-	void __iomem *addr;
-	void __iomem *mram_addr;
-	struct clk *hclk, *cclk;
-	int irq, ret;
-	struct device_node *np;
-	u32 mram_config_vals[MRAM_CFG_LEN];
-	u32 tx_fifo_size;
-
-	np = pdev->dev.of_node;
+	int end, i, start;
 
-	hclk = devm_clk_get(&pdev->dev, "hclk");
-	cclk = devm_clk_get(&pdev->dev, "cclk");
+	/* initialize the entire Message RAM in use to avoid possible
+	 * ECC/parity checksum errors when reading an uninitialized buffer
+	 */
+	start = priv->mcfg[MRAM_SIDF].off;
+	end = priv->mcfg[MRAM_TXB].off +
+		priv->mcfg[MRAM_TXB].num * TXB_ELEMENT_SIZE;
 
-	if (IS_ERR(hclk) || IS_ERR(cclk)) {
-		dev_err(&pdev->dev, "no clock found\n");
-		ret = -ENODEV;
-		goto failed_ret;
-	}
+	for (i = start; i < end; i += 4)
+		m_can_fifo_write_no_off(priv, i, 0x0);
+}
+EXPORT_SYMBOL_GPL(m_can_init_ram);
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "m_can");
-	addr = devm_ioremap_resource(&pdev->dev, res);
-	irq = platform_get_irq_byname(pdev, "int0");
+int m_can_class_get_clocks(struct m_can_priv *m_can_dev)
+{
+	int ret = 0;
 
-	if (IS_ERR(addr) || irq < 0) {
-		ret = -EINVAL;
-		goto failed_ret;
-	}
+	m_can_dev->hclk = devm_clk_get(m_can_dev->dev, "hclk");
+	m_can_dev->cclk = devm_clk_get(m_can_dev->dev, "cclk");
 
-	/* message ram could be shared */
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
-	if (!res) {
+	if (IS_ERR(m_can_dev->cclk)) {
+		dev_err(m_can_dev->dev, "no clock found\n");
 		ret = -ENODEV;
-		goto failed_ret;
 	}
 
-	mram_addr = devm_ioremap(&pdev->dev, res->start, resource_size(res));
-	if (!mram_addr) {
-		ret = -ENOMEM;
-		goto failed_ret;
-	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(m_can_class_get_clocks);
 
-	/* get message ram configuration */
-	ret = of_property_read_u32_array(np, "bosch,mram-cfg",
-					 mram_config_vals,
-					 sizeof(mram_config_vals) / 4);
+struct m_can_priv *m_can_class_allocate_dev(struct device *dev)
+{
+	struct m_can_priv *class_dev = NULL;
+	u32 mram_config_vals[MRAM_CFG_LEN];
+	struct net_device *net_dev;
+	u32 tx_fifo_size;
+	int ret;
+
+	ret = fwnode_property_read_u32_array(dev_fwnode(dev),
+					     "bosch,mram-cfg",
+					     mram_config_vals,
+					     sizeof(mram_config_vals) / 4);
 	if (ret) {
-		dev_err(&pdev->dev, "Could not get Message RAM configuration.");
-		goto failed_ret;
+		dev_err(dev, "Could not get Message RAM configuration.");
+		goto out;
 	}
 
 	/* Get TX FIFO size
@@ -1631,66 +1719,74 @@ static int m_can_plat_probe(struct platform_device *pdev)
 	tx_fifo_size = mram_config_vals[7];
 
 	/* allocate the m_can device */
-	dev = alloc_candev(sizeof(*priv), tx_fifo_size);
-	if (!dev) {
-		ret = -ENOMEM;
-		goto failed_ret;
+	net_dev = alloc_candev(sizeof(*class_dev), tx_fifo_size);
+	if (!net_dev) {
+		dev_err(dev, "Failed to allocate CAN device");
+		goto out;
 	}
 
-	priv = netdev_priv(dev);
-	dev->irq = irq;
-	priv->device = &pdev->dev;
-	priv->hclk = hclk;
-	priv->cclk = cclk;
-	priv->can.clock.freq = clk_get_rate(cclk);
-	priv->mram_base = mram_addr;
+	class_dev = netdev_priv(net_dev);
+	if (!class_dev) {
+		dev_err(dev, "Failed to init netdev private");
+		goto out;
+	}
 
-	platform_set_drvdata(pdev, dev);
-	SET_NETDEV_DEV(dev, &pdev->dev);
+	class_dev->net = net_dev;
+	class_dev->dev = dev;
+	SET_NETDEV_DEV(net_dev, dev);
 
-	/* Enable clocks. Necessary to read Core Release in order to determine
-	 * M_CAN version
-	 */
-	pm_runtime_enable(&pdev->dev);
-	ret = m_can_clk_start(priv);
-	if (ret)
-		goto pm_runtime_fail;
+	m_can_of_parse_mram(class_dev, mram_config_vals);
+out:
+	return class_dev;
+}
+EXPORT_SYMBOL_GPL(m_can_class_allocate_dev);
+
+int m_can_class_register(struct m_can_priv *m_can_dev)
+{
+	int ret;
 
-	ret = m_can_dev_setup(pdev, dev, addr);
+	if (m_can_dev->pm_clock_support) {
+		pm_runtime_enable(m_can_dev->dev);
+		ret = m_can_clk_start(m_can_dev);
+		if (ret)
+			goto pm_runtime_fail;
+	}
+
+	ret = m_can_dev_setup(m_can_dev);
 	if (ret)
 		goto clk_disable;
 
-	ret = register_m_can_dev(dev);
+	ret = register_m_can_dev(m_can_dev->net);
 	if (ret) {
-		dev_err(&pdev->dev, "registering %s failed (err=%d)\n",
-			KBUILD_MODNAME, ret);
+		dev_err(m_can_dev->dev, "registering %s failed (err=%d)\n",
+			m_can_dev->net->name, ret);
 		goto clk_disable;
 	}
 
-	m_can_of_parse_mram(priv, mram_config_vals);
-
-	devm_can_led_init(dev);
+	devm_can_led_init(m_can_dev->net);
 
-	of_can_transceiver(dev);
+	of_can_transceiver(m_can_dev->net);
 
-	dev_info(&pdev->dev, "%s device registered (irq=%d, version=%d)\n",
-		 KBUILD_MODNAME, dev->irq, priv->version);
+	dev_info(m_can_dev->dev, "%s device registered (irq=%d, version=%d)\n",
+		 KBUILD_MODNAME, m_can_dev->net->irq, m_can_dev->version);
 
 	/* Probe finished
 	 * Stop clocks. They will be reactivated once the M_CAN device is opened
 	 */
 clk_disable:
-	m_can_clk_stop(priv);
+	m_can_clk_stop(m_can_dev);
 pm_runtime_fail:
 	if (ret) {
-		pm_runtime_disable(&pdev->dev);
-		free_candev(dev);
+		if (m_can_dev->pm_clock_support)
+			pm_runtime_disable(m_can_dev->dev);
+		free_candev(m_can_dev->net);
 	}
-failed_ret:
+
 	return ret;
 }
+EXPORT_SYMBOL_GPL(m_can_class_register);
 
-static __maybe_unused int m_can_suspend(struct device *dev)
+int m_can_class_suspend(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct m_can_priv *priv = netdev_priv(ndev);
@@ -1708,8 +1804,9 @@ static __maybe_unused int m_can_suspend(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(m_can_class_suspend);
 
-static __maybe_unused int m_can_resume(struct device *dev)
+int m_can_class_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct m_can_priv *priv = netdev_priv(ndev);
@@ -1733,79 +1830,19 @@ static __maybe_unused int m_can_resume(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(m_can_class_resume);
 
-static void unregister_m_can_dev(struct net_device *dev)
+void m_can_class_unregister(struct m_can_priv *m_can_dev)
 {
-	unregister_candev(dev);
-}
+	unregister_candev(m_can_dev->net);
 
-static int m_can_plat_remove(struct platform_device *pdev)
-{
-	struct net_device *dev = platform_get_drvdata(pdev);
+	m_can_clk_stop(m_can_dev);
 
-	unregister_m_can_dev(dev);
-
-	pm_runtime_disable(&pdev->dev);
-
-	platform_set_drvdata(pdev, NULL);
-
-	free_candev(dev);
-
-	return 0;
-}
-
-static int __maybe_unused m_can_runtime_suspend(struct device *dev)
-{
-	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_priv *priv = netdev_priv(ndev);
-
-	clk_disable_unprepare(priv->cclk);
-	clk_disable_unprepare(priv->hclk);
-
-	return 0;
-}
-
-static int __maybe_unused m_can_runtime_resume(struct device *dev)
-{
-	struct net_device *ndev = dev_get_drvdata(dev);
-	struct m_can_priv *priv = netdev_priv(ndev);
-	int err;
-
-	err = clk_prepare_enable(priv->hclk);
-	if (err)
-		return err;
-
-	err = clk_prepare_enable(priv->cclk);
-	if (err)
-		clk_disable_unprepare(priv->hclk);
-
-	return err;
+	free_candev(m_can_dev->net);
 }
-
-static const struct dev_pm_ops m_can_pmops = {
-	SET_RUNTIME_PM_OPS(m_can_runtime_suspend,
-			   m_can_runtime_resume, NULL)
-	SET_SYSTEM_SLEEP_PM_OPS(m_can_suspend, m_can_resume)
-};
-
-static const struct of_device_id m_can_of_table[] = {
-	{ .compatible = "bosch,m_can", .data = NULL },
-	{ /* sentinel */ },
-};
-MODULE_DEVICE_TABLE(of, m_can_of_table);
-
-static struct platform_driver m_can_plat_driver = {
-	.driver = {
-		.name = KBUILD_MODNAME,
-		.of_match_table = m_can_of_table,
-		.pm     = &m_can_pmops,
-	},
-	.probe = m_can_plat_probe,
-	.remove = m_can_plat_remove,
-};
-
-module_platform_driver(m_can_plat_driver);
+EXPORT_SYMBOL_GPL(m_can_class_unregister);
 
 MODULE_AUTHOR("Dong Aisheng <b29396@freescale.com>");
+MODULE_AUTHOR("Dan Murphy <dmurphy@ti.com>");
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("CAN bus driver for Bosch M_CAN controller");
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
new file mode 100644
index 000000000000..5671f5423887
--- /dev/null
+++ b/drivers/net/can/m_can/m_can.h
@@ -0,0 +1,110 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* CAN bus driver for Bosch M_CAN controller
+ * Copyright (C) 2018 Texas Instruments Incorporated - http://www.ti.com/
+ */
+
+#ifndef _CAN_M_CAN_H_
+#define _CAN_M_CAN_H_
+
+#include <linux/can/core.h>
+#include <linux/can/led.h>
+#include <linux/completion.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/freezer.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/iopoll.h>
+#include <linux/can/dev.h>
+#include <linux/pinctrl/consumer.h>
+
+/* m_can lec values */
+enum m_can_lec_type {
+	LEC_NO_ERROR = 0,
+	LEC_STUFF_ERROR,
+	LEC_FORM_ERROR,
+	LEC_ACK_ERROR,
+	LEC_BIT1_ERROR,
+	LEC_BIT0_ERROR,
+	LEC_CRC_ERROR,
+	LEC_UNUSED,
+};
+
+enum m_can_mram_cfg {
+	MRAM_SIDF = 0,
+	MRAM_XIDF,
+	MRAM_RXF0,
+	MRAM_RXF1,
+	MRAM_RXB,
+	MRAM_TXE,
+	MRAM_TXB,
+	MRAM_CFG_NUM,
+};
+
+/* address offset and element number for each FIFO/Buffer in the Message RAM */
+struct mram_cfg {
+	u16 off;
+	u8  num;
+};
+
+struct m_can_priv;
+struct m_can_ops {
+	/* Device specific call backs */
+	int (*clear_interrupts)(struct m_can_priv *m_can_class);
+	u32 (*read_reg)(struct m_can_priv *m_can_class, int reg);
+	int (*write_reg)(struct m_can_priv *m_can_class, int reg, int val);
+	u32 (*read_fifo)(struct m_can_priv *m_can_class, int addr_offset);
+	int (*write_fifo)(struct m_can_priv *m_can_class, int addr_offset,
+			  int val);
+	int (*init)(struct m_can_priv *m_can_class);
+};
+
+struct m_can_priv {
+	struct can_priv can;
+	struct napi_struct napi;
+	struct net_device *net;
+	struct device *dev;
+	struct clk *hclk;
+	struct clk *cclk;
+
+	struct workqueue_struct *tx_wq;
+	struct work_struct tx_work;
+	struct sk_buff *tx_skb;
+
+	struct can_bittiming_const *bit_timing;
+	struct can_bittiming_const *data_timing;
+
+	struct m_can_ops *ops;
+
+	void *device_data;
+
+	int version;
+	int freq;
+	u32 irqstatus;
+
+	int pm_clock_support;
+	int is_peripheral;
+
+	struct mram_cfg mcfg[MRAM_CFG_NUM];
+};
+
+struct m_can_priv *m_can_class_allocate_dev(struct device *dev);
+int m_can_class_register(struct m_can_priv *m_can_dev);
+void m_can_class_unregister(struct m_can_priv *m_can_dev);
+int m_can_class_get_clocks(struct m_can_priv *m_can_dev);
+void m_can_init_ram(struct m_can_priv *priv);
+void m_can_config_endisable(struct m_can_priv *priv, bool enable);
+
+int m_can_class_suspend(struct device *dev);
+int m_can_class_resume(struct device *dev);
+#endif	/* _CAN_M_H_ */
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
new file mode 100644
index 000000000000..026053f62f77
--- /dev/null
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0
+// IOMapped CAN bus driver for Bosch M_CAN controller
+// Copyright (C) 2014 Freescale Semiconductor, Inc.
+//	Dong Aisheng <b29396@freescale.com>
+//
+// Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
+
+#include <linux/platform_device.h>
+
+#include "m_can.h"
+
+struct m_can_plat_priv {
+	void __iomem *base;
+	void __iomem *mram_base;
+};
+
+static u32 iomap_read_reg(struct m_can_priv *cdev, int reg)
+{
+	struct m_can_plat_priv *priv =
+			(struct m_can_plat_priv *)cdev->device_data;
+
+	return readl(priv->base + reg);
+}
+
+static u32 iomap_read_fifo(struct m_can_priv *cdev, int offset)
+{
+	struct m_can_plat_priv *priv =
+			(struct m_can_plat_priv *)cdev->device_data;
+
+	return readl(priv->mram_base + offset);
+}
+
+static int iomap_write_reg(struct m_can_priv *cdev, int reg, int val)
+{
+	struct m_can_plat_priv *priv =
+			(struct m_can_plat_priv *)cdev->device_data;
+
+	writel(val, priv->base + reg);
+
+	return 0;
+}
+
+static int iomap_write_fifo(struct m_can_priv *cdev, int offset, int val)
+{
+	struct m_can_plat_priv *priv =
+			(struct m_can_plat_priv *)cdev->device_data;
+
+	writel(val, priv->mram_base + offset);
+
+	return 0;
+}
+
+static struct m_can_ops m_can_plat_ops = {
+	.read_reg = iomap_read_reg,
+	.write_reg = iomap_write_reg,
+	.write_fifo = iomap_write_fifo,
+	.read_fifo = iomap_read_fifo,
+};
+
+static int m_can_plat_probe(struct platform_device *pdev)
+{
+	struct m_can_priv *mcan_class;
+	struct m_can_plat_priv *priv;
+	struct resource *res;
+	void __iomem *addr;
+	void __iomem *mram_addr;
+	int irq, ret = 0;
+
+	mcan_class = m_can_class_allocate_dev(&pdev->dev);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	mcan_class->device_data = priv;
+
+	m_can_class_get_clocks(mcan_class);
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "m_can");
+	addr = devm_ioremap_resource(&pdev->dev, res);
+	irq = platform_get_irq_byname(pdev, "int0");
+	if (IS_ERR(addr) || irq < 0) {
+		ret = -EINVAL;
+		goto failed_ret;
+	}
+
+	/* message ram could be shared */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "message_ram");
+	if (!res) {
+		ret = -ENODEV;
+		goto failed_ret;
+	}
+
+	mram_addr = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!mram_addr) {
+		ret = -ENOMEM;
+		goto failed_ret;
+	}
+
+	priv->base = addr;
+	priv->mram_base = mram_addr;
+
+	mcan_class->net->irq = irq;
+	mcan_class->pm_clock_support = 1;
+	mcan_class->can.clock.freq = clk_get_rate(mcan_class->cclk);
+	mcan_class->dev = &pdev->dev;
+
+	mcan_class->ops = &m_can_plat_ops;
+
+	mcan_class->is_peripheral = false;
+
+	platform_set_drvdata(pdev, mcan_class->dev);
+
+	m_can_init_ram(mcan_class);
+
+	ret = m_can_class_register(mcan_class);
+
+failed_ret:
+	return ret;
+}
+
+static __maybe_unused int m_can_suspend(struct device *dev)
+{
+	return m_can_class_suspend(dev);
+}
+
+static __maybe_unused int m_can_resume(struct device *dev)
+{
+	return m_can_class_resume(dev);
+}
+
+static int m_can_plat_remove(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+	struct m_can_priv *mcan_class = netdev_priv(dev);
+
+	m_can_class_unregister(mcan_class);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static int __maybe_unused m_can_runtime_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct m_can_priv *mcan_class = netdev_priv(ndev);
+
+	m_can_class_suspend(dev);
+
+	clk_disable_unprepare(mcan_class->cclk);
+	clk_disable_unprepare(mcan_class->hclk);
+
+	return 0;
+}
+
+static int __maybe_unused m_can_runtime_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct m_can_priv *mcan_class = netdev_priv(ndev);
+	int err;
+
+	err = clk_prepare_enable(mcan_class->hclk);
+	if (err)
+		return err;
+
+	err = clk_prepare_enable(mcan_class->cclk);
+	if (err)
+		clk_disable_unprepare(mcan_class->hclk);
+
+	m_can_class_resume(dev);
+
+	return err;
+}
+
+static const struct dev_pm_ops m_can_pmops = {
+	SET_RUNTIME_PM_OPS(m_can_runtime_suspend,
+			   m_can_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(m_can_suspend, m_can_resume)
+};
+
+static const struct of_device_id m_can_of_table[] = {
+	{ .compatible = "bosch,m_can", .data = NULL },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, m_can_of_table);
+
+static struct platform_driver m_can_plat_driver = {
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.of_match_table = m_can_of_table,
+		.pm     = &m_can_pmops,
+	},
+	.probe = m_can_plat_probe,
+	.remove = m_can_plat_remove,
+};
+
+module_platform_driver(m_can_plat_driver);
+
+MODULE_AUTHOR("Dong Aisheng <b29396@freescale.com>");
+MODULE_AUTHOR("Dan Murphy <dmurphy@ti.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("M_CAN driver for IO Mapped Bosch controllers");
-- 
2.21.0.5.gaeb582a983

