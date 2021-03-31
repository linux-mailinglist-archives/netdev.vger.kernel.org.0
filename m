Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FFF34F984
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 09:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbhCaHLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 03:11:47 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:59568 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233843AbhCaHLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 03:11:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0UTvzwhh_1617174699;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UTvzwhh_1617174699)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 31 Mar 2021 15:11:39 +0800
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
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next v3 0/8] virtio-net support xdp socket zero copy xmit
Date:   Wed, 31 Mar 2021 15:11:31 +0800
Message-Id: <20210331071139.15473-1-xuanzhuo@linux.alibaba.com>
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

#0 #1 made some adjustments to xsk.

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

Xuan Zhuo (8):
  xsk: XDP_SETUP_XSK_POOL support option check_dma
  xsk: support get page by addr
  virtio-net: xsk zero copy xmit setup
  virtio-net: xsk zero copy xmit implement wakeup and xmit
  virtio-net: xsk zero copy xmit support xsk unaligned mode
  virtio-net: xsk zero copy xmit kick by threshold
  virtio-net: poll tx call xsk zerocopy xmit
  virtio-net: free old xmit handle xsk

 drivers/net/virtio_net.c   | 449 +++++++++++++++++++++++++++++++++----
 include/linux/netdevice.h  |   1 +
 include/net/xdp_sock_drv.h |  11 +
 net/xdp/xsk_buff_pool.c    |   3 +-
 4 files changed, 415 insertions(+), 49 deletions(-)

--
2.31.0

