Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3522610476D
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 01:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfKUATK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 19:19:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48678 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfKUATK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 19:19:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=z8TpGyPkN/p6hj6xK/93Z7LOZPrtWo7AAZ1PB0/RZDI=; b=BO6QvKriOH/Y2xsYKz8gxC1eKg
        Dx3vpTWzq6MnsGlkfhaBiUovEEAxR8MzsQ4B//oLfeHSmUNQ9QN1ej+MR9pLw4bvGXjzm09OzVv3E
        Z57dQboT9awPaMUTAiuVYr5syiJC5R+XqZEF5sXxn4nhIuGHFP/k9Vg3JYPJxzbuMPu0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXaBT-0006mF-N1; Thu, 21 Nov 2019 01:18:55 +0100
Date:   Thu, 21 Nov 2019 01:18:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] Convert Ocelot and Felix switches to PHYLINK
Message-ID: <20191121001855.GC18325@lunn.ch>
References: <20191118181030.23921-1-olteanv@gmail.com>
 <20191118231339.ztotkr536udxuzsl@soft-dev3.microsemi.net>
 <CA+h21hpKN+7ifvFUt6KMYARf19i=Jfw_dwciuPxPC6ZyHRF2XQ@mail.gmail.com>
 <20191119204855.vgiwtrzx3426hbrc@soft-dev3.microsemi.net>
 <20191119214257.GB19542@lunn.ch>
 <20191120120849.xdizdx4vntor2fvv@soft-dev3.microsemi.net>
 <CA+h21hpDL=cLsZXyyk3V7=gQnaf-ZdyyuHjcaZ-DY+zRUcnJOw@mail.gmail.com>
 <20191120232152.p22rfjdngm4wtmak@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120232152.p22rfjdngm4wtmak@soft-dev3.microsemi.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Not really, at that point it was OK to have interface
> PHY_INTERFACE_MODE_NA. There were few more checks before creating the
> network device. Now with your changes you were creating
> a network device for each port of the soc even if some ports
> were not used on a board.

That does not sound right. If the port is not used, the DSA core will
call port_disable() to allow the driver to power off the port. It will
not create a network device for it.

Or is this just an issue with the switchdev driver, not the DSA
driver?

	Andrew
> > >                 serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
> > > -               if (IS_ERR(serdes)) {
> > > -                       err = PTR_ERR(serdes);
> > > -                       if (err == -EPROBE_DEFER)
> > > -                               dev_dbg(ocelot->dev, "deferring probe\n");
> > 
> > Why did you remove the probe deferral for the serdes phy?
> Because not all the ports have the "phys" property.

You probably need to differentiate between ENODEV and EPROBE_DEFER.
You definitely do need to return EPROBE_DEFER if you get that.  Shame
you cannot use devm_phy_optional_get().

    Andrew
