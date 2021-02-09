Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A657D315837
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbhBIU7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:59:19 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:64982 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbhBIUvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:51:08 -0500
Date:   Tue, 09 Feb 2021 20:48:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612903727; bh=2ZGDTP+U1Ebxj8vWtkJrsSoHhtkyLcBn7TvjRNc6gew=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=VlKfBN/r+GewNxB0eXUx8LKYeZatc5GhKMZhyyw6gWk6e44G+zbpeQMgWe6f6wPCW
         hfzy4q2QMvXBU2xTq8yXZu+uQq4Jbk7Q9a6aXjxtcJ6Ks+boM30JzLw+3DXU1u83dn
         dI7hYcVSW89Kj87Ij/mnikLb+1TkI7nCXNlM+syGZMQI+sSt/N5jiQVWzVE1In8NVA
         mymbj9ASCWyyeJF0J5zK+JDn06Vje0YfHjdI4z6xoqI/hzLxx5HQp6dc9j8xXkWILH
         rEZdWWrRBETwcNKqUTe3uc1EIx996qJyQ0hXfcGZ2sWBusIjIP5J5BXTA2YMZNx7j2
         Cgd4bUS4ALdzQ==
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
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yonghong Song <yhs@fb.com>, zhudi <zhudi21@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [v3 net-next 07/10] skbuff: move NAPI cache declarations upper in the file
Message-ID: <20210209204533.327360-8-alobakin@pm.me>
In-Reply-To: <20210209204533.327360-1-alobakin@pm.me>
References: <20210209204533.327360-1-alobakin@pm.me>
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

NAPI cache structures will be used for allocating skbuff_heads,
so move their declarations a bit upper.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 90 +++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4be2bb969535..860a9d4f752f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -119,6 +119,51 @@ static void skb_under_panic(struct sk_buff *skb, unsig=
ned int sz, void *addr)
 =09skb_panic(skb, sz, addr, __func__);
 }
=20
+#define NAPI_SKB_CACHE_SIZE=0964
+
+struct napi_alloc_cache {
+=09struct page_frag_cache page;
+=09unsigned int skb_count;
+=09void *skb_cache[NAPI_SKB_CACHE_SIZE];
+};
+
+static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
+static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
+
+static void *__alloc_frag_align(unsigned int fragsz, gfp_t gfp_mask,
+=09=09=09=09unsigned int align_mask)
+{
+=09struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
+
+=09return page_frag_alloc_align(&nc->page, fragsz, gfp_mask, align_mask);
+}
+
+void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask=
)
+{
+=09fragsz =3D SKB_DATA_ALIGN(fragsz);
+
+=09return __alloc_frag_align(fragsz, GFP_ATOMIC, align_mask);
+}
+EXPORT_SYMBOL(__napi_alloc_frag_align);
+
+void *__netdev_alloc_frag_align(unsigned int fragsz, unsigned int align_ma=
sk)
+{
+=09struct page_frag_cache *nc;
+=09void *data;
+
+=09fragsz =3D SKB_DATA_ALIGN(fragsz);
+=09if (in_irq() || irqs_disabled()) {
+=09=09nc =3D this_cpu_ptr(&netdev_alloc_cache);
+=09=09data =3D page_frag_alloc_align(nc, fragsz, GFP_ATOMIC, align_mask);
+=09} else {
+=09=09local_bh_disable();
+=09=09data =3D __alloc_frag_align(fragsz, GFP_ATOMIC, align_mask);
+=09=09local_bh_enable();
+=09}
+=09return data;
+}
+EXPORT_SYMBOL(__netdev_alloc_frag_align);
+
 /* Caller must provide SKB that is memset cleared */
 static void __build_skb_around(struct sk_buff *skb, void *data,
 =09=09=09       unsigned int frag_size)
@@ -220,51 +265,6 @@ struct sk_buff *build_skb_around(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(build_skb_around);
=20
-#define NAPI_SKB_CACHE_SIZE=0964
-
-struct napi_alloc_cache {
-=09struct page_frag_cache page;
-=09unsigned int skb_count;
-=09void *skb_cache[NAPI_SKB_CACHE_SIZE];
-};
-
-static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
-static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
-
-static void *__alloc_frag_align(unsigned int fragsz, gfp_t gfp_mask,
-=09=09=09=09unsigned int align_mask)
-{
-=09struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
-
-=09return page_frag_alloc_align(&nc->page, fragsz, gfp_mask, align_mask);
-}
-
-void *__napi_alloc_frag_align(unsigned int fragsz, unsigned int align_mask=
)
-{
-=09fragsz =3D SKB_DATA_ALIGN(fragsz);
-
-=09return __alloc_frag_align(fragsz, GFP_ATOMIC, align_mask);
-}
-EXPORT_SYMBOL(__napi_alloc_frag_align);
-
-void *__netdev_alloc_frag_align(unsigned int fragsz, unsigned int align_ma=
sk)
-{
-=09struct page_frag_cache *nc;
-=09void *data;
-
-=09fragsz =3D SKB_DATA_ALIGN(fragsz);
-=09if (in_irq() || irqs_disabled()) {
-=09=09nc =3D this_cpu_ptr(&netdev_alloc_cache);
-=09=09data =3D page_frag_alloc_align(nc, fragsz, GFP_ATOMIC, align_mask);
-=09} else {
-=09=09local_bh_disable();
-=09=09data =3D __alloc_frag_align(fragsz, GFP_ATOMIC, align_mask);
-=09=09local_bh_enable();
-=09}
-=09return data;
-}
-EXPORT_SYMBOL(__netdev_alloc_frag_align);
-
 /*
  * kmalloc_reserve is a wrapper around kmalloc_node_track_caller that tell=
s
  * the caller if emergency pfmemalloc reserves are being used. If it is an=
d
--=20
2.30.0


