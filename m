Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD765355E9A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 00:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344066AbhDFWMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 18:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344049AbhDFWMM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 18:12:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28172613CF;
        Tue,  6 Apr 2021 22:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617747123;
        bh=lDWVe8uJVyF4qQEWXYkk73NzJ4pq3P249B4bc1phhQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMO2rHYHpEj1DmLax3EJrwfQ2Ud4ghDF3q9x5B+y2z5lrOcCQXYdF1X6S2YHAmIQ9
         jWvdC3sjWV/YSfohQGpVBOmO89OVrKG9urj460CPseUYjfLqARU6AiCWIisodWhDtt
         Ce8LnRA/aQ6Mg3FjE/eo7rkFwByGTrpGmNjCGmzziGHwAqpPtRt9M9qRaajm3Ndn4Q
         MiGxrXfw1f4LC7i/u07/9aK8Ake4p2eGnf4tLvp5VFZfO7s5JZO/EWLNxZH1iMoc+h
         pafSSkSleex5y9j/a2SCLZ/PP6P6SHZNDJFNEmxwpKfFVLugqITNrfhK3JjPJdkzYa
         8+OdZim9Jv+EQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v3 11/18] net: phy: marvell10g: store temperature read method in chip strucutre
Date:   Wed,  7 Apr 2021 00:11:00 +0200
Message-Id: <20210406221107.1004-12-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210406221107.1004-1-kabel@kernel.org>
References: <20210406221107.1004-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a chip structure, we can store the temperature reading
method in this structure (OOP style).

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index e3ced38f40c9..a7c7c87201fa 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -112,6 +112,10 @@ struct mv3310_chip {
 	DECLARE_BITMAP(supported_interfaces, PHY_INTERFACE_MODE_MAX);
 	int (*get_mactype)(struct phy_device *phydev);
 	int (*init_interface)(struct phy_device *phydev, int mactype);
+
+#ifdef CONFIG_HWMON
+	int (*hwmon_read_temp_reg)(struct phy_device *phydev);
+#endif
 };
 
 struct mv3310_priv {
@@ -151,18 +155,11 @@ static int mv2110_hwmon_read_temp_reg(struct phy_device *phydev)
 	return phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_TEMP);
 }
 
-static int mv10g_hwmon_read_temp_reg(struct phy_device *phydev)
-{
-	if (phydev->drv->phy_id == MARVELL_PHY_ID_88X3310)
-		return mv3310_hwmon_read_temp_reg(phydev);
-	else /* MARVELL_PHY_ID_88E2110 */
-		return mv2110_hwmon_read_temp_reg(phydev);
-}
-
 static int mv3310_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 			     u32 attr, int channel, long *value)
 {
 	struct phy_device *phydev = dev_get_drvdata(dev);
+	const struct mv3310_chip *chip = to_mv3310_chip(phydev);
 	int temp;
 
 	if (type == hwmon_chip && attr == hwmon_chip_update_interval) {
@@ -171,7 +168,7 @@ static int mv3310_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 	}
 
 	if (type == hwmon_temp && attr == hwmon_temp_input) {
-		temp = mv10g_hwmon_read_temp_reg(phydev);
+		temp = chip->hwmon_read_temp_reg(phydev);
 		if (temp < 0)
 			return temp;
 
@@ -865,6 +862,10 @@ static const struct mv3310_chip mv3310_type = {
 				  PHY_INTERFACE_MODE_USXGMII),
 	.get_mactype = mv3310_get_mactype,
 	.init_interface = mv3310_init_interface,
+
+#ifdef CONFIG_HWMON
+	.hwmon_read_temp_reg = mv3310_hwmon_read_temp_reg,
+#endif
 };
 
 static const struct mv3310_chip mv2110_type = {
@@ -877,6 +878,10 @@ static const struct mv3310_chip mv2110_type = {
 				  PHY_INTERFACE_MODE_USXGMII),
 	.get_mactype = mv2110_get_mactype,
 	.init_interface = mv2110_init_interface,
+
+#ifdef CONFIG_HWMON
+	.hwmon_read_temp_reg = mv2110_hwmon_read_temp_reg,
+#endif
 };
 
 static struct phy_driver mv3310_drivers[] = {
-- 
2.26.2

