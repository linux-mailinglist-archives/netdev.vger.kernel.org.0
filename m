Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AB31FD4DB
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgFQSv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:51:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44736 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgFQSv0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 14:51:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jld9c-0010qx-LC; Wed, 17 Jun 2020 20:51:20 +0200
Date:   Wed, 17 Jun 2020 20:51:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com
Subject: Re: [PATCH v1 1/3] net: phy: Allow mdio buses to auto-probe c45
 devices
Message-ID: <20200617185120.GB240559@lunn.ch>
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-2-calvin.johnson@oss.nxp.com>
 <20200617174451.GT1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617174451.GT1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +	/* bus capabilities, used for probing */
> > +	enum {
> > +		MDIOBUS_C22 = 0,
> > +		MDIOBUS_C45,
> > +		MDIOBUS_C22_C45,
> > +	} probe_capabilities;
> 
> I think it would be better to reserve "0" to mean that no capabilities
> have been declared.  We hae the situation where we have mii_bus that
> exist which do support C45, but as they stand, probe_capabilities will
> be zero, and with your definitions above, that means MDIOBUS_C22.
> 
> It seems this could lock in some potential issues later down the line
> if we want to use this elsewhere.

Hi Russell

Actually, this patch already causes issues, i think.

drivers/net/ethernet/marvell/mvmdio.c contains two MDIO bus master
drivers. "marvell,orion-mdio" is C22 only. "marvell,xmdio" is C45
only. Because the capabilites is not initialized, it will default to
0, aka MDIOBUS_C22, for the C45 only bus master, and i expect bad
things will happen.

We need the value of 0 to cause existing behaviour. Or all MDIO bus
drivers need reviewing, and the correct capabilities set.

   Andrew
