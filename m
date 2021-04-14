Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C671735FBB5
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353442AbhDNTgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 15:36:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51342 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353424AbhDNTge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 15:36:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lWlIy-00Gkf1-QY; Wed, 14 Apr 2021 21:36:04 +0200
Date:   Wed, 14 Apr 2021 21:36:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/7] net: korina: Fix MDIO functions
Message-ID: <YHdEJGhQlAVkSwWW@lunn.ch>
References: <20210413204818.23350-1-tsbogend@alpha.franken.de>
 <20210413204818.23350-2-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413204818.23350-2-tsbogend@alpha.franken.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int korina_mdio_wait(struct korina_private *lp)
> +{
> +	int timeout = 1000;
> +
> +	while ((readl(&lp->eth_regs->miimind) & 1) && timeout-- > 0)
> +		udelay(1);
> +
> +	if (timeout <= 0)
> +		return -1;
> +
> +	return 0;

Using readl_poll_timeout_atomic() would be better.


> +}
> +
> +static int korina_mdio_read(struct net_device *dev, int phy, int reg)
>  {
>  	struct korina_private *lp = netdev_priv(dev);
>  	int ret;
>  
> -	mii_id = ((lp->rx_irq == 0x2c ? 1 : 0) << 8);
> +	if (korina_mdio_wait(lp))
> +		return -1;

This should really be -ETIMEDOUT

>  	dev->watchdog_timeo = TX_TIMEOUT;
>  	netif_napi_add(dev, &lp->napi, korina_poll, NAPI_POLL_WEIGHT);
>  
> -	lp->phy_addr = (((lp->rx_irq == 0x2c? 1:0) << 8) | 0x05);
>  	lp->mii_if.dev = dev;
> -	lp->mii_if.mdio_read = mdio_read;
> -	lp->mii_if.mdio_write = mdio_write;
> -	lp->mii_if.phy_id = lp->phy_addr;
> +	lp->mii_if.mdio_read = korina_mdio_read;
> +	lp->mii_if.mdio_write = korina_mdio_write;
> +	lp->mii_if.phy_id = 1;
>  	lp->mii_if.phy_id_mask = 0x1f;
>  	lp->mii_if.reg_num_mask = 0x1f;

You could also replace all the mii code with phylib.

    Andrew
