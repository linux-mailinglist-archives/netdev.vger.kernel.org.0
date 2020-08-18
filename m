Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F8A248CF0
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 19:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgHRR23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 13:28:29 -0400
Received: from lists.nic.cz ([217.31.204.67]:34618 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbgHRR2U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 13:28:20 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8982:ed8c:62b1:c0c8])
        by mail.nic.cz (Postfix) with ESMTPSA id 2F3D113F681;
        Tue, 18 Aug 2020 19:28:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597771698; bh=ia0qpyvxe+8EfqQgdfF10pUW2KLH5fSmkSWOgE1NxUY=;
        h=Date:From:To;
        b=lgkuWlgTDLmxWw7G6ycDK+8eKu1qkTDdE98LRYDmhBUmZj+G0xSBfp3iyiNvauRTO
         m9jjs3tF6hzWv431kg7uPzU0JRi1NJOaFWiiuE0YAWKNdwEZDByamadnm5AkE4w+VQ
         sf4wvAXkVGkMnYT9VV9zYXxmfX6RuCe6a56P9g6E=
Date:   Tue, 18 Aug 2020 19:28:17 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 3/4] net: phy: marvell10g: change
 MACTYPE according to phydev->interface
Message-ID: <20200818192817.427b9b12@dellmb.labs.office.nic.cz>
In-Reply-To: <20200812155441.GR1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
        <20200810220645.19326-4-marek.behun@nic.cz>
        <20200811152144.GN1551@shell.armlinux.org.uk>
        <20200812164431.34cf569f@dellmb.labs.office.nic.cz>
        <20200812150054.GP1551@shell.armlinux.org.uk>
        <20200812154436.GH2141651@lunn.ch>
        <20200812155441.GR1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WHITELIST shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Aug 2020 16:54:41 +0100
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Wed, Aug 12, 2020 at 05:44:36PM +0200, Andrew Lunn wrote:
> > > I'm aware of that problem.  I have some experimental patches
> > > which add PHY interface mode bitmaps to the MAC, PHY, and SFP
> > > module parsing functions.  I have stumbled on some problems
> > > though - it's going to be another API change (and people are
> > > already whinging about the phylink API changing "too quickly",
> > > were too quickly seems to be defined as once in three years), and
> > > in some cases, DSA, it's extremely hard to work out how to
> > > properly set such a bitmap due to DSA's layered approach.  
> > 
> > Hi Russell
> > 
> > If DSAs layering is causing real problems, we could rip it out, and
> > let the driver directly interact with phylink. I'm not opposed to
> > that.  
> 
> The reason I mentioned it is because I have this unpublished patch
> (beware, whitespace damaged due to copy-n-pasted):
> 
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index c1967e08b017..ba32492f3ec0 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1629,6 +1629,12 @@ static int dsa_slave_phy_setup(struct
> net_device *slave_dev)
> 
>         dp->pl_config.dev = &slave_dev->dev;
>         dp->pl_config.type = PHYLINK_NETDEV;
> +       __set_bit(PHY_INTERFACE_MODE_SGMII,
> +                 dp->pl_config.supported_interfaces);
> +       __set_bit(PHY_INTERFACE_MODE_2500BASEX,
> +                 dp->pl_config.supported_interfaces);
> +       __set_bit(PHY_INTERFACE_MODE_1000BASEX,
> +                 dp->pl_config.supported_interfaces);
> 
>         /* The get_fixed_state callback takes precedence over polling
> the
>          * link GPIO in PHYLINK (see phylink_get_fixed_state).  Only
> set
> 
> Which clearly is a gross hack - this code certainly has no idea about
> what interfaces the port itself supports.  How do we get around that
> with DSA layering?
> 
> We could add yet-another-driver-call down into the DSA driver for it
> to fill in that information and keep the current structure.  However,
> is that really the best solution - to have lots of fine grained driver
> calls?
> 
> DSA feels to be very cumbersome and awkward to modify at least to me.
> Almost everything seems to be "add another driver call" at the DSA
> layer, followed by "add another sub-driver call" at the mv88e6xxx
> layer.
> 

So I am encountering this now when testing my SFP + marvell10g patches
on a board with SFP cage on a DSA port.

I get what you find cumbersome, but I don't think there is other
reasonable solution here. We already have .phylink_validate, which
works with ethtool mode mask. So maybe a .phylink_config_init ?

Marek
