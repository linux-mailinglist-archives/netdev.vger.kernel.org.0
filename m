Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6744C871D
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 09:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbiCAIwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 03:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiCAIwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 03:52:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A9889301
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 00:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IUoG9ySu/a7PVL97yD3VeZpdK4UyVPoWIOL5rg6oNUY=; b=kjmdbBtDxE59/z/EPTjooABjaL
        gHyA5n9NpEzpKNmWZ/S6XG3t9ZPjhLRvX8CYJQFKZVJy0ho7KblYgzi1Ox8DtGX3mBCnPCxhB49kc
        A8vPTi4I6jl7ya5kDFhDKxcr9NDe7feuD62zqRsxByLgL9AHk0ioI2TbjVeDy7VbAFSEEK62isXz+
        t+KI1tXFI5vxSbcgveNmt8gk5EI0hgStV3tZIJBtXiaRuoBpO/ZJjwkBz8N9IhRzjrWVTYVGA+K4i
        +WGSGM7CtKuIsjR28wZouybKiiM2sq7sUR1ivJjSdbNaKebQDnk6sSCuVwYjr9Evxc83uPEvrAqRZ
        6rOC5LTw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40826 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nOyEJ-00010l-6z; Tue, 01 Mar 2022 08:51:35 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nOyEI-00Buu8-K9; Tue, 01 Mar 2022 08:51:34 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: phylink: use %pe for printing errors
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nOyEI-00Buu8-K9@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 01 Mar 2022 08:51:34 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert phylink to use %pe for printing error codes, which can print
them as errno symbols rather than numbers.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e0cd11e17e90..33c285252584 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1182,9 +1182,8 @@ static int phylink_register_sfp(struct phylink *pl,
 
 	bus = sfp_bus_find_fwnode(fwnode);
 	if (IS_ERR(bus)) {
-		ret = PTR_ERR(bus);
-		phylink_err(pl, "unable to attach SFP bus: %d\n", ret);
-		return ret;
+		phylink_err(pl, "unable to attach SFP bus: %pe\n", bus);
+		return PTR_ERR(bus);
 	}
 
 	pl->sfp_bus = bus;
@@ -1380,11 +1379,11 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 
 	ret = phylink_validate(pl, supported, &config);
 	if (ret) {
-		phylink_warn(pl, "validation of %s with support %*pb and advertisement %*pb failed: %d\n",
+		phylink_warn(pl, "validation of %s with support %*pb and advertisement %*pb failed: %pe\n",
 			     phy_modes(config.interface),
 			     __ETHTOOL_LINK_MODE_MASK_NBITS, phy->supported,
 			     __ETHTOOL_LINK_MODE_MASK_NBITS, config.advertising,
-			     ret);
+			     ERR_PTR(ret));
 		return ret;
 	}
 
@@ -2583,8 +2582,9 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 	/* Ignore errors if we're expecting a PHY to attach later */
 	ret = phylink_validate(pl, support, &config);
 	if (ret) {
-		phylink_err(pl, "validation with support %*pb failed: %d\n",
-			    __ETHTOOL_LINK_MODE_MASK_NBITS, support, ret);
+		phylink_err(pl, "validation with support %*pb failed: %pe\n",
+			    __ETHTOOL_LINK_MODE_MASK_NBITS, support,
+			    ERR_PTR(ret));
 		return ret;
 	}
 
@@ -2600,10 +2600,12 @@ static int phylink_sfp_config(struct phylink *pl, u8 mode,
 	linkmode_copy(support1, support);
 	ret = phylink_validate(pl, support1, &config);
 	if (ret) {
-		phylink_err(pl, "validation of %s/%s with support %*pb failed: %d\n",
+		phylink_err(pl,
+			    "validation of %s/%s with support %*pb failed: %pe\n",
 			    phylink_an_mode_str(mode),
 			    phy_modes(config.interface),
-			    __ETHTOOL_LINK_MODE_MASK_NBITS, support, ret);
+			    __ETHTOOL_LINK_MODE_MASK_NBITS, support,
+			    ERR_PTR(ret));
 		return ret;
 	}
 
-- 
2.30.2

