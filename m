Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90583B9B23
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 05:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbhGBD4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 23:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbhGBD4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 23:56:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125C1C061762
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 20:54:03 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lzAFL-00021A-VA; Fri, 02 Jul 2021 05:53:43 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lzAFI-0002yt-Au; Fri, 02 Jul 2021 05:53:40 +0200
Date:   Fri, 2 Jul 2021 05:53:40 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: usb: asix: ax88772: suspend PHY on
 driver probe
Message-ID: <20210702035340.sdoc5dqpuo4cgsqe@pengutronix.de>
References: <20210629044305.32322-1-o.rempel@pengutronix.de>
 <931f10ca-2d81-8264-950c-8d29c18a7b35@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <931f10ca-2d81-8264-950c-8d29c18a7b35@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 05:41:20 up 211 days, 17:47, 35 users,  load average: 0.00, 0.04,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 12:01:04PM -0700, Florian Fainelli wrote:
> On 6/28/21 9:43 PM, Oleksij Rempel wrote:
> > After probe/bind sequence is the PHY in active state, even if interface
> > is stopped. As result, on some systems like Samsung Exynos5250 SoC based Arndale
> > board, the ASIX PHY will be able to negotiate the link but fail to
> > transmit the data.
> > 
> > To handle it, suspend the PHY on probe.
> 
> Very unusual, could not the PHY be attached/connected to a ndo_open()
> time like what most drivers do?

May be this can be done to.
But, should not the PHY be in the same state after phy_connect() and after
phy_stop()?

Currently, phy_connect() and phy_start() resume the PHY. The phy_stop()
is suspending it. Since the driver calls phy_connect(), phy_start() and
phy_stop(), the resume/suspend state is out of balance.
In case some one will add for example something like regulator_enable/disable
callbacks in to phydev->syspend/resume callbacks, this would never work.

So, the question is, should phy_connect() put the PHY back in to suspend
mode? Or should the MAC driver take care of this?

> > 
> > Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/net/usb/asix_devices.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> > index aec97b021a73..2c115216420a 100644
> > --- a/drivers/net/usb/asix_devices.c
> > +++ b/drivers/net/usb/asix_devices.c
> > @@ -701,6 +701,7 @@ static int ax88772_init_phy(struct usbnet *dev)
> >  		return ret;
> >  	}
> >  
> > +	phy_suspend(priv->phydev);
> >  	priv->phydev->mac_managed_pm = 1;
> >  
> >  	phy_attached_info(priv->phydev);
> > 
> 
> 
> -- 
> Florian
> 

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
