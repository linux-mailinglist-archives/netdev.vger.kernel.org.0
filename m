Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EF7316B53
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbhBJQda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:33:30 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:62507 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbhBJQcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:32:10 -0500
Date:   Wed, 10 Feb 2021 16:30:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612974661; bh=dc++kGDTpe3XCTBAPmEcG2/TX7zpcf+/Bxeoau5z4Vs=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=fy526hQgcD9tBMZSjWCzYwbc1w9JdM2ekXfXImzYZTtgWlUn4MNvT+pUf2zBNKGlu
         TsupljStTtYQtZlP9cC75qljibTGygHEz76jjhzyXBzjo5ycwIdxb+U7FNg4P538ps
         4usmr90oitiylq0ahX7ccB769N8pMQEKeuKpMjlmPafyv69SUQ2NLcU4G3aK+cSlYy
         1JmJUcbQfgzF7QBh+EL6LtX9ScK2n3JSy0Y7eodCm9V9Y7vbyAeiDJZlB4I57J0kz6
         WKHydjiv+XVhUuVz7g/4k81jEMYdbzfyK9sdq8WE5lWdA84NjhyWauRC7yVXZNCDkZ
         OcdNwYOhWmitA==
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
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree.xilinx@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v4 net-next 10/11] skbuff: allow to use NAPI cache from __napi_alloc_skb()
Message-ID: <20210210162732.80467-11-alobakin@pm.me>
In-Reply-To: <20210210162732.80467-1-alobakin@pm.me>
References: <20210210162732.80467-1-alobakin@pm.me>
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

{,__}napi_alloc_skb() is mostly used either for optional non-linear
receive methods (usually controlled via Ethtool private flags and off
by default) and/or for Rx copybreaks.
Use __napi_build_skb() here for obtaining skbuff_heads from NAPI cache
instead of inplace allocations. This includes both kmalloc and page
frag paths.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/skbuff.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 750fa1825b28..ac6e0172f206 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -563,7 +563,8 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *na=
pi, unsigned int len,
 =09if (len <=3D SKB_WITH_OVERHEAD(1024) ||
 =09    len > SKB_WITH_OVERHEAD(PAGE_SIZE) ||
 =09    (gfp_mask & (__GFP_DIRECT_RECLAIM | GFP_DMA))) {
-=09=09skb =3D __alloc_skb(len, gfp_mask, SKB_ALLOC_RX, NUMA_NO_NODE);
+=09=09skb =3D __alloc_skb(len, gfp_mask, SKB_ALLOC_RX | SKB_ALLOC_NAPI,
+=09=09=09=09  NUMA_NO_NODE);
 =09=09if (!skb)
 =09=09=09goto skb_fail;
 =09=09goto skb_success;
@@ -580,7 +581,7 @@ struct sk_buff *__napi_alloc_skb(struct napi_struct *na=
pi, unsigned int len,
 =09if (unlikely(!data))
 =09=09return NULL;
=20
-=09skb =3D __build_skb(data, len);
+=09skb =3D __napi_build_skb(data, len);
 =09if (unlikely(!skb)) {
 =09=09skb_free_frag(data);
 =09=09return NULL;
--=20
2.30.1


