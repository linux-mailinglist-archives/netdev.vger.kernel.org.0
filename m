Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931B52F48BD
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 11:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbhAMKdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:33:41 -0500
Received: from mail1.protonmail.ch ([185.70.40.18]:63142 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbhAMKdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 05:33:40 -0500
Date:   Wed, 13 Jan 2021 10:32:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610533977; bh=EpolZpTKC5oUdKcjdBe4f+ZlCuhQ3GPo5fWCiOJXzzo=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=ESJ+CGICyHNXyAKgaElVkQrx/j8flou2v19wfQB2Btb8PSNWKcf1FRUDK2eH16rVH
         xim7jt88xJjRNPu9dnf+0qZo4GxEzEycF80B5xl80NSFHpCw7GjmMK8nC1FEiXl55r
         NROmrXT8VrhUKsW0wclTeqyV9uh5NIHGSEl2AvIy37iS2EcdHCeu4bBlmeufeKdUe8
         uyaw/KsR035fJf7ZK737shkcxpdERu5Imsu4PqQm1/8j+BXzpOVd/ftGTs0A4a50da
         QheM7mPIeR0JMmFmglx8usXx6uw8T4f18GGIrPJk8ePRy69biKSvFgs0kl4mJ/kkJH
         Xf1gbV06EbG6Q==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree@solarflare.com>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net-next] udp: allow forwarding of plain (non-fraglisted) UDP GRO packets
Message-ID: <20210113103232.4761-1-alobakin@pm.me>
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

Commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") actually
not only added a support for fraglisted UDP GRO, but also tweaked
some logics the way that non-fraglisted UDP GRO started to work for
forwarding too.
Commit 2e4ef10f5850 ("net: add GSO UDP L4 and GSO fraglists to the
list of software-backed types") added GSO UDP L4 to the list of
software GSO to allow virtual netdevs to forward them as is up to
the real drivers.

Tests showed that currently forwarding and NATing of plain UDP GRO
packets are performed fully correctly, regardless if the target
netdevice has a support for hardware/driver GSO UDP L4 or not.
Add the last element and allow to form plain UDP GRO packets if
there is no socket -> we are on forwarding path.

Plain UDP GRO forwarding even shows better performance than fraglisted
UDP GRO in some cases due to not wasting one skbuff_head per every
segment.

Since v1 [0]:
 - drop redundant 'if (sk)' check (Alexander Duyck);
 - add a ref in the commit message to one more commit that was
   an important step for UDP GRO forwarding.

[0] https://lore.kernel.org/netdev/20210112211536.261172-1-alobakin@pm.me

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ipv4/udp_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index ff39e94781bf..6f5237a0d181 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -460,12 +460,12 @@ struct sk_buff *udp_gro_receive(struct list_head *hea=
d, struct sk_buff *skb,
 =09if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
 =09=09NAPI_GRO_CB(skb)->is_flist =3D sk ? !udp_sk(sk)->gro_enabled: 1;
=20
-=09if ((sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist) {
+=09if (!sk || udp_sk(sk)->gro_enabled || NAPI_GRO_CB(skb)->is_flist) {
 =09=09pp =3D call_gro_receive(udp_gro_receive_segment, head, skb);
 =09=09return pp;
 =09}
=20
-=09if (!sk || NAPI_GRO_CB(skb)->encap_mark ||
+=09if (NAPI_GRO_CB(skb)->encap_mark ||
 =09    (skb->ip_summed !=3D CHECKSUM_PARTIAL &&
 =09     NAPI_GRO_CB(skb)->csum_cnt =3D=3D 0 &&
 =09     !NAPI_GRO_CB(skb)->csum_valid) ||
--=20
2.30.0


