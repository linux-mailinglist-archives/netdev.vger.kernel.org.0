Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C46541C85E
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345240AbhI2Pai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345157AbhI2Pah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:30:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80571C06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EE0SZBTdfOx3aQZvqzWhLaHRmp63ZVqI/aHzXTZCU88=; b=rCLsw5YUYvLB7R5kIAR4DVhOsk
        wu0ZcfpdsFyb0R6OezQri40s2NmhwI8/nMoqhWaZqLhIZz7HYFX++X/iEV27M9qerH7WBNHqRJ0NN
        28DzgCznjI95IhoTcTtMjbijZse6+eNm/QsxUSnwjAMig8svOGvr3ZqaPT1NA1M17/e8wo12XueiY
        6ebPtpXoHQDrZKw/eatlCt5Gk6jeQ5FYNKxZOCC18Y0wIMu/4NhN2POrJOQohB+veQHOLTZO7b8Jl
        SasgCsjbIIN8ELgPMvdCwFIHn5M3vPne0myBpcxbak5vLkiBbPbcJq/Mto9fcAVlAUqMHpcdYcBJ1
        jwLLn2Pw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51450 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mVbVt-0002Oy-S2; Wed, 29 Sep 2021 16:28:53 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mVbVt-0004Fh-Dv; Wed, 29 Sep 2021 16:28:53 +0100
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "Marek Beh__n" <kabel@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 net-next] net: phy: marvell10g: add downshift tunable
 support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mVbVt-0004Fh-Dv@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 29 Sep 2021 16:28:53 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the downshift tunable for the Marvell 88x3310 PHY.
Downshift is only usable with firmware 0.3.5.0 and later.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
v2: updated comment

 drivers/net/phy/marvell10g.c | 107 ++++++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index bd310e8d5e43..b6fea119fe13 100644
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
@@ -125,6 +137,7 @@ enum {
 };
 
 struct mv3310_chip {
+	bool (*has_downshift)(struct phy_device *phydev);
 	void (*init_supported_interfaces)(unsigned long *mask);
 	int (*get_mactype)(struct phy_device *phydev);
 	int (*init_interface)(struct phy_device *phydev, int mactype);
@@ -138,6 +151,7 @@ struct mv3310_priv {
 	DECLARE_BITMAP(supported_interfaces, PHY_INTERFACE_MODE_MAX);
 
 	u32 firmware_ver;
+	bool has_downshift;
 	bool rate_match;
 	phy_interface_t const_interface;
 
@@ -330,6 +344,71 @@ static int mv3310_reset(struct phy_device *phydev, u32 unit)
 					 5000, 100000, true);
 }
 
+static int mv3310_get_downshift(struct phy_device *phydev, u8 *ds)
+{
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+	int val;
+
+	if (!priv->has_downshift)
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
+	if (!priv->has_downshift)
+		return -EOPNOTSUPP;
+
+	if (ds == DOWNSHIFT_DEV_DISABLE)
+		return phy_clear_bits_mmd(phydev, MDIO_MMD_PCS, MV_PCS_DSC1,
+					  MV_PCS_DSC1_ENABLE);
+
+	/* DOWNSHIFT_DEV_DEFAULT_COUNT is confusing. It looks like it should
+	 * set the default settings for the PHY. However, it is used for
+	 * "ethtool --set-phy-tunable ethN downshift on". The intention is
+	 * to enable downshift at a default number of retries. The default
+	 * settings for 88x3310 are for two retries with downshift disabled.
+	 * So let's use two retries with downshift enabled.
+	 */
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
@@ -448,6 +527,9 @@ static int mv3310_probe(struct phy_device *phydev)
 		    priv->firmware_ver >> 24, (priv->firmware_ver >> 16) & 255,
 		    (priv->firmware_ver >> 8) & 255, priv->firmware_ver & 255);
 
+	if (chip->has_downshift)
+		priv->has_downshift = chip->has_downshift(phydev);
+
 	/* Powering down the port when not in use saves about 600mW */
 	ret = mv3310_power_down(phydev);
 	if (ret)
@@ -616,7 +698,16 @@ static int mv3310_config_init(struct phy_device *phydev)
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
@@ -886,6 +977,8 @@ static int mv3310_get_tunable(struct phy_device *phydev,
 			      struct ethtool_tunable *tuna, void *data)
 {
 	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return mv3310_get_downshift(phydev, data);
 	case ETHTOOL_PHY_EDPD:
 		return mv3310_get_edpd(phydev, data);
 	default:
@@ -897,6 +990,8 @@ static int mv3310_set_tunable(struct phy_device *phydev,
 			      struct ethtool_tunable *tuna, const void *data)
 {
 	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return mv3310_set_downshift(phydev, *(u8 *)data);
 	case ETHTOOL_PHY_EDPD:
 		return mv3310_set_edpd(phydev, *(u16 *)data);
 	default:
@@ -904,6 +999,14 @@ static int mv3310_set_tunable(struct phy_device *phydev,
 	}
 }
 
+static bool mv3310_has_downshift(struct phy_device *phydev)
+{
+	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
+
+	/* Fails to downshift with firmware older than v0.3.5.0 */
+	return priv->firmware_ver >= MV_VERSION(0,3,5,0);
+}
+
 static void mv3310_init_supported_interfaces(unsigned long *mask)
 {
 	__set_bit(PHY_INTERFACE_MODE_SGMII, mask);
@@ -943,6 +1046,7 @@ static void mv2111_init_supported_interfaces(unsigned long *mask)
 }
 
 static const struct mv3310_chip mv3310_type = {
+	.has_downshift = mv3310_has_downshift,
 	.init_supported_interfaces = mv3310_init_supported_interfaces,
 	.get_mactype = mv3310_get_mactype,
 	.init_interface = mv3310_init_interface,
@@ -953,6 +1057,7 @@ static const struct mv3310_chip mv3310_type = {
 };
 
 static const struct mv3310_chip mv3340_type = {
+	.has_downshift = mv3310_has_downshift,
 	.init_supported_interfaces = mv3340_init_supported_interfaces,
 	.get_mactype = mv3310_get_mactype,
 	.init_interface = mv3340_init_interface,
-- 
2.30.2

