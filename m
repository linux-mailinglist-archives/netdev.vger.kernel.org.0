Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E716361681
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhDOXti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:49:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54588 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234764AbhDOXtg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:49:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lXBjP-00Gz8H-IN; Fri, 16 Apr 2021 01:49:07 +0200
Date:   Fri, 16 Apr 2021 01:49:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 07/10] net: korina: Add support for device
 tree
Message-ID: <YHjQ8ylbX2X+QJHG@lunn.ch>
References: <20210414230648.76129-1-tsbogend@alpha.franken.de>
 <20210414230648.76129-8-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414230648.76129-8-tsbogend@alpha.franken.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	memcpy(dev->dev_addr, mac_addr, ETH_ALEN);
> +	if (mac_addr) {
> +		ether_addr_copy(dev->dev_addr, mac_addr);
> +	} else {
> +		u8 ofmac[ETH_ALEN];
> +
> +		if (of_get_mac_address(pdev->dev.of_node, ofmac) == 0)
> +			ether_addr_copy(dev->dev_addr, ofmac);

You should be able to skip the ether_addr_copy() by passing 
dev->dev_addr directly to of_get_mac_address().

> +		else
> +			eth_hw_addr_random(dev);
> +	}
>  
>  	lp->rx_irq = platform_get_irq_byname(pdev, "korina_rx");
>  	lp->tx_irq = platform_get_irq_byname(pdev, "korina_tx");
> @@ -1146,8 +1157,21 @@ static int korina_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id korina_match[] = {
> +	{
> +		.compatible = "idt,3243x-emac",

You need to document this compatible somewhere under Documentation/devicetree/binding

    Andrew
