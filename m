Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11DBEE5A46
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfJZLsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:48:35 -0400
Received: from correo.us.es ([193.147.175.20]:46416 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfJZLrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 13F8A8C3C57
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC38AB8011
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E1947B8007; Sat, 26 Oct 2019 13:47:40 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD249DA72F;
        Sat, 26 Oct 2019 13:47:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9DB2C42EE393;
        Sat, 26 Oct 2019 13:47:38 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/31] netfilter: ipset: move functions to ip_set_core.c.
Date:   Sat, 26 Oct 2019 13:47:06 +0200
Message-Id: <20191026114733.28111-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Several inline functions in ip_set.h are only called in ip_set_core.c:
move them and remove inline function specifier.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h | 102 ---------------------------------
 net/netfilter/ipset/ip_set_core.c      | 102 +++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+), 102 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 985c9bb1ab65..44f6de8a1733 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -508,87 +508,10 @@ ip_set_timeout_set(unsigned long *timeout, u32 value)
 	*timeout = t;
 }
 
-static inline u32
-ip_set_timeout_get(const unsigned long *timeout)
-{
-	u32 t;
-
-	if (*timeout == IPSET_ELEM_PERMANENT)
-		return 0;
-
-	t = jiffies_to_msecs(*timeout - jiffies)/MSEC_PER_SEC;
-	/* Zero value in userspace means no timeout */
-	return t == 0 ? 1 : t;
-}
-
 void ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 			 const struct ip_set_ext *ext);
 
 static inline void
-ip_set_add_bytes(u64 bytes, struct ip_set_counter *counter)
-{
-	atomic64_add((long long)bytes, &(counter)->bytes);
-}
-
-static inline void
-ip_set_add_packets(u64 packets, struct ip_set_counter *counter)
-{
-	atomic64_add((long long)packets, &(counter)->packets);
-}
-
-static inline u64
-ip_set_get_bytes(const struct ip_set_counter *counter)
-{
-	return (u64)atomic64_read(&(counter)->bytes);
-}
-
-static inline u64
-ip_set_get_packets(const struct ip_set_counter *counter)
-{
-	return (u64)atomic64_read(&(counter)->packets);
-}
-
-static inline bool
-ip_set_match_counter(u64 counter, u64 match, u8 op)
-{
-	switch (op) {
-	case IPSET_COUNTER_NONE:
-		return true;
-	case IPSET_COUNTER_EQ:
-		return counter == match;
-	case IPSET_COUNTER_NE:
-		return counter != match;
-	case IPSET_COUNTER_LT:
-		return counter < match;
-	case IPSET_COUNTER_GT:
-		return counter > match;
-	}
-	return false;
-}
-
-static inline void
-ip_set_update_counter(struct ip_set_counter *counter,
-		      const struct ip_set_ext *ext, u32 flags)
-{
-	if (ext->packets != ULLONG_MAX &&
-	    !(flags & IPSET_FLAG_SKIP_COUNTER_UPDATE)) {
-		ip_set_add_bytes(ext->bytes, counter);
-		ip_set_add_packets(ext->packets, counter);
-	}
-}
-
-static inline bool
-ip_set_put_counter(struct sk_buff *skb, const struct ip_set_counter *counter)
-{
-	return nla_put_net64(skb, IPSET_ATTR_BYTES,
-			     cpu_to_be64(ip_set_get_bytes(counter)),
-			     IPSET_ATTR_PAD) ||
-	       nla_put_net64(skb, IPSET_ATTR_PACKETS,
-			     cpu_to_be64(ip_set_get_packets(counter)),
-			     IPSET_ATTR_PAD);
-}
-
-static inline void
 ip_set_init_counter(struct ip_set_counter *counter,
 		    const struct ip_set_ext *ext)
 {
@@ -599,31 +522,6 @@ ip_set_init_counter(struct ip_set_counter *counter,
 }
 
 static inline void
-ip_set_get_skbinfo(struct ip_set_skbinfo *skbinfo,
-		   const struct ip_set_ext *ext,
-		   struct ip_set_ext *mext, u32 flags)
-{
-	mext->skbinfo = *skbinfo;
-}
-
-static inline bool
-ip_set_put_skbinfo(struct sk_buff *skb, const struct ip_set_skbinfo *skbinfo)
-{
-	/* Send nonzero parameters only */
-	return ((skbinfo->skbmark || skbinfo->skbmarkmask) &&
-		nla_put_net64(skb, IPSET_ATTR_SKBMARK,
-			      cpu_to_be64((u64)skbinfo->skbmark << 32 |
-					  skbinfo->skbmarkmask),
-			      IPSET_ATTR_PAD)) ||
-	       (skbinfo->skbprio &&
-		nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
-			      cpu_to_be32(skbinfo->skbprio))) ||
-	       (skbinfo->skbqueue &&
-		nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
-			      cpu_to_be16(skbinfo->skbqueue)));
-}
-
-static inline void
 ip_set_init_skbinfo(struct ip_set_skbinfo *skbinfo,
 		    const struct ip_set_ext *ext)
 {
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 73daea6d4bd5..30bc7df2f4cf 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -325,6 +325,19 @@ ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr)
 }
 EXPORT_SYMBOL_GPL(ip_set_get_ipaddr6);
 
+static u32
+ip_set_timeout_get(const unsigned long *timeout)
+{
+	u32 t;
+
+	if (*timeout == IPSET_ELEM_PERMANENT)
+		return 0;
+
+	t = jiffies_to_msecs(*timeout - jiffies) / MSEC_PER_SEC;
+	/* Zero value in userspace means no timeout */
+	return t == 0 ? 1 : t;
+}
+
 static char *
 ip_set_comment_uget(struct nlattr *tb)
 {
@@ -510,6 +523,46 @@ ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 }
 EXPORT_SYMBOL_GPL(ip_set_get_extensions);
 
+static u64
+ip_set_get_bytes(const struct ip_set_counter *counter)
+{
+	return (u64)atomic64_read(&(counter)->bytes);
+}
+
+static u64
+ip_set_get_packets(const struct ip_set_counter *counter)
+{
+	return (u64)atomic64_read(&(counter)->packets);
+}
+
+static bool
+ip_set_put_counter(struct sk_buff *skb, const struct ip_set_counter *counter)
+{
+	return nla_put_net64(skb, IPSET_ATTR_BYTES,
+			     cpu_to_be64(ip_set_get_bytes(counter)),
+			     IPSET_ATTR_PAD) ||
+	       nla_put_net64(skb, IPSET_ATTR_PACKETS,
+			     cpu_to_be64(ip_set_get_packets(counter)),
+			     IPSET_ATTR_PAD);
+}
+
+static bool
+ip_set_put_skbinfo(struct sk_buff *skb, const struct ip_set_skbinfo *skbinfo)
+{
+	/* Send nonzero parameters only */
+	return ((skbinfo->skbmark || skbinfo->skbmarkmask) &&
+		nla_put_net64(skb, IPSET_ATTR_SKBMARK,
+			      cpu_to_be64((u64)skbinfo->skbmark << 32 |
+					  skbinfo->skbmarkmask),
+			      IPSET_ATTR_PAD)) ||
+	       (skbinfo->skbprio &&
+		nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
+			      cpu_to_be32(skbinfo->skbprio))) ||
+	       (skbinfo->skbqueue &&
+		nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
+			      cpu_to_be16(skbinfo->skbqueue)));
+}
+
 int
 ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
 		      const void *e, bool active)
@@ -535,6 +588,55 @@ ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
 }
 EXPORT_SYMBOL_GPL(ip_set_put_extensions);
 
+static bool
+ip_set_match_counter(u64 counter, u64 match, u8 op)
+{
+	switch (op) {
+	case IPSET_COUNTER_NONE:
+		return true;
+	case IPSET_COUNTER_EQ:
+		return counter == match;
+	case IPSET_COUNTER_NE:
+		return counter != match;
+	case IPSET_COUNTER_LT:
+		return counter < match;
+	case IPSET_COUNTER_GT:
+		return counter > match;
+	}
+	return false;
+}
+
+static void
+ip_set_add_bytes(u64 bytes, struct ip_set_counter *counter)
+{
+	atomic64_add((long long)bytes, &(counter)->bytes);
+}
+
+static void
+ip_set_add_packets(u64 packets, struct ip_set_counter *counter)
+{
+	atomic64_add((long long)packets, &(counter)->packets);
+}
+
+static void
+ip_set_update_counter(struct ip_set_counter *counter,
+		      const struct ip_set_ext *ext, u32 flags)
+{
+	if (ext->packets != ULLONG_MAX &&
+	    !(flags & IPSET_FLAG_SKIP_COUNTER_UPDATE)) {
+		ip_set_add_bytes(ext->bytes, counter);
+		ip_set_add_packets(ext->packets, counter);
+	}
+}
+
+static void
+ip_set_get_skbinfo(struct ip_set_skbinfo *skbinfo,
+		   const struct ip_set_ext *ext,
+		   struct ip_set_ext *mext, u32 flags)
+{
+	mext->skbinfo = *skbinfo;
+}
+
 bool
 ip_set_match_extensions(struct ip_set *set, const struct ip_set_ext *ext,
 			struct ip_set_ext *mext, u32 flags, void *data)
-- 
2.11.0

