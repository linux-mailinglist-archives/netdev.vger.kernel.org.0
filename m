Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD0D4EBF36
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 12:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245583AbiC3KxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 06:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244428AbiC3KxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 06:53:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F006F3B579
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 03:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648637480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wnMSItC8n0CDYr8QTJ4aTsqJAmXh/a7xPpLx6HfylVg=;
        b=AIONujci/vuPWIQ+vsR6ZkCBrZPZmQpkiVl+ERXyrwmns0vX1JQwZL6yZh2uhW8+Sk4Ln1
        +E3YOFXxYj/lkEC1hhziYa3OryW4mJf/JJnLx/iu68bM/HLWflFP8pmQVXQNwUHy2En+Kv
        Y06uLhFqSfn9HhPRujjb7SVfZFC8Kf8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-gI58E74HM5O2Jq8RZog95Q-1; Wed, 30 Mar 2022 06:51:09 -0400
X-MC-Unique: gI58E74HM5O2Jq8RZog95Q-1
Received: by mail-wr1-f70.google.com with SMTP id a17-20020a5d6cb1000000b00203f85a2ed9so5792949wra.7
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 03:51:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wnMSItC8n0CDYr8QTJ4aTsqJAmXh/a7xPpLx6HfylVg=;
        b=yYcC6Um9z1lMKRJ+unQAmUGcvsOhTYAWSBDUu3CNzgjy3cCGsxLlw9MjIy4meGShTe
         ziMLvIFZanPS2joN+IKNAWTypQPTFEsqa4cx6AVXFDj+bxmC4TiPuRwmk3KMO0uqxsqv
         YHu8OU6D6K5JXxYn53UoTETEZZKBsf2TC8FKapcPu+AW9whH7DMPTfobJuwDkRCGU03P
         3c1ArrnaUWUXdAfiYdaK7QUvQUYMB9rL0J6KlEAlcQ08eBk6JDicQenVe3LDJiVwm8pm
         Fo3qPQncFggLn/4msM7s1mRBnl01VFE6pvTXWdQBXwEqlXLAQrKzYeGZajcLn0s8qGZp
         ashg==
X-Gm-Message-State: AOAM532ArOwjJd/BL7+xqDumTQMjF8XOGzuX0lZkAm4eEW3hkybdlEsS
        VS5I45+gWVeKyC1n3VT89znv9tgQ09yAJI8Lse0GSvUnx4XMLLKsVLF0Ra3f4gE//ijNrLhNF4r
        vUN/2flIOseffnkzw
X-Received: by 2002:a5d:66ca:0:b0:203:f9b1:dfc0 with SMTP id k10-20020a5d66ca000000b00203f9b1dfc0mr36046493wrw.146.1648637468405;
        Wed, 30 Mar 2022 03:51:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBZEJlZUuM9T8weSZ6dyHvg5KLz9n08nG046N4t/DHrijmrL4VGxtkumOjoOLwAE/zUA3xxQ==
X-Received: by 2002:a5d:66ca:0:b0:203:f9b1:dfc0 with SMTP id k10-20020a5d66ca000000b00203f9b1dfc0mr36046468wrw.146.1648637468157;
        Wed, 30 Mar 2022 03:51:08 -0700 (PDT)
Received: from redhat.com ([2.52.9.207])
        by smtp.gmail.com with ESMTPSA id d20-20020a05600c34d400b0038caf684679sm6436194wmq.0.2022.03.30.03.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 03:51:07 -0700 (PDT)
Date:   Wed, 30 Mar 2022 06:51:03 -0400
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
Message-ID: <20220330065039-mutt-send-email-mst@kernel.org>
References: <20220224110402.108161-1-xuanzhuo@linux.alibaba.com>
 <20220330023258-mutt-send-email-mst@kernel.org>
 <CACGkMEvESXv9PfMF9riPraX59j0BiLPfTgxuFVw1x0HWwjtYVQ@mail.gmail.com>
 <1648623508.9711535-4-xuanzhuo@linux.alibaba.com>
 <CACGkMEvE_wUNa=DgumVErTjp5gF4QRMDn6eP7UbDpSfSJSBy2Q@mail.gmail.com>
 <1648631012.1186295-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1648631012.1186295-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 05:03:32PM +0800, Xuan Zhuo wrote:
> On Wed, 30 Mar 2022 16:38:18 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > On Wed, Mar 30, 2022 at 2:59 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > >
> > > On Wed, 30 Mar 2022 14:56:17 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > > > On Wed, Mar 30, 2022 at 2:34 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Thu, Feb 24, 2022 at 07:03:53PM +0800, Xuan Zhuo wrote:
> > > > > > virtqueue_add() only supports virtual addresses, dma is completed in
> > > > > > virtqueue_add().
> > > > > >
> > > > > > In some scenarios (such as the AF_XDP scenario), DMA is completed in advance, so
> > > > > > it is necessary for us to support passing the DMA address to virtqueue_add().
> > > > >
> > > > > I picked up a couple of patches. Others are waiting for some acks
> > > > > (Jason?) and improved commit logs for documentation.
> > > >
> > > > I will review them.
> > >
> > > hi, the core code of premapped, I will merge it into 'virtio pci support
> > > VIRTIO_F_RING_RESET' because this function will be used when reusing the buffer
> > > after resize.
> >
> > I still prefer not to do that.
> >
> > We can make rest work for resize first and add pre mapping on top. It
> > will simplify the review.
> 
> Yes, I am also worried about the review problem, the number of my local resize
> patch has reached 44 (including reuse bufs).
> 
> hi, Michael, can we implement resize on top of v8 first? (drop unused bufs directly)
> 
> Then we implement premmapd and reuse the bufs after resize.
> 
> We need to get the address (DMA address) and len from the reset ring and submit
> it to the new vq through virtqueue_add(). So let virtqueue_add() support
> premapped first.
> 
> Thanks.

Not sure I understand.
So the plan is
- remap
- resize on top
?



> 
> >
> > Thanks
> >
> > >
> > > Thanks.
> > >
> > >
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > > Thanks!
> > > > >
> > > > > > v2:
> > > > > >     1. rename predma -> premapped
> > > > > >     2. virtio net xdp tx use virtio dma api
> > > > > >
> > > > > > v1:
> > > > > >    1. All sgs requested at one time are required to be unified PREDMA, and several
> > > > > >       of them are not supported to be PREDMA
> > > > > >    2. virtio_dma_map() is removed from this patch set and will be submitted
> > > > > >       together with the next time AF_XDP supports virtio dma
> > > > > >    3. Added patch #2 #3 to remove the check for flags when performing unmap
> > > > > >       indirect desc
> > > > > >
> > > > > > Xuan Zhuo (9):
> > > > > >   virtio_ring: rename vring_unmap_state_packed() to
> > > > > >     vring_unmap_extra_packed()
> > > > > >   virtio_ring: remove flags check for unmap split indirect desc
> > > > > >   virtio_ring: remove flags check for unmap packed indirect desc
> > > > > >   virtio_ring: virtqueue_add() support premapped
> > > > > >   virtio_ring: split: virtqueue_add_split() support premapped
> > > > > >   virtio_ring: packed: virtqueue_add_packed() support premapped
> > > > > >   virtio_ring: add api virtio_dma_map() for advance dma
> > > > > >   virtio_ring: introduce virtqueue_add_outbuf_premapped()
> > > > > >   virtio_net: xdp xmit use virtio dma api
> > > > > >
> > > > > >  drivers/net/virtio_net.c     |  42 +++++-
> > > > > >  drivers/virtio/virtio_ring.c | 280 ++++++++++++++++++++++++++---------
> > > > > >  include/linux/virtio.h       |  12 ++
> > > > > >  3 files changed, 254 insertions(+), 80 deletions(-)
> > > > > >
> > > > > > --
> > > > > > 2.31.0
> > > > >
> > > >
> > >
> >

