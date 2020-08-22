Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEE624E92A
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 19:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbgHVRzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 13:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgHVRzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 13:55:00 -0400
Received: from smtp.tuxdriver.com (tunnel92311-pt.tunnel.tserv13.ash1.ipv6.he.net [IPv6:2001:470:7:9c9::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E301EC061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 10:54:59 -0700 (PDT)
Received: from [2605:a601:a627:ca00:664d:4b4b:674f:5257] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1k9Xio-0007Ur-EE; Sat, 22 Aug 2020 13:54:32 -0400
Date:   Sat, 22 Aug 2020 13:54:19 -0400
From:   Neil Horman <nhorman@localhost.localdomain>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] net: Get rid of consume_skb when tracing is off
Message-ID: <20200822175419.GA293438@localhost.localdomain>
References: <20200821222329.GA2633@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821222329.GA2633@gondor.apana.org.au>
X-Spam-Score: -1.8 (-)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 22, 2020 at 08:23:29AM +1000, Herbert Xu wrote:
> The function consume_skb is only meaningful when tracing is enabled.
> This patch makes it conditional on CONFIG_TRACEPOINTS.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 46881d902124..e8bca74857a3 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1056,7 +1056,16 @@ void kfree_skb(struct sk_buff *skb);
>  void kfree_skb_list(struct sk_buff *segs);
>  void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
>  void skb_tx_error(struct sk_buff *skb);
> +
> +#ifdef CONFIG_TRACEPOINTS
>  void consume_skb(struct sk_buff *skb);
> +#else
> +static inline void consume_skb(struct sk_buff *skb)
> +{
> +	return kfree_skb(skb);
> +}
> +#endif
> +
Wouldn't it be better to make this:
#define consume_skb(x) kfree_skb(x)
?
Best
Neil

>  void __consume_stateless_skb(struct sk_buff *skb);
>  void  __kfree_skb(struct sk_buff *skb);
>  extern struct kmem_cache *skbuff_head_cache;
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 7e2e502ef519..593fe73d4993 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -820,6 +820,7 @@ void skb_tx_error(struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL(skb_tx_error);
>  
> +#ifdef CONFIG_TRACEPOINTS
>  /**
>   *	consume_skb - free an skbuff
>   *	@skb: buffer to free
> @@ -837,6 +838,7 @@ void consume_skb(struct sk_buff *skb)
>  	__kfree_skb(skb);
>  }
>  EXPORT_SYMBOL(consume_skb);
> +#endif
>  
>  /**
>   *	consume_stateless_skb - free an skbuff, assuming it is stateless
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
