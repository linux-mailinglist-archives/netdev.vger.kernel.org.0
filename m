Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063AD88006
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 18:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437095AbfHIQap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 12:30:45 -0400
Received: from smtprelay0207.hostedemail.com ([216.40.44.207]:46645 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726556AbfHIQao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 12:30:44 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 4A2E98368EFA;
        Fri,  9 Aug 2019 16:30:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2689:2828:3138:3139:3140:3141:3142:3352:3622:3866:3870:3874:4321:4605:5007:8603:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12297:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21451:21626:21740:30003:30054:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.14.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:29,LUA_SUMMARY:none
X-HE-Tag: part95_232f517601209
X-Filterd-Recvd-Size: 2195
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Fri,  9 Aug 2019 16:30:41 +0000 (UTC)
Message-ID: <dc0de0cd9a1e24477b20d563199e800b98d933f6.camel@perches.com>
Subject: Re: [PATCH v2 09/13] net: lpc-enet: fix printk format strings
From:   Joe Perches <joe@perches.com>
To:     Arnd Bergmann <arnd@arndb.de>, soc@kernel.org
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kbuild test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Fri, 09 Aug 2019 09:30:40 -0700
In-Reply-To: <20190809144043.476786-10-arnd@arndb.de>
References: <20190809144043.476786-1-arnd@arndb.de>
         <20190809144043.476786-10-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-08-09 at 16:40 +0200, Arnd Bergmann wrote:
> compile-testing this driver on other architectures showed
> multiple warnings:
> 
>   drivers/net/ethernet/nxp/lpc_eth.c: In function 'lpc_eth_drv_probe':
>   drivers/net/ethernet/nxp/lpc_eth.c:1337:19: warning: format '%d' expects argument of type 'int', but argument 4 has type 'resource_size_t {aka long long unsigned int}' [-Wformat=]
> 
>   drivers/net/ethernet/nxp/lpc_eth.c:1342:19: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'dma_addr_t {aka long long unsigned int}' [-Wformat=]
> 
> Use format strings that work on all architectures.
[]
> diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
[]
> @@ -1333,13 +1333,14 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
>  	pldat->dma_buff_base_p = dma_handle;
>  
>  	netdev_dbg(ndev, "IO address space     :%pR\n", res);
> -	netdev_dbg(ndev, "IO address size      :%d\n", resource_size(res));
> +	netdev_dbg(ndev, "IO address size      :%zd\n",
> +			(size_t)resource_size(res));

Ideally all these would use %zu not %zd


