Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D773140DF
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbhBHUsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:48:51 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7071 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbhBHUon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:44:43 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a2830000>; Mon, 08 Feb 2021 12:43:47 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:43:47 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:44 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 08/13] nexthop: Allow reporting activity of nexthop buckets
Date:   Mon, 8 Feb 2021 21:42:51 +0100
Message-ID: <3aad399ba65d7942546bb5ea53968cb299f58610.1612815058.git.petrm@nvidia.com>
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
        t=1612817027; bh=+C5mUoUIkKR1IRP6LILbRa8NPwM5Af8163tpbOTzj2M=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=WcFe+sybruobLzYFQCKnw2KGTVjbZ2BoRgLdimKAsiM5XysKMrprrZcaux4a5E1H3
         SnN0kxSWCEtWor8Bcmvk+TAdQciPS4upM/FuaJklSa3J3ADv5UvCoBKo6v4PutjKXq
         tLVbUfTK/LpeLvYzgwxj8v6OGDKGNwh22LDJ785hb6ilDuy/EhfIHfLc9GnhxS1ciN
         hSU30miK+zy0QrJF83rDmtuOQ/wM9JF7GrSuuGL/sjaD+bRG4klqTJdtyzAzyGhVWP
         ZS9TF209k/JBZg2+7XPMiVoPX3umUAqDoU+4GHJl9RC7yOBIizLFaXEM3hR5eanCMD
         1X3DVFhjULexA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The kernel periodically checks the idle time of nexthop buckets to
determine if they are idle and can be re-populated with a new nexthop.

When the resilient nexthop group is offloaded to hardware, the kernel
will not see activity on nexthop buckets unless it is reported from
hardware.

Add a function that can be periodically called by device drivers to
report activity on nexthop buckets after querying it from the underlying
device.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 include/net/nexthop.h |  2 ++
 net/ipv4/nexthop.c    | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index e1c30584e601..406bf0d959c6 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -221,6 +221,8 @@ int unregister_nexthop_notifier(struct net *net, struct=
 notifier_block *nb);
 void nexthop_set_hw_flags(struct net *net, u32 id, bool offload, bool trap=
);
 void nexthop_bucket_set_hw_flags(struct net *net, u32 id, u32 bucket_index=
,
 				 bool offload, bool trap);
+void nexthop_res_grp_activity_update(struct net *net, u32 id, u32 num_buck=
ets,
+				     unsigned long *activity);
=20
 /* caller is holding rcu or rtnl; no reference taken to nexthop */
 struct nexthop *nexthop_find_by_id(struct net *net, u32 id);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index aa5c8343ded7..0e80d34b20a7 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -3099,6 +3099,41 @@ void nexthop_bucket_set_hw_flags(struct net *net, u3=
2 id, u32 bucket_index,
 }
 EXPORT_SYMBOL(nexthop_bucket_set_hw_flags);
=20
+void nexthop_res_grp_activity_update(struct net *net, u32 id, u32 num_buck=
ets,
+				     unsigned long *activity)
+{
+	struct nh_res_table *res_table;
+	struct nexthop *nexthop;
+	struct nh_group *nhg;
+	u32 i;
+
+	rcu_read_lock();
+
+	nexthop =3D nexthop_find_by_id(net, id);
+	if (!nexthop || !nexthop->is_group)
+		goto out;
+
+	nhg =3D rcu_dereference(nexthop->nh_grp);
+	if (!nhg->resilient)
+		goto out;
+
+	/* Instead of silently ignoring some buckets, demand that the sizes
+	 * be the same.
+	 */
+	if (num_buckets !=3D nhg->res_table->num_nh_buckets)
+		goto out;
+
+	res_table =3D rcu_dereference(nhg->res_table);
+	for (i =3D 0; i < num_buckets; i++) {
+		if (test_bit(i, activity))
+			nh_res_bucket_set_busy(&res_table->nh_buckets[i]);
+	}
+
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(nexthop_res_grp_activity_update);
+
 static void __net_exit nexthop_net_exit(struct net *net)
 {
 	rtnl_lock();
--=20
2.26.2

