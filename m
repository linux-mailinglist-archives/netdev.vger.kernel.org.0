Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DE04105DD
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 12:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhIRKG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 06:06:56 -0400
Received: from relay.sw.ru ([185.231.240.75]:53002 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231649AbhIRKGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 06:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=CVFiO2eHG0Dnb1rH4/7ZVhi5oNdeIFRFpAIGDRI496s=; b=DskP0IHHyHiha8nYe
        WtBF8npC047UDgPTAlNncxxltkI/OWkeuX+wmLHLb1LhvwJzKSuOCNkgMONiku9MG1xflxzd8eB2q
        48XaI0fZymXKWkoD9kDo0k2lUZ0G0zg6bw77u3avSrX7PW0f3dRGWrEa3OeXAcylgANWL75ZnxofQ
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mRXDt-002PVX-B8; Sat, 18 Sep 2021 13:05:29 +0300
Subject: Re: [RFC net v7] net: skb_expand_head() adjust skb->truesize
 incorrectly
To:     Jakub Kicinski <kuba@kernel.org>, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org,
        Christoph Paasch <christoph.paasch@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>
References: <20210917162418.1437772-1-kuba@kernel.org>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <b38881fc-7dbf-8c5f-92b8-5fa1afaade0c@virtuozzo.com>
Date:   Sat, 18 Sep 2021 13:05:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210917162418.1437772-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/21 7:24 PM, Jakub Kicinski wrote:
> From: Vasily Averin <vvs@virtuozzo.com>
> 
> Christoph Paasch reports [1] about incorrect skb->truesize
> after skb_expand_head() call in ip6_xmit.
> This may happen because of two reasons:
>  - skb_set_owner_w() for newly cloned skb is called too early,
>    before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
>  - pskb_expand_head() does not adjust truesize in (skb->sk) case.
>    In this case sk->sk_wmem_alloc should be adjusted too.
> 
> Eric cautions us against increasing sk_wmem_alloc if the old
> skb did not hold any wmem references.
> 
> [1] https://lkml.org/lkml/2021/8/20/1082
> 
> Fixes: f1260ff15a71 ("skbuff: introduce skb_expand_head()")
> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
> Reported-by: Hao Sun <sunhao.th@gmail.com>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v7: - shift more magic into helpers
>     - follow Eric's advice and don't inherit non-wmem sks for now
> 
> Looks like we stalled here, let me try to push this forward.
> This builds, is it possible to repro without syzcaller?
> Anyone willing to test?
> ---
>  include/net/sock.h |  2 ++
>  net/core/skbuff.c  | 50 +++++++++++++++++++++++++++++++++++-----------
>  net/core/sock.c    | 10 ++++++++++
>  3 files changed, 50 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 66a9a90f9558..102e3e1009d1 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1707,6 +1707,8 @@ void sock_pfree(struct sk_buff *skb);
>  #define sock_edemux sock_efree
>  #endif
>  
> +bool is_skb_wmem(const struct sk_buff *skb);
> +
>  int sock_setsockopt(struct socket *sock, int level, int op,
>  		    sockptr_t optval, unsigned int optlen);
>  
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 7c2ab27fcbf9..5093321c2b65 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1786,6 +1786,24 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>  }
>  EXPORT_SYMBOL(skb_realloc_headroom);
>  
> +static void skb_owner_inherit(struct sk_buff *nskb, struct sk_buff *oskb)
> +{
> +	if (is_skb_wmem(oskb))
> +		skb_set_owner_w(nskb, oskb->sk);
> +
> +	/* handle rmem sock etc. as needed .. */
> +}
> +
> +static void skb_increase_truesize(struct sk_buff *skb, unsigned int add)
> +{
> +	if (is_skb_wmem(skb))
> +		refcount_add(add, &skb->sk->sk_wmem_alloc);
> +	/* handle rmem sock etc. as needed .. */
> +	WARN_ON(skb->destructor == sock_rfree);
> +
> +	skb->truesize += add;
> +}
> +
>  /**
>   *	skb_expand_head - reallocate header of &sk_buff
>   *	@skb: buffer to reallocate
> @@ -1801,6 +1819,7 @@ EXPORT_SYMBOL(skb_realloc_headroom);
>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>  {
>  	int delta = headroom - skb_headroom(skb);
> +	int osize = skb_end_offset(skb);
>  
>  	if (WARN_ONCE(delta <= 0,
>  		      "%s is expecting an increase in the headroom", __func__))
> @@ -1810,21 +1829,28 @@ struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>  	if (skb_shared(skb)) {
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
> +			goto err_free;
> +
> +		skb_owner_inherit(nskb, skb);
> +		consume_skb(skb);
>  		skb = nskb;
>  	}
> -	if (skb &&
> -	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
> -		kfree_skb(skb);
> -		skb = NULL;
> -	}
> +
> +	if (pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC))
> +		goto err_free;
> +	delta = skb_end_offset(skb) - osize;
> +
> +	/* pskb_expand_head() will adjust truesize itself for non-sk cases
> +	 * todo: move the adjustment there at some point?
> +	 */
> +	if (skb->sk && skb->destructor != sock_edemux)
> +		skb_increase_truesize(skb, delta);

I think it is wrong.
1) there are a few skb destructors called sock_wfree inside. I've found: 
   tpacket_destruct_skb, sctp_wfree, unix_destruct_scm and xsk_destruct_skb.
   If any such skb can be use here it will not adjust sk_wmem_alloc.   I afraid there might be other similar destructors, out of tree,
   so we cannot have full white list for wfree-compatible destructors.

2) in fact you increase truesize here for all skb types.
   If it is acceptable it could be done directly inside pskb_expand_head().
   However it isn't.  As you pointed sock_rfree case is handled incorrectly. 
   I've found other similar destructors: sock_rmem_free, netlink_skb_destructor,
   kcm_rfree, sock_ofree. They will be handled incorrectly too, but even without WARN_ON.
   Few other descriptors seems should not fail but do not require truesize update.

From my POV v6 patch version works correctly in any cases. If necessary it calls
original destructor, correctly set up new one and correctly adjust truesize
and sk_wmem_alloc.
If you still have doubts, we can just go back and clone non-wmem skb, 
like we did before.

Thank you,
	Vasily Averin

>  	return skb;
> +err_free:
> +	kfree_skb(skb);
> +	return NULL;
>  }
>  EXPORT_SYMBOL(skb_expand_head);
>  
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 62627e868e03..1483b4f755ef 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2227,6 +2227,16 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
>  }
>  EXPORT_SYMBOL(skb_set_owner_w);
>  
> +/* Should clones of this skb count towards skb->sk->sk_wmem_alloc
> + * and use sock_wfree() as their destructor?
> + */
> +bool is_skb_wmem(const struct sk_buff *skb)
> +{
> +	return skb->destructor == sock_wfree ||
> +		skb->destructor == __sock_wfree ||
> +		(IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree);
> +}
> +
>  static bool can_skb_orphan_partial(const struct sk_buff *skb)
>  {
>  #ifdef CONFIG_TLS_DEVICE
> 

