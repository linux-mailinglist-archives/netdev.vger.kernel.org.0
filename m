Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9292F7EE8
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 16:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732728AbhAOPFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 10:05:32 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:33531 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbhAOPFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 10:05:31 -0500
Date:   Fri, 15 Jan 2021 15:04:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610723089; bh=2oo8j0bPGH6PgdbONPcPCL6akNQMZOzVlG5AWg81tgk=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=OiMHZ41B2gEwXP7zksVL6ZWiLD7JE9eEaMjy5SRPNRNd+4lAn74xloZaOpVF5BGmy
         cuus3rCgP739fKqxfgEJFUCP+nIgmukJRktNV7pBt2i57jyb//uRmYUurQT6fGn0Sk
         oCx079r0SNkM1DezSGILFfLW542kOOimgSNh7ICMwYxev0iHPjmoCZ6zOBhbuy+SHW
         nKr2ILfUgk7vKYEQktoWQAaQoP7NQfflCI52+m9Z1K8gpxOsJw8dztOhIvneGy/KHI
         jqBGXKH14jrW34XZzpoPVP3SHKUjvgPNqhIEUA858KNFiD8rxciuWVYoftaty0VSmT
         rHJh6i5d3Z/dg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Florian Westphal <fw@strlen.de>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Marco Elver <elver@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net] skbuff: back tiny skbs with kmalloc() in __netdev_alloc_skb() too
Message-ID: <20210115150354.85967-1-alobakin@pm.me>
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
However, the fix adressed only __napi_alloc_skb() (primarily for
virtio_net and napi_get_frags()), but the issue can still be achieved
through __netdev_alloc_skb(), which is still used by several drivers.
Drivers often allocate a tiny skb for headers and place the rest of
the frame to frags (so-called copybreak).
Mirror the condition to __netdev_alloc_skb() to handle this case too.

Since v1 [0]:
 - fix "Fixes:" tag;
 - refine commit message (mention copybreak usecase).

[0] https://lore.kernel.org/netdev/20210114235423.232737-1-alobakin@pm.me

Fixes: a1c7fff7e18f ("net: netdev_alloc_skb() use build_skb()")
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


