Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D9418BD9B
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 18:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgCSRIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 13:08:32 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:47376 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbgCSRIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 13:08:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fVFZmkjcJn/sMhldB84aRj3HOM0Jf6QB3jp0ONtLI4k=; b=u7mugA91BuO+3Yq+6ncpB3+Zr
        8FRtYy4VLIFpF+ekNXEfrggaXeHSlhoxehTY2LIQjc1ULDm4nmvAtIcEL766D0Q3rmw8oP7NxpAmH
        /l6oFR1s2eq0qEQOEfbjUid3TcI2D+A1sSmAzTlmlUYWUw4p9BgWwK6sZnuFuuR/eiB3PkYilxTgf
        ZP/ohWCBnl9zi3vdG2TmPuzyh7QUexTRZstXBzzobFj+4Dj96NQNu8F+UEIQK4fBFedPN4fbH2Gmd
        vFOnOApiVys9R6Lt7v1IK3ZwN8lXKZIxU0235H/qObAs5hH44nLhlS5ltxCGzciA5SuedsI3U1/cl
        8E/V9I7vQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38626)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEyee-0003Pa-6Z; Thu, 19 Mar 2020 17:08:24 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEyeb-0004vq-H3; Thu, 19 Mar 2020 17:08:21 +0000
Date:   Thu, 19 Mar 2020 17:08:21 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: add and use phy_check_downshift
Message-ID: <20200319170821.GF25745@shell.armlinux.org.uk>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
 <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
 <20200318232159.GA25745@shell.armlinux.org.uk>
 <b0bc3ca0-0c1b-045e-cd00-37fc85c4eebf@gmail.com>
 <20200319112535.GD25745@shell.armlinux.org.uk>
 <20200319130429.GC24972@lunn.ch>
 <20200319135800.GE25745@shell.armlinux.org.uk>
 <92689def-4bbf-8988-3137-f3cfb940e9fc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92689def-4bbf-8988-3137-f3cfb940e9fc@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 05:36:30PM +0100, Heiner Kallweit wrote:
> On 19.03.2020 14:58, Russell King - ARM Linux admin wrote:
> > On Thu, Mar 19, 2020 at 02:04:29PM +0100, Andrew Lunn wrote:
> >>> The only time that this helps is if PHY drivers implement reading a
> >>> vendor register to report the actual link speed, and the PHY specific
> >>> driver is used.
> >>
> >> So maybe we either need to implement this reading of the vendor
> >> register as a driver op, or we have a flag indicating the driver is
> >> returning the real speed, not the negotiated speed?
> > 
> > I'm not sure it's necessary to have another driver op.  How about
> > this for an idea:
> > 
> > - add a flag to struct phy_device which indicates the status of
> >   downshift.
> > - on link-up, check the flag and report whether a downshift occurred,
> >   printing whether a downshift occurred in phy_print_status() and
> >   similar places.  (Yes, I know that there are some network drivers
> >   that don't use phy_print_status().)
> > 
> > The downshift flag could be made tristate - "unknown", "not downshifted"
> > and "downshifted" - which would enable phy_print_status() to indicate
> > whether there is downshift supported (and hence whether we need to pay
> > more attention to what is going on when there is a slow-link report.)
> > 
> > Something like:
> > 
> > For no downshift:
> > 	Link is Up - 1Gbps/Full - flow control off
> > For downshift:
> > 	Link is Up - 100Mbps/Full (downshifted) - flow control off
> > For unknown:
> > 	Link is Up - 1Gbps/Full (unknown downshift) - flow control off
> > 
> > which has the effect of being immediately obvious if the driver lacks
> > support.
> > 
> > We may wish to consider PHYs which support no downshift ability as
> > well, which should probably set the status to "not downshifted" or
> > maybe an "unsupported" state.
> > 
> > This way, if we fall back to the generic PHY driver, we'd get the
> > "unknown" state.
> > 
> 
> I'd like to split the topics. First we have downshift detection,
> then we have downshift reporting/warning.
> 
> *Downshift detection*
> Prerequisite of course is that the PHY supports reading the actual,
> possibly downshifted link speed (typically from a vendor-specific
> register). Then the PHY driver has to set phydev->speed to the
> actual link speed in the read_status() implementation.
> 
> For the actual downshift detection we have two options:
> 1. PHY provides info about a downshift event in a vendor-specific
>    register or as an interrupt source.
> 2. The generic method, compare actual link speed with the highest
>    mutually advertised speed.
> So far I don't see a benefit of option 1. The generic method is
> easier and reduces complexity in drivers.
> 
> The genphy driver is a fallback, and in addition may be intentionally
> used for PHY's that have no specific features. A PHY with additional
> features in general may or may not work properly with the genphy
> driver. Some RTL8168-internal PHY's fail miserably with the genphy
> driver. I just had a longer discussion about it caused by the fact
> that on some distributions r8169.ko is in initramfs but realtek.ko
> is not.
> On a side note: Seems that so far the kernel doesn't provide an
> option to express a hard module dependency that is not a code
> dependency.

So how do we address the "fallback to genphy driver" problem for PHYs
that do mostly work with genphy?  It is very easy to do, for example
by omitting the PHY specific driver from the kernel configuration.
Since the system continues to work in these cases, it may go unnoticed.

> *Downshift reporting/warning*
> In most cases downshift is caused by some problem with the cabling.
> Users like the typical Ubuntu user in most cases are not familiar
> with the concept of PHY downshift and what causes a downshift.
> Therefore it's not sufficient to just report a downshift, we have
> to provide the user with a hint what to do.
> Adding the "downshifted" info to phy_print_status() is a good idea,
> however I'd see it as an optional addition to the mentioned hint
> to the user what to do.
> The info "unknown downshift" IMO would just cause confusion. If we
> have nothing to say, then why say something. Also users may interpret
> "unknown" as "there's something wrong".

So you think reporting not-downshifted and no downshift capability
implemented by the driver should appear to be identical?

You claimed as part of the patch description that a downshifted link
was difficult to diagnose; it seems you aren't actually solving that
problem - and in that case I would suggest that you should not be
mentioning it in the commit log.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
