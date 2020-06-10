Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E2D1F4BEB
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 05:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgFJDuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 23:50:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgFJDt5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 23:49:57 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D73F20801;
        Wed, 10 Jun 2020 03:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591760997;
        bh=8nLew60rqVawK5XrPse3OrxIm5Na2OW94NQx6PdgsmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3iq2vp7FhegyLGiemUI7y+oueKHHMYwfLWTsJEvxwtmu1OOrAeFgzUS4uQdgPCyY
         NMVYqUIJKvHDXMj5FBXHHJVAeY/evHo6/3YAxfFHVOAvB3NBNCm7WYi10ZQeEhifEd
         ZzydUqPKCUEyiEtJfOyxzUuwWY7OrCsTYtYzJek0=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, assogba.emery@gmail.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH RFC net-next 2/8] nexthop: Refactor nexthop_select_path
Date:   Tue,  9 Jun 2020 21:49:47 -0600
Message-Id: <20200610034953.28861-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200610034953.28861-1-dsahern@kernel.org>
References: <20200610034953.28861-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the ipv{4,6}_good_nh calls to a separate helper.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/nexthop.c | 47 +++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5ebc47d5ec56..7d0a170821f3 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -536,6 +536,29 @@ static bool ipv4_good_nh(const struct fib_nh *nh)
 	return !!(state & NUD_VALID);
 }
 
+/* nexthops always check if it is good and does
+ * not rely on a sysctl for this behavior
+ */
+static bool good_nh(struct nexthop *nh)
+{
+	struct nh_info *nhi;
+	bool rc = false;
+
+	nhi = rcu_dereference(nh->nh_info);
+	switch (nhi->family) {
+	case AF_INET:
+		if (ipv4_good_nh(&nhi->fib_nh))
+			rc = true;
+		break;
+	case AF_INET6:
+		if (ipv6_good_nh(&nhi->fib6_nh))
+			rc = true;
+		break;
+	}
+
+	return rc;
+}
+
 struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 {
 	struct nexthop *rc = NULL;
@@ -548,31 +571,17 @@ struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 	nhg = rcu_dereference(nh->nh_grp);
 	for (i = 0; i < nhg->num_nh; ++i) {
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
-		struct nh_info *nhi;
+		struct nexthop *nh;
 
 		if (hash > atomic_read(&nhge->upper_bound))
 			continue;
 
-		if (nhge->nh->is_fdb_nh)
-			return nhge->nh;
-
-		/* nexthops always check if it is good and does
-		 * not rely on a sysctl for this behavior
-		 */
-		nhi = rcu_dereference(nhge->nh->nh_info);
-		switch (nhi->family) {
-		case AF_INET:
-			if (ipv4_good_nh(&nhi->fib_nh))
-				return nhge->nh;
-			break;
-		case AF_INET6:
-			if (ipv6_good_nh(&nhi->fib6_nh))
-				return nhge->nh;
-			break;
-		}
+		nh = nhge->nh;
+		if (nh->is_fdb_nh || good_nh(nh))
+			return nh;
 
 		if (!rc)
-			rc = nhge->nh;
+			rc = nh;
 	}
 
 	return rc;
-- 
2.21.1 (Apple Git-122.3)

