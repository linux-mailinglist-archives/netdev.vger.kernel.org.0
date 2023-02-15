Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9AA6973EA
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 02:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjBOBwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 20:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbjBOBvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 20:51:52 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B622ED5D;
        Tue, 14 Feb 2023 17:51:43 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VbhxXaA_1676425900;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VbhxXaA_1676425900)
          by smtp.aliyun-inc.com;
          Wed, 15 Feb 2023 09:51:40 +0800
Message-ID: <1676425701.9314106-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next v3] xsk: support use vaddr as ring
Date:   Wed, 15 Feb 2023 09:48:21 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20230214015112.12094-1-xuanzhuo@linux.alibaba.com>
 <3cfe3c9b-1c8c-363c-6dcb-343cabc2f369@intel.com>
In-Reply-To: <3cfe3c9b-1c8c-363c-6dcb-343cabc2f369@intel.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Feb 2023 15:45:12 +0100, Alexander Lobakin <alexandr.lobakin@intel.com> wrote:
> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Date: Tue, 14 Feb 2023 09:51:12 +0800
>
> > When we try to start AF_XDP on some machines with long running time, due
> > to the machine's memory fragmentation problem, there is no sufficient
> > contiguous physical memory that will cause the start failure.
>
> [...]
>
> > @@ -1319,13 +1317,10 @@ static int xsk_mmap(struct file *file, struct socket *sock,
> >
> >  	/* Matches the smp_wmb() in xsk_init_queue */
> >  	smp_rmb();
> > -	qpg = virt_to_head_page(q->ring);
> > -	if (size > page_size(qpg))
> > +	if (size > PAGE_ALIGN(q->ring_size))
>
> You can set q->ring_size as PAGE_ALIGN(size) already at the allocation
> to simplify this. I don't see any other places where you use it.

That's it, but I think it is not particularly appropriate to change the
the semantics of ring_size just for simplify this code. This may make
people feel strange.

I agree with you other opinions.

Thanks.


>
> >  		return -EINVAL;
> >
> > -	pfn = virt_to_phys(q->ring) >> PAGE_SHIFT;
> > -	return remap_pfn_range(vma, vma->vm_start, pfn,
> > -			       size, vma->vm_page_prot);
> > +	return remap_vmalloc_range(vma, q->ring, 0);
> >  }
> >
> >  static int xsk_notifier(struct notifier_block *this,
> > diff --git a/net/xdp/xsk_queue.c b/net/xdp/xsk_queue.c
> > index 6cf9586e5027..247316bdfcbe 100644
> > --- a/net/xdp/xsk_queue.c
> > +++ b/net/xdp/xsk_queue.c
> > @@ -7,6 +7,7 @@
> >  #include <linux/slab.h>
> >  #include <linux/overflow.h>
> >  #include <net/xdp_sock_drv.h>
> > +#include <linux/vmalloc.h>
>
> Alphabetic order maybe?
>
> >
> >  #include "xsk_queue.h"
> >
> > @@ -23,7 +24,6 @@ static size_t xskq_get_ring_size(struct xsk_queue *q, bool umem_queue)
> >  struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
> >  {
> >  	struct xsk_queue *q;
> > -	gfp_t gfp_flags;
> >  	size_t size;
> >
> >  	q = kzalloc(sizeof(*q), GFP_KERNEL);
> > @@ -33,12 +33,10 @@ struct xsk_queue *xskq_create(u32 nentries, bool umem_queue)
> >  	q->nentries = nentries;
> >  	q->ring_mask = nentries - 1;
> >
> > -	gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN |
> > -		    __GFP_COMP  | __GFP_NORETRY;
> >  	size = xskq_get_ring_size(q, umem_queue);
> >
> > -	q->ring = (struct xdp_ring *)__get_free_pages(gfp_flags,
> > -						      get_order(size));
> > +	q->ring_size = size;
>
> Maybe assign size only after successful allocation?
>
> > +	q->ring = (struct xdp_ring *)vmalloc_user(size);
>
> The cast from `void *` is redundant. It was needed for
> __get_free_pages() since it returns pointer as long.
>
> >  	if (!q->ring) {
> >  		kfree(q);
> >  		return NULL;
> > @@ -52,6 +50,6 @@ void xskq_destroy(struct xsk_queue *q)
> >  	if (!q)
> >  		return;
> >
> > -	page_frag_free(q->ring);
> > +	vfree(q->ring);
> >  	kfree(q);
> >  }
> > diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> > index c6fb6b763658..35922b8b92a8 100644
> > --- a/net/xdp/xsk_queue.h
> > +++ b/net/xdp/xsk_queue.h
> > @@ -45,6 +45,7 @@ struct xsk_queue {
> >  	struct xdp_ring *ring;
> >  	u64 invalid_descs;
> >  	u64 queue_empty_descs;
> > +	size_t ring_size;
> >  };
> >
> >  /* The structure of the shared state of the rings are a simple
> Thanks,
> Olek
