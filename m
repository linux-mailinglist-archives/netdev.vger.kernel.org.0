Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F5B2FA290
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 15:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392698AbhAROHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 09:07:52 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1520 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391401AbhAROG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 09:06:58 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600595da0000>; Mon, 18 Jan 2021 06:06:18 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 14:06:15 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 3/3] nexthop: Specialize rtm_nh_policy
Date:   Mon, 18 Jan 2021 15:05:25 +0100
Message-ID: <13520c35442244c0d622372c12708477ac72146f.1610978306.git.petrm@nvidia.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1610978306.git.petrm@nvidia.org>
References: <cover.1610978306.git.petrm@nvidia.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610978778; bh=iJTrpCCyb0kZwJ3whsWd3V8sekBYHFGuYMplbXmvo84=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=bu8dicTheUpEw7ubmc1yEooUdHx5a9gmfTFROKVYQM/74uMRxVLk40U8UaqmbmeNS
         Fn22QEDJ2un0PYyc/rFMdea0koz7uh8Dy3pE7lf2R265sIHcpawzpYybWwSF/ud09i
         zj+A45suQcFcW97XbyBE75qEWa8pIlqarNhb2EQZNOiBYYcDMXb/vZDBlwULUsNfhZ
         7b2QLOsN6mkGoJF7RKccP+Vr8W5fuA/VsGhsR63npKh+Rju43WqXjK1BwbvByH2+xm
         S+sdL/PzW+0fyykItcqongAda7bcT9+L+mxBTAYWaj4O1ys/B360mAB6M2+fJn1qwx
         HvA0is3wPg2UA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This policy is currently only used for creation of new next hops and new
next hop groups. Rename it accordingly and remove the two attributes that
are not valid in that context: NHA_GROUPS and NHA_MASTER.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 226d73cbc468..0e5a574a4070 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -22,7 +22,7 @@ static void remove_nexthop(struct net *net, struct nextho=
p *nh,
 #define NH_DEV_HASHBITS  8
 #define NH_DEV_HASHSIZE (1U << NH_DEV_HASHBITS)
=20
-static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] =3D {
+static const struct nla_policy rtm_nh_policy_new[NHA_MAX + 1] =3D {
 	[NHA_ID]		=3D { .type =3D NLA_U32 },
 	[NHA_GROUP]		=3D { .type =3D NLA_BINARY },
 	[NHA_GROUP_TYPE]	=3D { .type =3D NLA_U16 },
@@ -31,8 +31,6 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1]=
 =3D {
 	[NHA_GATEWAY]		=3D { .type =3D NLA_BINARY },
 	[NHA_ENCAP_TYPE]	=3D { .type =3D NLA_U16 },
 	[NHA_ENCAP]		=3D { .type =3D NLA_NESTED },
-	[NHA_GROUPS]		=3D { .type =3D NLA_FLAG },
-	[NHA_MASTER]		=3D { .type =3D NLA_U32 },
 	[NHA_FDB]		=3D { .type =3D NLA_FLAG },
 };
=20
@@ -1657,7 +1655,7 @@ static int rtm_to_nh_config(struct net *net, struct s=
k_buff *skb,
 	struct nlattr *tb[NHA_MAX + 1];
 	int err;
=20
-	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
+	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy_new,
 			  extack);
 	if (err < 0)
 		return err;
@@ -1685,11 +1683,6 @@ static int rtm_to_nh_config(struct net *net, struct =
sk_buff *skb,
 		goto out;
 	}
=20
-	if (tb[NHA_GROUPS] || tb[NHA_MASTER]) {
-		NL_SET_ERR_MSG(extack, "Invalid attributes in request");
-		goto out;
-	}
-
 	memset(cfg, 0, sizeof(*cfg));
 	cfg->nlflags =3D nlh->nlmsg_flags;
 	cfg->nlinfo.portid =3D NETLINK_CB(skb).portid;
--=20
2.26.2

