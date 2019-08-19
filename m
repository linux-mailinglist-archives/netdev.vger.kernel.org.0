Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82CB0949F5
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfHSQc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:32:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:55432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728036AbfHSQcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:32:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 011DDB632;
        Mon, 19 Aug 2019 16:32:08 +0000 (UTC)
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
Subject: [PATCH v5 17/17] Input: add IOC3 serio driver
Date:   Mon, 19 Aug 2019 18:31:40 +0200
Message-Id: <20190819163144.3478-18-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190819163144.3478-1-tbogendoerfer@suse.de>
References: <20190819163144.3478-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a platform driver for supporting keyboard and mouse
interface of SGI IOC3 chips.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/input/serio/Kconfig   |  10 +++
 drivers/input/serio/Makefile  |   1 +
 drivers/input/serio/ioc3kbd.c | 160 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 171 insertions(+)
 create mode 100644 drivers/input/serio/ioc3kbd.c

diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index f3e18f8ef9ca..373a1646019e 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -165,6 +165,16 @@ config SERIO_MACEPS2
 	  To compile this driver as a module, choose M here: the
 	  module will be called maceps2.
 
+config SERIO_SGI_IOC3
+	tristate "SGI IOC3 PS/2 controller"
+	depends on SGI_MFD_IOC3
+	help
+	  Say Y here if you have an SGI Onyx2, SGI Octane or IOC3 PCI card
+	  and you want to attach and use a keyboard, mouse, or both.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ioc3kbd.
+
 config SERIO_LIBPS2
 	tristate "PS/2 driver library"
 	depends on SERIO_I8042 || SERIO_I8042=n
diff --git a/drivers/input/serio/Makefile b/drivers/input/serio/Makefile
index 67950a5ccb3f..6d97bad7b844 100644
--- a/drivers/input/serio/Makefile
+++ b/drivers/input/serio/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_HIL_MLC)		+= hp_sdc_mlc.o hil_mlc.o
 obj-$(CONFIG_SERIO_PCIPS2)	+= pcips2.o
 obj-$(CONFIG_SERIO_PS2MULT)	+= ps2mult.o
 obj-$(CONFIG_SERIO_MACEPS2)	+= maceps2.o
+obj-$(CONFIG_SERIO_SGI_IOC3)	+= ioc3kbd.o
 obj-$(CONFIG_SERIO_LIBPS2)	+= libps2.o
 obj-$(CONFIG_SERIO_RAW)		+= serio_raw.o
 obj-$(CONFIG_SERIO_AMS_DELTA)	+= ams_delta_serio.o
diff --git a/drivers/input/serio/ioc3kbd.c b/drivers/input/serio/ioc3kbd.c
new file mode 100644
index 000000000000..32df2743c27f
--- /dev/null
+++ b/drivers/input/serio/ioc3kbd.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * SGI IOC3 PS/2 controller driver for linux
+ *
+ * Copyright (C) 2019 Thomas Bogendoerfer <tbogendoerfer@suse.de>
+ *
+ * Based on code Copyright (C) 2005 Stanislaw Skowronek <skylark@unaligned.org>
+ *               Copyright (C) 2009 Johannes Dickgreber <tanzy@gmx.de>
+ */
+
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/serio.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <asm/sn/ioc3.h>
+
+struct ioc3kbd_data {
+	struct ioc3_serioregs __iomem *regs;
+	struct serio *kbd, *aux;
+	int irq;
+};
+
+static int ioc3kbd_write(struct serio *dev, u8 val)
+{
+	struct ioc3kbd_data *d = dev->port_data;
+	unsigned long timeout = 0;
+	u32 mask;
+
+	mask = (dev == d->aux) ? KM_CSR_M_WRT_PEND : KM_CSR_K_WRT_PEND;
+	while ((readl(&d->regs->km_csr) & mask) && (timeout < 1000)) {
+		udelay(100);
+		timeout++;
+	}
+
+	if (timeout >= 1000)
+		return -ETIMEDOUT;
+
+	writel(val, dev == d->aux ? &d->regs->m_wd : &d->regs->k_wd);
+
+	return 0;
+}
+
+static irqreturn_t ioc3kbd_intr(int itq, void *dev_id)
+{
+	struct ioc3kbd_data *d = dev_id;
+	u32 data_k, data_m;
+
+	data_k = readl(&d->regs->k_rd);
+	data_m = readl(&d->regs->m_rd);
+
+	if (data_k & KM_RD_VALID_0)
+		serio_interrupt(d->kbd, (data_k >> KM_RD_DATA_0_SHIFT) & 0xff,
+				0);
+	if (data_k & KM_RD_VALID_1)
+		serio_interrupt(d->kbd, (data_k >> KM_RD_DATA_1_SHIFT) & 0xff,
+				0);
+	if (data_k & KM_RD_VALID_2)
+		serio_interrupt(d->kbd, (data_k >> KM_RD_DATA_2_SHIFT) & 0xff,
+				0);
+	if (data_m & KM_RD_VALID_0)
+		serio_interrupt(d->aux, (data_m >> KM_RD_DATA_0_SHIFT) & 0xff,
+				0);
+	if (data_m & KM_RD_VALID_1)
+		serio_interrupt(d->aux, (data_m >> KM_RD_DATA_1_SHIFT) & 0xff,
+				0);
+	if (data_m & KM_RD_VALID_2)
+		serio_interrupt(d->aux, (data_m >> KM_RD_DATA_2_SHIFT) & 0xff,
+				0);
+
+	return IRQ_HANDLED;
+}
+
+static int ioc3kbd_probe(struct platform_device *pdev)
+{
+	struct ioc3_serioregs __iomem *regs;
+	struct device *dev = &pdev->dev;
+	struct ioc3kbd_data *d;
+	struct serio *sk, *sa;
+	int irq, ret;
+
+	regs = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return -ENXIO;
+
+	d = devm_kzalloc(dev, sizeof(*d), GFP_KERNEL);
+	if (!d)
+		return -ENOMEM;
+
+	sk = kzalloc(sizeof(*sk), GFP_KERNEL);
+	if (!sk)
+		return -ENOMEM;
+
+	sa = kzalloc(sizeof(*sa), GFP_KERNEL);
+	if (!sa) {
+		kfree(sk);
+		return -ENOMEM;
+	}
+
+	sk->id.type = SERIO_8042;
+	sk->write = ioc3kbd_write;
+	snprintf(sk->name, sizeof(sk->name), "IOC3 keyboard %d", pdev->id);
+	snprintf(sk->phys, sizeof(sk->phys), "ioc3/serio%dkbd", pdev->id);
+	sk->port_data = d;
+	sk->dev.parent = dev;
+
+	sa->id.type = SERIO_8042;
+	sa->write = ioc3kbd_write;
+	snprintf(sa->name, sizeof(sa->name), "IOC3 auxiliary %d", pdev->id);
+	snprintf(sa->phys, sizeof(sa->phys), "ioc3/serio%daux", pdev->id);
+	sa->port_data = d;
+	sa->dev.parent = dev;
+
+	d->regs = regs;
+	d->kbd = sk;
+	d->aux = sa;
+	d->irq = irq;
+
+	platform_set_drvdata(pdev, d);
+	serio_register_port(d->kbd);
+	serio_register_port(d->aux);
+
+	ret = request_irq(irq, ioc3kbd_intr, IRQF_SHARED, "ioc3-kbd", d);
+	if (ret) {
+		dev_err(dev, "could not request IRQ %d\n", irq);
+		serio_unregister_port(d->kbd);
+		serio_unregister_port(d->aux);
+		return ret;
+	}
+	return 0;
+}
+
+static int ioc3kbd_remove(struct platform_device *pdev)
+{
+	struct ioc3kbd_data *d = platform_get_drvdata(pdev);
+
+	free_irq(d->irq, d);
+	serio_unregister_port(d->kbd);
+	serio_unregister_port(d->aux);
+	return 0;
+}
+
+static struct platform_driver ioc3kbd_driver = {
+	.probe          = ioc3kbd_probe,
+	.remove         = ioc3kbd_remove,
+	.driver = {
+		.name = "ioc3-kbd",
+	},
+};
+module_platform_driver(ioc3kbd_driver);
+
+MODULE_AUTHOR("Thomas Bogendoerfer <tbogendoerfer@suse.de>");
+MODULE_DESCRIPTION("SGI IOC3 serio driver");
+MODULE_LICENSE("GPL");
-- 
2.13.7

