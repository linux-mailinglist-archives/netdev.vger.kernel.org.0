Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A6CE5A3A
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfJZLrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:47:46 -0400
Received: from correo.us.es ([193.147.175.20]:46424 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbfJZLrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 842468C3C45
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75B10B8011
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6B669B7FFE; Sat, 26 Oct 2019 13:47:41 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79DD1B8001;
        Sat, 26 Oct 2019 13:47:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4B9EB42EE395;
        Sat, 26 Oct 2019 13:47:39 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 05/31] netfilter: ipset: make ip_set_put_flags extern.
Date:   Sat, 26 Oct 2019 13:47:07 +0200
Message-Id: <20191026114733.28111-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

ip_set_put_flags is rather large for a static inline function in a
header-file.  Move it to ip_set_core.c and export it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h | 23 +----------------------
 net/netfilter/ipset/ip_set_core.c      | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 44f6de8a1733..4d8b1eaf7708 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -276,28 +276,7 @@ ip_set_ext_destroy(struct ip_set *set, void *data)
 	}
 }
 
-static inline int
-ip_set_put_flags(struct sk_buff *skb, struct ip_set *set)
-{
-	u32 cadt_flags = 0;
-
-	if (SET_WITH_TIMEOUT(set))
-		if (unlikely(nla_put_net32(skb, IPSET_ATTR_TIMEOUT,
-					   htonl(set->timeout))))
-			return -EMSGSIZE;
-	if (SET_WITH_COUNTER(set))
-		cadt_flags |= IPSET_FLAG_WITH_COUNTERS;
-	if (SET_WITH_COMMENT(set))
-		cadt_flags |= IPSET_FLAG_WITH_COMMENT;
-	if (SET_WITH_SKBINFO(set))
-		cadt_flags |= IPSET_FLAG_WITH_SKBINFO;
-	if (SET_WITH_FORCEADD(set))
-		cadt_flags |= IPSET_FLAG_WITH_FORCEADD;
-
-	if (!cadt_flags)
-		return 0;
-	return nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(cadt_flags));
-}
+int ip_set_put_flags(struct sk_buff *skb, struct ip_set *set);
 
 /* Netlink CB args */
 enum {
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 30bc7df2f4cf..35cf59e4004b 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1418,6 +1418,30 @@ static int ip_set_swap(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 #define DUMP_TYPE(arg)		(((u32)(arg)) & 0x0000FFFF)
 #define DUMP_FLAGS(arg)		(((u32)(arg)) >> 16)
 
+int
+ip_set_put_flags(struct sk_buff *skb, struct ip_set *set)
+{
+	u32 cadt_flags = 0;
+
+	if (SET_WITH_TIMEOUT(set))
+		if (unlikely(nla_put_net32(skb, IPSET_ATTR_TIMEOUT,
+					   htonl(set->timeout))))
+			return -EMSGSIZE;
+	if (SET_WITH_COUNTER(set))
+		cadt_flags |= IPSET_FLAG_WITH_COUNTERS;
+	if (SET_WITH_COMMENT(set))
+		cadt_flags |= IPSET_FLAG_WITH_COMMENT;
+	if (SET_WITH_SKBINFO(set))
+		cadt_flags |= IPSET_FLAG_WITH_SKBINFO;
+	if (SET_WITH_FORCEADD(set))
+		cadt_flags |= IPSET_FLAG_WITH_FORCEADD;
+
+	if (!cadt_flags)
+		return 0;
+	return nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(cadt_flags));
+}
+EXPORT_SYMBOL_GPL(ip_set_put_flags);
+
 static int
 ip_set_dump_done(struct netlink_callback *cb)
 {
-- 
2.11.0

