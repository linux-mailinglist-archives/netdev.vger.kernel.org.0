Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FD53FB9A2
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 18:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237888AbhH3QB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 12:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237833AbhH3QB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 12:01:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC3AC061575;
        Mon, 30 Aug 2021 09:01:04 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id oa17so9823821pjb.1;
        Mon, 30 Aug 2021 09:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fk7/r4wiBFQn4VdUenLsdi7Ji84YzGRrFf1wzmjaAi8=;
        b=aBseQnMae5mHee4uH+72B54i7StOjj5fUyCXFy0cxHf/IqhZT1m7bsdcjetZKS5KM+
         W5mU1ZTbkSTRhFHfiKa4w2hRiNI6nkBPxwvnMTjHyzkv7G+pJPvtEqdaPFQ1hfmm04iQ
         iijWJZYd0vjVYsjy7Q2A9bk+8HV2OMp7Lxenuw4Kwxe1vG3CncQfyu48z082Q+vHaXLD
         jra6Fg5fgYB64cX84DV4GE5zfPwlm6q9iPPnwQMNzSwj5HchQ3KNvcC9c9vKqYp+D4Ez
         s+mfR96mtOZn2dMQUmxHY4Sfq4Xt4DcfrhVn7jQBmfaoZaMOBpGlrnOcVP1E7sJZ9chN
         P4jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fk7/r4wiBFQn4VdUenLsdi7Ji84YzGRrFf1wzmjaAi8=;
        b=SD0SDEMH9s7KmrqhfTmkYjqehhUMvxGFZtZbwxeYYkzXZqcf2nnIZs8eRkt7gq5xY+
         IBdivhAAmfU1V05bu9o3K1Xwa3jte8gyoy0LBEgAM+pUTikNnXNUF6L318grGdJ2YJkF
         S25TJFa9OsUzP8wPEl3aRHtpbhwtQ6/1Et4dtELznNn+6cKkTGZJfTog5CspCcdsmdI7
         EhNogOLEK5+tLG+Q7w1v7f4/uhyS+EsDjltvRAkLOXPjLUmrCrL3J9F51qQMgv43J4tl
         pLVbJjHZtDX50+moiXXUoU1ceyEQYeCjzE57FsqnhfSrbwuzJQ+p1Z8KOEgBkA3IxEO3
         XMTg==
X-Gm-Message-State: AOAM5327ocAeSBDg//gTjEMQu413u1gGvPM5fVxNeZwR4RLmBTz6NYcn
        5sai221aMrDEeppK4j+ejEM=
X-Google-Smtp-Source: ABdhPJzUZYGbQBQh0xlJfmCoBZK5gYWrJqYoI1syUuyy54FBztA/8jk16xOFSswZXTman0h7EswHng==
X-Received: by 2002:a17:902:cec1:b0:138:e176:9676 with SMTP id d1-20020a170902cec100b00138e1769676mr320049plg.65.1630339264325;
        Mon, 30 Aug 2021 09:01:04 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u21sm17896282pgk.57.2021.08.30.09.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Aug 2021 09:01:03 -0700 (PDT)
Subject: Re: [PATCH v2] skb_expand_head() adjust skb->truesize incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Julian Wiedmann <jwi@linux.ibm.com>
References: <CALMXkpZYGC5HNkJAi4wCuawC-9CVNjN1LqO073YJvUF5ONwupA@mail.gmail.com>
 <860513d5-fd02-832b-1c4c-ea2b17477d76@virtuozzo.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9f0c5e45-ad79-a9ea-dab1-aeb3bc3730ae@gmail.com>
Date:   Mon, 30 Aug 2021 09:01:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <860513d5-fd02-832b-1c4c-ea2b17477d76@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/29/21 5:59 AM, Vasily Averin wrote:
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

Unfortunately we can not always do this sk_wmem_alloc change here.

Some skb have skb->sk set, but the 'reference on socket' is not through sk_wmem_alloc

It seems you need a helper to make sure skb->destructor is one of
the destructors that use skb->truesize and sk->sk_wmem_alloc

For instance, skb_orphan_partial() could have been used.



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
