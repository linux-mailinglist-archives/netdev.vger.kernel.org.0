Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B8D17BA81
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 11:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCFKjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 05:39:47 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55524 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgCFKjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 05:39:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=r6CbwV5b+wmu+/jrv4vYTHJOiDQQtaW/MF+z+yttIdM=; b=rPf/GATiJCHLNcOawJ4gvVeHN
        2EhEJ0qpoSnHFp2WcsoGd4gy3UmSe8027s/CZ/BYNdj1mVskHnE++x5IbLxy8K91dyUNWxr5nBSNf
        6FkTn/032sb/TCFCmtqo6tGEeS+mD8W47XbaBg/2UFXtvsoWEO+vGLEyQqU18CVRNg3jURZiU0bRB
        vRtx2mQNPZGEu260VALJwK7HyPCQfsPyqCnaRTcfMUU1qslRKIVFNvJzAzjeiSCQ8/WdLgNGu/5FZ
        CPirrdQTzwIuq6SX/C1Zp1e8zU4sYFxWjyNb50+/QtWbYPG3U5vMzlHtqoYAXBGhFKQv0lx416bbQ
        DXVwA65pQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:49384)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jAAOH-00045n-OS; Fri, 06 Mar 2020 10:39:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jAAOE-0000OB-Qu; Fri, 06 Mar 2020 10:39:34 +0000
Date:   Fri, 6 Mar 2020 10:39:34 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 0/10] net: dsa: improve serdes integration
Message-ID: <20200306103934.GF25745@shell.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
 <20200305225407.GD25183@lunn.ch>
 <20200305234557.GE25745@shell.armlinux.org.uk>
 <20200306011310.GC2450@lunn.ch>
 <20200306035720.GD2450@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306035720.GD2450@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 06, 2020 at 04:57:20AM +0100, Andrew Lunn wrote:
> Hi Russell
> 
> > I will try to figure out which patch broke it.
> 
> ommit e67b45adefa8d43c68560906f3955845a5ee14d8 (HEAD)
> Author: Russell King <rmk+kernel@armlinux.org.uk>
> Date:   Thu Mar 5 12:42:26 2020 +0000
> 
>     net: dsa: mv88e6xxx: configure interface settings in mac_config
>     
>     Only configure the interface settings in mac_config(), leaving the
>     speed and duplex settings to mac_link_up to deal with.
> 
> Maybe:
> 
> 
> +       /* FIXME: should we force the link down here - but if we do, how
> +        * do we restore the link force/unforce state? The driver layering
> +        * gets in the way.
> +        */
> 
> ???

That's a possibility.  Is the MAC already configured for the interface
mode though?

The problem occurs because the CPU and DSA ports are forced up during
DSA initialisation, but phylink expects the link to initially be down.
So, one may think that simply forcing the link down here to work around
that would be a solution.

Unfortunately, that means that CPU and DSA ports without a fixed-link
spec will stay down because phylink won't call mac_link_up() - so we're
back to the poor integration of phylink for CPU and DSA ports problem.
Even if phylink /were/ to call mac_link_up() for that situation,
phylink has no information on the speed and duplex for such a port, so
speed and duplex would be nonsense.

That conversion is very problematical.

I do have some patches that solve it by changing phylink, but it's
quite a hack - the problem is detecting the uninitialised state in
phylink_start(), which is really quite late.  You can find them in my
"zii" branch:

net: dsa: mv88e6xxx: split out SPEED_MAX setting
net: phylink/dsa: fix DSA and CPU links

So, I think we're back to... what do we do about the broken phylink
integration for CPU and DSA ports.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
