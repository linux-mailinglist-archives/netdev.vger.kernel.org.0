Return-Path: <netdev+bounces-10253-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8C9472D381
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:50:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2FEF1C20B54
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B9E2340B;
	Mon, 12 Jun 2023 21:49:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD28B23418
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E370C433A4;
	Mon, 12 Jun 2023 21:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686606591;
	bh=PwJ08kwU4EcKNOjnjQ2iTefbGmnMhoeiAYbbf1UAKxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfoQspIEqw5n2sJdnjNZ4jkK1JfvQ7WvFd19NTo54kZLncGALLumPaCPXAwGNFiL8
	 giizW3dE/x4XTwOPwq4roU7XtLpw409yTIxTlYGLLPeJOP/GYMKwT3HjNb3uNseFsi
	 xHZNIPXY1RAa2NAvDaFbnccq/56G+gjSHM6hfH1qpxbP+X+14/9K38T1eX1MSsXic5
	 9b9/maqauYxksErFboUUidqWAvd95CYOw/e+fy15E0t2icRLmlb1brka+dHWu+RIYK
	 dJ28XeNraJtSwkhmEuZWPjuZ0yyQ+R9SHh+rwSgFE987qGd3F/l2KGlqAUl8fb1+bF
	 K5m8yYxFTBh9w==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	dsahern@gmail.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/2] net: create device lookup API with reference tracking
Date: Mon, 12 Jun 2023 14:49:43 -0700
Message-Id: <20230612214944.1837648-2-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612214944.1837648-1-kuba@kernel.org>
References: <20230612214944.1837648-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New users of dev_get_by_index() and dev_get_by_name() keep
getting added and it would be nice to steer them towards
the APIs with reference tracking.

Add variants of those calls which allocate the reference
tracker and use them in a couple of places.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2:
 - convert intermediate dev_put() -> netdev_put() in ethtool
v1: https://lore.kernel.org/all/20230609183207.1466075-1-kuba@kernel.org/
---
 include/linux/netdevice.h |  4 +++
 net/core/dev.c            | 75 ++++++++++++++++++++++++++-------------
 net/ethtool/netlink.c     | 10 +++---
 net/ipv6/route.c          | 12 +++----
 4 files changed, 66 insertions(+), 35 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2d6cb2bf2f05..acf706d49c2b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3124,6 +3124,10 @@ struct net_device *netdev_sk_get_lowest_dev(struct net_device *dev,
 					    struct sock *sk);
 struct net_device *dev_get_by_index(struct net *net, int ifindex);
 struct net_device *__dev_get_by_index(struct net *net, int ifindex);
+struct net_device *netdev_get_by_index(struct net *net, int ifindex,
+				       netdevice_tracker *tracker, gfp_t gfp);
+struct net_device *netdev_get_by_name(struct net *net, const char *name,
+				      netdevice_tracker *tracker, gfp_t gfp);
 struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex);
 struct net_device *dev_get_by_napi_id(unsigned int napi_id);
 int dev_restart(struct net_device *dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index c2456b3667fe..63abb0463c24 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -758,18 +758,7 @@ struct net_device *dev_get_by_name_rcu(struct net *net, const char *name)
 }
 EXPORT_SYMBOL(dev_get_by_name_rcu);
 
-/**
- *	dev_get_by_name		- find a device by its name
- *	@net: the applicable net namespace
- *	@name: name to find
- *
- *	Find an interface by name. This can be called from any
- *	context and does its own locking. The returned handle has
- *	the usage count incremented and the caller must use dev_put() to
- *	release it when it is no longer needed. %NULL is returned if no
- *	matching device is found.
- */
-
+/* Deprecated for new users, call netdev_get_by_name() instead */
 struct net_device *dev_get_by_name(struct net *net, const char *name)
 {
 	struct net_device *dev;
@@ -782,6 +771,31 @@ struct net_device *dev_get_by_name(struct net *net, const char *name)
 }
 EXPORT_SYMBOL(dev_get_by_name);
 
+/**
+ *	netdev_get_by_name() - find a device by its name
+ *	@net: the applicable net namespace
+ *	@name: name to find
+ *	@tracker: tracking object for the acquired reference
+ *	@gfp: allocation flags for the tracker
+ *
+ *	Find an interface by name. This can be called from any
+ *	context and does its own locking. The returned handle has
+ *	the usage count incremented and the caller must use netdev_put() to
+ *	release it when it is no longer needed. %NULL is returned if no
+ *	matching device is found.
+ */
+struct net_device *netdev_get_by_name(struct net *net, const char *name,
+				      netdevice_tracker *tracker, gfp_t gfp)
+{
+	struct net_device *dev;
+
+	dev = dev_get_by_name(net, name);
+	if (dev)
+		netdev_tracker_alloc(dev, tracker, gfp);
+	return dev;
+}
+EXPORT_SYMBOL(netdev_get_by_name);
+
 /**
  *	__dev_get_by_index - find a device by its ifindex
  *	@net: the applicable net namespace
@@ -831,18 +845,7 @@ struct net_device *dev_get_by_index_rcu(struct net *net, int ifindex)
 }
 EXPORT_SYMBOL(dev_get_by_index_rcu);
 
-
-/**
- *	dev_get_by_index - find a device by its ifindex
- *	@net: the applicable net namespace
- *	@ifindex: index of device
- *
- *	Search for an interface by index. Returns NULL if the device
- *	is not found or a pointer to the device. The device returned has
- *	had a reference added and the pointer is safe until the user calls
- *	dev_put to indicate they have finished with it.
- */
-
+/* Deprecated for new users, call netdev_get_by_index() instead */
 struct net_device *dev_get_by_index(struct net *net, int ifindex)
 {
 	struct net_device *dev;
@@ -855,6 +858,30 @@ struct net_device *dev_get_by_index(struct net *net, int ifindex)
 }
 EXPORT_SYMBOL(dev_get_by_index);
 
+/**
+ *	netdev_get_by_index() - find a device by its ifindex
+ *	@net: the applicable net namespace
+ *	@ifindex: index of device
+ *	@tracker: tracking object for the acquired reference
+ *	@gfp: allocation flags for the tracker
+ *
+ *	Search for an interface by index. Returns NULL if the device
+ *	is not found or a pointer to the device. The device returned has
+ *	had a reference added and the pointer is safe until the user calls
+ *	netdev_put() to indicate they have finished with it.
+ */
+struct net_device *netdev_get_by_index(struct net *net, int ifindex,
+				       netdevice_tracker *tracker, gfp_t gfp)
+{
+	struct net_device *dev;
+
+	dev = dev_get_by_index(net, ifindex);
+	if (dev)
+		netdev_tracker_alloc(dev, tracker, gfp);
+	return dev;
+}
+EXPORT_SYMBOL(netdev_get_by_index);
+
 /**
  *	dev_get_by_napi_id - find a device by napi_id
  *	@napi_id: ID of the NAPI struct
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 5dd5e8222c45..39a459b0111b 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -115,7 +115,8 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 	if (tb[ETHTOOL_A_HEADER_DEV_INDEX]) {
 		u32 ifindex = nla_get_u32(tb[ETHTOOL_A_HEADER_DEV_INDEX]);
 
-		dev = dev_get_by_index(net, ifindex);
+		dev = netdev_get_by_index(net, ifindex, &req_info->dev_tracker,
+					  GFP_KERNEL);
 		if (!dev) {
 			NL_SET_ERR_MSG_ATTR(extack,
 					    tb[ETHTOOL_A_HEADER_DEV_INDEX],
@@ -125,13 +126,14 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 		/* if both ifindex and ifname are passed, they must match */
 		if (devname_attr &&
 		    strncmp(dev->name, nla_data(devname_attr), IFNAMSIZ)) {
-			dev_put(dev);
+			netdev_put(dev, &req_info->dev_tracker);
 			NL_SET_ERR_MSG_ATTR(extack, header,
 					    "ifindex and name do not match");
 			return -ENODEV;
 		}
 	} else if (devname_attr) {
-		dev = dev_get_by_name(net, nla_data(devname_attr));
+		dev = netdev_get_by_name(net, nla_data(devname_attr),
+					 &req_info->dev_tracker, GFP_KERNEL);
 		if (!dev) {
 			NL_SET_ERR_MSG_ATTR(extack, devname_attr,
 					    "no device matches name");
@@ -144,8 +146,6 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 	}
 
 	req_info->dev = dev;
-	if (dev)
-		netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
 	req_info->flags = flags;
 	return 0;
 }
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 392aaa373b66..e510a4162ef8 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3503,6 +3503,7 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 		 struct fib6_config *cfg, gfp_t gfp_flags,
 		 struct netlink_ext_ack *extack)
 {
+	netdevice_tracker *dev_tracker = &fib6_nh->fib_nh_dev_tracker;
 	struct net_device *dev = NULL;
 	struct inet6_dev *idev = NULL;
 	int addr_type;
@@ -3520,7 +3521,8 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 
 	err = -ENODEV;
 	if (cfg->fc_ifindex) {
-		dev = dev_get_by_index(net, cfg->fc_ifindex);
+		dev = netdev_get_by_index(net, cfg->fc_ifindex,
+					  dev_tracker, gfp_flags);
 		if (!dev)
 			goto out;
 		idev = in6_dev_get(dev);
@@ -3554,11 +3556,11 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 		/* hold loopback dev/idev if we haven't done so. */
 		if (dev != net->loopback_dev) {
 			if (dev) {
-				dev_put(dev);
+				netdev_put(dev, dev_tracker);
 				in6_dev_put(idev);
 			}
 			dev = net->loopback_dev;
-			dev_hold(dev);
+			netdev_hold(dev, dev_tracker, gfp_flags);
 			idev = in6_dev_get(dev);
 			if (!idev) {
 				err = -ENODEV;
@@ -3610,8 +3612,6 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	}
 
 	fib6_nh->fib_nh_dev = dev;
-	netdev_tracker_alloc(dev, &fib6_nh->fib_nh_dev_tracker, gfp_flags);
-
 	fib6_nh->fib_nh_oif = dev->ifindex;
 	err = 0;
 out:
@@ -3621,7 +3621,7 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 	if (err) {
 		lwtstate_put(fib6_nh->fib_nh_lws);
 		fib6_nh->fib_nh_lws = NULL;
-		dev_put(dev);
+		netdev_put(dev, dev_tracker);
 	}
 
 	return err;
-- 
2.40.1


