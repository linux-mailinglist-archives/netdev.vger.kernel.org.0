Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8F431AC1D
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 15:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBMONK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 09:13:10 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:45003 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhBMOMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 09:12:43 -0500
Date:   Sat, 13 Feb 2021 14:11:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613225518; bh=9n7R30ez+8NGaLh1O893hoIhJlElIMgk5xtfqPCBjQ8=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=RaAV81wOT41uf0Fa31OhDFMqkCf1CVw4TH+gpDIgD3MlVTgbBNfnfE6PeSbnRPG+u
         V+ST/ZLtmziiSrlCqKtmlR7rsqJeobYwCAZvr5Gt7Q5PWlDd/rwxlkeLjN1MbECCqH
         vTCUcue4t69Q0wH0v3ccGKUM6qRH57QNc1rC03sGhPIzZrwg3sd06ogsAgqIYyOOY2
         es/yJsC9QSQb5hl+Vwz6ORUgXNjUtAq2oeT+Cc/ftErL5G0yA8bscAkInz9VtoUkVn
         HLDikLfOV9VKWJlmdEug7cPZ8zd1yv4bvQ7lkx/EKZKq8uCIL6j3jwooZMx37jDxP1
         Y4j6GvtlE/lLQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v6 net-next 05/11] skbuff: use __build_skb_around() in __alloc_skb()
Message-ID: <20210213141021.87840-6-alobakin@pm.me>
In-Reply-To: <20210213141021.87840-1-alobakin@pm.me>
References: <20210213141021.87840-1-alobakin@pm.me>
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

Just call __build_skb_around() instead of open-coding it.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 88566de26cd1..1c6f6ef70339 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -326,7 +326,6 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gf=
p_mask,
 =09=09=09    int flags, int node)
 {
 =09struct kmem_cache *cache;
-=09struct skb_shared_info *shinfo;
 =09struct sk_buff *skb;
 =09u8 *data;
 =09bool pfmemalloc;
@@ -366,21 +365,8 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t g=
fp_mask,
 =09 * the tail pointer in struct sk_buff!
 =09 */
 =09memset(skb, 0, offsetof(struct sk_buff, tail));
-=09/* Account for allocated memory : skb + skb->head */
-=09skb->truesize =3D SKB_TRUESIZE(size);
+=09__build_skb_around(skb, data, 0);
 =09skb->pfmemalloc =3D pfmemalloc;
-=09refcount_set(&skb->users, 1);
-=09skb->head =3D data;
-=09skb->data =3D data;
-=09skb_reset_tail_pointer(skb);
-=09skb->end =3D skb->tail + size;
-=09skb->mac_header =3D (typeof(skb->mac_header))~0U;
-=09skb->transport_header =3D (typeof(skb->transport_header))~0U;
-
-=09/* make sure we initialize shinfo sequentially */
-=09shinfo =3D skb_shinfo(skb);
-=09memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
-=09atomic_set(&shinfo->dataref, 1);
=20
 =09if (flags & SKB_ALLOC_FCLONE) {
 =09=09struct sk_buff_fclones *fclones;
@@ -393,8 +379,6 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gf=
p_mask,
 =09=09fclones->skb2.fclone =3D SKB_FCLONE_CLONE;
 =09}
=20
-=09skb_set_kcov_handle(skb, kcov_common_handle());
-
 =09return skb;
=20
 nodata:
--=20
2.30.1


