Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E18B21E9FD
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgGNHZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgGNHZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 03:25:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AC7C061755
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 00:25:08 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jvFJJ-0003dJ-03; Tue, 14 Jul 2020 09:25:05 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jvFJF-00021h-7T; Tue, 14 Jul 2020 09:25:01 +0200
Date:   Tue, 14 Jul 2020 09:25:01 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 5/5] net: phy: micrel: ksz886x/ksz8081: add
 cabletest support
Message-ID: <20200714072501.GA5072@pengutronix.de>
References: <20200710120851.28984-1-o.rempel@pengutronix.de>
 <20200710120851.28984-6-o.rempel@pengutronix.de>
 <20200711182912.GP1014141@lunn.ch>
 <20200713041129.gyoldkmsti4vl4m2@pengutronix.de>
 <20200713151719.GE1078057@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200713151719.GE1078057@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:17:19 up 35 days, 15:44, 130 users,  load average: 0.20, 0.35,
 0.35
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 05:17:19PM +0200, Andrew Lunn wrote:
> > > Hi Oleksij
> > > 
> > > Do the PHY register read/writes pass through the DSA driver for the
> > > 8873?  I was wondering if the switch could intercept reads/writes on
> > > port1 for KSZ8081_LMD and return EOPNOTSUPP? That would be a more
> > > robust solution than DT properties, which are going to get forgotten.
> > 
> > Yes, it was my first idea as well. But this switch allows direct MDIO
> > access to the PHYs and this PHY driver could be used without DSA driver.
> > Not sure if we should support both variants?
> > 
> > Beside, the Port 1 need at least one more quirk. The pause souport is
> > announced but is not working. Should we some how clear Puase bit in the PHY and
> > tell PHY framework to not use it? What is the best way to do it?
> 
> It all seems rather odd, the way one PHY is messed up, but the other
> works. Does this PHY exist as a standalone device, not integrated into
> the switch? Do the same erratas apply to such a standalone device?

I found multiple microchip devices with same PHYid: KSZ8463, KSZ8851
KSZ8463 - switch. Would be covered by DSA driver
KSZ8851 - single MAC device with PHY. Supported by ethernet/micrel
driver.

This erratum is not documented for other devices. So it may exist or
not.

> If the issues are just limited to integrated PHYs, there is maybe
> something you can do via DSA:
> 
> in slave.c:
> 
> static int dsa_slave_phy_setup(struct net_device *slave_dev)
> {
> ...
>         if (ds->ops->get_phy_flags)
>                 phy_flags = ds->ops->get_phy_flags(ds, dp->index);
> 
>         ret = phylink_of_phy_connect(dp->pl, port_dn, phy_flags);
> 
> It is either B53 or SF2 which uses this, i forget which. flags get
> or'ed into phydev->dev_flags. These are device specific flags. So you
> could define a bit to represent this errata. And then in the PHY
> driver do whatever needs to be done when you see the flag set for a
> specific PHY.
> 
> If Pause is broken, then yes, it would be good to remove the Pause
> from the available features, and return an error if requested to use
> it.

OK. So, i'll cover both errata with separate flags? Set flags in the DSA
driver and apply workarounds in the PHY. ACK?

Regards,
Oleksij

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
