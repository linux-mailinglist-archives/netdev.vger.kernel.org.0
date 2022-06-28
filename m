Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E757A55D7E9
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344912AbiF1Kch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344906AbiF1Kcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:32:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88C9E31DF3
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 03:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656412352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yj+l1CyJfxncM7clg/Kkt3LuEPPgYbqptfguPgxMX68=;
        b=bP0Px6kjZC+lrVMy+PzjVAR5G/JTvvTlVxYfsQDFRBrwCNu2A+gwBZELnQKtkvd9bKidub
        79QBG70ZAkNYELSyLlpXMC12sx3qeZlrtfy1q86FpIFJ3AvC97UuJ7eo55v7HY1wBL7nk8
        iJuP32FBypz0rINtE15ZJ/hbse3mlnk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-UwjH3nQ5Myubc5iTDXuV-A-1; Tue, 28 Jun 2022 06:32:28 -0400
X-MC-Unique: UwjH3nQ5Myubc5iTDXuV-A-1
Received: by mail-wm1-f70.google.com with SMTP id v125-20020a1cac83000000b0039c832fbd02so8676441wme.4
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 03:32:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Yj+l1CyJfxncM7clg/Kkt3LuEPPgYbqptfguPgxMX68=;
        b=yKRkz4M7eQBBDWilvK4BZbDhI5UD9d3kgiD/etfAqX98lNWwWCSRCZa/zHg5FSr/WC
         EK+ADDYTIJHey+nAyTgLZRmdeeW12MRECZZHuoGZ5WKqCxoIiSEUODOuI5kpL+5omw7r
         7GEyOCe0p6q4U/KlfK3Bgud1cUd+qDr9T7U73jY8tttWam7iko1unjy9zvW+lArHsVUF
         AkmKaA/jfCvmleVZ9QBfGC82m+bZKqK0Vo3uauCgzVBfC4PZFhJhJZcIqaNAc+HEoIsT
         QKiy89Nixl+xQXx3b5XzB4XejMm8OCzDjD7zpOt8mi6U1OTsfXY4z6R54Rlwdw+NvTD7
         2f/Q==
X-Gm-Message-State: AJIora/DnDEHPwu5xu7jOY0vQPX9Y7BxpA0vL778rckB+g2cc6DfivrT
        fdcPqPuFZgyAUZaoyQhhfr7+olCCHfu+fNUY1cSt9G+3CNFKPlYxXo81ydWYITjlJcwYrNOcDvI
        zQ1QCCcqaw88yHLEr
X-Received: by 2002:adf:ec02:0:b0:21b:931c:cf78 with SMTP id x2-20020adfec02000000b0021b931ccf78mr15917083wrn.188.1656412347105;
        Tue, 28 Jun 2022 03:32:27 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u0q1zb0XasHjDtUprY2RAdw0iCF9RJhMbAINWdPhvShq9yzBOuLGgClA5Y3lbBxmSbWrOqTQ==
X-Received: by 2002:adf:ec02:0:b0:21b:931c:cf78 with SMTP id x2-20020adfec02000000b0021b931ccf78mr15917036wrn.188.1656412346593;
        Tue, 28 Jun 2022 03:32:26 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-110.dyn.eolo.it. [146.241.115.110])
        by smtp.gmail.com with ESMTPSA id g13-20020adffc8d000000b0021b99efceb6sm13286202wrr.22.2022.06.28.03.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 03:32:26 -0700 (PDT)
Message-ID: <c075e7c4dcd787cca604f1cb1ddd9c6fc077a3c4.camel@redhat.com>
Subject: Re: [PATCH net-next v1 1/3] net: Add a bhash2 table hashed by port
 + address
From:   Paolo Abeni <pabeni@redhat.com>
To:     Joanne Koong <joannelkoong@gmail.com>, netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net
Date:   Tue, 28 Jun 2022 12:32:25 +0200
In-Reply-To: <20220623234242.2083895-2-joannelkoong@gmail.com>
References: <20220623234242.2083895-1-joannelkoong@gmail.com>
         <20220623234242.2083895-2-joannelkoong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-06-23 at 16:42 -0700, Joanne Koong wrote:
> The current bind hashtable (bhash) is hashed by port only.
> In the socket bind path, we have to check for bind conflicts by
> traversing the specified port's inet_bind_bucket while holding the
> hashbucket's spinlock (see inet_csk_get_port() and
> inet_csk_bind_conflict()). In instances where there are tons of
> sockets hashed to the same port at different addresses, the bind
> conflict check is time-intensive and can cause softirq cpu lockups,
> as well as stops new tcp connections since __inet_inherit_port()
> also contests for the spinlock.
> 
> This patch adds a second bind table, bhash2, that hashes by
> port and sk->sk_rcv_saddr (ipv4) and sk->sk_v6_rcv_saddr (ipv6).
> Searching the bhash2 table leads to significantly faster conflict
> resolution and less time holding the hashbucket spinlock.
> 
> Please note a few things:
> * There can be the case where the a socket's address changes after it
> has been bound. There are two cases where this happens:
> 
>   1) The case where there is a bind() call on INADDR_ANY (ipv4) or
>   IPV6_ADDR_ANY (ipv6) and then a connect() call. The kernel will
>   assign the socket an address when it handles the connect()
> 
>   2) In inet_sk_reselect_saddr(), which is called when rebuilding the
>   sk header and a few pre-conditions are met (eg rerouting fails).
> 
> In these two cases, we need to update the bhash2 table by removing the
> entry for the old address, and add a new entry reflecting the updated
> address.
> 
> * The bhash2 table must have its own lock, even though concurrent
> accesses on the same port are protected by the bhash lock. Bhash2 must
> have its own lock to protect against cases where sockets on different
> ports hash to different bhash hashbuckets but to the same bhash2
> hashbucket.
> 
> This brings up a few stipulations:
>   1) When acquiring both the bhash and the bhash2 lock, the bhash2 lock
>   will always be acquired after the bhash lock and released before the
>   bhash lock is released.
> 
>   2) There are no nested bhash2 hashbucket locks. A bhash2 lock is always
>   acquired+released before another bhash2 lock is acquired+released.
> 
> * The bhash table cannot be superseded by the bhash2 table because for
> bind requests on INADDR_ANY (ipv4) or IPV6_ADDR_ANY (ipv6), every socket
> bound to that port must be checked for a potential conflict. The bhash
> table is the only source of port->socket associations.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/net/inet_connection_sock.h |   3 +
>  include/net/inet_hashtables.h      |  80 ++++++++-
>  include/net/sock.h                 |  17 +-
>  net/dccp/ipv4.c                    |  24 ++-
>  net/dccp/ipv6.c                    |  12 ++
>  net/dccp/proto.c                   |  34 +++-
>  net/ipv4/af_inet.c                 |  31 +++-
>  net/ipv4/inet_connection_sock.c    | 279 ++++++++++++++++++++++-------
>  net/ipv4/inet_hashtables.c         | 277 ++++++++++++++++++++++++++--
>  net/ipv4/tcp.c                     |  11 +-
>  net/ipv4/tcp_ipv4.c                |  21 ++-
>  net/ipv6/tcp_ipv6.c                |  12 ++
>  12 files changed, 696 insertions(+), 105 deletions(-)
> 
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index 85cd695e7fd1..077cd730ce2f 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -25,6 +25,7 @@
>  #undef INET_CSK_CLEAR_TIMERS
>  
>  struct inet_bind_bucket;
> +struct inet_bind2_bucket;
>  struct tcp_congestion_ops;
>  
>  /*
> @@ -57,6 +58,7 @@ struct inet_connection_sock_af_ops {
>   *
>   * @icsk_accept_queue:	   FIFO of established children
>   * @icsk_bind_hash:	   Bind node
> + * @icsk_bind2_hash:	   Bind node in the bhash2 table
>   * @icsk_timeout:	   Timeout
>   * @icsk_retransmit_timer: Resend (no ack)
>   * @icsk_rto:		   Retransmit timeout
> @@ -83,6 +85,7 @@ struct inet_connection_sock {
>  	struct inet_sock	  icsk_inet;
>  	struct request_sock_queue icsk_accept_queue;
>  	struct inet_bind_bucket	  *icsk_bind_hash;
> +	struct inet_bind2_bucket  *icsk_bind2_hash;
>  	unsigned long		  icsk_timeout;
>   	struct timer_list	  icsk_retransmit_timer;
>   	struct timer_list	  icsk_delack_timer;
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index ebfa3df6f8dc..1e8a6ca5a988 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -23,6 +23,7 @@
>  
>  #include <net/inet_connection_sock.h>
>  #include <net/inet_sock.h>
> +#include <net/ip.h>
>  #include <net/sock.h>
>  #include <net/route.h>
>  #include <net/tcp_states.h>
> @@ -90,7 +91,28 @@ struct inet_bind_bucket {
>  	struct hlist_head	owners;
>  };
>  
> -static inline struct net *ib_net(struct inet_bind_bucket *ib)
> +struct inet_bind2_bucket {
> +	possible_net_t		ib_net;
> +	int			l3mdev;
> +	unsigned short		port;
> +	union {
> +#if IS_ENABLED(CONFIG_IPV6)
> +		struct in6_addr		v6_rcv_saddr;
> +#endif
> +		__be32			rcv_saddr;
> +	};
> +	/* Node in the bhash2 inet_bind_hashbucket chain */
> +	struct hlist_node	node;
> +	/* List of sockets hashed to this bucket */
> +	struct hlist_head	owners;
> +};
> +
> +static inline struct net *ib_net(const struct inet_bind_bucket *ib)
> +{
> +	return read_pnet(&ib->ib_net);
> +}
> +
> +static inline struct net *ib2_net(const struct inet_bind2_bucket *ib)
>  {
>  	return read_pnet(&ib->ib_net);
>  }
> @@ -133,7 +155,14 @@ struct inet_hashinfo {
>  	 * TCP hash as well as the others for fast bind/connect.
>  	 */
>  	struct kmem_cache		*bind_bucket_cachep;
> +	/* This bind table is hashed by local port */
>  	struct inet_bind_hashbucket	*bhash;
> +	struct kmem_cache		*bind2_bucket_cachep;
> +	/* This bind table is hashed by local port and sk->sk_rcv_saddr (ipv4)
> +	 * or sk->sk_v6_rcv_saddr (ipv6). This 2nd bind table is used
> +	 * primarily for expediting bind conflict resolution.
> +	 */
> +	struct inet_bind_hashbucket	*bhash2;
>  	unsigned int			bhash_size;
>  
>  	/* The 2nd listener table hashed by local port and address */
> @@ -193,14 +222,61 @@ inet_bind_bucket_create(struct kmem_cache *cachep, struct net *net,
>  void inet_bind_bucket_destroy(struct kmem_cache *cachep,
>  			      struct inet_bind_bucket *tb);
>  
> +bool inet_bind_bucket_match(const struct inet_bind_bucket *tb,
> +			    const struct net *net, unsigned short port,
> +			    int l3mdev);
> +
> +struct inet_bind2_bucket *
> +inet_bind2_bucket_create(struct kmem_cache *cachep, struct net *net,
> +			 struct inet_bind_hashbucket *head,
> +			 unsigned short port, int l3mdev,
> +			 const struct sock *sk);
> +
> +void inet_bind2_bucket_destroy(struct kmem_cache *cachep,
> +			       struct inet_bind2_bucket *tb);
> +
> +struct inet_bind2_bucket *
> +inet_bind2_bucket_find(const struct inet_bind_hashbucket *head,
> +		       const struct net *net,
> +		       unsigned short port, int l3mdev,
> +		       const struct sock *sk);
> +
> +bool inet_bind2_bucket_match_addr_any(const struct inet_bind2_bucket *tb,
> +				      const struct net *net, unsigned short port,
> +				      int l3mdev, const struct sock *sk);
> +
>  static inline u32 inet_bhashfn(const struct net *net, const __u16 lport,
>  			       const u32 bhash_size)
>  {
>  	return (lport + net_hash_mix(net)) & (bhash_size - 1);
>  }
>  
> +static inline struct inet_bind_hashbucket *
> +inet_bhashfn_portaddr(const struct inet_hashinfo *hinfo, const struct sock *sk,
> +		      const struct net *net, unsigned short port)
> +{
> +	u32 hash;
> +
> +#if IS_ENABLED(CONFIG_IPV6)
> +	if (sk->sk_family == AF_INET6)
> +		hash = ipv6_portaddr_hash(net, &sk->sk_v6_rcv_saddr, port);
> +	else
> +#endif
> +		hash = ipv4_portaddr_hash(net, sk->sk_rcv_saddr, port);
> +	return &hinfo->bhash2[hash & (hinfo->bhash_size - 1)];
> +}
> +
> +struct inet_bind_hashbucket *
> +inet_bhash2_addr_any_hashbucket(const struct sock *sk, const struct net *net, int port);
> +
> +/* This should be called whenever a socket's sk_rcv_saddr (ipv4) or
> + * sk_v6_rcv_saddr (ipv6) changes after it has been binded. The socket's
> + * rcv_saddr field should already have been updated when this is called.
> + */
> +int inet_bhash2_update_saddr(struct inet_bind_hashbucket *prev_saddr, struct sock *sk);
> +
>  void inet_bind_hash(struct sock *sk, struct inet_bind_bucket *tb,
> -		    const unsigned short snum);
> +		    struct inet_bind2_bucket *tb2, unsigned short port);
>  
>  /* Caller must disable local BH processing. */
>  int __inet_inherit_port(const struct sock *sk, struct sock *child);
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 5bed1ea7a722..3932e3e96281 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -348,6 +348,7 @@ struct sk_filter;
>    *	@sk_txtime_report_errors: set report errors mode for SO_TXTIME
>    *	@sk_txtime_unused: unused txtime flags
>    *	@ns_tracker: tracker for netns reference
> +  *	@sk_bind2_node: bind node in the bhash2 table
>    */
>  struct sock {
>  	/*
> @@ -537,6 +538,7 @@ struct sock {
>  #endif
>  	struct rcu_head		sk_rcu;
>  	netns_tracker		ns_tracker;
> +	struct hlist_node	sk_bind2_node;
>  };
>  
>  enum sk_pacing {
> @@ -811,12 +813,21 @@ static inline void __sk_del_bind_node(struct sock *sk)
>  	__hlist_del(&sk->sk_bind_node);
>  }
>  
> -static inline void sk_add_bind_node(struct sock *sk,
> -					struct hlist_head *list)
> +static inline void sk_add_bind_node(struct sock *sk, struct hlist_head *list)
>  {
>  	hlist_add_head(&sk->sk_bind_node, list);
>  }

This is an unneeded chunck, that increases the size of an already big
patch. I would have dropped it.
 
> +static inline void __sk_del_bind2_node(struct sock *sk)
> +{
> +	__hlist_del(&sk->sk_bind2_node);
> +}
> +
> +static inline void sk_add_bind2_node(struct sock *sk, struct hlist_head *list)
> +{
> +	hlist_add_head(&sk->sk_bind2_node, list);
> +}
> +
>  #define sk_for_each(__sk, list) \
>  	hlist_for_each_entry(__sk, list, sk_node)
>  #define sk_for_each_rcu(__sk, list) \
> @@ -834,6 +845,8 @@ static inline void sk_add_bind_node(struct sock *sk,
>  	hlist_for_each_entry_safe(__sk, tmp, list, sk_node)
>  #define sk_for_each_bound(__sk, list) \
>  	hlist_for_each_entry(__sk, list, sk_bind_node)
> +#define sk_for_each_bound_bhash2(__sk, list) \
> +	hlist_for_each_entry(__sk, list, sk_bind2_node)
>  
>  /**
>   * sk_for_each_entry_offset_rcu - iterate over a list at a given struct offset
> diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
> index da6e3b20cd75..7958f5d355f3 100644
> --- a/net/dccp/ipv4.c
> +++ b/net/dccp/ipv4.c
> @@ -45,14 +45,15 @@ static unsigned int dccp_v4_pernet_id __read_mostly;
>  int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  {
>  	const struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
> +	struct inet_bind_hashbucket *prev_addr_hashbucket = NULL;
> +	__be32 daddr, nexthop, prev_sk_rcv_saddr;
>  	struct inet_sock *inet = inet_sk(sk);
>  	struct dccp_sock *dp = dccp_sk(sk);
> +	struct ip_options_rcu *inet_opt;
>  	__be16 orig_sport, orig_dport;
> -	__be32 daddr, nexthop;
>  	struct flowi4 *fl4;
>  	struct rtable *rt;
>  	int err;
> -	struct ip_options_rcu *inet_opt;
>  
>  	dp->dccps_role = DCCP_ROLE_CLIENT;
>  
> @@ -89,9 +90,26 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  	if (inet_opt == NULL || !inet_opt->opt.srr)
>  		daddr = fl4->daddr;
>  
> -	if (inet->inet_saddr == 0)
> +	if (inet->inet_saddr == 0) {
> +		prev_addr_hashbucket = inet_bhashfn_portaddr(&dccp_hashinfo,
> +							     sk, sock_net(sk),
> +							     inet->inet_num);
> +		prev_sk_rcv_saddr = sk->sk_rcv_saddr;
>  		inet->inet_saddr = fl4->saddr;
> +	}
> +
>  	sk_rcv_saddr_set(sk, inet->inet_saddr);
> +
> +	if (prev_addr_hashbucket) {
> +		err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
> +		if (err) {
> +			inet->inet_saddr = 0;
> +			sk_rcv_saddr_set(sk, prev_sk_rcv_saddr);
> +			ip_rt_put(rt);
> +			return err;
> +		}
> +	}
> +
>  	inet->inet_dport = usin->sin_port;
>  	sk_daddr_set(sk, daddr);
>  
> diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
> index fd44638ec16b..83843aea173c 100644
> --- a/net/dccp/ipv6.c
> +++ b/net/dccp/ipv6.c
> @@ -934,8 +934,20 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
>  	}
>  
>  	if (saddr == NULL) {
> +		struct in6_addr prev_v6_rcv_saddr = sk->sk_v6_rcv_saddr;
> +		struct inet_bind_hashbucket *prev_addr_hashbucket;
> +
> +		prev_addr_hashbucket = inet_bhashfn_portaddr(&dccp_hashinfo,
> +							     sk, sock_net(sk),
> +							     inet->inet_num);
>  		saddr = &fl6.saddr;
>  		sk->sk_v6_rcv_saddr = *saddr;
> +
> +		err = inet_bhash2_update_saddr(prev_addr_hashbucket, sk);
> +		if (err) {
> +			sk->sk_v6_rcv_saddr = prev_v6_rcv_saddr;
> +			goto failure;
> +		}
>  	}
>  
>  	/* set the source address */
> diff --git a/net/dccp/proto.c b/net/dccp/proto.c
> index eb8e128e43e8..f4f2ad5f9c08 100644
> --- a/net/dccp/proto.c
> +++ b/net/dccp/proto.c
> @@ -1120,6 +1120,12 @@ static int __init dccp_init(void)
>  				  SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
>  	if (!dccp_hashinfo.bind_bucket_cachep)
>  		goto out_free_hashinfo2;
> +	dccp_hashinfo.bind2_bucket_cachep =
> +		kmem_cache_create("dccp_bind2_bucket",
> +				  sizeof(struct inet_bind2_bucket), 0,
> +				  SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
> +	if (!dccp_hashinfo.bind2_bucket_cachep)
> +		goto out_free_bind_bucket_cachep;
>  
>  	/*
>  	 * Size and allocate the main established and bind bucket
> @@ -1150,7 +1156,7 @@ static int __init dccp_init(void)
>  
>  	if (!dccp_hashinfo.ehash) {
>  		DCCP_CRIT("Failed to allocate DCCP established hash table");
> -		goto out_free_bind_bucket_cachep;
> +		goto out_free_bind2_bucket_cachep;
>  	}
>  
>  	for (i = 0; i <= dccp_hashinfo.ehash_mask; i++)
> @@ -1176,14 +1182,24 @@ static int __init dccp_init(void)
>  		goto out_free_dccp_locks;
>  	}
>  
> +	dccp_hashinfo.bhash2 = (struct inet_bind_hashbucket *)
> +		__get_free_pages(GFP_ATOMIC | __GFP_NOWARN, bhash_order);
> +
> +	if (!dccp_hashinfo.bhash2) {
> +		DCCP_CRIT("Failed to allocate DCCP bind2 hash table");
> +		goto out_free_dccp_bhash;
> +	}
> +
>  	for (i = 0; i < dccp_hashinfo.bhash_size; i++) {
>  		spin_lock_init(&dccp_hashinfo.bhash[i].lock);
>  		INIT_HLIST_HEAD(&dccp_hashinfo.bhash[i].chain);
> +		spin_lock_init(&dccp_hashinfo.bhash2[i].lock);
> +		INIT_HLIST_HEAD(&dccp_hashinfo.bhash2[i].chain);
>  	}
>  
>  	rc = dccp_mib_init();
>  	if (rc)
> -		goto out_free_dccp_bhash;
> +		goto out_free_dccp_bhash2;
>  
>  	rc = dccp_ackvec_init();
>  	if (rc)
> @@ -1207,30 +1223,38 @@ static int __init dccp_init(void)
>  	dccp_ackvec_exit();
>  out_free_dccp_mib:
>  	dccp_mib_exit();
> +out_free_dccp_bhash2:
> +	free_pages((unsigned long)dccp_hashinfo.bhash2, bhash_order);
>  out_free_dccp_bhash:
>  	free_pages((unsigned long)dccp_hashinfo.bhash, bhash_order);
>  out_free_dccp_locks:
>  	inet_ehash_locks_free(&dccp_hashinfo);
>  out_free_dccp_ehash:
>  	free_pages((unsigned long)dccp_hashinfo.ehash, ehash_order);
> +out_free_bind2_bucket_cachep:
> +	kmem_cache_destroy(dccp_hashinfo.bind2_bucket_cachep);
>  out_free_bind_bucket_cachep:
>  	kmem_cache_destroy(dccp_hashinfo.bind_bucket_cachep);
>  out_free_hashinfo2:
>  	inet_hashinfo2_free_mod(&dccp_hashinfo);
>  out_fail:
>  	dccp_hashinfo.bhash = NULL;
> +	dccp_hashinfo.bhash2 = NULL;
>  	dccp_hashinfo.ehash = NULL;
>  	dccp_hashinfo.bind_bucket_cachep = NULL;
> +	dccp_hashinfo.bind2_bucket_cachep = NULL;
>  	return rc;
>  }
>  
>  static void __exit dccp_fini(void)
>  {
> +	int bhash_order = get_order(dccp_hashinfo.bhash_size *
> +				    sizeof(struct inet_bind_hashbucket));
> +
>  	ccid_cleanup_builtins();
>  	dccp_mib_exit();
> -	free_pages((unsigned long)dccp_hashinfo.bhash,
> -		   get_order(dccp_hashinfo.bhash_size *
> -			     sizeof(struct inet_bind_hashbucket)));
> +	free_pages((unsigned long)dccp_hashinfo.bhash, bhash_order);
> +	free_pages((unsigned long)dccp_hashinfo.bhash2, bhash_order);
>  	free_pages((unsigned long)dccp_hashinfo.ehash,
>  		   get_order((dccp_hashinfo.ehash_mask + 1) *
>  			     sizeof(struct inet_ehash_bucket)));
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index da81f56fdd1c..47b5fa4f8c24 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1218,13 +1218,15 @@ EXPORT_SYMBOL(inet_unregister_protosw);
>  
>  static int inet_sk_reselect_saddr(struct sock *sk)
>  {
> +	struct inet_bind_hashbucket *prev_addr_hashbucket;
>  	struct inet_sock *inet = inet_sk(sk);
>  	__be32 old_saddr = inet->inet_saddr;
>  	__be32 daddr = inet->inet_daddr;
> +	struct ip_options_rcu *inet_opt;
>  	struct flowi4 *fl4;
>  	struct rtable *rt;
>  	__be32 new_saddr;
> -	struct ip_options_rcu *inet_opt;
> +	int err;
>  
>  	inet_opt = rcu_dereference_protected(inet->inet_opt,
>  					     lockdep_sock_is_held(sk));
> @@ -1239,20 +1241,33 @@ static int inet_sk_reselect_saddr(struct sock *sk)
>  	if (IS_ERR(rt))
>  		return PTR_ERR(rt);
>  
> -	sk_setup_caps(sk, &rt->dst);
> -

I don't see why  'sk_setup_caps()' is moved. Additionally it looks like
it's not called anymore on the error path. It looks like an unrelated
"optimization", I suggest to drop it.


Thanks!

Paolo

