Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B243575E2
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356172AbhDGUZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356126AbhDGUYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:24:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6602C6120E;
        Wed,  7 Apr 2021 20:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827036;
        bh=OWgKSxpXldxyWVKEkM2CzIG2eKsKcCEDcwM5aQC46DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bu/fDUBVYa3RhuQV5evGv1YSTTNjabqOL69PQJPCO4y8q3JgR6MmSC6sii4KQYrGn
         vE7zsmApO/8XgybFALeDmY2nxNxJbgyjX2Mcr7uVguLC6rf/z3CZ10BAvBqSY1kWnv
         5vrd1/2cFhnUDt7Ph71kh6GOV6FgUFOSWekVJuzZg2yXCR/rJv8fl2OdWVkctNJ1rI
         zc1GvmQqJd/lp3dlOVB0RIrPKcI0Mg6MW7Yhx9WMOwHiRQZIZk515QicP9XLPzCLBl
         h3cwzyZtOjMMSzsOi2ycr2Xa1qTQLKWTYpnAwKxKTHAQO6T+WzkA2rC8dWGBl3fS8b
         nDcMoYUDUY2Bg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 14/16] net: phy: marvell10g: differentiate 88E2110 vs 88E2111
Date:   Wed,  7 Apr 2021 22:22:52 +0200
Message-Id: <20210407202254.29417-15-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
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
 drivers/net/phy/marvell10g.c | 62 ++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 3c99757f0306..fcf4db4e5665 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -918,6 +918,14 @@ static void mv2110_init_supported_interfaces(unsigned long *mask)
 	__set_bit(PHY_INTERFACE_MODE_USXGMII, mask);
 }
 
+static void mv2111_init_supported_interfaces(unsigned long *mask)
+{
+	__set_bit(PHY_INTERFACE_MODE_SGMII, mask);
+	__set_bit(PHY_INTERFACE_MODE_2500BASEX, mask);
+	__set_bit(PHY_INTERFACE_MODE_10GBASER, mask);
+	__set_bit(PHY_INTERFACE_MODE_USXGMII, mask);
+}
+
 static const struct mv3310_chip mv3310_type = {
 	.init_supported_interfaces = mv3310_init_supported_interfaces,
 	.get_mactype = mv3310_get_mactype,
@@ -948,6 +956,41 @@ static const struct mv3310_chip mv2110_type = {
 #endif
 };
 
+static const struct mv3310_chip mv2111_type = {
+	.init_supported_interfaces = mv2111_init_supported_interfaces,
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
@@ -988,6 +1031,7 @@ static struct phy_driver mv3310_drivers[] = {
 	{
 		.phy_id		= MARVELL_PHY_ID_88E2110,
 		.phy_id_mask	= MARVELL_PHY_ID_MASK,
+		.match_phy_device = mv2110_match_phy_device,
 		.name		= "mv88e2110",
 		.driver_data	= &mv2110_type,
 		.probe		= mv3310_probe,
@@ -1002,6 +1046,24 @@ static struct phy_driver mv3310_drivers[] = {
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

