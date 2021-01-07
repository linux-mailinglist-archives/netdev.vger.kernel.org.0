Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664042ECD29
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbhAGJvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbhAGJvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:11 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6B0C0612FC
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:49:53 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxRvU-00015c-Eq
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 10:49:52 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2B17D5BBADC
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:49:09 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9A4515BBA2F;
        Thu,  7 Jan 2021 09:49:03 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bb3b969c;
        Thu, 7 Jan 2021 09:49:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>
Subject: [net-next 14/19] can: tcan4x5x: add {wr,rd}_table
Date:   Thu,  7 Jan 2021 10:48:55 +0100
Message-Id: <20210107094900.173046-15-mkl@pengutronix.de>
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

The memory space of the chip is not fully populated, so add a regmap range
table to document this.

Reviewed-by: Dan Murphy <dmurphy@ti.com>
Tested-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20201215231746.1132907-15-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/tcan4x5x-regmap.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/can/m_can/tcan4x5x-regmap.c b/drivers/net/can/m_can/tcan4x5x-regmap.c
index f113881fb012..5ea162578619 100644
--- a/drivers/net/can/m_can/tcan4x5x-regmap.c
+++ b/drivers/net/can/m_can/tcan4x5x-regmap.c
@@ -53,10 +53,24 @@ static int tcan4x5x_regmap_read(void *context,
 	return spi_write_then_read(spi, &addr, reg_size, (u32 *)val, val_size);
 }
 
+static const struct regmap_range tcan4x5x_reg_table_yes_range[] = {
+	regmap_reg_range(0x0000, 0x002c),	/* Device ID and SPI Registers */
+	regmap_reg_range(0x0800, 0x083c),	/* Device configuration registers and Interrupt Flags*/
+	regmap_reg_range(0x1000, 0x10fc),	/* M_CAN */
+	regmap_reg_range(0x8000, 0x87fc),	/* MRAM */
+};
+
+static const struct regmap_access_table tcan4x5x_reg_table = {
+	.yes_ranges = tcan4x5x_reg_table_yes_range,
+	.n_yes_ranges = ARRAY_SIZE(tcan4x5x_reg_table_yes_range),
+};
+
 static const struct regmap_config tcan4x5x_regmap = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
+	.wr_table = &tcan4x5x_reg_table,
+	.rd_table = &tcan4x5x_reg_table,
 	.cache_type = REGCACHE_NONE,
 	.max_register = TCAN4X5X_MAX_REGISTER,
 };
-- 
2.29.2


