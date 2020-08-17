Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF95245C7C
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 08:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgHQGbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 02:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgHQGa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 02:30:58 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D845C061388
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 23:30:58 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 74so7718517pfx.13
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 23:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=O8SkNeQ2iRC9AK8HGkt8A/EddL3/LkAQz0+EJ/G5Pko=;
        b=p3hVw/AZkEoQsRCwPixNbneatAJjeDqobsmlgu1rUf/3A1hqWaitCKQ7XKKmus2yAW
         zjBovtBG9gjXnTRCPKYW8c+UDKo6yozhVYRK8BFusT8tY/3EAoTDJisH9WYNt/T1O1p9
         9YZrMJ5r90ZgiSjY7vQdvVLmNe5SdTmBIa/oaC2oTsm3iab5vHx3SfAmsgIQCXA3RwAm
         xa4aLI4abA0fGOIe6ZcQgGXoz6KqmxJyEzwPLUTA7+xdegjr+l02bjp7adnW28jQjNEB
         3G7u87ubBzbbrk6OV7ynEHiTa9OCwae3YkNT/xT8y99icGXxSJtP/btdvMtHA0jsDLWw
         9A9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=O8SkNeQ2iRC9AK8HGkt8A/EddL3/LkAQz0+EJ/G5Pko=;
        b=ZcMA1T8CIZMKAb0NdSpVc5ps1+ZQmiUSVx58aRCdtEZ9I8Y073jRl9cZxtrRl7my0P
         +a0GinlJxoowCW9V6Qm0zUfjUCCi7U8m/RqD+9A1yaQrd2K7M9IQRwVhyqVsgYDvDsBp
         winNtbHHMq14DZsZy8UW0noNnJrBapKM16AQQrxGy3XWukk1Rn0/nt+sMgZLoEuyLnuB
         gIweEaeYwt8oMJ4zcWUtDkfTHKmmQfj1+DATNuuUMI+WfQv2PnxiZ0e/0ov+yK0KQmvx
         VDvU9fHDjboX+DswyuIIa1JDWOPcBOEZT+W6zZOtGPDU0BIIfHsiQMrihBX0qjGP85ni
         qpDQ==
X-Gm-Message-State: AOAM5339lt4x+OnlwV7PrxkUXyRcvLMcV2TZCWnCkfyjrc2xP/V0sRUf
        MU/lAUPZDU0t9WiXGr5genv1cIPm7xvX0w==
X-Google-Smtp-Source: ABdhPJwM1jMfQ6UzgeiLk/jw470MJezPZHPiz1MdewOa7/G9973gTET+m97QbiG5WW1gMclk22KPfg==
X-Received: by 2002:a63:6f06:: with SMTP id k6mr8872067pgc.304.1597645857562;
        Sun, 16 Aug 2020 23:30:57 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t25sm111627pgl.60.2020.08.16.23.30.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Aug 2020 23:30:56 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        David Ahern <dsahern@gmail.com>,
        YOSHIFUJI Hideaki <hideaki.yoshifuji@miraclelinux.com>
Subject: [PATCH net] ipv6: some fixes for ipv6_dev_find()
Date:   Mon, 17 Aug 2020 14:30:49 +0800
Message-Id: <1e29a394c9ccb72126dbc3e9769a59c0234f8649.1597645849.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to do 3 things for ipv6_dev_find():

  As David A. noticed,

  - rt6_lookup() is not really needed. Different from __ip_dev_find(),
    ipv6_dev_find() doesn't have a compatibility problem, so remove it.

  As Hideaki suggested,

  - "valid" (non-tentative) check for the address is also needed.
    ipv6_chk_addr() calls ipv6_chk_addr_and_flags(), which will
    traverse the address hash list, but it's heavy to be called
    inside ipv6_dev_find(). This patch is to reuse the code of
    ipv6_chk_addr_and_flags() for ipv6_dev_find().

  - dev parameter is passed into ipv6_dev_find(), as link-local
    addresses from user space has sin6_scope_id set and the dev
    lookup needs it.

Fixes: 81f6cb31222d ("ipv6: add ipv6_dev_find()")
Suggested-by: YOSHIFUJI Hideaki <hideaki.yoshifuji@miraclelinux.com>
Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/addrconf.h |  3 ++-
 net/ipv6/addrconf.c    | 60 +++++++++++++++++++-------------------------------
 net/tipc/udp_media.c   |  8 +++----
 3 files changed, 28 insertions(+), 43 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index ba3f6c15..18f783d 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -97,7 +97,8 @@ bool ipv6_chk_custom_prefix(const struct in6_addr *addr,
 
 int ipv6_chk_prefix(const struct in6_addr *addr, struct net_device *dev);
 
-struct net_device *ipv6_dev_find(struct net *net, const struct in6_addr *addr);
+struct net_device *ipv6_dev_find(struct net *net, const struct in6_addr *addr,
+				 struct net_device *dev);
 
 struct inet6_ifaddr *ipv6_get_ifaddr(struct net *net,
 				     const struct in6_addr *addr,
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 8e761b8..01146b6 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1893,12 +1893,13 @@ EXPORT_SYMBOL(ipv6_chk_addr);
  *   2. does the address exist on the specific device
  *      (skip_dev_check = false)
  */
-int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
-			    const struct net_device *dev, bool skip_dev_check,
-			    int strict, u32 banned_flags)
+static struct net_device *
+__ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
+			  const struct net_device *dev, bool skip_dev_check,
+			  int strict, u32 banned_flags)
 {
 	unsigned int hash = inet6_addr_hash(net, addr);
-	const struct net_device *l3mdev;
+	struct net_device *l3mdev, *ndev;
 	struct inet6_ifaddr *ifp;
 	u32 ifp_flags;
 
@@ -1909,10 +1910,11 @@ int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
 		dev = NULL;
 
 	hlist_for_each_entry_rcu(ifp, &inet6_addr_lst[hash], addr_lst) {
-		if (!net_eq(dev_net(ifp->idev->dev), net))
+		ndev = ifp->idev->dev;
+		if (!net_eq(dev_net(ndev), net))
 			continue;
 
-		if (l3mdev_master_dev_rcu(ifp->idev->dev) != l3mdev)
+		if (l3mdev_master_dev_rcu(ndev) != l3mdev)
 			continue;
 
 		/* Decouple optimistic from tentative for evaluation here.
@@ -1923,15 +1925,23 @@ int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
 			    : ifp->flags;
 		if (ipv6_addr_equal(&ifp->addr, addr) &&
 		    !(ifp_flags&banned_flags) &&
-		    (!dev || ifp->idev->dev == dev ||
+		    (!dev || ndev == dev ||
 		     !(ifp->scope&(IFA_LINK|IFA_HOST) || strict))) {
 			rcu_read_unlock();
-			return 1;
+			return ndev;
 		}
 	}
 
 	rcu_read_unlock();
-	return 0;
+	return NULL;
+}
+
+int ipv6_chk_addr_and_flags(struct net *net, const struct in6_addr *addr,
+			    const struct net_device *dev, bool skip_dev_check,
+			    int strict, u32 banned_flags)
+{
+	return __ipv6_chk_addr_and_flags(net, addr, dev, skip_dev_check,
+					 strict, banned_flags) ? 1 : 0;
 }
 EXPORT_SYMBOL(ipv6_chk_addr_and_flags);
 
@@ -1990,35 +2000,11 @@ EXPORT_SYMBOL(ipv6_chk_prefix);
  *
  * The caller should be protected by RCU, or RTNL.
  */
-struct net_device *ipv6_dev_find(struct net *net, const struct in6_addr *addr)
+struct net_device *ipv6_dev_find(struct net *net, const struct in6_addr *addr,
+				 struct net_device *dev)
 {
-	unsigned int hash = inet6_addr_hash(net, addr);
-	struct inet6_ifaddr *ifp, *result = NULL;
-	struct net_device *dev = NULL;
-
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(ifp, &inet6_addr_lst[hash], addr_lst) {
-		if (net_eq(dev_net(ifp->idev->dev), net) &&
-		    ipv6_addr_equal(&ifp->addr, addr)) {
-			result = ifp;
-			break;
-		}
-	}
-
-	if (!result) {
-		struct rt6_info *rt;
-
-		rt = rt6_lookup(net, addr, NULL, 0, NULL, 0);
-		if (rt) {
-			dev = rt->dst.dev;
-			ip6_rt_put(rt);
-		}
-	} else {
-		dev = result->idev->dev;
-	}
-	rcu_read_unlock();
-
-	return dev;
+	return __ipv6_chk_addr_and_flags(net, addr, dev, !dev, 1,
+					 IFA_F_TENTATIVE);
 }
 EXPORT_SYMBOL(ipv6_dev_find);
 
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index 53f0de0..911d13c 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -660,6 +660,7 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 	struct udp_tunnel_sock_cfg tuncfg = {NULL};
 	struct nlattr *opts[TIPC_NLA_UDP_MAX + 1];
 	u8 node_id[NODE_ID_LEN] = {0,};
+	struct net_device *dev;
 	int rmcast = 0;
 
 	ub = kzalloc(sizeof(*ub), GFP_ATOMIC);
@@ -714,8 +715,6 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 	rcu_assign_pointer(ub->bearer, b);
 	tipc_udp_media_addr_set(&b->addr, &local);
 	if (local.proto == htons(ETH_P_IP)) {
-		struct net_device *dev;
-
 		dev = __ip_dev_find(net, local.ipv4.s_addr, false);
 		if (!dev) {
 			err = -ENODEV;
@@ -738,9 +737,8 @@ static int tipc_udp_enable(struct net *net, struct tipc_bearer *b,
 		b->mtu = b->media->mtu;
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (local.proto == htons(ETH_P_IPV6)) {
-		struct net_device *dev;
-
-		dev = ipv6_dev_find(net, &local.ipv6);
+		dev = ub->ifindex ? __dev_get_by_index(net, ub->ifindex) : NULL;
+		dev = ipv6_dev_find(net, &local.ipv6, dev);
 		if (!dev) {
 			err = -ENODEV;
 			goto err;
-- 
2.1.0

