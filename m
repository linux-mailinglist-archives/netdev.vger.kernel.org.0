Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0183520F733
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388970AbgF3O2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730507AbgF3O2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:28:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBCBC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 07:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hwOQAbiVavcGHIRgAgzS4/qg4HjK1PzuxHgHsLa33qs=; b=tAigjBYhygUXvFH770bW024roe
        Cw2SXmhFRBEOZE8ojY/uQ+P3Q79gPEKdcUEh9eyzOPvbmuc79YeyL1PgI9UN1LlcLuMkbJL+gczfZ
        jV1pXHUbpDhryhjTBqsIL0u/3wkpbTQGJXn88OVN2bJSzn57XUz0UhTPGrFZepuyCvhLKLktS1pBc
        Hk/qLGilFvHdk7OvIUlyeGTDjdJtgceQCg509MXoRNLMH2PP/rcVlHcsaeDl7E8O16cVZN6dq3sz4
        WFwnkhdVBSKAREQZmKH8gMLl342zzgyIwD0+TkIfR8OaK2u/6EOMUTC5jOqgiv/ysEI4PGKHioAcH
        15y70fiA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47258 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHFU-0000dH-1d; Tue, 30 Jun 2020 15:28:36 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jqHFT-0006O2-Ol; Tue, 30 Jun 2020 15:28:35 +0100
In-Reply-To: <20200630142754.GC1551@shell.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 01/13] net: phylink: update ethtool reporting for
 fixed-link modes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jqHFT-0006O2-Ol@rmk-PC.armlinux.org.uk>
Date:   Tue, 30 Jun 2020 15:28:35 +0100
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

