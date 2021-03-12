Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE4333930C
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhCLQWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:22:19 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:28881 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhCLQWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:22:01 -0500
Date:   Fri, 12 Mar 2021 16:21:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615566119; bh=n32rb6vRZgpCVR60KMaNApA0b+cldverLEokVhYSONc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=BCOkWEZLvcX3pEMmjRe3WM+H1CUtp0qG16IAYlU2uFlBy20P1RWTK8knbV/lAgICi
         i/Sa/y+GU0WSVQrwNcaOrYWIXchtTnDdJJCg679tV35aH8yrw8OF/nuhWPoWw8ImX9
         Dp44qYMC6+Wj2d/uy8vKaFKaeEgVx42d1Pb0aFEAI4Kq/l4SDMjjvfqqtHAhm8m6ZC
         d8aVQgiKNepR5GMgQOm+cBBIo7KwCCaMfpdXpznEgUslAaAFAkyjTiKGVyPCaZEzit
         Ho0dXwmNEa0YcGEkmJXCksXJGjXfD1ACHpDTy6WXVHjdFwK/shSoJBerU3lm4KuBbV
         +N1Ll8qlEietA==
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
Subject: [PATCH net-next 1/4] gro: give 'hash' variable in dev_gro_receive() a less confusing name
Message-ID: <20210312162127.239795-2-alobakin@pm.me>
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

'hash' stores not the flow hash, but the index of the GRO bucket
corresponding to it.
Change its name to 'bucket' to avoid confusion while reading lines
like '__set_bit(hash, &napi->gro_bitmask)'.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/dev.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2bfdd528c7c3..adc42ba7ffd8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5956,7 +5956,7 @@ static void gro_flush_oldest(struct napi_struct *napi=
, struct list_head *head)

 static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk=
_buff *skb)
 {
-=09u32 hash =3D skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
+=09u32 bucket =3D skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
 =09struct list_head *head =3D &offload_base;
 =09struct packet_offload *ptype;
 =09__be16 type =3D skb->protocol;
@@ -6024,7 +6024,7 @@ static enum gro_result dev_gro_receive(struct napi_st=
ruct *napi, struct sk_buff
 =09if (pp) {
 =09=09skb_list_del_init(pp);
 =09=09napi_gro_complete(napi, pp);
-=09=09napi->gro_hash[hash].count--;
+=09=09napi->gro_hash[bucket].count--;
 =09}

 =09if (same_flow)
@@ -6033,10 +6033,10 @@ static enum gro_result dev_gro_receive(struct napi_=
struct *napi, struct sk_buff
 =09if (NAPI_GRO_CB(skb)->flush)
 =09=09goto normal;

-=09if (unlikely(napi->gro_hash[hash].count >=3D MAX_GRO_SKBS)) {
+=09if (unlikely(napi->gro_hash[bucket].count >=3D MAX_GRO_SKBS)) {
 =09=09gro_flush_oldest(napi, gro_head);
 =09} else {
-=09=09napi->gro_hash[hash].count++;
+=09=09napi->gro_hash[bucket].count++;
 =09}
 =09NAPI_GRO_CB(skb)->count =3D 1;
 =09NAPI_GRO_CB(skb)->age =3D jiffies;
@@ -6050,11 +6050,11 @@ static enum gro_result dev_gro_receive(struct napi_=
struct *napi, struct sk_buff
 =09if (grow > 0)
 =09=09gro_pull_from_frag0(skb, grow);
 ok:
-=09if (napi->gro_hash[hash].count) {
-=09=09if (!test_bit(hash, &napi->gro_bitmask))
-=09=09=09__set_bit(hash, &napi->gro_bitmask);
-=09} else if (test_bit(hash, &napi->gro_bitmask)) {
-=09=09__clear_bit(hash, &napi->gro_bitmask);
+=09if (napi->gro_hash[bucket].count) {
+=09=09if (!test_bit(bucket, &napi->gro_bitmask))
+=09=09=09__set_bit(bucket, &napi->gro_bitmask);
+=09} else if (test_bit(bucket, &napi->gro_bitmask)) {
+=09=09__clear_bit(bucket, &napi->gro_bitmask);
 =09}

 =09return ret;
--
2.30.2


