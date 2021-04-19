Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08583364214
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 14:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239248AbhDSMxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 08:53:44 -0400
Received: from mail2.protonmail.ch ([185.70.40.22]:59144 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239095AbhDSMxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 08:53:42 -0400
Date:   Mon, 19 Apr 2021 12:53:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1618836790; bh=dPP56wqBhSWGV3YL8whhYttyE2wvgRvYvvsmV73KBL8=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=VQ66dxJg3jgoswOeS3xpbnyhVPlSx8ucuj1ksjlNOOEm1PAZ7p54Pl38zGyj0yhSC
         weNZ1pV5AHdYHe8RGcfslkMoXPH3iTM6wcGayltsEZRL1fSUEzKnI99XR63YTX6J7f
         KBysTMm8eenjEa+1jAYcNIz9zrJT94N3/b9iDbz/0ZpKspsum/rVG36N0LBBo05+7b
         wXC9hL4cuuEoMBAAIQpnxOOi1A099a/6ZrPtStRk3uE9yZBXwonGggrrSyORve9uf6
         3yNaBVTRR0j/ckeysM74vKK3D6FDOjqmgg4R9w7nWx4JgfdulIVamP2yyejE0QxEBO
         Q+yc4k37PiHAw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net] gro: fix napi_gro_frags() Fast GRO breakage due to IP alignment check
Message-ID: <20210419125258.5969-1-alobakin@pm.me>
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

Commit 38ec4944b593 ("gro: ensure frag0 meets IP header alignment")
did the right thing, but missed the fact that napi_gro_frags() logics
calls for skb_gro_reset_offset() *before* pulling Ethernet header
to the skb linear space.
That said, the introduced check for frag0 address being aligned to 4
always fails for it as Ethernet header is obviously 14 bytes long,
and in case with NET_IP_ALIGN its start is not aligned to 4.

Fix this by adding @nhoff argument to skb_gro_reset_offset() which
tells if an IP header is placed right at the start of frag0 or not.
This restores Fast GRO for napi_gro_frags() that became very slow
after the mentioned commit, and preserves the introduced check to
avoid silent unaligned accesses.

From v1 [0]:
 - inline tiny skb_gro_reset_offset() to let the code be optimized
   more efficively (esp. for the !NET_IP_ALIGN case) (Eric);
 - pull in Reviewed-by from Eric.

[0] https://lore.kernel.org/netdev/20210418114200.5839-1-alobakin@pm.me

Fixes: 38ec4944b593 ("gro: ensure frag0 meets IP header alignment")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1f79b9aa9a3f..15fe36332fb8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5914,7 +5914,7 @@ static struct list_head *gro_list_prepare(struct napi=
_struct *napi,
 =09return head;
 }

-static void skb_gro_reset_offset(struct sk_buff *skb)
+static inline void skb_gro_reset_offset(struct sk_buff *skb, u32 nhoff)
 {
 =09const struct skb_shared_info *pinfo =3D skb_shinfo(skb);
 =09const skb_frag_t *frag0 =3D &pinfo->frags[0];
@@ -5925,7 +5925,7 @@ static void skb_gro_reset_offset(struct sk_buff *skb)

 =09if (!skb_headlen(skb) && pinfo->nr_frags &&
 =09    !PageHighMem(skb_frag_page(frag0)) &&
-=09    (!NET_IP_ALIGN || !(skb_frag_off(frag0) & 3))) {
+=09    (!NET_IP_ALIGN || !((skb_frag_off(frag0) + nhoff) & 3))) {
 =09=09NAPI_GRO_CB(skb)->frag0 =3D skb_frag_address(frag0);
 =09=09NAPI_GRO_CB(skb)->frag0_len =3D min_t(unsigned int,
 =09=09=09=09=09=09    skb_frag_size(frag0),
@@ -6143,7 +6143,7 @@ gro_result_t napi_gro_receive(struct napi_struct *nap=
i, struct sk_buff *skb)
 =09skb_mark_napi_id(skb, napi);
 =09trace_napi_gro_receive_entry(skb);

-=09skb_gro_reset_offset(skb);
+=09skb_gro_reset_offset(skb, 0);

 =09ret =3D napi_skb_finish(napi, skb, dev_gro_receive(napi, skb));
 =09trace_napi_gro_receive_exit(ret);
@@ -6232,7 +6232,7 @@ static struct sk_buff *napi_frags_skb(struct napi_str=
uct *napi)
 =09napi->skb =3D NULL;

 =09skb_reset_mac_header(skb);
-=09skb_gro_reset_offset(skb);
+=09skb_gro_reset_offset(skb, hlen);

 =09if (unlikely(skb_gro_header_hard(skb, hlen))) {
 =09=09eth =3D skb_gro_header_slow(skb, hlen, 0);
--
2.31.1


