Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0169C2F1E12
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390592AbhAKSae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:30:34 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:35082 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390532AbhAKSac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:30:32 -0500
Date:   Mon, 11 Jan 2021 18:29:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610389789; bh=ed2E3ZDT8/tIMKq0U8JNRKLCBc4eky4hYA4RXRAiMWs=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=XrpbpgkFYGY8WwMuHq87QqgNIu7l+lsA2yUPH41gqPBBZh3R/kMs6CFmeinU1Zsr5
         z58eX9902Rn+oIxj0Cb/AgwmHkbw/RfKHgK019AIcX7euBUWPADyc5rsXFEjOXcEkR
         vbRB30hBlfCaiQ5x38bHxwxM3fkR1dCEZGjnWqxtFYSAWIsIWEElj/BbtBZmqMHoIl
         +XhBUJVawl6/qs0Hs2RrKG/B66moh68B4SuT61suhO0XLQhjlRkuiZLAnIQjyxc0bD
         wOs4lyl1MI62nGmjE9goqazW3kLnrs8eaRRLtvYkFrrO4646b64vzr64wvozj3vrvo
         G/PxsoNsEPXUg==
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
Subject: [PATCH net-next 5/5] skbuff: refill skb_cache early from deferred-to-consume entries
Message-ID: <20210111182801.12609-5-alobakin@pm.me>
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

Instead of unconditional queueing of ready-to-consume skbuff_heads
to flush_skb_cache, feed skb_cache with them instead if it's not
full already.
This greatly reduces the frequency of kmem_cache_alloc_bulk() calls.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 57a7307689f3..ba0d5611635e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -904,6 +904,11 @@ static inline void _kfree_skb_defer(struct sk_buff *sk=
b)
 =09/* drop skb->head and call any destructors for packet */
 =09skb_release_all(skb);
=20
+=09if (nc->skb_count < NAPI_SKB_CACHE_SIZE) {
+=09=09nc->skb_cache[nc->skb_count++] =3D skb;
+=09=09return;
+=09}
+
 =09/* record skb to CPU local list */
 =09nc->flush_skb_cache[nc->flush_skb_count++] =3D skb;
=20
--=20
2.30.0


