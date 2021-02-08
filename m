Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B1C3140E6
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhBHUtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:49:40 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13383 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbhBHUpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:45:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a28f0001>; Mon, 08 Feb 2021 12:43:59 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:43:59 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:56 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 12/13] nexthop: Notify userspace about bucket migrations
Date:   Mon, 8 Feb 2021 21:42:55 +0100
Message-ID: <c9d7dc55595b2281af47dadd0ea2b27f332e31af.1612815058.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1612815057.git.petrm@nvidia.com>
References: <cover.1612815057.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612817040; bh=9qCeIJs02YEn/CnG2u8ubqJp/TZ1yxt3x8K9p3v/Yz4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=gPCPlJseLLwF28nYiq0JrF6KCYIEi3fUlX/vIZ2rGpT6l0y5XSgDTuUQeC3rNNoEO
         tpZbSNhCwObxXQ9ZcK7mZmaT/zg6dkSs7mvfNmTrntNdmRkciili0pR9xxxFv9zVbP
         1MiO+W7HeYfeNeZNLfkF7ZWftu2lgNbQt4QS4k4dt69DBN108uIyFc2ppQXqh9ZIGA
         57c5hqX0hQGLTQdDDdjrMp8i0kWs4s5nhgLZZFm8uV7DC9M28jRn6iyVxLy3X12Rjg
         8rZRzU6pYPkdi/Ed+Y6FM9MHf+2Qa38v/yihUHhxxMMr844RjmbQf9l0M8FFs2m9ip
         3i+ldeRHoQA5g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nexthop replacements et.al. are notified through netlink, but if a delayed
work migrates buckets on the background, userspace will stay oblivious.
Notify these as RTM_NEWNEXTHOPBUCKET events.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 76fa2018413f..4d89522fed4b 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -957,6 +957,34 @@ static int nh_fill_res_bucket(struct sk_buff *skb, str=
uct nexthop *nh,
 	return -EMSGSIZE;
 }
=20
+static void nexthop_bucket_notify(struct nh_res_table *res_table,
+				  u32 bucket_index)
+{
+	struct nh_res_bucket *bucket =3D &res_table->nh_buckets[bucket_index];
+	struct nh_grp_entry *nhge =3D nh_res_dereference(bucket->nh_entry);
+	struct nexthop *nh =3D nhge->nh_parent;
+	struct sk_buff *skb;
+	int err =3D -ENOBUFS;
+
+	skb =3D alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb)
+		goto errout;
+
+	err =3D nh_fill_res_bucket(skb, nh, bucket, bucket_index,
+				 RTM_NEWNEXTHOPBUCKET, 0, 0, NLM_F_REPLACE,
+				 NULL);
+	if (err < 0) {
+		kfree_skb(skb);
+		goto errout;
+	}
+
+	rtnl_notify(skb, nh->net, 0, RTNLGRP_NEXTHOP, NULL, GFP_KERNEL);
+	return;
+errout:
+	if (err < 0)
+		rtnl_set_sk_err(nh->net, RTNLGRP_NEXTHOP, err);
+}
+
 static bool valid_group_nh(struct nexthop *nh, unsigned int npaths,
 			   bool *is_fdb, struct netlink_ext_ack *extack)
 {
@@ -1470,7 +1498,8 @@ static bool nh_res_bucket_should_migrate(struct nh_re=
s_table *res_table,
 }
=20
 static bool nh_res_bucket_migrate(struct nh_res_table *res_table,
-				  u32 bucket_index, bool notify, bool force)
+				  u32 bucket_index, bool notify,
+				  bool notify_nl, bool force)
 {
 	struct nh_res_bucket *bucket =3D &res_table->nh_buckets[bucket_index];
 	struct nh_grp_entry *new_nhge;
@@ -1513,6 +1542,9 @@ static bool nh_res_bucket_migrate(struct nh_res_table=
 *res_table,
 	nh_res_bucket_set_nh(bucket, new_nhge);
 	nh_res_bucket_set_idle(res_table, bucket);
=20
+	if (notify_nl)
+		nexthop_bucket_notify(res_table, bucket_index);
+
 	if (nh_res_nhge_is_balanced(new_nhge))
 		list_del(&new_nhge->res.uw_nh_entry);
 	return true;
@@ -1520,7 +1552,8 @@ static bool nh_res_bucket_migrate(struct nh_res_table=
 *res_table,
=20
 #define NH_RES_UPKEEP_DW_MINIMUM_INTERVAL (HZ / 2)
=20
-static void nh_res_table_upkeep(struct nh_res_table *res_table, bool notif=
y)
+static void nh_res_table_upkeep(struct nh_res_table *res_table,
+				bool notify, bool notify_nl)
 {
 	unsigned long now =3D jiffies;
 	unsigned long deadline;
@@ -1545,7 +1578,7 @@ static void nh_res_table_upkeep(struct nh_res_table *=
res_table, bool notify)
 		if (nh_res_bucket_should_migrate(res_table, bucket,
 						 &deadline, &force)) {
 			if (!nh_res_bucket_migrate(res_table, i, notify,
-						   force)) {
+						   notify_nl, force)) {
 				unsigned long idle_point;
=20
 				/* A driver can override the migration
@@ -1586,7 +1619,7 @@ static void nh_res_table_upkeep_dw(struct work_struct=
 *work)
 	struct nh_res_table *res_table;
=20
 	res_table =3D container_of(dw, struct nh_res_table, upkeep_dw);
-	nh_res_table_upkeep(res_table, true);
+	nh_res_table_upkeep(res_table, true, true);
 }
=20
 static void nh_res_table_cancel_upkeep(struct nh_res_table *res_table)
@@ -1674,7 +1707,7 @@ static void replace_nexthop_grp_res(struct nh_group *=
oldg,
 	nh_res_group_rebalance(newg, old_res_table);
 	if (prev_has_uw && !list_empty(&old_res_table->uw_nh_entries))
 		old_res_table->unbalanced_since =3D prev_unbalanced_since;
-	nh_res_table_upkeep(old_res_table, true);
+	nh_res_table_upkeep(old_res_table, true, false);
 }
=20
 static void nh_mp_group_rebalance(struct nh_group *nhg)
@@ -2287,7 +2320,7 @@ static int insert_nexthop(struct net *net, struct nex=
thop *new_nh,
 			/* Do not send bucket notifications, we do full
 			 * notification below.
 			 */
-			nh_res_table_upkeep(res_table, false);
+			nh_res_table_upkeep(res_table, false, false);
 		}
 	}
=20
--=20
2.26.2

