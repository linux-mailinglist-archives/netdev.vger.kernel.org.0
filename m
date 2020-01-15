Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B03BD13BAAC
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 09:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgAOIDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 03:03:20 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33731 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgAOIDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 03:03:20 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1irde2-0000YA-F3; Wed, 15 Jan 2020 09:03:18 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1irde2-0005Oy-2M; Wed, 15 Jan 2020 09:03:18 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kernel@pengutronix.de
Subject: [PATCH v3] net: phy: dp83867: Set FORCE_LINK_GOOD to default after reset
Date:   Wed, 15 Jan 2020 09:01:07 +0100
Message-Id: <20200115080105.15641-1-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <1871867b-717d-ba43-4a6e-1b469867b0aa@gmail.com>
References: <1871867b-717d-ba43-4a6e-1b469867b0aa@gmail.com>
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

 drivers/net/phy/dp83867.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index adda0d0eab800..967f57ed0b65e 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -99,6 +99,7 @@
 #define DP83867_PHYCR_TX_FIFO_DEPTH_MASK	GENMASK(15, 14)
 #define DP83867_PHYCR_RX_FIFO_DEPTH_MASK	GENMASK(13, 12)
 #define DP83867_PHYCR_RESERVED_MASK		BIT(11)
+#define DP83867_PHYCR_FORCE_LINK_GOOD		BIT(10)
 
 /* RGMIIDCTL bits */
 #define DP83867_RGMII_TX_CLK_DELAY_MAX		0xf
@@ -635,7 +636,12 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 
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

