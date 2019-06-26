Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E5F567EC
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 13:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfFZLvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 07:51:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZLvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 07:51:39 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C4963308FE8D;
        Wed, 26 Jun 2019 11:51:38 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 217C96012E;
        Wed, 26 Jun 2019 11:51:30 +0000 (UTC)
Date:   Wed, 26 Jun 2019 13:51:28 +0200
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
Message-ID: <20190626135128.5724f40e@carbon>
In-Reply-To: <20190626104948.GF6485@khorivan>
References: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org>
        <20190625175948.24771-2-ivan.khoronzhuk@linaro.org>
        <20190626124216.494eee86@carbon>
        <20190626104948.GF6485@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 26 Jun 2019 11:51:39 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 13:49:49 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> On Wed, Jun 26, 2019 at 12:42:16PM +0200, Jesper Dangaard Brouer wrote:
> >On Tue, 25 Jun 2019 20:59:45 +0300
> >Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
> >  
> >> Add user counter allowing to delete pool only when no users.
> >> It doesn't prevent pool from flush, only prevents freeing the
> >> pool instance. Helps when no need to delete the pool and now
> >> it's user responsibility to free it by calling page_pool_free()
> >> while destroying procedure. It also makes to use page_pool_free()
> >> explicitly, not fully hidden in xdp unreg, which looks more
> >> correct after page pool "create" routine.  
> >
> >No, this is wrong.  
> below.
> 
> >  
> >> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >> ---
> >>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 +++++---
> >>  include/net/page_pool.h                           | 7 +++++++
> >>  net/core/page_pool.c                              | 7 +++++++
> >>  net/core/xdp.c                                    | 3 +++
> >>  4 files changed, 22 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> >> index 5e40db8f92e6..cb028de64a1d 100644
> >> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> >> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> >> @@ -545,10 +545,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
> >>  	}
> >>  	err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
> >>  					 MEM_TYPE_PAGE_POOL, rq->page_pool);
> >> -	if (err) {
> >> -		page_pool_free(rq->page_pool);
> >> +	if (err)
> >>  		goto err_free;
> >> -	}
> >>
> >>  	for (i = 0; i < wq_sz; i++) {
> >>  		if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
> >> @@ -613,6 +611,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
> >>  	if (rq->xdp_prog)
> >>  		bpf_prog_put(rq->xdp_prog);
> >>  	xdp_rxq_info_unreg(&rq->xdp_rxq);
> >> +	if (rq->page_pool)
> >> +		page_pool_free(rq->page_pool);
> >>  	mlx5_wq_destroy(&rq->wq_ctrl);
> >>
> >>  	return err;
> >> @@ -643,6 +643,8 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
> >>  	}
> >>
> >>  	xdp_rxq_info_unreg(&rq->xdp_rxq);
> >> +	if (rq->page_pool)
> >> +		page_pool_free(rq->page_pool);  
> >
> >No, this is wrong.  The hole point with the merged page_pool fixes
> >patchset was that page_pool_free() needs to be delayed until no-more
> >in-flight packets exist.  
> 
> Probably it's not so obvious, but it's still delayed and deleted only
> after no-more in-flight packets exist. Here question is only who is able
> to do this first based on refcnt.

Hmm... then I find this API is rather misleading, even the function
name page_pool_free is misleading ("free"). (Now, I do see, below, that
page_pool_create() take an extra reference).

But it is still wrong / problematic.  As you allow
__page_pool_request_shutdown() to be called with elevated refcnt.  Your
use-case is to have more than 1 xdp_rxq_info struct using the same
page_pool.  Then you have to call xdp_rxq_info_unreg_mem_model() for
each, which will call __page_pool_request_shutdown().

For this to be safe, your driver have to stop RX for all the
xdp_rxq_info structs that share the page_pool.  The page_pool already
have this requirement, but it comes as natural step when shutting down
an RXQ.  With your change, you have to take care of stopping the RXQs
first, and then call xdp_rxq_info_unreg_mem_model() for each
xdp_rxq_info afterwards.  I assume you do this, but it is just a driver
bug waiting to happen.


> >> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> >> index b366f59885c1..169b0e3c870e 100644
> >> --- a/net/core/page_pool.c
> >> +++ b/net/core/page_pool.c
[...]
> >> @@ -70,6 +71,8 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
> >>  		kfree(pool);
> >>  		return ERR_PTR(err);
> >>  	}
> >> +
> >> +	page_pool_get(pool);
> >>  	return pool;
> >>  }
> >>  EXPORT_SYMBOL(page_pool_create);

The thing (perhaps) like about your API change, is that you also allow
the driver to explicitly keep the page_pool object across/after a
xdp_rxq_info_unreg_mem_model().  And this way possibly reuse it for
another RXQ.  The problem is of-cause that on driver shutdown, this
will force drivers to implement the same shutdown logic with
schedule_delayed_work as the core xdp.c code already does.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
