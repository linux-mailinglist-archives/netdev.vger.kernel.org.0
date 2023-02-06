Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1E668BDA7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjBFNRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjBFNRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:17:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF8915C8A
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:20 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N0-0007Rq-EN
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:18 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2ED021712F8
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:24 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6C449171299;
        Mon,  6 Feb 2023 13:16:22 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2f1cbd01;
        Mon, 6 Feb 2023 13:16:21 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Thomas Kopp <thomas.kopp@microchip.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 03/47] can: mcp251xfd: regmap: optimizing transfer size for CRC transfers size 1
Date:   Mon,  6 Feb 2023 14:15:36 +0100
Message-Id: <20230206131620.2758724-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Kopp <thomas.kopp@microchip.com>

For CRC transfers with size 1 it is more efficient to use the
write_safe command instead of the write_crc command. This saves the
length byte on the SPI transfer.

changes since v1: https://lore.kernel.org/all/20230127124258.2764-1-thomas.kopp@microchip.com
- change logic to remove 1 level of indention

Link: https://lore.kernel.org/all/20230202141811.2581795-1-mkl@pengutronix.de
Signed-off-by: Thomas Kopp <thomas.kopp@microchip.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    | 18 ++++++++++---
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h     | 26 ++++++++++++++++---
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index bf3f0f150199..bfe4caa0c99d 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -30,11 +30,23 @@ mcp251xfd_cmd_prepare_write_reg(const struct mcp251xfd_priv *priv,
 	last_byte = mcp251xfd_last_byte_set(mask);
 	len = last_byte - first_byte + 1;
 
-	data = mcp251xfd_spi_cmd_write(priv, write_reg_buf, reg + first_byte);
+	data = mcp251xfd_spi_cmd_write(priv, write_reg_buf, reg + first_byte, len);
 	val_le32 = cpu_to_le32(val >> BITS_PER_BYTE * first_byte);
 	memcpy(data, &val_le32, len);
 
-	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_REG) {
+	if (!(priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_REG)) {
+		len += sizeof(write_reg_buf->nocrc.cmd);
+	} else if (len == 1) {
+		u16 crc;
+
+		/* CRC */
+		len += sizeof(write_reg_buf->safe.cmd);
+		crc = mcp251xfd_crc16_compute(&write_reg_buf->safe, len);
+		put_unaligned_be16(crc, (void *)write_reg_buf + len);
+
+		/* Total length */
+		len += sizeof(write_reg_buf->safe.crc);
+	} else {
 		u16 crc;
 
 		mcp251xfd_spi_cmd_crc_set_len_in_reg(&write_reg_buf->crc.cmd,
@@ -46,8 +58,6 @@ mcp251xfd_cmd_prepare_write_reg(const struct mcp251xfd_priv *priv,
 
 		/* Total length */
 		len += sizeof(write_reg_buf->crc.crc);
-	} else {
-		len += sizeof(write_reg_buf->nocrc.cmd);
 	}
 
 	return len;
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
index 2b0309fedfac..7024ff0cc2c0 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd.h
@@ -504,6 +504,11 @@ union mcp251xfd_write_reg_buf {
 		u8 data[4];
 		__be16 crc;
 	} crc;
+	struct __packed {
+		struct mcp251xfd_buf_cmd cmd;
+		u8 data[1];
+		__be16 crc;
+	} safe;
 } ____cacheline_aligned;
 
 struct mcp251xfd_tx_obj {
@@ -758,6 +763,13 @@ mcp251xfd_spi_cmd_write_crc_set_addr(struct mcp251xfd_buf_cmd_crc *cmd,
 	cmd->cmd = cpu_to_be16(MCP251XFD_SPI_INSTRUCTION_WRITE_CRC | addr);
 }
 
+static inline void
+mcp251xfd_spi_cmd_write_safe_set_addr(struct mcp251xfd_buf_cmd *cmd,
+				     u16 addr)
+{
+	cmd->cmd = cpu_to_be16(MCP251XFD_SPI_INSTRUCTION_WRITE_CRC_SAFE | addr);
+}
+
 static inline void
 mcp251xfd_spi_cmd_write_crc(struct mcp251xfd_buf_cmd_crc *cmd,
 			    u16 addr, u16 len)
@@ -769,14 +781,20 @@ mcp251xfd_spi_cmd_write_crc(struct mcp251xfd_buf_cmd_crc *cmd,
 static inline u8 *
 mcp251xfd_spi_cmd_write(const struct mcp251xfd_priv *priv,
 			union mcp251xfd_write_reg_buf *write_reg_buf,
-			u16 addr)
+			u16 addr, u8 len)
 {
 	u8 *data;
 
 	if (priv->devtype_data.quirks & MCP251XFD_QUIRK_CRC_REG) {
-		mcp251xfd_spi_cmd_write_crc_set_addr(&write_reg_buf->crc.cmd,
-						     addr);
-		data = write_reg_buf->crc.data;
+		if (len == 1) {
+			mcp251xfd_spi_cmd_write_safe_set_addr(&write_reg_buf->safe.cmd,
+							     addr);
+			data = write_reg_buf->safe.data;
+		} else {
+			mcp251xfd_spi_cmd_write_crc_set_addr(&write_reg_buf->crc.cmd,
+							     addr);
+			data = write_reg_buf->crc.data;
+		}
 	} else {
 		mcp251xfd_spi_cmd_write_nocrc(&write_reg_buf->nocrc.cmd,
 					      addr);
-- 
2.39.1


