Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F136035FCC7
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245581AbhDNUiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:38:23 -0400
Received: from elvis.franken.de ([193.175.24.41]:50505 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230227AbhDNUiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 16:38:20 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lWmGp-0007TK-00; Wed, 14 Apr 2021 22:37:55 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id C3C85C035A; Wed, 14 Apr 2021 22:36:56 +0200 (CEST)
Date:   Wed, 14 Apr 2021 22:36:56 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] net: korina: Fix MDIO functions
Message-ID: <20210414203656.GA3382@alpha.franken.de>
References: <20210413204818.23350-1-tsbogend@alpha.franken.de>
 <20210413204818.23350-2-tsbogend@alpha.franken.de>
 <YHdEJGhQlAVkSwWW@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHdEJGhQlAVkSwWW@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 09:36:04PM +0200, Andrew Lunn wrote:
> > +static int korina_mdio_wait(struct korina_private *lp)
> > +{
> > +	int timeout = 1000;
> > +
> > +	while ((readl(&lp->eth_regs->miimind) & 1) && timeout-- > 0)
> > +		udelay(1);
> > +
> > +	if (timeout <= 0)
> > +		return -1;
> > +
> > +	return 0;
> 
> Using readl_poll_timeout_atomic() would be better.

I'll have a look

> 
> 
> > +}
> > +
> > +static int korina_mdio_read(struct net_device *dev, int phy, int reg)
> >  {
> >  	struct korina_private *lp = netdev_priv(dev);
> >  	int ret;
> >  
> > -	mii_id = ((lp->rx_irq == 0x2c ? 1 : 0) << 8);
> > +	if (korina_mdio_wait(lp))
> > +		return -1;
> 
> This should really be -ETIMEDOUT

ok.

> >  	dev->watchdog_timeo = TX_TIMEOUT;
> >  	netif_napi_add(dev, &lp->napi, korina_poll, NAPI_POLL_WEIGHT);
> >  
> > -	lp->phy_addr = (((lp->rx_irq == 0x2c? 1:0) << 8) | 0x05);
> >  	lp->mii_if.dev = dev;
> > -	lp->mii_if.mdio_read = mdio_read;
> > -	lp->mii_if.mdio_write = mdio_write;
> > -	lp->mii_if.phy_id = lp->phy_addr;
> > +	lp->mii_if.mdio_read = korina_mdio_read;
> > +	lp->mii_if.mdio_write = korina_mdio_write;
> > +	lp->mii_if.phy_id = 1;
> >  	lp->mii_if.phy_id_mask = 0x1f;
> >  	lp->mii_if.reg_num_mask = 0x1f;
> 
> You could also replace all the mii code with phylib.

that's on my todo.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
