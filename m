Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BCE4C2640
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 09:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiBXI33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 03:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbiBXI3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 03:29:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D6B276D72
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:28:47 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN9UU-00040c-3S
        for netdev@vger.kernel.org; Thu, 24 Feb 2022 09:28:46 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3D4543C356
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:27:30 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id F383E3C317;
        Thu, 24 Feb 2022 08:27:29 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2fc6a74c;
        Thu, 24 Feb 2022 08:27:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 25/36] can: mcp251xfd: __mcp251xfd_chip_set_mode(): prepare for PLL support: improve error handling and diagnostics
Date:   Thu, 24 Feb 2022 09:27:15 +0100
Message-Id: <20220224082726.3000007-26-mkl@pengutronix.de>
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

This patch prepares the __mcp251xfd_chip_set_mode() function for PLL
support by adding more error checks and diagnostics.

Link: https://lore.kernel.org/all/20220207131047.282110-13-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 39 ++++++++++++++-----
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 154e6c376670..d08e0481df35 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -218,34 +218,55 @@ static int
 __mcp251xfd_chip_set_mode(const struct mcp251xfd_priv *priv,
 			  const u8 mode_req, bool nowait)
 {
-	u32 con, con_reqop;
+	u32 con = 0, con_reqop, osc = 0;
+	u8 mode;
 	int err;
 
 	con_reqop = FIELD_PREP(MCP251XFD_REG_CON_REQOP_MASK, mode_req);
 	err = regmap_update_bits(priv->map_reg, MCP251XFD_REG_CON,
 				 MCP251XFD_REG_CON_REQOP_MASK, con_reqop);
-	if (err)
+	if (err == -EBADMSG) {
+		netdev_err(priv->ndev,
+			   "Failed to set Requested Operation Mode.\n");
+
+		return -ENODEV;
+	} else if (err) {
 		return err;
+	}
 
 	if (mode_req == MCP251XFD_REG_CON_MODE_SLEEP || nowait)
 		return 0;
 
 	err = regmap_read_poll_timeout(priv->map_reg, MCP251XFD_REG_CON, con,
+				       !mcp251xfd_reg_invalid(con) &&
 				       FIELD_GET(MCP251XFD_REG_CON_OPMOD_MASK,
 						 con) == mode_req,
 				       MCP251XFD_POLL_SLEEP_US,
 				       MCP251XFD_POLL_TIMEOUT_US);
-	if (err) {
-		u8 mode = FIELD_GET(MCP251XFD_REG_CON_OPMOD_MASK, con);
+	if (err != -ETIMEDOUT && err != -EBADMSG)
+		return err;
+
+	/* Ignore return value.
+	 * Print below error messages, even if this fails.
+	 */
+	regmap_read(priv->map_reg, MCP251XFD_REG_OSC, &osc);
 
+	if (mcp251xfd_reg_invalid(con)) {
 		netdev_err(priv->ndev,
-			   "Controller failed to enter mode %s Mode (%u) and stays in %s Mode (%u).\n",
-			   mcp251xfd_get_mode_str(mode_req), mode_req,
-			   mcp251xfd_get_mode_str(mode), mode);
-		return err;
+			   "Failed to read CAN Control Register (con=0x%08x, osc=0x%08x).\n",
+			   con, osc);
+
+		return -ENODEV;
 	}
 
-	return 0;
+	mode = FIELD_GET(MCP251XFD_REG_CON_OPMOD_MASK, con);
+	netdev_err(priv->ndev,
+		   "Controller failed to enter mode %s Mode (%u) and stays in %s Mode (%u) (con=0x%08x, osc=0x%08x).\n",
+		   mcp251xfd_get_mode_str(mode_req), mode_req,
+		   mcp251xfd_get_mode_str(mode), mode,
+		   con, osc);
+
+	return -ETIMEDOUT;
 }
 
 static inline int
-- 
2.34.1


