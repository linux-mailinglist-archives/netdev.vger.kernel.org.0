Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32315401F66
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 20:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244342AbhIFSEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 14:04:47 -0400
Received: from relay.sw.ru ([185.231.240.75]:56336 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230219AbhIFSEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 14:04:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=dYP/kVnj128ydFQC67ehImb7kV/TltFY1+9Ktuzp6xA=; b=TnqDEF+bamo+Jgk4y
        qLXLFXXUUzHU3PUraXl11qn0eFHFfsIVeI44tA/lxa1C8JDABq+wcogaXlZuqIrzz3V/E3b4mzQZE
        cItqAJKpiRmFD4dQsTzSJnSOaKuesYr7Ey4lvVGJfkECxGDSDWILWqL/nAyVZ0gXZhdFyUkJsIybI
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mNIxv-0013kX-Tv; Mon, 06 Sep 2021 21:03:31 +0300
Subject: Re: [PATCH net v6] skb_expand_head() adjust skb->truesize incorrectly
From:   Vasily Averin <vvs@virtuozzo.com>
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <63f90028-df26-d212-3bd2-65168736ce06@virtuozzo.com>
 <cd1ad476-2f2b-b3e5-4cae-442c91ad4279@virtuozzo.com>
Message-ID: <82b4794e-1e39-6ac8-1047-dd19350a168a@virtuozzo.com>
Date:   Mon, 6 Sep 2021 21:03:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <cd1ad476-2f2b-b3e5-4cae-442c91ad4279@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've finally reproduced original issue by using reproducer from Christoph Paasch,
and was able locally validate this patch.

Thank you,
	Vasily Averin

On 9/6/21 9:01 PM, Vasily Averin wrote:
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
>      - after successfull pskb_expand_head() to change owner on extended skb.
> v2: based on patch version from Eric Dumazet,
>     added __pskb_expand_head() function, which can be forced
>     to adjust skb->truesize and sk->sk_wmem_alloc.
> ---
>  include/net/sock.h |  1 +
>  net/core/skbuff.c  | 60 ++++++++++++++++++++++++++++++++++++++++++++++--------
>  net/core/sock.c    |  8 ++++++++
>  3 files changed, 60 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 95b2577..173d58c 100644
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
> index f931176..e2a2aa31 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1804,28 +1804,70 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>  {
>  	int delta = headroom - skb_headroom(skb);
> +	int osize = skb_end_offset(skb);
> +	struct sk_buff *oskb = NULL;
> +	struct sock *sk = skb->sk;
>  
>  	if (WARN_ONCE(delta <= 0,
>  		      "%s is expecting an increase in the headroom", __func__))
>  		return skb;
>  
> -	/* pskb_expand_head() might crash, if skb is shared */
> +	delta = SKB_DATA_ALIGN(delta);
> +	/* pskb_expand_head() might crash, if skb is shared. */
>  	if (skb_shared(skb)) {
>  		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>  
> -		if (likely(nskb)) {
> -			if (skb->sk)
> -				skb_set_owner_w(nskb, skb->sk);
> -			consume_skb(skb);
> -		} else {
> +		if (unlikely(!nskb)) {
>  			kfree_skb(skb);
> +			return NULL;
>  		}
> +		oskb = skb;
>  		skb = nskb;
>  	}
> -	if (skb &&
> -	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
> +	if (pskb_expand_head(skb, delta, 0, GFP_ATOMIC)) {
>  		kfree_skb(skb);
> -		skb = NULL;
> +		kfree_skb(oskb);
> +		return NULL;
> +	}
> +	if (oskb) {
> +		if (sk)
> +			skb_set_owner_w(skb, sk);
> +		consume_skb(oskb);
> +	} else if (sk && skb->destructor != sock_edemux) {
> +		bool ref, set_owner;
> +
> +		ref = false; set_owner = false;
> +		delta = skb_end_offset(skb) - osize;
> +		/* skb_set_owner_w() calls current skb destructor.
> +		 * It can reduce sk_wmem_alloc to 0 and release sk,
> +		 * To prevnt this, we increase sk_wmem_alloc in advance.
> +		 * Some destructors might release the last sk_refcnt,
> +		 * so it won't be possible to call sock_hold for !fullsock
> +		 * We take an extra sk_refcnt to prevent this.
> +		 * In any case we increase truesize of expanded skb.
> +		 */
> +		refcount_add(delta, &sk->sk_wmem_alloc);
> +		if (!is_skb_wmem(skb)) {
> +			set_owner = true;
> +			if (!sk_fullsock(sk) && IS_ENABLED(CONFIG_INET)) {
> +				/* skb_set_owner_w can set sock_edemux */
> +				ref = refcount_inc_not_zero(&sk->sk_refcnt);
> +				if (!ref) {
> +					set_owner = false;
> +					WARN_ON(refcount_sub_and_test(delta, &sk->sk_wmem_alloc));
> +				}
> +			}
> +		}
> +		if (set_owner)
> +			skb_set_owner_w(skb, sk);
> +#ifdef CONFIG_INET
> +		if (skb->destructor == sock_edemux) {
> +			WARN_ON(refcount_sub_and_test(delta, &sk->sk_wmem_alloc));
> +			if (ref)
> +				WARN_ON(refcount_dec_and_test(&sk->sk_refcnt));
> +		}
> +#endif
> +		skb->truesize += delta;
>  	}
>  	return skb;
>  }
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 950f1e7..6cbda43 100644
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

