Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EF331C9EF
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 12:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhBPLks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 06:40:48 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:25232 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhBPLjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 06:39:01 -0500
Date:   Tue, 16 Feb 2021 11:38:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613475495; bh=7//j7y6xoZuLy2Ngmv+kjotOmXPJtO9KtcN3PXcUSkQ=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=UR4bFjUVK9exL1LGEM/AUDMtHefnF+AYxkSGYHfIuuTYibotYnneCzbLfSH25ETll
         3sZ7j8t0yPcz+LQVqbPQgctzQBPqc/xUMQpD44biUTxn68PXOeAasfYoCI/JmDkirJ
         Ih+TBLt+inppDmtRCBP/XdqR+G3tn2q2OyuyY7WaUiZiqC/DWbSaZpJCh8Vm9hyaqg
         LQp5EnEkGVNvacnPk8Pu+Y4TrWLo9gD6Oxxc+yeoQDIMxAxGZkS5uIzcsf4rZPSPTm
         Rpk1Obtl8HfjPqOdHERYtF5qtMEf10jJqEmtupATBMFpFt/t7G3j8qgczwlCJLfdNA
         iz5yhj+A6ApaA==
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Alexander Lobakin <alobakin@pm.me>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v4 bpf-next 0/6] xsk: build skb by page (aka generic zerocopy xmit)
Message-ID: <20210216113740.62041-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces XSK generic zerocopy xmit by adding XSK umem
pages as skb frags instead of copying data to linear space.
The only requirement for this for drivers is to be able to xmit skbs
with skb_headlen(skb) =3D=3D 0, i.e. all data including hard headers
starts from frag 0.
To indicate whether a particular driver supports this, a new netdev
priv flag, IFF_TX_SKB_NO_LINEAR, is added (and declared in virtio_net
as it's already capable of doing it). So consider implementing this
in your drivers to greatly speed-up generic XSK xmit.

The first two bits refactor netdev_priv_flags a bit to harden them
in terms of bitfield overflow, as IFF_TX_SKB_NO_LINEAR is the last
one that fits into unsigned int.
The fifth patch adds headroom and tailroom reservations for the
allocated skbs on XSK generic xmit path. This ensures there won't
be any unwanted skb reallocations on fast-path due to headroom and/or
tailroom driver/device requirements (own headers/descriptors etc.).
The other three add a new private flag, declare it in virtio_net
driver and introduce generic XSK zerocopy xmit itself.

The main body of work is created and done by Xuan Zhuo. His original
cover letter:

v3:
    Optimized code

v2:
    1. add priv_flags IFF_TX_SKB_NO_LINEAR instead of netdev_feature
    2. split the patch to three:
        a. add priv_flags IFF_TX_SKB_NO_LINEAR
        b. virtio net add priv_flags IFF_TX_SKB_NO_LINEAR
        c. When there is support this flag, construct skb without linear
           space
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

    mlx5_core 0000:3b:00.1 eth1: Error cqe on cqn 0x817, ci 0x8,
    qn 0x1dbb, opcode 0xd, syndrome 0x1, vendor syndrome 0x68
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

From v3 [0]:
 - refactor netdev_priv_flags to make it easier to add new ones and
   prevent bitwidth overflow;
 - add headroom (both standard and zerocopy) and tailroom (standard)
   reservation in skb for drivers to avoid potential reallocations;
 - fix skb->truesize accounting;
 - misc comment rewords.

[0] https://lore.kernel.org/netdev/cover.1611236588.git.xuanzhuo@linux.alib=
aba.com

Alexander Lobakin (3):
  netdev_priv_flags: add missing IFF_PHONY_HEADROOM self-definition
  netdevice: check for net_device::priv_flags bitfield overflow
  xsk: respect device's headroom and tailroom on generic xmit path

Xuan Zhuo (3):
  net: add priv_flags for allow tx skb without linear
  virtio-net: support IFF_TX_SKB_NO_LINEAR
  xsk: build skb by page (aka generic zerocopy xmit)

 drivers/net/virtio_net.c  |   3 +-
 include/linux/netdevice.h | 138 +++++++++++++++++++++-----------------
 net/xdp/xsk.c             | 113 ++++++++++++++++++++++++++-----
 3 files changed, 173 insertions(+), 81 deletions(-)

--=20
2.30.1


