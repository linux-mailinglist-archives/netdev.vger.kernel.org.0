Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293583140EB
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbhBHUuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:50:25 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7275 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbhBHUrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:47:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a28a0001>; Mon, 08 Feb 2021 12:43:54 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:43:53 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:50 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 10/13] nexthop: Add netlink handlers for bucket dump
Date:   Mon, 8 Feb 2021 21:42:53 +0100
Message-ID: <b1b51fb343524cc6be7c5ced3e5408442e222ff3.1612815058.git.petrm@nvidia.com>
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
        t=1612817034; bh=9oEFmrqlLs3QdLHeHTJAz7S3AXip7pAoUboShzppBgs=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Y4ICa6BQsIr14CciCw+8EcpX3vN7UifZdClXDz9HqnmuSTLIXhshkHyjh7pzWinAX
         hlubY0Dv+Lkkg6HXeBjB3TGLDZmQejTFyyXNoZekbyDy4I0/mDegVPxl/dPcQHtZhy
         YdOtuNRlnzrzjLx5k+2kP8DQ7HDYy4YnFWu40PS4twzd1T1jKvRH2UwTEuJUiGbFx8
         HmwKGAausqp3/kYa85RcNDUHqR/TN8akT7BNIfE66egVR996JajkAdU23jjNZMk6tf
         BgSlQ1YTOzDUrUcoTekBm5DOcJexrNjDkW5t31WRVuGExd04MaXxUYziPhq2KLWVsp
         alV8W4yKuYANQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a dump handler for resilient next hop buckets. When next-hop group ID
is given, it walks buckets of that group, otherwise it walks buckets of all
groups. It then dumps the buckets whose next hops match the given filtering
criteria.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 283 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 283 insertions(+)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 1118189190fd..13f37211cf72 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -55,6 +55,17 @@ static const struct nla_policy rtm_nh_res_policy_new[] =
=3D {
 	[NHA_RES_GROUP_UNBALANCED_TIMER]	=3D { .type =3D NLA_U32 },
 };
=20
+static const struct nla_policy rtm_nh_policy_dump_bucket[] =3D {
+	[NHA_ID]		=3D { .type =3D NLA_U32 },
+	[NHA_OIF]		=3D { .type =3D NLA_U32 },
+	[NHA_MASTER]		=3D { .type =3D NLA_U32 },
+	[NHA_RES_BUCKET]	=3D { .type =3D NLA_NESTED },
+};
+
+static const struct nla_policy rtm_nh_res_bucket_policy_dump[] =3D {
+	[NHA_RES_BUCKET_NH_ID]	=3D { .type =3D NLA_U32 },
+};
+
 static bool nexthop_notifiers_is_empty(struct net *net)
 {
 	return !net->nexthop.notifier_chain.head;
@@ -883,6 +894,60 @@ static void nh_res_bucket_set_busy(struct nh_res_bucke=
t *bucket)
 	atomic_long_set(&bucket->used_time, (long)jiffies);
 }
=20
+static clock_t nh_res_bucket_idle_time(const struct nh_res_bucket *bucket)
+{
+	unsigned long used_time =3D nh_res_bucket_used_time(bucket);
+
+	return jiffies_delta_to_clock_t(jiffies - used_time);
+}
+
+static int nh_fill_res_bucket(struct sk_buff *skb, struct nexthop *nh,
+			      struct nh_res_bucket *bucket, u32 bucket_index,
+			      int event, u32 portid, u32 seq,
+			      unsigned int nlflags,
+			      struct netlink_ext_ack *extack)
+{
+	struct nh_grp_entry *nhge =3D nh_res_dereference(bucket->nh_entry);
+	struct nlmsghdr *nlh;
+	struct nlattr *nest;
+	struct nhmsg *nhm;
+
+	nlh =3D nlmsg_put(skb, portid, seq, event, sizeof(*nhm), nlflags);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	nhm =3D nlmsg_data(nlh);
+	nhm->nh_family =3D AF_UNSPEC;
+	nhm->nh_flags =3D bucket->nh_flags;
+	nhm->nh_protocol =3D nh->protocol;
+	nhm->nh_scope =3D 0;
+	nhm->resvd =3D 0;
+
+	if (nla_put_u32(skb, NHA_ID, nh->id))
+		goto nla_put_failure;
+
+	nest =3D nla_nest_start(skb, NHA_RES_BUCKET);
+	if (!nest)
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, NHA_RES_BUCKET_INDEX, bucket_index) ||
+	    nla_put_u32(skb, NHA_RES_BUCKET_NH_ID, nhge->nh->id) ||
+	    nla_put_u64_64bit(skb, NHA_RES_BUCKET_IDLE_TIME,
+			      nh_res_bucket_idle_time(bucket),
+			      NHA_RES_BUCKET_PAD))
+		goto nla_put_failure_nest;
+
+	nla_nest_end(skb, nest);
+	nlmsg_end(skb, nlh);
+	return 0;
+
+nla_put_failure_nest:
+	nla_nest_cancel(skb, nest);
+nla_put_failure:
+	nlmsg_cancel(skb, nlh);
+	return -EMSGSIZE;
+}
+
 static bool valid_group_nh(struct nexthop *nh, unsigned int npaths,
 			   bool *is_fdb, struct netlink_ext_ack *extack)
 {
@@ -2911,10 +2976,12 @@ static int rtm_get_nexthop(struct sk_buff *in_skb, =
struct nlmsghdr *nlh,
 }
=20
 struct nh_dump_filter {
+	u32 nh_id;
 	int dev_idx;
 	int master_idx;
 	bool group_filter;
 	bool fdb_filter;
+	u32 res_bucket_nh_id;
 };
=20
 static bool nh_dump_filtered(struct nexthop *nh,
@@ -3094,6 +3161,219 @@ static int rtm_dump_nexthop(struct sk_buff *skb, st=
ruct netlink_callback *cb)
 	return err;
 }
=20
+static struct nexthop *
+nexthop_find_group_resilient(struct net *net, u32 id,
+			     struct netlink_ext_ack *extack)
+{
+	struct nh_group *nhg;
+	struct nexthop *nh;
+
+	nh =3D nexthop_find_by_id(net, id);
+	if (!nh)
+		return ERR_PTR(-ENOENT);
+
+	if (!nh->is_group) {
+		NL_SET_ERR_MSG(extack, "Not a nexthop group");
+		return ERR_PTR(-EINVAL);
+	}
+
+	nhg =3D rtnl_dereference(nh->nh_grp);
+	if (!nhg->resilient) {
+		NL_SET_ERR_MSG(extack, "Nexthop group not of type resilient");
+		return ERR_PTR(-EINVAL);
+	}
+
+	return nh;
+}
+
+static int nh_valid_dump_nhid(struct nlattr *attr, u32 *nh_id_p,
+			      struct netlink_ext_ack *extack)
+{
+	u32 idx;
+
+	if (attr) {
+		idx =3D nla_get_u32(attr);
+		if (!idx) {
+			NL_SET_ERR_MSG(extack, "Invalid nexthop id");
+			return -EINVAL;
+		}
+		*nh_id_p =3D idx;
+	} else {
+		*nh_id_p =3D 0;
+	}
+
+	return 0;
+}
+
+static int nh_valid_dump_bucket_req(const struct nlmsghdr *nlh,
+				    struct nh_dump_filter *filter,
+				    struct netlink_callback *cb)
+{
+	struct nlattr *res_tb[ARRAY_SIZE(rtm_nh_res_bucket_policy_dump)];
+	struct nlattr *tb[ARRAY_SIZE(rtm_nh_policy_dump_bucket)];
+	int err;
+
+	err =3D nlmsg_parse(nlh, sizeof(struct nhmsg), tb,
+			  ARRAY_SIZE(rtm_nh_policy_dump_bucket) - 1,
+			  rtm_nh_policy_dump_bucket, NULL);
+	if (err < 0)
+		return err;
+
+	err =3D nh_valid_dump_nhid(tb[NHA_ID], &filter->nh_id, cb->extack);
+	if (err)
+		return err;
+
+	if (tb[NHA_RES_BUCKET]) {
+		size_t max =3D ARRAY_SIZE(rtm_nh_res_bucket_policy_dump) - 1;
+
+		err =3D nla_parse_nested(res_tb, max,
+				       tb[NHA_RES_BUCKET],
+				       rtm_nh_res_bucket_policy_dump,
+				       cb->extack);
+		if (err < 0)
+			return err;
+
+		err =3D nh_valid_dump_nhid(res_tb[NHA_RES_BUCKET_NH_ID],
+					 &filter->res_bucket_nh_id,
+					 cb->extack);
+		if (err)
+			return err;
+	}
+
+	return __nh_valid_dump_req(nlh, tb, filter, cb->extack);
+}
+
+struct rtm_dump_res_bucket_ctx {
+	struct rtm_dump_nh_ctx nh;
+	u32 bucket_index;
+	u32 done_nh_idx; /* 1 + the index of the last fully processed NH. */
+};
+
+static struct rtm_dump_res_bucket_ctx *
+rtm_dump_res_bucket_ctx(struct netlink_callback *cb)
+{
+	struct rtm_dump_res_bucket_ctx *ctx =3D (void *)cb->ctx;
+
+	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
+	return ctx;
+}
+
+struct rtm_dump_nexthop_bucket_data {
+	struct rtm_dump_res_bucket_ctx *ctx;
+	struct nh_dump_filter filter;
+};
+
+static int rtm_dump_nexthop_bucket_nh(struct sk_buff *skb,
+				      struct netlink_callback *cb,
+				      struct nexthop *nh,
+				      struct rtm_dump_nexthop_bucket_data *dd)
+{
+	u32 portid =3D NETLINK_CB(cb->skb).portid;
+	struct nhmsg *nhm =3D nlmsg_data(cb->nlh);
+	struct nh_res_table *res_table;
+	struct nh_group *nhg;
+	u32 bucket_index;
+	int err;
+
+	if (dd->ctx->nh.idx < dd->ctx->done_nh_idx)
+		return 0;
+
+	nhg =3D rtnl_dereference(nh->nh_grp);
+	res_table =3D rtnl_dereference(nhg->res_table);
+	for (bucket_index =3D dd->ctx->bucket_index;
+	     bucket_index < res_table->num_nh_buckets;
+	     bucket_index++) {
+		struct nh_res_bucket *bucket;
+		struct nh_grp_entry *nhge;
+
+		bucket =3D &res_table->nh_buckets[bucket_index];
+		nhge =3D rtnl_dereference(bucket->nh_entry);
+		if (nh_dump_filtered(nhge->nh, &dd->filter, nhm->nh_family))
+			continue;
+
+		if (dd->filter.res_bucket_nh_id &&
+		    dd->filter.res_bucket_nh_id !=3D nhge->nh->id)
+			continue;
+
+		err =3D nh_fill_res_bucket(skb, nh, bucket, bucket_index,
+					 RTM_NEWNEXTHOPBUCKET, portid,
+					 cb->nlh->nlmsg_seq, NLM_F_MULTI,
+					 cb->extack);
+		if (err < 0) {
+			if (likely(skb->len))
+				goto out;
+			goto out_err;
+		}
+	}
+
+	dd->ctx->done_nh_idx =3D dd->ctx->nh.idx + 1;
+	bucket_index =3D 0;
+
+out:
+	err =3D skb->len;
+out_err:
+	dd->ctx->bucket_index =3D bucket_index;
+	return err;
+}
+
+static int rtm_dump_nexthop_bucket_cb(struct sk_buff *skb,
+				      struct netlink_callback *cb,
+				      struct nexthop *nh, void *data)
+{
+	struct rtm_dump_nexthop_bucket_data *dd =3D data;
+	struct nh_group *nhg;
+
+	if (!nh->is_group)
+		return 0;
+
+	nhg =3D rtnl_dereference(nh->nh_grp);
+	if (!nhg->resilient)
+		return 0;
+
+	return rtm_dump_nexthop_bucket_nh(skb, cb, nh, dd);
+}
+
+/* rtnl */
+static int rtm_dump_nexthop_bucket(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct rtm_dump_res_bucket_ctx *ctx =3D rtm_dump_res_bucket_ctx(cb);
+	struct rtm_dump_nexthop_bucket_data dd =3D { .ctx =3D ctx };
+	struct net *net =3D sock_net(skb->sk);
+	struct nexthop *nh;
+	int err;
+
+	err =3D nh_valid_dump_bucket_req(cb->nlh, &dd.filter, cb);
+	if (err)
+		return err;
+
+	if (dd.filter.nh_id) {
+		nh =3D nexthop_find_group_resilient(net, dd.filter.nh_id,
+						  cb->extack);
+		if (IS_ERR(nh))
+			return PTR_ERR(nh);
+		err =3D rtm_dump_nexthop_bucket_nh(skb, cb, nh, &dd);
+	} else {
+		struct rb_root *root =3D &net->nexthop.rb_root;
+
+		err =3D rtm_dump_walk_nexthops(skb, cb, root, &ctx->nh,
+					     &rtm_dump_nexthop_bucket_cb, &dd);
+	}
+
+	if (err < 0) {
+		if (likely(skb->len))
+			goto out;
+		goto out_err;
+	}
+
+out:
+	err =3D skb->len;
+out_err:
+	cb->seq =3D net->nexthop.seq;
+	nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+	return err;
+}
+
 static void nexthop_sync_mtu(struct net_device *dev, u32 orig_mtu)
 {
 	unsigned int hash =3D nh_dev_hashfn(dev->ifindex);
@@ -3317,6 +3597,9 @@ static int __init nexthop_init(void)
 	rtnl_register(PF_INET6, RTM_NEWNEXTHOP, rtm_new_nexthop, NULL, 0);
 	rtnl_register(PF_INET6, RTM_GETNEXTHOP, NULL, rtm_dump_nexthop, 0);
=20
+	rtnl_register(PF_UNSPEC, RTM_GETNEXTHOPBUCKET, NULL,
+		      rtm_dump_nexthop_bucket, 0);
+
 	return 0;
 }
 subsys_initcall(nexthop_init);
--=20
2.26.2

