Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94D7689003
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjBCHBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjBCHBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:01:35 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133DD8E4B5;
        Thu,  2 Feb 2023 23:01:32 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0VanhFlL_1675407687;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VanhFlL_1675407687)
          by smtp.aliyun-inc.com;
          Fri, 03 Feb 2023 15:01:27 +0800
Message-ID: <1675407676.377156-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 09/33] xsk: xsk_buff_pool add callback for dma_sync
Date:   Fri, 3 Feb 2023 15:01:16 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-10-xuanzhuo@linux.alibaba.com>
 <CAJ8uoz2+4+wUFYF1GjF51DFBV8ZsBRtTEVWpu_2fBmFUEQzOLQ@mail.gmail.com>
In-Reply-To: <CAJ8uoz2+4+wUFYF1GjF51DFBV8ZsBRtTEVWpu_2fBmFUEQzOLQ@mail.gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Feb 2023 13:51:20 +0100, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> On Thu, 2 Feb 2023 at 12:05, Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> >
> > Use callback to implement dma sync to simplify subsequent support for
> > virtio dma sync.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  include/net/xsk_buff_pool.h |  6 ++++++
> >  net/xdp/xsk_buff_pool.c     | 24 ++++++++++++++++++++----
> >  2 files changed, 26 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> > index 3e952e569418..53b681120354 100644
> > --- a/include/net/xsk_buff_pool.h
> > +++ b/include/net/xsk_buff_pool.h
> > @@ -75,6 +75,12 @@ struct xsk_buff_pool {
> >         u32 chunk_size;
> >         u32 chunk_shift;
> >         u32 frame_len;
> > +       void (*dma_sync_for_cpu)(struct device *dev, dma_addr_t addr,
> > +                                unsigned long offset, size_t size,
> > +                                enum dma_data_direction dir);
> > +       void (*dma_sync_for_device)(struct device *dev, dma_addr_t addr,
> > +                                   unsigned long offset, size_t size,
> > +                                   enum dma_data_direction dir);
>
> If we put these two pointers here, the number of cache lines required
> in the data path for this struct will be increased from 2 to 3 which
> will likely affect performance negatively. These sync operations are
> also not used on most systems. So how about we put them in the first
> section of this struct labeled "Members only used in the control path
> first." instead. There is a 26-byte hole at the end of it that can be
> used.


Will fix.

Thanks.


>
> >         u8 cached_need_wakeup;
> >         bool uses_need_wakeup;
> >         bool dma_need_sync;
> > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> > index ed6c71826d31..78e325e195fa 100644
> > --- a/net/xdp/xsk_buff_pool.c
> > +++ b/net/xdp/xsk_buff_pool.c
> > @@ -403,6 +403,20 @@ static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_
> >         return 0;
> >  }
> >
> > +static void dma_sync_for_cpu(struct device *dev, dma_addr_t addr,
> > +                            unsigned long offset, size_t size,
> > +                            enum dma_data_direction dir)
> > +{
> > +       dma_sync_single_range_for_cpu(dev, addr, offset, size, dir);
> > +}
> > +
> > +static void dma_sync_for_device(struct device *dev, dma_addr_t addr,
> > +                               unsigned long offset, size_t size,
> > +                               enum dma_data_direction dir)
> > +{
> > +       dma_sync_single_range_for_device(dev, addr, offset, size, dir);
> > +}
> > +
> >  int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
> >                unsigned long attrs, struct page **pages, u32 nr_pages)
> >  {
> > @@ -421,6 +435,9 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
> >                 return 0;
> >         }
> >
> > +       pool->dma_sync_for_cpu = dma_sync_for_cpu;
> > +       pool->dma_sync_for_device = dma_sync_for_device;
> > +
> >         dma_map = xp_create_dma_map(dev, pool->netdev, nr_pages, pool->umem);
> >         if (!dma_map)
> >                 return -ENOMEM;
> > @@ -667,15 +684,14 @@ EXPORT_SYMBOL(xp_raw_get_dma);
> >
> >  void xp_dma_sync_for_cpu_slow(struct xdp_buff_xsk *xskb)
> >  {
> > -       dma_sync_single_range_for_cpu(xskb->pool->dev, xskb->dma, 0,
> > -                                     xskb->pool->frame_len, DMA_BIDIRECTIONAL);
> > +       xskb->pool->dma_sync_for_cpu(xskb->pool->dev, xskb->dma, 0,
> > +                                    xskb->pool->frame_len, DMA_BIDIRECTIONAL);
> >  }
> >  EXPORT_SYMBOL(xp_dma_sync_for_cpu_slow);
> >
> >  void xp_dma_sync_for_device_slow(struct xsk_buff_pool *pool, dma_addr_t dma,
> >                                  size_t size)
> >  {
> > -       dma_sync_single_range_for_device(pool->dev, dma, 0,
> > -                                        size, DMA_BIDIRECTIONAL);
> > +       pool->dma_sync_for_device(pool->dev, dma, 0, size, DMA_BIDIRECTIONAL);
> >  }
> >  EXPORT_SYMBOL(xp_dma_sync_for_device_slow);
> > --
> > 2.32.0.3.g01195cf9f
> >
