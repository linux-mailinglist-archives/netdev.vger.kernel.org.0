Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CF921D9EF
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 17:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbgGMPRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 11:17:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60970 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgGMPRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 11:17:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jv0Cl-004si1-56; Mon, 13 Jul 2020 17:17:19 +0200
Date:   Mon, 13 Jul 2020 17:17:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 5/5] net: phy: micrel: ksz886x/ksz8081: add
 cabletest support
Message-ID: <20200713151719.GE1078057@lunn.ch>
References: <20200710120851.28984-1-o.rempel@pengutronix.de>
 <20200710120851.28984-6-o.rempel@pengutronix.de>
 <20200711182912.GP1014141@lunn.ch>
 <20200713041129.gyoldkmsti4vl4m2@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713041129.gyoldkmsti4vl4m2@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Oleksij
> > 
> > Do the PHY register read/writes pass through the DSA driver for the
> > 8873?  I was wondering if the switch could intercept reads/writes on
> > port1 for KSZ8081_LMD and return EOPNOTSUPP? That would be a more
> > robust solution than DT properties, which are going to get forgotten.
> 
> Yes, it was my first idea as well. But this switch allows direct MDIO
> access to the PHYs and this PHY driver could be used without DSA driver.
> Not sure if we should support both variants?
> 
> Beside, the Port 1 need at least one more quirk. The pause souport is
> announced but is not working. Should we some how clear Puase bit in the PHY and
> tell PHY framework to not use it? What is the best way to do it?

It all seems rather odd, the way one PHY is messed up, but the other
works. Does this PHY exist as a standalone device, not integrated into
the switch? Do the same erratas apply to such a standalone device?

If the issues are just limited to integrated PHYs, there is maybe
something you can do via DSA:

in slave.c:

static int dsa_slave_phy_setup(struct net_device *slave_dev)
{
...
        if (ds->ops->get_phy_flags)
                phy_flags = ds->ops->get_phy_flags(ds, dp->index);

        ret = phylink_of_phy_connect(dp->pl, port_dn, phy_flags);

It is either B53 or SF2 which uses this, i forget which. flags get
or'ed into phydev->dev_flags. These are device specific flags. So you
could define a bit to represent this errata. And then in the PHY
driver do whatever needs to be done when you see the flag set for a
specific PHY.

If Pause is broken, then yes, it would be good to remove the Pause
from the available features, and return an error if requested to use
it.

       Andrew
