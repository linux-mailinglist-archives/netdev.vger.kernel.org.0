Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED93B2459EB
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 00:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgHPWjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 18:39:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55658 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgHPWjn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 18:39:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7RJV-009dS1-70; Mon, 17 Aug 2020 00:39:41 +0200
Date:   Mon, 17 Aug 2020 00:39:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next 5/7] net: dsa: mv88e6xxx: Add devlink regions
Message-ID: <20200816223941.GC2294711@lunn.ch>
References: <20200816194316.2291489-1-andrew@lunn.ch>
 <20200816194316.2291489-6-andrew@lunn.ch>
 <20200816221205.mspo63dohn7pvxg4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200816221205.mspo63dohn7pvxg4@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static const struct devlink_region_ops *mv88e6xxx_region_port_ops[] = {
> > +	&mv88e6xxx_region_port_0_ops,
> > +	&mv88e6xxx_region_port_1_ops,
> > +	&mv88e6xxx_region_port_2_ops,
> > +	&mv88e6xxx_region_port_3_ops,
> > +	&mv88e6xxx_region_port_4_ops,
> > +	&mv88e6xxx_region_port_5_ops,
> > +	&mv88e6xxx_region_port_6_ops,
> > +	&mv88e6xxx_region_port_7_ops,
> > +	&mv88e6xxx_region_port_8_ops,
> > +	&mv88e6xxx_region_port_9_ops,
> > +	&mv88e6xxx_region_port_10_ops,
> > +	&mv88e6xxx_region_port_11_ops,
> > +};
> > +
> 
> Sounds like there should maybe be an abstraction for 'per-port regions' in
> devlink? I think your approach hardly scales if you start having
> switches with more than 11 ports.

mv88e6xxx is unlikely to have more an 11 ports. Marvell had to move
bits around in registers in non-compatible ways to support the 6390
family with this number of ports. I doubt we will ever see a 16 port
mv88e6xxx switch, the registers are just too congested.

So this scales as far as it needs to scale.

> > +/* The ATU entry varies between chipset generations. Define a generic
> > + * format which covers all the current and hopefully future
> > + * generations
> > + */
> 
> Could you please present this generic format to us? Maybe my interpretation of
> the word "generic" is incorrect in this context?

I mean generic across all mv88e6xxx switches. The fid has been slowly
getting bigger from generation to generation. If i remember correctly,
it start off as 6 bits. 2 more bits we added, in a different
register. Then it got moved into a new register and made 14 bits in
size. There are also some bits in the atu_op register which changed
meaning over time.

In order to decode any of this information in the regions, you need to
known the specific switch the dump came from. But that is the whole
point of regions.

https://www.kernel.org/doc/html/latest/networking/devlink/devlink-region.html

   As regions are likely very device or driver specific, no generic
   regions are defined. See the driver-specific documentation files
   for information on the specific regions a driver supports.

This should also make the context of 'generic' more clear.

     Andrew
