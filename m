Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB1665D20C
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfGBOrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:47:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbfGBOrA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 10:47:00 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4BA9B300DA2B;
        Tue,  2 Jul 2019 14:46:59 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBDA91001DDC;
        Tue,  2 Jul 2019 14:46:50 +0000 (UTC)
Date:   Tue, 2 Jul 2019 16:46:48 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v5 net-next 1/6] xdp: allow same allocator usage
Message-ID: <20190702164648.56ff0761@carbon>
In-Reply-To: <20190702102700.GA4510@khorivan>
References: <20190630172348.5692-1-ivan.khoronzhuk@linaro.org>
        <20190630172348.5692-2-ivan.khoronzhuk@linaro.org>
        <20190701134059.71757892@carbon>
        <20190702102700.GA4510@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 02 Jul 2019 14:46:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jul 2019 13:27:07 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> On Mon, Jul 01, 2019 at 01:40:59PM +0200, Jesper Dangaard Brouer wrote:
> >
> >I'm very skeptical about this approach.
> >
> >On Sun, 30 Jun 2019 20:23:43 +0300
> >Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
> >  
> >> XDP rxqs can be same for ndevs running under same rx napi softirq.
> >> But there is no ability to register same allocator for both rxqs,
> >> by fact it can same rxq but has different ndev as a reference.  
> >
> >This description is not very clear. It can easily be misunderstood.
> >
> >It is an absolute requirement that each RX-queue have their own
> >page_pool object/allocator. (This where the performance comes from) as
> >the page_pool have NAPI protected array for alloc and XDP_DROP recycle.
> >
> >Your driver/hardware seems to have special case, where a single
> >RX-queue can receive packets for two different net_device'es.
> >
> >Do you violate this XDP devmap redirect assumption[1]?
> >[1] https://github.com/torvalds/linux/blob/v5.2-rc7/kernel/bpf/devmap.c#L324-L329  
> Seems that yes, but that's used only for trace for now.
> As it runs under napi and flush clear dev_rx i must do it right in the
> rx_handler. So next patchset version will have one patch less.
> 
> Thanks!
> 
> >
> >  
> >> Due to last changes allocator destroy can be defered till the moment
> >> all packets are recycled by destination interface, afterwards it's
> >> freed. In order to schedule allocator destroy only after all users are
> >> unregistered, add refcnt to allocator object and schedule to destroy
> >> only it reaches 0.  
> >
> >The guiding principles when designing an API, is to make it easy to
> >use, but also make it hard to misuse.
> >
> >Your API change makes it easy to misuse the API.  As it make it easy to
> >(re)use the allocator pointer (likely page_pool) for multiple
> >xdp_rxq_info structs.  It is only valid for your use-case, because you
> >have hardware where a single RX-queue delivers to two different
> >net_devices.  For other normal use-cases, this will be a violation.
> >
> >If I was a user of this API, and saw your xdp_allocator_get(), then I
> >would assume that this was the normal case.  As minimum, we need to add
> >a comment in the code, about this specific/intended use-case.  I
> >through about detecting the misuse, by adding a queue_index to
> >xdp_mem_allocator, that can be checked against, when calling
> >xdp_rxq_info_reg_mem_model() with another xdp_rxq_info struct (to catch
> >the obvious mistake where queue_index mismatch).  
> 
> I can add, but not sure if it has or can have some conflicts with another
> memory allocators, now or in future. Main here to not became a cornerstone
> in some not obvious use-cases.
> 
> So, for now, let it be in this way:
> 
> --- a/include/net/xdp_priv.h
> +++ b/include/net/xdp_priv.h
> @@ -19,6 +19,7 @@ struct xdp_mem_allocator {
>         struct delayed_work defer_wq;
>         unsigned long defer_warn;
>         unsigned long refcnt;
> +       u32 queue_index;
>  };
> 
>  #endif /* __LINUX_NET_XDP_PRIV_H__ */
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index a44621190fdc..c4bf29810f4d 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -324,7 +324,7 @@ static bool __is_supported_mem_type(enum xdp_mem_type type)
>         return true;
>  }
> 
> -static struct xdp_mem_allocator *xdp_allocator_get(void *allocator)
> +static struct xdp_mem_allocator *xdp_allocator_find(void *allocator)
>  {
>         struct xdp_mem_allocator *xae, *xa = NULL;
>         struct rhashtable_iter iter;
> @@ -336,7 +336,6 @@ static struct xdp_mem_allocator *xdp_allocator_get(void *allocator)
> 
>                 while ((xae = rhashtable_walk_next(&iter)) && !IS_ERR(xae)) {
>                         if (xae->allocator == allocator) {
> -                               xae->refcnt++;
>                                 xa = xae;
>                                 break;
>                         }
> @@ -386,9 +385,13 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>                 }
>         }
> 
> -       xdp_alloc = xdp_allocator_get(allocator);
> +       xdp_alloc = xdp_allocator_find(allocator);
>         if (xdp_alloc) {
> +               if (xdp_alloc->queue_index != xdp_rxq->queue_index)
> +                       return -EINVAL;
> +
>                 xdp_rxq->mem.id = xdp_alloc->mem.id;
> +               xdp_alloc->refcnt++;

This is now adjusted outside lock, not good.

>                 return 0;
>         }
> 
> @@ -406,6 +409,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>         xdp_alloc->mem  = xdp_rxq->mem;
>         xdp_alloc->allocator = allocator;
>         xdp_alloc->refcnt = 1;
> +       xdp_alloc->queue_index = xdp_rxq->queue_index;
> 
>         /* Insert allocator into ID lookup table */
>         ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);
> 
> Jesper, are you Ok with this version?

Please see my other patch, this is based on our first refcnt attempt.
I think that other patch is a better way forward.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
