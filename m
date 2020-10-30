Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2E72A0D75
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgJ3SdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:33:16 -0400
Received: from mail-03.mail-europe.com ([91.134.188.129]:45876 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbgJ3SdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 14:33:16 -0400
Date:   Fri, 30 Oct 2020 18:33:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604082792; bh=LjCHrOdRA03o4xKg/F5+6+BqJIK8l1PZ5A6ied/We24=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=iInLccsSAHm9G0x94dqzQtSsPkfshjwiQnHvoKMjJqaLGyQU0SEfK4pGsMXLBDvgJ
         Wpns45I6YCiHVI3UA8Muhu0z8yk3j0bQecMxXbpibbHHeZzkUfpiQTqntv7lMQ1Xo7
         5g3QANmbTiD7kLAqbCkfmY3zmkFz7Yzi82aI0DnilgLePcs3zz7DnpjwGelRJJdrsP
         iU2T90ICVCjizL2nDimEyTFUIbWNu0ozkOhhKvksdzrv+GHSjQhrLcnNREoFMeHBBt
         xnbmkOdQhYiLWJZ962jkm58q2PzW/TylWzbY4IPvmtl5DQg1JRreHz7yEIy6s1iAdw
         V8PFs0VQZwRMw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Antoine Tenart <atenart@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next] net: avoid unneeded UDP L4 and fraglist GSO resegmentation
Message-ID: <Mx3BWGop6fGORN6Cpo4mHIHz2b1bb0eLxeMG8vsijnk@cp3-web-020.plabs.ch>
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

Commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") added a support
for fraglist UDP L4 and fraglist GSO not only for local traffic, but also
for forwarding. This works well on simple setups, but when any logical
netdev (e.g. VLAN) is present, kernel stack always performs software
resegmentation which actually kills the performance.
Despite the fact that no mainline drivers currently supports fraglist GSO,
this should and can be easily fixed by adding UDP L4 and fraglist GSO to
the list of GSO types that can be passed-through the logical interfaces
(NETIF_F_GSO_SOFTWARE). After this change, no resegmentation occurs (if
a particular driver supports and advertises this), and the performance
goes on par with e.g. 1:1 forwarding.
The only logical netdevs that seem to be unaffected to this are bridge
interfaces, as their code uses full NETIF_F_GSO_MASK.

Tested on MIPS32 R2 router board with a WIP NIC driver in VLAN NAT:
20 Mbps baseline, 1 Gbps / link speed with this patch.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/netdev_features.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_feature=
s.h
index 0b17c4322b09..934de56644e7 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -207,8 +207,8 @@ static inline int find_next_netdev_feature(u64 feature,=
 unsigned long start)
 =09=09=09=09 NETIF_F_FSO)
=20
 /* List of features with software fallbacks. */
-#define NETIF_F_GSO_SOFTWARE=09(NETIF_F_ALL_TSO | \
-=09=09=09=09 NETIF_F_GSO_SCTP)
+#define NETIF_F_GSO_SOFTWARE=09(NETIF_F_ALL_TSO | NETIF_F_GSO_SCTP |=09   =
  \
+=09=09=09=09 NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_FRAGLIST)
=20
 /*
  * If one device supports one of these features, then enable them
--=20
2.29.2


