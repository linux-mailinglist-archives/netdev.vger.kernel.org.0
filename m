Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2E63E471D
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 16:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbhHIODg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 10:03:36 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:52540 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232707AbhHIODe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 10:03:34 -0400
X-UUID: 6d88ec084ef846daafeab53e5dc075e8-20210809
X-UUID: 6d88ec084ef846daafeab53e5dc075e8-20210809
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 169894149; Mon, 09 Aug 2021 22:03:11 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkexhb02.mediatek.inc (172.21.101.103) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 9 Aug 2021 22:03:10 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Mon, 9 Aug 2021 22:03:09 +0800
Received: from localhost.localdomain (10.15.20.246) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 9 Aug 2021 22:03:02 +0800
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
Subject: [PATCH net-next v3] ipv6: add IFLA_INET6_RA_MTU to expose mtu value in the RA message
Date:   Mon, 9 Aug 2021 22:01:09 +0800
Message-ID: <20210809140109.32595-1-rocco.yue@mediatek.com>
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
different, the user space process can read ra_mtu to get
the mtu value carried in the RA message without worrying
about the issue of ipv4 being stuck due to the late arrival
of RA message. After comparing the value of ra_mtu and ipv4
mtu, then the device can use the lower MTU value for both
IPv4 and IPv6.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 include/net/if_inet6.h             |  2 +
 include/net/ndisc.h                |  1 +
 include/uapi/linux/if_link.h       |  1 +
 net/ipv6/addrconf.c                | 67 ++++++++++++++++++++++++++++++
 net/ipv6/ndisc.c                   |  6 +++
 tools/include/uapi/linux/if_link.h |  1 +
 6 files changed, 78 insertions(+)

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
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 38e4094960ce..c7b7f1b002fd 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -501,5 +501,6 @@ int ndisc_ifinfo_sysctl_strategy(struct ctl_table *ctl,
 #endif
 
 void inet6_ifinfo_notify(int event, struct inet6_dev *idev);
+void inet6_iframtu_notify(struct inet6_dev *idev);
 
 #endif
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5310003523ce..6dfdae1bb860 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -417,6 +417,7 @@ enum {
 	IFLA_INET6_ICMP6STATS,	/* statistics (icmpv6)		*/
 	IFLA_INET6_TOKEN,	/* device token			*/
 	IFLA_INET6_ADDR_GEN_MODE, /* implicit address generator mode */
+	IFLA_INET6_RA_MTU,	/* mtu carried in the RA message  */
 	__IFLA_INET6_MAX
 };
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 8381288a0d6e..3e3cdd49c295 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5543,6 +5543,7 @@ static inline size_t inet6_ifla6_size(void)
 	     + nla_total_size(ICMP6_MIB_MAX * 8) /* IFLA_INET6_ICMP6STATS */
 	     + nla_total_size(sizeof(struct in6_addr)) /* IFLA_INET6_TOKEN */
 	     + nla_total_size(1) /* IFLA_INET6_ADDR_GEN_MODE */
+	     + nla_total_size(4) /* IFLA_INET6_RA_MTU */
 	     + 0;
 }
 
@@ -5651,6 +5652,9 @@ static int inet6_fill_ifla6_attrs(struct sk_buff *skb, struct inet6_dev *idev,
 	if (nla_put_u8(skb, IFLA_INET6_ADDR_GEN_MODE, idev->cnf.addr_gen_mode))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, IFLA_INET6_RA_MTU, idev->ra_mtu))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
@@ -5767,6 +5771,9 @@ static int inet6_set_iftoken(struct inet6_dev *idev, struct in6_addr *token,
 static const struct nla_policy inet6_af_policy[IFLA_INET6_MAX + 1] = {
 	[IFLA_INET6_ADDR_GEN_MODE]	= { .type = NLA_U8 },
 	[IFLA_INET6_TOKEN]		= { .len = sizeof(struct in6_addr) },
+	[IFLA_INET6_RA_MTU]		= { .type = NLA_REJECT,
+					    .reject_message =
+					    "IFLA_INET6_RA_MTU can not be set" },
 };
 
 static int check_addr_gen_mode(int mode)
@@ -6129,6 +6136,66 @@ static void ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
 		__ipv6_ifa_notify(event, ifp);
 }
 
+static inline size_t inet6_iframtu_msgsize(void)
+{
+	return NLMSG_ALIGN(sizeof(struct ifinfomsg))
+	     + nla_total_size(IFNAMSIZ)	/* IFLA_IFNAME */
+	     + nla_total_size(4);	/* IFLA_INET6_RA_MTU */
+}
+
+static int inet6_fill_iframtu(struct sk_buff *skb, struct inet6_dev *idev)
+{
+	struct net_device *dev = idev->dev;
+	struct ifinfomsg *hdr;
+	struct nlmsghdr *nlh;
+
+	nlh = nlmsg_put(skb, 0, 0, RTM_NEWLINK, sizeof(*hdr), 0);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	hdr = nlmsg_data(nlh);
+	hdr->ifi_family = AF_INET6;
+	hdr->__ifi_pad = 0;
+	hdr->ifi_index = dev->ifindex;
+	hdr->ifi_flags = dev_get_flags(dev);
+	hdr->ifi_change = 0;
+
+	if (nla_put_string(skb, IFLA_IFNAME, dev->name) ||
+	    nla_put_u32(skb, IFLA_INET6_RA_MTU, idev->ra_mtu))
+		goto nla_put_failure;
+
+	nlmsg_end(skb, nlh);
+	return 0;
+
+nla_put_failure:
+	nlmsg_cancel(skb, nlh);
+	return -EMSGSIZE;
+}
+
+void inet6_iframtu_notify(struct inet6_dev *idev)
+{
+	struct sk_buff *skb;
+	struct net *net = dev_net(idev->dev);
+	int err = -ENOBUFS;
+
+	skb = nlmsg_new(inet6_iframtu_msgsize(), GFP_ATOMIC);
+	if (!skb)
+		goto errout;
+
+	err = inet6_fill_iframtu(skb, idev);
+	if (err < 0) {
+		/* -EMSGSIZE implies BUG in inet6_iframtu_msgsize() */
+		WARN_ON(err == -EMSGSIZE);
+		kfree_skb(skb);
+		goto errout;
+	}
+	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_IFINFO, NULL, GFP_ATOMIC);
+	return;
+errout:
+	if (err < 0)
+		rtnl_set_sk_err(net, RTNLGRP_IPV6_IFINFO, err);
+}
+
 #ifdef CONFIG_SYSCTL
 
 static int addrconf_sysctl_forward(struct ctl_table *ctl, int write,
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index c467c6419893..a04164cbd77f 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1496,6 +1496,12 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 		memcpy(&n, ((u8 *)(ndopts.nd_opts_mtu+1))+2, sizeof(mtu));
 		mtu = ntohl(n);
 
+		if (in6_dev->ra_mtu != mtu) {
+			in6_dev->ra_mtu = mtu;
+			inet6_iframtu_notify(in6_dev);
+			ND_PRINTK(2, info, "update ra_mtu to %d\n", in6_dev->ra_mtu);
+		}
+
 		if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu) {
 			ND_PRINTK(2, warn, "RA: invalid mtu: %d\n", mtu);
 		} else if (in6_dev->cnf.mtu6 != mtu) {
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index eb15f319aa57..36a8ae4793f1 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -230,6 +230,7 @@ enum {
 	IFLA_INET6_ICMP6STATS,	/* statistics (icmpv6)		*/
 	IFLA_INET6_TOKEN,	/* device token			*/
 	IFLA_INET6_ADDR_GEN_MODE, /* implicit address generator mode */
+	IFLA_INET6_RA_MTU,	/* mtu carried in the RA message  */
 	__IFLA_INET6_MAX
 };
 
-- 
2.18.0

