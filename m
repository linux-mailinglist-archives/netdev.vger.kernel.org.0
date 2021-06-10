Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE603A26A4
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 10:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhFJIYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 04:24:10 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:42051 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230469AbhFJIYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 04:24:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0UbxH88i_1623313329;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UbxH88i_1623313329)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 10 Jun 2021 16:22:09 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v5 00/15] virtio-net: support xdp socket zero copy
Date:   Thu, 10 Jun 2021 16:21:54 +0800
Message-Id: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP socket is an excellent by pass kernel network transmission framework. The
zero copy feature of xsk (XDP socket) needs to be supported by the driver. The
performance of zero copy is very good. mlx5 and intel ixgbe already support this
feature, This patch set allows virtio-net to support xsk's zerocopy xmit
feature.

Compared with other drivers, the trouble with virtio-net is that when we bind
the channel to xsk, we cannot directly disable/enable the channel. So we have to
consider the buf that has been placed in the vq after the xsk is released by the
upper layer.

My solution is to add a ctx to each buf placed in vq to record the page used,
and add a reference to the page. So when the upper xsk is released, these pages
are still safe in vq. We will process these bufs when we recycle buf or
receive new data.

In the case of rx, it will be more complicated, because we may encounter the buf
of xsk, or it may be a normal buf. Especially in the case of merge, we may
receive multiple bufs, and these bufs may be xsk buf and normal are
mixed together.

v5:
   support rx

v4:
    1. add priv_flags IFF_NOT_USE_DMA_ADDR
    2. more reasonable patch split

Xuan Zhuo (15):
  netdevice: priv_flags extend to 64bit
  netdevice: add priv_flags IFF_NOT_USE_DMA_ADDR
  virtio-net: add priv_flags IFF_NOT_USE_DMA_ADDR
  xsk: XDP_SETUP_XSK_POOL support option IFF_NOT_USE_DMA_ADDR
  virtio: support virtqueue_detach_unused_buf_ctx
  virtio-net: unify the code for recycling the xmit ptr
  virtio-net: standalone virtnet_aloc_frag function
  virtio-net: split the receive_mergeable function
  virtio-net: virtnet_poll_tx support budget check
  virtio-net: independent directory
  virtio-net: move to virtio_net.h
  virtio-net: support AF_XDP zc tx
  virtio-net: support AF_XDP zc rx
  virtio-net: xsk direct xmit inside xsk wakeup
  virtio-net: xsk zero copy xmit kick by threshold

 MAINTAINERS                           |   2 +-
 drivers/net/Kconfig                   |   8 +-
 drivers/net/Makefile                  |   2 +-
 drivers/net/virtio/Kconfig            |  11 +
 drivers/net/virtio/Makefile           |   7 +
 drivers/net/{ => virtio}/virtio_net.c | 670 +++++++++++-----------
 drivers/net/virtio/virtio_net.h       | 288 ++++++++++
 drivers/net/virtio/xsk.c              | 766 ++++++++++++++++++++++++++
 drivers/net/virtio/xsk.h              | 176 ++++++
 drivers/virtio/virtio_ring.c          |  22 +-
 include/linux/netdevice.h             | 143 ++---
 include/linux/virtio.h                |   2 +
 net/8021q/vlanproc.c                  |   2 +-
 net/xdp/xsk_buff_pool.c               |   2 +-
 14 files changed, 1664 insertions(+), 437 deletions(-)
 create mode 100644 drivers/net/virtio/Kconfig
 create mode 100644 drivers/net/virtio/Makefile
 rename drivers/net/{ => virtio}/virtio_net.c (92%)
 create mode 100644 drivers/net/virtio/virtio_net.h
 create mode 100644 drivers/net/virtio/xsk.c
 create mode 100644 drivers/net/virtio/xsk.h

--
2.31.0

