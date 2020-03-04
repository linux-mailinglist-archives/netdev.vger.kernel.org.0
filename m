Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEA21799CB
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388417AbgCDU0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:26:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:34006 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387926AbgCDU0j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:26:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EAB68B199;
        Wed,  4 Mar 2020 20:26:36 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 9AE1CE037F; Wed,  4 Mar 2020 21:26:36 +0100 (CET)
Message-Id: <e2a30158cd80c4a99061f98df20c0d8cb4f9b863.1583347351.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 24/25] netlink: message format descriptions for
 rtnetlink
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed,  4 Mar 2020 21:26:36 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description of rtnetlink message formats to be used for pretty printing
infrastructure and helper function to pretty print rtnetlink messages.

As rtnetlink is quite complex and only RTM_GETLINK and RTM_NEWLINK messages
are interesting for ethtool at the moment, this commit provides only names
of a limited subset of rtnetlink messages and names and formats of top
level attributes used in RTM_{NEW,DEL,GET,SET}LINK messages.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am         |  1 +
 netlink/desc-rtnl.c | 96 +++++++++++++++++++++++++++++++++++++++++++++
 netlink/prettymsg.c | 44 +++++++++++++++++++++
 netlink/prettymsg.h |  6 +++
 4 files changed, 147 insertions(+)
 create mode 100644 netlink/desc-rtnl.c

diff --git a/Makefile.am b/Makefile.am
index 74143b727c4f..2fd79eb8c79a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -33,6 +33,7 @@ ethtool_SOURCES += \
 		  netlink/settings.c netlink/parser.c netlink/parser.h \
 		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
+		  netlink/desc-rtnl.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/netlink/desc-rtnl.c b/netlink/desc-rtnl.c
new file mode 100644
index 000000000000..e15e6f0f0d2e
--- /dev/null
+++ b/netlink/desc-rtnl.c
@@ -0,0 +1,96 @@
+/*
+ * desc-rtnl.c - rtnetlink message descriptions
+ *
+ * Descriptions of rtnetlink messages and attributes for pretty print.
+ */
+
+#include <linux/rtnetlink.h>
+
+#include "../internal.h"
+#include "prettymsg.h"
+
+static const struct pretty_nla_desc __link_desc[] = {
+	NLATTR_DESC_INVALID(IFLA_UNSPEC),
+	NLATTR_DESC_BINARY(IFLA_ADDRESS),
+	NLATTR_DESC_BINARY(IFLA_BROADCAST),
+	NLATTR_DESC_STRING(IFLA_IFNAME),
+	NLATTR_DESC_U32(IFLA_MTU),
+	NLATTR_DESC_U32(IFLA_LINK),
+	NLATTR_DESC_STRING(IFLA_QDISC),
+	NLATTR_DESC_BINARY(IFLA_STATS),
+	NLATTR_DESC_INVALID(IFLA_COST),
+	NLATTR_DESC_INVALID(IFLA_PRIORITY),
+	NLATTR_DESC_U32(IFLA_MASTER),
+	NLATTR_DESC_BINARY(IFLA_WIRELESS),
+	NLATTR_DESC_NESTED_NODESC(IFLA_PROTINFO),
+	NLATTR_DESC_U32(IFLA_TXQLEN),
+	NLATTR_DESC_BINARY(IFLA_MAP),
+	NLATTR_DESC_U32(IFLA_WEIGHT),
+	NLATTR_DESC_U8(IFLA_OPERSTATE),
+	NLATTR_DESC_U8(IFLA_LINKMODE),
+	NLATTR_DESC_NESTED_NODESC(IFLA_LINKINFO),
+	NLATTR_DESC_U32(IFLA_NET_NS_PID),
+	NLATTR_DESC_STRING(IFLA_IFALIAS),
+	NLATTR_DESC_U32(IFLA_NUM_VF),
+	NLATTR_DESC_NESTED_NODESC(IFLA_VFINFO_LIST),
+	NLATTR_DESC_BINARY(IFLA_STATS64),
+	NLATTR_DESC_NESTED_NODESC(IFLA_VF_PORTS),
+	NLATTR_DESC_NESTED_NODESC(IFLA_PORT_SELF),
+	NLATTR_DESC_NESTED_NODESC(IFLA_AF_SPEC),
+	NLATTR_DESC_U32(IFLA_GROUP),
+	NLATTR_DESC_U32(IFLA_NET_NS_FD),
+	NLATTR_DESC_U32(IFLA_EXT_MASK),
+	NLATTR_DESC_U32(IFLA_PROMISCUITY),
+	NLATTR_DESC_U32(IFLA_NUM_TX_QUEUES),
+	NLATTR_DESC_U32(IFLA_NUM_RX_QUEUES),
+	NLATTR_DESC_U8(IFLA_CARRIER),
+	NLATTR_DESC_BINARY(IFLA_PHYS_PORT_ID),
+	NLATTR_DESC_U32(IFLA_CARRIER_CHANGES),
+	NLATTR_DESC_BINARY(IFLA_PHYS_SWITCH_ID),
+	NLATTR_DESC_S32(IFLA_LINK_NETNSID),
+	NLATTR_DESC_STRING(IFLA_PHYS_PORT_NAME),
+	NLATTR_DESC_U8(IFLA_PROTO_DOWN),
+	NLATTR_DESC_U32(IFLA_GSO_MAX_SEGS),
+	NLATTR_DESC_U32(IFLA_GSO_MAX_SIZE),
+	NLATTR_DESC_BINARY(IFLA_PAD),
+	NLATTR_DESC_U32(IFLA_XDP),
+	NLATTR_DESC_U32(IFLA_EVENT),
+	NLATTR_DESC_S32(IFLA_NEW_NETNSID),
+	NLATTR_DESC_S32(IFLA_IF_NETNSID),
+	NLATTR_DESC_U32(IFLA_CARRIER_UP_COUNT),
+	NLATTR_DESC_U32(IFLA_CARRIER_DOWN_COUNT),
+	NLATTR_DESC_S32(IFLA_NEW_IFINDEX),
+	NLATTR_DESC_U32(IFLA_MIN_MTU),
+	NLATTR_DESC_U32(IFLA_MAX_MTU),
+	NLATTR_DESC_NESTED_NODESC(IFLA_PROP_LIST),
+	NLATTR_DESC_STRING(IFLA_ALT_IFNAME),
+	NLATTR_DESC_BINARY(IFLA_PERM_ADDRESS),
+};
+
+const struct pretty_nlmsg_desc rtnl_msg_desc[] = {
+	NLMSG_DESC(RTM_NEWLINK, link),
+	NLMSG_DESC(RTM_DELLINK, link),
+	NLMSG_DESC(RTM_GETLINK, link),
+	NLMSG_DESC(RTM_SETLINK, link),
+};
+
+const unsigned int rtnl_msg_n_desc = ARRAY_SIZE(rtnl_msg_desc);
+
+#define RTNL_MSGHDR_LEN(_name, _struct) \
+	[((RTM_ ## _name) - RTM_BASE) / 4] = sizeof(struct _struct)
+#define RTNL_MSGHDR_NOLEN(_name) \
+	[((RTM_ ## _name) - RTM_BASE) / 4] = USHRT_MAX
+
+const unsigned short rtnl_msghdr_lengths[] = {
+	RTNL_MSGHDR_LEN(NEWLINK, ifinfomsg),
+	RTNL_MSGHDR_LEN(NEWADDR, ifaddrmsg),
+	RTNL_MSGHDR_LEN(NEWROUTE, rtmsg),
+	RTNL_MSGHDR_LEN(NEWNEIGH, ndmsg),
+	RTNL_MSGHDR_LEN(NEWRULE, rtmsg),
+	RTNL_MSGHDR_LEN(NEWQDISC, tcmsg),
+	RTNL_MSGHDR_LEN(NEWTCLASS, tcmsg),
+	RTNL_MSGHDR_LEN(NEWTFILTER, tcmsg),
+	RTNL_MSGHDR_LEN(NEWACTION, tcamsg),
+};
+
+const unsigned int rtnl_msghdr_n_len = ARRAY_SIZE(rtnl_msghdr_lengths);
diff --git a/netlink/prettymsg.c b/netlink/prettymsg.c
index 74fe6f2db7ed..9e62bebe615e 100644
--- a/netlink/prettymsg.c
+++ b/netlink/prettymsg.c
@@ -191,3 +191,47 @@ int pretty_print_genlmsg(const struct nlmsghdr *nlhdr,
 				  msg_desc ? msg_desc->attrs : NULL,
 				  msg_desc ? msg_desc->n_attrs : 0, err_offset);
 }
+
+static void rtm_link_summary(const struct ifinfomsg *ifinfo)
+{
+	if (ifinfo->ifi_family)
+		printf(" family=%u", ifinfo->ifi_family);
+	if (ifinfo->ifi_type)
+		printf(" type=0x%04x", ifinfo->ifi_type);
+	if (ifinfo->ifi_index)
+		printf(" ifindex=%d", ifinfo->ifi_index);
+	if (ifinfo->ifi_flags)
+		printf(" flags=0x%x", ifinfo->ifi_flags);
+	if (ifinfo->ifi_flags)
+		printf(" change=0x%x", ifinfo->ifi_change);
+}
+
+int pretty_print_rtnlmsg(const struct nlmsghdr *nlhdr, unsigned int err_offset)
+{
+	const unsigned int idx = (nlhdr->nlmsg_type - RTM_BASE) / 4;
+	const struct pretty_nlmsg_desc *msg_desc = NULL;
+	unsigned int hdrlen = USHRT_MAX;
+
+	if (nlhdr->nlmsg_type < rtnl_msg_n_desc)
+		msg_desc = &rtnl_msg_desc[nlhdr->nlmsg_type];
+	if (idx < rtnl_msghdr_n_len)
+		hdrlen = rtnl_msghdr_lengths[idx];
+	if (hdrlen < USHRT_MAX && mnl_nlmsg_get_payload_len(nlhdr) < hdrlen) {
+		fprintf(stderr, "ethtool: message too short (%u bytes)\n",
+			nlhdr->nlmsg_len);
+		return -EINVAL;
+	}
+	if (msg_desc && msg_desc->name)
+		printf("    %s", msg_desc->name);
+	else
+		printf("    [%u]", nlhdr->nlmsg_type);
+	if (idx == (RTM_NEWLINK - RTM_BASE) / 4)
+		rtm_link_summary(mnl_nlmsg_get_payload(nlhdr));
+	putchar('\n');
+	if (hdrlen == USHRT_MAX)
+		return 0;
+
+	return pretty_print_nlmsg(nlhdr, hdrlen,
+				  msg_desc ? msg_desc->attrs : NULL,
+				  msg_desc ? msg_desc->n_attrs : 0, err_offset);
+}
diff --git a/netlink/prettymsg.h b/netlink/prettymsg.h
index 50d0bbf43665..b5e5f735ac8a 100644
--- a/netlink/prettymsg.h
+++ b/netlink/prettymsg.h
@@ -98,6 +98,7 @@ struct pretty_nlmsg_desc {
 int pretty_print_genlmsg(const struct nlmsghdr *nlhdr,
 			 const struct pretty_nlmsg_desc *desc,
 			 unsigned int ndesc, unsigned int err_offset);
+int pretty_print_rtnlmsg(const struct nlmsghdr *nlhdr, unsigned int err_offset);
 
 /* message descriptions */
 
@@ -109,4 +110,9 @@ extern const unsigned int ethnl_kmsg_n_desc;
 extern const struct pretty_nlmsg_desc genlctrl_msg_desc[];
 extern const unsigned int genlctrl_msg_n_desc;
 
+extern const struct pretty_nlmsg_desc rtnl_msg_desc[];
+extern const unsigned int rtnl_msg_n_desc;
+extern const unsigned short rtnl_msghdr_lengths[];
+extern const unsigned int rtnl_msghdr_n_len;
+
 #endif /* ETHTOOL_NETLINK_PRETTYMSG_H__ */
-- 
2.25.1

