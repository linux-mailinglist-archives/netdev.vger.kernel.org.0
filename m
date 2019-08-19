Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E71D949EB
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfHSQcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:32:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:55270 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727524AbfHSQcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:32:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8D471B0B6;
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
Subject: [PATCH v5 02/17] w1: add DS2501, DS2502, DS2505 EPROM device driver
Date:   Mon, 19 Aug 2019 18:31:25 +0200
Message-Id: <20190819163144.3478-3-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190819163144.3478-1-tbogendoerfer@suse.de>
References: <20190819163144.3478-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a 1-Wire slave driver to support DS250x EPROM deivces. This
slave driver attaches the devices to the NVMEM subsystem for
an easy in-kernel usage.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/w1/slaves/Kconfig     |   6 +
 drivers/w1/slaves/Makefile    |   1 +
 drivers/w1/slaves/w1_ds250x.c | 293 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 300 insertions(+)
 create mode 100644 drivers/w1/slaves/w1_ds250x.c

diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
index 37aaad26b373..ebed495b9e69 100644
--- a/drivers/w1/slaves/Kconfig
+++ b/drivers/w1/slaves/Kconfig
@@ -101,6 +101,12 @@ config W1_SLAVE_DS2438
 	  Say Y here if you want to use a 1-wire
 	  DS2438 Smart Battery Monitor device support
 
+config W1_SLAVE_DS250X
+	tristate "512b/1kb/16kb EPROM family support"
+	help
+	  Say Y here if you want to use a 1-wire
+	  512b/1kb/16kb EPROM family device (DS250x).
+
 config W1_SLAVE_DS2780
 	tristate "Dallas 2780 battery monitor chip"
 	help
diff --git a/drivers/w1/slaves/Makefile b/drivers/w1/slaves/Makefile
index eab29f151413..8e9655eaa478 100644
--- a/drivers/w1/slaves/Makefile
+++ b/drivers/w1/slaves/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_W1_SLAVE_DS2431)	+= w1_ds2431.o
 obj-$(CONFIG_W1_SLAVE_DS2805)	+= w1_ds2805.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
 obj-$(CONFIG_W1_SLAVE_DS2438)	+= w1_ds2438.o
+obj-$(CONFIG_W1_SLAVE_DS250X)	+= w1_ds250x.o
 obj-$(CONFIG_W1_SLAVE_DS2780)	+= w1_ds2780.o
 obj-$(CONFIG_W1_SLAVE_DS2781)	+= w1_ds2781.o
 obj-$(CONFIG_W1_SLAVE_DS28E04)	+= w1_ds28e04.o
diff --git a/drivers/w1/slaves/w1_ds250x.c b/drivers/w1/slaves/w1_ds250x.c
new file mode 100644
index 000000000000..78da3774bbbe
--- /dev/null
+++ b/drivers/w1/slaves/w1_ds250x.c
@@ -0,0 +1,293 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * w1_ds250x.c - w1 family 09/0b/89/91 (DS250x) driver
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/crc16.h>
+
+#include <linux/w1.h>
+#include <linux/nvmem-provider.h>
+
+#define W1_DS2501_UNW_FAMILY    0x91
+#define W1_DS2501_SIZE          64
+
+#define W1_DS2502_FAMILY        0x09
+#define W1_DS2502_UNW_FAMILY    0x89
+#define W1_DS2502_SIZE          128
+
+#define W1_DS2505_FAMILY	0x0b
+#define W1_DS2505_SIZE		2048
+
+#define W1_PAGE_SIZE		32
+
+#define W1_EXT_READ_MEMORY	0xA5
+#define W1_READ_DATA_CRC        0xC3
+
+#define OFF2PG(off)	((off) / W1_PAGE_SIZE)
+
+#define CRC16_INIT		0
+#define CRC16_VALID		0xb001
+
+struct w1_eprom_data {
+	size_t size;
+	int (*read)(struct w1_slave *sl, int pageno);
+	u8 eprom[W1_DS2505_SIZE];
+	DECLARE_BITMAP(page_present, W1_DS2505_SIZE / W1_PAGE_SIZE);
+	char nvmem_name[64];
+};
+
+static int w1_ds2502_read_page(struct w1_slave *sl, int pageno)
+{
+	struct w1_eprom_data *data = sl->family_data;
+	int pgoff = pageno * W1_PAGE_SIZE;
+	int ret = -EIO;
+	u8 buf[3];
+	u8 crc8;
+
+	if (test_bit(pageno, data->page_present))
+		return 0; /* page already present */
+
+	mutex_lock(&sl->master->bus_mutex);
+
+	if (w1_reset_select_slave(sl))
+		goto err;
+
+	buf[0] = W1_READ_DATA_CRC;
+	buf[1] = pgoff & 0xff;
+	buf[2] = pgoff >> 8;
+	w1_write_block(sl->master, buf, 3);
+
+	crc8 = w1_read_8(sl->master);
+	if (w1_calc_crc8(buf, 3) != crc8)
+		goto err;
+
+	w1_read_block(sl->master, &data->eprom[pgoff], W1_PAGE_SIZE);
+
+	crc8 = w1_read_8(sl->master);
+	if (w1_calc_crc8(&data->eprom[pgoff], W1_PAGE_SIZE) != crc8)
+		goto err;
+
+	set_bit(pageno, data->page_present); /* mark page present */
+	ret = 0;
+err:
+	mutex_unlock(&sl->master->bus_mutex);
+	return ret;
+}
+
+static int w1_ds2505_read_page(struct w1_slave *sl, int pageno)
+{
+	struct w1_eprom_data *data = sl->family_data;
+	int redir_retries = 16;
+	int pgoff, epoff;
+	int ret = -EIO;
+	u8 buf[6];
+	u8 redir;
+	u16 crc;
+
+	if (test_bit(pageno, data->page_present))
+		return 0; /* page already present */
+
+	epoff = pgoff = pageno * W1_PAGE_SIZE;
+	mutex_lock(&sl->master->bus_mutex);
+
+retry:
+	if (w1_reset_select_slave(sl))
+		goto err;
+
+	buf[0] = W1_EXT_READ_MEMORY;
+	buf[1] = pgoff & 0xff;
+	buf[2] = pgoff >> 8;
+	w1_write_block(sl->master, buf, 3);
+	w1_read_block(sl->master, buf + 3, 3); /* redir, crc16 */
+	redir = buf[3];
+	crc = crc16(CRC16_INIT, buf, 6);
+
+	if (crc != CRC16_VALID)
+		goto err;
+
+
+	if (redir != 0xff) {
+		redir_retries--;
+		if (redir_retries < 0)
+			goto err;
+
+		pgoff = (redir ^ 0xff) * W1_PAGE_SIZE;
+		goto retry;
+	}
+
+	w1_read_block(sl->master, &data->eprom[epoff], W1_PAGE_SIZE);
+	w1_read_block(sl->master, buf, 2); /* crc16 */
+	crc = crc16(CRC16_INIT, &data->eprom[epoff], W1_PAGE_SIZE);
+	crc = crc16(crc, buf, 2);
+
+	if (crc != CRC16_VALID)
+		goto err;
+
+	set_bit(pageno, data->page_present);
+	ret = 0;
+err:
+	mutex_unlock(&sl->master->bus_mutex);
+	return ret;
+}
+
+static int w1_nvmem_read(void *priv, unsigned int off, void *buf, size_t count)
+{
+	struct w1_slave *sl = priv;
+	struct w1_eprom_data *data = sl->family_data;
+	size_t eprom_size = data->size;
+	int ret;
+	int i;
+
+	if (off > eprom_size)
+		return -EINVAL;
+
+	if ((off + count) > eprom_size)
+		count = eprom_size - off;
+
+	i = OFF2PG(off);
+	do {
+		ret = data->read(sl, i++);
+		if (ret < 0)
+			return ret;
+	} while (i < OFF2PG(off + count));
+
+	memcpy(buf, &data->eprom[off], count);
+	return 0;
+}
+
+static int w1_eprom_add_slave(struct w1_slave *sl)
+{
+	struct w1_eprom_data *data;
+	struct nvmem_device *nvmem;
+	struct nvmem_config nvmem_cfg = {
+		.dev = &sl->dev,
+		.reg_read = w1_nvmem_read,
+		.type = NVMEM_TYPE_OTP,
+		.read_only = true,
+		.word_size = 1,
+		.priv = sl,
+		.id = -1
+	};
+
+	data = devm_kzalloc(&sl->dev, sizeof(struct w1_eprom_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	sl->family_data = data;
+	switch (sl->family->fid) {
+	case W1_DS2501_UNW_FAMILY:
+		data->size = W1_DS2501_SIZE;
+		data->read = w1_ds2502_read_page;
+		break;
+	case W1_DS2502_FAMILY:
+	case W1_DS2502_UNW_FAMILY:
+		data->size = W1_DS2502_SIZE;
+		data->read = w1_ds2502_read_page;
+		break;
+	case W1_DS2505_FAMILY:
+		data->size = W1_DS2505_SIZE;
+		data->read = w1_ds2505_read_page;
+		break;
+	}
+
+	if (sl->master->bus_master->dev_id)
+		snprintf(data->nvmem_name, sizeof(data->nvmem_name),
+			 "%s-%02x-%012llx",
+			 sl->master->bus_master->dev_id, sl->reg_num.family,
+			 (unsigned long long)sl->reg_num.id);
+	else
+		snprintf(data->nvmem_name, sizeof(data->nvmem_name),
+			 "%02x-%012llx",
+			 sl->reg_num.family,
+			 (unsigned long long)sl->reg_num.id);
+
+	nvmem_cfg.name = data->nvmem_name;
+	nvmem_cfg.size = data->size;
+
+	nvmem = devm_nvmem_register(&sl->dev, &nvmem_cfg);
+	if (IS_ERR(nvmem))
+		return PTR_ERR(nvmem);
+
+	return 0;
+}
+
+static struct w1_family_ops w1_eprom_fops = {
+	.add_slave	= w1_eprom_add_slave,
+};
+
+static struct w1_family w1_family_09 = {
+	.fid = W1_DS2502_FAMILY,
+	.fops = &w1_eprom_fops,
+};
+
+static struct w1_family w1_family_0b = {
+	.fid = W1_DS2505_FAMILY,
+	.fops = &w1_eprom_fops,
+};
+
+static struct w1_family w1_family_89 = {
+	.fid = W1_DS2502_UNW_FAMILY,
+	.fops = &w1_eprom_fops,
+};
+
+static struct w1_family w1_family_91 = {
+	.fid = W1_DS2501_UNW_FAMILY,
+	.fops = &w1_eprom_fops,
+};
+
+static int __init w1_ds250x_init(void)
+{
+	int err;
+
+	err = w1_register_family(&w1_family_09);
+	if (err)
+		return err;
+
+	err = w1_register_family(&w1_family_0b);
+	if (err)
+		goto err_0b;
+
+	err = w1_register_family(&w1_family_89);
+	if (err)
+		goto err_89;
+
+	err = w1_register_family(&w1_family_91);
+	if (err)
+		goto err_91;
+
+	return 0;
+
+err_91:
+	w1_unregister_family(&w1_family_89);
+err_89:
+	w1_unregister_family(&w1_family_0b);
+err_0b:
+	w1_unregister_family(&w1_family_09);
+	return err;
+}
+
+static void __exit w1_ds250x_exit(void)
+{
+	w1_unregister_family(&w1_family_09);
+	w1_unregister_family(&w1_family_0b);
+	w1_unregister_family(&w1_family_89);
+	w1_unregister_family(&w1_family_91);
+}
+
+module_init(w1_ds250x_init);
+module_exit(w1_ds250x_exit);
+
+MODULE_AUTHOR("Thomas Bogendoerfer <tbogendoerfe@suse.de>");
+MODULE_DESCRIPTION("w1 family driver for DS250x Add Only Memory");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("w1-family-" __stringify(W1_DS2502_FAMILY));
+MODULE_ALIAS("w1-family-" __stringify(W1_DS2505_FAMILY));
+MODULE_ALIAS("w1-family-" __stringify(W1_DS2501_UNW_FAMILY));
+MODULE_ALIAS("w1-family-" __stringify(W1_DS2502_UNW_FAMILY));
-- 
2.13.7

