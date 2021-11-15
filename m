Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D89645036A
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 12:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbhKOLbc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Nov 2021 06:31:32 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38055 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbhKOLbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 06:31:22 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 4E18760012;
        Mon, 15 Nov 2021 11:28:20 +0000 (UTC)
Date:   Mon, 15 Nov 2021 12:24:32 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 1/6] net: ocelot: add support to get port mac from
 device-tree
Message-ID: <20211115122432.273d09b5@fixe.home>
In-Reply-To: <a12f593a-a9e4-44bf-1740-92303ceb1dc3@linux.ibm.com>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
        <20211103091943.3878621-2-clement.leger@bootlin.com>
        <a12f593a-a9e4-44bf-1740-92303ceb1dc3@linux.ibm.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 15 Nov 2021 13:19:49 +0200,
Julian Wiedmann <jwi@linux.ibm.com> a écrit :

> On 03.11.21 11:19, Clément Léger wrote:
> > Add support to get mac from device-tree using of_get_mac_address.
> > 
> > Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> > ---
> >  drivers/net/ethernet/mscc/ocelot_net.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> > index eaeba60b1bba..d76def435b23 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_net.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> > @@ -1704,7 +1704,10 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
> >  		NETIF_F_HW_TC;
> >  	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
> >  
> > -	eth_hw_addr_gen(dev, ocelot->base_mac, port);
> > +	err = of_get_mac_address(portnp, dev->dev_addr);  
> 
> of_get_ethdev_address() maybe, so that this gets routed through Jakub's fancy
> new eth_hw_addr_set() infrastructure?

Hi Julian,

Acked, I will use that.

> 
> > +	if (err)
> > +		eth_hw_addr_gen(dev, ocelot->base_mac, port);
> > +
> >  	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr,
> >  			  OCELOT_VLAN_UNAWARE_PVID, ENTRYTYPE_LOCKED);
> >  
> >   
> 



-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
