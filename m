Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D7BBB77A
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 17:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfIWPGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 11:06:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:41730 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726135AbfIWPGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Sep 2019 11:06:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 95048ACD7;
        Mon, 23 Sep 2019 15:06:02 +0000 (UTC)
Date:   Mon, 23 Sep 2019 17:06:01 +0200
From:   Petr Vorel <pvorel@suse.cz>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ipv6: Properly check reference count flag before taking
 reference
Message-ID: <20190923150600.GA27191@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20190923144612.29668-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923144612.29668-1-Jason@zx2c4.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> People are reporting that WireGuard experiences erratic crashes on 5.3,
> and bisected it down to 7d30a7f6424e. Casually flipping through that
> commit I noticed that a flag is checked using `|` instead of `&`, which in
> this current case, means that a reference is never incremented, which
> would result in the use-after-free users are seeing. This commit changes
> the `|` to the proper `&` test.

> Cc: stable@vger.kernel.org
> Fixes: 7d30a7f6424e ("Merge branch 'ipv6-avoid-taking-refcnt-on-dst-during-route-lookup'")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Reviewed-by: Petr Vorel <pvorel@suse.cz>

NOTE: this change was added in d64a1f574a29 ("ipv6: honor RT6_LOOKUP_F_DST_NOREF in rule lookup logic")

Kind regards,
Petr

> ---
>  net/ipv6/ip6_fib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
> index 87f47bc55c5e..6e2af411cd9c 100644
> --- a/net/ipv6/ip6_fib.c
> +++ b/net/ipv6/ip6_fib.c
> @@ -318,7 +318,7 @@ struct dst_entry *fib6_rule_lookup(struct net *net, struct flowi6 *fl6,
>  	if (rt->dst.error == -EAGAIN) {
>  		ip6_rt_put_flags(rt, flags);
>  		rt = net->ipv6.ip6_null_entry;
> -		if (!(flags | RT6_LOOKUP_F_DST_NOREF))
> +		if (!(flags & RT6_LOOKUP_F_DST_NOREF))
>  			dst_hold(&rt->dst);
>  	}
