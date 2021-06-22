Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE11F3B071C
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 16:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhFVOOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 10:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbhFVOOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 10:14:30 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4D6C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 07:12:14 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id m18so23862229wrv.2
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 07:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IuYCkiUjGqZ1aZwCzkarx0PPbQs1Bqo9JGZtZtG8d5U=;
        b=qGuE703iUsKtMsCvQxny0JdxFWXRZfQ0oQNHlwvPCVVXtNrLFKxVbNLqp4sW/xmzcP
         i22p+a+/igAj6xbdwtQy0wsTaTRqMy9g6oA7zLLwM3K6TbW0SMM5afZZ19VrATF6efZf
         GG9+pqZJi8L0m4Cs4MIncRo4yu7c5QjER8E5OnTHHzLRlM+xKm3wZz+RdfPgDyydu26j
         rX9s5F7seiRfx8Enp/Y0R74TVYi+3uWJodndbf/e4zh1X1QJ8zZ1Q/A34q/inkA1XL+R
         yZY4TurBacJVnSXTT1yVyLe32CoJlGoDw6muwAV4RsaDNtc19zJtWe8Hx6FDlqB6lXHx
         a+nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IuYCkiUjGqZ1aZwCzkarx0PPbQs1Bqo9JGZtZtG8d5U=;
        b=eJtQaatuv/2SCad8xVLMcIf8owRo13SD4IDSLAdFOzBI3njCSeDuTSvyrlOtCkYuxa
         nem0avEuDNXW7WWU/vu3rvDIGrPhnopEjo8YKw/4NqhoCZ75g+gOFCH4OarLSllguuTU
         YDP9lymRc+Eh+VZK5YygY2wCVZevs5kCsuK1FpCo3CL4k5q9uRgqSLBKKB+MdE1k7DYd
         gJxVwiaLIkkutzyhZ6OEphLsJt6s461dRlgINvdvvLI2PGiw77F4hPkxbhhMKtEiLLvR
         5pwSEpg5DxtbfofqgT+llsyTVsDkyI0GhwtzeY2/BTFoc5Z20Pvp4Fw0a7U8Nrw1l+WG
         BhwA==
X-Gm-Message-State: AOAM5318FubLtLU2qkGlBuDELI/2YfDGaw1xhje1mHIv4ndiSpDLj1po
        XzAg5Ty+EjCYXm+W6Z92J78=
X-Google-Smtp-Source: ABdhPJxshEiNbnPHqgNZXjMbbggkilLvtuLp9k1JKCmPJxq+fywz+YeXTeAhN7w2zubNhna/NGY2pQ==
X-Received: by 2002:adf:e787:: with SMTP id n7mr4990974wrm.169.1624371133443;
        Tue, 22 Jun 2021 07:12:13 -0700 (PDT)
Received: from [192.168.181.98] (15.248.23.93.rev.sfr.net. [93.23.248.15])
        by smtp.gmail.com with ESMTPSA id 61sm22950449wrp.4.2021.06.22.07.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 07:12:12 -0700 (PDT)
Subject: Re: [PATCH net-next] ip: avoid OOM kills with large UDP sends over
 loopback
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
References: <20210621231307.1917413-1-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8fe00e04-3a79-6439-6ec7-5e40408529e2@gmail.com>
Date:   Tue, 22 Jun 2021 16:12:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210621231307.1917413-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/21 1:13 AM, Jakub Kicinski wrote:
> Dave observed number of machines hitting OOM on the UDP send
> path. The workload seems to be sending large UDP packets over
> loopback. Since loopback has MTU of 64k kernel will try to
> allocate an skb with up to 64k of head space. This has a good
> chance of failing under memory pressure. What's worse if
> the message length is <32k the allocation may trigger an
> OOM killer.
> 
> This is entirely avoidable, we can use an skb with frags.
> 
> The scenario is unlikely and always using frags requires
> an extra allocation so opt for using fallback, rather
> then always using frag'ed/paged skb when payload is large.
> 
> Note that the size heuristic (header_len > PAGE_SIZE)
> is not entirely accurate, __alloc_skb() will add ~400B
> to size. Occasional order-1 allocation should be fine,
> though, we are primarily concerned with order-3.
> 
> Reported-by: Dave Jones <dsj@fb.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/net/sock.h    | 11 +++++++++++
>  net/ipv4/ip_output.c  | 19 +++++++++++++++++--
>  net/ipv6/ip6_output.c | 19 +++++++++++++++++--
>  3 files changed, 45 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 7a7058f4f265..4134fb718b97 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -924,6 +924,17 @@ static inline gfp_t sk_gfp_mask(const struct sock *sk, gfp_t gfp_mask)
>  	return gfp_mask | (sk->sk_allocation & __GFP_MEMALLOC);
>  }
>  
> +static inline void sk_allocation_push(struct sock *sk, gfp_t flag, gfp_t *old)
> +{
> +	*old = sk->sk_allocation;
> +	sk->sk_allocation |= flag;
> +}
> +

This is not thread safe.

Remember UDP sendmsg() does not lock the socket for non-corking sends.

> +static inline void sk_allocation_pop(struct sock *sk, gfp_t old)
> +{
> +	sk->sk_allocation = old;
> +}
> +
>  static inline void sk_acceptq_removed(struct sock *sk)
>  {
>  	WRITE_ONCE(sk->sk_ack_backlog, sk->sk_ack_backlog - 1);
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index c3efc7d658f6..a300c2c65d57 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1095,9 +1095,24 @@ static int __ip_append_data(struct sock *sk,
>  				alloclen += rt->dst.trailer_len;
>  
>  			if (transhdrlen) {
> -				skb = sock_alloc_send_skb(sk,
> -						alloclen + hh_len + 15,
> +				size_t header_len = alloclen + hh_len + 15;
> +				gfp_t sk_allocation;
> +
> +				if (header_len > PAGE_SIZE)
> +					sk_allocation_push(sk, __GFP_NORETRY,
> +							   &sk_allocation);
> +				skb = sock_alloc_send_skb(sk, header_len,
>  						(flags & MSG_DONTWAIT), &err);
> +				if (header_len > PAGE_SIZE) {
> +					BUILD_BUG_ON(MAX_HEADER >= PAGE_SIZE);
> +
> +					sk_allocation_pop(sk, sk_allocation);
> +					if (unlikely(!skb) && !paged &&
> +					    rt->dst.dev->features & NETIF_F_SG) {
> +						paged = true;
> +						goto alloc_new_skb;
> +					}
> +				}


What about using sock_alloc_send_pskb(... PAGE_ALLOC_COSTLY_ORDER)
(as we did in unix_dgram_sendmsg() for large packets), for SG enabled interfaces ?

We do not _have_ to put all the payload in skb linear part,
we could instead use page frags (order-0 if high order pages are not available)


>  			} else {
>  				skb = NULL;
>  				if (refcount_read(&sk->sk_wmem_alloc) + wmem_alloc_delta <=
