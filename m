Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D722EFC4E
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbhAIAqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:46:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58324 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAIAqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 19:46:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ky2Nn-00GzvR-Fx; Sat, 09 Jan 2021 01:45:31 +0100
Date:   Sat, 9 Jan 2021 01:45:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Brian Silverman <silvermanbri@gmail.com>, netdev@vger.kernel.org
Subject: Re: MDIO over I2C driver driver probe dependency issue
Message-ID: <X/j8qw+g1P7WCmlH@lunn.ch>
References: <CAJKO-jaewzeB2X-hZ4EiZiyvaKqH=B0CrhvC_buqfMTcns-b-w@mail.gmail.com>
 <4606bd55-55a6-1e81-a23b-f06230ffdb52@gmail.com>
 <X/hhT4Sz9FU4kiDe@lunn.ch>
 <CAJKO-jYwineOM5wc+FX=Nj3AOfKK06qK-iqQSP3uQufNRnuGWQ@mail.gmail.com>
 <X/jIx/brD6Aw+4sk@lunn.ch>
 <68bfbe38-5a3a-598c-25d7-dad33253ee9f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68bfbe38-5a3a-598c-25d7-dad33253ee9f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 02:11:31PM -0800, Florian Fainelli wrote:
> On 1/8/2021 1:04 PM, Andrew Lunn wrote:
> > On Fri, Jan 08, 2021 at 03:02:52PM -0500, Brian Silverman wrote:
> >> Thanks for the responses - I now have a more clear picture of what's going on.
> >>  (Note: I'm using Xilinx's 2019.2 kernel (based off 4.19).  I believe it would
> >> be similar to latest kernels, but I could be wrong.)
> > 
> > Hi Brian
> > 
> > macb_main has had a lot of changes with respect to PHYs. Please try
> > something modern, like 5.10.
> 
> It does not seem to me like 5.10 will be much better, because we have
> the following in PHYLINK:
> 
> int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
>                              u32 flags)
> ...
>           phy_dev = of_phy_find_device(phy_node);
>           /* We're done with the phy_node handle */
>           of_node_put(phy_node);
>           if (!phy_dev)
>                   return -ENODEV;
> 
> Given Brian's configuration we should be returning -EPROBE_DEFER here,
> but doing that would likely break a number of systems that do expect
> -ENODEV to be returned.

I just looked through the current users of phylink_of_phy_connect().
Most simply do a netdev_err() and return the error code to higher
levels. So apart from the spurious netdev_err() is -EPROBE_DEFER is
returned, they should do the right thing.

mvneta actually looks broken, it prints the error, but keeps going,
plays with WOL setings on the phy and device_set_wake() then returns
the error code.

macb is a bit more complex, but if i'm understanding it correctly, it
should handle -EPROBE_DEFER already, but you will get a spurious
netdev_err() for the -EPROBE_DEFER.

So i think we can fix this, and we should probably do it before there
are more users.

Brian, can you run a modern kernel to test patches, or do you need to
use the Xilinx fork?

    Andrew
