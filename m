Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF5132F1FC
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 18:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhCER52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 12:57:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhCER5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 12:57:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57DAB6506A;
        Fri,  5 Mar 2021 17:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614967038;
        bh=kWIujxV213g1u6NMBoyZMWWUf4fXdzjhWrcbJl8m5C4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ocKvfltVipf42vp3IKI4XW7eKYx8fvZV8MYK2T0IFuFPJe7BRHY/0WRDN4eMzJ2bz
         LCZzaMAeZbf5CjEmyQcVC9rix10pPNJODUmEssH+uQ9zvkBQeKtPMo9JFetRm3R7Lq
         bK+zMfJ1ADyBAVLguU6rm6VYpIohpnAKacjxWn/xPHbBb0LLRqcOw5CtamFK/eMOXc
         xQRv7TQ5yesbQsN92ZKLo2QLlU//930b4cgu1G1NdgRk0JPaDiQs8u388fa3xTYGSn
         rXIffxy3E+r4y9jP5qyR+5M5F7rwpH6QBHuKhQG3mlqLKbuuHSJFhFa3OrlUs6bWx3
         CzJkEZBadfHCg==
Date:   Fri, 5 Mar 2021 09:57:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] ipv6: drop incoming packets having a v4mapped
 source address
Message-ID: <20210305095717.241dbdf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20191002163855.145178-1-edumazet@google.com>
References: <20191002163855.145178-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Oct 2019 09:38:55 -0700 Eric Dumazet wrote:
> This began with a syzbot report. syzkaller was injecting
> IPv6 TCP SYN packets having a v4mapped source address.
> 
> After an unsuccessful 4-tuple lookup, TCP creates a request
> socket (SYN_RECV) and calls reqsk_queue_hash_req()
> 
> reqsk_queue_hash_req() calls sk_ehashfn(sk)
> 
> At this point we have AF_INET6 sockets, and the heuristic
> used by sk_ehashfn() to either hash the IPv4 or IPv6 addresses
> is to use ipv6_addr_v4mapped(&sk->sk_v6_daddr)
> 
> For the particular spoofed packet, we end up hashing V4 addresses
> which were not initialized by the TCP IPv6 stack, so KMSAN fired
> a warning.
> 
> I first fixed sk_ehashfn() to test both source and destination addresses,
> but then faced various problems, including user-space programs
> like packetdrill that had similar assumptions.
> 
> Instead of trying to fix the whole ecosystem, it is better
> to admit that we have a dual stack behavior, and that we
> can not build linux kernels without V4 stack anyway.
> 
> The dual stack API automatically forces the traffic to be IPv4
> if v4mapped addresses are used at bind() or connect(), so it makes
> no sense to allow IPv6 traffic to use the same v4mapped class.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Reported-by: syzbot <syzkaller@googlegroups.com>

FTR this appears to break an UDP/sFlow application which used to work
fine with mapped addresses. Given the IETF memo perhaps a sysctl would
be appropriate, but even with that we're back to problems in TCP if the
sysctl is flipped :S

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
>  	skb->transport_header = skb->network_header + sizeof(*hdr);
>  	IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);
>  

