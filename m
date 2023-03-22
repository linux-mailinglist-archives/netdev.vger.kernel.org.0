Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3656C57F9
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjCVUoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjCVUoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:44:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D472D5598;
        Wed, 22 Mar 2023 13:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lOw0pWp4oxfyhAJZHJ6ZoPMdYH5fP1+gj8yMHI7HkBI=; b=wVY/UHB9RnKnUdABCeZU9A7o1f
        QeKOFuEJLIpZovbpowXxnf7p/t78Xpr1VMW4Ylz/5z3MrXtTwWdbb7oiF+10GgeoempoqtuLVN2xX
        dGcTJsIrJtBDgMeeitW8o7Ng65Z87O8oCZ1GvhAgBtkciIxgTuxeB3fxNJUEdViuc0UY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pf4tK-0086mL-0U; Wed, 22 Mar 2023 21:17:02 +0100
Date:   Wed, 22 Mar 2023 21:17:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 6/7] net: dsa: mv88e6xxx: provide software
 node for default settings
Message-ID: <5922c650-0ef3-4e60-84e6-0bfe535e5a98@lunn.ch>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
 <04869523-3711-41a6-81ba-ddf2b12fd22e@lunn.ch>
 <ZBthf8EsnQIttGdI@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBthf8EsnQIttGdI@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 08:13:51PM +0000, Russell King (Oracle) wrote:
> On Wed, Mar 22, 2023 at 07:57:19PM +0100, Andrew Lunn wrote:
> > > +static struct fwnode_handle *mv88e6xxx_port_get_fwnode(struct dsa_switch *ds,
> > > +						       int port,
> > > +						       struct fwnode_handle *h)
> > > +{
> > > +	struct mv88e6xxx_chip *chip = ds->priv;
> > > +	struct device_node *np, *phy_node;
> > > +	int speed, duplex, err;
> > > +	phy_interface_t mode;
> > > +	struct dsa_port *dp;
> > > +	unsigned long caps;
> > > +
> > > +	dp = dsa_to_port(ds, port);
> > > +	if (dsa_port_is_user(dp))
> > > +		return h;
> > > +
> > > +	/* No DT? Eh? */
> > > +	np = to_of_node(h);
> > > +	if (!np)
> > > +		return h;
> > 
> > I've not looked at the big picture yet, but you can have a simple
> > switch setup without DT. I have a couple of amd64 boards which use
> > platform data. The user ports all have internal PHYs, and the CPU port
> > defaults to 1G, it might even be strapped that way.
> 
> Are you suggesting that we should generate some swnode description of
> the max interface mode and speed if we are missing a DT node?
> 
> I'm not seeing any port specific data in the mv88e6xxx platform data.

No, i'm just pointing out that not have DT is not an error, and can
happen. I just wanted to make sure you are not assuming there is
always DT.

	Andrew
