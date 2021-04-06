Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA1B355E9F
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344177AbhDFWMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243726AbhDFWMV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:12:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8B0E613DF;
        Tue,  6 Apr 2021 22:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747132;
        bh=WYleOevaHHI8e8w/cM4IhzUekfYlsL/IjsYmJuzRylM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMbXuocKQw1iyHsdW+39JBNMxe+vi7T9BFy+xLncrYfC8TAVFSeKo7TqM2v0RLG6k
         2VyGWeis7Aul8ygToJEj2p5IWcTX1yBzrKVQFkYx0COaperFuiBR93mWdI9n7ua5vN
         h4VZJaIdCY/bsYL5/HVT5dLUyYozcmEMeLul00sYsbBrwmYBzZL4M3pZABB3tWgNNS
         igP4hSdnWyzyLuUNKgfjmjQPb4TJtSqa3U5le6q/nCN44jcrW2e8ABysp9vS7vZmyh
         1fOM2eOIJWjd3X2MA9dcixXhwxPKZqrXXyL1qxj/qvrQKO7qnPIL1FvV07udbS+7kN
         kMW0toAZDOYyQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 16/18] net: phy: marvell10g: differentiate 88E2110 vs 88E2111
Date:   Wed,  7 Apr 2021 00:11:05 +0200
Message-Id: <20210406221107.1004-17-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406221107.1004-1-kabel@kernel.org>
References: <20210406221107.1004-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

88E2111 is a variant of 88E2110 which does not support 5 gigabit speeds.

Differentiate these variants via the match_phy_device() method, since
they have the same PHY ID.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 59 ++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 51b7a5083bdf..6269b9041180 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -934,6 +934,46 @@ static const struct mv3310_chip mv2110_type = {
 #endif
 };
 
+static const struct mv3310_chip mv2111_type = {
+	.supported_interfaces =
+		INITIALIZE_BITMAP(PHY_INTERFACE_MODE_MAX,
+				  PHY_INTERFACE_MODE_SGMII,
+				  PHY_INTERFACE_MODE_2500BASEX,
+				  PHY_INTERFACE_MODE_10GBASER,
+				  PHY_INTERFACE_MODE_USXGMII),
+	.get_mactype = mv2110_get_mactype,
+	.init_interface = mv2110_init_interface,
+
+#ifdef CONFIG_HWMON
+	.hwmon_read_temp_reg = mv2110_hwmon_read_temp_reg,
+#endif
+};
+
+static int mv211x_match_phy_device(struct phy_device *phydev, bool has_5g)
+{
+	int val;
+
+	if ((phydev->c45_ids.device_ids[MDIO_MMD_PMAPMD] &
+	     MARVELL_PHY_ID_MASK) != MARVELL_PHY_ID_88E2110)
+		return 0;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_SPEED);
+	if (val < 0)
+		return val;
+
+	return !!(val & MDIO_PCS_SPEED_5G) == has_5g;
+}
+
+static int mv2110_match_phy_device(struct phy_device *phydev)
+{
+	return mv211x_match_phy_device(phydev, true);
+}
+
+static int mv2111_match_phy_device(struct phy_device *phydev)
+{
+	return mv211x_match_phy_device(phydev, false);
+}
+
 static struct phy_driver mv3310_drivers[] = {
 	{
 		.phy_id		= MARVELL_PHY_ID_88X3310,
@@ -974,6 +1014,7 @@ static struct phy_driver mv3310_drivers[] = {
 	{
 		.phy_id		= MARVELL_PHY_ID_88E2110,
 		.phy_id_mask	= MARVELL_PHY_ID_MASK,
+		.match_phy_device = mv2110_match_phy_device,
 		.name		= "mv88e2110",
 		.driver_data	= &mv2110_type,
 		.probe		= mv3310_probe,
@@ -988,6 +1029,24 @@ static struct phy_driver mv3310_drivers[] = {
 		.remove		= mv3310_remove,
 		.set_loopback	= genphy_c45_loopback,
 	},
+	{
+		.phy_id		= MARVELL_PHY_ID_88E2110,
+		.phy_id_mask	= MARVELL_PHY_ID_MASK,
+		.match_phy_device = mv2111_match_phy_device,
+		.name		= "mv88e2111",
+		.driver_data	= &mv2111_type,
+		.probe		= mv3310_probe,
+		.suspend	= mv3310_suspend,
+		.resume		= mv3310_resume,
+		.config_init	= mv3310_config_init,
+		.config_aneg	= mv3310_config_aneg,
+		.aneg_done	= mv3310_aneg_done,
+		.read_status	= mv3310_read_status,
+		.get_tunable	= mv3310_get_tunable,
+		.set_tunable	= mv3310_set_tunable,
+		.remove		= mv3310_remove,
+		.set_loopback	= genphy_c45_loopback,
+	},
 };
 
 module_phy_driver(mv3310_drivers);
-- 
2.26.2

