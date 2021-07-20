Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7094F3CF8AD
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 13:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbhGTKf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 06:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237203AbhGTKet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 06:34:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D31CC061574
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 04:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rCt2t+FVANprQXZt+2rtxxiPOcfTuksboDRXytvqaBo=; b=ZSL5BKUN5CnnQ4UTEK7ijT3dpg
        qcU8NxAKswuuLAXqdqF2nuJXjjL0884ba9RPlM6FpZy7yqhhqjw+T1fFAr7YCrsSdb+gYQdzg5mRF
        JQYHpLVJ6SKyNaZPYhT5BQXveopabVxAcvrCaSmFaiLCQDx8r8yRD2ZOVz+MUHRoDNMKGVbL8VSNp
        9SyIyLeo8ZFiQVXQN0yWVjEfU6cuWD0uABUZ9+rJFBfXy0KgETGtW1qUfKkjCHU6ygZeJgu+pAWHB
        5xh/T9w9/uLXAPSUCmKXoyLsWNRO7Ac3biLpSoYxGmizUeIc7pLitlF4Kfmx73jylXgHuIMAw1AeE
        +MZfGg+A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53938 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m5nig-0006FE-8u; Tue, 20 Jul 2021 12:15:26 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1m5nig-0003N1-1f; Tue, 20 Jul 2021 12:15:26 +0100
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phylink: cleanup ksettings_set
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1m5nig-0003N1-1f@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 20 Jul 2021 12:15:26 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We only need to fiddle about with the supported mask after we have
validated the user's requested parameters. Simplify and streamline the
code by moving the linkmode copy and update of the autoneg bit after
validating the user's request.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 728eab380fd3..2cdf9f989dec 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1458,15 +1458,11 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		return phy_ethtool_ksettings_set(pl->phydev, kset);
 	}
 
-	linkmode_copy(support, pl->supported);
 	config = pl->link_config;
-	config.an_enabled = kset->base.autoneg == AUTONEG_ENABLE;
 
-	/* Mask out unsupported advertisements, and force the autoneg bit */
+	/* Mask out unsupported advertisements */
 	linkmode_and(config.advertising, kset->link_modes.advertising,
-		     support);
-	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising,
-			 config.an_enabled);
+		     pl->supported);
 
 	/* FIXME: should we reject autoneg if phy/mac does not support it? */
 	switch (kset->base.autoneg) {
@@ -1475,7 +1471,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 		 * duplex.
 		 */
 		s = phy_lookup_setting(kset->base.speed, kset->base.duplex,
-				       support, false);
+				       pl->supported, false);
 		if (!s)
 			return -EINVAL;
 
@@ -1516,6 +1512,12 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	/* We have ruled out the case with a PHY attached, and the
 	 * fixed-link cases.  All that is left are in-band links.
 	 */
+	config.an_enabled = kset->base.autoneg == AUTONEG_ENABLE;
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, config.advertising,
+			 config.an_enabled);
+
+	/* Validate without changing the current supported mask. */
+	linkmode_copy(support, pl->supported);
 	if (phylink_validate(pl, support, &config))
 		return -EINVAL;
 
-- 
2.20.1

