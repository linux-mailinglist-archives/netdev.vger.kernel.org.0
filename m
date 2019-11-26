Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B71D110A00B
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 15:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbfKZOOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 09:14:20 -0500
Received: from mail.stusta.mhn.de ([141.84.69.5]:50846 "EHLO
        mail.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfKZOOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 09:14:20 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Nov 2019 09:14:19 EST
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.stusta.mhn.de (Postfix) with ESMTPSA id 47MlyQ46bLz4Y;
        Tue, 26 Nov 2019 15:04:30 +0100 (CET)
From:   Adrian Bunk <bunk@kernel.org>
To:     stable@vger.kernel.org, netdev@vger.kernel.org
Cc:     Max Uvarov <muvarov@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Adrian Bunk <bunk@kernel.org>
Subject: [4.14/4.19 patch 2/2] net: phy: dp83867: increase SGMII autoneg timer duration
Date:   Tue, 26 Nov 2019 16:04:06 +0200
Message-Id: <20191126140406.6451-2-bunk@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191126140406.6451-1-bunk@kernel.org>
References: <20191126140406.6451-1-bunk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Uvarov <muvarov@gmail.com>

Commit 1a97a477e666cbdededab93bd3754e508f0c09d7 upstream.

After reset SGMII Autoneg timer is set to 2us (bits 6 and 5 are 01).
That is not enough to finalize autonegatiation on some devices.
Increase this timer duration to maximum supported 16ms.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ adapted for kernels without phy_modify_mmd ]
Signed-off-by: Adrian Bunk <bunk@kernel.org>
---
- already in 5.3
- applies and builds against 4.14 and 4.19
- tested with 4.14
---
 drivers/net/phy/dp83867.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 81106314e6da..e03e91d5f1b1 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -33,6 +33,12 @@
 
 /* Extended Registers */
 #define DP83867_CFG4            0x0031
+#define DP83867_CFG4_SGMII_ANEG_MASK (BIT(5) | BIT(6))
+#define DP83867_CFG4_SGMII_ANEG_TIMER_11MS   (3 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_800US  (2 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    (1 << 5)
+#define DP83867_CFG4_SGMII_ANEG_TIMER_16MS   (0 << 5)
+
 #define DP83867_RGMIICTL	0x0032
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_RGMIIDCTL	0x0086
@@ -300,6 +306,18 @@ static int dp83867_config_init(struct phy_device *phydev)
 
 		if (ret)
 			return ret;
+
+		/* After reset SGMII Autoneg timer is set to 2us (bits 6 and 5
+		 * are 01). That is not enough to finalize autoneg on some
+		 * devices. Increase this timer duration to maximum 16ms.
+		 */
+		val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4);
+		val &= ~DP83867_CFG4_SGMII_ANEG_MASK;
+		val |= DP83867_CFG4_SGMII_ANEG_TIMER_16MS;
+		ret = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_CFG4, val);
+
+		if (ret)
+			return ret;
 	}
 
 	/* Enable Interrupt output INT_OE in CFG3 register */
-- 
2.20.1

