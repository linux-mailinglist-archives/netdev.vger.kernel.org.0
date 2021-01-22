Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6758D300C2F
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 20:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbhAVSlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:41:12 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:43460 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729751AbhAVSV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 13:21:27 -0500
Date:   Fri, 22 Jan 2021 18:20:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611339608; bh=3Se3t8/e965C8Ew1Ejqh+IdWYEkkWugaOHxVVDEiiPE=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=lm7E5XbFhVahxNDM4EjEp66omOhsJsLnftvpFpzO+JnkLwyBXrTHVZqRG8ZgFI8UT
         kfE7BAjn/WXX2yaY8Hoamrmv9Ir3N2re77CAcCND3ltetwXajlJet0gYr1hONOeXXC
         DHhPIixmweZZ6j+Q10ULPz+29e6Qj5vMfgJhHkBlPSWt+L4C1Y+/L0NgkEOpiPLMTS
         cgrv3IN7X9dLtvSO+uyvD0DvpjAv+dP3fmKFJgBxBc1t4FLExx2PDiTAhwbwt4EMbc
         PArgUgGwSJRvw+i7lMmsSs24MjWsE+d9jnKcb8OlkiEB+hNvHwCBBqY8/UZW7cx+s5
         1X21JE2IDAukw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Igor Russkikh <irusskikh@marvell.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>,
        Meir Lichtinger <meirl@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v4 net-next 2/2] udp: allow forwarding of plain (non-fraglisted) UDP GRO packets
Message-ID: <20210122181909.36340-3-alobakin@pm.me>
In-Reply-To: <20210122181909.36340-1-alobakin@pm.me>
References: <20210122181909.36340-1-alobakin@pm.me>
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
we are on forwarding path, and the new NETIF_F_GRO_UDP_FWD is
enabled on a receiving netdevice.

If both NETIF_F_GRO_FRAGLIST and NETIF_F_GRO_UDP_FWD are set,
fraglisted GRO takes precedence. This keeps the current behaviour
and is generally more optimal for now, as the number of NICs with
hardware USO offload is relatively small.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ipv4/udp_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 1168d186cc43..41249705d9e9 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -460,7 +460,8 @@ struct sk_buff *udp_gro_receive(struct list_head *head,=
 struct sk_buff *skb,
 =09if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
 =09=09NAPI_GRO_CB(skb)->is_flist =3D sk ? !udp_sk(sk)->gro_enabled: 1;
=20
-=09if ((sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist) {
+=09if ((!sk && (skb->dev->features & NETIF_F_GRO_UDP_FWD)) ||
+=09    (sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist) {
 =09=09pp =3D call_gro_receive(udp_gro_receive_segment, head, skb);
 =09=09return pp;
 =09}
--=20
2.30.0


