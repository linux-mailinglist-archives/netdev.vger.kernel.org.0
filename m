Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE99569A7B4
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjBQJBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjBQJBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:01:37 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2B760A79;
        Fri, 17 Feb 2023 01:01:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0Vbs.KmO_1676624472;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vbs.KmO_1676624472)
          by smtp.aliyun-inc.com;
          Fri, 17 Feb 2023 17:01:13 +0800
Message-ID: <1676624360.6165776-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next v4] xsk: support use vaddr as ring
Date:   Fri, 17 Feb 2023 16:59:20 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     <netdev@vger.kernel.org>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
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
        <bpf@vger.kernel.org>
References: <20230216083047.93525-1-xuanzhuo@linux.alibaba.com>
 <779078a5-a4c8-6f75-2063-912d02e47bc7@intel.com>
In-Reply-To: <779078a5-a4c8-6f75-2063-912d02e47bc7@intel.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Feb 2023 14:04:47 +0100, Alexander Lobakin <aleksander.lobakin@intel.com> wrote:
> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Date: Thu, 16 Feb 2023 16:30:47 +0800
>
> > When we try to start AF_XDP on some machines with long running time, due
> > to the machine's memory fragmentation problem, there is no sufficient
> > contiguous physical memory that will cause the start failure.
> >
> > If the size of the queue is 8 * 1024, then the size of the desc[] is
> > 8 * 1024 * 8 = 16 * PAGE, but we also add struct xdp_ring size, so it is
> > 16page+. This is necessary to apply for a 4-order memory. If there are a
> > lot of queues, it is difficult to these machine with long running time.
> >
> > Here, that we actually waste 15 pages. 4-Order memory is 32 pages, but
> > we only use 17 pages.
> >
> > This patch replaces __get_free_pages() by vmalloc() to allocate memory
> > to solve these problems.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
>
> [...]
>
> > diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> > index c6fb6b763658..bfb2a7e50c26 100644
> > --- a/net/xdp/xsk_queue.h
> > +++ b/net/xdp/xsk_queue.h
> > @@ -45,6 +45,7 @@ struct xsk_queue {
> >  	struct xdp_ring *ring;
> >  	u64 invalid_descs;
> >  	u64 queue_empty_descs;
> > +	size_t ring_vmalloc_size;
>
> The name looks a bit long to me, but that might be just personal
> preference. The code itself now looks good to me.
>
> Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
>
> >  };
> >
> >  /* The structure of the shared state of the rings are a simple
>
> Next time pls make sure you added all of the reviewers to the Cc list
> when sending a new revision. I noticed you posted v4 only by monitoring
> the ML.

Oh, sorry. I always thought you were in the list. I did not notice this
situation.

I will pay attention next time. Thank you for your reply.

Thanks.


>
> Thanks,
> Olek
