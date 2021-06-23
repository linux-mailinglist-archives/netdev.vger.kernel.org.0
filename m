Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C683B217C
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhFWUEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:04:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52338 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWUEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 16:04:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HYBrxp5tq0Ks7zWa074honx4YXQ+703RX8SwQlCH2DY=; b=rqP6LofOBhrljR7O3Ptn+RknZt
        SfU8cgzDej1AP7IQrjzhiUTSLosK212UBV1pHaRhcm+jio0uTgZ6Zs3JBBLARB/Iq35DqaC+W1Ppl
        PvI36/AlOd7km9nCl4gp5wOuoN+AqcWR1D8VKQE3jPPAEamNCQ0Q8mGgfMtz6v8ZJngg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lw94E-00Aswz-7r; Wed, 23 Jun 2021 22:01:46 +0200
Date:   Wed, 23 Jun 2021 22:01:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@lists.infradead.org
Subject: Re: [RFC 2/3] net: Provide switchdev driver for NXP's More Than IP
 L2 switch
Message-ID: <YNOTKl7ZKk8vhcMR@lunn.ch>
References: <20210622144111.19647-1-lukma@denx.de>
 <20210622144111.19647-3-lukma@denx.de>
 <YNH7vS9FgvEhz2fZ@lunn.ch>
 <20210623133704.334a84df@ktm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623133704.334a84df@ktm>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Using volatile is generally wrong. Why do you need it?
> 
> This was the code, which I took from the legacy driver. I will adjust
> it.

It is called 'vendor crap' for a reason.

> > > +	for_each_available_child_of_node(p, port) {
> > > +		if (of_property_read_u32(port, "reg", &port_num))
> > > +			continue;
> > > +
> > > +		priv->n_ports = port_num;
> > > +
> > > +		fep_np = of_parse_phandle(port, "phy-handle", 0);  
> > 
> > As i said, phy-handle points to a phy. It minimum, you need to call
> > this mac-handle. But that then makes this switch driver very different
> > to every other switch driver.
> 
> Other drivers (DSA for example) use "ethernet" or "link" properties.
> Maybe those can be reused?

Not really. They have well known meanings and they are nothing like
what you are trying to do. You need a new name. Maybe 'mac-handle'?


> > > +		pdev = of_find_device_by_node(fep_np);
> > > +		ndev = platform_get_drvdata(pdev);
> > > +		priv->fep[port_num - 1] = netdev_priv(ndev);  
> > 
> > What happens when somebody puts reg=<42>; in DT?
> 
> I do guess that this will break the code.
> 
> However, DSA DT descriptions also rely on the exact numbering [1] (via
> e.g. reg property) of the ports. I've followed this paradigm.

DSA does a range check:

        for_each_available_child_of_node(ports, port) {
                err = of_property_read_u32(port, "reg", &reg);
                if (err)
                        goto out_put_node;

                if (reg >= ds->num_ports) {
                        dev_err(ds->dev, "port %pOF index %u exceeds num_ports (%zu)\n",
                                port, reg, ds->num_ports);
                        err = -EINVAL;
                        goto out_put_node;
                }

> > I would say, your basic structure needs to change, to make it more
> > like other switchdev drivers. You need to replace the two FEC device
> > instances with one switchdev driver.
> 
> I've used the cpsw_new.c as the example.
> 
> > The switchdev driver will then
> > instantiate the two netdevs for the two external MACs.
> 
> Then there is a question - what about eth[01], which already exists?

They don't exist. cpsw_new is not used at the same time as cpsw, it
replaces it. This new driver would replace the FEC driver. cpsw_new
makes use of some of the code in the cpsw driver to implement two
netdevs. This new FEC switch driver would do the same, make use of
some of the low level code, e.g. for DMA access, MDIO bus, etc.

> To be honest - such driver for L2 switch already has been forward
> ported by me [2] to v4.19.

Which is fine, you can do whatever you want in your own fork. But for
mainline, we need a clean architecture. I'm not convinced your code is
that clean, and how well future features can be added. Do you have
support for VLANS? Adding and removing entries to the lookup tables?
How will IGMP snooping work? How will STP work?

    Andrew
