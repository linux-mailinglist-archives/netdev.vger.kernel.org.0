Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16973140D4
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhBHUqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:46:53 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7061 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbhBHUoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:44:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a2740000>; Mon, 08 Feb 2021 12:43:32 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:43:31 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:28 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 03/13] nexthop: Add netlink defines and enumerators for resilient NH groups
Date:   Mon, 8 Feb 2021 21:42:46 +0100
Message-ID: <893e22e2ad6413a98ca76134b332c8962fcd3b6a.1612815058.git.petrm@nvidia.com>
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
        t=1612817012; bh=Yq+ezgN7ngGDNkayO1Kk0hAjjTUweNF61TKWMtCLAlw=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=f5j25qFysOoEj4FA/uQRdEH3cKFkC/4/qcJzbBJtRjxMJJdxRtGWVe/3nE4duZyAc
         2pexHNpZwo+oULZMQVUOY3qHi5uh+7+WCyT5T5wOwfrm3ILG4SZ1l2H8a8qWeywgXy
         ZEEuIiZXV8F6a+qWw9PaVJnGNB/O3AIK3JlQYcNJJvK6t9Csg7bj3qNhmhCTh7n1ye
         Ej5bqBCaTxPQUlhlZuz/GISI0+iCWc0ZQDDwqMiuG3Q8Vzy3WT1fOvEbb7oB8eEe2O
         OYyXFCpPH4Fwrb5eFX+CU+tVQr9xf2daDZnuLtB6xR1Wl/GSbLCffbnk8+yzTv+kvS
         qhfpnyzZnid1g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

- RTM_NEWNEXTHOP et.al. that handle resilient groups will have a new nested
  attribute, NHA_RES_GROUP, whose elements are attributes NHA_RES_GROUP_*.

- RTM_NEWNEXTHOPBUCKET et.al. is a suite of new messages that will
  currently serve only for dumping of individual buckets of resilient next
  hop groups. For nexthop group buckets, these messages will carry a nested
  attribute NHA_RES_BUCKET, whose elements are attributes NHA_RES_BUCKET_*.

  There are several reasons why a new suite of messages is created for
  nexthop buckets instead of overloading the information on the existing
  RTM_{NEW,DEL,GET}NEXTHOP messages.

  First, a nexthop group can contain a large number of nexthop buckets (4k
  is not unheard of). This imposes limits on the amount of information that
  can be encoded for each nexthop bucket given a netlink message is limited
  to 64k bytes.

  Second, while RTM_NEWNEXTHOPBUCKET is only used for notifications at
  this point, in the future it can be extended to provide user space with
  control over nexthop buckets configuration.

- The new group type is NEXTHOP_GRP_TYPE_RES. Note that nexthop code is
  adjusted to bounce groups with that type for now.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 include/uapi/linux/nexthop.h   | 43 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/rtnetlink.h |  7 ++++++
 net/ipv4/nexthop.c             |  2 ++
 security/selinux/nlmsgtab.c    |  5 +++-
 4 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nexthop.h b/include/uapi/linux/nexthop.h
index 2d4a1e784cf0..624460bc2d93 100644
--- a/include/uapi/linux/nexthop.h
+++ b/include/uapi/linux/nexthop.h
@@ -22,6 +22,7 @@ struct nexthop_grp {
=20
 enum {
 	NEXTHOP_GRP_TYPE_MPATH,  /* default type if not specified */
+	NEXTHOP_GRP_TYPE_RES,    /* resilient nexthop group */
 	__NEXTHOP_GRP_TYPE_MAX,
 };
=20
@@ -52,8 +53,50 @@ enum {
 	NHA_FDB,	/* flag; nexthop belongs to a bridge fdb */
 	/* if NHA_FDB is added, OIF, BLACKHOLE, ENCAP cannot be set */
=20
+	/* nested; resilient nexthop group attributes */
+	NHA_RES_GROUP,
+	/* nested; nexthop bucket attributes */
+	NHA_RES_BUCKET,
+
 	__NHA_MAX,
 };
=20
 #define NHA_MAX	(__NHA_MAX - 1)
+
+enum {
+	NHA_RES_GROUP_UNSPEC,
+	/* Pad attribute for 64-bit alignment. */
+	NHA_RES_GROUP_PAD =3D NHA_RES_GROUP_UNSPEC,
+
+	/* u32; number of nexthop buckets in a resilient nexthop group */
+	NHA_RES_GROUP_BUCKETS,
+	/* clock_t as u32; nexthop bucket idle timer (per-group) */
+	NHA_RES_GROUP_IDLE_TIMER,
+	/* clock_t as u32; nexthop unbalanced timer */
+	NHA_RES_GROUP_UNBALANCED_TIMER,
+	/* clock_t as u64; nexthop unbalanced time */
+	NHA_RES_GROUP_UNBALANCED_TIME,
+
+	__NHA_RES_GROUP_MAX,
+};
+
+#define NHA_RES_GROUP_MAX	(__NHA_RES_GROUP_MAX - 1)
+
+enum {
+	NHA_RES_BUCKET_UNSPEC,
+	/* Pad attribute for 64-bit alignment. */
+	NHA_RES_BUCKET_PAD =3D NHA_RES_BUCKET_UNSPEC,
+
+	/* u32; nexthop bucket index */
+	NHA_RES_BUCKET_INDEX,
+	/* clock_t as u64; nexthop bucket idle time */
+	NHA_RES_BUCKET_IDLE_TIME,
+	/* u32; nexthop id assigned to the nexthop bucket */
+	NHA_RES_BUCKET_NH_ID,
+
+	__NHA_RES_BUCKET_MAX,
+};
+
+#define NHA_RES_BUCKET_MAX	(__NHA_RES_BUCKET_MAX - 1)
+
 #endif
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.=
h
index 91e4ca064d61..d35953bc7d53 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -178,6 +178,13 @@ enum {
 	RTM_GETVLAN,
 #define RTM_GETVLAN	RTM_GETVLAN
=20
+	RTM_NEWNEXTHOPBUCKET =3D 116,
+#define RTM_NEWNEXTHOPBUCKET	RTM_NEWNEXTHOPBUCKET
+	RTM_DELNEXTHOPBUCKET,
+#define RTM_DELNEXTHOPBUCKET	RTM_DELNEXTHOPBUCKET
+	RTM_GETNEXTHOPBUCKET,
+#define RTM_GETNEXTHOPBUCKET	RTM_GETNEXTHOPBUCKET
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 7b687bca0b87..5d560d381070 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1486,6 +1486,8 @@ static struct nexthop *nexthop_create_group(struct ne=
t *net,
=20
 	if (cfg->nh_grp_type =3D=3D NEXTHOP_GRP_TYPE_MPATH)
 		nhg->mpath =3D 1;
+	else if (cfg->nh_grp_type =3D=3D NEXTHOP_GRP_TYPE_RES)
+		goto out_no_nh;
=20
 	WARN_ON_ONCE(nhg->mpath !=3D 1);
=20
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index b69231918686..d59276f48d4f 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -88,6 +88,9 @@ static const struct nlmsg_perm nlmsg_route_perms[] =3D
 	{ RTM_NEWVLAN,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELVLAN,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETVLAN,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_NEWNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_DELNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_GETNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 };
=20
 static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =3D
@@ -171,7 +174,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u3=
2 *perm)
 		 * structures at the top of this file with the new mappings
 		 * before updating the BUILD_BUG_ON() macro!
 		 */
-		BUILD_BUG_ON(RTM_MAX !=3D (RTM_NEWVLAN + 3));
+		BUILD_BUG_ON(RTM_MAX !=3D (RTM_NEWNEXTHOPBUCKET + 3));
 		err =3D nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
 				 sizeof(nlmsg_route_perms));
 		break;
--=20
2.26.2

