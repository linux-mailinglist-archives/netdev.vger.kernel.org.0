Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981313F9B6A
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 17:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245438AbhH0PFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 11:05:15 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:38126 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233712AbhH0PFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 11:05:14 -0400
X-UUID: 144f094e71e2400db557bd852b042f62-20210827
X-UUID: 144f094e71e2400db557bd852b042f62-20210827
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1513399212; Fri, 27 Aug 2021 23:04:21 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 27 Aug 2021 23:04:20 +0800
Received: from localhost.localdomain (10.15.20.246) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 27 Aug 2021 23:04:19 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <rocco.yue@gmail.com>,
        <chao.song@mediatek.com>, <zhuoliang.zhang@mediatek.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH net-next v6] ipv6: add IFLA_INET6_RA_MTU to expose mtu value
Date:   Fri, 27 Aug 2021 23:04:12 +0800
Message-ID: <20210827150412.9267-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel provides a "/proc/sys/net/ipv6/conf/<iface>/mtu"
file, which can temporarily record the mtu value of the last
received RA message when the RA mtu value is lower than the
interface mtu, but this proc has following limitations:

(1) when the interface mtu (/sys/class/net/<iface>/mtu) is
updeated, mtu6 (/proc/sys/net/ipv6/conf/<iface>/mtu) will
be updated to the value of interface mtu;
(2) mtu6 (/proc/sys/net/ipv6/conf/<iface>/mtu) only affect
ipv6 connection, and not affect ipv4.

Therefore, when the mtu option is carried in the RA message,
there will be a problem that the user sometimes cannot obtain
RA mtu value correctly by reading mtu6.

After this patch set, if a RA message carries the mtu option,
you can send a netlink msg which nlmsg_type is RTM_GETLINK,
and then by parsing the attribute of IFLA_INET6_RA_MTU to
get the mtu value carried in the RA message received on the
inet6 device. In addition, you can also get a link notification
when ra_mtu is updated so it doesn't have to poll.

In this way, if the MTU values that the device receives from
the network in the PCO IPv4 and the RA IPv6 procedures are
different, the user can obtain the correct ipv6 ra_mtu value
and compare the value of ra_mtu and ipv4 mtu, then the device
can use the lower MTU value for both IPv4 and IPv6.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 include/net/if_inet6.h             |  2 ++
 include/uapi/linux/if_link.h       |  1 +
 net/ipv6/addrconf.c                | 10 ++++++++++
 net/ipv6/ndisc.c                   | 17 +++++++++++------
 tools/include/uapi/linux/if_link.h |  1 +
 5 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 42235c178b06..653e7d0f65cb 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -210,6 +210,8 @@ struct inet6_dev {
 
 	unsigned long		tstamp; /* ipv6InterfaceTable update timestamp */
 	struct rcu_head		rcu;
+
+	unsigned int		ra_mtu;
 };
 
 static inline void ipv6_eth_mc_map(const struct in6_addr *addr, char *buf)
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 8aad65b69054..eebd3894fe89 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -417,6 +417,7 @@ enum {
 	IFLA_INET6_ICMP6STATS,	/* statistics (icmpv6)		*/
 	IFLA_INET6_TOKEN,	/* device token			*/
 	IFLA_INET6_ADDR_GEN_MODE, /* implicit address generator mode */
+	IFLA_INET6_RA_MTU,	/* mtu carried in the RA message */
 	__IFLA_INET6_MAX
 };
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 8381288a0d6e..17756f3ed33b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -394,6 +394,7 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 		ndev->cnf.addr_gen_mode = IN6_ADDR_GEN_MODE_STABLE_PRIVACY;
 
 	ndev->cnf.mtu6 = dev->mtu;
+	ndev->ra_mtu = 0;
 	ndev->nd_parms = neigh_parms_alloc(dev, &nd_tbl);
 	if (!ndev->nd_parms) {
 		kfree(ndev);
@@ -3849,6 +3850,7 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 	}
 
 	idev->tstamp = jiffies;
+	idev->ra_mtu = 0;
 
 	/* Last: Shot the device (if unregistered) */
 	if (unregister) {
@@ -5543,6 +5545,7 @@ static inline size_t inet6_ifla6_size(void)
 	     + nla_total_size(ICMP6_MIB_MAX * 8) /* IFLA_INET6_ICMP6STATS */
 	     + nla_total_size(sizeof(struct in6_addr)) /* IFLA_INET6_TOKEN */
 	     + nla_total_size(1) /* IFLA_INET6_ADDR_GEN_MODE */
+	     + nla_total_size(4) /* IFLA_INET6_RA_MTU */
 	     + 0;
 }
 
@@ -5651,6 +5654,10 @@ static int inet6_fill_ifla6_attrs(struct sk_buff *skb, struct inet6_dev *idev,
 	if (nla_put_u8(skb, IFLA_INET6_ADDR_GEN_MODE, idev->cnf.addr_gen_mode))
 		goto nla_put_failure;
 
+	if (idev->ra_mtu &&
+	    nla_put_u32(skb, IFLA_INET6_RA_MTU, idev->ra_mtu))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
@@ -5767,6 +5774,9 @@ static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token,
 static const struct nla_policy inet6_af_policy[IFLA_INET6_MAX + 1] = {
 	[IFLA_INET6_ADDR_GEN_MODE]	= { .type = NLA_U8 },
 	[IFLA_INET6_TOKEN]		= { .len = sizeof(struct in6_addr) },
+	[IFLA_INET6_RA_MTU]		= { .type = NLA_REJECT,
+					    .reject_message =
+						"IFLA_INET6_RA_MTU can not be set" },
 };
 
 static int check_addr_gen_mode(int mode)
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index c467c6419893..4b098521a44c 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1391,12 +1391,6 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 		}
 	}
 
-	/*
-	 *	Send a notify if RA changed managed/otherconf flags or timer settings
-	 */
-	if (send_ifinfo_notify)
-		inet6_ifinfo_notify(RTM_NEWLINK, in6_dev);
-
 skip_linkparms:
 
 	/*
@@ -1496,6 +1490,11 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 		memcpy(&n, ((u8 *)(ndopts.nd_opts_mtu+1))+2, sizeof(mtu));
 		mtu = ntohl(n);
 
+		if (in6_dev->ra_mtu != mtu) {
+			in6_dev->ra_mtu = mtu;
+			send_ifinfo_notify = true;
+		}
+
 		if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu) {
 			ND_PRINTK(2, warn, "RA: invalid mtu: %d\n", mtu);
 		} else if (in6_dev->cnf.mtu6 != mtu) {
@@ -1519,6 +1518,12 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 		ND_PRINTK(2, warn, "RA: invalid RA options\n");
 	}
 out:
+	/* Send a notify if RA changed managed/otherconf flags or
+	 * timer settings or ra_mtu value
+	 */
+	if (send_ifinfo_notify)
+		inet6_ifinfo_notify(RTM_NEWLINK, in6_dev);
+
 	fib6_info_release(rt);
 	if (neigh)
 		neigh_release(neigh);
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index eb15f319aa57..b3610fdd1fee 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -230,6 +230,7 @@ enum {
 	IFLA_INET6_ICMP6STATS,	/* statistics (icmpv6)		*/
 	IFLA_INET6_TOKEN,	/* device token			*/
 	IFLA_INET6_ADDR_GEN_MODE, /* implicit address generator mode */
+	IFLA_INET6_RA_MTU,	/* mtu carried in the RA message */
 	__IFLA_INET6_MAX
 };
 
-- 
2.18.0

