Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898C636B7CD
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbhDZRNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:13:11 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51528 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235660AbhDZRL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:58 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 72B5A64131;
        Mon, 26 Apr 2021 19:10:37 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 18/22] netfilter: nfnetlink: add struct nfnl_info and pass it to callbacks
Date:   Mon, 26 Apr 2021 19:10:52 +0200
Message-Id: <20210426171056.345271-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new structure to reduce callback footprint and to facilite
extensions of the nfnetlink callback interface in the future.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h  |  13 +-
 net/netfilter/ipset/ip_set_core.c    | 149 ++++++++-----------
 net/netfilter/nf_conntrack_netlink.c | 214 +++++++++++++--------------
 net/netfilter/nfnetlink.c            |  18 ++-
 net/netfilter/nfnetlink_acct.c       |  44 +++---
 net/netfilter/nfnetlink_cthelper.c   |  30 ++--
 net/netfilter/nfnetlink_cttimeout.c  | 101 ++++++-------
 net/netfilter/nfnetlink_log.c        |  26 ++--
 net/netfilter/nfnetlink_osf.c        |  19 +--
 net/netfilter/nfnetlink_queue.c      |  12 +-
 10 files changed, 286 insertions(+), 340 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index d4c14257db5d..1baa3205b199 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -7,11 +7,16 @@
 #include <net/netlink.h>
 #include <uapi/linux/netfilter/nfnetlink.h>
 
+struct nfnl_info {
+	struct net		*net;
+	struct sock		*sk;
+	const struct nlmsghdr	*nlh;
+	struct netlink_ext_ack	*extack;
+};
+
 struct nfnl_callback {
-	int (*call)(struct net *net, struct sock *nl, struct sk_buff *skb,
-		    const struct nlmsghdr *nlh,
-		    const struct nlattr * const cda[],
-		    struct netlink_ext_ack *extack);
+	int (*call)(struct sk_buff *skb, const struct nfnl_info *info,
+		    const struct nlattr * const cda[]);
 	int (*call_rcu)(struct net *net, struct sock *nl, struct sk_buff *skb,
 			const struct nlmsghdr *nlh,
 			const struct nlattr * const cda[],
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 359ff8ec236a..bf9902c1daa8 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1031,26 +1031,22 @@ find_free_id(struct ip_set_net *inst, const char *name, ip_set_id_t *index,
 	return 0;
 }
 
-static int ip_set_none(struct net *net, struct sock *ctnl, struct sk_buff *skb,
-		       const struct nlmsghdr *nlh,
-		       const struct nlattr * const attr[],
-		       struct netlink_ext_ack *extack)
+static int ip_set_none(struct sk_buff *skb, const struct nfnl_info *info,
+		       const struct nlattr * const attr[])
 {
 	return -EOPNOTSUPP;
 }
 
-static int ip_set_create(struct net *net, struct sock *ctnl,
-			 struct sk_buff *skb, const struct nlmsghdr *nlh,
-			 const struct nlattr * const attr[],
-			 struct netlink_ext_ack *extack)
+static int ip_set_create(struct sk_buff *skb, const struct nfnl_info *info,
+			 const struct nlattr * const attr[])
 {
-	struct ip_set_net *inst = ip_set_pernet(net);
+	struct ip_set_net *inst = ip_set_pernet(info->net);
 	struct ip_set *set, *clash = NULL;
 	ip_set_id_t index = IPSET_INVALID_ID;
 	struct nlattr *tb[IPSET_ATTR_CREATE_MAX + 1] = {};
 	const char *name, *typename;
 	u8 family, revision;
-	u32 flags = flag_exist(nlh);
+	u32 flags = flag_exist(info->nlh);
 	int ret = 0;
 
 	if (unlikely(protocol_min_failed(attr) ||
@@ -1101,7 +1097,7 @@ static int ip_set_create(struct net *net, struct sock *ctnl,
 	/* Set create flags depending on the type revision */
 	set->flags |= set->type->create_flags[revision];
 
-	ret = set->type->create(net, set, tb, flags);
+	ret = set->type->create(info->net, set, tb, flags);
 	if (ret != 0)
 		goto put_out;
 
@@ -1183,12 +1179,10 @@ ip_set_destroy_set(struct ip_set *set)
 	kfree(set);
 }
 
-static int ip_set_destroy(struct net *net, struct sock *ctnl,
-			  struct sk_buff *skb, const struct nlmsghdr *nlh,
-			  const struct nlattr * const attr[],
-			  struct netlink_ext_ack *extack)
+static int ip_set_destroy(struct sk_buff *skb, const struct nfnl_info *info,
+			  const struct nlattr * const attr[])
 {
-	struct ip_set_net *inst = ip_set_pernet(net);
+	struct ip_set_net *inst = ip_set_pernet(info->net);
 	struct ip_set *s;
 	ip_set_id_t i;
 	int ret = 0;
@@ -1230,7 +1224,7 @@ static int ip_set_destroy(struct net *net, struct sock *ctnl,
 		/* Modified by ip_set_destroy() only, which is serialized */
 		inst->is_destroyed = false;
 	} else {
-		u32 flags = flag_exist(nlh);
+		u32 flags = flag_exist(info->nlh);
 		s = find_set_and_id(inst, nla_data(attr[IPSET_ATTR_SETNAME]),
 				    &i);
 		if (!s) {
@@ -1264,12 +1258,10 @@ ip_set_flush_set(struct ip_set *set)
 	ip_set_unlock(set);
 }
 
-static int ip_set_flush(struct net *net, struct sock *ctnl, struct sk_buff *skb,
-			const struct nlmsghdr *nlh,
-			const struct nlattr * const attr[],
-			struct netlink_ext_ack *extack)
+static int ip_set_flush(struct sk_buff *skb, const struct nfnl_info *info,
+			const struct nlattr * const attr[])
 {
-	struct ip_set_net *inst = ip_set_pernet(net);
+	struct ip_set_net *inst = ip_set_pernet(info->net);
 	struct ip_set *s;
 	ip_set_id_t i;
 
@@ -1304,12 +1296,10 @@ ip_set_setname2_policy[IPSET_ATTR_CMD_MAX + 1] = {
 				    .len = IPSET_MAXNAMELEN - 1 },
 };
 
-static int ip_set_rename(struct net *net, struct sock *ctnl,
-			 struct sk_buff *skb, const struct nlmsghdr *nlh,
-			 const struct nlattr * const attr[],
-			 struct netlink_ext_ack *extack)
+static int ip_set_rename(struct sk_buff *skb, const struct nfnl_info *info,
+			 const struct nlattr * const attr[])
 {
-	struct ip_set_net *inst = ip_set_pernet(net);
+	struct ip_set_net *inst = ip_set_pernet(info->net);
 	struct ip_set *set, *s;
 	const char *name2;
 	ip_set_id_t i;
@@ -1354,12 +1344,10 @@ static int ip_set_rename(struct net *net, struct sock *ctnl,
  * so the ip_set_list always contains valid pointers to the sets.
  */
 
-static int ip_set_swap(struct net *net, struct sock *ctnl, struct sk_buff *skb,
-		       const struct nlmsghdr *nlh,
-		       const struct nlattr * const attr[],
-		       struct netlink_ext_ack *extack)
+static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info,
+		       const struct nlattr * const attr[])
 {
-	struct ip_set_net *inst = ip_set_pernet(net);
+	struct ip_set_net *inst = ip_set_pernet(info->net);
 	struct ip_set *from, *to;
 	ip_set_id_t from_id, to_id;
 	char from_name[IPSET_MAXNAMELEN];
@@ -1669,10 +1657,8 @@ ip_set_dump_do(struct sk_buff *skb, struct netlink_callback *cb)
 	return ret < 0 ? ret : skb->len;
 }
 
-static int ip_set_dump(struct net *net, struct sock *ctnl, struct sk_buff *skb,
-		       const struct nlmsghdr *nlh,
-		       const struct nlattr * const attr[],
-		       struct netlink_ext_ack *extack)
+static int ip_set_dump(struct sk_buff *skb, const struct nfnl_info *info,
+		       const struct nlattr * const attr[])
 {
 	if (unlikely(protocol_min_failed(attr)))
 		return -IPSET_ERR_PROTOCOL;
@@ -1683,7 +1669,7 @@ static int ip_set_dump(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 			.dump = ip_set_dump_do,
 			.done = ip_set_dump_done,
 		};
-		return netlink_dump_start(ctnl, skb, nlh, &c);
+		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
 }
 
@@ -1817,30 +1803,24 @@ static int ip_set_ad(struct net *net, struct sock *ctnl,
 	return ret;
 }
 
-static int ip_set_uadd(struct net *net, struct sock *ctnl,
-		       struct sk_buff *skb, const struct nlmsghdr *nlh,
-		       const struct nlattr * const attr[],
-		       struct netlink_ext_ack *extack)
+static int ip_set_uadd(struct sk_buff *skb, const struct nfnl_info *info,
+		       const struct nlattr * const attr[])
 {
-	return ip_set_ad(net, ctnl, skb,
-			 IPSET_ADD, nlh, attr, extack);
+	return ip_set_ad(info->net, info->sk, skb,
+			 IPSET_ADD, info->nlh, attr, info->extack);
 }
 
-static int ip_set_udel(struct net *net, struct sock *ctnl,
-		       struct sk_buff *skb, const struct nlmsghdr *nlh,
-		       const struct nlattr * const attr[],
-		       struct netlink_ext_ack *extack)
+static int ip_set_udel(struct sk_buff *skb, const struct nfnl_info *info,
+		       const struct nlattr * const attr[])
 {
-	return ip_set_ad(net, ctnl, skb,
-			 IPSET_DEL, nlh, attr, extack);
+	return ip_set_ad(info->net, info->sk, skb,
+			 IPSET_DEL, info->nlh, attr, info->extack);
 }
 
-static int ip_set_utest(struct net *net, struct sock *ctnl, struct sk_buff *skb,
-			const struct nlmsghdr *nlh,
-			const struct nlattr * const attr[],
-			struct netlink_ext_ack *extack)
+static int ip_set_utest(struct sk_buff *skb, const struct nfnl_info *info,
+			const struct nlattr * const attr[])
 {
-	struct ip_set_net *inst = ip_set_pernet(net);
+	struct ip_set_net *inst = ip_set_pernet(info->net);
 	struct ip_set *set;
 	struct nlattr *tb[IPSET_ATTR_ADT_MAX + 1] = {};
 	int ret = 0;
@@ -1872,12 +1852,10 @@ static int ip_set_utest(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 
 /* Get headed data of a set */
 
-static int ip_set_header(struct net *net, struct sock *ctnl,
-			 struct sk_buff *skb, const struct nlmsghdr *nlh,
-			 const struct nlattr * const attr[],
-			 struct netlink_ext_ack *extack)
+static int ip_set_header(struct sk_buff *skb, const struct nfnl_info *info,
+			 const struct nlattr * const attr[])
 {
-	struct ip_set_net *inst = ip_set_pernet(net);
+	struct ip_set_net *inst = ip_set_pernet(info->net);
 	const struct ip_set *set;
 	struct sk_buff *skb2;
 	struct nlmsghdr *nlh2;
@@ -1895,7 +1873,7 @@ static int ip_set_header(struct net *net, struct sock *ctnl,
 	if (!skb2)
 		return -ENOMEM;
 
-	nlh2 = start_msg(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
+	nlh2 = start_msg(skb2, NETLINK_CB(skb).portid, info->nlh->nlmsg_seq, 0,
 			 IPSET_CMD_HEADER);
 	if (!nlh2)
 		goto nlmsg_failure;
@@ -1907,7 +1885,8 @@ static int ip_set_header(struct net *net, struct sock *ctnl,
 		goto nla_put_failure;
 	nlmsg_end(skb2, nlh2);
 
-	ret = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid, MSG_DONTWAIT);
+	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
+			      MSG_DONTWAIT);
 	if (ret < 0)
 		return ret;
 
@@ -1929,10 +1908,8 @@ static const struct nla_policy ip_set_type_policy[IPSET_ATTR_CMD_MAX + 1] = {
 	[IPSET_ATTR_FAMILY]	= { .type = NLA_U8 },
 };
 
-static int ip_set_type(struct net *net, struct sock *ctnl, struct sk_buff *skb,
-		       const struct nlmsghdr *nlh,
-		       const struct nlattr * const attr[],
-		       struct netlink_ext_ack *extack)
+static int ip_set_type(struct sk_buff *skb, const struct nfnl_info *info,
+		       const struct nlattr * const attr[])
 {
 	struct sk_buff *skb2;
 	struct nlmsghdr *nlh2;
@@ -1955,7 +1932,7 @@ static int ip_set_type(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 	if (!skb2)
 		return -ENOMEM;
 
-	nlh2 = start_msg(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
+	nlh2 = start_msg(skb2, NETLINK_CB(skb).portid, info->nlh->nlmsg_seq, 0,
 			 IPSET_CMD_TYPE);
 	if (!nlh2)
 		goto nlmsg_failure;
@@ -1968,7 +1945,8 @@ static int ip_set_type(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 	nlmsg_end(skb2, nlh2);
 
 	pr_debug("Send TYPE, nlmsg_len: %u\n", nlh2->nlmsg_len);
-	ret = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid, MSG_DONTWAIT);
+	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
+			      MSG_DONTWAIT);
 	if (ret < 0)
 		return ret;
 
@@ -1988,10 +1966,8 @@ ip_set_protocol_policy[IPSET_ATTR_CMD_MAX + 1] = {
 	[IPSET_ATTR_PROTOCOL]	= { .type = NLA_U8 },
 };
 
-static int ip_set_protocol(struct net *net, struct sock *ctnl,
-			   struct sk_buff *skb, const struct nlmsghdr *nlh,
-			   const struct nlattr * const attr[],
-			   struct netlink_ext_ack *extack)
+static int ip_set_protocol(struct sk_buff *skb, const struct nfnl_info *info,
+			   const struct nlattr * const attr[])
 {
 	struct sk_buff *skb2;
 	struct nlmsghdr *nlh2;
@@ -2004,7 +1980,7 @@ static int ip_set_protocol(struct net *net, struct sock *ctnl,
 	if (!skb2)
 		return -ENOMEM;
 
-	nlh2 = start_msg(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
+	nlh2 = start_msg(skb2, NETLINK_CB(skb).portid, info->nlh->nlmsg_seq, 0,
 			 IPSET_CMD_PROTOCOL);
 	if (!nlh2)
 		goto nlmsg_failure;
@@ -2014,7 +1990,8 @@ static int ip_set_protocol(struct net *net, struct sock *ctnl,
 		goto nla_put_failure;
 	nlmsg_end(skb2, nlh2);
 
-	ret = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid, MSG_DONTWAIT);
+	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
+			      MSG_DONTWAIT);
 	if (ret < 0)
 		return ret;
 
@@ -2029,12 +2006,10 @@ static int ip_set_protocol(struct net *net, struct sock *ctnl,
 
 /* Get set by name or index, from userspace */
 
-static int ip_set_byname(struct net *net, struct sock *ctnl,
-			 struct sk_buff *skb, const struct nlmsghdr *nlh,
-			 const struct nlattr * const attr[],
-			 struct netlink_ext_ack *extack)
+static int ip_set_byname(struct sk_buff *skb, const struct nfnl_info *info,
+			 const struct nlattr * const attr[])
 {
-	struct ip_set_net *inst = ip_set_pernet(net);
+	struct ip_set_net *inst = ip_set_pernet(info->net);
 	struct sk_buff *skb2;
 	struct nlmsghdr *nlh2;
 	ip_set_id_t id = IPSET_INVALID_ID;
@@ -2053,7 +2028,7 @@ static int ip_set_byname(struct net *net, struct sock *ctnl,
 	if (!skb2)
 		return -ENOMEM;
 
-	nlh2 = start_msg(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
+	nlh2 = start_msg(skb2, NETLINK_CB(skb).portid, info->nlh->nlmsg_seq, 0,
 			 IPSET_CMD_GET_BYNAME);
 	if (!nlh2)
 		goto nlmsg_failure;
@@ -2063,7 +2038,8 @@ static int ip_set_byname(struct net *net, struct sock *ctnl,
 		goto nla_put_failure;
 	nlmsg_end(skb2, nlh2);
 
-	ret = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid, MSG_DONTWAIT);
+	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
+			      MSG_DONTWAIT);
 	if (ret < 0)
 		return ret;
 
@@ -2081,12 +2057,10 @@ static const struct nla_policy ip_set_index_policy[IPSET_ATTR_CMD_MAX + 1] = {
 	[IPSET_ATTR_INDEX]	= { .type = NLA_U16 },
 };
 
-static int ip_set_byindex(struct net *net, struct sock *ctnl,
-			  struct sk_buff *skb, const struct nlmsghdr *nlh,
-			  const struct nlattr * const attr[],
-			  struct netlink_ext_ack *extack)
+static int ip_set_byindex(struct sk_buff *skb, const struct nfnl_info *info,
+			  const struct nlattr * const attr[])
 {
-	struct ip_set_net *inst = ip_set_pernet(net);
+	struct ip_set_net *inst = ip_set_pernet(info->net);
 	struct sk_buff *skb2;
 	struct nlmsghdr *nlh2;
 	ip_set_id_t id = IPSET_INVALID_ID;
@@ -2108,7 +2082,7 @@ static int ip_set_byindex(struct net *net, struct sock *ctnl,
 	if (!skb2)
 		return -ENOMEM;
 
-	nlh2 = start_msg(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq, 0,
+	nlh2 = start_msg(skb2, NETLINK_CB(skb).portid, info->nlh->nlmsg_seq, 0,
 			 IPSET_CMD_GET_BYINDEX);
 	if (!nlh2)
 		goto nlmsg_failure;
@@ -2117,7 +2091,8 @@ static int ip_set_byindex(struct net *net, struct sock *ctnl,
 		goto nla_put_failure;
 	nlmsg_end(skb2, nlh2);
 
-	ret = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid, MSG_DONTWAIT);
+	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
+			      MSG_DONTWAIT);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 44e3cb80e2e0..5147a63b3d1b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1524,17 +1524,15 @@ static int ctnetlink_flush_conntrack(struct net *net,
 	return 0;
 }
 
-static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
-				   struct sk_buff *skb,
-				   const struct nlmsghdr *nlh,
-				   const struct nlattr * const cda[],
-				   struct netlink_ext_ack *extack)
+static int ctnetlink_del_conntrack(struct sk_buff *skb,
+				   const struct nfnl_info *info,
+				   const struct nlattr * const cda[])
 {
+	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
-	struct nf_conn *ct;
-	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
 	struct nf_conntrack_zone zone;
+	struct nf_conn *ct;
 	int err;
 
 	err = ctnetlink_parse_zone(cda[CTA_ZONE], &zone);
@@ -1550,15 +1548,15 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 	else {
 		u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
 
-		return ctnetlink_flush_conntrack(net, cda,
+		return ctnetlink_flush_conntrack(info->net, cda,
 						 NETLINK_CB(skb).portid,
-						 nlmsg_report(nlh), u3);
+						 nlmsg_report(info->nlh), u3);
 	}
 
 	if (err < 0)
 		return err;
 
-	h = nf_conntrack_find_get(net, &zone, &tuple);
+	h = nf_conntrack_find_get(info->net, &zone, &tuple);
 	if (!h)
 		return -ENOENT;
 
@@ -1578,28 +1576,26 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 		}
 	}
 
-	nf_ct_delete(ct, NETLINK_CB(skb).portid, nlmsg_report(nlh));
+	nf_ct_delete(ct, NETLINK_CB(skb).portid, nlmsg_report(info->nlh));
 	nf_ct_put(ct);
 
 	return 0;
 }
 
-static int ctnetlink_get_conntrack(struct net *net, struct sock *ctnl,
-				   struct sk_buff *skb,
-				   const struct nlmsghdr *nlh,
-				   const struct nlattr * const cda[],
-				   struct netlink_ext_ack *extack)
+static int ctnetlink_get_conntrack(struct sk_buff *skb,
+				   const struct nfnl_info *info,
+				   const struct nlattr * const cda[])
 {
+	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	u_int8_t u3 = nfmsg->nfgen_family;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
-	struct nf_conn *ct;
-	struct sk_buff *skb2 = NULL;
-	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u_int8_t u3 = nfmsg->nfgen_family;
 	struct nf_conntrack_zone zone;
+	struct sk_buff *skb2;
+	struct nf_conn *ct;
 	int err;
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.start = ctnetlink_start,
 			.dump = ctnetlink_dump_table,
@@ -1607,7 +1603,7 @@ static int ctnetlink_get_conntrack(struct net *net, struct sock *ctnl,
 			.data = (void *)cda,
 		};
 
-		return netlink_dump_start(ctnl, skb, nlh, &c);
+		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
 
 	err = ctnetlink_parse_zone(cda[CTA_ZONE], &zone);
@@ -1626,7 +1622,7 @@ static int ctnetlink_get_conntrack(struct net *net, struct sock *ctnl,
 	if (err < 0)
 		return err;
 
-	h = nf_conntrack_find_get(net, &zone, &tuple);
+	h = nf_conntrack_find_get(info->net, &zone, &tuple);
 	if (!h)
 		return -ENOENT;
 
@@ -1639,13 +1635,16 @@ static int ctnetlink_get_conntrack(struct net *net, struct sock *ctnl,
 		return -ENOMEM;
 	}
 
-	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
-				  NFNL_MSG_TYPE(nlh->nlmsg_type), ct, true, 0);
+	err = ctnetlink_fill_info(skb2, NETLINK_CB(skb).portid,
+				  info->nlh->nlmsg_seq,
+				  NFNL_MSG_TYPE(info->nlh->nlmsg_type), ct,
+				  true, 0);
 	nf_ct_put(ct);
 	if (err <= 0)
 		goto free;
 
-	err = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid, MSG_DONTWAIT);
+	err = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
+			      MSG_DONTWAIT);
 	if (err < 0)
 		goto out;
 
@@ -1743,18 +1742,16 @@ ctnetlink_dump_dying(struct sk_buff *skb, struct netlink_callback *cb)
 	return ctnetlink_dump_list(skb, cb, true);
 }
 
-static int ctnetlink_get_ct_dying(struct net *net, struct sock *ctnl,
-				  struct sk_buff *skb,
-				  const struct nlmsghdr *nlh,
-				  const struct nlattr * const cda[],
-				  struct netlink_ext_ack *extack)
+static int ctnetlink_get_ct_dying(struct sk_buff *skb,
+				  const struct nfnl_info *info,
+				  const struct nlattr * const cda[])
 {
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = ctnetlink_dump_dying,
 			.done = ctnetlink_done_list,
 		};
-		return netlink_dump_start(ctnl, skb, nlh, &c);
+		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
 
 	return -EOPNOTSUPP;
@@ -1766,18 +1763,16 @@ ctnetlink_dump_unconfirmed(struct sk_buff *skb, struct netlink_callback *cb)
 	return ctnetlink_dump_list(skb, cb, false);
 }
 
-static int ctnetlink_get_ct_unconfirmed(struct net *net, struct sock *ctnl,
-					struct sk_buff *skb,
-					const struct nlmsghdr *nlh,
-					const struct nlattr * const cda[],
-					struct netlink_ext_ack *extack)
+static int ctnetlink_get_ct_unconfirmed(struct sk_buff *skb,
+					const struct nfnl_info *info,
+					const struct nlattr * const cda[])
 {
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = ctnetlink_dump_unconfirmed,
 			.done = ctnetlink_done_list,
 		};
-		return netlink_dump_start(ctnl, skb, nlh, &c);
+		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
 
 	return -EOPNOTSUPP;
@@ -2374,18 +2369,16 @@ ctnetlink_create_conntrack(struct net *net,
 	return ERR_PTR(err);
 }
 
-static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
-				   struct sk_buff *skb,
-				   const struct nlmsghdr *nlh,
-				   const struct nlattr * const cda[],
-				   struct netlink_ext_ack *extack)
+static int ctnetlink_new_conntrack(struct sk_buff *skb,
+				   const struct nfnl_info *info,
+				   const struct nlattr * const cda[])
 {
+	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	struct nf_conntrack_tuple otuple, rtuple;
 	struct nf_conntrack_tuple_hash *h = NULL;
-	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	struct nf_conn *ct;
 	u_int8_t u3 = nfmsg->nfgen_family;
 	struct nf_conntrack_zone zone;
+	struct nf_conn *ct;
 	int err;
 
 	err = ctnetlink_parse_zone(cda[CTA_ZONE], &zone);
@@ -2407,13 +2400,13 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
 	}
 
 	if (cda[CTA_TUPLE_ORIG])
-		h = nf_conntrack_find_get(net, &zone, &otuple);
+		h = nf_conntrack_find_get(info->net, &zone, &otuple);
 	else if (cda[CTA_TUPLE_REPLY])
-		h = nf_conntrack_find_get(net, &zone, &rtuple);
+		h = nf_conntrack_find_get(info->net, &zone, &rtuple);
 
 	if (h == NULL) {
 		err = -ENOENT;
-		if (nlh->nlmsg_flags & NLM_F_CREATE) {
+		if (info->nlh->nlmsg_flags & NLM_F_CREATE) {
 			enum ip_conntrack_events events;
 
 			if (!cda[CTA_TUPLE_ORIG] || !cda[CTA_TUPLE_REPLY])
@@ -2421,8 +2414,8 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
 			if (otuple.dst.protonum != rtuple.dst.protonum)
 				return -EINVAL;
 
-			ct = ctnetlink_create_conntrack(net, &zone, cda, &otuple,
-							&rtuple, u3);
+			ct = ctnetlink_create_conntrack(info->net, &zone, cda,
+							&otuple, &rtuple, u3);
 			if (IS_ERR(ct))
 				return PTR_ERR(ct);
 
@@ -2445,7 +2438,7 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
 						      (1 << IPCT_SYNPROXY) |
 						      events,
 						      ct, NETLINK_CB(skb).portid,
-						      nlmsg_report(nlh));
+						      nlmsg_report(info->nlh));
 			nf_ct_put(ct);
 		}
 
@@ -2455,7 +2448,7 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
 
 	err = -EEXIST;
 	ct = nf_ct_tuplehash_to_ctrack(h);
-	if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
+	if (!(info->nlh->nlmsg_flags & NLM_F_EXCL)) {
 		err = ctnetlink_change_conntrack(ct, cda);
 		if (err == 0) {
 			nf_conntrack_eventmask_report((1 << IPCT_REPLY) |
@@ -2467,7 +2460,7 @@ static int ctnetlink_new_conntrack(struct net *net, struct sock *ctnl,
 						      (1 << IPCT_MARK) |
 						      (1 << IPCT_SYNPROXY),
 						      ct, NETLINK_CB(skb).portid,
-						      nlmsg_report(nlh));
+						      nlmsg_report(info->nlh));
 		}
 	}
 
@@ -2539,17 +2532,15 @@ ctnetlink_ct_stat_cpu_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-static int ctnetlink_stat_ct_cpu(struct net *net, struct sock *ctnl,
-				 struct sk_buff *skb,
-				 const struct nlmsghdr *nlh,
-				 const struct nlattr * const cda[],
-				 struct netlink_ext_ack *extack)
+static int ctnetlink_stat_ct_cpu(struct sk_buff *skb,
+				 const struct nfnl_info *info,
+				 const struct nlattr * const cda[])
 {
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = ctnetlink_ct_stat_cpu_dump,
 		};
-		return netlink_dump_start(ctnl, skb, nlh, &c);
+		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
 
 	return 0;
@@ -2585,10 +2576,8 @@ ctnetlink_stat_ct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	return -1;
 }
 
-static int ctnetlink_stat_ct(struct net *net, struct sock *ctnl,
-			     struct sk_buff *skb, const struct nlmsghdr *nlh,
-			     const struct nlattr * const cda[],
-			     struct netlink_ext_ack *extack)
+static int ctnetlink_stat_ct(struct sk_buff *skb, const struct nfnl_info *info,
+			     const struct nlattr * const cda[])
 {
 	struct sk_buff *skb2;
 	int err;
@@ -2598,13 +2587,14 @@ static int ctnetlink_stat_ct(struct net *net, struct sock *ctnl,
 		return -ENOMEM;
 
 	err = ctnetlink_stat_ct_fill_info(skb2, NETLINK_CB(skb).portid,
-					  nlh->nlmsg_seq,
-					  NFNL_MSG_TYPE(nlh->nlmsg_type),
+					  info->nlh->nlmsg_seq,
+					  NFNL_MSG_TYPE(info->nlh->nlmsg_type),
 					  sock_net(skb->sk));
 	if (err <= 0)
 		goto free;
 
-	err = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid, MSG_DONTWAIT);
+	err = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
+			      MSG_DONTWAIT);
 	if (err < 0)
 		goto out;
 
@@ -3284,29 +3274,29 @@ static int ctnetlink_dump_exp_ct(struct net *net, struct sock *ctnl,
 	return err;
 }
 
-static int ctnetlink_get_expect(struct net *net, struct sock *ctnl,
-				struct sk_buff *skb, const struct nlmsghdr *nlh,
-				const struct nlattr * const cda[],
-				struct netlink_ext_ack *extack)
+static int ctnetlink_get_expect(struct sk_buff *skb,
+				const struct nfnl_info *info,
+				const struct nlattr * const cda[])
 {
+	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	u_int8_t u3 = nfmsg->nfgen_family;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_expect *exp;
-	struct sk_buff *skb2;
-	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u_int8_t u3 = nfmsg->nfgen_family;
 	struct nf_conntrack_zone zone;
+	struct sk_buff *skb2;
 	int err;
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		if (cda[CTA_EXPECT_MASTER])
-			return ctnetlink_dump_exp_ct(net, ctnl, skb, nlh, cda,
-						     extack);
+			return ctnetlink_dump_exp_ct(info->net, info->sk, skb,
+						     info->nlh, cda,
+						     info->extack);
 		else {
 			struct netlink_dump_control c = {
 				.dump = ctnetlink_exp_dump_table,
 				.done = ctnetlink_exp_done,
 			};
-			return netlink_dump_start(ctnl, skb, nlh, &c);
+			return netlink_dump_start(info->sk, skb, info->nlh, &c);
 		}
 	}
 
@@ -3326,7 +3316,7 @@ static int ctnetlink_get_expect(struct net *net, struct sock *ctnl,
 	if (err < 0)
 		return err;
 
-	exp = nf_ct_expect_find_get(net, &zone, &tuple);
+	exp = nf_ct_expect_find_get(info->net, &zone, &tuple);
 	if (!exp)
 		return -ENOENT;
 
@@ -3348,13 +3338,15 @@ static int ctnetlink_get_expect(struct net *net, struct sock *ctnl,
 
 	rcu_read_lock();
 	err = ctnetlink_exp_fill_info(skb2, NETLINK_CB(skb).portid,
-				      nlh->nlmsg_seq, IPCTNL_MSG_EXP_NEW, exp);
+				      info->nlh->nlmsg_seq, IPCTNL_MSG_EXP_NEW,
+				      exp);
 	rcu_read_unlock();
 	nf_ct_expect_put(exp);
 	if (err <= 0)
 		goto free;
 
-	err = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid, MSG_DONTWAIT);
+	err = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
+			      MSG_DONTWAIT);
 	if (err < 0)
 		goto out;
 
@@ -3382,15 +3374,14 @@ static bool expect_iter_all(struct nf_conntrack_expect *exp, void *data)
 	return true;
 }
 
-static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
-				struct sk_buff *skb, const struct nlmsghdr *nlh,
-				const struct nlattr * const cda[],
-				struct netlink_ext_ack *extack)
+static int ctnetlink_del_expect(struct sk_buff *skb,
+				const struct nfnl_info *info,
+				const struct nlattr * const cda[])
 {
+	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	u_int8_t u3 = nfmsg->nfgen_family;
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple tuple;
-	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u_int8_t u3 = nfmsg->nfgen_family;
 	struct nf_conntrack_zone zone;
 	int err;
 
@@ -3406,7 +3397,7 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
 			return err;
 
 		/* bump usage count to 2 */
-		exp = nf_ct_expect_find_get(net, &zone, &tuple);
+		exp = nf_ct_expect_find_get(info->net, &zone, &tuple);
 		if (!exp)
 			return -ENOENT;
 
@@ -3422,7 +3413,7 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
 		spin_lock_bh(&nf_conntrack_expect_lock);
 		if (del_timer(&exp->timeout)) {
 			nf_ct_unlink_expect_report(exp, NETLINK_CB(skb).portid,
-						   nlmsg_report(nlh));
+						   nlmsg_report(info->nlh));
 			nf_ct_expect_put(exp);
 		}
 		spin_unlock_bh(&nf_conntrack_expect_lock);
@@ -3432,14 +3423,14 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
 	} else if (cda[CTA_EXPECT_HELP_NAME]) {
 		char *name = nla_data(cda[CTA_EXPECT_HELP_NAME]);
 
-		nf_ct_expect_iterate_net(net, expect_iter_name, name,
+		nf_ct_expect_iterate_net(info->net, expect_iter_name, name,
 					 NETLINK_CB(skb).portid,
-					 nlmsg_report(nlh));
+					 nlmsg_report(info->nlh));
 	} else {
 		/* This basically means we have to flush everything*/
-		nf_ct_expect_iterate_net(net, expect_iter_all, NULL,
+		nf_ct_expect_iterate_net(info->net, expect_iter_all, NULL,
 					 NETLINK_CB(skb).portid,
-					 nlmsg_report(nlh));
+					 nlmsg_report(info->nlh));
 	}
 
 	return 0;
@@ -3635,15 +3626,14 @@ ctnetlink_create_expect(struct net *net,
 	return err;
 }
 
-static int ctnetlink_new_expect(struct net *net, struct sock *ctnl,
-				struct sk_buff *skb, const struct nlmsghdr *nlh,
-				const struct nlattr * const cda[],
-				struct netlink_ext_ack *extack)
+static int ctnetlink_new_expect(struct sk_buff *skb,
+				const struct nfnl_info *info,
+				const struct nlattr * const cda[])
 {
+	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
+	u_int8_t u3 = nfmsg->nfgen_family;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_expect *exp;
-	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u_int8_t u3 = nfmsg->nfgen_family;
 	struct nf_conntrack_zone zone;
 	int err;
 
@@ -3662,20 +3652,20 @@ static int ctnetlink_new_expect(struct net *net, struct sock *ctnl,
 		return err;
 
 	spin_lock_bh(&nf_conntrack_expect_lock);
-	exp = __nf_ct_expect_find(net, &zone, &tuple);
+	exp = __nf_ct_expect_find(info->net, &zone, &tuple);
 	if (!exp) {
 		spin_unlock_bh(&nf_conntrack_expect_lock);
 		err = -ENOENT;
-		if (nlh->nlmsg_flags & NLM_F_CREATE) {
-			err = ctnetlink_create_expect(net, &zone, cda, u3,
+		if (info->nlh->nlmsg_flags & NLM_F_CREATE) {
+			err = ctnetlink_create_expect(info->net, &zone, cda, u3,
 						      NETLINK_CB(skb).portid,
-						      nlmsg_report(nlh));
+						      nlmsg_report(info->nlh));
 		}
 		return err;
 	}
 
 	err = -EEXIST;
-	if (!(nlh->nlmsg_flags & NLM_F_EXCL))
+	if (!(info->nlh->nlmsg_flags & NLM_F_EXCL))
 		err = ctnetlink_change_expect(exp, cda);
 	spin_unlock_bh(&nf_conntrack_expect_lock);
 
@@ -3736,17 +3726,15 @@ ctnetlink_exp_stat_cpu_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-static int ctnetlink_stat_exp_cpu(struct net *net, struct sock *ctnl,
-				  struct sk_buff *skb,
-				  const struct nlmsghdr *nlh,
-				  const struct nlattr * const cda[],
-				  struct netlink_ext_ack *extack)
+static int ctnetlink_stat_exp_cpu(struct sk_buff *skb,
+				  const struct nfnl_info *info,
+				  const struct nlattr * const cda[])
 {
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = ctnetlink_exp_stat_cpu_dump,
 		};
-		return netlink_dump_start(ctnl, skb, nlh, &c);
+		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
 
 	return 0;
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 06f5886f652e..5f04b67bf47e 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -252,6 +252,12 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct nlattr *attr = (void *)nlh + min_len;
 		int attrlen = nlh->nlmsg_len - min_len;
 		__u8 subsys_id = NFNL_SUBSYS_ID(type);
+		struct nfnl_info info = {
+			.net	= net,
+			.sk	= nfnlnet->nfnl,
+			.nlh	= nlh,
+			.extack	= extack,
+		};
 
 		/* Sanity-check NFNL_MAX_ATTR_COUNT */
 		if (ss->cb[cb_id].attr_count > NFNL_MAX_ATTR_COUNT) {
@@ -276,14 +282,14 @@ static int nfnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			rcu_read_unlock();
 			nfnl_lock(subsys_id);
 			if (nfnl_dereference_protected(subsys_id) != ss ||
-			    nfnetlink_find_client(type, ss) != nc)
+			    nfnetlink_find_client(type, ss) != nc) {
 				err = -EAGAIN;
-			else if (nc->call)
-				err = nc->call(net, nfnlnet->nfnl, skb, nlh,
-					       (const struct nlattr **)cda,
-					       extack);
-			else
+			} else if (nc->call) {
+				err = nc->call(skb, &info,
+					       (const struct nlattr **)cda);
+			} else {
 				err = -EINVAL;
+			}
 			nfnl_unlock(subsys_id);
 		}
 		if (err == -EAGAIN)
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 6895f31c5fbb..9cb4b21b8e95 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -56,15 +56,13 @@ static inline struct nfnl_acct_net *nfnl_acct_pernet(struct net *net)
 #define NFACCT_F_QUOTA (NFACCT_F_QUOTA_PKTS | NFACCT_F_QUOTA_BYTES)
 #define NFACCT_OVERQUOTA_BIT	2	/* NFACCT_F_OVERQUOTA */
 
-static int nfnl_acct_new(struct net *net, struct sock *nfnl,
-			 struct sk_buff *skb, const struct nlmsghdr *nlh,
-			 const struct nlattr * const tb[],
-			 struct netlink_ext_ack *extack)
+static int nfnl_acct_new(struct sk_buff *skb, const struct nfnl_info *info,
+			 const struct nlattr * const tb[])
 {
-	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
+	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(info->net);
 	struct nf_acct *nfacct, *matching = NULL;
-	char *acct_name;
 	unsigned int size = 0;
+	char *acct_name;
 	u32 flags = 0;
 
 	if (!tb[NFACCT_NAME])
@@ -78,7 +76,7 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
 		if (strncmp(nfacct->name, acct_name, NFACCT_NAME_MAX) != 0)
 			continue;
 
-                if (nlh->nlmsg_flags & NLM_F_EXCL)
+                if (info->nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 
 		matching = nfacct;
@@ -86,7 +84,7 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
         }
 
 	if (matching) {
-		if (nlh->nlmsg_flags & NLM_F_REPLACE) {
+		if (info->nlh->nlmsg_flags & NLM_F_REPLACE) {
 			/* reset counters if you request a replacement. */
 			atomic64_set(&matching->pkts, 0);
 			atomic64_set(&matching->bytes, 0);
@@ -273,17 +271,15 @@ static int nfnl_acct_start(struct netlink_callback *cb)
 	return 0;
 }
 
-static int nfnl_acct_get(struct net *net, struct sock *nfnl,
-			 struct sk_buff *skb, const struct nlmsghdr *nlh,
-			 const struct nlattr * const tb[],
-			 struct netlink_ext_ack *extack)
+static int nfnl_acct_get(struct sk_buff *skb, const struct nfnl_info *info,
+			 const struct nlattr * const tb[])
 {
-	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
+	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(info->net);
 	int ret = -ENOENT;
 	struct nf_acct *cur;
 	char *acct_name;
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nfnl_acct_dump,
 			.start = nfnl_acct_start,
@@ -291,7 +287,7 @@ static int nfnl_acct_get(struct net *net, struct sock *nfnl,
 			.data = (void *)tb[NFACCT_FILTER],
 		};
 
-		return netlink_dump_start(nfnl, skb, nlh, &c);
+		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
 
 	if (!tb[NFACCT_NAME])
@@ -311,15 +307,15 @@ static int nfnl_acct_get(struct net *net, struct sock *nfnl,
 		}
 
 		ret = nfnl_acct_fill_info(skb2, NETLINK_CB(skb).portid,
-					 nlh->nlmsg_seq,
-					 NFNL_MSG_TYPE(nlh->nlmsg_type),
-					 NFNL_MSG_ACCT_NEW, cur);
+					  info->nlh->nlmsg_seq,
+					  NFNL_MSG_TYPE(info->nlh->nlmsg_type),
+					  NFNL_MSG_ACCT_NEW, cur);
 		if (ret <= 0) {
 			kfree_skb(skb2);
 			break;
 		}
-		ret = netlink_unicast(nfnl, skb2, NETLINK_CB(skb).portid,
-					MSG_DONTWAIT);
+		ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
+				      MSG_DONTWAIT);
 		if (ret > 0)
 			ret = 0;
 
@@ -347,12 +343,10 @@ static int nfnl_acct_try_del(struct nf_acct *cur)
 	return ret;
 }
 
-static int nfnl_acct_del(struct net *net, struct sock *nfnl,
-			 struct sk_buff *skb, const struct nlmsghdr *nlh,
-			 const struct nlattr * const tb[],
-			 struct netlink_ext_ack *extack)
+static int nfnl_acct_del(struct sk_buff *skb, const struct nfnl_info *info,
+			 const struct nlattr * const tb[])
 {
-	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(net);
+	struct nfnl_acct_net *nfnl_acct_net = nfnl_acct_pernet(info->net);
 	struct nf_acct *cur, *tmp;
 	int ret = -ENOENT;
 	char *acct_name;
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 22f6f7fcc724..3d1a5215177b 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -408,10 +408,8 @@ nfnl_cthelper_update(const struct nlattr * const tb[],
 	return 0;
 }
 
-static int nfnl_cthelper_new(struct net *net, struct sock *nfnl,
-			     struct sk_buff *skb, const struct nlmsghdr *nlh,
-			     const struct nlattr * const tb[],
-			     struct netlink_ext_ack *extack)
+static int nfnl_cthelper_new(struct sk_buff *skb, const struct nfnl_info *info,
+			     const struct nlattr * const tb[])
 {
 	const char *helper_name;
 	struct nf_conntrack_helper *cur, *helper = NULL;
@@ -441,7 +439,7 @@ static int nfnl_cthelper_new(struct net *net, struct sock *nfnl,
 		     tuple.dst.protonum != cur->tuple.dst.protonum))
 			continue;
 
-		if (nlh->nlmsg_flags & NLM_F_EXCL)
+		if (info->nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 
 		helper = cur;
@@ -607,10 +605,8 @@ nfnl_cthelper_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-static int nfnl_cthelper_get(struct net *net, struct sock *nfnl,
-			     struct sk_buff *skb, const struct nlmsghdr *nlh,
-			     const struct nlattr * const tb[],
-			     struct netlink_ext_ack *extack)
+static int nfnl_cthelper_get(struct sk_buff *skb, const struct nfnl_info *info,
+			     const struct nlattr * const tb[])
 {
 	int ret = -ENOENT;
 	struct nf_conntrack_helper *cur;
@@ -623,11 +619,11 @@ static int nfnl_cthelper_get(struct net *net, struct sock *nfnl,
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nfnl_cthelper_dump_table,
 		};
-		return netlink_dump_start(nfnl, skb, nlh, &c);
+		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
 
 	if (tb[NFCTH_NAME])
@@ -659,15 +655,15 @@ static int nfnl_cthelper_get(struct net *net, struct sock *nfnl,
 		}
 
 		ret = nfnl_cthelper_fill_info(skb2, NETLINK_CB(skb).portid,
-					      nlh->nlmsg_seq,
-					      NFNL_MSG_TYPE(nlh->nlmsg_type),
+					      info->nlh->nlmsg_seq,
+					      NFNL_MSG_TYPE(info->nlh->nlmsg_type),
 					      NFNL_MSG_CTHELPER_NEW, cur);
 		if (ret <= 0) {
 			kfree_skb(skb2);
 			break;
 		}
 
-		ret = netlink_unicast(nfnl, skb2, NETLINK_CB(skb).portid,
+		ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
 				      MSG_DONTWAIT);
 		if (ret > 0)
 			ret = 0;
@@ -678,10 +674,8 @@ static int nfnl_cthelper_get(struct net *net, struct sock *nfnl,
 	return ret;
 }
 
-static int nfnl_cthelper_del(struct net *net, struct sock *nfnl,
-			     struct sk_buff *skb, const struct nlmsghdr *nlh,
-			     const struct nlattr * const tb[],
-			     struct netlink_ext_ack *extack)
+static int nfnl_cthelper_del(struct sk_buff *skb, const struct nfnl_info *info,
+			     const struct nlattr * const tb[])
 {
 	char *helper_name = NULL;
 	struct nf_conntrack_helper *cur;
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 46da5548d0b3..994f3172bf42 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -83,13 +83,11 @@ ctnl_timeout_parse_policy(void *timeout,
 	return ret;
 }
 
-static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
-				 struct sk_buff *skb,
-				 const struct nlmsghdr *nlh,
-				 const struct nlattr * const cda[],
-				 struct netlink_ext_ack *extack)
+static int cttimeout_new_timeout(struct sk_buff *skb,
+				 const struct nfnl_info *info,
+				 const struct nlattr * const cda[])
 {
-	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
+	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(info->net);
 	__u16 l3num;
 	__u8 l4num;
 	const struct nf_conntrack_l4proto *l4proto;
@@ -111,7 +109,7 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 		if (strncmp(timeout->name, name, CTNL_TIMEOUT_NAME_MAX) != 0)
 			continue;
 
-		if (nlh->nlmsg_flags & NLM_F_EXCL)
+		if (info->nlh->nlmsg_flags & NLM_F_EXCL)
 			return -EEXIST;
 
 		matching = timeout;
@@ -119,7 +117,7 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 	}
 
 	if (matching) {
-		if (nlh->nlmsg_flags & NLM_F_REPLACE) {
+		if (info->nlh->nlmsg_flags & NLM_F_REPLACE) {
 			/* You cannot replace one timeout policy by another of
 			 * different kind, sorry.
 			 */
@@ -129,7 +127,8 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 
 			return ctnl_timeout_parse_policy(&matching->timeout.data,
 							 matching->timeout.l4proto,
-							 net, cda[CTA_TIMEOUT_DATA]);
+							 info->net,
+							 cda[CTA_TIMEOUT_DATA]);
 		}
 
 		return -EBUSY;
@@ -150,8 +149,8 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 		goto err_proto_put;
 	}
 
-	ret = ctnl_timeout_parse_policy(&timeout->timeout.data, l4proto, net,
-					cda[CTA_TIMEOUT_DATA]);
+	ret = ctnl_timeout_parse_policy(&timeout->timeout.data, l4proto,
+					info->net, cda[CTA_TIMEOUT_DATA]);
 	if (ret < 0)
 		goto err;
 
@@ -248,22 +247,20 @@ ctnl_timeout_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-static int cttimeout_get_timeout(struct net *net, struct sock *ctnl,
-				 struct sk_buff *skb,
-				 const struct nlmsghdr *nlh,
-				 const struct nlattr * const cda[],
-				 struct netlink_ext_ack *extack)
+static int cttimeout_get_timeout(struct sk_buff *skb,
+				 const struct nfnl_info *info,
+				 const struct nlattr * const cda[])
 {
-	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
+	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(info->net);
 	int ret = -ENOENT;
 	char *name;
 	struct ctnl_timeout *cur;
 
-	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = ctnl_timeout_dump,
 		};
-		return netlink_dump_start(ctnl, skb, nlh, &c);
+		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
 
 	if (!cda[CTA_TIMEOUT_NAME])
@@ -283,15 +280,15 @@ static int cttimeout_get_timeout(struct net *net, struct sock *ctnl,
 		}
 
 		ret = ctnl_timeout_fill_info(skb2, NETLINK_CB(skb).portid,
-					     nlh->nlmsg_seq,
-					     NFNL_MSG_TYPE(nlh->nlmsg_type),
+					     info->nlh->nlmsg_seq,
+					     NFNL_MSG_TYPE(info->nlh->nlmsg_type),
 					     IPCTNL_MSG_TIMEOUT_NEW, cur);
 		if (ret <= 0) {
 			kfree_skb(skb2);
 			break;
 		}
-		ret = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid,
-					MSG_DONTWAIT);
+		ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
+				      MSG_DONTWAIT);
 		if (ret > 0)
 			ret = 0;
 
@@ -320,13 +317,11 @@ static int ctnl_timeout_try_del(struct net *net, struct ctnl_timeout *timeout)
 	return ret;
 }
 
-static int cttimeout_del_timeout(struct net *net, struct sock *ctnl,
-				 struct sk_buff *skb,
-				 const struct nlmsghdr *nlh,
-				 const struct nlattr * const cda[],
-				 struct netlink_ext_ack *extack)
+static int cttimeout_del_timeout(struct sk_buff *skb,
+				 const struct nfnl_info *info,
+				 const struct nlattr * const cda[])
 {
-	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
+	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(info->net);
 	struct ctnl_timeout *cur, *tmp;
 	int ret = -ENOENT;
 	char *name;
@@ -334,7 +329,7 @@ static int cttimeout_del_timeout(struct net *net, struct sock *ctnl,
 	if (!cda[CTA_TIMEOUT_NAME]) {
 		list_for_each_entry_safe(cur, tmp, &pernet->nfct_timeout_list,
 					 head)
-			ctnl_timeout_try_del(net, cur);
+			ctnl_timeout_try_del(info->net, cur);
 
 		return 0;
 	}
@@ -344,7 +339,7 @@ static int cttimeout_del_timeout(struct net *net, struct sock *ctnl,
 		if (strncmp(cur->name, name, CTNL_TIMEOUT_NAME_MAX) != 0)
 			continue;
 
-		ret = ctnl_timeout_try_del(net, cur);
+		ret = ctnl_timeout_try_del(info->net, cur);
 		if (ret < 0)
 			return ret;
 
@@ -353,11 +348,9 @@ static int cttimeout_del_timeout(struct net *net, struct sock *ctnl,
 	return ret;
 }
 
-static int cttimeout_default_set(struct net *net, struct sock *ctnl,
-				 struct sk_buff *skb,
-				 const struct nlmsghdr *nlh,
-				 const struct nlattr * const cda[],
-				 struct netlink_ext_ack *extack)
+static int cttimeout_default_set(struct sk_buff *skb,
+				 const struct nfnl_info *info,
+				 const struct nlattr * const cda[])
 {
 	const struct nf_conntrack_l4proto *l4proto;
 	__u8 l4num;
@@ -377,7 +370,7 @@ static int cttimeout_default_set(struct net *net, struct sock *ctnl,
 		goto err;
 	}
 
-	ret = ctnl_timeout_parse_policy(NULL, l4proto, net,
+	ret = ctnl_timeout_parse_policy(NULL, l4proto, info->net,
 					cda[CTA_TIMEOUT_DATA]);
 	if (ret < 0)
 		goto err;
@@ -427,11 +420,9 @@ cttimeout_default_fill_info(struct net *net, struct sk_buff *skb, u32 portid,
 	return -1;
 }
 
-static int cttimeout_default_get(struct net *net, struct sock *ctnl,
-				 struct sk_buff *skb,
-				 const struct nlmsghdr *nlh,
-				 const struct nlattr * const cda[],
-				 struct netlink_ext_ack *extack)
+static int cttimeout_default_get(struct sk_buff *skb,
+				 const struct nfnl_info *info,
+				 const struct nlattr * const cda[])
 {
 	const struct nf_conntrack_l4proto *l4proto;
 	unsigned int *timeouts = NULL;
@@ -453,35 +444,35 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 
 	switch (l4proto->l4proto) {
 	case IPPROTO_ICMP:
-		timeouts = &nf_icmp_pernet(net)->timeout;
+		timeouts = &nf_icmp_pernet(info->net)->timeout;
 		break;
 	case IPPROTO_TCP:
-		timeouts = nf_tcp_pernet(net)->timeouts;
+		timeouts = nf_tcp_pernet(info->net)->timeouts;
 		break;
 	case IPPROTO_UDP:
 	case IPPROTO_UDPLITE:
-		timeouts = nf_udp_pernet(net)->timeouts;
+		timeouts = nf_udp_pernet(info->net)->timeouts;
 		break;
 	case IPPROTO_DCCP:
 #ifdef CONFIG_NF_CT_PROTO_DCCP
-		timeouts = nf_dccp_pernet(net)->dccp_timeout;
+		timeouts = nf_dccp_pernet(info->net)->dccp_timeout;
 #endif
 		break;
 	case IPPROTO_ICMPV6:
-		timeouts = &nf_icmpv6_pernet(net)->timeout;
+		timeouts = &nf_icmpv6_pernet(info->net)->timeout;
 		break;
 	case IPPROTO_SCTP:
 #ifdef CONFIG_NF_CT_PROTO_SCTP
-		timeouts = nf_sctp_pernet(net)->timeouts;
+		timeouts = nf_sctp_pernet(info->net)->timeouts;
 #endif
 		break;
 	case IPPROTO_GRE:
 #ifdef CONFIG_NF_CT_PROTO_GRE
-		timeouts = nf_gre_pernet(net)->timeouts;
+		timeouts = nf_gre_pernet(info->net)->timeouts;
 #endif
 		break;
 	case 255:
-		timeouts = &nf_generic_pernet(net)->timeout;
+		timeouts = &nf_generic_pernet(info->net)->timeout;
 		break;
 	default:
 		WARN_ONCE(1, "Missing timeouts for proto %d", l4proto->l4proto);
@@ -497,9 +488,10 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 		goto err;
 	}
 
-	ret = cttimeout_default_fill_info(net, skb2, NETLINK_CB(skb).portid,
-					  nlh->nlmsg_seq,
-					  NFNL_MSG_TYPE(nlh->nlmsg_type),
+	ret = cttimeout_default_fill_info(info->net, skb2,
+					  NETLINK_CB(skb).portid,
+					  info->nlh->nlmsg_seq,
+					  NFNL_MSG_TYPE(info->nlh->nlmsg_type),
 					  IPCTNL_MSG_TIMEOUT_DEFAULT_SET,
 					  l3num, l4proto, timeouts);
 	if (ret <= 0) {
@@ -507,7 +499,8 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 		err = -ENOMEM;
 		goto err;
 	}
-	ret = netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid, MSG_DONTWAIT);
+	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
+			      MSG_DONTWAIT);
 	if (ret > 0)
 		ret = 0;
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d5f458d0ff3d..81630600b4ef 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -845,10 +845,8 @@ static struct notifier_block nfulnl_rtnl_notifier = {
 	.notifier_call	= nfulnl_rcv_nl_event,
 };
 
-static int nfulnl_recv_unsupp(struct net *net, struct sock *ctnl,
-			      struct sk_buff *skb, const struct nlmsghdr *nlh,
-			      const struct nlattr * const nfqa[],
-			      struct netlink_ext_ack *extack)
+static int nfulnl_recv_unsupp(struct sk_buff *skb, const struct nfnl_info *info,
+			      const struct nlattr * const nfula[])
 {
 	return -ENOTSUPP;
 }
@@ -869,18 +867,16 @@ static const struct nla_policy nfula_cfg_policy[NFULA_CFG_MAX+1] = {
 	[NFULA_CFG_FLAGS]	= { .type = NLA_U16 },
 };
 
-static int nfulnl_recv_config(struct net *net, struct sock *ctnl,
-			      struct sk_buff *skb, const struct nlmsghdr *nlh,
-			      const struct nlattr * const nfula[],
-			      struct netlink_ext_ack *extack)
+static int nfulnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
+			      const struct nlattr * const nfula[])
 {
-	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	struct nfnl_log_net *log = nfnl_log_pernet(info->net);
+	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	u_int16_t group_num = ntohs(nfmsg->res_id);
-	struct nfulnl_instance *inst;
 	struct nfulnl_msg_config_cmd *cmd = NULL;
-	struct nfnl_log_net *log = nfnl_log_pernet(net);
-	int ret = 0;
+	struct nfulnl_instance *inst;
 	u16 flags = 0;
+	int ret = 0;
 
 	if (nfula[NFULA_CFG_CMD]) {
 		u_int8_t pf = nfmsg->nfgen_family;
@@ -889,9 +885,9 @@ static int nfulnl_recv_config(struct net *net, struct sock *ctnl,
 		/* Commands without queue context */
 		switch (cmd->command) {
 		case NFULNL_CFG_CMD_PF_BIND:
-			return nf_log_bind_pf(net, pf, &nfulnl_logger);
+			return nf_log_bind_pf(info->net, pf, &nfulnl_logger);
 		case NFULNL_CFG_CMD_PF_UNBIND:
-			nf_log_unbind_pf(net, pf);
+			nf_log_unbind_pf(info->net, pf);
 			return 0;
 		}
 	}
@@ -932,7 +928,7 @@ static int nfulnl_recv_config(struct net *net, struct sock *ctnl,
 				goto out_put;
 			}
 
-			inst = instance_create(net, group_num,
+			inst = instance_create(info->net, group_num,
 					       NETLINK_CB(skb).portid,
 					       sk_user_ns(NETLINK_CB(skb).sk));
 			if (IS_ERR(inst)) {
diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 916a3c7f9eaf..1fd537ef4496 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -292,10 +292,9 @@ static const struct nla_policy nfnl_osf_policy[OSF_ATTR_MAX + 1] = {
 	[OSF_ATTR_FINGER]	= { .len = sizeof(struct nf_osf_user_finger) },
 };
 
-static int nfnl_osf_add_callback(struct net *net, struct sock *ctnl,
-				 struct sk_buff *skb, const struct nlmsghdr *nlh,
-				 const struct nlattr * const osf_attrs[],
-				 struct netlink_ext_ack *extack)
+static int nfnl_osf_add_callback(struct sk_buff *skb,
+				 const struct nfnl_info *info,
+				 const struct nlattr * const osf_attrs[])
 {
 	struct nf_osf_user_finger *f;
 	struct nf_osf_finger *kf = NULL, *sf;
@@ -307,7 +306,7 @@ static int nfnl_osf_add_callback(struct net *net, struct sock *ctnl,
 	if (!osf_attrs[OSF_ATTR_FINGER])
 		return -EINVAL;
 
-	if (!(nlh->nlmsg_flags & NLM_F_CREATE))
+	if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
 		return -EINVAL;
 
 	f = nla_data(osf_attrs[OSF_ATTR_FINGER]);
@@ -325,7 +324,7 @@ static int nfnl_osf_add_callback(struct net *net, struct sock *ctnl,
 		kfree(kf);
 		kf = NULL;
 
-		if (nlh->nlmsg_flags & NLM_F_EXCL)
+		if (info->nlh->nlmsg_flags & NLM_F_EXCL)
 			err = -EEXIST;
 		break;
 	}
@@ -339,11 +338,9 @@ static int nfnl_osf_add_callback(struct net *net, struct sock *ctnl,
 	return err;
 }
 
-static int nfnl_osf_remove_callback(struct net *net, struct sock *ctnl,
-				    struct sk_buff *skb,
-				    const struct nlmsghdr *nlh,
-				    const struct nlattr * const osf_attrs[],
-				    struct netlink_ext_ack *extack)
+static int nfnl_osf_remove_callback(struct sk_buff *skb,
+				    const struct nfnl_info *info,
+				    const struct nlattr * const osf_attrs[])
 {
 	struct nf_osf_user_finger *f;
 	struct nf_osf_finger *sf;
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 37e81d895e61..9d7e06d85199 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1245,16 +1245,14 @@ static const struct nf_queue_handler nfqh = {
 	.nf_hook_drop	= nfqnl_nf_hook_drop,
 };
 
-static int nfqnl_recv_config(struct net *net, struct sock *ctnl,
-			     struct sk_buff *skb, const struct nlmsghdr *nlh,
-			     const struct nlattr * const nfqa[],
-			     struct netlink_ext_ack *extack)
+static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
+			     const struct nlattr * const nfqa[])
 {
-	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
+	struct nfgenmsg *nfmsg = nlmsg_data(info->nlh);
 	u_int16_t queue_num = ntohs(nfmsg->res_id);
-	struct nfqnl_instance *queue;
 	struct nfqnl_msg_config_cmd *cmd = NULL;
-	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
+	struct nfqnl_instance *queue;
 	__u32 flags = 0, mask = 0;
 	int ret = 0;
 
-- 
2.30.2

