Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DC1350056
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 14:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbhCaM3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 08:29:23 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:18000 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235733AbhCaM2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 08:28:44 -0400
Date:   Wed, 31 Mar 2021 12:28:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1617193722; bh=DzNNIhtueDbi5knSFF79jDSW/yjamllT21Rs5yAKrfU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Kiw5ofMJM0PoEIqciBjRNDDMl1JXXl/7oolEPXqHxm6Pc6fAd7cra4+dtICoPoeh0
         BiCIIgSL7w2rB7iHpkK55IPXHllbKzUktAimLk/a6gyj8fiJgXGt45DHNm37YP4GSq
         euu1UogxpGYjrVb9naM1L7rG7ekltnJa8irSdcC45Ni8fsBYpNTf67ZJRz6+1PWMhP
         DvPYDY83zvry5hFdv1k0VxZ7N2lbDHx1leA/cYa/0TwG1xwAJx7KReTIFnlIJNCva9
         GVQlYRe/b4yMmXJhviuscQ0UU5LYtUBseHqPf0Mi70/hP6xT41G8Q7pc5jXldOdNCo
         I4shqL0Ycj0Pw==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 bpf-next 2/2] xsk: introduce generic almost-zerocopy xmit
Message-ID: <20210331122820.6356-2-alobakin@pm.me>
In-Reply-To: <20210331122820.6356-1-alobakin@pm.me>
References: <20210331122602.6000-1-alobakin@pm.me> <20210331122820.6356-1-alobakin@pm.me>
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

The reasons behind IFF_TX_SKB_NO_LINEAR are:
 - most drivers expect skb with the linear space;
 - most drivers expect hard header in the linear space;
 - many drivers need some headroom to insert custom headers
   and/or pull headers from frags (pskb_may_pull() etc.).

With some bits of overhead, we can satisfy all of this without
inducing full buffer data copy.

Now frames that are bigger than 128 bytes (to mitigate allocation
overhead) are also being built using zerocopy path (if the device and
driver support S/G xmit, which is almost always true).
We allocate 256* additional bytes for skb linear space and pull hard
header there (aligning its end by 16 bytes for platforms with
NET_IP_ALIGN). The rest of the buffer data is just pinned as frags.
A room of at least 240 bytes is left for any driver needs.

We could just pass the buffer to eth_get_headlen() to minimize
allocation overhead and be able to copy all the headers into the
linear space, but the flow dissection procedure tends to be more
expensive than the current approach.

IFF_TX_SKB_NO_LINEAR path remains unchanged and is still actual and
generally faster.

* The value of 256 bytes is kinda "magic", it can be found in lots
  of drivers and places of core code and it is believed that 256
  bytes are enough to store any headers of any frame.

Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/xdp/xsk.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 41f8f21b3348..1d241f87422c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -445,6 +445,9 @@ static void xsk_destruct_skb(struct sk_buff *skb)
 =09sock_wfree(skb);
 }

+#define XSK_SKB_HEADLEN=09=09256
+#define XSK_COPY_THRESHOLD=09(XSK_SKB_HEADLEN / 2)
+
 static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
 =09=09=09=09=09      struct xdp_desc *desc)
 {
@@ -452,13 +455,21 @@ static struct sk_buff *xsk_build_skb_zerocopy(struct =
xdp_sock *xs,
 =09u32 hr, len, ts, offset, copy, copied;
 =09struct sk_buff *skb;
 =09struct page *page;
+=09bool need_pull;
 =09void *buffer;
 =09int err, i;
 =09u64 addr;

 =09hr =3D max(NET_SKB_PAD, L1_CACHE_ALIGN(xs->dev->needed_headroom));
+=09len =3D hr;
+
+=09need_pull =3D !(xs->dev->priv_flags & IFF_TX_SKB_NO_LINEAR);
+=09if (need_pull) {
+=09=09len +=3D XSK_SKB_HEADLEN;
+=09=09hr +=3D NET_IP_ALIGN;
+=09}

-=09skb =3D sock_alloc_send_skb(&xs->sk, hr, 1, &err);
+=09skb =3D sock_alloc_send_skb(&xs->sk, len, 1, &err);
 =09if (unlikely(!skb))
 =09=09return ERR_PTR(err);

@@ -488,6 +499,11 @@ static struct sk_buff *xsk_build_skb_zerocopy(struct x=
dp_sock *xs,
 =09skb->data_len +=3D len;
 =09skb->truesize +=3D ts;

+=09if (need_pull && unlikely(!__pskb_pull_tail(skb, ETH_HLEN))) {
+=09=09kfree_skb(skb);
+=09=09return ERR_PTR(-ENOMEM);
+=09}
+
 =09refcount_add(ts, &xs->sk.sk_wmem_alloc);

 =09return skb;
@@ -498,19 +514,20 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock =
*xs,
 {
 =09struct net_device *dev =3D xs->dev;
 =09struct sk_buff *skb;
+=09u32 len =3D desc->len;

-=09if (dev->priv_flags & IFF_TX_SKB_NO_LINEAR) {
+=09if ((dev->priv_flags & IFF_TX_SKB_NO_LINEAR) ||
+=09    (len > XSK_COPY_THRESHOLD && likely(dev->features & NETIF_F_SG))) {
 =09=09skb =3D xsk_build_skb_zerocopy(xs, desc);
 =09=09if (IS_ERR(skb))
 =09=09=09return skb;
 =09} else {
-=09=09u32 hr, tr, len;
 =09=09void *buffer;
+=09=09u32 hr, tr;
 =09=09int err;

 =09=09hr =3D max(NET_SKB_PAD, L1_CACHE_ALIGN(dev->needed_headroom));
 =09=09tr =3D dev->needed_tailroom;
-=09=09len =3D desc->len;

 =09=09skb =3D sock_alloc_send_skb(&xs->sk, hr + len + tr, 1, &err);
 =09=09if (unlikely(!skb))
--
2.31.1


