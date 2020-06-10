Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196FF1F4BEA
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 05:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgFJDuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 23:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgFJDt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 23:49:58 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C5E820825;
        Wed, 10 Jun 2020 03:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591760997;
        bh=iAjlyLGRbgmUdnnlRR3rPb3WPrxkLYirujcaHYWvYi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UesMJKY/jFeJJ3gYJos6S1WKSpfiiNAdCNQhGTqHRu/KZ+ClhlWFbufCFzycHfi6y
         rNcrzDMkGcSMlZmlJXOOcGqom6gK+O5bn8Co4iBAV5pefQQXTWg9XSxktOSieftDVh
         D7JvN3atuoLFtAlk0BAO4UMopPnS+Vk/zpKfbNQA=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, assogba.emery@gmail.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH RFC net-next 3/8] nexthop: Refactor nexthop_for_each_fib6_nh
Date:   Tue,  9 Jun 2020 21:49:48 -0600
Message-Id: <20200610034953.28861-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200610034953.28861-1-dsahern@kernel.org>
References: <20200610034953.28861-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor nexthop_for_each_fib6_nh moving standalone and group processing
into helpers. Prepatory patch for adding active-backup group.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/nexthop.c | 48 +++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 7d0a170821f3..940f46a7d533 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -588,34 +588,52 @@ struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 }
 EXPORT_SYMBOL_GPL(nexthop_select_path);
 
+static int nexthop_fib6_nh_cb(struct nexthop *nh,
+			      int (*cb)(struct fib6_nh *nh, void *arg),
+			      void *arg)
+{
+	struct nh_info *nhi;
+
+	nhi = rcu_dereference_rtnl(nh->nh_info);
+
+	return cb(&nhi->fib6_nh, arg);
+}
+
+static int nexthop_fib6_nhg_cb(struct nh_group *nhg,
+			       int (*cb)(struct fib6_nh *nh, void *arg),
+			       void *arg)
+{
+	int err;
+	int i;
+
+	for (i = 0; i < nhg->num_nh; i++) {
+		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+		struct nexthop *nh = nhge->nh;
+
+		err = nexthop_fib6_nh_cb(nh, cb, arg);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 int nexthop_for_each_fib6_nh(struct nexthop *nh,
 			     int (*cb)(struct fib6_nh *nh, void *arg),
 			     void *arg)
 {
-	struct nh_info *nhi;
 	int err;
 
 	if (nh->is_group) {
 		struct nh_group *nhg;
-		int i;
 
 		nhg = rcu_dereference_rtnl(nh->nh_grp);
-		for (i = 0; i < nhg->num_nh; i++) {
-			struct nh_grp_entry *nhge = &nhg->nh_entries[i];
-
-			nhi = rcu_dereference_rtnl(nhge->nh->nh_info);
-			err = cb(&nhi->fib6_nh, arg);
-			if (err)
-				return err;
-		}
+		err = nexthop_fib6_nhg_cb(nhg, cb, arg);
 	} else {
-		nhi = rcu_dereference_rtnl(nh->nh_info);
-		err = cb(&nhi->fib6_nh, arg);
-		if (err)
-			return err;
+		err = nexthop_fib6_nh_cb(nh, cb, arg);
 	}
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(nexthop_for_each_fib6_nh);
 
-- 
2.21.1 (Apple Git-122.3)

