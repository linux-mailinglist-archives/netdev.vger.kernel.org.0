Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA08B2A1E42
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 14:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgKANRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 08:17:16 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:11209 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgKANRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 08:17:16 -0500
Date:   Sun, 01 Nov 2020 13:17:07 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1604236633; bh=MWc4+WdzEb9vlqPuIRHRa+VsUCStsNTEe71zwQOpcjU=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=VxKzvk7gAjSJqOu2Wge85kOLmXKUYEXt8jrBseQJLBDp9JOQPWNP5Zy13nx9M83YL
         3+3pDAmGDff+TQj1g+WJqIj6JTRPpvw1rLcvAmEM+Cyak1mf8Hx1bYKbwpMSmzky8h
         lzJqxo7gLA0WNU0HJsnrdNvEK4laSgcqZMDq7s+KQk9gTI02BSbJOS76PzItFBiHb1
         9kEALIFQ2panwhC1CDnbn8wMgzysiuktNM78Zyqvehi1oI+U734b8djgt6FrO43T+8
         zGEOomy5cWLmPQNdTnxbpkAp1S99rLJBZbyVvLpGPr1kkDP72sNWlPpgFQKmFBxJoL
         +27NGdOU/JGfA==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 net-next 1/2] net: add GSO UDP L4 and GSO fraglists to the list of software-backed types
Message-ID: <qXMvIwNa4HX1gIpQwq4bUiGIpTyB4QDWx9DDZHnNg@cp4-web-038.plabs.ch>
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

Commit e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.") and
commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") made UDP L4
and fraglisted GRO/GSO fully supported by the software fallback mode.
We can safely add them to NETIF_F_GSO_SOFTWARE to allow logical/virtual
netdevs to forward these types of skbs up to the real drivers.

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


