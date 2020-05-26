Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3731E24D6
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgEZPBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbgEZPBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 11:01:19 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A588208A7;
        Tue, 26 May 2020 15:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590505278;
        bh=aIcjXQpP0Jk4YDbBaKFB8r+UPV4Oij0K//ZaPBrLCVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EOi67xQF8KMg1ZADiKX64TM6p1j1LiTkTCDPcS4e1E0+Ds7mRn53NrCpuy+EO+Ofs
         n8QuF6X21cVE/3NaGiRVVhIboJrrpuDwGBER+e0NC17T5LTF4FTyhDY/kVZGDPn76I
         WZ17W1lS1dnB+GxmC0mW9kPCVPe1dgXZa/qqfiCs=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nikolay@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 5/5] ipv4: nexthop version of fib_info_nh_uses_dev
Date:   Tue, 26 May 2020 09:01:14 -0600
Message-Id: <20200526150114.41687-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200526150114.41687-1-dsahern@kernel.org>
References: <20200526150114.41687-1-dsahern@kernel.org>
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
---
 include/net/ip_fib.h    | 10 ++++++++++
 include/net/nexthop.h   | 25 +++++++++++++++++++++++++
 net/ipv4/fib_frontend.c | 19 ++++++++++---------
 3 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 1f1dd22980e4..6683558db7c9 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -448,6 +448,16 @@ static inline int fib_num_tclassid_users(struct net *net)
 #endif
 int fib_unmerge(struct net *net);
 
+static inline bool nhc_l3mdev_matches_dev(const struct fib_nh_common *nhc,
+const struct net_device *dev)
+{
+	if (nhc->nhc_dev == dev ||
+	    l3mdev_master_ifindex_rcu(nhc->nhc_dev) == dev->ifindex)
+			return true;
+
+	return false;
+}
+
 /* Exported by fib_semantics.c */
 int ip_fib_check_default(__be32 gw, struct net_device *dev);
 int fib_sync_down_dev(struct net_device *dev, unsigned long event, bool force);
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 9414ae46fc1c..35680a8c2a1c 100644
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
+                }
+        } else {
+		nhi = rcu_dereference(nh->nh_info);
+		if (nhc_l3mdev_matches_dev(&nhi->fib_nhc, dev))
+			return true;
+        }
+
+	return false;
+}
+
 static inline unsigned int fib_info_num_path(const struct fib_info *fi)
 {
 	if (unlikely(fi->nh))
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 213be9c050ad..aebb50735c68 100644
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

