Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 165561A5B03
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731013AbgDKXqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:46:14 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55766 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgDKXqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 19:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/sBTCU2K/OAC2yDbD+FrzFhzjjepZq/O6taqfxVmS8k=; b=LIgQUIAAUFNMaSCcu69I/B/GV
        m1SPhGWrHsnD74SV72c7+9F74c+OQA50SzOccymCpn3Uesd1/QJpfvDtqXr+0iHRA3R8Hhu5n+s6A
        T/iw6riKe0X7Y13HxmcNOm2cUHlygdHwcmrrR2r97yQuTifAnjJucubTaZx/zDcZ3njxQXuhgVI9W
        mt0mInczwDSyNu+86IIzO+U8MayA/scwfZI3hpobkwQ4qOZlqJE085Al3Rg0ENmLB9XCJxe7a9GgN
        UjwXIiFSpBjSd3qXNZ75LvTU81L5A9sPD+oVjXpEag2zNcX+pDq+jE6YRQSVJBQOH70yzlUKEpfWX
        65QZFyuoA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48850)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jNPp6-0001Un-2z; Sun, 12 Apr 2020 00:46:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jNPp1-0005SD-4h; Sun, 12 Apr 2020 00:45:59 +0100
Date:   Sun, 12 Apr 2020 00:45:59 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Clemens Gruber <clemens.gruber@pqgruber.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Fix pause frame negotiation
Message-ID: <20200411234559.GL25745@shell.armlinux.org.uk>
References: <20200411165125.1091-1-clemens.gruber@pqgruber.com>
 <20200411162824.59791b84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200411162824.59791b84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 11, 2020 at 04:28:24PM -0700, Jakub Kicinski wrote:
> On Sat, 11 Apr 2020 18:51:25 +0200 Clemens Gruber wrote:
> > The negotiation of flow control / pause frame modes was broken since
> > commit fcf1f59afc67 ("net: phy: marvell: rearrange to use
> > genphy_read_lpa()") moved the setting of phydev->duplex below the
> > phy_resolve_aneg_pause call. Due to a check of DUPLEX_FULL in that
> > function, phydev->pause was no longer set.
> > 
> > Fix it by moving the parsing of the status variable before the blocks
> > dealing with the pause frames.
> > 
> > As the Marvell 88E1510 datasheet does not specify the timing between the
> > link status and the "Speed and Duplex Resolved" bit, we have to force
> > the link down as long as the resolved bit is not set, to avoid reporting
> > link up before we even have valid Speed/Duplex.
> > 
> > Tested with a Marvell 88E1510 (RGMII to Copper/1000Base-T)
> > 
> > Fixes: fcf1f59afc67 ("net: phy: marvell: rearrange to use genphy_read_lpa()")
> > Signed-off-by: Clemens Gruber <clemens.gruber@pqgruber.com>
> > ---
> > Changes since v1:
> > - Force link to 0 if resolved bit is not set as suggested by Russell King
> > 
> >  drivers/net/phy/marvell.c | 46 ++++++++++++++++++++-------------------
> >  1 file changed, 24 insertions(+), 22 deletions(-)
> > 
> > diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> > index 9a8badafea8a..561df5e33f65 100644
> > --- a/drivers/net/phy/marvell.c
> > +++ b/drivers/net/phy/marvell.c
> > @@ -1278,6 +1278,30 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
> >  	int lpa;
> >  	int err;
> >  
> > +	if (!(status & MII_M1011_PHY_STATUS_RESOLVED)) {
> > +		phydev->link = 0;
> > +		return 0;
> > +	}
> 
> This doesn't address my comment, so was I wrong? What I was trying to
> say is that the function updates the established link info as well as
> autoneg advertising info. If the link is not resolved we can't read the
> link info, but we should still report the advertising modes. No?

If we report that the link is down, then the advertising modes are
irrelevent.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
