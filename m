Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AB831AC1E
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 15:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhBMONW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 09:13:22 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:47390 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhBMOMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 09:12:49 -0500
Date:   Sat, 13 Feb 2021 14:12:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613225526; bh=I5pt5vkO/t2xyU4szHrXQYlrL2EpJSlwZyjNhq3SMbc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=RNeDa1X1LbgFaylLgkmzQQSNfTo43sDqt1PI8rAVAULG679x9oEWroUGZaA1rAEbI
         trWOl56Ihh+RoYKufiVCu0+9OAO+3WXTqQfFk+S2ItAU35WQS4UpuGTLtg5GJPzaE9
         IfN7f2mSrW80zh/R7O1ZZa3C4riDkyG7MieC2mAq61MWz4GZ7HutLMKo0uwcLM5J7J
         kFjWJdcKhVjoLMsZcBJCTSWj4FZ/hSpO+KickuxLtNDdl2izkF/4y6HTuXPQbrWHHz
         N0U2woiwnY77I5DCupqn9/FMVr/okW3ipsmOWVUKkOlFqPY8HC7fwAQxYpet5K8ShG
         UyL62Nx10ooxQ==
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
Subject: [PATCH v6 net-next 06/11] skbuff: remove __kfree_skb_flush()
Message-ID: <20210213141021.87840-7-alobakin@pm.me>
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

This function isn't much needed as NAPI skb queue gets bulk-freed
anyway when there's no more room, and even may reduce the efficiency
of bulk operations.
It will be even less needed after reusing skb cache on allocation path,
so remove it and this way lighten network softirqs a bit.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/skbuff.h |  1 -
 net/core/dev.c         |  7 +------
 net/core/skbuff.c      | 12 ------------
 3 files changed, 1 insertion(+), 19 deletions(-)

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
index ce6291bc2e16..631807c196ad 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4944,8 +4944,6 @@ static __latent_entropy void net_tx_action(struct sof=
tirq_action *h)
 =09=09=09else
 =09=09=09=09__kfree_skb_defer(skb);
 =09=09}
-
-=09=09__kfree_skb_flush();
 =09}
=20
 =09if (sd->output_queue) {
@@ -7012,7 +7010,6 @@ static int napi_threaded_poll(void *data)
 =09=09=09__napi_poll(napi, &repoll);
 =09=09=09netpoll_poll_unlock(have);
=20
-=09=09=09__kfree_skb_flush();
 =09=09=09local_bh_enable();
=20
 =09=09=09if (!repoll)
@@ -7042,7 +7039,7 @@ static __latent_entropy void net_rx_action(struct sof=
tirq_action *h)
=20
 =09=09if (list_empty(&list)) {
 =09=09=09if (!sd_has_rps_ipi_waiting(sd) && list_empty(&repoll))
-=09=09=09=09goto out;
+=09=09=09=09return;
 =09=09=09break;
 =09=09}
=20
@@ -7069,8 +7066,6 @@ static __latent_entropy void net_rx_action(struct sof=
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
2.30.1


