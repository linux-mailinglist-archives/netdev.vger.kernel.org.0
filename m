Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA58C90F9
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbfJBSjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 14:39:02 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40530 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726669AbfJBSjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 14:39:02 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iFjWa-0004gM-DQ; Wed, 02 Oct 2019 20:38:56 +0200
Date:   Wed, 2 Oct 2019 20:38:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] ipv6: drop incoming packets having a v4mapped source
 address
Message-ID: <20191002183856.GA13866@breakpoint.cc>
References: <20191002163855.145178-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002163855.145178-1-edumazet@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:
> The dual stack API automatically forces the traffic to be IPv4
> if v4mapped addresses are used at bind() or connect(), so it makes
> no sense to allow IPv6 traffic to use the same v4mapped class.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
>  net/ipv6/ip6_input.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index d432d0011c160f41aec09640e95179dd7b364cfc..2bb0b66181a741c7fb73cacbdf34c5160f52d186 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -223,6 +223,16 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
>  	if (ipv6_addr_is_multicast(&hdr->saddr))
>  		goto err;
>  
> +	/* While RFC4291 is not explicit about v4mapped addresses
> +	 * in IPv6 headers, it seems clear linux dual-stack
> +	 * model can not deal properly with these.
> +	 * Security models could be fooled by ::ffff:127.0.0.1 for example.
> +	 *
> +	 * https://tools.ietf.org/html/draft-itojun-v6ops-v4mapped-harmful-02
> +	 */
> +	if (ipv6_addr_v4mapped(&hdr->saddr))
> +		goto err;
> +

Any reason to only consider ->saddr instead of checking daddr as well?
