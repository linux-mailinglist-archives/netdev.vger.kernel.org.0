Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D9D1E2EFA
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 21:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390002AbgEZTdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 15:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389789AbgEZS4Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 14:56:24 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 678F82086A;
        Tue, 26 May 2020 18:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519383;
        bh=EDdkK6dIOQTKwvtUxwXYy4/4X/dxjHM+E4M4/arruR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNrbjWeDR4TCYwBOSs4WRIv4ifr8HDt/kdpUbPMpRebOZkfmLC/pKHZFmtw5vDaBz
         IYXXp9oz+BmQbnTcejTwGcdN7hQ9boQkA15mfrguZiD9SYT89xBx018ipixMpZe4eB
         cn3Z9CLigy2Ifo6wqfg2o7QTJE7LvUPeX/WPZjIw=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nikolay@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net v2 5/5] ipv4: nexthop version of fib_info_nh_uses_dev
Date:   Tue, 26 May 2020 12:56:18 -0600
Message-Id: <20200526185618.43748-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200526185618.43748-1-dsahern@kernel.org>
References: <20200526185618.43748-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Similar to the last path, need to fix fib_info_nh_uses_dev for
external nexthops to avoid referencing multiple nh_grp structs.
Move the device check in fib_info_nh_uses_dev to a helper and
create a nexthop version that is called if the fib_info uses an
external nexthop.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 include/net/ip_fib.h    | 10 ++++++++++
 include/net/nexthop.h   | 25 +++++++++++++++++++++++++
 net/ipv4/fib_frontend.c | 19 ++++++++++---------
 3 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 771ce068bc96..2ec062aaa978 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -447,6 +447,16 @@ static inline int fib_num_tclassid_users(struct net *net)
 #endif
 int fib_unmerge(struct net *net);
 
+static inline bool nhc_l3mdev_matches_dev(const struct fib_nh_common *nhc,
+const struct net_device *dev)
+{
+	if (nhc->nhc_dev == dev ||
+	    l3mdev_master_ifindex_rcu(nhc->nhc_dev) == dev->ifindex)
+		return true;
+
+	return false;
+}
+
 /* Exported by fib_semantics.c */
 int ip_fib_check_default(__be32 gw, struct net_device *dev);
 int fib_sync_down_dev(struct net_device *dev, unsigned long event, bool force);
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 9414ae46fc1c..8c9f1a718859 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -266,6 +266,31 @@ struct fib_nh_common *nexthop_get_nhc_lookup(const struct nexthop *nh,
 	return NULL;
 }
 
+static inline bool nexthop_uses_dev(const struct nexthop *nh,
+				    const struct net_device *dev)
+{
+	struct nh_info *nhi;
+
+	if (nh->is_group) {
+		struct nh_group *nhg = rcu_dereference(nh->nh_grp);
+		int i;
+
+		for (i = 0; i < nhg->num_nh; i++) {
+			struct nexthop *nhe = nhg->nh_entries[i].nh;
+
+			nhi = rcu_dereference(nhe->nh_info);
+			if (nhc_l3mdev_matches_dev(&nhi->fib_nhc, dev))
+				return true;
+		}
+	} else {
+		nhi = rcu_dereference(nh->nh_info);
+		if (nhc_l3mdev_matches_dev(&nhi->fib_nhc, dev))
+			return true;
+	}
+
+	return false;
+}
+
 static inline unsigned int fib_info_num_path(const struct fib_info *fi)
 {
 	if (unlikely(fi->nh))
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 1bf9da3a75f9..41079490a118 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -309,17 +309,18 @@ bool fib_info_nh_uses_dev(struct fib_info *fi, const struct net_device *dev)
 {
 	bool dev_match = false;
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
-	int ret;
+	if (unlikely(fi->nh)) {
+		dev_match = nexthop_uses_dev(fi->nh, dev);
+	} else {
+		int ret;
 
-	for (ret = 0; ret < fib_info_num_path(fi); ret++) {
-		const struct fib_nh_common *nhc = fib_info_nhc(fi, ret);
+		for (ret = 0; ret < fib_info_num_path(fi); ret++) {
+			const struct fib_nh_common *nhc = fib_info_nhc(fi, ret);
 
-		if (nhc->nhc_dev == dev) {
-			dev_match = true;
-			break;
-		} else if (l3mdev_master_ifindex_rcu(nhc->nhc_dev) == dev->ifindex) {
-			dev_match = true;
-			break;
+			if (nhc_l3mdev_matches_dev(nhc, dev)) {
+				dev_match = true;
+				break;
+			}
 		}
 	}
 #else
-- 
2.21.1 (Apple Git-122.3)

