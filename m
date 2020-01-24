Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0BBA1490CA
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 23:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAXWQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 17:16:37 -0500
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:50451 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727264AbgAXWQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 17:16:36 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 5D7BC4DAD;
        Fri, 24 Jan 2020 22:16:35 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:4321:5007:6119:7576:8660:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12297:12438:12740:12760:12895:13069:13148:13161:13229:13230:13311:13357:13439:14181:14659:14721:21080:21627:21990,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: bath25_1c5321fa4a340
X-Filterd-Recvd-Size: 2460
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Fri, 24 Jan 2020 22:16:34 +0000 (UTC)
Message-ID: <6713b0b5394cfcc5b2b2c6c2f2fb48920a3f2efa.camel@perches.com>
Subject: Re: [net-next 06/14] mlx5: Use proper logging and tracing line
 terminations
From:   Joe Perches <joe@perches.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Fri, 24 Jan 2020 14:15:31 -0800
In-Reply-To: <20200124215431.47151-7-saeedm@mellanox.com>
References: <20200124215431.47151-1-saeedm@mellanox.com>
         <20200124215431.47151-7-saeedm@mellanox.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-01-24 at 21:55 +0000, Saeed Mahameed wrote:
> From: Joe Perches <joe@perches.com>

Not really from me.

> netdev_err should use newline termination but mlx5_health_report
> is used in a trace output function devlink_health_report where
> no newline should be used.
> 
> Remove the newlines from a couple formats and add a format string
> of "%s\n" to the netdev_err call to not directly output the
> logging string.
> 
> Also use snprintf to avoid any possible output string overrun.
[]
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
[]
> @@ -389,10 +389,10 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
>  	err_ctx.ctx = sq;
>  	err_ctx.recover = mlx5e_tx_reporter_timeout_recover;
>  	err_ctx.dump = mlx5e_tx_reporter_dump_sq;
> -	sprintf(err_str,
> -		"TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%x, usecs since last trans: %u\n",
> -		sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
> -		jiffies_to_usecs(jiffies - sq->txq->trans_start));
> +	snprintf(err_str, sizeof(err_str),
> +		 "TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%x, usecs since last trans: %u\n",
> +		 sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
> +		 jiffies_to_usecs(jiffies - sq->txq->trans_start));

This is not the patch I sent.
There should not be a newline here and
there was no newline in the patch I sent.

>  	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
>  }

