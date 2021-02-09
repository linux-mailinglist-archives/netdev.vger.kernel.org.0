Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E3931586D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbhBIVPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 16:15:05 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:54445 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbhBIUtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:49:16 -0500
Date:   Tue, 09 Feb 2021 20:48:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612903699; bh=85QQJNudKIF3Xtg97Y7g4QbqbeIMU4YL32cELilgRjM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=jhApZdmS2S6jhwoIFR1qFMrJ6Ar22V773Peax4i31bvsu8PZ9fepGhgyUjViJmVhS
         7Xf5ZdSVsTMVkg8neW2VcsC8HSTrUjsSoLCvW/+KCp1HfitZdYSuYafr7U7YlatlP1
         E2MO4pNbPYQ9ztadhoqkSrfN9Kbl8nROfOZmQISwoTSo979kbbfKJ1n/y83Gj7oHsn
         OnSLcwikPEpLi78JUssBc2v+gEoA/RFkplg4sO0iulkPxhLosp87I+ar9ypnRJLMTu
         p4wG38GmF9XhNW1HNCpvliQv2lyBb6uZpyPXChyhFugUsX3lZiOn5qOV8VcOBrF2lp
         lvfyBv34dYsXg==
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
Subject: [v3 net-next 05/10] skbuff: use __build_skb_around() in __alloc_skb()
Message-ID: <20210209204533.327360-6-alobakin@pm.me>
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
2.30.0


