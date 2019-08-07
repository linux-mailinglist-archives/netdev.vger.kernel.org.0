Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8FF84E70
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388175AbfHGORL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:17:11 -0400
Received: from kadath.azazel.net ([81.187.231.250]:45990 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730013AbfHGORK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eylhb0MkiVkCbSx2TTXZcOlwAsrwVINaDBsbqC01HfY=; b=dl7VuGMQ1gheXiqdzi9O8HtOaT
        WLzDzrO1a88Q2ziBULK4GKicn4wSZ0goyNFRxaqIlYa6UnxRFGMRaW7okYBjDo2y0cq9HkRPmXpX9
        +ZUCCWqD/8uj55jwmUELRrqOXgJ9vDtTFLpwKyPXgtSfrGdVBVoFxuUENWv8jlH+XBpjC/n/Q4ece
        GJRg6mIgSYPLn1XgfempUEdNWUA0eeyB8mXgTaphCtmcCLL3H68IW6CNmVrkIzREIu33I0CWh7c/t
        kY6OiwOe8SADC0wW7+5v0Tpv3YUnU7EQHTOU6saMMi5M4LRFIh2psP+DHTQV/Yuvq36XNSLxGPbAQ
        LNHKIc/A==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hvMkU-0001Wc-87; Wed, 07 Aug 2019 15:17:06 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH net-next v1 1/8] netfilter: inlined four headers files into another one.
Date:   Wed,  7 Aug 2019 15:16:58 +0100
Message-Id: <20190807141705.4864-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190807141705.4864-1-jeremy@azazel.net>
References: <20190722201615.GE23346@azazel.net>
 <20190807141705.4864-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

linux/netfilter/ipset/ip_set.h included four other header files:

  include/linux/netfilter/ipset/ip_set_comment.h
  include/linux/netfilter/ipset/ip_set_counter.h
  include/linux/netfilter/ipset/ip_set_skbinfo.h
  include/linux/netfilter/ipset/ip_set_timeout.h

Of these the first three were not included anywhere else.  The last,
ip_set_timeout.h, was included in a couple of other places, but defined
inline functions which call other inline functions defined in ip_set.h,
so ip_set.h had to be included before it.

Inlined all four into ip_set.h, and updated the other files that
included ip_set_timeout.h.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/ipset/ip_set.h        | 238 +++++++++++++++++-
 .../linux/netfilter/ipset/ip_set_comment.h    |  73 ------
 .../linux/netfilter/ipset/ip_set_counter.h    |  84 -------
 .../linux/netfilter/ipset/ip_set_skbinfo.h    |  42 ----
 .../linux/netfilter/ipset/ip_set_timeout.h    |  77 ------
 net/netfilter/ipset/ip_set_hash_gen.h         |   2 +-
 net/netfilter/xt_set.c                        |   1 -
 7 files changed, 235 insertions(+), 282 deletions(-)
 delete mode 100644 include/linux/netfilter/ipset/ip_set_comment.h
 delete mode 100644 include/linux/netfilter/ipset/ip_set_counter.h
 delete mode 100644 include/linux/netfilter/ipset/ip_set_skbinfo.h
 delete mode 100644 include/linux/netfilter/ipset/ip_set_timeout.h

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 12ad9b1853b4..9bc255a8461b 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -452,10 +452,240 @@ bitmap_bytes(u32 a, u32 b)
 	return 4 * ((((b - a + 8) / 8) + 3) / 4);
 }
 
-#include <linux/netfilter/ipset/ip_set_timeout.h>
-#include <linux/netfilter/ipset/ip_set_comment.h>
-#include <linux/netfilter/ipset/ip_set_counter.h>
-#include <linux/netfilter/ipset/ip_set_skbinfo.h>
+/* How often should the gc be run by default */
+#define IPSET_GC_TIME			(3 * 60)
+
+/* Timeout period depending on the timeout value of the given set */
+#define IPSET_GC_PERIOD(timeout) \
+	((timeout/3) ? min_t(u32, (timeout)/3, IPSET_GC_TIME) : 1)
+
+/* Entry is set with no timeout value */
+#define IPSET_ELEM_PERMANENT	0
+
+/* Set is defined with timeout support: timeout value may be 0 */
+#define IPSET_NO_TIMEOUT	UINT_MAX
+
+/* Max timeout value, see msecs_to_jiffies() in jiffies.h */
+#define IPSET_MAX_TIMEOUT	(UINT_MAX >> 1)/MSEC_PER_SEC
+
+#define ip_set_adt_opt_timeout(opt, set)	\
+((opt)->ext.timeout != IPSET_NO_TIMEOUT ? (opt)->ext.timeout : (set)->timeout)
+
+static inline unsigned int
+ip_set_timeout_uget(struct nlattr *tb)
+{
+	unsigned int timeout = ip_set_get_h32(tb);
+
+	/* Normalize to fit into jiffies */
+	if (timeout > IPSET_MAX_TIMEOUT)
+		timeout = IPSET_MAX_TIMEOUT;
+
+	return timeout;
+}
+
+static inline bool
+ip_set_timeout_expired(const unsigned long *t)
+{
+	return *t != IPSET_ELEM_PERMANENT && time_is_before_jiffies(*t);
+}
+
+static inline void
+ip_set_timeout_set(unsigned long *timeout, u32 value)
+{
+	unsigned long t;
+
+	if (!value) {
+		*timeout = IPSET_ELEM_PERMANENT;
+		return;
+	}
+
+	t = msecs_to_jiffies(value * MSEC_PER_SEC) + jiffies;
+	if (t == IPSET_ELEM_PERMANENT)
+		/* Bingo! :-) */
+		t--;
+	*timeout = t;
+}
+
+static inline u32
+ip_set_timeout_get(const unsigned long *timeout)
+{
+	u32 t;
+
+	if (*timeout == IPSET_ELEM_PERMANENT)
+		return 0;
+
+	t = jiffies_to_msecs(*timeout - jiffies)/MSEC_PER_SEC;
+	/* Zero value in userspace means no timeout */
+	return t == 0 ? 1 : t;
+}
+
+static inline char*
+ip_set_comment_uget(struct nlattr *tb)
+{
+	return nla_data(tb);
+}
+
+/* Called from uadd only, protected by the set spinlock.
+ * The kadt functions don't use the comment extensions in any way.
+ */
+static inline void
+ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
+		    const struct ip_set_ext *ext)
+{
+	struct ip_set_comment_rcu *c = rcu_dereference_protected(comment->c, 1);
+	size_t len = ext->comment ? strlen(ext->comment) : 0;
+
+	if (unlikely(c)) {
+		set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
+		kfree_rcu(c, rcu);
+		rcu_assign_pointer(comment->c, NULL);
+	}
+	if (!len)
+		return;
+	if (unlikely(len > IPSET_MAX_COMMENT_SIZE))
+		len = IPSET_MAX_COMMENT_SIZE;
+	c = kmalloc(sizeof(*c) + len + 1, GFP_ATOMIC);
+	if (unlikely(!c))
+		return;
+	strlcpy(c->str, ext->comment, len + 1);
+	set->ext_size += sizeof(*c) + strlen(c->str) + 1;
+	rcu_assign_pointer(comment->c, c);
+}
+
+/* Used only when dumping a set, protected by rcu_read_lock() */
+static inline int
+ip_set_put_comment(struct sk_buff *skb, const struct ip_set_comment *comment)
+{
+	struct ip_set_comment_rcu *c = rcu_dereference(comment->c);
+
+	if (!c)
+		return 0;
+	return nla_put_string(skb, IPSET_ATTR_COMMENT, c->str);
+}
+
+/* Called from uadd/udel, flush or the garbage collectors protected
+ * by the set spinlock.
+ * Called when the set is destroyed and when there can't be any user
+ * of the set data anymore.
+ */
+static inline void
+ip_set_comment_free(struct ip_set *set, struct ip_set_comment *comment)
+{
+	struct ip_set_comment_rcu *c;
+
+	c = rcu_dereference_protected(comment->c, 1);
+	if (unlikely(!c))
+		return;
+	set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
+	kfree_rcu(c, rcu);
+	rcu_assign_pointer(comment->c, NULL);
+}
+
+static inline void
+ip_set_add_bytes(u64 bytes, struct ip_set_counter *counter)
+{
+	atomic64_add((long long)bytes, &(counter)->bytes);
+}
+
+static inline void
+ip_set_add_packets(u64 packets, struct ip_set_counter *counter)
+{
+	atomic64_add((long long)packets, &(counter)->packets);
+}
+
+static inline u64
+ip_set_get_bytes(const struct ip_set_counter *counter)
+{
+	return (u64)atomic64_read(&(counter)->bytes);
+}
+
+static inline u64
+ip_set_get_packets(const struct ip_set_counter *counter)
+{
+	return (u64)atomic64_read(&(counter)->packets);
+}
+
+static inline bool
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
+static inline void
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
+static inline bool
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
+static inline void
+ip_set_init_counter(struct ip_set_counter *counter,
+		    const struct ip_set_ext *ext)
+{
+	if (ext->bytes != ULLONG_MAX)
+		atomic64_set(&(counter)->bytes, (long long)(ext->bytes));
+	if (ext->packets != ULLONG_MAX)
+		atomic64_set(&(counter)->packets, (long long)(ext->packets));
+}
+
+static inline void
+ip_set_get_skbinfo(struct ip_set_skbinfo *skbinfo,
+		   const struct ip_set_ext *ext,
+		   struct ip_set_ext *mext, u32 flags)
+{
+	mext->skbinfo = *skbinfo;
+}
+
+static inline bool
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
+static inline void
+ip_set_init_skbinfo(struct ip_set_skbinfo *skbinfo,
+		    const struct ip_set_ext *ext)
+{
+	*skbinfo = ext->skbinfo;
+}
 
 #define IP_SET_INIT_KEXT(skb, opt, set)			\
 	{ .bytes = (skb)->len, .packets = 1,		\
diff --git a/include/linux/netfilter/ipset/ip_set_comment.h b/include/linux/netfilter/ipset/ip_set_comment.h
deleted file mode 100644
index 0b894d81bbf2..000000000000
--- a/include/linux/netfilter/ipset/ip_set_comment.h
+++ /dev/null
@@ -1,73 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _IP_SET_COMMENT_H
-#define _IP_SET_COMMENT_H
-
-/* Copyright (C) 2013 Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
- */
-
-#ifdef __KERNEL__
-
-static inline char*
-ip_set_comment_uget(struct nlattr *tb)
-{
-	return nla_data(tb);
-}
-
-/* Called from uadd only, protected by the set spinlock.
- * The kadt functions don't use the comment extensions in any way.
- */
-static inline void
-ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
-		    const struct ip_set_ext *ext)
-{
-	struct ip_set_comment_rcu *c = rcu_dereference_protected(comment->c, 1);
-	size_t len = ext->comment ? strlen(ext->comment) : 0;
-
-	if (unlikely(c)) {
-		set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
-		kfree_rcu(c, rcu);
-		rcu_assign_pointer(comment->c, NULL);
-	}
-	if (!len)
-		return;
-	if (unlikely(len > IPSET_MAX_COMMENT_SIZE))
-		len = IPSET_MAX_COMMENT_SIZE;
-	c = kmalloc(sizeof(*c) + len + 1, GFP_ATOMIC);
-	if (unlikely(!c))
-		return;
-	strlcpy(c->str, ext->comment, len + 1);
-	set->ext_size += sizeof(*c) + strlen(c->str) + 1;
-	rcu_assign_pointer(comment->c, c);
-}
-
-/* Used only when dumping a set, protected by rcu_read_lock() */
-static inline int
-ip_set_put_comment(struct sk_buff *skb, const struct ip_set_comment *comment)
-{
-	struct ip_set_comment_rcu *c = rcu_dereference(comment->c);
-
-	if (!c)
-		return 0;
-	return nla_put_string(skb, IPSET_ATTR_COMMENT, c->str);
-}
-
-/* Called from uadd/udel, flush or the garbage collectors protected
- * by the set spinlock.
- * Called when the set is destroyed and when there can't be any user
- * of the set data anymore.
- */
-static inline void
-ip_set_comment_free(struct ip_set *set, struct ip_set_comment *comment)
-{
-	struct ip_set_comment_rcu *c;
-
-	c = rcu_dereference_protected(comment->c, 1);
-	if (unlikely(!c))
-		return;
-	set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
-	kfree_rcu(c, rcu);
-	rcu_assign_pointer(comment->c, NULL);
-}
-
-#endif
-#endif
diff --git a/include/linux/netfilter/ipset/ip_set_counter.h b/include/linux/netfilter/ipset/ip_set_counter.h
deleted file mode 100644
index 3400958c07be..000000000000
--- a/include/linux/netfilter/ipset/ip_set_counter.h
+++ /dev/null
@@ -1,84 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _IP_SET_COUNTER_H
-#define _IP_SET_COUNTER_H
-
-/* Copyright (C) 2015 Jozsef Kadlecsik <kadlec@netfilter.org> */
-
-#ifdef __KERNEL__
-
-static inline void
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
-ip_set_init_counter(struct ip_set_counter *counter,
-		    const struct ip_set_ext *ext)
-{
-	if (ext->bytes != ULLONG_MAX)
-		atomic64_set(&(counter)->bytes, (long long)(ext->bytes));
-	if (ext->packets != ULLONG_MAX)
-		atomic64_set(&(counter)->packets, (long long)(ext->packets));
-}
-
-#endif /* __KERNEL__ */
-#endif /* _IP_SET_COUNTER_H */
diff --git a/include/linux/netfilter/ipset/ip_set_skbinfo.h b/include/linux/netfilter/ipset/ip_set_skbinfo.h
deleted file mode 100644
index 3a2df02dbd55..000000000000
--- a/include/linux/netfilter/ipset/ip_set_skbinfo.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _IP_SET_SKBINFO_H
-#define _IP_SET_SKBINFO_H
-
-/* Copyright (C) 2015 Jozsef Kadlecsik <kadlec@netfilter.org> */
-
-#ifdef __KERNEL__
-
-static inline void
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
-ip_set_init_skbinfo(struct ip_set_skbinfo *skbinfo,
-		    const struct ip_set_ext *ext)
-{
-	*skbinfo = ext->skbinfo;
-}
-
-#endif /* __KERNEL__ */
-#endif /* _IP_SET_SKBINFO_H */
diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/linux/netfilter/ipset/ip_set_timeout.h
deleted file mode 100644
index 2be60e379ecf..000000000000
--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ /dev/null
@@ -1,77 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _IP_SET_TIMEOUT_H
-#define _IP_SET_TIMEOUT_H
-
-/* Copyright (C) 2003-2013 Jozsef Kadlecsik <kadlec@netfilter.org> */
-
-#ifdef __KERNEL__
-
-/* How often should the gc be run by default */
-#define IPSET_GC_TIME			(3 * 60)
-
-/* Timeout period depending on the timeout value of the given set */
-#define IPSET_GC_PERIOD(timeout) \
-	((timeout/3) ? min_t(u32, (timeout)/3, IPSET_GC_TIME) : 1)
-
-/* Entry is set with no timeout value */
-#define IPSET_ELEM_PERMANENT	0
-
-/* Set is defined with timeout support: timeout value may be 0 */
-#define IPSET_NO_TIMEOUT	UINT_MAX
-
-/* Max timeout value, see msecs_to_jiffies() in jiffies.h */
-#define IPSET_MAX_TIMEOUT	(UINT_MAX >> 1)/MSEC_PER_SEC
-
-#define ip_set_adt_opt_timeout(opt, set)	\
-((opt)->ext.timeout != IPSET_NO_TIMEOUT ? (opt)->ext.timeout : (set)->timeout)
-
-static inline unsigned int
-ip_set_timeout_uget(struct nlattr *tb)
-{
-	unsigned int timeout = ip_set_get_h32(tb);
-
-	/* Normalize to fit into jiffies */
-	if (timeout > IPSET_MAX_TIMEOUT)
-		timeout = IPSET_MAX_TIMEOUT;
-
-	return timeout;
-}
-
-static inline bool
-ip_set_timeout_expired(const unsigned long *t)
-{
-	return *t != IPSET_ELEM_PERMANENT && time_is_before_jiffies(*t);
-}
-
-static inline void
-ip_set_timeout_set(unsigned long *timeout, u32 value)
-{
-	unsigned long t;
-
-	if (!value) {
-		*timeout = IPSET_ELEM_PERMANENT;
-		return;
-	}
-
-	t = msecs_to_jiffies(value * MSEC_PER_SEC) + jiffies;
-	if (t == IPSET_ELEM_PERMANENT)
-		/* Bingo! :-) */
-		t--;
-	*timeout = t;
-}
-
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
-#endif	/* __KERNEL__ */
-#endif /* _IP_SET_TIMEOUT_H */
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 0feb77fa9edc..2e541cb3b37d 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -7,7 +7,7 @@
 #include <linux/rcupdate.h>
 #include <linux/jhash.h>
 #include <linux/types.h>
-#include <linux/netfilter/ipset/ip_set_timeout.h>
+#include <linux/netfilter/ipset/ip_set.h>
 
 #define __ipset_dereference_protected(p, c)	rcu_dereference_protected(p, c)
 #define ipset_dereference_protected(p, set) \
diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
index ecbfa291fb70..731bc2cafae4 100644
--- a/net/netfilter/xt_set.c
+++ b/net/netfilter/xt_set.c
@@ -14,7 +14,6 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/ipset/ip_set.h>
-#include <linux/netfilter/ipset/ip_set_timeout.h>
 #include <uapi/linux/netfilter/xt_set.h>
 
 MODULE_LICENSE("GPL");
-- 
2.20.1

