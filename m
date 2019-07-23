Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF3271A19
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390549AbfGWORL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:17:11 -0400
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:41924 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726201AbfGWORL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 10:17:11 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id E2DB98368F00;
        Tue, 23 Jul 2019 14:17:09 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:4321:5007:6119:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12297:12438:12740:12760:12895:13069:13161:13229:13311:13357:13439:14659:14721:21080:21451:21627:30012:30054:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: laugh64_3e612aa95d800
X-Filterd-Recvd-Size: 2461
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Tue, 23 Jul 2019 14:17:08 +0000 (UTC)
Message-ID: <282e6918adc670dc5667006f646664342c8bdef8.camel@perches.com>
Subject: Re: [PATCH] net: atheros: Use dev_get_drvdata
From:   Joe Perches <joe@perches.com>
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 23 Jul 2019 07:17:07 -0700
In-Reply-To: <20190723131856.31932-1-hslester96@gmail.com>
References: <20190723131856.31932-1-hslester96@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-07-23 at 21:18 +0800, Chuhong Yuan wrote:
> Instead of using to_pci_dev + pci_get_drvdata,
> use dev_get_drvdata to make code simpler.

unrelated trivia:

> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
[]
> @@ -2422,8 +2422,7 @@ static int atl1c_close(struct net_device *netdev)
>  
>  static int atl1c_suspend(struct device *dev)
>  {
> -	struct pci_dev *pdev = to_pci_dev(dev);
> -	struct net_device *netdev = pci_get_drvdata(pdev);
> +	struct net_device *netdev = dev_get_drvdata(dev);
>  	struct atl1c_adapter *adapter = netdev_priv(netdev);
>  	struct atl1c_hw *hw = &adapter->hw;
>  	u32 wufc = adapter->wol;
> @@ -2437,7 +2436,7 @@ static int atl1c_suspend(struct device *dev)
>  
>  	if (wufc)
>  		if (atl1c_phy_to_ps_link(hw) != 0)
> -			dev_dbg(&pdev->dev, "phy power saving failed");
> +			dev_dbg(dev, "phy power saving failed");

These and similar uses could/should use netdev_dbg

			netdev_dbg(netdev, "phy power saving failed\n");

with the terminating newline too

> diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
[]
> @@ -2780,7 +2779,7 @@ static int atl1_suspend(struct device *dev)
>  		val = atl1_get_speed_and_duplex(hw, &speed, &duplex);
>  		if (val) {
>  			if (netif_msg_ifdown(adapter))
> -				dev_printk(KERN_DEBUG, &pdev->dev,
> +				dev_printk(KERN_DEBUG, dev,
>  					"error getting speed/duplex\n");

netdev_printk(KERN_DEBUG, netdev, etc...);


