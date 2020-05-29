Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFEC1E85BC
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgE2Rur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:50:47 -0400
Received: from correo.us.es ([193.147.175.20]:58810 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgE2Rul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:50:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 92F2781402
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 19:50:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83E77DA781
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 19:50:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7305EDA72A; Fri, 29 May 2020 19:50:33 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 776D8DA712;
        Fri, 29 May 2020 19:50:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 19:50:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 45F7542EE38F;
        Fri, 29 May 2020 19:50:30 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 1/9] netfilter: ctnetlink: add kernel side filtering for dump
Date:   Fri, 29 May 2020 19:50:18 +0200
Message-Id: <20200529175026.30541-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529175026.30541-1-pablo@netfilter.org>
References: <20200529175026.30541-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Romain Bellan <romain.bellan@wifirst.fr>

Conntrack dump does not support kernel side filtering (only get exists,
but it returns only one entry. And user has to give a full valid tuple)

It means that userspace has to implement filtering after receiving many
irrelevant entries, consuming resources (conntrack table is sometimes
very huge, much more than a routing table for example).

This patch adds filtering in kernel side. To achieve this goal, we:

 * Add a new CTA_FILTER netlink attributes, actually a flag list to
   parametize filtering
 * Convert some *nlattr_to_tuple() functions, to allow a partial parsing
   of CTA_TUPLE_ORIG and CTA_TUPLE_REPLY (so nf_conntrack_tuple it not
   fully set)

Filtering is now possible on:
 * IP SRC/DST values
 * Ports for TCP and UDP flows
 * IMCP(v6) codes types and IDs

Filtering is done as an "AND" operator. For example, when flags
PROTO_SRC_PORT, PROTO_NUM and IP_SRC are sets, only entries matching all
values are dumped.

Changes since v1:
  Set NLM_F_DUMP_FILTERED in nlm flags if entries are filtered

Changes since v2:
  Move several constants to nf_internals.h
  Move a fix on netlink values check in a separate patch
  Add a check on not-supported flags
  Return EOPNOTSUPP if CDA_FILTER is set in ctnetlink_flush_conntrack
  (not yet implemented)
  Code style issues

Changes since v3:
  Fix compilation warning reported by kbuild test robot

Changes since v4:
  Fix a regression introduced in v3 (returned EINVAL for valid netlink
  messages without CTA_MARK)

Changes since v5:
  Change definition of CTA_FILTER_F_ALL
  Fix a regression when CTA_TUPLE_ZONE is not set

Signed-off-by: Romain Bellan <romain.bellan@wifirst.fr>
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h  |   6 +-
 .../linux/netfilter/nfnetlink_conntrack.h     |   9 +
 net/netfilter/nf_conntrack_core.c             |  19 +-
 net/netfilter/nf_conntrack_netlink.c          | 334 ++++++++++++++++--
 net/netfilter/nf_conntrack_proto_icmp.c       |  40 ++-
 net/netfilter/nf_conntrack_proto_icmpv6.c     |  42 ++-
 net/netfilter/nf_internals.h                  |  17 +
 7 files changed, 394 insertions(+), 73 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 4cad1f0a327a..88186b95b3c2 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -42,7 +42,8 @@ struct nf_conntrack_l4proto {
 	/* Calculate tuple nlattr size */
 	unsigned int (*nlattr_tuple_size)(void);
 	int (*nlattr_to_tuple)(struct nlattr *tb[],
-			       struct nf_conntrack_tuple *t);
+			       struct nf_conntrack_tuple *t,
+			       u_int32_t flags);
 	const struct nla_policy *nla_policy;
 
 	struct {
@@ -152,7 +153,8 @@ const struct nf_conntrack_l4proto *nf_ct_l4proto_find(u8 l4proto);
 int nf_ct_port_tuple_to_nlattr(struct sk_buff *skb,
 			       const struct nf_conntrack_tuple *tuple);
 int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
-			       struct nf_conntrack_tuple *t);
+			       struct nf_conntrack_tuple *t,
+			       u_int32_t flags);
 unsigned int nf_ct_port_nlattr_tuple_size(void);
 extern const struct nla_policy nf_ct_port_nla_policy[];
 
diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index 1d41810d17e2..262881792671 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -55,6 +55,7 @@ enum ctattr_type {
 	CTA_LABELS,
 	CTA_LABELS_MASK,
 	CTA_SYNPROXY,
+	CTA_FILTER,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
@@ -276,4 +277,12 @@ enum ctattr_expect_stats {
 };
 #define CTA_STATS_EXP_MAX (__CTA_STATS_EXP_MAX - 1)
 
+enum ctattr_filter {
+	CTA_FILTER_UNSPEC,
+	CTA_FILTER_ORIG_FLAGS,
+	CTA_FILTER_REPLY_FLAGS,
+	__CTA_FILTER_MAX
+};
+#define CTA_FILTER_MAX (__CTA_FILTER_MAX - 1)
+
 #endif /* _IPCONNTRACK_NETLINK_H */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1d57b95d3481..8abb1727bcc4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1974,13 +1974,22 @@ const struct nla_policy nf_ct_port_nla_policy[CTA_PROTO_MAX+1] = {
 EXPORT_SYMBOL_GPL(nf_ct_port_nla_policy);
 
 int nf_ct_port_nlattr_to_tuple(struct nlattr *tb[],
-			       struct nf_conntrack_tuple *t)
+			       struct nf_conntrack_tuple *t,
+			       u_int32_t flags)
 {
-	if (!tb[CTA_PROTO_SRC_PORT] || !tb[CTA_PROTO_DST_PORT])
-		return -EINVAL;
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_SRC_PORT)) {
+		if (!tb[CTA_PROTO_SRC_PORT])
+			return -EINVAL;
+
+		t->src.u.tcp.port = nla_get_be16(tb[CTA_PROTO_SRC_PORT]);
+	}
 
-	t->src.u.tcp.port = nla_get_be16(tb[CTA_PROTO_SRC_PORT]);
-	t->dst.u.tcp.port = nla_get_be16(tb[CTA_PROTO_DST_PORT]);
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_DST_PORT)) {
+		if (!tb[CTA_PROTO_DST_PORT])
+			return -EINVAL;
+
+		t->dst.u.tcp.port = nla_get_be16(tb[CTA_PROTO_DST_PORT]);
+	}
 
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9ddfcd002d3b..d7bd8b1f27d5 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -54,6 +54,8 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
+#include "nf_internals.h"
+
 MODULE_LICENSE("GPL");
 
 static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
@@ -544,14 +546,16 @@ static int ctnetlink_dump_info(struct sk_buff *skb, struct nf_conn *ct)
 
 static int
 ctnetlink_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
-		    struct nf_conn *ct, bool extinfo)
+		    struct nf_conn *ct, bool extinfo, unsigned int flags)
 {
 	const struct nf_conntrack_zone *zone;
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	struct nlattr *nest_parms;
-	unsigned int flags = portid ? NLM_F_MULTI : 0, event;
+	unsigned int event;
 
+	if (portid)
+		flags |= NLM_F_MULTI;
 	event = nfnl_msg_type(NFNL_SUBSYS_CTNETLINK, IPCTNL_MSG_CT_NEW);
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*nfmsg), flags);
 	if (nlh == NULL)
@@ -847,17 +851,70 @@ static int ctnetlink_done(struct netlink_callback *cb)
 }
 
 struct ctnetlink_filter {
+	u_int32_t cta_flags;
 	u8 family;
+
+	u_int32_t orig_flags;
+	u_int32_t reply_flags;
+
+	struct nf_conntrack_tuple orig;
+	struct nf_conntrack_tuple reply;
+	struct nf_conntrack_zone zone;
+
 	struct {
 		u_int32_t val;
 		u_int32_t mask;
 	} mark;
 };
 
+static const struct nla_policy cta_filter_nla_policy[CTA_FILTER_MAX + 1] = {
+	[CTA_FILTER_ORIG_FLAGS]		= { .type = NLA_U32 },
+	[CTA_FILTER_REPLY_FLAGS]	= { .type = NLA_U32 },
+};
+
+static int ctnetlink_parse_filter(const struct nlattr *attr,
+				  struct ctnetlink_filter *filter)
+{
+	struct nlattr *tb[CTA_FILTER_MAX + 1];
+	int ret = 0;
+
+	ret = nla_parse_nested(tb, CTA_FILTER_MAX, attr, cta_filter_nla_policy,
+			       NULL);
+	if (ret)
+		return ret;
+
+	if (tb[CTA_FILTER_ORIG_FLAGS]) {
+		filter->orig_flags = nla_get_u32(tb[CTA_FILTER_ORIG_FLAGS]);
+		if (filter->orig_flags & ~CTA_FILTER_F_ALL)
+			return -EOPNOTSUPP;
+	}
+
+	if (tb[CTA_FILTER_REPLY_FLAGS]) {
+		filter->reply_flags = nla_get_u32(tb[CTA_FILTER_REPLY_FLAGS]);
+		if (filter->reply_flags & ~CTA_FILTER_F_ALL)
+			return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int ctnetlink_parse_zone(const struct nlattr *attr,
+				struct nf_conntrack_zone *zone);
+static int ctnetlink_parse_tuple_filter(const struct nlattr * const cda[],
+					 struct nf_conntrack_tuple *tuple,
+					 u32 type, u_int8_t l3num,
+					 struct nf_conntrack_zone *zone,
+					 u_int32_t flags);
+
+/* applied on filters */
+#define CTA_FILTER_F_CTA_MARK			(1 << 0)
+#define CTA_FILTER_F_CTA_MARK_MASK		(1 << 1)
+
 static struct ctnetlink_filter *
 ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 {
 	struct ctnetlink_filter *filter;
+	int err;
 
 #ifndef CONFIG_NF_CONNTRACK_MARK
 	if (cda[CTA_MARK] || cda[CTA_MARK_MASK])
@@ -871,14 +928,65 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 	filter->family = family;
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (cda[CTA_MARK] && cda[CTA_MARK_MASK]) {
+	if (cda[CTA_MARK]) {
 		filter->mark.val = ntohl(nla_get_be32(cda[CTA_MARK]));
-		filter->mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
+		filter->cta_flags |= CTA_FILTER_FLAG(CTA_MARK);
+
+		if (cda[CTA_MARK_MASK]) {
+			filter->mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
+			filter->cta_flags |= CTA_FILTER_FLAG(CTA_MARK_MASK);
+		} else {
+			filter->mark.mask = 0xffffffff;
+		}
+	} else if (cda[CTA_MARK_MASK]) {
+		return ERR_PTR(-EINVAL);
 	}
 #endif
+	if (!cda[CTA_FILTER])
+		return filter;
+
+	err = ctnetlink_parse_zone(cda[CTA_ZONE], &filter->zone);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	err = ctnetlink_parse_filter(cda[CTA_FILTER], filter);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	if (filter->orig_flags) {
+		if (!cda[CTA_TUPLE_ORIG])
+			return ERR_PTR(-EINVAL);
+
+		err = ctnetlink_parse_tuple_filter(cda, &filter->orig,
+						   CTA_TUPLE_ORIG,
+						   filter->family,
+						   &filter->zone,
+						   filter->orig_flags);
+		if (err < 0)
+			return ERR_PTR(err);
+	}
+
+	if (filter->reply_flags) {
+		if (!cda[CTA_TUPLE_REPLY])
+			return ERR_PTR(-EINVAL);
+
+		err = ctnetlink_parse_tuple_filter(cda, &filter->reply,
+						   CTA_TUPLE_REPLY,
+						   filter->family,
+						   &filter->zone,
+						   filter->orig_flags);
+		if (err < 0)
+			return ERR_PTR(err);
+	}
+
 	return filter;
 }
 
+static bool ctnetlink_needs_filter(u8 family, const struct nlattr * const *cda)
+{
+	return family || cda[CTA_MARK] || cda[CTA_FILTER];
+}
+
 static int ctnetlink_start(struct netlink_callback *cb)
 {
 	const struct nlattr * const *cda = cb->data;
@@ -886,7 +994,7 @@ static int ctnetlink_start(struct netlink_callback *cb)
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	u8 family = nfmsg->nfgen_family;
 
-	if (family || (cda[CTA_MARK] && cda[CTA_MARK_MASK])) {
+	if (ctnetlink_needs_filter(family, cda)) {
 		filter = ctnetlink_alloc_filter(cda, family);
 		if (IS_ERR(filter))
 			return PTR_ERR(filter);
@@ -896,9 +1004,79 @@ static int ctnetlink_start(struct netlink_callback *cb)
 	return 0;
 }
 
+static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
+					struct nf_conntrack_tuple *ct_tuple,
+					u_int32_t flags, int family)
+{
+	switch (family) {
+	case NFPROTO_IPV4:
+		if ((flags & CTA_FILTER_FLAG(CTA_IP_SRC)) &&
+		    filter_tuple->src.u3.ip != ct_tuple->src.u3.ip)
+			return  0;
+
+		if ((flags & CTA_FILTER_FLAG(CTA_IP_DST)) &&
+		    filter_tuple->dst.u3.ip != ct_tuple->dst.u3.ip)
+			return  0;
+		break;
+	case NFPROTO_IPV6:
+		if ((flags & CTA_FILTER_FLAG(CTA_IP_SRC)) &&
+		    !ipv6_addr_cmp(&filter_tuple->src.u3.in6,
+				   &ct_tuple->src.u3.in6))
+			return 0;
+
+		if ((flags & CTA_FILTER_FLAG(CTA_IP_DST)) &&
+		    !ipv6_addr_cmp(&filter_tuple->dst.u3.in6,
+				   &ct_tuple->dst.u3.in6))
+			return 0;
+		break;
+	}
+
+	if ((flags & CTA_FILTER_FLAG(CTA_PROTO_NUM)) &&
+	    filter_tuple->dst.protonum != ct_tuple->dst.protonum)
+		return 0;
+
+	switch (ct_tuple->dst.protonum) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+		if ((flags & CTA_FILTER_FLAG(CTA_PROTO_SRC_PORT)) &&
+		    filter_tuple->src.u.tcp.port != ct_tuple->src.u.tcp.port)
+			return 0;
+
+		if ((flags & CTA_FILTER_FLAG(CTA_PROTO_DST_PORT)) &&
+		    filter_tuple->dst.u.tcp.port != ct_tuple->dst.u.tcp.port)
+			return 0;
+		break;
+	case IPPROTO_ICMP:
+		if ((flags & CTA_FILTER_FLAG(CTA_PROTO_ICMP_TYPE)) &&
+		    filter_tuple->dst.u.icmp.type != ct_tuple->dst.u.icmp.type)
+			return 0;
+		if ((flags & CTA_FILTER_FLAG(CTA_PROTO_ICMP_CODE)) &&
+		    filter_tuple->dst.u.icmp.code != ct_tuple->dst.u.icmp.code)
+			return 0;
+		if ((flags & CTA_FILTER_FLAG(CTA_PROTO_ICMP_ID)) &&
+		    filter_tuple->src.u.icmp.id != ct_tuple->src.u.icmp.id)
+			return 0;
+		break;
+	case IPPROTO_ICMPV6:
+		if ((flags & CTA_FILTER_FLAG(CTA_PROTO_ICMPV6_TYPE)) &&
+		    filter_tuple->dst.u.icmp.type != ct_tuple->dst.u.icmp.type)
+			return 0;
+		if ((flags & CTA_FILTER_FLAG(CTA_PROTO_ICMPV6_CODE)) &&
+		    filter_tuple->dst.u.icmp.code != ct_tuple->dst.u.icmp.code)
+			return 0;
+		if ((flags & CTA_FILTER_FLAG(CTA_PROTO_ICMPV6_ID)) &&
+		    filter_tuple->src.u.icmp.id != ct_tuple->src.u.icmp.id)
+			return 0;
+		break;
+	}
+
+	return 1;
+}
+
 static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 {
 	struct ctnetlink_filter *filter = data;
+	struct nf_conntrack_tuple *tuple;
 
 	if (filter == NULL)
 		goto out;
@@ -910,8 +1088,28 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 	if (filter->family && nf_ct_l3num(ct) != filter->family)
 		goto ignore_entry;
 
+	if (filter->orig_flags) {
+		tuple = nf_ct_tuple(ct, IP_CT_DIR_ORIGINAL);
+		if (!ctnetlink_filter_match_tuple(&filter->orig, tuple,
+						  filter->orig_flags,
+						  filter->family))
+			goto ignore_entry;
+	}
+
+	if (filter->reply_flags) {
+		tuple = nf_ct_tuple(ct, IP_CT_DIR_REPLY);
+		if (!ctnetlink_filter_match_tuple(&filter->reply, tuple,
+						  filter->reply_flags,
+						  filter->family))
+			goto ignore_entry;
+	}
+
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if ((ct->mark & filter->mark.mask) != filter->mark.val)
+	if ((filter->cta_flags & CTA_FILTER_FLAG(CTA_MARK_MASK)) &&
+	    (ct->mark & filter->mark.mask) != filter->mark.val)
+		goto ignore_entry;
+	else if ((filter->cta_flags & CTA_FILTER_FLAG(CTA_MARK)) &&
+		 ct->mark != filter->mark.val)
 		goto ignore_entry;
 #endif
 
@@ -925,6 +1123,7 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	unsigned int flags = cb->data ? NLM_F_DUMP_FILTERED : 0;
 	struct net *net = sock_net(skb->sk);
 	struct nf_conn *ct, *last;
 	struct nf_conntrack_tuple_hash *h;
@@ -979,7 +1178,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
 					    cb->nlh->nlmsg_seq,
 					    NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-					    ct, true);
+					    ct, true, flags);
 			if (res < 0) {
 				nf_conntrack_get(&ct->ct_general);
 				cb->args[1] = (unsigned long)ct;
@@ -1014,31 +1213,50 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 }
 
 static int ipv4_nlattr_to_tuple(struct nlattr *tb[],
-				struct nf_conntrack_tuple *t)
+				struct nf_conntrack_tuple *t,
+				u_int32_t flags)
 {
-	if (!tb[CTA_IP_V4_SRC] || !tb[CTA_IP_V4_DST])
-		return -EINVAL;
+	if (flags & CTA_FILTER_FLAG(CTA_IP_SRC)) {
+		if (!tb[CTA_IP_V4_SRC])
+			return -EINVAL;
+
+		t->src.u3.ip = nla_get_in_addr(tb[CTA_IP_V4_SRC]);
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_IP_DST)) {
+		if (!tb[CTA_IP_V4_DST])
+			return -EINVAL;
 
-	t->src.u3.ip = nla_get_in_addr(tb[CTA_IP_V4_SRC]);
-	t->dst.u3.ip = nla_get_in_addr(tb[CTA_IP_V4_DST]);
+		t->dst.u3.ip = nla_get_in_addr(tb[CTA_IP_V4_DST]);
+	}
 
 	return 0;
 }
 
 static int ipv6_nlattr_to_tuple(struct nlattr *tb[],
-				struct nf_conntrack_tuple *t)
+				struct nf_conntrack_tuple *t,
+				u_int32_t flags)
 {
-	if (!tb[CTA_IP_V6_SRC] || !tb[CTA_IP_V6_DST])
-		return -EINVAL;
+	if (flags & CTA_FILTER_FLAG(CTA_IP_SRC)) {
+		if (!tb[CTA_IP_V6_SRC])
+			return -EINVAL;
 
-	t->src.u3.in6 = nla_get_in6_addr(tb[CTA_IP_V6_SRC]);
-	t->dst.u3.in6 = nla_get_in6_addr(tb[CTA_IP_V6_DST]);
+		t->src.u3.in6 = nla_get_in6_addr(tb[CTA_IP_V6_SRC]);
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_IP_DST)) {
+		if (!tb[CTA_IP_V6_DST])
+			return -EINVAL;
+
+		t->dst.u3.in6 = nla_get_in6_addr(tb[CTA_IP_V6_DST]);
+	}
 
 	return 0;
 }
 
 static int ctnetlink_parse_tuple_ip(struct nlattr *attr,
-				    struct nf_conntrack_tuple *tuple)
+				    struct nf_conntrack_tuple *tuple,
+				    u_int32_t flags)
 {
 	struct nlattr *tb[CTA_IP_MAX+1];
 	int ret = 0;
@@ -1054,10 +1272,10 @@ static int ctnetlink_parse_tuple_ip(struct nlattr *attr,
 
 	switch (tuple->src.l3num) {
 	case NFPROTO_IPV4:
-		ret = ipv4_nlattr_to_tuple(tb, tuple);
+		ret = ipv4_nlattr_to_tuple(tb, tuple, flags);
 		break;
 	case NFPROTO_IPV6:
-		ret = ipv6_nlattr_to_tuple(tb, tuple);
+		ret = ipv6_nlattr_to_tuple(tb, tuple, flags);
 		break;
 	}
 
@@ -1069,7 +1287,8 @@ static const struct nla_policy proto_nla_policy[CTA_PROTO_MAX+1] = {
 };
 
 static int ctnetlink_parse_tuple_proto(struct nlattr *attr,
-				       struct nf_conntrack_tuple *tuple)
+				       struct nf_conntrack_tuple *tuple,
+				       u_int32_t flags)
 {
 	const struct nf_conntrack_l4proto *l4proto;
 	struct nlattr *tb[CTA_PROTO_MAX+1];
@@ -1080,8 +1299,12 @@ static int ctnetlink_parse_tuple_proto(struct nlattr *attr,
 	if (ret < 0)
 		return ret;
 
+	if (!(flags & CTA_FILTER_FLAG(CTA_PROTO_NUM)))
+		return 0;
+
 	if (!tb[CTA_PROTO_NUM])
 		return -EINVAL;
+
 	tuple->dst.protonum = nla_get_u8(tb[CTA_PROTO_NUM]);
 
 	rcu_read_lock();
@@ -1092,7 +1315,7 @@ static int ctnetlink_parse_tuple_proto(struct nlattr *attr,
 						     l4proto->nla_policy,
 						     NULL);
 		if (ret == 0)
-			ret = l4proto->nlattr_to_tuple(tb, tuple);
+			ret = l4proto->nlattr_to_tuple(tb, tuple, flags);
 	}
 
 	rcu_read_unlock();
@@ -1143,10 +1366,21 @@ static const struct nla_policy tuple_nla_policy[CTA_TUPLE_MAX+1] = {
 	[CTA_TUPLE_ZONE]	= { .type = NLA_U16 },
 };
 
+#define CTA_FILTER_F_ALL_CTA_PROTO \
+  (CTA_FILTER_F_CTA_PROTO_SRC_PORT | \
+   CTA_FILTER_F_CTA_PROTO_DST_PORT | \
+   CTA_FILTER_F_CTA_PROTO_ICMP_TYPE | \
+   CTA_FILTER_F_CTA_PROTO_ICMP_CODE | \
+   CTA_FILTER_F_CTA_PROTO_ICMP_ID | \
+   CTA_FILTER_F_CTA_PROTO_ICMPV6_TYPE | \
+   CTA_FILTER_F_CTA_PROTO_ICMPV6_CODE | \
+   CTA_FILTER_F_CTA_PROTO_ICMPV6_ID)
+
 static int
-ctnetlink_parse_tuple(const struct nlattr * const cda[],
-		      struct nf_conntrack_tuple *tuple, u32 type,
-		      u_int8_t l3num, struct nf_conntrack_zone *zone)
+ctnetlink_parse_tuple_filter(const struct nlattr * const cda[],
+			      struct nf_conntrack_tuple *tuple, u32 type,
+			      u_int8_t l3num, struct nf_conntrack_zone *zone,
+			      u_int32_t flags)
 {
 	struct nlattr *tb[CTA_TUPLE_MAX+1];
 	int err;
@@ -1158,23 +1392,32 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
 	if (err < 0)
 		return err;
 
-	if (!tb[CTA_TUPLE_IP])
-		return -EINVAL;
 
 	tuple->src.l3num = l3num;
 
-	err = ctnetlink_parse_tuple_ip(tb[CTA_TUPLE_IP], tuple);
-	if (err < 0)
-		return err;
+	if (flags & CTA_FILTER_FLAG(CTA_IP_DST) ||
+	    flags & CTA_FILTER_FLAG(CTA_IP_SRC)) {
+		if (!tb[CTA_TUPLE_IP])
+			return -EINVAL;
 
-	if (!tb[CTA_TUPLE_PROTO])
-		return -EINVAL;
+		err = ctnetlink_parse_tuple_ip(tb[CTA_TUPLE_IP], tuple, flags);
+		if (err < 0)
+			return err;
+	}
 
-	err = ctnetlink_parse_tuple_proto(tb[CTA_TUPLE_PROTO], tuple);
-	if (err < 0)
-		return err;
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_NUM)) {
+		if (!tb[CTA_TUPLE_PROTO])
+			return -EINVAL;
 
-	if (tb[CTA_TUPLE_ZONE]) {
+		err = ctnetlink_parse_tuple_proto(tb[CTA_TUPLE_PROTO], tuple, flags);
+		if (err < 0)
+			return err;
+	} else if (flags & CTA_FILTER_FLAG(ALL_CTA_PROTO)) {
+		/* Can't manage proto flags without a protonum  */
+		return -EINVAL;
+	}
+
+	if ((flags & CTA_FILTER_FLAG(CTA_TUPLE_ZONE)) && tb[CTA_TUPLE_ZONE]) {
 		if (!zone)
 			return -EINVAL;
 
@@ -1193,6 +1436,15 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
 	return 0;
 }
 
+static int
+ctnetlink_parse_tuple(const struct nlattr * const cda[],
+		      struct nf_conntrack_tuple *tuple, u32 type,
+		      u_int8_t l3num, struct nf_conntrack_zone *zone)
+{
+	return ctnetlink_parse_tuple_filter(cda, tuple, type, l3num, zone,
+					    CTA_FILTER_FLAG(ALL));
+}
+
 static const struct nla_policy help_nla_policy[CTA_HELP_MAX+1] = {
 	[CTA_HELP_NAME]		= { .type = NLA_NUL_STRING,
 				    .len = NF_CT_HELPER_NAME_LEN - 1 },
@@ -1240,6 +1492,7 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 				    .len = NF_CT_LABELS_MAX_SIZE },
 	[CTA_LABELS_MASK]	= { .type = NLA_BINARY,
 				    .len = NF_CT_LABELS_MAX_SIZE },
+	[CTA_FILTER]		= { .type = NLA_NESTED },
 };
 
 static int ctnetlink_flush_iterate(struct nf_conn *ct, void *data)
@@ -1256,7 +1509,10 @@ static int ctnetlink_flush_conntrack(struct net *net,
 {
 	struct ctnetlink_filter *filter = NULL;
 
-	if (family || (cda[CTA_MARK] && cda[CTA_MARK_MASK])) {
+	if (ctnetlink_needs_filter(family, cda)) {
+		if (cda[CTA_FILTER])
+			return -EOPNOTSUPP;
+
 		filter = ctnetlink_alloc_filter(cda, family);
 		if (IS_ERR(filter))
 			return PTR_ERR(filter);
@@ -1385,7 +1641,7 @@ static int ctnetlink_get_conntrack(struct net *net, struct sock *ctnl,
 	}
 
 	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
-				  NFNL_MSG_TYPE(nlh->nlmsg_type), ct, true);
+				  NFNL_MSG_TYPE(nlh->nlmsg_type), ct, true, 0);
 	nf_ct_put(ct);
 	if (err <= 0)
 		goto free;
@@ -1458,7 +1714,7 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 			res = ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).portid,
 						  cb->nlh->nlmsg_seq,
 						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
-						  ct, dying ? true : false);
+						  ct, dying ? true : false, 0);
 			if (res < 0) {
 				if (!atomic_inc_not_zero(&ct->ct_general.use))
 					continue;
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index c2e3dff773bc..4efd8741c105 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -20,6 +20,8 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_log.h>
 
+#include "nf_internals.h"
+
 static const unsigned int nf_ct_icmp_timeout = 30*HZ;
 
 bool icmp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
@@ -271,20 +273,32 @@ static const struct nla_policy icmp_nla_policy[CTA_PROTO_MAX+1] = {
 };
 
 static int icmp_nlattr_to_tuple(struct nlattr *tb[],
-				struct nf_conntrack_tuple *tuple)
+				struct nf_conntrack_tuple *tuple,
+				u_int32_t flags)
 {
-	if (!tb[CTA_PROTO_ICMP_TYPE] ||
-	    !tb[CTA_PROTO_ICMP_CODE] ||
-	    !tb[CTA_PROTO_ICMP_ID])
-		return -EINVAL;
-
-	tuple->dst.u.icmp.type = nla_get_u8(tb[CTA_PROTO_ICMP_TYPE]);
-	tuple->dst.u.icmp.code = nla_get_u8(tb[CTA_PROTO_ICMP_CODE]);
-	tuple->src.u.icmp.id = nla_get_be16(tb[CTA_PROTO_ICMP_ID]);
-
-	if (tuple->dst.u.icmp.type >= sizeof(invmap) ||
-	    !invmap[tuple->dst.u.icmp.type])
-		return -EINVAL;
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMP_TYPE)) {
+		if (!tb[CTA_PROTO_ICMP_TYPE])
+			return -EINVAL;
+
+		tuple->dst.u.icmp.type = nla_get_u8(tb[CTA_PROTO_ICMP_TYPE]);
+		if (tuple->dst.u.icmp.type >= sizeof(invmap) ||
+		    !invmap[tuple->dst.u.icmp.type])
+			return -EINVAL;
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMP_CODE)) {
+		if (!tb[CTA_PROTO_ICMP_CODE])
+			return -EINVAL;
+
+		tuple->dst.u.icmp.code = nla_get_u8(tb[CTA_PROTO_ICMP_CODE]);
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMP_ID)) {
+		if (!tb[CTA_PROTO_ICMP_ID])
+			return -EINVAL;
+
+		tuple->src.u.icmp.id = nla_get_be16(tb[CTA_PROTO_ICMP_ID]);
+	}
 
 	return 0;
 }
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index 6f9144e1f1c1..facd8c64ec4e 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -24,6 +24,8 @@
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_log.h>
 
+#include "nf_internals.h"
+
 static const unsigned int nf_ct_icmpv6_timeout = 30*HZ;
 
 bool icmpv6_pkt_to_tuple(const struct sk_buff *skb,
@@ -193,21 +195,33 @@ static const struct nla_policy icmpv6_nla_policy[CTA_PROTO_MAX+1] = {
 };
 
 static int icmpv6_nlattr_to_tuple(struct nlattr *tb[],
-				struct nf_conntrack_tuple *tuple)
+				struct nf_conntrack_tuple *tuple,
+				u_int32_t flags)
 {
-	if (!tb[CTA_PROTO_ICMPV6_TYPE] ||
-	    !tb[CTA_PROTO_ICMPV6_CODE] ||
-	    !tb[CTA_PROTO_ICMPV6_ID])
-		return -EINVAL;
-
-	tuple->dst.u.icmp.type = nla_get_u8(tb[CTA_PROTO_ICMPV6_TYPE]);
-	tuple->dst.u.icmp.code = nla_get_u8(tb[CTA_PROTO_ICMPV6_CODE]);
-	tuple->src.u.icmp.id = nla_get_be16(tb[CTA_PROTO_ICMPV6_ID]);
-
-	if (tuple->dst.u.icmp.type < 128 ||
-	    tuple->dst.u.icmp.type - 128 >= sizeof(invmap) ||
-	    !invmap[tuple->dst.u.icmp.type - 128])
-		return -EINVAL;
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMPV6_TYPE)) {
+		if (!tb[CTA_PROTO_ICMPV6_TYPE])
+			return -EINVAL;
+
+		tuple->dst.u.icmp.type = nla_get_u8(tb[CTA_PROTO_ICMPV6_TYPE]);
+		if (tuple->dst.u.icmp.type < 128 ||
+		    tuple->dst.u.icmp.type - 128 >= sizeof(invmap) ||
+		    !invmap[tuple->dst.u.icmp.type - 128])
+			return -EINVAL;
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMPV6_CODE)) {
+		if (!tb[CTA_PROTO_ICMPV6_CODE])
+			return -EINVAL;
+
+		tuple->dst.u.icmp.code = nla_get_u8(tb[CTA_PROTO_ICMPV6_CODE]);
+	}
+
+	if (flags & CTA_FILTER_FLAG(CTA_PROTO_ICMPV6_ID)) {
+		if (!tb[CTA_PROTO_ICMPV6_ID])
+			return -EINVAL;
+
+		tuple->src.u.icmp.id = nla_get_be16(tb[CTA_PROTO_ICMPV6_ID]);
+	}
 
 	return 0;
 }
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index d6c43902ebd7..832ae64179f0 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -6,6 +6,23 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 
+/* nf_conntrack_netlink.c: applied on tuple filters */
+#define CTA_FILTER_F_CTA_IP_SRC			(1 << 0)
+#define CTA_FILTER_F_CTA_IP_DST			(1 << 1)
+#define CTA_FILTER_F_CTA_TUPLE_ZONE		(1 << 2)
+#define CTA_FILTER_F_CTA_PROTO_NUM		(1 << 3)
+#define CTA_FILTER_F_CTA_PROTO_SRC_PORT		(1 << 4)
+#define CTA_FILTER_F_CTA_PROTO_DST_PORT		(1 << 5)
+#define CTA_FILTER_F_CTA_PROTO_ICMP_TYPE	(1 << 6)
+#define CTA_FILTER_F_CTA_PROTO_ICMP_CODE	(1 << 7)
+#define CTA_FILTER_F_CTA_PROTO_ICMP_ID		(1 << 8)
+#define CTA_FILTER_F_CTA_PROTO_ICMPV6_TYPE	(1 << 9)
+#define CTA_FILTER_F_CTA_PROTO_ICMPV6_CODE	(1 << 10)
+#define CTA_FILTER_F_CTA_PROTO_ICMPV6_ID	(1 << 11)
+#define CTA_FILTER_F_MAX			(1 << 12)
+#define CTA_FILTER_F_ALL			(CTA_FILTER_F_MAX-1)
+#define CTA_FILTER_FLAG(ctattr) CTA_FILTER_F_ ## ctattr
+
 /* nf_queue.c */
 void nf_queue_nf_hook_drop(struct net *net);
 
-- 
2.20.1

