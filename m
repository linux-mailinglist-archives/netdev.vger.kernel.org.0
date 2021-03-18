Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391AE340D69
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 19:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbhCRSnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 14:43:14 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:23574 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbhCRSmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 14:42:45 -0400
Date:   Thu, 18 Mar 2021 18:42:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616092962; bh=X+A01bVgCW9C0LcweX802pafQYX/MaNpf8hWlmvRiLI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=ihdVBEmjgnxfyRPkNRf6p8/oxzuoUGhnrp6NznWS9bSE5WC/C6TJe4eq3wNehnTwo
         XSxncp9rTywDwaLZ1VkljA4hoViA1ArxFmrMPpObCe9IXTCR8pJ6iXi5qtE3ukYhGJ
         c9vnxFBFBMryQwg3N4vEJvCrXTojaMWwR5YX8YYC5U56dZFTcp7bP8/g50FB41MAWE
         Oaam0BjnCsS/z9LFNcGyfN2TSSVDHn1RKB3nxpXu/Rx6rjR/kwhZsVLlTvIVVH7127
         /kAoc0UH3ivKn2fmFvTK7TpJugrpOKwtL16iEbx62f50ZKAJ1imdN8d8dCaXmfJXaE
         j1OdCDOS/OFtQ==
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
Subject: [PATCH net-next 3/4] vlan/8021q: avoid retpoline overhead on GRO
Message-ID: <20210318184157.700604-4-alobakin@pm.me>
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

The two most popular headers going after VLAN are IPv4 and IPv6.
Retpoline overhead for them is addressed only in dev_gro_receive(),
when they lie right after the outermost Ethernet header.
Use the indirect call wrappers in VLAN GRO receive code to reduce
the penalty on receiving tagged frames (when hardware stripping is
off or not available).

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/8021q/vlan_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 78ec2e1b14d1..59bc13b5f14f 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -4,6 +4,7 @@
 #include <linux/if_vlan.h>
 #include <linux/netpoll.h>
 #include <linux/export.h>
+#include <net/gro.h>
 #include "vlan.h"

 bool vlan_do_receive(struct sk_buff **skbp)
@@ -495,7 +496,10 @@ static struct sk_buff *vlan_gro_receive(struct list_he=
ad *head,

 =09skb_gro_pull(skb, sizeof(*vhdr));
 =09skb_gro_postpull_rcsum(skb, vhdr, sizeof(*vhdr));
-=09pp =3D call_gro_receive(ptype->callbacks.gro_receive, head, skb);
+
+=09pp =3D indirect_call_gro_receive_inet(ptype->callbacks.gro_receive,
+=09=09=09=09=09    ipv6_gro_receive, inet_gro_receive,
+=09=09=09=09=09    head, skb);

 out_unlock:
 =09rcu_read_unlock();
@@ -515,7 +519,9 @@ static int vlan_gro_complete(struct sk_buff *skb, int n=
hoff)
 =09rcu_read_lock();
 =09ptype =3D gro_find_complete_by_type(type);
 =09if (ptype)
-=09=09err =3D ptype->callbacks.gro_complete(skb, nhoff + sizeof(*vhdr));
+=09=09err =3D INDIRECT_CALL_INET(ptype->callbacks.gro_complete,
+=09=09=09=09=09 ipv6_gro_complete, inet_gro_complete,
+=09=09=09=09=09 skb, nhoff + sizeof(*vhdr));

 =09rcu_read_unlock();
 =09return err;
--
2.31.0


