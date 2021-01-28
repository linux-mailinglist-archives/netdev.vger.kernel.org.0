Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC43307674
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhA1Mwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:52:49 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15976 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhA1Mvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:51:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012b3190001>; Thu, 28 Jan 2021 04:50:33 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 12:50:30 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 07/12] nexthop: Extract dump filtering parameters into a single structure
Date:   Thu, 28 Jan 2021 13:49:19 +0100
Message-ID: <5f9dd4b7c8dc9efa6ef6c9e761aa4f34f2be2e73.1611836479.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1611836479.git.petrm@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL111.nvidia.com (172.20.187.18)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611838233; bh=Lwj+/FpH24KOQS0dcWnD65MbmThkW5Fjgw+VjmMKNcA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=YrEDe7c63jffRB1TQbLdb1Mpe3tPVx17NSam7CJsMlYtmU/B6NkK/RI4VFkb6EDZ1
         CZ6c6zPHFwBieKn6Ji6NNUeD+OzISFvgJawT6PIWLjUvIOmaBOTyurz9LP91iw+fwA
         eTgMpzHWWPgGjW+lDaj89OXTbhmZ772r3VoLG22XHSz2onz0s2k480XerYQXQ1PVLQ
         jKLlgSAfapZihbhUOx87r6l2h5Zs1EAOlQ1qz7vgASxuzkB/G6FFPeBjA6PzMJchfN
         QerhyYpP1mbeRz1R2uUSRc5vYwZ1YoR3mO76q3NaHeTgwMo7dqkzdOWFqq/bjf02wj
         po7s6CZpdpYwg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Requests to dump nexthops have many attributes in common with those that
requests to dump buckets of resilient NH groups will have. In order to make
reuse of this code simpler, convert the code to use a single structure with
filtering configuration instead of passing around the parameters one by
one.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 7149b12c4703..ad48e5d71bf9 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1971,16 +1971,23 @@ static int rtm_get_nexthop(struct sk_buff *in_skb, =
struct nlmsghdr *nlh,
 	goto out;
 }
=20
-static bool nh_dump_filtered(struct nexthop *nh, int dev_idx, int master_i=
dx,
-			     bool group_filter, u8 family)
+struct nh_dump_filter {
+	int dev_idx;
+	int master_idx;
+	bool group_filter;
+	bool fdb_filter;
+};
+
+static bool nh_dump_filtered(struct nexthop *nh,
+			     struct nh_dump_filter *filter, u8 family)
 {
 	const struct net_device *dev;
 	const struct nh_info *nhi;
=20
-	if (group_filter && !nh->is_group)
+	if (filter->group_filter && !nh->is_group)
 		return true;
=20
-	if (!dev_idx && !master_idx && !family)
+	if (!filter->dev_idx && !filter->master_idx && !family)
 		return false;
=20
 	if (nh->is_group)
@@ -1991,26 +1998,26 @@ static bool nh_dump_filtered(struct nexthop *nh, in=
t dev_idx, int master_idx,
 		return true;
=20
 	dev =3D nhi->fib_nhc.nhc_dev;
-	if (dev_idx && (!dev || dev->ifindex !=3D dev_idx))
+	if (filter->dev_idx && (!dev || dev->ifindex !=3D filter->dev_idx))
 		return true;
=20
-	if (master_idx) {
+	if (filter->master_idx) {
 		struct net_device *master;
=20
 		if (!dev)
 			return true;
=20
 		master =3D netdev_master_upper_dev_get((struct net_device *)dev);
-		if (!master || master->ifindex !=3D master_idx)
+		if (!master || master->ifindex !=3D filter->master_idx)
 			return true;
 	}
=20
 	return false;
 }
=20
-static int nh_valid_dump_req(const struct nlmsghdr *nlh, int *dev_idx,
-			     int *master_idx, bool *group_filter,
-			     bool *fdb_filter, struct netlink_callback *cb)
+static int nh_valid_dump_req(const struct nlmsghdr *nlh,
+			     struct nh_dump_filter *filter,
+			     struct netlink_callback *cb)
 {
 	struct netlink_ext_ack *extack =3D cb->extack;
 	struct nlattr *tb[ARRAY_SIZE(rtm_nh_policy_dump)];
@@ -2030,7 +2037,7 @@ static int nh_valid_dump_req(const struct nlmsghdr *n=
lh, int *dev_idx,
 			NL_SET_ERR_MSG(extack, "Invalid device index");
 			return -EINVAL;
 		}
-		*dev_idx =3D idx;
+		filter->dev_idx =3D idx;
 	}
 	if (tb[NHA_MASTER]) {
 		idx =3D nla_get_u32(tb[NHA_MASTER]);
@@ -2038,10 +2045,10 @@ static int nh_valid_dump_req(const struct nlmsghdr =
*nlh, int *dev_idx,
 			NL_SET_ERR_MSG(extack, "Invalid master device index");
 			return -EINVAL;
 		}
-		*master_idx =3D idx;
+		filter->master_idx =3D idx;
 	}
-	*group_filter =3D nla_get_flag(tb[NHA_GROUPS]);
-	*fdb_filter =3D nla_get_flag(tb[NHA_FDB]);
+	filter->group_filter =3D nla_get_flag(tb[NHA_GROUPS]);
+	filter->fdb_filter =3D nla_get_flag(tb[NHA_FDB]);
=20
 	nhm =3D nlmsg_data(nlh);
 	if (nhm->nh_protocol || nhm->resvd || nhm->nh_scope || nhm->nh_flags) {
@@ -2055,17 +2062,15 @@ static int nh_valid_dump_req(const struct nlmsghdr =
*nlh, int *dev_idx,
 /* rtnl */
 static int rtm_dump_nexthop(struct sk_buff *skb, struct netlink_callback *=
cb)
 {
-	bool group_filter =3D false, fdb_filter =3D false;
 	struct nhmsg *nhm =3D nlmsg_data(cb->nlh);
-	int dev_filter_idx =3D 0, master_idx =3D 0;
 	struct net *net =3D sock_net(skb->sk);
 	struct rb_root *root =3D &net->nexthop.rb_root;
+	struct nh_dump_filter filter =3D {};
 	struct rb_node *node;
 	int idx =3D 0, s_idx;
 	int err;
=20
-	err =3D nh_valid_dump_req(cb->nlh, &dev_filter_idx, &master_idx,
-				&group_filter, &fdb_filter, cb);
+	err =3D nh_valid_dump_req(cb->nlh, &filter, cb);
 	if (err < 0)
 		return err;
=20
@@ -2077,8 +2082,7 @@ static int rtm_dump_nexthop(struct sk_buff *skb, stru=
ct netlink_callback *cb)
 			goto cont;
=20
 		nh =3D rb_entry(node, struct nexthop, rb_node);
-		if (nh_dump_filtered(nh, dev_filter_idx, master_idx,
-				     group_filter, nhm->nh_family))
+		if (nh_dump_filtered(nh, &filter, nhm->nh_family))
 			goto cont;
=20
 		err =3D nh_fill_node(skb, nh, RTM_NEWNEXTHOP,
--=20
2.26.2

