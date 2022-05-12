Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E14525325
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356562AbiELRCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356839AbiELRCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:02:10 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF19E6D4DA
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 10:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1652374924;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=7O5qzx9scmGvP0wa5Nf4FuXPmPkk+zLJ1JtCKXEkxSk=;
    b=UAzRgSgsPvw+U8Diah1vrax/0+63PnteVRWtzWPtZw3QvLkOCSPT5EcH+5SQdqZUbl
    d1lOL0EKuqOj4y5N3nvfCQv6Wk1cqvYAlgneXjJTjAoFdz6V+I9OEWueNwG9hWujqwzt
    ev3xKb4KcNHRrvVDEgINBu2SV+8xzzn/mDlkt4GaR2v/LE1gSvm2UB5XaS/uE4+SU6xt
    zcO7Va3Od11kW/0GrvBcpJ4k0YlplP9x3qNLUNkL0a7i63qaNdnPlgPHeb8fqy22zaNZ
    knjyBOgDVFHssqSrHsrQbWfos0A35+5mbHHOP6J7CXZqEs5t8jaa1bdI4J1NBFnlrOR4
    DG0Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdBqPeOug2krLFRKxw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cff:5b04::b82]
    by smtp.strato.de (RZmta 47.45.0 AUTH)
    with ESMTPSA id R0691fy4CH230Ac
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 12 May 2022 19:02:03 +0200 (CEST)
Message-ID: <09dae83a-b716-3a0c-cc18-39e6e9afa6cc@hartkopp.net>
Date:   Thu, 12 May 2022 19:02:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 net-next] inet: add READ_ONCE(sk->sk_bound_dev_if) in
 INET_MATCH()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
References: <20220512165601.2326659-1-eric.dumazet@gmail.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220512165601.2326659-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12.05.22 18:56, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> INET_MATCH() runs without holding a lock on the socket.
> 
> We probably need to annotate most reads.
> 
> This patch makes INET_MATCH() an inline function
> to ease our changes.
> 
> v2:
> 
> We remove the 32bit version of it, as modern compilers
> should generate the same code really, no need to
> try to be smarter.
> 
> Also make 'struct net *net' the first argument.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
> 
> Sent as a standalone patch to not spam netdev@ list.
> 
>   include/net/inet_hashtables.h | 33 +++++++++++++++------------------
>   include/net/sock.h            |  3 ---
>   net/ipv4/inet_hashtables.c    | 15 +++++----------
>   net/ipv4/udp.c                |  3 +--
>   4 files changed, 21 insertions(+), 33 deletions(-)
> 
> diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
> index 98e1ec1a14f0382d1f4f8e85fe5ac2a056d2d6bc..e44e410813d0f469131f54cf3372458a0340d5cf 100644
> --- a/include/net/inet_hashtables.h
> +++ b/include/net/inet_hashtables.h
> @@ -295,7 +295,6 @@ static inline struct sock *inet_lookup_listener(struct net *net,
>   	((__force __portpair)(((__u32)(__dport) << 16) | (__force __u32)(__be16)(__sport)))
>   #endif
>   
> -#if (BITS_PER_LONG == 64)
>   #ifdef __BIG_ENDIAN
>   #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
>   	const __addrpair __name = (__force __addrpair) ( \
> @@ -307,24 +306,22 @@ static inline struct sock *inet_lookup_listener(struct net *net,
>   				   (((__force __u64)(__be32)(__daddr)) << 32) | \
>   				   ((__force __u64)(__be32)(__saddr)))
>   #endif /* __BIG_ENDIAN */
> -#define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif, __sdif) \
> -	(((__sk)->sk_portpair == (__ports))			&&	\
> -	 ((__sk)->sk_addrpair == (__cookie))			&&	\
> -	 (((__sk)->sk_bound_dev_if == (__dif))			||	\
> -	  ((__sk)->sk_bound_dev_if == (__sdif)))		&&	\
> -	 net_eq(sock_net(__sk), (__net)))
> -#else /* 32-bit arch */
> -#define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
> -	const int __name __deprecated __attribute__((unused))
>   
> -#define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif, __sdif) \
> -	(((__sk)->sk_portpair == (__ports))		&&		\
> -	 ((__sk)->sk_daddr	== (__saddr))		&&		\
> -	 ((__sk)->sk_rcv_saddr	== (__daddr))		&&		\
> -	 (((__sk)->sk_bound_dev_if == (__dif))		||		\
> -	  ((__sk)->sk_bound_dev_if == (__sdif)))	&&		\
> -	 net_eq(sock_net(__sk), (__net)))
> -#endif /* 64-bit arch */
> +static inline bool INET_MATCH(struct net *net, const struct sock *sk,

When you convert the #define into an inline function, wouldn't it be 
more natural to name it lower caps?

static inline bool inet_match(struct net *net, ... )


Best,
Oliver

> +			      const __addrpair cookie, const __portpair ports,
> +			      int dif, int sdif)
> +{
> +	int bound_dev_if;
> +
> +	if (!net_eq(sock_net(sk), net) ||
> +	    sk->sk_portpair != ports ||
> +	    sk->sk_addrpair != cookie)
> +	        return false;
> +
> +	/* Paired with WRITE_ONCE() from sock_bindtoindex_locked() */
> +	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
> +	return bound_dev_if == dif || bound_dev_if == sdif;
> +}
>   
>   /* Sockets in TCP_CLOSE state are _always_ taken out of the hash, so we need
>    * not check it for lookups anymore, thanks Alexey. -DaveM
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 73063c88a2499b31c1e8d25dc157d21f93b02bf5..01edfde4257d697f2a2c88ef704a3849af4e5305 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -161,9 +161,6 @@ typedef __u64 __bitwise __addrpair;
>    *	for struct sock and struct inet_timewait_sock.
>    */
>   struct sock_common {
> -	/* skc_daddr and skc_rcv_saddr must be grouped on a 8 bytes aligned
> -	 * address on 64bit arches : cf INET_MATCH()
> -	 */
>   	union {
>   		__addrpair	skc_addrpair;
>   		struct {
> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> index a5d57fa679caa47ec31ea4b1de3c45f93be4cd13..16a8440083f7e4bebd5de51ddb41b3d886b233cd 100644
> --- a/net/ipv4/inet_hashtables.c
> +++ b/net/ipv4/inet_hashtables.c
> @@ -410,13 +410,11 @@ struct sock *__inet_lookup_established(struct net *net,
>   	sk_nulls_for_each_rcu(sk, node, &head->chain) {
>   		if (sk->sk_hash != hash)
>   			continue;
> -		if (likely(INET_MATCH(sk, net, acookie,
> -				      saddr, daddr, ports, dif, sdif))) {
> +		if (likely(INET_MATCH(net, sk, acookie, ports, dif, sdif))) {
>   			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
>   				goto out;
> -			if (unlikely(!INET_MATCH(sk, net, acookie,
> -						 saddr, daddr, ports,
> -						 dif, sdif))) {
> +			if (unlikely(!INET_MATCH(net, sk, acookie,
> +						 ports, dif, sdif))) {
>   				sock_gen_put(sk);
>   				goto begin;
>   			}
> @@ -465,8 +463,7 @@ static int __inet_check_established(struct inet_timewait_death_row *death_row,
>   		if (sk2->sk_hash != hash)
>   			continue;
>   
> -		if (likely(INET_MATCH(sk2, net, acookie,
> -					 saddr, daddr, ports, dif, sdif))) {
> +		if (likely(INET_MATCH(net, sk2, acookie, ports, dif, sdif))) {
>   			if (sk2->sk_state == TCP_TIME_WAIT) {
>   				tw = inet_twsk(sk2);
>   				if (twsk_unique(sk, sk2, twp))
> @@ -532,9 +529,7 @@ static bool inet_ehash_lookup_by_sk(struct sock *sk,
>   		if (esk->sk_hash != sk->sk_hash)
>   			continue;
>   		if (sk->sk_family == AF_INET) {
> -			if (unlikely(INET_MATCH(esk, net, acookie,
> -						sk->sk_daddr,
> -						sk->sk_rcv_saddr,
> +			if (unlikely(INET_MATCH(net, esk, acookie,
>   						ports, dif, sdif))) {
>   				return true;
>   			}
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 9d5071c79c9599aa973b80869b7768a68a508cc2..53342ce17172722d51a5db34ca9f1d5c61fb82de 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2563,8 +2563,7 @@ static struct sock *__udp4_lib_demux_lookup(struct net *net,
>   	struct sock *sk;
>   
>   	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
> -		if (INET_MATCH(sk, net, acookie, rmt_addr,
> -			       loc_addr, ports, dif, sdif))
> +		if (INET_MATCH(net, sk, acookie, ports, dif, sdif))
>   			return sk;
>   		/* Only check first socket in chain */
>   		break;
