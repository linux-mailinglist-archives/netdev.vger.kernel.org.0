Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214DA1F4BE5
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 05:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgFJDuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 23:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgFJDt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 23:49:59 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDDEC207F9;
        Wed, 10 Jun 2020 03:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591760998;
        bh=fcxOL0Sj4+MUDk0ZzFAdZUGB36BlKRnhoZTp9ojcDhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYZX6KD9CRJrOM1/Aox4SrY9w4yn3LiL08ln/4LGMOCRBnEsrXNxIRWJZJUMwUT0a
         gCJM4mlDnpPKZA2fam77OUgpWOxdzyhYM05bERw/J6ze1HWmvpKrJSM94f4L/owvqk
         2Ll0YVRn50YsE4C9KpWoNOL03kRLalYkUy6Jvb5M=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, assogba.emery@gmail.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH RFC net-next 4/8] nexthop: Move nexthop_get_nhc_lookup to nexthop.c
Date:   Tue,  9 Jun 2020 21:49:49 -0600
Message-Id: <20200610034953.28861-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200610034953.28861-1-dsahern@kernel.org>
References: <20200610034953.28861-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nexthop_get_nhc_lookup is long enough for an inline and the
a-b checks are going to make it worse. Move to nexthop.c and
in the process refactor so that mpath code reuses single nh
lookup. Prepatory patch for adding active-backup group.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 include/net/nexthop.h | 29 +------------------------
 net/ipv4/nexthop.c    | 50 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+), 28 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index e5122ba78efe..e95800798aa5 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -261,37 +261,10 @@ struct fib_nh_common *nexthop_fib_nhc(struct nexthop *nh, int nhsel)
 }
 
 /* called from fib_table_lookup with rcu_lock */
-static inline
 struct fib_nh_common *nexthop_get_nhc_lookup(const struct nexthop *nh,
 					     int fib_flags,
 					     const struct flowi4 *flp,
-					     int *nhsel)
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
-			if (fib_lookup_good_nhc(&nhi->fib_nhc, fib_flags, flp)) {
-				*nhsel = i;
-				return &nhi->fib_nhc;
-			}
-		}
-	} else {
-		nhi = rcu_dereference(nh->nh_info);
-		if (fib_lookup_good_nhc(&nhi->fib_nhc, fib_flags, flp)) {
-			*nhsel = 0;
-			return &nhi->fib_nhc;
-		}
-	}
-
-	return NULL;
-}
+					     int *nhsel);
 
 static inline bool nexthop_uses_dev(const struct nexthop *nh,
 				    const struct net_device *dev)
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 940f46a7d533..c58ecc86b7a1 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -588,6 +588,56 @@ struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 }
 EXPORT_SYMBOL_GPL(nexthop_select_path);
 
+static struct fib_nh_common *nhc_lookup_single(const struct nexthop *nh,
+					       int fib_flags,
+					       const struct flowi4 *flp,
+					       int *nhsel)
+{
+	struct nh_info *nhi;
+
+	nhi = rcu_dereference(nh->nh_info);
+	if (fib_lookup_good_nhc(&nhi->fib_nhc, fib_flags, flp)) {
+		*nhsel = 0;
+		return &nhi->fib_nhc;
+	}
+	return NULL;
+}
+
+static struct fib_nh_common *nhc_lookup_mpath(const struct nh_group *nhg,
+					      int fib_flags,
+					      const struct flowi4 *flp,
+					      int *nhsel)
+{
+	struct fib_nh_common *nhc;
+	int i;
+
+	for (i = 0; i < nhg->num_nh; i++) {
+		struct nexthop *nhe = nhg->nh_entries[i].nh;
+
+		nhc = nhc_lookup_single(nhe, fib_flags, flp, nhsel);
+		if (nhc) {
+			*nhsel = i;
+			return nhc;
+		}
+	}
+
+	return NULL;
+}
+
+struct fib_nh_common *nexthop_get_nhc_lookup(const struct nexthop *nh,
+					     int fib_flags,
+					     const struct flowi4 *flp,
+					     int *nhsel)
+{
+	if (nh->is_group) {
+		const struct nh_group *nhg = rcu_dereference(nh->nh_grp);
+
+		return nhc_lookup_mpath(nhg, fib_flags, flp, nhsel);
+	}
+
+	return nhc_lookup_single(nh, fib_flags, flp, nhsel);
+}
+
 static int nexthop_fib6_nh_cb(struct nexthop *nh,
 			      int (*cb)(struct fib6_nh *nh, void *arg),
 			      void *arg)
-- 
2.21.1 (Apple Git-122.3)

