Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED312F6F25
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 00:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbhANXzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 18:55:46 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:35906 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728545AbhANXzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 18:55:46 -0500
Date:   Thu, 14 Jan 2021 23:54:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610668503; bh=fkj15JFInAacwkcXWADIVGKRGYKKKaLvXr53v7A5jGA=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=AxpLtlAd9rxvfz1UeO9vM5UmufvzQ2aYxgRQVfTNt0hZaAwHMemLnVvS7bSZQDhaG
         bQeSbycH5J9BL7Q8gB/CkH7fXTHdcme+sT/OScqfEKwqscsnaANhcLkz8LVD/mLFGr
         GUsvJ5KCAx667B/64+HcbI1Mqh9FD0jKFPbobNeBV0ttXRZ6zdl7dSN7HlvwyVPpuF
         esE9drroF13bRyzZdjpuiHpUFNGmT43nWD4c0cgEr5TuKvjWupcaS1o/l/n/ExAvH0
         T7Dv5zgBx7bAO0wZAcs4HN+6kNyKGzI++b4ahBGwMphGWO/gcQXlT2iYzqWtxB4v0K
         Hu8JBdt2YjXFw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Guillaume Nault <gnault@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Marco Elver <elver@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net] skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too
Message-ID: <20210114235423.232737-1-alobakin@pm.me>
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

Commit 3226b158e67c ("net: avoid 32 x truesize under-estimation for
tiny skbs") ensured that skbs with data size lower than 1025 bytes
will be kmalloc'ed to avoid excessive page cache fragmentation and
memory consumption.
However, the same issue can still be achieved manually via
__netdev_alloc_skb(), where the check for size hasn't been changed.
Mirror the condition from __napi_alloc_skb() to prevent from that.

Fixes: 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny sk=
bs")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c1a6f262636a..785daff48030 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -437,7 +437,11 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *=
dev, unsigned int len,
=20
 =09len +=3D NET_SKB_PAD;
=20
-=09if ((len > SKB_WITH_OVERHEAD(PAGE_SIZE)) ||
+=09/* If requested length is either too small or too big,
+=09 * we use kmalloc() for skb->head allocation.
+=09 */
+=09if (len <=3D SKB_WITH_OVERHEAD(1024) ||
+=09    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
 =09    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
 =09=09skb =3D __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
 =09=09if (!skb)
--=20
2.30.0


