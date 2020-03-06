Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D58B17BE75
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCFN3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:29:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49402 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbgCFN3e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:29:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=THBmUdYwPRAU7pfGzm8vcATV+y44rHXjYSfjuxYGB/M=; b=k7SJ/h/4pgZqmaQ/H0hEegc1Et
        y0m5qYo+nMKRqYAHbX3KisJT7icfR3d29tDx40yDydllXYCXI964yTKTxFHd4OZRGuiK0lsbw/Ky5
        WHsuecXs5R1DV5GkTdBZ5/eD1ERNDcNlhV04VvdCvSAXy5nN80MTbbZrfOoITEWab3So=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jAD2c-0004uM-BC; Fri, 06 Mar 2020 14:29:26 +0100
Date:   Fri, 6 Mar 2020 14:29:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 0/10] net: dsa: improve serdes integration
Message-ID: <20200306132926.GA18310@lunn.ch>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
 <20200305225407.GD25183@lunn.ch>
 <20200305234557.GE25745@shell.armlinux.org.uk>
 <20200306011310.GC2450@lunn.ch>
 <20200306035720.GD2450@lunn.ch>
 <20200306103934.GF25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306103934.GF25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Unfortunately, that means that CPU and DSA ports without a fixed-link
> spec will stay down because phylink won't call mac_link_up() - so we're
> back to the poor integration of phylink for CPU and DSA ports problem.
> Even if phylink /were/ to call mac_link_up() for that situation,
> phylink has no information on the speed and duplex for such a port, so
> speed and duplex would be nonsense.
> 
> That conversion is very problematical.
> 
> I do have some patches that solve it by changing phylink, but it's
> quite a hack - the problem is detecting the uninitialised state in
> phylink_start(), which is really quite late.  You can find them in my
> "zii" branch:
> 
> net: dsa: mv88e6xxx: split out SPEED_MAX setting
> net: phylink/dsa: fix DSA and CPU links
> 
> So, I think we're back to... what do we do about the broken phylink
> integration for CPU and DSA ports.

Hi Russell

Here is what i have been playing with:

commit ea4c6b6ad0694a3cd857f504fb5e3a5887ffa062
Author: Andrew Lunn <andrew@lunn.ch>
Date:   Wed Feb 12 14:49:18 2020 -0600

    net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed
    
    By default, DSA drivers should configure CPU and DSA ports to their
    maximum speed. In many configurations this is sufficient to make the
    link work.
    
    In some cases it is necessary to configure the link to run slower,
    e.g. because of limitations of the SoC it is connected to. Or back to
    back PHYs are used and the PHY needs to be driven in order to
    establish link. In this case, phylink is used.
    
    Only instantiate phylink if it is required. If there is no PHY, or no
    fixed link properties, phylink can upset a link which works in the
    default configuration.
    
    Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
    Signed-off-by: Andrew Lunn <andrew@lunn.ch>

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 9b54e5a76297..dc4da4dc44f5 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -629,9 +629,14 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 int dsa_port_link_register_of(struct dsa_port *dp)
 {
        struct dsa_switch *ds = dp->ds;
+       struct device_node *phy_np;
 
-       if (!ds->ops->adjust_link)
-               return dsa_port_phylink_register(dp);
+       if (!ds->ops->adjust_link) {
+               phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
+               if (of_phy_is_fixed_link(dp->dn) || phy_np)
+                       return dsa_port_phylink_register(dp);
+               return 0;
+       }
 
        dev_warn(ds->dev,
                 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
@@ -646,11 +651,12 @@ void dsa_port_link_unregister_of(struct dsa_port *dp)
 {
        struct dsa_switch *ds = dp->ds;
 
-       if (!ds->ops->adjust_link) {
+       if (!ds->ops->adjust_link && dp->pl) {
                rtnl_lock();
                phylink_disconnect_phy(dp->pl);
                rtnl_unlock();
                phylink_destroy(dp->pl);
+               dp->pl = NULL;
                return;
        }
 

If we go with this, we can assume we do know the speed, either from
fixed-link, or the PHY when it established the link.

There is maybe one use case not covered by my patch. A port might just
have a phy-mode property, e.g. 'rgmii-id', but no fixed link. I took a
quick look at the usual suspects in DT, and i didn't find an actual
example of this. And i also need to look at the code pre-phylink
integration to see if it was actually supported.

	    Andrew
