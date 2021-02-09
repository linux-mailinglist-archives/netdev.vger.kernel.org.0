Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D82F315839
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbhBIU7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:59:33 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:52696 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbhBIUu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:50:59 -0500
Date:   Tue, 09 Feb 2021 20:47:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612903676; bh=TNjH2OfntVMafeUExGLXFCMb3pBMh6ePd4fTgzTIZmc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=ou0BO8btB9uj5a0JyAgEuRgYLVipOvJTcyXQOi23D/fvjJyTvSB7srawpn7P7pJlv
         vfZCVrUUnb62n9yoVR8JzDg6AR3qMF5uQD79ypOdZ88KiJNCuJAPk1GnHBbZ9pNbhB
         NxyU85YPrVN+ggVUuCTPKWC0ye97KNiCiuE+KxFDBAbJjxqvOrPSUeBNNgdLEJE3/M
         Hfkyya8tWEIAcXtQcH1eBSjxGcU08QVWI1/NHe0E5qcggi/f10kqZfT/Hh6y8PXFQf
         /j/f1V5D6RtEEKUHSY+oQ3wwc/0B6SLP0Bopk7d1C3qGQ1Gi0RysAnh2Bn7C08xdFf
         FucsqV32sg3Iw==
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
Subject: [v3 net-next 03/10] skbuff: make __build_skb_around() return void
Message-ID: <20210209204533.327360-4-alobakin@pm.me>
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

__build_skb_around() can never fail and always returns passed skb.
Make it return void to simplify and optimize the code.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 70289f22a6f4..c7d184e11547 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -120,8 +120,8 @@ static void skb_under_panic(struct sk_buff *skb, unsign=
ed int sz, void *addr)
 }
=20
 /* Caller must provide SKB that is memset cleared */
-static struct sk_buff *__build_skb_around(struct sk_buff *skb,
-=09=09=09=09=09  void *data, unsigned int frag_size)
+static void __build_skb_around(struct sk_buff *skb, void *data,
+=09=09=09       unsigned int frag_size)
 {
 =09struct skb_shared_info *shinfo;
 =09unsigned int size =3D frag_size ? : ksize(data);
@@ -144,8 +144,6 @@ static struct sk_buff *__build_skb_around(struct sk_buf=
f *skb,
 =09atomic_set(&shinfo->dataref, 1);
=20
 =09skb_set_kcov_handle(skb, kcov_common_handle());
-
-=09return skb;
 }
=20
 /**
@@ -176,8 +174,9 @@ struct sk_buff *__build_skb(void *data, unsigned int fr=
ag_size)
 =09=09return NULL;
=20
 =09memset(skb, 0, offsetof(struct sk_buff, tail));
+=09__build_skb_around(skb, data, frag_size);
=20
-=09return __build_skb_around(skb, data, frag_size);
+=09return skb;
 }
=20
 /* build_skb() is wrapper over __build_skb(), that specifically
@@ -210,9 +209,9 @@ struct sk_buff *build_skb_around(struct sk_buff *skb,
 =09if (unlikely(!skb))
 =09=09return NULL;
=20
-=09skb =3D __build_skb_around(skb, data, frag_size);
+=09__build_skb_around(skb, data, frag_size);
=20
-=09if (skb && frag_size) {
+=09if (frag_size) {
 =09=09skb->head_frag =3D 1;
 =09=09if (page_is_pfmemalloc(virt_to_head_page(data)))
 =09=09=09skb->pfmemalloc =3D 1;
--=20
2.30.0


