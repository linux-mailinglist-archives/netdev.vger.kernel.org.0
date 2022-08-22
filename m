Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62B2C59BE22
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 13:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbiHVLEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 07:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbiHVLEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 07:04:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E98927B12
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 04:04:24 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ5Dw-0005PN-1N; Mon, 22 Aug 2022 13:04:04 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ5Du-001Hlt-RN; Mon, 22 Aug 2022 13:04:02 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oQ5Ds-009gyG-9u; Mon, 22 Aug 2022 13:04:00 +0200
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
Subject: [PATCH net-next v2 01/17] net: dsa: microchip: add separate struct ksz_chip_data for KSZ8563 chip
Date:   Mon, 22 Aug 2022 13:03:42 +0200
Message-Id: <20220822110358.2310055-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220822110358.2310055-1-o.rempel@pengutronix.de>
References: <20220822110358.2310055-1-o.rempel@pengutronix.de>
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

Add separate entry for the KSZ8563 chip. According to the documentation
it can support Gbit only on RGMII port. So, we will need to be able to
describe in the followup patch.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz_common.c | 39 ++++++++++++++++++++++++--
 drivers/net/dsa/microchip/ksz_common.h |  6 ++++
 drivers/net/dsa/microchip/ksz_spi.c    |  2 +-
 3 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index ed7d137cba994..170c05cc0687a 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -413,6 +413,29 @@ static const u8 lan937x_shifts[] = {
 };
 
 const struct ksz_chip_data ksz_switch_chips[] = {
+	[KSZ8563] = {
+		.chip_id = KSZ8563_CHIP_ID,
+		.dev_name = "KSZ8563",
+		.num_vlans = 4096,
+		.num_alus = 4096,
+		.num_statics = 16,
+		.cpu_ports = 0x07,	/* can be configured as cpu port */
+		.port_cnt = 3,		/* total port count */
+		.ops = &ksz9477_dev_ops,
+		.mib_names = ksz9477_mib_names,
+		.mib_cnt = ARRAY_SIZE(ksz9477_mib_names),
+		.reg_mib_cnt = MIB_COUNTER_NUM,
+		.regs = ksz9477_regs,
+		.masks = ksz9477_masks,
+		.shifts = ksz9477_shifts,
+		.xmii_ctrl0 = ksz9477_xmii_ctrl0,
+		.xmii_ctrl1 = ksz8795_xmii_ctrl1, /* Same as ksz8795 */
+		.supports_mii = {false, false, true},
+		.supports_rmii = {false, false, true},
+		.supports_rgmii = {false, false, true},
+		.internal_phy = {true, true, false},
+	},
+
 	[KSZ8795] = {
 		.chip_id = KSZ8795_CHIP_ID,
 		.dev_name = "KSZ8795",
@@ -1319,6 +1342,7 @@ static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 		proto = DSA_TAG_PROTO_KSZ8795;
 
 	if (dev->chip_id == KSZ8830_CHIP_ID ||
+	    dev->chip_id == KSZ8563_CHIP_ID ||
 	    dev->chip_id == KSZ9893_CHIP_ID)
 		proto = DSA_TAG_PROTO_KSZ9893;
 
@@ -1638,7 +1662,7 @@ static void ksz_phylink_mac_link_up(struct dsa_switch *ds, int port,
 
 static int ksz_switch_detect(struct ksz_device *dev)
 {
-	u8 id1, id2;
+	u8 id1, id2, id4;
 	u16 id16;
 	u32 id32;
 	int ret;
@@ -1684,7 +1708,6 @@ static int ksz_switch_detect(struct ksz_device *dev)
 		switch (id32) {
 		case KSZ9477_CHIP_ID:
 		case KSZ9897_CHIP_ID:
-		case KSZ9893_CHIP_ID:
 		case KSZ9567_CHIP_ID:
 		case LAN9370_CHIP_ID:
 		case LAN9371_CHIP_ID:
@@ -1692,6 +1715,18 @@ static int ksz_switch_detect(struct ksz_device *dev)
 		case LAN9373_CHIP_ID:
 		case LAN9374_CHIP_ID:
 			dev->chip_id = id32;
+			break;
+		case KSZ9893_CHIP_ID:
+			ret = ksz_read8(dev, REG_CHIP_ID4,
+					&id4);
+			if (ret)
+				return ret;
+
+			if (id4 == SKU_ID_KSZ8563)
+				dev->chip_id = KSZ8563_CHIP_ID;
+			else
+				dev->chip_id = KSZ9893_CHIP_ID;
+
 			break;
 		default:
 			dev_err(dev->dev,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 764ada3a0f42a..2b3877d4ef46f 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -123,6 +123,7 @@ struct ksz_device {
 
 /* List of supported models */
 enum ksz_model {
+	KSZ8563,
 	KSZ8795,
 	KSZ8794,
 	KSZ8765,
@@ -139,6 +140,7 @@ enum ksz_model {
 };
 
 enum ksz_chip_id {
+	KSZ8563_CHIP_ID = 0x8563,
 	KSZ8795_CHIP_ID = 0x8795,
 	KSZ8794_CHIP_ID = 0x8794,
 	KSZ8765_CHIP_ID = 0x8765,
@@ -482,6 +484,10 @@ static inline int is_lan937x(struct ksz_device *dev)
 
 #define SW_REV_ID_M			GENMASK(7, 4)
 
+/* KSZ9893, KSZ9563, KSZ8563 specific register  */
+#define REG_CHIP_ID4			0x0f
+#define SKU_ID_KSZ8563			0x3c
+
 /* Driver set switch broadcast storm protection at 10% rate. */
 #define BROADCAST_STORM_PROT_RATE	10
 
diff --git a/drivers/net/dsa/microchip/ksz_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
index 05bd089795f83..746b725b09ec4 100644
--- a/drivers/net/dsa/microchip/ksz_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -160,7 +160,7 @@ static const struct of_device_id ksz_dt_ids[] = {
 	},
 	{
 		.compatible = "microchip,ksz8563",
-		.data = &ksz_switch_chips[KSZ9893]
+		.data = &ksz_switch_chips[KSZ8563]
 	},
 	{
 		.compatible = "microchip,ksz9567",
-- 
2.30.2

