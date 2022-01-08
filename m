Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A82488676
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbiAHVod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbiAHVoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:44:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F915C0611FD
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:44:11 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVR-0004fq-Mr
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:44:09 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5BFD46D3AAC
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:55 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3B96D6D3A2F;
        Sat,  8 Jan 2022 21:43:49 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d172c68c;
        Sat, 8 Jan 2022 21:43:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>
Subject: [PATCH net-next 19/22] can: flexcan: add ethtool support to change rx-rtr setting during runtime
Date:   Sat,  8 Jan 2022 22:43:42 +0100
Message-Id: <20220108214345.1848470-20-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108214345.1848470-1-mkl@pengutronix.de>
References: <20220108214345.1848470-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a private flag to the flexcan driver to switch the
"rx-rtr" setting on and off.

"rx-rtr" on  - Receive RTR frames. (default)
               The CAN controller can and will receive RTR frames.

	       On some IP cores the controller cannot receive RTR
	       frames in the more performant "RX mailbox" mode and
	       will use "RX FIFO" mode instead.

"rx-rtr" off - Waive ability to receive RTR frames. (not supported on all IP cores)
               This mode activates the "RX mailbox mode" for better
	       performance, on some IP cores RTR frames cannot be
	       received anymore.

The "RX FIFO" mode uses a FIFO with a depth of 6 CAN frames.
The "RX mailbox" mode uses up to 62 mailboxes.

Link: https://lore.kernel.org/all/20220107193105.1699523-6-mkl@pengutronix.de
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Co-developed-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan/Makefile          |   1 +
 drivers/net/can/flexcan/flexcan-core.c    | 102 +-------------
 drivers/net/can/flexcan/flexcan-ethtool.c |  93 ++++++++++++
 drivers/net/can/flexcan/flexcan.h         | 163 ++++++++++++++++++++++
 4 files changed, 260 insertions(+), 99 deletions(-)
 create mode 100644 drivers/net/can/flexcan/flexcan-ethtool.c
 create mode 100644 drivers/net/can/flexcan/flexcan.h

diff --git a/drivers/net/can/flexcan/Makefile b/drivers/net/can/flexcan/Makefile
index 25dd1d12b866..89d5695c902e 100644
--- a/drivers/net/can/flexcan/Makefile
+++ b/drivers/net/can/flexcan/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_CAN_FLEXCAN) += flexcan.o
 
 flexcan-objs :=
 flexcan-objs += flexcan-core.o
+flexcan-objs += flexcan-ethtool.o
diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index 57cebc415661..0bff1884d5cc 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -15,7 +15,6 @@
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
 #include <linux/can/led.h>
-#include <linux/can/rx-offload.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/firmware/imx/sci.h>
@@ -33,6 +32,8 @@
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 
+#include "flexcan.h"
+
 #define DRV_NAME			"flexcan"
 
 /* 8 for RX fifo and 2 error handling */
@@ -206,59 +207,6 @@
 
 #define FLEXCAN_TIMEOUT_US		(250)
 
-/* FLEXCAN hardware feature flags
- *
- * Below is some version info we got:
- *    SOC   Version   IP-Version  Glitch- [TR]WRN_INT IRQ Err Memory err RTR rece-   FD Mode     MB
- *                                Filter? connected?  Passive detection  ption in MB Supported?
- * MCF5441X FlexCAN2  ?               no       yes        no       no       yes           no     16
- *    MX25  FlexCAN2  03.00.00.00     no        no        no       no        no           no     64
- *    MX28  FlexCAN2  03.00.04.00    yes       yes        no       no        no           no     64
- *    MX35  FlexCAN2  03.00.00.00     no        no        no       no        no           no     64
- *    MX53  FlexCAN2  03.00.00.00    yes        no        no       no        no           no     64
- *    MX6s  FlexCAN3  10.00.12.00    yes       yes        no       no       yes           no     64
- *    MX8QM FlexCAN3  03.00.23.00    yes       yes        no       no       yes          yes     64
- *    MX8MP FlexCAN3  03.00.17.01    yes       yes        no      yes       yes          yes     64
- *    VF610 FlexCAN3  ?               no       yes        no      yes       yes?          no     64
- *  LS1021A FlexCAN2  03.00.04.00     no       yes        no       no       yes           no     64
- *  LX2160A FlexCAN3  03.00.23.00     no       yes        no      yes       yes          yes     64
- *
- * Some SOCs do not have the RX_WARN & TX_WARN interrupt line connected.
- */
-
-/* [TR]WRN_INT not connected */
-#define FLEXCAN_QUIRK_BROKEN_WERR_STATE BIT(1)
- /* Disable RX FIFO Global mask */
-#define FLEXCAN_QUIRK_DISABLE_RXFG BIT(2)
-/* Enable EACEN and RRS bit in ctrl2 */
-#define FLEXCAN_QUIRK_ENABLE_EACEN_RRS  BIT(3)
-/* Disable non-correctable errors interrupt and freeze mode */
-#define FLEXCAN_QUIRK_DISABLE_MECR BIT(4)
-/* Use mailboxes (not FIFO) for RX path */
-#define FLEXCAN_QUIRK_USE_RX_MAILBOX BIT(5)
-/* No interrupt for error passive */
-#define FLEXCAN_QUIRK_BROKEN_PERR_STATE BIT(6)
-/* default to BE register access */
-#define FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN BIT(7)
-/* Setup stop mode with GPR to support wakeup */
-#define FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR BIT(8)
-/* Support CAN-FD mode */
-#define FLEXCAN_QUIRK_SUPPORT_FD BIT(9)
-/* support memory detection and correction */
-#define FLEXCAN_QUIRK_SUPPORT_ECC BIT(10)
-/* Setup stop mode with SCU firmware to support wakeup */
-#define FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW BIT(11)
-/* Setup 3 separate interrupts, main, boff and err */
-#define FLEXCAN_QUIRK_NR_IRQ_3 BIT(12)
-/* Setup 16 mailboxes */
-#define FLEXCAN_QUIRK_NR_MB_16 BIT(13)
-/* Device supports RX via mailboxes */
-#define FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX BIT(14)
-/* Device supports RTR reception via mailboxes */
-#define FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR BIT(15)
-/* Device supports RX via FIFO */
-#define FLEXCAN_QUIRK_SUPPPORT_RX_FIFO BIT(16)
-
 /* Structure of the message buffer */
 struct flexcan_mb {
 	u32 can_ctrl;
@@ -345,51 +293,6 @@ struct flexcan_regs {
 
 static_assert(sizeof(struct flexcan_regs) ==  0x4 * 18 + 0xfb8);
 
-struct flexcan_devtype_data {
-	u32 quirks;		/* quirks needed for different IP cores */
-};
-
-struct flexcan_stop_mode {
-	struct regmap *gpr;
-	u8 req_gpr;
-	u8 req_bit;
-};
-
-struct flexcan_priv {
-	struct can_priv can;
-	struct can_rx_offload offload;
-	struct device *dev;
-
-	struct flexcan_regs __iomem *regs;
-	struct flexcan_mb __iomem *tx_mb;
-	struct flexcan_mb __iomem *tx_mb_reserved;
-	u8 tx_mb_idx;
-	u8 mb_count;
-	u8 mb_size;
-	u8 clk_src;	/* clock source of CAN Protocol Engine */
-	u8 scu_idx;
-
-	u64 rx_mask;
-	u64 tx_mask;
-	u32 reg_ctrl_default;
-
-	struct clk *clk_ipg;
-	struct clk *clk_per;
-	struct flexcan_devtype_data devtype_data;
-	struct regulator *reg_xceiver;
-	struct flexcan_stop_mode stm;
-
-	int irq_boff;
-	int irq_err;
-
-	/* IPC handle when setup stop mode by System Controller firmware(scfw) */
-	struct imx_sc_ipc *sc_ipc_handle;
-
-	/* Read and Write APIs */
-	u32 (*read)(void __iomem *addr);
-	void (*write)(u32 val, void __iomem *addr);
-};
-
 static const struct flexcan_devtype_data fsl_mcf5441x_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_BROKEN_PERR_STATE |
 		FLEXCAN_QUIRK_NR_IRQ_3 | FLEXCAN_QUIRK_NR_MB_16 |
@@ -2219,6 +2122,7 @@ static int flexcan_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	dev->netdev_ops = &flexcan_netdev_ops;
+	flexcan_set_ethtool_ops(dev);
 	dev->irq = irq;
 	dev->flags |= IFF_ECHO;
 
diff --git a/drivers/net/can/flexcan/flexcan-ethtool.c b/drivers/net/can/flexcan/flexcan-ethtool.c
new file mode 100644
index 000000000000..d01347fbfaa9
--- /dev/null
+++ b/drivers/net/can/flexcan/flexcan-ethtool.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (c) 2022 Amarula Solutions, Dario Binacchi <dario.binacchi@amarulasolutions.com>
+ * Copyright (c) 2022 Pengutronix, Marc Kleine-Budde <kernel@pengutronix.de>
+ *
+ */
+
+#include <linux/can/dev.h>
+#include <linux/ethtool.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/platform_device.h>
+
+#include "flexcan.h"
+
+static const char flexcan_priv_flags_strings[][ETH_GSTRING_LEN] = {
+#define FLEXCAN_PRIV_FLAGS_RX_RTR BIT(0)
+	"rx-rtr",
+};
+
+static void
+flexcan_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
+{
+	switch (stringset) {
+	case ETH_SS_PRIV_FLAGS:
+		memcpy(data, flexcan_priv_flags_strings,
+		       sizeof(flexcan_priv_flags_strings));
+	}
+}
+
+static u32 flexcan_get_priv_flags(struct net_device *ndev)
+{
+	const struct flexcan_priv *priv = netdev_priv(ndev);
+	u32 priv_flags = 0;
+
+	if (flexcan_active_rx_rtr(priv))
+		priv_flags |= FLEXCAN_PRIV_FLAGS_RX_RTR;
+
+	return priv_flags;
+}
+
+static int flexcan_set_priv_flags(struct net_device *ndev, u32 priv_flags)
+{
+	struct flexcan_priv *priv = netdev_priv(ndev);
+	u32 quirks = priv->devtype_data.quirks;
+
+	if (priv_flags & FLEXCAN_PRIV_FLAGS_RX_RTR) {
+		if (flexcan_supports_rx_mailbox_rtr(priv))
+			quirks |= FLEXCAN_QUIRK_USE_RX_MAILBOX;
+		else if (flexcan_supports_rx_fifo(priv))
+			quirks &= ~FLEXCAN_QUIRK_USE_RX_MAILBOX;
+		else
+			quirks |= FLEXCAN_QUIRK_USE_RX_MAILBOX;
+	} else {
+		if (flexcan_supports_rx_mailbox(priv))
+			quirks |= FLEXCAN_QUIRK_USE_RX_MAILBOX;
+		else
+			quirks &= ~FLEXCAN_QUIRK_USE_RX_MAILBOX;
+	}
+
+	if (quirks != priv->devtype_data.quirks && netif_running(ndev))
+		return -EBUSY;
+
+	priv->devtype_data.quirks = quirks;
+
+	if (!(priv_flags & FLEXCAN_PRIV_FLAGS_RX_RTR) &&
+	    !flexcan_active_rx_rtr(priv))
+		netdev_info(ndev,
+			    "Activating RX mailbox mode, cannot receive RTR frames.\n");
+
+	return 0;
+}
+
+static int flexcan_get_sset_count(struct net_device *netdev, int sset)
+{
+	switch (sset) {
+	case ETH_SS_PRIV_FLAGS:
+		return ARRAY_SIZE(flexcan_priv_flags_strings);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static const struct ethtool_ops flexcan_ethtool_ops = {
+	.get_strings = flexcan_get_strings,
+	.get_priv_flags = flexcan_get_priv_flags,
+	.set_priv_flags = flexcan_set_priv_flags,
+	.get_sset_count = flexcan_get_sset_count,
+};
+
+void flexcan_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &flexcan_ethtool_ops;
+}
diff --git a/drivers/net/can/flexcan/flexcan.h b/drivers/net/can/flexcan/flexcan.h
new file mode 100644
index 000000000000..fccdff8b1f0f
--- /dev/null
+++ b/drivers/net/can/flexcan/flexcan.h
@@ -0,0 +1,163 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * flexcan.c - FLEXCAN CAN controller driver
+ *
+ * Copyright (c) 2005-2006 Varma Electronics Oy
+ * Copyright (c) 2009 Sascha Hauer, Pengutronix
+ * Copyright (c) 2010-2017 Pengutronix, Marc Kleine-Budde <kernel@pengutronix.de>
+ * Copyright (c) 2014 David Jander, Protonic Holland
+ * Copyright (C) 2022 Amarula Solutions, Dario Binacchi <dario.binacchi@amarulasolutions.com>
+ *
+ * Based on code originally by Andrey Volkov <avolkov@varma-el.com>
+ *
+ */
+
+#ifndef _FLEXCAN_H
+#define _FLEXCAN_H
+
+#include <linux/can/rx-offload.h>
+
+/* FLEXCAN hardware feature flags
+ *
+ * Below is some version info we got:
+ *    SOC   Version   IP-Version  Glitch- [TR]WRN_INT IRQ Err Memory err RTR rece-   FD Mode     MB
+ *                                Filter? connected?  Passive detection  ption in MB Supported?
+ * MCF5441X FlexCAN2  ?               no       yes        no       no       yes           no     16
+ *    MX25  FlexCAN2  03.00.00.00     no        no        no       no        no           no     64
+ *    MX28  FlexCAN2  03.00.04.00    yes       yes        no       no        no           no     64
+ *    MX35  FlexCAN2  03.00.00.00     no        no        no       no        no           no     64
+ *    MX53  FlexCAN2  03.00.00.00    yes        no        no       no        no           no     64
+ *    MX6s  FlexCAN3  10.00.12.00    yes       yes        no       no       yes           no     64
+ *    MX8QM FlexCAN3  03.00.23.00    yes       yes        no       no       yes          yes     64
+ *    MX8MP FlexCAN3  03.00.17.01    yes       yes        no      yes       yes          yes     64
+ *    VF610 FlexCAN3  ?               no       yes        no      yes       yes?          no     64
+ *  LS1021A FlexCAN2  03.00.04.00     no       yes        no       no       yes           no     64
+ *  LX2160A FlexCAN3  03.00.23.00     no       yes        no      yes       yes          yes     64
+ *
+ * Some SOCs do not have the RX_WARN & TX_WARN interrupt line connected.
+ */
+
+/* [TR]WRN_INT not connected */
+#define FLEXCAN_QUIRK_BROKEN_WERR_STATE BIT(1)
+ /* Disable RX FIFO Global mask */
+#define FLEXCAN_QUIRK_DISABLE_RXFG BIT(2)
+/* Enable EACEN and RRS bit in ctrl2 */
+#define FLEXCAN_QUIRK_ENABLE_EACEN_RRS  BIT(3)
+/* Disable non-correctable errors interrupt and freeze mode */
+#define FLEXCAN_QUIRK_DISABLE_MECR BIT(4)
+/* Use mailboxes (not FIFO) for RX path */
+#define FLEXCAN_QUIRK_USE_RX_MAILBOX BIT(5)
+/* No interrupt for error passive */
+#define FLEXCAN_QUIRK_BROKEN_PERR_STATE BIT(6)
+/* default to BE register access */
+#define FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN BIT(7)
+/* Setup stop mode with GPR to support wakeup */
+#define FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR BIT(8)
+/* Support CAN-FD mode */
+#define FLEXCAN_QUIRK_SUPPORT_FD BIT(9)
+/* support memory detection and correction */
+#define FLEXCAN_QUIRK_SUPPORT_ECC BIT(10)
+/* Setup stop mode with SCU firmware to support wakeup */
+#define FLEXCAN_QUIRK_SETUP_STOP_MODE_SCFW BIT(11)
+/* Setup 3 separate interrupts, main, boff and err */
+#define FLEXCAN_QUIRK_NR_IRQ_3 BIT(12)
+/* Setup 16 mailboxes */
+#define FLEXCAN_QUIRK_NR_MB_16 BIT(13)
+/* Device supports RX via mailboxes */
+#define FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX BIT(14)
+/* Device supports RTR reception via mailboxes */
+#define FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR BIT(15)
+/* Device supports RX via FIFO */
+#define FLEXCAN_QUIRK_SUPPPORT_RX_FIFO BIT(16)
+
+struct flexcan_devtype_data {
+	u32 quirks;		/* quirks needed for different IP cores */
+};
+
+struct flexcan_stop_mode {
+	struct regmap *gpr;
+	u8 req_gpr;
+	u8 req_bit;
+};
+
+struct flexcan_priv {
+	struct can_priv can;
+	struct can_rx_offload offload;
+	struct device *dev;
+
+	struct flexcan_regs __iomem *regs;
+	struct flexcan_mb __iomem *tx_mb;
+	struct flexcan_mb __iomem *tx_mb_reserved;
+	u8 tx_mb_idx;
+	u8 mb_count;
+	u8 mb_size;
+	u8 clk_src;	/* clock source of CAN Protocol Engine */
+	u8 scu_idx;
+
+	u64 rx_mask;
+	u64 tx_mask;
+	u32 reg_ctrl_default;
+
+	struct clk *clk_ipg;
+	struct clk *clk_per;
+	struct flexcan_devtype_data devtype_data;
+	struct regulator *reg_xceiver;
+	struct flexcan_stop_mode stm;
+
+	int irq_boff;
+	int irq_err;
+
+	/* IPC handle when setup stop mode by System Controller firmware(scfw) */
+	struct imx_sc_ipc *sc_ipc_handle;
+
+	/* Read and Write APIs */
+	u32 (*read)(void __iomem *addr);
+	void (*write)(u32 val, void __iomem *addr);
+};
+
+void flexcan_set_ethtool_ops(struct net_device *dev);
+
+static inline bool
+flexcan_supports_rx_mailbox(const struct flexcan_priv *priv)
+{
+	const u32 quirks = priv->devtype_data.quirks;
+
+	return quirks & FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX;
+}
+
+static inline bool
+flexcan_supports_rx_mailbox_rtr(const struct flexcan_priv *priv)
+{
+	const u32 quirks = priv->devtype_data.quirks;
+
+	return (quirks & (FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+			  FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR)) ==
+		(FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX |
+		 FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR);
+}
+
+static inline bool
+flexcan_supports_rx_fifo(const struct flexcan_priv *priv)
+{
+	const u32 quirks = priv->devtype_data.quirks;
+
+	return quirks & FLEXCAN_QUIRK_SUPPPORT_RX_FIFO;
+}
+
+static inline bool
+flexcan_active_rx_rtr(const struct flexcan_priv *priv)
+{
+	const u32 quirks = priv->devtype_data.quirks;
+
+	if (quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX) {
+		if (quirks & FLEXCAN_QUIRK_SUPPPORT_RX_MAILBOX_RTR)
+			return true;
+	} else {
+		/*  RX-FIFO is always RTR capable */
+		return true;
+	}
+
+	return false;
+}
+
+
+#endif /* _FLEXCAN_H */
-- 
2.34.1


