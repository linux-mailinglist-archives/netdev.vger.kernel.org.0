Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D64C17BF99
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgCFNxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:53:36 -0500
Received: from lists.nic.cz ([217.31.204.67]:52534 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgCFNxg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:53:36 -0500
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 096CF13FB6E;
        Fri,  6 Mar 2020 14:53:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1583502813; bh=eQEiA3dk2iJAewQHiH+isCedKTwGVm/X5TXqlyrQ/AU=;
        h=Date:From:To;
        b=GrNdnaemQs000oCNFEjLSoG+fye6+K0UI4H1gS/FekoGMvUTGRMnEi7EsV8mjP9ui
         2xp7EanUejIZKVkw/SPzL1erOoB82nBLrWYbZDazLYMrhF2mUA6aH4PVy7ST4amdVn
         VFYtYOFanO7uQamlL84DW5dxgfkB9IQG3L4bjoBQ=
Date:   Fri, 6 Mar 2020 14:53:32 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 0/10] net: dsa: improve serdes integration
Message-ID: <20200306145332.7b7a85da@nic.cz>
In-Reply-To: <20200306103934.GF25745@shell.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
        <20200305225407.GD25183@lunn.ch>
        <20200305234557.GE25745@shell.armlinux.org.uk>
        <20200306011310.GC2450@lunn.ch>
        <20200306035720.GD2450@lunn.ch>
        <20200306103934.GF25745@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,URIBL_BLOCKED,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.101.4 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Mar 2020 10:39:34 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Fri, Mar 06, 2020 at 04:57:20AM +0100, Andrew Lunn wrote:
> > Hi Russell
> >   
> > > I will try to figure out which patch broke it.  
> > 
> > ommit e67b45adefa8d43c68560906f3955845a5ee14d8 (HEAD)
> > Author: Russell King <rmk+kernel@armlinux.org.uk>
> > Date:   Thu Mar 5 12:42:26 2020 +0000
> > 
> >     net: dsa: mv88e6xxx: configure interface settings in mac_config
> >     
> >     Only configure the interface settings in mac_config(), leaving the
> >     speed and duplex settings to mac_link_up to deal with.
> > 
> > Maybe:
> > 
> > 
> > +       /* FIXME: should we force the link down here - but if we do, how
> > +        * do we restore the link force/unforce state? The driver layering
> > +        * gets in the way.
> > +        */
> > 
> > ???  
> 
> That's a possibility.  Is the MAC already configured for the interface
> mode though?
> 
> The problem occurs because the CPU and DSA ports are forced up during
> DSA initialisation, but phylink expects the link to initially be down.
> So, one may think that simply forcing the link down here to work around
> that would be a solution.
> 
> Unfortunately, that means that CPU and DSA ports without a fixed-link
> spec will stay down because phylink won't call mac_link_up() - so we're
> back to the poor integration of phylink for CPU and DSA ports problem.
> Even if phylink /were/ to call mac_link_up() for that situation,
> phylink has no information on the speed and duplex for such a port, so
> speed and duplex would be nonsense.
> 
> That conversion is very problematical.
> 
> I do have some patches that solve it by changing phylink, but it's
> quite a hack - the problem is detecting the uninitialised state in
> phylink_start(), which is really quite late.  You can find them in my
> "zii" branch:
> 
> net: dsa: mv88e6xxx: split out SPEED_MAX setting
> net: phylink/dsa: fix DSA and CPU links
> 
> So, I think we're back to... what do we do about the broken phylink
> integration for CPU and DSA ports.
> 

What I have been wondering about is if it would make sense to have the
ability to set CPU/DSA link settings from userspace. Currently the
CPU and DSA ports do not correspond to any system interface, so this is
impossible via ethtool. I have been thinking about how this could be
done.

What I don't like about current implementation is that it is impossible
to query the DSA ports from userspace.

For example in a configuration when eth0 is connected to port 5 on
Topaz, and ports 1-4 are lan1 - lan4, when I query statistics via
ethtool, on interfaces lanN I get staticstics for the swithc ports 1-4.
On interface eth0 the driver passes stats from the network interface on
the SOC and also stats from switch port 5.

But when there are two switches cascaded, there is currently no way to
query for stats on their DSA ports.

Sure, it could be solved by adding DSA ports into
dsa_master_get_ethtool_stats. But if DSA ports somehow could be queried
via ethtool, this problem could be solved.

Marek
