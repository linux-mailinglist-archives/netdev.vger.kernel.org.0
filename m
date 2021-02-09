Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889C2315867
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 22:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhBIVNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 16:13:47 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:52473 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbhBIUtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:49:18 -0500
Date:   Tue, 09 Feb 2021 20:48:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612903714; bh=ptg4dtlOixx4N/Ps+zPYWXSaL+5RU9Pp83Jx/VqNNi4=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=OthOSBa4ZrVmt9Pe6U5c7kIM32c/S/wz17TmX0NJafAk6xcJdpHkqzSbpNbtd2K8y
         mHH/fZD/2sx4wtjTL9Shycb3FMOB6oC+0sEuI8Ji1T4guq/t2X9LYileHj0bOVP2PQ
         qGSog8aAfij2n6xA5Y40BE7KGr4eMLRy6fXF0qyEPhdPpNviCtLtBAN0BqnmjTurui
         G16vUDZK8enN4jCa8Xop74SzsuPqBHw+OvAUjxITA/zHvQx4UouSM9LoWFibVdek4N
         DcYzaGG7UsRtUhYBFanGRfomZ3NmSyC9csMipA/XOX+VK6G5EfmXM2GXp8khjeRYF2
         ZnFUxWNrK/CzA==
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
Subject: [v3 net-next 06/10] skbuff: remove __kfree_skb_flush()
Message-ID: <20210209204533.327360-7-alobakin@pm.me>
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

This function isn't much needed as NAPI skb queue gets bulk-freed
anyway when there's no more room, and even may reduce the efficiency
of bulk operations.
It will be even less needed after reusing skb cache on allocation path,
so remove it and this way lighten network softirqs a bit.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/skbuff.h |  1 -
 net/core/dev.c         |  6 +-----
 net/core/skbuff.c      | 12 ------------
 3 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0a4e91a2f873..0e0707296098 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2919,7 +2919,6 @@ static inline struct sk_buff *napi_alloc_skb(struct n=
api_struct *napi,
 }
 void napi_consume_skb(struct sk_buff *skb, int budget);
=20
-void __kfree_skb_flush(void);
 void __kfree_skb_defer(struct sk_buff *skb);
=20
 /**
diff --git a/net/core/dev.c b/net/core/dev.c
index 21d74d30f5d7..135d46c0c3c7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4906,8 +4906,6 @@ static __latent_entropy void net_tx_action(struct sof=
tirq_action *h)
 =09=09=09else
 =09=09=09=09__kfree_skb_defer(skb);
 =09=09}
-
-=09=09__kfree_skb_flush();
 =09}
=20
 =09if (sd->output_queue) {
@@ -6873,7 +6871,7 @@ static __latent_entropy void net_rx_action(struct sof=
tirq_action *h)
=20
 =09=09if (list_empty(&list)) {
 =09=09=09if (!sd_has_rps_ipi_waiting(sd) && list_empty(&repoll))
-=09=09=09=09goto out;
+=09=09=09=09return;
 =09=09=09break;
 =09=09}
=20
@@ -6900,8 +6898,6 @@ static __latent_entropy void net_rx_action(struct sof=
tirq_action *h)
 =09=09__raise_softirq_irqoff(NET_RX_SOFTIRQ);
=20
 =09net_rps_action_and_irq_enable(sd);
-out:
-=09__kfree_skb_flush();
 }
=20
 struct netdev_adjacent {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1c6f6ef70339..4be2bb969535 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -838,18 +838,6 @@ void __consume_stateless_skb(struct sk_buff *skb)
 =09kfree_skbmem(skb);
 }
=20
-void __kfree_skb_flush(void)
-{
-=09struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
-
-=09/* flush skb_cache if containing objects */
-=09if (nc->skb_count) {
-=09=09kmem_cache_free_bulk(skbuff_head_cache, nc->skb_count,
-=09=09=09=09     nc->skb_cache);
-=09=09nc->skb_count =3D 0;
-=09}
-}
-
 static inline void _kfree_skb_defer(struct sk_buff *skb)
 {
 =09struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
--=20
2.30.0


