Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B284A3EBA
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 09:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344267AbiAaIlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 03:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiAaIle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 03:41:34 -0500
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA02C061714;
        Mon, 31 Jan 2022 00:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
        s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EqBex1pEueEt5PYfhmVjqD/9JJ88/2bfTG4wFEkEDgE=; b=rI3Lym48SCSoA8AE7hnxqhIwa4
        Xleg4aV90Ptamw4R7d3rBLmrynxD+iRBLjpwkTX4QQj1W7+EWaMzpg3jbEFamlcCAq/KhlRaVypli
        x4a4a20I1QWFVfDPrKgiImHY2ZCmY5Ns4eMZ8wcIlpzlH52CgV8Gj1PrW079OEmnbFaIYeuyUUudq
        ygtENLa8BfthG6Xji5JBYSsHUMhzWPn6qOHTKr2e0qA0TTHH0VNw/ztv/FV2ltdeq13KIK74iVJdN
        m98Rt2JC30ua+98nA7n3Z3pIEBFAfdhtGcSGOKytpoY73Q0RKTlEhi2pW9lPjLNEuiWNmtuhbXu0c
        Ddwg4a0w==;
Received: from noodles by the.earth.li with local (Exim 4.94.2)
        (envelope-from <noodles@earth.li>)
        id 1nESFa-00AjjO-AQ; Mon, 31 Jan 2022 08:41:26 +0000
Date:   Mon, 31 Jan 2022 08:41:26 +0000
From:   Jonathan McDowell <noodles@earth.li>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luo Jie <luoj@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Marko <robimarko@gmail.com>
Subject: Re: [PATCH net] net: phy: Fix qca8081 with speeds lower than 2.5Gb/s
Message-ID: <Yfegtn/3EUzHUT42@earth.li>
References: <YfZnmMteVry/A1XR@earth.li>
 <YfaHWSe+FvZC7w/x@shell.armlinux.org.uk>
 <YfasMniiA8wn+isu@earth.li>
 <YfbUYcOLiikv9Pyv@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfbUYcOLiikv9Pyv@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 30, 2022 at 06:09:37PM +0000, Russell King (Oracle) wrote:
> On Sun, Jan 30, 2022 at 03:18:10PM +0000, Jonathan McDowell wrote:
> > On Sun, Jan 30, 2022 at 12:40:57PM +0000, Russell King (Oracle) wrote:
> > > On Sun, Jan 30, 2022 at 10:25:28AM +0000, Jonathan McDowell wrote:
> > > > A typo in qca808x_read_status means we try to set SMII mode on the port
> > > > rather than SGMII when the link speed is not 2.5Gb/s. This results in no
> > > > traffic due to the mismatch in configuration between the phy and the
> > > > mac.
> > > > 
> > > > Fixes: 79c7bc0521545 ("net: phy: add qca8081 read_status")
> > > > Signed-off-by: Jonathan McDowell <noodles@earth.li>
> > > > ---
> > > >  drivers/net/phy/at803x.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> > > > index 5b6c0d120e09..7077e3a92d31 100644
> > > > --- a/drivers/net/phy/at803x.c
> > > > +++ b/drivers/net/phy/at803x.c
> > > > @@ -1691,7 +1691,7 @@ static int qca808x_read_status(struct phy_device *phydev)
> > > >  	if (phydev->link && phydev->speed == SPEED_2500)
> > > >  		phydev->interface = PHY_INTERFACE_MODE_2500BASEX;
> > > >  	else
> > > > -		phydev->interface = PHY_INTERFACE_MODE_SMII;
> > > > +		phydev->interface = PHY_INTERFACE_MODE_SGMII;
> > > 
> > > Is it intentional to set the interface to SGMII also when there is no
> > > link?
> > 
> > My reading of the code is that if this was just a GigE capable phy the
> > interface would be set once and never changed/unset. The only reason
> > it happens here is because the link changes to support the 2.5G mode, so
> > there's no problem with it defaulting to SGMII even when the external
> > link isn't actually up. Perhap Luo can confirm if this is the case?
> 
> My point is that other PHY drivers only change the interface mode when
> the link comes up, and we ought to have consistency between PHY drivers
> rather than each PHY driver deciding on different behaviours - unless
> there is a good reason to be different.

I'm not aware of any reason to do so. I've rolled a v2 that only changes
the interface mode when the link is up and it behaves as expected in my
testing, so I'll get that sent out later.

J.

-- 
/-\                             | 101 things you can't have too much
|@/  Debian GNU/Linux Developer |           of : 52 - IRC.
\-                              |
