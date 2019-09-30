Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90117C2515
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732314AbfI3Q0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:26:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54748 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbfI3Q0E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 12:26:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UsNG+BJJkiN5f+ZgZFe9likYWxzjLrZI+P2lP6TGLj4=; b=0iloPo15G8c0TSn0HfSecaAjWh
        +Z1hbpIV0ML425vNA/FRnPOdvyxejzfTpYjTQTBbuN+ied/F2oTZ6nytVsZs6Kx84V6FGohMS9U1I
        56HiWl3xVU0ceqkqcjcG/ZrlscF0IS9AgaN+3s9tz7qUxLL4qt5UwlNyBZfoq63uR5b0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iEyUn-0004l9-Vz; Mon, 30 Sep 2019 18:25:57 +0200
Date:   Mon, 30 Sep 2019 18:25:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v1] net: ag71xx: fix mdio subnode support
Message-ID: <20190930162557.GB15343@lunn.ch>
References: <20190930093310.10762-1-o.rempel@pengutronix.de>
 <20190930134209.GB14745@lunn.ch>
 <20190930142907.wo3tahtg7g7mvfmp@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930142907.wo3tahtg7g7mvfmp@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 04:29:07PM +0200, Oleksij Rempel wrote:
> On Mon, Sep 30, 2019 at 03:42:09PM +0200, Andrew Lunn wrote:
> > On Mon, Sep 30, 2019 at 11:33:10AM +0200, Oleksij Rempel wrote:
> > > The driver was working with fixed phy without any noticeable issues. This bug
> > > was uncovered by introducing dsa ar9331-switch driver.
> > > 
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > ---
> > >  drivers/net/ethernet/atheros/ag71xx.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
> > > index 6703960c7cf5..d1101eea15c2 100644
> > > --- a/drivers/net/ethernet/atheros/ag71xx.c
> > > +++ b/drivers/net/ethernet/atheros/ag71xx.c
> > > @@ -526,7 +526,7 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
> > >  	struct device *dev = &ag->pdev->dev;
> > >  	struct net_device *ndev = ag->ndev;
> > >  	static struct mii_bus *mii_bus;
> > > -	struct device_node *np;
> > > +	struct device_node *np, *mnp;
> > >  	int err;
> > >  
> > >  	np = dev->of_node;
> > > @@ -571,7 +571,9 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
> > >  		msleep(200);
> > >  	}
> > >  
> > > -	err = of_mdiobus_register(mii_bus, np);
> > > +	mnp = of_get_child_by_name(np, "mdio");
> > > +	err = of_mdiobus_register(mii_bus, mnp);
> > > +	of_node_put(mnp);
> > >  	if (err)
> > >  		goto mdio_err_put_clk;
> > 
> > Hi Oleksij
> > 
> > You need to keep backwards compatibility here. If you find an mdio
> > node, use it, but if not, you need to still register np.
> > 
> > This is also extending the driver binding, so you need to update the
> > binding documentation.
> 
> Hi Andrew,
> 
> Normally i would agree. But in this case:
> - this driver is freshly added to the kernel and is different to OpenWrt
>   implementation any way. No users from this side.
> - Devicetree binding says:
>   Documentation/devicetree/bindings/net/qca,ar71xx.txt
> |Optional properties:
> |- phy-handle : phandle to the PHY device connected to this device.
> |- fixed-link : Assume a fixed link. See fixed-link.txt in the same directory.
> |  Use instead of phy-handle.
> |
> |Optional subnodes:
> |- mdio : specifies the mdio bus, used as a container for phy nodes
> |  according to phy.txt in the same directory
> 
> So, it is driver bug ...ooOO (my personal bug :D)

Hi Oleksij

Ah, O.K. You should of explained that in the commit message.

Is the mdio support just in -rc, or is it older?

You need to add a Fixes: tag.

The patch subject should be [PATCH net] to indicate this is a fix to
the net tree

The patch should be against net, not next-next.

    Andrew
