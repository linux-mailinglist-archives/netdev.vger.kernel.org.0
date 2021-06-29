Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FDC3B6DB7
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 06:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhF2EqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 00:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhF2EqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 00:46:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD20C061766
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 21:43:35 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ly5ae-0003Tm-Vo; Tue, 29 Jun 2021 06:43:16 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ly5aV-0008QB-Dr; Tue, 29 Jun 2021 06:43:07 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v1 1/1] net: usb: asix: ax88772: suspend PHY on driver probe
Date:   Tue, 29 Jun 2021 06:43:05 +0200
Message-Id: <20210629044305.32322-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After probe/bind sequence is the PHY in active state, even if interface
is stopped. As result, on some systems like Samsung Exynos5250 SoC based Arndale
board, the ASIX PHY will be able to negotiate the link but fail to
transmit the data.

To handle it, suspend the PHY on probe.

Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/net/usb/asix_devices.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index aec97b021a73..2c115216420a 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -701,6 +701,7 @@ static int ax88772_init_phy(struct usbnet *dev)
 		return ret;
 	}
 
+	phy_suspend(priv->phydev);
 	priv->phydev->mac_managed_pm = 1;
 
 	phy_attached_info(priv->phydev);
-- 
2.30.2

