Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B392C65CB
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 13:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgK0Mgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 07:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728661AbgK0Mgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 07:36:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5D5C0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 04:36:31 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kiczD-0000GK-IO; Fri, 27 Nov 2020 13:36:27 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kiczA-00088f-Hn; Fri, 27 Nov 2020 13:36:24 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v1] net: phy: micrel: fix interrupt handling
Date:   Fri, 27 Nov 2020 13:36:21 +0100
Message-Id: <20201127123621.31234-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After migration to the shared interrupt support, the KSZ8031 PHY with
enabled interrupt support was not able to notify about link status
change.

Fixes: 59ca4e58b917 ("net: phy: micrel: implement generic .handle_interrupt() callback")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/micrel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 97f08f20630b..54e0d75203da 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -207,7 +207,7 @@ static irqreturn_t kszphy_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 
-	if ((irq_status & KSZPHY_INTCS_STATUS))
+	if (!(irq_status & KSZPHY_INTCS_STATUS))
 		return IRQ_NONE;
 
 	phy_trigger_machine(phydev);
-- 
2.29.2

