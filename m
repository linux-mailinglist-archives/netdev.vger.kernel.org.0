Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B103CFAD9
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238668AbhGTM6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238537AbhGTM6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 08:58:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B7CC0613E6
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 06:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=txqkTkky14UZ36dFgLUkCv1j5UptSUdb0IGyOcAYa8c=; b=vUf8xOyh7REt2B93c5r+Tr4oX6
        ofz8B8PaEg9i1ovEecAvfesW24RKBQIcS3Y/paym5Z9M4Azu2UXt0wjN1Aj/4tn7puz1IcC554RUv
        yWw5rNdi4f4XNFrI+X4X654F6O8O2hv/S5ZBLSw7qMpa6Lu+gS5FA+HeUxIZLIXO+HboiBGO2wlDI
        H6ab/ST6l8A/JAcr2HLx2K0o56u7HxAsy6PKHvoMQdwZKIHrODjlG8SAUq+/oPUE5n64FAMjyT3kU
        Qc35xLeq/Rl1NrT0ekTnX7PErGR1zFW42HFtJ0HjZMJ1VgkSr/WPcWwcoY7YRbEywW0NlEr8xiSfB
        eMb/YMow==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54890 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m5pwz-0006OS-0o; Tue, 20 Jul 2021 14:38:21 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m5pwy-0003uX-Pf; Tue, 20 Jul 2021 14:38:20 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "Marek Beh__n" <kabel@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH RFC net-next] net: phy: marvell10g: add downshift tunable support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1m5pwy-0003uX-Pf@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 20 Jul 2021 14:38:20 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the downshift tunable for the Marvell 88x3310 PHY.
Downshift is only usable with firmware 0.3.5.0 and later.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---

It would be useful to have views on the "FIXME" comment in this patch
please. Thanks.

 drivers/net/phy/marvell10g.c | 87 +++++++++++++++++++++++++++++++++++-
 1 file changed, 86 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 0b7cae118ad7..0c9e7e1fab91 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -22,6 +22,7 @@
  * If both the fiber and copper ports are connected, the first to gain
  * link takes priority and the other port is completely locked out.
  */
+#include <linux/bitfield.h>
 #include <linux/ctype.h>
 #include <linux/delay.h>
 #include <linux/hwmon.h>
@@ -33,6 +34,8 @@
 #define MV_PHY_ALASKA_NBT_QUIRK_MASK	0xfffffffe
 #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
 
+#define MV_VERSION(a,b,c,d) ((a) << 24 | (b) << 16 | (c) << 8 | (d))
+
 enum {
 	MV_PMA_FW_VER0		= 0xc011,
 	MV_PMA_FW_VER1		= 0xc012,
@@ -62,6 +65,15 @@ enum {
 	MV_PCS_CSCR1_MDIX_MDIX	= 0x0020,
 	MV_PCS_CSCR1_MDIX_AUTO	= 0x0060,
 
+	MV_PCS_DSC1		= 0x8003,
+	MV_PCS_DSC1_ENABLE	= BIT(9),
+	MV_PCS_DSC1_10GBT	= 0x01c0,
+	MV_PCS_DSC1_1GBR	= 0x0038,
+	MV_PCS_DSC1_100BTX	= 0x0007,
+	MV_PCS_DSC2		= 0x8004,
+	MV_PCS_DSC2_2P5G	= 0xf000,
+	MV_PCS_DSC2_5G		= 0x0f00,
+
 	MV_PCS_CSSR1		= 0x8008,
 	MV_PCS_CSSR1_SPD1_MASK	= 0xc000,
 	MV_PCS_CSSR1_SPD1_SPD2	= 0xc000,
@@ -330,6 +342,66 @@ static int mv3310_reset(struct phy_device *phydev, u32 unit)
 					 5000, 100000, true);
 }
 
+static int mv3310_get_downshift(struct phy_device *phydev, u8 *ds)
+{
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+	int val;
+
+	if (priv->firmware_ver < MV_VERSION(0,3,5,0))
+		return -EOPNOTSUPP;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_DSC1);
+	if (val < 0)
+		return val;
+
+	if (val & MV_PCS_DSC1_ENABLE)
+		/* assume that all fields are the same */
+		*ds = 1 + FIELD_GET(MV_PCS_DSC1_10GBT, (u16)val);
+	else
+		*ds = DOWNSHIFT_DEV_DISABLE;
+
+	return 0;
+}
+
+static int mv3310_set_downshift(struct phy_device *phydev, u8 ds)
+{
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+	u16 val;
+	int err;
+
+	/* Fails to downshift with v0.3.5.0 and earlier */
+	if (priv->firmware_ver < MV_VERSION(0,3,5,0))
+		return -EOPNOTSUPP;
+
+	if (ds == DOWNSHIFT_DEV_DISABLE)
+		return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MV_PCS_DSC1,
+					  MV_PCS_DSC1_ENABLE);
+
+	/* FIXME: The default is disabled, so should we disable? */
+	if (ds == DOWNSHIFT_DEV_DEFAULT_COUNT)
+		ds = 2;
+
+	if (ds > 8)
+		return -E2BIG;
+
+	ds -= 1;
+	val = FIELD_PREP(MV_PCS_DSC2_2P5G, ds);
+	val |= FIELD_PREP(MV_PCS_DSC2_5G, ds);
+	err = phy_modify_mmd(phydev, MDIO_MMD_PCS, MV_PCS_DSC2,
+			     MV_PCS_DSC2_2P5G | MV_PCS_DSC2_5G, val);
+	if (err < 0)
+		return err;
+
+	val = MV_PCS_DSC1_ENABLE;
+	val |= FIELD_PREP(MV_PCS_DSC1_10GBT, ds);
+	val |= FIELD_PREP(MV_PCS_DSC1_1GBR, ds);
+	val |= FIELD_PREP(MV_PCS_DSC1_100BTX, ds);
+
+	return phy_modify_mmd(phydev, MDIO_MMD_PCS, MV_PCS_DSC1,
+			      MV_PCS_DSC1_ENABLE | MV_PCS_DSC1_10GBT |
+			      MV_PCS_DSC1_1GBR | MV_PCS_DSC1_100BTX, val);
+}
+
 static int mv3310_get_edpd(struct phy_device *phydev, u16 *edpd)
 {
 	int val;
@@ -616,7 +688,16 @@ static int mv3310_config_init(struct phy_device *phydev)
 	}
 
 	/* Enable EDPD mode - saving 600mW */
-	return mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
+	err = mv3310_set_edpd(phydev, ETHTOOL_PHY_EDPD_DFLT_TX_MSECS);
+	if (err)
+		return err;
+
+	/* Allow downshift */
+	err = mv3310_set_downshift(phydev, DOWNSHIFT_DEV_DEFAULT_COUNT);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
+	return 0;
 }
 
 static int mv3310_get_features(struct phy_device *phydev)
@@ -886,6 +967,8 @@ static int mv3310_get_tunable(struct phy_device *phydev,
 			      struct ethtool_tunable *tuna, void *data)
 {
 	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return mv3310_get_downshift(phydev, data);
 	case ETHTOOL_PHY_EDPD:
 		return mv3310_get_edpd(phydev, data);
 	default:
@@ -897,6 +980,8 @@ static int mv3310_set_tunable(struct phy_device *phydev,
 			      struct ethtool_tunable *tuna, const void *data)
 {
 	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return mv3310_set_downshift(phydev, *(u8 *)data);
 	case ETHTOOL_PHY_EDPD:
 		return mv3310_set_edpd(phydev, *(u16 *)data);
 	default:
-- 
2.20.1

