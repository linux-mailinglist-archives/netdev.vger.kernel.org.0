Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D296739CB
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 14:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjASNS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 08:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbjASNSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 08:18:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205CA2887E
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 05:18:36 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pIUoD-0005uT-AK; Thu, 19 Jan 2023 14:18:25 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pIUoC-0079jZ-N8; Thu, 19 Jan 2023 14:18:24 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pIUoB-00G513-AS; Thu, 19 Jan 2023 14:18:23 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v1 2/4] net: phy: micrel: add EEE configuration support for KSZ9477 variants of PHYs
Date:   Thu, 19 Jan 2023 14:18:19 +0100
Message-Id: <20230119131821.3832456-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230119131821.3832456-1-o.rempel@pengutronix.de>
References: <20230119131821.3832456-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KSZ9477 variants of PHYs are not completely compatible with generic
phy_ethtool_get/set_eee() handlers. For example MDIO_PCS_EEE_ABLE acts
like a mirror of MDIO_AN_EEE_ADV register. If MDIO_AN_EEE_ADV set to 0,
MDIO_PCS_EEE_ABLE will be 0 too. It means, if we do
"ethtool --set-eee lan2 eee off", we won't be able to enable it again.

With this patch, instead of reading MDIO_PCS_EEE_ABLE register, the
driver will provide proper abilities.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/micrel.c | 92 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index d5b80c31ab91..099f1e83c08c 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1370,6 +1370,96 @@ static int ksz9131_config_aneg(struct phy_device *phydev)
 	return genphy_config_aneg(phydev);
 }
 
+static int ksz9477_get_eee_caps(struct phy_device *phydev,
+				struct ethtool_eee *data)
+{
+	int val;
+
+	/* At least on KSZ8563 (which has same PHY_ID as KSZ9477), the
+	 * MDIO_PCS_EEE_ABLE register is a mirror of MDIO_AN_EEE_ADV register.
+	 * So, we need to provide this information by driver.
+	 */
+	data->supported = SUPPORTED_100baseT_Full;
+
+	/* KSZ8563 is able to advertise not supported MDIO_EEE_1000T.
+	 * We need to test if the PHY is 1Gbit capable.
+	 */
+	val = phy_read(phydev, MII_BMSR);
+	if (val < 0)
+		return val;
+
+	if (val & BMSR_ERCAP)
+		data->supported |= SUPPORTED_1000baseT_Full;
+
+	return 0;
+}
+
+static int ksz9477_get_eee(struct phy_device *phydev, struct ethtool_eee *data)
+{
+	int val;
+
+	val = ksz9477_get_eee_caps(phydev, data);
+	if (val)
+		return val;
+
+	/* Get advertisement EEE */
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV);
+	if (val < 0)
+		return val;
+	data->advertised = mmd_eee_adv_to_ethtool_adv_t(val);
+	data->eee_enabled = !!data->advertised;
+
+	/* Get LP advertisement EEE */
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_LPABLE);
+	if (val < 0)
+		return val;
+	data->lp_advertised = mmd_eee_adv_to_ethtool_adv_t(val);
+
+	data->eee_active = !!(data->advertised & data->lp_advertised);
+
+	return 0;
+}
+
+static int ksz9477_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
+{
+	int old_adv, adv = 0, ret;
+
+	ret = ksz9477_get_eee_caps(phydev, data);
+	if (ret)
+		return ret;
+
+	old_adv = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV);
+	if (old_adv < 0)
+		return old_adv;
+
+	if (data->eee_enabled) {
+		if (!data->advertised)
+			adv = ethtool_adv_to_mmd_eee_adv_t(data->supported);
+		else
+			adv = ethtool_adv_to_mmd_eee_adv_t(data->advertised &
+							   data->supported);
+		/* Mask prohibited EEE modes */
+		adv &= ~phydev->eee_broken_modes;
+	}
+
+	if (old_adv != adv) {
+		ret = phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, adv);
+		if (ret < 0)
+			return ret;
+
+		/* Restart autonegotiation so the new modes get sent to the
+		 * link partner.
+		 */
+		if (phydev->autoneg == AUTONEG_ENABLE) {
+			ret = phy_restart_aneg(phydev);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
 #define KSZ8873MLL_GLOBAL_CONTROL_4	0x06
 #define KSZ8873MLL_GLOBAL_CONTROL_4_DUPLEX	BIT(6)
 #define KSZ8873MLL_GLOBAL_CONTROL_4_SPEED	BIT(4)
@@ -3422,6 +3512,8 @@ static struct phy_driver ksphy_driver[] = {
 	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
+	.get_eee	= ksz9477_get_eee,
+	.set_eee	= ksz9477_set_eee,
 } };
 
 module_phy_driver(ksphy_driver);
-- 
2.30.2

