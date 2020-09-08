Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7B1261C95
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIHTWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:22:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50720 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732029AbgIHTWq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 15:22:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kFjCJ-00Dpav-N9; Tue, 08 Sep 2020 21:22:31 +0200
Date:   Tue, 8 Sep 2020 21:22:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next v2 5/7] net: dsa: mv88e6xxx: Add devlink regions
Message-ID: <20200908192231.GB3290129@lunn.ch>
References: <20200908005155.3267736-1-andrew@lunn.ch>
 <20200908005155.3267736-6-andrew@lunn.ch>
 <20200908120100.77cfcfa1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908120100.77cfcfa1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 12:01:06PM -0700, Jakub Kicinski wrote:
> On Tue,  8 Sep 2020 02:51:53 +0200 Andrew Lunn wrote:
> > Allow ports, the global registers, and the ATU to be snapshot via
> > devlink regions.
> > 
> > v2:
> > Remove left over debug prints
> > Comment ATU format is generic for mv88e6xxx, not wider
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> Probably best CCing devlink maintainers on devlink patches.
> 
> Also - it's always useful to include show command outputs in the commit
> message for devlink patches.

Hi Jakub

root@rap:~# devlink region dump mdio_bus/gpio-0:00/port5 snapshot 42
0000000000000000 0f 10 03 00 00 00 01 39 7c 00 00 00 df 07 01 00 
0000000000000010 80 20 01 00 00 80 20 00 00 00 00 00 00 00 00 91 
0000000000000020 00 00 00 00 00 00 00 00 00 00 00 00 22 00 00 00 
0000000000000030 00 00 00 00 c0 01 00 80 00 00 00 00 00 00 00 00 

Not very informative. The whole point of devlink regions is that they
are suppose to be specific to a device, and you need intimate
knowledge of the device to decode it.

> > +#define PORT_REGION_OPS(_X_)						\
> > +static struct devlink_region_ops mv88e6xxx_region_port_ ## _X_ ## _ops = { \
> > +	.name = "port" #_X_,						\
> > +	.snapshot = mv88e6xxx_region_port_ ## _X_ ## _snapshot,		\
> > +	.destructor = kfree,						\
> > +}
> 
> This is a little awkward, can we make devlink pass the region pointer
> back to the callback instead? Plus perhaps an ability to allocate "priv"
> data inside the region would also h

Yes, this API is not easy to use. I suspect it is because it was
developed to support 'core dump' of the firmware, and you only have
one core to dump.

> > +PORT_REGION_OPS(0);
> > +PORT_REGION_OPS(1);
> > +PORT_REGION_OPS(2);
> > +PORT_REGION_OPS(3);
> > +PORT_REGION_OPS(4);
> > +PORT_REGION_OPS(5);
> > +PORT_REGION_OPS(6);
> > +PORT_REGION_OPS(7);
> > +PORT_REGION_OPS(8);
> > +PORT_REGION_OPS(9);
> > +PORT_REGION_OPS(10);
> > +PORT_REGION_OPS(11);
> > +
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
> 
> Ahh, seems like regions will get a per-port incarnation as some point as
> well..

Again, i think this is back to the history of dumping firmware core.
I guess the existing users don't have per port CPUs which could dump a
core.

	Andrew
