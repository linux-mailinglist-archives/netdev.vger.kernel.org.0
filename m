Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBECD10A009
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 15:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfKZOOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 09:14:20 -0500
Received: from mail.stusta.mhn.de ([141.84.69.5]:50850 "EHLO
        mail.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfKZOOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 09:14:20 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.stusta.mhn.de (Postfix) with ESMTPSA id 47MlyK1jz3z23;
        Tue, 26 Nov 2019 15:04:25 +0100 (CET)
From:   Adrian Bunk <bunk@kernel.org>
To:     stable@vger.kernel.org, netdev@vger.kernel.org
Cc:     Max Uvarov <muvarov@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Adrian Bunk <bunk@kernel.org>
Subject: [4.14/4.19 patch 1/2] net: phy: dp83867: fix speed 10 in sgmii mode
Date:   Tue, 26 Nov 2019 16:04:05 +0200
Message-Id: <20191126140406.6451-1-bunk@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Uvarov <muvarov@gmail.com>

Commit 333061b924539c0de081339643f45514f5f1c1e6 upstream.

For supporting 10Mps speed in SGMII mode DP83867_10M_SGMII_RATE_ADAPT bit
of DP83867_10M_SGMII_CFG register has to be cleared by software.
That does not affect speeds 100 and 1000 so can be done on init.

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
 drivers/net/phy/dp83867.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 12b09e6e03ba..81106314e6da 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -37,6 +37,8 @@
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_RGMIIDCTL	0x0086
 #define DP83867_IO_MUX_CFG	0x0170
+#define DP83867_10M_SGMII_CFG   0x016F
+#define DP83867_10M_SGMII_RATE_ADAPT_MASK BIT(7)
 
 #define DP83867_SW_RESET	BIT(15)
 #define DP83867_SW_RESTART	BIT(14)
@@ -283,6 +285,23 @@ static int dp83867_config_init(struct phy_device *phydev)
 		}
 	}
 
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		/* For support SPEED_10 in SGMII mode
+		 * DP83867_10M_SGMII_RATE_ADAPT bit
+		 * has to be cleared by software. That
+		 * does not affect SPEED_100 and
+		 * SPEED_1000.
+		 */
+		val = phy_read_mmd(phydev, DP83867_DEVADDR,
+				   DP83867_10M_SGMII_CFG);
+		val &= ~DP83867_10M_SGMII_RATE_ADAPT_MASK;
+		ret = phy_write_mmd(phydev, DP83867_DEVADDR,
+				    DP83867_10M_SGMII_CFG, val);
+
+		if (ret)
+			return ret;
+	}
+
 	/* Enable Interrupt output INT_OE in CFG3 register */
 	if (phy_interrupt_is_valid(phydev)) {
 		val = phy_read(phydev, DP83867_CFG3);
-- 
2.20.1

