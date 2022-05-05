Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7B751B801
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 08:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244669AbiEEGhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 02:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244478AbiEEGhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 02:37:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDFB220C2
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 23:33:33 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV3B-00047S-E5; Thu, 05 May 2022 08:33:21 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV3B-000SRy-Lc; Thu, 05 May 2022 08:33:20 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV38-001F6I-Sb; Thu, 05 May 2022 08:33:18 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 4/7] net: phy: introduce genphy_c45_pma_baset1_read_master_slave()
Date:   Thu,  5 May 2022 08:33:15 +0200
Message-Id: <20220505063318.296280-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220505063318.296280-1-o.rempel@pengutronix.de>
References: <20220505063318.296280-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move baset1 specific part of genphy_c45_read_pma() code to
separate function to make it reusable by PHY drivers.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy-c45.c | 30 ++++++++++++++++++++++++------
 include/linux/phy.h       |  1 +
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 103a9296bbd0..6f7a03318d42 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -550,6 +550,29 @@ int genphy_c45_read_lpa(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_read_lpa);
 
+/**
+ * genphy_c45_baset1_read_master_slave - read forced master/slave configuration
+ * @phydev: target phy_device struct
+ */
+int genphy_c45_pma_baset1_read_master_slave(struct phy_device *phydev)
+{
+	int val;
+
+	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_PMD_BT1_CTRL);
+	if (val < 0)
+		return val;
+
+	if (val & MDIO_PMA_PMD_BT1_CTRL_CFG_MST)
+		phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
+	else
+		phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(genphy_c45_pma_baset1_read_master_slave);
+
 /**
  * genphy_c45_read_pma - read link speed etc from PMA
  * @phydev: target phy_device struct
@@ -591,14 +614,9 @@ int genphy_c45_read_pma(struct phy_device *phydev)
 	phydev->duplex = DUPLEX_FULL;
 
 	if (genphy_c45_baset1_able(phydev)) {
-		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_PMD_BT1_CTRL);
+		val = genphy_c45_pma_baset1_read_master_slave(phydev);
 		if (val < 0)
 			return val;
-
-		if (MDIO_PMA_PMD_BT1_CTRL_CFG_MST)
-			phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
-		else
-			phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
 	}
 
 	return 0;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index a8548c138d78..a7490df8e1ec 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1619,6 +1619,7 @@ int genphy_c45_an_config_aneg(struct phy_device *phydev);
 int genphy_c45_an_disable_aneg(struct phy_device *phydev);
 int genphy_c45_read_mdix(struct phy_device *phydev);
 int genphy_c45_pma_read_abilities(struct phy_device *phydev);
+int genphy_c45_pma_baset1_read_master_slave(struct phy_device *phydev);
 int genphy_c45_read_status(struct phy_device *phydev);
 int genphy_c45_config_aneg(struct phy_device *phydev);
 int genphy_c45_loopback(struct phy_device *phydev, bool enable);
-- 
2.30.2

