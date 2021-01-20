Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D364E2FD704
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbhATR0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:26:10 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11448 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388872AbhATPpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 10:45:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60084ff30001>; Wed, 20 Jan 2021 07:44:51 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan
 2021 15:44:48 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 3/3] nexthop: Specialize rtm_nh_policy
Date:   Wed, 20 Jan 2021 16:44:12 +0100
Message-ID: <2d81065f0ea682aa00dd4f32c52f219d6f2e7022.1611156111.git.petrm@nvidia.com>
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
        t=1611157491; bh=3xkVkoNAb24R6SpOFZ9qkPl6t00zhFL6+pB8NSVfU/Q=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=bFjoZmU/YJ9tcOTtaQN0V9LwI9xgGIVxy2Rv077RKvJZarD2zwGZlIpftWwXvXrWy
         60Ionjod+YSJ4U1Ag2sbqYNRB8txbbzXIV9exd36qovzvuoglcfVyUTKcbBgnh4vpu
         b+WVaYSLY96mA2aH4km7+G2YuZb6Wvddk8xKgzBrp3S09xujDyKKfauSL3dpu7av/C
         h2Dw4d5m9/Exz80IQ6dbhT7XLdG6bZyuiyTvMKwrGJ5vtjAqO6GLFRu+jG8WlJDfqx
         d3EEg0RbjTMhzzZvLaiEaHklNytUCmZ+sMct44/fjbfFq+eWF7Eei7MDI2nWINIhke
         UQ9/vToFn+g6A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This policy is currently only used for creation of new next hops and new
next hop groups. Rename it accordingly and remove the two attributes that
are not valid in that context: NHA_GROUPS and NHA_MASTER.

For consistency with other policies, do not mention policy array size in
the declarator, and replace NHA_MAX for ARRAY_SIZE as appropriate.

Note that with this commit, NHA_MAX and __NHA_MAX are not used anymore.
Leave them in purely as a user API.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v2:
    - Do not specify size of the policy array. Use ARRAY_SIZE instead
      of NHA_MAX

 net/ipv4/nexthop.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index bbea78ea4870..e6dfca426242 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -22,7 +22,7 @@ static void remove_nexthop(struct net *net, struct nextho=
p *nh,
 #define NH_DEV_HASHBITS  8
 #define NH_DEV_HASHSIZE (1U << NH_DEV_HASHBITS)
=20
-static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] =3D {
+static const struct nla_policy rtm_nh_policy_new[] =3D {
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
@@ -576,7 +574,8 @@ static int nh_check_attr_fdb_group(struct nexthop *nh, =
u8 *nh_family,
 	return 0;
 }
=20
-static int nh_check_attr_group(struct net *net, struct nlattr *tb[],
+static int nh_check_attr_group(struct net *net,
+			       struct nlattr *tb[], size_t tb_size,
 			       struct netlink_ext_ack *extack)
 {
 	unsigned int len =3D nla_len(tb[NHA_GROUP]);
@@ -635,7 +634,7 @@ static int nh_check_attr_group(struct net *net, struct =
nlattr *tb[],
 			return -EINVAL;
 		}
 	}
-	for (i =3D NHA_GROUP_TYPE + 1; i < __NHA_MAX; ++i) {
+	for (i =3D NHA_GROUP_TYPE + 1; i < tb_size; ++i) {
 		if (!tb[i])
 			continue;
 		if (i =3D=3D NHA_FDB)
@@ -1654,11 +1653,12 @@ static int rtm_to_nh_config(struct net *net, struct=
 sk_buff *skb,
 			    struct netlink_ext_ack *extack)
 {
 	struct nhmsg *nhm =3D nlmsg_data(nlh);
-	struct nlattr *tb[NHA_MAX + 1];
+	struct nlattr *tb[ARRAY_SIZE(rtm_nh_policy_new)];
 	int err;
=20
-	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
-			  extack);
+	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb,
+			  ARRAY_SIZE(rtm_nh_policy_new) - 1,
+			  rtm_nh_policy_new, extack);
 	if (err < 0)
 		return err;
=20
@@ -1685,11 +1685,6 @@ static int rtm_to_nh_config(struct net *net, struct =
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
@@ -1731,7 +1726,7 @@ static int rtm_to_nh_config(struct net *net, struct s=
k_buff *skb,
 			NL_SET_ERR_MSG(extack, "Invalid group type");
 			goto out;
 		}
-		err =3D nh_check_attr_group(net, tb, extack);
+		err =3D nh_check_attr_group(net, tb, ARRAY_SIZE(tb), extack);
=20
 		/* no other attributes should be set */
 		goto out;
--=20
2.26.2

