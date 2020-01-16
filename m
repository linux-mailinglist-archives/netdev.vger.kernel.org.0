Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5B513DB46
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgAPNQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:16:47 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57407 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgAPNQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:16:46 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1is50v-0001BV-1L; Thu, 16 Jan 2020 14:16:45 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1is50u-0004nD-G7; Thu, 16 Jan 2020 14:16:44 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kernel@pengutronix.de
Subject: [PATCH v4] net: phy: dp83867: Set FORCE_LINK_GOOD to default after reset
Date:   Thu, 16 Jan 2020 14:16:31 +0100
Message-Id: <20200116131631.31724-1-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116.045753.1672747031363850521.davem@davemloft.net>
References: <20200116.045753.1672747031363850521.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the Datasheet this bit should be 0 (Normal operation) in
default. With the FORCE_LINK_GOOD bit set, it is not possible to get a
link. This patch sets FORCE_LINK_GOOD to the default value after
resetting the phy.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
v1 -> v2: - fixed typo in subject line
	  - used phy_modify instead of read/write
v2 -> v3: - returned dp83867_phy_reset with phy_modify call
v3 -> v4: - rebased to net branch

 drivers/net/phy/dp83867.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 9cd9dcee4eb2e..01cf71358359a 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -97,6 +97,7 @@
 #define DP83867_PHYCR_FIFO_DEPTH_MAX		0x03
 #define DP83867_PHYCR_FIFO_DEPTH_MASK		GENMASK(15, 14)
 #define DP83867_PHYCR_RESERVED_MASK		BIT(11)
+#define DP83867_PHYCR_FORCE_LINK_GOOD		BIT(10)
 
 /* RGMIIDCTL bits */
 #define DP83867_RGMII_TX_CLK_DELAY_MAX		0xf
@@ -599,7 +600,12 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 
 	usleep_range(10, 20);
 
-	return 0;
+	/* After reset FORCE_LINK_GOOD bit is set. Although the
+	 * default value should be unset. Disable FORCE_LINK_GOOD
+	 * for the phy to work properly.
+	 */
+	return phy_modify(phydev, MII_DP83867_PHYCTRL,
+			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
 }
 
 static struct phy_driver dp83867_driver[] = {
-- 
2.25.0

