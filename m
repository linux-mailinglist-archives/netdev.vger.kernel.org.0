Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF243CFAC8
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239090AbhGTM4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbhGTMxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 08:53:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5D1C061766
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 06:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ec09Jidg1jiuOLaiBWQNooaDQnXhekF1Dr6sz8Ay3HI=; b=KPOCOTXC1WWMjdALmamMm1tisQ
        WFvFfhrU5Kt/dIEKe1huSge/LszkArURk1B8ko3qCzebwpI93aQwujT/4Mff9saGR+eSAzSjyeN+w
        emUoCAIHYQgR8fG7ZilixJeKVsKiz2hh0/SKDDyG7NfSRlGpMcueqrL8m7nouv8OYiM3PGB5pmqpC
        QPPo4JtE9insLvwJjUizVcnsQHJg2oRNiDk6gtuMzVd2HVatc2b0Lg2c4B7l717CVG62w7QibZxqU
        xqnyAL/3EqR0zolxP/GNN9dYu71SQL/tFll3YU/WJEXql14CLysbYhvp79Vyg6r5v3NDJU4iA5caH
        bdB3AsTQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54864 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m5psc-0006O0-5q; Tue, 20 Jul 2021 14:33:50 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m5psb-0003qh-VP; Tue, 20 Jul 2021 14:33:50 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phy: at803x: simplify custom phy id matching
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1m5psb-0003qh-VP@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 20 Jul 2021 14:33:49 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The at803x driver contains a function, at803x_match_phy_id(), which
tests whether the PHY ID matches the value passed, comparing phy_id
with phydev->phy_id and testing all bits that in the driver's mask.

This is the same test that is used to match the driver, with phy_id
replaced with the driver specified ID, phydev->drv->phy_id.

Hence, we already know the value of the bits being tested if we look
at phydev->drv->phy_id directly, and we do not require a complicated
test to check them. Test directly against phydev->drv->phy_id instead.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/at803x.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 5d62b85a4024..0790ffcd3db6 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -532,12 +532,6 @@ static int at8031_register_regulators(struct phy_device *phydev)
 	return 0;
 }
 
-static bool at803x_match_phy_id(struct phy_device *phydev, u32 phy_id)
-{
-	return (phydev->phy_id & phydev->drv->phy_id_mask)
-		== (phy_id & phydev->drv->phy_id_mask);
-}
-
 static int at803x_parse_dt(struct phy_device *phydev)
 {
 	struct device_node *node = phydev->mdio.dev.of_node;
@@ -602,8 +596,8 @@ static int at803x_parse_dt(struct phy_device *phydev)
 		 *   to the AR8030 so there might be a good chance it works on
 		 *   the AR8030 too.
 		 */
-		if (at803x_match_phy_id(phydev, ATH8030_PHY_ID) ||
-		    at803x_match_phy_id(phydev, ATH8035_PHY_ID)) {
+		if (phydev->drv->phy_id == ATH8030_PHY_ID ||
+		    phydev->drv->phy_id == ATH8035_PHY_ID) {
 			priv->clk_25m_reg &= AT8035_CLK_OUT_MASK;
 			priv->clk_25m_mask &= AT8035_CLK_OUT_MASK;
 		}
@@ -631,7 +625,7 @@ static int at803x_parse_dt(struct phy_device *phydev)
 	/* Only supported on AR8031/AR8033, the AR8030/AR8035 use strapping
 	 * options.
 	 */
-	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
+	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
 		if (of_property_read_bool(node, "qca,keep-pll-enabled"))
 			priv->flags |= AT803X_KEEP_PLL_ENABLED;
 
@@ -676,7 +670,7 @@ static int at803x_probe(struct phy_device *phydev)
 	 * Switch to the copper page, as otherwise we read
 	 * the PHY capabilities from the fiber side.
 	 */
-	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
+	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
 		phy_lock_mdio_bus(phydev);
 		ret = at803x_write_page(phydev, AT803X_PAGE_COPPER);
 		phy_unlock_mdio_bus(phydev);
@@ -820,7 +814,7 @@ static int at803x_config_init(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
+	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
 		ret = at8031_pll_config(phydev);
 		if (ret < 0)
 			return ret;
-- 
2.20.1

