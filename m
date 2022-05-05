Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA8451B807
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 08:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244823AbiEEGh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 02:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244473AbiEEGhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 02:37:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6172D1A80B
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 23:33:35 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV3B-00047V-E6; Thu, 05 May 2022 08:33:21 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV3B-000SS7-Vr; Thu, 05 May 2022 08:33:20 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nmV38-001F6R-TA; Thu, 05 May 2022 08:33:18 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 5/7] net: phy: genphy_c45_pma_baset1_read_master_slave: read actual configuration
Date:   Thu,  5 May 2022 08:33:16 +0200
Message-Id: <20220505063318.296280-6-o.rempel@pengutronix.de>
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

Since MDIO_PMA_PMD_BT1_CTRL register shows actual configuration (and
forced state configuration is equal to the state), we should show
this configuration for ethtool.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy-c45.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 6f7a03318d42..40620e3c9467 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -559,15 +559,19 @@ int genphy_c45_pma_baset1_read_master_slave(struct phy_device *phydev)
 	int val;
 
 	phydev->master_slave_state = MASTER_SLAVE_STATE_UNKNOWN;
+	phydev->master_slave_get = MASTER_SLAVE_CFG_UNKNOWN;
 
 	val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_PMD_BT1_CTRL);
 	if (val < 0)
 		return val;
 
-	if (val & MDIO_PMA_PMD_BT1_CTRL_CFG_MST)
+	if (val & MDIO_PMA_PMD_BT1_CTRL_CFG_MST) {
+		phydev->master_slave_get = MASTER_SLAVE_CFG_MASTER_FORCE;
 		phydev->master_slave_state = MASTER_SLAVE_STATE_MASTER;
-	else
+	} else {
+		phydev->master_slave_get = MASTER_SLAVE_CFG_SLAVE_FORCE;
 		phydev->master_slave_state = MASTER_SLAVE_STATE_SLAVE;
+	}
 
 	return 0;
 }
-- 
2.30.2

