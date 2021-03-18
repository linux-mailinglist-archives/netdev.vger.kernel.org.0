Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE551340E94
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhCRTpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 15:45:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhCRTon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:44:43 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCED7C06174A;
        Thu, 18 Mar 2021 12:44:42 -0700 (PDT)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3441622205;
        Thu, 18 Mar 2021 20:44:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1616096680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=v7ksl+kurvJgbjPoQHc3k4xJE2CxKPb0gHgeIYEuAjU=;
        b=Sc6QXNeWvQdco/Yg7+0u5Tik1A5L40xQuFgK7pPsRuu1AawW6Pggxqc7OIjbwdCWNGwlfA
        /A/kLfy+qA66380xn9nPXmxj4bC66i6G71aQicQ82YTbp8WOY/UgvEgLz2B2g0ItoM71c2
        HUcd0ovnUEnHJvRYl6hQyyjQVLn1EKg=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next] net: phy: at803x: remove at803x_aneg_done()
Date:   Thu, 18 Mar 2021 20:44:31 +0100
Message-Id: <20210318194431.14811-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is what Vladimir says about it:

  at803x_aneg_done() keeps the aneg reporting as "not done" even when
  the copper-side link was reported as up, but the in-band autoneg has
  not finished.

  That was the _intended_ behavior when that code was introduced, and
  Heiner have said about it [1]:

  | That's not nice from the PHY:
  | It signals "link up", and if the system asks the PHY for link details,
  | then it sheepishly says "well, link is *almost* up".

  If the specification of phy_aneg_done behavior does not include
  in-band autoneg (and it doesn't), then this piece of code does not
  belong here.

  The fact that we can no longer trigger this code from phylib is yet
  another reason why it fails at its intended (and wrong) purpose and
  should be removed.

Removing the SGMII link check, would just keep the call to
genphy_aneg_done(), which is also the fallback. Thus we can just remove
at803x_aneg_done() altogether.

[1] https://lore.kernel.org/netdev/fdf0074a-2572-5914-6f3e-77202cbf96de@gmail.com/

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/at803x.c | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index c2aa4c92edde..d7799beb811c 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -751,36 +751,6 @@ static void at803x_link_change_notify(struct phy_device *phydev)
 	}
 }
 
-static int at803x_aneg_done(struct phy_device *phydev)
-{
-	int ccr;
-
-	int aneg_done = genphy_aneg_done(phydev);
-	if (aneg_done != BMSR_ANEGCOMPLETE)
-		return aneg_done;
-
-	/*
-	 * in SGMII mode, if copper side autoneg is successful,
-	 * also check SGMII side autoneg result
-	 */
-	ccr = phy_read(phydev, AT803X_REG_CHIP_CONFIG);
-	if ((ccr & AT803X_MODE_CFG_MASK) != AT803X_MODE_CFG_SGMII)
-		return aneg_done;
-
-	/* switch to SGMII/fiber page */
-	phy_write(phydev, AT803X_REG_CHIP_CONFIG, ccr & ~AT803X_BT_BX_REG_SEL);
-
-	/* check if the SGMII link is OK. */
-	if (!(phy_read(phydev, AT803X_PSSR) & AT803X_PSSR_MR_AN_COMPLETE)) {
-		phydev_warn(phydev, "803x_aneg_done: SGMII link is not ok\n");
-		aneg_done = 0;
-	}
-	/* switch back to copper page */
-	phy_write(phydev, AT803X_REG_CHIP_CONFIG, ccr | AT803X_BT_BX_REG_SEL);
-
-	return aneg_done;
-}
-
 static int at803x_read_status(struct phy_device *phydev)
 {
 	int ss, err, old_link = phydev->link;
@@ -1198,7 +1168,6 @@ static struct phy_driver at803x_driver[] = {
 	.resume			= at803x_resume,
 	/* PHY_GBIT_FEATURES */
 	.read_status		= at803x_read_status,
-	.aneg_done		= at803x_aneg_done,
 	.config_intr		= &at803x_config_intr,
 	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
-- 
2.20.1

