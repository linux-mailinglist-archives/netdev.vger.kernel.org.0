Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0EF69EE87
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 06:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBVFvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 00:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjBVFvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 00:51:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D643524F
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 21:51:02 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pUi1g-00060E-6R; Wed, 22 Feb 2023 06:50:48 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pUi1d-006eff-TG; Wed, 22 Feb 2023 06:50:47 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pUi1d-000TbR-Hv; Wed, 22 Feb 2023 06:50:45 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net v3 3/4] net: phy: do not force EEE support
Date:   Wed, 22 Feb 2023 06:50:42 +0100
Message-Id: <20230222055043.113711-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230222055043.113711-1-o.rempel@pengutronix.de>
References: <20230222055043.113711-1-o.rempel@pengutronix.de>
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

With following patches:
commit 9b01c885be36 ("net: phy: c22: migrate to genphy_c45_write_eee_adv()")
commit 5827b168125d ("net: phy: c45: migrate to genphy_c45_write_eee_adv()")

we set the advertisement to potentially supported values. This behavior
may introduce new regressions on systems where EEE was disabled by
default (BIOS or boot loader configuration or by other ways.)

At same time, with this patches, we would overwrite EEE advertisement
configuration made over ethtool.

To avoid this issues, we need to cache initial and ethtool advertisement
configuration and store it for later use.

Fixes: 9b01c885be36 ("net: phy: c22: migrate to genphy_c45_write_eee_adv()")
Fixes: 5827b168125d ("net: phy: c45: migrate to genphy_c45_write_eee_adv()")
Fixes: 022c3f87f88e ("net: phy: add genphy_c45_ethtool_get/set_eee() support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy-c45.c    | 24 +++++++++++++++++-------
 drivers/net/phy/phy_device.c | 19 +++++++++++++++++++
 include/linux/phy.h          |  5 +++++
 3 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 784868e818a7..8717c122e2f3 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -721,8 +721,7 @@ int genphy_c45_write_eee_adv(struct phy_device *phydev, unsigned long *adv)
  * @phydev: target phy_device struct
  * @adv: the linkmode advertisement status
  */
-static int genphy_c45_read_eee_adv(struct phy_device *phydev,
-				   unsigned long *adv)
+int genphy_c45_read_eee_adv(struct phy_device *phydev, unsigned long *adv)
 {
 	int val;
 
@@ -864,7 +863,13 @@ EXPORT_SYMBOL_GPL(genphy_c45_read_eee_abilities);
  */
 int genphy_c45_an_config_eee_aneg(struct phy_device *phydev)
 {
-	return genphy_c45_write_eee_adv(phydev, phydev->supported_eee);
+	if (!phydev->eee_enabled) {
+		__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
+
+		return genphy_c45_write_eee_adv(phydev, adv);
+	}
+
+	return genphy_c45_write_eee_adv(phydev, phydev->advertising_eee);
 }
 
 /**
@@ -1430,17 +1435,22 @@ EXPORT_SYMBOL(genphy_c45_ethtool_get_eee);
 int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
 			       struct ethtool_eee *data)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv) = {};
 	int ret;
 
 	if (data->eee_enabled) {
 		if (data->advertised)
-			adv[0] = data->advertised;
+			ethtool_convert_legacy_u32_to_link_mode(phydev->advertising_eee,
+								data->advertised);
 		else
-			linkmode_copy(adv, phydev->supported_eee);
+			linkmode_copy(phydev->advertising_eee,
+				      phydev->supported_eee);
+
+		phydev->eee_enabled = true;
+	} else {
+		phydev->eee_enabled = false;
 	}
 
-	ret = genphy_c45_write_eee_adv(phydev, adv);
+	ret = genphy_c45_an_config_eee_aneg(phydev);
 	if (ret < 0)
 		return ret;
 	if (ret > 0)
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 570a5803f9c2..3f8a64fb9d71 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3141,6 +3141,25 @@ static int phy_probe(struct device *dev)
 	of_set_phy_supported(phydev);
 	phy_advertise_supported(phydev);
 
+	/* Get PHY default EEE advertising modes and handle them as potentially
+	 * safe initial configuration.
+	 */
+	err = genphy_c45_read_eee_adv(phydev, phydev->advertising_eee);
+	if (err)
+		return err;
+
+	/* There is no "enabled" flag. If PHY is advertising, assume it is
+	 * kind of enabled.
+	 */
+	phydev->eee_enabled = !linkmode_empty(phydev->advertising_eee);
+
+	/* Some PHYs may advertise, by default, not support EEE modes. So,
+	 * we need to clean them.
+	 */
+	if (phydev->eee_enabled)
+		linkmode_and(phydev->advertising_eee, phydev->supported_eee,
+			     phydev->advertising_eee);
+
 	/* Get the EEE modes we want to prohibit. We will ask
 	 * the PHY stop advertising these mode later on
 	 */
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 19d83e112beb..36bf0bbc8efa 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -575,6 +575,8 @@ struct macsec_ops;
  * @advertising: Currently advertised linkmodes
  * @adv_old: Saved advertised while power saving for WoL
  * @supported_eee: supported PHY EEE linkmodes
+ * @advertising_eee: Currently advertised EEE linkmodes
+ * @eee_enabled: Flag indicating whether the EEE feature is enabled
  * @lp_advertising: Current link partner advertised linkmodes
  * @host_interfaces: PHY interface modes supported by host
  * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
@@ -681,6 +683,8 @@ struct phy_device {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(adv_old);
 	/* used for eee validation */
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported_eee);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising_eee);
+	bool eee_enabled;
 
 	/* Host supported PHY interface types. Should be ignored if empty. */
 	DECLARE_PHY_INTERFACE_MASK(host_interfaces);
@@ -1766,6 +1770,7 @@ int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
 			       struct ethtool_eee *data);
 int genphy_c45_write_eee_adv(struct phy_device *phydev, unsigned long *adv);
 int genphy_c45_an_config_eee_aneg(struct phy_device *phydev);
+int genphy_c45_read_eee_adv(struct phy_device *phydev, unsigned long *adv);
 
 /* Generic C45 PHY driver */
 extern struct phy_driver genphy_c45_driver;
-- 
2.30.2

