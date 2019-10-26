Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4DADE5A48
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfJZLsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:48:38 -0400
Received: from correo.us.es ([193.147.175.20]:46410 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbfJZLrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DBC988C3C63
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF5AEA7EFC
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C4C0FA7EE5; Sat, 26 Oct 2019 13:47:42 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C550CB7FFB;
        Sat, 26 Oct 2019 13:47:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 935AA42EE395;
        Sat, 26 Oct 2019 13:47:40 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/31] netfilter: ipset: move ip_set_get_ip_port() to ip_set_bitmap_port.c.
Date:   Sat, 26 Oct 2019 13:47:09 +0200
Message-Id: <20191026114733.28111-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

ip_set_get_ip_port() is only used in ip_set_bitmap_port.c.  Move it
there and make it static.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set_getport.h |  3 ---
 net/netfilter/ipset/ip_set_bitmap_port.c       | 27 +++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_getport.c           | 28 --------------------------
 3 files changed, 27 insertions(+), 31 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_getport.h b/include/linux/netfilter/ipset/ip_set_getport.h
index d74cd112b88a..1ecaabd9a048 100644
--- a/include/linux/netfilter/ipset/ip_set_getport.h
+++ b/include/linux/netfilter/ipset/ip_set_getport.h
@@ -20,9 +20,6 @@ static inline bool ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
 }
 #endif
 
-extern bool ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool src,
-				__be16 *port);
-
 static inline bool ip_set_proto_with_ports(u8 proto)
 {
 	switch (proto) {
diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index 72fede25469d..23d6095cb196 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -96,6 +96,33 @@ bitmap_port_do_head(struct sk_buff *skb, const struct bitmap_port *map)
 	       nla_put_net16(skb, IPSET_ATTR_PORT_TO, htons(map->last_port));
 }
 
+static bool
+ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool src, __be16 *port)
+{
+	bool ret;
+	u8 proto;
+
+	switch (pf) {
+	case NFPROTO_IPV4:
+		ret = ip_set_get_ip4_port(skb, src, port, &proto);
+		break;
+	case NFPROTO_IPV6:
+		ret = ip_set_get_ip6_port(skb, src, port, &proto);
+		break;
+	default:
+		return false;
+	}
+	if (!ret)
+		return ret;
+	switch (proto) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int
 bitmap_port_kadt(struct ip_set *set, const struct sk_buff *skb,
 		 const struct xt_action_param *par,
diff --git a/net/netfilter/ipset/ip_set_getport.c b/net/netfilter/ipset/ip_set_getport.c
index 2b8f959574b4..36615eb3eae1 100644
--- a/net/netfilter/ipset/ip_set_getport.c
+++ b/net/netfilter/ipset/ip_set_getport.c
@@ -148,31 +148,3 @@ ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
 }
 EXPORT_SYMBOL_GPL(ip_set_get_ip6_port);
 #endif
-
-bool
-ip_set_get_ip_port(const struct sk_buff *skb, u8 pf, bool src, __be16 *port)
-{
-	bool ret;
-	u8 proto;
-
-	switch (pf) {
-	case NFPROTO_IPV4:
-		ret = ip_set_get_ip4_port(skb, src, port, &proto);
-		break;
-	case NFPROTO_IPV6:
-		ret = ip_set_get_ip6_port(skb, src, port, &proto);
-		break;
-	default:
-		return false;
-	}
-	if (!ret)
-		return ret;
-	switch (proto) {
-	case IPPROTO_TCP:
-	case IPPROTO_UDP:
-		return true;
-	default:
-		return false;
-	}
-}
-EXPORT_SYMBOL_GPL(ip_set_get_ip_port);
-- 
2.11.0

