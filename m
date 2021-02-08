Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65883140D7
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBHUrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:47:41 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16129 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbhBHUog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:44:36 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a2800000>; Mon, 08 Feb 2021 12:43:44 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:43:44 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:41 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 07/13] nexthop: Allow setting "offload" and "trap" indication of nexthop buckets
Date:   Mon, 8 Feb 2021 21:42:50 +0100
Message-ID: <6bfcbfe2cd815fa1047ea411db870e36edd781e8.1612815058.git.petrm@nvidia.com>
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
        t=1612817024; bh=zjA5qYGudIMCdmLniBmB8CylmUnJyxwpT61JcR6iP3A=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=aE6A5a6pB9yJncXZ0HLq/N/EBsDgbS4+gYNC4PvI6/Ibug8BAyH8pkz5kTVw8O0E5
         i41sGGBnN8fAFdnKcRhOh+T/EO+PAI/tTAPhwEf7dGEuWIFM75CfAo0M8t1xowe42e
         d/XaDq/vdoMhucsAT6N+1upd92iz7Bt1PTQEdT0W/rvosiSmNkLv4D7gcq1/4JjBp7
         7klelXc/z08xQTtq8iaTH+yTp3p3SRC/6giNncUVCbfRLzgq3I4EpcmAXC/nwFoRRN
         4yWwsmunRUOYaLFQqobujaoebTgJxDcTtwybA0KrKS/qmm9zkRNyHapvlHoPthtgjI
         aawl9TfI6PxhQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add a function that can be called by device drivers to set "offload" or
"trap" indication on nexthop buckets following nexthop notifications and
other changes such as a neighbour becoming invalid.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 include/net/nexthop.h |  2 ++
 net/ipv4/nexthop.c    | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 97138357755e..e1c30584e601 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -219,6 +219,8 @@ int register_nexthop_notifier(struct net *net, struct n=
otifier_block *nb,
 			      struct netlink_ext_ack *extack);
 int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb=
);
 void nexthop_set_hw_flags(struct net *net, u32 id, bool offload, bool trap=
);
+void nexthop_bucket_set_hw_flags(struct net *net, u32 id, u32 bucket_index=
,
+				 bool offload, bool trap);
=20
 /* caller is holding rcu or rtnl; no reference taken to nexthop */
 struct nexthop *nexthop_find_by_id(struct net *net, u32 id);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index fe91f3a0fb1e..aa5c8343ded7 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -3065,6 +3065,40 @@ void nexthop_set_hw_flags(struct net *net, u32 id, b=
ool offload, bool trap)
 }
 EXPORT_SYMBOL(nexthop_set_hw_flags);
=20
+void nexthop_bucket_set_hw_flags(struct net *net, u32 id, u32 bucket_index=
,
+				 bool offload, bool trap)
+{
+	struct nh_res_table *res_table;
+	struct nh_res_bucket *bucket;
+	struct nexthop *nexthop;
+	struct nh_group *nhg;
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
+	if (bucket_index >=3D nhg->res_table->num_nh_buckets)
+		goto out;
+
+	res_table =3D rcu_dereference(nhg->res_table);
+	bucket =3D &res_table->nh_buckets[bucket_index];
+	bucket->nh_flags &=3D ~(RTNH_F_OFFLOAD | RTNH_F_TRAP);
+	if (offload)
+		bucket->nh_flags |=3D RTNH_F_OFFLOAD;
+	if (trap)
+		bucket->nh_flags |=3D RTNH_F_TRAP;
+
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(nexthop_bucket_set_hw_flags);
+
 static void __net_exit nexthop_net_exit(struct net *net)
 {
 	rtnl_lock();
--=20
2.26.2

