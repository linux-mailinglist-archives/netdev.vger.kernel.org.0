Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDF4733D7A
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 05:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfFDDT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 23:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726216AbfFDDT6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 23:19:58 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DE6A25E73;
        Tue,  4 Jun 2019 03:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559618397;
        bh=1sJ0rFmDkSUKs5NTf/mp6FuK8IJQ9VqjNnCAdOjsC7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6xNhptlnfUw11YAyCMeF4VS8T0eFnEZNIgDD8+48PKZoB6wJ+2F2kQHZrx/pZDRA
         qV6WDv6waDjIyV7EiXYik7Uc0zjSomWxlIZLLXhvjgiT5P6kKbjrkrd+45NhiHxdqr
         EO6h2eEbg9w8hwLsmFJ3pX67y8sjgncayo9W+k/c=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, saeedm@mellanox.com, kafai@fb.com,
        weiwan@google.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3 net-next 2/7] ipv4: Prepare for fib6_nh from a nexthop object
Date:   Mon,  3 Jun 2019 20:19:50 -0700
Message-Id: <20190604031955.26949-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190604031955.26949-1-dsahern@kernel.org>
References: <20190604031955.26949-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Convert more IPv4 code to use fib_nh_common over fib_nh to enable routes
to use a fib6_nh based nexthop. In the end, only code not using a
nexthop object in a fib_info should directly access fib_nh in a fib_info
without checking the famiy and going through fib_nh_common. Those
functions will be marked when it is not directly evident.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip_fib.h     | 15 +++++++++----
 net/ipv4/fib_frontend.c  | 12 +++++------
 net/ipv4/fib_rules.c     |  4 ++--
 net/ipv4/fib_semantics.c | 55 +++++++++++++++++++++++++++++++++---------------
 net/ipv4/fib_trie.c      | 15 +++++++------
 net/ipv4/nexthop.c       |  3 ++-
 net/ipv4/route.c         |  2 +-
 7 files changed, 69 insertions(+), 37 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 42b1a806f6f5..7da8ea784029 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -195,8 +195,8 @@ struct fib_result_nl {
 #define FIB_TABLE_HASHSZ 2
 #endif
 
-__be32 fib_info_update_nh_saddr(struct net *net, struct fib_nh *nh,
-				unsigned char scope);
+__be32 fib_info_update_nhc_saddr(struct net *net, struct fib_nh_common *nhc,
+				 unsigned char scope);
 __be32 fib_result_prefsrc(struct net *net, struct fib_result *res);
 
 #define FIB_RES_NHC(res)		((res).nhc)
@@ -455,11 +455,18 @@ static inline void fib_combine_itag(u32 *itag, const struct fib_result *res)
 {
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	struct fib_nh_common *nhc = res->nhc;
-	struct fib_nh *nh = container_of(nhc, struct fib_nh, nh_common);
 #ifdef CONFIG_IP_MULTIPLE_TABLES
 	u32 rtag;
 #endif
-	*itag = nh->nh_tclassid << 16;
+	if (nhc->nhc_family == AF_INET) {
+		struct fib_nh *nh;
+
+		nh = container_of(nhc, struct fib_nh, nh_common);
+		*itag = nh->nh_tclassid << 16;
+	} else {
+		*itag = 0;
+	}
+
 #ifdef CONFIG_IP_MULTIPLE_TABLES
 	rtag = res->tclassid;
 	if (*itag == 0)
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index a4691360b395..5ea2750982f2 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -235,9 +235,9 @@ static inline unsigned int __inet_dev_addr_type(struct net *net,
 	if (table) {
 		ret = RTN_UNICAST;
 		if (!fib_table_lookup(table, &fl4, &res, FIB_LOOKUP_NOREF)) {
-			struct fib_nh *nh = fib_info_nh(res.fi, 0);
+			struct fib_nh_common *nhc = fib_info_nhc(res.fi, 0);
 
-			if (!dev || dev == nh->fib_nh_dev)
+			if (!dev || dev == nhc->nhc_dev)
 				ret = res.type;
 		}
 	}
@@ -325,18 +325,18 @@ bool fib_info_nh_uses_dev(struct fib_info *fi, const struct net_device *dev)
 	int ret;
 
 	for (ret = 0; ret < fib_info_num_path(fi); ret++) {
-		const struct fib_nh *nh = fib_info_nh(fi, ret);
+		const struct fib_nh_common *nhc = fib_info_nhc(fi, ret);
 
-		if (nh->fib_nh_dev == dev) {
+		if (nhc->nhc_dev == dev) {
 			dev_match = true;
 			break;
-		} else if (l3mdev_master_ifindex_rcu(nh->fib_nh_dev) == dev->ifindex) {
+		} else if (l3mdev_master_ifindex_rcu(nhc->nhc_dev) == dev->ifindex) {
 			dev_match = true;
 			break;
 		}
 	}
 #else
-	if (fib_info_nh(fi, 0)->fib_nh_dev == dev)
+	if (fib_info_nhc(fi, 0)->nhc_dev == dev)
 		dev_match = true;
 #endif
 
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index ab06fd73b343..88807c138df4 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -147,9 +147,9 @@ static bool fib4_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg
 	struct net_device *dev = NULL;
 
 	if (result->fi) {
-		struct fib_nh *nh = fib_info_nh(result->fi, 0);
+		struct fib_nh_common *nhc = fib_info_nhc(result->fi, 0);
 
-		dev = nh->fib_nh_dev;
+		dev = nhc->nhc_dev;
 	}
 
 	/* do not accept result if the route does
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index a37ff07718a8..4a12c69f7fa1 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -61,6 +61,9 @@ static unsigned int fib_info_cnt;
 #define DEVINDEX_HASHSIZE (1U << DEVINDEX_HASHBITS)
 static struct hlist_head fib_info_devhash[DEVINDEX_HASHSIZE];
 
+/* for_nexthops and change_nexthops only used when nexthop object
+ * is not set in a fib_info. The logic within can reference fib_nh.
+ */
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 
 #define for_nexthops(fi) {						\
@@ -402,20 +405,23 @@ static inline size_t fib_nlmsg_size(struct fib_info *fi)
 
 		/* each nexthop is packed in an attribute */
 		size_t nhsize = nla_total_size(sizeof(struct rtnexthop));
+		unsigned int i;
 
 		/* may contain flow and gateway attribute */
 		nhsize += 2 * nla_total_size(4);
 
 		/* grab encap info */
-		for_nexthops(fi) {
-			if (nh->fib_nh_lws) {
+		for (i = 0; i < fib_info_num_path(fi); i++) {
+			struct fib_nh_common *nhc = fib_info_nhc(fi, i);
+
+			if (nhc->nhc_lwtstate) {
 				/* RTA_ENCAP_TYPE */
 				nh_encapsize += lwtunnel_get_encap_size(
-						nh->fib_nh_lws);
+						nhc->nhc_lwtstate);
 				/* RTA_ENCAP */
 				nh_encapsize +=  nla_total_size(2);
 			}
-		} endfor_nexthops(fi);
+		}
 
 		/* all nexthops are packed in a nested attribute */
 		payload += nla_total_size((nhs * nhsize) + nh_encapsize);
@@ -1194,9 +1200,15 @@ static void fib_info_hash_move(struct hlist_head *new_info_hash,
 	fib_info_hash_free(old_laddrhash, bytes);
 }
 
-__be32 fib_info_update_nh_saddr(struct net *net, struct fib_nh *nh,
-				unsigned char scope)
+__be32 fib_info_update_nhc_saddr(struct net *net, struct fib_nh_common *nhc,
+				 unsigned char scope)
 {
+	struct fib_nh *nh;
+
+	if (nhc->nhc_family != AF_INET)
+		return inet_select_addr(nhc->nhc_dev, 0, scope);
+
+	nh = container_of(nhc, struct fib_nh, nh_common);
 	nh->nh_saddr = inet_select_addr(nh->fib_nh_dev, nh->fib_nh_gw4, scope);
 	nh->nh_saddr_genid = atomic_read(&net->ipv4.dev_addr_genid);
 
@@ -1206,16 +1218,19 @@ __be32 fib_info_update_nh_saddr(struct net *net, struct fib_nh *nh,
 __be32 fib_result_prefsrc(struct net *net, struct fib_result *res)
 {
 	struct fib_nh_common *nhc = res->nhc;
-	struct fib_nh *nh;
 
 	if (res->fi->fib_prefsrc)
 		return res->fi->fib_prefsrc;
 
-	nh = container_of(nhc, struct fib_nh, nh_common);
-	if (nh->nh_saddr_genid == atomic_read(&net->ipv4.dev_addr_genid))
-		return nh->nh_saddr;
+	if (nhc->nhc_family == AF_INET) {
+		struct fib_nh *nh;
+
+		nh = container_of(nhc, struct fib_nh, nh_common);
+		if (nh->nh_saddr_genid == atomic_read(&net->ipv4.dev_addr_genid))
+			return nh->nh_saddr;
+	}
 
-	return fib_info_update_nh_saddr(net, nh, res->fi->fib_scope);
+	return fib_info_update_nhc_saddr(net, nhc, res->fi->fib_scope);
 }
 
 static bool fib_valid_prefsrc(struct fib_config *cfg, __be32 fib_prefsrc)
@@ -1397,7 +1412,8 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 	}
 
 	change_nexthops(fi) {
-		fib_info_update_nh_saddr(net, nexthop_nh, fi->fib_scope);
+		fib_info_update_nhc_saddr(net, &nexthop_nh->nh_common,
+					  fi->fib_scope);
 		if (nexthop_nh->fib_nh_gw_family == AF_INET6)
 			fi->fib_nh_is_v6 = true;
 	} endfor_nexthops(fi)
@@ -1625,17 +1641,22 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 	    nla_put_in_addr(skb, RTA_PREFSRC, fi->fib_prefsrc))
 		goto nla_put_failure;
 	if (nhs == 1) {
-		const struct fib_nh *nh = fib_info_nh(fi, 0);
+		const struct fib_nh_common *nhc = fib_info_nhc(fi, 0);
 		unsigned char flags = 0;
 
-		if (fib_nexthop_info(skb, &nh->nh_common, &flags, false) < 0)
+		if (fib_nexthop_info(skb, nhc, &flags, false) < 0)
 			goto nla_put_failure;
 
 		rtm->rtm_flags = flags;
 #ifdef CONFIG_IP_ROUTE_CLASSID
-		if (nh->nh_tclassid &&
-		    nla_put_u32(skb, RTA_FLOW, nh->nh_tclassid))
-			goto nla_put_failure;
+		if (nhc->nhc_family == AF_INET) {
+			struct fib_nh *nh;
+
+			nh = container_of(nhc, struct fib_nh, nh_common);
+			if (nh->nh_tclassid &&
+			    nla_put_u32(skb, RTA_FLOW, nh->nh_tclassid))
+				goto nla_put_failure;
+		}
 #endif
 	} else {
 		if (fib_add_multipath(skb, fi) < 0)
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 5c8a4d21b8e0..d704d1606b8f 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2724,9 +2724,9 @@ static unsigned int fib_flag_trans(int type, __be32 mask, struct fib_info *fi)
 	if (type == RTN_UNREACHABLE || type == RTN_PROHIBIT)
 		flags = RTF_REJECT;
 	if (fi) {
-		const struct fib_nh *nh = fib_info_nh(fi, 0);
+		const struct fib_nh_common *nhc = fib_info_nhc(fi, 0);
 
-		if (nh->fib_nh_gw4)
+		if (nhc->nhc_gw.ipv4)
 			flags |= RTF_GATEWAY;
 	}
 	if (mask == htonl(0xFFFFFFFF))
@@ -2773,14 +2773,17 @@ static int fib_route_seq_show(struct seq_file *seq, void *v)
 		seq_setwidth(seq, 127);
 
 		if (fi) {
-			struct fib_nh *nh = fib_info_nh(fi, 0);
+			struct fib_nh_common *nhc = fib_info_nhc(fi, 0);
+			__be32 gw = 0;
+
+			if (nhc->nhc_gw_family == AF_INET)
+				gw = nhc->nhc_gw.ipv4;
 
 			seq_printf(seq,
 				   "%s\t%08X\t%08X\t%04X\t%d\t%u\t"
 				   "%d\t%08X\t%d\t%u\t%u",
-				   nh->fib_nh_dev ? nh->fib_nh_dev->name : "*",
-				   prefix,
-				   nh->fib_nh_gw4, flags, 0, 0,
+				   nhc->nhc_dev ? nhc->nhc_dev->name : "*",
+				   prefix, gw, flags, 0, 0,
 				   fi->fib_priority,
 				   mask,
 				   (fi->fib_advmss ?
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 7a5a3d08fec3..aec4ecb145a0 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -815,7 +815,8 @@ static int nh_create_ipv4(struct net *net, struct nexthop *nh,
 	err = fib_check_nh(net, fib_nh, tb_id, 0, extack);
 	if (!err) {
 		nh->nh_flags = fib_nh->fib_nh_flags;
-		fib_info_update_nh_saddr(net, fib_nh, fib_nh->fib_nh_scope);
+		fib_info_update_nhc_saddr(net, &fib_nh->nh_common,
+					  fib_nh->fib_nh_scope);
 	} else {
 		fib_nh_release(net, fib_nh);
 	}
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 05a6a8ecb574..4a1168451f3a 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1585,7 +1585,7 @@ static void rt_set_nexthop(struct rtable *rt, __be32 daddr,
 		ip_dst_init_metrics(&rt->dst, fi->fib_metrics);
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
-		{
+		if (nhc->nhc_family == AF_INET) {
 			struct fib_nh *nh;
 
 			nh = container_of(nhc, struct fib_nh, nh_common);
-- 
2.11.0

