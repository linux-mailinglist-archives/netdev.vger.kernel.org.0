Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DFD3FF5A2
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 23:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347066AbhIBVeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 17:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347059AbhIBVeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 17:34:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE797C061575;
        Thu,  2 Sep 2021 14:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=c9VrKlIQFUEkJNSWwGh5FhWwSAwLHU/yc0GKasdTsno=; b=PhTlPHkQSR76SQ6vPZIPfez88
        w1hIL9OjrC3Hq9LRoRraV/YRdDHZ1uFhPsTeA0HotoexTlCM3kE7iaz7Opp54tndEHOdhICgZBy7C
        CsiyrkvBetGrN9C1xEUmjm0eTKP6Ash0CrasJ2Wi9zuJnoW3epaYDU8D5j4RoGFGNJaAmriOTMT0g
        mXFosO4BzuWjb5i/p3LpZkRaK18WnAEBsnLNzy0v7d2yGBnVbirzwbMDeS0lQ4Jc7wvs6Zds0uIse
        xegXRoFRH3njKLWptl+3dFnthPk8fVX32Z8hcWwKA7D3WOnO0WEcizVCy/xONfL0MKLs0StWw5UnX
        Vg/IWBGCQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48112)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLuKX-00024F-Nn; Thu, 02 Sep 2021 22:33:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLuKV-0008EU-98; Thu, 02 Sep 2021 22:33:03 +0100
Date:   Thu, 2 Sep 2021 22:33:03 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <20210902213303.GO22278@shell.armlinux.org.uk>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
 <20210902185016.GL22278@shell.armlinux.org.uk>
 <YTErTRBnRYJpWDnH@lunn.ch>
 <bd7c9398-5d3d-ccd8-8804-25074cff6bde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd7c9398-5d3d-ccd8-8804-25074cff6bde@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 01:33:57PM -0700, Florian Fainelli wrote:
> On 9/2/2021 12:51 PM, Andrew Lunn wrote:
> > On Thu, Sep 02, 2021 at 07:50:16PM +0100, Russell King (Oracle) wrote:
> > > On Thu, Sep 02, 2021 at 01:50:51AM +0300, Vladimir Oltean wrote:
> > > > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > > > index 52310df121de..2c22a32f0a1c 100644
> > > > --- a/drivers/net/phy/phy_device.c
> > > > +++ b/drivers/net/phy/phy_device.c
> > > > @@ -1386,8 +1386,16 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
> > > >   	/* Assume that if there is no driver, that it doesn't
> > > >   	 * exist, and we should use the genphy driver.
> > > > +	 * The exception is during probing, when the PHY driver might have
> > > > +	 * attempted a probe but has requested deferral. Since there might be
> > > > +	 * MAC drivers which also attach to the PHY during probe time, try
> > > > +	 * harder to bind the specific PHY driver, and defer the MAC driver's
> > > > +	 * probing until then.
> > > >   	 */
> > > >   	if (!d->driver) {
> > > > +		if (device_pending_probe(d))
> > > > +			return -EPROBE_DEFER;
> > > 
> > > Something else that concerns me here.
> > > 
> > > As noted, many network drivers attempt to attach their PHY when the
> > > device is brought up, and not during their probe function.
> > 
> > Yes, this is going to be a problem. I agree it is too late to return
> > -EPROBE_DEFER. Maybe phy_attach_direct() needs to wait around, if the
> > device is still on the deferred list, otherwise use genphy. And maybe
> > a timeout and return -ENODEV, which is not 100% correct, we know the
> > device exists, we just cannot drive it.
> 
> Is it really going to be a problem though? The two cases where this will
> matter is if we use IP auto-configuration within the kernel, which this
> patchset ought to be helping with

There is no handling of EPROBE_DEFER in the IP auto-configuration
code while trying to bring up interfaces:

        for_each_netdev(&init_net, dev) {
                if (ic_is_init_dev(dev)) {
...
                        oflags = dev->flags;
                        if (dev_change_flags(dev, oflags | IFF_UP, NULL) < 0) {
                                pr_err("IP-Config: Failed to open %s\n",
                                       dev->name);
                                continue;
                        }

So, the only way this could be reliable is if we can guarantee that
all deferred probes will have been retried by the time we get here.
Do we have that guarantee?

> if we are already in user-space and the
> PHY is connected at .ndo_open() time, there is a whole lot of things that
> did happen prior to getting there, such as udevd using modaliases in order
> to load every possible module we might, so I am debating whether we will
> really see a probe deferral at all.

As can be seen from my recent posts which show on Debian Buster that
interfaces are attempted to be brought up while e.g. mv88e6xxx is still
probing, we can't make any guarantees that things have "settled" by the
time userspace attempts to bring up the network interfaces.

I may have more on why that is happening... I won't post it here, I'll
post to the other thread.

> > Can we tell we are in the context of a driver probe? Or do we need to
> > add a parameter to the various phy_attach API calls to let the core
> > know if this is probe or open?
> 
> Actually we do the RTNL lock will be held during ndo_open and it won't
> during driver probe.

That's probably an unreliable indicator. DPAA2 has weirdness in the
way it can dynamically create and destroy network interfaces, which
does lead to problems with the rtnl lock. I've been carrying a patch
from NXP for this for almost two years now, which NXP still haven't
submitted:

http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=cex7&id=a600f2ee50223e9bcdcf86b65b4c427c0fd425a4

... and I've no idea why that patch never made mainline. I need it
to avoid the stated deadlock on SolidRun Honeycomb platforms when
creating additional network interfaces for the SFP cages in userspace.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
