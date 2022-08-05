Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2483C58A729
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 09:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237688AbiHEHcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 03:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237079AbiHEHcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 03:32:21 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE46BC0E
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 00:32:21 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oJroT-0004s9-Cg; Fri, 05 Aug 2022 09:32:05 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oJroO-001qjH-Rw; Fri, 05 Aug 2022 09:32:03 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1oJroQ-003odj-AT; Fri, 05 Aug 2022 09:32:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net v1 1/1] net: phy: c45 baset1: do not skip aneg configuration if clock role is not specified
Date:   Fri,  5 Aug 2022 09:31:59 +0200
Message-Id: <20220805073159.908643-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
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

In case master/slave clock role is not specified (which is default), the
aneg registers will not be written.

The visible impact of this is missing pause advertisement.

So, rework genphy_c45_baset1_an_config_aneg() to be able to write
advertisement registers even if clock role is unknown.

Fixes: 3da8ffd8545f ("net: phy: Add 10BASE-T1L support in phy-c45")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy-c45.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 29b1df03f3e8b..a87a4b3ffce4e 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -190,44 +190,42 @@ EXPORT_SYMBOL_GPL(genphy_c45_pma_setup_forced);
  */
 static int genphy_c45_baset1_an_config_aneg(struct phy_device *phydev)
 {
+	u16 adv_l_mask, adv_l = 0;
+	u16 adv_m_mask, adv_m = 0;
 	int changed = 0;
-	u16 adv_l = 0;
-	u16 adv_m = 0;
 	int ret;
 
+	adv_l_mask = MDIO_AN_T1_ADV_L_FORCE_MS | MDIO_AN_T1_ADV_L_PAUSE_CAP |
+		MDIO_AN_T1_ADV_L_PAUSE_ASYM;
+	adv_m_mask = MDIO_AN_T1_ADV_M_MST | MDIO_AN_T1_ADV_M_B10L;
+
 	switch (phydev->master_slave_set) {
 	case MASTER_SLAVE_CFG_MASTER_FORCE:
+		adv_m |= MDIO_AN_T1_ADV_M_MST;
+		fallthrough;
 	case MASTER_SLAVE_CFG_SLAVE_FORCE:
 		adv_l |= MDIO_AN_T1_ADV_L_FORCE_MS;
 		break;
 	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+		adv_m |= MDIO_AN_T1_ADV_M_MST;
+		fallthrough;
 	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
 		break;
 	case MASTER_SLAVE_CFG_UNKNOWN:
 	case MASTER_SLAVE_CFG_UNSUPPORTED:
-		return 0;
+		/* if master/slave role is not specified, do not overwrite it */
+		adv_l_mask &= ~MDIO_AN_T1_ADV_L_FORCE_MS;
+		adv_m_mask &= ~MDIO_AN_T1_ADV_M_MST;
+		break;
 	default:
 		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
 		return -EOPNOTSUPP;
 	}
 
-	switch (phydev->master_slave_set) {
-	case MASTER_SLAVE_CFG_MASTER_FORCE:
-	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
-		adv_m |= MDIO_AN_T1_ADV_M_MST;
-		break;
-	case MASTER_SLAVE_CFG_SLAVE_FORCE:
-	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
-		break;
-	default:
-		break;
-	}
-
 	adv_l |= linkmode_adv_to_mii_t1_adv_l_t(phydev->advertising);
 
 	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_L,
-				     (MDIO_AN_T1_ADV_L_FORCE_MS | MDIO_AN_T1_ADV_L_PAUSE_CAP
-				     | MDIO_AN_T1_ADV_L_PAUSE_ASYM), adv_l);
+				     adv_l_mask, adv_l);
 	if (ret < 0)
 		return ret;
 	if (ret > 0)
@@ -236,7 +234,7 @@ static int genphy_c45_baset1_an_config_aneg(struct phy_device *phydev)
 	adv_m |= linkmode_adv_to_mii_t1_adv_m_t(phydev->advertising);
 
 	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_M,
-				     MDIO_AN_T1_ADV_M_MST | MDIO_AN_T1_ADV_M_B10L, adv_m);
+				     adv_m_mask, adv_m);
 	if (ret < 0)
 		return ret;
 	if (ret > 0)
-- 
2.30.2

