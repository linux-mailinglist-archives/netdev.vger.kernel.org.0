Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C213B1339
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 07:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhFWF3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 01:29:42 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:55912 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhFWF3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 01:29:41 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 99552800056;
        Wed, 23 Jun 2021 07:27:22 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 07:27:22 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 23 Jun
 2021 07:27:22 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C7C5731801F6; Wed, 23 Jun 2021 07:27:21 +0200 (CEST)
Date:   Wed, 23 Jun 2021 07:27:21 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Frederic Weisbecker <frederic@kernel.org>
CC:     Varad Gautam <varad.gautam@suse.com>,
        <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] xfrm: policy: Restructure RCU-read locking in
 xfrm_sk_policy_lookup
Message-ID: <20210623052721.GF40979@gauss3.secunet.de>
References: <20210618141101.18168-1-varad.gautam@suse.com>
 <20210621082949.GX40979@gauss3.secunet.de>
 <f41d40cc-e474-1324-be0a-7beaf580c292@suse.com>
 <20210621110528.GZ40979@gauss3.secunet.de>
 <20210622112159.GC40979@gauss3.secunet.de>
 <20210622115124.GA109262@lothringen>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210622115124.GA109262@lothringen>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 01:51:24PM +0200, Frederic Weisbecker wrote:
> On Tue, Jun 22, 2021 at 01:21:59PM +0200, Steffen Klassert wrote:
> > On Mon, Jun 21, 2021 at 01:05:28PM +0200, Steffen Klassert wrote:
> > > On Mon, Jun 21, 2021 at 11:11:18AM +0200, Varad Gautam wrote:
> > 
> > Varad, can you try to replace the seqcount_mutex_t for xfrm_policy_hash_generation
> > by a seqcount_spinlock_t? I'm not familiar with that seqcount changes,
> > but we should not end up with using a mutex in this codepath.
> 
> Something like this? (beware, untested, also I don't know if the read side
> should then disable bh, doesn't look necessary for PREEMPT_RT, but I may be
> missing something...)
> 
> diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
> index e816b6a3ef2b..9b376b87bd54 100644
> --- a/include/net/netns/xfrm.h
> +++ b/include/net/netns/xfrm.h
> @@ -74,6 +74,7 @@ struct netns_xfrm {
>  #endif
>  	spinlock_t		xfrm_state_lock;
>  	seqcount_spinlock_t	xfrm_state_hash_generation;
> +	seqcount_spinlock_t	xfrm_policy_hash_generation;
>  
>  	spinlock_t xfrm_policy_lock;
>  	struct mutex xfrm_cfg_mutex;
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index ce500f847b99..46a6d15b66d6 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -155,7 +155,6 @@ static struct xfrm_policy_afinfo const __rcu *xfrm_policy_afinfo[AF_INET6 + 1]
>  						__read_mostly;
>  
>  static struct kmem_cache *xfrm_dst_cache __ro_after_init;
> -static __read_mostly seqcount_mutex_t xfrm_policy_hash_generation;
>  
>  static struct rhashtable xfrm_policy_inexact_table;
>  static const struct rhashtable_params xfrm_pol_inexact_params;
> @@ -585,7 +584,7 @@ static void xfrm_bydst_resize(struct net *net, int dir)
>  		return;
>  
>  	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
> -	write_seqcount_begin(&xfrm_policy_hash_generation);
> +	write_seqcount_begin(&net->xfrm.xfrm_policy_hash_generation);
>  
>  	odst = rcu_dereference_protected(net->xfrm.policy_bydst[dir].table,
>  				lockdep_is_held(&net->xfrm.xfrm_policy_lock));
> @@ -596,7 +595,7 @@ static void xfrm_bydst_resize(struct net *net, int dir)
>  	rcu_assign_pointer(net->xfrm.policy_bydst[dir].table, ndst);
>  	net->xfrm.policy_bydst[dir].hmask = nhashmask;
>  
> -	write_seqcount_end(&xfrm_policy_hash_generation);
> +	write_seqcount_end(&net->xfrm.xfrm_policy_hash_generation);
>  	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
>  
>  	synchronize_rcu();
> @@ -1245,7 +1244,7 @@ static void xfrm_hash_rebuild(struct work_struct *work)
>  	} while (read_seqretry(&net->xfrm.policy_hthresh.lock, seq));
>  
>  	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
> -	write_seqcount_begin(&xfrm_policy_hash_generation);
> +	write_seqcount_begin(&net->xfrm.xfrm_policy_hash_generation);
>  
>  	/* make sure that we can insert the indirect policies again before
>  	 * we start with destructive action.
> @@ -1354,7 +1353,7 @@ static void xfrm_hash_rebuild(struct work_struct *work)
>  
>  out_unlock:
>  	__xfrm_policy_inexact_flush(net);
> -	write_seqcount_end(&xfrm_policy_hash_generation);
> +	write_seqcount_end(&net->xfrm.xfrm_policy_hash_generation);
>  	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
>  
>  	mutex_unlock(&hash_resize_mutex);
> @@ -2095,9 +2094,9 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
>  	rcu_read_lock();
>   retry:
>  	do {
> -		sequence = read_seqcount_begin(&xfrm_policy_hash_generation);
> +		sequence = read_seqcount_begin(&net->xfrm.xfrm_policy_hash_generation);
>  		chain = policy_hash_direct(net, daddr, saddr, family, dir);
> -	} while (read_seqcount_retry(&xfrm_policy_hash_generation, sequence));
> +	} while (read_seqcount_retry(&net->xfrm.xfrm_policy_hash_generation, sequence));
>  
>  	ret = NULL;
>  	hlist_for_each_entry_rcu(pol, chain, bydst) {
> @@ -2128,7 +2127,7 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
>  	}
>  
>  skip_inexact:
> -	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence))
> +	if (read_seqcount_retry(&net->xfrm.xfrm_policy_hash_generation, sequence))
>  		goto retry;
>  
>  	if (ret && !xfrm_pol_hold_rcu(ret))
> @@ -4084,6 +4083,7 @@ static int __net_init xfrm_net_init(struct net *net)
>  	/* Initialize the per-net locks here */
>  	spin_lock_init(&net->xfrm.xfrm_state_lock);
>  	spin_lock_init(&net->xfrm.xfrm_policy_lock);
> +	seqcount_spinlock_init(&net->xfrm.xfrm_policy_hash_generation, &net->xfrm.xfrm_policy_lock);
>  	mutex_init(&net->xfrm.xfrm_cfg_mutex);
>  
>  	rv = xfrm_statistics_init(net);
> @@ -4128,7 +4128,6 @@ void __init xfrm_init(void)
>  {
>  	register_pernet_subsys(&xfrm_net_ops);
>  	xfrm_dev_init();
> -	seqcount_mutex_init(&xfrm_policy_hash_generation, &hash_resize_mutex);
>  	xfrm_input_init();
>  
>  #ifdef CONFIG_XFRM_ESPINTCP

Yes, looks like your patch should do it. The xfrm_policy_lock is the
write side protection for the seqcount here.

Thanks!
