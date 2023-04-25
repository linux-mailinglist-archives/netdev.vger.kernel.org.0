Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A12A6EDDC5
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbjDYIOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbjDYIOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:14:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4392B4C1E
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682410396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VxPkn25GHy91ynRR1pV4ar8WeNHXuOj3gGwdlgSRE94=;
        b=PSOA0jk3wHQmeKGIYABBr4DtCG3Dxrc/kCq7mNOsTPvyWM3yzJ7IUE7rr3xHGuF6NN/yT0
        BAZEEAvxvQ4Ip4ZbnYxGI05QRZg0wgk+BWelvnPVKpm1knPcrzj4Sg9KrIapZhcHUvLfZv
        SW6a48XDhxyScY6UNGRFQZP4Vf96VgU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-nvbxXzvXNi6PMen1qtJmnw-1; Tue, 25 Apr 2023 04:13:15 -0400
X-MC-Unique: nvbxXzvXNi6PMen1qtJmnw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f195c06507so52028705e9.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:13:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682410393; x=1685002393;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VxPkn25GHy91ynRR1pV4ar8WeNHXuOj3gGwdlgSRE94=;
        b=PxQNOi7Kvdft92M3Cb3cHfFVcIWpb+oIwkt+bRjMQag2Jy7AYjegXbIO3DEt0qkOor
         J5yEC58KeBTCjHG9MPOAnOWiQGWpgLY9/tXopPGeOPKie5/FXxIXnv+03f6yfhWn3YFi
         9sThniILMaLm+VMQZ/olwe+mtjrlrFdCWLEOi1EXCxIIIPpqhyjGVQiyxcwgrmvvJ/gI
         E83YRMnejYWelyJhRVpzL16H1adqT+uKXej3ezu6Q4SsMOwp+Ktd1BswmPsqe3crXb0k
         3bJDcXqEdcaxMTYBh3mjWu+VXNpzO7Lw2O74Z2XeIviigN5jQqKzDA7GDGWybfdhQR05
         yZXA==
X-Gm-Message-State: AAQBX9ebscjncpz2+1Of94P+xMzorbTQz7qbFFkX2Dq4FnNBfVUoW5UB
        lCEvCMXTlwGRONhWULqGCZUZoNKyRBPLv6R7T6bXHOG5HWHlVW6SkwHQT3eTUQlw/F6vN33twYx
        f6RM41v029XbO1eAs
X-Received: by 2002:a5d:510f:0:b0:2ef:eb45:2317 with SMTP id s15-20020a5d510f000000b002efeb452317mr15060912wrt.9.1682410393649;
        Tue, 25 Apr 2023 01:13:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350ajHtwCWQqjJiChIqdMNdH/aE1wrDRmNDbH28Xb0UQ//qoWFBM8yYYzpsbB1/PMN+SVAaB+og==
X-Received: by 2002:a5d:510f:0:b0:2ef:eb45:2317 with SMTP id s15-20020a5d510f000000b002efeb452317mr15060891wrt.9.1682410393266;
        Tue, 25 Apr 2023 01:13:13 -0700 (PDT)
Received: from redhat.com ([2.55.17.255])
        by smtp.gmail.com with ESMTPSA id o3-20020a05600c378300b003ef5f77901dsm14131859wmr.45.2023.04.25.01.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:13:12 -0700 (PDT)
Date:   Tue, 25 Apr 2023 04:13:09 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
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
Subject: Re: [PATCH vhost v7 00/11] virtio core prepares for AF_XDP
Message-ID: <20230425041246-mutt-send-email-mst@kernel.org>
References: <20230425073613.8839-1-xuanzhuo@linux.alibaba.com>
 <20230425034700-mutt-send-email-mst@kernel.org>
 <1682409903.8734658-2-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1682409903.8734658-2-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 04:05:03PM +0800, Xuan Zhuo wrote:
> On Tue, 25 Apr 2023 03:51:47 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Tue, Apr 25, 2023 at 03:36:02PM +0800, Xuan Zhuo wrote:
> > > ## About DMA APIs
> > >
> > > Now, virtio may can not work with DMA APIs when virtio features do not have
> > > VIRTIO_F_ACCESS_PLATFORM.
> > >
> > > 1. I tried to let DMA APIs return phy address by virtio-device. But DMA APIs just
> > >    work with the "real" devices.
> > > 2. I tried to let xsk support callballs to get phy address from virtio-net
> > >    driver as the dma address. But the maintainers of xsk may want to use dma-buf
> > >    to replace the DMA APIs. I think that may be a larger effort. We will wait
> > >    too long.
> > >
> > > So rethinking this, firstly, we can support premapped-dma only for devices with
> > > VIRTIO_F_ACCESS_PLATFORM. In the case of af-xdp, if the users want to use it,
> > > they have to update the device to support VIRTIO_F_RING_RESET, and they can also
> > > enable the device's VIRTIO_F_ACCESS_PLATFORM feature by the way.
> >
> > I don't understand this last sentence. If you think ring
> > reset can change device features then the answer is no, it can't.
> 
> 
> Sorry, I should remove "by the way".
> 
> 
> >
> > If you are saying device has to set VIRTIO_F_ACCESS_PLATFORM to
> > benefit from this work, that's fine at least as a first approach.
> > Note that setting VIRTIO_F_ACCESS_PLATFORM breaks old guests
> > (it's a secirity boundary), e.g. it is not available for
> > transitional devices.
> > So to support transitional devices, we might want to find another way to
> > address this down the road,
> 
> Maybe dma-buf is a way. I'll look into it, especially some practice on xsk.
> 
> > but as a first step, I agree just going with
> > DMA is fine.
> 
> 
> Thanks.

Pls do make sure to disable the feature when !VIRTIO_F_ACCESS_PLATFORM
though.

> 
> >
> >
> > > Thanks for the help from Christoph.
> > >
> > > =================
> > >
> > > XDP socket(AF_XDP) is an excellent bypass kernel network framework. The zero
> > > copy feature of xsk (XDP socket) needs to be supported by the driver. The
> > > performance of zero copy is very good.
> > >
> > > ENV: Qemu with vhost.
> > >
> > >                    vhost cpu | Guest APP CPU |Guest Softirq CPU | PPS
> > > -----------------------------|---------------|------------------|------------
> > > xmit by sockperf:     90%    |   100%        |                  |  318967
> > > xmit by xsk:          100%   |   30%         |   33%            | 1192064
> > > recv by sockperf:     100%   |   68%         |   100%           |  692288
> > > recv by xsk:          100%   |   33%         |   43%            |  771670
> > >
> > > Before achieving the function of Virtio-Net, we also have to let virtio core
> > > support these features:
> > >
> > > 1. virtio core support premapped
> > > 2. virtio core support reset per-queue
> > > 3. introduce DMA APIs to virtio core
> > >
> > > Please review.
> > >
> > > Thanks.
> > >
> > > v7:
> > >  1. virtqueue_dma_dev() return NULL when virtio is without DMA API.
> > >
> > > v6:
> > >  1. change the size of the flags to u32.
> > >
> > > v5:
> > >  1. fix for error handler
> > >  2. add flags to record internal dma mapping
> > >
> > > v4:
> > >  1. rename map_inter to dma_map_internal
> > >  2. fix: Excess function parameter 'vq' description in 'virtqueue_dma_dev'
> > >
> > > v3:
> > >  1. add map_inter to struct desc state to reocrd whether virtio core do dma map
> > >
> > > v2:
> > >  1. based on sgs[0]->dma_address to judgment is premapped
> > >  2. based on extra.addr to judgment to do unmap for no-indirect desc
> > >  3. based on indir_desc to judgment to do unmap for indirect desc
> > >  4. rename virtqueue_get_dma_dev to virtqueue_dma_dev
> > >
> > > v1:
> > >  1. expose dma device. NO introduce the api for dma and sync
> > >  2. split some commit for review.
> > >
> > > Xuan Zhuo (11):
> > >   virtio_ring: split: separate dma codes
> > >   virtio_ring: packed: separate dma codes
> > >   virtio_ring: packed-indirect: separate dma codes
> > >   virtio_ring: split: support premapped
> > >   virtio_ring: packed: support premapped
> > >   virtio_ring: packed-indirect: support premapped
> > >   virtio_ring: update document for virtqueue_add_*
> > >   virtio_ring: introduce virtqueue_dma_dev()
> > >   virtio_ring: correct the expression of the description of
> > >     virtqueue_resize()
> > >   virtio_ring: separate the logic of reset/enable from virtqueue_resize
> > >   virtio_ring: introduce virtqueue_reset()
> > >
> > >  drivers/virtio/virtio_ring.c | 352 +++++++++++++++++++++++++----------
> > >  include/linux/virtio.h       |   4 +
> > >  2 files changed, 259 insertions(+), 97 deletions(-)
> > >
> > > --
> > > 2.32.0.3.g01195cf9f
> >

