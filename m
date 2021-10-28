Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E1D43E3F8
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhJ1OlI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 Oct 2021 10:41:08 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:54037 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhJ1Ok5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 10:40:57 -0400
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 7BEA024000F;
        Thu, 28 Oct 2021 14:38:26 +0000 (UTC)
Date:   Thu, 28 Oct 2021 16:38:25 +0200
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
Message-ID: <20211028163825.7ccb1dea@xps-bootlin>
In-Reply-To: <20211028142254.mbm7gczhhb4h5g3n@skbuf>
References: <20211028134932.658167-1-clement.leger@bootlin.com>
        <20211028134932.658167-2-clement.leger@bootlin.com>
        <20211028140611.m7whuwrzqxp2t53f@skbuf>
        <20211028161522.6b711bb2@xps-bootlin>
        <20211028142254.mbm7gczhhb4h5g3n@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 28 Oct 2021 14:22:55 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> On Thu, Oct 28, 2021 at 04:15:22PM +0200, Clément Léger wrote:
> > Le Thu, 28 Oct 2021 14:06:12 +0000,
> > Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :
> >   
> > > On Thu, Oct 28, 2021 at 03:49:30PM +0200, Clément Léger wrote:  
> > > > Add support to get mac from device-tree using
> > > > of_get_mac_address.
> > > > 
> > > > Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> > > > ---
> > > >  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > > > b/drivers/net/ethernet/mscc/ocelot_vsc7514.c index
> > > > d51f799e4e86..c39118e5b3ee 100644 ---
> > > > a/drivers/net/ethernet/mscc/ocelot_vsc7514.c +++
> > > > b/drivers/net/ethernet/mscc/ocelot_vsc7514.c @@ -526,7 +526,10
> > > > @@ static int ocelot_chip_init(struct ocelot *ocelot, const
> > > > struct ocelot_ops *ops) ocelot_pll5_init(ocelot);
> > > >  
> > > > -	eth_random_addr(ocelot->base_mac);
> > > > +	ret = of_get_mac_address(ocelot->dev->of_node,
> > > > ocelot->base_mac);    
> > > 
> > > Why not per port? This is pretty strange, I think.  
> > 
> > Hi Vladimir,
> > 
> > Currently, all ports share the same base mac address (5 first
> > bytes). The final mac address per port is computed in
> > ocelot_probe_port by adding the port number as the last byte of the
> > mac_address provided.
> > 
> > Clément  
> 
> Yes, I know that, but that's not my point.
> Every switch port should be pretty much compliant with
> ethernet-controller.yaml, if it could inherit that it would be even
> better. And since mac-address is an ethernet-controller.yaml property,
> it is pretty much non-obvious at all that you put the mac-address
> property directly under the switch, and manually add 0, 1, 2, 3 etc
> to it. My request was to parse the mac-address property of each port.
> Like this:
> 
> base_mac = random;
> 
> for_each_port() {
> 	err = of_get_mac_address(port_dn, &port_mac);
> 	if (err)
> 		port_mac = base_mac + port;
> }

Ok indeed. So I will parse each port for a mac-address property. Do you
also want a fallback to use the switch base mac if not specified in
port or should I keep the use of a default random mac as the base
address anyway ?

> 
> > > > +	if (ret)
> > > > +		eth_random_addr(ocelot->base_mac);
> > > > +
> > > >  	ocelot->base_mac[5] &= 0xf0;
> > > >  
> > > >  	return 0;
> > > > -- 
> > > > 2.33.0  
> > >     
>   

