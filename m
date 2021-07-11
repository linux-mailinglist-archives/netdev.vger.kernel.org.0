Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C95F3C3F9C
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 00:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhGKWQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 18:16:16 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:61429 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKWQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 18:16:16 -0400
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 0C4BC40004;
        Sun, 11 Jul 2021 22:13:24 +0000 (UTC)
Date:   Mon, 12 Jul 2021 00:13:24 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 net-next 7/8] net: dsa: ocelot: felix: add support
 for VSC75XX control over SPI
Message-ID: <YOttBHN7AJvqDXe8@piout.net>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
 <20210710192602.2186370-8-colin.foster@in-advantage.com>
 <20210710205205.blitrpvdwmf4au7z@skbuf>
 <20210711170927.GG2219684@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210711170927.GG2219684@euler>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/07/2021 10:09:27-0700, Colin Foster wrote:
> On Sat, Jul 10, 2021 at 11:52:05PM +0300, Vladimir Oltean wrote:
> > On Sat, Jul 10, 2021 at 12:26:01PM -0700, Colin Foster wrote:
> > > +static const struct felix_info ocelot_spi_info = {
> > > +	.target_io_res			= vsc7512_target_io_res,
> > > +	.port_io_res			= vsc7512_port_io_res,
> > > +	.regfields			= vsc7512_regfields,
> > > +	.map				= vsc7512_regmap,
> > > +	.ops				= &vsc7512_ops,
> > > +	.stats_layout			= vsc7512_stats_layout,
> > > +	.num_stats			= ARRAY_SIZE(vsc7512_stats_layout),
> > > +	.vcap				= vsc7512_vcap_props,
> > > +	.num_mact_rows			= 1024,
> > > +
> > > +	/* The 7512 and 7514 both have support for up to 10 ports. The 7511 and
> > > +	 * 7513 have support for 4. Due to lack of hardware to test and
> > > +	 * validate external phys, this is currently limited to 4 ports.
> > > +	 * Expanding this to 10 for the 7512 and 7514 and defining the
> > > +	 * appropriate phy-handle values in the device tree should be possible.
> > > +	 */
> > > +	.num_ports			= 4,
> > 
> > Ouch, this was probably not a good move.
> > felix_setup() -> felix_init_structs sets ocelot->num_phys_ports based on
> > this value.
> > If you search for ocelot->num_phys_ports in ocelot and in felix, it is
> > widely used to denote "the index of the CPU port module within the
> > analyzer block", since the CPU port module's number is equal to the
> > number of the last physical port + 1. If VSC7512 has 10 ports, then the
> > CPU port module is port 10, and if you set num_ports to 4 you will cause
> > the driver to misbehave.
> 
> Yes, this is part of my concern with the CPU / NPI module mentioned
> before. In my hardware, I'd have port 0 plugged to the external CPU. In
> Ocelot it is the internal bus, and in Felix it is the NPI. In this SPI
> design, does the driver lose significant functionality by not having
> access to those ports?
> 

From the switchdev driver perspective, the CPU port is special because
it is the one allowing to send and receive frames to/from the exposed
ethernet interfaces. However, the goal is definitively to use that as
little as possible (especially since as implemented right now,
throughput is about 20Mbps).

I didn't have a look at the DSA implementation but I wouldn't expect the
NPI port to be that special.

> In my test setup (and our expected production) we'd have port 0
> connected to the external chip, and ports 1-3 exposed. Does Ocelot need
> to be modified to allow a parameter for the CPU port?
> 

DSA is what allows you to select which of the port is the port connected
to the BBB (this is the CPU port in DSA parlance). This is what you see
in the example in Documentation/devicetree/bindings/net/dsa/ocelot.txt

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
