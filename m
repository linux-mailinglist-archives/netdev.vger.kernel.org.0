Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513F72AA8B3
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 02:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgKHBK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 20:10:57 -0500
Received: from mail-02.mail-europe.com ([51.89.119.103]:37948 "EHLO
        mail-02.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKHBK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 20:10:57 -0500
Date:   Sun, 08 Nov 2020 01:10:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604797851; bh=bbuaFuL5yeagDloO3ygY6+kP0ogMmd7CoJq8XOz2JQY=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=mByuuSWGW7enhyevQhL7LR+BZzpnJ+oqTMbf32kY7KrYFQToGNaAAdgZ+rusOw4L4
         VzOlKLhkae1SpuxrLfI8L2HK+v5rTf2IVMD6jBlPj5fpeSgHMLN6TkKg/t58JmO0NV
         BkDe1ZeukNIYryoo9bQEg6M05T3ifAWlrdbxwTPWGndxuIxn5xqLCTndBY1lG/twcu
         LOqKrqK6kF1h0/aYjxeVuFyoCNW9DDwfd7hwpq69lQFPNkI7K3ZQYVzZA74W02WLnz
         D6B+6Xhs0SaIl60TYfhGOBOODm3P1rDRjPdsH+rXPPlvufHvoLumDzI8v69i5Jy4cy
         Fdo58Sl3O6zyg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZYvJI@cp4-web-034.plabs.ch>
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

While testing UDP GSO fraglists forwarding through driver that uses
Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
iperf packets:

[ ID] Interval           Transfer     Bitrate         Jitter
[SUM]  0.0-40.0 sec  12106 datagrams received out-of-order

Simple switch to napi_gro_receive() any other method without frag0
shortcut completely resolved them.

I've found that UDP GRO uses udp_hdr(skb) in its .gro_receive()
callback. While it's probably OK for non-frag0 paths (when all
headers or even the entire frame are already in skb->data), this
inline points to junk when using Fast GRO (napi_gro_frags() or
napi_gro_receive() with only Ethernet header in skb->data and all
the rest in shinfo->frags) and breaks GRO packet compilation and
the packet flow itself.
To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
are typically used. UDP even has an inline helper that makes use of
them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
to get rid of the out-of-order delivers.

Present since the introduction of plain UDP GRO in 5.0-rc1.

Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ipv4/udp_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index e67a66fbf27b..13740e9fe6ec 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -366,7 +366,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff=
 *skb,
 static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 =09=09=09=09=09       struct sk_buff *skb)
 {
-=09struct udphdr *uh =3D udp_hdr(skb);
+=09struct udphdr *uh =3D udp_gro_udphdr(skb);
 =09struct sk_buff *pp =3D NULL;
 =09struct udphdr *uh2;
 =09struct sk_buff *p;
--=20
2.29.2


