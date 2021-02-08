Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 145843140E7
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhBHUt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:49:59 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7218 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhBHUqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:46:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a2860002>; Mon, 08 Feb 2021 12:43:50 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:43:50 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:47 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 09/13] nexthop: Add netlink handlers for resilient nexthop groups
Date:   Mon, 8 Feb 2021 21:42:52 +0100
Message-ID: <3b23cbca7c0a42025bf372991d6ef766726c441c.1612815058.git.petrm@nvidia.com>
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
        t=1612817030; bh=Xz+ShZmFgHJpQ7eEQtrfSqxnYk0C36sVBvkieeDp6iw=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=JM46CXgRXK7NCRXNcCZlzXg0Z/MqI2KCPn44ikWf0/KM/WIZ81QCilXLg352e7MPk
         TVqWVz9Z174can8r85QSnTn1hRa53rDMV1vVbeAGn1JXrxSmyah2MoS+ek3BUIsT7/
         OYMC7NfhYO7C7ChGoG8URpDRIuo4R5ZCHSQDdNGDJOgwLxeCAOHbMpCW3pcwx1U17N
         LAD6oLboGXk+UlFw8rsvQFnXQcmhUs8qvaotMxZU/b482tig7dKGHUhkC/CAyaMk0q
         bbwXD7c1pO2/pAMojooDxiaxXowq5Ca6Pp4KK7yQFrhhNr/avPFiv8SjpxK9GZFGUn
         DmJ/4LfH1PwgQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the netlink messages that allow creation and dumping of resilient
nexthop groups.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 150 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 145 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 0e80d34b20a7..1118189190fd 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -16,6 +16,9 @@
 #include <net/route.h>
 #include <net/sock.h>
=20
+#define NH_RES_DEFAULT_IDLE_TIMER	(120 * HZ)
+#define NH_RES_DEFAULT_UNBALANCED_TIMER	0	/* No forced rebalancing. */
+
 static void remove_nexthop(struct net *net, struct nexthop *nh,
 			   struct nl_info *nlinfo);
=20
@@ -32,6 +35,7 @@ static const struct nla_policy rtm_nh_policy_new[] =3D {
 	[NHA_ENCAP_TYPE]	=3D { .type =3D NLA_U16 },
 	[NHA_ENCAP]		=3D { .type =3D NLA_NESTED },
 	[NHA_FDB]		=3D { .type =3D NLA_FLAG },
+	[NHA_RES_GROUP]		=3D { .type =3D NLA_NESTED },
 };
=20
 static const struct nla_policy rtm_nh_policy_get[] =3D {
@@ -45,6 +49,12 @@ static const struct nla_policy rtm_nh_policy_dump[] =3D =
{
 	[NHA_FDB]		=3D { .type =3D NLA_FLAG },
 };
=20
+static const struct nla_policy rtm_nh_res_policy_new[] =3D {
+	[NHA_RES_GROUP_BUCKETS]			=3D { .type =3D NLA_U32 },
+	[NHA_RES_GROUP_IDLE_TIMER]		=3D { .type =3D NLA_U32 },
+	[NHA_RES_GROUP_UNBALANCED_TIMER]	=3D { .type =3D NLA_U32 },
+};
+
 static bool nexthop_notifiers_is_empty(struct net *net)
 {
 	return !net->nexthop.notifier_chain.head;
@@ -588,6 +598,41 @@ static void nh_res_time_set_deadline(unsigned long nex=
t_time,
 		*deadline =3D next_time;
 }
=20
+static clock_t nh_res_table_unbalanced_time(struct nh_res_table *res_table=
)
+{
+	if (list_empty(&res_table->uw_nh_entries))
+		return 0;
+	return jiffies_delta_to_clock_t(jiffies - res_table->unbalanced_since);
+}
+
+static int nla_put_nh_group_res(struct sk_buff *skb, struct nh_group *nhg)
+{
+	struct nh_res_table *res_table =3D rtnl_dereference(nhg->res_table);
+	struct nlattr *nest;
+
+	nest =3D nla_nest_start(skb, NHA_RES_GROUP);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, NHA_RES_GROUP_BUCKETS,
+			res_table->num_nh_buckets) ||
+	    nla_put_u32(skb, NHA_RES_GROUP_IDLE_TIMER,
+			jiffies_to_clock_t(res_table->idle_timer)) ||
+	    nla_put_u32(skb, NHA_RES_GROUP_UNBALANCED_TIMER,
+			jiffies_to_clock_t(res_table->unbalanced_timer)) ||
+	    nla_put_u64_64bit(skb, NHA_RES_GROUP_UNBALANCED_TIME,
+			      nh_res_table_unbalanced_time(res_table),
+			      NHA_RES_GROUP_PAD))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
 static int nla_put_nh_group(struct sk_buff *skb, struct nh_group *nhg)
 {
 	struct nexthop_grp *p;
@@ -598,6 +643,8 @@ static int nla_put_nh_group(struct sk_buff *skb, struct=
 nh_group *nhg)
=20
 	if (nhg->mpath)
 		group_type =3D NEXTHOP_GRP_TYPE_MPATH;
+	else if (nhg->resilient)
+		group_type =3D NEXTHOP_GRP_TYPE_RES;
=20
 	if (nla_put_u16(skb, NHA_GROUP_TYPE, group_type))
 		goto nla_put_failure;
@@ -613,6 +660,9 @@ static int nla_put_nh_group(struct sk_buff *skb, struct=
 nh_group *nhg)
 		p +=3D 1;
 	}
=20
+	if (nhg->resilient && nla_put_nh_group_res(skb, nhg))
+		goto nla_put_failure;
+
 	return 0;
=20
 nla_put_failure:
@@ -700,13 +750,26 @@ static int nh_fill_node(struct sk_buff *skb, struct n=
exthop *nh,
 	return -EMSGSIZE;
 }
=20
+static size_t nh_nlmsg_size_grp_res(struct nh_group *nhg)
+{
+	return nla_total_size(0) +	/* NHA_RES_GROUP */
+		nla_total_size(4) +	/* NHA_RES_GROUP_BUCKETS */
+		nla_total_size(4) +	/* NHA_RES_GROUP_IDLE_TIMER */
+		nla_total_size(4) +	/* NHA_RES_GROUP_UNBALANCED_TIMER */
+		nla_total_size_64bit(8);/* NHA_RES_GROUP_UNBALANCED_TIME */
+}
+
 static size_t nh_nlmsg_size_grp(struct nexthop *nh)
 {
 	struct nh_group *nhg =3D rtnl_dereference(nh->nh_grp);
 	size_t sz =3D sizeof(struct nexthop_grp) * nhg->num_nh;
+	size_t tot =3D nla_total_size(sz) +
+		nla_total_size(2); /* NHA_GROUP_TYPE */
+
+	if (nhg->resilient)
+		tot +=3D nh_nlmsg_size_grp_res(nhg);
=20
-	return nla_total_size(sz) +
-	       nla_total_size(2);  /* NHA_GROUP_TYPE */
+	return tot;
 }
=20
 static size_t nh_nlmsg_size_single(struct nexthop *nh)
@@ -876,7 +939,7 @@ static int nh_check_attr_fdb_group(struct nexthop *nh, =
u8 *nh_family,
=20
 static int nh_check_attr_group(struct net *net,
 			       struct nlattr *tb[], size_t tb_size,
-			       struct netlink_ext_ack *extack)
+			       u16 nh_grp_type, struct netlink_ext_ack *extack)
 {
 	unsigned int len =3D nla_len(tb[NHA_GROUP]);
 	u8 nh_family =3D AF_UNSPEC;
@@ -937,8 +1000,14 @@ static int nh_check_attr_group(struct net *net,
 	for (i =3D NHA_GROUP_TYPE + 1; i < tb_size; ++i) {
 		if (!tb[i])
 			continue;
-		if (i =3D=3D NHA_FDB)
+		switch (i) {
+		case NHA_FDB:
 			continue;
+		case NHA_RES_GROUP:
+			if (nh_grp_type =3D=3D NEXTHOP_GRP_TYPE_RES)
+				continue;
+			break;
+		}
 		NL_SET_ERR_MSG(extack,
 			       "No other attributes can be set in nexthop groups");
 		return -EINVAL;
@@ -2468,6 +2537,70 @@ static struct nexthop *nexthop_add(struct net *net, =
struct nh_config *cfg,
 	return nh;
 }
=20
+static int rtm_nh_get_timer(struct nlattr *attr, unsigned long fallback,
+			    unsigned long *timer_p, bool *has_p,
+			    struct netlink_ext_ack *extack)
+{
+	unsigned long timer;
+	u32 value;
+
+	if (!attr) {
+		*timer_p =3D fallback;
+		*has_p =3D false;
+		return 0;
+	}
+
+	value =3D nla_get_u32(attr);
+	timer =3D clock_t_to_jiffies(value);
+	if (timer =3D=3D ~0UL) {
+		NL_SET_ERR_MSG(extack, "Timer value too large");
+		return -EINVAL;
+	}
+
+	*timer_p =3D timer;
+	*has_p =3D true;
+	return 0;
+}
+
+static int rtm_to_nh_config_grp_res(struct nlattr *res, struct nh_config *=
cfg,
+				    struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[ARRAY_SIZE(rtm_nh_res_policy_new)] =3D {};
+	int err;
+
+	if (res) {
+		err =3D nla_parse_nested(tb,
+				       ARRAY_SIZE(rtm_nh_res_policy_new) - 1,
+				       res, rtm_nh_res_policy_new, extack);
+		if (err < 0)
+			return err;
+	}
+
+	if (tb[NHA_RES_GROUP_BUCKETS]) {
+		cfg->nh_grp_res_num_buckets =3D
+			nla_get_u32(tb[NHA_RES_GROUP_BUCKETS]);
+		cfg->nh_grp_res_has_num_buckets =3D true;
+		if (!cfg->nh_grp_res_num_buckets) {
+			NL_SET_ERR_MSG(extack, "Number of buckets needs to be non-0");
+			return -EINVAL;
+		}
+	}
+
+	err =3D rtm_nh_get_timer(tb[NHA_RES_GROUP_IDLE_TIMER],
+			       NH_RES_DEFAULT_IDLE_TIMER,
+			       &cfg->nh_grp_res_idle_timer,
+			       &cfg->nh_grp_res_has_idle_timer,
+			       extack);
+	if (err)
+		return err;
+
+	return rtm_nh_get_timer(tb[NHA_RES_GROUP_UNBALANCED_TIMER],
+				NH_RES_DEFAULT_UNBALANCED_TIMER,
+				&cfg->nh_grp_res_unbalanced_timer,
+				&cfg->nh_grp_res_has_unbalanced_timer,
+				extack);
+}
+
 static int rtm_to_nh_config(struct net *net, struct sk_buff *skb,
 			    struct nlmsghdr *nlh, struct nh_config *cfg,
 			    struct netlink_ext_ack *extack)
@@ -2546,7 +2679,14 @@ static int rtm_to_nh_config(struct net *net, struct =
sk_buff *skb,
 			NL_SET_ERR_MSG(extack, "Invalid group type");
 			goto out;
 		}
-		err =3D nh_check_attr_group(net, tb, ARRAY_SIZE(tb), extack);
+		err =3D nh_check_attr_group(net, tb, ARRAY_SIZE(tb),
+					  cfg->nh_grp_type, extack);
+		if (err)
+			goto out;
+
+		if (cfg->nh_grp_type =3D=3D NEXTHOP_GRP_TYPE_RES)
+			err =3D rtm_to_nh_config_grp_res(tb[NHA_RES_GROUP],
+						       cfg, extack);
=20
 		/* no other attributes should be set */
 		goto out;
--=20
2.26.2

