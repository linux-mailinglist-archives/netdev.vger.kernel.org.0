Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4DA18B248
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 12:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgCSLZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 07:25:41 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43042 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgCSLZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 07:25:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=M3SZPnC7Rmsrg1bRz2AgIM/I53b4DuL+NG8Nhk1rG1A=; b=iF/N+o/XfGoh1QxJdF94MAyH/
        V8juDEEGV9l7N04GZiooB9yOzDxbo6YiXcEmYp9ljIuXVpu+zsAuwJDA0oCUePOQM3Eg3/H/rCEPS
        5CDb8yvfyXfLdDpf9GEBn+oV54kGbzliH2qZrNOAyqiqwyD4zSD0CviC81fg/TrbupdfavXoylMwW
        Rp5a9rzjefhd3UcqZRuG+l3OjCX+DthBiICEmPaSLzs6sdJmpcSTJOZQWX5Chdj62Em3sFBOmw3Gs
        U+u/UEH2wHwvgqSZX2jG4lOG9kGv13ijQDj2M6xRr0HNMh4FRb8M7DtmJkeJQJuG1XyLYRC6Ih0zi
        QFl6pER+g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38516)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jEtIt-0001rg-Ub; Thu, 19 Mar 2020 11:25:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jEtIt-0004jf-3y; Thu, 19 Mar 2020 11:25:35 +0000
Date:   Thu, 19 Mar 2020 11:25:35 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: phy: add and use phy_check_downshift
Message-ID: <20200319112535.GD25745@shell.armlinux.org.uk>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
 <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
 <20200318232159.GA25745@shell.armlinux.org.uk>
 <b0bc3ca0-0c1b-045e-cd00-37fc85c4eebf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0bc3ca0-0c1b-045e-cd00-37fc85c4eebf@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 08:30:58AM +0100, Heiner Kallweit wrote:
> On 19.03.2020 00:21, Russell King - ARM Linux admin wrote:
> > On Wed, Mar 18, 2020 at 10:29:01PM +0100, Heiner Kallweit wrote:
> >> So far PHY drivers have to check whether a downshift occurred to be
> >> able to notify the user. To make life of drivers authors a little bit
> >> easier move the downshift notification to phylib. phy_check_downshift()
> >> compares the highest mutually advertised speed with the actual value
> >> of phydev->speed (typically read by the PHY driver from a
> >> vendor-specific register) to detect a downshift.
> > 
> > My personal position on this is that reporting a downshift will be
> > sporadic at best, even when the link has negotiated slower.
> > 
> > The reason for this is that either end can decide to downshift.  If
> > the remote partner downshifts, then the local side has no idea that
> > a downshift occurred, and can't report that the link was downshifted.
> > 
> Right, this warning can't cover the case that remote link partner
> downshifts. In this case however ethtool et al should show the reduced
> link partner advertisement, and therefore provide a hint why speed
> is slow.
> 
> > So, is it actually useful to report these events?
> > 
> To provide an example: A user recently complained that r8169 driver
> makes problems on his system:
> - it takes long time until link comes up
> - link is slow
> With iperf he then found out that displayed speed is 1Gbps but actual
> link speed is 100Mbps. In the end he found that one pin of his network
> port was corroded, therefore the downshift.
> 
> The phase of blaming the driver could have been skipped if he would
> have seen a downshift warning from the very beginning.

This sounds like a good theory to justify it, but it suffers from one
major flaw.

There was indeed a bug - the driver was reporting 1Gbps, whereas the
link was not operating at that speed, but at 100Mbps.  Had that bug
not existed, the kernel would've reported 100Mbps as the speed, and
then your justification in the first paragraph applies - the link
speed is slower than expected.

With that bug in place, this patch does nothing; you're using the same
algorithm to calculate what the speed should be and comparing it with
the same algorithm result reported from phy_resolve_aneg_linkmode().

So, the problem is going to remain.

The only time that this helps is if PHY drivers implement reading a
vendor register to report the actual link speed, and the PHY specific
driver is used.

Also, falling back to the generic PHY driver is going to result in the
same hard-to-debug problem that you refer to above.

So, do we need to print a big fat warning that the generic driver is
being used, and recommend the user uses the tailored driver instead?

There's lots of issues to consider here; it is not as simple as has
been suggested, and I'm not sure that this patch adds particularly
high value by really solving the problem.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
