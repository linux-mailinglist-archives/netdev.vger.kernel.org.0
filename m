Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23AF3DA02B
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 11:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhG2JSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 05:18:31 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:46540 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S235086AbhG2JSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 05:18:31 -0400
X-UUID: f20c34cfd17347e1828d8a10ec1c4c1d-20210729
X-UUID: f20c34cfd17347e1828d8a10ec1c4c1d-20210729
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 471282150; Thu, 29 Jul 2021 17:18:24 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 29 Jul 2021 17:18:23 +0800
Received: from localhost.localdomain (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Jul 2021 17:18:23 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        <rocco.yue@gmail.com>, <chao.song@mediatek.com>,
        <zhuoliang.zhang@mediatek.com>, Rocco Yue <rocco.yue@mediatek.com>
Subject: [PATCH net-next] net: ipv6: add IFLA_RA_MTU to expose mtu value in the RA message
Date:   Thu, 29 Jul 2021 17:02:06 +0800
Message-ID: <20210729090206.11138-1-rocco.yue@mediatek.com>
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
updeated, mtu6 (/proc/sys/net/ipv6/conf/<iface>/mtu) will be
updated to the value of interface mtu;
(2) mtu6 (/proc/sys/net/ipv6/conf/<iface>/mtu) only affect
ipv6 connection, and not affect ipv4.

Therefore, when the mtu option is carried in the RA message,
there will be a problem that the user sometimes cannot obtain
RA mtu value by reading mtu6.

After this patch set, if a RA message carries the mtu option,
you can use RTM_GETLINK to get the mtu value carried in the
RA message received on the interface.

In this way, If the MTU values that the device receives from the
network in the PCO IPv4 and the RA IPv6 procedures are different,
the user space process can read ra_mtu to get the mtu value carried
in the RA message without worrying about the issue of ipv4 being
stuck due to the late arrival of RA message. After comparing the
value of ra_mtu and ipv4 mtu, then the device can use the lower
MTU value for both IPv4 and IPv6.

Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
---
 include/linux/ipv6.h               |  3 +++
 include/uapi/linux/if_link.h       |  2 +-
 include/uapi/linux/ipv6.h          |  1 +
 net/core/rtnetlink.c               |  7 +++++--
 net/ipv6/addrconf.c                | 13 +++++++++++++
 net/ipv6/ndisc.c                   |  5 +++++
 tools/include/uapi/linux/if_link.h |  1 +
 7 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 70b2ad3b9884..71aa0a3853f8 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -76,6 +76,7 @@ struct ipv6_devconf {
 	__s32		disable_policy;
 	__s32           ndisc_tclass;
 	__s32		rpl_seg_enabled;
+	__s32		ra_mtu;
 
 	struct ctl_table_header *sysctl_header;
 };
@@ -321,6 +322,8 @@ struct tcp6_timewait_sock {
 	struct tcp_timewait_sock   tcp6tw_tcp;
 };
 
+u32 inet6_dev_ramtu(struct net_device *dev);
+
 #if IS_ENABLED(CONFIG_IPV6)
 bool ipv6_mod_enabled(void);
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 4882e81514b6..ea6c872c5f2c 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -347,7 +347,7 @@ enum {
 	 */
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
-
+	IFLA_RA_MTU,
 	__IFLA_MAX
 };
 
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 70603775fe91..3dbcf212b766 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -190,6 +190,7 @@ enum {
 	DEVCONF_NDISC_TCLASS,
 	DEVCONF_RPL_SEG_ENABLED,
 	DEVCONF_RA_DEFRTR_METRIC,
+	DEVCONF_RA_MTU,
 	DEVCONF_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f6af3e74fc44..3f660bbbd7b8 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -37,7 +37,7 @@
 #include <linux/pci.h>
 #include <linux/etherdevice.h>
 #include <linux/bpf.h>
-
+#include <linux/ipv6.h>
 #include <linux/uaccess.h>
 
 #include <linux/inet.h>
@@ -1063,6 +1063,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4)  /* IFLA_MAX_MTU */
 	       + rtnl_prop_list_size(dev)
 	       + nla_total_size(MAX_ADDR_LEN) /* IFLA_PERM_ADDRESS */
+	       + nla_total_size(4)  /* IFLA_RA_MTU */
 	       + 0;
 }
 
@@ -1753,7 +1754,8 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_CARRIER_UP_COUNT,
 			atomic_read(&dev->carrier_up_count)) ||
 	    nla_put_u32(skb, IFLA_CARRIER_DOWN_COUNT,
-			atomic_read(&dev->carrier_down_count)))
+			atomic_read(&dev->carrier_down_count)) ||
+	    nla_put_u32(skb, IFLA_RA_MTU, inet6_dev_ramtu(dev)))
 		goto nla_put_failure;
 
 	if (rtnl_fill_proto_down(skb, dev))
@@ -1891,6 +1893,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
 	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
+	[IFLA_RA_MTU]		= { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3bf685fe64b9..d213400ee8a0 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -237,6 +237,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.ra_mtu			= 0,
 };
 
 static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
@@ -293,6 +294,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
 	.rpl_seg_enabled	= 0,
+	.ra_mtu			= 0,
 };
 
 /* Check if link is ready: is it up and is a valid qdisc available */
@@ -5526,6 +5528,17 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_DISABLE_POLICY] = cnf->disable_policy;
 	array[DEVCONF_NDISC_TCLASS] = cnf->ndisc_tclass;
 	array[DEVCONF_RPL_SEG_ENABLED] = cnf->rpl_seg_enabled;
+	array[DEVCONF_RA_MTU] = cnf->ra_mtu;
+}
+
+u32 inet6_dev_ramtu(struct net_device *dev)
+{
+	struct inet6_dev *idev = __in6_dev_get(dev);
+
+	if (idev)
+		return idev->cnf.ra_mtu;
+
+	return 0;
 }
 
 static inline size_t inet6_ifla6_size(void)
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index c467c6419893..1da626267662 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1496,6 +1496,11 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 		memcpy(&n, ((u8 *)(ndopts.nd_opts_mtu+1))+2, sizeof(mtu));
 		mtu = ntohl(n);
 
+		if (in6_dev->cnf.ra_mtu != mtu) {
+			in6_dev->cnf.ra_mtu = mtu;
+			ND_PRINTK(2, info, "update ra_mtu to %d\n", in6_dev->cnf.ra_mtu);
+		}
+
 		if (mtu < IPV6_MIN_MTU || mtu > skb->dev->mtu) {
 			ND_PRINTK(2, warn, "RA: invalid mtu: %d\n", mtu);
 		} else if (in6_dev->cnf.mtu6 != mtu) {
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index d208b2af697f..abc3607b7bab 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -170,6 +170,7 @@ enum {
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
+	IFLA_RA_MTU,
 	__IFLA_MAX
 };
 
-- 
2.18.0

