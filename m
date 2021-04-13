Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D56735D5B3
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 05:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344302AbhDMDPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 23:15:46 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:41778 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241101AbhDMDPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 23:15:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UVPZqgO_1618283723;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UVPZqgO_1618283723)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Apr 2021 11:15:23 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
Subject: [PATCH net-next v4 00/10] virtio-net support xdp socket zero copy xmit
Date:   Tue, 13 Apr 2021 11:15:13 +0800
Message-Id: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
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

And xsk's zerocopy rx has made major changes to virtio-net, and I hope to submit
it after this patch set are received.

Compared with other drivers, virtio-net does not directly obtain the dma
address, so I first obtain the xsk page, and then pass the page to virtio.

When recycling the sent packets, we have to distinguish between skb and xdp.
Now we have to distinguish between skb, xdp, xsk.

---------------- Performance Testing ------------

The udp package tool implemented by the interface of xsk vs sockperf(kernel udp)
for performance testing:

xsk zero copy xmit in virtio-net:
CPU        PPS         MSGSIZE    vhost-cpu
7.9%       511804      64         100%
13.3%%     484373      1500       100%

sockperf:
CPU        PPS         MSGSIZE    vhost-cpu
100%       375227      64         89.1%
100%       307322      1500       81.5%

v4:
    1. add priv_flags IFF_NOT_USE_DMA_ADDR
    2. more reasonable patch split


Xuan Zhuo (10):
  netdevice: priv_flags extend to 64bit
  netdevice: add priv_flags IFF_NOT_USE_DMA_ADDR
  virtio-net: add priv_flags IFF_NOT_USE_DMA_ADDR
  xsk: support get page by addr
  xsk: XDP_SETUP_XSK_POOL support option IFF_NOT_USE_DMA_ADDR
  virtio-net: unify the code for recycling the xmit ptr
  virtio-net: virtnet_poll_tx support budget check
  virtio-net: xsk zero copy xmit setup
  virtio-net: xsk zero copy xmit implement wakeup and xmit
  virtio-net: xsk zero copy xmit kick by threshold

 drivers/net/virtio_net.c   | 479 ++++++++++++++++++++++++++++++++-----
 include/linux/netdevice.h  | 139 ++++++-----
 include/net/xdp_sock_drv.h |  11 +
 net/xdp/xsk_buff_pool.c    |   2 +-
 4 files changed, 511 insertions(+), 120 deletions(-)

--
2.31.0

