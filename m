Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2B6421768
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238689AbhJDT14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235352AbhJDT1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 15:27:55 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10585C061745;
        Mon,  4 Oct 2021 12:26:06 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id m26so2145191pff.3;
        Mon, 04 Oct 2021 12:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2M6Uj+vSWviCNpc5R7qSdx8RTi709MJ8XezkLpEqkPc=;
        b=fg3Lzd3OJLGpZi2AVqAGPT+WOfNMsNJFqGYvSMREOt092H37dUq6HpkO1ntZ8ejbMv
         SDlbBfvGPAzrefEbfHUpB32ZE8frB0Z9LqTsJUplCAli1THZtQBSQdaT5xFfmyqorxtw
         Gx37jymCMQ+IWgAtW4vOvffkf/8j1qUomj3onXcYuNzW1Jua6sL7AQmuMARYS1Tykp73
         yMecNLv5lVfksItEPFky1Bl72t3NLk8dLyepMIf6U0h5+ue5R+2FD/sSNwcQCA0adljF
         1RU0QWnws70AAfSq0c1/rPfisP9m/IGJtMVmDUpfDc88V6vCtk9v9jluR5Bnia2UKfpt
         7xlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2M6Uj+vSWviCNpc5R7qSdx8RTi709MJ8XezkLpEqkPc=;
        b=vasEch4S/pACuJY1DhW2BoLuYcOFtUVjCTsFBlcIvtEnCNSSulMPp2DJO9ifAmEimz
         cvgb6B5LpYst+zj+FyV7im56VGES4MwL5MC7SCs9/I17rjCSjv/kOabEWukPUpaWAbgQ
         2Ms+Y6zJokh4Fh4sM+jlrTEzBlk4v4fvJpJT17xPY0EBfVXWMNgD1+Y7d1V3jiLudsnf
         /6qwI4d0GgR6B2LkrpaIVI3JCJLOzuIDEOzPkpR1XWfYZk2n76xj0AkvWWwZwQ669kAX
         DG6E+854txDZtpf7j/H0+0XY0NdeH2mkNhfgofEePENnSRi3dcyt7AdzPmkRClPVMWx+
         fqVw==
X-Gm-Message-State: AOAM532pnERmHYpF4lB0u+8Bi7McE5BbYMmnNkyWbOobZQ/u8IpUgJ3a
        V99eWTo5Laut8OJxg3jH2Fs=
X-Google-Smtp-Source: ABdhPJwSmZ7BHTPfy7rAgMahU7Bh+hXN9lhFN4LOuP8eId6C6142gwzC+avGE1mDhh0AbxFxlSwJWQ==
X-Received: by 2002:a63:534f:: with SMTP id t15mr12444966pgl.392.1633375565600;
        Mon, 04 Oct 2021 12:26:05 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id z22sm14418840pgn.81.2021.10.04.12.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 12:26:04 -0700 (PDT)
Subject: Re: [PATCH net v9] skb_expand_head() adjust skb->truesize incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
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
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a1b83e46-27d6-d8f0-2327-bb3466e2de13@gmail.com>
Date:   Mon, 4 Oct 2021 12:26:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <2bd9c638-3038-5aba-1dae-ad939e13c0c4@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/21 6:00 AM, Vasily Averin wrote:
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

    Why not re-using is_skb_wmem() here ?
    Testing != sock_edemux looks strange.
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

This probably should be inlined.

>  static bool can_skb_orphan_partial(const struct sk_buff *skb)
>  {
>  #ifdef CONFIG_TLS_DEVICE
> 
