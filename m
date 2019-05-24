Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D442A08D
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404312AbfEXVnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404301AbfEXVnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 17:43:16 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4263F21871;
        Fri, 24 May 2019 21:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558734195;
        bh=OHLW0MyUC88aY+YyPHxFQR0tSbHohCnxm/ZOb+Iynao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQSq+MmLzNk63gSQAwUcUxfgcaXO0fgdTVspsF49DWUTjlFyxsh8lQgGjoU6RMWs4
         lpAfbPrH1SfeKYvIoxSRh10j19RqGMLqsOcCnrgr9pu4kt1NunaDzxAtjrnI9sLvN0
         EL1rFDtBTF8hhUFqTYVMApYVV1jQIDtj6zMFCII0=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     sharpd@cumulusnetworks.com, sworley@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 6/6] nexthop: Add support for nexthop groups
Date:   Fri, 24 May 2019 14:43:08 -0700
Message-Id: <20190524214308.18615-7-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190524214308.18615-1-dsahern@kernel.org>
References: <20190524214308.18615-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Allow the creation of nexthop groups which reference other nexthop
objects to create multipath routes:

                      +--------------+
   +------------+   +--------------+ |
   | nh  nh_grp --->| nh_grp_entry |-+
   +------------+   +---------|----+
     ^                |       |    +------------+
     +----------------+       +--->| nh, weight |
        nh_parent                  +------------+

A group entry points to a nexthop with a weight for that hop within the
group. The nexthop has a list_head, grp_list, for tracking which groups
it is a member of and the group entry has a reference back to the parent.
The grp_list is used when a nexthop is deleted - to efficiently remove
it from groups using it.

If a nexthop group spec is given, no other attributes can be set. Each
nexthop id in a group spec must already exist.

Similar to single nexthops, the specification of a nexthop group can be
updated so that data is managed with rcu locking.

Add path selection function to account for multiple paths and add
ipv{4,6}_good_nh helpers to know that if a neighbor entry exists it is
in a good state.

Update NETDEV event handling to rebalance multipath nexthop groups if
a nexthop is deleted due to a link event (down or unregister).

When a nexthop is removed any groups using it are updated. Groups using a
nexthop a tracked via a grp_list.

Nexthop dumps can be limited to groups only by adding NHA_GROUPS to the
request.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/nexthop.h |  98 +++++++++-
 net/ipv4/nexthop.c    | 504 +++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 578 insertions(+), 24 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 7cde03337e14..6e1b8f53624c 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -35,6 +35,9 @@ struct nh_config {
 		struct in6_addr	ipv6;
 	} gw;
 
+	struct nlattr	*nh_grp;
+	u16		nh_grp_type;
+
 	struct nlattr	*nh_encap;
 	u16		nh_encap_type;
 
@@ -56,20 +59,39 @@ struct nh_info {
 	};
 };
 
+struct nh_grp_entry {
+	struct nexthop	*nh;
+	u8		weight;
+	atomic_t	upper_bound;
+
+	struct list_head nh_list;
+	struct nexthop	*nh_parent;  /* nexthop of group with this entry */
+};
+
+struct nh_group {
+	u16			num_nh;
+	bool			mpath;
+	bool			has_v4;
+	struct nh_grp_entry	nh_entries[0];
+};
+
 struct nexthop {
 	struct rb_node		rb_node;    /* entry on netns rbtree */
+	struct list_head	grp_list;   /* nh group entries using this nh */
 	struct net		*net;
 
 	u32			id;
 
 	u8			protocol;   /* app managing this nh */
 	u8			nh_flags;
+	bool			is_group;
 
 	refcount_t		refcnt;
 	struct rcu_head		rcu;
 
 	union {
 		struct nh_info	__rcu *nh_info;
+		struct nh_group __rcu *nh_grp;
 	};
 };
 
@@ -88,12 +110,86 @@ static inline void nexthop_put(struct nexthop *nh)
 		call_rcu(&nh->rcu, nexthop_free_rcu);
 }
 
+static inline bool nexthop_is_multipath(const struct nexthop *nh)
+{
+	if (nh->is_group) {
+		struct nh_group *nh_grp;
+
+		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
+		return nh_grp->mpath;
+	}
+	return false;
+}
+
+struct nexthop *nexthop_select_path(struct nexthop *nh, int hash);
+
+static inline unsigned int nexthop_num_path(const struct nexthop *nh)
+{
+	unsigned int rc = 1;
+
+	if (nexthop_is_multipath(nh)) {
+		struct nh_group *nh_grp;
+
+		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
+		rc = nh_grp->num_nh;
+	} else {
+		const struct nh_info *nhi;
+
+		nhi = rcu_dereference_rtnl(nh->nh_info);
+		if (nhi->reject_nh)
+			rc = 0;
+	}
+
+	return rc;
+}
+
+static inline
+struct nexthop *nexthop_mpath_select(const struct nexthop *nh, int nhsel)
+{
+	const struct nh_group *nhg = rcu_dereference_rtnl(nh->nh_grp);
+
+	/* for_nexthops macros in fib_semantics.c grabs a pointer to
+	 * the nexthop before checking nhsel
+	 */
+	if (nhsel > nhg->num_nh)
+		return NULL;
+
+	return nhg->nh_entries[nhsel].nh;
+}
+
+static inline
+int nexthop_mpath_fill_node(struct sk_buff *skb, struct nexthop *nh)
+{
+	struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
+	int i;
+
+	for (i = 0; i < nhg->num_nh; i++) {
+		struct nexthop *nhe = nhg->nh_entries[i].nh;
+		struct nh_info *nhi = rcu_dereference_rtnl(nhe->nh_info);
+		struct fib_nh_common *nhc = &nhi->fib_nhc;
+		int weight = nhg->nh_entries[i].weight;
+
+		if (fib_add_nexthop(skb, nhc, weight) < 0)
+			return -EMSGSIZE;
+	}
+
+	return 0;
+}
+
 /* called with rcu lock */
 static inline bool nexthop_is_blackhole(const struct nexthop *nh)
 {
 	const struct nh_info *nhi;
 
-	nhi = rcu_dereference(nh->nh_info);
+	if (nexthop_is_multipath(nh)) {
+		if (nexthop_num_path(nh) > 1)
+			return false;
+		nh = nexthop_mpath_select(nh, 0);
+		if (!nh)
+			return false;
+	}
+
+	nhi = rcu_dereference_rtnl(nh->nh_info);
 	return nhi->reject_nh;
 }
 #endif
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 3a1cbcb96baa..1af8a329dacb 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -8,12 +8,17 @@
 #include <linux/nexthop.h>
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
+#include <net/arp.h>
 #include <net/ipv6_stubs.h>
 #include <net/lwtunnel.h>
+#include <net/ndisc.h>
 #include <net/nexthop.h>
 #include <net/route.h>
 #include <net/sock.h>
 
+static void remove_nexthop(struct net *net, struct nexthop *nh,
+			   struct nl_info *nlinfo);
+
 #define NH_DEV_HASHBITS  8
 #define NH_DEV_HASHSIZE (1U << NH_DEV_HASHBITS)
 
@@ -53,9 +58,20 @@ static void nexthop_devhash_add(struct net *net, struct nh_info *nhi)
 	hlist_add_head(&nhi->dev_hash, head);
 }
 
-void nexthop_free_rcu(struct rcu_head *head)
+static void nexthop_free_mpath(struct nexthop *nh)
+{
+	struct nh_group *nhg;
+	int i;
+
+	nhg = rcu_dereference_raw(nh->nh_grp);
+	for (i = 0; i < nhg->num_nh; ++i)
+		WARN_ON(nhg->nh_entries[i].nh);
+
+	kfree(nhg);
+}
+
+static void nexthop_free_single(struct nexthop *nh)
 {
-	struct nexthop *nh = container_of(head, struct nexthop, rcu);
 	struct nh_info *nhi;
 
 	nhi = rcu_dereference_raw(nh->nh_info);
@@ -68,6 +84,16 @@ void nexthop_free_rcu(struct rcu_head *head)
 		break;
 	}
 	kfree(nhi);
+}
+
+void nexthop_free_rcu(struct rcu_head *head)
+{
+	struct nexthop *nh = container_of(head, struct nexthop, rcu);
+
+	if (nh->is_group)
+		nexthop_free_mpath(nh);
+	else
+		nexthop_free_single(nh);
 
 	kfree(nh);
 }
@@ -78,9 +104,26 @@ static struct nexthop *nexthop_alloc(void)
 	struct nexthop *nh;
 
 	nh = kzalloc(sizeof(struct nexthop), GFP_KERNEL);
+	if (nh) {
+		INIT_LIST_HEAD(&nh->grp_list);
+	}
 	return nh;
 }
 
+static struct nh_group *nexthop_grp_alloc(u16 num_nh)
+{
+	size_t sz = offsetof(struct nexthop, nh_grp)
+		    + sizeof(struct nh_group)
+		    + sizeof(struct nh_grp_entry) * num_nh;
+	struct nh_group *nhg;
+
+	nhg = kzalloc(sz, GFP_KERNEL);
+	if (nhg)
+		nhg->num_nh = num_nh;
+
+	return nhg;
+}
+
 static void nh_base_seq_inc(struct net *net)
 {
 	while (++net->nexthop.seq == 0)
@@ -129,6 +172,37 @@ static u32 nh_find_unused_id(struct net *net)
 	return 0;
 }
 
+static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
+{
+	struct nexthop_grp *p;
+	size_t len = nhg->num_nh * sizeof(*p);
+	struct nlattr *nla;
+	u16 group_type = 0;
+	int i;
+
+	if (nhg->mpath)
+		group_type = NEXTHOP_GRP_TYPE_MPATH;
+
+	if (nla_put_u16(skb, NHA_GROUP_TYPE, group_type))
+		goto nla_put_failure;
+
+	nla = nla_reserve(skb, NHA_GROUP, len);
+	if (!nla)
+		goto nla_put_failure;
+
+	p = nla_data(nla);
+	for (i = 0; i < nhg->num_nh; ++i) {
+		p->id = nhg->nh_entries[i].nh->id;
+		p->weight = nhg->nh_entries[i].weight - 1;
+		p += 1;
+	}
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 			int event, u32 portid, u32 seq, unsigned int nlflags)
 {
@@ -152,6 +226,14 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 	if (nla_put_u32(skb, NHA_ID, nh->id))
 		goto nla_put_failure;
 
+	if (nh->is_group) {
+		struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
+
+		if (nla_put_nh_group(skb, nhg))
+			goto nla_put_failure;
+		goto out;
+	}
+
 	nhi = rtnl_dereference(nh->nh_info);
 	nhm->nh_family = nhi->family;
 	if (nhi->reject_nh) {
@@ -196,15 +278,24 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 	return -EMSGSIZE;
 }
 
-static size_t nh_nlmsg_size(struct nexthop *nh)
+static size_t nh_nlmsg_size_grp(struct nexthop *nh)
+{
+	struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
+	size_t sz = sizeof(struct nexthop_grp) * nhg->num_nh;
+
+	return nla_total_size(sz) +
+	       nla_total_size(2);  /* NHA_GROUP_TYPE */
+}
+
+static size_t nh_nlmsg_size_single(struct nexthop *nh)
 {
 	struct nh_info *nhi = rtnl_dereference(nh->nh_info);
-	size_t sz = nla_total_size(4);    /* NHA_ID */
+	size_t sz;
 
 	/* covers NHA_BLACKHOLE since NHA_OIF and BLACKHOLE
 	 * are mutually exclusive
 	 */
-	sz += nla_total_size(4);  /* NHA_OIF */
+	sz = nla_total_size(4);  /* NHA_OIF */
 
 	switch (nhi->family) {
 	case AF_INET:
@@ -227,6 +318,18 @@ static size_t nh_nlmsg_size(struct nexthop *nh)
 	return sz;
 }
 
+static size_t nh_nlmsg_size(struct nexthop *nh)
+{
+	size_t sz = nla_total_size(4);    /* NHA_ID */
+
+	if (nh->is_group)
+		sz += nh_nlmsg_size_grp(nh);
+	else
+		sz += nh_nlmsg_size_single(nh);
+
+	return sz;
+}
+
 static void nexthop_notify(int event, struct nexthop *nh, struct nl_info *info)
 {
 	unsigned int nlflags = info->nlh ? info->nlh->nlmsg_flags : 0;
@@ -254,17 +357,274 @@ static void nexthop_notify(int event, struct nexthop *nh, struct nl_info *info)
 		rtnl_set_sk_err(info->nl_net, RTNLGRP_NEXTHOP, err);
 }
 
-static void __remove_nexthop(struct net *net, struct nexthop *nh)
+static bool valid_group_nh(struct nexthop *nh, unsigned int npaths,
+			   struct netlink_ext_ack *extack)
 {
-	struct nh_info *nhi;
+	if (nh->is_group) {
+		struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
 
-	nhi = rtnl_dereference(nh->nh_info);
-	if (nhi->fib_nhc.nhc_dev)
-		hlist_del(&nhi->dev_hash);
+		/* nested multipath (group within a group) is not
+		 * supported
+		 */
+		if (nhg->mpath) {
+			NL_SET_ERR_MSG(extack,
+				       "Multipath group can not be a nexthop within a group");
+			return false;
+		}
+	} else {
+		struct nh_info *nhi = rtnl_dereference(nh->nh_info);
+
+		if (nhi->reject_nh && npaths > 1) {
+			NL_SET_ERR_MSG(extack,
+				       "Blackhole nexthop can not be used in a group with more than 1 path");
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
+			       struct netlink_ext_ack *extack)
+{
+	unsigned int len = nla_len(tb[NHA_GROUP]);
+	struct nexthop_grp *nhg;
+	unsigned int i, j;
+
+	if (len & (sizeof(struct nexthop_grp) - 1)) {
+		NL_SET_ERR_MSG(extack,
+			       "Invalid length for nexthop group attribute");
+		return -EINVAL;
+	}
+
+	/* convert len to number of nexthop ids */
+	len /= sizeof(*nhg);
+
+	nhg = nla_data(tb[NHA_GROUP]);
+	for (i = 0; i < len; ++i) {
+		if (nhg[i].resvd1 || nhg[i].resvd2) {
+			NL_SET_ERR_MSG(extack, "Reserved fields in nexthop_grp must be 0");
+			return -EINVAL;
+		}
+		if (nhg[i].weight > 254) {
+			NL_SET_ERR_MSG(extack, "Invalid value for weight");
+			return -EINVAL;
+		}
+		for (j = i + 1; j < len; ++j) {
+			if (nhg[i].id == nhg[j].id) {
+				NL_SET_ERR_MSG(extack, "Nexthop id can not be used twice in a group");
+				return -EINVAL;
+			}
+		}
+	}
+
+	nhg = nla_data(tb[NHA_GROUP]);
+	for (i = 0; i < len; ++i) {
+		struct nexthop *nh;
+
+		nh = nexthop_find_by_id(net, nhg[i].id);
+		if (!nh) {
+			NL_SET_ERR_MSG(extack, "Invalid nexthop id");
+			return -EINVAL;
+		}
+		if (!valid_group_nh(nh, len, extack))
+			return -EINVAL;
+	}
+	for (i = NHA_GROUP + 1; i < __NHA_MAX; ++i) {
+		if (!tb[i])
+			continue;
+
+		NL_SET_ERR_MSG(extack,
+			       "No other attributes can be set in nexthop groups");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static bool ipv6_good_nh(const struct fib6_nh *nh)
+{
+	int state = NUD_REACHABLE;
+	struct neighbour *n;
+
+	rcu_read_lock_bh();
+
+	n = __ipv6_neigh_lookup_noref_stub(nh->fib_nh_dev, &nh->fib_nh_gw6);
+	if (n)
+		state = n->nud_state;
+
+	rcu_read_unlock_bh();
+
+	return !!(state & NUD_VALID);
+}
+
+static bool ipv4_good_nh(const struct fib_nh *nh)
+{
+	int state = NUD_REACHABLE;
+	struct neighbour *n;
+
+	rcu_read_lock_bh();
+
+	n = __ipv4_neigh_lookup_noref(nh->fib_nh_dev,
+				      (__force u32)nh->fib_nh_gw4);
+	if (n)
+		state = n->nud_state;
+
+	rcu_read_unlock_bh();
+
+	return !!(state & NUD_VALID);
+}
+
+struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
+{
+	struct nexthop *rc = NULL;
+	struct nh_group *nhg;
+	int i;
+
+	if (!nh->is_group)
+		return nh;
+
+	nhg = rcu_dereference(nh->nh_grp);
+	for (i = 0; i < nhg->num_nh; ++i) {
+		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+		struct nh_info *nhi;
+
+		if (hash > atomic_read(&nhge->upper_bound))
+			continue;
+
+		/* nexthops always check if it is good and does
+		 * not rely on a sysctl for this behavior
+		 */
+		nhi = rcu_dereference(nhge->nh->nh_info);
+		switch (nhi->family) {
+		case AF_INET:
+			if (ipv4_good_nh(&nhi->fib_nh))
+				return nhge->nh;
+			break;
+		case AF_INET6:
+			if (ipv6_good_nh(&nhi->fib6_nh))
+				return nhge->nh;
+			break;
+		}
+
+		if (!rc)
+			rc = nhge->nh;
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(nexthop_select_path);
+
+static void nh_group_rebalance(struct nh_group *nhg)
+{
+	int total = 0;
+	int w = 0;
+	int i;
+
+	for (i = 0; i < nhg->num_nh; ++i)
+		total += nhg->nh_entries[i].weight;
+
+	for (i = 0; i < nhg->num_nh; ++i) {
+		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+		int upper_bound;
+
+		w += nhge->weight;
+		upper_bound = DIV_ROUND_CLOSEST_ULL((u64)w << 31, total) - 1;
+		atomic_set(&nhge->upper_bound, upper_bound);
+	}
+}
+
+static void remove_nh_grp_entry(struct nh_grp_entry *nhge,
+				struct nh_group *nhg,
+				struct nl_info *nlinfo)
+{
+	struct nexthop *nh = nhge->nh;
+	struct nh_grp_entry *nhges;
+	bool found = false;
+	int i;
+
+	WARN_ON(!nh);
+
+	nhges = nhg->nh_entries;
+	for (i = 0; i < nhg->num_nh; ++i) {
+		if (found) {
+			nhges[i-1].nh = nhges[i].nh;
+			nhges[i-1].weight = nhges[i].weight;
+			list_del(&nhges[i].nh_list);
+			list_add(&nhges[i-1].nh_list, &nhges[i-1].nh->grp_list);
+		} else if (nhg->nh_entries[i].nh == nh) {
+			found = true;
+		}
+	}
+
+	if (WARN_ON(!found))
+		return;
+
+	nhg->num_nh--;
+	nhg->nh_entries[nhg->num_nh].nh = NULL;
+
+	nh_group_rebalance(nhg);
+
+	nexthop_put(nh);
+
+	if (nlinfo)
+		nexthop_notify(RTM_NEWNEXTHOP, nhge->nh_parent, nlinfo);
+}
+
+static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
+				       struct nl_info *nlinfo)
+{
+	struct nh_grp_entry *nhge, *tmp;
+
+	list_for_each_entry_safe(nhge, tmp, &nh->grp_list, nh_list) {
+		struct nh_group *nhg;
+
+		list_del(&nhge->nh_list);
+		nhg = rtnl_dereference(nhge->nh_parent->nh_grp);
+		remove_nh_grp_entry(nhge, nhg, nlinfo);
+
+		/* if this group has no more entries then remove it */
+		if (!nhg->num_nh)
+			remove_nexthop(net, nhge->nh_parent, nlinfo);
+	}
+}
+
+static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
+{
+	struct nh_group *nhg = rcu_dereference_rtnl(nh->nh_grp);
+	int i, num_nh = nhg->num_nh;
+
+	for (i = 0; i < num_nh; ++i) {
+		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+
+		if (WARN_ON(!nhge->nh))
+			continue;
+
+		list_del(&nhge->nh_list);
+		nexthop_put(nhge->nh);
+		nhge->nh = NULL;
+		nhg->num_nh--;
+	}
+}
+
+static void __remove_nexthop(struct net *net, struct nexthop *nh,
+			     struct nl_info *nlinfo)
+{
+	if (nh->is_group) {
+		remove_nexthop_group(nh, nlinfo);
+	} else {
+		struct nh_info *nhi;
+
+		nhi = rtnl_dereference(nh->nh_info);
+		if (nhi->fib_nhc.nhc_dev)
+			hlist_del(&nhi->dev_hash);
+
+		remove_nexthop_from_groups(net, nh, nlinfo);
+	}
 }
 
 static void remove_nexthop(struct net *net, struct nexthop *nh,
-			   bool skip_fib, struct nl_info *nlinfo)
+			   struct nl_info *nlinfo)
 {
 	/* remove from the tree */
 	rb_erase(&nh->rb_node, &net->nexthop.rb_root);
@@ -272,7 +632,7 @@ static void remove_nexthop(struct net *net, struct nexthop *nh,
 	if (nlinfo)
 		nexthop_notify(RTM_DELNEXTHOP, nh, nlinfo);
 
-	__remove_nexthop(net, nh);
+	__remove_nexthop(net, nh, nlinfo);
 	nh_base_seq_inc(net);
 
 	nexthop_put(nh);
@@ -353,7 +713,7 @@ static void nexthop_flush_dev(struct net_device *dev)
 		if (nhi->fib_nhc.nhc_dev != dev)
 			continue;
 
-		remove_nexthop(net, nhi->nh_parent, false, NULL);
+		remove_nexthop(net, nhi->nh_parent, NULL);
 	}
 }
 
@@ -366,11 +726,69 @@ static void flush_all_nexthops(struct net *net)
 
 	while ((node = rb_first(root))) {
 		nh = rb_entry(node, struct nexthop, rb_node);
-		remove_nexthop(net, nh, false, NULL);
+		remove_nexthop(net, nh, NULL);
 		cond_resched();
 	}
 }
 
+static struct nexthop *nexthop_create_group(struct net *net,
+					    struct nh_config *cfg)
+{
+	struct nlattr *grps_attr = cfg->nh_grp;
+	struct nexthop_grp *entry = nla_data(grps_attr);
+	struct nh_group *nhg;
+	struct nexthop *nh;
+	int i;
+
+	nh = nexthop_alloc();
+	if (!nh)
+		return ERR_PTR(-ENOMEM);
+
+	nh->is_group = 1;
+
+	nhg = nexthop_grp_alloc(nla_len(grps_attr) / sizeof(*entry));
+	if (!nhg) {
+		kfree(nh);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	for (i = 0; i < nhg->num_nh; ++i) {
+		struct nexthop *nhe;
+		struct nh_info *nhi;
+
+		nhe = nexthop_find_by_id(net, entry[i].id);
+		if (!nexthop_get(nhe))
+			goto out_no_nh;
+
+		nhi = rtnl_dereference(nhe->nh_info);
+		if (nhi->family == AF_INET)
+			nhg->has_v4 = true;
+
+		nhg->nh_entries[i].nh = nhe;
+		nhg->nh_entries[i].weight = entry[i].weight + 1;
+		list_add(&nhg->nh_entries[i].nh_list, &nhe->grp_list);
+		nhg->nh_entries[i].nh_parent = nh;
+	}
+
+	if (cfg->nh_grp_type == NEXTHOP_GRP_TYPE_MPATH) {
+		nhg->mpath = 1;
+		nh_group_rebalance(nhg);
+	}
+
+	rcu_assign_pointer(nh->nh_grp, nhg);
+
+	return nh;
+
+out_no_nh:
+	for (; i >= 0; --i)
+		nexthop_put(nhg->nh_entries[i].nh);
+
+	kfree(nhg);
+	kfree(nh);
+
+	return ERR_PTR(-ENOENT);
+}
+
 static int nh_create_ipv4(struct net *net, struct nexthop *nh,
 			  struct nh_info *nhi, struct nh_config *cfg,
 			  struct netlink_ext_ack *extack)
@@ -506,7 +924,11 @@ static struct nexthop *nexthop_add(struct net *net, struct nh_config *cfg,
 		}
 	}
 
-	nh = nexthop_create(net, cfg, extack);
+	if (cfg->nh_grp)
+		nh = nexthop_create_group(net, cfg);
+	else
+		nh = nexthop_create(net, cfg, extack);
+
 	if (IS_ERR(nh))
 		return nh;
 
@@ -517,7 +939,7 @@ static struct nexthop *nexthop_add(struct net *net, struct nh_config *cfg,
 
 	err = insert_nexthop(net, nh, cfg, extack);
 	if (err) {
-		__remove_nexthop(net, nh);
+		__remove_nexthop(net, nh, NULL);
 		nexthop_put(nh);
 		nh = ERR_PTR(err);
 	}
@@ -552,6 +974,10 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 	case AF_INET:
 	case AF_INET6:
 		break;
+	case AF_UNSPEC:
+		if (tb[NHA_GROUP])
+			break;
+		/* fallthrough */
 	default:
 		NL_SET_ERR_MSG(extack, "Invalid address family");
 		goto out;
@@ -575,6 +1001,27 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 	if (tb[NHA_ID])
 		cfg->nh_id = nla_get_u32(tb[NHA_ID]);
 
+	if (tb[NHA_GROUP]) {
+		if (nhm->nh_family != AF_UNSPEC) {
+			NL_SET_ERR_MSG(extack, "Invalid family for group");
+			goto out;
+		}
+		cfg->nh_grp = tb[NHA_GROUP];
+
+		cfg->nh_grp_type = NEXTHOP_GRP_TYPE_MPATH;
+		if (tb[NHA_GROUP_TYPE])
+			cfg->nh_grp_type = nla_get_u16(tb[NHA_GROUP_TYPE]);
+
+		if (cfg->nh_grp_type > NEXTHOP_GRP_TYPE_MAX) {
+			NL_SET_ERR_MSG(extack, "Invalid group type");
+			goto out;
+		}
+		err = nh_check_attr_group(net, tb, extack);
+
+		/* no other attributes should be set */
+		goto out;
+	}
+
 	if (tb[NHA_BLACKHOLE]) {
 		if (tb[NHA_GATEWAY] || tb[NHA_OIF] ||
 		    tb[NHA_ENCAP]   || tb[NHA_ENCAP_TYPE]) {
@@ -752,7 +1199,7 @@ static int rtm_del_nexthop(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!nh)
 		return -ENOENT;
 
-	remove_nexthop(net, nh, false, &nlinfo);
+	remove_nexthop(net, nh, &nlinfo);
 
 	return 0;
 }
@@ -796,15 +1243,21 @@ static int rtm_get_nexthop(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 	goto out;
 }
 
-static bool nh_dump_filtered(struct nexthop *nh, int dev_idx,
-			     int master_idx, u8 family)
+static bool nh_dump_filtered(struct nexthop *nh, int dev_idx, int master_idx,
+			     bool group_filter, u8 family)
 {
 	const struct net_device *dev;
 	const struct nh_info *nhi;
 
+	if (group_filter && !nh->is_group)
+		return true;
+
 	if (!dev_idx && !master_idx && !family)
 		return false;
 
+	if (nh->is_group)
+		return true;
+
 	nhi = rtnl_dereference(nh->nh_info);
 	if (family && nhi->family != family)
 		return true;
@@ -827,8 +1280,8 @@ static bool nh_dump_filtered(struct nexthop *nh, int dev_idx,
 	return false;
 }
 
-static int nh_valid_dump_req(const struct nlmsghdr *nlh,
-			     int *dev_idx, int *master_idx,
+static int nh_valid_dump_req(const struct nlmsghdr *nlh, int *dev_idx,
+			     int *master_idx, bool *group_filter,
 			     struct netlink_callback *cb)
 {
 	struct netlink_ext_ack *extack = cb->extack;
@@ -863,6 +1316,9 @@ static int nh_valid_dump_req(const struct nlmsghdr *nlh,
 			}
 			*master_idx = idx;
 			break;
+		case NHA_GROUPS:
+			*group_filter = true;
+			break;
 		default:
 			NL_SET_ERR_MSG(extack, "Unsupported attribute in dump request");
 			return -EINVAL;
@@ -885,11 +1341,13 @@ static int rtm_dump_nexthop(struct sk_buff *skb, struct netlink_callback *cb)
 	int dev_filter_idx = 0, master_idx = 0;
 	struct net *net = sock_net(skb->sk);
 	struct rb_root *root = &net->nexthop.rb_root;
+	bool group_filter = false;
 	struct rb_node *node;
 	int idx = 0, s_idx;
 	int err;
 
-	err = nh_valid_dump_req(cb->nlh, &dev_filter_idx, &master_idx, cb);
+	err = nh_valid_dump_req(cb->nlh, &dev_filter_idx, &master_idx,
+				&group_filter, cb);
 	if (err < 0)
 		return err;
 
@@ -902,7 +1360,7 @@ static int rtm_dump_nexthop(struct sk_buff *skb, struct netlink_callback *cb)
 
 		nh = rb_entry(node, struct nexthop, rb_node);
 		if (nh_dump_filtered(nh, dev_filter_idx, master_idx,
-				     nhm->nh_family))
+				     group_filter, nhm->nh_family))
 			goto cont;
 
 		err = nh_fill_node(skb, nh, RTM_NEWNEXTHOP,
-- 
2.11.0

