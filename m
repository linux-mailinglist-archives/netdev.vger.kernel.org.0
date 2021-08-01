Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8823DC91B
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 02:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhHAAcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 20:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhHAAcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 20:32:03 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A1CC06175F
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 17:31:56 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id b21so18650255ljo.13
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 17:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r7f8Yd9lsvHscuXlvjYbkOZjjdh2QL24FXKlfk1jyMY=;
        b=ydph/LDOQAh9o9b6wu3ClbglAK2A93oKL+D3uXqqGWFmiyQOil5BOCFZ23UQDVgeqM
         PZItzpmthBfHOrHRIOJnNYx5XuEd3iMw4eTIs/0Trsez5ILbJVJD6lJWCQ4kcqfTxkgZ
         t8EmJc8QgJ6x87torCLesYw/dOj3k9aEE0hgNCMrV68Qc02jKLjL1C/FPmuYFgk6OcYZ
         fVAJxISdIiie7RYK0aXfRwKTmIs2IqVqcxv0UOlpxcoO5GZF8F7nv3vGofRa+16Su0L4
         M2IPpyvtAKbD3eSUGfZHPykwl5E1MTRWGQUTykRkniHiKqaDVLxbGW+xglGE0x3/WfX4
         Kh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r7f8Yd9lsvHscuXlvjYbkOZjjdh2QL24FXKlfk1jyMY=;
        b=jodKHw6r2gBLCxWq5Dg5Mto5FdK8nCZ8Wy9VWeUifEcGt6nA/9phfS1ZZqIwGaAvmp
         wPhH/3I4Lc/uSQwgEy7EeZUtt4DdOoAc8l5w9AQ6PO5FS4mOAZ/ISQyMC1zoNVScom/C
         IcldAIhQDrKf0GA3m8qYRLvCXTe5AzywFQkNXIrRxUVkt2lbakjpHEQXN35VQcHu5tlD
         lpMhlSs023F4dkmfvtNqaIU13VVl0ITC8HPx3sqXAl9b6ruxK4scNm9rqIcBnaisdBPq
         HlQG4sR2fso7EX6KNS5GvtWeyeZgcKx2QMhxBsx8jg/OZFp30tbEZnHVHiB/pb7Nv9F4
         NSrQ==
X-Gm-Message-State: AOAM530b6g3knz1wXlyQyC1/CiP/KDGePpLAlQxknGSt+ORVwknWhWRt
        SFz4CpGQCAz6CVX6XRR1y16EZURLGH1vBA==
X-Google-Smtp-Source: ABdhPJzWmDc6dP06Ni3Ium8tyRrUybwxi+69bNFnaWJzLAycCvxvwqaMVyR/Uq84BNB68G+rOFTIdw==
X-Received: by 2002:a2e:a41c:: with SMTP id p28mr6605463ljn.210.1627777914338;
        Sat, 31 Jul 2021 17:31:54 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r6sm485255ljk.76.2021.07.31.17.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 17:31:54 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 1/6] ixp4xx_eth: make ptp support a platform driver
Date:   Sun,  1 Aug 2021 02:27:32 +0200
Message-Id: <20210801002737.3038741-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210801002737.3038741-1-linus.walleij@linaro.org>
References: <20210801002737.3038741-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

After the recent ixp4xx cleanups, the ptp driver has gained a
build failure in some configurations:

drivers/net/ethernet/xscale/ptp_ixp46x.c: In function 'ptp_ixp_init':
drivers/net/ethernet/xscale/ptp_ixp46x.c:290:51: error: 'IXP4XX_TIMESYNC_BASE_VIRT' undeclared (first use in this function)

Avoid the last bit of hardcoded constants from platform headers
by turning the ptp driver bit into a platform driver and passing
the IRQ and MMIO address as resources.

This is a bit tricky:

- The interface between the two drivers is now the new
  ixp46x_ptp_find() function, replacing the global
  ixp46x_phc_index variable. The call is done as late
  as possible, in hwtstamp_set(), to ensure that the
  ptp device is fully probed.

- As the ptp driver is now called by the network driver, the
  link dependency is reversed, which in turn requires a small
  Makefile hack

- The GPIO number is still left hardcoded. This is clearly not
  great, but it can be addressed later. Note that commit 98ac0cc270b7
  ("ARM: ixp4xx: Convert to MULTI_IRQ_HANDLER") changed the
  IRQ number to something meaningless. Passing the correct IRQ
  in a resource fixes this.

- When the PTP driver is disabled, ethtool .get_ts_info()
  now correctly lists only software timestamping regardless
  of the hardware.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[Fix a missing include]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ixp4xx/common.c            | 14 ++++++
 drivers/net/ethernet/xscale/Kconfig      |  4 +-
 drivers/net/ethernet/xscale/Makefile     |  6 ++-
 drivers/net/ethernet/xscale/ixp46x_ts.h  | 13 ++++-
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 28 +++++++----
 drivers/net/ethernet/xscale/ptp_ixp46x.c | 61 ++++++++++++++++--------
 6 files changed, 92 insertions(+), 34 deletions(-)

diff --git a/arch/arm/mach-ixp4xx/common.c b/arch/arm/mach-ixp4xx/common.c
index b5eadd70d903..cdc720f54daa 100644
--- a/arch/arm/mach-ixp4xx/common.c
+++ b/arch/arm/mach-ixp4xx/common.c
@@ -268,9 +268,23 @@ static struct platform_device ixp46x_i2c_controller = {
 	.resource	= ixp46x_i2c_resources
 };
 
+static struct resource ixp46x_ptp_resources[] = {
+	DEFINE_RES_MEM(IXP4XX_TIMESYNC_BASE_PHYS, SZ_4K),
+	DEFINE_RES_IRQ_NAMED(IRQ_IXP4XX_GPIO8, "master"),
+	DEFINE_RES_IRQ_NAMED(IRQ_IXP4XX_GPIO7, "slave"),
+};
+
+static struct platform_device ixp46x_ptp = {
+	.name		= "ptp-ixp46x",
+	.id		= -1,
+	.resource	= ixp46x_ptp_resources,
+	.num_resources	= ARRAY_SIZE(ixp46x_ptp_resources),
+};
+
 static struct platform_device *ixp46x_devices[] __initdata = {
 	&ixp46x_hwrandom_device,
 	&ixp46x_i2c_controller,
+	&ixp46x_ptp,
 };
 
 unsigned long ixp4xx_exp_bus_size;
diff --git a/drivers/net/ethernet/xscale/Kconfig b/drivers/net/ethernet/xscale/Kconfig
index 468ffe3d1707..0e878fa6e322 100644
--- a/drivers/net/ethernet/xscale/Kconfig
+++ b/drivers/net/ethernet/xscale/Kconfig
@@ -29,9 +29,9 @@ config IXP4XX_ETH
 	  on IXP4xx processor.
 
 config PTP_1588_CLOCK_IXP46X
-	tristate "Intel IXP46x as PTP clock"
+	bool "Intel IXP46x as PTP clock"
 	depends on IXP4XX_ETH
-	depends on PTP_1588_CLOCK
+	depends on PTP_1588_CLOCK=y || PTP_1588_CLOCK=IXP4XX_ETH
 	default y
 	help
 	  This driver adds support for using the IXP46X as a PTP
diff --git a/drivers/net/ethernet/xscale/Makefile b/drivers/net/ethernet/xscale/Makefile
index 607f91b1e878..e935f2a2979f 100644
--- a/drivers/net/ethernet/xscale/Makefile
+++ b/drivers/net/ethernet/xscale/Makefile
@@ -3,5 +3,9 @@
 # Makefile for the Intel XScale IXP device drivers.
 #
 
+# Keep this link order to avoid deferred probing
+ifdef CONFIG_PTP_1588_CLOCK_IXP46X
+obj-$(CONFIG_IXP4XX_ETH)		+= ptp_ixp46x.o
+endif
+
 obj-$(CONFIG_IXP4XX_ETH)		+= ixp4xx_eth.o
-obj-$(CONFIG_PTP_1588_CLOCK_IXP46X)	+= ptp_ixp46x.o
diff --git a/drivers/net/ethernet/xscale/ixp46x_ts.h b/drivers/net/ethernet/xscale/ixp46x_ts.h
index d792130e27b0..ee9b93ded20a 100644
--- a/drivers/net/ethernet/xscale/ixp46x_ts.h
+++ b/drivers/net/ethernet/xscale/ixp46x_ts.h
@@ -62,7 +62,16 @@ struct ixp46x_ts_regs {
 #define TX_SNAPSHOT_LOCKED (1<<0)
 #define RX_SNAPSHOT_LOCKED (1<<1)
 
-/* The ptp_ixp46x module will set this variable */
-extern int ixp46x_phc_index;
+#if IS_ENABLED(CONFIG_PTP_1588_CLOCK_IXP46X)
+int ixp46x_ptp_find(struct ixp46x_ts_regs *__iomem *regs, int *phc_index);
+#else
+static inline int ixp46x_ptp_find(struct ixp46x_ts_regs *__iomem *regs, int *phc_index)
+{
+	*regs = NULL;
+	*phc_index = -1;
+
+	return -ENODEV;
+}
+#endif
 
 #endif
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 7ae754eadf22..32dc2c7abb22 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -169,6 +169,8 @@ struct eth_regs {
 
 struct port {
 	struct eth_regs __iomem *regs;
+	struct ixp46x_ts_regs __iomem *timesync_regs;
+	int phc_index;
 	struct npe *npe;
 	struct net_device *netdev;
 	struct napi_struct napi;
@@ -295,7 +297,7 @@ static void ixp_rx_timestamp(struct port *port, struct sk_buff *skb)
 
 	ch = PORT2CHANNEL(port);
 
-	regs = (struct ixp46x_ts_regs __iomem *) IXP4XX_TIMESYNC_BASE_VIRT;
+	regs = port->timesync_regs;
 
 	val = __raw_readl(&regs->channel[ch].ch_event);
 
@@ -340,7 +342,7 @@ static void ixp_tx_timestamp(struct port *port, struct sk_buff *skb)
 
 	ch = PORT2CHANNEL(port);
 
-	regs = (struct ixp46x_ts_regs __iomem *) IXP4XX_TIMESYNC_BASE_VIRT;
+	regs = port->timesync_regs;
 
 	/*
 	 * This really stinks, but we have to poll for the Tx time stamp.
@@ -375,6 +377,7 @@ static int hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
 	struct hwtstamp_config cfg;
 	struct ixp46x_ts_regs *regs;
 	struct port *port = netdev_priv(netdev);
+	int ret;
 	int ch;
 
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
@@ -383,8 +386,12 @@ static int hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
 	if (cfg.flags) /* reserved for future extensions */
 		return -EINVAL;
 
+	ret = ixp46x_ptp_find(&port->timesync_regs, &port->phc_index);
+	if (ret)
+		return ret;
+
 	ch = PORT2CHANNEL(port);
-	regs = (struct ixp46x_ts_regs __iomem *) IXP4XX_TIMESYNC_BASE_VIRT;
+	regs = port->timesync_regs;
 
 	if (cfg.tx_type != HWTSTAMP_TX_OFF && cfg.tx_type != HWTSTAMP_TX_ON)
 		return -ERANGE;
@@ -988,25 +995,27 @@ static void ixp4xx_get_drvinfo(struct net_device *dev,
 	strlcpy(info->bus_info, "internal", sizeof(info->bus_info));
 }
 
-int ixp46x_phc_index = -1;
-EXPORT_SYMBOL_GPL(ixp46x_phc_index);
-
 static int ixp4xx_get_ts_info(struct net_device *dev,
 			      struct ethtool_ts_info *info)
 {
-	if (!cpu_is_ixp46x()) {
+	struct port *port = netdev_priv(dev);
+
+	if (port->phc_index < 0)
+		ixp46x_ptp_find(&port->timesync_regs, &port->phc_index);
+
+	info->phc_index = port->phc_index;
+
+	if (info->phc_index < 0) {
 		info->so_timestamping =
 			SOF_TIMESTAMPING_TX_SOFTWARE |
 			SOF_TIMESTAMPING_RX_SOFTWARE |
 			SOF_TIMESTAMPING_SOFTWARE;
-		info->phc_index = -1;
 		return 0;
 	}
 	info->so_timestamping =
 		SOF_TIMESTAMPING_TX_HARDWARE |
 		SOF_TIMESTAMPING_RX_HARDWARE |
 		SOF_TIMESTAMPING_RAW_HARDWARE;
-	info->phc_index = ixp46x_phc_index;
 	info->tx_types =
 		(1 << HWTSTAMP_TX_OFF) |
 		(1 << HWTSTAMP_TX_ON);
@@ -1481,6 +1490,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	port = netdev_priv(ndev);
 	port->netdev = ndev;
 	port->id = plat->npe;
+	port->phc_index = -1;
 
 	/* Get the port resource and remap */
 	port->regs = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index 99d4d9439d05..6232a0e0710e 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2010 OMICRON electronics GmbH
  */
 #include <linux/device.h>
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/init.h>
@@ -13,6 +14,7 @@
 #include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/ptp_clock_kernel.h>
+#include <linux/platform_device.h>
 #include <linux/soc/ixp4xx/cpu.h>
 
 #include "ixp46x_ts.h"
@@ -20,9 +22,7 @@
 #define DRIVER		"ptp_ixp46x"
 #define N_EXT_TS	2
 #define MASTER_GPIO	8
-#define MASTER_IRQ	25
 #define SLAVE_GPIO	7
-#define SLAVE_IRQ	24
 
 struct ixp_clock {
 	struct ixp46x_ts_regs *regs;
@@ -30,9 +30,11 @@ struct ixp_clock {
 	struct ptp_clock_info caps;
 	int exts0_enabled;
 	int exts1_enabled;
+	int slave_irq;
+	int master_irq;
 };
 
-DEFINE_SPINLOCK(register_lock);
+static DEFINE_SPINLOCK(register_lock);
 
 /*
  * Register access functions
@@ -273,21 +275,36 @@ static int setup_interrupt(int gpio)
 	return irq;
 }
 
-static void __exit ptp_ixp_exit(void)
+int ixp46x_ptp_find(struct ixp46x_ts_regs *__iomem *regs, int *phc_index)
 {
-	free_irq(MASTER_IRQ, &ixp_clock);
-	free_irq(SLAVE_IRQ, &ixp_clock);
-	ixp46x_phc_index = -1;
-	ptp_clock_unregister(ixp_clock.ptp_clock);
+	*regs = ixp_clock.regs;
+	*phc_index = ptp_clock_index(ixp_clock.ptp_clock);
+
+	if (!ixp_clock.ptp_clock)
+		return -EPROBE_DEFER;
+
+	return 0;
 }
+EXPORT_SYMBOL_GPL(ixp46x_ptp_find);
 
-static int __init ptp_ixp_init(void)
+static int ptp_ixp_remove(struct platform_device *pdev)
 {
-	if (!cpu_is_ixp46x())
-		return -ENODEV;
+	free_irq(ixp_clock.master_irq, &ixp_clock);
+	free_irq(ixp_clock.slave_irq, &ixp_clock);
+	ptp_clock_unregister(ixp_clock.ptp_clock);
+	ixp_clock.ptp_clock = NULL;
 
-	ixp_clock.regs =
-		(struct ixp46x_ts_regs __iomem *) IXP4XX_TIMESYNC_BASE_VIRT;
+	return 0;
+}
+
+static int ptp_ixp_probe(struct platform_device *pdev)
+{
+	ixp_clock.regs = devm_platform_ioremap_resource(pdev, 0);
+	ixp_clock.master_irq = platform_get_irq(pdev, 0);
+	ixp_clock.slave_irq = platform_get_irq(pdev, 1);
+	if (IS_ERR(ixp_clock.regs) ||
+	    !ixp_clock.master_irq || !ixp_clock.slave_irq)
+		return -ENXIO;
 
 	ixp_clock.caps = ptp_ixp_caps;
 
@@ -296,32 +313,36 @@ static int __init ptp_ixp_init(void)
 	if (IS_ERR(ixp_clock.ptp_clock))
 		return PTR_ERR(ixp_clock.ptp_clock);
 
-	ixp46x_phc_index = ptp_clock_index(ixp_clock.ptp_clock);
-
 	__raw_writel(DEFAULT_ADDEND, &ixp_clock.regs->addend);
 	__raw_writel(1, &ixp_clock.regs->trgt_lo);
 	__raw_writel(0, &ixp_clock.regs->trgt_hi);
 	__raw_writel(TTIPEND, &ixp_clock.regs->event);
 
-	if (MASTER_IRQ != setup_interrupt(MASTER_GPIO)) {
+	if (ixp_clock.master_irq != setup_interrupt(MASTER_GPIO)) {
 		pr_err("failed to setup gpio %d as irq\n", MASTER_GPIO);
 		goto no_master;
 	}
-	if (SLAVE_IRQ != setup_interrupt(SLAVE_GPIO)) {
+	if (ixp_clock.slave_irq != setup_interrupt(SLAVE_GPIO)) {
 		pr_err("failed to setup gpio %d as irq\n", SLAVE_GPIO);
 		goto no_slave;
 	}
 
 	return 0;
 no_slave:
-	free_irq(MASTER_IRQ, &ixp_clock);
+	free_irq(ixp_clock.master_irq, &ixp_clock);
 no_master:
 	ptp_clock_unregister(ixp_clock.ptp_clock);
+	ixp_clock.ptp_clock = NULL;
 	return -ENODEV;
 }
 
-module_init(ptp_ixp_init);
-module_exit(ptp_ixp_exit);
+static struct platform_driver ptp_ixp_driver = {
+	.driver.name = "ptp-ixp46x",
+	.driver.suppress_bind_attrs = true,
+	.probe = ptp_ixp_probe,
+	.remove = ptp_ixp_remove,
+};
+module_platform_driver(ptp_ixp_driver);
 
 MODULE_AUTHOR("Richard Cochran <richardcochran@gmail.com>");
 MODULE_DESCRIPTION("PTP clock using the IXP46X timer");
-- 
2.31.1

