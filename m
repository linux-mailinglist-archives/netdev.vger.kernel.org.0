Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEF2340D67
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhCRSnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:43:13 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:35379 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhCRSmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:42:42 -0400
Date:   Thu, 18 Mar 2021 18:42:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616092960; bh=lRsfcB6MOCDLr07XVaSyak4dBxm5+WyXdc1BMSXra2g=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=pKCNFQL/xr/CXt9HvoPgr9+uy4yPhiw//L6nBrmR539JfzGk91q/hhycZHWlBhKe0
         pEqihAX8BbLHii5g2NL91Rq+QVzslf02BZD6x6w8p31NMh+R7VxdhY/WT8qByzmqFa
         vGXL+j+v9MZmhur5h1LOMiKOB4isYNyyQedMOyiHHxaq+l3Oi66aiDrV2xb2tsHjgU
         OyJuHv8AMcALbcG6cJ+uMNaRJ0OqH4y9iz1mBtXCV8DF4r1LX2zHxi9TE9I6XMkk6i
         rrQomPXgnCtRRWaYr182NwLOSEjaMDHDR8lYDnn+6rUTw7PweuQS2ik0rCDEUF41V7
         exGiYWEwFqVJQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Leon Romanovsky <leon@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 4/4] ethernet: avoid retpoline overhead on TEB (GENEVE, NvGRE, VxLAN) GRO
Message-ID: <20210318184157.700604-5-alobakin@pm.me>
In-Reply-To: <20210318184157.700604-1-alobakin@pm.me>
References: <20210318184157.700604-1-alobakin@pm.me>
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

The two most popular headers going after Ethernet are IPv4 and IPv6.
Retpoline overhead for them is addressed only in dev_gro_receive(),
when they lie right after the outermost Ethernet header.
Use the indirect call wrappers in TEB (Transparent Ethernet Bridging,
such as GENEVE, NvGRE, VxLAN etc.) GRO receive code to reduce the
penalty when processing the inner headers.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/ethernet/eth.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index e01cf766d2c5..933b427122be 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -58,6 +58,7 @@
 #include <net/ip.h>
 #include <net/dsa.h>
 #include <net/flow_dissector.h>
+#include <net/gro.h>
 #include <linux/uaccess.h>
 #include <net/pkt_sched.h>

@@ -449,7 +450,10 @@ struct sk_buff *eth_gro_receive(struct list_head *head=
, struct sk_buff *skb)

 =09skb_gro_pull(skb, sizeof(*eh));
 =09skb_gro_postpull_rcsum(skb, eh, sizeof(*eh));
-=09pp =3D call_gro_receive(ptype->callbacks.gro_receive, head, skb);
+
+=09pp =3D indirect_call_gro_receive_inet(ptype->callbacks.gro_receive,
+=09=09=09=09=09    ipv6_gro_receive, inet_gro_receive,
+=09=09=09=09=09    head, skb);

 out_unlock:
 =09rcu_read_unlock();
@@ -473,8 +477,9 @@ int eth_gro_complete(struct sk_buff *skb, int nhoff)
 =09rcu_read_lock();
 =09ptype =3D gro_find_complete_by_type(type);
 =09if (ptype !=3D NULL)
-=09=09err =3D ptype->callbacks.gro_complete(skb, nhoff +
-=09=09=09=09=09=09    sizeof(struct ethhdr));
+=09=09err =3D INDIRECT_CALL_INET(ptype->callbacks.gro_complete,
+=09=09=09=09=09 ipv6_gro_complete, inet_gro_complete,
+=09=09=09=09=09 skb, nhoff + sizeof(*eh));

 =09rcu_read_unlock();
 =09return err;
--
2.31.0


