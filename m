Return-Path: <netdev+bounces-4998-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B926770F679
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:32:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73BF0281420
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4CA15BC;
	Wed, 24 May 2023 12:32:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05F218AF3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:32:34 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4734FA3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:32:33 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ore@pengutronix.de>)
	id 1q1nfE-0006vr-2p; Wed, 24 May 2023 14:32:24 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1q1nfD-002TzG-12; Wed, 24 May 2023 14:32:23 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ore@pengutronix.de>)
	id 1q1nfB-00APaV-P3; Wed, 24 May 2023 14:32:21 +0200
From: Oleksij Rempel <o.rempel@pengutronix.de>
To: "David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>,
	kernel@pengutronix.de,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	"Russell King (Oracle)" <linux@armlinux.org.uk>
Subject: [PATCH net-next v1 5/5] net: dsa: microchip: Add register access control for KSZ8873 chip
Date: Wed, 24 May 2023 14:32:20 +0200
Message-Id: <20230524123220.2481565-6-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230524123220.2481565-1-o.rempel@pengutronix.de>
References: <20230524123220.2481565-1-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
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

This update introduces specific register access boundaries for the
KSZ8873 and KSZ8863 chips within the DSA Microchip driver. The outlined
ranges target global control registers, port registers, and advanced
control registers.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz_common.c | 41 ++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 53bb7d9712d0..768f649d2f40 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1075,6 +1075,45 @@ static const struct regmap_access_table ksz9896_register_set = {
 	.n_yes_ranges = ARRAY_SIZE(ksz9896_valid_regs),
 };
 
+static const struct regmap_range ksz8873_valid_regs[] = {
+	regmap_reg_range(0x00, 0x01),
+	/* global control register */
+	regmap_reg_range(0x02, 0x0f),
+
+	/* port registers */
+	regmap_reg_range(0x10, 0x1d),
+	regmap_reg_range(0x1e, 0x1f),
+	regmap_reg_range(0x20, 0x2d),
+	regmap_reg_range(0x2e, 0x2f),
+	regmap_reg_range(0x30, 0x39),
+	regmap_reg_range(0x3f, 0x3f),
+
+	/* advanced control registers */
+	regmap_reg_range(0x60, 0x6f),
+	regmap_reg_range(0x70, 0x75),
+	regmap_reg_range(0x76, 0x78),
+	regmap_reg_range(0x79, 0x7a),
+	regmap_reg_range(0x7b, 0x83),
+	regmap_reg_range(0x8e, 0x99),
+	regmap_reg_range(0x9a, 0xa5),
+	regmap_reg_range(0xa6, 0xa6),
+	regmap_reg_range(0xa7, 0xaa),
+	regmap_reg_range(0xab, 0xae),
+	regmap_reg_range(0xaf, 0xba),
+	regmap_reg_range(0xbb, 0xbc),
+	regmap_reg_range(0xbd, 0xbd),
+	regmap_reg_range(0xc0, 0xc0),
+	regmap_reg_range(0xc2, 0xc2),
+	regmap_reg_range(0xc3, 0xc3),
+	regmap_reg_range(0xc4, 0xc4),
+	regmap_reg_range(0xc6, 0xc6),
+};
+
+static const struct regmap_access_table ksz8873_register_set = {
+	.yes_ranges = ksz8873_valid_regs,
+	.n_yes_ranges = ARRAY_SIZE(ksz8873_valid_regs),
+};
+
 const struct ksz_chip_data ksz_switch_chips[] = {
 	[KSZ8563] = {
 		.chip_id = KSZ8563_CHIP_ID,
@@ -1214,6 +1253,8 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.supports_mii = {false, false, true},
 		.supports_rmii = {false, false, true},
 		.internal_phy = {true, true, false},
+		.wr_table = &ksz8873_register_set,
+		.rd_table = &ksz8873_register_set,
 	},
 
 	[KSZ9477] = {
-- 
2.39.2


