Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400F9397C20
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbhFAWI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:08:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39558 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbhFAWIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 18:08:21 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id F35A1641D0;
        Wed,  2 Jun 2021 00:05:31 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 08/16] netfilter: use nfnetlink_unicast()
Date:   Wed,  2 Jun 2021 00:06:21 +0200
Message-Id: <20210601220629.18307-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace netlink_unicast() calls by nfnetlink_unicast() which already
deals with translating EAGAIN to ENOBUFS as the nfnetlink core expects.

nfnetlink_unicast() calls nlmsg_unicast() which returns zero in case of
success, otherwise the netlink core function netlink_rcv_skb() turns
err > 0 into an acknowlegment.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c    | 50 +++++----------------
 net/netfilter/nf_conntrack_netlink.c | 65 ++++++++--------------------
 net/netfilter/nfnetlink_acct.c       |  9 ++--
 net/netfilter/nfnetlink_cthelper.c   | 10 ++---
 net/netfilter/nfnetlink_cttimeout.c  | 34 +++++----------
 5 files changed, 44 insertions(+), 124 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index de2d20c37cda..16ae92054baa 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1685,8 +1685,8 @@ static const struct nla_policy ip_set_adt_policy[IPSET_ATTR_CMD_MAX + 1] = {
 };
 
 static int
-call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
-	struct nlattr *tb[], enum ipset_adt adt,
+call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
+	struct ip_set *set, struct nlattr *tb[], enum ipset_adt adt,
 	u32 flags, bool use_lineno)
 {
 	int ret;
@@ -1738,8 +1738,7 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 
 		*errline = lineno;
 
-		netlink_unicast(ctnl, skb2, NETLINK_CB(skb).portid,
-				MSG_DONTWAIT);
+		nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 		/* Signal netlink not to send its ACK/errmsg.  */
 		return -EINTR;
 	}
@@ -1783,7 +1782,7 @@ static int ip_set_ad(struct net *net, struct sock *ctnl,
 				     attr[IPSET_ATTR_DATA],
 				     set->type->adt_policy, NULL))
 			return -IPSET_ERR_PROTOCOL;
-		ret = call_ad(ctnl, skb, set, tb, adt, flags,
+		ret = call_ad(net, ctnl, skb, set, tb, adt, flags,
 			      use_lineno);
 	} else {
 		int nla_rem;
@@ -1794,7 +1793,7 @@ static int ip_set_ad(struct net *net, struct sock *ctnl,
 			    nla_parse_nested(tb, IPSET_ATTR_ADT_MAX, nla,
 					     set->type->adt_policy, NULL))
 				return -IPSET_ERR_PROTOCOL;
-			ret = call_ad(ctnl, skb, set, tb, adt,
+			ret = call_ad(net, ctnl, skb, set, tb, adt,
 				      flags, use_lineno);
 			if (ret < 0)
 				return ret;
@@ -1859,7 +1858,6 @@ static int ip_set_header(struct sk_buff *skb, const struct nfnl_info *info,
 	const struct ip_set *set;
 	struct sk_buff *skb2;
 	struct nlmsghdr *nlh2;
-	int ret = 0;
 
 	if (unlikely(protocol_min_failed(attr) ||
 		     !attr[IPSET_ATTR_SETNAME]))
@@ -1885,12 +1883,7 @@ static int ip_set_header(struct sk_buff *skb, const struct nfnl_info *info,
 		goto nla_put_failure;
 	nlmsg_end(skb2, nlh2);
 
-	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 
 nla_put_failure:
 	nlmsg_cancel(skb2, nlh2);
@@ -1945,12 +1938,7 @@ static int ip_set_type(struct sk_buff *skb, const struct nfnl_info *info,
 	nlmsg_end(skb2, nlh2);
 
 	pr_debug("Send TYPE, nlmsg_len: %u\n", nlh2->nlmsg_len);
-	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 
 nla_put_failure:
 	nlmsg_cancel(skb2, nlh2);
@@ -1971,7 +1959,6 @@ static int ip_set_protocol(struct sk_buff *skb, const struct nfnl_info *info,
 {
 	struct sk_buff *skb2;
 	struct nlmsghdr *nlh2;
-	int ret = 0;
 
 	if (unlikely(!attr[IPSET_ATTR_PROTOCOL]))
 		return -IPSET_ERR_PROTOCOL;
@@ -1990,12 +1977,7 @@ static int ip_set_protocol(struct sk_buff *skb, const struct nfnl_info *info,
 		goto nla_put_failure;
 	nlmsg_end(skb2, nlh2);
 
-	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 
 nla_put_failure:
 	nlmsg_cancel(skb2, nlh2);
@@ -2014,7 +1996,6 @@ static int ip_set_byname(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nlmsghdr *nlh2;
 	ip_set_id_t id = IPSET_INVALID_ID;
 	const struct ip_set *set;
-	int ret = 0;
 
 	if (unlikely(protocol_failed(attr) ||
 		     !attr[IPSET_ATTR_SETNAME]))
@@ -2038,12 +2019,7 @@ static int ip_set_byname(struct sk_buff *skb, const struct nfnl_info *info,
 		goto nla_put_failure;
 	nlmsg_end(skb2, nlh2);
 
-	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 
 nla_put_failure:
 	nlmsg_cancel(skb2, nlh2);
@@ -2065,7 +2041,6 @@ static int ip_set_byindex(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nlmsghdr *nlh2;
 	ip_set_id_t id = IPSET_INVALID_ID;
 	const struct ip_set *set;
-	int ret = 0;
 
 	if (unlikely(protocol_failed(attr) ||
 		     !attr[IPSET_ATTR_INDEX]))
@@ -2091,12 +2066,7 @@ static int ip_set_byindex(struct sk_buff *skb, const struct nfnl_info *info,
 		goto nla_put_failure;
 	nlmsg_end(skb2, nlh2);
 
-	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 
 nla_put_failure:
 	nlmsg_cancel(skb2, nlh2);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 8690fc07030f..220f51f055ab 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1628,9 +1628,8 @@ static int ctnetlink_get_conntrack(struct sk_buff *skb,
 
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
-	err = -ENOMEM;
 	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (skb2 == NULL) {
+	if (!skb2) {
 		nf_ct_put(ct);
 		return -ENOMEM;
 	}
@@ -1640,21 +1639,12 @@ static int ctnetlink_get_conntrack(struct sk_buff *skb,
 				  NFNL_MSG_TYPE(info->nlh->nlmsg_type), ct,
 				  true, 0);
 	nf_ct_put(ct);
-	if (err <= 0)
-		goto free;
-
-	err = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (err < 0)
-		goto out;
-
-	return 0;
+	if (err <= 0) {
+		kfree_skb(skb2);
+		return -ENOMEM;
+	}
 
-free:
-	kfree_skb(skb2);
-out:
-	/* this avoids a loop in nfnetlink. */
-	return err == -EAGAIN ? -ENOBUFS : err;
+	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 }
 
 static int ctnetlink_done_list(struct netlink_callback *cb)
@@ -2590,21 +2580,12 @@ static int ctnetlink_stat_ct(struct sk_buff *skb, const struct nfnl_info *info,
 					  info->nlh->nlmsg_seq,
 					  NFNL_MSG_TYPE(info->nlh->nlmsg_type),
 					  sock_net(skb->sk));
-	if (err <= 0)
-		goto free;
-
-	err = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (err < 0)
-		goto out;
-
-	return 0;
+	if (err <= 0) {
+		kfree_skb(skb2);
+		return -ENOMEM;
+	}
 
-free:
-	kfree_skb(skb2);
-out:
-	/* this avoids a loop in nfnetlink. */
-	return err == -EAGAIN ? -ENOBUFS : err;
+	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 }
 
 static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
@@ -3329,11 +3310,10 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 		}
 	}
 
-	err = -ENOMEM;
 	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (skb2 == NULL) {
+	if (!skb2) {
 		nf_ct_expect_put(exp);
-		goto out;
+		return -ENOMEM;
 	}
 
 	rcu_read_lock();
@@ -3342,21 +3322,12 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 				      exp);
 	rcu_read_unlock();
 	nf_ct_expect_put(exp);
-	if (err <= 0)
-		goto free;
-
-	err = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (err < 0)
-		goto out;
-
-	return 0;
+	if (err <= 0) {
+		kfree_skb(skb2);
+		return -ENOMEM;
+	}
 
-free:
-	kfree_skb(skb2);
-out:
-	/* this avoids a loop in nfnetlink. */
-	return err == -EAGAIN ? -ENOBUFS : err;
+	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 }
 
 static bool expect_iter_name(struct nf_conntrack_expect *exp, void *data)
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 3c8cf8748cfb..505f46a32173 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -314,14 +314,11 @@ static int nfnl_acct_get(struct sk_buff *skb, const struct nfnl_info *info,
 			kfree_skb(skb2);
 			break;
 		}
-		ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-				      MSG_DONTWAIT);
-		if (ret > 0)
-			ret = 0;
 
-		/* this avoids a loop in nfnetlink. */
-		return ret == -EAGAIN ? -ENOBUFS : ret;
+		ret = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
+		break;
 	}
+
 	return ret;
 }
 
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 322ac5dd5402..df58cd534ff5 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -663,14 +663,10 @@ static int nfnl_cthelper_get(struct sk_buff *skb, const struct nfnl_info *info,
 			break;
 		}
 
-		ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-				      MSG_DONTWAIT);
-		if (ret > 0)
-			ret = 0;
-
-		/* this avoids a loop in nfnetlink. */
-		return ret == -EAGAIN ? -ENOBUFS : ret;
+		ret = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
+		break;
 	}
+
 	return ret;
 }
 
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 38848ad68899..c57673d499be 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -287,14 +287,11 @@ static int cttimeout_get_timeout(struct sk_buff *skb,
 			kfree_skb(skb2);
 			break;
 		}
-		ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-				      MSG_DONTWAIT);
-		if (ret > 0)
-			ret = 0;
 
-		/* this avoids a loop in nfnetlink. */
-		return ret == -EAGAIN ? -ENOBUFS : ret;
+		ret = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
+		break;
 	}
+
 	return ret;
 }
 
@@ -427,9 +424,9 @@ static int cttimeout_default_get(struct sk_buff *skb,
 	const struct nf_conntrack_l4proto *l4proto;
 	unsigned int *timeouts = NULL;
 	struct sk_buff *skb2;
-	int ret, err;
 	__u16 l3num;
 	__u8 l4num;
+	int ret;
 
 	if (!cda[CTA_TIMEOUT_L3PROTO] || !cda[CTA_TIMEOUT_L4PROTO])
 		return -EINVAL;
@@ -438,9 +435,8 @@ static int cttimeout_default_get(struct sk_buff *skb,
 	l4num = nla_get_u8(cda[CTA_TIMEOUT_L4PROTO]);
 	l4proto = nf_ct_l4proto_find(l4num);
 
-	err = -EOPNOTSUPP;
 	if (l4proto->l4proto != l4num)
-		goto err;
+		return -EOPNOTSUPP;
 
 	switch (l4proto->l4proto) {
 	case IPPROTO_ICMP:
@@ -480,13 +476,11 @@ static int cttimeout_default_get(struct sk_buff *skb,
 	}
 
 	if (!timeouts)
-		goto err;
+		return -EOPNOTSUPP;
 
 	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (skb2 == NULL) {
-		err = -ENOMEM;
-		goto err;
-	}
+	if (!skb2)
+		return -ENOMEM;
 
 	ret = cttimeout_default_fill_info(info->net, skb2,
 					  NETLINK_CB(skb).portid,
@@ -496,18 +490,10 @@ static int cttimeout_default_get(struct sk_buff *skb,
 					  l3num, l4proto, timeouts);
 	if (ret <= 0) {
 		kfree_skb(skb2);
-		err = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
-	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (ret > 0)
-		ret = 0;
 
-	/* this avoids a loop in nfnetlink. */
-	return ret == -EAGAIN ? -ENOBUFS : ret;
-err:
-	return err;
+	return nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 }
 
 static struct nf_ct_timeout *ctnl_timeout_find_get(struct net *net,
-- 
2.30.2

