Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F110A27F131
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 20:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgI3STO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 14:19:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36558 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3STN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 14:19:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNggw-00GwPE-U1; Wed, 30 Sep 2020 20:19:02 +0200
Date:   Wed, 30 Sep 2020 20:19:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v1 3/7] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20200930181902.GT3996795@lunn.ch>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-4-calvin.johnson@oss.nxp.com>
 <20200930163440.GR3996795@lunn.ch>
 <20200930180725.GE1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930180725.GE1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 07:07:25PM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Sep 30, 2020 at 06:34:40PM +0200, Andrew Lunn wrote:
> > > @@ -2866,7 +2888,15 @@ EXPORT_SYMBOL_GPL(device_phy_find_device);
> > >   */
> > >  struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
> > >  {
> > > -	return fwnode_find_reference(fwnode, "phy-handle", 0);
> > > +	struct fwnode_handle *phy_node;
> > > +
> > > +	phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
> > > +	if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
> > > +		return phy_node;
> > > +	phy_node = fwnode_find_reference(fwnode, "phy", 0);
> > > +	if (IS_ERR(phy_node))
> > > +		phy_node = fwnode_find_reference(fwnode, "phy-device", 0);
> > > +	return phy_node;
> > 
> > Why do you have three different ways to reference a PHY?
> 
> Compatibility with the DT version - note that "phy" and "phy-device"
> are only used for non-ACPI fwnodes. This should allow us to convert
> drivers where necessary without fear of causing DT regressions.

Ah.

A comment would be good here.

  Andrew
