Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10DD2F8ADB
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 04:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbhAPDAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 22:00:13 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:51008 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728493AbhAPDAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 22:00:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0ULrQCZk_1610765968;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0ULrQCZk_1610765968)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 16 Jan 2021 10:59:28 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
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
Subject: [PATCH net-next v2 0/7] virtio-net support xdp socket zero copy xmit
Date:   Sat, 16 Jan 2021 10:59:21 +0800
Message-Id: <cover.1610765285.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
References: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
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
Now we have to distinguish between skb, xdp, xsk. So the second patch solves
this problem first.

The last four patches are used to support xsk zerocopy in virtio-net:

 1. support xsk enable/disable
 2. realize the function of xsk packet sending
 3. implement xsk wakeup callback
 4. set xsk completed when packet sent done


---------------- Performance Testing ------------

The udp package tool implemented by the interface of xsk vs sockperf(kernel udp)
for performance testing:

xsk zero copy in virtio-net:
CPU        PPS         MSGSIZE
28.7%      3833857     64
38.5%      3689491     512
38.9%      2787096     1456

xsk without zero copy in virtio-net:
CPU        PPS         MSGSIZE
100%       1916747     64
100%       1775988     512
100%       1440054     1456

sockperf:
CPU        PPS         MSGSIZE
100%       713274      64
100%       701024      512
100%       695832      1456

Xuan Zhuo (7):
  xsk: support get page for drv
  virtio-net, xsk: distinguish XDP_TX and XSK XMIT ctx
  xsk, virtio-net: prepare for support xsk zerocopy xmit
  virtio-net, xsk: support xsk enable/disable
  virtio-net, xsk: realize the function of xsk packet sending
  virtio-net, xsk: implement xsk wakeup callback
  virtio-net, xsk: set xsk completed when packet sent done

 drivers/net/virtio_net.c    | 559 +++++++++++++++++++++++++++++++++++++++-----
 include/linux/netdevice.h   |   1 +
 include/net/xdp_sock_drv.h  |  10 +
 include/net/xsk_buff_pool.h |   1 +
 net/xdp/xsk_buff_pool.c     |  10 +-
 5 files changed, 523 insertions(+), 58 deletions(-)

--
1.8.3.1

