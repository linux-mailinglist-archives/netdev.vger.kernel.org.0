Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB745119BA0
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbfLJWKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:10:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728605AbfLJWEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 17:04:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B88062053B;
        Tue, 10 Dec 2019 22:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015452;
        bh=C4iqK5lGqkGKIphoCmrLRwzWutfxjbIEpyXJyE2sRuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2WFckODDlszZu7l3Q4q3Az92lj0W1ojz1hGVBtfy5Mf8dk63+NGydnezcnVPBq5y
         44giKnLOZRAXkpdjUdnnniVU7thqluweff5d7c+ZfIatb4Q7cvtmUYVByi4ROVJAvE
         hc+zeWniLbdlDG+M4Eh7BMTca1tBcQ0NG6sfxxeg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 059/130] net: phy: dp83867: enable robust auto-mdix
Date:   Tue, 10 Dec 2019 17:01:50 -0500
Message-Id: <20191210220301.13262-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 5a7f08c2abb0efc9d17aff2fc75d6d3b85e622e4 ]

The link detection timeouts can be observed (or link might not be detected
at all) when dp83867 PHY is configured in manual mode (speed/duplex).

CFG3[9] Robust Auto-MDIX option allows to significantly improve link detection
in case dp83867 is configured in manual mode and reduce link detection
time.
As per DM: "If link partners are configured to operational modes that are
not supported by normal Auto MDI/MDIX mode (like Auto-Neg versus Force
100Base-TX or Force 100Base-TX versus Force 100Base-TX), this Robust Auto
MDI/MDIX mode allows MDI/MDIX resolution and prevents deadlock."

Hence, enable this option by default as there are no known reasons
not to do so.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83867.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index e03e91d5f1b1b..0cbcced0870e6 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -84,6 +84,10 @@
 #define DP83867_IO_MUX_CFG_IO_IMPEDANCE_MAX	0x0
 #define DP83867_IO_MUX_CFG_IO_IMPEDANCE_MIN	0x1f
 
+/* CFG3 bits */
+#define DP83867_CFG3_INT_OE			BIT(7)
+#define DP83867_CFG3_ROBUST_AUTO_MDIX		BIT(9)
+
 /* CFG4 bits */
 #define DP83867_CFG4_PORT_MIRROR_EN              BIT(0)
 
@@ -320,12 +324,13 @@ static int dp83867_config_init(struct phy_device *phydev)
 			return ret;
 	}
 
+	val = phy_read(phydev, DP83867_CFG3);
 	/* Enable Interrupt output INT_OE in CFG3 register */
-	if (phy_interrupt_is_valid(phydev)) {
-		val = phy_read(phydev, DP83867_CFG3);
-		val |= BIT(7);
-		phy_write(phydev, DP83867_CFG3, val);
-	}
+	if (phy_interrupt_is_valid(phydev))
+		val |= DP83867_CFG3_INT_OE;
+
+	val |= DP83867_CFG3_ROBUST_AUTO_MDIX;
+	phy_write(phydev, DP83867_CFG3, val);
 
 	if (dp83867->port_mirroring != DP83867_PORT_MIRROING_KEEP)
 		dp83867_config_port_mirroring(phydev);
-- 
2.20.1

