Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EE169A421
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjBQDHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjBQDHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:07:24 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF8D53816
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=u9BZc7R2vRylOxJcR3s148QMA9AthrV+VZp7M8B/6iU=; b=x0iDZ5iTnt/r9lfAkBHPO8pADA
        4NTymCUwelv2Jfw0OXlJpweu4aO+mnKYqb+86Yzmxu//mMT6FfxciYnqyoqplOcnH/BukEHdd5I4T
        7drTY3ljV8nYjB+Ho8a2ja30gF9HmStuaCgkgaQu7s+B/Hn1l/7YnkAFeDdG2h9JgX4o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSr5k-005Evb-V6; Fri, 17 Feb 2023 04:07:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [=PATCH net-next 2/2] net: phy: Add locks to ethtool functions
Date:   Fri, 17 Feb 2023 04:07:14 +0100
Message-Id: <20230217030714.1249009-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230217030714.1249009-1-andrew@lunn.ch>
References: <20230217030714.1249009-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phydev lock should be held while accessing members of phydev,
or calling into the driver.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c | 84 +++++++++++++++++++++++++++++++++----------
 1 file changed, 66 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 2f1041a7211e..b33e55a7364e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1069,27 +1069,35 @@ EXPORT_SYMBOL(phy_ethtool_ksettings_set);
 int phy_speed_down(struct phy_device *phydev, bool sync)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_tmp);
-	int ret;
+	int ret = 0;
+
+	mutex_lock(&phydev->lock);
 
 	if (phydev->autoneg != AUTONEG_ENABLE)
-		return 0;
+		goto out;
 
 	linkmode_copy(adv_tmp, phydev->advertising);
 
 	ret = phy_speed_down_core(phydev);
 	if (ret)
-		return ret;
+		goto out;
 
 	linkmode_copy(phydev->adv_old, adv_tmp);
 
-	if (linkmode_equal(phydev->advertising, adv_tmp))
-		return 0;
+	if (linkmode_equal(phydev->advertising, adv_tmp)) {
+		ret = 0;
+		goto out;
+	}
 
 	ret = phy_config_aneg(phydev);
 	if (ret)
-		return ret;
+		goto out;
+
+	ret = sync ? phy_poll_aneg_done(phydev) : 0;
+out:
+	mutex_unlock(&phydev->lock);
 
-	return sync ? phy_poll_aneg_done(phydev) : 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(phy_speed_down);
 
@@ -1102,21 +1110,28 @@ EXPORT_SYMBOL_GPL(phy_speed_down);
 int phy_speed_up(struct phy_device *phydev)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_tmp);
+	int ret = 0;
+
+	mutex_lock(&phydev->lock);
 
 	if (phydev->autoneg != AUTONEG_ENABLE)
-		return 0;
+		goto out;
 
 	if (linkmode_empty(phydev->adv_old))
-		return 0;
+		goto out;
 
 	linkmode_copy(adv_tmp, phydev->advertising);
 	linkmode_copy(phydev->advertising, phydev->adv_old);
 	linkmode_zero(phydev->adv_old);
 
 	if (linkmode_equal(phydev->advertising, adv_tmp))
-		return 0;
+		goto out;
+
+	ret = phy_config_aneg(phydev);
+out:
+	mutex_unlock(&phydev->lock);
 
-	return phy_config_aneg(phydev);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(phy_speed_up);
 
@@ -1500,10 +1515,16 @@ EXPORT_SYMBOL(phy_init_eee);
  */
 int phy_get_eee_err(struct phy_device *phydev)
 {
+	int ret;
+
 	if (!phydev->drv)
 		return -EIO;
 
-	return phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_WK_ERR);
+	mutex_lock(&phydev->lock);
+	ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_PCS_EEE_WK_ERR);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(phy_get_eee_err);
 
@@ -1517,10 +1538,16 @@ EXPORT_SYMBOL(phy_get_eee_err);
  */
 int phy_ethtool_get_eee(struct phy_device *phydev, struct ethtool_eee *data)
 {
+	int ret;
+
 	if (!phydev->drv)
 		return -EIO;
 
-	return genphy_c45_ethtool_get_eee(phydev, data);
+	mutex_lock(&phydev->lock);
+	ret = genphy_c45_ethtool_get_eee(phydev, data);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(phy_ethtool_get_eee);
 
@@ -1533,10 +1560,16 @@ EXPORT_SYMBOL(phy_ethtool_get_eee);
  */
 int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
 {
+	int ret;
+
 	if (!phydev->drv)
 		return -EIO;
 
-	return genphy_c45_ethtool_set_eee(phydev, data);
+	mutex_lock(&phydev->lock);
+	ret = genphy_c45_ethtool_set_eee(phydev, data);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(phy_ethtool_set_eee);
 
@@ -1548,8 +1581,15 @@ EXPORT_SYMBOL(phy_ethtool_set_eee);
  */
 int phy_ethtool_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 {
-	if (phydev->drv && phydev->drv->set_wol)
-		return phydev->drv->set_wol(phydev, wol);
+	int ret;
+
+	if (phydev->drv && phydev->drv->set_wol) {
+		mutex_lock(&phydev->lock);
+		ret = phydev->drv->set_wol(phydev, wol);
+		mutex_unlock(&phydev->lock);
+
+		return ret;
+	}
 
 	return -EOPNOTSUPP;
 }
@@ -1563,8 +1603,11 @@ EXPORT_SYMBOL(phy_ethtool_set_wol);
  */
 void phy_ethtool_get_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
 {
-	if (phydev->drv && phydev->drv->get_wol)
+	if (phydev->drv && phydev->drv->get_wol) {
+		mutex_lock(&phydev->lock);
 		phydev->drv->get_wol(phydev, wol);
+		mutex_unlock(&phydev->lock);
+	}
 }
 EXPORT_SYMBOL(phy_ethtool_get_wol);
 
@@ -1601,6 +1644,7 @@ EXPORT_SYMBOL(phy_ethtool_set_link_ksettings);
 int phy_ethtool_nway_reset(struct net_device *ndev)
 {
 	struct phy_device *phydev = ndev->phydev;
+	int ret;
 
 	if (!phydev)
 		return -ENODEV;
@@ -1608,6 +1652,10 @@ int phy_ethtool_nway_reset(struct net_device *ndev)
 	if (!phydev->drv)
 		return -EIO;
 
-	return phy_restart_aneg(phydev);
+	mutex_lock(&phydev->lock);
+	ret = phy_restart_aneg(phydev);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
 }
 EXPORT_SYMBOL(phy_ethtool_nway_reset);
-- 
2.39.1

