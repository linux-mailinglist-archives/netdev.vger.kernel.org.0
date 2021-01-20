Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5AB2FD702
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbhATRZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:25:35 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12385 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387695AbhATPpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 10:45:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60084ff00000>; Wed, 20 Jan 2021 07:44:48 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan
 2021 15:44:45 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 2/3] nexthop: Use a dedicated policy for nh_valid_dump_req()
Date:   Wed, 20 Jan 2021 16:44:11 +0100
Message-ID: <6d799e1d8d5c4b3e079554b42912842887335092.1611156111.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1611156111.git.petrm@nvidia.com>
References: <cover.1611156111.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611157488; bh=dKA6GCfS7aImpmHTl5FOO9nDWrNJzFYK8zLuIM1DY7c=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=b5ruO+HtlQh+rnSDfaQ/W3Ay4jJfofdODu1ltn1OTzxq2zCKWm93mVNWNWBaEj2LI
         H67lmqtJQ0SCIQga0oDWaNeGOhlASA9TX5r5aMYp+d5mYE1XZ2jZkkRP0AI3KSEWfa
         eQlSZtn4APeQ8TuuzzXPScJtBdY6zbOyq8+O2CuQvreDttK44GAyASwCLgpA53H1K7
         RmNXkydEddx5JvUFw2U0tHAlCl9j6P3U45eNrhdqesQ2epvJhnjw2DAsoQwr0UliRx
         mIE05HZKJAAbXH80JMA4kRtV6LCA6HJZFBXeBO0Jr+FrjiwRLDnWUHyzUGw/Y+EQER
         h2gRUeRg2OXfw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function uses the global nexthop policy, but only accepts four
particular attributes. Create a new policy that only includes the four
supported attributes, and use it. Convert the loop to a series of ifs.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v2:
    - Do not specify size of the policy array. Use ARRAY_SIZE instead
      of NHA_MAX
    - Convert manual setting of true to nla_get_flag().

 net/ipv4/nexthop.c | 60 +++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 391079ff1bb5..bbea78ea4870 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -40,6 +40,13 @@ static const struct nla_policy rtm_nh_policy_get[] =3D {
 	[NHA_ID]		=3D { .type =3D NLA_U32 },
 };
=20
+static const struct nla_policy rtm_nh_policy_dump[] =3D {
+	[NHA_OIF]		=3D { .type =3D NLA_U32 },
+	[NHA_GROUPS]		=3D { .type =3D NLA_FLAG },
+	[NHA_MASTER]		=3D { .type =3D NLA_U32 },
+	[NHA_FDB]		=3D { .type =3D NLA_FLAG },
+};
+
 static bool nexthop_notifiers_is_empty(struct net *net)
 {
 	return !net->nexthop.notifier_chain.head;
@@ -1983,48 +1990,35 @@ static int nh_valid_dump_req(const struct nlmsghdr =
*nlh, int *dev_idx,
 			     bool *fdb_filter, struct netlink_callback *cb)
 {
 	struct netlink_ext_ack *extack =3D cb->extack;
-	struct nlattr *tb[NHA_MAX + 1];
+	struct nlattr *tb[ARRAY_SIZE(rtm_nh_policy_dump)];
 	struct nhmsg *nhm;
-	int err, i;
+	int err;
 	u32 idx;
=20
-	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
-			  NULL);
+	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb,
+			  ARRAY_SIZE(rtm_nh_policy_dump) - 1,
+			  rtm_nh_policy_dump, NULL);
 	if (err < 0)
 		return err;
=20
-	for (i =3D 0; i <=3D NHA_MAX; ++i) {
-		if (!tb[i])
-			continue;
-
-		switch (i) {
-		case NHA_OIF:
-			idx =3D nla_get_u32(tb[i]);
-			if (idx > INT_MAX) {
-				NL_SET_ERR_MSG(extack, "Invalid device index");
-				return -EINVAL;
-			}
-			*dev_idx =3D idx;
-			break;
-		case NHA_MASTER:
-			idx =3D nla_get_u32(tb[i]);
-			if (idx > INT_MAX) {
-				NL_SET_ERR_MSG(extack, "Invalid master device index");
-				return -EINVAL;
-			}
-			*master_idx =3D idx;
-			break;
-		case NHA_GROUPS:
-			*group_filter =3D true;
-			break;
-		case NHA_FDB:
-			*fdb_filter =3D true;
-			break;
-		default:
-			NL_SET_ERR_MSG(extack, "Unsupported attribute in dump request");
+	if (tb[NHA_OIF]) {
+		idx =3D nla_get_u32(tb[NHA_OIF]);
+		if (idx > INT_MAX) {
+			NL_SET_ERR_MSG(extack, "Invalid device index");
+			return -EINVAL;
+		}
+		*dev_idx =3D idx;
+	}
+	if (tb[NHA_MASTER]) {
+		idx =3D nla_get_u32(tb[NHA_MASTER]);
+		if (idx > INT_MAX) {
+			NL_SET_ERR_MSG(extack, "Invalid master device index");
 			return -EINVAL;
 		}
+		*master_idx =3D idx;
 	}
+	*group_filter =3D nla_get_flag(tb[NHA_GROUPS]);
+	*fdb_filter =3D nla_get_flag(tb[NHA_FDB]);
=20
 	nhm =3D nlmsg_data(nlh);
 	if (nhm->nh_protocol || nhm->resvd || nhm->nh_scope || nhm->nh_flags) {
--=20
2.26.2

