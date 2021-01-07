Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D31B2ECD3B
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbhAGJvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbhAGJv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F410C0612AC
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:50:00 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxRva-0001DG-Rb
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 10:49:58 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 700EB5BBAE4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:49:09 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id DF2645BBA34;
        Thu,  7 Jan 2021 09:49:03 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 39ff7cf6;
        Thu, 7 Jan 2021 09:49:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>
Subject: [net-next 15/19] can: tcan4x5x: rework SPI access
Date:   Thu,  7 Jan 2021 10:48:56 +0100
Message-Id: <20210107094900.173046-16-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107094900.173046-1-mkl@pengutronix.de>
References: <20210107094900.173046-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch reworks the SPI access and fixes several probems:
- tcan4x5x_regmap_gather_write(), tcan4x5x_regmap_read():
  Do not place variable "addr" on stack and use it as buffer for SPI
  transfer. Buffers for SPI transfers must be allocated from DMA save
  memory.
- tcan4x5x_regmap_gather_write(), tcan4x5x_regmap_read():
  Halfe number of SPI transfers by using a single buffer + memcpy().
  This improves the performance, especially on SPI controllers, which
  use interrupt based transfers.
- Use "8" bits per word, not "32". This makes it possible to use this
  driver on SoCs like the Raspberry Pi, which SPI host controller
  drivers only support 8 bits per word.

Note: this breaks half duplex only controllers. Support for them will be
re-added in the next patch.

Reviewed-by: Dan Murphy <dmurphy@ti.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20201215231746.1132907-16-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x-core.c   |  2 +-
 drivers/net/can/m_can/tcan4x5x-regmap.c | 87 +++++++++++++++++--------
 drivers/net/can/m_can/tcan4x5x.h        | 23 +++++++
 3 files changed, 84 insertions(+), 28 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-core.c b/drivers/net/can/m_can/tcan4x5x-core.c
index 739b8f89a335..d37843a74663 100644
--- a/drivers/net/can/m_can/tcan4x5x-core.c
+++ b/drivers/net/can/m_can/tcan4x5x-core.c
@@ -380,7 +380,7 @@ static int tcan4x5x_can_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, priv);
 
 	/* Configure the SPI bus */
-	spi->bits_per_word = 32;
+	spi->bits_per_word = 8;
 	ret = spi_setup(spi);
 	if (ret)
 		goto out_m_can_class_free_dev;
diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index 5ea162578619..660e9d87dffb 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -9,48 +9,76 @@
 
 #include "tcan4x5x.h"
 
-#define TCAN4X5X_WRITE_CMD (0x61 << 24)
-#define TCAN4X5X_READ_CMD (0x41 << 24)
+#define TCAN4X5X_SPI_INSTRUCTION_WRITE (0x61 << 24)
+#define TCAN4X5X_SPI_INSTRUCTION_READ (0x41 << 24)
 
 #define TCAN4X5X_MAX_REGISTER 0x8ffc
 
-static int tcan4x5x_regmap_gather_write(void *context, const void *reg,
-					size_t reg_len, const void *val,
-					size_t val_len)
+static int tcan4x5x_regmap_gather_write(void *context,
+					const void *reg, size_t reg_len,
+					const void *val, size_t val_len)
 {
 	struct spi_device *spi = context;
-	struct spi_message m;
-	u32 addr;
-	struct spi_transfer t[2] = {
-		{ .tx_buf = &addr, .len = reg_len, .cs_change = 0,},
-		{ .tx_buf = val, .len = val_len, },
+	struct tcan4x5x_priv *priv = spi_get_drvdata(spi);
+	struct tcan4x5x_map_buf *buf_tx = &priv->map_buf_tx;
+	struct spi_transfer xfer[] = {
+		{
+			.tx_buf = buf_tx,
+			.len = sizeof(buf_tx->cmd) + val_len,
+		},
 	};
 
-	addr = TCAN4X5X_WRITE_CMD | (*((u16 *)reg) << 8) | val_len >> 2;
+	memcpy(&buf_tx->cmd, reg, sizeof(buf_tx->cmd.cmd) +
+	       sizeof(buf_tx->cmd.addr));
+	tcan4x5x_spi_cmd_set_len(&buf_tx->cmd, val_len);
+	memcpy(buf_tx->data, val, val_len);
 
-	spi_message_init(&m);
-	spi_message_add_tail(&t[0], &m);
-	spi_message_add_tail(&t[1], &m);
-
-	return spi_sync(spi, &m);
+	return spi_sync_transfer(spi, xfer, ARRAY_SIZE(xfer));
 }
 
 static int tcan4x5x_regmap_write(void *context, const void *data, size_t count)
 {
-	return tcan4x5x_regmap_gather_write(context, data, sizeof(u32),
-					    data + sizeof(u32),
-					    count - sizeof(u32));
+	return tcan4x5x_regmap_gather_write(context, data, sizeof(__be32),
+					    data + sizeof(__be32),
+					    count - sizeof(__be32));
 }
 
 static int tcan4x5x_regmap_read(void *context,
-				const void *reg, size_t reg_size,
-				void *val, size_t val_size)
+				const void *reg_buf, size_t reg_len,
+				void *val_buf, size_t val_len)
 {
 	struct spi_device *spi = context;
+	struct tcan4x5x_priv *priv = spi_get_drvdata(spi);
+	struct tcan4x5x_map_buf *buf_rx = &priv->map_buf_rx;
+	struct tcan4x5x_map_buf *buf_tx = &priv->map_buf_tx;
+	struct spi_transfer xfer[] = {
+		{
+			.tx_buf = buf_tx,
+		}
+	};
+	struct spi_message msg;
+	int err;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer[0], &msg);
+
+	memcpy(&buf_tx->cmd, reg_buf, sizeof(buf_tx->cmd.cmd) +
+	       sizeof(buf_tx->cmd.addr));
+	tcan4x5x_spi_cmd_set_len(&buf_tx->cmd, val_len);
+
+	xfer[0].rx_buf = buf_rx;
+	xfer[0].len = sizeof(buf_tx->cmd) + val_len;
 
-	u32 addr = TCAN4X5X_READ_CMD | (*((u16 *)reg) << 8) | val_size >> 2;
+	if (TCAN4X5X_SANITIZE_SPI)
+		memset(buf_tx->data, 0x0, val_len);
 
-	return spi_write_then_read(spi, &addr, reg_size, (u32 *)val, val_size);
+	err = spi_sync(spi, &msg);
+	if (err)
+		return err;
+
+	memcpy(val_buf, buf_rx->data, val_len);
+
+	return 0;
 }
 
 static const struct regmap_range tcan4x5x_reg_table_yes_range[] = {
@@ -66,21 +94,26 @@ static const struct regmap_access_table tcan4x5x_reg_table = {
 };
 
 static const struct regmap_config tcan4x5x_regmap = {
-	.reg_bits = 32,
+	.reg_bits = 24,
 	.reg_stride = 4,
+	.pad_bits = 8,
 	.val_bits = 32,
 	.wr_table = &tcan4x5x_reg_table,
 	.rd_table = &tcan4x5x_reg_table,
-	.cache_type = REGCACHE_NONE,
 	.max_register = TCAN4X5X_MAX_REGISTER,
+	.cache_type = REGCACHE_NONE,
+	.read_flag_mask = (__force unsigned long)
+		cpu_to_be32(TCAN4X5X_SPI_INSTRUCTION_READ),
+	.write_flag_mask = (__force unsigned long)
+		cpu_to_be32(TCAN4X5X_SPI_INSTRUCTION_WRITE),
 };
 
 static const struct regmap_bus tcan4x5x_bus = {
 	.write = tcan4x5x_regmap_write,
 	.gather_write = tcan4x5x_regmap_gather_write,
 	.read = tcan4x5x_regmap_read,
-	.reg_format_endian_default = REGMAP_ENDIAN_NATIVE,
-	.val_format_endian_default = REGMAP_ENDIAN_NATIVE,
+	.reg_format_endian_default = REGMAP_ENDIAN_BIG,
+	.val_format_endian_default = REGMAP_ENDIAN_BIG,
 	.max_raw_read = 256,
 	.max_raw_write = 256,
 };
diff --git a/drivers/net/can/m_can/tcan4x5x.h b/drivers/net/can/m_can/tcan4x5x.h
index e5bdd91b8005..7bf264f8e81f 100644
--- a/drivers/net/can/m_can/tcan4x5x.h
+++ b/drivers/net/can/m_can/tcan4x5x.h
@@ -17,6 +17,19 @@
 
 #include "m_can.h"
 
+#define TCAN4X5X_SANITIZE_SPI 1
+
+struct __packed tcan4x5x_buf_cmd {
+	u8 cmd;
+	__be16 addr;
+	u8 len;
+};
+
+struct __packed tcan4x5x_map_buf {
+	struct tcan4x5x_buf_cmd cmd;
+	u8 data[256 * sizeof(u32)];
+} ____cacheline_aligned;
+
 struct tcan4x5x_priv {
 	struct m_can_classdev cdev;
 
@@ -27,8 +40,18 @@ struct tcan4x5x_priv {
 	struct gpio_desc *device_wake_gpio;
 	struct gpio_desc *device_state_gpio;
 	struct regulator *power;
+
+	struct tcan4x5x_map_buf map_buf_rx;
+	struct tcan4x5x_map_buf map_buf_tx;
 };
 
+static inline void
+tcan4x5x_spi_cmd_set_len(struct tcan4x5x_buf_cmd *cmd, u8 len)
+{
+	/* number of u32 */
+	cmd->len = len >> 2;
+}
+
 int tcan4x5x_regmap_init(struct tcan4x5x_priv *priv);
 
 #endif
-- 
2.29.2


