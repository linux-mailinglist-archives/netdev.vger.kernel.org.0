Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878C8687C91
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbjBBLpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjBBLpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:45:42 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BDD8B35E;
        Thu,  2 Feb 2023 03:45:40 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VaksnL5_1675338335;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VaksnL5_1675338335)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 19:45:36 +0800
Message-ID: <1675338247.0108669-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 00/33] virtio-net: support AF_XDP zero copy
Date:   Thu, 2 Feb 2023 19:44:07 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
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
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202060757-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230202060757-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Feb 2023 06:08:30 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Thu, Feb 02, 2023 at 07:00:25PM +0800, Xuan Zhuo wrote:
> > XDP socket(AF_XDP) is an excellent bypass kernel network framework. The zero
> > copy feature of xsk (XDP socket) needs to be supported by the driver. The
> > performance of zero copy is very good.
>
> Great! Any numbers to share?

RESEND. Last mail has some email format error.

ENV: Qemu with vhost.

                   vhost cpu | Guest APP CPU |Guest Softirq CPU | PPS
-----------------------------|---------------|------------------|------------
xmit by sockperf:     90%    |   100%        |                  |  318967
xmit by xsk:          100%   |   30%         |   33%            | 1192064
recv by sockperf:     100%   |   68%         |   100%           |  692288
recv by xsk:          100%   |   33%         |   43%            |  771670

Thanks.


>
> > mlx5 and intel ixgbe already support
> > this feature, This patch set allows virtio-net to support xsk's zerocopy xmit
> > feature.
> >
> > Virtio-net did not support per-queue reset, so it was impossible to support XDP
> > Socket Zerocopy. At present, we have completed the work of Virtio Spec and
> > Kernel in Per-Queue Reset. It is time for Virtio-Net to complete the support for
> > the XDP Socket Zerocopy.
> >
> > Virtio-net can not increase the queue at will, so xsk shares the queue with
> > kernel.
> >
> > On the other hand, Virtio-Net does not support generate interrupt manually, so
> > when we wakeup tx xmit, we used some tips. If the CPU run by TX NAPI last time
> > is other CPUs, use IPI to wake up NAPI on the remote CPU. If it is also the
> > local CPU, then we wake up sofrirqd.
> >
> > Please review.
> >
> > Thanks.
> >
> >
> > Xuan Zhuo (33):
> >   virtio_ring: virtqueue_add() support premapped
> >   virtio_ring: split: virtqueue_add_split() support premapped
> >   virtio_ring: packed: virtqueue_add_packed() support premapped
> >   virtio_ring: introduce virtqueue_add_outbuf_premapped()
> >   virtio_ring: introduce virtqueue_add_inbuf_premapped()
> >   virtio_ring: introduce virtqueue_reset()
> >   virtio_ring: add api virtio_dma_map() for advance dma
> >   virtio_ring: introduce dma sync api for virtio
> >   xsk: xsk_buff_pool add callback for dma_sync
> >   xsk: support virtio DMA map
> >   virtio_net: rename free_old_xmit_skbs to free_old_xmit
> >   virtio_net: unify the code for recycling the xmit ptr
> >   virtio_net: virtnet_poll_tx support rescheduled
> >   virtio_net: independent directory
> >   virtio_net: move to virtio_net.h
> >   virtio_net: introduce virtnet_xdp_handler() to seprate the logic of
> >     run xdp
> >   virtio_net: receive_small() use virtnet_xdp_handler()
> >   virtio_net: receive_merageable() use virtnet_xdp_handler()
> >   virtio_net: introduce virtnet_tx_reset()
> >   virtio_net: xsk: introduce virtnet_rq_bind_xsk_pool()
> >   virtio_net: xsk: introduce virtnet_xsk_pool_enable()
> >   virtio_net: xsk: introduce xsk disable
> >   virtio_net: xsk: support xsk setup
> >   virtio_net: xsk: stop disable tx napi
> >   virtio_net: xsk: __free_old_xmit distinguishes xsk buffer
> >   virtio_net: virtnet_sq_free_unused_buf() check xsk buffer
> >   virtio_net: virtnet_rq_free_unused_buf() check xsk buffer
> >   net: introduce napi_tx_raise()
> >   virtio_net: xsk: tx: support tx
> >   virtio_net: xsk: tx: support wakeup
> >   virtio_net: xsk: tx: auto wakeup when free old xmit
> >   virtio_net: xsk: rx: introduce add_recvbuf_xsk()
> >   virtio_net: xsk: rx: introduce receive_xsk() to recv xsk buffer
> >
> >  MAINTAINERS                                 |   2 +-
> >  drivers/net/Kconfig                         |   8 +-
> >  drivers/net/Makefile                        |   2 +-
> >  drivers/net/virtio/Kconfig                  |  11 +
> >  drivers/net/virtio/Makefile                 |   8 +
> >  drivers/net/{virtio_net.c => virtio/main.c} | 564 +++++++-------------
> >  drivers/net/virtio/virtio_net.h             | 317 +++++++++++
> >  drivers/net/virtio/xsk.c                    | 524 ++++++++++++++++++
> >  drivers/net/virtio/xsk.h                    |  33 ++
> >  drivers/virtio/virtio_ring.c                | 376 +++++++++++--
> >  include/linux/netdevice.h                   |   7 +
> >  include/linux/virtio.h                      |  29 +
> >  include/net/xsk_buff_pool.h                 |   6 +
> >  net/core/dev.c                              |  11 +
> >  net/xdp/xsk_buff_pool.c                     |  79 ++-
> >  15 files changed, 1541 insertions(+), 436 deletions(-)
> >  create mode 100644 drivers/net/virtio/Kconfig
> >  create mode 100644 drivers/net/virtio/Makefile
> >  rename drivers/net/{virtio_net.c => virtio/main.c} (92%)
> >  create mode 100644 drivers/net/virtio/virtio_net.h
> >  create mode 100644 drivers/net/virtio/xsk.c
> >  create mode 100644 drivers/net/virtio/xsk.h
> >
> > --
> > 2.32.0.3.g01195cf9f
>
