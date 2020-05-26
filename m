Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A851E2EFB
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 21:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390952AbgEZTdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 15:33:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389797AbgEZS4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 14:56:22 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B544208B6;
        Tue, 26 May 2020 18:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519381;
        bh=zeB4mtttKcrEXgCO0k4Jm6TfTcjFPut91gntKbxyIQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxmNFSxr690I3/91/3edFgHROpPrDrzA4yk1JG1jOMekU47ADT+nOgOjJuWrlWkx1
         XtwCF9p+y/VarGxIecuI+A9sVg0SmINiHDwzsFqOqeo3PtMbNhoKxJlJVOkRDuW3S2
         Op7avDYJlEt2VbWRSLpWpgs1cLCXMywWjfWRFjO4=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nikolay@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net v2 1/5] nexthops: Move code from remove_nexthop_from_groups to remove_nh_grp_entry
Date:   Tue, 26 May 2020 12:56:14 -0600
Message-Id: <20200526185618.43748-2-dsahern@kernel.org>
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

Move nh_grp dereference and check for removing nexthop group due to
all members gone into remove_nh_grp_entry.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/ipv4/nexthop.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 715e14475220..b4b772f120a7 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -694,17 +694,21 @@ static void nh_group_rebalance(struct nh_group *nhg)
 	}
 }
 
-static void remove_nh_grp_entry(struct nh_grp_entry *nhge,
-				struct nh_group *nhg,
+static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 				struct nl_info *nlinfo)
 {
+	struct nexthop *nhp = nhge->nh_parent;
 	struct nexthop *nh = nhge->nh;
 	struct nh_grp_entry *nhges;
+	struct nh_group *nhg;
 	bool found = false;
 	int i;
 
 	WARN_ON(!nh);
 
+	list_del(&nhge->nh_list);
+
+	nhg = rtnl_dereference(nhp->nh_grp);
 	nhges = nhg->nh_entries;
 	for (i = 0; i < nhg->num_nh; ++i) {
 		if (found) {
@@ -728,7 +732,11 @@ static void remove_nh_grp_entry(struct nh_grp_entry *nhge,
 	nexthop_put(nh);
 
 	if (nlinfo)
-		nexthop_notify(RTM_NEWNEXTHOP, nhge->nh_parent, nlinfo);
+		nexthop_notify(RTM_NEWNEXTHOP, nhp, nlinfo);
+
+	/* if this group has no more entries then remove it */
+	if (!nhg->num_nh)
+		remove_nexthop(net, nhp, nlinfo);
 }
 
 static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
@@ -736,17 +744,8 @@ static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
 {
 	struct nh_grp_entry *nhge, *tmp;
 
-	list_for_each_entry_safe(nhge, tmp, &nh->grp_list, nh_list) {
-		struct nh_group *nhg;
-
-		list_del(&nhge->nh_list);
-		nhg = rtnl_dereference(nhge->nh_parent->nh_grp);
-		remove_nh_grp_entry(nhge, nhg, nlinfo);
-
-		/* if this group has no more entries then remove it */
-		if (!nhg->num_nh)
-			remove_nexthop(net, nhge->nh_parent, nlinfo);
-	}
+	list_for_each_entry_safe(nhge, tmp, &nh->grp_list, nh_list)
+		remove_nh_grp_entry(net, nhge, nlinfo);
 }
 
 static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
-- 
2.21.1 (Apple Git-122.3)

