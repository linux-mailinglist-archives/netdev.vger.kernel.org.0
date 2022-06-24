Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F1F559470
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 09:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiFXH4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 03:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiFXH4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 03:56:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E60F69FBA
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 00:56:08 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o4eAa-0006PA-Ql; Fri, 24 Jun 2022 09:56:00 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o4eAY-002Nyq-Lj; Fri, 24 Jun 2022 09:56:00 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o4eAZ-00DBFf-7O; Fri, 24 Jun 2022 09:55:59 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH net-next v1 1/1] net: phy: ax88772a: fix lost pause advertisement configuration
Date:   Fri, 24 Jun 2022 09:55:58 +0200
Message-Id: <20220624075558.3141464-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
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

In case of asix_ax88772a_link_change_notify() workaround, we run soft
reset which will automatically clear MII_ADVERTISE configuration. The
PHYlib framework do not know about changed configuration state of the
PHY, so we need to save and restore all needed configuration registers.

Fixes: dde258469257 ("net: usb/phy: asix: add support for ax88772A/C PHYs")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/ax88796b.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/ax88796b.c b/drivers/net/phy/ax88796b.c
index 457896337505..6971d0196917 100644
--- a/drivers/net/phy/ax88796b.c
+++ b/drivers/net/phy/ax88796b.c
@@ -18,6 +18,11 @@ MODULE_DESCRIPTION("Asix PHY driver");
 MODULE_AUTHOR("Michael Schmitz <schmitzmic@gmail.com>");
 MODULE_LICENSE("GPL");
 
+struct asix_context {
+	u16 bmcr;
+	u16 advertise;
+};
+
 /**
  * asix_soft_reset - software reset the PHY via BMCR_RESET bit
  * @phydev: target phy_device struct
@@ -83,13 +88,43 @@ static int asix_ax88772a_read_status(struct phy_device *phydev)
 	return 0;
 }
 
+/* save relevant PHY registers to private copy */
+static void asix_context_save(struct phy_device *phydev,
+			      struct asix_context *context)
+{
+	context->bmcr = phy_read(phydev, MII_BMCR);
+	context->advertise = phy_read(phydev, MII_ADVERTISE);
+}
+
+/* restore relevant PHY registers from private copy */
+static void asix_context_restore(struct phy_device *phydev,
+				 const struct asix_context *context)
+{
+	u16 bmcr = context->bmcr;
+
+	phy_write(phydev, MII_ADVERTISE, context->advertise);
+
+	/* after all settings are restored, restart autoneg */
+	if (phydev->autoneg == AUTONEG_ENABLE)
+		bmcr |= BMCR_ANRESTART;
+
+	phy_write(phydev, MII_BMCR, bmcr);
+}
+
 static void asix_ax88772a_link_change_notify(struct phy_device *phydev)
 {
 	/* Reset PHY, otherwise MII_LPA will provide outdated information.
 	 * This issue is reproducible only with some link partner PHYs
 	 */
-	if (phydev->state == PHY_NOLINK && phydev->drv->soft_reset)
+	if (phydev->state == PHY_NOLINK && phydev->drv->soft_reset) {
+		struct asix_context context;
+
+		asix_context_save(phydev, &context);
+
 		phydev->drv->soft_reset(phydev);
+
+		asix_context_restore(phydev, &context);
+	}
 }
 
 static struct phy_driver asix_driver[] = {
-- 
2.30.2

