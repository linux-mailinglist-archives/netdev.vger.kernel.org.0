Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E550084E73
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388197AbfHGORS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:17:18 -0400
Received: from kadath.azazel.net ([81.187.231.250]:46002 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730020AbfHGORK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AdJQKlP/EwvVJrrS3gzmO5O7r7qABzf3dmPAVrLTUaE=; b=lHAXqXvfcO0EDSuFf+JBCQmfWh
        PWbPA6yl33SkT1QwpPbg6ht/hY4RWZAZ7ks9FhH6rkymbAuLDfunpoGu6C4CPu2MVu13TJUle01G2
        iJStAIt2s2HXwGwCX5LUOF+GgV5kYQBZ2Lb/hQh+pPXtriZNWPL8kCr/RddlxnKGSIogYtLCzqfMh
        GDQ5KlpCH29RCl1ZKzuIlQ0GzU6czpzIcQ3+t7nfZcaGF7F7RupP4pkgYyKdGvBoE4Z/pfKr746KZ
        XAFYuwwrUAThnmPmNpXWzoTETnMRC10Qu9CkyAziSZHTKEyUmjtakdlEglXCwWQuSbfBSPncpNOoM
        FyG4awHw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hvMkU-0001Wc-Sw; Wed, 07 Aug 2019 15:17:06 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH net-next v1 5/8] netfilter: added missing IS_ENABLED(CONFIG_NF_CONNTRACK) checks to some header-files.
Date:   Wed,  7 Aug 2019 15:17:02 +0100
Message-Id: <20190807141705.4864-6-jeremy@azazel.net>
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

struct nf_conn contains a "struct nf_conntrack ct_general" member and
struct net contains a "struct netns_ct ct" member which are both only
defined in CONFIG_NF_CONNTRACK is enabled.  These members are used in a
number of inline functions defined in other header-files.  Added
preprocessor checks to make sure the headers will compile if
CONFIG_NF_CONNTRACK is disabled.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
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
2.20.1

