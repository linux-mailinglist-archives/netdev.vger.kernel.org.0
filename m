Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F68157B30B
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240383AbiGTIg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232594AbiGTIg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:36:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682AD54ACA
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:36:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oE5Bx-0005mM-Td
        for netdev@vger.kernel.org; Wed, 20 Jul 2022 10:36:25 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CB0D0B5B88
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:36:24 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 53847B5B80;
        Wed, 20 Jul 2022 08:36:24 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ce92ab8b;
        Wed, 20 Jul 2022 08:36:23 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 1/2] can: mcp251xfd: fix detection of mcp251863
Date:   Wed, 20 Jul 2022 10:36:20 +0200
Message-Id: <20220720083621.3294548-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720083621.3294548-1-mkl@pengutronix.de>
References: <20220720083621.3294548-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit c6f2a617a0a8 ("can: mcp251xfd: add support for mcp251863")
support for the mcp251863 was added. However it was not taken into
account that the auto detection of the chip model cannot distinguish
between mcp2518fd and mcp251863 and would lead to a warning message if
the firmware specifies a mcp251863.

Fix auto detection: If a mcp2518fd compatible chip is found, keep the
mcp251863 if specified by firmware, use mcp2518fd instead.

Link: https://lore.kernel.org/all/20220706064835.1848864-1-mkl@pengutronix.de
Fixes: c6f2a617a0a8 ("can: mcp251xfd: add support for mcp251863")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 9b47b07162fe..bc6518504fd4 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1690,8 +1690,8 @@ static int mcp251xfd_register_chip_detect(struct mcp251xfd_priv *priv)
 	u32 osc;
 	int err;
 
-	/* The OSC_LPMEN is only supported on MCP2518FD, so use it to
-	 * autodetect the model.
+	/* The OSC_LPMEN is only supported on MCP2518FD and MCP251863,
+	 * so use it to autodetect the model.
 	 */
 	err = regmap_update_bits(priv->map_reg, MCP251XFD_REG_OSC,
 				 MCP251XFD_REG_OSC_LPMEN,
@@ -1703,10 +1703,18 @@ static int mcp251xfd_register_chip_detect(struct mcp251xfd_priv *priv)
 	if (err)
 		return err;
 
-	if (osc & MCP251XFD_REG_OSC_LPMEN)
-		devtype_data = &mcp251xfd_devtype_data_mcp2518fd;
-	else
+	if (osc & MCP251XFD_REG_OSC_LPMEN) {
+		/* We cannot distinguish between MCP2518FD and
+		 * MCP251863. If firmware specifies MCP251863, keep
+		 * it, otherwise set to MCP2518FD.
+		 */
+		if (mcp251xfd_is_251863(priv))
+			devtype_data = &mcp251xfd_devtype_data_mcp251863;
+		else
+			devtype_data = &mcp251xfd_devtype_data_mcp2518fd;
+	} else {
 		devtype_data = &mcp251xfd_devtype_data_mcp2517fd;
+	}
 
 	if (!mcp251xfd_is_251XFD(priv) &&
 	    priv->devtype_data.model != devtype_data->model) {

base-commit: 48ea8ea32dbf3231882e9bc0b297fe1400785219
-- 
2.35.1


