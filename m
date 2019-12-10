Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00BBB118692
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfLJLiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:38:51 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50132 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbfLJLiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:38:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=p+0WpSxXXUtagba3vOEjLFjDjbBNemDiOSF0zcD4DU0=; b=L5zPBPHJbFQFRq5C1XIVb3Jrq
        pBxmhj20Ls77kWZl2ea6m7UyOvC+BOI+2L40+fJX7m9rJG3fC8tOPSXhjXW97bBMlziZu4ADvkC81
        kcMBXEIy5tBmvsTTi4qLtICAzhVze6G555r+TXAnBUUdh33UbaW9uxkocM4UP5q3lmfJNttd5QE1U
        Mzc8rhnY3EF1cfN9Km8NFK0j5IHhVccyV2j4SgNn/5duP8vkTKEX/zbZ0nrYSZ5I5crQc/TNUntk+
        XpHkPc6e97SXV/qPEog9bIf1Prog4MznrzKTwuDhy9YZXmgQ+bcjkkoCjMu4Lsx0dHJEFU6kPZS3M
        pGgZhoEfw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:46900)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iedqd-000140-NI; Tue, 10 Dec 2019 11:38:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iedqY-0004at-24; Tue, 10 Dec 2019 11:38:30 +0000
Date:   Tue, 10 Dec 2019 11:38:30 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Milind Parab <mparab@cadence.com>
Cc:     "nicolas.nerre@microchip.com" <nicolas.nerre@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dhananjay Vilasrao Kangude <dkangude@cadence.com>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "brad.mouring@ni.com" <brad.mouring@ni.com>,
        Parshuram Raju Thombare <pthombar@cadence.com>
Subject: Re: [PATCH 1/3] net: macb: fix for fixed-link mode
Message-ID: <20191210113829.GT25745@shell.armlinux.org.uk>
References: <1575890033-23846-1-git-send-email-mparab@cadence.com>
 <1575890061-24250-1-git-send-email-mparab@cadence.com>
 <20191209112615.GE25745@shell.armlinux.org.uk>
 <BY5PR07MB6514923C4D3127F43C54FE5ED35B0@BY5PR07MB6514.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR07MB6514923C4D3127F43C54FE5ED35B0@BY5PR07MB6514.namprd07.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 09:14:13AM +0000, Milind Parab wrote:
> >> This patch fix the issue with fixed link. With fixed-link
> >> device opening fails due to macb_phylink_connect not
> >> handling fixed-link mode, in which case no MAC-PHY connection
> >> is needed and phylink_connect return success (0), however
> >> in current driver attempt is made to search and connect to
> >> PHY even for fixed-link.
> >>
> >> Signed-off-by: Milind Parab <mparab@cadence.com>
> >> ---
> >>  drivers/net/ethernet/cadence/macb_main.c | 17 ++++++++---------
> >>  1 file changed, 8 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> >> index 9c767ee252ac..6b68ef34ab19 100644
> >> --- a/drivers/net/ethernet/cadence/macb_main.c
> >> +++ b/drivers/net/ethernet/cadence/macb_main.c
> >> @@ -615,17 +615,13 @@ static int macb_phylink_connect(struct macb *bp)
> >>  {
> >>  	struct net_device *dev = bp->dev;
> >>  	struct phy_device *phydev;
> >> +	struct device_node *dn = bp->pdev->dev.of_node;
> >>  	int ret;
> >>
> >> -	if (bp->pdev->dev.of_node &&
> >> -	    of_parse_phandle(bp->pdev->dev.of_node, "phy-handle", 0)) {
> >> -		ret = phylink_of_phy_connect(bp->phylink, bp->pdev-
> >>dev.of_node,
> >> -					     0);
> >> -		if (ret) {
> >> -			netdev_err(dev, "Could not attach PHY (%d)\n", ret);
> >> -			return ret;
> >> -		}
> >> -	} else {
> >> +	if (dn)
> >> +		ret = phylink_of_phy_connect(bp->phylink, dn, 0);
> >> +
> >> +	if (!dn || (ret && !of_parse_phandle(dn, "phy-handle", 0))) {
> >
> >Hi,
> >If of_parse_phandle() returns non-null, the device_node it returns will
> >have its reference count increased by one.  That reference needs to be
> >put.
> >
> 
> Okay, as per your suggestion below addition will be okay to store the "phy_node" and then of_node_put(phy_node) on error
> 
> phy_node = of_parse_phandle(dn, "phy-handle", 0);
>         if (!dn || (ret && !phy_node)) {
>                 phydev = phy_find_first(bp->mii_bus);
...
>         if (phy_node)
>                 of_node_put(phy_node);

As you're only interested in whether phy-handle exists or not, you
could do this instead:

	phy_node = of_parse_phandle(dn, "phy-handle", 0);
	of_node_put(phy_node);
	if (!dn || (ret && !phy_node)) {
		...

Yes, it looks a bit weird, but the only thing you're interested in
here is whether of_parse_phandle() returned NULL or non-NULL. You're
not interested in dereferencing the pointer.

Some may raise some eye-brows at that, so it may be better to have
this as a helper:

static bool macb_phy_handle_exists(struct device_node *dn)
{
	dn = of_parse_phandle(dn, "phy-handle", 0);
	of_node_put(dn);
	return dn != NULL;
}

and use it as:

	if (!dn || (ret && !macb_phy_handle_exists(dn))) {

which is more obvious what is going on.

> 
>         return ret;
> 
> >I assume you're trying to determine whether phylink_of_phy_connect()
> >failed because of a missing phy-handle rather than of_phy_attach()
> >failing?  Maybe those two failures ought to be distinguished by errno
> >return value?
> 
> Yes, PHY will be scanned only if phylink_of_phy_connect() returns error due to missing "phy-handle". 
> Currently, phylink_of_phy_connect() returns same error for missing "phy-handle" and of_phy_attach() failure.
> 
> >of_phy_attach() may fail due to of_phy_find_device() failing to find
> >the PHY, or phy_attach_direct() failing.  We could switch from using
> >of_phy_attach(), to using of_phy_find_device() directly so we can then
> >propagate phy_attach_direct()'s error code back, rather than losing it.
> >That would then leave the case of of_phy_find_device() failure to be
> >considered in terms of errno return value.

Here's a patch I quickly knocked up that does this - may not apply to
the kernel you're using as there's a whole bunch of work I have
outstanding, but gives the outline idea.  Does this help?

8<===
From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH] net: phylink: avoid of_phy_attach()

of_phy_attach() hides the return value of phy_attach_direct(), forcing
us to return a "generic" ENODEV error code that is indistinguishable
from the lack-of-phy-property case.

Switch to using of_phy_find_device() to find the PHY device, and then
propagating any phy_attach_direct() error back to the caller.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index e9036b72114c..5a5109428d9e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -887,14 +887,17 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 		return 0;
 	}
 
-	phy_dev = of_phy_attach(pl->netdev, phy_node, flags,
-				pl->link_interface);
+	phy_dev = of_phy_find_device(phy_node);
 	/* We're done with the phy_node handle */
 	of_node_put(phy_node);
-
 	if (!phy_dev)
 		return -ENODEV;
 
+	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
+				pl->link_interface);
+	if (ret)
+		return ret;
+
 	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
 	if (ret)
 		phy_detach(phy_dev);
-- 
2.20.1


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
