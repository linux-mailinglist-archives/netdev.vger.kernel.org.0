Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9DCFF5CBD
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 02:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbfKIBdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 20:33:49 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:48874 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbfKIBdt (ORCPT <rfc822;netdev@vger.kernel.orG>);
        Fri, 8 Nov 2019 20:33:49 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iTFdL-0004sS-Nq; Sat, 09 Nov 2019 09:33:47 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iTFdG-0007uj-Es; Sat, 09 Nov 2019 09:33:42 +0800
Date:   Sat, 9 Nov 2019 09:33:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH net-next] xfrm: add missing rcu verbs to fix data-race
Message-ID: <20191109013342.d7notm6wmllgydsf@gondor.apana.org.au>
References: <20191108034701.77736-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108034701.77736-1-edumazet@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 07:47:01PM -0800, Eric Dumazet wrote:
> KCSAN reported a data-race in xfrm_lookup_with_ifid() and
> xfrm_sk_free_policy() [1]

I'm very uncomfortable with these warnings being enabled in KASAN
unless there is a way to opt out of them without adding unnecessary
READ_ONCE/WRITE_ONCE tags.

All they do is create patches such as this one that simply adds
these tags without resolving the underlying issues (if there are
any).

> diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> index aa08a7a5f6ac5836524dd34115cd57e2675e574d..8884575ae2135b739a2c316bf8a92b56d6cc807c 100644
> --- a/include/net/xfrm.h
> +++ b/include/net/xfrm.h
> @@ -1093,7 +1093,7 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
>  	struct net *net = dev_net(skb->dev);
>  	int ndir = dir | (reverse ? XFRM_POLICY_MASK + 1 : 0);
>  
> -	if (sk && sk->sk_policy[XFRM_POLICY_IN])
> +	if (sk && rcu_access_pointer(sk->sk_policy[XFRM_POLICY_IN]))
>  		return __xfrm_policy_check(sk, ndir, skb, family);

This is simply an optimisation and we don't care if we get it
wrong due to the lack of READ_ONCE/WRITE_ONCE.  Even with the
READ_ONCE tag, there is nothing stopping a policy from being
added after the test returns false, or all policies from being
deleted after the test returns true.

IOW this is simply unnecessary.

> @@ -1171,7 +1171,8 @@ static inline int xfrm_sk_clone_policy(struct sock *sk, const struct sock *osk)
>  {
>  	sk->sk_policy[0] = NULL;
>  	sk->sk_policy[1] = NULL;
> -	if (unlikely(osk->sk_policy[0] || osk->sk_policy[1]))
> +	if (unlikely(rcu_access_pointer(osk->sk_policy[0]) ||
> +		     rcu_access_pointer(osk->sk_policy[1])))
>  		return __xfrm_sk_clone_policy(sk, osk);
>  	return 0;

These on the other hand are done under socket lock.  IOW they
are completely synchronised with respect to the write side which
is also under socket lock so no tagging is necessary.

Incidentally rcu_access_pointer is now practically the same as
rcu_dereference because the smp_read_barrier_depends has been
moved over to READ_ONCE.  In fact there is no performance difference
between rcu_dereference and rcu_dereference_raw either.

I think we should either remove the smp_barrier_depends from
rcu_access_pointer, or just get rid of rcu_access_pointer completely.

> @@ -1185,12 +1186,12 @@ static inline void xfrm_sk_free_policy(struct sock *sk)
>  	pol = rcu_dereference_protected(sk->sk_policy[0], 1);
>  	if (unlikely(pol != NULL)) {
>  		xfrm_policy_delete(pol, XFRM_POLICY_MAX);
> -		sk->sk_policy[0] = NULL;
> +		rcu_assign_pointer(sk->sk_policy[0], NULL);
>  	}
>  	pol = rcu_dereference_protected(sk->sk_policy[1], 1);
>  	if (unlikely(pol != NULL)) {
>  		xfrm_policy_delete(pol, XFRM_POLICY_MAX+1);
> -		sk->sk_policy[1] = NULL;
> +		rcu_assign_pointer(sk->sk_policy[1], NULL);

These should use RCU_INIT_POINTER.

> diff --git a/net/smc/smc.h b/net/smc/smc.h
> index be11ba41190fb58be3ce9e8ab1a9ea4f8aa6a05b..4324dd39de99ba5967e1325746a2f5eff4baf2e7 100644
> --- a/net/smc/smc.h
> +++ b/net/smc/smc.h
> @@ -253,8 +253,8 @@ static inline u32 ntoh24(u8 *net)
>  #ifdef CONFIG_XFRM
>  static inline bool using_ipsec(struct smc_sock *smc)
>  {
> -	return (smc->clcsock->sk->sk_policy[0] ||
> -		smc->clcsock->sk->sk_policy[1]) ? true : false;
> +	return (rcu_access_pointer(smc->clcsock->sk->sk_policy[0]) ||
> +		rcu_access_pointer(smc->clcsock->sk->sk_policy[1])) ? true : false;
>  }
>  #else
>  static inline bool using_ipsec(struct smc_sock *smc)

Now this could actually be a real bug because it doesn't appear
to be an optimisation and it doesn't seem to be holding the socket
lock either.

Again this shows that we shouldn't just add READ_ONCE/WRITE_ONCE
tags because they might be papering over real bugs and help them
hide better because people will automatically assume that using
READ_ONCE/WRITE_ONCE means that the code is *safe*.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
