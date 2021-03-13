Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F7033A10D
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 21:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbhCMUaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 15:30:24 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:49178 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbhCMUaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 15:30:20 -0500
Date:   Sat, 13 Mar 2021 20:30:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615667419; bh=DnDoi6Lmfg94w7sOkyFM7FB6VyKUOf07zHIo4MZA/Cg=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=KvqIDRGtNKVPx5uG9YerkyQl3N1CJnINMgTHxmftAcTiLHHa41/f5C0HZVjRizpT7
         PmZ/s47R27kYsuSjzIaDoHpUbvxxBbZnKgrS6i8CJteVgs3zBEFJfmry8FuPQbe1FX
         szl8KYXjVHR5j129ss46aG/wpv6f15aUYu/EMnXejnOlzwRMqkgrJDqcSdwdb2lDPR
         gW1JvOcCRllwCTcWXIagb14VrpCD3izrJnCdUDQmyl0YD+eu537m1e0mOG/57hxGh/
         +VDy4EZ9C8NHD0gasuG+SL4BQZXc0uuZUxSSJBsos1lUL8FMT+wGLdU/ySb/ldrjw3
         APB59EOK8Uo9w==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net-next 2/3] gro: consistentify napi->gro_hash[x] access in dev_gro_receive()
Message-ID: <20210313202946.59729-3-alobakin@pm.me>
In-Reply-To: <20210313202946.59729-1-alobakin@pm.me>
References: <20210313202946.59729-1-alobakin@pm.me>
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

GRO bucket index doesn't change through the entire function.
Store a pointer to the corresponding bucket instead of its member
and use it consistently through the function.
It is performance-safe since &gro_list->list =3D=3D gro_list.

Misc: remove superfluous braces around single-line branches.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/dev.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1317e6b6758a..b635467087f3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5953,7 +5953,7 @@ static void gro_flush_oldest(struct napi_struct *napi=
, struct list_head *head)
 static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk=
_buff *skb)
 {
 =09u32 hash =3D skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
-=09struct list_head *gro_head =3D &napi->gro_hash[hash].list;
+=09struct gro_list *gro_list =3D &napi->gro_hash[hash];
 =09struct list_head *head =3D &offload_base;
 =09struct packet_offload *ptype;
 =09__be16 type =3D skb->protocol;
@@ -5965,7 +5965,7 @@ static enum gro_result dev_gro_receive(struct napi_st=
ruct *napi, struct sk_buff
 =09if (netif_elide_gro(skb->dev))
 =09=09goto normal;

-=09gro_list_prepare(gro_head, skb);
+=09gro_list_prepare(&gro_list->list, skb);

 =09rcu_read_lock();
 =09list_for_each_entry_rcu(ptype, head, list) {
@@ -6001,7 +6001,7 @@ static enum gro_result dev_gro_receive(struct napi_st=
ruct *napi, struct sk_buff

 =09=09pp =3D INDIRECT_CALL_INET(ptype->callbacks.gro_receive,
 =09=09=09=09=09ipv6_gro_receive, inet_gro_receive,
-=09=09=09=09=09gro_head, skb);
+=09=09=09=09=09&gro_list->list, skb);
 =09=09break;
 =09}
 =09rcu_read_unlock();
@@ -6020,7 +6020,7 @@ static enum gro_result dev_gro_receive(struct napi_st=
ruct *napi, struct sk_buff
 =09if (pp) {
 =09=09skb_list_del_init(pp);
 =09=09napi_gro_complete(napi, pp);
-=09=09napi->gro_hash[hash].count--;
+=09=09gro_list->count--;
 =09}

 =09if (same_flow)
@@ -6029,16 +6029,16 @@ static enum gro_result dev_gro_receive(struct napi_=
struct *napi, struct sk_buff
 =09if (NAPI_GRO_CB(skb)->flush)
 =09=09goto normal;

-=09if (unlikely(napi->gro_hash[hash].count >=3D MAX_GRO_SKBS)) {
-=09=09gro_flush_oldest(napi, gro_head);
-=09} else {
-=09=09napi->gro_hash[hash].count++;
-=09}
+=09if (unlikely(gro_list->count >=3D MAX_GRO_SKBS))
+=09=09gro_flush_oldest(napi, &gro_list->list);
+=09else
+=09=09gro_list->count++;
+
 =09NAPI_GRO_CB(skb)->count =3D 1;
 =09NAPI_GRO_CB(skb)->age =3D jiffies;
 =09NAPI_GRO_CB(skb)->last =3D skb;
 =09skb_shinfo(skb)->gso_size =3D skb_gro_len(skb);
-=09list_add(&skb->list, gro_head);
+=09list_add(&skb->list, &gro_list->list);
 =09ret =3D GRO_HELD;

 pull:
@@ -6046,7 +6046,7 @@ static enum gro_result dev_gro_receive(struct napi_st=
ruct *napi, struct sk_buff
 =09if (grow > 0)
 =09=09gro_pull_from_frag0(skb, grow);
 ok:
-=09if (napi->gro_hash[hash].count) {
+=09if (gro_list->count) {
 =09=09if (!test_bit(hash, &napi->gro_bitmask))
 =09=09=09__set_bit(hash, &napi->gro_bitmask);
 =09} else if (test_bit(hash, &napi->gro_bitmask)) {
--
2.30.2


