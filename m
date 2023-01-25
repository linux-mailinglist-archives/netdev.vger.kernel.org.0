Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 519D167A9A3
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 05:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjAYEbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 23:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjAYEbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 23:31:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CEA470BC
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 20:31:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04D22B81892
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 04:31:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646CDC433D2;
        Wed, 25 Jan 2023 04:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674621060;
        bh=F5Cy3RQaKQHFr966hwl2H7qurX9bwcZfriMg7cCn9NU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S+8KGf7lnXD0i9xFjTMLjY3fqmDdBv/n9d+FUXYrdxYyJ2PcjSx3mkmcLByKjMUB0
         LwuRk/SpGpUxhPklE6QXZAtOdYwkeBV4ViJ2i5z3w4YTH4YQttDAFUpuiQO1MSqDFr
         EOlZqf3U5kbcsX6lvA845fw52wq1yfnkzYfNiojfI5Ph1+EFV8FaP90navELTW6rRU
         TJFbeDvF45IiqfGZ5YANpGVeTzCwHov4iygivUPd2VH6Px28h+ktl18jGpHN30+VW7
         +cdPRsDwyyyzbNnOFd8wVY0xu5GgPqtw+M8OjSLmMMv7Ifapm8aOaA7VzufqvVaEBD
         dMGfgWO8JGgMQ==
Date:   Tue, 24 Jan 2023 20:30:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Brian Haley <haleyb.dev@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] neighbor: fix proxy_delay usage when it is
 zero
Message-ID: <20230124203059.59cdb789@kernel.org>
In-Reply-To: <20230123185829.238909-1-haleyb.dev@gmail.com>
References: <20230123185829.238909-1-haleyb.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Jan 2023 13:58:29 -0500 Brian Haley wrote:
> When set to zero, the neighbor sysctl proxy_delay value
> does not cause an immediate reply for ARP/ND requests
> as expected, it instead causes a random delay between
> [0, U32_MAX]. Looking at this comment from
> __get_random_u32_below() explains the reason:
> 
> /*
>  * This function is technically undefined for ceil == 0, and in fact
>  * for the non-underscored constant version in the header, we build bug
>  * on that. But for the non-constant case, it's convenient to have that
>  * evaluate to being a straight call to get_random_u32(), so that
>  * get_random_u32_inclusive() can work over its whole range without
>  * undefined behavior.
>  */
> 
> Added helper function that does not call get_random_u32_below()
> if proxy_delay is zero and just uses the current value of
> jiffies instead, causing pneigh_enqueue() to respond
> immediately.
> 
> Also added definition of proxy_delay to ip-sysctl.txt since
> it was missing.

Sounds like this never worked, until commit a533b70a657c ("net:
neighbor: fix a crash caused by mod zero") it crashed, now it
does something silly. Can we instead reject 0 as invalid input
during configuration?

> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 7fbd060d6047..34183fb38b20 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -1589,6 +1589,12 @@ proxy_arp_pvlan - BOOLEAN
>  	  Hewlett-Packard call it Source-Port filtering or port-isolation.
>  	  Ericsson call it MAC-Forced Forwarding (RFC Draft).
>  
> +proxy_delay - INTEGER
> +	Delay proxy response.
> +
> +	The maximum number of jiffies to delay a response to a neighbor
> +	solicitation when proxy_arp or proxy_ndp is enabled. Defaults to 80.

Is there a better way of expressing the fact that we always
choose a value lower than proxy_delay ? Maximum sounds a bit
like we'd do:

	when = jiffies + random() % (proxy_delay + 1);

>  shared_media - BOOLEAN
>  	Send(router) or accept(host) RFC1620 shared media redirects.
>  	Overrides secure_redirects.
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index f00a79fc301b..8bd8aaae6d5e 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1662,11 +1662,22 @@ static void neigh_proxy_process(struct timer_list *t)
>  	spin_unlock(&tbl->proxy_queue.lock);
>  }
>  
> +static __inline__ unsigned long neigh_proxy_delay(struct neigh_parms *p)

Drop the inline please, it's pointless for a tiny static function

> +{
> +	/*

did you run checkpatch?

> +	 * If proxy_delay is zero, do not call get_random_u32_below()
> +	 * as it is undefined behavior.
> +	 */
> +	unsigned long proxy_delay = NEIGH_VAR(p, PROXY_DELAY);

empty line here

> +	return proxy_delay ?
> +	       jiffies + get_random_u32_below(NEIGH_VAR(p, PROXY_DELAY)) :

also - since you have proxy_delay in a local variable why not use it

> +	       jiffies;
> +}
> +
>  void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
>  		    struct sk_buff *skb)
>  {
> -	unsigned long sched_next = jiffies +
> -			get_random_u32_below(NEIGH_VAR(p, PROXY_DELAY));
> +	unsigned long sched_next = neigh_proxy_delay(p);
>  
>  	if (p->qlen > NEIGH_VAR(p, PROXY_QLEN)) {
>  		kfree_skb(skb);

