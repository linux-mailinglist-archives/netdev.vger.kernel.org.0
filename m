Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A684E5A49
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfJZLsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:48:40 -0400
Received: from correo.us.es ([193.147.175.20]:46414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbfJZLrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2BE2D8C3C66
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1F977FF13B
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 14B1AB7FF2; Sat, 26 Oct 2019 13:47:42 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 22F52B8005;
        Sat, 26 Oct 2019 13:47:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E847E42EE395;
        Sat, 26 Oct 2019 13:47:39 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/31] netfilter: ipset: move function to ip_set_bitmap_ip.c.
Date:   Sat, 26 Oct 2019 13:47:08 +0200
Message-Id: <20191026114733.28111-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

One inline function in ip_set_bitmap.h is only called in
ip_set_bitmap_ip.c: move it and remove inline function specifier.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set_bitmap.h | 14 --------------
 net/netfilter/ipset/ip_set_bitmap_ip.c        | 12 ++++++++++++
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_bitmap.h b/include/linux/netfilter/ipset/ip_set_bitmap.h
index 2dddbc6dcac7..fcc4d214a788 100644
--- a/include/linux/netfilter/ipset/ip_set_bitmap.h
+++ b/include/linux/netfilter/ipset/ip_set_bitmap.h
@@ -12,18 +12,4 @@ enum {
 	IPSET_ADD_START_STORED_TIMEOUT,
 };
 
-/* Common functions */
-
-static inline u32
-range_to_mask(u32 from, u32 to, u8 *bits)
-{
-	u32 mask = 0xFFFFFFFE;
-
-	*bits = 32;
-	while (--(*bits) > 0 && mask && (to & mask) != from)
-		mask <<= 1;
-
-	return mask;
-}
-
 #endif /* __IP_SET_BITMAP_H */
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index c06172d5b017..abe8f77d7d23 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -237,6 +237,18 @@ init_map_ip(struct ip_set *set, struct bitmap_ip *map,
 	return true;
 }
 
+static u32
+range_to_mask(u32 from, u32 to, u8 *bits)
+{
+	u32 mask = 0xFFFFFFFE;
+
+	*bits = 32;
+	while (--(*bits) > 0 && mask && (to & mask) != from)
+		mask <<= 1;
+
+	return mask;
+}
+
 static int
 bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 		 u32 flags)
-- 
2.11.0

