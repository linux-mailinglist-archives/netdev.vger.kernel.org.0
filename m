Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9657C6E7B20
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbjDSNnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbjDSNnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:43:22 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B98713C3B;
        Wed, 19 Apr 2023 06:43:20 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VgVBGnO_1681911795;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgVBGnO_1681911795)
          by smtp.aliyun-inc.com;
          Wed, 19 Apr 2023 21:43:16 +0800
Message-ID: <1681911760.8853464-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Date:   Wed, 19 Apr 2023 21:42:40 +0800
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
        <bpf@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
 <88d5a2f6-af43-c3f9-615d-701ef01d923d@intel.com>
In-Reply-To: <88d5a2f6-af43-c3f9-615d-701ef01d923d@intel.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Apr 2023 15:22:39 +0200, Alexander Lobakin <aleksander.lobakin@intel.com> wrote:
> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Date: Mon, 17 Apr 2023 11:27:50 +0800
>
> > The purpose of this patch is to allow driver pass the own dma_ops to
> > xsk.
> >
> > This is to cope with the scene of virtio-net. If virtio does not have
> > VIRTIO_F_ACCESS_PLATFORM, then virtio cannot use DMA API. In this case,
> > XSK cannot use DMA API directly to achieve DMA address. Based on this
> > scene, we must let XSK support driver to use the driver's dma_ops.
> >
> > On the other hand, the implementation of XSK as a highlevel code
> > should put the underlying operation of DMA to the driver layer.
> > The driver layer determines the implementation of the final DMA. XSK
> > should not make such assumptions. Everything will be simplified if DMA
> > is done at the driver level.
> >
> > More is here:
> >     https://lore.kernel.org/virtualization/1681265026.6082013-1-xuanzhuo@linux.alibaba.com/
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>
> [...]
>
> >  struct xsk_buff_pool {
> >  	/* Members only used in the control path first. */
> >  	struct device *dev;
> > @@ -85,6 +102,7 @@ struct xsk_buff_pool {
> >  	 * sockets share a single cq when the same netdev and queue id is shared.
> >  	 */
> >  	spinlock_t cq_lock;
> > +	struct xsk_dma_ops dma_ops;
>
> Why full struct, not a const pointer? You'll have indirect calls either
> way, copying the full struct won't reclaim you much performance.
>
> >  	struct xdp_buff_xsk *free_heads[];
> >  };
> >
>
> [...]
>
> > @@ -424,18 +426,29 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
> >  		return 0;
> >  	}
> >
> > +	if (!dma_ops) {
> > +		pool->dma_ops.map_page = dma_map_page_attrs;
> > +		pool->dma_ops.mapping_error = dma_mapping_error;
> > +		pool->dma_ops.need_sync = dma_need_sync;
> > +		pool->dma_ops.sync_single_range_for_device = dma_sync_single_range_for_device;
> > +		pool->dma_ops.sync_single_range_for_cpu = dma_sync_single_range_for_cpu;
> > +		dma_ops = &pool->dma_ops;
> > +	} else {
> > +		pool->dma_ops = *dma_ops;
> > +	}
>
> If DMA syncs are not needed on your x86_64 DMA-coherent system, it
> doesn't mean we all don't need it. Instead of filling pointers with
> "default" callbacks, you could instead avoid indirect calls at all when
> no custom DMA ops are specified. Pls see how for example Christoph did
> that for direct DMA. It would cost only one if-else for case without
> custom DMA ops here instead of an indirect call each time.
>
> (I *could* suggest using INDIRECT_CALL_WRAPPER(), but I won't, since
>  it's more expensive than direct checking and I feel like it's more
>  appropriate to check directly here)

OK, I will fix it in next version.

Thanks.




>
> > +
> >  	dma_map = xp_create_dma_map(dev, pool->netdev, nr_pages, pool->umem);
> >  	if (!dma_map)
> >  		return -ENOMEM;
> [...]
>
> Thanks,
> Olek
