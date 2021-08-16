Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904073ECBDB
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 02:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbhHPAGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 20:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbhHPAGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 20:06:25 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4799DC0613CF;
        Sun, 15 Aug 2021 17:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cfAWkMGWzzkKs9mNad95sbUPUcyj83ADf+VQ53dAXuM=; b=P0dk3kQ4dltUXGzd1kFWtlKg4
        OsnZXRoefVF93mY0eaNCldR/ZRutYSgAWzlkSvvuhA1CumO+vrZxW7LD5LVelHEke26SRA8+xco1p
        VCT9Eex8mYYQxF5oe2U605vGlfNmhEwbUQNUBQQgRFHA1y5u0ucmnrozZLPkp8MGmITN4DdvuZUHP
        xShrhBFdJbjodBQ0zryPhhiQIIG4npAmIrAilZgUzXP8+DwnA76J8aobzR+wUSp/4M/SghZwVTVQi
        elTJWYLFWXSJRnPZSHHQDyvVcazupLElpY1FyWXRaggQCySKxG3NvkFiePr5UpQqo/kCkFOMZb8qX
        jvrXxJuWg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47344)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mFQ8S-0006wu-6p; Mon, 16 Aug 2021 01:05:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mFQ8R-0007Qe-2s; Mon, 16 Aug 2021 01:05:47 +0100
Date:   Mon, 16 Aug 2021 01:05:47 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 09/10] net: dsa: ocelot: felix: add
 support for VSC75XX control over SPI
Message-ID: <20210816000546.GE22278@shell.armlinux.org.uk>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-10-colin.foster@in-advantage.com>
 <20210814114329.mycpcfwoqpqxzsyl@skbuf>
 <20210814120211.v2qjqgi6l3slnkq2@skbuf>
 <20210815204149.GB3328995@euler>
 <20210815231454.GD22278@shell.armlinux.org.uk>
 <20210815232753.GA3526284@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210815232753.GA3526284@euler>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 15, 2021 at 04:27:53PM -0700, Colin Foster wrote:
> On Mon, Aug 16, 2021 at 12:14:54AM +0100, Russell King (Oracle) wrote:
> > > diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > > index a84129d18007..d0b3f6be360f 100644
> > > --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> > > +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > > @@ -1046,7 +1046,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
> > >  	int rc;
> > >  
> > >  	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
> > > -				  sizeof(struct lynx_pcs *),
> > > +				  sizeof(struct phylink_pcs *),
> > >  				  GFP_KERNEL);
> > >  	if (!felix->pcs) {
> > >  		dev_err(dev, "failed to allocate array for PCS PHYs\n");
> > > @@ -1095,8 +1095,8 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
> > >  
> > >  	for (port = 0; port < felix->info->num_ports; port++) {
> > >  		struct ocelot_port *ocelot_port = ocelot->ports[port];
> > > +		struct phylink_pcs *phylink;
> > >  		struct mdio_device *pcs;
> > > -		struct lynx_pcs *lynx;
> > 
> > Normally, "phylink" is used to refer to the main phylink data
> > structure, so I'm not too thrilled to see it getting re-used for the
> > PCS. However, as you have a variable called "pcs" already, I suppose
> > you don't have much choice.
> > 
> > That said, it would be nice to have consistent naming through at
> > least a single file, and you do have "pcs" below to refer to this
> > same thing.
> > 
> > Maybe using plpcs or ppcs would suffice? Or maybe use the "long name"
> > of phylink_pcs ?
> 
> I noticed this as well. It seems to me like the mdio_device variable
> name of pcs is misleading, and perhaps should be "mdio" and phylink_pcs
> should be pcs, or any of the alternatives you suggested.

Yes, we could alternatively could use mdiodev for mdio devices,
which would free up "pcs" for use with struct phylink_pcs.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
