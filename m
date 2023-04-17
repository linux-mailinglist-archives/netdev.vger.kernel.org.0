Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168926E401C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 08:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbjDQGuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 02:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjDQGuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 02:50:44 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242E8E5A;
        Sun, 16 Apr 2023 23:50:39 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0VgE.UCn_1681714234;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgE.UCn_1681714234)
          by smtp.aliyun-inc.com;
          Mon, 17 Apr 2023 14:50:35 +0800
Message-ID: <1681714108.3197143-4-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Date:   Mon, 17 Apr 2023 14:48:28 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org,
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
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
 <20230417024216-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230417024216-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 02:43:32 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Mon, Apr 17, 2023 at 11:27:50AM +0800, Xuan Zhuo wrote:
> > @@ -532,9 +545,9 @@ struct xdp_buff *xp_alloc(struct xsk_buff_pool *pool)
> >  	xskb->xdp.data_meta = xskb->xdp.data;
> >
> >  	if (pool->dma_need_sync) {
> > -		dma_sync_single_range_for_device(pool->dev, xskb->dma, 0,
> > -						 pool->frame_len,
> > -						 DMA_BIDIRECTIONAL);
> > +		pool->dma_ops.sync_single_range_for_device(pool->dev, xskb->dma, 0,
> > +							   pool->frame_len,
> > +							   DMA_BIDIRECTIONAL);
> >  	}
> >  	return &xskb->xdp;
> >  }
> > @@ -670,15 +683,15 @@ EXPORT_SYMBOL(xp_raw_get_dma);
> >
> >  void xp_dma_sync_for_cpu_slow(struct xdp_buff_xsk *xskb)
> >  {
> > -	dma_sync_single_range_for_cpu(xskb->pool->dev, xskb->dma, 0,
> > -				      xskb->pool->frame_len, DMA_BIDIRECTIONAL);
> > +	xskb->pool->dma_ops.sync_single_range_for_cpu(xskb->pool->dev, xskb->dma, 0,
> > +						      xskb->pool->frame_len, DMA_BIDIRECTIONAL);
> >  }
> >  EXPORT_SYMBOL(xp_dma_sync_for_cpu_slow);
> >
> >  void xp_dma_sync_for_device_slow(struct xsk_buff_pool *pool, dma_addr_t dma,
> >  				 size_t size)
> >  {
> > -	dma_sync_single_range_for_device(pool->dev, dma, 0,
> > -					 size, DMA_BIDIRECTIONAL);
> > +	pool->dma_ops.sync_single_range_for_device(pool->dev, dma, 0,
> > +						   size, DMA_BIDIRECTIONAL);
> >  }
> >  EXPORT_SYMBOL(xp_dma_sync_for_device_slow);
>
> So you add an indirect function call on data path? Won't this be costly?


Yes, this may introduce some cost. The good news is that in some case,
sync is not necessary. dma_need_sync should be false.

Thanks.


>
> > --
> > 2.32.0.3.g01195cf9f
>
