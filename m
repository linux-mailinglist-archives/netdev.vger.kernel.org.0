Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F2B420DCA
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbhJDNTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 09:19:04 -0400
Received: from relay.sw.ru ([185.231.240.75]:37906 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236256AbhJDNQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 09:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=WQ33uEg7GhDWMq/xO0qWy61MKydhEka6Yf8IGioQDH8=; b=FDkS6AqWQ3Ld/xios
        dfXeQ8FJPTjLmkjavhRV2s0PKFZHhDigwYEYUTDS/q61oZjWMMZRstKMO1dIrLaourmMJITsI65za
        9QZoABUDhD7xU3oKvEW/i/mx2ojR607UiI1pmZ4KGJgoRyMBbfEjeT997ZdrpAmW/jijdrEa2Q3nM
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mXNnn-004uNU-UB; Mon, 04 Oct 2021 16:14:43 +0300
Subject: Re: [PATCH net v9] skb_expand_head() adjust skb->truesize incorrectly
From:   Vasily Averin <vvs@virtuozzo.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        linux-kernel@vger.kernel.org, kernel@openvz.org
References: <45b3cb13-8c6e-25a3-f568-921ab6f1ca8f@virtuozzo.com>
 <2bd9c638-3038-5aba-1dae-ad939e13c0c4@virtuozzo.com>
Message-ID: <7d5f8955-56d4-d5a2-c74e-ed6d19649abb@virtuozzo.com>
Date:   Mon, 4 Oct 2021 16:14:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <2bd9c638-3038-5aba-1dae-ad939e13c0c4@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Eric,
could you please take look at this patch?

Original issue reported by Christoph Paasch is still not fixed,
however now buggy paches was merged into upstream.

v6 patch version [1] fixes the problem by careful change of destructor
on existing skb. I still think it is correct however I'm agree
it requires careful review.

[1] https://lkml.org/lkml/2021/9/6/584

This patch version is more simple and returns to cloning of non-wmem skb.

Both variants (i.e. this one and v6) resolves the problem.

Could you please review the patches, select one of them or propose some
better solution?

Thank you,
	Vasily Averin

On 10/4/21 4:00 PM, Vasily Averin wrote:
> Christoph Paasch reports [1] about incorrect skb->truesize
> after skb_expand_head() call in ip6_xmit.
> This may happen because of two reasons:
> - skb_set_owner_w() for newly cloned skb is called too early,
> before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
> - pskb_expand_head() does not adjust truesize in (skb->sk) case.
> In this case sk->sk_wmem_alloc should be adjusted too.
> 
> [1] https://lkml.org/lkml/2021/8/20/1082
> 
> Fixes: f1260ff15a71 ("skbuff: introduce skb_expand_head()")
> Fixes: 2d85a1b31dde ("ipv6: ip6_finish_output2: set sk into newly allocated nskb")
> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
> v9: restored sock_edemux check
> v8: clone non-wmem skb
> v7 (from kuba@):
>     shift more magic into helpers,
>     follow Eric's advice and don't inherit non-wmem skbs for now
> v6: fixed delta,
>     improved comments
> v5: fixed else condition, thanks to Eric
>     reworked update of expanded skb,
>     added corresponding comments
> v4: decided to use is_skb_wmem() after pskb_expand_head() call
>     fixed 'return (EXPRESSION);' in os_skb_wmem according to Eric Dumazet
> v3: removed __pskb_expand_head(),
>     added is_skb_wmem() helper for skb with wmem-compatible destructors
>     there are 2 ways to use it:
>      - before pskb_expand_head(), to create skb clones
>      - after successfull pskb_expand_head() to change owner on extended
>        skb.
> v2: based on patch version from Eric Dumazet,
>     added __pskb_expand_head() function, which can be forced
>     to adjust skb->truesize and sk->sk_wmem_alloc.
> ---
>  include/net/sock.h |  1 +
>  net/core/skbuff.c  | 35 ++++++++++++++++++++++-------------
>  net/core/sock.c    |  8 ++++++++
>  3 files changed, 31 insertions(+), 13 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 66a9a90f9558..a547651d46a7 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1695,6 +1695,7 @@ struct sk_buff *sock_wmalloc(struct sock *sk, unsigned long size, int force,
>  			     gfp_t priority);
>  void __sock_wfree(struct sk_buff *skb);
>  void sock_wfree(struct sk_buff *skb);
> +bool is_skb_wmem(const struct sk_buff *skb);
>  struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
>  			     gfp_t priority);
>  void skb_orphan_partial(struct sk_buff *skb);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 2170bea2c7de..8cb6d360cda5 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1804,30 +1804,39 @@ EXPORT_SYMBOL(skb_realloc_headroom);
>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>  {
>  	int delta = headroom - skb_headroom(skb);
> +	int osize = skb_end_offset(skb);
> +	struct sock *sk = skb->sk;
>  
>  	if (WARN_ONCE(delta <= 0,
>  		      "%s is expecting an increase in the headroom", __func__))
>  		return skb;
>  
> -	/* pskb_expand_head() might crash, if skb is shared */
> -	if (skb_shared(skb)) {
> +	delta = SKB_DATA_ALIGN(delta);
> +	/* pskb_expand_head() might crash, if skb is shared. */
> +	if (skb_shared(skb) || !is_skb_wmem(skb)) {
>  		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>  
> -		if (likely(nskb)) {
> -			if (skb->sk)
> -				skb_set_owner_w(nskb, skb->sk);
> -			consume_skb(skb);
> -		} else {
> -			kfree_skb(skb);
> -		}
> +		if (unlikely(!nskb))
> +			goto fail;
> +
> +		if (sk)
> +			skb_set_owner_w(nskb, sk);
> +		consume_skb(skb);
>  		skb = nskb;
>  	}
> -	if (skb &&
> -	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
> -		kfree_skb(skb);
> -		skb = NULL;
> +	if (pskb_expand_head(skb, delta, 0, GFP_ATOMIC))
> +		goto fail;
> +
> +	if (sk && skb->destructor != sock_edemux) {
> +		delta = skb_end_offset(skb) - osize;
> +		refcount_add(delta, &sk->sk_wmem_alloc);
> +		skb->truesize += delta;
>  	}
>  	return skb;
> +
> +fail:
> +	kfree_skb(skb);
> +	return NULL;
>  }
>  EXPORT_SYMBOL(skb_expand_head);
>  
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 62627e868e03..1932755ae9ba 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2227,6 +2227,14 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
>  }
>  EXPORT_SYMBOL(skb_set_owner_w);
>  
> +bool is_skb_wmem(const struct sk_buff *skb)
> +{
> +	return skb->destructor == sock_wfree ||
> +	       skb->destructor == __sock_wfree ||
> +	       (IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree);
> +}
> +EXPORT_SYMBOL(is_skb_wmem);
> +
>  static bool can_skb_orphan_partial(const struct sk_buff *skb)
>  {
>  #ifdef CONFIG_TLS_DEVICE
> 

