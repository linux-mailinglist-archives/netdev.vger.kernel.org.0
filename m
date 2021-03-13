Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99E333A10C
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 21:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbhCMUaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 15:30:23 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:35942 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbhCMUaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 15:30:17 -0500
Date:   Sat, 13 Mar 2021 20:30:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615667415; bh=+Y41TIeJ8/xi12wFQoHTtKGc2Uu9MqV6KIC4TT+u/qU=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=AHkb80T4Amw/xvefMpgDOC2I4wSUzXCmltZvMow4B0RyA3hMPjT13nYxG/VTjNoaX
         VuGvRA0hlO0Tzw3Uj6s1mVJ7E1cuI7jEsdeGSSH6wmJzBvMzugjLzZlosmSW9081Xo
         c8JBdeIQ/WEA1aV8Qu+gADu9GpoaRuUXrm69g4NVkwxZ4FTd+NRWJNMG/0Juz3nFy6
         zfMYgTDjZy0ogX8HFyWJJmnlpOjiJiDMdVgppkrNdZW6QgjI504FAm7UJsRv7lGaQG
         kmraSuGAhERMd2c089P3J3PvYl/kfcvUtUhz7eWFVYpx8hC+HKHHIXJxWj4zj9Ss50
         Vu/E0tFXjzYbg==
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
Subject: [PATCH v2 net-next 1/3] gro: simplify gro_list_prepare()
Message-ID: <20210313202946.59729-2-alobakin@pm.me>
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

gro_list_prepare() always returns &napi->gro_hash[bucket].list,
without any variations. Moreover, it uses 'napi' argument only to
have access to this list, and calculates the bucket index for the
second time (firstly it happens at the beginning of
dev_gro_receive()) to do that.
Given that dev_gro_receive() already has an index to the needed
list, just pass it as the first argument to eliminate redundant
calculations, and make gro_list_prepare() return void.
Also, both arguments of gro_list_prepare() can be constified since
this function can only modify the skbs from the bucket list.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/dev.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2bfdd528c7c3..1317e6b6758a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5858,15 +5858,13 @@ void napi_gro_flush(struct napi_struct *napi, bool =
flush_old)
 }
 EXPORT_SYMBOL(napi_gro_flush);

-static struct list_head *gro_list_prepare(struct napi_struct *napi,
-=09=09=09=09=09  struct sk_buff *skb)
+static void gro_list_prepare(const struct list_head *head,
+=09=09=09     const struct sk_buff *skb)
 {
 =09unsigned int maclen =3D skb->dev->hard_header_len;
 =09u32 hash =3D skb_get_hash_raw(skb);
-=09struct list_head *head;
 =09struct sk_buff *p;

-=09head =3D &napi->gro_hash[hash & (GRO_HASH_BUCKETS - 1)].list;
 =09list_for_each_entry(p, head, list) {
 =09=09unsigned long diffs;

@@ -5892,8 +5890,6 @@ static struct list_head *gro_list_prepare(struct napi=
_struct *napi,
 =09=09=09=09       maclen);
 =09=09NAPI_GRO_CB(p)->same_flow =3D !diffs;
 =09}
-
-=09return head;
 }

 static void skb_gro_reset_offset(struct sk_buff *skb)
@@ -5957,10 +5953,10 @@ static void gro_flush_oldest(struct napi_struct *na=
pi, struct list_head *head)
 static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk=
_buff *skb)
 {
 =09u32 hash =3D skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
+=09struct list_head *gro_head =3D &napi->gro_hash[hash].list;
 =09struct list_head *head =3D &offload_base;
 =09struct packet_offload *ptype;
 =09__be16 type =3D skb->protocol;
-=09struct list_head *gro_head;
 =09struct sk_buff *pp =3D NULL;
 =09enum gro_result ret;
 =09int same_flow;
@@ -5969,7 +5965,7 @@ static enum gro_result dev_gro_receive(struct napi_st=
ruct *napi, struct sk_buff
 =09if (netif_elide_gro(skb->dev))
 =09=09goto normal;

-=09gro_head =3D gro_list_prepare(napi, skb);
+=09gro_list_prepare(gro_head, skb);

 =09rcu_read_lock();
 =09list_for_each_entry_rcu(ptype, head, list) {
--
2.30.2


