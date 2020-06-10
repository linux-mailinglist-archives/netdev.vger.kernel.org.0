Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBC81F4BE6
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 05:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgFJDuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 23:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFJDt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 23:49:59 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 584792076A;
        Wed, 10 Jun 2020 03:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591760998;
        bh=kOc4BHGGYmoR1yMo/touSA2B2rB1cFGODQyAyEXvq+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhFlD0ByD+9FbQQVxk/QForsSJmlW9G/DOeLGeivEviWvbIthLzsiq7b1HQcCg0Va
         tnby9zczD9YW5ul4vozoRzrvFEcra1LSI7uy68ImClFqHInE6esdZcM0pO8wRj0k1K
         NZ4uXRUWoLDeVir1G6jyBao4IS8AfYpHE5tSJcwg=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, assogba.emery@gmail.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH RFC net-next 5/8] nexthop: Move nexthop_uses_dev to nexthop.c
Date:   Tue,  9 Jun 2020 21:49:50 -0600
Message-Id: <20200610034953.28861-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200610034953.28861-1-dsahern@kernel.org>
References: <20200610034953.28861-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nexthop_uses_dev is long enough for an inline and the a-b checks are
going to make it worse. Move to nexthop.c and in the process refactor
so that mpath code reuses single nh lookup. Prepatory patch for adding
active-backup group.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 include/net/nexthop.h | 25 +------------------------
 net/ipv4/nexthop.c    | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index e95800798aa5..271d2cb92954 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -266,30 +266,7 @@ struct fib_nh_common *nexthop_get_nhc_lookup(const struct nexthop *nh,
 					     const struct flowi4 *flp,
 					     int *nhsel);
 
-static inline bool nexthop_uses_dev(const struct nexthop *nh,
-				    const struct net_device *dev)
-{
-	struct nh_info *nhi;
-
-	if (nh->is_group) {
-		struct nh_group *nhg = rcu_dereference(nh->nh_grp);
-		int i;
-
-		for (i = 0; i < nhg->num_nh; i++) {
-			struct nexthop *nhe = nhg->nh_entries[i].nh;
-
-			nhi = rcu_dereference(nhe->nh_info);
-			if (nhc_l3mdev_matches_dev(&nhi->fib_nhc, dev))
-				return true;
-		}
-	} else {
-		nhi = rcu_dereference(nh->nh_info);
-		if (nhc_l3mdev_matches_dev(&nhi->fib_nhc, dev))
-			return true;
-	}
-
-	return false;
-}
+bool nexthop_uses_dev(const struct nexthop *nh, const struct net_device *dev);
 
 static inline unsigned int fib_info_num_path(const struct fib_info *fi)
 {
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index c58ecc86b7a1..0020ea2ecc9f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -638,6 +638,41 @@ struct fib_nh_common *nexthop_get_nhc_lookup(const struct nexthop *nh,
 	return nhc_lookup_single(nh, fib_flags, flp, nhsel);
 }
 
+static bool nh_uses_dev_single(const struct nexthop *nh,
+			       const struct net_device *dev)
+{
+	const struct nh_info *nhi;
+
+	nhi = rcu_dereference(nh->nh_info);
+	return nhc_l3mdev_matches_dev(&nhi->fib_nhc, dev);
+}
+
+static bool nh_uses_dev_mpath(const struct nh_group *nhg,
+			      const struct net_device *dev)
+{
+	int i;
+
+	for (i = 0; i < nhg->num_nh; i++) {
+		struct nexthop *nhe = nhg->nh_entries[i].nh;
+
+		if (nh_uses_dev_single(nhe, dev))
+			return true;
+	}
+
+	return false;
+}
+
+bool nexthop_uses_dev(const struct nexthop *nh, const struct net_device *dev)
+{
+	if (nh->is_group) {
+		const struct nh_group *nhg = rcu_dereference(nh->nh_grp);
+
+		return nh_uses_dev_mpath(nhg, dev);
+	}
+
+	return nh_uses_dev_single(nh, dev);
+}
+
 static int nexthop_fib6_nh_cb(struct nexthop *nh,
 			      int (*cb)(struct fib6_nh *nh, void *arg),
 			      void *arg)
-- 
2.21.1 (Apple Git-122.3)

