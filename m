Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E04339311
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhCLQWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:22:22 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:22961 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbhCLQWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:22:11 -0500
Date:   Fri, 12 Mar 2021 16:22:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615566129; bh=kBDDl8otlT8o/LM6cr4LLdHLvlyC4ODcgI6jQUcxeAo=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=TPHwMLPFx8yRTAB179mgR4wMVehNyO1TW5OYr/dIAAqdgMy2JYicEKDCcO+VFjYyJ
         IKN4UB/I6vvxrSSOr6OlqtnK8/u+OW0HBgr7gKyN/K89KXe4axUMhWhSM+UzeSzEHU
         MwUckvm5CtZq5Yi52sx3dAKqidGMlCcb7nGVJJ+3llgTos3O7SXTnhuAZjSrRlGeeQ
         yJpiCrDpScE8Msn0QCnkgllWL7aDgXJjBCDkTjMaX1vwKpcJVB4OX+RWD9Lwh36tZY
         KsOUt9bwav3507PGqtPRUdUZ7/dikwJNHeqqHbSElUICxbx7+dzXQ5HP2mPX5GwKUv
         U7DaUwhm5Wo3Q==
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
Subject: [PATCH net-next 3/4] gro: simplify gro_list_prepare()
Message-ID: <20210312162127.239795-4-alobakin@pm.me>
In-Reply-To: <20210312162127.239795-1-alobakin@pm.me>
References: <20210312162127.239795-1-alobakin@pm.me>
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
Given that dev_gro_receive() already has a pointer to the needed
list, just pass it as the first argument to eliminate redundant
calculations, and make gro_list_prepare() return void.
Also, both arguments of gro_list_prepare() can be constified since
this function can only modify the skbs from the bucket list.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/dev.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ee124aecb8a2..65d9e7d9d1e8 100644
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
@@ -5958,10 +5954,10 @@ static enum gro_result dev_gro_receive(struct napi_=
struct *napi, struct sk_buff
 {
 =09u32 bucket =3D skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
 =09struct gro_list *gro_list =3D &napi->gro_hash[bucket];
+=09struct list_head *gro_head =3D &gro_list->list;
 =09struct list_head *head =3D &offload_base;
 =09struct packet_offload *ptype;
 =09__be16 type =3D skb->protocol;
-=09struct list_head *gro_head;
 =09struct sk_buff *pp =3D NULL;
 =09enum gro_result ret;
 =09int same_flow;
@@ -5970,7 +5966,7 @@ static enum gro_result dev_gro_receive(struct napi_st=
ruct *napi, struct sk_buff
 =09if (netif_elide_gro(skb->dev))
 =09=09goto normal;

-=09gro_head =3D gro_list_prepare(napi, skb);
+=09gro_list_prepare(gro_head, skb);

 =09rcu_read_lock();
 =09list_for_each_entry_rcu(ptype, head, list) {
--
2.30.2


