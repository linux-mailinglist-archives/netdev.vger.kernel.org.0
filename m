Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B6C30FFFA
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 23:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhBDWPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 17:15:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhBDWPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 17:15:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25D9664F93;
        Thu,  4 Feb 2021 22:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612476892;
        bh=GpmSw79ymJetHCbvJFBKDSisj8//wlTvJjHMvYZprDA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hg8WKXSkHduVIK0DaaVKr+En3mlAt647pQcm03takACsXd2AXkA+yDYE3nTwF7ceP
         gSbNI+Y27YHFliKbl6HmOkYOP3+wHJOI8pxOJ2GoZuCy1azbMVjTHldTQzSUMpr0/P
         hUMVFZESylDdfXAKghWfXP4bbxYV/dEbc4U+FJ15esNsjzhocOM0al8TgdT3VAnnOq
         /bkw4PWBjQJUlGuqLzBikqo2SCmjHXJPRb20kmO5rzOWuhHgUChgeV8a70BHtY5i/s
         B56hCRCJdTCv5vBqaayHtSB0+tWNYd3WjvmgXaUYXW4QyCbnljetx7xHqsKLjwkz9i
         XTaOR3ZvEVzJw==
Message-ID: <dbad0731e30c920cf4ab3458dfce3c73060e917c.camel@kernel.org>
Subject: Re: [PATCH net] net: gro: do not keep too many GRO packets in
 napi->rx_list
From:   Saeed Mahameed <saeed@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        John Sperbeck <jsperbeck@google.com>,
        Jian Yang <jianyang@google.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Edward Cree <ecree@solarflare.com>
Date:   Thu, 04 Feb 2021 14:14:51 -0800
In-Reply-To: <20210204213146.4192368-1-eric.dumazet@gmail.com>
References: <20210204213146.4192368-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-02-04 at 13:31 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Commit c80794323e82 ("net: Fix packet reordering caused by GRO and
> listified RX cooperation") had the unfortunate effect of adding
> latencies in common workloads.
> 
> Before the patch, GRO packets were immediately passed to
> upper stacks.
> 
> After the patch, we can accumulate quite a lot of GRO
> packets (depdending on NAPI budget).
> 

Why napi budget ? looking at the code it seems to be more related to
MAX_GRO_SKBS * gro_normal_batch, since we are counting GRO SKBs as 1

but maybe i am missing some information about the actual issue you are
hitting.

> My fix is counting in napi->rx_count number of segments
> instead of number of logical packets.
> 
> Fixes: c80794323e82 ("net: Fix packet reordering caused by GRO and
> listified RX cooperation")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Bisected-by: John Sperbeck <jsperbeck@google.com>
> Tested-by: Jian Yang <jianyang@google.com>
> Cc: Maxim Mikityanskiy <maximmi@mellanox.com>
> Cc: Alexander Lobakin <alobakin@dlink.ru>
> Cc: Saeed Mahameed <saeedm@mellanox.com>
> Cc: Edward Cree <ecree@solarflare.com>
> ---
>  net/core/dev.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index
> a979b86dbacda9dfe31dd8b269024f7f0f5a8ef1..449b45b843d40ece7dd1e2ed6a5
> 996ee1db9f591 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5735,10 +5735,11 @@ static void gro_normal_list(struct
> napi_struct *napi)
>  /* Queue one GRO_NORMAL SKB up for list processing. If batch size
> exceeded,
>   * pass the whole batch up to the stack.
>   */
> -static void gro_normal_one(struct napi_struct *napi, struct sk_buff
> *skb)
> +static void gro_normal_one(struct napi_struct *napi, struct sk_buff
> *skb, int segs)
>  {
>         list_add_tail(&skb->list, &napi->rx_list);
> -       if (++napi->rx_count >= gro_normal_batch)
> +       napi->rx_count += segs;
> +       if (napi->rx_count >= gro_normal_batch)
>                 gro_normal_list(napi);
>  }
>  
> @@ -5777,7 +5778,7 @@ static int napi_gro_complete(struct napi_struct
> *napi, struct sk_buff *skb)
>         }
>  
>  out:
> -       gro_normal_one(napi, skb);
> +       gro_normal_one(napi, skb, NAPI_GRO_CB(skb)->count);

Seems correct to me,

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>


