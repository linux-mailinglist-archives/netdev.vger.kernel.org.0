Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8251863F6E7
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 18:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiLARyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 12:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiLARyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 12:54:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89180A1C09
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 09:53:05 -0800 (PST)
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <l.stach@pengutronix.de>)
        id 1p0nk6-0001KI-SP; Thu, 01 Dec 2022 18:53:02 +0100
From:   Lucas Stach <l.stach@pengutronix.de>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de
Subject: [PATCH] net: phylink: don't try to stop halted PHY
Date:   Thu,  1 Dec 2022 18:53:02 +0100
Message-Id: <20221201175302.2732938-1-l.stach@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::28
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the PHY driver has encountered a non-recoverable error condition, e.g
due to a failure in MDIO communication it may have already halted the PHY
by calling phy_error(). If that is the case then phylink should not try to
stop the PHY again.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/net/phy/phylink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6547b6cc6cbe..1e2be9197567 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1935,7 +1935,7 @@ void phylink_stop(struct phylink *pl)
 
 	if (pl->sfp_bus)
 		sfp_upstream_stop(pl->sfp_bus);
-	if (pl->phydev)
+	if (pl->phydev && phy_is_started(pl->phydev))
 		phy_stop(pl->phydev);
 	del_timer_sync(&pl->link_poll);
 	if (pl->link_irq) {
-- 
2.30.2

