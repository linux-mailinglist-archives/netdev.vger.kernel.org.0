Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADE66E7B19
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbjDSNmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbjDSNl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:41:59 -0400
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4FD171D;
        Wed, 19 Apr 2023 06:41:54 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0VgVGQZB_1681911709;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgVGQZB_1681911709)
          by smtp.aliyun-inc.com;
          Wed, 19 Apr 2023 21:41:50 +0800
Message-ID: <1681911643.4417202-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Date:   Wed, 19 Apr 2023 21:40:43 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     <netdev@vger.kernel.org>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
 <ZDzKAD2SNe1q/XA6@infradead.org>
 <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
 <20230417115610.7763a87c@kernel.org>
 <20230417115753.7fb64b68@kernel.org>
 <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
 <20230417181950.5db68526@kernel.org>
 <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
 <20230417195400.482cfe75@kernel.org>
 <ZD4kMOym15pFcjq+@infradead.org>
 <20230417231947.3972f1a8@kernel.org>
 <ZD95RY9PjVRi7qz3@infradead.org>
 <d18eea7a-a71c-8de0-bde3-7ab000a77539@intel.com>
In-Reply-To: <d18eea7a-a71c-8de0-bde3-7ab000a77539@intel.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Apr 2023 15:14:48 +0200, Alexander Lobakin <aleksander.lobakin@intel.com> wrote:
> From: Christoph Hellwig <hch@infradead.org>
> Date: Tue, 18 Apr 2023 22:16:53 -0700
>
> > On Mon, Apr 17, 2023 at 11:19:47PM -0700, Jakub Kicinski wrote:
> >>> You can't just do dma mapping outside the driver, because there are
> >>> drivers that do not require DMA mapping at all.  virtio is an example,
> >>> but all the classic s390 drivers and some other odd virtualization
> >>> ones are others.
> >>
> >> What bus are the classic s390 on (in terms of the device model)?
> >
> > I think most of them are based on struct ccw_device, but I'll let the
> > s390 maintainers fill in.
> >
> > Another interesting case that isn't really relevant for your networking
> > guys, but that caused as problems is RDMA.  For hardware RDMA devices
> > it wants the ULPs to DMA map, but it turns out we have various software
> > drivers that map to network drivers that do their own DMA mapping
> > at a much lower layer and after potentially splitting packets or
> > even mangling them.
> >
> >>
> >>>> I don't think it's reasonable to be bubbling up custom per-subsystem
> >>>> DMA ops into all of them for the sake of virtio.
> >>>
> >>> dma addresses and thus dma mappings are completely driver specific.
> >>> Upper layers have no business looking at them.
>
> Here it's not an "upper layer". XSk core doesn't look at them or pass
> them between several drivers. It maps DMA solely via the struct device
> passed from the driver and then just gets-sets addresses for this driver
> only. Just like Page Pool does for regular Rx buffers. This got moved to
> the XSk core to not repeat the same code pattern in each driver.
>
> >>
> >> Damn, that's unfortunate. Thinking aloud -- that means that if we want
> >> to continue to pull memory management out of networking drivers to
> >> improve it for all, cross-optimize with the rest of the stack and
> >> allow various upcoming forms of zero copy -- then we need to add an
> >> equivalent of dma_ops and DMA API locally in networking?
>
> Managing DMA addresses is totally fine as long as you don't try to pass
> mapped addresses between different drivers :D Page Pool already does
> that and I don't see a problem in that in general.
>
> >
> > Can you explain what the actual use case is?
> >
> >>From the original patchset I suspect it is dma mapping something very
> > long term and then maybe doing syncs on it as needed?
>
> As I mentioned, XSk provides some handy wrappers to map DMA for drivers.
> Previously, XSk was supported by real hardware drivers only, but here
> the developer tries to add support to virtio-net. I suspect he needs to
> use DMA mapping functions different from which the regular driver use.
> So this is far from dma_map_ops, the author picked wrong name :D


Yes, dma_ops caused some misunderstandings, which is indeed a wrong name.

Thanks.


> And correct, for XSk we map one big piece of memory only once and then
> reuse it for buffers, no inflight map/unmap on hotpath (only syncs when
> needed). So this mapping is longterm and is stored in XSk core structure
> assigned to the driver which this mapping was done for.
> I think Jakub thinks of something similar, but for the "regular" Rx/Tx,
> not only XDP sockets :)
>
> Thanks,
> Olek
