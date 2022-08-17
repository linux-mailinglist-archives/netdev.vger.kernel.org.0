Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19438597188
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbiHQOhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240214AbiHQOh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:37:26 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A229C2F5
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 07:36:50 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a7so24932535ejp.2
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 07:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=AgMgbh/oLddMZPBoOQHfUpECQ+KTIAY4HesxfB5erIE=;
        b=P6u1yEjBiVK7LfSwO00akYXs5KorregUpBoiuONF92wWfsfKnWD4JBgUV0luAtJc4L
         f+ScOxeZLSU6LQGBMok/3LSG8RjtDMBIiQrnDvufVP0QtcWE+QS/81Fd4+0Bja6wRDIX
         CQhpkyPRJDjtRXDNGusXZMNnEhzEifx9uL2jg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=AgMgbh/oLddMZPBoOQHfUpECQ+KTIAY4HesxfB5erIE=;
        b=TTiuND+GpF68iMa0lbMAY8M0vXJh61uacVB3sHwx/bLrKAdBKFzemGCkP82SAC649o
         P8YHlmXz+5mkNEs3fv9azS/HCZ+F8/Ur6mCzRxU3XezpulNDbcS2U2/uzLf6h0SGzAN9
         QXo4eBvFgifsowk+2GXWwesdqSFEYEPSxZjifOYXfXo0AwJ8kbt3jBoXeKIRjGcJbsdr
         JnAPKmKTZ+zVdyg7nJeLfv+3UguTFyesr+k4G2OIHqrIZ8129QfFCxwvV7AwiEoUCqAK
         efhahAFmAtoaJw45JUEogoUy4q0jWn3rPnT2ax6NJLK1Y4cZ0NsQnlgxoDyCN1aXqX4Y
         q83g==
X-Gm-Message-State: ACgBeo0mDs24tUAOnpTmFodaQAUnJcZFzB19zpYMlWnB6uM/HyrH3qBD
        uRrZIiq6kg47k5YL5jz/vyQBUA==
X-Google-Smtp-Source: AA6agR5z3skAvfL0Kie9WLSoihLLmmiz77a0stu37z4nZQkxkCvrnoJWnFTHoQp92ODXbrcihsPYbA==
X-Received: by 2002:a17:907:3ea7:b0:730:9a8b:b8f1 with SMTP id hs39-20020a1709073ea700b007309a8bb8f1mr16813617ejc.168.1660747008064;
        Wed, 17 Aug 2022 07:36:48 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-79-31-31-9.retail.telecomitalia.it. [79.31.31.9])
        by smtp.gmail.com with ESMTPSA id o9-20020aa7c7c9000000b0043cab10f702sm10711982eds.90.2022.08.17.07.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 07:36:47 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 4/4] can: bxcan: add support for ST bxCAN controller
Date:   Wed, 17 Aug 2022 16:35:29 +0200
Message-Id: <20220817143529.257908-5-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220817143529.257908-1-dario.binacchi@amarulasolutions.com>
References: <20220817143529.257908-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the basic extended CAN controller (bxCAN) found in many
low- to middle-end STM32 SoCs. It supports the Basic Extended CAN
protocol versions 2.0A and B with a maximum bit rate of 1 Mbit/s.

The controller supports two channels (CAN1 as master and CAN2 as slave)
and the driver can enable either or both of the channels. They share
some of the required logic (e. g. clocks and filters), and that means
you cannot use the slave CAN without enabling some hardware resources
managed by the master CAN.

Each channel has 3 transmit mailboxes, 2 receive FIFOs with 3 stages and
28 scalable filter banks.
It also manages 4 dedicated interrupt vectors:
- transmit interrupt
- FIFO 0 receive interrupt
- FIFO 1 receive interrupt
- status change error interrupt

Driver uses all 3 available mailboxes for transmission and FIFO 0 for
reception. Rx filter rules are configured to the minimum. They accept
all messages and assign filter 0 to CAN1 and filter 14 to CAN2 in
identifier mask mode with 32 bits width. It enables and uses transmit,
receive buffers for FIFO 0 and error and status change interrupts.

Signed-off-by: Dario Binacchi <dariobin@libero.it>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

 drivers/net/can/Kconfig            |   1 +
 drivers/net/can/Makefile           |   1 +
 drivers/net/can/bxcan/Kconfig      |  34 +
 drivers/net/can/bxcan/Makefile     |   4 +
 drivers/net/can/bxcan/bxcan-core.c | 201 ++++++
 drivers/net/can/bxcan/bxcan-core.h |  33 +
 drivers/net/can/bxcan/bxcan-drv.c  | 980 +++++++++++++++++++++++++++++
 7 files changed, 1254 insertions(+)
 create mode 100644 drivers/net/can/bxcan/Kconfig
 create mode 100644 drivers/net/can/bxcan/Makefile
 create mode 100644 drivers/net/can/bxcan/bxcan-core.c
 create mode 100644 drivers/net/can/bxcan/bxcan-core.h
 create mode 100644 drivers/net/can/bxcan/bxcan-drv.c

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 3048ad77edb3..d55355a0e583 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -206,6 +206,7 @@ config PCH_CAN
 	  is an IOH for x86 embedded processor (Intel Atom E6xx series).
 	  This driver can access CAN bus.
 
+source "drivers/net/can/bxcan/Kconfig"
 source "drivers/net/can/c_can/Kconfig"
 source "drivers/net/can/cc770/Kconfig"
 source "drivers/net/can/ctucanfd/Kconfig"
diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
index 61c75ce9d500..373f2c99689a 100644
--- a/drivers/net/can/Makefile
+++ b/drivers/net/can/Makefile
@@ -14,6 +14,7 @@ obj-y				+= usb/
 obj-y				+= softing/
 
 obj-$(CONFIG_CAN_AT91)		+= at91_can.o
+obj-$(CONFIG_CAN_BXCAN)		+= bxcan/
 obj-$(CONFIG_CAN_CAN327)	+= can327.o
 obj-$(CONFIG_CAN_CC770)		+= cc770/
 obj-$(CONFIG_CAN_C_CAN)		+= c_can/
diff --git a/drivers/net/can/bxcan/Kconfig b/drivers/net/can/bxcan/Kconfig
new file mode 100644
index 000000000000..df34c212bf51
--- /dev/null
+++ b/drivers/net/can/bxcan/Kconfig
@@ -0,0 +1,34 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# bxCAN driver configuration
+#
+menuconfig CAN_BXCAN
+	tristate "STMicroelectronics STM32 Basic Extended CAN (bxCAN) devices"
+	depends on ARCH_STM32 || COMPILE_TEST
+	depends on OF
+	depends on HAS_IOMEM
+	help
+	  Say Y here if you want support for ST bxCAN controller framework.
+	  This is common support for devices that embed the ST bxCAN IP.
+
+if CAN_BXCAN
+
+config CAN_BXCAN_CORE
+	tristate "STMicroelectronics STM32 bxCAN core"
+	  help
+	  Select this option to enable the core driver for STMicroelectronics
+	  STM32 basic extended CAN controller (bxCAN).
+
+	  This driver can also be built as a module. If so, the module
+	  will be called bxcan-core.
+
+config CAN_BXCAN_DRV
+	tristate "STMicroelectronics STM32 bxCAN driver"
+	depends on CAN_BXCAN_CORE
+	  help
+	  Say yes here to build support for the STMicroelectronics STM32 basic
+	  extended CAN Controller (bxCAN).
+
+	  This driver can also be built as a module. If so, the module
+	  will be called bxcan-drv.
+endif
diff --git a/drivers/net/can/bxcan/Makefile b/drivers/net/can/bxcan/Makefile
new file mode 100644
index 000000000000..60350f055271
--- /dev/null
+++ b/drivers/net/can/bxcan/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_CAN_BXCAN_CORE) += bxcan-core.o
+obj-$(CONFIG_CAN_BXCAN_DRV) += bxcan-drv.o
diff --git a/drivers/net/can/bxcan/bxcan-core.c b/drivers/net/can/bxcan/bxcan-core.c
new file mode 100644
index 000000000000..16cbc8faf583
--- /dev/null
+++ b/drivers/net/can/bxcan/bxcan-core.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0
+/* bxcan-core.c - STM32 Basic Extended CAN core controller driver
+ *
+ * This file is part of STM32 bxcan driver
+ *
+ * Copyright (c) 2022 Dario Binacchi <dario.binacchi@amarulasolutions.com>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+
+#include "bxcan-core.h"
+
+#define BXCAN_FILTER_ID(master)       (master ? 0 : 14)
+
+/* Filter master register (FMR) bits */
+#define BXCAN_FMR_CANSB_MASK	GENMASK(13, 8)
+#define BXCAN_FMR_CANSB(x)	(((x) & 0x3f) << 8)
+#define BXCAN_FMR_FINIT		BIT(0)
+
+/* Structure of the filter bank */
+struct bxcan_fb {
+	u32 fr1;		/* filter 1 */
+	u32 fr2;		/* filter 2 */
+};
+
+/* Structure of the hardware filter registers */
+struct bxcan_fregs {
+	u32 fmr;		/* 0x00 - filter master */
+	u32 fm1r;		/* 0x04 - filter mode */
+	u32 reserved2;		/* 0x08 */
+	u32 fs1r;		/* 0x0c - filter scale */
+	u32 reserved3;		/* 0x10 */
+	u32 ffa1r;		/* 0x14 - filter FIFO assignment */
+	u32 reserved4;		/* 0x18 */
+	u32 fa1r;		/* 0x1c - filter activation */
+	u32 reserved5[8];	/* 0x20 */
+	struct bxcan_fb fb[28];	/* 0x40 - filter banks */
+};
+
+struct bxcan_core_priv {
+	void __iomem *base;
+	struct bxcan_fregs __iomem *fregs;
+	struct clk *clk_master;
+	unsigned int clk_master_ref;
+};
+
+void bxcan_disable_filters(struct device *dev, bool master)
+{
+	struct bxcan_core_priv *priv = dev_get_drvdata(dev);
+	unsigned int fid = BXCAN_FILTER_ID(master);
+	u32 fmask = BIT(fid);
+
+	bxcan_rmw(&priv->fregs->fa1r, fmask, 0);
+}
+
+void bxcan_enable_filters(struct device *dev, bool master)
+{
+	struct bxcan_core_priv *priv = dev_get_drvdata(dev);
+	unsigned int fid = BXCAN_FILTER_ID(master);
+	u32 fmask = BIT(fid);
+
+	/* Filter settings:
+	 *
+	 * Accept all messages.
+	 * Assign filter 0 to CAN1 and filter 14 to CAN2 in identifier
+	 * mask mode with 32 bits width.
+	 */
+
+	/* Enter filter initialization mode and assing filters to CAN
+	 * controllers.
+	 */
+	bxcan_rmw(&priv->fregs->fmr, BXCAN_FMR_CANSB_MASK,
+		  BXCAN_FMR_CANSB(14) | BXCAN_FMR_FINIT);
+
+	/* Deactivate filter */
+	bxcan_rmw(&priv->fregs->fa1r, fmask, 0);
+
+	/* Two 32-bit registers in identifier mask mode */
+	bxcan_rmw(&priv->fregs->fm1r, fmask, 0);
+
+	/* Single 32-bit scale configuration */
+	bxcan_rmw(&priv->fregs->fs1r, 0, fmask);
+
+	/* Assign filter to FIFO 0 */
+	bxcan_rmw(&priv->fregs->ffa1r, fmask, 0);
+
+	/* Accept all messages */
+	writel(0, &priv->fregs->fb[fid].fr1);
+	writel(0, &priv->fregs->fb[fid].fr2);
+
+	/* Activate filter */
+	bxcan_rmw(&priv->fregs->fa1r, 0, fmask);
+
+	/* Exit filter initialization mode */
+	bxcan_rmw(&priv->fregs->fmr, BXCAN_FMR_FINIT, 0);
+}
+
+int bxcan_enable_master_clk(struct device *dev)
+{
+	struct bxcan_core_priv *priv = dev_get_drvdata(dev);
+	int err;
+
+	if (priv->clk_master_ref == 0) {
+		err = clk_prepare_enable(priv->clk_master);
+		if (err)
+			return err;
+	}
+
+	priv->clk_master_ref++;
+	return 0;
+}
+
+void bxcan_disable_master_clk(struct device *dev)
+{
+	struct bxcan_core_priv *priv = dev_get_drvdata(dev);
+
+	if (priv->clk_master_ref == 0)
+		return;
+
+	if (priv->clk_master_ref == 1)
+		clk_disable_unprepare(priv->clk_master);
+
+	priv->clk_master_ref--;
+}
+
+unsigned long bxcan_get_master_clk_rate(struct device *dev)
+{
+	struct bxcan_core_priv *priv = dev_get_drvdata(dev);
+
+	return clk_get_rate(priv->clk_master);
+}
+
+void __iomem *bxcan_get_base_addr(struct device *dev)
+{
+	struct bxcan_core_priv *priv = dev_get_drvdata(dev);
+
+	return priv->base;
+}
+
+static const struct of_device_id bxcan_core_of_match[] = {
+	{.compatible = "st,stm32-bxcan-core"},
+	{ /* sentinel */ },
+};
+
+MODULE_DEVICE_TABLE(of, bxcan_core_of_match);
+
+static int bxcan_core_probe(struct platform_device *pdev)
+{
+	struct bxcan_core_priv *priv;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = pdev->dev.of_node;
+	void __iomem *regs;
+	struct clk *clk;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, priv);
+	regs = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
+	clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(dev, "failed to get clock\n");
+		return PTR_ERR(clk);
+	}
+
+	priv->base = regs;
+	priv->fregs = regs + 0x200;
+	priv->clk_master = clk;
+
+	dev_info(&pdev->dev, "regs: %px\n", priv->base);
+	ret = of_platform_populate(np, NULL, NULL, dev);
+	if (ret < 0) {
+		dev_err(dev, "failed to populate DT children\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct platform_driver bxcan_core_driver = {
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.of_match_table = bxcan_core_of_match,
+	},
+	.probe = bxcan_core_probe,
+};
+
+module_platform_driver(bxcan_core_driver);
+
+MODULE_AUTHOR("Dario Binacchi <dario.binacchi@amarulasolutions.com>");
+MODULE_DESCRIPTION("STMicroelectronics Basic Extended CAN core driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/can/bxcan/bxcan-core.h b/drivers/net/can/bxcan/bxcan-core.h
new file mode 100644
index 000000000000..51846b1ae698
--- /dev/null
+++ b/drivers/net/can/bxcan/bxcan-core.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * bxcan-core - STM32 Basic Extended CAN core controller driver
+ *
+ * Copyright (c) 2022 Dario Binacchi <dario.binacchi@amarulasolutions.com>
+ */
+
+#ifndef __BXCAN_CORE_H
+#define __BXCAN_CORE_H
+
+#include <linux/clk.h>
+#include <linux/io.h>
+
+int bxcan_enable_master_clk(struct device *dev);
+void bxcan_disable_master_clk(struct device *dev);
+unsigned long bxcan_get_master_clk_rate(struct device *dev);
+void __iomem *bxcan_get_base_addr(struct device *dev);
+void bxcan_enable_filters(struct device *dev, bool master);
+void bxcan_disable_filters(struct device *dev, bool master);
+
+static inline void bxcan_rmw(volatile void __iomem *addr, u32 clear, u32 set)
+{
+	u32 old, val;
+
+	old = readl(addr);
+	val = (old & ~clear) | set;
+	if (val != old)
+		writel(val, addr);
+
+	pr_debug("rmw 0x%08x @ 0x%08x\n", val, (u32)addr);
+}
+
+#endif
diff --git a/drivers/net/can/bxcan/bxcan-drv.c b/drivers/net/can/bxcan/bxcan-drv.c
new file mode 100644
index 000000000000..5fbb0327d104
--- /dev/null
+++ b/drivers/net/can/bxcan/bxcan-drv.c
@@ -0,0 +1,980 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// bxcan-drv.c - STM32 Basic Extended CAN controller driver
+//
+// Copyright (c) 2022 Dario Binacchi <dario.binacchi@amarulasolutions.com>
+//
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/bitfield.h>
+#include <linux/can.h>
+#include <linux/can/dev.h>
+#include <linux/can/error.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+
+#include "bxcan-core.h"
+
+#define BXCAN_NAPI_WEIGHT		3
+#define BXCAN_TIMEOUT_US		10000
+
+#define BXCAN_TX_MB_NUM			3
+
+/* Master control register (MCR) bits */
+#define BXCAN_MCR_DBF			BIT(16)
+#define BXCAN_MCR_RESET			BIT(15)
+#define BXCAN_MCR_TTCM			BIT(7)
+#define BXCAN_MCR_ABOM			BIT(6)
+#define BXCAN_MCR_AWUM			BIT(5)
+#define BXCAN_MCR_NART			BIT(4)
+#define BXCAN_MCR_RFLM			BIT(3)
+#define BXCAN_MCR_TXFP			BIT(2)
+#define BXCAN_MCR_SLEEP			BIT(1)
+#define BXCAN_MCR_INRQ			BIT(0)
+
+/* Master status register (MSR) bits */
+#define BXCAN_MSR_RX			BIT(11)
+#define BXCAN_MSR_SAMP			BIT(10)
+#define BXCAN_MSR_RXM			BIT(9)
+#define BXCAN_MSR_TXM			BIT(8)
+#define BXCAN_MSR_SLAKI			BIT(4)
+#define BXCAN_MSR_WKUI			BIT(3)
+#define BXCAN_MSR_ERRI			BIT(2)
+#define BXCAN_MSR_SLAK			BIT(1)
+#define BXCAN_MSR_INAK			BIT(0)
+
+/* Transmit status register (TSR) bits */
+#define BXCAN_TSR_LOW2			BIT(31)
+#define BXCAN_TSR_LOW1			BIT(30)
+#define BXCAN_TSR_LOW0			BIT(29)
+#define BXCAN_TSR_TME			GENMASK(28, 26)
+#define BXCAN_TSR_TME_SHIFT		(26)
+#define BXCAN_TSR_TME2			BIT(28)
+#define BXCAN_TSR_TME1			BIT(27)
+#define BXCAN_TSR_TME0			BIT(26)
+#define BXCAN_TSR_CODE			GENMASK(25, 24)
+#define BXCAN_TSR_ABRQ2			BIT(23)
+#define BXCAN_TSR_TERR2			BIT(19)
+#define BXCAN_TSR_ALST2			BIT(18)
+#define BXCAN_TSR_TXOK2			BIT(17)
+#define BXCAN_TSR_RQCP2			BIT(16)
+#define BXCAN_TSR_ABRQ1			BIT(15)
+#define BXCAN_TSR_TERR1			BIT(11)
+#define BXCAN_TSR_ALST1			BIT(10)
+#define BXCAN_TSR_TXOK1			BIT(9)
+#define BXCAN_TSR_RQCP1			BIT(8)
+#define BXCAN_TSR_ABRQ0			BIT(7)
+#define BXCAN_TSR_TERR0			BIT(3)
+#define BXCAN_TSR_ALST0			BIT(2)
+#define BXCAN_TSR_TXOK0			BIT(1)
+#define BXCAN_TSR_RQCP0			BIT(0)
+
+/* Receive FIFO 0 register (RF0R) bits */
+#define BXCAN_RF0R_RFOM0		BIT(5)
+#define BXCAN_RF0R_FOVR0		BIT(4)
+#define BXCAN_RF0R_FULL0		BIT(3)
+#define BXCAN_RF0R_FMP0			GENMASK(1, 0)
+
+/* Interrupt enable register (IER) bits */
+#define BXCAN_IER_SLKIE			BIT(17)
+#define BXCAN_IER_WKUIE			BIT(16)
+#define BXCAN_IER_ERRIE			BIT(15)
+#define BXCAN_IER_LECIE			BIT(11)
+#define BXCAN_IER_BOFIE			BIT(10)
+#define BXCAN_IER_EPVIE			BIT(9)
+#define BXCAN_IER_EWGIE			BIT(8)
+#define BXCAN_IER_FOVIE1		BIT(6)
+#define BXCAN_IER_FFIE1			BIT(5)
+#define BXCAN_IER_FMPIE1		BIT(4)
+#define BXCAN_IER_FOVIE0		BIT(3)
+#define BXCAN_IER_FFIE0			BIT(2)
+#define BXCAN_IER_FMPIE0		BIT(1)
+#define BXCAN_IER_TMEIE			BIT(0)
+
+/* Error status register (ESR) bits */
+#define BXCAN_ESR_REC_SHIFT		(24)
+#define BXCAN_ESR_REC			GENMASK(31, 24)
+#define BXCAN_ESR_TEC_SHIFT		(16)
+#define BXCAN_ESR_TEC			GENMASK(23, 16)
+#define BXCAN_ESR_LEC_SHIFT		(4)
+#define BXCAN_ESR_LEC			GENMASK(6, 4)
+#define BXCAN_ESR_BOFF			BIT(1)
+#define BXCAN_ESR_EPVF			BIT(1)
+#define BXCAN_ESR_EWGF			BIT(0)
+#define BXCAN_TEC(esr)			(((esr) & BXCAN_ESR_TEC) >> \
+					 BXCAN_ESR_TEC_SHIFT)
+#define BXCAN_REC(esr)			(((esr) & BXCAN_ESR_REC) >> \
+					 BXCAN_ESR_REC_SHIFT)
+
+/* Bit timing register (BTR) bits */
+#define BXCAN_BTR_SILM			BIT(31)
+#define BXCAN_BTR_LBKM			BIT(30)
+#define BXCAN_BTR_SJW_MASK		GENMASK(25, 24)
+#define BXCAN_BTR_SJW(x)		(((x) & 0x03) << 24)
+#define BXCAN_BTR_TS2_MASK		GENMASK(22, 20)
+#define BXCAN_BTR_TS2(x)		(((x) & 0x07) << 20)
+#define BXCAN_BTR_TS1_MASK		GENMASK(19, 16)
+#define BXCAN_BTR_TS1(x)		(((x) & 0x0f) << 16)
+#define BXCAN_BTR_BRP_MASK		GENMASK(9, 0)
+#define BXCAN_BTR_BRP(x)		((x) & 0x3ff)
+
+/* TX mailbox identifier register (TIxR, x = 0..2) bits */
+#define BXCAN_TIxR_STID(x)		(((x) & 0x7ff) << 21)
+#define BXCAN_TIxR_EXID(x)		((x) << 3)
+#define BXCAN_TIxR_IDE			BIT(2)
+#define BXCAN_TIxR_RTR			BIT(1)
+#define BXCAN_TIxR_TXRQ			BIT(0)
+
+/* TX mailbox data length and time stamp register (TDTxR, x = 0..2 bits */
+#define BXCAN_TDTxR_TIME(x)		(((x) & 0x0f) << 16)
+#define BXCAN_TDTxR_TGT			BIT(8)
+#define BXCAN_TDTxR_DLC_MASK		GENMASK(3, 0)
+#define BXCAN_TDTxR_DLC(x)		((x) & 0x0f)
+
+/* RX FIFO mailbox identifier register (RIxR, x = 0..1 */
+#define BXCAN_RIxR_STID_SHIFT		(21)
+#define BXCAN_RIxR_EXID_SHIFT		(3)
+#define BXCAN_RIxR_IDE			BIT(2)
+#define BXCAN_RIxR_RTR			BIT(1)
+
+/* RX FIFO mailbox data length and timestamp register (RDTxR, x = 0..1) bits */
+#define BXCAN_RDTxR_TIME		GENMASK(31, 16)
+#define BXCAN_RDTxR_FMI			GENMASK(15, 8)
+#define BXCAN_RDTxR_DLC			GENMASK(3, 0)
+
+enum bxcan_lec_code {
+	LEC_NO_ERROR = 0,
+	LEC_STUFF_ERROR,
+	LEC_FORM_ERROR,
+	LEC_ACK_ERROR,
+	LEC_BIT1_ERROR,
+	LEC_BIT0_ERROR,
+	LEC_CRC_ERROR,
+	LEC_UNUSED
+};
+
+/* Structure of the message buffer */
+struct bxcan_mb {
+	u32 id;			/* can identifier */
+	u32 dlc;		/* data length control and timestamp */
+	u32 data[2];		/* data */
+};
+
+/* Structure of the hardware registers */
+struct bxcan_regs {
+	u32 mcr;			/* 0x00 - master control */
+	u32 msr;			/* 0x04 - master status */
+	u32 tsr;			/* 0x08 - transmit status */
+	u32 rf0r;			/* 0x0c - FIFO 0 */
+	u32 rf1r;			/* 0x10 - FIFO 1 */
+	u32 ier;			/* 0x14 - interrupt enable */
+	u32 esr;			/* 0x18 - error status */
+	u32 btr;			/* 0x1c - bit timing*/
+	u32 reserved0[88];		/* 0x20 */
+	struct bxcan_mb tx_mb[BXCAN_TX_MB_NUM];	/* 0x180 - tx mailbox */
+	struct bxcan_mb rx_mb[2];	/* 0x1b0 - rx mailbox */
+};
+
+struct bxcan_priv {
+	struct can_priv can;
+	struct device *dev;
+	struct napi_struct napi;
+
+	struct bxcan_regs __iomem *regs;
+	int tx_irq;
+	int sce_irq;
+	u8 tx_dlc[BXCAN_TX_MB_NUM];
+	bool master;
+	struct clk *clk;
+};
+
+static const struct can_bittiming_const bxcan_bittiming_const = {
+	.name = KBUILD_MODNAME,
+	.tseg1_min = 1,
+	.tseg1_max = 16,
+	.tseg2_min = 1,
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 1,
+	.brp_max = 1024,
+	.brp_inc = 1,
+};
+
+static int bxcan_chip_softreset(struct bxcan_priv *priv)
+{
+	struct bxcan_regs __iomem *regs = priv->regs;
+	unsigned int timeout = BXCAN_TIMEOUT_US / 10;
+
+	bxcan_rmw(&regs->mcr, 0, BXCAN_MCR_RESET);
+	while (timeout-- && !(readl(&regs->msr) & BXCAN_MSR_SLAK))
+		udelay(10);
+
+	if (!(readl(&regs->msr) & BXCAN_MSR_SLAK))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int bxcan_enter_init_mode(struct bxcan_priv *priv)
+{
+	struct bxcan_regs __iomem *regs = priv->regs;
+	unsigned int timeout = BXCAN_TIMEOUT_US / 10;
+
+	bxcan_rmw(&regs->mcr, 0, BXCAN_MCR_INRQ);
+	while (timeout-- && !(readl(&regs->msr) & BXCAN_MSR_INAK))
+		udelay(100);
+
+	if (!(readl(&regs->msr) & BXCAN_MSR_INAK))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int bxcan_leave_init_mode(struct bxcan_priv *priv)
+{
+	struct bxcan_regs __iomem *regs = priv->regs;
+	unsigned int timeout = BXCAN_TIMEOUT_US / 10;
+
+	bxcan_rmw(&regs->mcr, BXCAN_MCR_INRQ, 0);
+	while (timeout-- && (readl(&regs->msr) & BXCAN_MSR_INAK))
+		udelay(100);
+
+	if (readl(&regs->msr) & BXCAN_MSR_INAK)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int bxcan_leave_sleep_mode(struct bxcan_priv *priv)
+{
+	struct bxcan_regs __iomem *regs = priv->regs;
+	unsigned int timeout = BXCAN_TIMEOUT_US / 10;
+
+	bxcan_rmw(&regs->mcr, BXCAN_MCR_SLEEP, 0);
+	while (timeout-- && (readl(&regs->msr) & BXCAN_MSR_SLAK))
+		udelay(100);
+
+	if (readl(&regs->msr) & BXCAN_MSR_SLAK)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int bxcan_enter_sleep_mode(struct bxcan_priv *priv)
+{
+	struct bxcan_regs __iomem *regs = priv->regs;
+	unsigned int timeout = BXCAN_TIMEOUT_US / 10;
+
+	bxcan_rmw(&regs->mcr, 0, BXCAN_MCR_SLEEP);
+	while (timeout-- && !(readl(&regs->msr) & BXCAN_MSR_SLAK))
+		udelay(100);
+
+	if (!(readl(&regs->msr) & BXCAN_MSR_SLAK))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static irqreturn_t bxcan_rx_isr(int irq, void *dev_id)
+{
+	struct net_device *ndev = dev_id;
+	struct bxcan_priv *priv = netdev_priv(ndev);
+	struct bxcan_regs __iomem *regs = priv->regs;
+
+	if (napi_schedule_prep(&priv->napi)) {
+		/* Disable Rx FIFO message pending interrupt */
+		bxcan_rmw(&regs->ier, BXCAN_IER_FMPIE0, 0);
+		__napi_schedule(&priv->napi);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t bxcan_tx_isr(int irq, void *dev_id)
+{
+	struct net_device *ndev = dev_id;
+	struct bxcan_priv *priv = netdev_priv(ndev);
+	struct bxcan_regs __iomem *regs = priv->regs;
+	struct net_device_stats *stats = &ndev->stats;
+	u32 tsr, rqcp_bit = BXCAN_TSR_RQCP0;
+	int i;
+
+	tsr = readl(&regs->tsr);
+	for (i = 0; i < BXCAN_TX_MB_NUM; rqcp_bit <<= 8, i++) {
+		if (!(tsr & rqcp_bit))
+			continue;
+
+		stats->tx_packets++;
+		stats->tx_bytes += priv->tx_dlc[i];
+	}
+
+	writel(tsr, &regs->tsr);
+
+	if (netif_queue_stopped(ndev))
+		netif_wake_queue(ndev);
+
+	return IRQ_HANDLED;
+}
+
+static void bxcan_handle_state_change(struct net_device *ndev, u32 esr)
+{
+	struct bxcan_priv *priv = netdev_priv(ndev);
+	struct net_device_stats *stats = &ndev->stats;
+	enum can_state new_state = priv->can.state;
+	struct can_berr_counter bec;
+	enum can_state rx_state, tx_state;
+	struct sk_buff *skb;
+	struct can_frame *cf;
+
+	/* Early exit if no error flag is set */
+	if (!(esr & (BXCAN_ESR_EWGF | BXCAN_ESR_EPVF | BXCAN_ESR_BOFF)))
+		return;
+
+	bec.txerr = BXCAN_TEC(esr);
+	bec.rxerr = BXCAN_REC(esr);
+
+	if (esr & BXCAN_ESR_BOFF)
+		new_state = CAN_STATE_BUS_OFF;
+	else if (esr & BXCAN_ESR_EPVF)
+		new_state = CAN_STATE_ERROR_PASSIVE;
+	else if (esr & BXCAN_ESR_EWGF)
+		new_state = CAN_STATE_ERROR_WARNING;
+
+	/* state hasn't changed */
+	if (unlikely(new_state == priv->can.state))
+		return;
+
+	skb = alloc_can_err_skb(ndev, &cf);
+	if (unlikely(!skb))
+		return;
+
+	tx_state = bec.txerr >= bec.rxerr ? new_state : 0;
+	rx_state = bec.txerr <= bec.rxerr ? new_state : 0;
+	can_change_state(ndev, cf, tx_state, rx_state);
+
+	if (new_state == CAN_STATE_BUS_OFF)
+		can_bus_off(ndev);
+
+	stats->rx_bytes += cf->len;
+	stats->rx_packets++;
+	netif_rx(skb);
+}
+
+static void bxcan_handle_bus_err(struct net_device *ndev, u32 esr)
+{
+	struct bxcan_priv *priv = netdev_priv(ndev);
+	enum bxcan_lec_code lec_code;
+	struct can_frame *cf;
+	struct sk_buff *skb;
+
+	lec_code = (esr & BXCAN_ESR_LEC_SHIFT) >> BXCAN_ESR_LEC_SHIFT;
+
+	/* Early exit if no lec update or no error.
+	 * No lec update means that no CAN bus event has been detected
+	 * since CPU wrote LEC_UNUSED value to status reg.
+	 */
+	if (lec_code == LEC_UNUSED || lec_code == LEC_NO_ERROR)
+		return;
+
+	if (!(priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING))
+		return;
+
+	/* Common for all type of bus errors */
+	priv->can.can_stats.bus_error++;
+
+	/* Propagate the error condition to the CAN stack */
+	skb = alloc_can_err_skb(ndev, &cf);
+	if (unlikely(!skb))
+		return;
+
+	ndev->stats.rx_bytes += cf->len;
+
+	/* Check for 'last error code' which tells us the
+	 * type of the last error to occur on the CAN bus
+	 */
+	cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
+
+	switch (lec_code) {
+	case LEC_STUFF_ERROR:
+		netdev_dbg(ndev, "Stuff error\n");
+		ndev->stats.rx_errors++;
+		cf->data[2] |= CAN_ERR_PROT_STUFF;
+		break;
+	case LEC_FORM_ERROR:
+		netdev_dbg(ndev, "Form error\n");
+		ndev->stats.rx_errors++;
+		cf->data[2] |= CAN_ERR_PROT_FORM;
+		break;
+	case LEC_ACK_ERROR:
+		netdev_dbg(ndev, "Ack error\n");
+		ndev->stats.tx_errors++;
+		cf->data[3] = CAN_ERR_PROT_LOC_ACK;
+		break;
+	case LEC_BIT1_ERROR:
+		netdev_dbg(ndev, "Bit error (recessive)\n");
+		ndev->stats.tx_errors++;
+		cf->data[2] |= CAN_ERR_PROT_BIT1;
+		break;
+	case LEC_BIT0_ERROR:
+		netdev_dbg(ndev, "Bit error (dominant)\n");
+		ndev->stats.tx_errors++;
+		cf->data[2] |= CAN_ERR_PROT_BIT0;
+		break;
+	case LEC_CRC_ERROR:
+		netdev_dbg(ndev, "CRC error\n");
+		ndev->stats.rx_errors++;
+		cf->data[3] = CAN_ERR_PROT_LOC_CRC_SEQ;
+		break;
+	default:
+		break;
+	}
+
+	netif_rx(skb);
+}
+
+static irqreturn_t bxcan_state_change_isr(int irq, void *dev_id)
+{
+	struct net_device *ndev = dev_id;
+	struct bxcan_priv *priv = netdev_priv(ndev);
+	struct bxcan_regs __iomem *regs = priv->regs;
+	u32 msr, esr;
+
+	msr = readl(&regs->msr);
+	if (!(msr & BXCAN_MSR_ERRI))
+		return IRQ_NONE;
+
+	esr = readl(&regs->esr);
+	bxcan_handle_state_change(ndev, esr);
+	bxcan_handle_bus_err(ndev, esr);
+
+	msr |= BXCAN_MSR_ERRI;
+	writel(msr, &regs->msr);
+	return IRQ_HANDLED;
+}
+
+static int bxcan_start(struct net_device *ndev)
+{
+	struct bxcan_priv *priv = netdev_priv(ndev);
+	struct bxcan_regs __iomem *regs = priv->regs;
+	struct can_bittiming *bt = &priv->can.bittiming;
+	u32 set;
+	int err;
+
+	err = bxcan_chip_softreset(priv);
+	if (err) {
+		netdev_err(ndev, "failed to reset chip, error %d\n", err);
+		return err;
+	}
+
+	err = bxcan_leave_sleep_mode(priv);
+	if (err) {
+		netdev_err(ndev, "failed to leave sleep mode, error %d\n", err);
+		goto failed_leave_sleep;
+	}
+
+	err = bxcan_enter_init_mode(priv);
+	if (err) {
+		netdev_err(ndev, "failed to enter init mode, error %d\n", err);
+		goto failed_enter_init;
+	}
+
+	/* MCR
+	 *
+	 * select request order priority
+	 * disable time triggered mode
+	 * bus-off state left on sw request
+	 * sleep mode left on sw request
+	 * retransmit automatically on error
+	 * do not lock RX FIFO on overrun
+	 */
+	bxcan_rmw(&regs->mcr, BXCAN_MCR_TTCM | BXCAN_MCR_ABOM | BXCAN_MCR_AWUM |
+		  BXCAN_MCR_NART | BXCAN_MCR_RFLM, BXCAN_MCR_TXFP);
+
+	/* Bit timing register settings */
+	set = BXCAN_BTR_BRP(bt->brp - 1) |
+		BXCAN_BTR_TS1(bt->phase_seg1 + bt->prop_seg - 1) |
+		BXCAN_BTR_TS2(bt->phase_seg2 - 1) | BXCAN_BTR_SJW(bt->sjw - 1);
+
+	/* loopback + silent mode put the controller in test mode,
+	 * useful for hot self-test
+	 */
+	if (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)
+		set |= BXCAN_BTR_LBKM;
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
+		set |= BXCAN_BTR_SILM;
+
+	netdev_dbg(ndev,
+		   "TQ[ns]: %d, PrS: %d, PhS1: %d, PhS2: %d, SJW: %d, BRP: %d, CAN_BTR: 0x%08x\n",
+		   bt->tq, bt->prop_seg, bt->phase_seg1, bt->phase_seg2,
+		   bt->sjw, bt->brp, set);
+	bxcan_rmw(&regs->btr, BXCAN_BTR_SILM | BXCAN_BTR_LBKM |
+		  BXCAN_BTR_BRP_MASK | BXCAN_BTR_TS1_MASK | BXCAN_BTR_TS2_MASK |
+		  BXCAN_BTR_SJW_MASK, set);
+
+	bxcan_enable_filters(priv->dev->parent, priv->master);
+
+	err = bxcan_leave_init_mode(priv);
+	if (err) {
+		netdev_err(ndev, "failed to leave init mode, error %d\n", err);
+		goto failed_leave_init;
+	}
+
+	/* Set a `lec` value so that we can check for updates later */
+	bxcan_rmw(&regs->esr, BXCAN_ESR_LEC, LEC_UNUSED << BXCAN_ESR_LEC_SHIFT);
+
+	/* IER
+	 *
+	 * Enable interrupt for:
+	 * bus-off
+	 * passive error
+	 * warning error
+	 * last error code
+	 * RX FIFO pending message
+	 * TX mailbox empty
+	 */
+	bxcan_rmw(&regs->ier, BXCAN_IER_WKUIE | BXCAN_IER_SLKIE |
+		  BXCAN_IER_FOVIE1 | BXCAN_IER_FFIE1 | BXCAN_IER_FMPIE1 |
+		  BXCAN_IER_FOVIE0 | BXCAN_IER_FFIE0,
+		  BXCAN_IER_ERRIE | BXCAN_IER_LECIE | BXCAN_IER_BOFIE |
+		  BXCAN_IER_EPVIE | BXCAN_IER_EWGIE | BXCAN_IER_FMPIE0 |
+		  BXCAN_IER_TMEIE);
+
+	priv->can.state = CAN_STATE_ERROR_ACTIVE;
+	return 0;
+
+failed_leave_init:
+failed_enter_init:
+failed_leave_sleep:
+	bxcan_chip_softreset(priv);
+	return err;
+}
+
+static int bxcan_open(struct net_device *ndev)
+{
+	struct bxcan_priv *priv = netdev_priv(ndev);
+	int err;
+
+	err = open_candev(ndev);
+	if (err) {
+		netdev_err(ndev, "open_candev() failed, error %d\n", err);
+		goto failed_open;
+	}
+
+	napi_enable(&priv->napi);
+	err = request_irq(ndev->irq, bxcan_rx_isr, IRQF_SHARED, ndev->name,
+			  ndev);
+	if (err) {
+		netdev_err(ndev, "failed to register rx irq(%d), error %d\n",
+			   ndev->irq, err);
+		goto failed_rx_irq_request;
+	}
+
+	err = request_irq(priv->tx_irq, bxcan_tx_isr, IRQF_SHARED, ndev->name,
+			  ndev);
+	if (err) {
+		netdev_err(ndev, "failed to register tx irq(%d), error %d\n",
+			   priv->tx_irq, err);
+		goto failed_tx_irq_request;
+	}
+
+	err = request_irq(priv->sce_irq, bxcan_state_change_isr, IRQF_SHARED,
+			  ndev->name, ndev);
+	if (err) {
+		netdev_err(ndev, "failed to register sce irq(%d), error %d\n",
+			   priv->sce_irq, err);
+		goto failed_sce_irq_request;
+	}
+
+	err = bxcan_start(ndev);
+	if (err)
+		goto failed_start;
+
+	netif_start_queue(ndev);
+	return 0;
+
+failed_start:
+failed_sce_irq_request:
+	free_irq(priv->tx_irq, ndev);
+failed_tx_irq_request:
+	free_irq(ndev->irq, ndev);
+failed_rx_irq_request:
+	napi_disable(&priv->napi);
+	close_candev(ndev);
+failed_open:
+	return err;
+}
+
+static void bxcan_stop(struct net_device *ndev)
+{
+	struct bxcan_priv *priv = netdev_priv(ndev);
+
+	bxcan_disable_filters(priv->dev->parent, priv->master);
+	bxcan_enter_sleep_mode(priv);
+	priv->can.state = CAN_STATE_STOPPED;
+}
+
+static int bxcan_close(struct net_device *ndev)
+{
+	struct bxcan_priv *priv = netdev_priv(ndev);
+
+	netif_stop_queue(ndev);
+	bxcan_stop(ndev);
+	free_irq(ndev->irq, ndev);
+	free_irq(priv->tx_irq, ndev);
+	free_irq(priv->sce_irq, ndev);
+	napi_disable(&priv->napi);
+	close_candev(ndev);
+	return 0;
+}
+
+static netdev_tx_t bxcan_start_xmit(struct sk_buff *skb,
+				    struct net_device *ndev)
+{
+	struct bxcan_priv *priv = netdev_priv(ndev);
+	struct can_frame *cf = (struct can_frame *)skb->data;
+	struct bxcan_regs *regs = priv->regs;
+	struct bxcan_mb *mb_regs;
+	unsigned int mb_id;
+	u32 id, tsr;
+	int i, j;
+
+	if (can_dropped_invalid_skb(ndev, skb))
+		return NETDEV_TX_OK;
+
+	tsr = readl(&regs->tsr);
+	mb_id = ffs((tsr & BXCAN_TSR_TME) >> BXCAN_TSR_TME_SHIFT);
+	if (mb_id == 0)
+		return NETDEV_TX_BUSY;
+
+	mb_id -= 1;
+	mb_regs = &regs->tx_mb[mb_id];
+
+	if (cf->can_id & CAN_EFF_FLAG)
+		id = BXCAN_TIxR_EXID(cf->can_id & CAN_EFF_MASK) |
+			BXCAN_TIxR_IDE;
+	else
+		id = BXCAN_TIxR_STID(cf->can_id & CAN_SFF_MASK);
+
+	if (cf->can_id & CAN_RTR_FLAG)
+		id |= BXCAN_TIxR_RTR;
+
+	bxcan_rmw(&mb_regs->dlc, BXCAN_TDTxR_DLC_MASK,
+		  BXCAN_TDTxR_DLC(cf->len));
+	priv->tx_dlc[mb_id] = cf->len;
+
+	for (i = 0, j = 0; i < cf->len; i += 4, j++)
+		writel(*(u32 *)(cf->data + i), &mb_regs->data[j]);
+
+	/* Start transmission */
+	writel(id | BXCAN_TIxR_TXRQ, &mb_regs->id);
+	/* Stop the queue if we've filled all mailbox entries */
+	if (!(readl(&regs->tsr) & BXCAN_TSR_TME))
+		netif_stop_queue(ndev);
+
+	return NETDEV_TX_OK;
+}
+
+static const struct net_device_ops bxcan_netdev_ops = {
+	.ndo_open = bxcan_open,
+	.ndo_stop = bxcan_close,
+	.ndo_start_xmit = bxcan_start_xmit,
+	.ndo_change_mtu = can_change_mtu,
+};
+
+static void bxcan_rx_pkt(struct net_device *ndev, struct bxcan_mb *mb_regs)
+{
+	struct net_device_stats *stats = &ndev->stats;
+	struct can_frame *cf;
+	struct sk_buff *skb;
+	u32 id, dlc;
+
+	skb = alloc_can_skb(ndev, &cf);
+	if (!skb) {
+		stats->rx_dropped++;
+		return;
+	}
+
+	id = readl(&mb_regs->id);
+	if (id & BXCAN_RIxR_IDE)
+		cf->can_id = (id >> BXCAN_RIxR_EXID_SHIFT) | CAN_EFF_FLAG;
+	else
+		cf->can_id = (id >> BXCAN_RIxR_STID_SHIFT) & CAN_SFF_MASK;
+
+	dlc = readl(&mb_regs->dlc) & BXCAN_RDTxR_DLC;
+	cf->len = can_cc_dlc2len(dlc);
+
+	if (id & BXCAN_RIxR_RTR) {
+		cf->can_id |= CAN_RTR_FLAG;
+	} else {
+		int i, j;
+
+		for (i = 0, j = 0; i < cf->len; i += 4, j++)
+			*(u32 *)(cf->data + i) = readl(&mb_regs->data[j]);
+	}
+
+	stats->rx_bytes += cf->len;
+	stats->rx_packets++;
+	netif_receive_skb(skb);
+}
+
+static int bxcan_rx_poll(struct napi_struct *napi, int quota)
+{
+	struct net_device *ndev = napi->dev;
+	struct bxcan_priv *priv = netdev_priv(ndev);
+	struct bxcan_regs *regs = priv->regs;
+	int num_pkts;
+	u32 rf0r;
+
+	for (num_pkts = 0; num_pkts < quota; num_pkts++) {
+		rf0r = readl(&regs->rf0r);
+		if (!(rf0r & BXCAN_RF0R_FMP0))
+			break;
+
+		bxcan_rx_pkt(ndev, &regs->rx_mb[0]);
+
+		rf0r |= BXCAN_RF0R_RFOM0;
+		writel(rf0r, &regs->rf0r);
+	}
+
+	if (num_pkts < quota) {
+		napi_complete_done(napi, num_pkts);
+		bxcan_rmw(&regs->ier, 0, BXCAN_IER_FMPIE0);
+	}
+
+	return num_pkts;
+}
+
+static int bxcan_do_set_mode(struct net_device *ndev, enum can_mode mode)
+{
+	int err;
+
+	switch (mode) {
+	case CAN_MODE_START:
+		err = bxcan_start(ndev);
+		if (err)
+			return err;
+
+		netif_wake_queue(ndev);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int bxcan_disable_clks(struct bxcan_priv *priv)
+{
+	if (priv->clk)
+		clk_disable_unprepare(priv->clk);
+
+	bxcan_disable_master_clk(priv->dev->parent);
+	return 0;
+}
+
+static int bxcan_enable_clks(struct bxcan_priv *priv)
+{
+	int err;
+
+	err = bxcan_enable_master_clk(priv->dev->parent);
+	if (err)
+		return err;
+
+	if (priv->clk) {
+		err = clk_prepare_enable(priv->clk);
+		if (err)
+			bxcan_disable_master_clk(priv->dev->parent);
+	}
+
+	return err;
+}
+
+static int bxcan_get_berr_counter(const struct net_device *ndev,
+				  struct can_berr_counter *bec)
+{
+	struct bxcan_priv *priv = netdev_priv(ndev);
+	struct bxcan_regs *regs = priv->regs;
+	u32 esr;
+	int err;
+
+	err = bxcan_enable_clks(priv);
+	if (err)
+		return err;
+
+	esr = readl(&regs->esr);
+	bec->txerr = BXCAN_TEC(esr);
+	bec->rxerr = BXCAN_REC(esr);
+	err = bxcan_disable_clks(priv);
+	return 0;
+}
+
+static int bxcan_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
+	struct net_device *ndev;
+	struct bxcan_priv *priv;
+	struct clk *clk = NULL;
+	bool master;
+	u32 offset;
+	int err, rx_irq, tx_irq, sce_irq;
+
+	master = of_property_read_bool(np, "master");
+	if (!master) {
+		clk = devm_clk_get(dev, NULL);
+		if (IS_ERR(clk)) {
+			dev_err(dev, "failed to get clock\n");
+			return PTR_ERR(clk);
+		}
+	}
+
+	rx_irq = platform_get_irq_byname(pdev, "rx0");
+	if (rx_irq < 0) {
+		dev_err(dev, "failed to get rx0 irq\n");
+		return rx_irq;
+	}
+
+	tx_irq = platform_get_irq_byname(pdev, "tx");
+	if (tx_irq < 0) {
+		dev_err(dev, "failed to get tx irq\n");
+		return tx_irq;
+	}
+
+	sce_irq = platform_get_irq_byname(pdev, "sce");
+	if (sce_irq < 0) {
+		dev_err(dev, "failed to get sce irq\n");
+		return sce_irq;
+	}
+
+	err = of_property_read_u32(np, "reg", &offset);
+	if (err) {
+		dev_err(dev, "failed to get reg property\n");
+		return err;
+	}
+
+	ndev = alloc_candev(sizeof(struct bxcan_priv), 1);
+	if (!ndev) {
+		dev_err(dev, "alloc_candev() failed\n");
+		return -ENOMEM;
+	}
+
+	priv = netdev_priv(ndev);
+	platform_set_drvdata(pdev, ndev);
+	SET_NETDEV_DEV(ndev, dev);
+	ndev->netdev_ops = &bxcan_netdev_ops;
+	ndev->irq = rx_irq;
+
+	priv->dev = dev;
+	priv->regs = bxcan_get_base_addr(dev->parent) + offset;
+	priv->clk = clk;
+	priv->tx_irq = tx_irq;
+	priv->sce_irq = sce_irq;
+	priv->master = master;
+	priv->can.clock.freq =
+		master ? bxcan_get_master_clk_rate(dev->parent) :
+		clk_get_rate(clk);
+	priv->can.bittiming_const = &bxcan_bittiming_const;
+	priv->can.do_set_mode = bxcan_do_set_mode;
+	priv->can.do_get_berr_counter = bxcan_get_berr_counter;
+	priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
+		CAN_CTRLMODE_LISTENONLY	| CAN_CTRLMODE_BERR_REPORTING;
+	netif_napi_add(ndev, &priv->napi, bxcan_rx_poll, BXCAN_NAPI_WEIGHT);
+
+	err = bxcan_enable_clks(priv);
+	if (err) {
+		dev_err(dev, "failed to enable clocks\n");
+		return err;
+	}
+
+	err = register_candev(ndev);
+	if (err) {
+		dev_err(dev, "failed to register netdev\n");
+		goto failed_register;
+	}
+
+	dev_info(dev, "regs: %px, clk: %d Hz, IRQs: %d, %d, %d\n",
+		 priv->regs, priv->can.clock.freq, tx_irq, rx_irq,
+		 sce_irq);
+	return 0;
+
+failed_register:
+	netif_napi_del(&priv->napi);
+	free_candev(ndev);
+	return err;
+}
+
+static int bxcan_remove(struct platform_device *pdev)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct bxcan_priv *priv = netdev_priv(ndev);
+
+	unregister_candev(ndev);
+	bxcan_disable_clks(priv);
+	netif_napi_del(&priv->napi);
+	free_candev(ndev);
+	return 0;
+}
+
+static int __maybe_unused bxcan_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct bxcan_priv *priv = netdev_priv(ndev);
+
+	if (!netif_running(ndev))
+		return 0;
+
+	netif_stop_queue(ndev);
+	netif_device_detach(ndev);
+
+	bxcan_enter_sleep_mode(priv);
+	priv->can.state = CAN_STATE_SLEEPING;
+	bxcan_disable_clks(priv);
+	return 0;
+}
+
+static int __maybe_unused bxcan_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct bxcan_priv *priv = netdev_priv(ndev);
+
+	if (!netif_running(ndev))
+		return 0;
+
+	bxcan_enable_clks(priv);
+	bxcan_leave_sleep_mode(priv);
+	priv->can.state = CAN_STATE_ERROR_ACTIVE;
+
+	netif_device_attach(ndev);
+	netif_start_queue(ndev);
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(bxcan_pm_ops, bxcan_suspend, bxcan_resume);
+
+static const struct of_device_id bxcan_of_match[] = {
+	{.compatible = "st,stm32-bxcan"},
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, bxcan_of_match);
+
+static struct platform_driver bxcan_driver = {
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.pm = &bxcan_pm_ops,
+		.of_match_table = bxcan_of_match,
+	},
+	.probe = bxcan_probe,
+	.remove = bxcan_remove,
+};
+
+module_platform_driver(bxcan_driver);
+
+MODULE_AUTHOR("Dario Binacchi <dario.binacchi@amarulasolutions.com>");
+MODULE_DESCRIPTION("STMicroelectronics Basic Extended CAN controller driver");
+MODULE_LICENSE("GPL");
-- 
2.32.0

