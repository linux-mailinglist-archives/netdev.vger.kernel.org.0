Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686F0272624
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbgIUNqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbgIUNqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AF3C0613B7
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:18 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM91-0003ED-7v; Mon, 21 Sep 2020 15:46:15 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 34/38] can: mcp25xxfd: add regmap infrastructure
Date:   Mon, 21 Sep 2020 15:45:53 +0200
Message-Id: <20200921134557.2251383-35-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134557.2251383-1-mkl@pengutronix.de>
References: <20200921134557.2251383-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the regmap infrastructure for the Microchip MCP25xxFD SPI CAN
controller family. The actual driver is added in the next commit.

Tested-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20200918172536.2074504-3-mkl@pengutronix.de
---
 drivers/net/can/spi/Kconfig                   |   2 +
 drivers/net/can/spi/Makefile                  |   1 +
 drivers/net/can/spi/mcp25xxfd/Kconfig         |  17 +
 drivers/net/can/spi/mcp25xxfd/Makefile        |   7 +
 .../net/can/spi/mcp25xxfd/mcp25xxfd-crc16.c   |  89 ++
 .../net/can/spi/mcp25xxfd/mcp25xxfd-regmap.c  | 556 ++++++++++++
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h     | 835 ++++++++++++++++++
 7 files changed, 1507 insertions(+)
 create mode 100644 drivers/net/can/spi/mcp25xxfd/Kconfig
 create mode 100644 drivers/net/can/spi/mcp25xxfd/Makefile
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd-crc16.c
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd-regmap.c
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h

diff --git a/drivers/net/can/spi/Kconfig b/drivers/net/can/spi/Kconfig
index a332008d8495..a82240628c33 100644
--- a/drivers/net/can/spi/Kconfig
+++ b/drivers/net/can/spi/Kconfig
@@ -13,4 +13,6 @@ config CAN_MCP251X
 	  Driver for the Microchip MCP251x and MCP25625 SPI CAN
 	  controllers.
 
+source "drivers/net/can/spi/mcp25xxfd/Kconfig"
+
 endmenu
diff --git a/drivers/net/can/spi/Makefile b/drivers/net/can/spi/Makefile
index f115b2c46623..20c18ac96b1c 100644
--- a/drivers/net/can/spi/Makefile
+++ b/drivers/net/can/spi/Makefile
@@ -6,3 +6,4 @@
 
 obj-$(CONFIG_CAN_HI311X)	+= hi311x.o
 obj-$(CONFIG_CAN_MCP251X)	+= mcp251x.o
+obj-y				+= mcp25xxfd/
diff --git a/drivers/net/can/spi/mcp25xxfd/Kconfig b/drivers/net/can/spi/mcp25xxfd/Kconfig
new file mode 100644
index 000000000000..9eb596019a58
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config CAN_MCP25XXFD
+	tristate "Microchip MCP25xxFD SPI CAN controllers"
+	select REGMAP
+	help
+	  Driver for the Microchip MCP25XXFD SPI FD-CAN controller
+	  family.
+
+config CAN_MCP25XXFD_SANITY
+	depends on CAN_MCP25XXFD
+	bool "Additional Sanity Checks"
+	help
+	  This option enables additional sanity checks in the driver,
+	  that compares various internal counters with the in chip
+	  variants. This comes with a runtime overhead.
+	  Disable if unsure.
diff --git a/drivers/net/can/spi/mcp25xxfd/Makefile b/drivers/net/can/spi/mcp25xxfd/Makefile
new file mode 100644
index 000000000000..9dadf0070b42
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_CAN_MCP25XXFD) += mcp25xxfd.o
+
+mcp25xxfd-objs :=
+mcp25xxfd-objs += mcp25xxfd-crc16.o
+mcp25xxfd-objs += mcp25xxfd-regmap.o
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-crc16.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-crc16.c
new file mode 100644
index 000000000000..79d09aaebf33
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-crc16.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// mcp25xxfd - Microchip MCP25xxFD Family CAN controller driver
+//
+// Copyright (c) 2020 Pengutronix,
+//                    Marc Kleine-Budde <kernel@pengutronix.de>
+//
+// Based on:
+//
+// CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+//
+// Copyright (c) 2019 Martin Sperl <kernel@martin.sperl.org>
+//
+
+#include "mcp25xxfd.h"
+
+/* The standard crc16 in linux/crc16.h is unfortunately not computing
+ * the correct results (left shift vs. right shift). So here an
+ * implementation with a table generated with the help of:
+ *
+ * http://lkml.iu.edu/hypermail/linux/kernel/0508.1/1085.html
+ */
+static const u16 mcp25xxfd_crc16_table[] = {
+	0x0000, 0x8005, 0x800f, 0x000a, 0x801b, 0x001e, 0x0014, 0x8011,
+	0x8033, 0x0036, 0x003c, 0x8039, 0x0028, 0x802d, 0x8027, 0x0022,
+	0x8063, 0x0066, 0x006c, 0x8069, 0x0078, 0x807d, 0x8077, 0x0072,
+	0x0050, 0x8055, 0x805f, 0x005a, 0x804b, 0x004e, 0x0044, 0x8041,
+	0x80c3, 0x00c6, 0x00cc, 0x80c9, 0x00d8, 0x80dd, 0x80d7, 0x00d2,
+	0x00f0, 0x80f5, 0x80ff, 0x00fa, 0x80eb, 0x00ee, 0x00e4, 0x80e1,
+	0x00a0, 0x80a5, 0x80af, 0x00aa, 0x80bb, 0x00be, 0x00b4, 0x80b1,
+	0x8093, 0x0096, 0x009c, 0x8099, 0x0088, 0x808d, 0x8087, 0x0082,
+	0x8183, 0x0186, 0x018c, 0x8189, 0x0198, 0x819d, 0x8197, 0x0192,
+	0x01b0, 0x81b5, 0x81bf, 0x01ba, 0x81ab, 0x01ae, 0x01a4, 0x81a1,
+	0x01e0, 0x81e5, 0x81ef, 0x01ea, 0x81fb, 0x01fe, 0x01f4, 0x81f1,
+	0x81d3, 0x01d6, 0x01dc, 0x81d9, 0x01c8, 0x81cd, 0x81c7, 0x01c2,
+	0x0140, 0x8145, 0x814f, 0x014a, 0x815b, 0x015e, 0x0154, 0x8151,
+	0x8173, 0x0176, 0x017c, 0x8179, 0x0168, 0x816d, 0x8167, 0x0162,
+	0x8123, 0x0126, 0x012c, 0x8129, 0x0138, 0x813d, 0x8137, 0x0132,
+	0x0110, 0x8115, 0x811f, 0x011a, 0x810b, 0x010e, 0x0104, 0x8101,
+	0x8303, 0x0306, 0x030c, 0x8309, 0x0318, 0x831d, 0x8317, 0x0312,
+	0x0330, 0x8335, 0x833f, 0x033a, 0x832b, 0x032e, 0x0324, 0x8321,
+	0x0360, 0x8365, 0x836f, 0x036a, 0x837b, 0x037e, 0x0374, 0x8371,
+	0x8353, 0x0356, 0x035c, 0x8359, 0x0348, 0x834d, 0x8347, 0x0342,
+	0x03c0, 0x83c5, 0x83cf, 0x03ca, 0x83db, 0x03de, 0x03d4, 0x83d1,
+	0x83f3, 0x03f6, 0x03fc, 0x83f9, 0x03e8, 0x83ed, 0x83e7, 0x03e2,
+	0x83a3, 0x03a6, 0x03ac, 0x83a9, 0x03b8, 0x83bd, 0x83b7, 0x03b2,
+	0x0390, 0x8395, 0x839f, 0x039a, 0x838b, 0x038e, 0x0384, 0x8381,
+	0x0280, 0x8285, 0x828f, 0x028a, 0x829b, 0x029e, 0x0294, 0x8291,
+	0x82b3, 0x02b6, 0x02bc, 0x82b9, 0x02a8, 0x82ad, 0x82a7, 0x02a2,
+	0x82e3, 0x02e6, 0x02ec, 0x82e9, 0x02f8, 0x82fd, 0x82f7, 0x02f2,
+	0x02d0, 0x82d5, 0x82df, 0x02da, 0x82cb, 0x02ce, 0x02c4, 0x82c1,
+	0x8243, 0x0246, 0x024c, 0x8249, 0x0258, 0x825d, 0x8257, 0x0252,
+	0x0270, 0x8275, 0x827f, 0x027a, 0x826b, 0x026e, 0x0264, 0x8261,
+	0x0220, 0x8225, 0x822f, 0x022a, 0x823b, 0x023e, 0x0234, 0x8231,
+	0x8213, 0x0216, 0x021c, 0x8219, 0x0208, 0x820d, 0x8207, 0x0202
+};
+
+static inline u16 mcp25xxfd_crc16_byte(u16 crc, const u8 data)
+{
+	u8 index = (crc >> 8) ^ data;
+
+	return (crc << 8) ^ mcp25xxfd_crc16_table[index];
+}
+
+static u16 mcp25xxfd_crc16(u16 crc, u8 const *buffer, size_t len)
+{
+	while (len--)
+		crc = mcp25xxfd_crc16_byte(crc, *buffer++);
+
+	return crc;
+}
+
+u16 mcp25xxfd_crc16_compute(const void *data, size_t data_size)
+{
+	u16 crc = 0xffff;
+
+	return mcp25xxfd_crc16(crc, data, data_size);
+}
+
+u16 mcp25xxfd_crc16_compute2(const void *cmd, size_t cmd_size,
+			     const void *data, size_t data_size)
+{
+	u16 crc;
+
+	crc = mcp25xxfd_crc16_compute(cmd, cmd_size);
+	crc = mcp25xxfd_crc16(crc, data, data_size);
+
+	return crc;
+}
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-regmap.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-regmap.c
new file mode 100644
index 000000000000..376649c7e443
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd-regmap.c
@@ -0,0 +1,556 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// mcp25xxfd - Microchip MCP25xxFD Family CAN controller driver
+//
+// Copyright (c) 2019, 2020 Pengutronix,
+//                          Marc Kleine-Budde <kernel@pengutronix.de>
+//
+
+#include "mcp25xxfd.h"
+
+#include <asm/unaligned.h>
+
+static const struct regmap_config mcp25xxfd_regmap_crc;
+
+static int
+mcp25xxfd_regmap_nocrc_write(void *context, const void *data, size_t count)
+{
+	struct spi_device *spi = context;
+
+	return spi_write(spi, data, count);
+}
+
+static int
+mcp25xxfd_regmap_nocrc_gather_write(void *context,
+				    const void *reg, size_t reg_len,
+				    const void *val, size_t val_len)
+{
+	struct spi_device *spi = context;
+	struct mcp25xxfd_priv *priv = spi_get_drvdata(spi);
+	struct mcp25xxfd_map_buf_nocrc *buf_tx = priv->map_buf_nocrc_tx;
+	struct spi_transfer xfer[] = {
+		{
+			.tx_buf = buf_tx,
+			.len = sizeof(buf_tx->cmd) + val_len,
+		},
+	};
+
+	BUILD_BUG_ON(sizeof(buf_tx->cmd) != sizeof(__be16));
+
+	if (IS_ENABLED(CONFIG_CAN_MCP25XXFD_SANITY) &&
+	    reg_len != sizeof(buf_tx->cmd.cmd))
+		return -EINVAL;
+
+	memcpy(&buf_tx->cmd, reg, sizeof(buf_tx->cmd));
+	memcpy(buf_tx->data, val, val_len);
+
+	return spi_sync_transfer(spi, xfer, ARRAY_SIZE(xfer));
+}
+
+static inline bool mcp25xxfd_update_bits_read_reg(unsigned int reg)
+{
+	switch (reg) {
+	case MCP25XXFD_REG_INT:
+	case MCP25XXFD_REG_TEFCON:
+	case MCP25XXFD_REG_FIFOCON(MCP25XXFD_RX_FIFO(0)):
+	case MCP25XXFD_REG_FLTCON(0):
+	case MCP25XXFD_REG_ECCSTAT:
+	case MCP25XXFD_REG_CRC:
+		return false;
+	case MCP25XXFD_REG_CON:
+	case MCP25XXFD_REG_FIFOSTA(MCP25XXFD_RX_FIFO(0)):
+	case MCP25XXFD_REG_OSC:
+	case MCP25XXFD_REG_ECCCON:
+		return true;
+	default:
+		WARN(1, "Status of reg 0x%04x unknown.\n", reg);
+	}
+
+	return true;
+}
+
+static int
+mcp25xxfd_regmap_nocrc_update_bits(void *context, unsigned int reg,
+				   unsigned int mask, unsigned int val)
+{
+	struct spi_device *spi = context;
+	struct mcp25xxfd_priv *priv = spi_get_drvdata(spi);
+	struct mcp25xxfd_map_buf_nocrc *buf_rx = priv->map_buf_nocrc_rx;
+	struct mcp25xxfd_map_buf_nocrc *buf_tx = priv->map_buf_nocrc_tx;
+	__le32 orig_le32 = 0, mask_le32, val_le32, tmp_le32;
+	u8 first_byte, last_byte, len;
+	int err;
+
+	BUILD_BUG_ON(sizeof(buf_rx->cmd) != sizeof(__be16));
+	BUILD_BUG_ON(sizeof(buf_tx->cmd) != sizeof(__be16));
+
+	if (IS_ENABLED(CONFIG_CAN_MCP25XXFD_SANITY) &&
+	    mask == 0)
+		return -EINVAL;
+
+	first_byte = mcp25xxfd_first_byte_set(mask);
+	last_byte = mcp25xxfd_last_byte_set(mask);
+	len = last_byte - first_byte + 1;
+
+	if (mcp25xxfd_update_bits_read_reg(reg)) {
+		struct spi_transfer xfer[2] = { };
+		struct spi_message msg;
+
+		spi_message_init(&msg);
+		spi_message_add_tail(&xfer[0], &msg);
+
+		if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_HALF_DUPLEX) {
+			xfer[0].tx_buf = buf_tx;
+			xfer[0].len = sizeof(buf_tx->cmd);
+
+			xfer[1].rx_buf = buf_rx->data;
+			xfer[1].len = len;
+			spi_message_add_tail(&xfer[1], &msg);
+		} else {
+			xfer[0].tx_buf = buf_tx;
+			xfer[0].rx_buf = buf_rx;
+			xfer[0].len = sizeof(buf_tx->cmd) + len;
+
+			if (MCP25XXFD_SANITIZE_SPI)
+				memset(buf_tx->data, 0x0, len);
+		}
+
+		mcp25xxfd_spi_cmd_read_nocrc(&buf_tx->cmd, reg + first_byte);
+		err = spi_sync(spi, &msg);
+		if (err)
+			return err;
+
+		memcpy(&orig_le32, buf_rx->data, len);
+	}
+
+	mask_le32 = cpu_to_le32(mask >> BITS_PER_BYTE * first_byte);
+	val_le32 = cpu_to_le32(val >> BITS_PER_BYTE * first_byte);
+
+	tmp_le32 = orig_le32 & ~mask_le32;
+	tmp_le32 |= val_le32 & mask_le32;
+
+	mcp25xxfd_spi_cmd_write_nocrc(&buf_tx->cmd, reg + first_byte);
+	memcpy(buf_tx->data, &tmp_le32, len);
+
+	return spi_write(spi, buf_tx, sizeof(buf_tx->cmd) + len);
+}
+
+static int
+mcp25xxfd_regmap_nocrc_read(void *context,
+			    const void *reg, size_t reg_len,
+			    void *val_buf, size_t val_len)
+{
+	struct spi_device *spi = context;
+	struct mcp25xxfd_priv *priv = spi_get_drvdata(spi);
+	struct mcp25xxfd_map_buf_nocrc *buf_rx = priv->map_buf_nocrc_rx;
+	struct mcp25xxfd_map_buf_nocrc *buf_tx = priv->map_buf_nocrc_tx;
+	struct spi_transfer xfer[2] = { };
+	struct spi_message msg;
+	int err;
+
+	BUILD_BUG_ON(sizeof(buf_rx->cmd) != sizeof(__be16));
+	BUILD_BUG_ON(sizeof(buf_tx->cmd) != sizeof(__be16));
+
+	if (IS_ENABLED(CONFIG_CAN_MCP25XXFD_SANITY) &&
+	    reg_len != sizeof(buf_tx->cmd.cmd))
+		return -EINVAL;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer[0], &msg);
+
+	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_HALF_DUPLEX) {
+		xfer[0].tx_buf = reg;
+		xfer[0].len = sizeof(buf_tx->cmd);
+
+		xfer[1].rx_buf = val_buf;
+		xfer[1].len = val_len;
+		spi_message_add_tail(&xfer[1], &msg);
+	} else {
+		xfer[0].tx_buf = buf_tx;
+		xfer[0].rx_buf = buf_rx;
+		xfer[0].len = sizeof(buf_tx->cmd) + val_len;
+
+		memcpy(&buf_tx->cmd, reg, sizeof(buf_tx->cmd));
+		if (MCP25XXFD_SANITIZE_SPI)
+			memset(buf_tx->data, 0x0, val_len);
+	};
+
+	err = spi_sync(spi, &msg);
+	if (err)
+		return err;
+
+	if (!(priv->devtype_data.quirks & MCP25XXFD_QUIRK_HALF_DUPLEX))
+		memcpy(val_buf, buf_rx->data, val_len);
+
+	return 0;
+}
+
+static int
+mcp25xxfd_regmap_crc_gather_write(void *context,
+				  const void *reg_p, size_t reg_len,
+				  const void *val, size_t val_len)
+{
+	struct spi_device *spi = context;
+	struct mcp25xxfd_priv *priv = spi_get_drvdata(spi);
+	struct mcp25xxfd_map_buf_crc *buf_tx = priv->map_buf_crc_tx;
+	struct spi_transfer xfer[] = {
+		{
+			.tx_buf = buf_tx,
+			.len = sizeof(buf_tx->cmd) + val_len +
+				sizeof(buf_tx->crc),
+		},
+	};
+	u16 reg = *(u16 *)reg_p;
+	u16 crc;
+
+	BUILD_BUG_ON(sizeof(buf_tx->cmd) != sizeof(__be16) + sizeof(u8));
+
+	if (IS_ENABLED(CONFIG_CAN_MCP25XXFD_SANITY) &&
+	    reg_len != sizeof(buf_tx->cmd.cmd) +
+	    mcp25xxfd_regmap_crc.pad_bits / BITS_PER_BYTE)
+		return -EINVAL;
+
+	mcp25xxfd_spi_cmd_write_crc(&buf_tx->cmd, reg, val_len);
+	memcpy(buf_tx->data, val, val_len);
+
+	crc = mcp25xxfd_crc16_compute(buf_tx, sizeof(buf_tx->cmd) + val_len);
+	put_unaligned_be16(crc, buf_tx->data + val_len);
+
+	return spi_sync_transfer(spi, xfer, ARRAY_SIZE(xfer));
+}
+
+static int
+mcp25xxfd_regmap_crc_write(void *context,
+			   const void *data, size_t count)
+{
+	const size_t data_offset = sizeof(__be16) +
+		mcp25xxfd_regmap_crc.pad_bits / BITS_PER_BYTE;
+
+	return mcp25xxfd_regmap_crc_gather_write(context,
+						 data, data_offset,
+						 data + data_offset,
+						 count - data_offset);
+}
+
+static int
+mcp25xxfd_regmap_crc_read_one(struct mcp25xxfd_priv *priv,
+			      struct spi_message *msg, unsigned int data_len)
+{
+	const struct mcp25xxfd_map_buf_crc *buf_rx = priv->map_buf_crc_rx;
+	const struct mcp25xxfd_map_buf_crc *buf_tx = priv->map_buf_crc_tx;
+	u16 crc_received, crc_calculated;
+	int err;
+
+	BUILD_BUG_ON(sizeof(buf_rx->cmd) != sizeof(__be16) + sizeof(u8));
+	BUILD_BUG_ON(sizeof(buf_tx->cmd) != sizeof(__be16) + sizeof(u8));
+
+	err = spi_sync(priv->spi, msg);
+	if (err)
+		return err;
+
+	crc_received = get_unaligned_be16(buf_rx->data + data_len);
+	crc_calculated = mcp25xxfd_crc16_compute2(&buf_tx->cmd,
+						  sizeof(buf_tx->cmd),
+						  buf_rx->data,
+						  data_len);
+	if (crc_received != crc_calculated)
+		return -EBADMSG;
+
+	return 0;
+}
+
+static int
+mcp25xxfd_regmap_crc_read(void *context,
+			  const void *reg_p, size_t reg_len,
+			  void *val_buf, size_t val_len)
+{
+	struct spi_device *spi = context;
+	struct mcp25xxfd_priv *priv = spi_get_drvdata(spi);
+	struct mcp25xxfd_map_buf_crc *buf_rx = priv->map_buf_crc_rx;
+	struct mcp25xxfd_map_buf_crc *buf_tx = priv->map_buf_crc_tx;
+	struct spi_transfer xfer[2] = { };
+	struct spi_message msg;
+	u16 reg = *(u16 *)reg_p;
+	int i, err;
+
+	BUILD_BUG_ON(sizeof(buf_rx->cmd) != sizeof(__be16) + sizeof(u8));
+	BUILD_BUG_ON(sizeof(buf_tx->cmd) != sizeof(__be16) + sizeof(u8));
+
+	if (IS_ENABLED(CONFIG_CAN_MCP25XXFD_SANITY) &&
+	    reg_len != sizeof(buf_tx->cmd.cmd) +
+	    mcp25xxfd_regmap_crc.pad_bits / BITS_PER_BYTE)
+		return -EINVAL;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer[0], &msg);
+
+	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_HALF_DUPLEX) {
+		xfer[0].tx_buf = buf_tx;
+		xfer[0].len = sizeof(buf_tx->cmd);
+
+		xfer[1].rx_buf = buf_rx->data;
+		xfer[1].len = val_len + sizeof(buf_tx->crc);
+		spi_message_add_tail(&xfer[1], &msg);
+	} else {
+		xfer[0].tx_buf = buf_tx;
+		xfer[0].rx_buf = buf_rx;
+		xfer[0].len = sizeof(buf_tx->cmd) + val_len +
+			sizeof(buf_tx->crc);
+
+		if (MCP25XXFD_SANITIZE_SPI)
+			memset(buf_tx->data, 0x0, val_len +
+			       sizeof(buf_tx->crc));
+	}
+
+	mcp25xxfd_spi_cmd_read_crc(&buf_tx->cmd, reg, val_len);
+
+	for (i = 0; i < MCP25XXFD_READ_CRC_RETRIES_MAX; i++) {
+		err = mcp25xxfd_regmap_crc_read_one(priv, &msg, val_len);
+		if (!err)
+			goto out;
+		if (err != -EBADMSG)
+			return err;
+
+		/* MCP25XXFD_REG_OSC is the first ever reg we read from.
+		 *
+		 * The chip may be in deep sleep and this SPI transfer
+		 * (i.e. the assertion of the CS) will wake the chip
+		 * up. This takes about 3ms. The CRC of this transfer
+		 * is wrong.
+		 *
+		 * Or there isn't a chip at all, in this case the CRC
+		 * will be wrong, too.
+		 *
+		 * In both cases ignore the CRC and copy the read data
+		 * to the caller. It will take care of both cases.
+		 *
+		 */
+		if (reg == MCP25XXFD_REG_OSC) {
+			err = 0;
+			goto out;
+		}
+
+		netdev_dbg(priv->ndev,
+			   "CRC read error at address 0x%04x (length=%zd, data=%*ph, CRC=0x%04x) retrying.\n",
+			   reg, val_len, (int)val_len, buf_rx->data,
+			   get_unaligned_be16(buf_rx->data + val_len));
+	}
+
+	if (err) {
+		netdev_info(priv->ndev,
+			    "CRC read error at address 0x%04x (length=%zd, data=%*ph, CRC=0x%04x).\n",
+			    reg, val_len, (int)val_len, buf_rx->data,
+			    get_unaligned_be16(buf_rx->data + val_len));
+
+		return err;
+	}
+ out:
+	memcpy(val_buf, buf_rx->data, val_len);
+
+	return 0;
+}
+
+static const struct regmap_range mcp25xxfd_reg_table_yes_range[] = {
+	regmap_reg_range(0x000, 0x2ec),	/* CAN FD Controller Module SFR */
+	regmap_reg_range(0x400, 0xbfc),	/* RAM */
+	regmap_reg_range(0xe00, 0xe14),	/* MCP2517/18FD SFR */
+};
+
+static const struct regmap_access_table mcp25xxfd_reg_table = {
+	.yes_ranges = mcp25xxfd_reg_table_yes_range,
+	.n_yes_ranges = ARRAY_SIZE(mcp25xxfd_reg_table_yes_range),
+};
+
+static const struct regmap_config mcp25xxfd_regmap_nocrc = {
+	.name = "nocrc",
+	.reg_bits = 16,
+	.reg_stride = 4,
+	.pad_bits = 0,
+	.val_bits = 32,
+	.max_register = 0xffc,
+	.wr_table = &mcp25xxfd_reg_table,
+	.rd_table = &mcp25xxfd_reg_table,
+	.cache_type = REGCACHE_NONE,
+	.read_flag_mask = (__force unsigned long)
+		cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_READ),
+	.write_flag_mask = (__force unsigned long)
+		cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_WRITE),
+};
+
+static const struct regmap_bus mcp25xxfd_bus_nocrc = {
+	.write = mcp25xxfd_regmap_nocrc_write,
+	.gather_write = mcp25xxfd_regmap_nocrc_gather_write,
+	.reg_update_bits = mcp25xxfd_regmap_nocrc_update_bits,
+	.read = mcp25xxfd_regmap_nocrc_read,
+	.reg_format_endian_default = REGMAP_ENDIAN_BIG,
+	.val_format_endian_default = REGMAP_ENDIAN_LITTLE,
+	.max_raw_read = sizeof_field(struct mcp25xxfd_map_buf_nocrc, data),
+	.max_raw_write = sizeof_field(struct mcp25xxfd_map_buf_nocrc, data),
+};
+
+static const struct regmap_config mcp25xxfd_regmap_crc = {
+	.name = "crc",
+	.reg_bits = 16,
+	.reg_stride = 4,
+	.pad_bits = 16,		/* keep data bits aligned */
+	.val_bits = 32,
+	.max_register = 0xffc,
+	.wr_table = &mcp25xxfd_reg_table,
+	.rd_table = &mcp25xxfd_reg_table,
+	.cache_type = REGCACHE_NONE,
+};
+
+static const struct regmap_bus mcp25xxfd_bus_crc = {
+	.write = mcp25xxfd_regmap_crc_write,
+	.gather_write = mcp25xxfd_regmap_crc_gather_write,
+	.read = mcp25xxfd_regmap_crc_read,
+	.reg_format_endian_default = REGMAP_ENDIAN_NATIVE,
+	.val_format_endian_default = REGMAP_ENDIAN_LITTLE,
+	.max_raw_read = sizeof_field(struct mcp25xxfd_map_buf_crc, data),
+	.max_raw_write = sizeof_field(struct mcp25xxfd_map_buf_crc, data),
+};
+
+static inline bool
+mcp25xxfd_regmap_use_nocrc(struct mcp25xxfd_priv *priv)
+{
+	return (!(priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_REG)) ||
+		(!(priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_RX));
+}
+
+static inline bool
+mcp25xxfd_regmap_use_crc(struct mcp25xxfd_priv *priv)
+{
+	return (priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_REG) ||
+		(priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_RX);
+}
+
+static int
+mcp25xxfd_regmap_init_nocrc(struct mcp25xxfd_priv *priv)
+{
+	if (!priv->map_nocrc) {
+		struct regmap *map;
+
+		map = devm_regmap_init(&priv->spi->dev, &mcp25xxfd_bus_nocrc,
+				       priv->spi, &mcp25xxfd_regmap_nocrc);
+		if (IS_ERR(map))
+			return PTR_ERR(map);
+
+		priv->map_nocrc = map;
+	}
+
+	if (!priv->map_buf_nocrc_rx) {
+		priv->map_buf_nocrc_rx =
+			devm_kzalloc(&priv->spi->dev,
+				     sizeof(*priv->map_buf_nocrc_rx),
+				     GFP_KERNEL);
+		if (!priv->map_buf_nocrc_rx)
+			return -ENOMEM;
+	}
+
+	if (!priv->map_buf_nocrc_tx) {
+		priv->map_buf_nocrc_tx =
+			devm_kzalloc(&priv->spi->dev,
+				     sizeof(*priv->map_buf_nocrc_tx),
+				     GFP_KERNEL);
+		if (!priv->map_buf_nocrc_tx)
+			return -ENOMEM;
+	}
+
+	if (!(priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_REG))
+		priv->map_reg = priv->map_nocrc;
+
+	if (!(priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_RX))
+		priv->map_rx = priv->map_nocrc;
+
+	return 0;
+}
+
+static void mcp25xxfd_regmap_destroy_nocrc(struct mcp25xxfd_priv *priv)
+{
+	if (priv->map_buf_nocrc_rx) {
+		devm_kfree(&priv->spi->dev, priv->map_buf_nocrc_rx);
+		priv->map_buf_nocrc_rx = NULL;
+	}
+	if (priv->map_buf_nocrc_tx) {
+		devm_kfree(&priv->spi->dev, priv->map_buf_nocrc_tx);
+		priv->map_buf_nocrc_tx = NULL;
+	}
+}
+
+static int
+mcp25xxfd_regmap_init_crc(struct mcp25xxfd_priv *priv)
+{
+	if (!priv->map_crc) {
+		struct regmap *map;
+
+		map = devm_regmap_init(&priv->spi->dev, &mcp25xxfd_bus_crc,
+				       priv->spi, &mcp25xxfd_regmap_crc);
+		if (IS_ERR(map))
+			return PTR_ERR(map);
+
+		priv->map_crc = map;
+	}
+
+	if (!priv->map_buf_crc_rx) {
+		priv->map_buf_crc_rx =
+			devm_kzalloc(&priv->spi->dev,
+				     sizeof(*priv->map_buf_crc_rx),
+				     GFP_KERNEL);
+		if (!priv->map_buf_crc_rx)
+			return -ENOMEM;
+	}
+
+	if (!priv->map_buf_crc_tx) {
+		priv->map_buf_crc_tx =
+			devm_kzalloc(&priv->spi->dev,
+				     sizeof(*priv->map_buf_crc_tx),
+				     GFP_KERNEL);
+		if (!priv->map_buf_crc_tx)
+			return -ENOMEM;
+	}
+
+	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_REG)
+		priv->map_reg = priv->map_crc;
+
+	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_RX)
+		priv->map_rx = priv->map_crc;
+
+	return 0;
+}
+
+static void mcp25xxfd_regmap_destroy_crc(struct mcp25xxfd_priv *priv)
+{
+	if (priv->map_buf_crc_rx) {
+		devm_kfree(&priv->spi->dev, priv->map_buf_crc_rx);
+		priv->map_buf_crc_rx = NULL;
+	}
+	if (priv->map_buf_crc_tx) {
+		devm_kfree(&priv->spi->dev, priv->map_buf_crc_tx);
+		priv->map_buf_crc_tx = NULL;
+	}
+}
+
+int mcp25xxfd_regmap_init(struct mcp25xxfd_priv *priv)
+{
+	int err;
+
+	if (mcp25xxfd_regmap_use_nocrc(priv)) {
+		err = mcp25xxfd_regmap_init_nocrc(priv);
+
+		if (err)
+			return err;
+	} else {
+		mcp25xxfd_regmap_destroy_nocrc(priv);
+	}
+
+	if (mcp25xxfd_regmap_use_crc(priv)) {
+		err = mcp25xxfd_regmap_init_crc(priv);
+
+		if (err)
+			return err;
+	} else {
+		mcp25xxfd_regmap_destroy_crc(priv);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h
new file mode 100644
index 000000000000..3bc799204cb0
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd.h
@@ -0,0 +1,835 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * mcp25xxfd - Microchip MCP25xxFD Family CAN controller driver
+ *
+ * Copyright (c) 2019 Pengutronix,
+ *                    Marc Kleine-Budde <kernel@pengutronix.de>
+ * Copyright (c) 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+
+#ifndef _MCP25XXFD_H
+#define _MCP25XXFD_H
+
+#include <linux/can/core.h>
+#include <linux/can/dev.h>
+#include <linux/can/rx-offload.h>
+#include <linux/gpio/consumer.h>
+#include <linux/kernel.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/spi/spi.h>
+
+/* MPC25xx registers */
+
+/* CAN FD Controller Module SFR */
+#define MCP25XXFD_REG_CON 0x00
+#define MCP25XXFD_REG_CON_TXBWS_MASK GENMASK(31, 28)
+#define MCP25XXFD_REG_CON_ABAT BIT(27)
+#define MCP25XXFD_REG_CON_REQOP_MASK GENMASK(26, 24)
+#define MCP25XXFD_REG_CON_MODE_MIXED 0
+#define MCP25XXFD_REG_CON_MODE_SLEEP 1
+#define MCP25XXFD_REG_CON_MODE_INT_LOOPBACK 2
+#define MCP25XXFD_REG_CON_MODE_LISTENONLY 3
+#define MCP25XXFD_REG_CON_MODE_CONFIG 4
+#define MCP25XXFD_REG_CON_MODE_EXT_LOOPBACK 5
+#define MCP25XXFD_REG_CON_MODE_CAN2_0 6
+#define MCP25XXFD_REG_CON_MODE_RESTRICTED 7
+#define MCP25XXFD_REG_CON_OPMOD_MASK GENMASK(23, 21)
+#define MCP25XXFD_REG_CON_TXQEN BIT(20)
+#define MCP25XXFD_REG_CON_STEF BIT(19)
+#define MCP25XXFD_REG_CON_SERR2LOM BIT(18)
+#define MCP25XXFD_REG_CON_ESIGM BIT(17)
+#define MCP25XXFD_REG_CON_RTXAT BIT(16)
+#define MCP25XXFD_REG_CON_BRSDIS BIT(12)
+#define MCP25XXFD_REG_CON_BUSY BIT(11)
+#define MCP25XXFD_REG_CON_WFT_MASK GENMASK(10, 9)
+#define MCP25XXFD_REG_CON_WFT_T00FILTER 0x0
+#define MCP25XXFD_REG_CON_WFT_T01FILTER 0x1
+#define MCP25XXFD_REG_CON_WFT_T10FILTER 0x2
+#define MCP25XXFD_REG_CON_WFT_T11FILTER 0x3
+#define MCP25XXFD_REG_CON_WAKFIL BIT(8)
+#define MCP25XXFD_REG_CON_PXEDIS BIT(6)
+#define MCP25XXFD_REG_CON_ISOCRCEN BIT(5)
+#define MCP25XXFD_REG_CON_DNCNT_MASK GENMASK(4, 0)
+
+#define MCP25XXFD_REG_NBTCFG 0x04
+#define MCP25XXFD_REG_NBTCFG_BRP_MASK GENMASK(31, 24)
+#define MCP25XXFD_REG_NBTCFG_TSEG1_MASK GENMASK(23, 16)
+#define MCP25XXFD_REG_NBTCFG_TSEG2_MASK GENMASK(14, 8)
+#define MCP25XXFD_REG_NBTCFG_SJW_MASK GENMASK(6, 0)
+
+#define MCP25XXFD_REG_DBTCFG 0x08
+#define MCP25XXFD_REG_DBTCFG_BRP_MASK GENMASK(31, 24)
+#define MCP25XXFD_REG_DBTCFG_TSEG1_MASK GENMASK(20, 16)
+#define MCP25XXFD_REG_DBTCFG_TSEG2_MASK GENMASK(11, 8)
+#define MCP25XXFD_REG_DBTCFG_SJW_MASK GENMASK(3, 0)
+
+#define MCP25XXFD_REG_TDC 0x0c
+#define MCP25XXFD_REG_TDC_EDGFLTEN BIT(25)
+#define MCP25XXFD_REG_TDC_SID11EN BIT(24)
+#define MCP25XXFD_REG_TDC_TDCMOD_MASK GENMASK(17, 16)
+#define MCP25XXFD_REG_TDC_TDCMOD_AUTO 2
+#define MCP25XXFD_REG_TDC_TDCMOD_MANUAL 1
+#define MCP25XXFD_REG_TDC_TDCMOD_DISABLED 0
+#define MCP25XXFD_REG_TDC_TDCO_MASK GENMASK(14, 8)
+#define MCP25XXFD_REG_TDC_TDCV_MASK GENMASK(5, 0)
+
+#define MCP25XXFD_REG_TBC 0x10
+
+#define MCP25XXFD_REG_TSCON 0x14
+#define MCP25XXFD_REG_TSCON_TSRES BIT(18)
+#define MCP25XXFD_REG_TSCON_TSEOF BIT(17)
+#define MCP25XXFD_REG_TSCON_TBCEN BIT(16)
+#define MCP25XXFD_REG_TSCON_TBCPRE_MASK GENMASK(9, 0)
+
+#define MCP25XXFD_REG_VEC 0x18
+#define MCP25XXFD_REG_VEC_RXCODE_MASK GENMASK(30, 24)
+#define MCP25XXFD_REG_VEC_TXCODE_MASK GENMASK(22, 16)
+#define MCP25XXFD_REG_VEC_FILHIT_MASK GENMASK(12, 8)
+#define MCP25XXFD_REG_VEC_ICODE_MASK GENMASK(6, 0)
+
+#define MCP25XXFD_REG_INT 0x1c
+#define MCP25XXFD_REG_INT_IF_MASK GENMASK(15, 0)
+#define MCP25XXFD_REG_INT_IE_MASK GENMASK(31, 16)
+#define MCP25XXFD_REG_INT_IVMIE BIT(31)
+#define MCP25XXFD_REG_INT_WAKIE BIT(30)
+#define MCP25XXFD_REG_INT_CERRIE BIT(29)
+#define MCP25XXFD_REG_INT_SERRIE BIT(28)
+#define MCP25XXFD_REG_INT_RXOVIE BIT(27)
+#define MCP25XXFD_REG_INT_TXATIE BIT(26)
+#define MCP25XXFD_REG_INT_SPICRCIE BIT(25)
+#define MCP25XXFD_REG_INT_ECCIE BIT(24)
+#define MCP25XXFD_REG_INT_TEFIE BIT(20)
+#define MCP25XXFD_REG_INT_MODIE BIT(19)
+#define MCP25XXFD_REG_INT_TBCIE BIT(18)
+#define MCP25XXFD_REG_INT_RXIE BIT(17)
+#define MCP25XXFD_REG_INT_TXIE BIT(16)
+#define MCP25XXFD_REG_INT_IVMIF BIT(15)
+#define MCP25XXFD_REG_INT_WAKIF BIT(14)
+#define MCP25XXFD_REG_INT_CERRIF BIT(13)
+#define MCP25XXFD_REG_INT_SERRIF BIT(12)
+#define MCP25XXFD_REG_INT_RXOVIF BIT(11)
+#define MCP25XXFD_REG_INT_TXATIF BIT(10)
+#define MCP25XXFD_REG_INT_SPICRCIF BIT(9)
+#define MCP25XXFD_REG_INT_ECCIF BIT(8)
+#define MCP25XXFD_REG_INT_TEFIF BIT(4)
+#define MCP25XXFD_REG_INT_MODIF BIT(3)
+#define MCP25XXFD_REG_INT_TBCIF BIT(2)
+#define MCP25XXFD_REG_INT_RXIF BIT(1)
+#define MCP25XXFD_REG_INT_TXIF BIT(0)
+/* These IRQ flags must be cleared by SW in the CAN_INT register */
+#define MCP25XXFD_REG_INT_IF_CLEARABLE_MASK \
+	(MCP25XXFD_REG_INT_IVMIF | MCP25XXFD_REG_INT_WAKIF | \
+	 MCP25XXFD_REG_INT_CERRIF |  MCP25XXFD_REG_INT_SERRIF | \
+	 MCP25XXFD_REG_INT_MODIF)
+
+#define MCP25XXFD_REG_RXIF 0x20
+#define MCP25XXFD_REG_TXIF 0x24
+#define MCP25XXFD_REG_RXOVIF 0x28
+#define MCP25XXFD_REG_TXATIF 0x2c
+#define MCP25XXFD_REG_TXREQ 0x30
+
+#define MCP25XXFD_REG_TREC 0x34
+#define MCP25XXFD_REG_TREC_TXBO BIT(21)
+#define MCP25XXFD_REG_TREC_TXBP BIT(20)
+#define MCP25XXFD_REG_TREC_RXBP BIT(19)
+#define MCP25XXFD_REG_TREC_TXWARN BIT(18)
+#define MCP25XXFD_REG_TREC_RXWARN BIT(17)
+#define MCP25XXFD_REG_TREC_EWARN BIT(16)
+#define MCP25XXFD_REG_TREC_TEC_MASK GENMASK(15, 8)
+#define MCP25XXFD_REG_TREC_REC_MASK GENMASK(7, 0)
+
+#define MCP25XXFD_REG_BDIAG0 0x38
+#define MCP25XXFD_REG_BDIAG0_DTERRCNT_MASK GENMASK(31, 24)
+#define MCP25XXFD_REG_BDIAG0_DRERRCNT_MASK GENMASK(23, 16)
+#define MCP25XXFD_REG_BDIAG0_NTERRCNT_MASK GENMASK(15, 8)
+#define MCP25XXFD_REG_BDIAG0_NRERRCNT_MASK GENMASK(7, 0)
+
+#define MCP25XXFD_REG_BDIAG1 0x3c
+#define MCP25XXFD_REG_BDIAG1_DLCMM BIT(31)
+#define MCP25XXFD_REG_BDIAG1_ESI BIT(30)
+#define MCP25XXFD_REG_BDIAG1_DCRCERR BIT(29)
+#define MCP25XXFD_REG_BDIAG1_DSTUFERR BIT(28)
+#define MCP25XXFD_REG_BDIAG1_DFORMERR BIT(27)
+#define MCP25XXFD_REG_BDIAG1_DBIT1ERR BIT(25)
+#define MCP25XXFD_REG_BDIAG1_DBIT0ERR BIT(24)
+#define MCP25XXFD_REG_BDIAG1_TXBOERR BIT(23)
+#define MCP25XXFD_REG_BDIAG1_NCRCERR BIT(21)
+#define MCP25XXFD_REG_BDIAG1_NSTUFERR BIT(20)
+#define MCP25XXFD_REG_BDIAG1_NFORMERR BIT(19)
+#define MCP25XXFD_REG_BDIAG1_NACKERR BIT(18)
+#define MCP25XXFD_REG_BDIAG1_NBIT1ERR BIT(17)
+#define MCP25XXFD_REG_BDIAG1_NBIT0ERR BIT(16)
+#define MCP25XXFD_REG_BDIAG1_BERR_MASK \
+	(MCP25XXFD_REG_BDIAG1_DLCMM | MCP25XXFD_REG_BDIAG1_ESI | \
+	 MCP25XXFD_REG_BDIAG1_DCRCERR | MCP25XXFD_REG_BDIAG1_DSTUFERR | \
+	 MCP25XXFD_REG_BDIAG1_DFORMERR | MCP25XXFD_REG_BDIAG1_DBIT1ERR | \
+	 MCP25XXFD_REG_BDIAG1_DBIT0ERR | MCP25XXFD_REG_BDIAG1_TXBOERR | \
+	 MCP25XXFD_REG_BDIAG1_NCRCERR | MCP25XXFD_REG_BDIAG1_NSTUFERR | \
+	 MCP25XXFD_REG_BDIAG1_NFORMERR | MCP25XXFD_REG_BDIAG1_NACKERR | \
+	 MCP25XXFD_REG_BDIAG1_NBIT1ERR | MCP25XXFD_REG_BDIAG1_NBIT0ERR)
+#define MCP25XXFD_REG_BDIAG1_EFMSGCNT_MASK GENMASK(15, 0)
+
+#define MCP25XXFD_REG_TEFCON 0x40
+#define MCP25XXFD_REG_TEFCON_FSIZE_MASK GENMASK(28, 24)
+#define MCP25XXFD_REG_TEFCON_FRESET BIT(10)
+#define MCP25XXFD_REG_TEFCON_UINC BIT(8)
+#define MCP25XXFD_REG_TEFCON_TEFTSEN BIT(5)
+#define MCP25XXFD_REG_TEFCON_TEFOVIE BIT(3)
+#define MCP25XXFD_REG_TEFCON_TEFFIE BIT(2)
+#define MCP25XXFD_REG_TEFCON_TEFHIE BIT(1)
+#define MCP25XXFD_REG_TEFCON_TEFNEIE BIT(0)
+
+#define MCP25XXFD_REG_TEFSTA 0x44
+#define MCP25XXFD_REG_TEFSTA_TEFOVIF BIT(3)
+#define MCP25XXFD_REG_TEFSTA_TEFFIF BIT(2)
+#define MCP25XXFD_REG_TEFSTA_TEFHIF BIT(1)
+#define MCP25XXFD_REG_TEFSTA_TEFNEIF BIT(0)
+
+#define MCP25XXFD_REG_TEFUA 0x48
+
+#define MCP25XXFD_REG_TXQCON 0x50
+#define MCP25XXFD_REG_TXQCON_PLSIZE_MASK GENMASK(31, 29)
+#define MCP25XXFD_REG_TXQCON_PLSIZE_8 0
+#define MCP25XXFD_REG_TXQCON_PLSIZE_12 1
+#define MCP25XXFD_REG_TXQCON_PLSIZE_16 2
+#define MCP25XXFD_REG_TXQCON_PLSIZE_20 3
+#define MCP25XXFD_REG_TXQCON_PLSIZE_24 4
+#define MCP25XXFD_REG_TXQCON_PLSIZE_32 5
+#define MCP25XXFD_REG_TXQCON_PLSIZE_48 6
+#define MCP25XXFD_REG_TXQCON_PLSIZE_64 7
+#define MCP25XXFD_REG_TXQCON_FSIZE_MASK GENMASK(28, 24)
+#define MCP25XXFD_REG_TXQCON_TXAT_UNLIMITED 3
+#define MCP25XXFD_REG_TXQCON_TXAT_THREE_SHOT 1
+#define MCP25XXFD_REG_TXQCON_TXAT_ONE_SHOT 0
+#define MCP25XXFD_REG_TXQCON_TXAT_MASK GENMASK(22, 21)
+#define MCP25XXFD_REG_TXQCON_TXPRI_MASK GENMASK(20, 16)
+#define MCP25XXFD_REG_TXQCON_FRESET BIT(10)
+#define MCP25XXFD_REG_TXQCON_TXREQ BIT(9)
+#define MCP25XXFD_REG_TXQCON_UINC BIT(8)
+#define MCP25XXFD_REG_TXQCON_TXEN BIT(7)
+#define MCP25XXFD_REG_TXQCON_TXATIE BIT(4)
+#define MCP25XXFD_REG_TXQCON_TXQEIE BIT(2)
+#define MCP25XXFD_REG_TXQCON_TXQNIE BIT(0)
+
+#define MCP25XXFD_REG_TXQSTA 0x54
+#define MCP25XXFD_REG_TXQSTA_TXQCI_MASK GENMASK(12, 8)
+#define MCP25XXFD_REG_TXQSTA_TXABT BIT(7)
+#define MCP25XXFD_REG_TXQSTA_TXLARB BIT(6)
+#define MCP25XXFD_REG_TXQSTA_TXERR BIT(5)
+#define MCP25XXFD_REG_TXQSTA_TXATIF BIT(4)
+#define MCP25XXFD_REG_TXQSTA_TXQEIF BIT(2)
+#define MCP25XXFD_REG_TXQSTA_TXQNIF BIT(0)
+
+#define MCP25XXFD_REG_TXQUA 0x58
+
+#define MCP25XXFD_REG_FIFOCON(x) (0x50 + 0xc * (x))
+#define MCP25XXFD_REG_FIFOCON_PLSIZE_MASK GENMASK(31, 29)
+#define MCP25XXFD_REG_FIFOCON_PLSIZE_8 0
+#define MCP25XXFD_REG_FIFOCON_PLSIZE_12 1
+#define MCP25XXFD_REG_FIFOCON_PLSIZE_16 2
+#define MCP25XXFD_REG_FIFOCON_PLSIZE_20 3
+#define MCP25XXFD_REG_FIFOCON_PLSIZE_24 4
+#define MCP25XXFD_REG_FIFOCON_PLSIZE_32 5
+#define MCP25XXFD_REG_FIFOCON_PLSIZE_48 6
+#define MCP25XXFD_REG_FIFOCON_PLSIZE_64 7
+#define MCP25XXFD_REG_FIFOCON_FSIZE_MASK GENMASK(28, 24)
+#define MCP25XXFD_REG_FIFOCON_TXAT_MASK GENMASK(22, 21)
+#define MCP25XXFD_REG_FIFOCON_TXAT_ONE_SHOT 0
+#define MCP25XXFD_REG_FIFOCON_TXAT_THREE_SHOT 1
+#define MCP25XXFD_REG_FIFOCON_TXAT_UNLIMITED 3
+#define MCP25XXFD_REG_FIFOCON_TXPRI_MASK GENMASK(20, 16)
+#define MCP25XXFD_REG_FIFOCON_FRESET BIT(10)
+#define MCP25XXFD_REG_FIFOCON_TXREQ BIT(9)
+#define MCP25XXFD_REG_FIFOCON_UINC BIT(8)
+#define MCP25XXFD_REG_FIFOCON_TXEN BIT(7)
+#define MCP25XXFD_REG_FIFOCON_RTREN BIT(6)
+#define MCP25XXFD_REG_FIFOCON_RXTSEN BIT(5)
+#define MCP25XXFD_REG_FIFOCON_TXATIE BIT(4)
+#define MCP25XXFD_REG_FIFOCON_RXOVIE BIT(3)
+#define MCP25XXFD_REG_FIFOCON_TFERFFIE BIT(2)
+#define MCP25XXFD_REG_FIFOCON_TFHRFHIE BIT(1)
+#define MCP25XXFD_REG_FIFOCON_TFNRFNIE BIT(0)
+
+#define MCP25XXFD_REG_FIFOSTA(x) (0x54 + 0xc * (x))
+#define MCP25XXFD_REG_FIFOSTA_FIFOCI_MASK GENMASK(12, 8)
+#define MCP25XXFD_REG_FIFOSTA_TXABT BIT(7)
+#define MCP25XXFD_REG_FIFOSTA_TXLARB BIT(6)
+#define MCP25XXFD_REG_FIFOSTA_TXERR BIT(5)
+#define MCP25XXFD_REG_FIFOSTA_TXATIF BIT(4)
+#define MCP25XXFD_REG_FIFOSTA_RXOVIF BIT(3)
+#define MCP25XXFD_REG_FIFOSTA_TFERFFIF BIT(2)
+#define MCP25XXFD_REG_FIFOSTA_TFHRFHIF BIT(1)
+#define MCP25XXFD_REG_FIFOSTA_TFNRFNIF BIT(0)
+
+#define MCP25XXFD_REG_FIFOUA(x) (0x58 + 0xc * (x))
+
+#define MCP25XXFD_REG_FLTCON(x) (0x1d0 + 0x4 * (x))
+#define MCP25XXFD_REG_FLTCON_FLTEN3 BIT(31)
+#define MCP25XXFD_REG_FLTCON_F3BP_MASK GENMASK(28, 24)
+#define MCP25XXFD_REG_FLTCON_FLTEN2 BIT(23)
+#define MCP25XXFD_REG_FLTCON_F2BP_MASK GENMASK(20, 16)
+#define MCP25XXFD_REG_FLTCON_FLTEN1 BIT(15)
+#define MCP25XXFD_REG_FLTCON_F1BP_MASK GENMASK(12, 8)
+#define MCP25XXFD_REG_FLTCON_FLTEN0 BIT(7)
+#define MCP25XXFD_REG_FLTCON_F0BP_MASK GENMASK(4, 0)
+#define MCP25XXFD_REG_FLTCON_FLTEN(x) (BIT(7) << 8 * ((x) & 0x3))
+#define MCP25XXFD_REG_FLTCON_FLT_MASK(x) (GENMASK(7, 0) << (8 * ((x) & 0x3)))
+#define MCP25XXFD_REG_FLTCON_FBP(x, fifo) ((fifo) << 8 * ((x) & 0x3))
+
+#define MCP25XXFD_REG_FLTOBJ(x) (0x1f0 + 0x8 * (x))
+#define MCP25XXFD_REG_FLTOBJ_EXIDE BIT(30)
+#define MCP25XXFD_REG_FLTOBJ_SID11 BIT(29)
+#define MCP25XXFD_REG_FLTOBJ_EID_MASK GENMASK(28, 11)
+#define MCP25XXFD_REG_FLTOBJ_SID_MASK GENMASK(10, 0)
+
+#define MCP25XXFD_REG_FLTMASK(x) (0x1f4 + 0x8 * (x))
+#define MCP25XXFD_REG_MASK_MIDE BIT(30)
+#define MCP25XXFD_REG_MASK_MSID11 BIT(29)
+#define MCP25XXFD_REG_MASK_MEID_MASK GENMASK(28, 11)
+#define MCP25XXFD_REG_MASK_MSID_MASK GENMASK(10, 0)
+
+/* RAM */
+#define MCP25XXFD_RAM_START 0x400
+#define MCP25XXFD_RAM_SIZE SZ_2K
+
+/* Message Object */
+#define MCP25XXFD_OBJ_ID_SID11 BIT(29)
+#define MCP25XXFD_OBJ_ID_EID_MASK GENMASK(28, 11)
+#define MCP25XXFD_OBJ_ID_SID_MASK GENMASK(10, 0)
+#define MCP25XXFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK GENMASK(31, 9)
+#define MCP25XXFD_OBJ_FLAGS_SEQ_MCP2517FD_MASK GENMASK(15, 9)
+#define MCP25XXFD_OBJ_FLAGS_SEQ_MASK MCP25XXFD_OBJ_FLAGS_SEQ_MCP2518FD_MASK
+#define MCP25XXFD_OBJ_FLAGS_ESI BIT(8)
+#define MCP25XXFD_OBJ_FLAGS_FDF BIT(7)
+#define MCP25XXFD_OBJ_FLAGS_BRS BIT(6)
+#define MCP25XXFD_OBJ_FLAGS_RTR BIT(5)
+#define MCP25XXFD_OBJ_FLAGS_IDE BIT(4)
+#define MCP25XXFD_OBJ_FLAGS_DLC GENMASK(3, 0)
+
+#define MCP25XXFD_REG_FRAME_EFF_SID_MASK GENMASK(28, 18)
+#define MCP25XXFD_REG_FRAME_EFF_EID_MASK GENMASK(17, 0)
+
+/* MCP2517/18FD SFR */
+#define MCP25XXFD_REG_OSC 0xe00
+#define MCP25XXFD_REG_OSC_SCLKRDY BIT(12)
+#define MCP25XXFD_REG_OSC_OSCRDY BIT(10)
+#define MCP25XXFD_REG_OSC_PLLRDY BIT(8)
+#define MCP25XXFD_REG_OSC_CLKODIV_10 3
+#define MCP25XXFD_REG_OSC_CLKODIV_4 2
+#define MCP25XXFD_REG_OSC_CLKODIV_2 1
+#define MCP25XXFD_REG_OSC_CLKODIV_1 0
+#define MCP25XXFD_REG_OSC_CLKODIV_MASK GENMASK(6, 5)
+#define MCP25XXFD_REG_OSC_SCLKDIV BIT(4)
+#define MCP25XXFD_REG_OSC_LPMEN BIT(3)	/* MCP2518FD only */
+#define MCP25XXFD_REG_OSC_OSCDIS BIT(2)
+#define MCP25XXFD_REG_OSC_PLLEN BIT(0)
+
+#define MCP25XXFD_REG_IOCON 0xe04
+#define MCP25XXFD_REG_IOCON_INTOD BIT(30)
+#define MCP25XXFD_REG_IOCON_SOF BIT(29)
+#define MCP25XXFD_REG_IOCON_TXCANOD BIT(28)
+#define MCP25XXFD_REG_IOCON_PM1 BIT(25)
+#define MCP25XXFD_REG_IOCON_PM0 BIT(24)
+#define MCP25XXFD_REG_IOCON_GPIO1 BIT(17)
+#define MCP25XXFD_REG_IOCON_GPIO0 BIT(16)
+#define MCP25XXFD_REG_IOCON_LAT1 BIT(9)
+#define MCP25XXFD_REG_IOCON_LAT0 BIT(8)
+#define MCP25XXFD_REG_IOCON_XSTBYEN BIT(6)
+#define MCP25XXFD_REG_IOCON_TRIS1 BIT(1)
+#define MCP25XXFD_REG_IOCON_TRIS0 BIT(0)
+
+#define MCP25XXFD_REG_CRC 0xe08
+#define MCP25XXFD_REG_CRC_FERRIE BIT(25)
+#define MCP25XXFD_REG_CRC_CRCERRIE BIT(24)
+#define MCP25XXFD_REG_CRC_FERRIF BIT(17)
+#define MCP25XXFD_REG_CRC_CRCERRIF BIT(16)
+#define MCP25XXFD_REG_CRC_IF_MASK GENMASK(17, 16)
+#define MCP25XXFD_REG_CRC_MASK GENMASK(15, 0)
+
+#define MCP25XXFD_REG_ECCCON 0xe0c
+#define MCP25XXFD_REG_ECCCON_PARITY_MASK GENMASK(14, 8)
+#define MCP25XXFD_REG_ECCCON_DEDIE BIT(2)
+#define MCP25XXFD_REG_ECCCON_SECIE BIT(1)
+#define MCP25XXFD_REG_ECCCON_ECCEN BIT(0)
+
+#define MCP25XXFD_REG_ECCSTAT 0xe10
+#define MCP25XXFD_REG_ECCSTAT_ERRADDR_MASK GENMASK(27, 16)
+#define MCP25XXFD_REG_ECCSTAT_IF_MASK GENMASK(2, 1)
+#define MCP25XXFD_REG_ECCSTAT_DEDIF BIT(2)
+#define MCP25XXFD_REG_ECCSTAT_SECIF BIT(1)
+
+#define MCP25XXFD_REG_DEVID 0xe14	/* MCP2518FD only */
+#define MCP25XXFD_REG_DEVID_ID_MASK GENMASK(7, 4)
+#define MCP25XXFD_REG_DEVID_REV_MASK GENMASK(3, 0)
+
+/* number of TX FIFO objects, depending on CAN mode
+ *
+ * FIFO setup: tef: 8*12 bytes = 96 bytes, tx: 8*16 bytes = 128 bytes
+ * FIFO setup: tef: 4*12 bytes = 48 bytes, tx: 4*72 bytes = 288 bytes
+ */
+#define MCP25XXFD_TX_OBJ_NUM_CAN 8
+#define MCP25XXFD_TX_OBJ_NUM_CANFD 4
+
+#if MCP25XXFD_TX_OBJ_NUM_CAN > MCP25XXFD_TX_OBJ_NUM_CANFD
+#define MCP25XXFD_TX_OBJ_NUM_MAX MCP25XXFD_TX_OBJ_NUM_CAN
+#else
+#define MCP25XXFD_TX_OBJ_NUM_MAX MCP25XXFD_TX_OBJ_NUM_CANFD
+#endif
+
+#define MCP25XXFD_NAPI_WEIGHT 32
+#define MCP25XXFD_TX_FIFO 1
+#define MCP25XXFD_RX_FIFO(x) (MCP25XXFD_TX_FIFO + 1 + (x))
+
+/* SPI commands */
+#define MCP25XXFD_SPI_INSTRUCTION_RESET 0x0000
+#define MCP25XXFD_SPI_INSTRUCTION_WRITE 0x2000
+#define MCP25XXFD_SPI_INSTRUCTION_READ 0x3000
+#define MCP25XXFD_SPI_INSTRUCTION_WRITE_CRC 0xa000
+#define MCP25XXFD_SPI_INSTRUCTION_READ_CRC 0xb000
+#define MCP25XXFD_SPI_INSTRUCTION_WRITE_CRC_SAFE 0xc000
+#define MCP25XXFD_SPI_ADDRESS_MASK GENMASK(11, 0)
+
+#define MCP25XXFD_SYSCLOCK_HZ_MAX 40000000
+#define MCP25XXFD_SYSCLOCK_HZ_MIN 1000000
+#define MCP25XXFD_SPICLOCK_HZ_MAX 20000000
+#define MCP25XXFD_OSC_PLL_MULTIPLIER 10
+#define MCP25XXFD_OSC_STAB_SLEEP_US (3 * USEC_PER_MSEC)
+#define MCP25XXFD_OSC_STAB_TIMEOUT_US (10 * MCP25XXFD_OSC_STAB_SLEEP_US)
+#define MCP25XXFD_POLL_SLEEP_US (10)
+#define MCP25XXFD_POLL_TIMEOUT_US (USEC_PER_MSEC)
+#define MCP25XXFD_SOFTRESET_RETRIES_MAX 3
+#define MCP25XXFD_READ_CRC_RETRIES_MAX 3
+#define MCP25XXFD_ECC_CNT_MAX 2
+#define MCP25XXFD_SANITIZE_SPI 1
+#define MCP25XXFD_SANITIZE_CAN 1
+
+/* Silence TX MAB overflow warnings */
+#define MCP25XXFD_QUIRK_MAB_NO_WARN BIT(0)
+/* Use CRC to access registers */
+#define MCP25XXFD_QUIRK_CRC_REG BIT(1)
+/* Use CRC to access RX/TEF-RAM */
+#define MCP25XXFD_QUIRK_CRC_RX BIT(2)
+/* Use CRC to access TX-RAM */
+#define MCP25XXFD_QUIRK_CRC_TX BIT(3)
+/* Enable ECC for RAM */
+#define MCP25XXFD_QUIRK_ECC BIT(4)
+/* Use Half Duplex SPI transfers */
+#define MCP25XXFD_QUIRK_HALF_DUPLEX BIT(5)
+
+struct mcp25xxfd_hw_tef_obj {
+	u32 id;
+	u32 flags;
+	u32 ts;
+};
+
+/* The tx_obj_raw version is used in spi async, i.e. without
+ * regmap. We have to take care of endianness ourselves.
+ */
+struct mcp25xxfd_hw_tx_obj_raw {
+	__le32 id;
+	__le32 flags;
+	u8 data[sizeof_field(struct canfd_frame, data)];
+};
+
+struct mcp25xxfd_hw_tx_obj_can {
+	u32 id;
+	u32 flags;
+	u8 data[sizeof_field(struct can_frame, data)];
+};
+
+struct mcp25xxfd_hw_tx_obj_canfd {
+	u32 id;
+	u32 flags;
+	u8 data[sizeof_field(struct canfd_frame, data)];
+};
+
+struct mcp25xxfd_hw_rx_obj_can {
+	u32 id;
+	u32 flags;
+	u32 ts;
+	u8 data[sizeof_field(struct can_frame, data)];
+};
+
+struct mcp25xxfd_hw_rx_obj_canfd {
+	u32 id;
+	u32 flags;
+	u32 ts;
+	u8 data[sizeof_field(struct canfd_frame, data)];
+};
+
+struct mcp25xxfd_tef_ring {
+	unsigned int head;
+	unsigned int tail;
+
+	/* u8 obj_num equals tx_ring->obj_num */
+	/* u8 obj_size equals sizeof(struct mcp25xxfd_hw_tef_obj) */
+};
+
+struct __packed mcp25xxfd_buf_cmd {
+	__be16 cmd;
+};
+
+struct __packed mcp25xxfd_buf_cmd_crc {
+	__be16 cmd;
+	u8 len;
+};
+
+union mcp25xxfd_tx_obj_load_buf {
+	struct __packed {
+		struct mcp25xxfd_buf_cmd cmd;
+		struct mcp25xxfd_hw_tx_obj_raw hw_tx_obj;
+	} nocrc;
+	struct __packed {
+		struct mcp25xxfd_buf_cmd_crc cmd;
+		struct mcp25xxfd_hw_tx_obj_raw hw_tx_obj;
+		__be16 crc;
+	} crc;
+} ____cacheline_aligned;
+
+union mcp25xxfd_write_reg_buf {
+	struct __packed {
+		struct mcp25xxfd_buf_cmd cmd;
+		u8 data[4];
+	} nocrc;
+	struct __packed {
+		struct mcp25xxfd_buf_cmd_crc cmd;
+		u8 data[4];
+		__be16 crc;
+	} crc;
+} ____cacheline_aligned;
+
+struct mcp25xxfd_tx_obj {
+	struct spi_message msg;
+	struct spi_transfer xfer[2];
+	union mcp25xxfd_tx_obj_load_buf buf;
+};
+
+struct mcp25xxfd_tx_ring {
+	unsigned int head;
+	unsigned int tail;
+
+	u16 base;
+	u8 obj_num;
+	u8 obj_size;
+
+	struct mcp25xxfd_tx_obj obj[MCP25XXFD_TX_OBJ_NUM_MAX];
+	union mcp25xxfd_write_reg_buf rts_buf;
+};
+
+struct mcp25xxfd_rx_ring {
+	unsigned int head;
+	unsigned int tail;
+
+	u16 base;
+	u8 nr;
+	u8 fifo_nr;
+	u8 obj_num;
+	u8 obj_size;
+
+	struct mcp25xxfd_hw_rx_obj_canfd obj[];
+};
+
+struct __packed mcp25xxfd_map_buf_nocrc {
+	struct mcp25xxfd_buf_cmd cmd;
+	u8 data[256];
+} ____cacheline_aligned;
+
+struct __packed mcp25xxfd_map_buf_crc {
+	struct mcp25xxfd_buf_cmd_crc cmd;
+	u8 data[256 - 4];
+	__be16 crc;
+} ____cacheline_aligned;
+
+struct mcp25xxfd_ecc {
+	u32 ecc_stat;
+	int cnt;
+};
+
+struct mcp25xxfd_regs_status {
+	u32 intf;
+};
+
+enum mcp25xxfd_model {
+	MCP25XXFD_MODEL_MCP2517FD = 0x2517,
+	MCP25XXFD_MODEL_MCP2518FD = 0x2518,
+	MCP25XXFD_MODEL_MCP25XXFD = 0xffff,	/* autodetect model */
+};
+
+struct mcp25xxfd_devtype_data {
+	enum mcp25xxfd_model model;
+	u32 quirks;
+};
+
+struct mcp25xxfd_priv {
+	struct can_priv can;
+	struct can_rx_offload offload;
+	struct net_device *ndev;
+
+	struct regmap *map_reg;			/* register access */
+	struct regmap *map_rx;			/* RX/TEF RAM access */
+
+	struct regmap *map_nocrc;
+	struct mcp25xxfd_map_buf_nocrc *map_buf_nocrc_rx;
+	struct mcp25xxfd_map_buf_nocrc *map_buf_nocrc_tx;
+
+	struct regmap *map_crc;
+	struct mcp25xxfd_map_buf_crc *map_buf_crc_rx;
+	struct mcp25xxfd_map_buf_crc *map_buf_crc_tx;
+
+	struct spi_device *spi;
+	u32 spi_max_speed_hz_orig;
+
+	struct mcp25xxfd_tef_ring tef;
+	struct mcp25xxfd_tx_ring tx[1];
+	struct mcp25xxfd_rx_ring *rx[1];
+
+	u8 rx_ring_num;
+
+	struct mcp25xxfd_ecc ecc;
+	struct mcp25xxfd_regs_status regs_status;
+
+	struct gpio_desc *rx_int;
+	struct clk *clk;
+	struct regulator *reg_vdd;
+	struct regulator *reg_xceiver;
+
+	struct mcp25xxfd_devtype_data devtype_data;
+	struct can_berr_counter bec;
+};
+
+#define MCP25XXFD_IS(_model) \
+static inline bool \
+mcp25xxfd_is_##_model(const struct mcp25xxfd_priv *priv) \
+{ \
+	return priv->devtype_data.model == MCP25XXFD_MODEL_MCP##_model##FD; \
+}
+
+MCP25XXFD_IS(2517);
+MCP25XXFD_IS(2518);
+MCP25XXFD_IS(25XX);
+
+static inline u8 mcp25xxfd_first_byte_set(u32 mask)
+{
+	return (mask & 0x0000ffff) ?
+		((mask & 0x000000ff) ? 0 : 1) :
+		((mask & 0x00ff0000) ? 2 : 3);
+}
+
+static inline u8 mcp25xxfd_last_byte_set(u32 mask)
+{
+	return (mask & 0xffff0000) ?
+		((mask & 0xff000000) ? 3 : 2) :
+		((mask & 0x0000ff00) ? 1 : 0);
+}
+
+static inline __be16 mcp25xxfd_cmd_reset(void)
+{
+	return cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_RESET);
+}
+
+static inline void
+mcp25xxfd_spi_cmd_read_nocrc(struct mcp25xxfd_buf_cmd *cmd, u16 addr)
+{
+	cmd->cmd = cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_READ | addr);
+}
+
+static inline void
+mcp25xxfd_spi_cmd_write_nocrc(struct mcp25xxfd_buf_cmd *cmd, u16 addr)
+{
+	cmd->cmd = cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_WRITE | addr);
+}
+
+static inline bool mcp25xxfd_reg_in_ram(unsigned int reg)
+{
+	static const struct regmap_range range =
+		regmap_reg_range(MCP25XXFD_RAM_START,
+				 MCP25XXFD_RAM_START + MCP25XXFD_RAM_SIZE - 4);
+
+	return regmap_reg_in_range(reg, &range);
+}
+
+static inline void
+__mcp25xxfd_spi_cmd_crc_set_len(struct mcp25xxfd_buf_cmd_crc *cmd,
+				u16 len, bool in_ram)
+{
+	/* Number of u32 for RAM access, number of u8 otherwise. */
+	if (in_ram)
+		cmd->len = len >> 2;
+	else
+		cmd->len = len;
+}
+
+static inline void
+mcp25xxfd_spi_cmd_crc_set_len_in_ram(struct mcp25xxfd_buf_cmd_crc *cmd, u16 len)
+{
+	__mcp25xxfd_spi_cmd_crc_set_len(cmd, len, true);
+}
+
+static inline void
+mcp25xxfd_spi_cmd_crc_set_len_in_reg(struct mcp25xxfd_buf_cmd_crc *cmd, u16 len)
+{
+	__mcp25xxfd_spi_cmd_crc_set_len(cmd, len, false);
+}
+
+static inline void
+mcp25xxfd_spi_cmd_read_crc_set_addr(struct mcp25xxfd_buf_cmd_crc *cmd, u16 addr)
+{
+	cmd->cmd = cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_READ_CRC | addr);
+}
+
+static inline void
+mcp25xxfd_spi_cmd_read_crc(struct mcp25xxfd_buf_cmd_crc *cmd,
+			   u16 addr, u16 len)
+{
+	mcp25xxfd_spi_cmd_read_crc_set_addr(cmd, addr);
+	__mcp25xxfd_spi_cmd_crc_set_len(cmd, len, mcp25xxfd_reg_in_ram(addr));
+}
+
+static inline void
+mcp25xxfd_spi_cmd_write_crc_set_addr(struct mcp25xxfd_buf_cmd_crc *cmd,
+				     u16 addr)
+{
+	cmd->cmd = cpu_to_be16(MCP25XXFD_SPI_INSTRUCTION_WRITE_CRC | addr);
+}
+
+static inline void
+mcp25xxfd_spi_cmd_write_crc(struct mcp25xxfd_buf_cmd_crc *cmd,
+			    u16 addr, u16 len)
+{
+	mcp25xxfd_spi_cmd_write_crc_set_addr(cmd, addr);
+	__mcp25xxfd_spi_cmd_crc_set_len(cmd, len, mcp25xxfd_reg_in_ram(addr));
+}
+
+static inline u8 *
+mcp25xxfd_spi_cmd_write(const struct mcp25xxfd_priv *priv,
+			union mcp25xxfd_write_reg_buf *write_reg_buf,
+			u16 addr)
+{
+	u8 *data;
+
+	if (priv->devtype_data.quirks & MCP25XXFD_QUIRK_CRC_REG) {
+		mcp25xxfd_spi_cmd_write_crc_set_addr(&write_reg_buf->crc.cmd,
+						     addr);
+		data = write_reg_buf->crc.data;
+	} else {
+		mcp25xxfd_spi_cmd_write_nocrc(&write_reg_buf->nocrc.cmd,
+					      addr);
+		data = write_reg_buf->nocrc.data;
+	}
+
+	return data;
+}
+
+static inline u16 mcp25xxfd_get_tef_obj_addr(u8 n)
+{
+	return MCP25XXFD_RAM_START +
+		sizeof(struct mcp25xxfd_hw_tef_obj) * n;
+}
+
+static inline u16
+mcp25xxfd_get_tx_obj_addr(const struct mcp25xxfd_tx_ring *ring, u8 n)
+{
+	return ring->base + ring->obj_size * n;
+}
+
+static inline u16
+mcp25xxfd_get_rx_obj_addr(const struct mcp25xxfd_rx_ring *ring, u8 n)
+{
+	return ring->base + ring->obj_size * n;
+}
+
+static inline u8 mcp25xxfd_get_tef_head(const struct mcp25xxfd_priv *priv)
+{
+	return priv->tef.head & (priv->tx->obj_num - 1);
+}
+
+static inline u8 mcp25xxfd_get_tef_tail(const struct mcp25xxfd_priv *priv)
+{
+	return priv->tef.tail & (priv->tx->obj_num - 1);
+}
+
+static inline u8 mcp25xxfd_get_tef_len(const struct mcp25xxfd_priv *priv)
+{
+	return priv->tef.head - priv->tef.tail;
+}
+
+static inline u8 mcp25xxfd_get_tef_linear_len(const struct mcp25xxfd_priv *priv)
+{
+	u8 len;
+
+	len = mcp25xxfd_get_tef_len(priv);
+
+	return min_t(u8, len, priv->tx->obj_num - mcp25xxfd_get_tef_tail(priv));
+}
+
+static inline u8 mcp25xxfd_get_tx_head(const struct mcp25xxfd_tx_ring *ring)
+{
+	return ring->head & (ring->obj_num - 1);
+}
+
+static inline u8 mcp25xxfd_get_tx_tail(const struct mcp25xxfd_tx_ring *ring)
+{
+	return ring->tail & (ring->obj_num - 1);
+}
+
+static inline u8 mcp25xxfd_get_tx_free(const struct mcp25xxfd_tx_ring *ring)
+{
+	return ring->obj_num - (ring->head - ring->tail);
+}
+
+static inline int
+mcp25xxfd_get_tx_nr_by_addr(const struct mcp25xxfd_tx_ring *tx_ring, u8 *nr,
+			    u16 addr)
+{
+	if (addr < mcp25xxfd_get_tx_obj_addr(tx_ring, 0) ||
+	    addr >= mcp25xxfd_get_tx_obj_addr(tx_ring, tx_ring->obj_num))
+		return -ENOENT;
+
+	*nr = (addr - mcp25xxfd_get_tx_obj_addr(tx_ring, 0)) /
+		tx_ring->obj_size;
+
+	return 0;
+}
+
+static inline u8 mcp25xxfd_get_rx_head(const struct mcp25xxfd_rx_ring *ring)
+{
+	return ring->head & (ring->obj_num - 1);
+}
+
+static inline u8 mcp25xxfd_get_rx_tail(const struct mcp25xxfd_rx_ring *ring)
+{
+	return ring->tail & (ring->obj_num - 1);
+}
+
+static inline u8 mcp25xxfd_get_rx_len(const struct mcp25xxfd_rx_ring *ring)
+{
+	return ring->head - ring->tail;
+}
+
+static inline u8
+mcp25xxfd_get_rx_linear_len(const struct mcp25xxfd_rx_ring *ring)
+{
+	u8 len;
+
+	len = mcp25xxfd_get_rx_len(ring);
+
+	return min_t(u8, len, ring->obj_num - mcp25xxfd_get_rx_tail(ring));
+}
+
+#define mcp25xxfd_for_each_tx_obj(ring, _obj, n) \
+	for ((n) = 0, (_obj) = &(ring)->obj[(n)]; \
+	     (n) < (ring)->obj_num; \
+	     (n)++, (_obj) = &(ring)->obj[(n)])
+
+#define mcp25xxfd_for_each_rx_ring(priv, ring, n) \
+	for ((n) = 0, (ring) = *((priv)->rx + (n)); \
+	     (n) < (priv)->rx_ring_num; \
+	     (n)++, (ring) = *((priv)->rx + (n)))
+
+int mcp25xxfd_regmap_init(struct mcp25xxfd_priv *priv);
+u16 mcp25xxfd_crc16_compute2(const void *cmd, size_t cmd_size,
+			     const void *data, size_t data_size);
+u16 mcp25xxfd_crc16_compute(const void *data, size_t data_size);
+
+#endif
-- 
2.28.0

