Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2AB6EDD3A
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 09:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbjDYHwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 03:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjDYHwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 03:52:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9495193
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 00:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682409116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LN+Qupnqrx3nxABl/NIAu7chVBT65o1KteV7K9jKs8k=;
        b=PRCMeDD1B64GmOMAtJEXqz13X7qgNx6kElg+cTyYQC9T38VouWsKwkP8s9bVT9yRmTMjC3
        2FS/vumxgkQxwggMKK+JmQLWQ4CoTvwZBq6/hBt4t1lY3vc5aY79Js3BQTWOmuadVvAktj
        vHE062kuGO5gd7ensh96MkEaRVwwyJA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-mostlS1KMtGht0QQtVoXbg-1; Tue, 25 Apr 2023 03:51:53 -0400
X-MC-Unique: mostlS1KMtGht0QQtVoXbg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f168827701so20567085e9.0
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 00:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682409112; x=1685001112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LN+Qupnqrx3nxABl/NIAu7chVBT65o1KteV7K9jKs8k=;
        b=cJnLicLK6rJJl+DlLz5OzYCGwkSYQYbVrS0Y2R+UIJiQo4PMweqvyS/CZnojC3jHIr
         ovKO8+Mralu18Yt9DFkxJHcrSVbxOeoQbf/ET7f4YfDQwVLL09hOI2DRRksKd6mj72RW
         RvJPlWV/nPEFDhgCb7GDmy6AyQrkvvFcqyTMaGrFtlbAcjnNx1yAhsIVRsiVg6osu5ds
         stx57ibnAWK2Qyu6uvh8pYqZu80RXo+P+U5ub4ppj17F3IVv5N648EWtKhhETVYcrcTM
         CFqFE3aP8Lc2D0o9ID7Gzb+Lj2DG2H3o3KV55TQ5AqltjZgikyy50u+PV6mdU0OCQwNr
         IYpg==
X-Gm-Message-State: AAQBX9ekpImqN7VzIglML+ee2BzgiTV2AKImbakXLReMk5cDfl9nwKxv
        Ymen1cTnxGujvgyU2erzl44BFT+tdeQ7q9F38EEB5nfvLTVsZPrAM9oFPLbMq3ysy6QJIYc08Sg
        efoEHUAJVhHHJW1+b
X-Received: by 2002:a05:600c:3649:b0:3f1:e5f2:5e86 with SMTP id y9-20020a05600c364900b003f1e5f25e86mr4762889wmq.23.1682409112470;
        Tue, 25 Apr 2023 00:51:52 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZvYSm0BmOXto3eV5uDy4ezuJbU7lrOsrd6Ji2Rlo2HbihXXA127mPR01nyk9gbKectoF7/Aw==
X-Received: by 2002:a05:600c:3649:b0:3f1:e5f2:5e86 with SMTP id y9-20020a05600c364900b003f1e5f25e86mr4762869wmq.23.1682409112085;
        Tue, 25 Apr 2023 00:51:52 -0700 (PDT)
Received: from redhat.com ([2.55.61.39])
        by smtp.gmail.com with ESMTPSA id b5-20020a056000054500b002e5ff05765esm12545401wrf.73.2023.04.25.00.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 00:51:51 -0700 (PDT)
Date:   Tue, 25 Apr 2023 03:51:47 -0400
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
Message-ID: <20230425034700-mutt-send-email-mst@kernel.org>
References: <20230425073613.8839-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425073613.8839-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 03:36:02PM +0800, Xuan Zhuo wrote:
> ## About DMA APIs
> 
> Now, virtio may can not work with DMA APIs when virtio features do not have
> VIRTIO_F_ACCESS_PLATFORM.
> 
> 1. I tried to let DMA APIs return phy address by virtio-device. But DMA APIs just
>    work with the "real" devices.
> 2. I tried to let xsk support callballs to get phy address from virtio-net
>    driver as the dma address. But the maintainers of xsk may want to use dma-buf
>    to replace the DMA APIs. I think that may be a larger effort. We will wait
>    too long.
> 
> So rethinking this, firstly, we can support premapped-dma only for devices with
> VIRTIO_F_ACCESS_PLATFORM. In the case of af-xdp, if the users want to use it,
> they have to update the device to support VIRTIO_F_RING_RESET, and they can also
> enable the device's VIRTIO_F_ACCESS_PLATFORM feature by the way.

I don't understand this last sentence. If you think ring
reset can change device features then the answer is no, it can't.

If you are saying device has to set VIRTIO_F_ACCESS_PLATFORM to
benefit from this work, that's fine at least as a first approach.
Note that setting VIRTIO_F_ACCESS_PLATFORM breaks old guests
(it's a secirity boundary), e.g. it is not available for
transitional devices.
So to support transitional devices, we might want to find another way to
address this down the road, but as a first step, I agree just going with
DMA is fine.


> Thanks for the help from Christoph.
> 
> =================
> 
> XDP socket(AF_XDP) is an excellent bypass kernel network framework. The zero
> copy feature of xsk (XDP socket) needs to be supported by the driver. The
> performance of zero copy is very good.
> 
> ENV: Qemu with vhost.
> 
>                    vhost cpu | Guest APP CPU |Guest Softirq CPU | PPS
> -----------------------------|---------------|------------------|------------
> xmit by sockperf:     90%    |   100%        |                  |  318967
> xmit by xsk:          100%   |   30%         |   33%            | 1192064
> recv by sockperf:     100%   |   68%         |   100%           |  692288
> recv by xsk:          100%   |   33%         |   43%            |  771670
> 
> Before achieving the function of Virtio-Net, we also have to let virtio core
> support these features:
> 
> 1. virtio core support premapped
> 2. virtio core support reset per-queue
> 3. introduce DMA APIs to virtio core
> 
> Please review.
> 
> Thanks.
> 
> v7:
>  1. virtqueue_dma_dev() return NULL when virtio is without DMA API.
> 
> v6:
>  1. change the size of the flags to u32.
> 
> v5:
>  1. fix for error handler
>  2. add flags to record internal dma mapping
> 
> v4:
>  1. rename map_inter to dma_map_internal
>  2. fix: Excess function parameter 'vq' description in 'virtqueue_dma_dev'
> 
> v3:
>  1. add map_inter to struct desc state to reocrd whether virtio core do dma map
> 
> v2:
>  1. based on sgs[0]->dma_address to judgment is premapped
>  2. based on extra.addr to judgment to do unmap for no-indirect desc
>  3. based on indir_desc to judgment to do unmap for indirect desc
>  4. rename virtqueue_get_dma_dev to virtqueue_dma_dev
> 
> v1:
>  1. expose dma device. NO introduce the api for dma and sync
>  2. split some commit for review.
> 
> Xuan Zhuo (11):
>   virtio_ring: split: separate dma codes
>   virtio_ring: packed: separate dma codes
>   virtio_ring: packed-indirect: separate dma codes
>   virtio_ring: split: support premapped
>   virtio_ring: packed: support premapped
>   virtio_ring: packed-indirect: support premapped
>   virtio_ring: update document for virtqueue_add_*
>   virtio_ring: introduce virtqueue_dma_dev()
>   virtio_ring: correct the expression of the description of
>     virtqueue_resize()
>   virtio_ring: separate the logic of reset/enable from virtqueue_resize
>   virtio_ring: introduce virtqueue_reset()
> 
>  drivers/virtio/virtio_ring.c | 352 +++++++++++++++++++++++++----------
>  include/linux/virtio.h       |   4 +
>  2 files changed, 259 insertions(+), 97 deletions(-)
> 
> --
> 2.32.0.3.g01195cf9f

