Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A014EBF63
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 12:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245666AbiC3LAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 07:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245651AbiC3LAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 07:00:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C684B13F42
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 03:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648637944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9RAN3K31yIanK0mkbf822eHFFyjPQazU54U6oFjxEo8=;
        b=goDuZ6llBGFtSWpRcf3UwWH/dd7SDWTvZUQ2GoO4TqmE3gA94/C0Sm8hRDj5F2iiiMZa3Y
        76FhSIUJQ42JkNmWvfXAwf9Z1xYmezW9m1yItMSa0DBq5uQw8qURmv2ywtaKEBU0vXkuUj
        J6l7F4DApWdpIMQ9CwN/qsS1/VSO0OU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-mAlJK2T2OzO_PDbB5-vcuQ-1; Wed, 30 Mar 2022 06:59:02 -0400
X-MC-Unique: mAlJK2T2OzO_PDbB5-vcuQ-1
Received: by mail-wm1-f69.google.com with SMTP id q6-20020a1cf306000000b0038c5726365aso2426843wmq.3
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 03:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9RAN3K31yIanK0mkbf822eHFFyjPQazU54U6oFjxEo8=;
        b=UsuCFgfyMmKwADJi3LXBu0/NTuoB/gzn3nKg1DtFJUIw4ndAU+O3T7/9+CUTByArpb
         0zLYCnZWZZRYfHDu2CPlEMJp6WDq9PNs/0s879jQdDsJcZPILoK0szX4j/XF1D5XNMot
         7s7WsGvQs8hHsKtDlvbUookfVjZA4t7ZkGATqkKcpElve2RadkFX9GnX+3APkLls5TGs
         sYUp2YIH6ciHXTruCnCeo74oKbQ9YstoSigVJe2umjThtds16erVo6VhqCWYmjcyvDo9
         RFbH6Yk5R0CfEKMBnzE4HshmKpdJc9E3sAD5ifV5RIQbh2+21dUVqED59C6Vom28DxwK
         y0fw==
X-Gm-Message-State: AOAM532gVYbf2DQL4eKiVYJlSsXkCW5I3gWZUSDZtoQnQ6xNkg1v89GG
        GL37uy5wO/doEnv8gcRJBDE4cF4DDtxF2CVh1kCDcmGTH5ZFz05zGzBz3iR5PT986O/i8E80GkD
        zGDOwliRJc42WKgqG
X-Received: by 2002:a05:600c:3487:b0:38c:9a42:4d49 with SMTP id a7-20020a05600c348700b0038c9a424d49mr3900213wmq.29.1648637941469;
        Wed, 30 Mar 2022 03:59:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKV0sSZa5jXgCtLILsMdNcYCvhipOKkQEFH6Okc5wsU1w1DYNitZVMOfLDz3s0DMSZYRktng==
X-Received: by 2002:a05:600c:3487:b0:38c:9a42:4d49 with SMTP id a7-20020a05600c348700b0038c9a424d49mr3900188wmq.29.1648637941203;
        Wed, 30 Mar 2022 03:59:01 -0700 (PDT)
Received: from redhat.com ([2.52.9.207])
        by smtp.gmail.com with ESMTPSA id x13-20020adfec0d000000b00203ff46f802sm24462014wrn.36.2022.03.30.03.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 03:59:00 -0700 (PDT)
Date:   Wed, 30 Mar 2022 06:58:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Subject: Re: [PATCH v2 0/9] virtio: support advance DMA
Message-ID: <20220330065832-mutt-send-email-mst@kernel.org>
References: <20220224110402.108161-1-xuanzhuo@linux.alibaba.com>
 <20220330023258-mutt-send-email-mst@kernel.org>
 <CACGkMEvESXv9PfMF9riPraX59j0BiLPfTgxuFVw1x0HWwjtYVQ@mail.gmail.com>
 <1648623508.9711535-4-xuanzhuo@linux.alibaba.com>
 <CACGkMEvE_wUNa=DgumVErTjp5gF4QRMDn6eP7UbDpSfSJSBy2Q@mail.gmail.com>
 <1648631012.1186295-1-xuanzhuo@linux.alibaba.com>
 <20220330065039-mutt-send-email-mst@kernel.org>
 <1648637513.2871974-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1648637513.2871974-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 06:51:53PM +0800, Xuan Zhuo wrote:
> On Wed, 30 Mar 2022 06:51:03 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Wed, Mar 30, 2022 at 05:03:32PM +0800, Xuan Zhuo wrote:
> > > On Wed, 30 Mar 2022 16:38:18 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > > > On Wed, Mar 30, 2022 at 2:59 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > > > >
> > > > > On Wed, 30 Mar 2022 14:56:17 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > > > > > On Wed, Mar 30, 2022 at 2:34 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > >
> > > > > > > On Thu, Feb 24, 2022 at 07:03:53PM +0800, Xuan Zhuo wrote:
> > > > > > > > virtqueue_add() only supports virtual addresses, dma is completed in
> > > > > > > > virtqueue_add().
> > > > > > > >
> > > > > > > > In some scenarios (such as the AF_XDP scenario), DMA is completed in advance, so
> > > > > > > > it is necessary for us to support passing the DMA address to virtqueue_add().
> > > > > > >
> > > > > > > I picked up a couple of patches. Others are waiting for some acks
> > > > > > > (Jason?) and improved commit logs for documentation.
> > > > > >
> > > > > > I will review them.
> > > > >
> > > > > hi, the core code of premapped, I will merge it into 'virtio pci support
> > > > > VIRTIO_F_RING_RESET' because this function will be used when reusing the buffer
> > > > > after resize.
> > > >
> > > > I still prefer not to do that.
> > > >
> > > > We can make rest work for resize first and add pre mapping on top. It
> > > > will simplify the review.
> > >
> > > Yes, I am also worried about the review problem, the number of my local resize
> > > patch has reached 44 (including reuse bufs).
> > >
> > > hi, Michael, can we implement resize on top of v8 first? (drop unused bufs directly)
> > >
> > > Then we implement premmapd and reuse the bufs after resize.
> > >
> > > We need to get the address (DMA address) and len from the reset ring and submit
> > > it to the new vq through virtqueue_add(). So let virtqueue_add() support
> > > premapped first.
> > >
> > > Thanks.
> >
> > Not sure I understand.
> > So the plan is
> > - remap
> > - resize on top
> > ?
> 
> #1 resize with drop unused bufs directly
> #2 premapped and resize support reuse the unused bufs
> 
> This way "premaped" will have a user.
> 
> Between #1 and #2, I may submit some code with optimized formatting, because
> jason doesn't like my introduction of struct vring_split and struct vring_packed
> in #1 for passing parameters between extracted functions.
> 
> Thanks.

So let's start with 1. Direct drop for now is ok.


> 
> >
> >
> >
> > >
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > > Thanks.
> > > > >
> > > > >
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > > > >
> > > > > > > Thanks!
> > > > > > >
> > > > > > > > v2:
> > > > > > > >     1. rename predma -> premapped
> > > > > > > >     2. virtio net xdp tx use virtio dma api
> > > > > > > >
> > > > > > > > v1:
> > > > > > > >    1. All sgs requested at one time are required to be unified PREDMA, and several
> > > > > > > >       of them are not supported to be PREDMA
> > > > > > > >    2. virtio_dma_map() is removed from this patch set and will be submitted
> > > > > > > >       together with the next time AF_XDP supports virtio dma
> > > > > > > >    3. Added patch #2 #3 to remove the check for flags when performing unmap
> > > > > > > >       indirect desc
> > > > > > > >
> > > > > > > > Xuan Zhuo (9):
> > > > > > > >   virtio_ring: rename vring_unmap_state_packed() to
> > > > > > > >     vring_unmap_extra_packed()
> > > > > > > >   virtio_ring: remove flags check for unmap split indirect desc
> > > > > > > >   virtio_ring: remove flags check for unmap packed indirect desc
> > > > > > > >   virtio_ring: virtqueue_add() support premapped
> > > > > > > >   virtio_ring: split: virtqueue_add_split() support premapped
> > > > > > > >   virtio_ring: packed: virtqueue_add_packed() support premapped
> > > > > > > >   virtio_ring: add api virtio_dma_map() for advance dma
> > > > > > > >   virtio_ring: introduce virtqueue_add_outbuf_premapped()
> > > > > > > >   virtio_net: xdp xmit use virtio dma api
> > > > > > > >
> > > > > > > >  drivers/net/virtio_net.c     |  42 +++++-
> > > > > > > >  drivers/virtio/virtio_ring.c | 280 ++++++++++++++++++++++++++---------
> > > > > > > >  include/linux/virtio.h       |  12 ++
> > > > > > > >  3 files changed, 254 insertions(+), 80 deletions(-)
> > > > > > > >
> > > > > > > > --
> > > > > > > > 2.31.0
> > > > > > >
> > > > > >
> > > > >
> > > >
> >

