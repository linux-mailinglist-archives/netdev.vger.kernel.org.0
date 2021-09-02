Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9E23FF45C
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347424AbhIBTwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:52:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54030 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231464AbhIBTwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 15:52:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xOucIOQ6UtzBW3tM9Wea+AQXnKYvu/HSHmo7sZLlgbo=; b=4+6aumT0YXZ4ccr6LAogodGa/K
        ewLzJRNRHlJaihgAp3V972EpohUYUNbLe10SY/+ZUEaLf12MJVUckbz77lw3iXztzT+IYCvg+3FDj
        mPQFqqhmAfVlzw2PjzkRWCHezSO275WTVt1w/0lxZMGRQn/g/48jfYp89FCCDv8pl/Y4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mLskP-0052nI-2o; Thu, 02 Sep 2021 21:51:41 +0200
Date:   Thu, 2 Sep 2021 21:51:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <YTErTRBnRYJpWDnH@lunn.ch>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
 <20210902185016.GL22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902185016.GL22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 07:50:16PM +0100, Russell King (Oracle) wrote:
> On Thu, Sep 02, 2021 at 01:50:51AM +0300, Vladimir Oltean wrote:
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 52310df121de..2c22a32f0a1c 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -1386,8 +1386,16 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
> >  
> >  	/* Assume that if there is no driver, that it doesn't
> >  	 * exist, and we should use the genphy driver.
> > +	 * The exception is during probing, when the PHY driver might have
> > +	 * attempted a probe but has requested deferral. Since there might be
> > +	 * MAC drivers which also attach to the PHY during probe time, try
> > +	 * harder to bind the specific PHY driver, and defer the MAC driver's
> > +	 * probing until then.
> >  	 */
> >  	if (!d->driver) {
> > +		if (device_pending_probe(d))
> > +			return -EPROBE_DEFER;
> 
> Something else that concerns me here.
> 
> As noted, many network drivers attempt to attach their PHY when the
> device is brought up, and not during their probe function.

Yes, this is going to be a problem. I agree it is too late to return
-EPROBE_DEFER. Maybe phy_attach_direct() needs to wait around, if the
device is still on the deferred list, otherwise use genphy. And maybe
a timeout and return -ENODEV, which is not 100% correct, we know the
device exists, we just cannot drive it.

Can we tell we are in the context of a driver probe? Or do we need to
add a parameter to the various phy_attach API calls to let the core
know if this is probe or open?

This is more likely to be a problem with NFS root, with the kernel
bringing up an interface as soon as its registered. userspace bringing
up interfaces is generally much later, and udev tends to wait around
until there are no more driver load requests before the boot
continues.

	Andrew
