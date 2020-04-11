Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADD21A4F0E
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 11:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgDKJRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 05:17:11 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46138 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgDKJRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 05:17:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v99Py2O0+MBHwgVQ/kvvKOXcuOYbcOVt8mAGyw3i4Tc=; b=FqvciLnYpg0v2BVGpjcS8Lwrb
        fZ11tbBxmcHXtRBjPQyg6xVsKorqGIrHwa2YkbfMaMcn5wMqRwIQydIxFRbbHCDqOykqKJ2EBkGjV
        l2jkNl7I6mhdBSzNraotNDn7pbJbUiYh8X4QvUlnMBz6bBiD5Cnks8tpmxrrGRxArPiDJL2xOYP/+
        qtppDkyyQXhMGapeeLZ39wtu7LGZgUbQxBEF7OQ1nmlcAhRUXljMPMq/7qLRC7ie6G+LBXjZRO0vB
        OvoLouNz3imMq4M6jgU2Zfjaf9MqevP68NPhqRe3ZdKsD/TZ3KfDEibPGJGZ6eNkWu71c8vz5CP7F
        9goLAiqSw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:44436)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jNCGA-0006Pl-LN; Sat, 11 Apr 2020 10:17:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jNCG9-0004vE-5I; Sat, 11 Apr 2020 10:17:05 +0100
Date:   Sat, 11 Apr 2020 10:17:05 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Clemens Gruber <clemens.gruber@pqgruber.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: Fix pause frame negotiation
Message-ID: <20200411091705.GG25745@shell.armlinux.org.uk>
References: <20200408214326.934440-1-clemens.gruber@pqgruber.com>
 <20200410174304.22f812fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410174304.22f812fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 05:43:04PM -0700, Jakub Kicinski wrote:
> On Wed,  8 Apr 2020 23:43:26 +0200 Clemens Gruber wrote:
> > The negotiation of flow control / pause frame modes was broken since
> > commit fcf1f59afc67 ("net: phy: marvell: rearrange to use
> > genphy_read_lpa()") moved the setting of phydev->duplex below the
> > phy_resolve_aneg_pause call. Due to a check of DUPLEX_FULL in that
> > function, phydev->pause was no longer set.
> > 
> > Fix it by moving the parsing of the status variable before the blocks
> > dealing with the pause frames.
> > 
> > Fixes: fcf1f59afc67 ("net: phy: marvell: rearrange to use genphy_read_lpa()")
> > Cc: stable@vger.kernel.org # v5.6+
> 
> nit: please don't CC stable on networking patches
> 
> > Signed-off-by: Clemens Gruber <clemens.gruber@pqgruber.com>
> > ---
> >  drivers/net/phy/marvell.c | 44 +++++++++++++++++++--------------------
> >  1 file changed, 22 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> > index 4714ca0e0d4b..02cde4c0668c 100644
> > --- a/drivers/net/phy/marvell.c
> > +++ b/drivers/net/phy/marvell.c
> > @@ -1263,6 +1263,28 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
> >  	int lpa;
> >  	int err;
> >  
> > +	if (!(status & MII_M1011_PHY_STATUS_RESOLVED))
> > +		return 0;
> 
> If we return early here won't we miss updating the advertising bits?
> We will no longer call e.g. fiber_lpa_mod_linkmode_lpa_t().
> 
> Perhaps extracting info from status should be moved to a helper so we
> can return early without affecting the rest of the flow?
> 
> Is my understanding correct?  Russell?

You are correct - and yes, there is also a problem here.

It is not clear whether the resolved bit is set before or after the
link status reports that link is up - however, the resolved bit
indicates whether the speed and duplex are valid.

What I've done elsewhere is if the resolved bit is not set, then we
force phydev->link to be false, so we don't attempt to process a
link-up status until we can read the link parameters.  I think that's
what needs to happen here, i.o.w.:

	if (!(status & MII_M1011_PHY_STATUS_RESOLVED)) {
		phydev->link = 0;
		return 0;
	}

especially as we're not reading the LPA.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
