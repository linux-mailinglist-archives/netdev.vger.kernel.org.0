Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203F931D91D
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 13:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbhBQMFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 07:05:01 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:43509 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbhBQMCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 07:02:35 -0500
Date:   Wed, 17 Feb 2021 12:01:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613563312; bh=rD+msxxQv7QdHAN2CCbl57zhJ/ALAb4aGQXqzumABFM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=PT3LFaRlDYIV38fZI3I77r0E6FRjWTnolRzDMij8v+KHiOlF1PrjH6OD/eTLWIG/r
         vRO5YwIToJaBCQfuG3D8h85eevr57gs7i+gJp8O7wHlSUu4al7QRs91SMIn077+2EP
         4kYtYfHvMHVtcaW4f5bWsWWJ9vPRwjAoSx2Bhkh9/QRN45SuYmKeujZIcUIcvP0bc6
         BwMwNEc7+xBMyTU7alJelqBMMVLlanUgXbNCTImULuUCu5gDwKZsHSAH8+Z8/w0PbH
         RK6FzU95XwQ1b6MFWnLms29T1f6zGNv+w5d0Qr0PbX27GRFMFxtAhAmH3gqAOA6NBc
         Srtl/5xLIkMfg==
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
Subject: [PATCH v7 bpf-next 5/6] xsk: respect device's headroom and tailroom on generic xmit path
Message-ID: <20210217120003.7938-6-alobakin@pm.me>
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

xsk_generic_xmit() allocates a new skb and then queues it for
xmitting. The size of new skb's headroom is desc->len, so it comes
to the driver/device with no reserved headroom and/or tailroom.
Lots of drivers need some headroom (and sometimes tailroom) to
prepend (and/or append) some headers or data, e.g. CPU tags,
device-specific headers/descriptors (LSO, TLS etc.), and if case
of no available space skb_cow_head() will reallocate the skb.
Reallocations are unwanted on fast-path, especially when it comes
to XDP, so generic XSK xmit should reserve the spaces declared in
dev->needed_headroom and dev->needed tailroom to avoid them.

Note on max(NET_SKB_PAD, L1_CACHE_ALIGN(dev->needed_headroom)):

Usually, output functions reserve LL_RESERVED_SPACE(dev), which
consists of dev->hard_header_len + dev->needed_headroom, aligned
by 16.
However, on XSK xmit hard header is already here in the chunk, so
hard_header_len is not needed. But it'd still be better to align
data up to cacheline, while reserving no less than driver requests
for headroom. NET_SKB_PAD here is to double-insure there will be
no reallocations even when the driver advertises no needed_headroom,
but in fact need it (not so rare case).

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 4faabd1ecfd1..143979ea4165 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -454,12 +454,16 @@ static int xsk_generic_xmit(struct sock *sk)
 =09struct sk_buff *skb;
 =09unsigned long flags;
 =09int err =3D 0;
+=09u32 hr, tr;
=20
 =09mutex_lock(&xs->mutex);
=20
 =09if (xs->queue_id >=3D xs->dev->real_num_tx_queues)
 =09=09goto out;
=20
+=09hr =3D max(NET_SKB_PAD, L1_CACHE_ALIGN(xs->dev->needed_headroom));
+=09tr =3D xs->dev->needed_tailroom;
+
 =09while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
 =09=09char *buffer;
 =09=09u64 addr;
@@ -471,11 +475,13 @@ static int xsk_generic_xmit(struct sock *sk)
 =09=09}
=20
 =09=09len =3D desc.len;
-=09=09skb =3D sock_alloc_send_skb(sk, len, 1, &err);
+=09=09skb =3D sock_alloc_send_skb(sk, hr + len + tr, 1, &err);
 =09=09if (unlikely(!skb))
 =09=09=09goto out;
=20
+=09=09skb_reserve(skb, hr);
 =09=09skb_put(skb, len);
+
 =09=09addr =3D desc.addr;
 =09=09buffer =3D xsk_buff_raw_get_data(xs->pool, addr);
 =09=09err =3D skb_store_bits(skb, 0, buffer, len);
--=20
2.30.1


