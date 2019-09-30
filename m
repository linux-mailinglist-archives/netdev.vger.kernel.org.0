Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEA4C2777
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbfI3U5R convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Sep 2019 16:57:17 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59097 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbfI3U5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:57:13 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iEzqk-00015W-B5; Mon, 30 Sep 2019 19:52:42 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1iEzqi-0004zx-TB; Mon, 30 Sep 2019 19:52:40 +0200
Date:   Mon, 30 Sep 2019 19:52:40 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v1] net: ag71xx: fix mdio subnode support
Message-ID: <20190930175240.hfujxyst475wftzt@pengutronix.de>
References: <20190930093310.10762-1-o.rempel@pengutronix.de>
 <20190930134209.GB14745@lunn.ch>
 <20190930142907.wo3tahtg7g7mvfmp@pengutronix.de>
 <20190930162557.GB15343@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190930162557.GB15343@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:52:14 up 136 days, 10 min, 87 users,  load average: 0.00, 0.00,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 06:25:57PM +0200, Andrew Lunn wrote:
> On Mon, Sep 30, 2019 at 04:29:07PM +0200, Oleksij Rempel wrote:
> > On Mon, Sep 30, 2019 at 03:42:09PM +0200, Andrew Lunn wrote:
> > > On Mon, Sep 30, 2019 at 11:33:10AM +0200, Oleksij Rempel wrote:
> > > > The driver was working with fixed phy without any noticeable issues. This bug
> > > > was uncovered by introducing dsa ar9331-switch driver.
> > > > 
> > > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > > ---
> > > >  drivers/net/ethernet/atheros/ag71xx.c | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
> > > > index 6703960c7cf5..d1101eea15c2 100644
> > > > --- a/drivers/net/ethernet/atheros/ag71xx.c
> > > > +++ b/drivers/net/ethernet/atheros/ag71xx.c
> > > > @@ -526,7 +526,7 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
> > > >  	struct device *dev = &ag->pdev->dev;
> > > >  	struct net_device *ndev = ag->ndev;
> > > >  	static struct mii_bus *mii_bus;
> > > > -	struct device_node *np;
> > > > +	struct device_node *np, *mnp;
> > > >  	int err;
> > > >  
> > > >  	np = dev->of_node;
> > > > @@ -571,7 +571,9 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
> > > >  		msleep(200);
> > > >  	}
> > > >  
> > > > -	err = of_mdiobus_register(mii_bus, np);
> > > > +	mnp = of_get_child_by_name(np, "mdio");
> > > > +	err = of_mdiobus_register(mii_bus, mnp);
> > > > +	of_node_put(mnp);
> > > >  	if (err)
> > > >  		goto mdio_err_put_clk;
> > > 
> > > Hi Oleksij
> > > 
> > > You need to keep backwards compatibility here. If you find an mdio
> > > node, use it, but if not, you need to still register np.
> > > 
> > > This is also extending the driver binding, so you need to update the
> > > binding documentation.
> > 
> > Hi Andrew,
> > 
> > Normally i would agree. But in this case:
> > - this driver is freshly added to the kernel and is different to OpenWrt
> >   implementation any way. No users from this side.
> > - Devicetree binding says:
> >   Documentation/devicetree/bindings/net/qca,ar71xx.txt
> > |Optional properties:
> > |- phy-handle : phandle to the PHY device connected to this device.
> > |- fixed-link : Assume a fixed link. See fixed-link.txt in the same directory.
> > |  Use instead of phy-handle.
> > |
> > |Optional subnodes:
> > |- mdio : specifies the mdio bus, used as a container for phy nodes
> > |  according to phy.txt in the same directory
> > 
> > So, it is driver bug ...ooOO (my personal bug :D)
> 
> Hi Oleksij
> 
> Ah, O.K. You should of explained that in the commit message.
> 
> Is the mdio support just in -rc, or is it older?
> 
> You need to add a Fixes: tag.
> 
> The patch subject should be [PATCH net] to indicate this is a fix to
> the net tree
> 
> The patch should be against net, not next-next.

Ok. thx! i'll fix it.

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
