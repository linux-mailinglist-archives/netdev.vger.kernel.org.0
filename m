Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 017B719021B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 00:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgCWXnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 19:43:47 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49137 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbgCWXnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 19:43:43 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48mWDD6yH1z1qsbM;
        Tue, 24 Mar 2020 00:43:40 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48mWDD6lg6z1qyDk;
        Tue, 24 Mar 2020 00:43:40 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id JwuO2xV1MLpM; Tue, 24 Mar 2020 00:43:38 +0100 (CET)
X-Auth-Info: XzzCk/4oR/ZCx1srQcCVMKTWAMDxgg4RTQ2rwybfhRs=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 24 Mar 2020 00:43:38 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH 13/14] net: ks8851: Implement Parallel bus operations
Date:   Tue, 24 Mar 2020 00:43:02 +0100
Message-Id: <20200323234303.526748-14-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323234303.526748-1-marex@denx.de>
References: <20200323234303.526748-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement accessors for KS8851-16MLL/MLLI/MLLU parallel bus variant of
the KS8851. This is based off the ks8851_mll.c , which is a driver for
exactly the same hardware, however the ks8851.c code is much higher
quality. Hence, this patch pulls out the relevant information from the
ks8851_mll.c on how to access the bus, but uses the common ks8851.c
code. To make this patch reviewable, instead of rewriting ks8851_mll.c,
ks8851_mll.c is removed in a separate subsequent patch.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/micrel/Makefile     |   2 +-
 drivers/net/ethernet/micrel/ks8851_par.c | 201 +++++++++++++++++++++++
 2 files changed, 202 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/micrel/ks8851_par.c

diff --git a/drivers/net/ethernet/micrel/Makefile b/drivers/net/ethernet/micrel/Makefile
index bb5c6c53fa02..bff104b15aaa 100644
--- a/drivers/net/ethernet/micrel/Makefile
+++ b/drivers/net/ethernet/micrel/Makefile
@@ -5,5 +5,5 @@
 
 obj-$(CONFIG_KS8842) += ks8842.o
 obj-$(CONFIG_KS8851) += ks8851.o ks8851_spi.o
-obj-$(CONFIG_KS8851_MLL) += ks8851_mll.o
+obj-$(CONFIG_KS8851_MLL) += ks8851.o ks8851_par.o
 obj-$(CONFIG_KSZ884X_PCI) += ksz884x.o
diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
new file mode 100644
index 000000000000..2b1be1293c42
--- /dev/null
+++ b/drivers/net/ethernet/micrel/ks8851_par.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* drivers/net/ethernet/micrel/ks8851.c
+ *
+ * Copyright 2009 Simtec Electronics
+ *	http://www.simtec.co.uk/
+ *	Ben Dooks <ben@simtec.co.uk>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#define DEBUG
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/cache.h>
+#include <linux/crc32.h>
+#include <linux/mii.h>
+#include <linux/eeprom_93cx6.h>
+#include <linux/regulator/consumer.h>
+
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/of_net.h>
+
+#include "ks8851.h"
+
+#define BE3             0x8000      /* Byte Enable 3 */
+#define BE2             0x4000      /* Byte Enable 2 */
+#define BE1             0x2000      /* Byte Enable 1 */
+#define BE0             0x1000      /* Byte Enable 0 */
+
+/**
+ * struct ks8851_net_par - KS8851 Parallel driver private data
+ * @ks8851: KS8851 driver common private data
+ * @hw_addr	: start address of data register.
+ * @hw_addr_cmd	: start address of command register.
+ * @cmd_reg_cache	: command register cached.
+ */
+struct ks8851_net_par {
+	struct ks8851_net	ks8851;	/* Must be first */
+	void __iomem		*hw_addr;
+	void __iomem		*hw_addr_cmd;
+	u16			cmd_reg_cache;
+};
+
+#define to_ks8851_par(ks) container_of((ks), struct ks8851_net_par, ks8851)
+
+/**
+ * ks8851_wrreg16_par - write 16bit register value to chip
+ * @ks: The chip state
+ * @reg: The register address
+ * @val: The value to write
+ *
+ * Issue a write to put the value @val into the register specified in @reg.
+ */
+static void ks8851_wrreg16_par(struct ks8851_net *ks, unsigned int reg,
+			       unsigned int val)
+{
+	struct ks8851_net_par *ksp = to_ks8851_par(ks);
+
+	ksp->cmd_reg_cache = (u16)reg | ((BE3 | BE2) >> (reg & 0x02));
+	iowrite16(ksp->cmd_reg_cache, ksp->hw_addr_cmd);
+	iowrite16(val, ksp->hw_addr);
+}
+
+/**
+ * ks8851_rdreg16_par - read 16 bit register from device via SPI
+ * @ks: The chip information
+ * @reg: The register address
+ *
+ * Read a 16bit register from the chip, returning the result
+ */
+static unsigned int ks8851_rdreg16_par(struct ks8851_net *ks, unsigned int reg)
+{
+	struct ks8851_net_par *ksp = to_ks8851_par(ks);
+
+	ksp->cmd_reg_cache = (u16)reg | ((BE3 | BE2) >> (reg & 0x02));
+	iowrite16(ksp->cmd_reg_cache, ksp->hw_addr_cmd);
+	return ioread16(ksp->hw_addr);
+}
+
+/**
+ * ks8851_rdfifo_par - read data from the receive fifo
+ * @ks: The device state.
+ * @buff: The buffer address
+ * @len: The length of the data to read
+ *
+ * Issue an RXQ FIFO read command and read the @len amount of data from
+ * the FIFO into the buffer specified by @buff.
+ */
+static void ks8851_rdfifo_par(struct ks8851_net *ks, u8 *buff, unsigned int len)
+{
+	struct ks8851_net_par *ksp = to_ks8851_par(ks);
+	u16 *wptr = (u16 *)(buff + 2);
+
+	netif_dbg(ks, rx_status, ks->netdev,
+		  "%s: %d@%p\n", __func__, len, buff);
+
+	len >>= 1;
+	while (len--)
+		*wptr++ = be16_to_cpu(ioread16(ksp->hw_addr));
+}
+
+/**
+ * ks8851_wrpkt_par - write packet to TX FIFO
+ * @ks: The device state.
+ * @txp: The sk_buff to transmit.
+ * @irq: IRQ on completion of the packet.
+ *
+ * Send the @txp to the chip. This means creating the relevant packet header
+ * specifying the length of the packet and the other information the chip
+ * needs, such as IRQ on completion. Send the header and the packet data to
+ * the device.
+ */
+static void ks8851_wrpkt_par(struct ks8851_net *ks, struct sk_buff *txp,
+			     bool irq)
+{
+	struct ks8851_net_par *ksp = to_ks8851_par(ks);
+	unsigned int len = ALIGN(txp->len, 4);
+	u16 *wptr = (u16 *)txp->data;
+	unsigned int fid = 0;
+
+	netif_dbg(ks, tx_queued, ks->netdev, "%s: skb %p, %d@%p, irq %d\n",
+		  __func__, txp, txp->len, txp->data, irq);
+
+	fid = ks->fid++;
+	fid &= TXFR_TXFID_MASK;
+
+	if (irq)
+		fid |= TXFR_TXIC;	/* irq on completion */
+
+	iowrite16(cpu_to_be16(fid), ksp->hw_addr);
+	iowrite16(cpu_to_be16(txp->len), ksp->hw_addr);
+
+	len >>= 1;
+	while (len--)
+		iowrite16(cpu_to_be16(*wptr++), ksp->hw_addr);
+}
+
+static int ks8851_probe_par(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ks8851_net_par *ksp;
+	struct net_device *ndev;
+	struct ks8851_net *ks;
+
+	ndev = devm_alloc_etherdev(dev, sizeof(struct ks8851_net_par));
+	if (!ndev)
+		return -ENOMEM;
+
+	ks = netdev_priv(ndev);
+	ks->rdreg16 = ks8851_rdreg16_par;
+	ks->wrreg16 = ks8851_wrreg16_par;
+	ks->rdfifo = ks8851_rdfifo_par;
+	ks->wrfifo = ks8851_wrpkt_par;
+
+	ksp = to_ks8851_par(ks);
+
+	ksp->hw_addr = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(ksp->hw_addr))
+		return PTR_ERR(ksp->hw_addr);
+
+	ksp->hw_addr_cmd = devm_platform_ioremap_resource(pdev, 1);
+	if (IS_ERR(ksp->hw_addr_cmd))
+		return PTR_ERR(ksp->hw_addr_cmd);
+
+	ndev->irq = platform_get_irq(pdev, 0);
+
+	return ks8851_probe_common(ndev, dev);
+}
+
+static int ks8851_remove_par(struct platform_device *pdev)
+{
+	return ks8851_remove_common(&pdev->dev);
+}
+
+static const struct of_device_id ks8851_match_table[] = {
+	{ .compatible = "micrel,ks8851-mll" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, ks8851_match_table);
+
+static struct platform_driver ks8851_driver = {
+	.driver = {
+		.name = "ks8851",
+		.of_match_table = ks8851_match_table,
+		.pm = &ks8851_pm_ops,
+	},
+	.probe = ks8851_probe_par,
+	.remove = ks8851_remove_par,
+};
+module_platform_driver(ks8851_driver);
+
+MODULE_DESCRIPTION("KS8851 Network driver");
+MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
+MODULE_LICENSE("GPL");
-- 
2.25.1

