Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81AAC2A090
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404337AbfEXVnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:43:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404252AbfEXVnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 17:43:15 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BB2A21850;
        Fri, 24 May 2019 21:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558734194;
        bh=BH09J/5SAL48tMgDE8R/20od9kODTMLeJ/xId2gMzEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MV0t61pR+6YKM2VuRjs/EKDUmCN57UtjZ0S5NK9KwInwqEcDPP454VGE4hkABrKxv
         TVGA1Am9ksFKUuZbovaIFld9/BOuNckH/2EN/cEje01S1ax3ev3g4r/+vPz/4R0M/j
         k433NcomaZNnbRiu1k/6NmXTD9UB5fdkCUyGS0LI=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     sharpd@cumulusnetworks.com, sworley@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 3/6] nexthop: Add support for IPv4 nexthops
Date:   Fri, 24 May 2019 14:43:05 -0700
Message-Id: <20190524214308.18615-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190524214308.18615-1-dsahern@kernel.org>
References: <20190524214308.18615-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add support for IPv4 nexthops. If nh_family is set to AF_INET, then
NHA_GATEWAY is expected to be an IPv4 address.

Register for netdev events to be notified of admin up/down changes as
well as deletes. A hash table is used to track nexthop per devices to
quickly convert device events to the affected nexthops.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/nexthop.h |   5 ++
 net/ipv4/nexthop.c    | 208 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 213 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 18e1f512f866..c0e4b0d92c39 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -29,6 +29,10 @@ struct nh_config {
 	int		nh_ifindex;
 	struct net_device *dev;
 
+	union {
+		__be32		ipv4;
+	} gw;
+
 	u32		nlflags;
 	struct nl_info	nlinfo;
 };
@@ -42,6 +46,7 @@ struct nh_info {
 
 	union {
 		struct fib_nh_common	fib_nhc;
+		struct fib_nh		fib_nh;
 	};
 };
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index ec0ccf2ed873..79c7b3461e19 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -9,8 +9,12 @@
 #include <linux/rtnetlink.h>
 #include <linux/slab.h>
 #include <net/nexthop.h>
+#include <net/route.h>
 #include <net/sock.h>
 
+#define NH_DEV_HASHBITS  8
+#define NH_DEV_HASHSIZE (1U << NH_DEV_HASHBITS)
+
 static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
 	[NHA_UNSPEC]		= { .strict_start_type = NHA_UNSPEC + 1 },
 	[NHA_ID]		= { .type = NLA_U32 },
@@ -25,12 +29,39 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
 	[NHA_MASTER]		= { .type = NLA_U32 },
 };
 
+static unsigned int nh_dev_hashfn(unsigned int val)
+{
+	unsigned int mask = NH_DEV_HASHSIZE - 1;
+
+	return (val ^
+		(val >> NH_DEV_HASHBITS) ^
+		(val >> (NH_DEV_HASHBITS * 2))) & mask;
+}
+
+static void nexthop_devhash_add(struct net *net, struct nh_info *nhi)
+{
+	struct net_device *dev = nhi->fib_nhc.nhc_dev;
+	struct hlist_head *head;
+	unsigned int hash;
+
+	WARN_ON(!dev);
+
+	hash = nh_dev_hashfn(dev->ifindex);
+	head = &net->nexthop.devhash[hash];
+	hlist_add_head(&nhi->dev_hash, head);
+}
+
 void nexthop_free_rcu(struct rcu_head *head)
 {
 	struct nexthop *nh = container_of(head, struct nexthop, rcu);
 	struct nh_info *nhi;
 
 	nhi = rcu_dereference_raw(nh->nh_info);
+	switch (nhi->family) {
+	case AF_INET:
+		fib_nh_release(nh->net, &nhi->fib_nh);
+		break;
+	}
 	kfree(nhi);
 
 	kfree(nh);
@@ -96,6 +127,7 @@ static u32 nh_find_unused_id(struct net *net)
 static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 			int event, u32 portid, u32 seq, unsigned int nlflags)
 {
+	struct fib_nh *fib_nh;
 	struct nlmsghdr *nlh;
 	struct nh_info *nhi;
 	struct nhmsg *nhm;
@@ -120,6 +152,22 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 		if (nla_put_flag(skb, NHA_BLACKHOLE))
 			goto nla_put_failure;
 		goto out;
+	} else {
+		const struct net_device *dev;
+
+		dev = nhi->fib_nhc.nhc_dev;
+		if (dev && nla_put_u32(skb, NHA_OIF, dev->ifindex))
+			goto nla_put_failure;
+	}
+
+	nhm->nh_scope = nhi->fib_nhc.nhc_scope;
+	switch (nhi->family) {
+	case AF_INET:
+		fib_nh = &nhi->fib_nh;
+		if (fib_nh->fib_nh_gw_family &&
+		    nla_put_u32(skb, NHA_GATEWAY, fib_nh->fib_nh_gw4))
+			goto nla_put_failure;
+		break;
 	}
 
 out:
@@ -132,6 +180,7 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 
 static size_t nh_nlmsg_size(struct nexthop *nh)
 {
+	struct nh_info *nhi = rtnl_dereference(nh->nh_info);
 	size_t sz = nla_total_size(4);    /* NHA_ID */
 
 	/* covers NHA_BLACKHOLE since NHA_OIF and BLACKHOLE
@@ -139,6 +188,13 @@ static size_t nh_nlmsg_size(struct nexthop *nh)
 	 */
 	sz += nla_total_size(4);  /* NHA_OIF */
 
+	switch (nhi->family) {
+	case AF_INET:
+		if (nhi->fib_nh.fib_nh_gw_family)
+			sz += nla_total_size(4);  /* NHA_GATEWAY */
+		break;
+	}
+
 	return sz;
 }
 
@@ -169,6 +225,15 @@ static void nexthop_notify(int event, struct nexthop *nh, struct nl_info *info)
 		rtnl_set_sk_err(info->nl_net, RTNLGRP_NEXTHOP, err);
 }
 
+static void __remove_nexthop(struct net *net, struct nexthop *nh)
+{
+	struct nh_info *nhi;
+
+	nhi = rtnl_dereference(nh->nh_info);
+	if (nhi->fib_nhc.nhc_dev)
+		hlist_del(&nhi->dev_hash);
+}
+
 static void remove_nexthop(struct net *net, struct nexthop *nh,
 			   bool skip_fib, struct nl_info *nlinfo)
 {
@@ -178,6 +243,7 @@ static void remove_nexthop(struct net *net, struct nexthop *nh,
 	if (nlinfo)
 		nexthop_notify(RTM_DELNEXTHOP, nh, nlinfo);
 
+	__remove_nexthop(net, nh);
 	nh_base_seq_inc(net);
 
 	nexthop_put(nh);
@@ -244,6 +310,24 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 	return rc;
 }
 
+/* rtnl */
+/* remove all nexthops tied to a device being deleted */
+static void nexthop_flush_dev(struct net_device *dev)
+{
+	unsigned int hash = nh_dev_hashfn(dev->ifindex);
+	struct net *net = dev_net(dev);
+	struct hlist_head *head = &net->nexthop.devhash[hash];
+	struct hlist_node *n;
+	struct nh_info *nhi;
+
+	hlist_for_each_entry_safe(nhi, n, head, dev_hash) {
+		if (nhi->fib_nhc.nhc_dev != dev)
+			continue;
+
+		remove_nexthop(net, nhi->nh_parent, false, NULL);
+	}
+}
+
 /* rtnl; called when net namespace is deleted */
 static void flush_all_nexthops(struct net *net)
 {
@@ -258,6 +342,38 @@ static void flush_all_nexthops(struct net *net)
 	}
 }
 
+static int nh_create_ipv4(struct net *net, struct nexthop *nh,
+			  struct nh_info *nhi, struct nh_config *cfg,
+			  struct netlink_ext_ack *extack)
+{
+	struct fib_nh *fib_nh = &nhi->fib_nh;
+	struct fib_config fib_cfg = {
+		.fc_oif   = cfg->nh_ifindex,
+		.fc_gw4   = cfg->gw.ipv4,
+		.fc_gw_family = cfg->gw.ipv4 ? AF_INET : 0,
+		.fc_flags = cfg->nh_flags,
+	};
+	u32 tb_id = l3mdev_fib_table(cfg->dev);
+	int err = -EINVAL;
+
+	err = fib_nh_init(net, fib_nh, &fib_cfg, 1, extack);
+	if (err) {
+		fib_nh_release(net, fib_nh);
+		goto out;
+	}
+
+	/* sets nh_dev if successful */
+	err = fib_check_nh(net, fib_nh, tb_id, 0, extack);
+	if (!err) {
+		nh->nh_flags = fib_nh->fib_nh_flags;
+		fib_info_update_nh_saddr(net, fib_nh, fib_nh->fib_nh_scope);
+	} else {
+		fib_nh_release(net, fib_nh);
+	}
+out:
+	return err;
+}
+
 static struct nexthop *nexthop_create(struct net *net, struct nh_config *cfg,
 				      struct netlink_ext_ack *extack)
 {
@@ -287,12 +403,21 @@ static struct nexthop *nexthop_create(struct net *net, struct nh_config *cfg,
 		cfg->nh_ifindex = net->loopback_dev->ifindex;
 	}
 
+	switch (cfg->nh_family) {
+	case AF_INET:
+		err = nh_create_ipv4(net, nh, nhi, cfg, extack);
+		break;
+	}
+
 	if (err) {
 		kfree(nhi);
 		kfree(nh);
 		return ERR_PTR(err);
 	}
 
+	/* add the entry to the device based hash */
+	nexthop_devhash_add(net, nhi);
+
 	rcu_assign_pointer(nh->nh_info, nhi);
 
 	return nh;
@@ -329,6 +454,7 @@ static struct nexthop *nexthop_add(struct net *net, struct nh_config *cfg,
 
 	err = insert_nexthop(net, nh, cfg, extack);
 	if (err) {
+		__remove_nexthop(net, nh);
 		nexthop_put(nh);
 		nh = ERR_PTR(err);
 	}
@@ -360,6 +486,8 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 	}
 
 	switch (nhm->nh_family) {
+	case AF_INET:
+		break;
 	default:
 		NL_SET_ERR_MSG(extack, "Invalid address family");
 		goto out;
@@ -416,6 +544,32 @@ static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 		goto out;
 	}
 
+	err = -EINVAL;
+	if (tb[NHA_GATEWAY]) {
+		struct nlattr *gwa = tb[NHA_GATEWAY];
+
+		switch (cfg->nh_family) {
+		case AF_INET:
+			if (nla_len(gwa) != sizeof(u32)) {
+				NL_SET_ERR_MSG(extack, "Invalid gateway");
+				goto out;
+			}
+			cfg->gw.ipv4 = nla_get_be32(gwa);
+			break;
+		default:
+			NL_SET_ERR_MSG(extack,
+				       "Unknown address family for gateway");
+			goto out;
+		}
+	} else {
+		/* device only nexthop (no gateway) */
+		if (cfg->nh_flags & RTNH_F_ONLINK) {
+			NL_SET_ERR_MSG(extack,
+				       "ONLINK flag can not be set for nexthop without a gateway");
+			goto out;
+		}
+	}
+
 	err = 0;
 out:
 	return err;
@@ -683,16 +837,68 @@ static int rtm_dump_nexthop(struct sk_buff *skb, struct netlink_callback *cb)
 	return err;
 }
 
+static void nexthop_sync_mtu(struct net_device *dev, u32 orig_mtu)
+{
+	unsigned int hash = nh_dev_hashfn(dev->ifindex);
+	struct net *net = dev_net(dev);
+	struct hlist_head *head = &net->nexthop.devhash[hash];
+	struct hlist_node *n;
+	struct nh_info *nhi;
+
+	hlist_for_each_entry_safe(nhi, n, head, dev_hash) {
+		if (nhi->fib_nhc.nhc_dev == dev) {
+			if (nhi->family == AF_INET)
+				fib_nhc_update_mtu(&nhi->fib_nhc, dev->mtu,
+						   orig_mtu);
+		}
+	}
+}
+
+/* rtnl */
+static int nh_netdev_event(struct notifier_block *this,
+			   unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_info_ext *info_ext;
+
+	switch (event) {
+	case NETDEV_DOWN:
+	case NETDEV_UNREGISTER:
+		nexthop_flush_dev(dev);
+		break;
+	case NETDEV_CHANGE:
+		if (!(dev_get_flags(dev) & (IFF_RUNNING | IFF_LOWER_UP)))
+			nexthop_flush_dev(dev);
+		break;
+	case NETDEV_CHANGEMTU:
+		info_ext = ptr;
+		nexthop_sync_mtu(dev, info_ext->ext.mtu);
+		rt_cache_flush(dev_net(dev));
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block nh_netdev_notifier = {
+	.notifier_call = nh_netdev_event,
+};
+
 static void __net_exit nexthop_net_exit(struct net *net)
 {
 	rtnl_lock();
 	flush_all_nexthops(net);
 	rtnl_unlock();
+	kfree(net->nexthop.devhash);
 }
 
 static int __net_init nexthop_net_init(struct net *net)
 {
+	size_t sz = sizeof(struct hlist_head) * NH_DEV_HASHSIZE;
+
 	net->nexthop.rb_root = RB_ROOT;
+	net->nexthop.devhash = kzalloc(sz, GFP_KERNEL);
+	if (!net->nexthop.devhash)
+		return -ENOMEM;
 
 	return 0;
 }
@@ -706,6 +912,8 @@ static int __init nexthop_init(void)
 {
 	register_pernet_subsys(&nexthop_net_ops);
 
+	register_netdevice_notifier(&nh_netdev_notifier);
+
 	rtnl_register(PF_UNSPEC, RTM_NEWNEXTHOP, rtm_new_nexthop, NULL, 0);
 	rtnl_register(PF_UNSPEC, RTM_DELNEXTHOP, rtm_del_nexthop, NULL, 0);
 	rtnl_register(PF_UNSPEC, RTM_GETNEXTHOP, rtm_get_nexthop,
-- 
2.11.0

