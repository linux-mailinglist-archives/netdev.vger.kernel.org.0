Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375E83634E4
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 13:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhDRLnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 07:43:33 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:52070 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhDRLnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 07:43:31 -0400
Date:   Sun, 18 Apr 2021 11:42:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1618746181; bh=uFGkfd6SSEGyPUyf0IwGBqQSMt0EHtgOF4jDCcrsprA=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=OCDgkUQxPBc75HEKHfPWHcuo79aNHy6390QgJujnEubklCI857H1O2zOn1BXBYAud
         xh3SYKREtiBNzTlQwGaS1+p3pfyWSoIEa34INqo05sRCj/QPwxk249SMHpPWY2ClVC
         E2jKvtYiYDGeLM+uNfXiKivd0Cpl5LFaa40kh4SVZTsUD2gESceyXX5+Zz4QgRsFfm
         gCBir0x/0t9zRWDOqj+xdzHa1l4l4h0Cq31KpkbLLIxtPW0Ng8ATsRB8VvFyNmBrkz
         J+ePLL354nJR0HFLfGvTOZjxmQslqppFPtdT7wjSVC8DD1QTp/gVxIz0zyCt85tBG7
         nqF4hhIve8CWA==
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
Subject: [PATCH net] gro: fix napi_gro_frags() Fast GRO breakage due to IP alignment check
Message-ID: <20210418114200.5839-1-alobakin@pm.me>
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

Fixes: 38ec4944b593 ("gro: ensure frag0 meets IP header alignment")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1f79b9aa9a3f..965d5f9b6fee 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5914,7 +5914,7 @@ static struct list_head *gro_list_prepare(struct napi=
_struct *napi,
 =09return head;
 }

-static void skb_gro_reset_offset(struct sk_buff *skb)
+static void skb_gro_reset_offset(struct sk_buff *skb, u32 nhoff)
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


