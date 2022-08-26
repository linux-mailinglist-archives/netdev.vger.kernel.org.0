Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B325A264B
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 12:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344161AbiHZK5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 06:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344053AbiHZK46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 06:56:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1553667452
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:56:54 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRX0w-0002uP-7p; Fri, 26 Aug 2022 12:56:38 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRX0u-0024Yg-RN; Fri, 26 Aug 2022 12:56:36 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oRX0t-00GB3M-IV; Fri, 26 Aug 2022 12:56:35 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v4 10/17] net: dsa: microchip: add regmap_range for KSZ8563 chip
Date:   Fri, 26 Aug 2022 12:56:27 +0200
Message-Id: <20220826105634.3855578-11-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826105634.3855578-1-o.rempel@pengutronix.de>
References: <20220826105634.3855578-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
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

Add register validation for KSZ8563.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 121 +++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 099c7bf699406..b63d4ca608553 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -412,6 +412,125 @@ static const u8 lan937x_shifts[] = {
 	[ALU_STAT_INDEX]		= 8,
 };
 
+static const struct regmap_range ksz8563_valid_regs[] = {
+	regmap_reg_range(0x0000, 0x0003),
+	regmap_reg_range(0x0006, 0x0006),
+	regmap_reg_range(0x000f, 0x001f),
+	regmap_reg_range(0x0100, 0x0100),
+	regmap_reg_range(0x0104, 0x0107),
+	regmap_reg_range(0x010d, 0x010d),
+	regmap_reg_range(0x0110, 0x0113),
+	regmap_reg_range(0x0120, 0x012b),
+	regmap_reg_range(0x0201, 0x0201),
+	regmap_reg_range(0x0210, 0x0213),
+	regmap_reg_range(0x0300, 0x0300),
+	regmap_reg_range(0x0302, 0x031b),
+	regmap_reg_range(0x0320, 0x032b),
+	regmap_reg_range(0x0330, 0x0336),
+	regmap_reg_range(0x0338, 0x033e),
+	regmap_reg_range(0x0340, 0x035f),
+	regmap_reg_range(0x0370, 0x0370),
+	regmap_reg_range(0x0378, 0x0378),
+	regmap_reg_range(0x037c, 0x037d),
+	regmap_reg_range(0x0390, 0x0393),
+	regmap_reg_range(0x0400, 0x040e),
+	regmap_reg_range(0x0410, 0x042f),
+	regmap_reg_range(0x0500, 0x0519),
+	regmap_reg_range(0x0520, 0x054b),
+	regmap_reg_range(0x0550, 0x05b3),
+
+	/* port 1 */
+	regmap_reg_range(0x1000, 0x1001),
+	regmap_reg_range(0x1004, 0x100b),
+	regmap_reg_range(0x1013, 0x1013),
+	regmap_reg_range(0x1017, 0x1017),
+	regmap_reg_range(0x101b, 0x101b),
+	regmap_reg_range(0x101f, 0x1021),
+	regmap_reg_range(0x1030, 0x1030),
+	regmap_reg_range(0x1100, 0x1111),
+	regmap_reg_range(0x111a, 0x111d),
+	regmap_reg_range(0x1122, 0x1127),
+	regmap_reg_range(0x112a, 0x112b),
+	regmap_reg_range(0x1136, 0x1139),
+	regmap_reg_range(0x113e, 0x113f),
+	regmap_reg_range(0x1400, 0x1401),
+	regmap_reg_range(0x1403, 0x1403),
+	regmap_reg_range(0x1410, 0x1417),
+	regmap_reg_range(0x1420, 0x1423),
+	regmap_reg_range(0x1500, 0x1507),
+	regmap_reg_range(0x1600, 0x1612),
+	regmap_reg_range(0x1800, 0x180f),
+	regmap_reg_range(0x1900, 0x1907),
+	regmap_reg_range(0x1914, 0x191b),
+	regmap_reg_range(0x1a00, 0x1a03),
+	regmap_reg_range(0x1a04, 0x1a08),
+	regmap_reg_range(0x1b00, 0x1b01),
+	regmap_reg_range(0x1b04, 0x1b04),
+	regmap_reg_range(0x1c00, 0x1c05),
+	regmap_reg_range(0x1c08, 0x1c1b),
+
+	/* port 2 */
+	regmap_reg_range(0x2000, 0x2001),
+	regmap_reg_range(0x2004, 0x200b),
+	regmap_reg_range(0x2013, 0x2013),
+	regmap_reg_range(0x2017, 0x2017),
+	regmap_reg_range(0x201b, 0x201b),
+	regmap_reg_range(0x201f, 0x2021),
+	regmap_reg_range(0x2030, 0x2030),
+	regmap_reg_range(0x2100, 0x2111),
+	regmap_reg_range(0x211a, 0x211d),
+	regmap_reg_range(0x2122, 0x2127),
+	regmap_reg_range(0x212a, 0x212b),
+	regmap_reg_range(0x2136, 0x2139),
+	regmap_reg_range(0x213e, 0x213f),
+	regmap_reg_range(0x2400, 0x2401),
+	regmap_reg_range(0x2403, 0x2403),
+	regmap_reg_range(0x2410, 0x2417),
+	regmap_reg_range(0x2420, 0x2423),
+	regmap_reg_range(0x2500, 0x2507),
+	regmap_reg_range(0x2600, 0x2612),
+	regmap_reg_range(0x2800, 0x280f),
+	regmap_reg_range(0x2900, 0x2907),
+	regmap_reg_range(0x2914, 0x291b),
+	regmap_reg_range(0x2a00, 0x2a03),
+	regmap_reg_range(0x2a04, 0x2a08),
+	regmap_reg_range(0x2b00, 0x2b01),
+	regmap_reg_range(0x2b04, 0x2b04),
+	regmap_reg_range(0x2c00, 0x2c05),
+	regmap_reg_range(0x2c08, 0x2c1b),
+
+	/* port 3 */
+	regmap_reg_range(0x3000, 0x3001),
+	regmap_reg_range(0x3004, 0x300b),
+	regmap_reg_range(0x3013, 0x3013),
+	regmap_reg_range(0x3017, 0x3017),
+	regmap_reg_range(0x301b, 0x301b),
+	regmap_reg_range(0x301f, 0x3021),
+	regmap_reg_range(0x3030, 0x3030),
+	regmap_reg_range(0x3300, 0x3301),
+	regmap_reg_range(0x3303, 0x3303),
+	regmap_reg_range(0x3400, 0x3401),
+	regmap_reg_range(0x3403, 0x3403),
+	regmap_reg_range(0x3410, 0x3417),
+	regmap_reg_range(0x3420, 0x3423),
+	regmap_reg_range(0x3500, 0x3507),
+	regmap_reg_range(0x3600, 0x3612),
+	regmap_reg_range(0x3800, 0x380f),
+	regmap_reg_range(0x3900, 0x3907),
+	regmap_reg_range(0x3914, 0x391b),
+	regmap_reg_range(0x3a00, 0x3a03),
+	regmap_reg_range(0x3a04, 0x3a08),
+	regmap_reg_range(0x3b00, 0x3b01),
+	regmap_reg_range(0x3b04, 0x3b04),
+	regmap_reg_range(0x3c00, 0x3c05),
+	regmap_reg_range(0x3c08, 0x3c1b),
+};
+
+static const struct regmap_access_table ksz8563_register_set = {
+	.yes_ranges = ksz8563_valid_regs,
+	.n_yes_ranges = ARRAY_SIZE(ksz8563_valid_regs),
+};
+
 const struct ksz_chip_data ksz_switch_chips[] = {
 	[KSZ8563] = {
 		.chip_id = KSZ8563_CHIP_ID,
@@ -435,6 +554,8 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.supports_rgmii = {false, false, true},
 		.internal_phy = {true, true, false},
 		.gbit_capable = {false, false, true},
+		.wr_table = &ksz8563_register_set,
+		.rd_table = &ksz8563_register_set,
 	},
 
 	[KSZ8795] = {
-- 
2.30.2

