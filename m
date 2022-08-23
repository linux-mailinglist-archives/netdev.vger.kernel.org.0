Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1759559D30F
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 10:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241575AbiHWIDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 04:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240406AbiHWIC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 04:02:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76164659E6
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 01:02:57 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oQOrt-0002vm-OZ; Tue, 23 Aug 2022 10:02:37 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQOrr-001SvC-Nv; Tue, 23 Aug 2022 10:02:35 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQOrp-00ALZN-8B; Tue, 23 Aug 2022 10:02:33 +0200
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
Subject: [PATCH net-next v3 12/17] net: dsa: microchip: add regmap_range for KSZ9477 chip
Date:   Tue, 23 Aug 2022 10:02:26 +0200
Message-Id: <20220823080231.2466017-13-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220823080231.2466017-1-o.rempel@pengutronix.de>
References: <20220823080231.2466017-1-o.rempel@pengutronix.de>
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

Add register validation for KSZ9477

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz_common.c | 272 +++++++++++++++++++++++++
 1 file changed, 272 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index e2a698e16e023..a863d4feb4135 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -531,6 +531,276 @@ static const struct regmap_access_table ksz8563_register_set = {
 	.n_yes_ranges = ARRAY_SIZE(ksz8563_valid_regs),
 };
 
+static const struct regmap_range ksz9477_valid_regs[] = {
+	regmap_reg_range(0x0000, 0x0003),
+	regmap_reg_range(0x0006, 0x0006),
+	regmap_reg_range(0x0010, 0x001f),
+	regmap_reg_range(0x0100, 0x0100),
+	regmap_reg_range(0x0103, 0x0107),
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
+	regmap_reg_range(0x0444, 0x044b),
+	regmap_reg_range(0x0450, 0x046f),
+	regmap_reg_range(0x0500, 0x0519),
+	regmap_reg_range(0x0520, 0x054b),
+	regmap_reg_range(0x0550, 0x05b3),
+	regmap_reg_range(0x0604, 0x060b),
+	regmap_reg_range(0x0610, 0x0612),
+	regmap_reg_range(0x0614, 0x062c),
+	regmap_reg_range(0x0640, 0x0645),
+	regmap_reg_range(0x0648, 0x064d),
+
+	/* port 1 */
+	regmap_reg_range(0x1000, 0x1001),
+	regmap_reg_range(0x1013, 0x1013),
+	regmap_reg_range(0x1017, 0x1017),
+	regmap_reg_range(0x101b, 0x101b),
+	regmap_reg_range(0x101f, 0x1020),
+	regmap_reg_range(0x1030, 0x1030),
+	regmap_reg_range(0x1100, 0x1115),
+	regmap_reg_range(0x111a, 0x111f),
+	regmap_reg_range(0x1122, 0x1127),
+	regmap_reg_range(0x112a, 0x112b),
+	regmap_reg_range(0x1136, 0x1139),
+	regmap_reg_range(0x113e, 0x113f),
+	regmap_reg_range(0x1400, 0x1401),
+	regmap_reg_range(0x1403, 0x1403),
+	regmap_reg_range(0x1410, 0x1417),
+	regmap_reg_range(0x1420, 0x1423),
+	regmap_reg_range(0x1500, 0x1507),
+	regmap_reg_range(0x1600, 0x1613),
+	regmap_reg_range(0x1800, 0x180f),
+	regmap_reg_range(0x1820, 0x1827),
+	regmap_reg_range(0x1830, 0x1837),
+	regmap_reg_range(0x1840, 0x184b),
+	regmap_reg_range(0x1900, 0x1907),
+	regmap_reg_range(0x1914, 0x191b),
+	regmap_reg_range(0x1920, 0x1920),
+	regmap_reg_range(0x1923, 0x1927),
+	regmap_reg_range(0x1a00, 0x1a03),
+	regmap_reg_range(0x1a04, 0x1a07),
+	regmap_reg_range(0x1b00, 0x1b01),
+	regmap_reg_range(0x1b04, 0x1b04),
+	regmap_reg_range(0x1c00, 0x1c05),
+	regmap_reg_range(0x1c08, 0x1c1b),
+
+	/* port 2 */
+	regmap_reg_range(0x2000, 0x2001),
+	regmap_reg_range(0x2013, 0x2013),
+	regmap_reg_range(0x2017, 0x2017),
+	regmap_reg_range(0x201b, 0x201b),
+	regmap_reg_range(0x201f, 0x2020),
+	regmap_reg_range(0x2030, 0x2030),
+	regmap_reg_range(0x2100, 0x2115),
+	regmap_reg_range(0x211a, 0x211f),
+	regmap_reg_range(0x2122, 0x2127),
+	regmap_reg_range(0x212a, 0x212b),
+	regmap_reg_range(0x2136, 0x2139),
+	regmap_reg_range(0x213e, 0x213f),
+	regmap_reg_range(0x2400, 0x2401),
+	regmap_reg_range(0x2403, 0x2403),
+	regmap_reg_range(0x2410, 0x2417),
+	regmap_reg_range(0x2420, 0x2423),
+	regmap_reg_range(0x2500, 0x2507),
+	regmap_reg_range(0x2600, 0x2613),
+	regmap_reg_range(0x2800, 0x280f),
+	regmap_reg_range(0x2820, 0x2827),
+	regmap_reg_range(0x2830, 0x2837),
+	regmap_reg_range(0x2840, 0x284b),
+	regmap_reg_range(0x2900, 0x2907),
+	regmap_reg_range(0x2914, 0x291b),
+	regmap_reg_range(0x2920, 0x2920),
+	regmap_reg_range(0x2923, 0x2927),
+	regmap_reg_range(0x2a00, 0x2a03),
+	regmap_reg_range(0x2a04, 0x2a07),
+	regmap_reg_range(0x2b00, 0x2b01),
+	regmap_reg_range(0x2b04, 0x2b04),
+	regmap_reg_range(0x2c00, 0x2c05),
+	regmap_reg_range(0x2c08, 0x2c1b),
+
+	/* port 3 */
+	regmap_reg_range(0x3000, 0x3001),
+	regmap_reg_range(0x3013, 0x3013),
+	regmap_reg_range(0x3017, 0x3017),
+	regmap_reg_range(0x301b, 0x301b),
+	regmap_reg_range(0x301f, 0x3020),
+	regmap_reg_range(0x3030, 0x3030),
+	regmap_reg_range(0x3100, 0x3115),
+	regmap_reg_range(0x311a, 0x311f),
+	regmap_reg_range(0x3122, 0x3127),
+	regmap_reg_range(0x312a, 0x312b),
+	regmap_reg_range(0x3136, 0x3139),
+	regmap_reg_range(0x313e, 0x313f),
+	regmap_reg_range(0x3400, 0x3401),
+	regmap_reg_range(0x3403, 0x3403),
+	regmap_reg_range(0x3410, 0x3417),
+	regmap_reg_range(0x3420, 0x3423),
+	regmap_reg_range(0x3500, 0x3507),
+	regmap_reg_range(0x3600, 0x3613),
+	regmap_reg_range(0x3800, 0x380f),
+	regmap_reg_range(0x3820, 0x3827),
+	regmap_reg_range(0x3830, 0x3837),
+	regmap_reg_range(0x3840, 0x384b),
+	regmap_reg_range(0x3900, 0x3907),
+	regmap_reg_range(0x3914, 0x391b),
+	regmap_reg_range(0x3920, 0x3920),
+	regmap_reg_range(0x3923, 0x3927),
+	regmap_reg_range(0x3a00, 0x3a03),
+	regmap_reg_range(0x3a04, 0x3a07),
+	regmap_reg_range(0x3b00, 0x3b01),
+	regmap_reg_range(0x3b04, 0x3b04),
+	regmap_reg_range(0x3c00, 0x3c05),
+	regmap_reg_range(0x3c08, 0x3c1b),
+
+	/* port 4 */
+	regmap_reg_range(0x4000, 0x4001),
+	regmap_reg_range(0x4013, 0x4013),
+	regmap_reg_range(0x4017, 0x4017),
+	regmap_reg_range(0x401b, 0x401b),
+	regmap_reg_range(0x401f, 0x4020),
+	regmap_reg_range(0x4030, 0x4030),
+	regmap_reg_range(0x4100, 0x4115),
+	regmap_reg_range(0x411a, 0x411f),
+	regmap_reg_range(0x4122, 0x4127),
+	regmap_reg_range(0x412a, 0x412b),
+	regmap_reg_range(0x4136, 0x4139),
+	regmap_reg_range(0x413e, 0x413f),
+	regmap_reg_range(0x4400, 0x4401),
+	regmap_reg_range(0x4403, 0x4403),
+	regmap_reg_range(0x4410, 0x4417),
+	regmap_reg_range(0x4420, 0x4423),
+	regmap_reg_range(0x4500, 0x4507),
+	regmap_reg_range(0x4600, 0x4613),
+	regmap_reg_range(0x4800, 0x480f),
+	regmap_reg_range(0x4820, 0x4827),
+	regmap_reg_range(0x4830, 0x4837),
+	regmap_reg_range(0x4840, 0x484b),
+	regmap_reg_range(0x4900, 0x4907),
+	regmap_reg_range(0x4914, 0x491b),
+	regmap_reg_range(0x4920, 0x4920),
+	regmap_reg_range(0x4923, 0x4927),
+	regmap_reg_range(0x4a00, 0x4a03),
+	regmap_reg_range(0x4a04, 0x4a07),
+	regmap_reg_range(0x4b00, 0x4b01),
+	regmap_reg_range(0x4b04, 0x4b04),
+	regmap_reg_range(0x4c00, 0x4c05),
+	regmap_reg_range(0x4c08, 0x4c1b),
+
+	/* port 5 */
+	regmap_reg_range(0x5000, 0x5001),
+	regmap_reg_range(0x5013, 0x5013),
+	regmap_reg_range(0x5017, 0x5017),
+	regmap_reg_range(0x501b, 0x501b),
+	regmap_reg_range(0x501f, 0x5020),
+	regmap_reg_range(0x5030, 0x5030),
+	regmap_reg_range(0x5100, 0x5115),
+	regmap_reg_range(0x511a, 0x511f),
+	regmap_reg_range(0x5122, 0x5127),
+	regmap_reg_range(0x512a, 0x512b),
+	regmap_reg_range(0x5136, 0x5139),
+	regmap_reg_range(0x513e, 0x513f),
+	regmap_reg_range(0x5400, 0x5401),
+	regmap_reg_range(0x5403, 0x5403),
+	regmap_reg_range(0x5410, 0x5417),
+	regmap_reg_range(0x5420, 0x5423),
+	regmap_reg_range(0x5500, 0x5507),
+	regmap_reg_range(0x5600, 0x5613),
+	regmap_reg_range(0x5800, 0x580f),
+	regmap_reg_range(0x5820, 0x5827),
+	regmap_reg_range(0x5830, 0x5837),
+	regmap_reg_range(0x5840, 0x584b),
+	regmap_reg_range(0x5900, 0x5907),
+	regmap_reg_range(0x5914, 0x591b),
+	regmap_reg_range(0x5920, 0x5920),
+	regmap_reg_range(0x5923, 0x5927),
+	regmap_reg_range(0x5a00, 0x5a03),
+	regmap_reg_range(0x5a04, 0x5a07),
+	regmap_reg_range(0x5b00, 0x5b01),
+	regmap_reg_range(0x5b04, 0x5b04),
+	regmap_reg_range(0x5c00, 0x5c05),
+	regmap_reg_range(0x5c08, 0x5c1b),
+
+	/* port 6 */
+	regmap_reg_range(0x6000, 0x6001),
+	regmap_reg_range(0x6013, 0x6013),
+	regmap_reg_range(0x6017, 0x6017),
+	regmap_reg_range(0x601b, 0x601b),
+	regmap_reg_range(0x601f, 0x6020),
+	regmap_reg_range(0x6030, 0x6030),
+	regmap_reg_range(0x6300, 0x6301),
+	regmap_reg_range(0x6400, 0x6401),
+	regmap_reg_range(0x6403, 0x6403),
+	regmap_reg_range(0x6410, 0x6417),
+	regmap_reg_range(0x6420, 0x6423),
+	regmap_reg_range(0x6500, 0x6507),
+	regmap_reg_range(0x6600, 0x6613),
+	regmap_reg_range(0x6800, 0x680f),
+	regmap_reg_range(0x6820, 0x6827),
+	regmap_reg_range(0x6830, 0x6837),
+	regmap_reg_range(0x6840, 0x684b),
+	regmap_reg_range(0x6900, 0x6907),
+	regmap_reg_range(0x6914, 0x691b),
+	regmap_reg_range(0x6920, 0x6920),
+	regmap_reg_range(0x6923, 0x6927),
+	regmap_reg_range(0x6a00, 0x6a03),
+	regmap_reg_range(0x6a04, 0x6a07),
+	regmap_reg_range(0x6b00, 0x6b01),
+	regmap_reg_range(0x6b04, 0x6b04),
+	regmap_reg_range(0x6c00, 0x6c05),
+	regmap_reg_range(0x6c08, 0x6c1b),
+
+	/* port 7 */
+	regmap_reg_range(0x7000, 0x7001),
+	regmap_reg_range(0x7013, 0x7013),
+	regmap_reg_range(0x7017, 0x7017),
+	regmap_reg_range(0x701b, 0x701b),
+	regmap_reg_range(0x701f, 0x7020),
+	regmap_reg_range(0x7030, 0x7030),
+	regmap_reg_range(0x7200, 0x7203),
+	regmap_reg_range(0x7206, 0x7207),
+	regmap_reg_range(0x7300, 0x7301),
+	regmap_reg_range(0x7400, 0x7401),
+	regmap_reg_range(0x7403, 0x7403),
+	regmap_reg_range(0x7410, 0x7417),
+	regmap_reg_range(0x7420, 0x7423),
+	regmap_reg_range(0x7500, 0x7507),
+	regmap_reg_range(0x7600, 0x7613),
+	regmap_reg_range(0x7800, 0x780f),
+	regmap_reg_range(0x7820, 0x7827),
+	regmap_reg_range(0x7830, 0x7837),
+	regmap_reg_range(0x7840, 0x784b),
+	regmap_reg_range(0x7900, 0x7907),
+	regmap_reg_range(0x7914, 0x791b),
+	regmap_reg_range(0x7920, 0x7920),
+	regmap_reg_range(0x7923, 0x7927),
+	regmap_reg_range(0x7a00, 0x7a03),
+	regmap_reg_range(0x7a04, 0x7a07),
+	regmap_reg_range(0x7b00, 0x7b01),
+	regmap_reg_range(0x7b04, 0x7b04),
+	regmap_reg_range(0x7c00, 0x7c05),
+	regmap_reg_range(0x7c08, 0x7c1b),
+};
+
+static const struct regmap_access_table ksz9477_register_set = {
+	.yes_ranges = ksz9477_valid_regs,
+	.n_yes_ranges = ARRAY_SIZE(ksz9477_valid_regs),
+};
+
 const struct ksz_chip_data ksz_switch_chips[] = {
 	[KSZ8563] = {
 		.chip_id = KSZ8563_CHIP_ID,
@@ -691,6 +961,8 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.internal_phy	= {true, true, true, true,
 				   true, false, false},
 		.gbit_capable	= {true, true, true, true, true, true, true},
+		.wr_table = &ksz9477_register_set,
+		.rd_table = &ksz9477_register_set,
 	},
 
 	[KSZ9897] = {
-- 
2.30.2

