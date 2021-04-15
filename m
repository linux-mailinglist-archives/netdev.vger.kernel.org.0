Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4C33615FF
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbhDOXSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:18:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54468 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234735AbhDOXSX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:18:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lXBFC-00Gycy-IW; Fri, 16 Apr 2021 01:17:54 +0200
Date:   Fri, 16 Apr 2021 01:17:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 01/10] net: korina: Fix MDIO functions
Message-ID: <YHjJotQ9vQ03KZSH@lunn.ch>
References: <20210414230648.76129-1-tsbogend@alpha.franken.de>
 <20210414230648.76129-2-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414230648.76129-2-tsbogend@alpha.franken.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int korina_mdio_wait(struct korina_private *lp)
> +{
> +	u32 value;
> +
> +	return readl_poll_timeout_atomic(&lp->eth_regs->miimind,
> +					 value, value & ETH_MII_IND_BSY,
> +					 1, 1000);
> +}
> +
> +static int korina_mdio_read(struct net_device *dev, int phy, int reg)
>  {
>  	struct korina_private *lp = netdev_priv(dev);
>  	int ret;
>  
> -	mii_id = ((lp->rx_irq == 0x2c ? 1 : 0) << 8);
> +	if (korina_mdio_wait(lp))
> +		return -ETIMEDOUT;
>  
> -	writel(0, &lp->eth_regs->miimcfg);
> -	writel(0, &lp->eth_regs->miimcmd);
> -	writel(mii_id | reg, &lp->eth_regs->miimaddr);
> -	writel(ETH_MII_CMD_SCN, &lp->eth_regs->miimcmd);
> +	writel(phy << 8 | reg, &lp->eth_regs->miimaddr);
> +	writel(1, &lp->eth_regs->miimcmd);
> +
> +	if (korina_mdio_wait(lp))
> +		return -ETIMEDOUT;

Just return what readl_poll_timeout_atomic() returns. In general, you
should not change error codes.

>  
> -	ret = (int)(readl(&lp->eth_regs->miimrdd));
> +	if (readl(&lp->eth_regs->miimind) & ETH_MII_IND_NV)
> +		return -1;

Please use -ESOMETHING, not -1.

       Andrew
