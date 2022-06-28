Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA1C55C7DE
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344520AbiF1LpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 07:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345277AbiF1LpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 07:45:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BED34B8A
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 04:44:02 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o69dJ-0007K8-Qv; Tue, 28 Jun 2022 13:43:53 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o69dD-003C6P-KH; Tue, 28 Jun 2022 13:43:51 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o69dG-00GUMp-Dl; Tue, 28 Jun 2022 13:43:50 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH net v3 1/1] net: phy: ax88772a: fix lost pause advertisement configuration
Date:   Tue, 28 Jun 2022 13:43:49 +0200
Message-Id: <20220628114349.3929928-1-o.rempel@pengutronix.de>
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
PHY, so we need use phy_init_hw() to reinit PHY configuration.

Fixes: dde258469257 ("net: usb/phy: asix: add support for ax88772A/C PHYs")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
changes v3:
- resend against net
- add Reviewed-by: Andrew Lunn <andrew@lunn.ch>

changes v2:
- use phy_init_hw() and phy_start_aneg() instead of saving restoring
  register.

 drivers/net/phy/ax88796b.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/ax88796b.c b/drivers/net/phy/ax88796b.c
index 457896337505..0f1e617a26c9 100644
--- a/drivers/net/phy/ax88796b.c
+++ b/drivers/net/phy/ax88796b.c
@@ -88,8 +88,10 @@ static void asix_ax88772a_link_change_notify(struct phy_device *phydev)
 	/* Reset PHY, otherwise MII_LPA will provide outdated information.
 	 * This issue is reproducible only with some link partner PHYs
 	 */
-	if (phydev->state == PHY_NOLINK && phydev->drv->soft_reset)
-		phydev->drv->soft_reset(phydev);
+	if (phydev->state == PHY_NOLINK) {
+		phy_init_hw(phydev);
+		phy_start_aneg(phydev);
+	}
 }
 
 static struct phy_driver asix_driver[] = {
-- 
2.30.2

