Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC54BE5AE2
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfJZNSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:18:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727900AbfJZNSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:18:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2C1A21D7F;
        Sat, 26 Oct 2019 13:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095915;
        bh=p0U1Bm6GqTTZpOtW7ZNZSgiM9xHZLo7MuTpmRqE6vHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QL/jmIHxrK/X4UNEoh31kVAKQR7sym+060T/nBqB3hERvg0cmLwzorvlnlXehl4C
         EgClChVtTINMWapkkvr82AlRyTdS6QuD6mthsugv3gCX1VQoNLpSubaaujhYDDFgZX
         RMEWmWySuZ2rUg9l06r+pw29qgZbS4o1kqqa33lI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Nyekjaer <sean.nyekjaer@prevas.dk>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 87/99] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
Date:   Sat, 26 Oct 2019 09:15:48 -0400
Message-Id: <20191026131600.2507-87-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 8b95599c55ed24b36cf44a4720067cfe67edbcb4 ]

The KSZ8051 PHY and the KSZ8794/KSZ8795/KSZ8765 switch share exactly the
same PHY ID. Since KSZ8051 is higher in the ksphy_driver[] list of PHYs
in the micrel PHY driver, it is used even with the KSZ87xx switch. This
is wrong, since the KSZ8051 configures registers of the PHY which are
not present on the simplified KSZ87xx switch PHYs and misconfigures
other registers of the KSZ87xx switch PHYs.

Fortunatelly, it is possible to tell apart the KSZ8051 PHY from the
KSZ87xx switch by checking the Basic Status register Bit 0, which is
read-only and indicates presence of the Extended Capability Registers.
The KSZ8051 PHY has those registers while the KSZ87xx switch does not.

This patch implements simple check for the presence of this bit for
both the KSZ8051 PHY and KSZ87xx switch, to let both use the correct
PHY driver instance.

Fixes: 9d162ed69f51 ("net: phy: micrel: add support for KSZ8795")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Sean Nyekjaer <sean.nyekjaer@prevas.dk>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 2fea5541c35a8..a0444e28c6e7c 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -341,6 +341,35 @@ static int ksz8041_config_aneg(struct phy_device *phydev)
 	return genphy_config_aneg(phydev);
 }
 
+static int ksz8051_ksz8795_match_phy_device(struct phy_device *phydev,
+					    const u32 ksz_phy_id)
+{
+	int ret;
+
+	if ((phydev->phy_id & MICREL_PHY_ID_MASK) != ksz_phy_id)
+		return 0;
+
+	ret = phy_read(phydev, MII_BMSR);
+	if (ret < 0)
+		return ret;
+
+	/* KSZ8051 PHY and KSZ8794/KSZ8795/KSZ8765 switch share the same
+	 * exact PHY ID. However, they can be told apart by the extended
+	 * capability registers presence. The KSZ8051 PHY has them while
+	 * the switch does not.
+	 */
+	ret &= BMSR_ERCAP;
+	if (ksz_phy_id == PHY_ID_KSZ8051)
+		return ret;
+	else
+		return !ret;
+}
+
+static int ksz8051_match_phy_device(struct phy_device *phydev)
+{
+	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ8051);
+}
+
 static int ksz8081_config_init(struct phy_device *phydev)
 {
 	/* KSZPHY_OMSO_FACTORY_TEST is set at de-assertion of the reset line
@@ -364,6 +393,11 @@ static int ksz8061_config_init(struct phy_device *phydev)
 	return kszphy_config_init(phydev);
 }
 
+static int ksz8795_match_phy_device(struct phy_device *phydev)
+{
+	return ksz8051_ksz8795_match_phy_device(phydev, PHY_ID_KSZ8795);
+}
+
 static int ksz9021_load_values_from_of(struct phy_device *phydev,
 				       const struct device_node *of_node,
 				       u16 reg,
@@ -1017,8 +1051,6 @@ static struct phy_driver ksphy_driver[] = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	.phy_id		= PHY_ID_KSZ8051,
-	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Micrel KSZ8051",
 	/* PHY_BASIC_FEATURES */
 	.driver_data	= &ksz8051_type,
@@ -1029,6 +1061,7 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
+	.match_phy_device = ksz8051_match_phy_device,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
@@ -1141,13 +1174,12 @@ static struct phy_driver ksphy_driver[] = {
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-	.phy_id		= PHY_ID_KSZ8795,
-	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Micrel KSZ8795",
 	/* PHY_BASIC_FEATURES */
 	.config_init	= kszphy_config_init,
 	.config_aneg	= ksz8873mll_config_aneg,
 	.read_status	= ksz8873mll_read_status,
+	.match_phy_device = ksz8795_match_phy_device,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
 }, {
-- 
2.20.1

