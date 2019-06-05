Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7504359AF
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 11:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfFEJbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 05:31:01 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53962 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfFEJbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 05:31:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UxuxuMMhDod5gLKTtEb4SCIHyl/6GQrbGrNXB4JxzcM=; b=ow9xnoOi6KCnfUsWDw/MVy+Jh
        9xWS22BEu7LdoIiYiKO2rTa8sJoaoFBzpQeNAWbqgeuv+Rrf/ZE7Qhf4i+ayywIBE/Vj4fAY6m64M
        vx0z828c3sM1ghfrRBUUwDcd3cYiElxNFWGryHJe27jWOJZ2Z2kaxpL7QM2mRbOfaozEwAT8aTvmr
        lzicjucQixNqbf4eHDkR2sb3X2ukyLDk+aOuBRSnpN5KQz9OShTG5IOXZNHBctzn1M5R/WQdAL4xn
        n750ySn4nBXaxBTvnTPER0WF3Bm/Cfr+RNvVC3cvP7AN+Y0EoYHoTyqJJGa5zqc2ovDy6mK+eY86L
        lTE4XlX9A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56222)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hYSG1-0006wF-NC; Wed, 05 Jun 2019 10:30:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hYSFz-0002JZ-RO; Wed, 05 Jun 2019 10:30:55 +0100
Date:   Wed, 5 Jun 2019 10:30:55 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
Message-ID: <20190605093055.sry7mcwefdiawvlc@shell.armlinux.org.uk>
References: <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
 <CA+h21hrOPCVoDwbQa9uFVu3uVWtoP+2Vp2z94An2qtv=u8wWKg@mail.gmail.com>
 <20190604221626.4vjtsexoutqzblkl@shell.armlinux.org.uk>
 <CA+h21hrkQkBocwigiemhN_H+QJ3yWZaJt+aoBWhZiW3BNNQOXw@mail.gmail.com>
 <20190604225919.xpkykt2z3a7utiet@shell.armlinux.org.uk>
 <CA+h21hrT+XPfqePouzKB4UUfUawck831bKhAY6-BOunnvbmT1g@mail.gmail.com>
 <20190604232433.4v2qqxyihqi2rmjl@shell.armlinux.org.uk>
 <CA+h21hpDyDLChzrqX19bU81+ss3psVesNftCqN7+7+GFkMe_-A@mail.gmail.com>
 <262dfc0e-c248-23e7-cd34-d13e104afe91@gmail.com>
 <CA+h21howazOwxZ840kYKS_cCaGB6_B1f0e=2NMHY1y8zDw7iug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21howazOwxZ840kYKS_cCaGB6_B1f0e=2NMHY1y8zDw7iug@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 11:27:59AM +0300, Vladimir Oltean wrote:
> On Wed, 5 Jun 2019 at 06:06, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >
> >
> >
> > On 6/4/2019 4:46 PM, Vladimir Oltean wrote:
> > > On Wed, 5 Jun 2019 at 02:24, Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > >>
> > >> On Wed, Jun 05, 2019 at 02:03:19AM +0300, Vladimir Oltean wrote:
> > >>> On Wed, 5 Jun 2019 at 01:59, Russell King - ARM Linux admin
> > >>> <linux@armlinux.org.uk> wrote:
> > >>>>
> > >>>> On Wed, Jun 05, 2019 at 01:44:08AM +0300, Vladimir Oltean wrote:
> > >>>>> You caught me.
> > >>>>>
> > >>>>> But even ignoring the NIC case, isn't the PHY state machine
> > >>>>> inconsistent with itself? It is ok with callink phy_suspend upon
> > >>>>> ndo_stop, but it won't call phy_suspend after phy_connect, when the
> > >>>>> netdev is implicitly stopped?
> > >>>>
> > >>>> The PHY state machine isn't inconsistent with itself, but it does
> > >>>> have strange behaviour.
> > >>>>
> > >>>> When the PHY is attached, the PHY is resumed and the state machine
> > >>>> is in PHY_READY state.  If it goes through a start/stop cycle, the
> > >>>> state machine transitions to PHY_HALTED and attempts to place the
> > >>>> PHY into a low power state.  So the PHY state is consistent with
> > >>>> the state machine state (we don't end up in the same state but with
> > >>>> the PHY in a different state.)
> > >>>>
> > >>>> What we do have is a difference between the PHY state (and state
> > >>>> machine state) between the boot scenario, and the interface up/down
> > >>>> scenario, the latter behaviour having been introduced by a commit
> > >>>> back in 2013:
> > >>>>
> > >>>>     net: phy: suspend phydev when going to HALTED
> > >>>>
> > >>>>     When phydev is going to HALTED state, we can try to suspend it to
> > >>>>     safe more power. phy_suspend helper will check if PHY can be suspended,
> > >>>>     so just call it when entering HALTED state.
> > >>>>
> > >>>> --
> > >>>> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > >>>> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> > >>>> According to speedtest.net: 11.9Mbps down 500kbps up
> > >>>
> > >>> I am really not into the PHYLIB internals, but basically what you're
> > >>> telling me is that running "ip link set dev eth0 down" is a
> > >>> stronger/more imperative condition than not running "ip link set dev
> > >>> eth0 up"... Does it also suspend the PHY if I put the interface down
> > >>> while it was already down?
> > >>
> > >> No - but that has nothing to do with phylib internals, more to do with
> > >> the higher levels of networking.  ndo_stop() will not be called unless
> > >> ndo_open() has already been called.  In other words, setting an already
> > >> down device down via "ip link set dev eth0 down" is a no-op.
> > >>
> > >> So, let's a common scenario.  You power up a board.  The PHY comes up
> > >> and establishes a link.  The boot loader runs, loads the kernel, which
> > >
> > > This may or may not be the case. As you pointed out a few emails back,
> > > this is a system-level issue that requires a system-level solution -
> > > so cutting the link in U-boot is not out of the question.
> > >
> > >> then boots.  Your network driver is a module, and hasn't been loaded
> > >> yet.  The link is still up.
> > >>
> > >> The modular network driver gets loaded, and initialises.  Userspace
> > >> does not bring the network device up, and the network driver does not
> > >> attach or connect to the PHY (which is actually quite common).  So,
> > >> the link is still up.
> > >>
> > >> The modular PHY driver gets loaded, and binds to the PHY.  The link
> > >> is still up.
> > >
> > > I would rather say, 'even if the link is not up, Linux brings it up
> > > (possibly prematurely) via phy_resume'.
> > > But let's consider the case where the link *was* up. The general idea
> > > is 'implement your workarounds in whatever other way, that link is
> > > welcome!'.
> >
> > With the systems that I work with, we have enforced the following
> > behavior to happen: the boot loader and kernel only turn on what they
> > needs, at the time they need it, and nothing more, once done, they put
> > the blocks back into lowest power mode (clock and power gated if
> > available). So yes, there are multiple link re-negotiations throughput
> > the boot process, but when there is no device bound to a driver the
> > system conserves power by default which is deemed a higher goal than
> > speed. Your mileage may vary of course.
> >
> > There is not exactly a simple way of enforcing that kind (or another
> > kind for that matter) of policy kernel wide, so it's unfortunately up to
> > the driver writer to propose something that is deemed sensible.
> >
> > We could however, extend existing tools like iproute2 to offer the
> > ability to control whether the PHY should be completely powered off, in
> > a low power state allowing WoL, or remain UP when the network device is
> > brought down. That would not cover the case that Russell explained, but
> > it would be another monkey wrench you can throw at the system.
> > --
> > Florian
> 
> Hi Florian,
> 
> By going to HALTED on phy_stop, the system already achieves what I am
> looking after - although maybe it is an unintended consequence for
> you.
> I'm only trying to make an argument for removing the phy_resume from
> phy_attach_direct now.

Merely doing that will create problems.  You may remember a few emails
ago, we discussed whether the physical PHY state was consistent with
the PHY state machine state.  By making that change, the PHY state
machine vs the physical PHY state becomes inconsistent.

Removing phy_resume() from phy_attach_direct() means that the PHY may
not be in a resumed state at this point, yet we set the PHY state
machine to PHY_READY.  When phy_start() is called, the state will be
transitioned to PHY_UP rather than PHY_RESUMING, and we will try to
update the advertisement into the PHY (as I've previously described.)

If the PHY is powered down, but the state machine transitions from
PHY_READY to PHY_UP state, programming the advertisement will have no
effect, and the PHY will remain in power-down mode.

So, the PHY state machine state needs to also be set according to the
PHY mode.  The same is true for phy_probe(), which also assumes that
the PHY is not powered down.

> If there was a link, and it doesn't need
> re-negociation, fine, use it in phy_start, but at most leave U-boot to
> put that link down and don't force it up prior to the netdev's
> ndo_open.
> 
> Regards,
> -Vladimir
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
