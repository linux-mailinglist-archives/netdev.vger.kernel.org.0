Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43DC3FB0ED
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 07:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhH3Fxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 01:53:54 -0400
Received: from relay.sw.ru ([185.231.240.75]:48032 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231741AbhH3Fxw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 01:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=CZGtUolhje7Vsk3gbqjS0thLrINH1hLljA/H/12io0E=; b=H9wsO24Iz+sDH3ehq
        0dj5woeHzyyWljn/zso5+TQ9UVplmy/Bi+okE788RCXG9cvxSog+zYK2vS92Fb9vkpv9Mf/VP9LEs
        ZI2yN8jm66AhnqgOgLtoTJFmLuG+D70K9EeZcKdtqEE/tvuYlxh3DkDUNQa7V5saqrnidkr0p0ZTM
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mKaDx-000AK5-RU; Mon, 30 Aug 2021 08:52:49 +0300
Subject: Re: [PATCH net-next v2] skb_expand_head() adjust skb->truesize
 incorrectly
From:   Vasily Averin <vvs@virtuozzo.com>
To:     Christoph Paasch <christoph.paasch@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
References: <CALMXkpZYGC5HNkJAi4wCuawC-9CVNjN1LqO073YJvUF5ONwupA@mail.gmail.com>
 <860513d5-fd02-832b-1c4c-ea2b17477d76@virtuozzo.com>
Message-ID: <835071d6-88e8-902e-4997-042bf4b84b6f@virtuozzo.com>
Date:   Mon, 30 Aug 2021 08:52:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <860513d5-fd02-832b-1c4c-ea2b17477d76@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) I forgot to specify that the patch is intended fro net-next git
2) I forgot to ad Alexey Kuznetsov in cc. I resend the patch to him 
  in a separate letter and received his consent.
3) I forgot to set Fixed mark
Fixes: f1260ff15a71 ("skbuff: introduce skb_expand_head()")

Thank you,
	Vasily Averin

On 8/29/21 3:59 PM, Vasily Averin wrote:
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
> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
> ---
> v2: based on patch version from Eric Dumazet,
>     added __pskb_expand_head() function, which can be forced
>     to adjust skb->truesize and sk->sk_wmem_alloc.
> ---
>  net/core/skbuff.c | 43 +++++++++++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 14 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f931176..4691023 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1681,10 +1681,10 @@ struct sk_buff *__pskb_copy_fclone(struct sk_buff *skb, int headroom,
>   *	reloaded after call to this function.
>   */
>  
> -int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
> -		     gfp_t gfp_mask)
> +static int __pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
> +			      gfp_t gfp_mask, bool update_truesize)
>  {
> -	int i, osize = skb_end_offset(skb);
> +	int delta, i, osize = skb_end_offset(skb);
>  	int size = osize + nhead + ntail;
>  	long off;
>  	u8 *data;
> @@ -1756,9 +1756,13 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
>  	 * For the moment, we really care of rx path, or
>  	 * when skb is orphaned (not attached to a socket).
>  	 */
> -	if (!skb->sk || skb->destructor == sock_edemux)
> -		skb->truesize += size - osize;
> -
> +	delta = size - osize;
> +	if (!skb->sk || skb->destructor == sock_edemux) {
> +		skb->truesize += delta;
> +	} else if (update_truesize) {
> +		refcount_add(delta, &skb->sk->sk_wmem_alloc);
> +		skb->truesize += delta;
> +	}
>  	return 0;
>  
>  nofrags:
> @@ -1766,6 +1770,12 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
>  nodata:
>  	return -ENOMEM;
>  }
> +
> +int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
> +		     gfp_t gfp_mask)
> +{
> +	return __pskb_expand_head(skb, nhead, ntail, gfp_mask, false);
> +}
>  EXPORT_SYMBOL(pskb_expand_head);
>  
>  /* Make private copy of skb with writable head and some headroom */
> @@ -1804,28 +1814,33 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>  {
>  	int delta = headroom - skb_headroom(skb);
> +	struct sk_buff *oskb = NULL;
>  
>  	if (WARN_ONCE(delta <= 0,
>  		      "%s is expecting an increase in the headroom", __func__))
>  		return skb;
>  
> +	delta = SKB_DATA_ALIGN(delta);
>  	/* pskb_expand_head() might crash, if skb is shared */
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
> +	if (__pskb_expand_head(skb, delta, 0, GFP_ATOMIC, true)) {
>  		kfree_skb(skb);
> -		skb = NULL;
> +		kfree_skb(oskb);
> +		return NULL;
> +	}
> +	if (oskb) {
> +		if (oskb->sk)
> +			skb_set_owner_w(skb, oskb->sk);
> +		consume_skb(oskb);
>  	}
>  	return skb;
>  }
> 

