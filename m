Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C56213AFBE
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgANQqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:46:01 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43825 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbgANQqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:46:00 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1irPKJ-0006qP-2x; Tue, 14 Jan 2020 17:45:59 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1irPKI-0003X0-Dg; Tue, 14 Jan 2020 17:45:58 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kernel@pengutronix.de
Subject: [PATCH v2] net: phy: dp83867: Set FORCE_LINK_GOOD to default after reset
Date:   Tue, 14 Jan 2020 17:45:53 +0100
Message-Id: <20200114164553.12997-1-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200114132502.GH11788@lunn.ch>
References: <20200114132502.GH11788@lunn.ch>
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

 drivers/net/phy/dp83867.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index adda0d0eab800..68855177d92cc 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -99,6 +99,7 @@
 #define DP83867_PHYCR_TX_FIFO_DEPTH_MASK	GENMASK(15, 14)
 #define DP83867_PHYCR_RX_FIFO_DEPTH_MASK	GENMASK(13, 12)
 #define DP83867_PHYCR_RESERVED_MASK		BIT(11)
+#define DP83867_PHYCR_FORCE_LINK_GOOD		BIT(10)
 
 /* RGMIIDCTL bits */
 #define DP83867_RGMII_TX_CLK_DELAY_MAX		0xf
@@ -635,6 +636,15 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 
 	usleep_range(10, 20);
 
+	/* After reset FORCE_LINK_GOOD bit is set. Although the
+	 * default value should be unset. Disable FORCE_LINK_GOOD
+	 * for the phy to work properly.
+	 */
+	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
+			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
+	if (err < 0)
+		return err;
+
 	return 0;
 }
 
-- 
2.25.0

