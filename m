Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983DC2DF101
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 19:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgLSSV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 13:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgLSSV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 13:21:58 -0500
Date:   Sat, 19 Dec 2020 10:21:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608402077;
        bh=9anSoEyGYfwJXexpe6AJSpZfREs9m9aRLDWzjrBcS+4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=eRsUzkUv7P5atJeg5AJ+M/FUr1Xe/SC+T0zH0T9jEQz3uDHCWgy/YaWidKSZkdn8y
         02zDl8WpDmKwYzq12Z8KXRogx7MRBtYhZY31H4nhdb6NLnQToffek+G7BA2TnT9ILK
         QGr1dIaPIrdF/Er7oYa0GSNeUn8YhNzRgXHek1wZR/p8O+kk4IDErMzcsOGPhkdmTt
         TksQ8wUkma8m/S4nov+Pp7PyvrxMEoKBAtDUu9eQmyrwndrMlzXMSKncUz7Kesy5Wh
         ioMMjyr2ZAzLpjDswBwpa6iGEwfYig60X5fJJnZ+ByxepjGwvynPuAW5wsoKGAQt8V
         S0xPrW6/LqbLA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     weichenchen <weichen.chen@linux.alibaba.com>
Cc:     davem@davemloft.net, liuhangbin@gmail.com, dsahern@kernel.org,
        jdike@akamai.com, mrv@mojatatu.com, lirongqing@baidu.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        splendidsky.cwc@alibaba-inc.com, yanxu.zw@alibaba-inc.com
Subject: Re: [PATCH] net: neighbor: fix a crash caused by mod zero
Message-ID: <20201219102116.3cc0d74c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201218042019.52096-1-weichen.chen@linux.alibaba.com>
References: <20201218042019.52096-1-weichen.chen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Dec 2020 12:20:19 +0800 weichenchen wrote:
> pneigh_enqueue() tries to obtain a random delay by mod
> NEIGH_VAR(p, PROXY_DELAY). However, NEIGH_VAR(p, PROXY_DELAY)
> migth be zero at that point because someone could write zero
> to /proc/sys/net/ipv4/neigh/[device]/proxy_delay after the
> callers check it.
> 
> This patch double-checks NEIGH_VAR(p, PROXY_DELAY) in
> pneigh_enqueue() to ensure not to take zero as modulus.
> 
> Signed-off-by: weichenchen <weichen.chen@linux.alibaba.com>

Let's have the caller pass in the value since it did the checking?

> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 9500d28a43b0..eb5d015c53d3 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1570,9 +1570,14 @@ void pneigh_enqueue(struct neigh_table *tbl, struct neigh_parms *p,
>  		    struct sk_buff *skb)
>  {
>  	unsigned long now = jiffies;
> +	unsigned long sched_next;
>  
> -	unsigned long sched_next = now + (prandom_u32() %
> -					  NEIGH_VAR(p, PROXY_DELAY));
> +	int delay = NEIGH_VAR(p, PROXY_DELAY);
> +
> +	if (delay <= 0)

Not that this still doesn't guarantee that the compiler won't re-read
the value (however unlikely). We need a READ_ONCE().

> +		sched_next = now;
> +	else
> +		sched_next = now + (prandom_u32() % delay);
>  
>  	if (tbl->proxy_queue.qlen > NEIGH_VAR(p, PROXY_QLEN)) {
>  		kfree_skb(skb);

