Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8ED69EE86
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 06:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjBVFvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 00:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbjBVFvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 00:51:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEDA34F65
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 21:51:01 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pUi1g-000605-6W; Wed, 22 Feb 2023 06:50:48 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pUi1d-006efT-63; Wed, 22 Feb 2023 06:50:46 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pUi1d-000TbI-HG; Wed, 22 Feb 2023 06:50:45 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [PATCH net v3 2/4] net: phy: c45: add genphy_c45_an_config_eee_aneg() function
Date:   Wed, 22 Feb 2023 06:50:41 +0100
Message-Id: <20230222055043.113711-3-o.rempel@pengutronix.de>
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

Add new genphy_c45_an_config_eee_aneg() function and replace some of
genphy_c45_write_eee_adv() calls. This will be needed by the next patch.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy-c45.c    | 11 ++++++++++-
 drivers/net/phy/phy_device.c |  2 +-
 include/linux/phy.h          |  1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index f23cce2c5199..784868e818a7 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -262,7 +262,7 @@ int genphy_c45_an_config_aneg(struct phy_device *phydev)
 	linkmode_and(phydev->advertising, phydev->advertising,
 		     phydev->supported);
 
-	ret = genphy_c45_write_eee_adv(phydev, phydev->supported_eee);
+	ret = genphy_c45_an_config_eee_aneg(phydev);
 	if (ret < 0)
 		return ret;
 	else if (ret)
@@ -858,6 +858,15 @@ int genphy_c45_read_eee_abilities(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_read_eee_abilities);
 
+/**
+ * genphy_c45_an_config_eee_aneg - configure EEE advertisement
+ * @phydev: target phy_device struct
+ */
+int genphy_c45_an_config_eee_aneg(struct phy_device *phydev)
+{
+	return genphy_c45_write_eee_adv(phydev, phydev->supported_eee);
+}
+
 /**
  * genphy_c45_pma_read_abilities - read supported link modes from PMA
  * @phydev: target phy_device struct
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 71becceb8764..570a5803f9c2 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2231,7 +2231,7 @@ int __genphy_config_aneg(struct phy_device *phydev, bool changed)
 {
 	int err;
 
-	err = genphy_c45_write_eee_adv(phydev, phydev->supported_eee);
+	err = genphy_c45_an_config_eee_aneg(phydev);
 	if (err < 0)
 		return err;
 	else if (err)
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 727bff531a14..19d83e112beb 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1765,6 +1765,7 @@ int genphy_c45_ethtool_get_eee(struct phy_device *phydev,
 int genphy_c45_ethtool_set_eee(struct phy_device *phydev,
 			       struct ethtool_eee *data);
 int genphy_c45_write_eee_adv(struct phy_device *phydev, unsigned long *adv);
+int genphy_c45_an_config_eee_aneg(struct phy_device *phydev);
 
 /* Generic C45 PHY driver */
 extern struct phy_driver genphy_c45_driver;
-- 
2.30.2

