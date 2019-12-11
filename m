Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED96511A95A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbfLKK4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:56:33 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39534 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfLKK4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 05:56:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BaRt3zkXeQpA6ZzHW9rSxLgADksdD7w3vGQxv6HKP6k=; b=FlXVaBiSLBdvJHApiht+GIQCH7
        RTK9bU4QzBXHVmZL8scSmyWNDoBeg16tGySYK6RvsKoEuz/Jk4Kll6BsSbBpWfpPzAHE9/hhpv7gY
        0UjLDyAkdU+/+tg0uP+Xp4DiNzsZH7NOAZU96AaHNJ+m6r2/hSkVL2Jt2XU5EcR5CUNCtoYajRSVV
        gpkgjFVQBo0wlSmVSngsPtsYp7pKirKDHgDnKhIM3PE2tNLfmU1FYr1B6p6MLVSygkrxlZfhroRhm
        +sxDek326RXCn+bvzu9dg0sbL4eg65Lvt1dEy9OBSKU6o7MMjmZ39BW/J/YTkgD9NMUw/HkHfUZDl
        3TCNKMpw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60978 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfF-0007um-1x; Wed, 11 Dec 2019 10:56:17 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfC-0002y6-Tx; Wed, 11 Dec 2019 10:56:14 +0000
In-Reply-To: <20191211104821.GB25745@shell.armlinux.org.uk>
References: <20191211104821.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 05/14] net: sfp: move phy_start()/phy_stop() to
 phylink
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iezfC-0002y6-Tx@rmk-PC.armlinux.org.uk>
Date:   Wed, 11 Dec 2019 10:56:14 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move phy_start() and phy_stop() into the module_start and module_stop
notifications in phylink, rather than having them in the SFP code.
This gives phylink responsibility for controlling the PHY, rather
than having SFP start and stop the PHY state machine.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 22 ++++++++++++++++++++++
 drivers/net/phy/sfp.c     |  2 --
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index d02eb83ed151..8c3fafebe667 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1770,6 +1770,26 @@ static int phylink_sfp_module_insert(void *upstream,
 	return ret;
 }
 
+static int phylink_sfp_module_start(void *upstream)
+{
+	struct phylink *pl = upstream;
+
+	/* If this SFP module has a PHY, start the PHY now. */
+	if (pl->phydev)
+		phy_start(pl->phydev);
+
+	return 0;
+}
+
+static void phylink_sfp_module_stop(void *upstream)
+{
+	struct phylink *pl = upstream;
+
+	/* If this SFP module has a PHY, stop it. */
+	if (pl->phydev)
+		phy_stop(pl->phydev);
+}
+
 static void phylink_sfp_link_down(void *upstream)
 {
 	struct phylink *pl = upstream;
@@ -1805,6 +1825,8 @@ static const struct sfp_upstream_ops sfp_phylink_ops = {
 	.attach = phylink_sfp_attach,
 	.detach = phylink_sfp_detach,
 	.module_insert = phylink_sfp_module_insert,
+	.module_start = phylink_sfp_module_start,
+	.module_stop = phylink_sfp_module_stop,
 	.link_up = phylink_sfp_link_up,
 	.link_down = phylink_sfp_link_down,
 	.connect_phy = phylink_sfp_connect_phy,
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 23f30dac0f17..d7d2c797c89c 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1396,7 +1396,6 @@ static void sfp_sm_mod_next(struct sfp *sfp, unsigned int state,
 
 static void sfp_sm_phy_detach(struct sfp *sfp)
 {
-	phy_stop(sfp->mod_phy);
 	sfp_remove_phy(sfp->sfp_bus);
 	phy_device_remove(sfp->mod_phy);
 	phy_device_free(sfp->mod_phy);
@@ -1427,7 +1426,6 @@ static void sfp_sm_probe_phy(struct sfp *sfp)
 	}
 
 	sfp->mod_phy = phy;
-	phy_start(phy);
 }
 
 static void sfp_sm_link_up(struct sfp *sfp)
-- 
2.20.1

