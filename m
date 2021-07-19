Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F7D3CD4B3
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 14:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbhGSLop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 07:44:45 -0400
Received: from out2.migadu.com ([188.165.223.204]:18979 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236667AbhGSLoo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 07:44:44 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1626697523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K7ghx0AZsAyKL0WMYIN9lYhMMsO+l3gMR+GM0jJGS+I=;
        b=FJCsD5NtTUaB7czIVAKgJuxtM6SYhbF1SJR38/MCwH6CIGd4srQFQT3hgT+hz89P1tV+Bn
        lKGr12K2SdoKpXR6u6KLFvC4c1yhq8WE/zQltRThUr2cp0XhPBehHrRrYBn8jxHMqQBnx8
        AWZQKLBgy1LlH/3SsBIslC66ddTQnxI=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        nikolay@nvidia.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        courmisch@gmail.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH 2/4] net: Adjustment parameters in rtnl_notify()
Date:   Mon, 19 Jul 2021 20:25:06 +0800
Message-Id: <20210719122506.5414-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fifth parameter alread modify from 'struct nlmsghdr *nlh' to
'int report', just adjustment them.
Add the case the nlh variable is NULL in nlmsg_report().

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 include/net/netlink.h    | 5 ++---
 net/bridge/br_fdb.c      | 2 +-
 net/bridge/br_mdb.c      | 4 ++--
 net/bridge/br_netlink.c  | 2 +-
 net/bridge/br_vlan.c     | 2 +-
 net/core/fib_rules.c     | 2 +-
 net/core/neighbour.c     | 2 +-
 net/core/net_namespace.c | 2 +-
 net/core/rtnetlink.c     | 6 +++---
 net/dcb/dcbnl.c          | 2 +-
 net/decnet/dn_dev.c      | 2 +-
 net/decnet/dn_table.c    | 2 +-
 net/ipv4/devinet.c       | 4 ++--
 net/ipv4/fib_semantics.c | 2 +-
 net/ipv4/fib_trie.c      | 2 +-
 net/ipv4/ipmr.c          | 4 ++--
 net/ipv4/nexthop.c       | 4 ++--
 net/ipv6/addrconf.c      | 8 ++++----
 net/ipv6/ip6mr.c         | 4 ++--
 net/ipv6/ndisc.c         | 2 +-
 net/ipv6/route.c         | 9 +++++----
 net/mpls/af_mpls.c       | 4 ++--
 net/phonet/pn_netlink.c  | 4 ++--
 net/wireless/wext-core.c | 2 +-
 24 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 1ceec518ab49..85320141769b 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -875,8 +875,6 @@ static inline int nlmsg_validate_deprecated(const struct nlmsghdr *nlh,
 			      policy, NL_VALIDATE_LIBERAL, extack);
 }
 
-
-
 /**
  * nlmsg_report - need to report back to application?
  * @nlh: netlink message header
@@ -885,7 +883,8 @@ static inline int nlmsg_validate_deprecated(const struct nlmsghdr *nlh,
  */
 static inline int nlmsg_report(const struct nlmsghdr *nlh)
 {
-	return !!(nlh->nlmsg_flags & NLM_F_ECHO);
+
+	return nlh ? !!(nlh->nlmsg_flags & NLM_F_ECHO) : 0;
 }
 
 /**
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 2b862cffc03a..79d2f01280ae 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -816,7 +816,7 @@ static void fdb_notify(struct net_bridge *br,
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, 0, GFP_ATOMIC);
 	return;
 errout:
 	rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 17a720b4473f..e1fc0674edde 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -773,7 +773,7 @@ void br_mdb_notify(struct net_device *dev,
 		goto errout;
 	}
 
-	rtnl_notify(skb, net, 0, RTNLGRP_MDB, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_MDB, 0, GFP_ATOMIC);
 	return;
 errout:
 	rtnl_set_sk_err(net, RTNLGRP_MDB, err);
@@ -839,7 +839,7 @@ void br_rtr_notify(struct net_device *dev, struct net_bridge_port *port,
 		goto errout;
 	}
 
-	rtnl_notify(skb, net, 0, RTNLGRP_MDB, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_MDB, 0, GFP_ATOMIC);
 	return;
 
 errout:
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 8642e56059fb..05a0c67f8a8c 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -607,7 +607,7 @@ void br_info_notify(int event, const struct net_bridge *br,
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_LINK, 0, GFP_ATOMIC);
 	return;
 errout:
 	rtnl_set_sk_err(net, RTNLGRP_LINK, err);
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index a08e9f193009..6ab6bfec5787 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1795,7 +1795,7 @@ void br_vlan_notify(const struct net_bridge *br,
 		goto out_err;
 
 	nlmsg_end(skb, nlh);
-	rtnl_notify(skb, net, 0, RTNLGRP_BRVLAN, NULL, GFP_KERNEL);
+	rtnl_notify(skb, net, 0, RTNLGRP_BRVLAN, 0, GFP_KERNEL);
 	return;
 
 out_err:
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index a9f937975080..47a6335839b5 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -1183,7 +1183,7 @@ static void notify_rule_change(int event, struct fib_rule *rule,
 		goto errout;
 	}
 
-	rtnl_notify(skb, net, pid, ops->nlgroup, nlh, GFP_KERNEL);
+	rtnl_notify(skb, net, pid, ops->nlgroup, nlmsg_report(nlh), GFP_KERNEL);
 	return;
 errout:
 	if (err < 0)
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 53e85c70c6e5..a7d7e3d78651 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3370,7 +3370,7 @@ static void __neigh_notify(struct neighbour *n, int type, int flags,
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, 0, GFP_ATOMIC);
 	return;
 errout:
 	if (err < 0)
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 9b5a767eddd5..4c1853e4e550 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -1070,7 +1070,7 @@ static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
 	if (err < 0)
 		goto err_out;
 
-	rtnl_notify(msg, net, portid, RTNLGRP_NSID, nlh, gfp);
+	rtnl_notify(msg, net, portid, RTNLGRP_NSID, nlmsg_report(nlh), gfp);
 	return;
 
 err_out:
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 48bb9dc6f06f..5c6b7faf4dbc 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3814,7 +3814,7 @@ void rtmsg_ifinfo_send(struct sk_buff *skb, struct net_device *dev, gfp_t flags)
 {
 	struct net *net = dev_net(dev);
 
-	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, flags);
+	rtnl_notify(skb, net, 0, RTNLGRP_LINK, 0, flags);
 }
 
 static void rtmsg_ifinfo_event(int type, struct net_device *dev,
@@ -3908,7 +3908,7 @@ static void rtnl_fdb_notify(struct net_device *dev, u8 *addr, u16 vid, int type,
 		goto errout;
 	}
 
-	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, 0, GFP_ATOMIC);
 	return;
 errout:
 	rtnl_set_sk_err(net, RTNLGRP_NEIGH, err);
@@ -4839,7 +4839,7 @@ static int rtnl_bridge_notify(struct net_device *dev)
 	if (!skb->len)
 		goto errout;
 
-	rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_LINK, 0, GFP_ATOMIC);
 	return 0;
 errout:
 	WARN_ON(err == -EMSGSIZE);
diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index b441ab330fd3..79cf618c768d 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1395,7 +1395,7 @@ static int dcbnl_notify(struct net_device *dev, int event, int cmd,
 	} else {
 		/* End nlmsg and notify broadcast listeners */
 		nlmsg_end(skb, nlh);
-		rtnl_notify(skb, net, 0, RTNLGRP_DCB, NULL, GFP_KERNEL);
+		rtnl_notify(skb, net, 0, RTNLGRP_DCB, 0, GFP_KERNEL);
 	}
 
 	return err;
diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index d1c50a48614b..1e795723b25c 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -728,7 +728,7 @@ static void dn_ifaddr_notify(int event, struct dn_ifaddr *ifa)
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, &init_net, 0, RTNLGRP_DECnet_IFADDR, NULL, GFP_KERNEL);
+	rtnl_notify(skb, &init_net, 0, RTNLGRP_DECnet_IFADDR, 0, GFP_KERNEL);
 	return;
 errout:
 	if (err < 0)
diff --git a/net/decnet/dn_table.c b/net/decnet/dn_table.c
index 4086f9c746af..3f545e486f81 100644
--- a/net/decnet/dn_table.c
+++ b/net/decnet/dn_table.c
@@ -399,7 +399,7 @@ static void dn_rtmsg_fib(int event, struct dn_fib_node *f, int z, u32 tb_id,
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, &init_net, portid, RTNLGRP_DECnet_ROUTE, nlh, GFP_KERNEL);
+	rtnl_notify(skb, &init_net, portid, RTNLGRP_DECnet_ROUTE, nlmsg_report(nlh), GFP_KERNEL);
 	return;
 errout:
 	if (err < 0)
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 73721a4448bd..063b52804122 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1907,7 +1907,7 @@ static void rtmsg_ifa(int event, struct in_ifaddr *ifa, struct nlmsghdr *nlh,
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, net, portid, RTNLGRP_IPV4_IFADDR, nlh, GFP_KERNEL);
+	rtnl_notify(skb, net, portid, RTNLGRP_IPV4_IFADDR, nlmsg_report(nlh), GFP_KERNEL);
 	return;
 errout:
 	if (err < 0)
@@ -2102,7 +2102,7 @@ void inet_netconf_notify_devconf(struct net *net, int event, int type,
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, net, 0, RTNLGRP_IPV4_NETCONF, NULL, GFP_KERNEL);
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV4_NETCONF, 0, GFP_KERNEL);
 	return;
 errout:
 	if (err < 0)
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 4c0c33e4710d..785cf4cc4ddf 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -530,7 +530,7 @@ void rtmsg_fib(int event, __be32 key, struct fib_alias *fa,
 		goto errout;
 	}
 	rtnl_notify(skb, info->nl_net, info->portid, RTNLGRP_IPV4_ROUTE,
-		    info->nlh, GFP_KERNEL);
+		    nlmsg_report(info->nlh), GFP_KERNEL);
 	return;
 errout:
 	if (err < 0)
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 25cf387cca5b..2ded42e3ad67 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1078,7 +1078,7 @@ void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri)
 		goto errout;
 	}
 
-	rtnl_notify(skb, net, 0, RTNLGRP_IPV4_ROUTE, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV4_ROUTE, 0, GFP_ATOMIC);
 	goto out;
 
 errout:
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 2dda856ca260..6768f773e104 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2383,7 +2383,7 @@ static void mroute_netlink_event(struct mr_table *mrt, struct mfc_cache *mfc,
 	if (err < 0)
 		goto errout;
 
-	rtnl_notify(skb, net, 0, RTNLGRP_IPV4_MROUTE, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV4_MROUTE, 0, GFP_ATOMIC);
 	return;
 
 errout:
@@ -2447,7 +2447,7 @@ static void igmpmsg_netlink_event(struct mr_table *mrt, struct sk_buff *pkt)
 
 	nlmsg_end(skb, nlh);
 
-	rtnl_notify(skb, net, 0, RTNLGRP_IPV4_MROUTE_R, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV4_MROUTE_R, 0, GFP_ATOMIC);
 	return;
 
 nla_put_failure:
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 4075230b14c6..681bfb4212d4 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -857,7 +857,7 @@ static void nexthop_notify(int event, struct nexthop *nh, struct nl_info *info)
 	}
 
 	rtnl_notify(skb, info->nl_net, info->portid, RTNLGRP_NEXTHOP,
-		    info->nlh, gfp_any());
+		    nlmsg_report(info->nlh), gfp_any());
 	return;
 errout:
 	if (err < 0)
@@ -978,7 +978,7 @@ static void nexthop_bucket_notify(struct nh_res_table *res_table,
 		goto errout;
 	}
 
-	rtnl_notify(skb, nh->net, 0, RTNLGRP_NEXTHOP, NULL, GFP_KERNEL);
+	rtnl_notify(skb, nh->net, 0, RTNLGRP_NEXTHOP, 0, GFP_KERNEL);
 	return;
 errout:
 	if (err < 0)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index e2f625e39455..27a4d3aa5558 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -583,7 +583,7 @@ void inet6_netconf_notify_devconf(struct net *net, int event, int type,
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_NETCONF, NULL, GFP_KERNEL);
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_NETCONF, 0, GFP_KERNEL);
 	return;
 errout:
 	rtnl_set_sk_err(net, RTNLGRP_IPV6_NETCONF, err);
@@ -5442,7 +5442,7 @@ static void inet6_ifa_notify(int event, struct inet6_ifaddr *ifa)
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_IFADDR, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_IFADDR, 0, GFP_ATOMIC);
 	return;
 errout:
 	if (err < 0)
@@ -5979,7 +5979,7 @@ void inet6_ifinfo_notify(int event, struct inet6_dev *idev)
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_IFINFO, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_IFINFO, 0, GFP_ATOMIC);
 	return;
 errout:
 	if (err < 0)
@@ -6051,7 +6051,7 @@ static void inet6_prefix_notify(int event, struct inet6_dev *idev,
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_PREFIX, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_PREFIX, 0, GFP_ATOMIC);
 	return;
 errout:
 	if (err < 0)
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 06b0d2c329b9..daa4dce01964 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2412,7 +2412,7 @@ static void mr6_netlink_event(struct mr_table *mrt, struct mfc6_cache *mfc,
 	if (err < 0)
 		goto errout;
 
-	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_MROUTE, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_MROUTE, 0, GFP_ATOMIC);
 	return;
 
 errout:
@@ -2476,7 +2476,7 @@ static void mrt6msg_netlink_event(struct mr_table *mrt, struct sk_buff *pkt)
 
 	nlmsg_end(skb, nlh);
 
-	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_MROUTE_R, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_MROUTE_R, 0, GFP_ATOMIC);
 	return;
 
 nla_put_failure:
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index c467c6419893..bd8219f2d75f 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1157,7 +1157,7 @@ static void ndisc_ra_useropt(struct sk_buff *ra, struct nd_opt_hdr *opt)
 		goto nla_put_failure;
 	nlmsg_end(skb, nlh);
 
-	rtnl_notify(skb, net, 0, RTNLGRP_ND_USEROPT, NULL, GFP_ATOMIC);
+	rtnl_notify(skb, net, 0, RTNLGRP_ND_USEROPT, 0, GFP_ATOMIC);
 	return;
 
 nla_put_failure:
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 7b756a7dc036..c107fcf539d6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3968,7 +3968,7 @@ static int __ip6_del_rt_siblings(struct fib6_info *rt, struct fib6_config *cfg)
 
 	if (skb) {
 		rtnl_notify(skb, net, info->portid, RTNLGRP_IPV6_ROUTE,
-			    info->nlh, gfp_any());
+			    nlmsg_report(info->nlh), gfp_any());
 	}
 	return err;
 }
@@ -6149,7 +6149,7 @@ void inet6_rt_notify(int event, struct fib6_info *rt, struct nl_info *info,
 		goto errout;
 	}
 	rtnl_notify(skb, net, info->portid, RTNLGRP_IPV6_ROUTE,
-		    info->nlh, gfp_any());
+		    nlmsg_report(info->nlh), gfp_any());
 	return;
 errout:
 	if (err < 0)
@@ -6175,8 +6175,9 @@ void fib6_rt_update(struct net *net, struct fib6_info *rt,
 		kfree_skb(skb);
 		goto errout;
 	}
+
 	rtnl_notify(skb, net, info->portid, RTNLGRP_IPV6_ROUTE,
-		    info->nlh, gfp_any());
+		    nlmsg_report(info->nlh), gfp_any());
 	return;
 errout:
 	if (err < 0)
@@ -6227,7 +6228,7 @@ void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
 		goto errout;
 	}
 
-	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_ROUTE, NULL, GFP_KERNEL);
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_ROUTE, 0, GFP_KERNEL);
 	return;
 
 errout:
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 05a21dd072df..2915be869471 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1197,7 +1197,7 @@ static void mpls_netconf_notify_devconf(struct net *net, int event,
 		goto errout;
 	}
 
-	rtnl_notify(skb, net, 0, RTNLGRP_MPLS_NETCONF, NULL, GFP_KERNEL);
+	rtnl_notify(skb, net, 0, RTNLGRP_MPLS_NETCONF, 0, GFP_KERNEL);
 	return;
 errout:
 	if (err < 0)
@@ -2257,7 +2257,7 @@ static void rtmsg_lfib(int event, u32 label, struct mpls_route *rt,
 		kfree_skb(skb);
 		goto errout;
 	}
-	rtnl_notify(skb, net, portid, RTNLGRP_MPLS_ROUTE, nlh, GFP_KERNEL);
+	rtnl_notify(skb, net, portid, RTNLGRP_MPLS_ROUTE, nlmsg_report(nlh), GFP_KERNEL);
 
 	return;
 errout:
diff --git a/net/phonet/pn_netlink.c b/net/phonet/pn_netlink.c
index 59aebe296890..03e04d0b8453 100644
--- a/net/phonet/pn_netlink.c
+++ b/net/phonet/pn_netlink.c
@@ -38,7 +38,7 @@ void phonet_address_notify(int event, struct net_device *dev, u8 addr)
 		goto errout;
 	}
 	rtnl_notify(skb, dev_net(dev), 0,
-		    RTNLGRP_PHONET_IFADDR, NULL, GFP_KERNEL);
+		    RTNLGRP_PHONET_IFADDR, 0, GFP_KERNEL);
 	return;
 errout:
 	rtnl_set_sk_err(dev_net(dev), RTNLGRP_PHONET_IFADDR, err);
@@ -204,7 +204,7 @@ void rtm_phonet_notify(int event, struct net_device *dev, u8 dst)
 		goto errout;
 	}
 	rtnl_notify(skb, dev_net(dev), 0,
-			  RTNLGRP_PHONET_ROUTE, NULL, GFP_KERNEL);
+			  RTNLGRP_PHONET_ROUTE, 0, GFP_KERNEL);
 	return;
 errout:
 	rtnl_set_sk_err(dev_net(dev), RTNLGRP_PHONET_ROUTE, err);
diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 76a80a41615b..7fb2c3144254 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -350,7 +350,7 @@ void wireless_nlevent_flush(void)
 	down_read(&net_rwsem);
 	for_each_net(net) {
 		while ((skb = skb_dequeue(&net->wext_nlevents)))
-			rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL,
+			rtnl_notify(skb, net, 0, RTNLGRP_LINK, 0,
 				    GFP_KERNEL);
 	}
 	up_read(&net_rwsem);
-- 
2.32.0

