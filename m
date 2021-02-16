Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE1731CC14
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 15:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhBPOfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 09:35:47 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:53165 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbhBPOfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 09:35:32 -0500
Date:   Tue, 16 Feb 2021 14:34:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613486083; bh=lgg1wNkMT8XQOATCoVN+lIKDRAuSPLux4jRMr6UVN+I=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=n3+ZZewhVF2gv5WzYKrGyZ+FQUQzcddVc+ZixijiqEj+LEY0b4hinVo/gu/NhpJk7
         zU1ytXnLhMiX5Tz1y9wIb5PsYIla6Can2VQF0f5dFvx402pJ0qghGQY3JYGSR/eYJf
         HYkzCdeknwMSK9qEd7YqZAcVuaS9vZU/4GRlriSxVV/z+TYUswblA4y/QBM9A6iq43
         nUFRZg1XYSya/me4EPkjUX4xj/n4McwQYrLztj+Eb47NTZwaN8yVI4Yk0fXtdHG3PW
         mYTGLZBD7x7ytCiVEOrwA1cB/MS2Hwn2mYfOX60y3rIpbyCweP71Mz2ZMe7FN/Jkd2
         O7HIwMR/z0zpg==
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
Subject: [PATCH v5 bpf-next 4/6] virtio-net: support IFF_TX_SKB_NO_LINEAR
Message-ID: <20210216143333.5861-5-alobakin@pm.me>
In-Reply-To: <20210216143333.5861-1-alobakin@pm.me>
References: <20210216143333.5861-1-alobakin@pm.me>
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

Virtio net supports the case where the skb linear space is empty, so add
priv_flags.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/virtio_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ba8e63792549..f2ff6c3906c1 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2972,7 +2972,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 =09=09return -ENOMEM;
=20
 =09/* Set up network device as normal. */
-=09dev->priv_flags |=3D IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE;
+=09dev->priv_flags |=3D IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
+=09=09=09   IFF_TX_SKB_NO_LINEAR;
 =09dev->netdev_ops =3D &virtnet_netdev;
 =09dev->features =3D NETIF_F_HIGHDMA;
=20
--=20
2.30.1


