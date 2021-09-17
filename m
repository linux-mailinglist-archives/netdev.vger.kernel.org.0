Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1A8410174
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 00:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344821AbhIQWnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 18:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344017AbhIQWnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 18:43:07 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93262C061574
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 15:41:44 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d11so10146800qtw.3
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 15:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nj8LH/WzCTrMVhIcQTzqI9IlBp0SZTOvh5C1TfhvIyY=;
        b=fAiM+II7IRfdhkwi8T+8kylR3aZkVcMlC0yonBU/6eOzzrFEfEnR3oTrUjWD5SmK7s
         iFzRxELIh9v6BXnwNnXGzmxJyNOjEd8ipWpdO5zxUC0bX1DaxMOkOl0lEWKqeP2BsHuH
         JAWlK1OPOw7AZSgf3Fh2JKvBwnNOsttso+FiWv5ekacXAIq48lMxA8GPXEPe9XA7eyz+
         mKcaty0l2asmFW85PGttk04+Jg07SKVPums756s+US92BisrVIMkXAEAf4/d6lUhL8H/
         yAba7wgkqkGyOsmhCGTXmK43u3NrvBgvIcIB+dmi3vLzJ/6D0qjYQo1oNSYs2/mM3g/M
         /uqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nj8LH/WzCTrMVhIcQTzqI9IlBp0SZTOvh5C1TfhvIyY=;
        b=N5h+BKI4ytUtpN/EDy6ULsl8T6jKTGMQwFyziWalN+Ff2Xct/yd0rJOs+IUPbOlvlp
         Z6CLYfqxcLMK/N8pVvCXh7EP6gCwz96k9O3pm0tt9lHCKJUiPndRy7WicjoXuticvvy6
         ItC98hSfKOvt1aqDcdDTmU0O4a7TyR1Do5+DWU/Ml5FR1QZ0QpRm4GAzGcCX59Xvcwya
         7TM7GsBvHBGXe0lntMl0edCs7Yti4JPV9WWHr/exwqu3Ghkzw7Fx3ODdl2vgkBX/GgoZ
         i7uUMaPb/gLIuTWMp1dX3Au5WGEkxFq115VrIXH5K6fy0lyeAQgg/pfHnwpA6b6LNwtH
         2aEw==
X-Gm-Message-State: AOAM530Zoh549C1uJmgL4aFVRmF5r2kPk3Xjjr4cD3YeYy3ioDe+S6r1
        A0bJyhmeshDPkjDoChzzIUj8fimpYw==
X-Google-Smtp-Source: ABdhPJxeA9oOrFjRRS813eexn7JrTLxjdKu5/PzCcxCCTPE5dI427cwtoPgWu2mbP0jxDdXSuFlc7w==
X-Received: by 2002:ac8:5d8a:: with SMTP id d10mr12382735qtx.225.1631918503328;
        Fri, 17 Sep 2021 15:41:43 -0700 (PDT)
Received: from ssuryadesk.lan ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id l5sm3541094qtq.4.2021.09.17.15.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 15:41:43 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [RFC PATCH net-next] ipmr: ip6mr: APIs to support adding more than MAXVIFS/MAXMIFS
Date:   Fri, 17 Sep 2021 18:41:23 -0400
Message-Id: <20210917224123.410009-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAXVIFS and MAXMIFS are too small (32) for certain applications. But
they are defined in user header files  So, use a different definition
CONFIG_IP_MROUTE_EXT_MAXVIFS that is configurable and different ioctl
requests (MRT_xyz_EXT and MRT6_xyz_EXT) as well as a different structure
for adding MFC (mfcctl_ext).

CONFIG_IP_MROUTE_EXT_MAXVIFS is bounded by the IF_SETSIZE (256) in
mroute6.h.

This patch is extending the following RFC:
http://patchwork.ozlabs.org/project/netdev/patch/m1eiis8uc6.fsf@fess.ebiederm.org/

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 include/linux/mroute_base.h  |  11 +---
 include/uapi/linux/mroute.h  |  14 ++++-
 include/uapi/linux/mroute6.h |   5 +-
 net/ipv4/Kconfig             |  11 ++++
 net/ipv4/ipmr.c              | 115 +++++++++++++++++++++++++++++------
 net/ipv4/ipmr_base.c         |   2 +-
 net/ipv6/ip6mr.c             |  52 +++++++++++-----
 7 files changed, 163 insertions(+), 47 deletions(-)

diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
index 8071148f29a6..85f3a8864044 100644
--- a/include/linux/mroute_base.h
+++ b/include/linux/mroute_base.h
@@ -89,13 +89,6 @@ static inline int mr_call_vif_notifiers(struct net *net,
 	return call_fib_notifiers(net, event_type, &info.info);
 }
 
-#ifndef MAXVIFS
-/* This one is nasty; value is defined in uapi using different symbols for
- * mroute and morute6 but both map into same 32.
- */
-#define MAXVIFS	32
-#endif
-
 #define VIF_EXISTS(_mrt, _idx) (!!((_mrt)->vif_table[_idx].dev))
 
 /* mfc_flags:
@@ -145,7 +138,7 @@ struct mr_mfc {
 			unsigned long pkt;
 			unsigned long wrong_if;
 			unsigned long lastuse;
-			unsigned char ttls[MAXVIFS];
+			unsigned char ttls[CONFIG_IP_MROUTE_EXT_MAXVIFS];
 			refcount_t refcount;
 		} res;
 	} mfc_un;
@@ -246,7 +239,7 @@ struct mr_table {
 	struct sock __rcu	*mroute_sk;
 	struct timer_list	ipmr_expire_timer;
 	struct list_head	mfc_unres_queue;
-	struct vif_device	vif_table[MAXVIFS];
+	struct vif_device	vif_table[CONFIG_IP_MROUTE_EXT_MAXVIFS];
 	struct rhltable		mfc_hash;
 	struct list_head	mfc_cache_list;
 	int			maxvif;
diff --git a/include/uapi/linux/mroute.h b/include/uapi/linux/mroute.h
index 1a42f5f9b31b..b28f46565a43 100644
--- a/include/uapi/linux/mroute.h
+++ b/include/uapi/linux/mroute.h
@@ -29,7 +29,10 @@
 #define MRT_ADD_MFC_PROXY	(MRT_BASE+10)	/* Add a (*,*|G) mfc entry	*/
 #define MRT_DEL_MFC_PROXY	(MRT_BASE+11)	/* Del a (*,*|G) mfc entry	*/
 #define MRT_FLUSH	(MRT_BASE+12)	/* Flush all mfc entries and/or vifs	*/
-#define MRT_MAX		(MRT_BASE+12)
+#define MRT_ADD_VIF_EXT	(MRT_BASE+13)	/* Add a virtual interface		*/
+#define MRT_ADD_MFC_EXT	(MRT_BASE+14)	/* Add a multicast forwarding entry	*/
+#define MRT_ADD_MFC_PROXY_EXT	(MRT_BASE+15)	/* Add a (*,*|G) mfc entry	*/
+#define MRT_MAX		(MRT_BASE+15)
 
 #define SIOCGETVIFCNT	SIOCPROTOPRIVATE	/* IP protocol privates */
 #define SIOCGETSGCNT	(SIOCPROTOPRIVATE+1)
@@ -88,6 +91,15 @@ struct mfcctl {
 	int	     mfcc_expire;
 };
 
+struct mfcctl_ext {
+	/* Need to be the same as mfcctl */
+	struct in_addr mfcc_origin;		/* Origin of mcast	*/
+	struct in_addr mfcc_mcastgrp;		/* Group in question	*/
+	vifi_t	mfcc_parent;			/* Where it arrived	*/
+	unsigned char mfcc_ttls[];		/* Where it is going	*/
+	/* Don't put anything here as mfcc_ttls should grow into here */
+};
+
 /*  Group count retrieval for mrouted */
 struct sioc_sg_req {
 	struct in_addr src;
diff --git a/include/uapi/linux/mroute6.h b/include/uapi/linux/mroute6.h
index a1fd6173e2db..1d15af3e0011 100644
--- a/include/uapi/linux/mroute6.h
+++ b/include/uapi/linux/mroute6.h
@@ -32,7 +32,10 @@
 #define MRT6_ADD_MFC_PROXY	(MRT6_BASE+10)	/* Add a (*,*|G) mfc entry	*/
 #define MRT6_DEL_MFC_PROXY	(MRT6_BASE+11)	/* Del a (*,*|G) mfc entry	*/
 #define MRT6_FLUSH	(MRT6_BASE+12)	/* Flush all mfc entries and/or vifs	*/
-#define MRT6_MAX	(MRT6_BASE+12)
+#define MRT6_ADD_MIF_EXT	(MRT6_BASE+13)	/* Add a virtual interface		*/
+#define MRT6_ADD_MFC_EXT	(MRT6_BASE+14)	/* Add a multicast forwarding entry	*/
+#define MRT6_ADD_MFC_PROXY_EXT	(MRT6_BASE+15)	/* Add a (*,*|G) mfc entry	*/
+#define MRT6_MAX	(MRT6_BASE+15)
 
 #define SIOCGETMIFCNT_IN6	SIOCPROTOPRIVATE	/* IP protocol privates */
 #define SIOCGETSGCNT_IN6	(SIOCPROTOPRIVATE+1)
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 87983e70f03f..34ff677a4dca 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -243,6 +243,17 @@ config IP_MROUTE_MULTIPLE_TABLES
 
 	  If unsure, say N.
 
+config IP_MROUTE_EXT_MAXVIFS
+	int "IP: extended maximum multicast routing vif"
+	depends on IP_MROUTE || IPV6_MROUTE
+	range 32 256
+	default 32
+	help
+	  Maximum multicast routing vif is set at 32 and it is defined in the
+	  user API header file, so it is fixed. There are cases where more
+	  vifs are needed. This config is used to get more vifs. The default
+	  is set to be the same as MAXVIFS (32).
+
 config IP_PIMSM_V1
 	bool "IP: PIM-SM version 1 support"
 	depends on IP_MROUTE
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 2dda856ca260..50c81c4c347a 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -788,9 +788,9 @@ static void ipmr_update_thresholds(struct mr_table *mrt, struct mr_mfc *cache,
 {
 	int vifi;
 
-	cache->mfc_un.res.minvif = MAXVIFS;
+	cache->mfc_un.res.minvif = CONFIG_IP_MROUTE_EXT_MAXVIFS;
 	cache->mfc_un.res.maxvif = 0;
-	memset(cache->mfc_un.res.ttls, 255, MAXVIFS);
+	memset(cache->mfc_un.res.ttls, 255, CONFIG_IP_MROUTE_EXT_MAXVIFS);
 
 	for (vifi = 0; vifi < mrt->maxvif; vifi++) {
 		if (VIF_EXISTS(mrt, vifi) &&
@@ -952,7 +952,7 @@ static struct mfc_cache *ipmr_cache_alloc(void)
 
 	if (c) {
 		c->_c.mfc_un.res.last_assert = jiffies - MFC_ASSERT_THRESH - 1;
-		c->_c.mfc_un.res.minvif = MAXVIFS;
+		c->_c.mfc_un.res.minvif = CONFIG_IP_MROUTE_EXT_MAXVIFS;
 		c->_c.free = ipmr_cache_free_rcu;
 		refcount_set(&c->_c.mfc_un.res.refcount, 1);
 	}
@@ -1185,15 +1185,15 @@ static int ipmr_mfc_delete(struct mr_table *mrt, struct mfcctl *mfc, int parent)
 	return 0;
 }
 
-static int ipmr_mfc_add(struct net *net, struct mr_table *mrt,
-			struct mfcctl *mfc, int mrtsock, int parent)
+static int ipmr_mfc_add_ext(struct net *net, struct mr_table *mrt,
+			    struct mfcctl_ext *mfc, int mrtsock, int parent)
 {
 	struct mfc_cache *uc, *c;
 	struct mr_mfc *_uc;
 	bool found;
 	int ret;
 
-	if (mfc->mfcc_parent >= MAXVIFS)
+	if (mfc->mfcc_parent >= CONFIG_IP_MROUTE_EXT_MAXVIFS)
 		return -ENFILE;
 
 	/* The entries are added/deleted only under RTNL */
@@ -1265,6 +1265,36 @@ static int ipmr_mfc_add(struct net *net, struct mr_table *mrt,
 	return 0;
 }
 
+static int ipmr_mfc_add(struct net *net, struct mr_table *mrt,
+			struct mfcctl *mfc, int mrtsock, int parent)
+{
+	unsigned int ext_maxvifs = CONFIG_IP_MROUTE_EXT_MAXVIFS;
+	struct mfcctl_ext *mfc_ext;
+	int i, ret;
+
+	/* Maintain the behavior for MRT_ADD_MFC. */
+	if (mfc->mfcc_parent >= MAXVIFS)
+		return -ENFILE;
+
+	mfc_ext = kzalloc(sizeof(*mfc_ext) +
+			   sizeof(mfc_ext->mfcc_ttls[0]) * ext_maxvifs,
+			   GFP_KERNEL);
+	if (!mfc_ext)
+		return -ENOMEM;
+	memcpy(mfc_ext, mfc, sizeof(*mfc_ext));
+	for (i = 0; i < MAXVIFS; i++)
+		mfc_ext->mfcc_ttls[i] = mfc->mfcc_ttls[i];
+	/* Prevent processing ttls for vifs over MAXVIFS. Also vif above MAXVIFS
+	 * shouldn't exist. So, ipmr_update_thresholds() will not process.
+	 */
+	for (; i < ext_maxvifs; i++)
+		mfc_ext->mfcc_ttls[i] = 0;
+
+	ret = ipmr_mfc_add_ext(net, mrt, mfc_ext, mrtsock, parent);
+	kfree(mfc_ext);
+	return ret;
+}
+
 /* Close the multicast socket, and clear the vif tables etc */
 static void mroute_clean_tables(struct mr_table *mrt, int flags)
 {
@@ -1348,8 +1378,11 @@ static void mrtsock_destruct(struct sock *sk)
 int ip_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 			 unsigned int optlen)
 {
+	unsigned int ext_maxvifs = CONFIG_IP_MROUTE_EXT_MAXVIFS;
 	struct net *net = sock_net(sk);
 	int val, ret = 0, parent = 0;
+	struct mfcctl_ext *mfc_ext;
+	unsigned int mfc_ext_size;
 	struct mr_table *mrt;
 	struct vifctl vif;
 	struct mfcctl mfc;
@@ -1413,6 +1446,7 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 		break;
 	case MRT_ADD_VIF:
 	case MRT_DEL_VIF:
+	case MRT_ADD_VIF_EXT:
 		if (optlen != sizeof(vif)) {
 			ret = -EINVAL;
 			break;
@@ -1421,11 +1455,18 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 			ret = -EFAULT;
 			break;
 		}
-		if (vif.vifc_vifi >= MAXVIFS) {
-			ret = -ENFILE;
-			break;
-		}
 		if (optname == MRT_ADD_VIF) {
+			if (vif.vifc_vifi >= MAXVIFS) {
+				ret = -ENFILE;
+				break;
+			}
+		} else {
+			if (vif.vifc_vifi >= CONFIG_IP_MROUTE_EXT_MAXVIFS) {
+				ret = -ENFILE;
+				break;
+			}
+		}
+		if (optname == MRT_ADD_VIF || optname == MRT_ADD_VIF_EXT) {
 			ret = vif_add(net, mrt, &vif,
 				      sk == rtnl_dereference(mrt->mroute_sk));
 		} else {
@@ -1458,6 +1499,38 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 					   sk == rtnl_dereference(mrt->mroute_sk),
 					   parent);
 		break;
+	case MRT_ADD_MFC_EXT:
+		parent = -1;
+		fallthrough;
+	case MRT_ADD_MFC_PROXY_EXT:
+		if (optlen < sizeof(*mfc_ext)) {
+			ret = -EINVAL;
+			break;
+		}
+		/* If userspace passes less than CONFIG_IP_MROUTE_EXT_MAXVIFS
+		 * ttls, make sure to allocate to the max and initialize to
+		 * zeros. If userspace passes more, the rest of the code will
+		 * process up to CONFIG_IP_MROUTE_EXT_MAXVIFS. MRT_ADD_VIF_EXT
+		 * only accepts up to CONFIG_IP_MROUTE_EXT_MAXVIFS
+		 */
+		mfc_ext_size = (unsigned int)(sizeof(*mfc_ext) +
+			       sizeof(mfc_ext->mfcc_ttls[0]) * ext_maxvifs);
+		mfc_ext = kzalloc(max(optlen, mfc_ext_size), GFP_KERNEL);
+		if (!mfc_ext) {
+			ret = -ENOMEM;
+			break;
+		}
+		if (copy_from_sockptr(mfc_ext, optval, optlen)) {
+			ret = -EFAULT;
+			break;
+		}
+		if (parent == 0)
+			parent = mfc_ext->mfcc_parent;
+		ret = ipmr_mfc_add_ext(net, mrt, mfc_ext,
+				       sk == rtnl_dereference(mrt->mroute_sk),
+				       parent);
+		kfree(mfc_ext);
+		break;
 	case MRT_FLUSH:
 		if (optlen != sizeof(val)) {
 			ret = -EINVAL;
@@ -2369,13 +2442,15 @@ static size_t mroute_msgsize(bool unresolved, int maxvif)
 static void mroute_netlink_event(struct mr_table *mrt, struct mfc_cache *mfc,
 				 int cmd)
 {
+	bool unresolved = mfc->_c.mfc_parent >= CONFIG_IP_MROUTE_EXT_MAXVIFS;
 	struct net *net = read_pnet(&mrt->net);
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
-	skb = nlmsg_new(mroute_msgsize(mfc->_c.mfc_parent >= MAXVIFS,
-				       mrt->maxvif),
-			GFP_ATOMIC);
+	/* Unresolved cache has the mfc_parent being set to -1, so checking
+	 * with CONFIG_IP_MROUTE_EXT_MAXVIFS should be ok.
+	 */
+	skb = nlmsg_new(mroute_msgsize(unresolved, mrt->maxvif), GFP_ATOMIC);
 	if (!skb)
 		goto errout;
 
@@ -2619,14 +2694,14 @@ static bool ipmr_rtm_validate_proto(unsigned char rtm_protocol)
 	return false;
 }
 
-static int ipmr_nla_get_ttls(const struct nlattr *nla, struct mfcctl *mfcc)
+static int ipmr_nla_get_ttls(const struct nlattr *nla, struct mfcctl_ext *mfcc)
 {
 	struct rtnexthop *rtnh = nla_data(nla);
 	int remaining = nla_len(nla), vifi = 0;
 
 	while (rtnh_ok(rtnh, remaining)) {
 		mfcc->mfcc_ttls[vifi] = rtnh->rtnh_hops;
-		if (++vifi == MAXVIFS)
+		if (++vifi == CONFIG_IP_MROUTE_EXT_MAXVIFS)
 			break;
 		rtnh = rtnh_next(rtnh, &remaining);
 	}
@@ -2636,7 +2711,7 @@ static int ipmr_nla_get_ttls(const struct nlattr *nla, struct mfcctl *mfcc)
 
 /* returns < 0 on error, 0 for ADD_MFC and 1 for ADD_MFC_PROXY */
 static int rtm_to_ipmr_mfcc(struct net *net, struct nlmsghdr *nlh,
-			    struct mfcctl *mfcc, int *mrtsock,
+			    struct mfcctl_ext *mfcc, int *mrtsock,
 			    struct mr_table **mrtret,
 			    struct netlink_ext_ack *extack)
 {
@@ -2713,7 +2788,7 @@ static int ipmr_rtm_route(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net *net = sock_net(skb->sk);
 	int ret, mrtsock, parent;
 	struct mr_table *tbl;
-	struct mfcctl mfcc;
+	struct mfcctl_ext mfcc;
 
 	mrtsock = 0;
 	tbl = NULL;
@@ -2723,9 +2798,9 @@ static int ipmr_rtm_route(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	parent = ret ? mfcc.mfcc_parent : -1;
 	if (nlh->nlmsg_type == RTM_NEWROUTE)
-		return ipmr_mfc_add(net, tbl, &mfcc, mrtsock, parent);
+		return ipmr_mfc_add_ext(net, tbl, &mfcc, mrtsock, parent);
 	else
-		return ipmr_mfc_delete(tbl, &mfcc, parent);
+		return ipmr_mfc_delete(tbl, (struct mfcctl *)&mfcc, parent);
 }
 
 static bool ipmr_fill_table(struct mr_table *mrt, struct sk_buff *skb)
@@ -3106,6 +3181,8 @@ int __init ip_mr_init(void)
 {
 	int err;
 
+	BUILD_BUG_ON(CONFIG_IP_MROUTE_EXT_MAXVIFS < MAXVIFS);
+
 	mrt_cachep = kmem_cache_create("ip_mrt_cache",
 				       sizeof(struct mfc_cache),
 				       0, SLAB_HWCACHE_ALIGN | SLAB_PANIC,
diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index aa8738a91210..ce109643ce7b 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -215,7 +215,7 @@ int mr_fill_mroute(struct mr_table *mrt, struct sk_buff *skb,
 	int ct;
 
 	/* If cache is unresolved, don't try to parse IIF and OIF */
-	if (c->mfc_parent >= MAXVIFS) {
+	if (c->mfc_parent >= CONFIG_IP_MROUTE_EXT_MAXVIFS) {
 		rtm->rtm_flags |= RTNH_F_UNRESOLVED;
 		return -ENOENT;
 	}
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 36ed9efb8825..1310a896191e 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -50,6 +50,8 @@
 
 #include <linux/nospec.h>
 
+#define EXT_MAXMIFS CONFIG_IP_MROUTE_EXT_MAXVIFS
+
 struct ip6mr_rule {
 	struct fib_rule		common;
 };
@@ -839,9 +841,9 @@ static void ip6mr_update_thresholds(struct mr_table *mrt,
 {
 	int vifi;
 
-	cache->mfc_un.res.minvif = MAXMIFS;
+	cache->mfc_un.res.minvif = EXT_MAXMIFS;
 	cache->mfc_un.res.maxvif = 0;
-	memset(cache->mfc_un.res.ttls, 255, MAXMIFS);
+	memset(cache->mfc_un.res.ttls, 255, EXT_MAXMIFS);
 
 	for (vifi = 0; vifi < mrt->maxvif; vifi++) {
 		if (VIF_EXISTS(mrt, vifi) &&
@@ -980,7 +982,7 @@ static struct mfc6_cache *ip6mr_cache_alloc(void)
 	if (!c)
 		return NULL;
 	c->_c.mfc_un.res.last_assert = jiffies - MFC_ASSERT_THRESH - 1;
-	c->_c.mfc_un.res.minvif = MAXMIFS;
+	c->_c.mfc_un.res.minvif = EXT_MAXMIFS;
 	c->_c.free = ip6mr_cache_free_rcu;
 	refcount_set(&c->_c.mfc_un.res.refcount, 1);
 	return c;
@@ -1303,6 +1305,9 @@ static int __net_init ip6mr_net_init(struct net *net)
 {
 	int err;
 
+	BUILD_BUG_ON(EXT_MAXMIFS < MAXMIFS);
+	BUILD_BUG_ON(EXT_MAXMIFS > IF_SETSIZE);
+
 	err = ip6mr_notifier_init(net);
 	if (err)
 		return err;
@@ -1405,17 +1410,18 @@ void ip6_mr_cleanup(void)
 static int ip6mr_mfc_add(struct net *net, struct mr_table *mrt,
 			 struct mf6cctl *mfc, int mrtsock, int parent)
 {
-	unsigned char ttls[MAXMIFS];
+	unsigned char ttls[EXT_MAXMIFS];
 	struct mfc6_cache *uc, *c;
 	struct mr_mfc *_uc;
 	bool found;
 	int i, err;
 
-	if (mfc->mf6cc_parent >= MAXMIFS)
+	/* Check for the case of >= MAXMIFS is done outside of this func */
+	if (mfc->mf6cc_parent >= EXT_MAXMIFS)
 		return -ENFILE;
 
-	memset(ttls, 255, MAXMIFS);
-	for (i = 0; i < MAXMIFS; i++) {
+	memset(ttls, 255, EXT_MAXMIFS);
+	for (i = 0; i < EXT_MAXMIFS; i++) {
 		if (IF_ISSET(i, &mfc->mf6cc_ifset))
 			ttls[i] = 1;
 	}
@@ -1663,12 +1669,18 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 		return ip6mr_sk_done(sk);
 
 	case MRT6_ADD_MIF:
+	case MRT6_ADD_MIF_EXT:
 		if (optlen < sizeof(vif))
 			return -EINVAL;
 		if (copy_from_sockptr(&vif, optval, sizeof(vif)))
 			return -EFAULT;
-		if (vif.mif6c_mifi >= MAXMIFS)
-			return -ENFILE;
+		if (optname == MRT6_ADD_MIF) {
+			if (vif.mif6c_mifi >= MAXMIFS)
+				return -ENFILE;
+		} else {
+			if (vif.mif6c_mifi >= EXT_MAXMIFS)
+				return -ENFILE;
+		}
 		rtnl_lock();
 		ret = mif6_add(net, mrt, &vif,
 			       sk == rtnl_dereference(mrt->mroute_sk));
@@ -1690,10 +1702,12 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 	 *	in a sort of kernel/user symbiosis.
 	 */
 	case MRT6_ADD_MFC:
+	case MRT6_ADD_MFC_EXT:
 	case MRT6_DEL_MFC:
 		parent = -1;
 		fallthrough;
 	case MRT6_ADD_MFC_PROXY:
+	case MRT6_ADD_MFC_PROXY_EXT:
 	case MRT6_DEL_MFC_PROXY:
 		if (optlen < sizeof(mfc))
 			return -EINVAL;
@@ -1702,13 +1716,19 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 		if (parent == 0)
 			parent = mfc.mf6cc_parent;
 		rtnl_lock();
-		if (optname == MRT6_DEL_MFC || optname == MRT6_DEL_MFC_PROXY)
+		if (optname == MRT6_DEL_MFC || optname == MRT6_DEL_MFC_PROXY) {
 			ret = ip6mr_mfc_delete(mrt, &mfc, parent);
-		else
-			ret = ip6mr_mfc_add(net, mrt, &mfc,
-					    sk ==
-					    rtnl_dereference(mrt->mroute_sk),
-					    parent);
+		} else {
+			if ((optname == MRT6_ADD_MFC ||
+			     optname == MRT6_ADD_MFC_PROXY) &&
+			    mfc.mf6cc_parent >= MAXMIFS)
+				ret = -ENFILE;
+			else
+				ret = ip6mr_mfc_add(net, mrt, &mfc,
+						    sk ==
+						    rtnl_dereference(mrt->mroute_sk),
+						    parent);
+		}
 		rtnl_unlock();
 		return ret;
 
@@ -2402,7 +2422,7 @@ static void mr6_netlink_event(struct mr_table *mrt, struct mfc6_cache *mfc,
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
-	skb = nlmsg_new(mr6_msgsize(mfc->_c.mfc_parent >= MAXMIFS, mrt->maxvif),
+	skb = nlmsg_new(mr6_msgsize(mfc->_c.mfc_parent >= EXT_MAXMIFS, mrt->maxvif),
 			GFP_ATOMIC);
 	if (!skb)
 		goto errout;
-- 
2.25.1

