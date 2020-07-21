Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F74227E01
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbgGULDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgGULDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 07:03:47 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA735C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 04:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jWnuTgvrY16Y8YFH+7MVW5urbwsQdUOnF2txdRWbrM8=; b=fOOZuxit6MW/TIvJlbFk0eStyo
        /8nIfw8NgKwZrkb1vFt6Q5bODeI0g5V0Pn471YgMF2LKeUWAdMZxEKSawHOCvoGXBGs9HKqswC/1F
        3VSl2U0G7KUScSiDacVj4IcuvBSAbxRItmiIwUinuvn3FlFwtfbzR3zvmmhtAUaQKhN4rofEquAN1
        i6uODs7m72u/W4zKWu1WAy6kV5A9ysRrtHmQBxcm0hCTc/UpZTjt+lY8RhMpSTJMFlILfa6F0k1JG
        jhB7DgE4YFZc3BPVFnEkusl0nG5ptXDCw2YByOjBY2fYaj0EgKauQ6D8uFdJZu3KgQU2/ycal830R
        phvOJHqw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41754 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq3l-0004E1-It; Tue, 21 Jul 2020 12:03:45 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jxq3l-0004Qq-B4; Tue, 21 Jul 2020 12:03:45 +0100
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
Subject: [PATCH net-next 01/14] net: phylink: update ethtool reporting for
 fixed-link modes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jxq3l-0004Qq-B4@rmk-PC.armlinux.org.uk>
Date:   Tue, 21 Jul 2020 12:03:45 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Comparing the ethtool output from phylink and non-phylink fixed-link
setups shows that we have some differences:

- The "auto-negotiation" fields are different; phylink reports these
  as "No", non-phylink reports these as "Yes" for the supported and
  advertising masks.
- The link partner advertisement is set to the link speed with non-
  phylink, but phylink leaves this unset, causing all link partner
  fields to be omitted.

The phylink ethtool output also disagrees with the software emulated
PHY dump via the MII registers.

Update the phylink fixed-link parsing code so that we better reflect
the behaviour of the non-phylink code that this facility replaces, and
bring the ethtool interface more into line with the report from via the
MII interface.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index dae6c8b51d7f..0fd5a11966aa 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -241,8 +241,10 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 	phylink_set(pl->supported, MII);
 	phylink_set(pl->supported, Pause);
 	phylink_set(pl->supported, Asym_Pause);
+	phylink_set(pl->supported, Autoneg);
 	if (s) {
 		__set_bit(s->bit, pl->supported);
+		__set_bit(s->bit, pl->link_config.lp_advertising);
 	} else {
 		phylink_warn(pl, "fixed link %s duplex %dMbps not recognised\n",
 			     pl->link_config.duplex == DUPLEX_FULL ? "full" : "half",
-- 
2.20.1

