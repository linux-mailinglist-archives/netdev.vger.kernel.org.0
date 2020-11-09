Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37132AC6BC
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbgKIVPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:15:34 -0500
Received: from mail-03.mail-europe.com ([91.134.188.129]:46506 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729697AbgKIVPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:15:33 -0500
Date:   Mon, 09 Nov 2020 21:15:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604956528; bh=zTOBwWAH6JdA/Q03nXi6Nv+Ot9+RM1svymVRReyFZ/8=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=h62fmhbfhOQh29yjgA3Xy2EV/wnNK+6x2cCmxLhCpZOYToq+Wxq/DKNc4C3L7qly+
         fhI8MT7TLwEmLfVel4vhk+bByJHsNON9hYijHc0KcPPqXATGQSLf9YoRmliXcx9YRR
         oivPpGExOwk4+cP7XL0CqUsb79xq3JJWVNPjSh1QfpUw3VYwjGs1xHCq+yzm29xXUp
         oYbgnAQfcN6pBO1CWZepGdKrAQLQXTBlhGAkzpNr315v/KjAOdyQHoNE2kUQ+wE2pw
         ADlyQrF79KqzyPbtnlc7pwp+RjhGVit/JxSOSux+tEWPbD2z7QxbtkmP+kd/l6SJcw
         Q2JPLlNI3x9og==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v3 net] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <MgZce9htmEtCtHg7pmWxXXfdhmQ6AHrnltXC41zOoo@cp7-web-042.plabs.ch>
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

Since v2 [1]:
 - dropped redundant check introduced in v2 as it's performed right
   before (thanks to Eric);
 - udp_hdr() switched to data + off for skbs from list (also Eric);
 - fixed possible malfunction of {,__}udp{4,6}_lib_lookup_skb() with
   Fast/frag0 due to ip{,v6}_hdr() usage (Willem).

Since v1 [2]:
 - added a NULL pointer check for "uh" as suggested by Willem.

[1] https://lore.kernel.org/netdev/0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtNqV=
dY@cp4-web-030.plabs.ch
[2] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZYv=
JI@cp4-web-034.plabs.ch

Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ipv4/udp.c         | 4 ++--
 net/ipv4/udp_offload.c | 9 ++++++---
 net/ipv6/udp.c         | 4 ++--
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 09f0a23d1a01..948ddc9a0212 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -534,7 +534,7 @@ static inline struct sock *__udp4_lib_lookup_skb(struct=
 sk_buff *skb,
 =09=09=09=09=09=09 __be16 sport, __be16 dport,
 =09=09=09=09=09=09 struct udp_table *udptable)
 {
-=09const struct iphdr *iph =3D ip_hdr(skb);
+=09const struct iphdr *iph =3D skb_gro_network_header(skb);
=20
 =09return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
 =09=09=09=09 iph->daddr, dport, inet_iif(skb),
@@ -544,7 +544,7 @@ static inline struct sock *__udp4_lib_lookup_skb(struct=
 sk_buff *skb,
 struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
 =09=09=09=09 __be16 sport, __be16 dport)
 {
-=09const struct iphdr *iph =3D ip_hdr(skb);
+=09const struct iphdr *iph =3D skb_gro_network_header(skb);
=20
 =09return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
 =09=09=09=09 iph->daddr, dport, inet_iif(skb),
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index e67a66fbf27b..dbc4d17c55e9 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -366,11 +366,11 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_bu=
ff *skb,
 static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
 =09=09=09=09=09       struct sk_buff *skb)
 {
-=09struct udphdr *uh =3D udp_hdr(skb);
+=09struct udphdr *uh =3D udp_gro_udphdr(skb);
 =09struct sk_buff *pp =3D NULL;
 =09struct udphdr *uh2;
 =09struct sk_buff *p;
-=09unsigned int ulen;
+=09u32 ulen, off;
 =09int ret =3D 0;
=20
 =09/* requires non zero csum, for symmetry with GSO */
@@ -385,6 +385,9 @@ static struct sk_buff *udp_gro_receive_segment(struct l=
ist_head *head,
 =09=09NAPI_GRO_CB(skb)->flush =3D 1;
 =09=09return NULL;
 =09}
+
+=09off =3D skb_gro_offset(skb);
+
 =09/* pull encapsulating udp header */
 =09skb_gro_pull(skb, sizeof(struct udphdr));
=20
@@ -392,7 +395,7 @@ static struct sk_buff *udp_gro_receive_segment(struct l=
ist_head *head,
 =09=09if (!NAPI_GRO_CB(p)->same_flow)
 =09=09=09continue;
=20
-=09=09uh2 =3D udp_hdr(p);
+=09=09uh2 =3D (void *)p->data + off;
=20
 =09=09/* Match ports only, as csum is always non zero */
 =09=09if ((*(u32 *)&uh->source !=3D *(u32 *)&uh2->source)) {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 29d9691359b9..a256ecce76b2 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -269,7 +269,7 @@ static struct sock *__udp6_lib_lookup_skb(struct sk_buf=
f *skb,
 =09=09=09=09=09  __be16 sport, __be16 dport,
 =09=09=09=09=09  struct udp_table *udptable)
 {
-=09const struct ipv6hdr *iph =3D ipv6_hdr(skb);
+=09const struct ipv6hdr *iph =3D skb_gro_network_header(skb);
=20
 =09return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
 =09=09=09=09 &iph->daddr, dport, inet6_iif(skb),
@@ -279,7 +279,7 @@ static struct sock *__udp6_lib_lookup_skb(struct sk_buf=
f *skb,
 struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
 =09=09=09=09 __be16 sport, __be16 dport)
 {
-=09const struct ipv6hdr *iph =3D ipv6_hdr(skb);
+=09const struct ipv6hdr *iph =3D skb_gro_network_header(skb);
=20
 =09return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
 =09=09=09=09 &iph->daddr, dport, inet6_iif(skb),
--=20
2.29.2


