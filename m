Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01D5D2A091
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404333AbfEXVnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404276AbfEXVnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 17:43:15 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3923A2184E;
        Fri, 24 May 2019 21:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558734194;
        bh=e4H/8UtvBwzKv+UZYM6q5Ydx1h8d5+LTxHpTGQz/IPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LI1Ioli57pR1zsMo/z9M5sqmrg8MhhOsKow1xw6VqHYSTRN5P7fwvfWadVQgyduB
         ojqDB0/50/zog+6+6sNtaGufN6ACSV+XqwlHoGh04MsnJ1xcm7zrfiOo1VLD/TW/Ye
         H8wqI2PqyLr62gYttDLY243bly5pTy2yXuRDse7E=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     sharpd@cumulusnetworks.com, sworley@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 2/6] net: Initial nexthop code
Date:   Fri, 24 May 2019 14:43:04 -0700
Message-Id: <20190524214308.18615-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190524214308.18615-1-dsahern@kernel.org>
References: <20190524214308.18615-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Barebones start point for nexthops. Implementation for RTM commands,
notifications, management of rbtree for holding nexthops by id, and
kernel side data structures for nexthops and nexthop config.

Nexthops are maintained in an rbtree sorted by id. Similar to routes,
nexthops are configured per namespace using netns_nexthop struct added
to struct net.

Nexthop notifications are sent when a nexthop is added or deleted,
but NOT if the delete is due to a device event or network namespace
teardown (which also involves device events). Applications are
expected to use the device down event to flush nexthops and any
routes used by the nexthops.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/net_namespace.h |   2 +
 include/net/netns/nexthop.h |  18 ++
 include/net/nexthop.h       |  88 ++++++
 net/ipv4/Makefile           |   2 +-
 net/ipv4/nexthop.c          | 722 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 831 insertions(+), 1 deletion(-)
 create mode 100644 include/net/netns/nexthop.h
 create mode 100644 include/net/nexthop.h
 create mode 100644 net/ipv4/nexthop.c

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 12689ddfc24c..abb4f92456e1 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -19,6 +19,7 @@
 #include <net/netns/packet.h>
 #include <net/netns/ipv4.h>
 #include <net/netns/ipv6.h>
+#include <net/netns/nexthop.h>
 #include <net/netns/ieee802154_6lowpan.h>
 #include <net/netns/sctp.h>
 #include <net/netns/dccp.h>
@@ -108,6 +109,7 @@ struct net {
 	struct netns_mib	mib;
 	struct netns_packet	packet;
 	struct netns_unix	unx;
+	struct netns_nexthop	nexthop;
 	struct netns_ipv4	ipv4;
 #if IS_ENABLED(CONFIG_IPV6)
 	struct netns_ipv6	ipv6;
diff --git a/include/net/netns/nexthop.h b/include/net/netns/nexthop.h
new file mode 100644
index 000000000000..c712ee5eebd9
--- /dev/null
+++ b/include/net/netns/nexthop.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * nexthops in net namespaces
+ */
+
+#ifndef __NETNS_NEXTHOP_H__
+#define __NETNS_NEXTHOP_H__
+
+#include <linux/rbtree.h>
+
+struct netns_nexthop {
+	struct rb_root		rb_root;	/* tree of nexthops by id */
+	struct hlist_head	*devhash;	/* nexthops by device */
+
+	unsigned int		seq;		/* protected by rtnl_mutex */
+	u32			last_id_allocated;
+};
+#endif
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
new file mode 100644
index 000000000000..18e1f512f866
--- /dev/null
+++ b/include/net/nexthop.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Generic nexthop implementation
+ *
+ * Copyright (c) 2017-19 Cumulus Networks
+ * Copyright (c) 2017-19 David Ahern <dsa@cumulusnetworks.com>
+ */
+
+#ifndef __LINUX_NEXTHOP_H
+#define __LINUX_NEXTHOP_H
+
+#include <linux/netdevice.h>
+#include <linux/types.h>
+#include <net/ip_fib.h>
+#include <net/netlink.h>
+
+#define NEXTHOP_VALID_USER_FLAGS RTNH_F_ONLINK
+
+struct nexthop;
+
+struct nh_config {
+	u32		nh_id;
+
+	u8		nh_family;
+	u8		nh_protocol;
+	u8		nh_blackhole;
+	u32		nh_flags;
+
+	int		nh_ifindex;
+	struct net_device *dev;
+
+	u32		nlflags;
+	struct nl_info	nlinfo;
+};
+
+struct nh_info {
+	struct hlist_node	dev_hash;    /* entry on netns devhash */
+	struct nexthop		*nh_parent;
+
+	u8			family;
+	bool			reject_nh;
+
+	union {
+		struct fib_nh_common	fib_nhc;
+	};
+};
+
+struct nexthop {
+	struct rb_node		rb_node;    /* entry on netns rbtree */
+	struct net		*net;
+
+	u32			id;
+
+	u8			protocol;   /* app managing this nh */
+	u8			nh_flags;
+
+	refcount_t		refcnt;
+	struct rcu_head		rcu;
+
+	union {
+		struct nh_info	__rcu *nh_info;
+	};
+};
+
+/* caller is holding rcu or rtnl; no reference taken to nexthop */
+struct nexthop *nexthop_find_by_id(struct net *net, u32 id);
+void nexthop_free_rcu(struct rcu_head *head);
+
+static inline bool nexthop_get(struct nexthop *nh)
+{
+	return refcount_inc_not_zero(&nh->refcnt);
+}
+
+static inline void nexthop_put(struct nexthop *nh)
+{
+	if (refcount_dec_and_test(&nh->refcnt))
+		call_rcu(&nh->rcu, nexthop_free_rcu);
+}
+
+/* called with rcu lock */
+static inline bool nexthop_is_blackhole(const struct nexthop *nh)
+{
+	const struct nh_info *nhi;
+
+	nhi = rcu_dereference(nh->nh_info);
+	return nhi->reject_nh;
+}
+#endif
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 000a61994c8f..d57ecfaf89d4 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -14,7 +14,7 @@ obj-y     := route.o inetpeer.o protocol.o \
 	     udp_offload.o arp.o icmp.o devinet.o af_inet.o igmp.o \
 	     fib_frontend.o fib_semantics.o fib_trie.o fib_notifier.o \
 	     inet_fragment.o ping.o ip_tunnel_core.o gre_offload.o \
-	     metrics.o netlink.o
+	     metrics.o netlink.o nexthop.o
 
 obj-$(CONFIG_BPFILTER) += bpfilter/
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
new file mode 100644
index 000000000000..ec0ccf2ed873
--- /dev/null
+++ b/net/ipv4/nexthop.c
@@ -0,0 +1,722 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Generic nexthop implementation
+ *
+ * Copyright (c) 2017-19 Cumulus Networks
+ * Copyright (c) 2017-19 David Ahern <dsa@cumulusnetworks.com>
+ */
+
+#include <linux/nexthop.h>
+#include <linux/rtnetlink.h>
+#include <linux/slab.h>
+#include <net/nexthop.h>
+#include <net/sock.h>
+
+static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
+	[NHA_UNSPEC]		= { .strict_start_type = NHA_UNSPEC + 1 },
+	[NHA_ID]		= { .type = NLA_U32 },
+	[NHA_GROUP]		= { .type = NLA_BINARY },
+	[NHA_GROUP_TYPE]	= { .type = NLA_U16 },
+	[NHA_BLACKHOLE]		= { .type = NLA_FLAG },
+	[NHA_OIF]		= { .type = NLA_U32 },
+	[NHA_GATEWAY]		= { .type = NLA_BINARY },
+	[NHA_ENCAP_TYPE]	= { .type = NLA_U16 },
+	[NHA_ENCAP]		= { .type = NLA_NESTED },
+	[NHA_GROUPS]		= { .type = NLA_FLAG },
+	[NHA_MASTER]		= { .type = NLA_U32 },
+};
+
+void nexthop_free_rcu(struct rcu_head *head)
+{
+	struct nexthop *nh = container_of(head, struct nexthop, rcu);
+	struct nh_info *nhi;
+
+	nhi = rcu_dereference_raw(nh->nh_info);
+	kfree(nhi);
+
+	kfree(nh);
+}
+EXPORT_SYMBOL_GPL(nexthop_free_rcu);
+
+static struct nexthop *nexthop_alloc(void)
+{
+	struct nexthop *nh;
+
+	nh = kzalloc(sizeof(struct nexthop), GFP_KERNEL);
+	return nh;
+}
+
+static void nh_base_seq_inc(struct net *net)
+{
+	while (++net->nexthop.seq == 0)
+		;
+}
+
+/* no reference taken; rcu lock or rtnl must be held */
+struct nexthop *nexthop_find_by_id(struct net *net, u32 id)
+{
+	struct rb_node **pp, *parent = NULL, *next;
+
+	pp = &net->nexthop.rb_root.rb_node;
+	while (1) {
+		struct nexthop *nh;
+
+		next = rcu_dereference_raw(*pp);
+		if (!next)
+			break;
+		parent = next;
+
+		nh = rb_entry(parent, struct nexthop, rb_node);
+		if (id < nh->id)
+			pp = &next->rb_left;
+		else if (id > nh->id)
+			pp = &next->rb_right;
+		else
+			return nh;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nexthop_find_by_id);
+
+/* used for auto id allocation; called with rtnl held */
+static u32 nh_find_unused_id(struct net *net)
+{
+	u32 id_start = net->nexthop.last_id_allocated;
+
+	while (1) {
+		net->nexthop.last_id_allocated++;
+		if (net->nexthop.last_id_allocated == id_start)
+			break;
+
+		if (!nexthop_find_by_id(net, net->nexthop.last_id_allocated))
+			return net->nexthop.last_id_allocated;
+	}
+	return 0;
+}
+
+static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
+			int event, u32 portid, u32 seq, unsigned int nlflags)
+{
+	struct nlmsghdr *nlh;
+	struct nh_info *nhi;
+	struct nhmsg *nhm;
+
+	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*nhm), nlflags);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	nhm = nlmsg_data(nlh);
+	nhm->nh_family = AF_UNSPEC;
+	nhm->nh_flags = nh->nh_flags;
+	nhm->nh_protocol = nh->protocol;
+	nhm->nh_scope = 0;
+	nhm->resvd = 0;
+
+	if (nla_put_u32(skb, NHA_ID, nh->id))
+		goto nla_put_failure;
+
+	nhi = rtnl_dereference(nh->nh_info);
+	nhm->nh_family = nhi->family;
+	if (nhi->reject_nh) {
+		if (nla_put_flag(skb, NHA_BLACKHOLE))
+			goto nla_put_failure;
+		goto out;
+	}
+
+out:
+	nlmsg_end(skb, nlh);
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
+static size_t nh_nlmsg_size(struct nexthop *nh)
+{
+	size_t sz = nla_total_size(4);    /* NHA_ID */
+
+	/* covers NHA_BLACKHOLE since NHA_OIF and BLACKHOLE
+	 * are mutually exclusive
+	 */
+	sz += nla_total_size(4);  /* NHA_OIF */
+
+	return sz;
+}
+
+static void nexthop_notify(int event, struct nexthop *nh, struct nl_info *info)
+{
+	unsigned int nlflags = info->nlh ? info->nlh->nlmsg_flags : 0;
+	u32 seq = info->nlh ? info->nlh->nlmsg_seq : 0;
+	struct sk_buff *skb;
+	int err = -ENOBUFS;
+
+	skb = nlmsg_new(nh_nlmsg_size(nh), gfp_any());
+	if (!skb)
+		goto errout;
+
+	err = nh_fill_node(skb, nh, event, info->portid, seq, nlflags);
+	if (err < 0) {
+		/* -EMSGSIZE implies BUG in nh_nlmsg_size() */
+		WARN_ON(err == -EMSGSIZE);
+		kfree_skb(skb);
+		goto errout;
+	}
+
+	rtnl_notify(skb, info->nl_net, info->portid, RTNLGRP_NEXTHOP,
+		    info->nlh, gfp_any());
+	return;
+errout:
+	if (err < 0)
+		rtnl_set_sk_err(info->nl_net, RTNLGRP_NEXTHOP, err);
+}
+
+static void remove_nexthop(struct net *net, struct nexthop *nh,
+			   bool skip_fib, struct nl_info *nlinfo)
+{
+	/* remove from the tree */
+	rb_erase(&nh->rb_node, &net->nexthop.rb_root);
+
+	if (nlinfo)
+		nexthop_notify(RTM_DELNEXTHOP, nh, nlinfo);
+
+	nh_base_seq_inc(net);
+
+	nexthop_put(nh);
+}
+
+static int replace_nexthop(struct net *net, struct nexthop *old,
+			   struct nexthop *new, struct netlink_ext_ack *extack)
+{
+	return -EEXIST;
+}
+
+/* called with rtnl_lock held */
+static int insert_nexthop(struct net *net, struct nexthop *new_nh,
+			  struct nh_config *cfg, struct netlink_ext_ack *extack)
+{
+	struct rb_node **pp, *parent = NULL, *next;
+	struct rb_root *root = &net->nexthop.rb_root;
+	bool replace = !!(cfg->nlflags & NLM_F_REPLACE);
+	bool create = !!(cfg->nlflags & NLM_F_CREATE);
+	u32 new_id = new_nh->id;
+	int rc = -EEXIST;
+
+	pp = &root->rb_node;
+	while (1) {
+		struct nexthop *nh;
+
+		next = rtnl_dereference(*pp);
+		if (!next)
+			break;
+
+		parent = next;
+
+		nh = rb_entry(parent, struct nexthop, rb_node);
+		if (new_id < nh->id) {
+			pp = &next->rb_left;
+		} else if (new_id > nh->id) {
+			pp = &next->rb_right;
+		} else if (replace) {
+			rc = replace_nexthop(net, nh, new_nh, extack);
+			if (!rc)
+				new_nh = nh; /* send notification with old nh */
+			goto out;
+		} else {
+			/* id already exists and not a replace */
+			goto out;
+		}
+	}
+
+	if (replace && !create) {
+		NL_SET_ERR_MSG(extack, "Replace specified without create and no entry exists");
+		rc = -ENOENT;
+		goto out;
+	}
+
+	rb_link_node_rcu(&new_nh->rb_node, parent, pp);
+	rb_insert_color(&new_nh->rb_node, root);
+	rc = 0;
+out:
+	if (!rc) {
+		nh_base_seq_inc(net);
+		nexthop_notify(RTM_NEWNEXTHOP, new_nh, &cfg->nlinfo);
+	}
+
+	return rc;
+}
+
+/* rtnl; called when net namespace is deleted */
+static void flush_all_nexthops(struct net *net)
+{
+	struct rb_root *root = &net->nexthop.rb_root;
+	struct rb_node *node;
+	struct nexthop *nh;
+
+	while ((node = rb_first(root))) {
+		nh = rb_entry(node, struct nexthop, rb_node);
+		remove_nexthop(net, nh, false, NULL);
+		cond_resched();
+	}
+}
+
+static struct nexthop *nexthop_create(struct net *net, struct nh_config *cfg,
+				      struct netlink_ext_ack *extack)
+{
+	struct nh_info *nhi;
+	struct nexthop *nh;
+	int err = 0;
+
+	nh = nexthop_alloc();
+	if (!nh)
+		return ERR_PTR(-ENOMEM);
+
+	nhi = kzalloc(sizeof(*nhi), GFP_KERNEL);
+	if (!nhi) {
+		kfree(nh);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	nh->nh_flags = cfg->nh_flags;
+	nh->net = net;
+
+	nhi->nh_parent = nh;
+	nhi->family = cfg->nh_family;
+	nhi->fib_nhc.nhc_scope = RT_SCOPE_LINK;
+
+	if (cfg->nh_blackhole) {
+		nhi->reject_nh = 1;
+		cfg->nh_ifindex = net->loopback_dev->ifindex;
+	}
+
+	if (err) {
+		kfree(nhi);
+		kfree(nh);
+		return ERR_PTR(err);
+	}
+
+	rcu_assign_pointer(nh->nh_info, nhi);
+
+	return nh;
+}
+
+/* called with rtnl lock held */
+static struct nexthop *nexthop_add(struct net *net, struct nh_config *cfg,
+				   struct netlink_ext_ack *extack)
+{
+	struct nexthop *nh;
+	int err;
+
+	if (cfg->nlflags & NLM_F_REPLACE && !cfg->nh_id) {
+		NL_SET_ERR_MSG(extack, "Replace requires nexthop id");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (!cfg->nh_id) {
+		cfg->nh_id = nh_find_unused_id(net);
+		if (!cfg->nh_id) {
+			NL_SET_ERR_MSG(extack, "No unused id");
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	nh = nexthop_create(net, cfg, extack);
+	if (IS_ERR(nh))
+		return nh;
+
+	refcount_set(&nh->refcnt, 1);
+	nh->id = cfg->nh_id;
+	nh->protocol = cfg->nh_protocol;
+	nh->net = net;
+
+	err = insert_nexthop(net, nh, cfg, extack);
+	if (err) {
+		nexthop_put(nh);
+		nh = ERR_PTR(err);
+	}
+
+	return nh;
+}
+
+static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
+			    struct nlmsghdr *nlh, struct nh_config *cfg,
+			    struct netlink_ext_ack *extack)
+{
+	struct nhmsg *nhm = nlmsg_data(nlh);
+	struct nlattr *tb[NHA_MAX + 1];
+	int err;
+
+	err = nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
+			  extack);
+	if (err < 0)
+		return err;
+
+	err = -EINVAL;
+	if (nhm->resvd || nhm->nh_scope) {
+		NL_SET_ERR_MSG(extack, "Invalid values in ancillary header");
+		goto out;
+	}
+	if (nhm->nh_flags & ~NEXTHOP_VALID_USER_FLAGS) {
+		NL_SET_ERR_MSG(extack, "Invalid nexthop flags in ancillary header");
+		goto out;
+	}
+
+	switch (nhm->nh_family) {
+	default:
+		NL_SET_ERR_MSG(extack, "Invalid address family");
+		goto out;
+	}
+
+	if (tb[NHA_GROUPS] || tb[NHA_MASTER]) {
+		NL_SET_ERR_MSG(extack, "Invalid attributes in request");
+		goto out;
+	}
+
+	memset(cfg, 0, sizeof(*cfg));
+	cfg->nlflags = nlh->nlmsg_flags;
+	cfg->nlinfo.portid = NETLINK_CB(skb).portid;
+	cfg->nlinfo.nlh = nlh;
+	cfg->nlinfo.nl_net = net;
+
+	cfg->nh_family = nhm->nh_family;
+	cfg->nh_protocol = nhm->nh_protocol;
+	cfg->nh_flags = nhm->nh_flags;
+
+	if (tb[NHA_ID])
+		cfg->nh_id = nla_get_u32(tb[NHA_ID]);
+
+	if (tb[NHA_BLACKHOLE]) {
+		if (tb[NHA_GATEWAY] || tb[NHA_OIF]) {
+			NL_SET_ERR_MSG(extack, "Blackhole attribute can not be used with gateway or oif");
+			goto out;
+		}
+
+		cfg->nh_blackhole = 1;
+		err = 0;
+		goto out;
+	}
+
+	if (!tb[NHA_OIF]) {
+		NL_SET_ERR_MSG(extack, "Device attribute required for non-blackhole nexthops");
+		goto out;
+	}
+
+	cfg->nh_ifindex = nla_get_u32(tb[NHA_OIF]);
+	if (cfg->nh_ifindex)
+		cfg->dev = __dev_get_by_index(net, cfg->nh_ifindex);
+
+	if (!cfg->dev) {
+		NL_SET_ERR_MSG(extack, "Invalid device index");
+		goto out;
+	} else if (!(cfg->dev->flags & IFF_UP)) {
+		NL_SET_ERR_MSG(extack, "Nexthop device is not up");
+		err = -ENETDOWN;
+		goto out;
+	} else if (!netif_carrier_ok(cfg->dev)) {
+		NL_SET_ERR_MSG(extack, "Carrier for nexthop device is down");
+		err = -ENETDOWN;
+		goto out;
+	}
+
+	err = 0;
+out:
+	return err;
+}
+
+/* rtnl */
+static int rtm_new_nexthop(struct sk_buff *skb, struct nlmsghdr *nlh,
+			   struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nh_config cfg;
+	struct nexthop *nh;
+	int err;
+
+	err = rtm_to_nh_config(net, skb, nlh, &cfg, extack);
+	if (!err) {
+		nh = nexthop_add(net, &cfg, extack);
+		if (IS_ERR(nh))
+			err = PTR_ERR(nh);
+	}
+
+	return err;
+}
+
+static int nh_valid_get_del_req(struct nlmsghdr *nlh, u32 *id,
+				struct netlink_ext_ack *extack)
+{
+	struct nhmsg *nhm = nlmsg_data(nlh);
+	struct nlattr *tb[NHA_MAX + 1];
+	int err, i;
+
+	err = nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
+			  extack);
+	if (err < 0)
+		return err;
+
+	err = -EINVAL;
+	for (i = 0; i < __NHA_MAX; ++i) {
+		if (!tb[i])
+			continue;
+
+		switch (i) {
+		case NHA_ID:
+			break;
+		default:
+			NL_SET_ERR_MSG_ATTR(extack, tb[i],
+					    "Unexpected attribute in request");
+			goto out;
+		}
+	}
+	if (nhm->nh_protocol || nhm->resvd || nhm->nh_scope || nhm->nh_flags) {
+		NL_SET_ERR_MSG(extack, "Invalid values in header");
+		goto out;
+	}
+
+	if (!tb[NHA_ID]) {
+		NL_SET_ERR_MSG(extack, "Nexthop id is missing");
+		goto out;
+	}
+
+	*id = nla_get_u32(tb[NHA_ID]);
+	if (!(*id))
+		NL_SET_ERR_MSG(extack, "Invalid nexthop id");
+	else
+		err = 0;
+out:
+	return err;
+}
+
+/* rtnl */
+static int rtm_del_nexthop(struct sk_buff *skb, struct nlmsghdr *nlh,
+			   struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nl_info nlinfo = {
+		.nlh = nlh,
+		.nl_net = net,
+		.portid = NETLINK_CB(skb).portid,
+	};
+	struct nexthop *nh;
+	int err;
+	u32 id;
+
+	err = nh_valid_get_del_req(nlh, &id, extack);
+	if (err)
+		return err;
+
+	nh = nexthop_find_by_id(net, id);
+	if (!nh)
+		return -ENOENT;
+
+	remove_nexthop(net, nh, false, &nlinfo);
+
+	return 0;
+}
+
+/* rtnl */
+static int rtm_get_nexthop(struct sk_buff *in_skb, struct nlmsghdr *nlh,
+			   struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(in_skb->sk);
+	struct sk_buff *skb = NULL;
+	struct nexthop *nh;
+	int err;
+	u32 id;
+
+	err = nh_valid_get_del_req(nlh, &id, extack);
+	if (err)
+		return err;
+
+	err = -ENOBUFS;
+	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb)
+		goto out;
+
+	err = -ENOENT;
+	nh = nexthop_find_by_id(net, id);
+	if (!nh)
+		goto errout_free;
+
+	err = nh_fill_node(skb, nh, RTM_NEWNEXTHOP, NETLINK_CB(in_skb).portid,
+			   nlh->nlmsg_seq, 0);
+	if (err < 0) {
+		WARN_ON(err == -EMSGSIZE);
+		goto errout_free;
+	}
+
+	err = rtnl_unicast(skb, net, NETLINK_CB(in_skb).portid);
+out:
+	return err;
+errout_free:
+	kfree_skb(skb);
+	goto out;
+}
+
+static bool nh_dump_filtered(struct nexthop *nh, int dev_idx,
+			     int master_idx, u8 family)
+{
+	const struct net_device *dev;
+	const struct nh_info *nhi;
+
+	if (!dev_idx && !master_idx && !family)
+		return false;
+
+	nhi = rtnl_dereference(nh->nh_info);
+	if (family && nhi->family != family)
+		return true;
+
+	dev = nhi->fib_nhc.nhc_dev;
+	if (dev_idx && (!dev || dev->ifindex != dev_idx))
+		return true;
+
+	if (master_idx) {
+		struct net_device *master;
+
+		if (!dev)
+			return true;
+
+		master = netdev_master_upper_dev_get((struct net_device *)dev);
+		if (!master || master->ifindex != master_idx)
+			return true;
+	}
+
+	return false;
+}
+
+static int nh_valid_dump_req(const struct nlmsghdr *nlh,
+			     int *dev_idx, int *master_idx,
+			     struct netlink_callback *cb)
+{
+	struct netlink_ext_ack *extack = cb->extack;
+	struct nlattr *tb[NHA_MAX + 1];
+	struct nhmsg *nhm;
+	int err, i;
+	u32 idx;
+
+	err = nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
+			  NULL);
+	if (err < 0)
+		return err;
+
+	for (i = 0; i <= NHA_MAX; ++i) {
+		if (!tb[i])
+			continue;
+
+		switch (i) {
+		case NHA_OIF:
+			idx = nla_get_u32(tb[i]);
+			if (idx > INT_MAX) {
+				NL_SET_ERR_MSG(extack, "Invalid device index");
+				return -EINVAL;
+			}
+			*dev_idx = idx;
+			break;
+		case NHA_MASTER:
+			idx = nla_get_u32(tb[i]);
+			if (idx > INT_MAX) {
+				NL_SET_ERR_MSG(extack, "Invalid master device index");
+				return -EINVAL;
+			}
+			*master_idx = idx;
+			break;
+		default:
+			NL_SET_ERR_MSG(extack, "Unsupported attribute in dump request");
+			return -EINVAL;
+		}
+	}
+
+	nhm = nlmsg_data(nlh);
+	if (nhm->nh_protocol || nhm->resvd || nhm->nh_scope || nhm->nh_flags) {
+		NL_SET_ERR_MSG(extack, "Invalid values in header for nexthop dump request");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* rtnl */
+static int rtm_dump_nexthop(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct nhmsg *nhm = nlmsg_data(cb->nlh);
+	int dev_filter_idx = 0, master_idx = 0;
+	struct net *net = sock_net(skb->sk);
+	struct rb_root *root = &net->nexthop.rb_root;
+	struct rb_node *node;
+	int idx = 0, s_idx;
+	int err;
+
+	err = nh_valid_dump_req(cb->nlh, &dev_filter_idx, &master_idx, cb);
+	if (err < 0)
+		return err;
+
+	s_idx = cb->args[0];
+	for (node = rb_first(root); node; node = rb_next(node)) {
+		struct nexthop *nh;
+
+		if (idx < s_idx)
+			goto cont;
+
+		nh = rb_entry(node, struct nexthop, rb_node);
+		if (nh_dump_filtered(nh, dev_filter_idx, master_idx,
+				     nhm->nh_family))
+			goto cont;
+
+		err = nh_fill_node(skb, nh, RTM_NEWNEXTHOP,
+				   NETLINK_CB(cb->skb).portid,
+				   cb->nlh->nlmsg_seq, NLM_F_MULTI);
+		if (err < 0) {
+			if (likely(skb->len))
+				goto out;
+
+			goto out_err;
+		}
+cont:
+		idx++;
+	}
+
+out:
+	err = skb->len;
+out_err:
+	cb->args[0] = idx;
+	cb->seq = net->nexthop.seq;
+	nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+
+	return err;
+}
+
+static void __net_exit nexthop_net_exit(struct net *net)
+{
+	rtnl_lock();
+	flush_all_nexthops(net);
+	rtnl_unlock();
+}
+
+static int __net_init nexthop_net_init(struct net *net)
+{
+	net->nexthop.rb_root = RB_ROOT;
+
+	return 0;
+}
+
+static struct pernet_operations nexthop_net_ops = {
+	.init = nexthop_net_init,
+	.exit = nexthop_net_exit,
+};
+
+static int __init nexthop_init(void)
+{
+	register_pernet_subsys(&nexthop_net_ops);
+
+	rtnl_register(PF_UNSPEC, RTM_NEWNEXTHOP, rtm_new_nexthop, NULL, 0);
+	rtnl_register(PF_UNSPEC, RTM_DELNEXTHOP, rtm_del_nexthop, NULL, 0);
+	rtnl_register(PF_UNSPEC, RTM_GETNEXTHOP, rtm_get_nexthop,
+		      rtm_dump_nexthop, 0);
+
+	rtnl_register(PF_INET, RTM_NEWNEXTHOP, rtm_new_nexthop, NULL, 0);
+	rtnl_register(PF_INET, RTM_GETNEXTHOP, NULL, rtm_dump_nexthop, 0);
+
+	rtnl_register(PF_INET6, RTM_NEWNEXTHOP, rtm_new_nexthop, NULL, 0);
+	rtnl_register(PF_INET6, RTM_GETNEXTHOP, NULL, rtm_dump_nexthop, 0);
+
+	return 0;
+}
+subsys_initcall(nexthop_init);
-- 
2.11.0

