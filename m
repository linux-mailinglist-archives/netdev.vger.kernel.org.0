Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647CC5F857
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfGDMl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:41:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56538 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727117AbfGDMl4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 08:41:56 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CED41308FC20;
        Thu,  4 Jul 2019 12:41:53 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C72E218666;
        Thu,  4 Jul 2019 12:41:45 +0000 (UTC)
Date:   Thu, 4 Jul 2019 14:41:44 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        brouer@redhat.com
Subject: Re: [PATCH v6 net-next 1/5] xdp: allow same allocator usage
Message-ID: <20190704144144.5edd18eb@carbon>
In-Reply-To: <20190704102239.GA3406@khorivan>
References: <20190703101903.8411-1-ivan.khoronzhuk@linaro.org>
        <20190703101903.8411-2-ivan.khoronzhuk@linaro.org>
        <20190703194013.02842e42@carbon>
        <20190704102239.GA3406@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 04 Jul 2019 12:41:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Jul 2019 13:22:40 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> On Wed, Jul 03, 2019 at 07:40:13PM +0200, Jesper Dangaard Brouer wrote:
> >On Wed,  3 Jul 2019 13:18:59 +0300
> >Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
> >  
> >> First of all, it is an absolute requirement that each RX-queue have
> >> their own page_pool object/allocator. And this change is intendant
> >> to handle special case, where a single RX-queue can receive packets
> >> from two different net_devices.
> >>
> >> In order to protect against using same allocator for 2 different rx
> >> queues, add queue_index to xdp_mem_allocator to catch the obvious
> >> mistake where queue_index mismatch, as proposed by Jesper Dangaard
> >> Brouer.
> >>
> >> Adding this on xdp allocator level allows drivers with such dependency
> >> change the allocators w/o modifications.
> >>
> >> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >> ---
> >>  include/net/xdp_priv.h |  2 ++
> >>  net/core/xdp.c         | 55 ++++++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 57 insertions(+)
> >>
> >> diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
> >> index 6a8cba6ea79a..9858a4057842 100644
> >> --- a/include/net/xdp_priv.h
> >> +++ b/include/net/xdp_priv.h
> >> @@ -18,6 +18,8 @@ struct xdp_mem_allocator {
> >>  	struct rcu_head rcu;
> >>  	struct delayed_work defer_wq;
> >>  	unsigned long defer_warn;
> >> +	unsigned long refcnt;
> >> +	u32 queue_index;
> >>  };  
> >
> >I don't like this approach, because I think we need to extend struct
> >xdp_mem_allocator with a net_device pointer, for doing dev_hold(), to
> >correctly handle lifetime issues. (As I tried to explain previously).
> >This will be much harder after this change, which is why I proposed the
> >other patch.  
> My concern comes not from zero also.
> It's partly continuation of not answered questions from here:
> https://lwn.net/ml/netdev/20190625122822.GC6485@khorivan/
> 
> "For me it's important to know only if it means that alloc.count is
> freed at first call of __mem_id_disconnect() while shutdown.
> The workqueue for the rest is connected only with ring cache protected
> by ring lock and not supposed that alloc.count can be changed while
> workqueue tries to shutdonwn the pool."

Yes.  The alloc.count is only freed on first call.  I considered
changing the shutdown API, to have two shutdown calls, where the call
used from the work-queue will not have the loop emptying alloc.count,
but instead have a WARN_ON(alloc.count), as it MUST be empty (once is
code running from work-queue).

> So patch you propose to leave works only because of luck, because fast
> cache is cleared before workqueue is scheduled and no races between two
> workqueues for fast cache later. I'm not really against this patch, but
> I have to try smth better.

It is not "luck".  It does the correct thing as we never enter the
while loop in __page_pool_request_shutdown() from a work-queue, but it
is not obvious from the code.  The not-so-nice thing is that two
work-queue shutdowns will be racing with each-other, in the multi
netdev use-case, but access to the ptr_ring is safe/locked.


> So, the patch is fine only because of specific of page_pool implementation.
> I'm not sure that in future similar workqueue completion will be lucky for
> another allocator (it easily can happen due to xdp frame can live longer
> than an allocator). Similar problem can happen with other drivers having
> same allocator, that can use zca (potentially can use smth similar),
> af_xdp api allows to switch on it or some other allocators....
> 
> But not the essence. The concern about adding smth new to the allocator
> later, like net device, can be solved with a little modification to the patch,
> (despite here can be several more approaches) for instance, like this:
> (by fact it's still the same, when mem_alloc instance per each register call
> but with same void *allocator)

Okay, below you have demonstrated that it is possible to extend later,
although it will make the code (IMHO) "ugly" and more complicated...
So, I guess, I cannot object to this not being extensible.

 
> diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
> index 6a8cba6ea79a..c7ad0f41e1b0 100644
> --- a/include/net/xdp_priv.h
> +++ b/include/net/xdp_priv.h
> @@ -18,6 +18,8 @@ struct xdp_mem_allocator {
>  	struct rcu_head rcu;
>  	struct delayed_work defer_wq;
>  	unsigned long defer_warn;
> +	unsigned long *refcnt;
> +	u32 queue_index;
>  };
>  
>  #endif /* __LINUX_NET_XDP_PRIV_H__ */
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 829377cc83db..a44e3e4c8307 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -64,9 +64,37 @@ static const struct rhashtable_params mem_id_rht_params = {
>  	.obj_cmpfn = xdp_mem_id_cmp,
>  };
>  
> +static struct xdp_mem_allocator *xdp_allocator_find(void *allocator)
> +{
> +	struct xdp_mem_allocator *xae, *xa = NULL;
> +	struct rhashtable_iter iter;
> +
> +	if (!allocator)
> +		return xa;
> +
> +	rhashtable_walk_enter(mem_id_ht, &iter);
> +	do {
> +		rhashtable_walk_start(&iter);
> +
> +		while ((xae = rhashtable_walk_next(&iter)) && !IS_ERR(xae)) {
> +			if (xae->allocator == allocator) {
> +				xa = xae;
> +				break;
> +			}
> +		}
> +
> +		rhashtable_walk_stop(&iter);
> +
> +	} while (xae == ERR_PTR(-EAGAIN));
> +	rhashtable_walk_exit(&iter);
> +
> +	return xa;
> +}
> +
>  static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
>  {
>  	struct xdp_mem_allocator *xa;
> +	void *allocator;
>  
>  	xa = container_of(rcu, struct xdp_mem_allocator, rcu);
>  
> @@ -74,15 +102,27 @@ static void __xdp_mem_allocator_rcu_free(struct rcu_head *rcu)
>  	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
>  		page_pool_free(xa->page_pool);
>  
> -	/* Allow this ID to be reused */
> -	ida_simple_remove(&mem_id_pool, xa->mem.id);
> +	kfree(xa->refcnt);
> +	allocator = xa->allocator;
> +	while (xa) {
> +		xa = xdp_allocator_find(allocator);
> +		if (!xa)
> +			break;
> +
> +		mutex_lock(&mem_id_lock);
> +		rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params);
> +		mutex_unlock(&mem_id_lock);
>  
> -	/* Poison memory */
> -	xa->mem.id = 0xFFFF;
> -	xa->mem.type = 0xF0F0;
> -	xa->allocator = (void *)0xDEAD9001;
> +		/* Allow this ID to be reused */
> +		ida_simple_remove(&mem_id_pool, xa->mem.id);
>  
> -	kfree(xa);
> +		/* Poison memory */
> +		xa->mem.id = 0xFFFF;
> +		xa->mem.type = 0xF0F0;
> +		xa->allocator = (void *)0xDEAD9001;
> +
> +		kfree(xa);
> +	}
>  }
>  
>  static bool __mem_id_disconnect(int id, bool force)
> @@ -98,6 +138,18 @@ static bool __mem_id_disconnect(int id, bool force)
>  		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
>  		return true;
>  	}
> +
> +	/* to avoid calling hash lookup twice, decrement refcnt here till it
> +	 * reaches zero, then it can be called from workqueue afterwards.
> +	 */
> +	if (*xa->refcnt)
> +		(*xa->refcnt)--;
> +
> +	if (*xa->refcnt) {
> +		mutex_unlock(&mem_id_lock);
> +		return true;
> +	}
> +
>  	xa->disconnect_cnt++;
>  
>  	/* Detects in-flight packet-pages for page_pool */
> @@ -106,8 +158,7 @@ static bool __mem_id_disconnect(int id, bool force)
>  
>  	trace_mem_disconnect(xa, safe_to_remove, force);
>  
> -	if ((safe_to_remove || force) &&
> -	    !rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
> +	if (safe_to_remove || force)
>  		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
>  
>  	mutex_unlock(&mem_id_lock);
> @@ -316,6 +367,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  			       enum xdp_mem_type type, void *allocator)
>  {
>  	struct xdp_mem_allocator *xdp_alloc;
> +	unsigned long *refcnt = NULL;
>  	gfp_t gfp = GFP_KERNEL;
>  	int id, errno, ret;
>  	void *ptr;
> @@ -347,6 +399,19 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  		}
>  	}
>  
> +	mutex_lock(&mem_id_lock);
> +	xdp_alloc = xdp_allocator_find(allocator);
> +	if (xdp_alloc) {
> +		/* One allocator per queue is supposed only */
> +		if (xdp_alloc->queue_index != xdp_rxq->queue_index) {
> +			mutex_unlock(&mem_id_lock);
> +			return -EINVAL;
> +		}
> +
> +		refcnt = xdp_alloc->refcnt;
> +	}
> +	mutex_unlock(&mem_id_lock);
> +
>  	xdp_alloc = kzalloc(sizeof(*xdp_alloc), gfp);
>  	if (!xdp_alloc)
>  		return -ENOMEM;
> @@ -360,6 +425,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  	xdp_rxq->mem.id = id;
>  	xdp_alloc->mem  = xdp_rxq->mem;
>  	xdp_alloc->allocator = allocator;
> +	xdp_alloc->queue_index = xdp_rxq->queue_index;
>  
>  	/* Insert allocator into ID lookup table */
>  	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);
> @@ -370,6 +436,16 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  		goto err;
>  	}
>  
> +	if (!refcnt) {
> +		refcnt = kzalloc(sizeof(*xdp_alloc->refcnt), gfp);
> +		if (!refcnt) {
> +			errno = -ENOMEM;
> +			goto err;
> +		}
> +	}
> +
> +	(*refcnt)++;
> +	xdp_alloc->refcnt = refcnt;
>  	mutex_unlock(&mem_id_lock);
>  
>  	trace_mem_connect(xdp_alloc, xdp_rxq);
> 
 

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
