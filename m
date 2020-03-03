Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7E1177B25
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 16:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbgCCPyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 10:54:24 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37786 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729940AbgCCPyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 10:54:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jcPHFinW+Mz6+m8eXwCKjTCrwR7E3viFAFIZCRxO+ks=; b=zpfDBuQdw0NfGEKvhfjoYLMfJ7
        HdaBaGfCOtf5D3aUywlquok0Q/DwkCTouown52fWclaXSd6gpFUmkXPhPFnwTr1M/AlnPLAk1FAX/
        RfeajfGooCkgZ+YlijQKldgk2emqTci5seKMJaEvRz0aExKJgKi4gGs3KftdqT7th0P6srCwqrXFe
        mo0qzHE51tTGZiGhHo/VHky2IDib4Qr+50hIxrLYlbjq6h8SaXJwtUnV1iTMVm7GVszd50+lYXyMx
        St2+Z9pcaPQ+LKarX/TpM+GXWy+pevwXon6dcVer6dLkrLnSiKvD1S/yeT8yM5yzmnoMBjn42Rm9r
        VYk6vUMw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42180 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j99s8-0000U8-8k; Tue, 03 Mar 2020 15:54:16 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j99s6-00011Y-UI; Tue, 03 Mar 2020 15:54:14 +0000
In-Reply-To: <20200303155347.GS25745@shell.armlinux.org.uk>
References: <20200303155347.GS25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/3] net: phy: marvell10g: add energy detect power
 down tunable
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j99s6-00011Y-UI@rmk-PC.armlinux.org.uk>
Date:   Tue, 03 Mar 2020 15:54:14 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the energy detect power down tunable, which saves
around 600mW when the link is down. The 88x3310 supports off, rx-only
and NLP every second. Enable EDPD by default for 88x3310.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c | 86 +++++++++++++++++++++++++++++++++++-
 1 file changed, 85 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 9d4fed782b19..148c07b59a9e 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -41,6 +41,10 @@ enum {
 	MV_PCS_1000BASEX	= 0x2000,
 
 	MV_PCS_CSCR1		= 0x8000,
+	MV_PCS_CSCR1_ED_MASK	= 0x0300,
+	MV_PCS_CSCR1_ED_OFF	= 0x0000,
+	MV_PCS_CSCR1_ED_RX	= 0x0200,
+	MV_PCS_CSCR1_ED_NLP	= 0x0300,
 	MV_PCS_CSCR1_MDIX_MASK	= 0x0060,
 	MV_PCS_CSCR1_MDIX_MDI	= 0x0000,
 	MV_PCS_CSCR1_MDIX_MDIX	= 0x0020,
@@ -243,6 +247,59 @@ static int mv3310_reset(struct phy_device *phydev, u32 unit)
 	return val & MDIO_CTRL1_RESET ? -ETIMEDOUT : 0;
 }
 
+static int mv3310_get_edpd(struct phy_device *phydev, u16 *edpd)
+{
+	int val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_CSCR1);
+	if (val < 0)
+		return val;
+
+	switch (val & MV_PCS_CSCR1_ED_MASK) {
+	case MV_PCS_CSCR1_ED_NLP:
+		*edpd = 1000;
+		break;
+	case MV_PCS_CSCR1_ED_RX:
+		*edpd = ETHTOOL_PHY_EDPD_NO_TX;
+		break;
+	default:
+		*edpd = ETHTOOL_PHY_EDPD_DISABLE;
+		break;
+	}
+	return 0;
+}
+
+static int mv3310_set_edpd(struct phy_device *phydev, u16 edpd)
+{
+	u16 val;
+	int err;
+
+	switch (edpd) {
+	case 1000:
+	case ETHTOOL_PHY_EDPD_DFLT_TX_MSECS:
+		val = MV_PCS_CSCR1_ED_NLP;
+		break;
+
+	case ETHTOOL_PHY_EDPD_NO_TX:
+		val = MV_PCS_CSCR1_ED_RX;
+		break;
+
+	case ETHTOOL_PHY_EDPD_DISABLE:
+		val = MV_PCS_CSCR1_ED_OFF;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	err = phy_modify_mmd_changed(phydev, MDIO_MMD_PCS, MV_PCS_CSCR1,
+				     MV_PCS_CSCR1_ED_MASK, val);
+	if (err > 0)
+		err = mv3310_reset(phydev, MV_PCS_BASE_T);
+
+	return err;
+}
+
 static int mv3310_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
 {
 	struct phy_device *phydev = upstream;
@@ -345,7 +402,8 @@ static int mv3310_config_init(struct phy_device *phydev)
 
 	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
 
-	return 0;
+	/* Enable EDPD mode - saving 600mW */
+	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
 }
 
 static int mv3310_get_features(struct phy_device *phydev)
@@ -594,6 +652,28 @@ static int mv3310_read_status(struct phy_device *phydev)
 	return 0;
 }
 
+static int mv3310_get_tunable(struct phy_device *phydev,
+			      struct ethtool_tunable *tuna, void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_EDPD:
+		return mv3310_get_edpd(phydev, data);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int mv3310_set_tunable(struct phy_device *phydev,
+			      struct ethtool_tunable *tuna, const void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_EDPD:
+		return mv3310_set_edpd(phydev, *(u16 *)data);
+	default:
+		return -EINVAL;
+	}
+}
+
 static struct phy_driver mv3310_drivers[] = {
 	{
 		.phy_id		= MARVELL_PHY_ID_88X3310,
@@ -608,6 +688,8 @@ static struct phy_driver mv3310_drivers[] = {
 		.config_aneg	= mv3310_config_aneg,
 		.aneg_done	= mv3310_aneg_done,
 		.read_status	= mv3310_read_status,
+		.get_tunable	= mv3310_get_tunable,
+		.set_tunable	= mv3310_set_tunable,
 	},
 	{
 		.phy_id		= MARVELL_PHY_ID_88E2110,
@@ -621,6 +703,8 @@ static struct phy_driver mv3310_drivers[] = {
 		.config_aneg	= mv3310_config_aneg,
 		.aneg_done	= mv3310_aneg_done,
 		.read_status	= mv3310_read_status,
+		.get_tunable	= mv3310_get_tunable,
+		.set_tunable	= mv3310_set_tunable,
 	},
 };
 
-- 
2.20.1

