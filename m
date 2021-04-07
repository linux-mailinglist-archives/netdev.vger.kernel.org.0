Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8F13565F2
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 10:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245120AbhDGIBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 04:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242867AbhDGIBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 04:01:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B2DC061764
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 01:01:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lU37y-000208-4n
        for netdev@vger.kernel.org; Wed, 07 Apr 2021 10:01:30 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B5388609804
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 08:01:25 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 20D936097D8;
        Wed,  7 Apr 2021 08:01:21 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ea9b0bef;
        Wed, 7 Apr 2021 08:01:19 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>
Subject: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work around broken CRC on TBC register
Date:   Wed,  7 Apr 2021 10:01:18 +0200
Message-Id: <20210407080118.1916040-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407080118.1916040-1-mkl@pengutronix.de>
References: <20210407080118.1916040-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MCP251XFD_REG_TBC is the time base counter register. It increments
once per SYS clock tick, which is 20 or 40 MHz. Observation shows that
if the lowest byte (which is transferred first on the SPI bus) of that
register is 0x00 or 0x80 the calculated CRC doesn't always match the
transferred one.

To reproduce this problem let the driver read the TBC register in a
high frequency. This can be done by attaching only the mcp251xfd CAN
controller to a valid terminated CAN bus and send a single CAN frame.
As there are no other CAN controller on the bus, the sent CAN frame is
not ACKed and the mcp251xfd repeats it. If user space enables the bus
error reporting, each of the NACK errors is reported with a time
stamp (which is read from the TBC register) to user space.

$ ip link set can0 down
$ ip link set can0 up type can bitrate 500000 berr-reporting on
$ cansend can0 4FF#ff.01.00.00.00.00.00.00

This leads to several error messages per second:

| mcp251xfd spi0.0 can0: CRC read error at address 0x0010 (length=4, data=00 3a 86 da, CRC=0x7753) retrying.
| mcp251xfd spi0.0 can0: CRC read error at address 0x0010 (length=4, data=80 01 b4 da, CRC=0x5830) retrying.
| mcp251xfd spi0.0 can0: CRC read error at address 0x0010 (length=4, data=00 e9 23 db, CRC=0xa723) retrying.
| mcp251xfd spi0.0 can0: CRC read error at address 0x0010 (length=4, data=00 8a 30 db, CRC=0x4a9c) retrying.
| mcp251xfd spi0.0 can0: CRC read error at address 0x0010 (length=4, data=80 f3 43 db, CRC=0x66d2) retrying.

If the highest bit in the lowest byte is flipped the transferred CRC
matches the calculated one. We assume for now the CRC calculation in
the chip works on wrong data and the transferred data is correct.

This patch implements the following workaround:

- If a CRC read error on the TBC register is detected and the lowest
  byte is 0x00 or 0x80, the highest bit of the lowest byte is flipped
  and the CRC is calculated again.
- If the CRC now matches, the _original_ data is passed to the reader.
  For now we assume transferred data was OK.

Link: https://lore.kernel.org/r/20210406110617.1865592-5-mkl@pengutronix.de
Cc: Manivannan Sadhasivam <mani@kernel.org>
Cc: Thomas Kopp <thomas.kopp@microchip.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-regmap.c  | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
index 35557ac43c03..297491516a26 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
@@ -321,6 +321,40 @@ mcp251xfd_regmap_crc_read(void *context,
 		if (err != -EBADMSG)
 			return err;
 
+		/* MCP251XFD_REG_TBC is the time base counter
+		 * register. It increments once per SYS clock tick,
+		 * which is 20 or 40 MHz.
+		 *
+		 * Observation shows that if the lowest byte (which is
+		 * transferred first on the SPI bus) of that register
+		 * is 0x00 or 0x80 the calculated CRC doesn't always
+		 * match the transferred one.
+		 *
+		 * If the highest bit in the lowest byte is flipped
+		 * the transferred CRC matches the calculated one. We
+		 * assume for now the CRC calculation in the chip
+		 * works on wrong data and the transferred data is
+		 * correct.
+		 */
+		if (reg == MCP251XFD_REG_TBC &&
+		    (buf_rx->data[0] == 0x0 || buf_rx->data[0] == 0x80)) {
+			/* Flip highest bit in lowest byte of le32 */
+			buf_rx->data[0] ^= 0x80;
+
+			/* re-check CRC */
+			err = mcp251xfd_regmap_crc_read_check_crc(buf_rx,
+								  buf_tx,
+								  val_len);
+			if (!err) {
+				/* If CRC is now correct, assume
+				 * transferred data was OK, flip bit
+				 * back to original value.
+				 */
+				buf_rx->data[0] ^= 0x80;
+				goto out;
+			}
+		}
+
 		/* MCP251XFD_REG_OSC is the first ever reg we read from.
 		 *
 		 * The chip may be in deep sleep and this SPI transfer
-- 
2.30.2


