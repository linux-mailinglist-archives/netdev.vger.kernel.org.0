Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CBA1F4BE7
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 05:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgFJDuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 23:50:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgFJDuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 23:50:02 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6804920829;
        Wed, 10 Jun 2020 03:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591760999;
        bh=XNR7jklSCQPwpm5aH7JokTLnhIsh/ZOnoOSS4HOKJoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPS0I5UuEL8L4qaNCp++CXWT9L0zxPs80Rxx9Yji3lWuRftKwc0OQ1Pp8k2g5KHJV
         k4OyGKlMwytJLp1vwqXDpALAaCtNWz/sJB08Jz60qMzUMjPfIoKmpa1+JLt4KFgMsT
         FESzHfnB2Se8Cfyy0KandQyiVvcfGkMg8m/SFZK4=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, assogba.emery@gmail.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH RFC net-next 7/8] nexthop: Add support for active-backup nexthop type
Date:   Tue,  9 Jun 2020 21:49:52 -0600
Message-Id: <20200610034953.28861-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200610034953.28861-1-dsahern@kernel.org>
References: <20200610034953.28861-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new active-backup group type. The intent is that the group describes
a primary nexthop with a backup option if the primary is not available.
Since nexthop code removes entries on carrier or admin down this really
means the backup applies when the neighbor entry for the active becomes
invalid. In that case the lookup atomically switches to use the backup.

Conceptually, the linkage is like this. For single path routes, a FIB
entry references a nexthop that is a an active-backup pair:
                                nexthop active
  { prefix }  -> a-b nexthop -<
                                nexthop backup

Alternatively, an active-backup nexthop can be one more entries in a
multipath route:
                                                     nexthop active
                                   nexthop 1 (ab) -<
  { prefix }  -> mpath nexthop -<    ...             nexthop backup
                                   nexthop N

The intent is to provide a fast failover option for routing daemons -
the primary goes down, notification is sent to userspace, and the backup
takes over until the daemon can adjust the routes.

For multipath routes this has the added benefit of providing an option
to limit the flows affected by a carrier or admin down event. Currently,
flows are hashed over the N-paths of a multipath route. If a path goes
dead, the leg is effectively removed and all flows are potentially
affected as the hashing consides now N-1 paths. With active-backup
nexthops an admin can setup a backup for each leg to minimize the
affected flows.

Most of this change is updating the group handling to account for
the a-b pair, especially in nexthop groups. Datapath lookups should
only consider the active nexthop unless it is determined bad. Route
notifications and lookups will only show the existence of the
active nexthop.

Signed-off-by: ASSOGBA Emery <assogba.emery@gmail.com>
Co-developed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 include/net/nexthop.h        |  50 ++++++++--
 include/uapi/linux/nexthop.h |   1 +
 net/ipv4/fib_semantics.c     |   6 +-
 net/ipv4/nexthop.c           | 186 ++++++++++++++++++++++++++++++++---
 4 files changed, 217 insertions(+), 26 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 8cedadb902b6..aee870bc8c0e 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -76,6 +76,7 @@ struct nh_group {
 	struct nh_group		*spare; /* spare group for removals */
 	u16			num_nh;
 	bool			mpath;
+	bool			active_backup;
 	bool			has_v4;
 	struct nh_grp_entry	nh_entries[];
 };
@@ -158,6 +159,17 @@ static inline bool nexthop_is_multipath(const struct nexthop *nh)
 	return false;
 }
 
+static inline bool nexthop_is_active_backup(const struct nexthop *nh)
+{
+	if (nh->is_group) {
+		struct nh_group *nh_grp;
+
+		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
+		return nh_grp->active_backup;
+	}
+	return false;
+}
+
 struct nexthop *nexthop_select_path(struct nexthop *nh, int hash);
 
 static inline unsigned int nexthop_num_path(const struct nexthop *nh)
@@ -168,8 +180,7 @@ static inline unsigned int nexthop_num_path(const struct nexthop *nh)
 		struct nh_group *nh_grp;
 
 		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
-		if (nh_grp->mpath)
-			rc = nh_grp->num_nh;
+		rc = nh_grp->num_nh;
 	}
 
 	return rc;
@@ -196,9 +207,18 @@ int nexthop_mpath_fill_node(struct sk_buff *skb, struct nexthop *nh,
 
 	for (i = 0; i < nhg->num_nh; i++) {
 		struct nexthop *nhe = nhg->nh_entries[i].nh;
-		struct nh_info *nhi = rcu_dereference_rtnl(nhe->nh_info);
-		struct fib_nh_common *nhc = &nhi->fib_nhc;
 		int weight = nhg->nh_entries[i].weight;
+		struct fib_nh_common *nhc;
+		struct nh_info *nhi;
+
+		if (nhe->is_group) {
+			struct nh_group *nhg_ab = rtnl_dereference(nhe->nh_grp);
+
+			/* group in group is active-backup. take primary */
+			nhe = nhg_ab->nh_entries[0].nh;
+		}
+		nhi = rcu_dereference_rtnl(nhe->nh_info);
+		nhc = &nhi->fib_nhc;
 
 		if (fib_add_nexthop(skb, nhc, weight, rt_family) < 0)
 			return -EMSGSIZE;
@@ -216,7 +236,7 @@ static inline bool nexthop_is_blackhole(const struct nexthop *nh)
 		struct nh_group *nh_grp;
 
 		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
-		if (nh_grp->num_nh > 1)
+		if (nh_grp->active_backup || nh_grp->num_nh > 1)
 			return false;
 
 		nh = nh_grp->nh_entries[0].nh;
@@ -253,6 +273,16 @@ struct fib_nh_common *nexthop_fib_nhc(struct nexthop *nh, int nhsel)
 			nh = nexthop_mpath_select(nh_grp, nhsel);
 			if (!nh)
 				return NULL;
+
+			/* multipath with a-b path */
+			if (nh->is_group) {
+				nh_grp = rcu_dereference_rtnl(nh->nh_grp);
+				nh = nh_grp->nh_entries[0].nh;
+			}
+		} else if (nh_grp->active_backup) {
+			if (nhsel > 0)
+				return NULL;
+			nh = nh_grp->nh_entries[0].nh;
 		}
 	}
 
@@ -309,9 +339,13 @@ static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
 		struct nh_group *nh_grp;
 
 		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
-		nh = nexthop_mpath_select(nh_grp, 0);
-		if (!nh)
-			return NULL;
+		nh = nh_grp->nh_entries[0].nh;
+
+		/* mpath with active-backup path */
+		if (nh->is_group) {
+			nh_grp = rcu_dereference_rtnl(nh->nh_grp);
+			nh = nh_grp->nh_entries[0].nh;
+		}
 	}
 
 	nhi = rcu_dereference_rtnl(nh->nh_info);
diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
index 2d4a1e784cf0..9566e1ac07fe 100644
--- a/include/uapi/linux/nexthop.h
+++ b/include/uapi/linux/nexthop.h
@@ -22,6 +22,7 @@ struct nexthop_grp {
 
 enum {
 	NEXTHOP_GRP_TYPE_MPATH,  /* default type if not specified */
+	NEXTHOP_GRP_TYPE_ACTIVE_BACKUP,
 	__NEXTHOP_GRP_TYPE_MAX,
 };
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index e53871e4a097..a218cd912de9 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -480,10 +480,10 @@ static inline size_t fib_nlmsg_size(struct fib_info *fi)
 		nhsize += 2 * nla_total_size(4);
 
 		/* grab encap info */
-		for (i = 0; i < fib_info_num_path(fi); i++) {
+		for (i = 0; i < nhs; i++) {
 			struct fib_nh_common *nhc = fib_info_nhc(fi, i);
 
-			if (nhc->nhc_lwtstate) {
+			if (nhc && nhc->nhc_lwtstate) {
 				/* RTA_ENCAP_TYPE */
 				nh_encapsize += lwtunnel_get_encap_size(
 						nhc->nhc_lwtstate);
@@ -1780,6 +1780,8 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 			goto nla_put_failure;
 		if (nexthop_is_blackhole(fi->nh))
 			rtm->rtm_type = RTN_BLACKHOLE;
+		else if (nexthop_is_active_backup(fi->nh))
+			nhs = 1;
 		if (!fi->fib_net->ipv4.sysctl_nexthop_compat_mode)
 			goto offload;
 	}
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 8984e1e4058b..e7335a81198f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -204,6 +204,9 @@ static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
 	if (nhg->mpath)
 		group_type = NEXTHOP_GRP_TYPE_MPATH;
 
+	if (nhg->active_backup)
+		group_type = NEXTHOP_GRP_TYPE_ACTIVE_BACKUP;
+
 	if (nla_put_u16(skb, NHA_GROUP_TYPE, group_type))
 		goto nla_put_failure;
 
@@ -433,6 +436,7 @@ static int nh_check_attr_fdb_group(struct nexthop *nh, u8 *nh_family,
 }
 
 static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
+			       u16 nh_grp_type,
 			       struct netlink_ext_ack *extack)
 {
 	unsigned int len = nla_len(tb[NHA_GROUP]);
@@ -451,6 +455,13 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
 	len /= sizeof(*nhg);
 
 	nhg = nla_data(tb[NHA_GROUP]);
+
+	if (nh_grp_type == NEXTHOP_GRP_TYPE_ACTIVE_BACKUP &&
+	    (len != 2 || nhg[0].weight || nhg[1].weight)) {
+		NL_SET_ERR_MSG(extack, "Active/backup group must have 2 nexthops and weight can not be set");
+		return -EINVAL;
+	}
+
 	for (i = 0; i < len; ++i) {
 		if (nhg[i].resvd1 || nhg[i].resvd2) {
 			NL_SET_ERR_MSG(extack, "Reserved fields in nexthop_grp must be 0");
@@ -468,8 +479,14 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
 		}
 	}
 
-	if (tb[NHA_FDB])
+	if (tb[NHA_FDB]) {
+		if (nh_grp_type == NEXTHOP_GRP_TYPE_ACTIVE_BACKUP) {
+			NL_SET_ERR_MSG(extack, "Active/backup group not valid with fdb entries");
+			return -EINVAL;
+		}
 		nhg_fdb = 1;
+	}
+
 	nhg = nla_data(tb[NHA_GROUP]);
 	for (i = 0; i < len; ++i) {
 		struct nexthop *nh;
@@ -559,16 +576,43 @@ static bool good_nh(struct nexthop *nh)
 	return rc;
 }
 
-struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
+static struct nexthop *nh_select_path_ab(struct nh_group *nhg, int hash)
 {
 	struct nexthop *rc = NULL;
-	struct nh_group *nhg;
-	int i;
+	struct nexthop *p, *b;
+
+	switch (nhg->num_nh) {
+	case 2:
+		/* if primary is good, use it */
+		p = nhg->nh_entries[0].nh;
+		if (good_nh(p)) {
+			rc = p;
+			break;
+		}
 
-	if (!nh->is_group)
-		return nh;
+		/* try backup */
+		b = nhg->nh_entries[1].nh;
+		if (good_nh(b))
+			rc = b;
+		break;
+	case 1:
+		p = nhg->nh_entries[0].nh;
+		if (good_nh(p))
+			rc = p;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	return rc;
+}
+
+static struct nexthop *nh_select_path_mpath(struct nh_group *nhg, int hash)
+{
+	struct nexthop *rc = NULL;
+	int i;
 
-	nhg = rcu_dereference(nh->nh_grp);
 	for (i = 0; i < nhg->num_nh; ++i) {
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
 		struct nexthop *nh;
@@ -577,8 +621,17 @@ struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 			continue;
 
 		nh = nhge->nh;
-		if (nh->is_fdb_nh || good_nh(nh))
+
+		/* group in a group; inner one is active/backup pair */
+		if (unlikely(nh->is_group)) {
+			struct nh_group *nhg = rcu_dereference(nh->nh_grp);
+
+			nh = nh_select_path_ab(nhg, hash);
+			if (nh)
+				return nh;
+		} else if (good_nh(nh)) {
 			return nh;
+		}
 
 		if (!rc)
 			rc = nh;
@@ -586,6 +639,23 @@ struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 
 	return rc;
 }
+
+struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
+{
+	struct nh_group *nhg;
+	struct nexthop *rc;
+
+	if (!nh->is_group)
+		return nh;
+
+	nhg = rcu_dereference(nh->nh_grp);
+	if (nhg->active_backup)
+		rc = nh_select_path_ab(nhg, hash);
+	else
+		rc = nh_select_path_mpath(nhg, hash);
+
+	return rc;
+}
 EXPORT_SYMBOL_GPL(nexthop_select_path);
 
 static struct fib_nh_common *nhc_lookup_single(const struct nexthop *nh,
@@ -603,6 +673,17 @@ static struct fib_nh_common *nhc_lookup_single(const struct nexthop *nh,
 	return NULL;
 }
 
+/* active-backup only looks at primary */
+static struct fib_nh_common *nhc_lookup_ab(const struct nh_group *nhg,
+					   int fib_flags,
+					   const struct flowi4 *flp,
+					   int *nhsel)
+{
+	struct nexthop *nhe = nhg->nh_entries[0].nh;
+
+	return nhc_lookup_single(nhe, fib_flags, flp, nhsel);
+}
+
 static struct fib_nh_common *nhc_lookup_mpath(const struct nh_group *nhg,
 					      int fib_flags,
 					      const struct flowi4 *flp,
@@ -614,7 +695,14 @@ static struct fib_nh_common *nhc_lookup_mpath(const struct nh_group *nhg,
 	for (i = 0; i < nhg->num_nh; i++) {
 		struct nexthop *nhe = nhg->nh_entries[i].nh;
 
-		nhc = nhc_lookup_single(nhe, fib_flags, flp, nhsel);
+		if (nhe->is_group) {
+			const struct nh_group *nhg_ab;
+
+			nhg_ab = rcu_dereference(nhe->nh_grp);
+			nhc = nhc_lookup_ab(nhg_ab, fib_flags, flp, nhsel);
+		} else {
+			nhc = nhc_lookup_single(nhe, fib_flags, flp, nhsel);
+		}
 		if (nhc) {
 			*nhsel = i;
 			return nhc;
@@ -632,7 +720,10 @@ struct fib_nh_common *nexthop_get_nhc_lookup(const struct nexthop *nh,
 	if (nh->is_group) {
 		const struct nh_group *nhg = rcu_dereference(nh->nh_grp);
 
-		return nhc_lookup_mpath(nhg, fib_flags, flp, nhsel);
+		if (nhg->mpath)
+			return nhc_lookup_mpath(nhg, fib_flags, flp, nhsel);
+
+		return nhc_lookup_ab(nhg, fib_flags, flp, nhsel);
 	}
 
 	return nhc_lookup_single(nh, fib_flags, flp, nhsel);
@@ -647,6 +738,15 @@ static bool nh_uses_dev_single(const struct nexthop *nh,
 	return nhc_l3mdev_matches_dev(&nhi->fib_nhc, dev);
 }
 
+/* active-backup only looks at primary */
+static bool nh_uses_dev_ab(const struct nh_group *nhg,
+			   const struct net_device *dev)
+{
+	struct nexthop *nhe = nhg->nh_entries[0].nh;
+
+	return nh_uses_dev_single(nhe, dev);
+}
+
 static bool nh_uses_dev_mpath(const struct nh_group *nhg,
 			      const struct net_device *dev)
 {
@@ -655,8 +755,15 @@ static bool nh_uses_dev_mpath(const struct nh_group *nhg,
 	for (i = 0; i < nhg->num_nh; i++) {
 		struct nexthop *nhe = nhg->nh_entries[i].nh;
 
-		if (nh_uses_dev_single(nhe, dev))
+		if (nhe->is_group) {
+			const struct nh_group *nhg_ab;
+
+			nhg_ab = rcu_dereference(nhe->nh_grp);
+			if (nh_uses_dev_ab(nhg_ab, dev))
+				return true;
+		} else if (nh_uses_dev_single(nhe, dev)) {
 			return true;
+		}
 	}
 
 	return false;
@@ -667,7 +774,9 @@ bool nexthop_uses_dev(const struct nexthop *nh, const struct net_device *dev)
 	if (nh->is_group) {
 		const struct nh_group *nhg = rcu_dereference(nh->nh_grp);
 
-		return nh_uses_dev_mpath(nhg, dev);
+		if (nhg->mpath)
+			return nh_uses_dev_mpath(nhg, dev);
+		return nh_uses_dev_ab(nhg, dev);
 	}
 
 	return nh_uses_dev_single(nh, dev);
@@ -684,6 +793,28 @@ static int nexthop_fib6_nh_cb(struct nexthop *nh,
 	return cb(&nhi->fib6_nh, arg);
 }
 
+static int nexthop_fib6_ab_nhg_cb(struct nh_group *nhg, bool primary_only,
+				  int (*cb)(struct fib6_nh *nh, void *arg),
+				  void *arg)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < nhg->num_nh; i++) {
+		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+		struct nexthop *nh = nhge->nh;
+
+		err = nexthop_fib6_nh_cb(nh, cb, arg);
+		if (err)
+			return err;
+
+		if (primary_only)
+			break;
+	}
+
+	return 0;
+}
+
 static int nexthop_fib6_nhg_cb(struct nh_group *nhg, bool primary_only,
 			       int (*cb)(struct fib6_nh *nh, void *arg),
 			       void *arg)
@@ -695,7 +826,17 @@ static int nexthop_fib6_nhg_cb(struct nh_group *nhg, bool primary_only,
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
 		struct nexthop *nh = nhge->nh;
 
-		err = nexthop_fib6_nh_cb(nh, cb, arg);
+		if (unlikely(nh->is_group)) {
+			struct nh_group *nhg2;
+
+			nhg2 = rcu_dereference(nh->nh_grp);
+			/* group in group is active/backup */
+			err = nexthop_fib6_ab_nhg_cb(nhg2, primary_only,
+						     cb, arg);
+		} else {
+			err = nexthop_fib6_nh_cb(nh, cb, arg);
+		}
+
 		if (err)
 			return err;
 	}
@@ -899,6 +1040,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 
 	newg->has_v4 = nhg->has_v4;
 	newg->mpath = nhg->mpath;
+	newg->active_backup = nhg->active_backup;
 	newg->num_nh = nhg->num_nh;
 
 	/* copy old entries to new except the one getting removed */
@@ -941,7 +1083,8 @@ static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
 	synchronize_rcu();
 }
 
-static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
+static void remove_nexthop_group(struct net *net, struct nexthop *nh,
+				 struct nl_info *nlinfo)
 {
 	struct nh_group *nhg = rcu_dereference_rtnl(nh->nh_grp);
 	int i, num_nh = nhg->num_nh;
@@ -954,6 +1097,9 @@ static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
 
 		list_del_init(&nhge->nh_list);
 	}
+
+	if (nhg->active_backup)
+		remove_nexthop_from_groups(net, nh, nlinfo);
 }
 
 /* not called for nexthop replace */
@@ -987,7 +1133,7 @@ static void __remove_nexthop(struct net *net, struct nexthop *nh,
 	__remove_nexthop_fib(net, nh);
 
 	if (nh->is_group) {
-		remove_nexthop_group(nh, nlinfo);
+		remove_nexthop_group(net, nh, nlinfo);
 	} else {
 		struct nh_info *nhi;
 
@@ -1043,6 +1189,11 @@ static int replace_nexthop_grp(struct net *net, struct nexthop *old,
 	oldg = rtnl_dereference(old->nh_grp);
 	newg = rtnl_dereference(new->nh_grp);
 
+	if (oldg->active_backup ^ newg->active_backup) {
+		NL_SET_ERR_MSG(extack, "Can not change group type with replace");
+		return -EINVAL;
+	}
+
 	/* update parents - used by nexthop code for cleanup */
 	for (i = 0; i < newg->num_nh; i++)
 		newg->nh_entries[i].nh_parent = old;
@@ -1330,6 +1481,9 @@ static struct nexthop *nexthop_create_group(struct net *net,
 	if (cfg->nh_fdb)
 		nh->is_fdb_nh = 1;
 
+	if (cfg->nh_grp_type == NEXTHOP_GRP_TYPE_ACTIVE_BACKUP)
+		nhg->active_backup = 1;
+
 	rcu_assign_pointer(nh->nh_grp, nhg);
 
 	return nh;
@@ -1594,7 +1748,7 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 			NL_SET_ERR_MSG(extack, "Invalid group type");
 			goto out;
 		}
-		err = nh_check_attr_group(net, tb, extack);
+		err = nh_check_attr_group(net, tb, cfg->nh_grp_type, extack);
 
 		/* no other attributes should be set */
 		goto out;
-- 
2.21.1 (Apple Git-122.3)

