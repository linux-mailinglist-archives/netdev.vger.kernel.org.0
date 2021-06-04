Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B680139BA0F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 15:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhFDNow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 09:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhFDNon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 09:44:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7B3C061787
        for <netdev@vger.kernel.org>; Fri,  4 Jun 2021 06:42:57 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lpA63-00072q-HA; Fri, 04 Jun 2021 15:42:47 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lpA61-0000fv-LY; Fri, 04 Jun 2021 15:42:45 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v1 6/7] net: phy: do not print dump stack if device was removed
Date:   Fri,  4 Jun 2021 15:42:43 +0200
Message-Id: <20210604134244.2467-7-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210604134244.2467-1-o.rempel@pengutronix.de>
References: <20210604134244.2467-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case phy_state_machine() works on top of USB device, we can get -ENODEV
at any point. So, be less noisy if device was removed.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/phy/phy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 1f0512e39c65..1089a93d12f6 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -1136,6 +1136,9 @@ void phy_state_machine(struct work_struct *work)
 	else if (do_suspend)
 		phy_suspend(phydev);
 
+	if (err == -ENODEV)
+		return;
+
 	if (err < 0)
 		phy_error(phydev);
 
-- 
2.29.2

