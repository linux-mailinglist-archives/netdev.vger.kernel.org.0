Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18E16EDDA5
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbjDYIIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbjDYIIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:08:44 -0400
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690EBA2;
        Tue, 25 Apr 2023 01:08:42 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VgzLxx7_1682410117;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgzLxx7_1682410117)
          by smtp.aliyun-inc.com;
          Tue, 25 Apr 2023 16:08:38 +0800
Message-ID: <1682409903.8734658-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost v7 00/11] virtio core prepares for AF_XDP
Date:   Tue, 25 Apr 2023 16:05:03 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
References: <20230425073613.8839-1-xuanzhuo@linux.alibaba.com>
 <20230425034700-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230425034700-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 03:51:47 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Tue, Apr 25, 2023 at 03:36:02PM +0800, Xuan Zhuo wrote:
> > ## About DMA APIs
> >
> > Now, virtio may can not work with DMA APIs when virtio features do not have
> > VIRTIO_F_ACCESS_PLATFORM.
> >
> > 1. I tried to let DMA APIs return phy address by virtio-device. But DMA APIs just
> >    work with the "real" devices.
> > 2. I tried to let xsk support callballs to get phy address from virtio-net
> >    driver as the dma address. But the maintainers of xsk may want to use dma-buf
> >    to replace the DMA APIs. I think that may be a larger effort. We will wait
> >    too long.
> >
> > So rethinking this, firstly, we can support premapped-dma only for devices with
> > VIRTIO_F_ACCESS_PLATFORM. In the case of af-xdp, if the users want to use it,
> > they have to update the device to support VIRTIO_F_RING_RESET, and they can also
> > enable the device's VIRTIO_F_ACCESS_PLATFORM feature by the way.
>
> I don't understand this last sentence. If you think ring
> reset can change device features then the answer is no, it can't.


Sorry, I should remove "by the way".


>
> If you are saying device has to set VIRTIO_F_ACCESS_PLATFORM to
> benefit from this work, that's fine at least as a first approach.
> Note that setting VIRTIO_F_ACCESS_PLATFORM breaks old guests
> (it's a secirity boundary), e.g. it is not available for
> transitional devices.
> So to support transitional devices, we might want to find another way to
> address this down the road,

Maybe dma-buf is a way. I'll look into it, especially some practice on xsk.

> but as a first step, I agree just going with
> DMA is fine.


Thanks.


>
>
> > Thanks for the help from Christoph.
> >
> > =================
> >
> > XDP socket(AF_XDP) is an excellent bypass kernel network framework. The zero
> > copy feature of xsk (XDP socket) needs to be supported by the driver. The
> > performance of zero copy is very good.
> >
> > ENV: Qemu with vhost.
> >
> >                    vhost cpu | Guest APP CPU |Guest Softirq CPU | PPS
> > -----------------------------|---------------|------------------|------------
> > xmit by sockperf:     90%    |   100%        |                  |  318967
> > xmit by xsk:          100%   |   30%         |   33%            | 1192064
> > recv by sockperf:     100%   |   68%         |   100%           |  692288
> > recv by xsk:          100%   |   33%         |   43%            |  771670
> >
> > Before achieving the function of Virtio-Net, we also have to let virtio core
> > support these features:
> >
> > 1. virtio core support premapped
> > 2. virtio core support reset per-queue
> > 3. introduce DMA APIs to virtio core
> >
> > Please review.
> >
> > Thanks.
> >
> > v7:
> >  1. virtqueue_dma_dev() return NULL when virtio is without DMA API.
> >
> > v6:
> >  1. change the size of the flags to u32.
> >
> > v5:
> >  1. fix for error handler
> >  2. add flags to record internal dma mapping
> >
> > v4:
> >  1. rename map_inter to dma_map_internal
> >  2. fix: Excess function parameter 'vq' description in 'virtqueue_dma_dev'
> >
> > v3:
> >  1. add map_inter to struct desc state to reocrd whether virtio core do dma map
> >
> > v2:
> >  1. based on sgs[0]->dma_address to judgment is premapped
> >  2. based on extra.addr to judgment to do unmap for no-indirect desc
> >  3. based on indir_desc to judgment to do unmap for indirect desc
> >  4. rename virtqueue_get_dma_dev to virtqueue_dma_dev
> >
> > v1:
> >  1. expose dma device. NO introduce the api for dma and sync
> >  2. split some commit for review.
> >
> > Xuan Zhuo (11):
> >   virtio_ring: split: separate dma codes
> >   virtio_ring: packed: separate dma codes
> >   virtio_ring: packed-indirect: separate dma codes
> >   virtio_ring: split: support premapped
> >   virtio_ring: packed: support premapped
> >   virtio_ring: packed-indirect: support premapped
> >   virtio_ring: update document for virtqueue_add_*
> >   virtio_ring: introduce virtqueue_dma_dev()
> >   virtio_ring: correct the expression of the description of
> >     virtqueue_resize()
> >   virtio_ring: separate the logic of reset/enable from virtqueue_resize
> >   virtio_ring: introduce virtqueue_reset()
> >
> >  drivers/virtio/virtio_ring.c | 352 +++++++++++++++++++++++++----------
> >  include/linux/virtio.h       |   4 +
> >  2 files changed, 259 insertions(+), 97 deletions(-)
> >
> > --
> > 2.32.0.3.g01195cf9f
>
