Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FBA2AF9F1
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 21:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgKKUpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 15:45:51 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:28405 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgKKUpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 15:45:51 -0500
Date:   Wed, 11 Nov 2020 20:45:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1605127548; bh=PBGKEoBc5TqnNvKjdre9o7gs+BzG9F9/O6Jd+eE2xuQ=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=EbZ6JiWR22TFUuM/vh+9LAASIOmEU0ukpQSy20Xzg4GDNubDLLWbSwteYDViiFHtR
         O2cMKYclwgCRMomNRCi0CxZ8Qxn44pc1IKxYqs90QtgO17XXYQAwOJbbcIfffDtrBU
         TuwoaK/rSjc+5vzmP/42e+8tr3Z9IrVqJRO+W6oLmF/uYTqHv1hfWcTr9+jFKT34Yu
         bvbTGUvT7xEabRdo9jolS+MmjA1Bp0DugikS8Cb2mRXRHpjJH2LEjklIGs+L3buYwH
         7VUNO5jyGo7JjuPCyLWonX8iwCnpXATNW+YQ7sQDV2KcJkd9UzRc1ra0S5Tz7tzC8A
         rbOkENCW5vHkQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v5 net 2/2] net: udp: fix IP header access and skb lookup on Fast/frag0 UDP GRO
Message-ID: <sc7E1N6fUafwmUSYAu3TKgH39kfjNK5WuUi0wng54@cp4-web-030.plabs.ch>
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

udp{4,6}_lib_lookup_skb() use ip{,v6}_hdr() to get IP header of the
packet. While it's probably OK for non-frag0 paths, this helpers
will also point to junk on Fast/frag0 GRO when all headers are
located in frags. As a result, sk/skb lookup may fail or give wrong
results. To support both GRO modes, skb_gro_network_header() might
be used. To not modify original functions, add private versions of
udp{4,6}_lib_lookup_skb() only to perform correct sk lookups on GRO.

Present since the introduction of "application-level" UDP GRO
in 4.7-rc1.

Misc: replace totally unneeded ternaries with plain ifs.

Fixes: a6024562ffd7 ("udp: Add GRO functions to UDP socket")
Suggested-by: Willem de Bruijn <willemb@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ipv4/udp_offload.c | 17 +++++++++++++++--
 net/ipv6/udp_offload.c | 17 +++++++++++++++--
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 13740e9fe6ec..c62805cd3131 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -500,12 +500,22 @@ struct sk_buff *udp_gro_receive(struct list_head *hea=
d, struct sk_buff *skb,
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
 =09struct udphdr *uh =3D udp_gro_udphdr(skb);
+=09struct sock *sk =3D NULL;
 =09struct sk_buff *pp;
-=09struct sock *sk;
=20
 =09if (unlikely(!uh))
 =09=09goto flush;
@@ -523,7 +533,10 @@ struct sk_buff *udp4_gro_receive(struct list_head *hea=
d, struct sk_buff *skb)
 skip:
 =09NAPI_GRO_CB(skb)->is_ipv6 =3D 0;
 =09rcu_read_lock();
-=09sk =3D static_branch_unlikely(&udp_encap_needed_key) ? udp4_lib_lookup_=
skb(skb, uh->source, uh->dest) : NULL;
+
+=09if (static_branch_unlikely(&udp_encap_needed_key))
+=09=09sk =3D udp4_gro_lookup_skb(skb, uh->source, uh->dest);
+
 =09pp =3D udp_gro_receive(head, skb, uh, sk);
 =09rcu_read_unlock();
 =09return pp;
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 584157a07759..f9e888d1b9af 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -111,12 +111,22 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_bu=
ff *skb,
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
 =09struct udphdr *uh =3D udp_gro_udphdr(skb);
+=09struct sock *sk =3D NULL;
 =09struct sk_buff *pp;
-=09struct sock *sk;
=20
 =09if (unlikely(!uh))
 =09=09goto flush;
@@ -135,7 +145,10 @@ struct sk_buff *udp6_gro_receive(struct list_head *hea=
d, struct sk_buff *skb)
 skip:
 =09NAPI_GRO_CB(skb)->is_ipv6 =3D 1;
 =09rcu_read_lock();
-=09sk =3D static_branch_unlikely(&udpv6_encap_needed_key) ? udp6_lib_looku=
p_skb(skb, uh->source, uh->dest) : NULL;
+
+=09if (static_branch_unlikely(&udpv6_encap_needed_key))
+=09=09sk =3D udp6_gro_lookup_skb(skb, uh->source, uh->dest);
+
 =09pp =3D udp_gro_receive(head, skb, uh, sk);
 =09rcu_read_unlock();
 =09return pp;
--=20
2.29.2


