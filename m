Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE542EA706
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 10:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbhAEJM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 04:12:28 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:34423 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726664AbhAEJM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 04:12:28 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0UKog-sy_1609837903;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UKog-sy_1609837903)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 05 Jan 2021 17:11:44 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     dust.li@linux.alibaba.com, tonylu@linux.alibaba.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        virtualization@lists.linux-foundation.org (open list:VIRTIO CORE AND
        NET DRIVERS), linux-kernel@vger.kernel.org (open list),
        bpf@vger.kernel.org (open list:XDP SOCKETS (AF_XDP))
Subject: [PATCH netdev 0/5] virtio-net support xdp socket zero copy xmit
Date:   Tue,  5 Jan 2021 17:11:38 +0800
Message-Id: <cover.1609837120.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch made some adjustments to xsk.

The second patch itself can be used as an independent patch to solve the problem
that XDP may fail to load when the number of queues is insufficient.

The third to last patch implements support for xsk in virtio-net.

A practical problem with virtio is that tx interrupts are not very reliable.
There will always be some missing or delayed tx interrupts. So I specially added
a point timer to solve this problem. Of course, considering performance issues,
The timer only triggers when the ring of the network card is full.

Regarding the issue of virtio-net supporting xsk's zero copy rx, I am also
developing it, but I found that the modification may be relatively large, so I
consider this patch set to be separated from the code related to xsk zero copy
rx.

Xuan Zhuo (5):
  xsk: support get page for drv
  virtio-net: support XDP_TX when not more queues
  virtio-net, xsk: distinguish XDP_TX and XSK XMIT ctx
  xsk, virtio-net: prepare for support xsk
  virtio-net, xsk: virtio-net support xsk zero copy tx

 drivers/net/virtio_net.c    | 643 +++++++++++++++++++++++++++++++++++++++-----
 include/linux/netdevice.h   |   1 +
 include/net/xdp_sock_drv.h  |  10 +
 include/net/xsk_buff_pool.h |   1 +
 net/xdp/xsk_buff_pool.c     |  10 +-
 5 files changed, 597 insertions(+), 68 deletions(-)

--
1.8.3.1

