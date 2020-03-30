Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D43E619869A
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgC3VfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:35:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728540AbgC3VfQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 17:35:16 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF1E8206CC;
        Mon, 30 Mar 2020 21:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585604114;
        bh=smx635GZQmL6ODRcoLVRN8tOVcugBxrvfCvamj/YcFE=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=TJKTNGpiOz2YLtjhr6KEI+vsy8rg1euHWh0uznilkVL85CZGX3ublL1sKFTfEy+Xr
         EK7bYOAH6hFC4dZg15/ZpwyU5WYZwyH9cz5B0egHzKQAuMtym3l6nLVoC0paBnvb5q
         m/n7qmtrXYMkxZWQfpeRKvbj4XZ8m06GozjHpn9I=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 94E9435229BC; Mon, 30 Mar 2020 14:35:14 -0700 (PDT)
Date:   Mon, 30 Mar 2020 14:35:14 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] net_sched: add a temporary refcnt for struct
 tcindex_data
Message-ID: <20200330213514.GT19865@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200328191259.17145-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200328191259.17145-1-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 12:12:59PM -0700, Cong Wang wrote:
> Although we intentionally use an ordered workqueue for all tc
> filter works, the ordering is not guaranteed by RCU work,
> given that tcf_queue_work() is esstenially a call_rcu().
> 
> This problem is demostrated by Thomas:
> 
>   CPU 0:
>     tcf_queue_work()
>       tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
> 
>   -> Migration to CPU 1
> 
>   CPU 1:
>      tcf_queue_work(&p->rwork, tcindex_destroy_work);
> 
> so the 2nd work could be queued before the 1st one, which leads
> to a free-after-free.
> 
> Enforcing this order in RCU work is hard as it requires to change
> RCU code too. Fortunately we can workaround this problem in tcindex
> filter by taking a temporary refcnt, we only refcnt it right before
> we begin to destroy it. This simplifies the code a lot as a full
> refcnt requires much more changes in tcindex_set_parms().
> 
> Reported-by: syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com
> Fixes: 3d210534cc93 ("net_sched: fix a race condition in tcindex_destroy()")
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Looks plausible, but what did you do to verify that the structures
were in fact being freed?  See below for more detail.

							Thanx, Paul

> ---
>  net/sched/cls_tcindex.c | 44 +++++++++++++++++++++++++++++++++++------
>  1 file changed, 38 insertions(+), 6 deletions(-)
> 
> diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> index 9904299424a1..065345832a69 100644
> --- a/net/sched/cls_tcindex.c
> +++ b/net/sched/cls_tcindex.c
> @@ -11,6 +11,7 @@
>  #include <linux/skbuff.h>
>  #include <linux/errno.h>
>  #include <linux/slab.h>
> +#include <linux/refcount.h>
>  #include <net/act_api.h>
>  #include <net/netlink.h>
>  #include <net/pkt_cls.h>
> @@ -26,9 +27,12 @@
>  #define DEFAULT_HASH_SIZE	64	/* optimized for diffserv */
>  
>  
> +struct tcindex_data;
> +
>  struct tcindex_filter_result {
>  	struct tcf_exts		exts;
>  	struct tcf_result	res;
> +	struct tcindex_data	*p;
>  	struct rcu_work		rwork;
>  };
>  
> @@ -49,6 +53,7 @@ struct tcindex_data {
>  	u32 hash;		/* hash table size; 0 if undefined */
>  	u32 alloc_hash;		/* allocated size */
>  	u32 fall_through;	/* 0: only classify if explicit match */
> +	refcount_t refcnt;	/* a temporary refcnt for perfect hash */
>  	struct rcu_work rwork;
>  };
>  
> @@ -57,6 +62,20 @@ static inline int tcindex_filter_is_set(struct tcindex_filter_result *r)
>  	return tcf_exts_has_actions(&r->exts) || r->res.classid;
>  }
>  
> +static void tcindex_data_get(struct tcindex_data *p)
> +{
> +	refcount_inc(&p->refcnt);
> +}
> +
> +static void tcindex_data_put(struct tcindex_data *p)
> +{
> +	if (refcount_dec_and_test(&p->refcnt)) {
> +		kfree(p->perfect);
> +		kfree(p->h);
> +		kfree(p);
> +	}
> +}
> +
>  static struct tcindex_filter_result *tcindex_lookup(struct tcindex_data *p,
>  						    u16 key)
>  {
> @@ -141,6 +160,7 @@ static void __tcindex_destroy_rexts(struct tcindex_filter_result *r)
>  {
>  	tcf_exts_destroy(&r->exts);
>  	tcf_exts_put_net(&r->exts);
> +	tcindex_data_put(r->p);
>  }
>  
>  static void tcindex_destroy_rexts_work(struct work_struct *work)
> @@ -212,6 +232,8 @@ static int tcindex_delete(struct tcf_proto *tp, void *arg, bool *last,
>  		else
>  			__tcindex_destroy_fexts(f);
>  	} else {
> +		tcindex_data_get(p);

Good!  You need this one to prevent the counter prematurely reaching zero.

> +
>  		if (tcf_exts_get_net(&r->exts))
>  			tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
>  		else
> @@ -228,9 +250,7 @@ static void tcindex_destroy_work(struct work_struct *work)
>  					      struct tcindex_data,
>  					      rwork);
>  
> -	kfree(p->perfect);
> -	kfree(p->h);
> -	kfree(p);
> +	tcindex_data_put(p);

But what did you do to verify that the counter actually reaches zero?

>  }
>  
>  static inline int
> @@ -248,9 +268,11 @@ static const struct nla_policy tcindex_policy[TCA_TCINDEX_MAX + 1] = {
>  };
>  
>  static int tcindex_filter_result_init(struct tcindex_filter_result *r,
> +				      struct tcindex_data *p,
>  				      struct net *net)
>  {
>  	memset(r, 0, sizeof(*r));
> +	r->p = p;
>  	return tcf_exts_init(&r->exts, net, TCA_TCINDEX_ACT,
>  			     TCA_TCINDEX_POLICE);
>  }
> @@ -290,6 +312,7 @@ static int tcindex_alloc_perfect_hash(struct net *net, struct tcindex_data *cp)
>  				    TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
>  		if (err < 0)
>  			goto errout;
> +		cp->perfect[i].p = cp;
>  	}
>  
>  	return 0;
> @@ -334,6 +357,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  	cp->alloc_hash = p->alloc_hash;
>  	cp->fall_through = p->fall_through;
>  	cp->tp = tp;
> +	refcount_set(&cp->refcnt, 1); /* Paired with tcindex_destroy_work() */

The bit about checking that the counter reaches zero is underscored by the
apparent initialization to the value 1.

>  	if (tb[TCA_TCINDEX_HASH])
>  		cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);
> @@ -366,7 +390,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  	}
>  	cp->h = p->h;
>  
> -	err = tcindex_filter_result_init(&new_filter_result, net);
> +	err = tcindex_filter_result_init(&new_filter_result, cp, net);
>  	if (err < 0)
>  		goto errout_alloc;
>  	if (old_r)
> @@ -434,7 +458,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  			goto errout_alloc;
>  		f->key = handle;
>  		f->next = NULL;
> -		err = tcindex_filter_result_init(&f->result, net);
> +		err = tcindex_filter_result_init(&f->result, cp, net);
>  		if (err < 0) {
>  			kfree(f);
>  			goto errout_alloc;
> @@ -447,7 +471,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  	}
>  
>  	if (old_r && old_r != r) {
> -		err = tcindex_filter_result_init(old_r, net);
> +		err = tcindex_filter_result_init(old_r, cp, net);
>  		if (err < 0) {
>  			kfree(f);
>  			goto errout_alloc;
> @@ -571,6 +595,14 @@ static void tcindex_destroy(struct tcf_proto *tp, bool rtnl_held,
>  		for (i = 0; i < p->hash; i++) {
>  			struct tcindex_filter_result *r = p->perfect + i;
>  
> +			/* tcf_queue_work() does not guarantee the ordering we
> +			 * want, so we have to take this refcnt temporarily to
> +			 * ensure 'p' is freed after all tcindex_filter_result
> +			 * here. Imperfect hash does not need this, because it
> +			 * uses linked lists rather than an array.
> +			 */
> +			tcindex_data_get(p);
> +
>  			tcf_unbind_filter(tp, &r->res);
>  			if (tcf_exts_get_net(&r->exts))
>  				tcf_queue_work(&r->rwork,
> -- 
> 2.21.1
> 
