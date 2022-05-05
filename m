Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F8651B809
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 08:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244765AbiEEGhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 02:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244562AbiEEGhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 02:37:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0571418E08
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 23:33:35 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV3B-00047T-E6; Thu, 05 May 2022 08:33:21 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV3B-000SRz-MU; Thu, 05 May 2022 08:33:20 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV38-001F60-RL; Thu, 05 May 2022 08:33:18 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 2/7] net: phy: introduce genphy_c45_pma_base1_setup_master_slave()
Date:   Thu,  5 May 2022 08:33:13 +0200
Message-Id: <20220505063318.296280-3-o.rempel@pengutronix.de>
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

Move baset1 specific part of genphy_c45_pma_setup_forced() code to
separate function to make it reusable by PHY drivers.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy-c45.c | 49 ++++++++++++++++++++++++---------------
 include/linux/phy.h       |  1 +
 2 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 0014aa6e73c0..140cd2b42092 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -70,6 +70,35 @@ int genphy_c45_pma_suspend(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_pma_suspend);
 
+/**
+ * genphy_c45_pma_base1_setup_master_slave - configures forced master/slave
+ * role of BaseT1 devices.
+ * @phydev: target phy_device struct
+ */
+int genphy_c45_pma_base1_setup_master_slave(struct phy_device *phydev)
+{
+	int ctl = 0;
+
+	switch (phydev->master_slave_set) {
+	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+	case MASTER_SLAVE_CFG_MASTER_FORCE:
+		ctl = MDIO_PMA_PMD_BT1_CTRL_CFG_MST;
+		break;
+	case MASTER_SLAVE_CFG_SLAVE_FORCE:
+	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
+	case MASTER_SLAVE_CFG_UNKNOWN:
+	case MASTER_SLAVE_CFG_UNSUPPORTED:
+		break;
+	default:
+		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
+		return -EOPNOTSUPP;
+	}
+
+	return phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_PMD_BT1_CTRL,
+			     MDIO_PMA_PMD_BT1_CTRL_CFG_MST, ctl);
+}
+EXPORT_SYMBOL_GPL(genphy_c45_pma_base1_setup_master_slave);
+
 /**
  * genphy_c45_pma_setup_forced - configures a forced speed
  * @phydev: target phy_device struct
@@ -141,25 +170,7 @@ int genphy_c45_pma_setup_forced(struct phy_device *phydev)
 		return ret;
 
 	if (genphy_c45_baset1_able(phydev)) {
-		int ctl = 0;
-
-		switch (phydev->master_slave_set) {
-		case MASTER_SLAVE_CFG_MASTER_PREFERRED:
-		case MASTER_SLAVE_CFG_MASTER_FORCE:
-			ctl = MDIO_PMA_PMD_BT1_CTRL_CFG_MST;
-			break;
-		case MASTER_SLAVE_CFG_SLAVE_FORCE:
-		case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
-		case MASTER_SLAVE_CFG_UNKNOWN:
-		case MASTER_SLAVE_CFG_UNSUPPORTED:
-			break;
-		default:
-			phydev_warn(phydev, "Unsupported Master/Slave mode\n");
-			return -EOPNOTSUPP;
-		}
-
-		ret = phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_PMD_BT1_CTRL,
-				     MDIO_PMA_PMD_BT1_CTRL_CFG_MST, ctl);
+		ret = genphy_c45_pma_base1_setup_master_slave(phydev);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2d12054932ba..a8548c138d78 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1614,6 +1614,7 @@ int genphy_c45_read_link(struct phy_device *phydev);
 int genphy_c45_read_lpa(struct phy_device *phydev);
 int genphy_c45_read_pma(struct phy_device *phydev);
 int genphy_c45_pma_setup_forced(struct phy_device *phydev);
+int genphy_c45_pma_base1_setup_master_slave(struct phy_device *phydev);
 int genphy_c45_an_config_aneg(struct phy_device *phydev);
 int genphy_c45_an_disable_aneg(struct phy_device *phydev);
 int genphy_c45_read_mdix(struct phy_device *phydev);
-- 
2.30.2

