Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0621D60A18
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 18:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbfGEQT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 12:19:29 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36339 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbfGEQT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 12:19:27 -0400
Received: by mail-lj1-f195.google.com with SMTP id i21so9795919ljj.3
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 09:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r06zz3YlIXJJfqfOHxKfp8LTZDyCOLvN5vyfR0T3JUQ=;
        b=VORoCdvjx/RCcIVQDYp3bdHwMYz0sOji3VknJNJZIIThtKBcRH2PDbfvZl358Yt99c
         e2F9/uBgKbdwmBm7eZJ6AZTMQBC2qxmxLsJyqx28r7tvZOIg/rVu4mhLyo7N/s8zeK7g
         g+3OVQ3bPSBToZoihjBvG5UeKZ9AuzRO1lR46gqpqnbAgPVz8knKT+kJ3p/x//tDcOAz
         dRgDG2xQqx8q5ygIESFheUNKaAxbZdF7dIVf5ghHrkKGaQ1GH7AQqmx78fzxPe0yUGdZ
         W2wPiKiwt6Hw84HefPUoCIOXhIxaWpRQUFBGHdO6Nwl/eH76uHCQ2WbEEyM4yQg3Vno6
         MnYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r06zz3YlIXJJfqfOHxKfp8LTZDyCOLvN5vyfR0T3JUQ=;
        b=LHQtfuROf8adjuyEJDWaE+d2GcQnxSjd274y8KemNJUKf4w4/3fqGSMsqmjdX/6u8M
         lcUvCUM+Wv0agMJBOAoyjNt24rJBq4mIBbWehJ6ootzdf5QQg3IUIu4O7G3aQKGOBKKq
         hnjBvWQVN2uS08etm7uqHS5g1pkeGLKU0a6bIy3eqGiUaz/hiq0XP80dU7F1O0qp2XNq
         nVo3W1mLjla1zMro4jB9X3QR1/9k70kcay4APBqnIBztiVznvmiu5kH+3nFLjpEQ0Rp8
         XIc7pqoEbV0EX75aRnfnv8bwEnF4njNsXqQnaL8cy18DM3hY19K1br9iVnmIKb8tN18K
         AWSg==
X-Gm-Message-State: APjAAAVVOzprI9dj4ZUCuZQBUckWMhm1Roh3dnuKg5yr79MozP8aOjKS
        Oa5g++d30HiklyGIaVqRjnsk9e8rnlPG2btCDlbb0Q==
X-Google-Smtp-Source: APXvYqxV7jaGfm5Jd+nw9KlZRnfRRlGtY5yqzwobRUny3JfeKw2EWNUq0gwwctToUgP4DLiPPVDxwENwkErWBs/ha9o=
X-Received: by 2002:a2e:5d5a:: with SMTP id r87mr2630679ljb.196.1562343564331;
 Fri, 05 Jul 2019 09:19:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190704231406.27083-1-ivan.khoronzhuk@linaro.org>
 <20190704231406.27083-2-ivan.khoronzhuk@linaro.org> <20190705094346.13b06da6@carbon>
In-Reply-To: <20190705094346.13b06da6@carbon>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Fri, 5 Jul 2019 12:19:13 -0400
Message-ID: <CALzJLG_b9kQcBoqpTjuMCFaRzrYugsLjtNjEzhO0xZ9H7bWWjQ@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 1/5] net: core: page_pool: add user refcnt and
 reintroduce page_pool_destroy
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        grygorii.strashko@ti.com, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org, ilias.apalodimas@linaro.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 5, 2019 at 3:45 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
>
> CC: Tariq + Saeed, could you please review the mlx5 part.
>
> On Fri,  5 Jul 2019 02:14:02 +0300
> Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
> > Jesper recently removed page_pool_destroy() (from driver invocation)
> > and moved shutdown and free of page_pool into xdp_rxq_info_unreg(),
> > in-order to handle in-flight packets/pages. This created an asymmetry
> > in drivers create/destroy pairs.
> >
> > This patch reintroduce page_pool_destroy and add page_pool user
> > refcnt. This serves the purpose to simplify drivers error handling as
> > driver now drivers always calls page_pool_destroy() and don't need to
> > track if xdp_rxq_info_reg_mem_model() was unsuccessful.
> >
> > This could be used for a special cases where a single RX-queue (with a
> > single page_pool) provides packets for two net_device'es, and thus
> > needs to register the same page_pool twice with two xdp_rxq_info
> > structures.
> >
> > This patch is primarily to ease API usage for drivers. The recently
> > merged netsec driver, actually have a bug in this area, which is
> > solved by this API change.
> >

This patch and the mlx5 part looks good to me,
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>

> > This patch is a modified version of Ivan Khoronzhu's original patch.
> >
> > Link: https://lore.kernel.org/netdev/20190625175948.24771-2-ivan.khoronzhuk@linaro.org/
> > Fixes: 5c67bf0ec4d0 ("net: netsec: Use page_pool API")
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
> Thank you Ivan for taking this more simple approach.  If we later see
> more drivers wanting this feature of a single RX-queue providing
> packets to multiple net_device'es, then we can change into your
> more generic API at XDP-reg-layer approach later.  For now, we keep
> code complexity as low as possible.
>
>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +--
> >  drivers/net/ethernet/socionext/netsec.c       |  8 ++----
> >  include/net/page_pool.h                       | 25 +++++++++++++++++++
> >  net/core/page_pool.c                          |  8 ++++++
> >  net/core/xdp.c                                |  3 +++
> >  5 files changed, 40 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > index 2f9093ba82aa..ac882b2341d0 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -575,8 +575,6 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
> >               }
> >               err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
> >                                                MEM_TYPE_PAGE_POOL, rq->page_pool);
> > -             if (err)
> > -                     page_pool_free(rq->page_pool);
> >       }
> >       if (err)
> >               goto err_free;
> > @@ -644,6 +642,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
> >       if (rq->xdp_prog)
> >               bpf_prog_put(rq->xdp_prog);
> >       xdp_rxq_info_unreg(&rq->xdp_rxq);
> > +     page_pool_destroy(rq->page_pool);
> >       mlx5_wq_destroy(&rq->wq_ctrl);
> >
> >       return err;
> > @@ -678,6 +677,7 @@ static void mlx5e_free_rq(struct mlx5e_rq *rq)
> >       }
> >
> >       xdp_rxq_info_unreg(&rq->xdp_rxq);
> > +     page_pool_destroy(rq->page_pool);
> >       mlx5_wq_destroy(&rq->wq_ctrl);
> >  }
> >
> > diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> > index 5544a722543f..43ab0ce90704 100644
> > --- a/drivers/net/ethernet/socionext/netsec.c
> > +++ b/drivers/net/ethernet/socionext/netsec.c
> > @@ -1210,15 +1210,11 @@ static void netsec_uninit_pkt_dring(struct netsec_priv *priv, int id)
> >               }
> >       }
> >
> > -     /* Rx is currently using page_pool
> > -      * since the pool is created during netsec_setup_rx_dring(), we need to
> > -      * free the pool manually if the registration failed
> > -      */
> > +     /* Rx is currently using page_pool */
> >       if (id == NETSEC_RING_RX) {
> >               if (xdp_rxq_info_is_reg(&dring->xdp_rxq))
> >                       xdp_rxq_info_unreg(&dring->xdp_rxq);
> > -             else
> > -                     page_pool_free(dring->page_pool);
> > +             page_pool_destroy(dring->page_pool);
> >       }
> >
> >       memset(dring->desc, 0, sizeof(struct netsec_desc) * DESC_NUM);
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index ee9c871d2043..2cbcdbdec254 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -101,6 +101,12 @@ struct page_pool {
> >       struct ptr_ring ring;
> >
> >       atomic_t pages_state_release_cnt;
> > +
> > +     /* A page_pool is strictly tied to a single RX-queue being
> > +      * protected by NAPI, due to above pp_alloc_cache. This
> > +      * refcnt serves purpose is to simplify drivers error handling.
> > +      */
> > +     refcount_t user_cnt;
> >  };
> >
> >  struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp);
> > @@ -134,6 +140,15 @@ static inline void page_pool_free(struct page_pool *pool)
> >  #endif
> >  }
> >
> > +/* Drivers use this instead of page_pool_free */
> > +static inline void page_pool_destroy(struct page_pool *pool)
> > +{
> > +     if (!pool)
> > +             return;
> > +
> > +     page_pool_free(pool);
> > +}
> > +
> >  /* Never call this directly, use helpers below */
> >  void __page_pool_put_page(struct page_pool *pool,
> >                         struct page *page, bool allow_direct);
> > @@ -201,4 +216,14 @@ static inline bool is_page_pool_compiled_in(void)
> >  #endif
> >  }
> >
> > +static inline void page_pool_get(struct page_pool *pool)
> > +{
> > +     refcount_inc(&pool->user_cnt);
> > +}
> > +
> > +static inline bool page_pool_put(struct page_pool *pool)
> > +{
> > +     return refcount_dec_and_test(&pool->user_cnt);
> > +}
> > +
> >  #endif /* _NET_PAGE_POOL_H */
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index b366f59885c1..3272dc7a8c81 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -49,6 +49,9 @@ static int page_pool_init(struct page_pool *pool,
> >
> >       atomic_set(&pool->pages_state_release_cnt, 0);
> >
> > +     /* Driver calling page_pool_create() also call page_pool_destroy() */
> > +     refcount_set(&pool->user_cnt, 1);
> > +
> >       if (pool->p.flags & PP_FLAG_DMA_MAP)
> >               get_device(pool->p.dev);
> >
> > @@ -70,6 +73,7 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
> >               kfree(pool);
> >               return ERR_PTR(err);
> >       }
> > +
> >       return pool;
> >  }
> >  EXPORT_SYMBOL(page_pool_create);
> > @@ -356,6 +360,10 @@ static void __warn_in_flight(struct page_pool *pool)
> >
> >  void __page_pool_free(struct page_pool *pool)
> >  {
> > +     /* Only last user actually free/release resources */
> > +     if (!page_pool_put(pool))
> > +             return;
> > +
> >       WARN(pool->alloc.count, "API usage violation");
> >       WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
> >
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 829377cc83db..d7bf62ffbb5e 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -370,6 +370,9 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
> >               goto err;
> >       }
> >
> > +     if (type == MEM_TYPE_PAGE_POOL)
> > +             page_pool_get(xdp_alloc->page_pool);
> > +
> >       mutex_unlock(&mem_id_lock);
> >
> >       trace_mem_connect(xdp_alloc, xdp_rxq);
>
>
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
