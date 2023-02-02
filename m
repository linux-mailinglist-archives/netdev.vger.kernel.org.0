Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C821687BA9
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjBBLJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjBBLJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:09:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C958976AD
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 03:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675336121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lz0zTz+Gz36uEjAct9g3W1/HujYGKgEb+bfXh3QBDS8=;
        b=PwUIUVxP3uZd9MW6dcYIiauZkVN55ELTtJawCSLp1Qcb4Dvx+NlmUAC7TYNK41E7Z2XDLZ
        VwRo/kvsIwXNc/hW39Qd/65GldcOv7ZRGQzBO3eqQQwOiIHLZlX0UVoPuhdkHhcFu3OE/B
        QF9ZDErDGQzYjFLdwtujQ1WP9O/I0U4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-647-KZRsvCHCMsyBPSoEfkHPYw-1; Thu, 02 Feb 2023 06:08:40 -0500
X-MC-Unique: KZRsvCHCMsyBPSoEfkHPYw-1
Received: by mail-wm1-f72.google.com with SMTP id h9-20020a1ccc09000000b003db1c488826so2650435wmb.3
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 03:08:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lz0zTz+Gz36uEjAct9g3W1/HujYGKgEb+bfXh3QBDS8=;
        b=JynONKFB/HaZ16mO7YRKpH1lFmdbCczSvIJSDAidO5jzQ2TktgxlF6YRPEhqlpM5Ij
         H02EAUW2oNLx7blkFm4botTyLjpSEnMzdhM4vjnNuyP5xeTgjW/Tob63zXUZEbufsrre
         QrKVvtEHHvWdM16vJ0tXBZR/Dx2lIYALJl8ARF2ogJU+J44Sd9YzEZZUHcgaGAZjh3cI
         jwRlxoiz+aDyK2hRg1o8Bk8I0/OxgmfkSOOBd1eCYCus+jI2FbAOE5ysTK5hM7SrZbzU
         SpbD/SLzWc56aAdcnGH8KO1RUBO0ti0QwykgzifDSL5/bV4uDYrjp/oi0Is3bN2A1YqW
         2aCA==
X-Gm-Message-State: AO0yUKU6cX8Dw9wnMvRVvnsGElSIrnKdv3bXN4sWq+JdSsRlogGVgn7i
        ooQJCm4LEC/96xmwBzbwf274+SPrGYTyeEss1KhPkmoITjjmFwUcHiQOntCLtcu0CW0NWS9pVOM
        92n+sCo0o8eL/J69l
X-Received: by 2002:a5d:47cc:0:b0:2c3:be89:7c2a with SMTP id o12-20020a5d47cc000000b002c3be897c2amr1585476wrc.13.1675336118297;
        Thu, 02 Feb 2023 03:08:38 -0800 (PST)
X-Google-Smtp-Source: AK7set8L6ehiCIHTqXDjFaeDmD8e3MDpBSAuqRb/FSnbN4gHDYlbjhPH+AJMGwS/WUDQOGOLlrDz/A==
X-Received: by 2002:a5d:47cc:0:b0:2c3:be89:7c2a with SMTP id o12-20020a5d47cc000000b002c3be897c2amr1585462wrc.13.1675336118054;
        Thu, 02 Feb 2023 03:08:38 -0800 (PST)
Received: from redhat.com ([2a02:14f:1fc:826d:55d8:70a4:3d30:fc2f])
        by smtp.gmail.com with ESMTPSA id f12-20020adfdb4c000000b002bfb1de74absm19571527wrj.114.2023.02.02.03.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 03:08:37 -0800 (PST)
Date:   Thu, 2 Feb 2023 06:08:30 -0500
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
Message-ID: <20230202060757-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:00:25PM +0800, Xuan Zhuo wrote:
> XDP socket(AF_XDP) is an excellent bypass kernel network framework. The zero
> copy feature of xsk (XDP socket) needs to be supported by the driver. The
> performance of zero copy is very good.

Great! Any numbers to share?

> mlx5 and intel ixgbe already support
> this feature, This patch set allows virtio-net to support xsk's zerocopy xmit
> feature.
> 
> Virtio-net did not support per-queue reset, so it was impossible to support XDP
> Socket Zerocopy. At present, we have completed the work of Virtio Spec and
> Kernel in Per-Queue Reset. It is time for Virtio-Net to complete the support for
> the XDP Socket Zerocopy.
> 
> Virtio-net can not increase the queue at will, so xsk shares the queue with
> kernel.
> 
> On the other hand, Virtio-Net does not support generate interrupt manually, so
> when we wakeup tx xmit, we used some tips. If the CPU run by TX NAPI last time
> is other CPUs, use IPI to wake up NAPI on the remote CPU. If it is also the
> local CPU, then we wake up sofrirqd.
> 
> Please review.
> 
> Thanks.
> 
> 
> Xuan Zhuo (33):
>   virtio_ring: virtqueue_add() support premapped
>   virtio_ring: split: virtqueue_add_split() support premapped
>   virtio_ring: packed: virtqueue_add_packed() support premapped
>   virtio_ring: introduce virtqueue_add_outbuf_premapped()
>   virtio_ring: introduce virtqueue_add_inbuf_premapped()
>   virtio_ring: introduce virtqueue_reset()
>   virtio_ring: add api virtio_dma_map() for advance dma
>   virtio_ring: introduce dma sync api for virtio
>   xsk: xsk_buff_pool add callback for dma_sync
>   xsk: support virtio DMA map
>   virtio_net: rename free_old_xmit_skbs to free_old_xmit
>   virtio_net: unify the code for recycling the xmit ptr
>   virtio_net: virtnet_poll_tx support rescheduled
>   virtio_net: independent directory
>   virtio_net: move to virtio_net.h
>   virtio_net: introduce virtnet_xdp_handler() to seprate the logic of
>     run xdp
>   virtio_net: receive_small() use virtnet_xdp_handler()
>   virtio_net: receive_merageable() use virtnet_xdp_handler()
>   virtio_net: introduce virtnet_tx_reset()
>   virtio_net: xsk: introduce virtnet_rq_bind_xsk_pool()
>   virtio_net: xsk: introduce virtnet_xsk_pool_enable()
>   virtio_net: xsk: introduce xsk disable
>   virtio_net: xsk: support xsk setup
>   virtio_net: xsk: stop disable tx napi
>   virtio_net: xsk: __free_old_xmit distinguishes xsk buffer
>   virtio_net: virtnet_sq_free_unused_buf() check xsk buffer
>   virtio_net: virtnet_rq_free_unused_buf() check xsk buffer
>   net: introduce napi_tx_raise()
>   virtio_net: xsk: tx: support tx
>   virtio_net: xsk: tx: support wakeup
>   virtio_net: xsk: tx: auto wakeup when free old xmit
>   virtio_net: xsk: rx: introduce add_recvbuf_xsk()
>   virtio_net: xsk: rx: introduce receive_xsk() to recv xsk buffer
> 
>  MAINTAINERS                                 |   2 +-
>  drivers/net/Kconfig                         |   8 +-
>  drivers/net/Makefile                        |   2 +-
>  drivers/net/virtio/Kconfig                  |  11 +
>  drivers/net/virtio/Makefile                 |   8 +
>  drivers/net/{virtio_net.c => virtio/main.c} | 564 +++++++-------------
>  drivers/net/virtio/virtio_net.h             | 317 +++++++++++
>  drivers/net/virtio/xsk.c                    | 524 ++++++++++++++++++
>  drivers/net/virtio/xsk.h                    |  33 ++
>  drivers/virtio/virtio_ring.c                | 376 +++++++++++--
>  include/linux/netdevice.h                   |   7 +
>  include/linux/virtio.h                      |  29 +
>  include/net/xsk_buff_pool.h                 |   6 +
>  net/core/dev.c                              |  11 +
>  net/xdp/xsk_buff_pool.c                     |  79 ++-
>  15 files changed, 1541 insertions(+), 436 deletions(-)
>  create mode 100644 drivers/net/virtio/Kconfig
>  create mode 100644 drivers/net/virtio/Makefile
>  rename drivers/net/{virtio_net.c => virtio/main.c} (92%)
>  create mode 100644 drivers/net/virtio/virtio_net.h
>  create mode 100644 drivers/net/virtio/xsk.c
>  create mode 100644 drivers/net/virtio/xsk.h
> 
> -- 
> 2.32.0.3.g01195cf9f

