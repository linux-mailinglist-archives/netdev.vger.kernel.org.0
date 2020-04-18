Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B43E51AEEC3
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 16:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgDROjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 10:39:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46482 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgDROjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 10:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1LsCjVacgDNgCyib7rEtoSFJWVTL9FJKR4yzQpOfwYg=; b=UrQgm4vL1ovuJYFTO+d+97W3Qs
        TCvDjd0CNLvezkYbzOVdaG5akr/ykupJjk7WO1yvDFwqYS16vyIEWFeY87wFH3ZtWJHL6Cr1zdiuO
        Y0WiLKT375DuF8uGMnfREUff7WFSnp9EB7x6V+XcdicIyOPEwXy2PcZ+sWZo/hA2l26k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPocZ-003TEL-8P; Sat, 18 Apr 2020 16:39:03 +0200
Date:   Sat, 18 Apr 2020 16:39:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>, linux.cj@gmail.com,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, Varun Sethi <V.Sethi@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC net-next PATCH v2 1/2] net/fsl: add ACPI support for mdio
 bus
Message-ID: <20200418143903.GF804711@lunn.ch>
References: <20200418105432.11233-1-calvin.johnson@oss.nxp.com>
 <20200418105432.11233-2-calvin.johnson@oss.nxp.com>
 <20200418114116.GU25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418114116.GU25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int xgmac_mdiobus_register_phy(struct mii_bus *bus,
> > +				      struct fwnode_handle *child, u32 addr)
> > +{
> > +	struct phy_device *phy;
> > +	bool is_c45 = false;
> > +	int rc;
> > +	const char *cp;
> > +	u32 phy_id;
> > +
> > +	fwnode_property_read_string(child, "compatible", &cp);
> > +	if (!strcmp(cp, "ethernet-phy-ieee802.3-c45"))
> > +		is_c45 = true;
> > +
> > +	if (!is_c45 && !xgmac_get_phy_id(child, &phy_id))
> > +		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
> > +	else
> > +		phy = get_phy_device(bus, addr, is_c45);
> > +	if (IS_ERR(phy))
> > +		return PTR_ERR(phy);
> > +
> > +	phy->irq = bus->irq[addr];
> > +
> > +	/* Associate the fwnode with the device structure so it
> > +	 * can be looked up later.
> > +	 */
> > +	phy->mdio.dev.fwnode = child;
> > +
> > +	/* All data is now stored in the phy struct, so register it */
> > +	rc = phy_device_register(phy);
> > +	if (rc) {
> > +		phy_device_free(phy);
> > +		fwnode_handle_put(child);
> > +		return rc;
> > +	}
> > +
> > +	dev_dbg(&bus->dev, "registered phy at address %i\n", addr);
> > +
> > +	return 0;
> 
> You seem to be duplicating the OF implementation in a private driver,
> converting it to fwnode.  This is not how we develop the Linux kernel.
> We fix subsystem problems by fixing the subsystems, not by throwing
> what should be subsystem code into private drivers.

And i think a similar comment was given for v1, but i could be
remembering wrongly.

	    Andrew
