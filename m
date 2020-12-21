Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB312E010D
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgLUTdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:33:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgLUTdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 14:33:22 -0500
Date:   Mon, 21 Dec 2020 11:32:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608579161;
        bh=TCTuYaYNHrP7bcRC51HYFpDjsH33vTgwsnuPSS27qpE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=FZpPgB/aYN6/kAO1fq6YHOSY1BkdzWBX/TZ9ixqXarXjQAeZWK2bUvH+DZfwgE8QW
         p14XU4COE0tmamJsr5d5X1/RjygpQTqSvqG2a4FiHCcKFMOb1+v7EYFaEhM/f4oI1V
         P3TSQMJzgw3JqGqVLsogpJVyqyaXZ4O2MiJuuc9dj1MT0sU0k18yIJH9vWsio8PcG4
         vWBJAwCegN8DtT7sq3A0fBVbRxLLPy5C2Oujb4hSHAn9oC/r4RKzCnmwCy+Yr1wtzC
         tSx4PLUfnfHRwa4rl6lFFzIr9XHle5GwQ/CPlYE5kJguer0IVLuypY00mtoyzpJvYO
         yNY2WR6YYIgqg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     weichenchen <weichen.chen@linux.alibaba.com>
Cc:     splendidsky.cwc@alibaba-inc.com, yanxu.zw@alibaba-inc.com,
        "David S. Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Jeff Dike <jdike@akamai.com>,
        Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: neighbor: fix a crash caused by mod zero
Message-ID: <20201221113240.2ae38a77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201221130754.12628-1-weichen.chen@linux.alibaba.com>
References: <20201219102116.3cc0d74c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201221130754.12628-1-weichen.chen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Dec 2020 21:07:44 +0800 weichenchen wrote:
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
> ---
> V2:
>     - Use READ_ONCE() to prevent the complier from re-reading
>       NEIGH_VAR(p, PROXY_DELAY).
>     - Give a hint to the complier that delay <= 0 is unlikely
>       to happen.
> 
> Note: I don't think having the caller pass in the value is a
> good idea mainly because delay should be only decided by
> /proc/sys/net/ipv4/neigh/[device]/proxy_delay rather than the
> caller.

In terms of not breaking abstraction? The decision to call 
this helper or not is made in the caller. And both callers 
do a NEIGH_VAR(p, PROXY_DELAY) == 0 check before making the 
call.

It seems like if the caller used READ_ONCE and passed the value 
in we would save ourselves the potentially surprising code flow.

> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 9500d28a43b0..7b03d3f129c0 100644
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
> +	int delay = READ_ONCE(NEIGH_VAR(p, PROXY_DELAY));
> +
> +	if (unlikely(delay <= 0))
> +		sched_next = now;
> +	else
> +		sched_next = now + (prandom_u32() % delay);
>  
>  	if (tbl->proxy_queue.qlen > NEIGH_VAR(p, PROXY_QLEN)) {
>  		kfree_skb(skb);

