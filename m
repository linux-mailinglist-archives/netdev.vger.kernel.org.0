Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCBB225617
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 05:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGTDPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 23:15:45 -0400
Received: from smtprelay0210.hostedemail.com ([216.40.44.210]:48634 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726510AbgGTDPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 23:15:45 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 711A61800709C;
        Mon, 20 Jul 2020 03:15:44 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3867:3871:4250:4321:4605:5007:10004:10400:10848:11026:11232:11657:11658:11914:12043:12048:12114:12296:12297:12438:12740:12760:12895:13019:13069:13255:13311:13357:13439:14659:14721:21080:21451:21627:22047:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: fire30_270f2ac26f21
X-Filterd-Recvd-Size: 1856
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Mon, 20 Jul 2020 03:15:42 +0000 (UTC)
Message-ID: <f31ec3e646c9ba73c09f821a173c20110346deab.camel@perches.com>
Subject: Re: [PATCH net-next v2] net: ena: Fix using plain integer as NULL
 pointer in ena_init_napi_in_range
From:   Joe Perches <joe@perches.com>
To:     Wang Hai <wanghai38@huawei.com>, gtzalik@amazon.com,
        saeedb@amazon.com, zorik@amazon.com, davem@davemloft.net,
        kuba@kernel.org, sameehj@amazon.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 19 Jul 2020 20:15:41 -0700
In-Reply-To: <20200720025309.18597-1-wanghai38@huawei.com>
References: <20200720025309.18597-1-wanghai38@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-07-20 at 10:53 +0800, Wang Hai wrote:
> Fix sparse build warning:
> 
> drivers/net/ethernet/amazon/ena/ena_netdev.c:2193:34: warning:
>  Using plain integer as NULL pointer
[]
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
[]
> @@ -2190,11 +2190,10 @@ static void ena_del_napi_in_range(struct ena_adapter *adapter,
>  static void ena_init_napi_in_range(struct ena_adapter *adapter,
>  				   int first_index, int count)
>  {
> -	struct ena_napi *napi = {0};
>  	int i;
>  
>  	for (i = first_index; i < first_index + count; i++) {
> -		napi = &adapter->ena_napi[i];
> +		struct ena_napi *napi = &adapter->ena_napi[i];
>  
>  		netif_napi_add(adapter->netdev,
>  			       &adapter->ena_napi[i].napi,

Another possible change is to this statement:

 		netif_napi_add(adapter->netdev,
			       &napi->napi,
			       etc...);



