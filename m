Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B608911D44E
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 18:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbfLLRnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 12:43:50 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33766 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbfLLRnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 12:43:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sw4p6TAUZstPkwM79xeq2y+f96wNSSWZzvjddm1ewWg=; b=f8ZHgUKqzSgFT2Rv35K30TBxsS
        6gO1K3L0uk1xZ44dtmMDH4+jeXnjBZtm5QswUX6t0uLCNhTlj2Bjd6n6Z8x5fAroYe6v1m8WLFboZ
        0CFeXvxAx7/Hv3Ybt4xp3R3BB/jcyQDcnZ/bggjHHKIDesP2NHICPKzv9QHSOy7P9FelfT7rjNFkp
        E7qFu1sltOrqNEFQ7n685YxM6Y5a+/Za13YqR7Qcl8LJ4p7cIp1IPU1wfRDDVppPzwbAoObPTlq8c
        UDhZc+NsrXBfQsV8n+caXv2vh2hWO6vbZN6y/dqjYFlzCNGHGKCLCn+rWi3GguUS7p3qZ5oh1JcjS
        CXjmpIjQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:33586 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ifSV4-0008CO-LS; Thu, 12 Dec 2019 17:43:42 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ifSV3-0000at-JR; Thu, 12 Dec 2019 17:43:41 +0000
In-Reply-To: <20191212174309.GM25745@shell.armlinux.org.uk>
References: <20191212174309.GM25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/3] net: phylink: extend clause 45 PHY validation
 workaround
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ifSV3-0000at-JR@rmk-PC.armlinux.org.uk>
Date:   Thu, 12 Dec 2019 17:43:41 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e45d1f5288b8 ("net: phylink: support Clause 45 PHYs on SFP+
modules") added a workaround to support clause 45 PHYs which
dynamically switch their interface mode on SFP+ modules.  This was
implemented by validating the PHYs supported/advertising using
PHY_INTERFACE_MODE_NA, rather than the specific interface mode that
we attached the PHY with.

However, we already have a situation where phylink is used to connect
a Marvell 88X3310 PHY which also behaves in exactly the same way, but
which seemingly doesn't need this.  The reason seems to be that the
mvpp2 driver sets a whole bunch of link modes for
PHY_INTERFACE_MODE_10GKR down to 10Mb/s, despite 10GBASE-R not actually
supporting anything but 10Gb/s speeds.

When testing with drivers that (correctly) take the mvneta approach,
where the validate() method only returns what can be supported /
advertised for the specified link mode, we find that Clause 45 PHYs do
not behave as we expect: their advertisement is restricted to what
the current link will support, rather than what the PHY supports
through its dynamic switching.

Extend this workaround to all such cases; if we have a Clause 45 PHY
attaching via any means, except in USXGMII, XAUI and RXAUI which are
all unable to support this dynamic switching or have other solutions
to it, then we need to validate using PHY_INTERFACE_MODE_NA.

This should allow mvpp2 to switch to a more conformant validate()
implementation.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 2e5bc63c1dfa..896772694bf4 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -735,7 +735,19 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	memset(&config, 0, sizeof(config));
 	linkmode_copy(supported, phy->supported);
 	linkmode_copy(config.advertising, phy->advertising);
-	config.interface = interface;
+
+	/* Clause 45 PHYs switch their Serdes lane between several different
+	 * modes, normally 10GBASE-R, SGMII. Some use 2500BASE-X for 2.5G
+	 * speeds. We really need to know which interface modes the PHY and
+	 * MAC supports to properly work out which linkmodes can be supported.
+	 */
+	if (phy->is_c45 &&
+	    interface != PHY_INTERFACE_MODE_RXAUI &&
+	    interface != PHY_INTERFACE_MODE_XAUI &&
+	    interface != PHY_INTERFACE_MODE_USXGMII)
+		config.interface = PHY_INTERFACE_MODE_NA;
+	else
+		config.interface = interface;
 
 	ret = phylink_validate(pl, supported, &config);
 	if (ret)
@@ -1904,14 +1916,6 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 	if (ret < 0)
 		return ret;
 
-	/* Clause 45 PHYs switch their Serdes lane between several different
-	 * modes, normally 10GBASE-R, SGMII. Some use 2500BASE-X for 2.5G
-	 * speeds.  We really need to know which interface modes the PHY and
-	 * MAC supports to properly work out which linkmodes can be supported.
-	 */
-	if (phy->is_c45)
-		interface = PHY_INTERFACE_MODE_NA;
-
 	ret = phylink_bringup_phy(pl, phy, interface);
 	if (ret)
 		phy_detach(phy);
-- 
2.20.1

