Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06923A5BDE
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 05:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhFNDjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 23:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbhFNDjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 23:39:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75415C061574
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 20:37:33 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lsdPn-0005aq-Ak; Mon, 14 Jun 2021 05:37:31 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lsdPm-0006Sh-Vj; Mon, 14 Jun 2021 05:37:30 +0200
Date:   Mon, 14 Jun 2021 05:37:30 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v4 8/9] net: dsa: dsa_slave_phy_connect():
 extend phy's flags with port specific phy flags
Message-ID: <20210614033730.46vnyemwvxjk5s5n@pengutronix.de>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-9-o.rempel@pengutronix.de>
 <20210611192417.gvfxi2kbfjx4jv3d@skbuf>
 <97ea2ff1-d3a3-b2d5-f829-3863409bfecc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <97ea2ff1-d3a3-b2d5-f829-3863409bfecc@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 05:36:53 up 193 days, 17:43, 48 users,  load average: 0.05, 0.03,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 04:26:33PM -0700, Florian Fainelli wrote:
> 
> 
> On 6/11/2021 12:24 PM, Vladimir Oltean wrote:
> > On Fri, Jun 11, 2021 at 09:15:26AM +0200, Oleksij Rempel wrote:
> >> This patch extends the flags of the phy that's being connected with the
> >> port specific flags of the switch port.
> >>
> >> This is needed to handle a port specific erratum of the KSZ8873 switch,
> >> which is added in a later patch.
> >>
> >> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> >> ---
> > 
> > What happens differently between having this patch and not having it?
> 
> The current get_phy_flags() is only processed when we connect to a PHY
> via a designed phy-handle property via phylink_of_phy_connect((, but if
> we fallback on the internal MDIO bus created by a switch and take the
> dsa_slave_phy_connect() path then we would not be processing that flag
> and using it at PHY connection time. Oleksij, your proposed patch fails
> to check that dsa_switch_ops::get_phy_flags is actually non-NULL, how
> about this approach instead where we only fetch the flags once, and we
> deal with an option get_phy_flags callback too:

ok, sounds good.
Thank you.

> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index d4756b920108..ba7866ec946f 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1749,7 +1749,7 @@ static void dsa_slave_phylink_fixed_state(struct
> phylink_config *config,
>  }
> 
>  /* slave device setup
> *******************************************************/
> -static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr)
> +static int dsa_slave_phy_connect(struct net_device *slave_dev, int
> addr, u32 flags)
>  {
>         struct dsa_port *dp = dsa_slave_to_port(slave_dev);
>         struct dsa_switch *ds = dp->ds;
> @@ -1760,6 +1760,8 @@ static int dsa_slave_phy_connect(struct net_device
> *slave_dev, int addr)
>                 return -ENODEV;
>         }
> 
> +       slave_dev->phydev->dev_flags |= flags;
> +
>         return phylink_connect_phy(dp->pl, slave_dev->phydev);
>  }
> 
> @@ -1804,7 +1806,7 @@ static int dsa_slave_phy_setup(struct net_device
> *slave_dev)
>                 /* We could not connect to a designated PHY or SFP, so
> try to
>                  * use the switch internal MDIO bus instead
>                  */
> -               ret = dsa_slave_phy_connect(slave_dev, dp->index);
> +               ret = dsa_slave_phy_connect(slave_dev, dp->index,
> phy_flags);
>                 if (ret) {
>                         netdev_err(slave_dev,
>                                    "failed to connect to port %d: %d\n",
> -- 
> Florian
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
