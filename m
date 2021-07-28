Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7673D8638
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 05:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbhG1Dri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 23:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233500AbhG1Drh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 23:47:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16CCB60F9B;
        Wed, 28 Jul 2021 03:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627444057;
        bh=4OcC31ijvQFCJDYltPlZwhp8vwmKYtXpweFEQIPqsRw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M1wliU3vNkORLmrti8+u3OFBvg+3EcwasLg1sjUy7y4GZYIlgJ705tPXiyGDxhD/j
         +UJginm8OAB8EevB+W3Ivggw5D1PzKIg0znOPHxpL6W2LKlhhDJ+ouQuYPKsYmj9Sw
         b5abboJKh3rB1N+HJsQitUYApuAGvj722sED3Ntip2TuBvdz9mlQGMXDOLdJXG9/LH
         JujcaRcHuFRCH4jta6B1EVeyzNhy8Tujo/qYkuknqsT/OP1qupm2FM+hYYrO5Ax0B1
         NgHhG+OzGvaU0KU9sjMfGU2rL9MttPoEG2eqK8d0WDwgK9XC6rw4xy0+ETGWxsAhiW
         k9LV+SUABg4pA==
Date:   Tue, 27 Jul 2021 22:50:06 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 05/64] skbuff: Switch structure bounds to struct_group()
Message-ID: <20210728035006.GD35706@embeddedor>
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-6-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727205855.411487-6-keescook@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 01:57:56PM -0700, Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memcpy(), memmove(), and memset(), avoid
> intentionally writing across neighboring fields.
> 
> Replace the existing empty member position markers "headers_start" and
> "headers_end" with a struct_group(). This will allow memcpy() and sizeof()
> to more easily reason about sizes, and improve readability.
> 
> "pahole" shows no size nor member offset changes to struct sk_buff.
> "objdump -d" shows no no meaningful object code changes (i.e. only source
> line number induced differences and optimizations.)
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>  drivers/net/wireguard/queueing.h |  4 +---
>  include/linux/skbuff.h           |  9 ++++-----
>  net/core/skbuff.c                | 14 +++++---------
>  3 files changed, 10 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
> index 4ef2944a68bc..52da5e963003 100644
> --- a/drivers/net/wireguard/queueing.h
> +++ b/drivers/net/wireguard/queueing.h
> @@ -79,9 +79,7 @@ static inline void wg_reset_packet(struct sk_buff *skb, bool encapsulating)
>  	u8 sw_hash = skb->sw_hash;
>  	u32 hash = skb->hash;
>  	skb_scrub_packet(skb, true);
> -	memset(&skb->headers_start, 0,
> -	       offsetof(struct sk_buff, headers_end) -
> -		       offsetof(struct sk_buff, headers_start));
> +	memset(&skb->headers, 0, sizeof(skb->headers));
>  	if (encapsulating) {
>  		skb->l4_hash = l4_hash;
>  		skb->sw_hash = sw_hash;
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index f19190820e63..b4032e9b130e 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -800,11 +800,10 @@ struct sk_buff {
>  	__u8			active_extensions;
>  #endif
>  
> -	/* fields enclosed in headers_start/headers_end are copied
> +	/* Fields enclosed in headers group are copied
>  	 * using a single memcpy() in __copy_skb_header()
>  	 */
> -	/* private: */
> -	__u32			headers_start[0];
> +	struct_group(headers,
>  	/* public: */
>  
>  /* if you move pkt_type around you also must adapt those constants */
> @@ -920,8 +919,8 @@ struct sk_buff {
>  	u64			kcov_handle;
>  #endif
>  
> -	/* private: */
> -	__u32			headers_end[0];
> +	); /* end headers group */
> +
>  	/* public: */
>  
>  	/* These elements must be at the end, see alloc_skb() for details.  */
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index fc7942c0dddc..5f29c65507e0 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -987,12 +987,10 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
>  }
>  EXPORT_SYMBOL(napi_consume_skb);
>  
> -/* Make sure a field is enclosed inside headers_start/headers_end section */
> +/* Make sure a field is contained by headers group */
>  #define CHECK_SKB_FIELD(field) \
> -	BUILD_BUG_ON(offsetof(struct sk_buff, field) <		\
> -		     offsetof(struct sk_buff, headers_start));	\
> -	BUILD_BUG_ON(offsetof(struct sk_buff, field) >		\
> -		     offsetof(struct sk_buff, headers_end));	\
> +	BUILD_BUG_ON(offsetof(struct sk_buff, field) !=		\
> +		     offsetof(struct sk_buff, headers.field));	\
>  
>  static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
>  {
> @@ -1004,14 +1002,12 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
>  	__skb_ext_copy(new, old);
>  	__nf_copy(new, old, false);
>  
> -	/* Note : this field could be in headers_start/headers_end section
> +	/* Note : this field could be in the headers group.
>  	 * It is not yet because we do not want to have a 16 bit hole
>  	 */
>  	new->queue_mapping = old->queue_mapping;
>  
> -	memcpy(&new->headers_start, &old->headers_start,
> -	       offsetof(struct sk_buff, headers_end) -
> -	       offsetof(struct sk_buff, headers_start));
> +	memcpy(&new->headers, &old->headers, sizeof(new->headers));
>  	CHECK_SKB_FIELD(protocol);
>  	CHECK_SKB_FIELD(csum);
>  	CHECK_SKB_FIELD(hash);
> -- 
> 2.30.2
> 
