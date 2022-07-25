Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89F35803FB
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 20:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbiGYS1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 14:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiGYS1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 14:27:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB81417050
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 11:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57ED1610A1
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 18:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C874C341C6;
        Mon, 25 Jul 2022 18:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658773637;
        bh=oZIdBBT3aQQABcZYcWHR1jF5yKY7udljfG2Zi/JtLOY=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=qWLft+natnSxarO8po1X/HzXPSO0A6YcZ8bzdWsOpiqKdBKhcOQmXd7bMGJ14MpyJ
         E0aaixa+dH7o5JjyO4y0+vGnveR/5Vh9CQjGelkyOtPxTaR2R39rvXaICzEFOqUP/Q
         oadA94DWVNVUMgAyHP5fUcGy8cCefIW0v3cujm6RZZfFTHMfxFnGx5kfwoX4Wj6hnx
         Z8AOrmbgVL9SbjNctfGhMC2dq+hHyixJ99hVdlXDCpw/8gyv7Ar3W04ZAmuNaz2pqJ
         pj2negTWW4TYIXsteV+OlE/mD4DaxalgNGuWoh/iAJjBxJmUb5sKqxsmAPcvlzXNLs
         wCzszTkbG/ndw==
Message-ID: <33db44a5-cbbb-0a3f-3487-9ceef35fd57e@kernel.org>
Date:   Mon, 25 Jul 2022 12:27:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] net: allow unbound socket for packets in VRF when
 tcp_l3mdev_accept set
Content-Language: en-US
To:     Mike Manning <mvrmanning@gmail.com>, netdev@vger.kernel.org,
        jluebbe@lasnet.de, Andy Roulin <aroulin@nvidia.com>
References: <20220725181442.18041-1-mvrmanning@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220725181442.18041-1-mvrmanning@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ cc Andy who reported a similar issue ]

On 7/25/22 12:14 PM, Mike Manning wrote:
> The commit 3c82a21f4320 ("net: allow binding socket in a VRF when
> there's an unbound socket") changed the inet socket lookup to avoid
> packets in a VRF from matching an unbound socket. This is to ensure the
> necessary isolation between the default and other VRFs for routing and
> forwarding. VRF-unaware processes running in the default VRF cannot
> access another VRF and have to be run with 'ip vrf exec <vrf>'. This is
> to be expected with tcp_l3mdev_accept disabled, but could be reallowed
> when this sysctl option is enabled. So instead of directly checking dif
> and sdif in inet[6]_match, here call inet_sk_bound_dev_eq(). This
> allows a match on unbound socket for non-zero sdif i.e. for packets in
> a VRF, if tcp_l3mdev_accept is enabled.
> 
> Fixes: 3c82a21f4320 ("net: allow binding socket in a VRF when there's an unbound socket")
> Signed-off-by: Mike Manning <mvrmanning@gmail.com>
> Link: https://lore.kernel.org/netdev/a54c149aed38fded2d3b5fdb1a6c89e36a083b74.camel@lasnet.de/
> ---
> 
> Nettest results for VRF testing remain unchanged:
> 
> $ diff nettest-baseline-502c6f8cedcc.txt nettest-fix.txt
> $ tail -3 nettest-fix.txt
> Tests passed: 869
> Tests failed:   5
> 
> Disclaimer: While I do not think that there should be any noticeable
> socket throughput degradation due to these changes, I am unable to
> carry out any performance tests for this, nor provide any follow-up
> support if there is any such degradation.
> 
> ---
>  include/net/inet6_hashtables.h |  7 +++----
>  include/net/inet_hashtables.h  | 19 +++----------------
>  include/net/inet_sock.h        | 11 +++++++++++
>  3 files changed, 17 insertions(+), 20 deletions(-)
> 
> diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
> index f259e1ae14ba..56f1286583d3 100644
> --- a/include/net/inet6_hashtables.h
> +++ b/include/net/inet6_hashtables.h
> @@ -110,8 +110,6 @@ static inline bool inet6_match(struct net *net, const struct sock *sk,
>  			       const __portpair ports,
>  			       const int dif, const int sdif)
>  {
> -	int bound_dev_if;
> -
>  	if (!net_eq(sock_net(sk), net) ||
>  	    sk->sk_family != AF_INET6 ||
>  	    sk->sk_portpair != ports ||
> @@ -119,8 +117,9 @@ static inline bool inet6_match(struct net *net, const struct sock *sk,
>  	    !ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
>  		return false;
>  
> -	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
> -	return bound_dev_if == dif || bound_dev_if == sdif;
> +	/* READ_ONCE() paired with WRITE_ONCE() in sock_bindtoindex_locked() */
> +	return inet_sk_bound_dev_eq(net, READ_ONCE(sk->sk_bound_dev_if), dif,
> +				    sdif);
>  }
>  #endif /* IS_ENABLED(CONFIG_IPV6) */
>  
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index fd6b510d114b..e9cf2157ed8a 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -175,17 +175,6 @@ static inline void inet_ehash_locks_free(struct inet_hashinfo *hashinfo)
>  	hashinfo->ehash_locks = NULL;
>  }
>  
> -static inline bool inet_sk_bound_dev_eq(struct net *net, int bound_dev_if,
> -					int dif, int sdif)
> -{
> -#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
> -	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept),
> -				 bound_dev_if, dif, sdif);
> -#else
> -	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
> -#endif
> -}
> -
>  struct inet_bind_bucket *
>  inet_bind_bucket_create(struct kmem_cache *cachep, struct net *net,
>  			struct inet_bind_hashbucket *head,
> @@ -271,16 +260,14 @@ static inline bool inet_match(struct net *net, const struct sock *sk,
>  			      const __addrpair cookie, const __portpair ports,
>  			      int dif, int sdif)
>  {
> -	int bound_dev_if;
> -
>  	if (!net_eq(sock_net(sk), net) ||
>  	    sk->sk_portpair != ports ||
>  	    sk->sk_addrpair != cookie)
>  	        return false;
>  
> -	/* Paired with WRITE_ONCE() from sock_bindtoindex_locked() */
> -	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
> -	return bound_dev_if == dif || bound_dev_if == sdif;
> +	/* READ_ONCE() paired with WRITE_ONCE() in sock_bindtoindex_locked() */
> +	return inet_sk_bound_dev_eq(net, READ_ONCE(sk->sk_bound_dev_if), dif,
> +				    sdif);
>  }
>  
>  /* Sockets in TCP_CLOSE state are _always_ taken out of the hash, so we need
> diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
> index 6395f6b9a5d2..bf5654ce711e 100644
> --- a/include/net/inet_sock.h
> +++ b/include/net/inet_sock.h
> @@ -149,6 +149,17 @@ static inline bool inet_bound_dev_eq(bool l3mdev_accept, int bound_dev_if,
>  	return bound_dev_if == dif || bound_dev_if == sdif;
>  }
>  
> +static inline bool inet_sk_bound_dev_eq(struct net *net, int bound_dev_if,
> +					int dif, int sdif)
> +{
> +#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
> +	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept),
> +				 bound_dev_if, dif, sdif);
> +#else
> +	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
> +#endif
> +}
> +
>  struct inet_cork {
>  	unsigned int		flags;
>  	__be32			addr;

