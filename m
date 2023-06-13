Return-Path: <netdev+bounces-10486-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1428B72EB53
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:57:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3766E1C20510
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 992BB22D4E;
	Tue, 13 Jun 2023 18:57:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3DC20F8;
	Tue, 13 Jun 2023 18:57:16 +0000 (UTC)
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF86B5;
	Tue, 13 Jun 2023 11:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686682634; x=1718218634;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rmFqequertUZdgeLdi6uxOH/VPKFko1mkleAU4INkB4=;
  b=ImZfKrpapebcSKwgTncgz8cb9H9lhRNpVAD7sudrzptKGGg+TbJ2YrTB
   /kn8/+GWZU7ynFex21WQgFV3pdqips6LQZj1A8uvGJJ15+MDRdauUYijM
   k4bWRlSf+lEXtlQwO2AbiVZ6A7YpHeYeCa1CtpfXY7ZGoH4apdW+1Z6Lv
   M=;
X-IronPort-AV: E=Sophos;i="6.00,240,1681171200"; 
   d="scan'208";a="653979675"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 18:57:07 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 90D09A3E3D;
	Tue, 13 Jun 2023 18:57:04 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 13 Jun 2023 18:57:01 +0000
Received: from 88665a182662.ant.amazon.com.com (10.95.246.146) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 13 Jun 2023 18:56:56 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <lmb@isovalent.com>
CC: <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
	<daniel@iogearbox.net>, <davem@davemloft.net>, <dsahern@kernel.org>,
	<edumazet@google.com>, <haoluo@google.com>, <hemanthmalla@gmail.com>,
	<joe@wand.net.nz>, <john.fastabend@gmail.com>, <jolsa@kernel.org>,
	<kpsingh@kernel.org>, <kuba@kernel.org>, <kuniyu@amazon.com>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<martin.lau@linux.dev>, <mykolal@fb.com>, <netdev@vger.kernel.org>,
	<pabeni@redhat.com>, <sdf@google.com>, <shuah@kernel.org>, <song@kernel.org>,
	<willemdebruijn.kernel@gmail.com>, <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2 3/6] net: remove duplicate reuseport_lookup functions
Date: Tue, 13 Jun 2023 11:56:47 -0700
Message-ID: <20230613185647.64531-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230613-so-reuseport-v2-3-b7c69a342613@isovalent.com>
References: <20230613-so-reuseport-v2-3-b7c69a342613@isovalent.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.246.146]
X-ClientProxiedBy: EX19D044UWA003.ant.amazon.com (10.13.139.43) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Lorenz Bauer <lmb@isovalent.com>
Date: Tue, 13 Jun 2023 11:14:58 +0100
> There are currently four copies of reuseport_lookup: one each for
> (TCP, UDP)x(IPv4, IPv6). This forces us to duplicate all callers of
> those functions as well. This is already the case for sk_lookup
> helpers (inet,inet6,udp4,udp6)_lookup_run_bpf.
> 
> The only difference between the reuseport_lookup helpers is calling
> a different hash function. Cut down the number of reuseport_lookup
> functions to one per IP version by using the INDIRECT_CALL
> infrastructure.
> 
> Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
> ---
>  include/net/inet6_hashtables.h | 11 ++++++++++-
>  include/net/inet_hashtables.h  | 15 +++++++++-----
>  net/ipv4/inet_hashtables.c     | 22 ++++++++++++++-------
>  net/ipv4/udp.c                 | 37 +++++++++++-----------------------
>  net/ipv6/inet6_hashtables.c    | 16 +++++++++++----
>  net/ipv6/udp.c                 | 45 +++++++++++++++---------------------------
>  6 files changed, 75 insertions(+), 71 deletions(-)
> 
> diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
> index 032ddab48f8f..49d586454287 100644
> --- a/include/net/inet6_hashtables.h
> +++ b/include/net/inet6_hashtables.h
> @@ -48,12 +48,21 @@ struct sock *__inet6_lookup_established(struct net *net,
>  					const u16 hnum, const int dif,
>  					const int sdif);
>  
> +typedef u32 (*inet6_ehashfn_t)(const struct net *net,
> +			       const struct in6_addr *laddr, const u16 lport,
> +			       const struct in6_addr *faddr, const __be16 fport);
> +
> +u32 inet6_ehashfn(const struct net *net,
> +		  const struct in6_addr *laddr, const u16 lport,
> +		  const struct in6_addr *faddr, const __be16 fport);
> +
>  struct sock *inet6_lookup_reuseport(struct net *net, struct sock *sk,
>  				    struct sk_buff *skb, int doff,
>  				    const struct in6_addr *saddr,
>  				    __be16 sport,
>  				    const struct in6_addr *daddr,
> -				    unsigned short hnum);
> +				    unsigned short hnum,
> +				    inet6_ehashfn_t ehashfn);
>  
>  struct sock *inet6_lookup_listener(struct net *net,
>  				   struct inet_hashinfo *hashinfo,
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index 8734f3488f5d..51ab6a1a3601 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -379,10 +379,19 @@ struct sock *__inet_lookup_established(struct net *net,
>  				       const __be32 daddr, const u16 hnum,
>  				       const int dif, const int sdif);
>  
> +typedef u32 (*inet_ehashfn_t)(const struct net *net,
> +			      const __be32 laddr, const __u16 lport,
> +			      const __be32 faddr, const __be16 fport);
> +
> +u32 inet_ehashfn(const struct net *net,
> +		 const __be32 laddr, const __u16 lport,
> +		 const __be32 faddr, const __be16 fport);
> +
>  struct sock *inet_lookup_reuseport(struct net *net, struct sock *sk,
>  				   struct sk_buff *skb, int doff,
>  				   __be32 saddr, __be16 sport,
> -				   __be32 daddr, unsigned short hnum);
> +				   __be32 daddr, unsigned short hnum,
> +				   inet_ehashfn_t ehashfn);
>  
>  static inline struct sock *
>  	inet_lookup_established(struct net *net, struct inet_hashinfo *hashinfo,
> @@ -453,10 +462,6 @@ static inline struct sock *__inet_lookup_skb(struct inet_hashinfo *hashinfo,
>  			     refcounted);
>  }
>  
> -u32 inet6_ehashfn(const struct net *net,
> -		  const struct in6_addr *laddr, const u16 lport,
> -		  const struct in6_addr *faddr, const __be16 fport);
> -
>  static inline void sk_daddr_set(struct sock *sk, __be32 addr)
>  {
>  	sk->sk_daddr = addr; /* alias of inet_daddr */
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index 91f9210d4e83..1ec895fd9905 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -28,9 +28,9 @@
>  #include <net/tcp.h>
>  #include <net/sock_reuseport.h>
>  
> -static u32 inet_ehashfn(const struct net *net, const __be32 laddr,
> -			const __u16 lport, const __be32 faddr,
> -			const __be16 fport)
> +u32 inet_ehashfn(const struct net *net, const __be32 laddr,
> +		 const __u16 lport, const __be32 faddr,
> +		 const __be16 fport)
>  {
>  	static u32 inet_ehash_secret __read_mostly;
>  
> @@ -332,6 +332,10 @@ static inline int compute_score(struct sock *sk, struct net *net,
>  	return score;
>  }
>  
> +INDIRECT_CALLABLE_DECLARE(u32 udp_ehashfn(const struct net *,
> +					  const __be32, const __u16,
> +					  const __be32, const __be16));
> +
>  /**
>   * inet_lookup_reuseport() - execute reuseport logic on AF_INET socket if necessary.
>   * @net: network namespace.
> @@ -342,6 +346,7 @@ static inline int compute_score(struct sock *sk, struct net *net,
>   * @sport: source port.
>   * @daddr: destination address.
>   * @hnum: destination port in host byte order.
> + * @ehashfn: hash function used to generate the fallback hash.
>   *
>   * Return: NULL if sk doesn't have SO_REUSEPORT set, otherwise a pointer to
>   *         the selected sock or an error.
> @@ -349,13 +354,15 @@ static inline int compute_score(struct sock *sk, struct net *net,
>  struct sock *inet_lookup_reuseport(struct net *net, struct sock *sk,
>  				   struct sk_buff *skb, int doff,
>  				   __be32 saddr, __be16 sport,
> -				   __be32 daddr, unsigned short hnum)
> +				   __be32 daddr, unsigned short hnum,
> +				   inet_ehashfn_t ehashfn)
>  {
>  	struct sock *reuse_sk = NULL;
>  	u32 phash;
>  
>  	if (sk->sk_reuseport) {
> -		phash = inet_ehashfn(net, daddr, hnum, saddr, sport);
> +		phash = INDIRECT_CALL_2(ehashfn, inet_ehashfn, udp_ehashfn,
> +					net, daddr, hnum, saddr, sport);
>  		reuse_sk = reuseport_select_sock(sk, phash, skb, doff);
>  	}
>  	return reuse_sk;
> @@ -385,7 +392,7 @@ static struct sock *inet_lhash2_lookup(struct net *net,
>  		score = compute_score(sk, net, hnum, daddr, dif, sdif);
>  		if (score > hiscore) {
>  			result = inet_lookup_reuseport(net, sk, skb, doff,
> -						       saddr, sport, daddr, hnum);
> +						       saddr, sport, daddr, hnum, inet_ehashfn);
>  			if (result)
>  				return result;
>  
> @@ -414,7 +421,8 @@ static inline struct sock *inet_lookup_run_bpf(struct net *net,
>  	if (no_reuseport || IS_ERR_OR_NULL(sk))
>  		return sk;
>  
> -	reuse_sk = inet_lookup_reuseport(net, sk, skb, doff, saddr, sport, daddr, hnum);
> +	reuse_sk = inet_lookup_reuseport(net, sk, skb, doff, saddr, sport, daddr, hnum,
> +					 inet_ehashfn);
>  	if (reuse_sk)
>  		sk = reuse_sk;
>  	return sk;
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index fd3dae081f3a..10468fe144d0 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -405,9 +405,9 @@ static int compute_score(struct sock *sk, struct net *net,
>  	return score;
>  }
>  
> -static u32 udp_ehashfn(const struct net *net, const __be32 laddr,
> -		       const __u16 lport, const __be32 faddr,
> -		       const __be16 fport)
> +INDIRECT_CALLABLE_SCOPE
> +u32 udp_ehashfn(const struct net *net, const __be32 laddr, const __u16 lport,
> +		const __be32 faddr, const __be16 fport)
>  {
>  	static u32 udp_ehash_secret __read_mostly;
>  
> @@ -417,22 +417,6 @@ static u32 udp_ehashfn(const struct net *net, const __be32 laddr,
>  			      udp_ehash_secret + net_hash_mix(net));
>  }
>  
> -static struct sock *lookup_reuseport(struct net *net, struct sock *sk,
> -				     struct sk_buff *skb,
> -				     __be32 saddr, __be16 sport,
> -				     __be32 daddr, unsigned short hnum)
> -{
> -	struct sock *reuse_sk = NULL;
> -	u32 hash;
> -
> -	if (sk->sk_reuseport && sk->sk_state != TCP_ESTABLISHED) {
> -		hash = udp_ehashfn(net, daddr, hnum, saddr, sport);
> -		reuse_sk = reuseport_select_sock(sk, hash, skb,
> -						 sizeof(struct udphdr));
> -	}
> -	return reuse_sk;
> -}
> -
>  /* called with rcu_read_lock() */
>  static struct sock *udp4_lib_lookup2(struct net *net,
>  				     __be32 saddr, __be16 sport,
> @@ -450,11 +434,13 @@ static struct sock *udp4_lib_lookup2(struct net *net,
>  		score = compute_score(sk, net, saddr, sport,
>  				      daddr, hnum, dif, sdif);
>  		if (score > badness) {
> -			result = lookup_reuseport(net, sk, skb,
> -						  saddr, sport, daddr, hnum);
> -			/* Fall back to scoring if group has connections */
> -			if (result && !reuseport_has_conns(sk))
> -				return result;
> +			if (sk->sk_state != TCP_ESTABLISHED) {
> +				result = inet_lookup_reuseport(net, sk, skb, sizeof(struct udphdr),
> +							       saddr, sport, daddr, hnum, udp_ehashfn);
> +				/* Fall back to scoring if group has connections */
> +				if (result && !reuseport_has_conns(sk))
> +					return result;

				result = result ? : sk;
> +			}

			else {
				result = sk;
			}

The assignment to result below is buggy.  Let's say SO_REUSEPROT group
have TCP_CLOSE and TCP_ESTABLISHED sockets.

  1. Find TCP_CLOSE sk and do SO_REUSEPORT lookup
  2. result is not NULL, but the group has TCP_ESTABLISHED sk
  3. result = result
  4. Find TCP_ESTABLISHED sk, which has a higher score
  5. result = result (TCP_CLOSE) <-- should be sk.

Same for v6 function.

>  
>  			result = result ? : sk;
>  			badness = score;
> @@ -480,7 +466,8 @@ static struct sock *udp4_lookup_run_bpf(struct net *net,
>  	if (no_reuseport || IS_ERR_OR_NULL(sk))
>  		return sk;
>  
> -	reuse_sk = lookup_reuseport(net, sk, skb, saddr, sport, daddr, hnum);
> +	reuse_sk = inet_lookup_reuseport(net, sk, skb, sizeof(struct udphdr),
> +					 saddr, sport, daddr, hnum, udp_ehashfn);
>  	if (reuse_sk)
>  		sk = reuse_sk;
>  	return sk;
> diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
> index 208998694ae3..a350ee40141c 100644
> --- a/net/ipv6/inet6_hashtables.c
> +++ b/net/ipv6/inet6_hashtables.c
> @@ -111,6 +111,10 @@ static inline int compute_score(struct sock *sk, struct net *net,
>  	return score;
>  }
>  
> +INDIRECT_CALLABLE_DECLARE(u32 udp6_ehashfn(const struct net *,
> +					   const struct in6_addr *, const u16,
> +					   const struct in6_addr *, const __be16));
> +
>  /**
>   * inet6_lookup_reuseport() - execute reuseport logic on AF_INET6 socket if necessary.
>   * @net: network namespace.
> @@ -121,6 +125,7 @@ static inline int compute_score(struct sock *sk, struct net *net,
>   * @sport: source port.
>   * @daddr: destination address.
>   * @hnum: destination port in host byte order.
> + * @ehashfn: hash function used to generate the fallback hash.
>   *
>   * Return: NULL if sk doesn't have SO_REUSEPORT set, otherwise a pointer to
>   *         the selected sock or an error.
> @@ -130,13 +135,15 @@ struct sock *inet6_lookup_reuseport(struct net *net, struct sock *sk,
>  				    const struct in6_addr *saddr,
>  				    __be16 sport,
>  				    const struct in6_addr *daddr,
> -				    unsigned short hnum)
> +				    unsigned short hnum,
> +				    inet6_ehashfn_t ehashfn)
>  {
>  	struct sock *reuse_sk = NULL;
>  	u32 phash;
>  
>  	if (sk->sk_reuseport) {
> -		phash = inet6_ehashfn(net, daddr, hnum, saddr, sport);
> +		phash = INDIRECT_CALL_2(ehashfn, inet6_ehashfn, udp6_ehashfn,
> +					net, daddr, hnum, saddr, sport);
>  		reuse_sk = reuseport_select_sock(sk, phash, skb, doff);
>  	}
>  	return reuse_sk;
> @@ -159,7 +166,7 @@ static struct sock *inet6_lhash2_lookup(struct net *net,
>  		score = compute_score(sk, net, hnum, daddr, dif, sdif);
>  		if (score > hiscore) {
>  			result = inet6_lookup_reuseport(net, sk, skb, doff,
> -							saddr, sport, daddr, hnum);
> +							saddr, sport, daddr, hnum, inet6_ehashfn);
>  			if (result)
>  				return result;
>  
> @@ -190,7 +197,8 @@ static inline struct sock *inet6_lookup_run_bpf(struct net *net,
>  	if (no_reuseport || IS_ERR_OR_NULL(sk))
>  		return sk;
>  
> -	reuse_sk = inet6_lookup_reuseport(net, sk, skb, doff, saddr, sport, daddr, hnum);
> +	reuse_sk = inet6_lookup_reuseport(net, sk, skb, doff,
> +					  saddr, sport, daddr, hnum, inet6_ehashfn);
>  	if (reuse_sk)
>  		sk = reuse_sk;
>  	return sk;
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index e5a337e6b970..2af3a595f38a 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -70,11 +70,12 @@ int udpv6_init_sock(struct sock *sk)
>  	return 0;
>  }
>  
> -static u32 udp6_ehashfn(const struct net *net,
> -			const struct in6_addr *laddr,
> -			const u16 lport,
> -			const struct in6_addr *faddr,
> -			const __be16 fport)
> +INDIRECT_CALLABLE_SCOPE
> +u32 udp6_ehashfn(const struct net *net,
> +		 const struct in6_addr *laddr,
> +		 const u16 lport,
> +		 const struct in6_addr *faddr,
> +		 const __be16 fport)
>  {
>  	static u32 udp6_ehash_secret __read_mostly;
>  	static u32 udp_ipv6_hash_secret __read_mostly;
> @@ -159,24 +160,6 @@ static int compute_score(struct sock *sk, struct net *net,
>  	return score;
>  }
>  
> -static struct sock *lookup_reuseport(struct net *net, struct sock *sk,
> -				     struct sk_buff *skb,
> -				     const struct in6_addr *saddr,
> -				     __be16 sport,
> -				     const struct in6_addr *daddr,
> -				     unsigned int hnum)
> -{
> -	struct sock *reuse_sk = NULL;
> -	u32 hash;
> -
> -	if (sk->sk_reuseport && sk->sk_state != TCP_ESTABLISHED) {
> -		hash = udp6_ehashfn(net, daddr, hnum, saddr, sport);
> -		reuse_sk = reuseport_select_sock(sk, hash, skb,
> -						 sizeof(struct udphdr));
> -	}
> -	return reuse_sk;
> -}
> -
>  /* called with rcu_read_lock() */
>  static struct sock *udp6_lib_lookup2(struct net *net,
>  		const struct in6_addr *saddr, __be16 sport,
> @@ -193,11 +176,14 @@ static struct sock *udp6_lib_lookup2(struct net *net,
>  		score = compute_score(sk, net, saddr, sport,
>  				      daddr, hnum, dif, sdif);
>  		if (score > badness) {
> -			result = lookup_reuseport(net, sk, skb,
> -						  saddr, sport, daddr, hnum);
> -			/* Fall back to scoring if group has connections */
> -			if (result && !reuseport_has_conns(sk))
> -				return result;
> +			if (sk->sk_state != TCP_ESTABLISHED) {
> +				result = inet6_lookup_reuseport(net, sk, skb, sizeof(struct udphdr),
> +								saddr, sport, daddr, hnum,
> +								udp6_ehashfn);
> +				/* Fall back to scoring if group has connections */
> +				if (result && !reuseport_has_conns(sk))
> +					return result;
> +			}
>  
>  			result = result ? : sk;
>  			badness = score;
> @@ -225,7 +211,8 @@ static inline struct sock *udp6_lookup_run_bpf(struct net *net,
>  	if (no_reuseport || IS_ERR_OR_NULL(sk))
>  		return sk;
>  
> -	reuse_sk = lookup_reuseport(net, sk, skb, saddr, sport, daddr, hnum);
> +	reuse_sk = inet6_lookup_reuseport(net, sk, skb, sizeof(struct udphdr),
> +					  saddr, sport, daddr, hnum, udp6_ehashfn);
>  	if (reuse_sk)
>  		sk = reuse_sk;
>  	return sk;
> 
> -- 
> 2.40.1

