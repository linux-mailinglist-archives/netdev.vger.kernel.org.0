Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FE71C4991
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 00:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgEDW2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 18:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgEDW2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 18:28:30 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED315C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 15:28:29 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w3so370174plz.5
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 15:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gZxwmcOnYI8K1qxp5F3nQ8jlL3utLOPCQfqA68jQdYU=;
        b=dLvpVxEChsNmj9/ihurFXdnxwmRwBzi1lvOqMWfbMGOt1Q9LG6GV91kairi04y3I8H
         xOTSKIrKykSd+xm5tnZiIEJIPHfIEBeaoi9Pc+S5dN+zkPJD4RHd0oDcFWFWZGgn6pGM
         XqiP5Pxnk+DrHecJaMa6dmJpc9eyeC/Yb52ME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gZxwmcOnYI8K1qxp5F3nQ8jlL3utLOPCQfqA68jQdYU=;
        b=q1eO4JF1VbXBZ9QwgP136eB0jm9EcKWG1aj/2dyRqN3D3hz3GOoez9wiSg7UMQsbwT
         6amL3Dup1yZvMmsxTrX+A8+TlU4DbusC26OFmuSdrxRzlXeDIboAchCpzoFMbvPqYQ5B
         afbMtTghZsISkJbNl6nKI7sREAWgCrMfLJUZ8cyfSz1ttvpTQ1jvLLpjvclSKluvRYyv
         jchuaZsfCTo4h0dduV6Jg6VBHPR/m6Xj1NArXHxLT7r6z8hHodn/oJ49oc0vxIa5d/Mb
         37EVVvdvW1ninKRDIaZFaIqCJgPDwy3Ij52g31tyIKoeOSMdL9P1efVNwC5jjBTg1Tgk
         4IuQ==
X-Gm-Message-State: AGi0PuawrBDLkumnzm2nQUDkHnLjW01Q81UsICY5cB2uLPh33JqP+wOv
        K7cciDAAhGpt2VbOHYbA+Uiggw==
X-Google-Smtp-Source: APiQypKM5nrZJvXf6jCzpm1yaGBXeW4CV8jIkVDK0Gtki6UzH4ZPzIXGqyyh1cGkvzWmIKj/M9cAOA==
X-Received: by 2002:a17:902:ed4a:: with SMTP id y10mr249362plb.227.1588631309359;
        Mon, 04 May 2020 15:28:29 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id ie17sm21213pjb.19.2020.05.04.15.28.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 15:28:28 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        idosch@mellanox.com, jiri@mellanox.com, petrm@mellanox.com
Subject: [RFC PATCH net-next 1/5] nexthop: support for fdb ecmp nexthops
Date:   Mon,  4 May 2020 15:28:17 -0700
Message-Id: <1588631301-21564-2-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
References: <1588631301-21564-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

This patch introduces ecmp nexthops and nexthop groups
for mac fdb entries. In subsequent patches this is used
by the vxlan driver fdb entries. The use case is
E-VPN multihoming [1,2,3] which requires bridged vxlan traffic
to be load balanced to remote switches (vteps) belonging to
the same multi-homed ethernet segment (This is analogous to
a multi-homed LAG but over vxlan).

Changes include new nexthop flag NHA_FDB for nexthops
referenced by fdb entries. These nexthops only have ip.
This patch includes appropriate checks to avoid routes
referencing such nexthops.

example:
$ip nexthop add id 12 via 172.16.1.2 fdb
$ip nexthop add id 13 via 172.16.1.3 fdb
$ip nexthop add id 102 group 12/13 fdb

$bridge fdb add 02:02:00:00:00:13 dev vxlan1000 nhid 101 self

[1] E-VPN https://tools.ietf.org/html/rfc7432
[2] E-VPN VxLAN: https://tools.ietf.org/html/rfc8365
[3] LPC talk with mention of nexthop groups for L2 ecmp
http://vger.kernel.org/lpc_net2018_talks/scaling_bridge_fdb_database_slidesV3.pdf

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 include/net/nexthop.h        |  14 ++++++
 include/uapi/linux/nexthop.h |   1 +
 net/ipv4/nexthop.c           | 101 +++++++++++++++++++++++++++++++++----------
 3 files changed, 93 insertions(+), 23 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index c440ccc..3ad4e97 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -26,6 +26,7 @@ struct nh_config {
 	u8		nh_family;
 	u8		nh_protocol;
 	u8		nh_blackhole;
+	u8		nh_fdb;
 	u32		nh_flags;
 
 	int		nh_ifindex;
@@ -52,6 +53,7 @@ struct nh_info {
 
 	u8			family;
 	bool			reject_nh;
+	bool			fdb_nh;
 
 	union {
 		struct fib_nh_common	fib_nhc;
@@ -80,6 +82,7 @@ struct nexthop {
 	struct rb_node		rb_node;    /* entry on netns rbtree */
 	struct list_head	fi_list;    /* v4 entries using nh */
 	struct list_head	f6i_list;   /* v6 entries using nh */
+	struct list_head        fdb_list;   /* fdb entries using this nh */
 	struct list_head	grp_list;   /* nh group entries using this nh */
 	struct net		*net;
 
@@ -88,6 +91,7 @@ struct nexthop {
 	u8			protocol;   /* app managing this nh */
 	u8			nh_flags;
 	bool			is_group;
+	bool			is_fdb_nh;
 
 	refcount_t		refcnt;
 	struct rcu_head		rcu;
@@ -304,4 +308,14 @@ static inline void nexthop_path_fib6_result(struct fib6_result *res, int hash)
 int nexthop_for_each_fib6_nh(struct nexthop *nh,
 			     int (*cb)(struct fib6_nh *nh, void *arg),
 			     void *arg);
+
+static inline struct nh_info *nexthop_path_fdb(struct nexthop *nh,  u32 hash)
+{
+	struct nh_info *nhi;
+
+	nh = nexthop_select_path(nh, hash);
+	nhi = rcu_dereference(nh->nh_info);
+
+	return nhi;
+}
 #endif
diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
index 7b61867..19a234a 100644
--- a/include/uapi/linux/nexthop.h
+++ b/include/uapi/linux/nexthop.h
@@ -48,6 +48,7 @@ enum {
 	 */
 	NHA_GROUPS,	/* flag; only return nexthop groups in dump */
 	NHA_MASTER,	/* u32;  only return nexthops with given master dev */
+	NHA_FDB,	/* nexthop belongs to a bridge fdb */
 
 	__NHA_MAX,
 };
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 3957364..98f8d2a 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -33,6 +33,7 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
 	[NHA_ENCAP]		= { .type = NLA_NESTED },
 	[NHA_GROUPS]		= { .type = NLA_FLAG },
 	[NHA_MASTER]		= { .type = NLA_U32 },
+	[NHA_FDB]		= { .type = NLA_FLAG },
 };
 
 static unsigned int nh_dev_hashfn(unsigned int val)
@@ -107,6 +108,7 @@ static struct nexthop *nexthop_alloc(void)
 		INIT_LIST_HEAD(&nh->fi_list);
 		INIT_LIST_HEAD(&nh->f6i_list);
 		INIT_LIST_HEAD(&nh->grp_list);
+		INIT_LIST_HEAD(&nh->fdb_list);
 	}
 	return nh;
 }
@@ -227,6 +229,9 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 	if (nla_put_u32(skb, NHA_ID, nh->id))
 		goto nla_put_failure;
 
+	if (nh->is_fdb_nh && nla_put_flag(skb, NHA_FDB))
+		goto nla_put_failure;
+
 	if (nh->is_group) {
 		struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
 
@@ -241,7 +246,7 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 		if (nla_put_flag(skb, NHA_BLACKHOLE))
 			goto nla_put_failure;
 		goto out;
-	} else {
+	} else if (!nh->is_fdb_nh) {
 		const struct net_device *dev;
 
 		dev = nhi->fib_nhc.nhc_dev;
@@ -393,6 +398,7 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
 	unsigned int len = nla_len(tb[NHA_GROUP]);
 	struct nexthop_grp *nhg;
 	unsigned int i, j;
+	u8 nhg_fdb = 0;
 
 	if (len & (sizeof(struct nexthop_grp) - 1)) {
 		NL_SET_ERR_MSG(extack,
@@ -421,6 +427,8 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
 		}
 	}
 
+	if (tb[NHA_FDB])
+		nhg_fdb = 1;
 	nhg = nla_data(tb[NHA_GROUP]);
 	for (i = 0; i < len; ++i) {
 		struct nexthop *nh;
@@ -432,11 +440,16 @@ static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
 		}
 		if (!valid_group_nh(nh, len, extack))
 			return -EINVAL;
+		if (nhg_fdb && !nh->is_fdb_nh) {
+			NL_SET_ERR_MSG(extack, "FDB Multipath group can only have fdb nexthops");
+			return -EINVAL;
+		}
 	}
 	for (i = NHA_GROUP + 1; i < __NHA_MAX; ++i) {
 		if (!tb[i])
 			continue;
-
+		if (tb[NHA_FDB])
+			continue;
 		NL_SET_ERR_MSG(extack,
 			       "No other attributes can be set in nexthop groups");
 		return -EINVAL;
@@ -495,6 +508,9 @@ struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 		if (hash > atomic_read(&nhge->upper_bound))
 			continue;
 
+		if (nhge->nh->is_fdb_nh)
+			return nhge->nh;
+
 		/* nexthops always check if it is good and does
 		 * not rely on a sysctl for this behavior
 		 */
@@ -564,6 +580,11 @@ int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
 {
 	struct nh_info *nhi;
 
+	if (nh->is_fdb_nh) {
+		NL_SET_ERR_MSG(extack, "Route cannot point to a fdb nexthop");
+		return -EINVAL;
+	}
+
 	/* fib6_src is unique to a fib6_info and limits the ability to cache
 	 * routes in fib6_nh within a nexthop that is potentially shared
 	 * across multiple fib entries. If the config wants to use source
@@ -640,6 +661,12 @@ int fib_check_nexthop(struct nexthop *nh, u8 scope,
 {
 	int err = 0;
 
+	if (nh->is_fdb_nh) {
+		NL_SET_ERR_MSG(extack, "Route cannot point to a fdb nexthop");
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (nh->is_group) {
 		struct nh_group *nhg;
 
@@ -1125,6 +1152,9 @@ static struct nexthop *nexthop_create_group(struct net *net,
 		nh_group_rebalance(nhg);
 	}
 
+	if (cfg->nh_fdb)
+		nh->is_fdb_nh = 1;
+
 	rcu_assign_pointer(nh->nh_grp, nhg);
 
 	return nh;
@@ -1152,7 +1182,7 @@ static int nh_create_ipv4(struct net *net, struct nexthop *nh,
 		.fc_encap = cfg->nh_encap,
 		.fc_encap_type = cfg->nh_encap_type,
 	};
-	u32 tb_id = l3mdev_fib_table(cfg->dev);
+	u32 tb_id = (cfg->dev ? l3mdev_fib_table(cfg->dev) : RT_TABLE_MAIN);
 	int err;
 
 	err = fib_nh_init(net, fib_nh, &fib_cfg, 1, extack);
@@ -1161,6 +1191,9 @@ static int nh_create_ipv4(struct net *net, struct nexthop *nh,
 		goto out;
 	}
 
+	if (nh->is_fdb_nh)
+		goto out;
+
 	/* sets nh_dev if successful */
 	err = fib_check_nh(net, fib_nh, tb_id, 0, extack);
 	if (!err) {
@@ -1227,6 +1260,9 @@ static struct nexthop *nexthop_create(struct net *net, struct nh_config *cfg,
 	nhi->family = cfg->nh_family;
 	nhi->fib_nhc.nhc_scope = RT_SCOPE_LINK;
 
+	if (cfg->nh_fdb)
+		nh->is_fdb_nh = 1;
+
 	if (cfg->nh_blackhole) {
 		nhi->reject_nh = 1;
 		cfg->nh_ifindex = net->loopback_dev->ifindex;
@@ -1248,7 +1284,8 @@ static struct nexthop *nexthop_create(struct net *net, struct nh_config *cfg,
 	}
 
 	/* add the entry to the device based hash */
-	nexthop_devhash_add(net, nhi);
+	if (!nh->is_fdb_nh)
+		nexthop_devhash_add(net, nhi);
 
 	rcu_assign_pointer(nh->nh_info, nhi);
 
@@ -1367,6 +1404,9 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 			NL_SET_ERR_MSG(extack, "Invalid group type");
 			goto out;
 		}
+		if (tb[NHA_FDB])
+			cfg->nh_fdb = nla_get_flag(tb[NHA_FDB]);
+
 		err = nh_check_attr_group(net, tb, extack);
 
 		/* no other attributes should be set */
@@ -1385,26 +1425,38 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 		goto out;
 	}
 
-	if (!tb[NHA_OIF]) {
-		NL_SET_ERR_MSG(extack, "Device attribute required for non-blackhole nexthops");
+	if (tb[NHA_FDB]) {
+		if (tb[NHA_OIF] ||
+		    tb[NHA_ENCAP]   || tb[NHA_ENCAP_TYPE]) {
+			NL_SET_ERR_MSG(extack, "Fdb attribute can not be used with encap or oif");
+			goto out;
+		}
+
+		cfg->nh_fdb = nla_get_flag(tb[NHA_FDB]);
+	}
+
+	if (!cfg->nh_fdb && !tb[NHA_OIF]) {
+		NL_SET_ERR_MSG(extack, "Device attribute required for non-blackhole and non-fdb nexthops");
 		goto out;
 	}
 
-	cfg->nh_ifindex = nla_get_u32(tb[NHA_OIF]);
-	if (cfg->nh_ifindex)
-		cfg->dev = __dev_get_by_index(net, cfg->nh_ifindex);
+	if (!cfg->nh_fdb && tb[NHA_OIF]) {
+		cfg->nh_ifindex = nla_get_u32(tb[NHA_OIF]);
+		if (cfg->nh_ifindex)
+			cfg->dev = __dev_get_by_index(net, cfg->nh_ifindex);
 
-	if (!cfg->dev) {
-		NL_SET_ERR_MSG(extack, "Invalid device index");
-		goto out;
-	} else if (!(cfg->dev->flags & IFF_UP)) {
-		NL_SET_ERR_MSG(extack, "Nexthop device is not up");
-		err = -ENETDOWN;
-		goto out;
-	} else if (!netif_carrier_ok(cfg->dev)) {
-		NL_SET_ERR_MSG(extack, "Carrier for nexthop device is down");
-		err = -ENETDOWN;
-		goto out;
+		if (!cfg->dev) {
+			NL_SET_ERR_MSG(extack, "Invalid device index");
+			goto out;
+		} else if (!(cfg->dev->flags & IFF_UP)) {
+			NL_SET_ERR_MSG(extack, "Nexthop device is not up");
+			err = -ENETDOWN;
+			goto out;
+		} else if (!netif_carrier_ok(cfg->dev)) {
+			NL_SET_ERR_MSG(extack, "Carrier for nexthop device is down");
+			err = -ENETDOWN;
+			goto out;
+		}
 	}
 
 	err = -EINVAL;
@@ -1633,7 +1685,7 @@ static bool nh_dump_filtered(struct nexthop *nh, int dev_idx, int master_idx,
 
 static int nh_valid_dump_req(const struct nlmsghdr *nlh, int *dev_idx,
 			     int *master_idx, bool *group_filter,
-			     struct netlink_callback *cb)
+			     bool *fdb_filter, struct netlink_callback *cb)
 {
 	struct netlink_ext_ack *extack = cb->extack;
 	struct nlattr *tb[NHA_MAX + 1];
@@ -1670,6 +1722,9 @@ static int nh_valid_dump_req(const struct nlmsghdr *nlh, int *dev_idx,
 		case NHA_GROUPS:
 			*group_filter = true;
 			break;
+		case NHA_FDB:
+			*fdb_filter = true;
+			break;
 		default:
 			NL_SET_ERR_MSG(extack, "Unsupported attribute in dump request");
 			return -EINVAL;
@@ -1688,17 +1743,17 @@ static int nh_valid_dump_req(const struct nlmsghdr *nlh, int *dev_idx,
 /* rtnl */
 static int rtm_dump_nexthop(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	bool group_filter = false, fdb_filter = false;
 	struct nhmsg *nhm = nlmsg_data(cb->nlh);
 	int dev_filter_idx = 0, master_idx = 0;
 	struct net *net = sock_net(skb->sk);
 	struct rb_root *root = &net->nexthop.rb_root;
-	bool group_filter = false;
 	struct rb_node *node;
 	int idx = 0, s_idx;
 	int err;
 
 	err = nh_valid_dump_req(cb->nlh, &dev_filter_idx, &master_idx,
-				&group_filter, cb);
+				&group_filter, &fdb_filter, cb);
 	if (err < 0)
 		return err;
 
-- 
2.1.4

