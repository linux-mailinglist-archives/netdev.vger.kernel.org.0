Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42905361A82
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 09:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239574AbhDPHXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 03:23:34 -0400
Received: from elvis.franken.de ([193.175.24.41]:53273 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239532AbhDPHXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 03:23:32 -0400
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lXIol-0007qW-00; Fri, 16 Apr 2021 09:23:07 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id D32FFC04CD; Fri, 16 Apr 2021 09:12:26 +0200 (CEST)
Date:   Fri, 16 Apr 2021 09:12:26 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 07/10] net: korina: Add support for device
 tree
Message-ID: <20210416071226.GA5257@alpha.franken.de>
References: <20210414230648.76129-1-tsbogend@alpha.franken.de>
 <20210414230648.76129-8-tsbogend@alpha.franken.de>
 <YHjQ8ylbX2X+QJHG@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHjQ8ylbX2X+QJHG@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 01:49:07AM +0200, Andrew Lunn wrote:
> > -	memcpy(dev->dev_addr, mac_addr, ETH_ALEN);
> > +	if (mac_addr) {
> > +		ether_addr_copy(dev->dev_addr, mac_addr);
> > +	} else {
> > +		u8 ofmac[ETH_ALEN];
> > +
> > +		if (of_get_mac_address(pdev->dev.of_node, ofmac) == 0)
> > +			ether_addr_copy(dev->dev_addr, ofmac);
> 
> You should be able to skip the ether_addr_copy() by passing 
> dev->dev_addr directly to of_get_mac_address().

good point

> 
> > +		else
> > +			eth_hw_addr_random(dev);
> > +	}
> >  
> >  	lp->rx_irq = platform_get_irq_byname(pdev, "korina_rx");
> >  	lp->tx_irq = platform_get_irq_byname(pdev, "korina_tx");
> > @@ -1146,8 +1157,21 @@ static int korina_remove(struct platform_device *pdev)
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id korina_match[] = {
> > +	{
> > +		.compatible = "idt,3243x-emac",
> 
> You need to document this compatible somewhere under Documentation/devicetree/binding

checkpatch hinted to put it in an extra patch, it's patch 10 of this
series and looking at my inbox it didn't get through :-(.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
