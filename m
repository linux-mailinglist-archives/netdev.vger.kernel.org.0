Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F8B5943F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 08:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfF1Gfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 02:35:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbfF1Gfi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 02:35:38 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9138383F3B;
        Fri, 28 Jun 2019 06:35:32 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 432965D705;
        Fri, 28 Jun 2019 06:35:22 +0000 (UTC)
Date:   Fri, 28 Jun 2019 08:35:20 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     davem@davemloft.net, grygorii.strashko@ti.com, saeedm@mellanox.com,
        leon@kernel.org, ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        brouer@redhat.com
Subject: Re: [PATCH v4 net-next 1/4] net: core: page_pool: add user cnt
 preventing pool deletion
Message-ID: <20190628083520.4203cb41@carbon>
In-Reply-To: <20190627220245.GA3269@khorivan>
References: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org>
        <20190625175948.24771-2-ivan.khoronzhuk@linaro.org>
        <20190627214317.237e5926@carbon>
        <20190627220245.GA3269@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 28 Jun 2019 06:35:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 01:02:47 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> Hi Jesper, thanks you remember about it.
> 
> >
> >I don't think that "create" and "free" routines paring looks "more
> >correct" together.
> >
> >Maybe we can scale back your solution(?), via creating a page_pool_get()
> >and page_pool_put() API that can be used by your driver, to keep the
> >page_pool object after a xdp_rxq_info_unreg() call.  Then you can use
> >it for two xdp_rxq_info structs, and call page_pool_put() after you
> >have unregistered both.
> >
> >The API would basically be:
> >
> >diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> >index b366f59885c1..691ddacfb5a6 100644
> >--- a/net/core/page_pool.c
> >+++ b/net/core/page_pool.c
> >@@ -357,6 +357,10 @@ static void __warn_in_flight(struct page_pool *pool)
> > void __page_pool_free(struct page_pool *pool)
> > {
> >        WARN(pool->alloc.count, "API usage violation");
> >+
> >+       if (atomic_read(&pool->user_cnt) != 0)
> >+               return;
> >+
> >        WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
> >
> >        /* Can happen due to forced shutdown */
> >@@ -372,6 +376,19 @@ void __page_pool_free(struct page_pool *pool)
> > }
> > EXPORT_SYMBOL(__page_pool_free);
> >
> >+void page_pool_put(struct page_pool *pool)
> >+{
> >+       if (!atomic_dec_and_test(&pool->user_cnt))
> >+               __page_pool_free(pool);
> >+}
> >+EXPORT_SYMBOL(page_pool_put);
> >+
> >+void page_pool_get(struct page_pool *pool)
> >+{
> >+       atomic_inc(&pool->user_cnt);
> >+}
> >+EXPORT_SYMBOL(page_pool_get);
> >+  
> 
> I have another solution that doesn't touch page pool and adds modifications
> to xdp allocator. As for me it looks better and work wider, I don't need to
> think about this in the driver also.
> 
> It's supposed allocator works as before, no any changes to mlx5 and
> page_pool API and its usage and seems like fits your requirements.
> It still supposes that allocator runs under same napi softirq but allows
> to reuse allocator.
> 
> I have not verified yet, but looks like:
> 
> diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
> index 6a8cba6ea79a..995b21da2f27 100644
> --- a/include/net/xdp_priv.h
> +++ b/include/net/xdp_priv.h
> @@ -18,6 +18,7 @@ struct xdp_mem_allocator {
>  	struct rcu_head rcu;
>  	struct delayed_work defer_wq;
>  	unsigned long defer_warn;
> +	unsigned long refcnt;
>  };
>  
>  #endif /* __LINUX_NET_XDP_PRIV_H__ */
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index f98ab6b98674..6239483e3793 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -98,6 +98,12 @@ static bool __mem_id_disconnect(int id, bool force)
>  		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
>  		return true;
>  	}
> +
> +	if (--xa->refcnt) {
> +		mutex_unlock(&mem_id_lock);
> +		return true;

This doesn't work.  This function __mem_id_disconnect() can be called
multiple times. E.g. if there are in-flight packets.


> +	}
> +
>  	xa->disconnect_cnt++;
>  
>  	/* Detects in-flight packet-pages for page_pool */
> @@ -312,6 +318,33 @@ static bool __is_supported_mem_type(enum xdp_mem_type type)
>  	return true;
>  }
>  
> +static struct xdp_mem_allocator *xdp_allocator_get(void *allocator)
> +{
> +	struct xdp_mem_allocator *xae, *xa == NULL;
> +	struct rhashtable_iter iter;
> +
> +	mutex_lock(&mem_id_lock);
> +	rhashtable_walk_enter(mem_id_ht, &iter);
> +	do {
> +		rhashtable_walk_start(&iter);
> +
> +		while ((xae = rhashtable_walk_next(&iter)) && !IS_ERR(xae)) {
> +			if (xae->allocator == allocator) {
> +				xae->refcnt++;
> +				xa = xae;
> +				break;
> +			}
> +		}
> +
> +		rhashtable_walk_stop(&iter);
> +
> +	} while (xae == ERR_PTR(-EAGAIN));
> +	rhashtable_walk_exit(&iter);
> +	mutex_unlock(&mem_id_lock);
> +
> +	return xa;
> +}
> +
>  int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  			       enum xdp_mem_type type, void *allocator)
>  {
> @@ -347,6 +380,9 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  		}
>  	}
>  
> +	if (xdp_allocator_get(allocator))
> +		return 0;
> +
>  	xdp_alloc = kzalloc(sizeof(*xdp_alloc), gfp);
>  	if (!xdp_alloc)
>  		return -ENOMEM;
> @@ -360,6 +396,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  	xdp_rxq->mem.id = id;
>  	xdp_alloc->mem  = xdp_rxq->mem;
>  	xdp_alloc->allocator = allocator;
> +	xdp_alloc->refcnt = 1;
>  
>  	/* Insert allocator into ID lookup table */
>  	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);
> 
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
