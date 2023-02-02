Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11C8D687B04
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjBBLBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbjBBLBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:01:06 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF547712D9;
        Thu,  2 Feb 2023 03:01:04 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VakfWxy_1675335658;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VakfWxy_1675335658)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 19:00:59 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
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
Subject: [PATCH 00/33] virtio-net: support AF_XDP zero copy
Date:   Thu,  2 Feb 2023 19:00:25 +0800
Message-Id: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
MIME-Version: 1.0
X-Git-Hash: d7589ab6ea10
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP socket(AF_XDP) is an excellent bypass kernel network framework. The zero
copy feature of xsk (XDP socket) needs to be supported by the driver. The
performance of zero copy is very good. mlx5 and intel ixgbe already support
this feature, This patch set allows virtio-net to support xsk's zerocopy xmit
feature.

Virtio-net did not support per-queue reset, so it was impossible to support XDP
Socket Zerocopy. At present, we have completed the work of Virtio Spec and
Kernel in Per-Queue Reset. It is time for Virtio-Net to complete the support for
the XDP Socket Zerocopy.

Virtio-net can not increase the queue at will, so xsk shares the queue with
kernel.

On the other hand, Virtio-Net does not support generate interrupt manually, so
when we wakeup tx xmit, we used some tips. If the CPU run by TX NAPI last time
is other CPUs, use IPI to wake up NAPI on the remote CPU. If it is also the
local CPU, then we wake up sofrirqd.

Please review.

Thanks.


Xuan Zhuo (33):
  virtio_ring: virtqueue_add() support premapped
  virtio_ring: split: virtqueue_add_split() support premapped
  virtio_ring: packed: virtqueue_add_packed() support premapped
  virtio_ring: introduce virtqueue_add_outbuf_premapped()
  virtio_ring: introduce virtqueue_add_inbuf_premapped()
  virtio_ring: introduce virtqueue_reset()
  virtio_ring: add api virtio_dma_map() for advance dma
  virtio_ring: introduce dma sync api for virtio
  xsk: xsk_buff_pool add callback for dma_sync
  xsk: support virtio DMA map
  virtio_net: rename free_old_xmit_skbs to free_old_xmit
  virtio_net: unify the code for recycling the xmit ptr
  virtio_net: virtnet_poll_tx support rescheduled
  virtio_net: independent directory
  virtio_net: move to virtio_net.h
  virtio_net: introduce virtnet_xdp_handler() to seprate the logic of
    run xdp
  virtio_net: receive_small() use virtnet_xdp_handler()
  virtio_net: receive_merageable() use virtnet_xdp_handler()
  virtio_net: introduce virtnet_tx_reset()
  virtio_net: xsk: introduce virtnet_rq_bind_xsk_pool()
  virtio_net: xsk: introduce virtnet_xsk_pool_enable()
  virtio_net: xsk: introduce xsk disable
  virtio_net: xsk: support xsk setup
  virtio_net: xsk: stop disable tx napi
  virtio_net: xsk: __free_old_xmit distinguishes xsk buffer
  virtio_net: virtnet_sq_free_unused_buf() check xsk buffer
  virtio_net: virtnet_rq_free_unused_buf() check xsk buffer
  net: introduce napi_tx_raise()
  virtio_net: xsk: tx: support tx
  virtio_net: xsk: tx: support wakeup
  virtio_net: xsk: tx: auto wakeup when free old xmit
  virtio_net: xsk: rx: introduce add_recvbuf_xsk()
  virtio_net: xsk: rx: introduce receive_xsk() to recv xsk buffer

 MAINTAINERS                                 |   2 +-
 drivers/net/Kconfig                         |   8 +-
 drivers/net/Makefile                        |   2 +-
 drivers/net/virtio/Kconfig                  |  11 +
 drivers/net/virtio/Makefile                 |   8 +
 drivers/net/{virtio_net.c => virtio/main.c} | 564 +++++++-------------
 drivers/net/virtio/virtio_net.h             | 317 +++++++++++
 drivers/net/virtio/xsk.c                    | 524 ++++++++++++++++++
 drivers/net/virtio/xsk.h                    |  33 ++
 drivers/virtio/virtio_ring.c                | 376 +++++++++++--
 include/linux/netdevice.h                   |   7 +
 include/linux/virtio.h                      |  29 +
 include/net/xsk_buff_pool.h                 |   6 +
 net/core/dev.c                              |  11 +
 net/xdp/xsk_buff_pool.c                     |  79 ++-
 15 files changed, 1541 insertions(+), 436 deletions(-)
 create mode 100644 drivers/net/virtio/Kconfig
 create mode 100644 drivers/net/virtio/Makefile
 rename drivers/net/{virtio_net.c => virtio/main.c} (92%)
 create mode 100644 drivers/net/virtio/virtio_net.h
 create mode 100644 drivers/net/virtio/xsk.c
 create mode 100644 drivers/net/virtio/xsk.h

-- 
2.32.0.3.g01195cf9f

