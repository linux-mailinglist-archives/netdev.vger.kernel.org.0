Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6881A5B8F
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbgDKXud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:50:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbgDKXub (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:50:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8526720936;
        Sat, 11 Apr 2020 23:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586649031;
        bh=GrmMSd83oRr7yDkchC4S4UHDHr94N0l328ftQ/s1suc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IfCoR5eegu4iaVZvOa1j8RZ/3DrAETQOIkN15zO5inDIcQo7KLjMBOzooL02CI+fJ
         XkxH1lHcuKkoeEaMA5SyNNlNSoq/RFnb4+lJ6XGyTUOpokevYENX/WXQRmyDKbc34n
         NRhr5roPXt2fbsXJ+Q2Jf5YXSAkE6cHtJ9gbygC4=
Date:   Sat, 11 Apr 2020 16:50:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Clemens Gruber <clemens.gruber@pqgruber.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Fix pause frame negotiation
Message-ID: <20200411165029.694a1b8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200411234559.GL25745@shell.armlinux.org.uk>
References: <20200411165125.1091-1-clemens.gruber@pqgruber.com>
        <20200411162824.59791b84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200411234559.GL25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Apr 2020 00:45:59 +0100 Russell King - ARM Linux admin wrote:
> On Sat, Apr 11, 2020 at 04:28:24PM -0700, Jakub Kicinski wrote:
> > On Sat, 11 Apr 2020 18:51:25 +0200 Clemens Gruber wrote:  
> > > The negotiation of flow control / pause frame modes was broken since
> > > commit fcf1f59afc67 ("net: phy: marvell: rearrange to use
> > > genphy_read_lpa()") moved the setting of phydev->duplex below the
> > > phy_resolve_aneg_pause call. Due to a check of DUPLEX_FULL in that
> > > function, phydev->pause was no longer set.
> > > 
> > > Fix it by moving the parsing of the status variable before the blocks
> > > dealing with the pause frames.
> > > 
> > > As the Marvell 88E1510 datasheet does not specify the timing between the
> > > link status and the "Speed and Duplex Resolved" bit, we have to force
> > > the link down as long as the resolved bit is not set, to avoid reporting
> > > link up before we even have valid Speed/Duplex.
> > > 
> > > Tested with a Marvell 88E1510 (RGMII to Copper/1000Base-T)
> > > 
> > > Fixes: fcf1f59afc67 ("net: phy: marvell: rearrange to use genphy_read_lpa()")
> > > Signed-off-by: Clemens Gruber <clemens.gruber@pqgruber.com>
> > > ---
> > > Changes since v1:
> > > - Force link to 0 if resolved bit is not set as suggested by Russell King
> > > 
> > >  drivers/net/phy/marvell.c | 46 ++++++++++++++++++++-------------------
> > >  1 file changed, 24 insertions(+), 22 deletions(-)
> > > 
> > > diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> > > index 9a8badafea8a..561df5e33f65 100644
> > > --- a/drivers/net/phy/marvell.c
> > > +++ b/drivers/net/phy/marvell.c
> > > @@ -1278,6 +1278,30 @@ static int marvell_read_status_page_an(struct phy_device *phydev,
> > >  	int lpa;
> > >  	int err;
> > >  
> > > +	if (!(status & MII_M1011_PHY_STATUS_RESOLVED)) {
> > > +		phydev->link = 0;
> > > +		return 0;
> > > +	}  
> > 
> > This doesn't address my comment, so was I wrong? What I was trying to
> > say is that the function updates the established link info as well as
> > autoneg advertising info. If the link is not resolved we can't read the
> > link info, but we should still report the advertising modes. No?  
> 
> If we report that the link is down, then the advertising modes are
> irrelevent.

Ugh, these are link partner modes...

Applied, thanks!
