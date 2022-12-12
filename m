Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C0B649DE5
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbiLLLc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiLLLbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:31:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F3A9FDC
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 03:31:13 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p4h1b-0000qE-O3
        for netdev@vger.kernel.org; Mon, 12 Dec 2022 12:31:11 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 906B213CC87
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 11:30:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A05DE13CC4C;
        Mon, 12 Dec 2022 11:30:57 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 49428086;
        Mon, 12 Dec 2022 11:30:48 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Markus Schneider-Pargmann <msp@baylibre.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 39/39] can: tcan4x5x: Specify separate read/write ranges
Date:   Mon, 12 Dec 2022 12:30:45 +0100
Message-Id: <20221212113045.222493-40-mkl@pengutronix.de>
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

Specify exactly which registers are read/writeable in the chip. This
is supposed to help detect any violations in the future.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://lore.kernel.org/all/20221206115728.1056014-12-msp@baylibre.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x-regmap.c | 43 +++++++++++++++++++++----
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index 33aed989e42a..2b218ce04e9f 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -90,16 +90,47 @@ static int tcan4x5x_regmap_read(void *context,
 	return 0;
 }
 
-static const struct regmap_range tcan4x5x_reg_table_yes_range[] = {
+static const struct regmap_range tcan4x5x_reg_table_wr_range[] = {
+	/* Device ID and SPI Registers */
+	regmap_reg_range(0x000c, 0x0010),
+	/* Device configuration registers and Interrupt Flags*/
+	regmap_reg_range(0x0800, 0x080c),
+	regmap_reg_range(0x0814, 0x0814),
+	regmap_reg_range(0x0820, 0x0820),
+	regmap_reg_range(0x0830, 0x0830),
+	/* M_CAN */
+	regmap_reg_range(0x100c, 0x102c),
+	regmap_reg_range(0x1048, 0x1048),
+	regmap_reg_range(0x1050, 0x105c),
+	regmap_reg_range(0x1080, 0x1088),
+	regmap_reg_range(0x1090, 0x1090),
+	regmap_reg_range(0x1098, 0x10a0),
+	regmap_reg_range(0x10a8, 0x10b0),
+	regmap_reg_range(0x10b8, 0x10c0),
+	regmap_reg_range(0x10c8, 0x10c8),
+	regmap_reg_range(0x10d0, 0x10d4),
+	regmap_reg_range(0x10e0, 0x10e4),
+	regmap_reg_range(0x10f0, 0x10f0),
+	regmap_reg_range(0x10f8, 0x10f8),
+	/* MRAM */
+	regmap_reg_range(0x8000, 0x87fc),
+};
+
+static const struct regmap_range tcan4x5x_reg_table_rd_range[] = {
 	regmap_reg_range(0x0000, 0x0010),	/* Device ID and SPI Registers */
 	regmap_reg_range(0x0800, 0x0830),	/* Device configuration registers and Interrupt Flags*/
 	regmap_reg_range(0x1000, 0x10fc),	/* M_CAN */
 	regmap_reg_range(0x8000, 0x87fc),	/* MRAM */
 };
 
-static const struct regmap_access_table tcan4x5x_reg_table = {
-	.yes_ranges = tcan4x5x_reg_table_yes_range,
-	.n_yes_ranges = ARRAY_SIZE(tcan4x5x_reg_table_yes_range),
+static const struct regmap_access_table tcan4x5x_reg_table_wr = {
+	.yes_ranges = tcan4x5x_reg_table_wr_range,
+	.n_yes_ranges = ARRAY_SIZE(tcan4x5x_reg_table_wr_range),
+};
+
+static const struct regmap_access_table tcan4x5x_reg_table_rd = {
+	.yes_ranges = tcan4x5x_reg_table_rd_range,
+	.n_yes_ranges = ARRAY_SIZE(tcan4x5x_reg_table_rd_range),
 };
 
 static const struct regmap_config tcan4x5x_regmap = {
@@ -107,8 +138,8 @@ static const struct regmap_config tcan4x5x_regmap = {
 	.reg_stride = 4,
 	.pad_bits = 8,
 	.val_bits = 32,
-	.wr_table = &tcan4x5x_reg_table,
-	.rd_table = &tcan4x5x_reg_table,
+	.wr_table = &tcan4x5x_reg_table_wr,
+	.rd_table = &tcan4x5x_reg_table_rd,
 	.max_register = TCAN4X5X_MAX_REGISTER,
 	.cache_type = REGCACHE_NONE,
 	.read_flag_mask = (__force unsigned long)
-- 
2.35.1


