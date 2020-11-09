Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4F42AC18D
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731100AbgKIQ5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:57:08 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:16684 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730558AbgKIQ5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:57:04 -0500
Date:   Mon, 09 Nov 2020 16:56:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604941021; bh=24CXDu7SlVQSYK+DralV6vCb3LhYybzpCMVK+wTvYIo=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=WhkC+Czl9Dt5SwYheDY/N7g/K306kk2KommAeD+ICNuydysY66vSDc3ueMfawtlgm
         r35SzFvNeZxqs3ZybRJA604iTGKSQvqm84blu5AddxxfOjVGZrNz5aG3z6TRchVtfD
         kW3OxuzgUnQKgq6NbQwzrVdioqEu1B6LR4berP/Ku/Um+ZlJ2m6VWtkEmUnDACtEAR
         UQMl2sT9YYG2QxvciIpSl3MvrvklUbuWTGvtTEgRvRGLlDJvS+W04+aFd7J7bynIDr
         UuL71NSWRlvllFTh71U/IJ32OKoG17r5K/lbHlsgGaFfvgR0YRERgBB7gg08fN9Ema
         WLqjgaI4BDcAA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtNqVdY@cp4-web-030.plabs.ch>
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

Since v1 [1]:
 - added a NULL pointer check for "uh" as suggested by Willem.

[1] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZYv=
JI@cp4-web-034.plabs.ch

Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ipv4/udp_offload.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index e67a66fbf27b..7f6bd221880a 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -366,13 +366,18 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_bu=
ff *skb,
 static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 =09=09=09=09=09       struct sk_buff *skb)
 {
-=09struct udphdr *uh =3D udp_hdr(skb);
+=09struct udphdr *uh =3D udp_gro_udphdr(skb);
 =09struct sk_buff *pp =3D NULL;
 =09struct udphdr *uh2;
 =09struct sk_buff *p;
 =09unsigned int ulen;
 =09int ret =3D 0;
=20
+=09if (unlikely(!uh)) {
+=09=09NAPI_GRO_CB(skb)->flush =3D 1;
+=09=09return NULL;
+=09}
+
 =09/* requires non zero csum, for symmetry with GSO */
 =09if (!uh->check) {
 =09=09NAPI_GRO_CB(skb)->flush =3D 1;
--=20
2.29.2


