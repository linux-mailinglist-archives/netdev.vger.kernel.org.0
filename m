Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996012AC9A2
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 01:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbgKJAR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 19:17:29 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:38620 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKJAR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 19:17:28 -0500
X-Greylist: delayed 10916 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Nov 2020 19:17:26 EST
Date:   Tue, 10 Nov 2020 00:17:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604967445; bh=3r5eH4kmQg8GtWwXBLWSLr+/uoVW1i5B4scSDxo7/Fw=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=QVw7gVxXrBphejmocuPxl0Fslxe9chWynYwC/lwOmLn4TZYfcqgVIQSMJj7ScX7Yz
         k18zKmyC5mRSgQj6MU5XkBP/yGUPhXlDOcAhgQ6XnvLiExj7NrG9drVX7AL0I2M3yU
         osoCI/jeVvyiieDEYqv9FcJJH3kdInHG4MGn4EMqubXXlWuwXjhbTM21PgDNy2dzUO
         AoWNa7W4LK0pQNZc33TcV3BPdIqMuYHRV2Wk+cxTShDgL1soCRKb6vIhIvQs5iEjgK
         sbgjvHg5mwB4ti4FFlDLj9n7ynwXiDobV2VoprwF9G4ntd2zGYX/sOEMRGwBM3vzrk
         bnv7HM102/9Xg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v4 net] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <Ha2hou5eJPcblo4abjAqxZRzIl1RaLs2Hy0oOAgFs@cp4-web-036.plabs.ch>
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

Simple switch to napi_gro_receive() or any other method without frag0
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

Since v3 [1]:
 - restore the original {,__}udp{4,6}_lib_lookup_skb() and use
   private versions of them inside GRO code (Willem).

Since v2 [2]:
 - dropped redundant check introduced in v2 as it's performed right
   before (thanks to Eric);
 - udp_hdr() switched to data + off for skbs from list (also Eric);
 - fixed possible malfunction of {,__}udp{4,6}_lib_lookup_skb() with
   Fast/frag0 due to ip{,v6}_hdr() usage (Willem).

Since v1 [3]:
 - added a NULL pointer check for "uh" as suggested by Willem.

[1] https://lore.kernel.org/netdev/MgZce9htmEtCtHg7pmWxXXfdhmQ6AHrnltXC41zO=
oo@cp7-web-042.plabs.ch
[2] https://lore.kernel.org/netdev/0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtNqV=
dY@cp4-web-030.plabs.ch
[3] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZYv=
JI@cp4-web-034.plabs.ch

Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Cc: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ipv4/udp_offload.c | 23 +++++++++++++++++++----
 net/ipv6/udp_offload.c | 14 +++++++++++++-
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index e67a66fbf27b..6064efe17cdb 100644
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
@@ -500,6 +503,16 @@ struct sk_buff *udp_gro_receive(struct list_head *head=
, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(udp_gro_receive);
=20
+static struct sock *udp4_gro_lookup_skb(struct sk_buff *skb, __be16 sport,
+=09=09=09=09=09__be16 dport)
+{
+=09const struct iphdr *iph =3D skb_gro_network_header(skb);
+
+=09return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
+=09=09=09=09 iph->daddr, dport, inet_iif(skb),
+=09=09=09=09 inet_sdif(skb), &udp_table, NULL);
+}
+
 INDIRECT_CALLABLE_SCOPE
 struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *s=
kb)
 {
@@ -523,7 +536,9 @@ struct sk_buff *udp4_gro_receive(struct list_head *head=
, struct sk_buff *skb)
 skip:
 =09NAPI_GRO_CB(skb)->is_ipv6 =3D 0;
 =09rcu_read_lock();
-=09sk =3D static_branch_unlikely(&udp_encap_needed_key) ? udp4_lib_lookup_=
skb(skb, uh->source, uh->dest) : NULL;
+=09sk =3D static_branch_unlikely(&udp_encap_needed_key) ?
+=09     udp4_gro_lookup_skb(skb, uh->source, uh->dest) :
+=09     NULL;
 =09pp =3D udp_gro_receive(head, skb, uh, sk);
 =09rcu_read_unlock();
 =09return pp;
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 584157a07759..b126ab2120d9 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -111,6 +111,16 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buf=
f *skb,
 =09return segs;
 }
=20
+static struct sock *udp6_gro_lookup_skb(struct sk_buff *skb, __be16 sport,
+=09=09=09=09=09__be16 dport)
+{
+=09const struct ipv6hdr *iph =3D skb_gro_network_header(skb);
+
+=09return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
+=09=09=09=09 &iph->daddr, dport, inet6_iif(skb),
+=09=09=09=09 inet6_sdif(skb), &udp_table, NULL);
+}
+
 INDIRECT_CALLABLE_SCOPE
 struct sk_buff *udp6_gro_receive(struct list_head *head, struct sk_buff *s=
kb)
 {
@@ -135,7 +145,9 @@ struct sk_buff *udp6_gro_receive(struct list_head *head=
, struct sk_buff *skb)
 skip:
 =09NAPI_GRO_CB(skb)->is_ipv6 =3D 1;
 =09rcu_read_lock();
-=09sk =3D static_branch_unlikely(&udpv6_encap_needed_key) ? udp6_lib_looku=
p_skb(skb, uh->source, uh->dest) : NULL;
+=09sk =3D static_branch_unlikely(&udpv6_encap_needed_key) ?
+=09     udp6_gro_lookup_skb(skb, uh->source, uh->dest) :
+=09     NULL;
 =09pp =3D udp_gro_receive(head, skb, uh, sk);
 =09rcu_read_unlock();
 =09return pp;
--=20
2.29.2


