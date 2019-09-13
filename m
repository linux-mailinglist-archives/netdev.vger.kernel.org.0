Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA0DB1C45
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388206AbfIMLbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:35 -0400
Received: from correo.us.es ([193.147.175.20]:42600 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388169AbfIMLbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 69C1D4FFE17
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5888BA7E24
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4DD4AA7E27; Fri, 13 Sep 2019 13:31:26 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C9E0A7E21;
        Fri, 13 Sep 2019 13:31:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DEE5042EE395;
        Fri, 13 Sep 2019 13:31:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 23/27] netfilter: conntrack: move code to linux/nf_conntrack_common.h.
Date:   Fri, 13 Sep 2019 13:30:58 +0200
Message-Id: <20190913113102.15776-24-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Move some `struct nf_conntrack` code from linux/skbuff.h to
linux/nf_conntrack_common.h.  Together with a couple of helpers for
getting and setting skb->_nfct, it allows us to remove
CONFIG_NF_CONNTRACK checks from net/netfilter/nf_conntrack.h.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_common.h | 20 +++++++++++++++++
 include/linux/skbuff.h                        | 32 +++++++++++++--------------
 include/net/netfilter/nf_conntrack.h          | 24 +++++---------------
 net/netfilter/nf_conntrack_standalone.c       |  1 -
 4 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index e142b2b5f1ea..1db83c931d9c 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -2,6 +2,7 @@
 #ifndef _NF_CONNTRACK_COMMON_H
 #define _NF_CONNTRACK_COMMON_H
 
+#include <linux/atomic.h>
 #include <uapi/linux/netfilter/nf_conntrack_common.h>
 
 struct ip_conntrack_stat {
@@ -19,4 +20,23 @@ struct ip_conntrack_stat {
 	unsigned int search_restart;
 };
 
+#define NFCT_INFOMASK	7UL
+#define NFCT_PTRMASK	~(NFCT_INFOMASK)
+
+struct nf_conntrack {
+	atomic_t use;
+};
+
+void nf_conntrack_destroy(struct nf_conntrack *nfct);
+static inline void nf_conntrack_put(struct nf_conntrack *nfct)
+{
+	if (nfct && atomic_dec_and_test(&nfct->use))
+		nf_conntrack_destroy(nfct);
+}
+static inline void nf_conntrack_get(struct nf_conntrack *nfct)
+{
+	if (nfct)
+		atomic_inc(&nfct->use);
+}
+
 #endif /* _NF_CONNTRACK_COMMON_H */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 028e684fa974..907209c0794e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -37,6 +37,9 @@
 #include <linux/in6.h>
 #include <linux/if_packet.h>
 #include <net/flow.h>
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#include <linux/netfilter/nf_conntrack_common.h>
+#endif
 
 /* The interface for checksum offload between the stack and networking drivers
  * is as follows...
@@ -244,12 +247,6 @@ struct bpf_prog;
 union bpf_attr;
 struct skb_ext;
 
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
-struct nf_conntrack {
-	atomic_t use;
-};
-#endif
-
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 struct nf_bridge_info {
 	enum {
@@ -914,7 +911,6 @@ static inline bool skb_pfmemalloc(const struct sk_buff *skb)
 #define SKB_DST_NOREF	1UL
 #define SKB_DST_PTRMASK	~(SKB_DST_NOREF)
 
-#define SKB_NFCT_PTRMASK	~(7UL)
 /**
  * skb_dst - returns skb dst_entry
  * @skb: buffer
@@ -4040,25 +4036,27 @@ static inline void skb_remcsum_process(struct sk_buff *skb, void *ptr,
 static inline struct nf_conntrack *skb_nfct(const struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	return (void *)(skb->_nfct & SKB_NFCT_PTRMASK);
+	return (void *)(skb->_nfct & NFCT_PTRMASK);
 #else
 	return NULL;
 #endif
 }
 
-#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
-void nf_conntrack_destroy(struct nf_conntrack *nfct);
-static inline void nf_conntrack_put(struct nf_conntrack *nfct)
+static inline unsigned long skb_get_nfct(const struct sk_buff *skb)
 {
-	if (nfct && atomic_dec_and_test(&nfct->use))
-		nf_conntrack_destroy(nfct);
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	return skb->_nfct;
+#else
+	return 0UL;
+#endif
 }
-static inline void nf_conntrack_get(struct nf_conntrack *nfct)
+
+static inline void skb_set_nfct(struct sk_buff *skb, unsigned long nfct)
 {
-	if (nfct)
-		atomic_inc(&nfct->use);
-}
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	skb->_nfct = nfct;
 #endif
+}
 
 #ifdef CONFIG_SKB_EXTENSIONS
 enum skb_ext_id {
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 22275f42f0bb..9f551f3b69c6 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -13,12 +13,10 @@
 #ifndef _NF_CONNTRACK_H
 #define _NF_CONNTRACK_H
 
-#include <linux/netfilter/nf_conntrack_common.h>
-
 #include <linux/bitops.h>
 #include <linux/compiler.h>
-#include <linux/atomic.h>
 
+#include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tcp.h>
 #include <linux/netfilter/nf_conntrack_dccp.h>
 #include <linux/netfilter/nf_conntrack_sctp.h>
@@ -58,7 +56,6 @@ struct nf_conntrack_net {
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
 struct nf_conn {
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	/* Usage count in here is 1 for hash table, 1 per skb,
 	 * plus 1 for any connection(s) we are `master' for
 	 *
@@ -68,7 +65,6 @@ struct nf_conn {
 	 * beware nf_ct_get() is different and don't inc refcnt.
 	 */
 	struct nf_conntrack ct_general;
-#endif
 
 	spinlock_t	lock;
 	/* jiffies32 when this ct is considered dead */
@@ -149,18 +145,14 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 int nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 			     const struct nf_conn *ignored_conntrack);
 
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-
-#define NFCT_INFOMASK	7UL
-#define NFCT_PTRMASK	~(NFCT_INFOMASK)
-
 /* Return conntrack_info and tuple hash for given skb. */
 static inline struct nf_conn *
 nf_ct_get(const struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
 {
-	*ctinfo = skb->_nfct & NFCT_INFOMASK;
+	unsigned long nfct = skb_get_nfct(skb);
 
-	return (struct nf_conn *)(skb->_nfct & NFCT_PTRMASK);
+	*ctinfo = nfct & NFCT_INFOMASK;
+	return (struct nf_conn *)(nfct & NFCT_PTRMASK);
 }
 
 /* decrement reference count on a conntrack */
@@ -170,8 +162,6 @@ static inline void nf_ct_put(struct nf_conn *ct)
 	nf_conntrack_put(&ct->ct_general);
 }
 
-#endif
-
 /* Protocol module loading */
 int nf_ct_l3proto_try_module_get(unsigned short l3proto);
 void nf_ct_l3proto_module_put(unsigned short l3proto);
@@ -323,16 +313,12 @@ void nf_ct_tmpl_free(struct nf_conn *tmpl);
 
 u32 nf_ct_get_id(const struct nf_conn *ct);
 
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-
 static inline void
 nf_ct_set(struct sk_buff *skb, struct nf_conn *ct, enum ip_conntrack_info info)
 {
-	skb->_nfct = (unsigned long)ct | info;
+	skb_set_nfct(skb, (unsigned long)ct | info);
 }
 
-#endif
-
 #define NF_CT_STAT_INC(net, count)	  __this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_INC_ATOMIC(net, count) this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_ADD_ATOMIC(net, count, v) this_cpu_add((net)->ct.stat->count, (v))
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 88d4127df863..410809c669e1 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1167,7 +1167,6 @@ static int __init nf_conntrack_standalone_init(void)
 	if (ret < 0)
 		goto out_start;
 
-	BUILD_BUG_ON(SKB_NFCT_PTRMASK != NFCT_PTRMASK);
 	BUILD_BUG_ON(NFCT_INFOMASK <= IP_CT_NUMBER);
 
 #ifdef CONFIG_SYSCTL
-- 
2.11.0

