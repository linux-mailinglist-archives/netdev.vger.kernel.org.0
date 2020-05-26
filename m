Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50471E24D5
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgEZPBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729337AbgEZPBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 11:01:18 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A63F20873;
        Tue, 26 May 2020 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590505277;
        bh=qtlLwL7K560CvZ7hhvJLv+24Rh/9u7+uA+tYRoEFSj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmQwAj2SE05zY2scVuBJIC4Jv3/kZBaW9dMXIYtV0c/3ltuydT1lyWpMD8MqPoya5
         tGGSGbAnEM8QSsxizx54S26LCItV57x2/vm8p6IOjnxhHNw2QDDRhI0xgUz6lPEfZx
         FKzpFivQQaEOpF76jMwQ29S1vJOD9E3kynh3iL8k=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nikolay@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 3/5] nexthop: Expand nexthop_is_multipath in a few places
Date:   Tue, 26 May 2020 09:01:12 -0600
Message-Id: <20200526150114.41687-4-dsahern@kernel.org>
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

I got too fancy consolidating checks on multipath type. The result
is that path lookups can access 2 different nh_grp structs as exposed
by Nik's torture tests. Expand nexthop_is_multipath within nexthop.h to
avoid multiple, nh_grp dereferences and make decisions based on the
consistent struct.

Only 2 places left using nexthop_is_multipath are within IPv6, both
only check that the nexthop is a multipath for a branching decision
which are acceptable.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/nexthop.h | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 8a343519ed7a..f09e8d7d9886 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -137,21 +137,20 @@ static inline unsigned int nexthop_num_path(const struct nexthop *nh)
 {
 	unsigned int rc = 1;
 
-	if (nexthop_is_multipath(nh)) {
+	if (nh->is_group) {
 		struct nh_group *nh_grp;
 
 		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
-		rc = nh_grp->num_nh;
+		if (nh_grp->mpath)
+			rc = nh_grp->num_nh;
 	}
 
 	return rc;
 }
 
 static inline
-struct nexthop *nexthop_mpath_select(const struct nexthop *nh, int nhsel)
+struct nexthop *nexthop_mpath_select(const struct nh_group *nhg, int nhsel)
 {
-	const struct nh_group *nhg = rcu_dereference_rtnl(nh->nh_grp);
-
 	/* for_nexthops macros in fib_semantics.c grabs a pointer to
 	 * the nexthop before checking nhsel
 	 */
@@ -186,12 +185,14 @@ static inline bool nexthop_is_blackhole(const struct nexthop *nh)
 {
 	const struct nh_info *nhi;
 
-	if (nexthop_is_multipath(nh)) {
-		if (nexthop_num_path(nh) > 1)
-			return false;
-		nh = nexthop_mpath_select(nh, 0);
-		if (!nh)
+	if (nh->is_group) {
+		struct nh_group *nh_grp;
+
+		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
+		if (nh_grp->num_nh > 1)
 			return false;
+
+		nh = nh_grp->nh_entries[0].nh;
 	}
 
 	nhi = rcu_dereference_rtnl(nh->nh_info);
@@ -217,10 +218,15 @@ struct fib_nh_common *nexthop_fib_nhc(struct nexthop *nh, int nhsel)
 	BUILD_BUG_ON(offsetof(struct fib_nh, nh_common) != 0);
 	BUILD_BUG_ON(offsetof(struct fib6_nh, nh_common) != 0);
 
-	if (nexthop_is_multipath(nh)) {
-		nh = nexthop_mpath_select(nh, nhsel);
-		if (!nh)
-			return NULL;
+	if (nh->is_group) {
+		struct nh_group *nh_grp;
+
+		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
+		if (nh_grp->mpath) {
+			nh = nexthop_mpath_select(nh_grp, nhsel);
+			if (!nh)
+				return NULL;
+		}
 	}
 
 	nhi = rcu_dereference_rtnl(nh->nh_info);
@@ -264,8 +270,11 @@ static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
 {
 	struct nh_info *nhi;
 
-	if (nexthop_is_multipath(nh)) {
-		nh = nexthop_mpath_select(nh, 0);
+	if (nh->is_group) {
+		struct nh_group *nh_grp;
+
+		nh_grp = rcu_dereference_rtnl(nh->nh_grp);
+		nh = nexthop_mpath_select(nh_grp, 0);
 		if (!nh)
 			return NULL;
 	}
-- 
2.21.1 (Apple Git-122.3)

