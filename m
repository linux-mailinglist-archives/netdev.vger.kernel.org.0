Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24A0653429
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 17:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiLUQhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 11:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbiLUQhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 11:37:37 -0500
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4668323EA4
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 08:37:29 -0800 (PST)
Received: by mail-ej1-f42.google.com with SMTP id x22so38074988ejs.11
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 08:37:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=asoYpppXkxDahpnaqVnzOJ1LrSt47rSUiR8TgXcB2VY=;
        b=sv8wK9gtakrUl/6QmwNgOH8hNCL26aSzETIFlePhjciI+6USO2Y+1OyBPoSymLWwEn
         1Zh1HbfxSMkyhHDUJlEHAOh+JU29LsCZjjKgOIYULeQfzqI7gA/rvstKpuxW0IM7GoJH
         /8b8LOHWtcluBuEnajKSWyOF/ojFLRw7TzqkIpxudIUUydr26A1o3aUntpv6KPLz+Gae
         3jh8D2rVlnXO3bWxxsGUblUxQK/TJUXvEhRxMrpA5dyIfHlBriqJuO/G/appnE5Qfyca
         JDv/UiVlWBA0AqhTY6lqAevJwldvYFuMxYN74EtDHSK0v+pk05MU+3uxklCFKJumcWcb
         yliw==
X-Gm-Message-State: AFqh2kqQksTZhD48U6YYfiTEX4BW7hGvih92rlFRczIqC1aTN4+VI6+K
        IKsyiJ4A+OiG1zhO+1iRpBI=
X-Google-Smtp-Source: AMrXdXtIHv3Mfu/0ZeO1A+nFOSBGvnJszRHGWh0emUxmR61BKEYOeEd6IySUVhwIaOfl6lcUwNunoQ==
X-Received: by 2002:a17:907:8c86:b0:7c1:1adc:46fd with SMTP id td6-20020a1709078c8600b007c11adc46fdmr1933173ejc.34.1671640647601;
        Wed, 21 Dec 2022 08:37:27 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:49? ([2a0b:e7c0:0:107::aaaa:49])
        by smtp.gmail.com with ESMTPSA id k17-20020a170906971100b007c0b6e1c7fdsm7304015ejx.104.2022.12.21.08.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Dec 2022 08:37:27 -0800 (PST)
Message-ID: <9eae0fc2-ea4f-20fe-7a0a-cae3a4bb9354@kernel.org>
Date:   Wed, 21 Dec 2022 17:37:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH RFC net 1/2] tcp: Add TIME_WAIT sockets in bhash2.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Joanne Koong <joannelkoong@gmail.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20221221151258.25748-1-kuniyu@amazon.com>
 <20221221151258.25748-2-kuniyu@amazon.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20221221151258.25748-2-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21. 12. 22, 16:12, Kuniyuki Iwashima wrote:
> Jiri Slaby reported regression of bind() with a simple repro. [0]
> 
> The repro creates a TIME_WAIT socket and tries to bind() a new socket
> with the same local address and port.  Before commit 28044fc1d495 ("net:
> Add a bhash2 table hashed by port and address"), the bind() failed with
> -EADDRINUSE, but now it succeeds.
> 
> The cited commit should have put TIME_WAIT sockets into bhash2; otherwise,
> inet_bhash2_conflict() misses TIME_WAIT sockets when validating bind()
> requests if the address is not a wildcard one.
> 
> [0]: https://lore.kernel.org/netdev/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/
> 
> Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
> Reported-by: Jiri Slaby <jirislaby@kernel.org>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Tested-by: Jiri Slaby <jirislaby@kernel.org>


> ---
>   include/net/inet_timewait_sock.h |  2 ++
>   include/net/sock.h               |  5 +++--
>   net/ipv4/inet_hashtables.c       |  5 +++--
>   net/ipv4/inet_timewait_sock.c    | 31 +++++++++++++++++++++++++++++--
>   4 files changed, 37 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
> index 5b47545f22d3..c46ed239ad9a 100644
> --- a/include/net/inet_timewait_sock.h
> +++ b/include/net/inet_timewait_sock.h
> @@ -44,6 +44,7 @@ struct inet_timewait_sock {
>   #define tw_bound_dev_if		__tw_common.skc_bound_dev_if
>   #define tw_node			__tw_common.skc_nulls_node
>   #define tw_bind_node		__tw_common.skc_bind_node
> +#define tw_bind2_node		__tw_common.skc_bind2_node
>   #define tw_refcnt		__tw_common.skc_refcnt
>   #define tw_hash			__tw_common.skc_hash
>   #define tw_prot			__tw_common.skc_prot
> @@ -73,6 +74,7 @@ struct inet_timewait_sock {
>   	u32			tw_priority;
>   	struct timer_list	tw_timer;
>   	struct inet_bind_bucket	*tw_tb;
> +	struct inet_bind2_bucket	*tw_tb2;
>   };
>   #define tw_tclass tw_tos
>   
> diff --git a/include/net/sock.h b/include/net/sock.h
> index dcd72e6285b2..aaec985c1b5b 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -156,6 +156,7 @@ typedef __u64 __bitwise __addrpair;
>    *	@skc_tw_rcv_nxt: (aka tw_rcv_nxt) TCP window next expected seq number
>    *		[union with @skc_incoming_cpu]
>    *	@skc_refcnt: reference count
> + *	@skc_bind2_node: bind node in the bhash2 table
>    *
>    *	This is the minimal network layer representation of sockets, the header
>    *	for struct sock and struct inet_timewait_sock.
> @@ -241,6 +242,7 @@ struct sock_common {
>   		u32		skc_window_clamp;
>   		u32		skc_tw_snd_nxt; /* struct tcp_timewait_sock */
>   	};
> +	struct hlist_node	skc_bind2_node;
>   	/* public: */
>   };
>   
> @@ -351,7 +353,6 @@ struct sk_filter;
>     *	@sk_txtime_report_errors: set report errors mode for SO_TXTIME
>     *	@sk_txtime_unused: unused txtime flags
>     *	@ns_tracker: tracker for netns reference
> -  *	@sk_bind2_node: bind node in the bhash2 table
>     */
>   struct sock {
>   	/*
> @@ -384,6 +385,7 @@ struct sock {
>   #define sk_net_refcnt		__sk_common.skc_net_refcnt
>   #define sk_bound_dev_if		__sk_common.skc_bound_dev_if
>   #define sk_bind_node		__sk_common.skc_bind_node
> +#define sk_bind2_node		__sk_common.skc_bind2_node
>   #define sk_prot			__sk_common.skc_prot
>   #define sk_net			__sk_common.skc_net
>   #define sk_v6_daddr		__sk_common.skc_v6_daddr
> @@ -542,7 +544,6 @@ struct sock {
>   #endif
>   	struct rcu_head		sk_rcu;
>   	netns_tracker		ns_tracker;
> -	struct hlist_node	sk_bind2_node;
>   };
>   
>   enum sk_pacing {
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index d039b4e732a3..1e81dc7c6de4 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -1103,15 +1103,16 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
>   	/* Head lock still held and bh's disabled */
>   	inet_bind_hash(sk, tb, tb2, port);
>   
> -	spin_unlock(&head2->lock);
> -
>   	if (sk_unhashed(sk)) {
>   		inet_sk(sk)->inet_sport = htons(port);
>   		inet_ehash_nolisten(sk, (struct sock *)tw, NULL);
>   	}
>   	if (tw)
>   		inet_twsk_bind_unhash(tw, hinfo);
> +
> +	spin_unlock(&head2->lock);
>   	spin_unlock(&head->lock);
> +
>   	if (tw)
>   		inet_twsk_deschedule_put(tw);
>   	local_bh_enable();
> diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> index 66fc940f9521..bec037d9ab8e 100644
> --- a/net/ipv4/inet_timewait_sock.c
> +++ b/net/ipv4/inet_timewait_sock.c
> @@ -29,6 +29,7 @@
>   void inet_twsk_bind_unhash(struct inet_timewait_sock *tw,
>   			  struct inet_hashinfo *hashinfo)
>   {
> +	struct inet_bind2_bucket *tb2 = tw->tw_tb2;
>   	struct inet_bind_bucket *tb = tw->tw_tb;
>   
>   	if (!tb)
> @@ -37,6 +38,11 @@ void inet_twsk_bind_unhash(struct inet_timewait_sock *tw,
>   	__hlist_del(&tw->tw_bind_node);
>   	tw->tw_tb = NULL;
>   	inet_bind_bucket_destroy(hashinfo->bind_bucket_cachep, tb);
> +
> +	__hlist_del(&tw->tw_bind2_node);
> +	tw->tw_tb2 = NULL;
> +	inet_bind2_bucket_destroy(hashinfo->bind2_bucket_cachep, tb2);
> +
>   	__sock_put((struct sock *)tw);
>   }
>   
> @@ -45,7 +51,7 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
>   {
>   	struct inet_hashinfo *hashinfo = tw->tw_dr->hashinfo;
>   	spinlock_t *lock = inet_ehash_lockp(hashinfo, tw->tw_hash);
> -	struct inet_bind_hashbucket *bhead;
> +	struct inet_bind_hashbucket *bhead, *bhead2;
>   
>   	spin_lock(lock);
>   	sk_nulls_del_node_init_rcu((struct sock *)tw);
> @@ -54,9 +60,13 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
>   	/* Disassociate with bind bucket. */
>   	bhead = &hashinfo->bhash[inet_bhashfn(twsk_net(tw), tw->tw_num,
>   			hashinfo->bhash_size)];
> +	bhead2 = inet_bhashfn_portaddr(hashinfo, (struct sock *)tw,
> +				       twsk_net(tw), tw->tw_num);
>   
>   	spin_lock(&bhead->lock);
> +	spin_lock(&bhead2->lock);
>   	inet_twsk_bind_unhash(tw, hashinfo);
> +	spin_unlock(&bhead2->lock);
>   	spin_unlock(&bhead->lock);
>   
>   	refcount_dec(&tw->tw_dr->tw_refcount);
> @@ -93,6 +103,12 @@ static void inet_twsk_add_bind_node(struct inet_timewait_sock *tw,
>   	hlist_add_head(&tw->tw_bind_node, list);
>   }
>   
> +static void inet_twsk_add_bind2_node(struct inet_timewait_sock *tw,
> +				     struct hlist_head *list)
> +{
> +	hlist_add_head(&tw->tw_bind2_node, list);
> +}
> +
>   /*
>    * Enter the time wait state. This is called with locally disabled BH.
>    * Essentially we whip up a timewait bucket, copy the relevant info into it
> @@ -105,17 +121,28 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
>   	const struct inet_connection_sock *icsk = inet_csk(sk);
>   	struct inet_ehash_bucket *ehead = inet_ehash_bucket(hashinfo, sk->sk_hash);
>   	spinlock_t *lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
> -	struct inet_bind_hashbucket *bhead;
> +	struct inet_bind_hashbucket *bhead, *bhead2;
> +
>   	/* Step 1: Put TW into bind hash. Original socket stays there too.
>   	   Note, that any socket with inet->num != 0 MUST be bound in
>   	   binding cache, even if it is closed.
>   	 */
>   	bhead = &hashinfo->bhash[inet_bhashfn(twsk_net(tw), inet->inet_num,
>   			hashinfo->bhash_size)];
> +	bhead2 = inet_bhashfn_portaddr(hashinfo, sk, twsk_net(tw), inet->inet_num);
> +
>   	spin_lock(&bhead->lock);
> +	spin_lock(&bhead2->lock);
> +
>   	tw->tw_tb = icsk->icsk_bind_hash;
>   	WARN_ON(!icsk->icsk_bind_hash);
>   	inet_twsk_add_bind_node(tw, &tw->tw_tb->owners);
> +
> +	tw->tw_tb2 = icsk->icsk_bind2_hash;
> +	WARN_ON(!icsk->icsk_bind2_hash);
> +	inet_twsk_add_bind2_node(tw, &tw->tw_tb2->owners);
> +
> +	spin_unlock(&bhead2->lock);
>   	spin_unlock(&bhead->lock);
>   
>   	spin_lock(lock);

-- 
js
suse labs

