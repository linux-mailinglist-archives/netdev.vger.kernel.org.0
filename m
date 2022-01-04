Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DF5484245
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbiADNUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbiADNUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 08:20:51 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36430C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 05:20:51 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id b13so148390840edd.8
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 05:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x92F48qdygAQPuHSXvnlERxbW3P7rZ7paNpbbL8fdA8=;
        b=Lo798ZuRMRuckPy1lZyAuJ9aFuQxJKQgFRaFl4PdO+kxeSV4Bg2vhsWkkGysCjz8nJ
         4wUWBwynEf+qmUa9NLIHhXtQaRkejkbAUliduMBBmhboSGY4HyaMh4V8gN3FkJb3O17F
         il+ReC3YuDiMLZKjB3Rn9bdS2nXCsTrhU6uT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x92F48qdygAQPuHSXvnlERxbW3P7rZ7paNpbbL8fdA8=;
        b=29kLECffOqzHMpHx2akik+LcS9yzGXs/UehjIqdnGoQAdp8KZjjxKJvebz3smmoDMU
         cdYnPRqNhcPejTI4JpHc8fVA8VsdcbyTXXYhQRorfs3dxV49RQVWlSGJp6jfL4ZMrchv
         FPVB89Ppsnq5QmblyXbPEutz7eDq16y7ZzEI6lmXQUg+LVwjZXhYRu71NmZXTXKjVOhv
         MfNa1z9Jcwu97ufyn6zmSvGJ446TO+aOw/ktPdzVm4BT/VrDXfar5rgHvngwKbn2wxjh
         gSA+Jo2y9KjGxtiO0cVnafvgxQif/wlXtigQ+S6/Bw8kRpfsSNW5406y69mIfsx/JNzu
         EMPQ==
X-Gm-Message-State: AOAM532kza84t0V2yjlNaMxg6qKnXVS8boC30P/6jcU15Mo+RKhKnBOH
        kQ1Whg9asbw/Ln/zcszmT1GV7g==
X-Google-Smtp-Source: ABdhPJzihpSM66xT+uOQ2iGayOBWdCnTTJsExBsJGNtT36Hu+cB1rtVfAsg5pERYJFtj65+zbqZ9RA==
X-Received: by 2002:a17:906:f1c1:: with SMTP id gx1mr40813289ejb.554.1641302449791;
        Tue, 04 Jan 2022 05:20:49 -0800 (PST)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-95-244-92-231.retail.telecomitalia.it. [95.244.92.231])
        by smtp.gmail.com with ESMTPSA id y13sm14765575edq.77.2022.01.04.05.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 05:20:49 -0800 (PST)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Michael Trimarchi <michael@amarulasolutions.com>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 2/2] can: flexcan: add ethtool support
Date:   Tue,  4 Jan 2022 14:20:26 +0100
Message-Id: <20220104132026.3062763-3-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220104132026.3062763-1-dario.binacchi@amarulasolutions.com>
References: <20220104132026.3062763-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For now, the driver information is added but the target is to change the
type of reception at runtime (RxFIFO enabled / disabled).

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

 drivers/net/can/Makefile                      |   3 +
 drivers/net/can/flexcan.h                     | 107 ++++++++++++++++++
 drivers/net/can/flexcan_ethtool.c             |  29 +++++
 drivers/net/can/{flexcan.c => flexcan_main.c} |  96 +---------------
 4 files changed, 142 insertions(+), 93 deletions(-)
 create mode 100644 drivers/net/can/flexcan.h
 create mode 100644 drivers/net/can/flexcan_ethtool.c
 rename drivers/net/can/{flexcan.c => flexcan_main.c} (94%)

diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
index a2b4463d8480..34728cfa6430 100644
--- a/drivers/net/can/Makefile
+++ b/drivers/net/can/Makefile
@@ -16,7 +16,10 @@ obj-y				+= softing/
 obj-$(CONFIG_CAN_AT91)		+= at91_can.o
 obj-$(CONFIG_CAN_CC770)		+= cc770/
 obj-$(CONFIG_CAN_C_CAN)		+= c_can/
+
 obj-$(CONFIG_CAN_FLEXCAN)	+= flexcan.o
+flexcan-objs			+= flexcan_main.o flexcan_ethtool.o
+
 obj-$(CONFIG_CAN_GRCAN)		+= grcan.o
 obj-$(CONFIG_CAN_IFI_CANFD)	+= ifi_canfd/
 obj-$(CONFIG_CAN_JANZ_ICAN3)	+= janz-ican3.o
diff --git a/drivers/net/can/flexcan.h b/drivers/net/can/flexcan.h
new file mode 100644
index 000000000000..722b8edc3ff8
--- /dev/null
+++ b/drivers/net/can/flexcan.h
@@ -0,0 +1,107 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Copyright (C) 2022 Amarula Solutions
+ *
+ * Author: Dario Binacchi <dario.binacchi@amarulasolutions.com>
+ */
+
+#ifndef FLEXCAN_H
+#define FLEXCAN_H
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
+/* Use timestamp based offloading */
+#define FLEXCAN_QUIRK_USE_OFF_TIMESTAMP BIT(5)
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
+#endif /* FLEXCAN_H */
diff --git a/drivers/net/can/flexcan_ethtool.c b/drivers/net/can/flexcan_ethtool.c
new file mode 100644
index 000000000000..55c6b59bb6bf
--- /dev/null
+++ b/drivers/net/can/flexcan_ethtool.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2022 Amarula Solutions
+ *
+ * Author: Dario Binacchi <dario.binacchi@amarulasolutions.com>
+ */
+
+#include <linux/ethtool.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/netdevice.h>
+#include <linux/can/dev.h>
+
+#include "flexcan.h"
+
+static void flexcan_get_drvinfo(struct net_device *netdev,
+				struct ethtool_drvinfo *info)
+{
+	strscpy(info->driver, "flexcan", sizeof(info->driver));
+}
+
+static const struct ethtool_ops flexcan_ethtool_ops = {
+	.get_drvinfo = flexcan_get_drvinfo,
+};
+
+void flexcan_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &flexcan_ethtool_ops;
+}
diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan_main.c
similarity index 94%
rename from drivers/net/can/flexcan.c
rename to drivers/net/can/flexcan_main.c
index 223c32bf1f6c..e3e43e9cfbd6 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan_main.c
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
@@ -206,53 +207,6 @@
 
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
-/* Use timestamp based offloading */
-#define FLEXCAN_QUIRK_USE_OFF_TIMESTAMP BIT(5)
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
-
 /* Structure of the message buffer */
 struct flexcan_mb {
 	u32 can_ctrl;
@@ -339,51 +293,6 @@ struct flexcan_regs {
 
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
 		FLEXCAN_QUIRK_NR_IRQ_3 | FLEXCAN_QUIRK_NR_MB_16,
@@ -2177,6 +2086,7 @@ static int flexcan_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 	dev->netdev_ops = &flexcan_netdev_ops;
+	flexcan_set_ethtool_ops(dev);
 	dev->irq = irq;
 	dev->flags |= IFF_ECHO;
 
-- 
2.32.0

