Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8112DFE627
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKOUFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:05:52 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50090 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfKOUFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:05:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kNqOOZ29zBbUm3v6u7wjVYsjCgq4wgjNa7TCRZqQV7A=; b=TVSWnuAFiT/7lMeko4e1XKlKd5
        edsZEvLYHCo0Y36dBzFn/w0Hm/CDL0pQbyYHERgFDgUjDIDlGEykixCvu7iwIybfFbZ1+FgR86+0d
        X2i+k2nOPrhJhVXOHeqzpsZfb6VmnAhCVi2yGKFRPkaz/kY4zgp5hPLOKTV+mF3arT1QSI7yxO6KA
        aRtQtjNgX7ldTgJEkTXN21rCjDSlKhXP5gsTeOknMK5WytzZNtShtZBgx80tnKsinlH59OrT9eoa/
        bxMrY4G1uhqfRFwj8iq1GheT5qUxooToauDUercLwCLsUdeK5zY8u6P/TE82B0wpjkcjf9ihOzAQ6
        uk7UULNg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:55184 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iVhqj-0003A3-SQ; Fri, 15 Nov 2019 20:05:45 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iVhqj-0007eY-8u; Fri, 15 Nov 2019 20:05:45 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] net: phylink: update to use phy_support_asym_pause()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iVhqj-0007eY-8u@rmk-PC.armlinux.org.uk>
Date:   Fri, 15 Nov 2019 20:05:45 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use phy_support_asym_pause() rather than open-coding it.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 2b70b4d50573..a68d664b65a3 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -697,11 +697,6 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
 	int ret;
 
-	memset(&config, 0, sizeof(config));
-	linkmode_copy(supported, phy->supported);
-	linkmode_copy(config.advertising, phy->advertising);
-	config.interface = pl->link_config.interface;
-
 	/*
 	 * This is the new way of dealing with flow control for PHYs,
 	 * as described by Timur Tabi in commit 529ed1275263 ("net: phy:
@@ -709,10 +704,12 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy)
 	 * using our validate call to the MAC, we rely upon the MAC
 	 * clearing the bits from both supported and advertising fields.
 	 */
-	if (phylink_test(supported, Pause))
-		phylink_set(config.advertising, Pause);
-	if (phylink_test(supported, Asym_Pause))
-		phylink_set(config.advertising, Asym_Pause);
+	phy_support_asym_pause(phy);
+
+	memset(&config, 0, sizeof(config));
+	linkmode_copy(supported, phy->supported);
+	linkmode_copy(config.advertising, phy->advertising);
+	config.interface = pl->link_config.interface;
 
 	ret = phylink_validate(pl, supported, &config);
 	if (ret)
-- 
2.20.1

