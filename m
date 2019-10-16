Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12476D90BC
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392983AbfJPMYR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Oct 2019 08:24:17 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53099 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387581AbfJPMYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:24:16 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iKiLU-0004AS-AG; Wed, 16 Oct 2019 14:24:04 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1iKiLR-0005zs-CJ; Wed, 16 Oct 2019 14:24:01 +0200
Date:   Wed, 16 Oct 2019 14:24:01 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 1/4] net: ag71xx: port to phylink
Message-ID: <20191016122401.jnldnlwruv7h5kgy@pengutronix.de>
References: <20191014061549.3669-1-o.rempel@pengutronix.de>
 <20191014061549.3669-2-o.rempel@pengutronix.de>
 <20191016121216.GD4780@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20191016121216.GD4780@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:20:56 up 151 days, 18:39, 100 users,  load average: 0.12, 0.11,
 0.04
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 02:12:16PM +0200, Andrew Lunn wrote:
> On Mon, Oct 14, 2019 at 08:15:46AM +0200, Oleksij Rempel wrote:
> > The port to phylink was done as close as possible to initial
> > functionality.
> > Theoretically this HW can support flow control, practically seems to be not
> > enough to just enable it. So, more work should be done.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> Hi Oleksij
> 
> Please include Russell King in Cc: in future.

He was included in To:. Do you mean, I need to move him from To to Cc?

> > -static void ag71xx_phy_link_adjust(struct net_device *ndev)
> > +static void ag71xx_mac_validate(struct phylink_config *config,
> > +			    unsigned long *supported,
> > +			    struct phylink_link_state *state)
> >  {
> > -	struct ag71xx *ag = netdev_priv(ndev);
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > +
> > +	if (state->interface != PHY_INTERFACE_MODE_NA &&
> > +	    state->interface != PHY_INTERFACE_MODE_GMII &&
> > +	    state->interface != PHY_INTERFACE_MODE_MII) {
> > +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> > +		return;
> > +	}
> > +
> > +	phylink_set(mask, MII);
> > +
> > +	/* flow control is not supported */
> >  
> > -	ag71xx_link_adjust(ag, true);
> > +	phylink_set(mask, 10baseT_Half);
> > +	phylink_set(mask, 10baseT_Full);
> > +	phylink_set(mask, 100baseT_Half);
> > +	phylink_set(mask, 100baseT_Full);
> > +
> > +	phylink_set(mask, 1000baseT_Full);
> > +	phylink_set(mask, 1000baseX_Full);
> 
> Can the MAC/PHY dynamically switch between MII and GMII? Maybe you
> should only add 1G support when interface is GMII?

OK, good point.

> > @@ -1239,6 +1255,13 @@ static int ag71xx_open(struct net_device *ndev)
> >  	unsigned int max_frame_len;
> >  	int ret;
> >  
> > +	ret = phylink_of_phy_connect(ag->phylink, ag->pdev->dev.of_node, 0);
> > +	if (ret) {
> > +		netif_info(ag, link, ndev, "phylink_of_phy_connect filed with err: %i\n",
> > +			   ret);
> 
> netif_info seems wrong. _err()?

Yes, will fix it.

Regards,
Oleksij.

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
