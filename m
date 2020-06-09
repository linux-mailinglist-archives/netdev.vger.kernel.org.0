Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420F31F2C2A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732993AbgFIAV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:21:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732281AbgFIAVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 20:21:25 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11CF2206C3;
        Tue,  9 Jun 2020 00:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591662084;
        bh=mMSpDQiYsZFFK73NCNGTCBJ0utpmEzO9tcP6w/09smM=;
        h=From:To:Cc:Subject:Date:From;
        b=fXLq72JSWQnCP58N1fLKyb/L4CzQuttsTKLbz/y+rt6O59i5PL/jo29rwAkhK6BEX
         MNFhU0NUakDjyv87mE5hB1hQ09WHNXgQOshoKa2wfuLq6yv/u+BKVRiDdakCO/6H+h
         C46E+PGLtg6aA7JhOp7OCYs0HB/OwfKiyyoN1Ng8=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH net] nexthops: Fix fdb labeling for groups
Date:   Mon,  8 Jun 2020 18:21:20 -0600
Message-Id: <20200609002120.16155-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fdb nexthops are marked with a flag. For standalone nexthops, a flag was
added to the nh_info struct. For groups that flag was added to struct
nexthop when it should have been added to the group information. Fix
by removing the flag from the nexthop struct and adding a flag to nh_group
that mirrors nh_info and is really only a caching of the individual types.
Add a helper, nexthop_is_fdb, for use by the vxlan code and fixup the
internal code to use the flag from either nh_info or nh_group.

Fixes: 38428d68719c ("nexthop: support for fdb ecmp nexthops")
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
Roopa: you have not submitted the iproute2 patch, so I can not run the
fdb selftests added to fib_nexthops.sh

 drivers/net/vxlan.c   |  2 +-
 include/net/nexthop.h | 17 ++++++++-
 net/ipv4/nexthop.c    | 81 +++++++++++++++++++++++++------------------
 3 files changed, 65 insertions(+), 35 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5bb448ae6c9c..24ea689516e4 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -876,7 +876,7 @@ static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
 			nh = NULL;
 			goto err_inval;
 		}
-		if (!nh->is_fdb_nh) {
+		if (!nexthop_is_fdb(nh)) {
 			NL_SET_ERR_MSG(extack, "Nexthop is not a fdb nexthop");
 			goto err_inval;
 		}
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index e4b55b43e907..3f9e0ca2dc4d 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -76,6 +76,7 @@ struct nh_group {
 	struct nh_group		*spare; /* spare group for removals */
 	u16			num_nh;
 	bool			mpath;
+	bool			fdb_nh;
 	bool			has_v4;
 	struct nh_grp_entry	nh_entries[];
 };
@@ -93,7 +94,6 @@ struct nexthop {
 	u8			protocol;   /* app managing this nh */
 	u8			nh_flags;
 	bool			is_group;
-	bool			is_fdb_nh;
 
 	refcount_t		refcnt;
 	struct rcu_head		rcu;
@@ -136,6 +136,21 @@ static inline bool nexthop_cmp(const struct nexthop *nh1,
 	return nh1 == nh2;
 }
 
+static inline bool nexthop_is_fdb(const struct nexthop *nh)
+{
+	if (nh->is_group) {
+		const struct nh_group *nh_grp;
+
+		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
+		return nh_grp->fdb_nh;
+	} else {
+		const struct nh_info *nhi;
+
+		nhi = rcu_dereference_rtnl(nh->nh_info);
+		return nhi->fdb_nh;
+	}
+}
+
 static inline bool nexthop_is_multipath(const struct nexthop *nh)
 {
 	if (nh->is_group) {
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 400a9f89ebdb..2807c6852471 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -247,12 +247,11 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 	if (nla_put_u32(skb, NHA_ID, nh->id))
 		goto nla_put_failure;
 
-	if (nh->is_fdb_nh && nla_put_flag(skb, NHA_FDB))
-		goto nla_put_failure;
-
 	if (nh->is_group) {
 		struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
 
+		if (nhg->fdb_nh && nla_put_flag(skb, NHA_FDB))
+			goto nla_put_failure;
 		if (nla_put_nh_group(skb, nhg))
 			goto nla_put_failure;
 		goto out;
@@ -264,7 +263,10 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 		if (nla_put_flag(skb, NHA_BLACKHOLE))
 			goto nla_put_failure;
 		goto out;
-	} else if (!nh->is_fdb_nh) {
+	} else if (nhi->fdb_nh) {
+		if (nla_put_flag(skb, NHA_FDB))
+			goto nla_put_failure;
+	} else {
 		const struct net_device *dev;
 
 		dev = nhi->fib_nhc.nhc_dev;
@@ -385,7 +387,7 @@ static void nexthop_notify(int event, struct nexthop *nh, struct nl_info *info)
 }
 
 static bool valid_group_nh(struct nexthop *nh, unsigned int npaths,
-			   struct netlink_ext_ack *extack)
+			   bool *is_fdb, struct netlink_ext_ack *extack)
 {
 	if (nh->is_group) {
 		struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
@@ -398,6 +400,7 @@ static bool valid_group_nh(struct nexthop *nh, unsigned int npaths,
 				       "Multipath group can not be a nexthop within a group");
 			return false;
 		}
+		*is_fdb = nhg->fdb_nh;
 	} else {
 		struct nh_info *nhi = rtnl_dereference(nh->nh_info);
 
@@ -406,6 +409,7 @@ static bool valid_group_nh(struct nexthop *nh, unsigned int npaths,
 				       "Blackhole nexthop can not be used in a group with more than 1 path");
 			return false;
 		}
+		*is_fdb = nhi->fdb_nh;
 	}
 
 	return true;
@@ -416,12 +420,13 @@ static int nh_check_attr_fdb_group(struct nexthop *nh, u8 *nh_family,
 {
 	struct nh_info *nhi;
 
-	if (!nh->is_fdb_nh) {
+	nhi = rtnl_dereference(nh->nh_info);
+
+	if (!nhi->fdb_nh) {
 		NL_SET_ERR_MSG(extack, "FDB nexthop group can only have fdb nexthops");
 		return -EINVAL;
 	}
 
-	nhi = rtnl_dereference(nh->nh_info);
 	if (*nh_family == AF_UNSPEC) {
 		*nh_family = nhi->family;
 	} else if (*nh_family != nhi->family) {
@@ -473,19 +478,20 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
 	nhg = nla_data(tb[NHA_GROUP]);
 	for (i = 0; i < len; ++i) {
 		struct nexthop *nh;
+		bool is_fdb_nh;
 
 		nh = nexthop_find_by_id(net, nhg[i].id);
 		if (!nh) {
 			NL_SET_ERR_MSG(extack, "Invalid nexthop id");
 			return -EINVAL;
 		}
-		if (!valid_group_nh(nh, len, extack))
+		if (!valid_group_nh(nh, len, &is_fdb_nh, extack))
 			return -EINVAL;
 
 		if (nhg_fdb && nh_check_attr_fdb_group(nh, &nh_family, extack))
 			return -EINVAL;
 
-		if (!nhg_fdb && nh->is_fdb_nh) {
+		if (!nhg_fdb && is_fdb_nh) {
 			NL_SET_ERR_MSG(extack, "Non FDB nexthop group cannot have fdb nexthops");
 			return -EINVAL;
 		}
@@ -553,13 +559,13 @@ struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 		if (hash > atomic_read(&nhge->upper_bound))
 			continue;
 
-		if (nhge->nh->is_fdb_nh)
+		nhi = rcu_dereference(nhge->nh->nh_info);
+		if (nhi->fdb_nh)
 			return nhge->nh;
 
 		/* nexthops always check if it is good and does
 		 * not rely on a sysctl for this behavior
 		 */
-		nhi = rcu_dereference(nhge->nh->nh_info);
 		switch (nhi->family) {
 		case AF_INET:
 			if (ipv4_good_nh(&nhi->fib_nh))
@@ -624,11 +630,7 @@ int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
 		       struct netlink_ext_ack *extack)
 {
 	struct nh_info *nhi;
-
-	if (nh->is_fdb_nh) {
-		NL_SET_ERR_MSG(extack, "Route cannot point to a fdb nexthop");
-		return -EINVAL;
-	}
+	bool is_fdb_nh;
 
 	/* fib6_src is unique to a fib6_info and limits the ability to cache
 	 * routes in fib6_nh within a nexthop that is potentially shared
@@ -645,10 +647,17 @@ int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
 		nhg = rtnl_dereference(nh->nh_grp);
 		if (nhg->has_v4)
 			goto no_v4_nh;
+		is_fdb_nh = nhg->fdb_nh;
 	} else {
 		nhi = rtnl_dereference(nh->nh_info);
 		if (nhi->family == AF_INET)
 			goto no_v4_nh;
+		is_fdb_nh = nhi->fdb_nh;
+	}
+
+	if (is_fdb_nh) {
+		NL_SET_ERR_MSG(extack, "Route cannot point to a fdb nexthop");
+		return -EINVAL;
 	}
 
 	return 0;
@@ -677,12 +686,9 @@ static int fib6_check_nh_list(struct nexthop *old, struct nexthop *new,
 	return fib6_check_nexthop(new, NULL, extack);
 }
 
-static int nexthop_check_scope(struct nexthop *nh, u8 scope,
+static int nexthop_check_scope(struct nh_info *nhi, u8 scope,
 			       struct netlink_ext_ack *extack)
 {
-	struct nh_info *nhi;
-
-	nhi = rtnl_dereference(nh->nh_info);
 	if (scope == RT_SCOPE_HOST && nhi->fib_nhc.nhc_gw_family) {
 		NL_SET_ERR_MSG(extack,
 			       "Route with host scope can not have a gateway");
@@ -704,29 +710,38 @@ static int nexthop_check_scope(struct nexthop *nh, u8 scope,
 int fib_check_nexthop(struct nexthop *nh, u8 scope,
 		      struct netlink_ext_ack *extack)
 {
+	struct nh_info *nhi;
 	int err = 0;
 
-	if (nh->is_fdb_nh) {
-		NL_SET_ERR_MSG(extack, "Route cannot point to a fdb nexthop");
-		err = -EINVAL;
-		goto out;
-	}
-
 	if (nh->is_group) {
 		struct nh_group *nhg;
 
+		nhg = rtnl_dereference(nh->nh_grp);
+		if (nhg->fdb_nh) {
+			NL_SET_ERR_MSG(extack, "Route cannot point to a fdb nexthop");
+			err = -EINVAL;
+			goto out;
+		}
+
 		if (scope == RT_SCOPE_HOST) {
 			NL_SET_ERR_MSG(extack, "Route with host scope can not have multiple nexthops");
 			err = -EINVAL;
 			goto out;
 		}
 
-		nhg = rtnl_dereference(nh->nh_grp);
 		/* all nexthops in a group have the same scope */
-		err = nexthop_check_scope(nhg->nh_entries[0].nh, scope, extack);
+		nhi = rtnl_dereference(nhg->nh_entries[0].nh->nh_info);
+		err = nexthop_check_scope(nhi, scope, extack);
 	} else {
-		err = nexthop_check_scope(nh, scope, extack);
+		nhi = rtnl_dereference(nh->nh_info);
+		if (nhi->fdb_nh) {
+			NL_SET_ERR_MSG(extack, "Route cannot point to a fdb nexthop");
+			err = -EINVAL;
+			goto out;
+		}
+		err = nexthop_check_scope(nhi, scope, extack);
 	}
+
 out:
 	return err;
 }
@@ -1216,7 +1231,7 @@ static struct nexthop *nexthop_create_group(struct net *net,
 	}
 
 	if (cfg->nh_fdb)
-		nh->is_fdb_nh = 1;
+		nhg->fdb_nh = 1;
 
 	rcu_assign_pointer(nh->nh_grp, nhg);
 
@@ -1255,7 +1270,7 @@ static int nh_create_ipv4(struct net *net, struct nexthop *nh,
 		goto out;
 	}
 
-	if (nh->is_fdb_nh)
+	if (nhi->fdb_nh)
 		goto out;
 
 	/* sets nh_dev if successful */
@@ -1326,7 +1341,7 @@ static struct nexthop *nexthop_create(struct net *net, struct nh_config *cfg,
 	nhi->fib_nhc.nhc_scope = RT_SCOPE_LINK;
 
 	if (cfg->nh_fdb)
-		nh->is_fdb_nh = 1;
+		nhi->fdb_nh = 1;
 
 	if (cfg->nh_blackhole) {
 		nhi->reject_nh = 1;
@@ -1349,7 +1364,7 @@ static struct nexthop *nexthop_create(struct net *net, struct nh_config *cfg,
 	}
 
 	/* add the entry to the device based hash */
-	if (!nh->is_fdb_nh)
+	if (!nhi->fdb_nh)
 		nexthop_devhash_add(net, nhi);
 
 	rcu_assign_pointer(nh->nh_info, nhi);
-- 
2.17.1

