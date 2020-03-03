Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3AA177965
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgCCOoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:44:06 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36660 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbgCCOoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 09:44:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TIYjpLgBwVg8aHVGNf6RLTfOIZHr7Pv/DiqdDYbKrXs=; b=AfHRSNI5lHurYAUHzKGDNiSC2/
        3wxo0f7oa5Kla3cdeTFPM/37c+/7zQPuQ432YUsW3+uHYwUZxus5IQkIz6fhS1Tk5IY+Gy2crW2cx
        RylqXkqR3IPZqRQqm8e1IMW3yYuGZsU6jbZu22rrifPzo7nE6Z8rmTzl6jD3ji0Pu6yV9sjbBCDbX
        6V5FSyqR8N2K3uMAXJI6nLM8xUmgX/m/YfKrpTkOpd9NWVR6E9YSQuc2PrAIv81JsIhpnUsEAyvpE
        mI8PUnJgARVGsexwQQfJBub4Obq/MO98VdMQA5T/HwsQlpvRIozgtNYPdASszDez/xPie/eacjxp7
        e9xK+DyA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42068 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j98m6-00006a-BK; Tue, 03 Mar 2020 14:43:58 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j98m5-00057k-Q6; Tue, 03 Mar 2020 14:43:57 +0000
In-Reply-To: <20200303144259.GM25745@shell.armlinux.org.uk>
References: <20200303144259.GM25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net: phy: marvell10g: add mdix control
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j98m5-00057k-Q6@rmk-PC.armlinux.org.uk>
Date:   Tue, 03 Mar 2020 14:43:57 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for controlling the MDI-X state of the PHY.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c | 40 ++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 9a4e12a2af07..20b24b1971a3 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -39,6 +39,12 @@ enum {
 	MV_PCS_BASE_R		= 0x1000,
 	MV_PCS_1000BASEX	= 0x2000,
 
+	MV_PCS_CSCR1		= 0x8000,
+	MV_PCS_CSCR1_MDIX_MASK	= 0x0060,
+	MV_PCS_CSCR1_MDIX_MDI	= 0x0000,
+	MV_PCS_CSCR1_MDIX_MDIX	= 0x0020,
+	MV_PCS_CSCR1_MDIX_AUTO	= 0x0060,
+
 	MV_PCS_CSSR1		= 0x8008,
 	MV_PCS_CSSR1_SPD1_MASK	= 0xc000,
 	MV_PCS_CSSR1_SPD1_SPD2	= 0xc000,
@@ -316,6 +322,8 @@ static int mv3310_config_init(struct phy_device *phydev)
 	    phydev->interface != PHY_INTERFACE_MODE_10GBASER)
 		return -ENODEV;
 
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+
 	return 0;
 }
 
@@ -345,14 +353,42 @@ static int mv3310_get_features(struct phy_device *phydev)
 	return 0;
 }
 
+static int mv3310_config_mdix(struct phy_device *phydev)
+{
+	u16 val;
+	int err;
+
+	switch (phydev->mdix_ctrl) {
+	case ETH_TP_MDI_AUTO:
+		val = MV_PCS_CSCR1_MDIX_AUTO;
+		break;
+	case ETH_TP_MDI_X:
+		val = MV_PCS_CSCR1_MDIX_MDIX;
+		break;
+	case ETH_TP_MDI:
+		val = MV_PCS_CSCR1_MDIX_MDI;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	err = phy_modify_mmd_changed(phydev, MDIO_MMD_PCS, MV_PCS_CSCR1,
+				     MV_PCS_CSCR1_MDIX_MASK, val);
+	if (err < 0)
+		return err;
+
+	return mv3310_maybe_reset(phydev, MV_PCS_BASE_T, err > 0);
+}
+
 static int mv3310_config_aneg(struct phy_device *phydev)
 {
 	bool changed = false;
 	u16 reg;
 	int ret;
 
-	/* We don't support manual MDI control */
-	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+	ret = mv3310_config_mdix(phydev);
+	if (ret < 0)
+		return ret;
 
 	if (phydev->autoneg == AUTONEG_DISABLE)
 		return genphy_c45_pma_setup_forced(phydev);
-- 
2.20.1

