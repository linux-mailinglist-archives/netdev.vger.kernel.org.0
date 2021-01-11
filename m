Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3942F0EA7
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 10:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbhAKJAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 04:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727623AbhAKJAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 04:00:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9314C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 00:59:39 -0800 (PST)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kyt31-0007ue-AL; Mon, 11 Jan 2021 09:59:35 +0100
Received: from mfe by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kyt30-0007Td-9U; Mon, 11 Jan 2021 09:59:34 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] net: phy: smsc: fix clk error handling
Date:   Mon, 11 Jan 2021 09:59:32 +0100
Message-Id: <20210111085932.28680-1-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in
support") added the phy clk support. The commit already checks if
clk_get_optional() throw an error but instead of returning the error it
ignores it.

Fixes: bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in support")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/net/phy/smsc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 0fc39ac5ca88..10722fed666d 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -284,7 +284,8 @@ static int smsc_phy_probe(struct phy_device *phydev)
 	/* Make clk optional to keep DTB backward compatibility. */
 	priv->refclk = clk_get_optional(dev, NULL);
 	if (IS_ERR(priv->refclk))
-		dev_err_probe(dev, PTR_ERR(priv->refclk), "Failed to request clock\n");
+		return dev_err_probe(dev, PTR_ERR(priv->refclk),
+				     "Failed to request clock\n");
 
 	ret = clk_prepare_enable(priv->refclk);
 	if (ret)
-- 
2.20.1

