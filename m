Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866B56027CA
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiJRJCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiJRJCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:02:02 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322EAA6C26
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:01:42 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id F3BD8504ED3;
        Tue, 18 Oct 2022 11:57:57 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru F3BD8504ED3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666083482; bh=6uJrKKzeevkDcqFkwhmRdyZICeHdWA/mZ8EHuhJ+M/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACYxg5fVbkAz51pU8Z1k80TDbFIAZjBJRJQznbkLlw/0CBA7HEPXKQO3xaDkUqjwv
         iDktbTFUraxxURlgMMRUWTXW2Hby/eYAPdLdAUghN9n7AMQhMAkIJHealJ2B2ZmCSC
         HSlbOFKtZqTzDyMWlMbida8TiViybycZyxlXsEG0=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        Charles Parent <charles.parent@orolia2s.com>
Subject: [PATCH net-next v3 2/5] ptp: ocp: add Orolia timecard support
Date:   Tue, 18 Oct 2022 12:01:19 +0300
Message-Id: <20221018090122.3361-3-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221018090122.3361-1-vfedorenko@novek.ru>
References: <20221018090122.3361-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

This brings in the Orolia timecard support from the GitHub repository.
The card uses different drivers to provide access to i2c EEPROM and
firmware SPI flash. And it also has a bit different EEPROM map, but
other parts of the code are the same and could be reused.

Co-developed-by: Charles Parent <charles.parent@orolia2s.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 drivers/ptp/ptp_ocp.c | 291 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 291 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index e5b28f89c8dd..701fa265758a 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -13,9 +13,11 @@
 #include <linux/clk-provider.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/i2c-xiic.h>
+#include <linux/platform_data/i2c-ocores.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/xilinx_spi.h>
+#include <linux/spi/altera.h>
 #include <net/devlink.h>
 #include <linux/i2c.h>
 #include <linux/mtd/mtd.h>
@@ -28,6 +30,9 @@
 #define PCI_VENDOR_ID_CELESTICA			0x18d4
 #define PCI_DEVICE_ID_CELESTICA_TIMECARD	0x1008
 
+#define PCI_VENDOR_ID_OROLIA			0x1ad7
+#define PCI_DEVICE_ID_OROLIA_ARTCARD		0xa000
+
 static struct class timecard_class = {
 	.owner		= THIS_MODULE,
 	.name		= "timecard",
@@ -310,6 +315,7 @@ struct ptp_ocp {
 	struct ptp_ocp_ext_src	*ts2;
 	struct ptp_ocp_ext_src	*ts3;
 	struct ptp_ocp_ext_src	*ts4;
+	struct ocp_art_gpio_reg __iomem *art_sma;
 	struct img_reg __iomem	*image;
 	struct ptp_clock	*ptp;
 	struct ptp_clock_info	ptp_info;
@@ -370,8 +376,13 @@ static int ptp_ocp_signal_from_perout(struct ptp_ocp *bp, int gen,
 static int ptp_ocp_signal_enable(void *priv, u32 req, bool enable);
 static int ptp_ocp_sma_store(struct ptp_ocp *bp, const char *buf, int sma_nr);
 
+static int ptp_ocp_art_board_init(struct ptp_ocp *bp, struct ocp_resource *r);
+
 static const struct ocp_attr_group fb_timecard_groups[];
 
+static const struct ocp_attr_group art_timecard_groups[];
+static const struct ocp_sma_op ocp_art_sma_op;
+
 struct ptp_ocp_eeprom_map {
 	u16	off;
 	u16	len;
@@ -394,6 +405,12 @@ static struct ptp_ocp_eeprom_map fb_eeprom_map[] = {
 	{ }
 };
 
+static struct ptp_ocp_eeprom_map art_eeprom_map[] = {
+	{ EEPROM_ENTRY(0x200 + 0x43, board_id) },
+	{ EEPROM_ENTRY(0x200 + 0x63, serial) },
+	{ }
+};
+
 #define bp_assign_entry(bp, res, val) ({				\
 	uintptr_t addr = (uintptr_t)(bp) + (res)->bp_offset;		\
 	*(typeof(val) *)addr = val;					\
@@ -435,6 +452,13 @@ static struct ptp_ocp_eeprom_map fb_eeprom_map[] = {
  * 14: Signal Generator 4
  * 15: TS3
  * 16: TS4
+ --
+ * 8: Orolia TS1
+ * 10: Orolia TS2
+ * 11: Orolia TS0 (GNSS)
+ * 12: Orolia PPS
+ * 14: Orolia TS3
+ * 15: Orolia TS4
  */
 
 static struct ocp_resource ocp_fb_resource[] = {
@@ -661,9 +685,127 @@ static struct ocp_resource ocp_fb_resource[] = {
 	{ }
 };
 
+struct ocp_art_gpio_reg {
+	struct {
+		u32	gpio;
+		u32	__pad[3];
+	} map[4];
+};
+
+static struct ocp_resource ocp_art_resource[] = {
+	{
+		OCP_MEM_RESOURCE(reg),
+		.offset = 0x01000000, .size = 0x10000,
+	},
+	{
+		OCP_SERIAL_RESOURCE(gnss_port),
+		.offset = 0x00160000 + 0x1000, .irq_vec = 3,
+		.extra = &(struct ptp_ocp_serial_port) {
+			.baud = 115200,
+		},
+	},
+	{
+		OCP_MEM_RESOURCE(art_sma),
+		.offset = 0x003C0000, .size = 0x1000,
+	},
+	/* Timestamp associated with GNSS1 receiver PPS */
+	{
+		OCP_EXT_RESOURCE(ts0),
+		.offset = 0x360000, .size = 0x20, .irq_vec = 12,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 0,
+			.irq_fcn = ptp_ocp_ts_irq,
+			.enable = ptp_ocp_ts_enable,
+		},
+	},
+	{
+		OCP_EXT_RESOURCE(ts1),
+		.offset = 0x380000, .size = 0x20, .irq_vec = 8,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 1,
+			.irq_fcn = ptp_ocp_ts_irq,
+			.enable = ptp_ocp_ts_enable,
+		},
+	},
+	{
+		OCP_EXT_RESOURCE(ts2),
+		.offset = 0x390000, .size = 0x20, .irq_vec = 10,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 2,
+			.irq_fcn = ptp_ocp_ts_irq,
+			.enable = ptp_ocp_ts_enable,
+		},
+	},
+	{
+		OCP_EXT_RESOURCE(ts3),
+		.offset = 0x3A0000, .size = 0x20, .irq_vec = 14,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 3,
+			.irq_fcn = ptp_ocp_ts_irq,
+			.enable = ptp_ocp_ts_enable,
+		},
+	},
+	{
+		OCP_EXT_RESOURCE(ts4),
+		.offset = 0x3B0000, .size = 0x20, .irq_vec = 15,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 4,
+			.irq_fcn = ptp_ocp_ts_irq,
+			.enable = ptp_ocp_ts_enable,
+		},
+	},
+	/* Timestamp associated with Internal PPS of the card */
+	{
+		OCP_EXT_RESOURCE(pps),
+		.offset = 0x00330000, .size = 0x20, .irq_vec = 11,
+		.extra = &(struct ptp_ocp_ext_info) {
+			.index = 5,
+			.irq_fcn = ptp_ocp_ts_irq,
+			.enable = ptp_ocp_ts_enable,
+		},
+	},
+	{
+		OCP_SPI_RESOURCE(spi_flash),
+		.offset = 0x00310000, .size = 0x10000, .irq_vec = 9,
+		.extra = &(struct ptp_ocp_flash_info) {
+			.name = "spi_altera", .pci_offset = 0,
+			.data_size = sizeof(struct altera_spi_platform_data),
+			.data = &(struct altera_spi_platform_data) {
+				.num_chipselect = 1,
+				.num_devices = 1,
+				.devices = &(struct spi_board_info) {
+					.modalias = "spi-nor",
+				},
+			},
+		},
+	},
+	{
+		OCP_I2C_RESOURCE(i2c_ctrl),
+		.offset = 0x350000, .size = 0x100, .irq_vec = 4,
+		.extra = &(struct ptp_ocp_i2c_info) {
+			.name = "ocores-i2c",
+			.fixed_rate = 400000,
+			.data_size = sizeof(struct ocores_i2c_platform_data),
+			.data = &(struct ocores_i2c_platform_data) {
+				.clock_khz = 125000,
+				.bus_khz = 400,
+				.num_devices = 1,
+				.devices = &(struct i2c_board_info) {
+					I2C_BOARD_INFO("24c08", 0x50),
+				},
+			},
+		},
+	},
+	{
+		.setup = ptp_ocp_art_board_init,
+	},
+	{ }
+};
+
 static const struct pci_device_id ptp_ocp_pcidev_id[] = {
 	{ PCI_DEVICE_DATA(FACEBOOK, TIMECARD, &ocp_fb_resource) },
 	{ PCI_DEVICE_DATA(CELESTICA, TIMECARD, &ocp_fb_resource) },
+	{ PCI_DEVICE_DATA(OROLIA, ARTCARD, &ocp_art_resource) },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, ptp_ocp_pcidev_id);
@@ -728,6 +870,19 @@ static const struct ocp_selector ptp_ocp_sma_out[] = {
 	{ }
 };
 
+static const struct ocp_selector ptp_ocp_art_sma_in[] = {
+	{ .name = "PPS1",	.value = 0x0001 },
+	{ .name = "10Mhz",	.value = 0x0008 },
+	{ }
+};
+
+static const struct ocp_selector ptp_ocp_art_sma_out[] = {
+	{ .name = "PHC",	.value = 0x0002 },
+	{ .name = "GNSS",	.value = 0x0004 },
+	{ .name = "10Mhz",	.value = 0x0010 },
+	{ }
+};
+
 struct ocp_sma_op {
 	const struct ocp_selector *tbl[2];
 	void (*init)(struct ptp_ocp *bp);
@@ -2243,6 +2398,28 @@ ptp_ocp_fb_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
 	return ptp_ocp_init_clock(bp);
 }
 
+/* ART specific board initializers; last "resource" registered. */
+static int
+ptp_ocp_art_board_init(struct ptp_ocp *bp, struct ocp_resource *r)
+{
+	int err;
+
+	bp->flash_start = 0x1000000;
+	bp->eeprom_map = art_eeprom_map;
+	bp->fw_cap = OCP_CAP_BASIC;
+	bp->fw_version = ioread32(&bp->reg->version);
+	bp->fw_tag = 2;
+	bp->sma_op = &ocp_art_sma_op;
+
+	ptp_ocp_sma_init(bp);
+
+	err = ptp_ocp_attr_group_add(bp, art_timecard_groups);
+	if (err)
+		return err;
+
+	return ptp_ocp_init_clock(bp);
+}
+
 static bool
 ptp_ocp_allow_irq(struct ptp_ocp *bp, struct ocp_resource *r)
 {
@@ -2275,6 +2452,96 @@ ptp_ocp_register_resources(struct ptp_ocp *bp, kernel_ulong_t driver_data)
 	return err;
 }
 
+static void
+ptp_ocp_art_sma_init(struct ptp_ocp *bp)
+{
+	u32 reg;
+	int i;
+
+	/* defaults */
+	bp->sma[0].mode = SMA_MODE_IN;
+	bp->sma[1].mode = SMA_MODE_IN;
+	bp->sma[2].mode = SMA_MODE_OUT;
+	bp->sma[3].mode = SMA_MODE_OUT;
+
+	bp->sma[0].default_fcn = 0x08;	/* IN: 10Mhz */
+	bp->sma[1].default_fcn = 0x01;	/* IN: PPS1 */
+	bp->sma[2].default_fcn = 0x10;	/* OUT: 10Mhz */
+	bp->sma[3].default_fcn = 0x02;	/* OUT: PHC */
+
+	/* If no SMA map, the pin functions and directions are fixed. */
+	if (!bp->art_sma) {
+		for (i = 0; i < 4; i++) {
+			bp->sma[i].fixed_fcn = true;
+			bp->sma[i].fixed_dir = true;
+		}
+		return;
+	}
+
+	for (i = 0; i < 4; i++) {
+		reg = ioread32(&bp->art_sma->map[i].gpio);
+
+		switch (reg & 0xff) {
+		case 0:
+			bp->sma[i].fixed_fcn = true;
+			bp->sma[i].fixed_dir = true;
+			break;
+		case 1:
+		case 8:
+			bp->sma[i].mode = SMA_MODE_IN;
+			break;
+		default:
+			bp->sma[i].mode = SMA_MODE_OUT;
+			break;
+		}
+	}
+}
+
+static u32
+ptp_ocp_art_sma_get(struct ptp_ocp *bp, int sma_nr)
+{
+	if (bp->sma[sma_nr - 1].fixed_fcn)
+		return bp->sma[sma_nr - 1].default_fcn;
+
+	return ioread32(&bp->art_sma->map[sma_nr - 1].gpio) & 0xff;
+}
+
+/* note: store 0 is considered invalid. */
+static int
+ptp_ocp_art_sma_set(struct ptp_ocp *bp, int sma_nr, u32 val)
+{
+	unsigned long flags;
+	u32 __iomem *gpio;
+	int err = 0;
+	u32 reg;
+
+	val &= SMA_SELECT_MASK;
+	if (hweight32(val) > 1)
+		return -EINVAL;
+
+	gpio = &bp->art_sma->map[sma_nr - 1].gpio;
+
+	spin_lock_irqsave(&bp->lock, flags);
+	reg = ioread32(gpio);
+	if (((reg >> 16) & val) == 0) {
+		err = -EOPNOTSUPP;
+	} else {
+		reg = (reg & 0xff00) | (val & 0xff);
+		iowrite32(reg, gpio);
+	}
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return err;
+}
+
+static const struct ocp_sma_op ocp_art_sma_op = {
+	.tbl		= { ptp_ocp_art_sma_in, ptp_ocp_art_sma_out },
+	.init		= ptp_ocp_art_sma_init,
+	.get		= ptp_ocp_art_sma_get,
+	.set_inputs	= ptp_ocp_art_sma_set,
+	.set_output	= ptp_ocp_art_sma_set,
+};
+
 static ssize_t
 ptp_ocp_show_output(const struct ocp_selector *tbl, u32 val, char *buf,
 		    int def_val)
@@ -3083,6 +3350,30 @@ static const struct ocp_attr_group fb_timecard_groups[] = {
 	{ },
 };
 
+static struct attribute *art_timecard_attrs[] = {
+	&dev_attr_serialnum.attr,
+	&dev_attr_clock_source.attr,
+	&dev_attr_available_clock_sources.attr,
+	&dev_attr_utc_tai_offset.attr,
+	&dev_attr_ts_window_adjust.attr,
+	&dev_attr_sma1.attr,
+	&dev_attr_sma2.attr,
+	&dev_attr_sma3.attr,
+	&dev_attr_sma4.attr,
+	&dev_attr_available_sma_inputs.attr,
+	&dev_attr_available_sma_outputs.attr,
+	NULL,
+};
+
+static const struct attribute_group art_timecard_group = {
+	.attrs = art_timecard_attrs,
+};
+
+static const struct ocp_attr_group art_timecard_groups[] = {
+	{ .cap = OCP_CAP_BASIC,	    .group = &art_timecard_group },
+	{ },
+};
+
 static void
 gpio_input_map(char *buf, struct ptp_ocp *bp, u16 map[][2], u16 bit,
 	       const char *def)
-- 
2.27.0

