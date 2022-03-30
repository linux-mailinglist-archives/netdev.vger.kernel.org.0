Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCFC4EBD58
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 11:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244645AbiC3JND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 05:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238507AbiC3JNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 05:13:02 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD01F2013EA;
        Wed, 30 Mar 2022 02:11:16 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V8d5iwz_1648631473;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V8d5iwz_1648631473)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 30 Mar 2022 17:11:14 +0800
Message-ID: <1648631012.1186295-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v2 0/9] virtio: support advance DMA
Date:   Wed, 30 Mar 2022 17:03:32 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
References: <20220224110402.108161-1-xuanzhuo@linux.alibaba.com>
 <20220330023258-mutt-send-email-mst@kernel.org>
 <CACGkMEvESXv9PfMF9riPraX59j0BiLPfTgxuFVw1x0HWwjtYVQ@mail.gmail.com>
 <1648623508.9711535-4-xuanzhuo@linux.alibaba.com>
 <CACGkMEvE_wUNa=DgumVErTjp5gF4QRMDn6eP7UbDpSfSJSBy2Q@mail.gmail.com>
In-Reply-To: <CACGkMEvE_wUNa=DgumVErTjp5gF4QRMDn6eP7UbDpSfSJSBy2Q@mail.gmail.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Mar 2022 16:38:18 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Wed, Mar 30, 2022 at 2:59 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> >
> > On Wed, 30 Mar 2022 14:56:17 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > > On Wed, Mar 30, 2022 at 2:34 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Thu, Feb 24, 2022 at 07:03:53PM +0800, Xuan Zhuo wrote:
> > > > > virtqueue_add() only supports virtual addresses, dma is completed in
> > > > > virtqueue_add().
> > > > >
> > > > > In some scenarios (such as the AF_XDP scenario), DMA is completed in advance, so
> > > > > it is necessary for us to support passing the DMA address to virtqueue_add().
> > > >
> > > > I picked up a couple of patches. Others are waiting for some acks
> > > > (Jason?) and improved commit logs for documentation.
> > >
> > > I will review them.
> >
> > hi, the core code of premapped, I will merge it into 'virtio pci support
> > VIRTIO_F_RING_RESET' because this function will be used when reusing the buffer
> > after resize.
>
> I still prefer not to do that.
>
> We can make rest work for resize first and add pre mapping on top. It
> will simplify the review.

Yes, I am also worried about the review problem, the number of my local resize
patch has reached 44 (including reuse bufs).

hi, Michael, can we implement resize on top of v8 first? (drop unused bufs directly)

Then we implement premmapd and reuse the bufs after resize.

We need to get the address (DMA address) and len from the reset ring and submit
it to the new vq through virtqueue_add(). So let virtqueue_add() support
premapped first.

Thanks.


>
> Thanks
>
> >
> > Thanks.
> >
> >
> > >
> > > Thanks
> > >
> > > >
> > > > Thanks!
> > > >
> > > > > v2:
> > > > >     1. rename predma -> premapped
> > > > >     2. virtio net xdp tx use virtio dma api
> > > > >
> > > > > v1:
> > > > >    1. All sgs requested at one time are required to be unified PREDMA, and several
> > > > >       of them are not supported to be PREDMA
> > > > >    2. virtio_dma_map() is removed from this patch set and will be submitted
> > > > >       together with the next time AF_XDP supports virtio dma
> > > > >    3. Added patch #2 #3 to remove the check for flags when performing unmap
> > > > >       indirect desc
> > > > >
> > > > > Xuan Zhuo (9):
> > > > >   virtio_ring: rename vring_unmap_state_packed() to
> > > > >     vring_unmap_extra_packed()
> > > > >   virtio_ring: remove flags check for unmap split indirect desc
> > > > >   virtio_ring: remove flags check for unmap packed indirect desc
> > > > >   virtio_ring: virtqueue_add() support premapped
> > > > >   virtio_ring: split: virtqueue_add_split() support premapped
> > > > >   virtio_ring: packed: virtqueue_add_packed() support premapped
> > > > >   virtio_ring: add api virtio_dma_map() for advance dma
> > > > >   virtio_ring: introduce virtqueue_add_outbuf_premapped()
> > > > >   virtio_net: xdp xmit use virtio dma api
> > > > >
> > > > >  drivers/net/virtio_net.c     |  42 +++++-
> > > > >  drivers/virtio/virtio_ring.c | 280 ++++++++++++++++++++++++++---------
> > > > >  include/linux/virtio.h       |  12 ++
> > > > >  3 files changed, 254 insertions(+), 80 deletions(-)
> > > > >
> > > > > --
> > > > > 2.31.0
> > > >
> > >
> >
>
