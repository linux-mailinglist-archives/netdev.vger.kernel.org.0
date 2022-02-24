Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69F44C2622
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 09:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiBXIai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 03:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbiBXI3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 03:29:44 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5E32782AD
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:28:59 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN9Uf-0004TW-G7
        for netdev@vger.kernel.org; Thu, 24 Feb 2022 09:28:57 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A12A13C2EA
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:27:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 577E73C29B;
        Thu, 24 Feb 2022 08:27:29 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 678f5caf;
        Thu, 24 Feb 2022 08:27:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 17/36] can: mcp251xfd: mcp251xfd_chip_sleep(): introduce function to bring chip into sleep mode
Date:   Thu, 24 Feb 2022 09:27:07 +0100
Message-Id: <20220224082726.3000007-18-mkl@pengutronix.de>
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

This patch adds a new function to bring the chip into sleep mode, and
replaces several occurrences of open coded variants.

Link: https://lore.kernel.org/all/20220207131047.282110-5-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 49ce5ff34903..4c8c45f246d8 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -289,6 +289,11 @@ static int mcp251xfd_chip_clock_enable(const struct mcp251xfd_priv *priv)
 	return err;
 }
 
+static inline int mcp251xfd_chip_sleep(const struct mcp251xfd_priv *priv)
+{
+	return mcp251xfd_chip_set_mode(priv, MCP251XFD_REG_CON_MODE_SLEEP);
+}
+
 static int mcp251xfd_chip_softreset_do(const struct mcp251xfd_priv *priv)
 {
 	const __be16 cmd = mcp251xfd_cmd_reset();
@@ -635,7 +640,7 @@ static int mcp251xfd_chip_stop(struct mcp251xfd_priv *priv,
 
 	mcp251xfd_chip_interrupts_disable(priv);
 	mcp251xfd_chip_rx_int_disable(priv);
-	return mcp251xfd_chip_set_mode(priv, MCP251XFD_REG_CON_MODE_SLEEP);
+	return mcp251xfd_chip_sleep(priv);
 }
 
 static int mcp251xfd_chip_start(struct mcp251xfd_priv *priv)
@@ -1719,19 +1724,19 @@ static int mcp251xfd_register(struct mcp251xfd_priv *priv)
 	if (err == -ENODEV)
 		goto out_runtime_disable;
 	if (err)
-		goto out_chip_set_mode_sleep;
+		goto out_chip_sleep;
 
 	err = mcp251xfd_register_chip_detect(priv);
 	if (err)
-		goto out_chip_set_mode_sleep;
+		goto out_chip_sleep;
 
 	err = mcp251xfd_register_check_rx_int(priv);
 	if (err)
-		goto out_chip_set_mode_sleep;
+		goto out_chip_sleep;
 
 	err = register_candev(ndev);
 	if (err)
-		goto out_chip_set_mode_sleep;
+		goto out_chip_sleep;
 
 	err = mcp251xfd_register_done(priv);
 	if (err)
@@ -1741,7 +1746,7 @@ static int mcp251xfd_register(struct mcp251xfd_priv *priv)
 	 * disable the clocks and vdd. If CONFIG_PM is not enabled,
 	 * the clocks and vdd will stay powered.
 	 */
-	err = mcp251xfd_chip_set_mode(priv, MCP251XFD_REG_CON_MODE_SLEEP);
+	err = mcp251xfd_chip_sleep(priv);
 	if (err)
 		goto out_unregister_candev;
 
@@ -1751,8 +1756,8 @@ static int mcp251xfd_register(struct mcp251xfd_priv *priv)
 
  out_unregister_candev:
 	unregister_candev(ndev);
- out_chip_set_mode_sleep:
-	mcp251xfd_chip_set_mode(priv, MCP251XFD_REG_CON_MODE_SLEEP);
+ out_chip_sleep:
+	mcp251xfd_chip_sleep(priv);
  out_runtime_disable:
 	pm_runtime_disable(ndev->dev.parent);
  out_runtime_put_noidle:
-- 
2.34.1


