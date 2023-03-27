Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E0B6CA773
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbjC0OYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbjC0OXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:23:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19757EC8
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:22:17 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnja-0008Hj-Kt; Mon, 27 Mar 2023 16:22:06 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjY-0076IK-7Q; Mon, 27 Mar 2023 16:22:04 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1pgnjW-00Fkik-PV; Mon, 27 Mar 2023 16:22:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Amit Cohen <amcohen@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next v2 1/8] net: phy: Add driver-specific get/set_eee support for non-standard PHYs
Date:   Mon, 27 Mar 2023 16:21:55 +0200
Message-Id: <20230327142202.3754446-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230327142202.3754446-1-o.rempel@pengutronix.de>
References: <20230327142202.3754446-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not all PHYs are implemented fully according to the IEEE 802.3
specification and cannot be handled by the generic
phy_ethtool_get/set_eee() functions. To address this, this commit adds
driver-specific get/set_eee support, enabling better handling of such
PHYs. This is particularly important for handling PHYs with SmartEEE
support, which requires specialized management.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy.c | 10 ++++++++--
 include/linux/phy.h   |  5 +++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 0c0df38cd1ab..103484c24437 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1568,7 +1568,10 @@ int phy_ethtool_get_eee(struct phy_device *phydev, struct ethtool_eee *data)
 		return -EIO;
 
 	mutex_lock(&phydev->lock);
-	ret = genphy_c45_ethtool_get_eee(phydev, data);
+	if (phydev->drv->get_eee)
+		ret = phydev->drv->get_eee(phydev, data);
+	else
+		ret = genphy_c45_ethtool_get_eee(phydev, data);
 	mutex_unlock(&phydev->lock);
 
 	return ret;
@@ -1590,7 +1593,10 @@ int phy_ethtool_set_eee(struct phy_device *phydev, struct ethtool_eee *data)
 		return -EIO;
 
 	mutex_lock(&phydev->lock);
-	ret = genphy_c45_ethtool_set_eee(phydev, data);
+	if (phydev->drv->set_eee)
+		ret = phydev->drv->set_eee(phydev, data);
+	else
+		ret = genphy_c45_ethtool_set_eee(phydev, data);
 	mutex_unlock(&phydev->lock);
 
 	return ret;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index fefd5091bc24..07cebf110aa6 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1056,6 +1056,11 @@ struct phy_driver {
 	/** @get_plca_status: Return the current PLCA status info */
 	int (*get_plca_status)(struct phy_device *dev,
 			       struct phy_plca_status *plca_st);
+
+	/** @get_eee: Return the current EEE configuration */
+	int (*get_eee)(struct phy_device *phydev, struct ethtool_eee *e);
+	/** @set_eee: Set the EEE configuration */
+	int (*set_eee)(struct phy_device *phydev, struct ethtool_eee *e);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.30.2

