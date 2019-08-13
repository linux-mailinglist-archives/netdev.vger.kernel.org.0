Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5B18C0C9
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfHMSiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:38:19 -0400
Received: from correo.us.es ([193.147.175.20]:59002 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfHMSiT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 14:38:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 84B48DA73F
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:38:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 757614CA35
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:38:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6B1FDD190F; Tue, 13 Aug 2019 20:38:16 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 403064CA35;
        Tue, 13 Aug 2019 20:38:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:38:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E906B4265A2F;
        Tue, 13 Aug 2019 20:38:13 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/17] netfilter: add missing IS_ENABLED(CONFIG_NF_CONNTRACK) checks to some header-files.
Date:   Tue, 13 Aug 2019 20:38:03 +0200
Message-Id: <20190813183809.4081-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813183809.4081-1-pablo@netfilter.org>
References: <20190813183809.4081-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

struct nf_conn contains a "struct nf_conntrack ct_general" member and
struct net contains a "struct netns_ct ct" member which are both only
defined in CONFIG_NF_CONNTRACK is enabled.  These members are used in a
number of inline functions defined in other header-files.  Added
preprocessor checks to make sure the headers will compile if
CONFIG_NF_CONNTRACK is disabled.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h           | 10 ++++++++++
 include/net/netfilter/nf_conntrack_acct.h      | 13 +++++++++++++
 include/net/netfilter/nf_conntrack_l4proto.h   |  2 ++
 include/net/netfilter/nf_conntrack_timestamp.h |  6 ++++++
 4 files changed, 31 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index c86657d99630..2cc304efe7f9 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -59,6 +59,7 @@ struct nf_conntrack_net {
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
 struct nf_conn {
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	/* Usage count in here is 1 for hash table, 1 per skb,
 	 * plus 1 for any connection(s) we are `master' for
 	 *
@@ -68,6 +69,7 @@ struct nf_conn {
 	 * beware nf_ct_get() is different and don't inc refcnt.
 	 */
 	struct nf_conntrack ct_general;
+#endif
 
 	spinlock_t	lock;
 	/* jiffies32 when this ct is considered dead */
@@ -148,6 +150,8 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 int nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 			     const struct nf_conn *ignored_conntrack);
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #define NFCT_INFOMASK	7UL
 #define NFCT_PTRMASK	~(NFCT_INFOMASK)
 
@@ -167,6 +171,8 @@ static inline void nf_ct_put(struct nf_conn *ct)
 	nf_conntrack_put(&ct->ct_general);
 }
 
+#endif
+
 /* Protocol module loading */
 int nf_ct_l3proto_try_module_get(unsigned short l3proto);
 void nf_ct_l3proto_module_put(unsigned short l3proto);
@@ -318,12 +324,16 @@ void nf_ct_tmpl_free(struct nf_conn *tmpl);
 
 u32 nf_ct_get_id(const struct nf_conn *ct);
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 static inline void
 nf_ct_set(struct sk_buff *skb, struct nf_conn *ct, enum ip_conntrack_info info)
 {
 	skb->_nfct = (unsigned long)ct | info;
 }
 
+#endif
+
 #define NF_CT_STAT_INC(net, count)	  __this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_INC_ATOMIC(net, count) this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_ADD_ATOMIC(net, count, v) this_cpu_add((net)->ct.stat->count, (v))
diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index 1fee733c18a7..ad9f2172dee1 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -29,6 +29,7 @@ struct nf_conn_acct *nf_conn_acct_find(const struct nf_conn *ct)
 static inline
 struct nf_conn_acct *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
 {
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	struct net *net = nf_ct_net(ct);
 	struct nf_conn_acct *acct;
 
@@ -41,22 +42,34 @@ struct nf_conn_acct *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
 
 
 	return acct;
+#else
+	return NULL;
+#endif
 };
 
 /* Check if connection tracking accounting is enabled */
 static inline bool nf_ct_acct_enabled(struct net *net)
 {
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	return net->ct.sysctl_acct != 0;
+#else
+	return false;
+#endif
 }
 
 /* Enable/disable connection tracking accounting */
 static inline void nf_ct_set_acct(struct net *net, bool enable)
 {
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	net->ct.sysctl_acct = enable;
+#endif
 }
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 void nf_conntrack_acct_pernet_init(struct net *net);
 
 int nf_conntrack_acct_init(void);
 void nf_conntrack_acct_fini(void);
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_ACCT_H */
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index a49edfdf47e8..1990d54bf8f2 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -176,6 +176,7 @@ void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
 			       const char *fmt, ...) { }
 #endif /* CONFIG_SYSCTL */
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 static inline struct nf_generic_net *nf_generic_pernet(struct net *net)
 {
        return &net->ct.nf_ct_proto.generic;
@@ -200,6 +201,7 @@ static inline struct nf_icmp_net *nf_icmpv6_pernet(struct net *net)
 {
        return &net->ct.nf_ct_proto.icmpv6;
 }
+#endif
 
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 static inline struct nf_dccp_net *nf_dccp_pernet(struct net *net)
diff --git a/include/net/netfilter/nf_conntrack_timestamp.h b/include/net/netfilter/nf_conntrack_timestamp.h
index 0ed617bf0a3d..2b8aeba649aa 100644
--- a/include/net/netfilter/nf_conntrack_timestamp.h
+++ b/include/net/netfilter/nf_conntrack_timestamp.h
@@ -40,12 +40,18 @@ struct nf_conn_tstamp *nf_ct_tstamp_ext_add(struct nf_conn *ct, gfp_t gfp)
 
 static inline bool nf_ct_tstamp_enabled(struct net *net)
 {
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	return net->ct.sysctl_tstamp != 0;
+#else
+	return false;
+#endif
 }
 
 static inline void nf_ct_set_tstamp(struct net *net, bool enable)
 {
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	net->ct.sysctl_tstamp = enable;
+#endif
 }
 
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
-- 
2.11.0


