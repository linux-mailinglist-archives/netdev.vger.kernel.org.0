Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E422F1E07
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390516AbhAKS3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:29:48 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:16187 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390502AbhAKS3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:29:47 -0500
Date:   Mon, 11 Jan 2021 18:29:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610389745; bh=uLN743u/wqC/gFFuGPFTwvMOdJ2kjErr9WqlX51ROd4=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=nkuQl8J/da2u0Tmb+7OxCZKNk/wFExeqrMkX5jgpkqnU+jSg6DqQjd6fHnytlLjUZ
         Qq1kC/v0PSwTbZe+uPUjwnnrFgnV3xb9mIcRVucIkZaA5u6jAiuO3zKw1nS30pIFgx
         JhKH/V3eBxsc5KHmPKrKViFH0mRAjmD4hxD6mDzMrOPgf2JJzIdB9i5qM3jVvRvopq
         eqBFwDzQZYsk1pelTAGCJRLjb1STPtge7qU3qLsc6xxv8JfQeqBfT1aFAaWB6hU/Fq
         xdq383aD6ZHBBE9XLXWbWYrKRt+fTepkRePEZQBy/BUXTHTgf0dnrZerIjgHq2JTWr
         MB0QOp3VQR+KQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree@solarflare.com>,
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
Subject: [PATCH net-next 3/5] skbuff: reuse skbuff_heads from flush_skb_cache if available
Message-ID: <20210111182801.12609-3-alobakin@pm.me>
In-Reply-To: <20210111182801.12609-1-alobakin@pm.me>
References: <20210111182655.12159-1-alobakin@pm.me> <20210111182801.12609-1-alobakin@pm.me>
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

Instead of unconditional allocating a new skbuff_head and
unconditional flushing of flush_skb_cache, reuse the ones queued
up for flushing if there are any.
skbuff_heads stored in flush_skb_cache are already unreferenced
from any pages or extensions and almost ready for use. We perform
zeroing in __napi_alloc_skb() anyway, regardless of where did our
skbuff_head came from.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3c904c29efbb..0e8c597ff6ce 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -487,6 +487,9 @@ EXPORT_SYMBOL(__netdev_alloc_skb);
=20
 static struct sk_buff *__napi_decache_skb(struct napi_alloc_cache *nc)
 {
+=09if (nc->flush_skb_count)
+=09=09return nc->flush_skb_cache[--nc->flush_skb_count];
+
 =09return kmem_cache_alloc(skbuff_head_cache, GFP_ATOMIC);
 }
=20
--=20
2.30.0


