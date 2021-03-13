Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690EF33A10F
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 21:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbhCMUay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 15:30:54 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:60471 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbhCMUaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 15:30:21 -0500
Date:   Sat, 13 Mar 2021 20:30:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1615667419; bh=h8AxKy9QmCvHGWAs8euuTGEWJfSRa96KUPzMBTCT3Bs=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=h3JPpOw+8WBMl4rj82j7AX9N7ZOtXgJ5vj21dlyj+DDHkvRWQ8qHHJGxDS8ZiXxzr
         qpbX63vj6ImP5t2h/5GbON5g2TkGc737ft5Sfo/mKihjSn0OHB1JVgCuhykpULm0Hc
         PyiMCbgZVBKbYS5atvIgKvmqgG1VSEL6Des9BRPP97y+TxVCUW/HGK2AousZqOfn7W
         ZRptEqAhTpyLczMeNThcUwCyRmn+kZeOManx75uLN8xFo9Nlcyzfc3RrhAv8ZDnBSV
         EdKVulCqWAsDcwKgDhhg6DcqvzBPLE5bDnE7FZgwh+Ei9hs5QBW1ADOcA03HMgpHId
         fZC+8Zv+O6y8A==
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
Subject: [PATCH v2 net-next 3/3] gro: give 'hash' variable in dev_gro_receive() a less confusing name
Message-ID: <20210313202946.59729-4-alobakin@pm.me>
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

'hash' stores not the flow hash, but the index of the GRO bucket
corresponding to it.
Change its name to 'bucket' to avoid confusion while reading lines
like '__set_bit(hash, &napi->gro_bitmask)'.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/dev.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b635467087f3..5a2847a19cf2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5952,8 +5952,8 @@ static void gro_flush_oldest(struct napi_struct *napi=
, struct list_head *head)

 static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk=
_buff *skb)
 {
-=09u32 hash =3D skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
-=09struct gro_list *gro_list =3D &napi->gro_hash[hash];
+=09u32 bucket =3D skb_get_hash_raw(skb) & (GRO_HASH_BUCKETS - 1);
+=09struct gro_list *gro_list =3D &napi->gro_hash[bucket];
 =09struct list_head *head =3D &offload_base;
 =09struct packet_offload *ptype;
 =09__be16 type =3D skb->protocol;
@@ -6047,10 +6047,10 @@ static enum gro_result dev_gro_receive(struct napi_=
struct *napi, struct sk_buff
 =09=09gro_pull_from_frag0(skb, grow);
 ok:
 =09if (gro_list->count) {
-=09=09if (!test_bit(hash, &napi->gro_bitmask))
-=09=09=09__set_bit(hash, &napi->gro_bitmask);
-=09} else if (test_bit(hash, &napi->gro_bitmask)) {
-=09=09__clear_bit(hash, &napi->gro_bitmask);
+=09=09if (!test_bit(bucket, &napi->gro_bitmask))
+=09=09=09__set_bit(bucket, &napi->gro_bitmask);
+=09} else if (test_bit(bucket, &napi->gro_bitmask)) {
+=09=09__clear_bit(bucket, &napi->gro_bitmask);
 =09}

 =09return ret;
--
2.30.2


