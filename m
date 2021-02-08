Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46513140EF
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbhBHUvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:51:03 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7280 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbhBHUrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:47:23 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a28c0000>; Mon, 08 Feb 2021 12:43:56 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:43:56 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:53 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 11/13] nexthop: Add netlink handlers for bucket get
Date:   Mon, 8 Feb 2021 21:42:54 +0100
Message-ID: <5c847b2ade59deb0c9fbf962f1ffd3d612fab02f.1612815058.git.petrm@nvidia.com>
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
        t=1612817037; bh=I4cXvTz+QJ00OhV3qjAZ1bc4GgdpA9eJPhu+DJ3OFjo=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Wntt8sEuonPbU2+S8Y1YgwP6xhiZhXbMZ0k8bkERvATDq5TpR/m2NGv5DpXud0mBI
         PWajIJtJTnlzBsOHBmJ7fyDIQX3gzlLmPjFdR5AdLtvswvG9SDrM2JbiFPV/TVgXiK
         JGSARpkGO6E7OTDUYncuVyBtoiMZARTpzLf2DO/IFnUDzW6JpfzKXjbEZBUv4KHfxP
         gkt7wx344Lf/wFsoaKPaIl9LSJgv5uZjqdhPc4tEI38aeaLsoYWzy6UcFon4jd1kI+
         bn9KGRY5qndRL1kGcdPn3QbP61pUSk5RcS6tCfexgNCrlf7xI4ya08HL599Igk6Sh+
         4iv8hVY6uQTlg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow getting (but not setting) individual buckets to inspect the next hop
mapped therein, idle time, and flags.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 110 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 109 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 13f37211cf72..76fa2018413f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -66,6 +66,15 @@ static const struct nla_policy rtm_nh_res_bucket_policy_=
dump[] =3D {
 	[NHA_RES_BUCKET_NH_ID]	=3D { .type =3D NLA_U32 },
 };
=20
+static const struct nla_policy rtm_nh_policy_get_bucket[] =3D {
+	[NHA_ID]		=3D { .type =3D NLA_U32 },
+	[NHA_RES_BUCKET]	=3D { .type =3D NLA_NESTED },
+};
+
+static const struct nla_policy rtm_nh_res_bucket_policy_get[] =3D {
+	[NHA_RES_BUCKET_INDEX]	=3D { .type =3D NLA_U32 },
+};
+
 static bool nexthop_notifiers_is_empty(struct net *net)
 {
 	return !net->nexthop.notifier_chain.head;
@@ -3374,6 +3383,105 @@ static int rtm_dump_nexthop_bucket(struct sk_buff *=
skb,
 	return err;
 }
=20
+static int nh_valid_get_bucket_req_res_bucket(struct nlattr *res,
+					      u32 *bucket_index,
+					      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[ARRAY_SIZE(rtm_nh_res_bucket_policy_get)];
+	int err;
+
+	err =3D nla_parse_nested(tb, ARRAY_SIZE(rtm_nh_res_bucket_policy_get) - 1=
,
+			       res, rtm_nh_res_bucket_policy_get, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[NHA_RES_BUCKET_INDEX]) {
+		NL_SET_ERR_MSG(extack, "Bucket index is missing");
+		return -EINVAL;
+	}
+
+	*bucket_index =3D nla_get_u32(tb[NHA_RES_BUCKET_INDEX]);
+	return 0;
+}
+
+static int nh_valid_get_bucket_req(const struct nlmsghdr *nlh,
+				   u32 *id, u32 *bucket_index,
+				   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[ARRAY_SIZE(rtm_nh_policy_get_bucket)];
+	int err;
+
+	err =3D nlmsg_parse(nlh, sizeof(struct nhmsg), tb,
+			  ARRAY_SIZE(rtm_nh_policy_get_bucket) - 1,
+			  rtm_nh_policy_get_bucket, extack);
+	if (err < 0)
+		return err;
+
+	err =3D __nh_valid_get_del_req(nlh, tb, id, extack);
+	if (err)
+		return err;
+
+	if (!tb[NHA_RES_BUCKET]) {
+		NL_SET_ERR_MSG(extack, "Bucket information is missing");
+		return -EINVAL;
+	}
+
+	err =3D nh_valid_get_bucket_req_res_bucket(tb[NHA_RES_BUCKET],
+						 bucket_index, extack);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/* rtnl */
+static int rtm_get_nexthop_bucket(struct sk_buff *in_skb, struct nlmsghdr =
*nlh,
+				  struct netlink_ext_ack *extack)
+{
+	struct net *net =3D sock_net(in_skb->sk);
+	struct nh_res_table *res_table;
+	struct sk_buff *skb =3D NULL;
+	struct nh_group *nhg;
+	struct nexthop *nh;
+	u32 bucket_index;
+	int err;
+	u32 id;
+
+	err =3D nh_valid_get_bucket_req(nlh, &id, &bucket_index, extack);
+	if (err)
+		return err;
+
+	nh =3D nexthop_find_group_resilient(net, id, extack);
+	if (IS_ERR(nh))
+		return PTR_ERR(nh);
+
+	nhg =3D rtnl_dereference(nh->nh_grp);
+	res_table =3D rtnl_dereference(nhg->res_table);
+	if (bucket_index >=3D res_table->num_nh_buckets) {
+		NL_SET_ERR_MSG(extack, "Bucket index out of bounds");
+		return -ENOENT;
+	}
+
+	skb =3D alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb)
+		return -ENOBUFS;
+
+	err =3D nh_fill_res_bucket(skb, nh, &res_table->nh_buckets[bucket_index],
+				 bucket_index, RTM_NEWNEXTHOPBUCKET,
+				 NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
+				 0, extack);
+	if (err < 0) {
+		WARN_ON(err =3D=3D -EMSGSIZE);
+		goto errout_free;
+	}
+
+	return rtnl_unicast(skb, net, NETLINK_CB(in_skb).portid);
+
+errout_free:
+	kfree_skb(skb);
+	return err;
+}
+
 static void nexthop_sync_mtu(struct net_device *dev, u32 orig_mtu)
 {
 	unsigned int hash =3D nh_dev_hashfn(dev->ifindex);
@@ -3597,7 +3705,7 @@ static int __init nexthop_init(void)
 	rtnl_register(PF_INET6, RTM_NEWNEXTHOP, rtm_new_nexthop, NULL, 0);
 	rtnl_register(PF_INET6, RTM_GETNEXTHOP, NULL, rtm_dump_nexthop, 0);
=20
-	rtnl_register(PF_UNSPEC, RTM_GETNEXTHOPBUCKET, NULL,
+	rtnl_register(PF_UNSPEC, RTM_GETNEXTHOPBUCKET, rtm_get_nexthop_bucket,
 		      rtm_dump_nexthop_bucket, 0);
=20
 	return 0;
--=20
2.26.2

