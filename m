Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6EB35A9B
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 12:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfFEKnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 06:43:24 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:54852 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbfFEKnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 06:43:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aF1gTpTUT+VRQ8m874B34AeddEGNehBbH4U/J95Rm1c=; b=SOh74irBXMsBr2b45M0KKglFSZ
        nhwHfACK/GOam1RuSLAw80TrSJ8kis4WqnBr0s+MJtC6DjcPeLCqM5GXHYAq7kwVCZmqhW3G9+qij
        XYOJXpo3uW2kSkDtRbspIwiTnOLDkMpT/YjZdoPkkPxEUU8G8a+79eF13RAKHUcm+AINYy2oO5bM8
        EswfHk14Lgrfu8svrkwANibHGaAn9hFdIIT3wTVabCAmz9b6xoOYKRCVFBY4+Z7ZCaYSwdJGXjr6c
        cTptoW/9VOOIs/fxIT+ieRarDs/iA7XJLl7kKaiBTkcedLhFAAXf0FBGcF2jhxm/kVc5mca1S25v7
        LGHl33HQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57134 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hYTO0-0007H4-JW; Wed, 05 Jun 2019 11:43:16 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1hYTO0-0000MZ-2d; Wed, 05 Jun 2019 11:43:16 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH] net: phy: marvell10g: allow PHY to probe without firmware
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
Date:   Wed, 05 Jun 2019 11:43:16 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the PHY to probe when there is no firmware, but do not allow the
link to come up by forcing the PHY state to PHY_HALTED in a similar way
to phy_error().

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
Depends on "net: phy: marvell10g: report if the PHY fails to boot firmware"

 drivers/net/phy/marvell10g.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 754cde873dde..86333d98b384 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -60,6 +60,8 @@ enum {
 };
 
 struct mv3310_priv {
+	bool firmware_failed;
+
 	struct device *hwmon_dev;
 	char *hwmon_name;
 };
@@ -214,6 +216,10 @@ static int mv3310_probe(struct phy_device *phydev)
 	    (phydev->c45_ids.devices_in_package & mmd_mask) != mmd_mask)
 		return -ENODEV;
 
+	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
 	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_BOOT);
 	if (ret < 0)
 		return ret;
@@ -221,13 +227,9 @@ static int mv3310_probe(struct phy_device *phydev)
 	if (ret & MV_PMA_BOOT_FATAL) {
 		dev_warn(&phydev->mdio.dev,
 			 "PHY failed to boot firmware, status=%04x\n", ret);
-		return -ENODEV;
+		priv->firmware_failed = true;
 	}
 
-	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
 	dev_set_drvdata(&phydev->mdio.dev, priv);
 
 	ret = mv3310_hwmon_probe(phydev);
@@ -247,6 +249,19 @@ static int mv3310_resume(struct phy_device *phydev)
 	return mv3310_hwmon_config(phydev, true);
 }
 
+static void mv3310_link_change_notify(struct phy_device *phydev)
+{
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+	enum phy_state state = phydev->state;
+
+	if (priv->firmware_failed &&
+	    (state == PHY_UP || state == PHY_RESUMING)) {
+		dev_warn(&phydev->mdio.dev,
+			 "PHY firmware failure: link forced down");
+		phydev->state = PHY_HALTED;
+	}
+}
+
 /* Some PHYs in the Alaska family such as the 88X3310 and the 88E2010
  * don't set bit 14 in PMA Extended Abilities (1.11), although they do
  * support 2.5GBASET and 5GBASET. For these models, we can still read their
-- 
2.7.4

