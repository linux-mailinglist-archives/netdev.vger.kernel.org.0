Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD15D35CF6
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 14:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfFEMgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 08:36:07 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56410 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727663AbfFEMgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 08:36:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Jkh8aFGc1DIz53Nb1XQcPJN2NV8vK8Jl7GsP7J3fylo=; b=Os/wu0P1h69AAY1YbEgWZ/oba
        Msw4RJTG7mhF/TJHYmzGkYaWa1RO/YFyte+vedhgcaddt6WQf+Hoxe8Zlb08VOYsj+f11iik59tyO
        4VAmMVPxNOYcqLCYbVUOrk5465mIqxpPpUI8X5p1EDiEnHFPrZrL68aVNCr63tbKIcnzK4e97dqND
        ycBxfwaKmBOm8DEyvwWKr0b6i6wWJFNs4oN7d8xs2aywb0kg7jMMBywUvD6hmpEWLOyNgs4uOGhse
        c2GQVZmDe2kXMR/846kNKaSDL9FGKjBtsks69RYrHHocHDihk/IJNPMxpTEV8bFfCohNAYqOr5hSo
        cHA0A3LbQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56226)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hYV97-0007q7-2D; Wed, 05 Jun 2019 13:36:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hYV95-0002Pg-KA; Wed, 05 Jun 2019 13:35:59 +0100
Date:   Wed, 5 Jun 2019 13:35:59 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
Message-ID: <20190605123559.kpvapvmr7uwwpzif@shell.armlinux.org.uk>
References: <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com>
 <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
 <CA+h21hrOPCVoDwbQa9uFVu3uVWtoP+2Vp2z94An2qtv=u8wWKg@mail.gmail.com>
 <20190604221626.4vjtsexoutqzblkl@shell.armlinux.org.uk>
 <CA+h21hrkQkBocwigiemhN_H+QJ3yWZaJt+aoBWhZiW3BNNQOXw@mail.gmail.com>
 <20190604225919.xpkykt2z3a7utiet@shell.armlinux.org.uk>
 <CA+h21hrT+XPfqePouzKB4UUfUawck831bKhAY6-BOunnvbmT1g@mail.gmail.com>
 <20190604232433.4v2qqxyihqi2rmjl@shell.armlinux.org.uk>
 <CA+h21hpDyDLChzrqX19bU81+ss3psVesNftCqN7+7+GFkMe_-A@mail.gmail.com>
 <20190605121631.47icyavtcrnwddlg@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605121631.47icyavtcrnwddlg@shell.armlinux.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 01:16:31PM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Jun 05, 2019 at 02:46:13AM +0300, Vladimir Oltean wrote:
> > On Wed, 5 Jun 2019 at 02:24, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > > No - but that has nothing to do with phylib internals, more to do with
> > > the higher levels of networking.  ndo_stop() will not be called unless
> > > ndo_open() has already been called.  In other words, setting an already
> > > down device down via "ip link set dev eth0 down" is a no-op.
> > >
> > > So, let's a common scenario.  You power up a board.  The PHY comes up
> > > and establishes a link.  The boot loader runs, loads the kernel, which
> > > then boots.  Your network driver is a module, and hasn't been loaded
> > > yet.  The link is still up.
> > >
> > > The modular network driver gets loaded, and initialises.  Userspace
> > > does not bring the network device up, and the network driver does not
> > > attach or connect to the PHY (which is actually quite common).  So,
> > > the link is still up.
> > >
> > > The modular PHY driver gets loaded, and binds to the PHY.  The link
> > > is still up.
> > 
> > I would rather say, 'even if the link is not up, Linux brings it up
> > (possibly prematurely) via phy_resume'.
> > But let's consider the case where the link *was* up. The general idea
> > is 'implement your workarounds in whatever other way, that link is
> > welcome!'.
> 
> I think you've missed some of the nuances about my example scenario.
> 
> If your MAC driver expects the MII pins to be silent after it probes,
> this will not be the case in the scenario that I've given you.  The
> PHY won't be silenced here, even with your proposed changes.
> 
> > > Userspace configures the network interface, which causes the PHY
> > > device to be attached to the network device, and phy_start() to be
> > > called on it - the negotiation advertisement is configured, and
> > > negotiation restarted if necessary.
> 
> This is where your suggested modifications first take effect.
> 
> What I'm stating is that if you write your network driver to require
> that the PHY link is down after the network driver is probed but before
> ndo_open is called, in the above exact scenario, that will not be the
> case and your network driver may malfunction.
> 
> Having the kernel rely on a certain boot loader behaviour is very bad.
> 
> You also have to consider that the previous context to the kernel
> booting may _not_ be the boot loader - for example, if the kernel
> supports crash dump kexec, then the previous context to the crash
> kernel is the kernel which crashed, which may well have established a
> link on the network interface.
> 
> So, relying on the state of the hardware from the boot loader is a
> recipe for a buggy driver.

There is another reason to avoid having the MAC active while the PHY
is in low power mode.  From 802.3-2015 clause 45.2.1.1.2 Low power
(1.0.11):

"The behavior of the PMA/PMD in transition to and from the low-power
mode is implementation specific and any interface signals should not
be relied upon."

which is different to clause 22.2.4.1.5 Power down:

"During the transition to the power-down state and while in the
power-down state, the PHY shall not generate spurious signals on the
MII or GMII."

Since Clause 45 PHYs are supported by phylib, and can respond to
Clause 22 management frames, this is another reason why the MAC should
ignore any signals it receives from the PHY while the network interface
is down.

Of course, your specific situation, you may have a PHY that is compliant
with 22.2.4.1.5 rather than 45.2.1.1.2, but if you're writing a network
driver, you can't make that assumption, especially if you're going to be
submitting it to mainline.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
