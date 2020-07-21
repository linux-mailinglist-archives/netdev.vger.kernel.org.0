Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8112E227E09
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgGULE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgGULE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 07:04:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C639DC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 04:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GPFBs7zG0CaaCQxaMsWwrtEWYfSQUhkh43pHFQOIfsI=; b=oSsSrBg4yiYcx2RDC4jYsOyUVd
        pOkiPvrY4e7M2vieruj4UUcgEU6sYCGsUaE02aavIqlA+ZNWKnGVoU3IU2uqTylDxxQ+7zuzF19Mp
        OdhIliWluu7rdiZz3aMwnwrtCWhlfTGBQ+L2d6mxA5hUC3MWcdF4IJo1bBDdY8f7U+6YhKa6V8YvT
        q8xHfnDK+AekHDAaYPEayb6upMzlAbww6JvRTOvsbxMjUXVpo56g6VjVxob2p0X35oZz+rZauKUC8
        5n11AUWp0M5Bpg78HL8/T9F0jsgwun5P3NN7g5xBcCrf/XNZ5636AVZvlOS4ODGQeIXoWhpYyKsOA
        VW5YZ4GQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41772 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq4Q-0004G5-G2; Tue, 21 Jul 2020 12:04:26 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq4Q-0004SY-9J; Tue, 21 Jul 2020 12:04:26 +0100
In-Reply-To: <20200721110152.GY1551@shell.armlinux.org.uk>
References: <20200721110152.GY1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 09/14] net: phylink: use config.an_enabled in
 ksettings_set method
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jxq4Q-0004SY-9J@rmk-PC.armlinux.org.uk>
Date:   Tue, 21 Jul 2020 12:04:26 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than recomputing whether AN is enabled, use config.an_enabled.

Suggested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 967c068d16c8..6cb9ca74341b 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1400,8 +1400,7 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
 	pl->link_config.interface = config.interface;
 	pl->link_config.speed = config.speed;
 	pl->link_config.duplex = config.duplex;
-	pl->link_config.an_enabled = kset->base.autoneg !=
-				     AUTONEG_DISABLE;
+	pl->link_config.an_enabled = config.an_enabled;
 
 	if (pl->cur_link_an_mode == MLO_AN_INBAND &&
 	    !test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state)) {
-- 
2.20.1

