Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832D02FC580
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394595AbhASNrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:47:48 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:46361 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388109AbhASJqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 04:46:04 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0UMEN45h_1611049512;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UMEN45h_1611049512)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 19 Jan 2021 17:45:12 +0800
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
Subject: [PATCH bpf-next v2 0/3] xsk: build skb by page
Date:   Tue, 19 Jan 2021 17:45:09 +0800
Message-Id: <cover.1611048724.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:
    1. add priv_flags IFF_TX_SKB_NO_LINEAR instead of netdev_feature
    2. split the patch to three:
        a. add priv_flags IFF_TX_SKB_NO_LINEAR
        b. virtio net add priv_flags IFF_TX_SKB_NO_LINEAR
        c. When there is support this flag, construct skb without linear space
    3. use ERR_PTR() and PTR_ERR() to handle the err


v1 message log:
---------------

This patch is used to construct skb based on page to save memory copy
overhead.

This has one problem:

We construct the skb by fill the data page as a frag into the skb. In
this way, the linear space is empty, and the header information is also
in the frag, not in the linear space, which is not allowed for some
network cards. For example, Mellanox Technologies MT27710 Family
[ConnectX-4 Lx] will get the following error message:

    mlx5_core 0000:3b:00.1 eth1: Error cqe on cqn 0x817, ci 0x8, qn 0x1dbb, opcode 0xd, syndrome 0x1, vendor syndrome 0x68
    00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    00000030: 00 00 00 00 60 10 68 01 0a 00 1d bb 00 0f 9f d2
    WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0xf, len: 64
    00000000: 00 00 0f 0a 00 1d bb 03 00 00 00 08 00 00 00 00
    00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    00000020: 00 00 00 2b 00 08 00 00 00 00 00 05 9e e3 08 00
    00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    mlx5_core 0000:3b:00.1 eth1: ERR CQE on SQ: 0x1dbb

I also tried to use build_skb to construct skb, but because of the
existence of skb_shinfo, it must be behind the linear space, so this
method is not working. We can't put skb_shinfo on desc->addr, it will be
exposed to users, this is not safe.

Finally, I added a feature NETIF_F_SKB_NO_LINEAR to identify whether the
network card supports the header information of the packet in the frag
and not in the linear space.

---------------- Performance Testing ------------

The test environment is Aliyun ECS server.
Test cmd:
```
xdpsock -i eth0 -t  -S -s <msg size>
```

Test result data:

size    64      512     1024    1500
copy    1916747 1775988 1600203 1440054
page    1974058 1953655 1945463 1904478
percent 3.0%    10.0%   21.58%  32.3%


Xuan Zhuo (3):
  net: add priv_flags for allow tx skb without linear
  virtio-net: support IFF_TX_SKB_NO_LINEAR
  xsk: build skb by page

 drivers/net/virtio_net.c  |   3 +-
 include/linux/netdevice.h |   3 ++
 net/xdp/xsk.c             | 112 ++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 99 insertions(+), 19 deletions(-)

--
1.8.3.1

