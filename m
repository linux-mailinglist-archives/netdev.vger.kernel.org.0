Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54BD31D90B
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 13:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhBQMDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 07:03:31 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:40051 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbhBQMCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 07:02:25 -0500
Date:   Wed, 17 Feb 2021 12:01:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613563282; bh=uvsje6kXLionjEyqOvW16bSJRxCvIh50mtSZCtnJSvo=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=kl/0zkCDlZIHzDLdP/5tOn1YP0vKzpfihguDgaZk8EWz3aLwjyIeJUELieMqjCIGM
         StSJiu1OwQS4YKpoRsdNqv3A02k+fmOl2mKE2Q5FWECgR87zDRWXTVugtSju+qTHtZ
         3aM1A9OJtge0ioCnQpDpKLx4KO5e9R/ArpWICScYzx6905sMBXVyLUsyBhp9aupr+r
         YZny4I8Ix59HJ3rWh22kboNLIMswzbjb/2C85/kUPt0rk083qhgQFOwBcaq9VmFxaE
         NxE0xFKVZXz+rWoEnfT719F74HayUYByBxGwKug0dFRB4baEuZxykwOKdPyyK8rxGx
         IBOSJ5UkptpFA==
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
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
Subject: [PATCH v7 bpf-next 3/6] net: add priv_flags for allow tx skb without linear
Message-ID: <20210217120003.7938-4-alobakin@pm.me>
In-Reply-To: <20210217120003.7938-1-alobakin@pm.me>
References: <20210217120003.7938-1-alobakin@pm.me>
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
index 2c1a642ecdc0..1186ba901ad3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1518,6 +1518,8 @@ struct net_device_ops {
  * @IFF_FAILOVER_SLAVE_BIT: device is lower dev of a failover master devic=
e
  * @IFF_L3MDEV_RX_HANDLER_BIT: only invoke the rx handler of L3 master dev=
ice
  * @IFF_LIVE_RENAME_OK_BIT: rename is allowed while device is up and runni=
ng
+ * @IFF_TX_SKB_NO_LINEAR_BIT: device/driver is capable of xmitting frames =
with
+ *=09skb_headlen(skb) =3D=3D 0 (data starts from frag0)
  *
  * @NETDEV_PRIV_FLAG_COUNT: total priv flags count
  */
@@ -1553,6 +1555,7 @@ enum netdev_priv_flags {
 =09IFF_FAILOVER_SLAVE_BIT,
 =09IFF_L3MDEV_RX_HANDLER_BIT,
 =09IFF_LIVE_RENAME_OK_BIT,
+=09IFF_TX_SKB_NO_LINEAR_BIT,
=20
 =09NETDEV_PRIV_FLAG_COUNT,
 };
@@ -1595,6 +1598,7 @@ static_assert(sizeof(netdev_priv_flags_t) * BITS_PER_=
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


