Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7461B43F6FF
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 08:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhJ2GMK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Oct 2021 02:12:10 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:44389 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbhJ2GMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 02:12:09 -0400
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id E4A3E240003;
        Fri, 29 Oct 2021 06:09:37 +0000 (UTC)
Date:   Fri, 29 Oct 2021 08:09:37 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] net: ocelot: add support to get mac from
 device-tree
Message-ID: <20211029080937.152f1876@fixe.home>
In-Reply-To: <20211028145142.xjgd3u2xz7kpijtl@skbuf>
References: <20211028134932.658167-1-clement.leger@bootlin.com>
        <20211028134932.658167-2-clement.leger@bootlin.com>
        <20211028140611.m7whuwrzqxp2t53f@skbuf>
        <20211028161522.6b711bb2@xps-bootlin>
        <20211028142254.mbm7gczhhb4h5g3n@skbuf>
        <20211028163825.7ccb1dea@xps-bootlin>
        <20211028145142.xjgd3u2xz7kpijtl@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 28 Oct 2021 14:51:43 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> On Thu, Oct 28, 2021 at 04:38:25PM +0200, Clément Léger wrote:
> > Le Thu, 28 Oct 2021 14:22:55 +0000,
> > Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :
> >   
> > > On Thu, Oct 28, 2021 at 04:15:22PM +0200, Clément Léger wrote:  
> > > > Le Thu, 28 Oct 2021 14:06:12 +0000,
> > > > Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :
> > > >     
> > > > > On Thu, Oct 28, 2021 at 03:49:30PM +0200, Clément Léger
> > > > > wrote:    
> > > > > > Add support to get mac from device-tree using
> > > > > > of_get_mac_address.
> > > > > > 
> > > > > > Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> > > > > > ---
> > > > > >  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 5 ++++-
> > > > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > > > > > b/drivers/net/ethernet/mscc/ocelot_vsc7514.c index
> > > > > > d51f799e4e86..c39118e5b3ee 100644 ---
> > > > > > a/drivers/net/ethernet/mscc/ocelot_vsc7514.c +++
> > > > > > b/drivers/net/ethernet/mscc/ocelot_vsc7514.c @@ -526,7
> > > > > > +526,10 @@ static int ocelot_chip_init(struct ocelot
> > > > > > *ocelot, const struct ocelot_ops *ops)
> > > > > > ocelot_pll5_init(ocelot); 
> > > > > > -	eth_random_addr(ocelot->base_mac);
> > > > > > +	ret = of_get_mac_address(ocelot->dev->of_node,
> > > > > > ocelot->base_mac);      
> > > > > 
> > > > > Why not per port? This is pretty strange, I think.    
> > > > 
> > > > Hi Vladimir,
> > > > 
> > > > Currently, all ports share the same base mac address (5 first
> > > > bytes). The final mac address per port is computed in
> > > > ocelot_probe_port by adding the port number as the last byte of
> > > > the mac_address provided.
> > > > 
> > > > Clément    
> > > 
> > > Yes, I know that, but that's not my point.
> > > Every switch port should be pretty much compliant with
> > > ethernet-controller.yaml, if it could inherit that it would be
> > > even better. And since mac-address is an ethernet-controller.yaml
> > > property, it is pretty much non-obvious at all that you put the
> > > mac-address property directly under the switch, and manually add
> > > 0, 1, 2, 3 etc to it. My request was to parse the mac-address
> > > property of each port. Like this:
> > > 
> > > base_mac = random;
> > > 
> > > for_each_port() {
> > > 	err = of_get_mac_address(port_dn, &port_mac);
> > > 	if (err)
> > > 		port_mac = base_mac + port;
> > > }  
> > 
> > Ok indeed. So I will parse each port for a mac-address property. Do
> > you also want a fallback to use the switch base mac if not
> > specified in port or should I keep the use of a default random mac
> > as the base address anyway ?  
> 
> Isn't the pseudocode I posted above explicit enough? Sorry...
> Keep doing what the driver is doing right now, with an optional
> mac-address override per port.
> Why would we read the mac-address property of the switch? Which other
> switch driver does that? Are there device trees in circulation where
> this is being done?

BTW, this is actually done on sparx5 switch driver.

> 
> > > > > > +	if (ret)
> > > > > > +		eth_random_addr(ocelot->base_mac);
> > > > > > +
> > > > > >  	ocelot->base_mac[5] &= 0xf0;
> > > > > >  
> > > > > >  	return 0;
> > > > > > -- 
> > > > > > 2.33.0    
> > > > >       
> > >     
>   



-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
