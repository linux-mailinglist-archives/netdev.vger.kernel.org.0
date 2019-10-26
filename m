Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 935A3E5FDD
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 00:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfJZWYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 18:24:52 -0400
Received: from smtprelay0091.hostedemail.com ([216.40.44.91]:59737 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726434AbfJZWYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 18:24:52 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id DE8311801BE98;
        Sat, 26 Oct 2019 22:24:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:4321:4605:5007:6119:7903:10004:10400:10848:11026:11232:11657:11658:11914:12043:12114:12296:12297:12740:12760:12895:13069:13095:13311:13357:13439:13972:14659:14721:14880:21080:21433:21611:21627:30029:30054:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: oil87_6469c2f41951d
X-Filterd-Recvd-Size: 2118
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Sat, 26 Oct 2019 22:24:49 +0000 (UTC)
Message-ID: <5c3a0c832defddf8d1ddbf51dba255c73004bcb6.camel@perches.com>
Subject: Re: [PATCH 07/10] net: ehernet: ixp4xx: Use devm_alloc_etherdev()
From:   Joe Perches <joe@perches.com>
To:     Linus Walleij <linus.walleij@linaro.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 26 Oct 2019 15:24:46 -0700
In-Reply-To: <20191021000824.531-8-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
         <20191021000824.531-8-linus.walleij@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-10-21 at 02:08 +0200, Linus Walleij wrote:
> Using the devm_alloc_etherdev() function simplifies the error
> path. I also patch the message to use dev_info().

slight typo in subject

> diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c

Maybe it's better to avoid changing this driver.
Is this device still sold?  It's 15+ years old.

> @@ -1378,7 +1378,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
>  
>  	plat = dev_get_platdata(dev);
>  
> -	if (!(ndev = alloc_etherdev(sizeof(struct port))))
> +	if (!(ndev = devm_alloc_etherdev(dev, sizeof(struct port))))

Probably nicer to split the assignment and test too.

> @@ -1479,8 +1476,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
>  	if ((err = register_netdev(ndev)))
>  		goto err_phy_dis;
>  
> -	printk(KERN_INFO "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
> -	       npe_name(port->npe));
> +	dev_info(dev, "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
> +		 npe_name(port->npe));

and this should probably be

	netdev_info(ndev, "MII PHY %d on %s\n", plat->phy, npe_name(port->npe));

But there are 30+ printks in this file, so why just this one?


