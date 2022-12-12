Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA067649DE0
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbiLLLca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiLLLbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167C5659F
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:14 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1c-0000p9-6O
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:12 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4C0F113CC83
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6371513CC45;
        Mon, 12 Dec 2022 11:30:57 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 567fd8d7;
        Mon, 12 Dec 2022 11:30:48 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Markus Schneider-Pargmann <msp@baylibre.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 38/39] can: tcan4x5x: Fix register range of first two blocks
Date:   Mon, 12 Dec 2022 12:30:44 +0100
Message-Id: <20221212113045.222493-39-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212113045.222493-1-mkl@pengutronix.de>
References: <20221212113045.222493-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Schneider-Pargmann <msp@baylibre.com>

According to the datasheet 0x10 is the last register in the first block,
not register 0x2c.

The datasheet lists the last register of the second block as 0x830, not
0x83c.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20221206115728.1056014-11-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x-regmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index 26e212b8ca7a..33aed989e42a 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -91,8 +91,8 @@ static int tcan4x5x_regmap_read(void *context,
 }
 
 static const struct regmap_range tcan4x5x_reg_table_yes_range[] = {
-	regmap_reg_range(0x0000, 0x002c),	/* Device ID and SPI Registers */
-	regmap_reg_range(0x0800, 0x083c),	/* Device configuration registers and Interrupt Flags*/
+	regmap_reg_range(0x0000, 0x0010),	/* Device ID and SPI Registers */
+	regmap_reg_range(0x0800, 0x0830),	/* Device configuration registers and Interrupt Flags*/
 	regmap_reg_range(0x1000, 0x10fc),	/* M_CAN */
 	regmap_reg_range(0x8000, 0x87fc),	/* MRAM */
 };
-- 
2.35.1


