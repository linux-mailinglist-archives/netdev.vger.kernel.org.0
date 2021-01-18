Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12762FAA69
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394116AbhARTmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:42:25 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:29460 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437399AbhARTeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 14:34:24 -0500
Date:   Mon, 18 Jan 2021 19:33:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610998404; bh=C8ABwwYHkwQARcAAcxQdRAoNdGpuSuZgs01wmbrorcQ=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=Q9N36UStJD0wddnkzstxJ6fT0Gb4cEX/rwY+UVjVcYuz8vBG54JfxmJYWzEEbMy+E
         mhRwwHj7SZL65Orwdv7xcnTwk9RtwxQMexxDul5fTqxlftFGuwfbA5M+BqS/AKeskV
         XtyuBbi660cLFXukPjWsPmkZsQXoqAku7ut5IgfYXp8RWZ4OiCWEg8U+FloftNruto
         ruHlFQ/eiv7SxIjwG1+AJ8LgQxm2RsNIdmLQn20v/27IGzd14l1SAAh+reKITU3alJ
         k2Io/awU6ndYfbBRPMBLLZB6Rpr2pyvC0c7/IgWFmV0t9F4nkguIe6kUBGwoCV9yzX
         Md3D77KPBtsoA==
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
Subject: [PATCH net-next 2/2] udp: allow forwarding of plain (non-fraglisted) UDP GRO packets
Message-ID: <20210118193232.87583-2-alobakin@pm.me>
In-Reply-To: <20210118193232.87583-1-alobakin@pm.me>
References: <20210118193122.87271-1-alobakin@pm.me> <20210118193232.87583-1-alobakin@pm.me>
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
Plain UDP GRO forwarding even shows better performance than fraglisted
UDP GRO in some cases due to not wasting one skbuff_head per every
segment.

Add the last element and allow to form plain UDP GRO packets if
there is no socket -> we are on forwarding path, and the new
NETIF_F_GRO_UDP is enabled on a receiving netdevice.
Note that fraglisted UDP GRO now also depends on this feature, as
NETIF_F_GRO_FRAGLIST isn't tied to any particular L4 protocol.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ipv4/udp_offload.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index ff39e94781bf..781a035de5a9 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -454,13 +454,19 @@ struct sk_buff *udp_gro_receive(struct list_head *hea=
d, struct sk_buff *skb,
 =09struct sk_buff *p;
 =09struct udphdr *uh2;
 =09unsigned int off =3D skb_gro_offset(skb);
-=09int flush =3D 1;
+=09int flist =3D 0, flush =3D 1;
+=09bool gro_by_feat =3D false;
=20
-=09NAPI_GRO_CB(skb)->is_flist =3D 0;
-=09if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
-=09=09NAPI_GRO_CB(skb)->is_flist =3D sk ? !udp_sk(sk)->gro_enabled: 1;
+=09if (skb->dev->features & NETIF_F_GRO_UDP) {
+=09=09if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
+=09=09=09flist =3D !sk || !udp_sk(sk)->gro_enabled;
=20
-=09if ((sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist) {
+=09=09gro_by_feat =3D !sk || flist;
+=09}
+
+=09NAPI_GRO_CB(skb)->is_flist =3D flist;
+
+=09if (gro_by_feat || (sk && udp_sk(sk)->gro_enabled)) {
 =09=09pp =3D call_gro_receive(udp_gro_receive_segment, head, skb);
 =09=09return pp;
 =09}
--=20
2.30.0


