Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4EF2C6D61
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 23:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732707AbgK0Wt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 17:49:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53636 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732690AbgK0Wqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 17:46:51 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kimVq-009Bkr-FW; Fri, 27 Nov 2020 23:46:46 +0100
Date:   Fri, 27 Nov 2020 23:46:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127224646.GA2073444@lunn.ch>
References: <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
 <20201126132418.zigx6c2iuc4kmlvy@skbuf>
 <20201126175607.bqmpwbdqbsahtjn2@skbuf>
 <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127204714.GX2073444@lunn.ch>
 <20201127131346.3d594c8e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127213244.GY2073444@lunn.ch>
 <20201127141402.417933f3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127141402.417933f3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 02:14:02PM -0800, Jakub Kicinski wrote:
> On Fri, 27 Nov 2020 22:32:44 +0100 Andrew Lunn wrote:
> > > > So long as these counters are still in ethtool -S, i guess it does not
> > > > matter. That i do trust to be accurate, and probably consistent across
> > > > the counters it returns.  
> > > 
> > > Not in the NIC designs I'm familiar with.  
> > 
> > Many NICs have a way to take a hardware snapshot of all counters.
> > You can then read them out as fast or slow as you want, since you
> > read the snapshot, not the live counters. As a result you can compare
> > counters against each other.
> 
> Curious, does Marvell HW do it?

Yes. Every generation of Marvell SOHO switch has this.

> IDK I find it very questionable if the system design doesn't take into
> account that statistics are retrieved every n seconds. We can perhaps
> scale the default period with the speed of the bus?

You don't actually have much choice. I2C is defined to run at
100Kbps. There is a fast mode which runs at 400Kbps. How do you design
around that? MDIO is around 2.5Mbps, but has 50% overhead from the
preamble. SPI can be up to 50Mbps, but there is no standard set of
speeds. None of the data sheets i've seen ever talk about recommended
scheduling polices for transactions over these busses. But testing has
shown, if you want good PTP, you need to keep them loaded as lightly
as possible. If you don't have PTP it becomes less important.

   Andrew
