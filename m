Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D65856709
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 12:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbfFZKm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 06:42:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbfFZKm1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 06:42:27 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 92D51300BEA8;
        Wed, 26 Jun 2019 10:42:26 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96B6B1001B13;
        Wed, 26 Jun 2019 10:42:17 +0000 (UTC)
Date:   Wed, 26 Jun 2019 12:42:16 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     davem@davemloft.net, grygorii.strashko@ti.com, hawk@kernel.org,
        saeedm@mellanox.com, leon@kernel.org, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        xdp-newbies@vger.kernel.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        brouer@redhat.com
Subject: Re: [PATCH v4 net-next 1/4] net: core: page_pool: add user cnt
 preventing pool deletion
Message-ID: <20190626124216.494eee86@carbon>
In-Reply-To: <20190625175948.24771-2-ivan.khoronzhuk@linaro.org>
References: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org>
        <20190625175948.24771-2-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 26 Jun 2019 10:42:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 20:59:45 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> Add user counter allowing to delete pool only when no users.
> It doesn't prevent pool from flush, only prevents freeing the
> pool instance. Helps when no need to delete the pool and now
> it's user responsibility to free it by calling page_pool_free()
> while destroying procedure. It also makes to use page_pool_free()
> explicitly, not fully hidden in xdp unreg, which looks more
> correct after page pool "create" routine.

No, this is wrong.

> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 +++++---
>  include/net/page_pool.h                           | 7 +++++++
>  net/core/page_pool.c                              | 7 +++++++
>  net/core/xdp.c                                    | 3 +++
>  4 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 5e40db8f92e6..cb028de64a1d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -545,10 +545,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>  	}
>  	err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
>  					 MEM_TYPE_PAGE_POOL, rq->page_pool);
> -	if (err) {
> -		page_pool_free(rq->page_pool);
> +	if (err)
>  		goto err_free;
> -	}
>  
>  	for (i = 0; i < wq_sz; i++) {
>  		if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
> @@ -613,6 +611,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>  	if (rq->xdp_prog)
>  		bpf_prog_put(rq->xdp_prog);
>  	xdp_rxq_info_unreg(&rq->xdp_rxq);
> +	if (rq->page_pool)
> +		page_pool_free(rq->page_pool);
>  	mlx5_wq_destroy(&rq->wq_ctrl);
>  
>  	return err;
> @@ -643,6 +643,8 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
>  	}
>  
>  	xdp_rxq_info_unreg(&rq->xdp_rxq);
> +	if (rq->page_pool)
> +		page_pool_free(rq->page_pool);

No, this is wrong.  The hole point with the merged page_pool fixes
patchset was that page_pool_free() needs to be delayed until no-more
in-flight packets exist.


>  	mlx5_wq_destroy(&rq->wq_ctrl);
>  }
>  
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index f07c518ef8a5..1ec838e9927e 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -101,6 +101,7 @@ struct page_pool {
>  	struct ptr_ring ring;
>  
>  	atomic_t pages_state_release_cnt;
> +	atomic_t user_cnt;
>  };
>  
>  struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
> @@ -183,6 +184,12 @@ static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  	return page->dma_addr;
>  }
>  
> +/* used to prevent pool from deallocation */
> +static inline void page_pool_get(struct page_pool *pool)
> +{
> +	atomic_inc(&pool->user_cnt);
> +}
> +
>  static inline bool is_page_pool_compiled_in(void)
>  {
>  #ifdef CONFIG_PAGE_POOL
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index b366f59885c1..169b0e3c870e 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -48,6 +48,7 @@ static int page_pool_init(struct page_pool *pool,
>  		return -ENOMEM;
>  
>  	atomic_set(&pool->pages_state_release_cnt, 0);
> +	atomic_set(&pool->user_cnt, 0);
>  
>  	if (pool->p.flags & PP_FLAG_DMA_MAP)
>  		get_device(pool->p.dev);
> @@ -70,6 +71,8 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
>  		kfree(pool);
>  		return ERR_PTR(err);
>  	}
> +
> +	page_pool_get(pool);
>  	return pool;
>  }
>  EXPORT_SYMBOL(page_pool_create);
> @@ -356,6 +359,10 @@ static void __warn_in_flight(struct page_pool *pool)
>  
>  void __page_pool_free(struct page_pool *pool)
>  {
> +	/* free only if no users */
> +	if (!atomic_dec_and_test(&pool->user_cnt))
> +		return;
> +
>  	WARN(pool->alloc.count, "API usage violation");
>  	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
>  
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 829377cc83db..04bdcd784d2e 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -372,6 +372,9 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  
>  	mutex_unlock(&mem_id_lock);
>  
> +	if (type == MEM_TYPE_PAGE_POOL)
> +		page_pool_get(xdp_alloc->page_pool);
> +
>  	trace_mem_connect(xdp_alloc, xdp_rxq);
>  	return 0;
>  err:



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
