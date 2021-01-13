Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A172F4C51
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 14:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbhAMNhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 08:37:45 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:34210 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbhAMNho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 08:37:44 -0500
Date:   Wed, 13 Jan 2021 13:36:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610545022; bh=Wxlzuo0a4dl7vh+BrgTHx6uBHCVOGXVNozBxr9mFN2Q=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Wx4+MmnLUv7niL6jpu4x8NgcUVxpCedUpf2G7Die60hRiBHBYW7TJZc6f49knbxc7
         j+T8zI+kcDE+xNf163xH0m8LL7M8jLY1PQR6Q/WPuBa4rNUS4U4Ir+LfMU0RxiSiix
         IvHCcTXLujUw+fgn7WH+hCVLrVPfdl3kxRT1fU1J39JKUUZ1GHozTITOJEzDdPfyQ2
         xRwNhQB74LcBdu//REEbDKZ0MQvy7RJ6RHTzDNHdkha8UbkMN9u2YyBo/2xZkXmEFN
         3TYZLFyVPZCGDTccc7djvGnngSiuMgUGadbFBaAWVfLUAX5hMcfkZHEspa+oO83v5n
         Dvur77vAI5Ykw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net-next 1/3] skbuff: open-code __build_skb() inside __napi_alloc_skb()
Message-ID: <20210113133635.39402-1-alobakin@pm.me>
In-Reply-To: <20210113133523.39205-1-alobakin@pm.me>
References: <20210113133523.39205-1-alobakin@pm.me>
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

In preparation for skbuff_heads caching and reusing, open-code
__build_skb() inside __napi_alloc_skb() with factoring out
the skbbuff_head allocation itself.
Note that the return value of __build_skb_around() is not checked
since it never returns anything except the given skb.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7626a33cce59..dc3300dc2ac4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -485,6 +485,11 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *=
dev, unsigned int len,
 }
 EXPORT_SYMBOL(__netdev_alloc_skb);
=20
+static struct sk_buff *napi_skb_cache_get(struct napi_alloc_cache *nc)
+{
+=09return kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
+}
+
 /**
  *=09__napi_alloc_skb - allocate skbuff for rx in a specific NAPI instance
  *=09@napi: napi instance this buffer was allocated for
@@ -525,12 +530,15 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *=
napi, unsigned int len,
 =09if (unlikely(!data))
 =09=09return NULL;
=20
-=09skb =3D __build_skb(data, len);
+=09skb =3D napi_skb_cache_get(nc);
 =09if (unlikely(!skb)) {
 =09=09skb_free_frag(data);
 =09=09return NULL;
 =09}
=20
+=09memset(skb, 0, offsetof(struct sk_buff, tail));
+=09__build_skb_around(skb, data, len);
+
 =09if (nc->page.pfmemalloc)
 =09=09skb->pfmemalloc =3D 1;
 =09skb->head_frag =3D 1;
--=20
2.30.0


