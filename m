Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D672CBEB7
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 14:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgLBNvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 08:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgLBNvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 08:51:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45CAC0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 05:51:09 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kkSXB-0002w5-Aq; Wed, 02 Dec 2020 14:51:05 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kkSX9-0006JI-Nu; Wed, 02 Dec 2020 14:51:03 +0100
Date:   Wed, 2 Dec 2020 14:51:03 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, linux-mips@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201202135103.dis4eqaqekp7q36j@pengutronix.de>
References: <20201202120712.6212-1-o.rempel@pengutronix.de>
 <20201202120712.6212-3-o.rempel@pengutronix.de>
 <20201202130438.vuhujicfcg2n2ih7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201202130438.vuhujicfcg2n2ih7@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:37:30 up  3:43, 22 users,  load average: 0.19, 0.13, 0.03
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 03:04:38PM +0200, Vladimir Oltean wrote:
> On Wed, Dec 02, 2020 at 01:07:12PM +0100, Oleksij Rempel wrote:
> > Add stats support for the ar9331 switch.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  /* Warning: switch reset will reset last AR9331_SW_MDIO_PHY_MODE_PAGE request
> > @@ -422,6 +527,7 @@ static void ar9331_sw_phylink_mac_link_down(struct dsa_switch *ds, int port,
> >  					    phy_interface_t interface)
> >  {
> >  	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> > +	struct ar9331_sw_port *p = &priv->port[port];
> >  	struct regmap *regmap = priv->regmap;
> >  	int ret;
> >  
> > @@ -429,6 +535,8 @@ static void ar9331_sw_phylink_mac_link_down(struct dsa_switch *ds, int port,
> >  				 AR9331_SW_PORT_STATUS_MAC_MASK, 0);
> >  	if (ret)
> >  		dev_err_ratelimited(priv->dev, "%s: %i\n", __func__, ret);
> > +
> > +	cancel_delayed_work_sync(&p->mib_read);
> 
> Is this sufficient? Do you get a guaranteed .phylink_mac_link_down event
> on unbind? How do you ensure you don't race with the stats worker there?

Currently it works, but you are right, i'll better do this on remove as
well.

> > +static void ar9331_stats_update(struct ar9331_sw_port *port,
> > +				struct rtnl_link_stats64 *stats)
> > +{
> > +	struct ar9331_sw_stats *s = &port->stats;
> > +
> > +	stats->rx_packets = s->rxbroad + s->rxmulti + s->rx64byte +
> > +		s->rx128byte + s->rx256byte + s->rx512byte + s->rx1024byte +
> > +		s->rx1518byte + s->rxmaxbyte;
> > +	stats->tx_packets = s->txbroad + s->txmulti + s->tx64byte +
> > +		s->tx128byte + s->tx256byte + s->tx512byte + s->tx1024byte +
> > +		s->tx1518byte + s->txmaxbyte;
> > +	stats->rx_bytes = s->rxgoodbyte;
> > +	stats->tx_bytes = s->txbyte;
> > +	stats->rx_errors = s->rxfcserr + s->rxalignerr + s->rxrunt +
> > +		s->rxfragment + s->rxoverflow;
> > +	stats->tx_errors = s->txoversize;
> > +	stats->multicast = s->rxmulti;
> > +	stats->collisions = s->txcollision;
> > +	stats->rx_length_errors = s->rxrunt * s->rxfragment + s->rxtoolong;
> 
> Multiplication? Is this right?

no. fixed.

> > +	stats->rx_crc_errors = s->rxfcserr + s->rxalignerr + s->rxfragment;
> > +	stats->rx_frame_errors = s->rxalignerr;
> > +	stats->rx_missed_errors = s->rxoverflow;
> > +	stats->tx_aborted_errors = s->txabortcol;
> > +	stats->tx_fifo_errors = s->txunderrun;
> > +	stats->tx_window_errors = s->txlatecol;
> > +	stats->rx_nohandler = s->filtered;
> > +}
> > +
> > +static void ar9331_do_stats_poll(struct work_struct *work)
> > +{
> > +
> 
> Could you remove this empty line.

fixed

Thank you!

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
