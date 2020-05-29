Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5CC1E77FC
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 10:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgE2IOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 04:14:48 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:51707 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgE2IOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 04:14:47 -0400
X-Originating-IP: 86.202.110.81
Received: from localhost (lfbn-lyo-1-15-81.w86-202.abo.wanadoo.fr [86.202.110.81])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 225082000D;
        Fri, 29 May 2020 08:14:42 +0000 (UTC)
Date:   Fri, 29 May 2020 10:14:41 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: Re: [PATCH net-next 11/11] net: dsa: ocelot: introduce driver for
 Seville VSC9953 switch
Message-ID: <20200529081441.GW3972@piout.net>
References: <20200527234113.2491988-1-olteanv@gmail.com>
 <20200527234113.2491988-12-olteanv@gmail.com>
 <20200528215618.GA853774@lunn.ch>
 <CA+h21hoVQPVJiYDQV7j+d7Vt8o5rK+Z8APO2Hp85Dt8cOU7e4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hoVQPVJiYDQV7j+d7Vt8o5rK+Z8APO2Hp85Dt8cOU7e4w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/05/2020 01:09:16+0300, Vladimir Oltean wrote:
> On Fri, 29 May 2020 at 00:56, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > Extending the Felix driver to probe a PCI as well as a platform device
> > > would have introduced unnecessary complexity. The 'meat' of both drivers
> > > is in drivers/net/ethernet/mscc/ocelot*.c anyway, so let's just
> > > duplicate the Felix driver, s/Felix/Seville/, and define the low-level
> > > bits in seville_vsc9953.c.
> >
> > Hi Vladimir
> >
> > That has resulted in a lot of duplicated code.
> >
> > Is there an overall family name for these switch?
> >
> > Could you add foo_set_ageing_time() with both felix and saville share?
> >
> >       Andrew
> 
> Yes, it looks like I can. I can move Felix PCI probing to
> felix_vsc9959.c, Seville platform device probing to seville_vsc9953.c,
> and remove seville.c.
> I would not be in a position to know whether there's any larger family
> name which should be used here. According to
> https://media.digikey.com/pdf/Data%20Sheets/Microsemi%20PDFs/Ocelot_Family_of_Ethernet_Switches_Dec2016.pdf,
> "Ocelot is a low port count, small form factor Ethernet switch family
> for the Industrial IoT market". Seville would not qualify as part of
> the Ocelot family (high port count, no 1588) but that doesn't mean it
> can't use the Ocelot driver. As confusing as it might be for the
> people at Microchip, I would tend to call anything that probes as pure
> switchdev "ocelot" and anything that probes as DSA "felix", since

As ocelot can be used in a DSA configuration (even if it is not
implemented yet), I don't think this would be correct. From my point of
view, felix and seville are part of the ocelot family.

> these were the first 2 drivers that entered mainline. Under this
> working model, Seville would reuse the struct dsa_switch_ops
> felix_switch_ops, while having its own low-level seville_vsc9953.c
> that deals with platform integration specific stuff (probing, internal
> MDIO, register map, etc), and the felix_switch_ops would call into
> ocelot for the common functionalities.
> What do you think?
> 
> -Vladimir

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
