Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224E358504A
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236229AbiG2NEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236193AbiG2NEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:04:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68E646DB4
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 06:04:06 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oHPeh-0006nQ-9g; Fri, 29 Jul 2022 15:03:51 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oHPef-000Vue-Ro; Fri, 29 Jul 2022 15:03:49 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oHPed-00CQXh-Er; Fri, 29 Jul 2022 15:03:47 +0200
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
Subject: [PATCH net-next v1 01/10] net: dsa: microchip: don't announce extended register support on non Gbit chips
Date:   Fri, 29 Jul 2022 15:03:37 +0200
Message-Id: <20220729130346.2961889-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220729130346.2961889-1-o.rempel@pengutronix.de>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
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

This issue was detected after adding support of regmap_ranges for KSZ8563R
chip. This chip is reporting extended registers support without having
actual extended registers. This made PHYlib request not existing
registers.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/microchip/ksz9477.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index c108d5444695..841f0d2b15c9 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -264,6 +264,22 @@ void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	mutex_unlock(&mib->cnt_mutex);
 }
 
+
+static void ksz9477_r_phy_quirks(struct ksz_device *dev, u16 addr, u16 reg,
+				 u16 *data)
+{
+	/* KSZ8563R do not have extended registers but BMSR_ESTATEN and
+	 * BMSR_ERCAP bits are set.
+	 * Since all KSZ9893 compatible chips, do not support extended
+	 * registers, it should be save to apply this quirk on complete family.
+	 * It is not possible to integrate this code in the PHY driver, since
+	 * we can't use PHYid to distinguish Gbit capable KSZ9477 PHYs from
+	 * 100Mbit KSZ8563R PHYs.
+	 */
+	if (dev->chip_id == KSZ9893_CHIP_ID && reg == MII_BMSR)
+		*data &= ~(BMSR_ESTATEN | BMSR_ERCAP);
+}
+
 void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 {
 	u16 val = 0xffff;
@@ -308,6 +324,7 @@ void ksz9477_r_phy(struct ksz_device *dev, u16 addr, u16 reg, u16 *data)
 		}
 	} else {
 		ksz_pread16(dev, addr, 0x100 + (reg << 1), &val);
+		ksz9477_r_phy_quirks(dev, addr, reg, &val);
 	}
 
 	*data = val;
-- 
2.30.2

