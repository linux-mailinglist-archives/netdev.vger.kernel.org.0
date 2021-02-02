Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8292930C65E
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbhBBQqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:46:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:58190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236514AbhBBQaA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 11:30:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0FBE64E9B;
        Tue,  2 Feb 2021 16:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612283351;
        bh=paQ+BchwYVvwdJSw+2am0VhJqPwumNJxvJ12yTRWSpw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UK6kKFcUjMI5eX8kXj5l5t4fWg8DmPpNdL3muGLNtrFV9Q9q1oJCBvWwGtusSUIv/
         W15JGwT2I7P1dfnzYb522HEMVCivIJCbztD2bvvdrLpBp3hf65kANOy3Z988Wygv6C
         a4jK2CVGwGA7mAzqELYuywb6jsdoHyxq0ZogWFOiLUisyKyRk7K90PKZCFosWJeepB
         1DiITVstTAU7ZQb03xqkyDBtEGlNKm7zQ8deY6x6AZNHBp8Y7sX3yNROr2dqdv9eTC
         vy5zi9VgWXJptRum47qzZzgbdX7b3CILl8EV+y6iLvGy5DqMyXhhrpXsaBjAa3x5st
         XTM3lDzROHcZg==
Date:   Tue, 2 Feb 2021 08:29:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Leon Romanovsky <leonro@nvidia.com>, coreteam@netfilter.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH net 1/4] ipv6: silence compilation warning for non-IPV6
 builds
Message-ID: <20210202082909.7d8f479f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202135544.3262383-2-leon@kernel.org>
References: <20210202135544.3262383-1-leon@kernel.org>
        <20210202135544.3262383-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Feb 2021 15:55:41 +0200 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The W=1 compilation of allmodconfig generates the following warning:
> 
> net/ipv6/icmp.c:448:6: warning: no previous prototype for 'icmp6_send' [-Wmissing-prototypes]
>   448 | void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
>       |      ^~~~~~~~~~
> 
> In such configuration, the icmp6_send() is not used outside of icmp.c, so close
> its EXPORT_SYMBOL and add "static" word to limit the scope.
> 
> Fixes: cc7a21b6fbd9 ("ipv6: icmp6: avoid indirect call for icmpv6_send()")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

That's a little much ifdefinery, why not move the declaration from
under the ifdef in the header instead?

If you repost please target net-next, admittedly these fixes are pretty
"obviously correct" but they are not urgent either.

> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index f3d05866692e..5d4232b492dc 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -445,6 +445,9 @@ static int icmp6_iif(const struct sk_buff *skb)
>  /*
>   *	Send an ICMP message in response to a packet in error
>   */
> +#if !IS_BUILTIN(CONFIG_IPV6)
> +static
> +#endif
>  void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
>  		const struct in6_addr *force_saddr)
>  {
> @@ -634,7 +637,10 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
>  out_bh_enable:
>  	local_bh_enable();
>  }
> +
> +#if IS_BUILTIN(CONFIG_IPV6)
>  EXPORT_SYMBOL(icmp6_send);
> +#endif
> 
>  /* Slightly more convenient version of icmp6_send.
>   */
> --
> 2.29.2
> 

