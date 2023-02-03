Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B37C68931B
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbjBCJJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbjBCJJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:09:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E2295D08
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675415318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sUtd5Ka/hp1Bq87QrTDKK+BVxo/tljWjUJR5C9jZS9o=;
        b=AgBtC94qyUVmWncD4ApCeTu04kdUiS208ofn/39ZI2QGT5c52XKhHZBVUiMSNEGcI051l7
        lItyTXfxPAh7opxwqa+idY91KuUipe6An15+igrsQ3UgMyUA/9qqqKhFWWvvQjh+tl8lUQ
        pbMsJz4G3qbAgtjrEIb3n38bXyX9E5E=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-596--cixHB62OxuZTtnMcIopwg-1; Fri, 03 Feb 2023 04:08:37 -0500
X-MC-Unique: -cixHB62OxuZTtnMcIopwg-1
Received: by mail-ed1-f69.google.com with SMTP id s13-20020aa7d78d000000b004a95f05cbc2so729381edq.1
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 01:08:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sUtd5Ka/hp1Bq87QrTDKK+BVxo/tljWjUJR5C9jZS9o=;
        b=o/Q9HjlnXpMSAyh4PUA0fCd7clFbpu4H5aslTx8FPGOuMz5gu7Y4nNaYsVs7gduGSy
         qS6gBZf6C8iiXQrLe6sgNJL03XE4OxFdjTUQPaSXUYKM4MoZs+jZf4hur6xL2jgl1bmU
         aIU5VyiRznB+2Y7SLei6gIg4pkGyNAUkcngWbgnm+cRUAkarLgQ0kdeSDb/vRkvR0qb1
         Cr5Ls9PIQEWWqcLRHsx/Clej/mHUZTeprI39rL/vM8LkBmEAVZbz4j7uIILzgFQDrI6Q
         Mh5kFZ7vBdD41ijt2Nue5vVQ4UFzYMJQBZHyRKJXNREE24mw60+0HjutwI/q0Olp/AQS
         /xIg==
X-Gm-Message-State: AO0yUKXAkpYcgcKSe7r72Qprr0HzukdoCU1eCBHYgAqnXQCmCY3X461+
        ZaZeZ+P5dXLa5ohLUXNPkO9/y2xvg7dJ2ymRX/KhPndxRQu5kKGF4rPnP1GBPe0bgVPsSG19M16
        Ua03aM+l4gwoOb6JS
X-Received: by 2002:a17:907:9917:b0:88d:6de1:96bf with SMTP id ka23-20020a170907991700b0088d6de196bfmr10097239ejc.12.1675415316327;
        Fri, 03 Feb 2023 01:08:36 -0800 (PST)
X-Google-Smtp-Source: AK7set/rLVod5gDwzE+Z06Asw3o+8+gM8I6XaOfEuxYW7oEkMOteoDLr5ZFSr2jTAp3DEer8lZOIIQ==
X-Received: by 2002:a17:907:9917:b0:88d:6de1:96bf with SMTP id ka23-20020a170907991700b0088d6de196bfmr10097214ejc.12.1675415316150;
        Fri, 03 Feb 2023 01:08:36 -0800 (PST)
Received: from redhat.com ([2.52.156.122])
        by smtp.gmail.com with ESMTPSA id rh25-20020a17090720f900b00887830e535csm1068995ejb.159.2023.02.03.01.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 01:08:35 -0800 (PST)
Date:   Fri, 3 Feb 2023 04:08:31 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 00/33] virtio-net: support AF_XDP zero copy
Message-ID: <20230203040739-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202060757-mutt-send-email-mst@kernel.org>
 <1675338247.0108669-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675338247.0108669-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:44:07PM +0800, Xuan Zhuo wrote:
> On Thu, 2 Feb 2023 06:08:30 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Thu, Feb 02, 2023 at 07:00:25PM +0800, Xuan Zhuo wrote:
> > > XDP socket(AF_XDP) is an excellent bypass kernel network framework. The zero
> > > copy feature of xsk (XDP socket) needs to be supported by the driver. The
> > > performance of zero copy is very good.
> >
> > Great! Any numbers to share?
> 
> RESEND. Last mail has some email format error.
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
> Thanks.

Impressive, thanks a lot for this work!
Pls remember to retest and include up to date numbers on
subsequent versions.

> 
> >
> > > mlx5 and intel ixgbe already support
> > > this feature, This patch set allows virtio-net to support xsk's zerocopy xmit
> > > feature.
> > >
> > > Virtio-net did not support per-queue reset, so it was impossible to support XDP
> > > Socket Zerocopy. At present, we have completed the work of Virtio Spec and
> > > Kernel in Per-Queue Reset. It is time for Virtio-Net to complete the support for
> > > the XDP Socket Zerocopy.
> > >
> > > Virtio-net can not increase the queue at will, so xsk shares the queue with
> > > kernel.
> > >
> > > On the other hand, Virtio-Net does not support generate interrupt manually, so
> > > when we wakeup tx xmit, we used some tips. If the CPU run by TX NAPI last time
> > > is other CPUs, use IPI to wake up NAPI on the remote CPU. If it is also the
> > > local CPU, then we wake up sofrirqd.
> > >
> > > Please review.
> > >
> > > Thanks.
> > >
> > >
> > > Xuan Zhuo (33):
> > >   virtio_ring: virtqueue_add() support premapped
> > >   virtio_ring: split: virtqueue_add_split() support premapped
> > >   virtio_ring: packed: virtqueue_add_packed() support premapped
> > >   virtio_ring: introduce virtqueue_add_outbuf_premapped()
> > >   virtio_ring: introduce virtqueue_add_inbuf_premapped()
> > >   virtio_ring: introduce virtqueue_reset()
> > >   virtio_ring: add api virtio_dma_map() for advance dma
> > >   virtio_ring: introduce dma sync api for virtio
> > >   xsk: xsk_buff_pool add callback for dma_sync
> > >   xsk: support virtio DMA map
> > >   virtio_net: rename free_old_xmit_skbs to free_old_xmit
> > >   virtio_net: unify the code for recycling the xmit ptr
> > >   virtio_net: virtnet_poll_tx support rescheduled
> > >   virtio_net: independent directory
> > >   virtio_net: move to virtio_net.h
> > >   virtio_net: introduce virtnet_xdp_handler() to seprate the logic of
> > >     run xdp
> > >   virtio_net: receive_small() use virtnet_xdp_handler()
> > >   virtio_net: receive_merageable() use virtnet_xdp_handler()
> > >   virtio_net: introduce virtnet_tx_reset()
> > >   virtio_net: xsk: introduce virtnet_rq_bind_xsk_pool()
> > >   virtio_net: xsk: introduce virtnet_xsk_pool_enable()
> > >   virtio_net: xsk: introduce xsk disable
> > >   virtio_net: xsk: support xsk setup
> > >   virtio_net: xsk: stop disable tx napi
> > >   virtio_net: xsk: __free_old_xmit distinguishes xsk buffer
> > >   virtio_net: virtnet_sq_free_unused_buf() check xsk buffer
> > >   virtio_net: virtnet_rq_free_unused_buf() check xsk buffer
> > >   net: introduce napi_tx_raise()
> > >   virtio_net: xsk: tx: support tx
> > >   virtio_net: xsk: tx: support wakeup
> > >   virtio_net: xsk: tx: auto wakeup when free old xmit
> > >   virtio_net: xsk: rx: introduce add_recvbuf_xsk()
> > >   virtio_net: xsk: rx: introduce receive_xsk() to recv xsk buffer
> > >
> > >  MAINTAINERS                                 |   2 +-
> > >  drivers/net/Kconfig                         |   8 +-
> > >  drivers/net/Makefile                        |   2 +-
> > >  drivers/net/virtio/Kconfig                  |  11 +
> > >  drivers/net/virtio/Makefile                 |   8 +
> > >  drivers/net/{virtio_net.c => virtio/main.c} | 564 +++++++-------------
> > >  drivers/net/virtio/virtio_net.h             | 317 +++++++++++
> > >  drivers/net/virtio/xsk.c                    | 524 ++++++++++++++++++
> > >  drivers/net/virtio/xsk.h                    |  33 ++
> > >  drivers/virtio/virtio_ring.c                | 376 +++++++++++--
> > >  include/linux/netdevice.h                   |   7 +
> > >  include/linux/virtio.h                      |  29 +
> > >  include/net/xsk_buff_pool.h                 |   6 +
> > >  net/core/dev.c                              |  11 +
> > >  net/xdp/xsk_buff_pool.c                     |  79 ++-
> > >  15 files changed, 1541 insertions(+), 436 deletions(-)
> > >  create mode 100644 drivers/net/virtio/Kconfig
> > >  create mode 100644 drivers/net/virtio/Makefile
> > >  rename drivers/net/{virtio_net.c => virtio/main.c} (92%)
> > >  create mode 100644 drivers/net/virtio/virtio_net.h
> > >  create mode 100644 drivers/net/virtio/xsk.c
> > >  create mode 100644 drivers/net/virtio/xsk.h
> > >
> > > --
> > > 2.32.0.3.g01195cf9f
> >

