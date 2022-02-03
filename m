Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC10F4A8898
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352219AbiBCQbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:31:53 -0500
Received: from mx07-0057a101.pphosted.com ([205.220.184.10]:34488 "EHLO
        mx07-0057a101.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352218AbiBCQbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:31:52 -0500
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2137FhRF009768;
        Thu, 3 Feb 2022 17:31:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=12052020; bh=vY0lD5md1sLIwCVcBHbC2KeHGjxz2ha31fFKAL++r70=;
 b=oHGRXhQmQNYJ+VOzxbi3T4iuZjUEfVaA0p1M8Vp2toGN+0ZVBcgxwMYuR1j4gcmByhEp
 MyX6Qr1NOxiQSKRsdk78QXLW/k8lVIMkC8RnN2hO6RPAgWoASH/ZgPcHepeJaIHH0VQh
 PHc5d1vA83xJxis5apUCMhzDM7NGXIlUfQSnYO1f+uYhe1CgVpw/2Bvp8Y0q76SCsVAW
 6Raia4SNeW3k//CU6pbBrg0UJzyGVBocV/jwnryzsCRlF848rAtgyWbj/U34sxQsK6u/
 VkYBz9YUuTnjwkPBnvRa6/K+EQhdQBexMngMR2LIEqOx4Dz5fY6wEIQBId4tsFdExYKR bA== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3dxu1u2uj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 17:31:30 +0100
Received: from jacques-work.labs.westermo.se (192.168.131.30) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Thu, 3 Feb 2022 17:31:29 +0100
From:   Jacques de Laval <Jacques.De.Laval@westermo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Jacques de Laval <Jacques.De.Laval@westermo.com>
Subject: [PATCH net-next 1/1] net: Add new protocol attribute to IP addresses
Date:   Thu, 3 Feb 2022 17:31:06 +0100
Message-ID: <20220203163106.1276624-1-Jacques.De.Laval@westermo.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [192.168.131.30]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-ORIG-GUID: DWW9oJnEmFbE87zm8nEWzoY2NR5ZUuL-
X-Proofpoint-GUID: DWW9oJnEmFbE87zm8nEWzoY2NR5ZUuL-
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new protocol attribute to IPv4 and IPv6 addresses.
Inspiration was taken from the protocol attribute of routes. User space
applications like iproute2 can set/get the protocol with the Netlink API.

The attribute is stored as an 8-bit unsigned int. Only IFAPROT_UNSPEC is
defined. The rest of the available ids are available for user space to
define.

Grouping addresses on their origin is useful in scenarios where you want
to distinguish between addresses coming from a specific protocol like DHCP
and addresses that have been statically set.

Tagging addresses with a string label is an existing feature that could be
used as a solution. Unfortunately the max length of a label is
15 characters, and for compatibility reasons the label must be prefixed
with the name of the device followed by a colon. Since device names also
have a max length of 15 characters, only -1 characters is guaranteed to be
available for any origin tag, which is not that much.

A reference implementation of user space setting and getting protocols
is available for iproute2:

Link: https://github.com/westermo/iproute2/commit/9a6ea18bd79f47f293e5edc7780f315ea42ff540

Signed-off-by: Jacques de Laval <Jacques.De.Laval@westermo.com>
---
 include/linux/inetdevice.h   |  1 +
 include/net/addrconf.h       |  1 +
 include/net/if_inet6.h       |  2 ++
 include/uapi/linux/if_addr.h |  4 ++++
 net/ipv4/devinet.c           |  8 ++++++++
 net/ipv6/addrconf.c          | 12 ++++++++++++
 6 files changed, 28 insertions(+)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index a038feb63f23..caa6b7a5b5ac 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -148,6 +148,7 @@ struct in_ifaddr {
 	unsigned char		ifa_prefixlen;
 	__u32			ifa_flags;
 	char			ifa_label[IFNAMSIZ];
+	unsigned char		ifa_proto;
 
 	/* In seconds, relative to tstamp. Expiry is at tstamp + HZ * lft. */
 	__u32			ifa_valid_lft;
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 78ea3e332688..e53d8f4f4166 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -69,6 +69,7 @@ struct ifa6_config {
 	u32			preferred_lft;
 	u32			valid_lft;
 	u16			scope;
+	u8			ifa_proto;
 };
 
 int addrconf_init(void);
diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 653e7d0f65cb..f7c270b24167 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -73,6 +73,8 @@ struct inet6_ifaddr {
 
 	struct rcu_head		rcu;
 	struct in6_addr		peer_addr;
+
+	__u8			ifa_proto;
 };
 
 struct ip6_sf_socklist {
diff --git a/include/uapi/linux/if_addr.h b/include/uapi/linux/if_addr.h
index dfcf3ce0097f..2aa46b9c9961 100644
--- a/include/uapi/linux/if_addr.h
+++ b/include/uapi/linux/if_addr.h
@@ -35,6 +35,7 @@ enum {
 	IFA_FLAGS,
 	IFA_RT_PRIORITY,  /* u32, priority/metric for prefix route */
 	IFA_TARGET_NETNSID,
+	IFA_PROTO,
 	__IFA_MAX,
 };
 
@@ -69,4 +70,7 @@ struct ifa_cacheinfo {
 #define IFA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifaddrmsg))
 #endif
 
+/* ifa_protocol */
+#define IFAPROT_UNSPEC	0
+
 #endif
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 4744c7839de5..369b229d0de4 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -102,6 +102,7 @@ static const struct nla_policy ifa_ipv4_policy[IFA_MAX+1] = {
 	[IFA_FLAGS]		= { .type = NLA_U32 },
 	[IFA_RT_PRIORITY]	= { .type = NLA_U32 },
 	[IFA_TARGET_NETNSID]	= { .type = NLA_S32 },
+	[IFA_PROTO]		= { .type = NLA_U8 },
 };
 
 struct inet_fill_args {
@@ -887,6 +888,11 @@ static struct in_ifaddr *rtm_to_ifaddr(struct net *net, struct nlmsghdr *nlh,
 	if (tb[IFA_RT_PRIORITY])
 		ifa->ifa_rt_priority = nla_get_u32(tb[IFA_RT_PRIORITY]);
 
+	if (tb[IFA_PROTO])
+		ifa->ifa_proto = nla_get_u8(tb[IFA_PROTO]);
+	else
+		ifa->ifa_proto = IFAPROT_UNSPEC;
+
 	if (tb[IFA_CACHEINFO]) {
 		struct ifa_cacheinfo *ci;
 
@@ -1623,6 +1629,7 @@ static size_t inet_nlmsg_size(void)
 	       + nla_total_size(4) /* IFA_BROADCAST */
 	       + nla_total_size(IFNAMSIZ) /* IFA_LABEL */
 	       + nla_total_size(4)  /* IFA_FLAGS */
+	       + nla_total_size(1)  /* IFA_PROTO */
 	       + nla_total_size(4)  /* IFA_RT_PRIORITY */
 	       + nla_total_size(sizeof(struct ifa_cacheinfo)); /* IFA_CACHEINFO */
 }
@@ -1697,6 +1704,7 @@ static int inet_fill_ifaddr(struct sk_buff *skb, struct in_ifaddr *ifa,
 	     nla_put_in_addr(skb, IFA_BROADCAST, ifa->ifa_broadcast)) ||
 	    (ifa->ifa_label[0] &&
 	     nla_put_string(skb, IFA_LABEL, ifa->ifa_label)) ||
+	    nla_put_u8(skb, IFA_PROTO, ifa->ifa_proto) ||
 	    nla_put_u32(skb, IFA_FLAGS, ifa->ifa_flags) ||
 	    (ifa->ifa_rt_priority &&
 	     nla_put_u32(skb, IFA_RT_PRIORITY, ifa->ifa_rt_priority)) ||
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 846037e73723..a74a3e73fcbf 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1117,6 +1117,7 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 	ifa->prefix_len = cfg->plen;
 	ifa->rt_priority = cfg->rt_priority;
 	ifa->flags = cfg->ifa_flags;
+	ifa->ifa_proto = cfg->ifa_proto;
 	/* No need to add the TENTATIVE flag for addresses with NODAD */
 	if (!(cfg->ifa_flags & IFA_F_NODAD))
 		ifa->flags |= IFA_F_TENTATIVE;
@@ -4626,6 +4627,7 @@ static const struct nla_policy ifa_ipv6_policy[IFA_MAX+1] = {
 	[IFA_FLAGS]		= { .len = sizeof(u32) },
 	[IFA_RT_PRIORITY]	= { .len = sizeof(u32) },
 	[IFA_TARGET_NETNSID]	= { .type = NLA_S32 },
+	[IFA_PROTO]             = { .len = sizeof(u8) },
 };
 
 static int
@@ -4750,6 +4752,7 @@ static int inet6_addr_modify(struct inet6_ifaddr *ifp, struct ifa6_config *cfg)
 	ifp->tstamp = jiffies;
 	ifp->valid_lft = cfg->valid_lft;
 	ifp->prefered_lft = cfg->preferred_lft;
+	ifp->ifa_proto = cfg->ifa_proto;
 
 	if (cfg->rt_priority && cfg->rt_priority != ifp->rt_priority)
 		ifp->rt_priority = cfg->rt_priority;
@@ -4843,6 +4846,11 @@ inet6_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (tb[IFA_RT_PRIORITY])
 		cfg.rt_priority = nla_get_u32(tb[IFA_RT_PRIORITY]);
 
+	if (tb[IFA_PROTO])
+		cfg.ifa_proto = nla_get_u8(tb[IFA_PROTO]);
+	else
+		cfg.ifa_proto = IFAPROT_UNSPEC;
+
 	cfg.valid_lft = INFINITY_LIFE_TIME;
 	cfg.preferred_lft = INFINITY_LIFE_TIME;
 
@@ -4946,6 +4954,7 @@ static inline int inet6_ifaddr_msgsize(void)
 	       + nla_total_size(16) /* IFA_ADDRESS */
 	       + nla_total_size(sizeof(struct ifa_cacheinfo))
 	       + nla_total_size(4)  /* IFA_FLAGS */
+	       + nla_total_size(1)  /* IFA_PROTO */
 	       + nla_total_size(4)  /* IFA_RT_PRIORITY */;
 }
 
@@ -5023,6 +5032,9 @@ static int inet6_fill_ifaddr(struct sk_buff *skb, struct inet6_ifaddr *ifa,
 	if (nla_put_u32(skb, IFA_FLAGS, ifa->flags) < 0)
 		goto error;
 
+	if (nla_put_u8(skb, IFA_PROTO, ifa->ifa_proto))
+		goto error;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.33.0

