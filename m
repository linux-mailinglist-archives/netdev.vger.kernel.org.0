Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EB9269DC3
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 07:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgIOFVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 01:21:32 -0400
Received: from smtprelay0224.hostedemail.com ([216.40.44.224]:38172 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbgIOFVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 01:21:32 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 341C1180AA4FD;
        Tue, 15 Sep 2020 05:21:30 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4321:5007:6691:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12297:12740:12760:12895:13069:13255:13311:13357:13439:14659:14721:21080:21451:21627:30012:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: jam58_380e3482710e
X-Filterd-Recvd-Size: 2003
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Tue, 15 Sep 2020 05:21:29 +0000 (UTC)
Message-ID: <d42ad86fb17e575b4e56b361b53629a9d8f858e8.camel@perches.com>
Subject: Re: [PATCH net-next v5 1/6] lib8390: Fix coding style issues and
 remove version printing
From:   Joe Perches <joe@perches.com>
To:     Armin Wolf <W_Armin@gmx.de>, davem@davemloft.net,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     netdev@vger.kernel.org
Date:   Mon, 14 Sep 2020 22:21:28 -0700
In-Reply-To: <20200914210128.7741-2-W_Armin@gmx.de>
References: <20200914210128.7741-1-W_Armin@gmx.de>
         <20200914210128.7741-2-W_Armin@gmx.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-14 at 23:01 +0200, Armin Wolf wrote:
> Fix various checkpatch warnings.
> 
> Remove version printing so modules including lib8390 do not
> have to provide a global version string for successful
> compilation.

This 8390 code is for a _really_ old driver.
It doesn't seem likely these changes are all that useful.
(and I say that as someone that's done a lot of drive-by
 cleaning to this code, mostly treewide though)

> diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/8390/lib8390.c
[]
> @@ -308,25 +301,24 @@ static netdev_tx_t __ei_start_xmit(struct sk_buff *skb,
>  	char *data = skb->data;
> 
>  	if (skb->len < ETH_ZLEN) {
> -		memset(buf, 0, ETH_ZLEN);	/* more efficient than doing just the needed bits */
> +		/* More efficient than doing just the needed bits */
> +		memset(buf, 0, ETH_ZLEN);
>  		memcpy(buf, data, skb->len);

Even with the comment, this bit seems less than optimal.
Maybe not overwriting the already zeroed content is better?
At least it's fewer memory accesses.

		memcpy(buf, data, skb->len);
		memset(&buf[skb->len], 0, ETH_ZLEN - skb->len);


