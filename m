Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776D1390F91
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 06:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhEZEck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 00:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhEZEcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 00:32:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64022C06138C
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 21:30:52 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBo-0001Ou-Ba; Wed, 26 May 2021 06:30:40 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lllBm-0002cO-K8; Wed, 26 May 2021 06:30:38 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: [PATCH net-next v3 4/9] net: phy: micrel: apply resume errata workaround for ksz8873 and ksz8863
Date:   Wed, 26 May 2021 06:30:32 +0200
Message-Id: <20210526043037.9830-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210526043037.9830-1-o.rempel@pengutronix.de>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ksz8873 and ksz8863 switches are affected by following errata:

| "Receiver error in 100BASE-TX mode following Soft Power Down"
|
| Some KSZ8873 devices may exhibit receiver errors after transitioning
| from Soft Power Down mode to Normal mode, as controlled by register 195
| (0xC3) bits [1:0]. When exiting Soft Power Down mode, the receiver
| blocks may not start up properly, causing the PHY to miss data and
| exhibit erratic behavior. The problem may appear on either port 1 or
| port 2, or both ports. The problem occurs only for 100BASE-TX, not
| 10BASE-T.
|
| END USER IMPLICATIONS
| When the failure occurs, the following symptoms are seen on the affected
| port(s):
| - The port is able to link
| - LED0 blinks, even when there is no traffic
| - The MIB counters indicate receive errors (Rx Fragments, Rx Symbol
|   Errors, Rx CRC Errors, Rx Alignment Errors)
| - Only a small fraction of packets is correctly received and forwarded
|   through the switch. Most packets are dropped due to receive errors.
|
| The failing condition cannot be corrected by the following:
| - Removing and reconnecting the cable
| - Hardware reset
| - Software Reset and PCS Reset bits in register 67 (0x43)
|
| Work around:
| The problem can be corrected by setting and then clearing the Port Power
| Down bits (registers 29 (0x1D) and 45 (0x2D), bit 3). This must be done
| separately for each affected port after returning from Soft Power Down
| Mode to Normal Mode. The following procedure will ensure no further
| issues due to this erratum. To enter Soft Power Down Mode, set register
| 195 (0xC3), bits [1:0] = 10.
|
| To exit Soft Power Down Mode, follow these steps:
| 1. Set register 195 (0xC3), bits [1:0] = 00 // Exit soft power down mode
| 2. Wait 1ms minimum
| 3. Set register 29 (0x1D), bit [3] = 1 // Enter PHY port 1 power down mode
| 4. Set register 29 (0x1D), bit [3] = 0 // Exit PHY port 1 power down mode
| 5. Set register 45 (0x2D), bit [3] = 1 // Enter PHY port 2 power down mode
| 6. Set register 45 (0x2D), bit [3] = 0 // Exit PHY port 2 power down mode

This patch implements steps 2...6 of the suggested workaround. The first
step needs to be implemented in the switch driver.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/micrel.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 227d88db7d27..f03188ed953a 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1048,6 +1048,26 @@ static int ksz8873mll_config_aneg(struct phy_device *phydev)
 	return 0;
 }
 
+static int ksz886x_resume(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Apply errata workaround for KSZ8863 and KSZ8873:
+	 * Receiver error in 100BASE-TX mode following Soft Power Down
+	 *
+	 * When exiting Soft Power Down mode, the receiver blocks may not start
+	 * up properly, causing the PHY to miss data and exhibit erratic
+	 * behavior.
+	 */
+	usleep_range(1000, 2000);
+
+	ret = phy_set_bits(phydev, MII_BMCR, BMCR_PDOWN);
+	if (ret)
+		return ret;
+
+	return phy_clear_bits(phydev, MII_BMCR, BMCR_PDOWN);
+}
+
 static int kszphy_get_sset_count(struct phy_device *phydev)
 {
 	return ARRAY_SIZE(kszphy_hw_stats);
@@ -1401,7 +1421,7 @@ static struct phy_driver ksphy_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
 	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.resume		= ksz886x_resume,
 }, {
 	.name		= "Micrel KSZ87XX Switch",
 	/* PHY_BASIC_FEATURES */
-- 
2.29.2

