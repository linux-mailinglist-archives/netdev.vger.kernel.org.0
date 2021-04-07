Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7723575DB
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356155AbhDGUYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:24:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356096AbhDGUX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 16:23:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 988D761184;
        Wed,  7 Apr 2021 20:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617827028;
        bh=FOaVm68ZK4mqgmMoYHfIPoz9Nz1NL1YF216t71VEz7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyLEQ+08nk8Z4hDKBJtlUgGrp6c0kU4l2yUogLbt9w2zXGdHR91PlTONxThHQgtyP
         gc8l4pY2vRMH9eXs2jZEKQrQQeq4P9Kn1dICNpbMStLuBVzutW8/LEwT0SNAyrq5cZ
         watOxl7HCTlhMYB9UsOIpqhgMz/79tJPnzHRZEvtgndhL7G4GItQYwV0lmIubBRb+m
         cVO6jfvJkbCLusPlz1QHM2+CZUb9Ii71RKWR67je5UhfUl2k6vAVds05K1DWTGSmQQ
         BCbSSi+1Uj2+Y9s1nxQNrygd45WHtYsQweYINyafxkQkKtH0QFLCsfZrerHOTU85Ag
         UewQlJFGM+7ag==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>, kuba@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v4 09/16] net: phy: marvell10g: store temperature read method in chip strucutre
Date:   Wed,  7 Apr 2021 22:22:47 +0200
Message-Id: <20210407202254.29417-10-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210407202254.29417-1-kabel@kernel.org>
References: <20210407202254.29417-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a chip structure, we can store the temperature reading
method in this structure (OOP style).

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/marvell10g.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index a7c6b1944b05..20d3e572c935 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -112,6 +112,10 @@ struct mv3310_chip {
 	void (*init_supported_interfaces)(unsigned long *mask);
 	int (*get_mactype)(struct phy_device *phydev);
 	int (*init_interface)(struct phy_device *phydev, int mactype);
+
+#ifdef CONFIG_HWMON
+	int (*hwmon_read_temp_reg)(struct phy_device *phydev);
+#endif
 };
 
 struct mv3310_priv {
@@ -152,18 +156,11 @@ static int mv2110_hwmon_read_temp_reg(struct phy_device *phydev)
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
@@ -172,7 +169,7 @@ static int mv3310_hwmon_read(struct device *dev, enum hwmon_sensor_types type,
 	}
 
 	if (type == hwmon_temp && attr == hwmon_temp_input) {
-		temp = mv10g_hwmon_read_temp_reg(phydev);
+		temp = chip->hwmon_read_temp_reg(phydev);
 		if (temp < 0)
 			return temp;
 
@@ -882,12 +879,20 @@ static const struct mv3310_chip mv3310_type = {
 	.init_supported_interfaces = mv3310_init_supported_interfaces,
 	.get_mactype = mv3310_get_mactype,
 	.init_interface = mv3310_init_interface,
+
+#ifdef CONFIG_HWMON
+	.hwmon_read_temp_reg = mv3310_hwmon_read_temp_reg,
+#endif
 };
 
 static const struct mv3310_chip mv2110_type = {
 	.init_supported_interfaces = mv2110_init_supported_interfaces,
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

