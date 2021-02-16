Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C4D31CF05
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 18:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhBPR2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 12:28:32 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:37450 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhBPR2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 12:28:19 -0500
Date:   Tue, 16 Feb 2021 17:27:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613496456; bh=QDosC33QktE2waBddw6zce1oGZOsZXv08mklFMTqals=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Cew1qXA8sVizRsOO/sBB08Vvi2RQzlKUQKMjMedo4Dx6bqGc/ncLYLbpnVK8nCf0g
         xIdN0fBBx2xlZNBnv6oc7YLH6k8L6zzsW3AJUO3BKA/+Hqf/RRzvYX1feYv0y14JCc
         ukS8L2DrQc7Lp/vGIyR17NZgwVD/oBMAforC5kkw+MraAvrhOW+50mdE2odpVNNfDB
         /1wGWTK6dhfVVlUKC78p6qi0tOMEPd9s3edjarQHQcYNwtjMtAirCyi528sY6jjttY
         rWPEudmx75po4cj/tpbk6OfBXXAvLjHSD+p3+xzU49ywOD7eav8CE0o8PyOlCR76UF
         QKeHA9ZAqsuLA==
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
Subject: [PATCH v6 bpf-next 3/6] net: add priv_flags for allow tx skb without linear
Message-ID: <20210216172640.374487-4-alobakin@pm.me>
In-Reply-To: <20210216172640.374487-1-alobakin@pm.me>
References: <20210216172640.374487-1-alobakin@pm.me>
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

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

In some cases, we hope to construct skb directly based on the existing
memory without copying data. In this case, the page will be placed
directly in the skb, and the linear space of skb is empty. But
unfortunately, many the network card does not support this operation.
For example Mellanox Technologies MT27710 Family [ConnectX-4 Lx] will
get the following error message:

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

So a priv_flag is added here to indicate whether the network card
supports this feature.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Suggested-by: Alexander Lobakin <alobakin@pm.me>
[ alobakin: give a new flag more detailed description ]
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/netdevice.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0a9b2b31f411..ecaf67efab5b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1525,6 +1525,8 @@ struct net_device_ops {
  * @IFF_FAILOVER_SLAVE: device is lower dev of a failover master device
  * @IFF_L3MDEV_RX_HANDLER: only invoke the rx handler of L3 master device
  * @IFF_LIVE_RENAME_OK: rename is allowed while device is up and running
+ * @IFF_TX_SKB_NO_LINEAR: device/driver is capable of xmitting frames with
+ *=09skb_headlen(skb) =3D=3D 0 (data starts from frag0)
  */
 enum netdev_priv_flags {
 =09IFF_802_1Q_VLAN_BIT,
@@ -1558,6 +1560,7 @@ enum netdev_priv_flags {
 =09IFF_FAILOVER_SLAVE_BIT,
 =09IFF_L3MDEV_RX_HANDLER_BIT,
 =09IFF_LIVE_RENAME_OK_BIT,
+=09IFF_TX_SKB_NO_LINEAR_BIT,
=20
 =09NETDEV_PRIV_FLAG_COUNT,
 };
@@ -1600,6 +1603,7 @@ static_assert(sizeof(netdev_priv_flags_t) * BITS_PER_=
BYTE >=3D
 #define IFF_FAILOVER_SLAVE=09=09__IFF(FAILOVER_SLAVE)
 #define IFF_L3MDEV_RX_HANDLER=09=09__IFF(L3MDEV_RX_HANDLER)
 #define IFF_LIVE_RENAME_OK=09=09__IFF(LIVE_RENAME_OK)
+#define IFF_TX_SKB_NO_LINEAR=09=09__IFF(TX_SKB_NO_LINEAR)
=20
 /**
  *=09struct net_device - The DEVICE structure.
--=20
2.30.1


