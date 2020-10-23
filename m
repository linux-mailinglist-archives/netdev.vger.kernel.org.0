Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530F929787B
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 22:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756439AbgJWUxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 16:53:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756428AbgJWUxr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 16:53:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kW448-003Awl-Nh; Fri, 23 Oct 2020 22:53:36 +0200
Date:   Fri, 23 Oct 2020 22:53:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>, linux-can@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/6] net: phy: add CAN PHY Virtual Bus
Message-ID: <20201023205336.GF752111@lunn.ch>
References: <20201023105626.6534-1-o.rempel@pengutronix.de>
 <20201023105626.6534-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023105626.6534-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 12:56:21PM +0200, Oleksij Rempel wrote:
> Most of CAN PHYs (transceivers) are not attached to any data bus, so we
> are not able to communicate with them. For this case, we introduce a CAN
> specific virtual bus to make use of existing PHY framework.

I don't think you are making the best use of the phylib framework.

MDIO busses can be standalone devices, with their own DT nodes. And
that device node can list the PHY devices on the bus.

can_mdio {
	compatible = "virtual,mdio-virtual";
        #address-cells = <1>;
        #size-cells = <0>;

	canphy0: can-phy@0 {
		compatible = "can,generic-transceiver",
		reg = <0>;
	}
	canphy1: can-phy@1 
		compatible = "nxp,tja1051",
		reg = <1>
	}
}

When you call of_mdiobus_register(fmb->mii_bus, np) it will parse this
tree and should create PHY devices for them, and since your PHY driver
has a match function, it should then bind the correct PHY driver.

Your 'MAC' driver then uses phy-handle as normal to point to the PHY.

There is also some interesting overlap here with what Intel posted
recently:

https://www.spinics.net/lists/kernel/msg3706164.html

I'm not sure anything can be shared here, but it is worth looking at
and thinking about.

    Andrew
