Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E894C1EEE
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244529AbiBWWod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244526AbiBWWoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:44:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739433F33C
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:43:47 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN0ML-0006ak-Pc
        for netdev@vger.kernel.org; Wed, 23 Feb 2022 23:43:45 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 71BBF3BBD0
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 22:43:34 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 244583BB9B;
        Wed, 23 Feb 2022 22:43:34 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 869336bf;
        Wed, 23 Feb 2022 22:43:33 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 14/36] can: mcp251xfd: mcp251xfd_reg_invalid(): rename from mcp251xfd_osc_invalid()
Date:   Wed, 23 Feb 2022 23:43:10 +0100
Message-Id: <20220223224332.2965690-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223224332.2965690-1-mkl@pengutronix.de>
References: <20220223224332.2965690-1-mkl@pengutronix.de>
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

This patch renames mcp251xfd_osc_invalid() to mcp251xfd_reg_invalid(),
as it will be used for other registers than the "osc" register in a
later patch.

This patch also moves this function to more towards the beginning of
the file, to be available for other functions, too.

Link: https://lore.kernel.org/all/20220207131047.282110-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index b5986df6eca0..7e0c4e662381 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -178,6 +178,11 @@ static int mcp251xfd_clks_and_vdd_disable(const struct mcp251xfd_priv *priv)
 	return 0;
 }
 
+static inline bool mcp251xfd_reg_invalid(u32 reg)
+{
+	return reg == 0x0 || reg == 0xffffffff;
+}
+
 static inline int
 mcp251xfd_chip_get_mode(const struct mcp251xfd_priv *priv, u8 *mode)
 {
@@ -241,11 +246,6 @@ mcp251xfd_chip_set_mode_nowait(const struct mcp251xfd_priv *priv,
 	return __mcp251xfd_chip_set_mode(priv, mode_req, true);
 }
 
-static inline bool mcp251xfd_osc_invalid(u32 reg)
-{
-	return reg == 0x0 || reg == 0xffffffff;
-}
-
 static int mcp251xfd_chip_clock_enable(const struct mcp251xfd_priv *priv)
 {
 	u32 osc, osc_reference, osc_mask;
@@ -274,7 +274,7 @@ static int mcp251xfd_chip_clock_enable(const struct mcp251xfd_priv *priv)
 				       (osc & osc_mask) == osc_reference,
 				       MCP251XFD_OSC_STAB_SLEEP_US,
 				       MCP251XFD_OSC_STAB_TIMEOUT_US);
-	if (mcp251xfd_osc_invalid(osc)) {
+	if (mcp251xfd_reg_invalid(osc)) {
 		netdev_err(priv->ndev,
 			   "Failed to detect %s (osc=0x%08x).\n",
 			   mcp251xfd_get_model_str(priv), osc);
-- 
2.34.1


