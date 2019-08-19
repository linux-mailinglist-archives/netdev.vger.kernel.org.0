Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2285949EA
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbfHSQcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:32:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:55232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727483AbfHSQcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:32:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 310D4B052;
        Mon, 19 Aug 2019 16:32:01 +0000 (UTC)
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
Subject: [PATCH v5 01/17] w1: add 1-wire master driver for IP block found in SGI ASICs
Date:   Mon, 19 Aug 2019 18:31:24 +0200
Message-Id: <20190819163144.3478-2-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190819163144.3478-1-tbogendoerfer@suse.de>
References: <20190819163144.3478-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting with SGI Origin machines nearly every new SGI ASIC contains
an 1-Wire master. They are used for attaching One-Wire prom devices,
which contain information about part numbers, revision numbers,
serial number etc. and MAC addresses for ethernet interfaces.
This patch adds a master driver to support this IP block.
It also adds an extra field dev_id to struct w1_bus_master, which
could be in used in slave drivers for creating unique device names.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/w1/masters/Kconfig           |   9 +++
 drivers/w1/masters/Makefile          |   1 +
 drivers/w1/masters/sgi_w1.c          | 130 +++++++++++++++++++++++++++++++++++
 include/linux/platform_data/sgi-w1.h |  15 ++++
 include/linux/w1.h                   |   2 +
 5 files changed, 157 insertions(+)
 create mode 100644 drivers/w1/masters/sgi_w1.c
 create mode 100644 include/linux/platform_data/sgi-w1.h

diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index 7ae260577901..24b9a8e05f64 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -65,5 +65,14 @@ config HDQ_MASTER_OMAP
 	  Say Y here if you want support for the 1-wire or HDQ Interface
 	  on an OMAP processor.
 
+config W1_MASTER_SGI
+	tristate "SGI ASIC driver"
+	help
+	  Say Y here if you want support for your 1-wire devices using
+	  SGI ASIC 1-Wire interface
+
+	  This support is also available as a module.  If so, the module
+	  will be called sgi_w1.
+
 endmenu
 
diff --git a/drivers/w1/masters/Makefile b/drivers/w1/masters/Makefile
index 18954cae4256..dae629b7ab49 100644
--- a/drivers/w1/masters/Makefile
+++ b/drivers/w1/masters/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_W1_MASTER_MXC)		+= mxc_w1.o
 obj-$(CONFIG_W1_MASTER_DS1WM)		+= ds1wm.o
 obj-$(CONFIG_W1_MASTER_GPIO)		+= w1-gpio.o
 obj-$(CONFIG_HDQ_MASTER_OMAP)		+= omap_hdq.o
+obj-$(CONFIG_W1_MASTER_SGI)		+= sgi_w1.o
diff --git a/drivers/w1/masters/sgi_w1.c b/drivers/w1/masters/sgi_w1.c
new file mode 100644
index 000000000000..1b2d96b945be
--- /dev/null
+++ b/drivers/w1/masters/sgi_w1.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * sgi_w1.c - w1 master driver for one wire support in SGI ASICs
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/sgi-w1.h>
+
+#include <linux/w1.h>
+
+#define MCR_RD_DATA	BIT(0)
+#define MCR_DONE	BIT(1)
+
+#define MCR_PACK(pulse, sample) (((pulse) << 10) | ((sample) << 2))
+
+struct sgi_w1_device {
+	u32 __iomem *mcr;
+	struct w1_bus_master bus_master;
+	char dev_id[64];
+};
+
+static u8 sgi_w1_wait(u32 __iomem *mcr)
+{
+	u32 mcr_val;
+
+	do {
+		mcr_val = readl(mcr);
+	} while (!(mcr_val & MCR_DONE));
+
+	return (mcr_val & MCR_RD_DATA) ? 1 : 0;
+}
+
+/*
+ * this is the low level routine to
+ * reset the device on the One Wire interface
+ * on the hardware
+ */
+static u8 sgi_w1_reset_bus(void *data)
+{
+	struct sgi_w1_device *dev = data;
+	u8 ret;
+
+	writel(MCR_PACK(520, 65), dev->mcr);
+	ret = sgi_w1_wait(dev->mcr);
+	udelay(500); /* recovery time */
+	return ret;
+}
+
+/*
+ * this is the low level routine to read/write a bit on the One Wire
+ * interface on the hardware. It does write 0 if parameter bit is set
+ * to 0, otherwise a write 1/read.
+ */
+static u8 sgi_w1_touch_bit(void *data, u8 bit)
+{
+	struct sgi_w1_device *dev = data;
+	u8 ret;
+
+	if (bit)
+		writel(MCR_PACK(6, 13), dev->mcr);
+	else
+		writel(MCR_PACK(80, 30), dev->mcr);
+
+	ret = sgi_w1_wait(dev->mcr);
+	if (bit)
+		udelay(100); /* recovery */
+	return ret;
+}
+
+static int sgi_w1_probe(struct platform_device *pdev)
+{
+	struct sgi_w1_device *sdev;
+	struct sgi_w1_platform_data *pdata;
+	struct resource *res;
+
+	sdev = devm_kzalloc(&pdev->dev, sizeof(struct sgi_w1_device),
+			    GFP_KERNEL);
+	if (!sdev)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	sdev->mcr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(sdev->mcr))
+		return PTR_ERR(sdev->mcr);
+
+	sdev->bus_master.data = sdev;
+	sdev->bus_master.reset_bus = sgi_w1_reset_bus;
+	sdev->bus_master.touch_bit = sgi_w1_touch_bit;
+
+	pdata = dev_get_platdata(&pdev->dev);
+	if (pdata) {
+		strlcpy(sdev->dev_id, pdata->dev_id, sizeof(sdev->dev_id));
+		sdev->bus_master.dev_id = sdev->dev_id;
+	}
+
+	platform_set_drvdata(pdev, sdev);
+
+	return w1_add_master_device(&sdev->bus_master);
+}
+
+/*
+ * disassociate the w1 device from the driver
+ */
+static int sgi_w1_remove(struct platform_device *pdev)
+{
+	struct sgi_w1_device *sdev = platform_get_drvdata(pdev);
+
+	w1_remove_master_device(&sdev->bus_master);
+
+	return 0;
+}
+
+static struct platform_driver sgi_w1_driver = {
+	.driver = {
+		.name = "sgi_w1",
+	},
+	.probe = sgi_w1_probe,
+	.remove = sgi_w1_remove,
+};
+module_platform_driver(sgi_w1_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Thomas Bogendoerfer");
+MODULE_DESCRIPTION("Driver for One-Wire IP in SGI ASICs");
diff --git a/include/linux/platform_data/sgi-w1.h b/include/linux/platform_data/sgi-w1.h
new file mode 100644
index 000000000000..fc6b92e0b942
--- /dev/null
+++ b/include/linux/platform_data/sgi-w1.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * SGI One-Wire (W1) IP
+ */
+
+#ifndef PLATFORM_DATA_SGI_W1_H
+#define PLATFORM_DATA_SGI_W1_H
+
+#include <asm/sn/types.h>
+
+struct sgi_w1_platform_data {
+	char dev_id[64];
+};
+
+#endif /* PLATFORM_DATA_SGI_W1_H */
diff --git a/include/linux/w1.h b/include/linux/w1.h
index e0b5156f78fd..89843e9f634c 100644
--- a/include/linux/w1.h
+++ b/include/linux/w1.h
@@ -150,6 +150,8 @@ struct w1_bus_master {
 
 	void		(*search)(void *, struct w1_master *,
 		u8, w1_slave_found_callback);
+
+	char		*dev_id;
 };
 
 /**
-- 
2.13.7

