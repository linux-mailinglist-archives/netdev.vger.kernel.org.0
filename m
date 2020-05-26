Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1D61E24DA
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729709AbgEZPB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgEZPBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 11:01:17 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F04B2086A;
        Tue, 26 May 2020 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590505276;
        bh=ME/ljJ4wPvY3mZ6j6qlikgZucSW9RVtys6ze+k2jkUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hrRPV16ISVs4hUzCd0avAS7msuOV0puLJctEIweKofNVvlvYYTECeRAoua72eNFhg
         4Suo+o/hgWWroB1QFpb7tlp3FiQBESEeEyUHxmESssGH9dObf2EhAeLT+ho48BKhR5
         RxwbtDQcZ/XEfTUGTxXPpOcWJfq46c3ySQCNStGA=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nikolay@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 2/5] nexthops: don't modify published nexthop groups
Date:   Tue, 26 May 2020 09:01:11 -0600
Message-Id: <20200526150114.41687-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200526150114.41687-1-dsahern@kernel.org>
References: <20200526150114.41687-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

We must avoid modifying published nexthop groups while they might be
in use, otherwise we might see NULL ptr dereferences. In order to do
that we allocate 2 nexthoup group structures upon nexthop creation
and swap between them when we have to delete an entry. The reason is
that we can't fail nexthop group removal, so we can't handle allocation
failure thus we move the extra allocation on creation where we can
safely fail and return ENOMEM.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/nexthop.h |  1 +
 net/ipv4/nexthop.c    | 91 +++++++++++++++++++++++++++----------------
 2 files changed, 59 insertions(+), 33 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index c440ccc861fc..8a343519ed7a 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -70,6 +70,7 @@ struct nh_grp_entry {
 };
 
 struct nh_group {
+	struct nh_group		*spare; /* spare group for removals */
 	u16			num_nh;
 	bool			mpath;
 	bool			has_v4;
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 0f68d9801808..a8a399aaa4bc 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -63,9 +63,16 @@ static void nexthop_free_mpath(struct nexthop *nh)
 	int i;
 
 	nhg = rcu_dereference_raw(nh->nh_grp);
-	for (i = 0; i < nhg->num_nh; ++i)
-		WARN_ON(nhg->nh_entries[i].nh);
+	for (i = 0; i < nhg->num_nh; ++i) {
+		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
 
+		WARN_ON(!list_empty(&nhge->nh_list));
+		nexthop_put(nhge->nh);
+	}
+
+	WARN_ON(nhg->spare == nhg);
+
+	kfree(nhg->spare);
 	kfree(nhg);
 }
 
@@ -696,46 +703,53 @@ static void nh_group_rebalance(struct nh_group *nhg)
 static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 				struct nl_info *nlinfo)
 {
+	struct nh_grp_entry *nhges, *new_nhges;
 	struct nexthop *nhp = nhge->nh_parent;
 	struct nexthop *nh = nhge->nh;
-	struct nh_grp_entry *nhges;
-	struct nh_group *nhg;
-	bool found = false;
-	int i;
+	struct nh_group *nhg, *newg;
+	int i, j;
 
 	WARN_ON(!nh);
 
-	list_del(&nhge->nh_list);
-
 	nhg = rtnl_dereference(nhp->nh_grp);
-	nhges = nhg->nh_entries;
-	for (i = 0; i < nhg->num_nh; ++i) {
-		if (found) {
-			nhges[i-1].nh = nhges[i].nh;
-			nhges[i-1].weight = nhges[i].weight;
-			list_del(&nhges[i].nh_list);
-			list_add(&nhges[i-1].nh_list, &nhges[i-1].nh->grp_list);
-		} else if (nhg->nh_entries[i].nh == nh) {
-			found = true;
-		}
-	}
+	newg = nhg->spare;
 
-	if (WARN_ON(!found))
+	/* last entry, keep it visible and remove the parent */
+	if (nhg->num_nh == 1) {
+		remove_nexthop(net, nhp, nlinfo);
 		return;
+	}
 
-	nhg->num_nh--;
-	nhg->nh_entries[nhg->num_nh].nh = NULL;
+	newg->has_v4 = nhg->has_v4;
+	newg->mpath = nhg->mpath;
+	newg->num_nh = nhg->num_nh;
 
-	nh_group_rebalance(nhg);
+	/* copy old entries to new except the one getting removed */
+	nhges = nhg->nh_entries;
+	new_nhges = newg->nh_entries;
+	for (i = 0, j = 0; i < nhg->num_nh; ++i) {
+		/* current nexthop getting removed */
+		if (nhg->nh_entries[i].nh == nh) {
+			newg->num_nh--;
+			continue;
+		}
 
-	nexthop_put(nh);
+		list_del(&nhges[i].nh_list);
+		new_nhges[j].nh_parent = nhges[i].nh_parent;
+		new_nhges[j].nh = nhges[i].nh;
+		new_nhges[j].weight = nhges[i].weight;
+		list_add(&new_nhges[j].nh_list, &new_nhges[j].nh->grp_list);
+		j++;
+	}
+
+	nh_group_rebalance(newg);
+	rcu_assign_pointer(nhp->nh_grp, newg);
+
+	list_del(&nhge->nh_list);
+	nexthop_put(nhge->nh);
 
 	if (nlinfo)
 		nexthop_notify(RTM_NEWNEXTHOP, nhp, nlinfo);
-
-	/* if this group has no more entries then remove it */
-	if (!nhg->num_nh)
-		remove_nexthop(net, nhp, nlinfo);
 }
 
 static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
@@ -745,6 +759,9 @@ static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
 
 	list_for_each_entry_safe(nhge, tmp, &nh->grp_list, nh_list)
 		remove_nh_grp_entry(net, nhge, nlinfo);
+
+	/* make sure all see the newly published array before releasing rtnl */
+	synchronize_rcu();
 }
 
 static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
@@ -758,10 +775,7 @@ static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
 		if (WARN_ON(!nhge->nh))
 			continue;
 
-		list_del(&nhge->nh_list);
-		nexthop_put(nhge->nh);
-		nhge->nh = NULL;
-		nhg->num_nh--;
+		list_del_init(&nhge->nh_list);
 	}
 }
 
@@ -1084,6 +1098,7 @@ static struct nexthop *nexthop_create_group(struct net *net,
 {
 	struct nlattr *grps_attr = cfg->nh_grp;
 	struct nexthop_grp *entry = nla_data(grps_attr);
+	u16 num_nh = nla_len(grps_attr) / sizeof(*entry);
 	struct nh_group *nhg;
 	struct nexthop *nh;
 	int i;
@@ -1094,12 +1109,21 @@ static struct nexthop *nexthop_create_group(struct net *net,
 
 	nh->is_group = 1;
 
-	nhg = nexthop_grp_alloc(nla_len(grps_attr) / sizeof(*entry));
+	nhg = nexthop_grp_alloc(num_nh);
 	if (!nhg) {
 		kfree(nh);
 		return ERR_PTR(-ENOMEM);
 	}
 
+	/* spare group used for removals */
+	nhg->spare = nexthop_grp_alloc(num_nh);
+	if (!nhg) {
+		kfree(nhg);
+		kfree(nh);
+		return NULL;
+	}
+	nhg->spare->spare = nhg;
+
 	for (i = 0; i < nhg->num_nh; ++i) {
 		struct nexthop *nhe;
 		struct nh_info *nhi;
@@ -1131,6 +1155,7 @@ static struct nexthop *nexthop_create_group(struct net *net,
 	for (; i >= 0; --i)
 		nexthop_put(nhg->nh_entries[i].nh);
 
+	kfree(nhg->spare);
 	kfree(nhg);
 	kfree(nh);
 
-- 
2.21.1 (Apple Git-122.3)

