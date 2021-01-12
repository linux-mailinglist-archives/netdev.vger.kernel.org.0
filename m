Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376DF2F3D60
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438171AbhALViQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:38:16 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:18394 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437135AbhALVRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 16:17:10 -0500
Date:   Tue, 12 Jan 2021 21:16:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610486185; bh=u3+4dtI12OmkQzaD7GjfxNXM1iUxv1TVQoI7JU869+E=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=AU3JUpGUyjwX/rK4G8Gl0j95eog5GBxUw8OsqyF60R0HDEAf/Eczl2QEWG2ymKaYE
         8/wFdVe7AsEADbDH+jA5CTk2rzsERtj7ZDwMVwV+zCYZn37sNOE5dcVa+Yd+kmA7kc
         56Kb3GIlJiPPPOAEtkzm+idAeZQTQ6HrxngOzogKFnzNrgX3ds3D+Mqc2RoCunJIEv
         r1RRwmJSNdlfa7WGxpPhCR9IWWqZ5FznmMmYZxVP+vM6fnClGEeEx1UAElPCk+IHf6
         cCkEn7Ria8I/p3+bkcSidM3qN5zQ2AAS6XDpNI5BZssUd65/JfSQTo7yEBYj7SFObm
         +QRk+z8TPtpwQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Eric Dumazet <edumazet@google.com>,
        Edward Cree <ecree@solarflare.com>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Lobakin <alobakin@pm.me>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next] udp: allow forwarding of plain (non-fraglisted) UDP GRO packets
Message-ID: <20210112211536.261172-1-alobakin@pm.me>
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
Tests showed that currently forwarding and NATing of plain UDP GRO
packets are performed fully correctly, regardless if the target
netdevice has a support for hardware/driver GSO UDP L4 or not.
Add the last element and allow to form plain UDP GRO packets if
there is no socket -> we are on forwarding path.

Plain UDP GRO forwarding even shows better performance than fraglisted
UDP GRO in some cases due to not wasting one skbuff_head per every
segment.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ipv4/udp_offload.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index ff39e94781bf..9d71df3d52ce 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -460,12 +460,13 @@ struct sk_buff *udp_gro_receive(struct list_head *hea=
d, struct sk_buff *skb,
 =09if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
 =09=09NAPI_GRO_CB(skb)->is_flist =3D sk ? !udp_sk(sk)->gro_enabled: 1;
=20
-=09if ((sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist) {
+=09if (!sk || (sk && udp_sk(sk)->gro_enabled) ||
+=09    NAPI_GRO_CB(skb)->is_flist) {
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


