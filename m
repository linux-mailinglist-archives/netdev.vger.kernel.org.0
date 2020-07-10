Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FC821B4BB
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgGJMJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgGJMJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:09:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2558FC08C5DD
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 05:09:08 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jtrpu-00080b-8F; Fri, 10 Jul 2020 14:09:02 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jtrpq-0007Yn-N7; Fri, 10 Jul 2020 14:08:58 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH net-next v1 2/5] net: phy: micrel: apply resume errata workaround for ksz8873 and ksz8863
Date:   Fri, 10 Jul 2020 14:08:48 +0200
Message-Id: <20200710120851.28984-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200710120851.28984-1-o.rempel@pengutronix.de>
References: <20200710120851.28984-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
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
index caf56b9b51db..12106fbea565 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1010,6 +1010,26 @@ static int ksz8873mll_config_aneg(struct phy_device *phydev)
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
@@ -1347,7 +1367,7 @@ static struct phy_driver ksphy_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
 	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.resume		= ksz886x_resume,
 }, {
 	.name		= "Micrel KSZ87XX Switch",
 	/* PHY_BASIC_FEATURES */
-- 
2.27.0

