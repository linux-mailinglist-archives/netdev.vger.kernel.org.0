Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A1D353E2
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 01:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfFDX3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 19:29:05 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47132 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727655AbfFDXYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 19:24:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dWIgDhv9e+tXmol+y8WvywrkiH6N9PLNU40QuJlGM6Q=; b=1wxzfboKaycP9fkpHlc+cM5Nt
        qmFtesSZYH2mOExJUroeLNvtRJ+OtsRYnt8gB6pge+ZGIpeoxrC2WkjQKhwL9klgqgkcG7hU80G8S
        cTGxVnxxu9EgHQT0LN7zcqfMXH7Cq4ZX0zwhy87W+9d7n/MA0r1w/779S50HScZLvv2SU8Rp0Zbxi
        tyfsvrR9jy41XXxu2Z/uenLHDS0pZj7j3aLGxUjMv2s2g2bBIMEY5vrfnrQ3CzL3J1FyNtLSPC6C1
        1mQV/UoFtCP6Be9Fv8PrpSW/LEZt822NGRgHtDTuB+58bU59Z+zxXyyC25KYertKEUoe+uBZh+Yfo
        xxf/HHgaw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56208)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hYInC-0004CW-R3; Wed, 05 Jun 2019 00:24:34 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hYInB-0001sX-BK; Wed, 05 Jun 2019 00:24:33 +0100
Date:   Wed, 5 Jun 2019 00:24:33 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
Message-ID: <20190604232433.4v2qqxyihqi2rmjl@shell.armlinux.org.uk>
References: <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <20190604211221.GW19627@lunn.ch>
 <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
 <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com>
 <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
 <CA+h21hrOPCVoDwbQa9uFVu3uVWtoP+2Vp2z94An2qtv=u8wWKg@mail.gmail.com>
 <20190604221626.4vjtsexoutqzblkl@shell.armlinux.org.uk>
 <CA+h21hrkQkBocwigiemhN_H+QJ3yWZaJt+aoBWhZiW3BNNQOXw@mail.gmail.com>
 <20190604225919.xpkykt2z3a7utiet@shell.armlinux.org.uk>
 <CA+h21hrT+XPfqePouzKB4UUfUawck831bKhAY6-BOunnvbmT1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hrT+XPfqePouzKB4UUfUawck831bKhAY6-BOunnvbmT1g@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 02:03:19AM +0300, Vladimir Oltean wrote:
> On Wed, 5 Jun 2019 at 01:59, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Wed, Jun 05, 2019 at 01:44:08AM +0300, Vladimir Oltean wrote:
> > > You caught me.
> > >
> > > But even ignoring the NIC case, isn't the PHY state machine
> > > inconsistent with itself? It is ok with callink phy_suspend upon
> > > ndo_stop, but it won't call phy_suspend after phy_connect, when the
> > > netdev is implicitly stopped?
> >
> > The PHY state machine isn't inconsistent with itself, but it does
> > have strange behaviour.
> >
> > When the PHY is attached, the PHY is resumed and the state machine
> > is in PHY_READY state.  If it goes through a start/stop cycle, the
> > state machine transitions to PHY_HALTED and attempts to place the
> > PHY into a low power state.  So the PHY state is consistent with
> > the state machine state (we don't end up in the same state but with
> > the PHY in a different state.)
> >
> > What we do have is a difference between the PHY state (and state
> > machine state) between the boot scenario, and the interface up/down
> > scenario, the latter behaviour having been introduced by a commit
> > back in 2013:
> >
> >     net: phy: suspend phydev when going to HALTED
> >
> >     When phydev is going to HALTED state, we can try to suspend it to
> >     safe more power. phy_suspend helper will check if PHY can be suspended,
> >     so just call it when entering HALTED state.
> >
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> > According to speedtest.net: 11.9Mbps down 500kbps up
> 
> I am really not into the PHYLIB internals, but basically what you're
> telling me is that running "ip link set dev eth0 down" is a
> stronger/more imperative condition than not running "ip link set dev
> eth0 up"... Does it also suspend the PHY if I put the interface down
> while it was already down?

No - but that has nothing to do with phylib internals, more to do with
the higher levels of networking.  ndo_stop() will not be called unless
ndo_open() has already been called.  In other words, setting an already
down device down via "ip link set dev eth0 down" is a no-op.

So, let's a common scenario.  You power up a board.  The PHY comes up
and establishes a link.  The boot loader runs, loads the kernel, which
then boots.  Your network driver is a module, and hasn't been loaded
yet.  The link is still up.

The modular network driver gets loaded, and initialises.  Userspace
does not bring the network device up, and the network driver does not
attach or connect to the PHY (which is actually quite common).  So,
the link is still up.

The modular PHY driver gets loaded, and binds to the PHY.  The link
is still up.

Userspace configures the network interface, which causes the PHY
device to be attached to the network device, and phy_start() to be
called on it - the negotiation advertisement is configured, and
negotiation restarted if necessary.

When userspace deconfigures the network interface, phy_stop() will
be called, and, as the network driver attached the PHY in its
ndo_open() function, the network driver will detach the PHY from
the network interface to reverse those effects.  The PHY will be
suspended, but more so than that, if there is a reset line, the
reset line will be activated to the PHY.

The above is an illustration of one sequence that /can/ happen.
Other sequences are also possible.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
