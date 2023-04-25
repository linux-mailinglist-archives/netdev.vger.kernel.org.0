Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18576EE205
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbjDYMlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbjDYMlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:41:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBE7E43
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682426428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sym5/GwpOgOUNUvBOB0eNgCCMsyqEVQvUPUwFKzQhvg=;
        b=ABl/Ece64kylqISVRssxr6tPTwRRea+PDeNbvkmj3ICpwt88W8mr70sxmIsvLxyoJ2hA5f
        WXcJez2gHyPnuvbM042FkIwhXWCQyyIPAQiybaPQWdYlv609Q0GSQiRiEHSB0HhkkqJjR7
        ve39/Ks0yfLFUUo3uMTv0GXq+XZDGnc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-8n5SmcfXOy2SZRDnfhJX7w-1; Tue, 25 Apr 2023 08:40:27 -0400
X-MC-Unique: 8n5SmcfXOy2SZRDnfhJX7w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f195c06507so57758255e9.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682426426; x=1685018426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sym5/GwpOgOUNUvBOB0eNgCCMsyqEVQvUPUwFKzQhvg=;
        b=Yg7eWJ1h1PvwmDPGr6UmHpH7ovMqMUHj6HSwZEQXaIviO81V35/S+rbp3HBJdNQw8Y
         dnNkKeaFv93pnNDzMtUnY1pJmNBHpdydlcyry2RTB+qHE134CJ0jiy/FM2m4U3v3xaQd
         ealKPaae1dwAW0eWIayxrp9TK4TZGIyV4cIoteqsp0eX1HTRkQWBKIvq/A7fwMiEzQN+
         QDfzDnePzhP3YOodFlLN1DS3Z325Ynu7Nl7WZsrz5zZgBttjQGrBCpWLII1m4BobnPXU
         Y5q96cH9v+Kb/StL/8xnQCPsf/Sm2JatGIw14rQzoUn38UNrxpS2GXjJlG+G76Vw7NOw
         EckQ==
X-Gm-Message-State: AAQBX9cuCOKB4rVFMMCbwYOAI3JwiK17+r3LIccGZo/XuVF/Ej97Qjjy
        k9Zazq/GIYokTuLe0gLAeAc18F6AhS/rbpvKUGsK85nZ4iU4G40IkxYHa//qkeumBCGBOvUuHsC
        PQVJ7orhEt92sdkda
X-Received: by 2002:a05:600c:5114:b0:3f1:6fb4:5645 with SMTP id o20-20020a05600c511400b003f16fb45645mr10951669wms.1.1682426425941;
        Tue, 25 Apr 2023 05:40:25 -0700 (PDT)
X-Google-Smtp-Source: AKy350aOcJZaWAP2XurK0YcB78/MVzB3a4SbfPQ9/T3FHEIHFqS0/3AKC/hoI8zwh6WihM8FUfKAKg==
X-Received: by 2002:a05:600c:5114:b0:3f1:6fb4:5645 with SMTP id o20-20020a05600c511400b003f16fb45645mr10951645wms.1.1682426425610;
        Tue, 25 Apr 2023 05:40:25 -0700 (PDT)
Received: from redhat.com ([2.55.61.39])
        by smtp.gmail.com with ESMTPSA id o10-20020a05600c510a00b003ee443bf0c7sm18298331wms.16.2023.04.25.05.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 05:40:25 -0700 (PDT)
Date:   Tue, 25 Apr 2023 08:40:21 -0400
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
Message-ID: <20230425083947-mutt-send-email-mst@kernel.org>
References: <20230425073613.8839-1-xuanzhuo@linux.alibaba.com>
 <20230425034700-mutt-send-email-mst@kernel.org>
 <1682409903.8734658-2-xuanzhuo@linux.alibaba.com>
 <20230425041246-mutt-send-email-mst@kernel.org>
 <1682410913.3294404-4-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1682410913.3294404-4-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 04:21:53PM +0800, Xuan Zhuo wrote:
> On Tue, 25 Apr 2023 04:13:09 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Tue, Apr 25, 2023 at 04:05:03PM +0800, Xuan Zhuo wrote:
> > > On Tue, 25 Apr 2023 03:51:47 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > On Tue, Apr 25, 2023 at 03:36:02PM +0800, Xuan Zhuo wrote:
> > > > > ## About DMA APIs
> > > > >
> > > > > Now, virtio may can not work with DMA APIs when virtio features do not have
> > > > > VIRTIO_F_ACCESS_PLATFORM.
> > > > >
> > > > > 1. I tried to let DMA APIs return phy address by virtio-device. But DMA APIs just
> > > > >    work with the "real" devices.
> > > > > 2. I tried to let xsk support callballs to get phy address from virtio-net
> > > > >    driver as the dma address. But the maintainers of xsk may want to use dma-buf
> > > > >    to replace the DMA APIs. I think that may be a larger effort. We will wait
> > > > >    too long.
> > > > >
> > > > > So rethinking this, firstly, we can support premapped-dma only for devices with
> > > > > VIRTIO_F_ACCESS_PLATFORM. In the case of af-xdp, if the users want to use it,
> > > > > they have to update the device to support VIRTIO_F_RING_RESET, and they can also
> > > > > enable the device's VIRTIO_F_ACCESS_PLATFORM feature by the way.
> > > >
> > > > I don't understand this last sentence. If you think ring
> > > > reset can change device features then the answer is no, it can't.
> > >
> > >
> > > Sorry, I should remove "by the way".
> > >
> > >
> > > >
> > > > If you are saying device has to set VIRTIO_F_ACCESS_PLATFORM to
> > > > benefit from this work, that's fine at least as a first approach.
> > > > Note that setting VIRTIO_F_ACCESS_PLATFORM breaks old guests
> > > > (it's a secirity boundary), e.g. it is not available for
> > > > transitional devices.
> > > > So to support transitional devices, we might want to find another way to
> > > > address this down the road,
> > >
> > > Maybe dma-buf is a way. I'll look into it, especially some practice on xsk.
> > >
> > > > but as a first step, I agree just going with
> > > > DMA is fine.
> > >
> > >
> > > Thanks.
> >
> > Pls do make sure to disable the feature when !VIRTIO_F_ACCESS_PLATFORM
> > though.
> 
> If you refer to the implementation inside virtio-net, this feature will depend
> on the return of virtqueue_dma_dev().
> 
> But virtqueue_dma_dev() depends "use_dma_api". When xen_domain() is true and
> !VIRTIO_F_ACCESS_PLATFORM, the "use_dma_api" is true.
> 
> So what kind of situation do you mean?
> 
> Thanks.

E.g. a legacy device.

-- 
MST

