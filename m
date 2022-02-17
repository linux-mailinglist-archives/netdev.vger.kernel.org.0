Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEAE4BA3ED
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240328AbiBQPDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:03:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiBQPDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:03:03 -0500
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3912C245B3
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:02:46 -0800 (PST)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 21HBkGmA026858;
        Thu, 17 Feb 2022 16:02:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=12052020; bh=yNL/TlYzDdA12QbvXQiktsuLWfq30AyL407U9TSuuic=;
 b=qx3XGmZ72i4baQFTbOU6aLhSiGYdR8W8347R1nKcwpHfD7hWriuR+dDALjw/peCIir+d
 2LzpntrZKNeQNl6LC4BKHlTEn1Vbnm4C9x+GuwCswxXK3RLAg+corLJzjgS0vy846MzH
 7mJf0cTEtjBGrH6UvGfsLTXt5LKOxyYZ3pvRgGyRe1v39t2TtU14FHc3JI4vGdcdZOkT
 7AI8K/GPyVJi1uT1rUFfDpv0iAnV3rqIKd1x7Krn6hr+xqaO/MCYh4llFb7rcknHe0sI
 3W+WIdQcgGRqwkW7/UrfCzmxesl4iWN6qGaerydVX79EgPlkhzaNX6p9Uq/BbMPYO69S ww== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3e8n4121em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 16:02:24 +0100
Received: from jacques-work.labs.westermo.se (192.168.131.30) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Thu, 17 Feb 2022 16:02:23 +0100
From:   Jacques de Laval <Jacques.De.Laval@westermo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Jacques de Laval <Jacques.De.Laval@westermo.com>
Subject: [PATCH net-next v4 1/1] net: Add new protocol attribute to IP addresses
Date:   Thu, 17 Feb 2022 16:02:02 +0100
Message-ID: <20220217150202.80802-1-Jacques.De.Laval@westermo.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [192.168.131.30]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-ORIG-GUID: nmHntEO16safaJ1hiyVswU69HZ9GARV_
X-Proofpoint-GUID: nmHntEO16safaJ1hiyVswU69HZ9GARV_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new protocol attribute to IPv4 and IPv6 addresses.
Inspiration was taken from the protocol attribute of routes. User space
applications like iproute2 can set/get the protocol with the Netlink API.

The attribute is stored as an 8-bit unsigned integer.

The protocol attribute is set by kernel for these categories:

- IPv4 and IPv6 loopback addresses
- IPv6 addresses generated from router announcements
- IPv6 link local addresses

User space may pass custom protocols, not defined by the kernel.

Grouping addresses on their origin is useful in scenarios where you want
to distinguish between addresses based on who added them, e.g. kernel
vs. user space.

Tagging addresses with a string label is an existing feature that could be
used as a solution. Unfortunately the max length of a label is
15 characters, and for compatibility reasons the label must be prefixed
with the name of the device followed by a colon. Since device names also
have a max length of 15 characters, only -1 characters is guaranteed to be
available for any origin tag, which is not that much.

A reference implementation of user space setting and getting protocols
is available for iproute2:

https://github.com/westermo/iproute2/commit/9a6ea18bd79f47f293e5edc7780f315ea42ff540

Signed-off-by: Jacques de Laval <Jacques.De.Laval@westermo.com>
Reviewed-by: David Ahern <dsahern@kernel.org>

---
v1 -> v2:
  - Move ifa_prot to existing holes in structs (David)
  - Change __u8 to u8 (Jakub)
  - Define and use constants for addresses set by kernel (David)
v2 -> v3:
  - Document userspace attribute in comment (David)
  - Fix comment formatting (David)
  - Don't set IFAPROT_KERNEL_LO in inet_set_ifa, could be userspace
    initiated (David)
  - Only set protocol attribute if specified (David)
v3 -> v4
  - Use type field (NLA_U8) instead of len in nla_policy struct (Jakub)
---
 include/linux/inetdevice.h   |  1 +
 include/net/addrconf.h       |  2 ++
 include/net/if_inet6.h       |  2 ++
 include/uapi/linux/if_addr.h |  9 ++++++++-
 net/ipv4/devinet.c           |  7 +++++++
 net/ipv6/addrconf.c          | 27 +++++++++++++++++++++------
 6 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 674aeead6260..ead323243e7b 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -150,6 +150,7 @@ struct in_ifaddr {
 	__be32			ifa_broadcast;
 	unsigned char		ifa_scope;
 	unsigned char		ifa_prefixlen;
+	unsigned char		ifa_proto;
 	__u32			ifa_flags;
 	char			ifa_label[IFNAMSIZ];
 
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index e7ce719838b5..2cc129a89bd6 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -64,6 +64,8 @@ struct ifa6_config {
 	const struct in6_addr	*pfx;
 	unsigned int		plen;
 
+	u8			ifa_proto;
+
 	const struct in6_addr	*peer_pfx;
 
 	u32			rt_priority;
diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index f026cf08a8e8..4cfdef6ca4f6 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -71,6 +71,8 @@ struct inet6_ifaddr {
 
 	bool			tokenized;
 
+	u8			ifa_proto;
+
 	struct rcu_head		rcu;
 	struct in6_addr		peer_addr;
 };
diff --git a/include/uapi/linux/if_addr.h b/include/uapi/linux/if_addr.h
index dfcf3ce0097f..1c392dd95a5e 100644
--- a/include/uapi/linux/if_addr.h
+++ b/include/uapi/linux/if_addr.h
@@ -33,8 +33,9 @@ enum {
 	IFA_CACHEINFO,
 	IFA_MULTICAST,
 	IFA_FLAGS,
-	IFA_RT_PRIORITY,  /* u32, priority/metric for prefix route */
+	IFA_RT_PRIORITY,	/* u32, priority/metric for prefix route */
 	IFA_TARGET_NETNSID,
+	IFA_PROTO,		/* u8, address protocol */
 	__IFA_MAX,
 };
 
@@ -69,4 +70,10 @@ struct ifa_cacheinfo {
 #define IFA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifaddrmsg))
 #endif
 
+/* ifa_proto */
+#define IFAPROT_UNSPEC		0
+#define IFAPROT_KERNEL_LO	1	/* loopback */
+#define IFAPROT_KERNEL_RA	2	/* set by kernel from router announcement */
+#define IFAPROT_KERNEL_LL	3	/* link-local set by kernel */
+
 #endif
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index fba2bffd65f7..53a6b14dc50a 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -104,6 +104,7 @@ static const struct nla_policy ifa_ipv4_policy[IFA_MAX+1] = {
 	[IFA_FLAGS]		= { .type = NLA_U32 },
 	[IFA_RT_PRIORITY]	= { .type = NLA_U32 },
 	[IFA_TARGET_NETNSID]	= { .type = NLA_S32 },
+	[IFA_PROTO]		= { .type = NLA_U8 },
 };
 
 struct inet_fill_args {
@@ -889,6 +890,9 @@ static struct in_ifaddr *rtm_to_ifaddr(struct net *net, struct nlmsghdr *nlh,
 	if (tb[IFA_RT_PRIORITY])
 		ifa->ifa_rt_priority = nla_get_u32(tb[IFA_RT_PRIORITY]);
 
+	if (tb[IFA_PROTO])
+		ifa->ifa_proto = nla_get_u8(tb[IFA_PROTO]);
+
 	if (tb[IFA_CACHEINFO]) {
 		struct ifa_cacheinfo *ci;
 
@@ -1625,6 +1629,7 @@ static size_t inet_nlmsg_size(void)
 	       + nla_total_size(4) /* IFA_BROADCAST */
 	       + nla_total_size(IFNAMSIZ) /* IFA_LABEL */
 	       + nla_total_size(4)  /* IFA_FLAGS */
+	       + nla_total_size(1)  /* IFA_PROTO */
 	       + nla_total_size(4)  /* IFA_RT_PRIORITY */
 	       + nla_total_size(sizeof(struct ifa_cacheinfo)); /* IFA_CACHEINFO */
 }
@@ -1699,6 +1704,8 @@ static int inet_fill_ifaddr(struct sk_buff *skb, struct in_ifaddr *ifa,
 	     nla_put_in_addr(skb, IFA_BROADCAST, ifa->ifa_broadcast)) ||
 	    (ifa->ifa_label[0] &&
 	     nla_put_string(skb, IFA_LABEL, ifa->ifa_label)) ||
+	    (ifa->ifa_proto &&
+	     nla_put_u8(skb, IFA_PROTO, ifa->ifa_proto)) ||
 	    nla_put_u32(skb, IFA_FLAGS, ifa->ifa_flags) ||
 	    (ifa->ifa_rt_priority &&
 	     nla_put_u32(skb, IFA_RT_PRIORITY, ifa->ifa_rt_priority)) ||
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 57fbd6f03ff8..c6ff56cd65f5 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1115,6 +1115,7 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 	ifa->prefix_len = cfg->plen;
 	ifa->rt_priority = cfg->rt_priority;
 	ifa->flags = cfg->ifa_flags;
+	ifa->ifa_proto = cfg->ifa_proto;
 	/* No need to add the TENTATIVE flag for addresses with NODAD */
 	if (!(cfg->ifa_flags & IFA_F_NODAD))
 		ifa->flags |= IFA_F_TENTATIVE;
@@ -2593,6 +2594,7 @@ int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 			.valid_lft = valid_lft,
 			.preferred_lft = prefered_lft,
 			.scope = addr_type & IPV6_ADDR_SCOPE_MASK,
+			.ifa_proto = IFAPROT_KERNEL_RA
 		};
 
 #ifdef CONFIG_IPV6_OPTIMISTIC_DAD
@@ -3077,7 +3079,7 @@ int addrconf_del_ifaddr(struct net *net, void __user *arg)
 }
 
 static void add_addr(struct inet6_dev *idev, const struct in6_addr *addr,
-		     int plen, int scope)
+		     int plen, int scope, u8 proto)
 {
 	struct inet6_ifaddr *ifp;
 	struct ifa6_config cfg = {
@@ -3086,7 +3088,8 @@ static void add_addr(struct inet6_dev *idev, const struct in6_addr *addr,
 		.ifa_flags = IFA_F_PERMANENT,
 		.valid_lft = INFINITY_LIFE_TIME,
 		.preferred_lft = INFINITY_LIFE_TIME,
-		.scope = scope
+		.scope = scope,
+		.ifa_proto = proto
 	};
 
 	ifp = ipv6_add_addr(idev, &cfg, true, NULL);
@@ -3131,7 +3134,7 @@ static void add_v4_addrs(struct inet6_dev *idev)
 	}
 
 	if (addr.s6_addr32[3]) {
-		add_addr(idev, &addr, plen, scope);
+		add_addr(idev, &addr, plen, scope, IFAPROT_UNSPEC);
 		addrconf_prefix_route(&addr, plen, 0, idev->dev, 0, pflags,
 				      GFP_KERNEL);
 		return;
@@ -3154,7 +3157,8 @@ static void add_v4_addrs(struct inet6_dev *idev)
 					flag |= IFA_HOST;
 				}
 
-				add_addr(idev, &addr, plen, flag);
+				add_addr(idev, &addr, plen, flag,
+					 IFAPROT_UNSPEC);
 				addrconf_prefix_route(&addr, plen, 0, idev->dev,
 						      0, pflags, GFP_KERNEL);
 			}
@@ -3177,7 +3181,7 @@ static void init_loopback(struct net_device *dev)
 		return;
 	}
 
-	add_addr(idev, &in6addr_loopback, 128, IFA_HOST);
+	add_addr(idev, &in6addr_loopback, 128, IFA_HOST, IFAPROT_KERNEL_LO);
 }
 
 void addrconf_add_linklocal(struct inet6_dev *idev,
@@ -3189,7 +3193,8 @@ void addrconf_add_linklocal(struct inet6_dev *idev,
 		.ifa_flags = flags | IFA_F_PERMANENT,
 		.valid_lft = INFINITY_LIFE_TIME,
 		.preferred_lft = INFINITY_LIFE_TIME,
-		.scope = IFA_LINK
+		.scope = IFA_LINK,
+		.ifa_proto = IFAPROT_KERNEL_LL
 	};
 	struct inet6_ifaddr *ifp;
 
@@ -4627,6 +4632,7 @@ static const struct nla_policy ifa_ipv6_policy[IFA_MAX+1] = {
 	[IFA_FLAGS]		= { .len = sizeof(u32) },
 	[IFA_RT_PRIORITY]	= { .len = sizeof(u32) },
 	[IFA_TARGET_NETNSID]	= { .type = NLA_S32 },
+	[IFA_PROTO]		= { .type = NLA_U8 },
 };
 
 static int
@@ -4752,6 +4758,7 @@ static int inet6_addr_modify(struct net *net, struct inet6_ifaddr *ifp,
 	ifp->tstamp = jiffies;
 	ifp->valid_lft = cfg->valid_lft;
 	ifp->prefered_lft = cfg->preferred_lft;
+	ifp->ifa_proto = cfg->ifa_proto;
 
 	if (cfg->rt_priority && cfg->rt_priority != ifp->rt_priority)
 		ifp->rt_priority = cfg->rt_priority;
@@ -4845,6 +4852,9 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (tb[IFA_RT_PRIORITY])
 		cfg.rt_priority = nla_get_u32(tb[IFA_RT_PRIORITY]);
 
+	if (tb[IFA_PROTO])
+		cfg.ifa_proto = nla_get_u8(tb[IFA_PROTO]);
+
 	cfg.valid_lft = INFINITY_LIFE_TIME;
 	cfg.preferred_lft = INFINITY_LIFE_TIME;
 
@@ -4948,6 +4958,7 @@ static inline int inet6_ifaddr_msgsize(void)
 	       + nla_total_size(16) /* IFA_ADDRESS */
 	       + nla_total_size(sizeof(struct ifa_cacheinfo))
 	       + nla_total_size(4)  /* IFA_FLAGS */
+	       + nla_total_size(1)  /* IFA_PROTO */
 	       + nla_total_size(4)  /* IFA_RT_PRIORITY */;
 }
 
@@ -5025,6 +5036,10 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 	if (nla_put_u32(skb, IFA_FLAGS, ifa->flags) < 0)
 		goto error;
 
+	if (ifa->ifa_proto &&
+	    nla_put_u8(skb, IFA_PROTO, ifa->ifa_proto))
+		goto error;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.35.1

