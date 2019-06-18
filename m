Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD01497F1
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 06:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfFREOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 00:14:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfFREOL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 00:14:11 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29A7C2085A;
        Tue, 18 Jun 2019 04:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560831250;
        bh=nlZXgfeO6Lsh2kyizJV7f0jo6QHVyCgeaN7az9UUvCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kY7iHu16DRL/De7QSnn93HiZnBvHZ7nuR0sz2+igmPIjXrbIHvQb/A99QarMRMITN
         PzUN7LxK/YihJm+Lpj2ontkYOyOMlAaoYY2NRZZA8S3h1YTlKBM8CcV780UdPlqG5S
         Xyk4/xFcbJBcBbvDmveLcChxf6NZmuFQH1iAOta4=
Date:   Mon, 17 Jun 2019 21:14:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, edumazet@google.com,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jbaron@akamai.com, cpaasch@apple.com, David.Laight@aculab.com,
        ycheng@google.com
Subject: Re: [PATCH v3] net: ipv4: move tcp_fastopen server side code to
 SipHash library
Message-ID: <20190618041408.GB2266@sol.localdomain>
References: <20190617080933.32152-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617080933.32152-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 10:09:33AM +0200, Ard Biesheuvel wrote:
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index c23019a3b264..9ea0e71f5c6a 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -58,12 +58,7 @@ static inline unsigned int tcp_optlen(const struct sk_buff *skb)
>  
>  /* TCP Fast Open Cookie as stored in memory */
>  struct tcp_fastopen_cookie {
> -	union {
> -		u8	val[TCP_FASTOPEN_COOKIE_MAX];
> -#if IS_ENABLED(CONFIG_IPV6)
> -		struct in6_addr addr;
> -#endif
> -	};
> +	u64	val[TCP_FASTOPEN_COOKIE_MAX / sizeof(u64)];
>  	s8	len;
>  	bool	exp;	/* In RFC6994 experimental option format */
>  };

Is it okay that the cookies will depend on CPU endianness?

> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 96e0e53ff440..184930b02779 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1628,9 +1628,9 @@ bool tcp_fastopen_defer_connect(struct sock *sk, int *err);
>  
>  /* Fastopen key context */
>  struct tcp_fastopen_context {
> -	struct crypto_cipher	*tfm[TCP_FASTOPEN_KEY_MAX];
> -	__u8			key[TCP_FASTOPEN_KEY_BUF_LENGTH];
> -	struct rcu_head		rcu;
> +	__u8		key[TCP_FASTOPEN_KEY_MAX][TCP_FASTOPEN_KEY_LENGTH];
> +	int		num;
> +	struct rcu_head	rcu;
>  };

Why not use 'siphash_key_t' here?  Then the (potentially alignment-violating)
cast in __tcp_fastopen_cookie_gen_cipher() wouldn't be needed.

>  int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
>  			      void *primary_key, void *backup_key,
>  			      unsigned int len)
> @@ -115,11 +75,20 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
>  	struct fastopen_queue *q;
>  	int err = 0;
>  
> -	ctx = tcp_fastopen_alloc_ctx(primary_key, backup_key, len);
> -	if (IS_ERR(ctx)) {
> -		err = PTR_ERR(ctx);
> +	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx) {
> +		err = -ENOMEM;
>  		goto out;
>  	}
> +
> +	memcpy(ctx->key[0], primary_key, len);
> +	if (backup_key) {
> +		memcpy(ctx->key[1], backup_key, len);
> +		ctx->num = 2;
> +	} else {
> +		ctx->num = 1;
> +	}
> +
>  	spin_lock(&net->ipv4.tcp_fastopen_ctx_lock);
>  	if (sk) {
>  		q = &inet_csk(sk)->icsk_accept_queue.fastopenq;

Shouldn't there be a check that 'len == TCP_FASTOPEN_KEY_LENGTH'?  I see that
all callers pass that, but it seems unnecessarily fragile for this to accept
short lengths and leave uninitialized memory in that case.

- Eric
