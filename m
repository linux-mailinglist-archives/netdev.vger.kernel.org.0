Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15C64C2614
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 09:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiBXI3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 03:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiBXI32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 03:29:28 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9382A278282
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:28:55 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN9Ub-0004IP-P9
        for netdev@vger.kernel.org; Thu, 24 Feb 2022 09:28:53 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8F9053C2DA
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:27:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2596B3C269;
        Thu, 24 Feb 2022 08:27:29 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0b955d3e;
        Thu, 24 Feb 2022 08:27:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 15/36] can: mcp251xfd: mcp251xfd_regmap_crc_read(): ignore CRC error only if solely OSC register is read
Date:   Thu, 24 Feb 2022 09:27:05 +0100
Message-Id: <20220224082726.3000007-16-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220224082726.3000007-1-mkl@pengutronix.de>
References: <20220224082726.3000007-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MCP251XFD_REG_OSC is the first register the driver reads from. The
chip may be in deep sleep and the SPI transfer (i.e. the assertion of
the CS) will wake the chip up. This takes about 3ms. The CRC of this
transfer is wrong, or there isn't any chip at all, in this case the
CRC will be wrong, too. The driver ignores the CRC error and returns
the read data to the caller.

To avoid any confusion, this patch changes the
mcp251xfd_regmap_crc_read() function to only ignore the CRC error if
solely the OSC register is read. So when reading more than the OSC
registers at once, CRC errors are not ignored.

Link: https://lore.kernel.org/all/20220207131047.282110-3-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
index 7b120c716228..8112f8df22a6 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
@@ -368,7 +368,7 @@ mcp251xfd_regmap_crc_read(void *context,
 		 * to the caller. It will take care of both cases.
 		 *
 		 */
-		if (reg == MCP251XFD_REG_OSC) {
+		if (reg == MCP251XFD_REG_OSC && val_len == sizeof(__le32)) {
 			err = 0;
 			goto out;
 		}
-- 
2.34.1


