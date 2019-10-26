Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14D43E5A0D
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfJZLrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:47:45 -0400
Received: from correo.us.es ([193.147.175.20]:46414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbfJZLro (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 650398C3C63
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58F53B8011
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 13:47:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4EB31B7FFB; Sat, 26 Oct 2019 13:47:40 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27522B7FFB;
        Sat, 26 Oct 2019 13:47:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E7FBA42EE393;
        Sat, 26 Oct 2019 13:47:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/31] netfilter: ipset: move ip_set_comment functions from ip_set.h to ip_set_core.c.
Date:   Sat, 26 Oct 2019 13:47:05 +0200
Message-Id: <20191026114733.28111-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Most of the functions are only called from within ip_set_core.c.

The exception is ip_set_init_comment.  However, this is too complex to
be a good candidate for a static inline function.  Move it to
ip_set_core.c, change its linkage to extern and export it, leaving a
declaration in ip_set.h.

ip_set_comment_free is only used as an extension destructor, so change
its prototype to match and drop cast.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/ipset/ip_set.h | 63 ++------------------------------
 net/netfilter/ipset/ip_set_core.c      | 66 +++++++++++++++++++++++++++++++++-
 2 files changed, 67 insertions(+), 62 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 9fee4837d02c..985c9bb1ab65 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -521,67 +521,8 @@ ip_set_timeout_get(const unsigned long *timeout)
 	return t == 0 ? 1 : t;
 }
 
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
+void ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
+			 const struct ip_set_ext *ext);
 
 static inline void
 ip_set_add_bytes(u64 bytes, struct ip_set_counter *counter)
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 04266295a750..73daea6d4bd5 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -325,6 +325,70 @@ ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr)
 }
 EXPORT_SYMBOL_GPL(ip_set_get_ipaddr6);
 
+static char *
+ip_set_comment_uget(struct nlattr *tb)
+{
+	return nla_data(tb);
+}
+
+/* Called from uadd only, protected by the set spinlock.
+ * The kadt functions don't use the comment extensions in any way.
+ */
+void
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
+EXPORT_SYMBOL_GPL(ip_set_init_comment);
+
+/* Used only when dumping a set, protected by rcu_read_lock() */
+static int
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
+static void
+ip_set_comment_free(struct ip_set *set, void *ptr)
+{
+	struct ip_set_comment *comment = ptr;
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
 typedef void (*destroyer)(struct ip_set *, void *);
 /* ipset data extension types, in size order */
 
@@ -351,7 +415,7 @@ const struct ip_set_ext_type ip_set_extensions[] = {
 		.flag	 = IPSET_FLAG_WITH_COMMENT,
 		.len	 = sizeof(struct ip_set_comment),
 		.align	 = __alignof__(struct ip_set_comment),
-		.destroy = (destroyer) ip_set_comment_free,
+		.destroy = ip_set_comment_free,
 	},
 };
 EXPORT_SYMBOL_GPL(ip_set_extensions);
-- 
2.11.0

