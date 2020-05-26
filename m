Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2181E24D3
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgEZPBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728888AbgEZPBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 11:01:16 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03EEB207FB;
        Tue, 26 May 2020 15:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590505276;
        bh=KQ3fQIRKs/Im1AlYkedKG1qtnp6qQr51EL7BxAGlYwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lx8Xkevsu9mz+tgfFpQBDpjEjJQCFhvluYL2uFUD0I1tq7Da7lg+7xgUDAQJiLvJH
         8//E5Mb0wLIfseFrvxuILmyaRpAGMDmkyeUIJgag+MT23o3Hn4WpHMNlFv2Ph0UrRx
         FB3RFCc1HXt3gIf7TZzIHEA2QXNsZ3xHPsAVANyc=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nikolay@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 1/5] nexthops: Move code from remove_nexthop_from_groups to remove_nh_grp_entry
Date:   Tue, 26 May 2020 09:01:10 -0600
Message-Id: <20200526150114.41687-2-dsahern@kernel.org>
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

Move nh_grp dereference and check for removing nexthop group due to
all members gone into remove_nh_grp_entry.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/nexthop.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 2a31c4af845e..0f68d9801808 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -693,17 +693,21 @@ static void nh_group_rebalance(struct nh_group *nhg)
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
@@ -727,7 +731,11 @@ static void remove_nh_grp_entry(struct nh_grp_entry *nhge,
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
@@ -735,17 +743,8 @@ static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
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

