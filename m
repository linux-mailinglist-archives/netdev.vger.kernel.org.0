Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15EE717C384
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgCFREe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:04:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:43118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727030AbgCFREd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 12:04:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3E5DEB20F;
        Fri,  6 Mar 2020 17:04:25 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id CD022E00E7; Fri,  6 Mar 2020 18:04:24 +0100 (CET)
Message-Id: <e3884b9dddfcff0523534ecf702775f5ecb766cb.1583513281.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583513281.git.mkubecek@suse.cz>
References: <cover.1583513281.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v3 05/25] netlink: add netlink related UAPI header
 files
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Fri,  6 Mar 2020 18:04:24 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add copies of kernel UAPI header files needed for netlink interface:

  <linux/netlink.h>
  <linux/genetlink.h>
  <linux/ethtool_netlink.h>
  <linux/rtnetlink.h>
  <linux/if_link.h>

The (sanitized) copies are taken from v5.6-rc1.

v2:
  - add linux/rtnetlink.h and linux/if_link.h

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 uapi/linux/ethtool_netlink.h |  237 ++++++++
 uapi/linux/genetlink.h       |   89 +++
 uapi/linux/if_link.h         | 1051 ++++++++++++++++++++++++++++++++++
 uapi/linux/netlink.h         |  248 ++++++++
 uapi/linux/rtnetlink.h       |  777 +++++++++++++++++++++++++
 5 files changed, 2402 insertions(+)
 create mode 100644 uapi/linux/ethtool_netlink.h
 create mode 100644 uapi/linux/genetlink.h
 create mode 100644 uapi/linux/if_link.h
 create mode 100644 uapi/linux/netlink.h
 create mode 100644 uapi/linux/rtnetlink.h

diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
new file mode 100644
index 000000000000..ad6d3a00019d
--- /dev/null
+++ b/uapi/linux/ethtool_netlink.h
@@ -0,0 +1,237 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * include/uapi/linux/ethtool_netlink.h - netlink interface for ethtool
+ *
+ * See Documentation/networking/ethtool-netlink.txt in kernel source tree for
+ * doucumentation of the interface.
+ */
+
+#ifndef _LINUX_ETHTOOL_NETLINK_H_
+#define _LINUX_ETHTOOL_NETLINK_H_
+
+#include <linux/ethtool.h>
+
+/* message types - userspace to kernel */
+enum {
+	ETHTOOL_MSG_USER_NONE,
+	ETHTOOL_MSG_STRSET_GET,
+	ETHTOOL_MSG_LINKINFO_GET,
+	ETHTOOL_MSG_LINKINFO_SET,
+	ETHTOOL_MSG_LINKMODES_GET,
+	ETHTOOL_MSG_LINKMODES_SET,
+	ETHTOOL_MSG_LINKSTATE_GET,
+	ETHTOOL_MSG_DEBUG_GET,
+	ETHTOOL_MSG_DEBUG_SET,
+	ETHTOOL_MSG_WOL_GET,
+	ETHTOOL_MSG_WOL_SET,
+
+	/* add new constants above here */
+	__ETHTOOL_MSG_USER_CNT,
+	ETHTOOL_MSG_USER_MAX = __ETHTOOL_MSG_USER_CNT - 1
+};
+
+/* message types - kernel to userspace */
+enum {
+	ETHTOOL_MSG_KERNEL_NONE,
+	ETHTOOL_MSG_STRSET_GET_REPLY,
+	ETHTOOL_MSG_LINKINFO_GET_REPLY,
+	ETHTOOL_MSG_LINKINFO_NTF,
+	ETHTOOL_MSG_LINKMODES_GET_REPLY,
+	ETHTOOL_MSG_LINKMODES_NTF,
+	ETHTOOL_MSG_LINKSTATE_GET_REPLY,
+	ETHTOOL_MSG_DEBUG_GET_REPLY,
+	ETHTOOL_MSG_DEBUG_NTF,
+	ETHTOOL_MSG_WOL_GET_REPLY,
+	ETHTOOL_MSG_WOL_NTF,
+
+	/* add new constants above here */
+	__ETHTOOL_MSG_KERNEL_CNT,
+	ETHTOOL_MSG_KERNEL_MAX = __ETHTOOL_MSG_KERNEL_CNT - 1
+};
+
+/* request header */
+
+/* use compact bitsets in reply */
+#define ETHTOOL_FLAG_COMPACT_BITSETS	(1 << 0)
+/* provide optional reply for SET or ACT requests */
+#define ETHTOOL_FLAG_OMIT_REPLY	(1 << 1)
+
+#define ETHTOOL_FLAG_ALL (ETHTOOL_FLAG_COMPACT_BITSETS | \
+			  ETHTOOL_FLAG_OMIT_REPLY)
+
+enum {
+	ETHTOOL_A_HEADER_UNSPEC,
+	ETHTOOL_A_HEADER_DEV_INDEX,		/* u32 */
+	ETHTOOL_A_HEADER_DEV_NAME,		/* string */
+	ETHTOOL_A_HEADER_FLAGS,			/* u32 - ETHTOOL_FLAG_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_HEADER_CNT,
+	ETHTOOL_A_HEADER_MAX = __ETHTOOL_A_HEADER_CNT - 1
+};
+
+/* bit sets */
+
+enum {
+	ETHTOOL_A_BITSET_BIT_UNSPEC,
+	ETHTOOL_A_BITSET_BIT_INDEX,		/* u32 */
+	ETHTOOL_A_BITSET_BIT_NAME,		/* string */
+	ETHTOOL_A_BITSET_BIT_VALUE,		/* flag */
+
+	/* add new constants above here */
+	__ETHTOOL_A_BITSET_BIT_CNT,
+	ETHTOOL_A_BITSET_BIT_MAX = __ETHTOOL_A_BITSET_BIT_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_BITSET_BITS_UNSPEC,
+	ETHTOOL_A_BITSET_BITS_BIT,		/* nest - _A_BITSET_BIT_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_BITSET_BITS_CNT,
+	ETHTOOL_A_BITSET_BITS_MAX = __ETHTOOL_A_BITSET_BITS_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_BITSET_UNSPEC,
+	ETHTOOL_A_BITSET_NOMASK,		/* flag */
+	ETHTOOL_A_BITSET_SIZE,			/* u32 */
+	ETHTOOL_A_BITSET_BITS,			/* nest - _A_BITSET_BITS_* */
+	ETHTOOL_A_BITSET_VALUE,			/* binary */
+	ETHTOOL_A_BITSET_MASK,			/* binary */
+
+	/* add new constants above here */
+	__ETHTOOL_A_BITSET_CNT,
+	ETHTOOL_A_BITSET_MAX = __ETHTOOL_A_BITSET_CNT - 1
+};
+
+/* string sets */
+
+enum {
+	ETHTOOL_A_STRING_UNSPEC,
+	ETHTOOL_A_STRING_INDEX,			/* u32 */
+	ETHTOOL_A_STRING_VALUE,			/* string */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STRING_CNT,
+	ETHTOOL_A_STRING_MAX = __ETHTOOL_A_STRING_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_STRINGS_UNSPEC,
+	ETHTOOL_A_STRINGS_STRING,		/* nest - _A_STRINGS_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STRINGS_CNT,
+	ETHTOOL_A_STRINGS_MAX = __ETHTOOL_A_STRINGS_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_STRINGSET_UNSPEC,
+	ETHTOOL_A_STRINGSET_ID,			/* u32 */
+	ETHTOOL_A_STRINGSET_COUNT,		/* u32 */
+	ETHTOOL_A_STRINGSET_STRINGS,		/* nest - _A_STRINGS_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STRINGSET_CNT,
+	ETHTOOL_A_STRINGSET_MAX = __ETHTOOL_A_STRINGSET_CNT - 1
+};
+
+enum {
+	ETHTOOL_A_STRINGSETS_UNSPEC,
+	ETHTOOL_A_STRINGSETS_STRINGSET,		/* nest - _A_STRINGSET_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STRINGSETS_CNT,
+	ETHTOOL_A_STRINGSETS_MAX = __ETHTOOL_A_STRINGSETS_CNT - 1
+};
+
+/* STRSET */
+
+enum {
+	ETHTOOL_A_STRSET_UNSPEC,
+	ETHTOOL_A_STRSET_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_STRSET_STRINGSETS,		/* nest - _A_STRINGSETS_* */
+	ETHTOOL_A_STRSET_COUNTS_ONLY,		/* flag */
+
+	/* add new constants above here */
+	__ETHTOOL_A_STRSET_CNT,
+	ETHTOOL_A_STRSET_MAX = __ETHTOOL_A_STRSET_CNT - 1
+};
+
+/* LINKINFO */
+
+enum {
+	ETHTOOL_A_LINKINFO_UNSPEC,
+	ETHTOOL_A_LINKINFO_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_LINKINFO_PORT,		/* u8 */
+	ETHTOOL_A_LINKINFO_PHYADDR,		/* u8 */
+	ETHTOOL_A_LINKINFO_TP_MDIX,		/* u8 */
+	ETHTOOL_A_LINKINFO_TP_MDIX_CTRL,	/* u8 */
+	ETHTOOL_A_LINKINFO_TRANSCEIVER,		/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_LINKINFO_CNT,
+	ETHTOOL_A_LINKINFO_MAX = __ETHTOOL_A_LINKINFO_CNT - 1
+};
+
+/* LINKMODES */
+
+enum {
+	ETHTOOL_A_LINKMODES_UNSPEC,
+	ETHTOOL_A_LINKMODES_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_LINKMODES_AUTONEG,		/* u8 */
+	ETHTOOL_A_LINKMODES_OURS,		/* bitset */
+	ETHTOOL_A_LINKMODES_PEER,		/* bitset */
+	ETHTOOL_A_LINKMODES_SPEED,		/* u32 */
+	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_LINKMODES_CNT,
+	ETHTOOL_A_LINKMODES_MAX = __ETHTOOL_A_LINKMODES_CNT - 1
+};
+
+/* LINKSTATE */
+
+enum {
+	ETHTOOL_A_LINKSTATE_UNSPEC,
+	ETHTOOL_A_LINKSTATE_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_LINKSTATE_LINK,		/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_LINKSTATE_CNT,
+	ETHTOOL_A_LINKSTATE_MAX = __ETHTOOL_A_LINKSTATE_CNT - 1
+};
+
+/* DEBUG */
+
+enum {
+	ETHTOOL_A_DEBUG_UNSPEC,
+	ETHTOOL_A_DEBUG_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_DEBUG_MSGMASK,		/* bitset */
+
+	/* add new constants above here */
+	__ETHTOOL_A_DEBUG_CNT,
+	ETHTOOL_A_DEBUG_MAX = __ETHTOOL_A_DEBUG_CNT - 1
+};
+
+/* WOL */
+
+enum {
+	ETHTOOL_A_WOL_UNSPEC,
+	ETHTOOL_A_WOL_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_WOL_MODES,			/* bitset */
+	ETHTOOL_A_WOL_SOPASS,			/* binary */
+
+	/* add new constants above here */
+	__ETHTOOL_A_WOL_CNT,
+	ETHTOOL_A_WOL_MAX = __ETHTOOL_A_WOL_CNT - 1
+};
+
+/* generic netlink info */
+#define ETHTOOL_GENL_NAME "ethtool"
+#define ETHTOOL_GENL_VERSION 1
+
+#define ETHTOOL_MCGRP_MONITOR_NAME "monitor"
+
+#endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/uapi/linux/genetlink.h b/uapi/linux/genetlink.h
new file mode 100644
index 000000000000..1317119cbff8
--- /dev/null
+++ b/uapi/linux/genetlink.h
@@ -0,0 +1,89 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __LINUX_GENERIC_NETLINK_H
+#define __LINUX_GENERIC_NETLINK_H
+
+#include <linux/types.h>
+#include <linux/netlink.h>
+
+#define GENL_NAMSIZ	16	/* length of family name */
+
+#define GENL_MIN_ID	NLMSG_MIN_TYPE
+#define GENL_MAX_ID	1023
+
+struct genlmsghdr {
+	__u8	cmd;
+	__u8	version;
+	__u16	reserved;
+};
+
+#define GENL_HDRLEN	NLMSG_ALIGN(sizeof(struct genlmsghdr))
+
+#define GENL_ADMIN_PERM		0x01
+#define GENL_CMD_CAP_DO		0x02
+#define GENL_CMD_CAP_DUMP	0x04
+#define GENL_CMD_CAP_HASPOL	0x08
+#define GENL_UNS_ADMIN_PERM	0x10
+
+/*
+ * List of reserved static generic netlink identifiers:
+ */
+#define GENL_ID_CTRL		NLMSG_MIN_TYPE
+#define GENL_ID_VFS_DQUOT	(NLMSG_MIN_TYPE + 1)
+#define GENL_ID_PMCRAID		(NLMSG_MIN_TYPE + 2)
+/* must be last reserved + 1 */
+#define GENL_START_ALLOC	(NLMSG_MIN_TYPE + 3)
+
+/**************************************************************************
+ * Controller
+ **************************************************************************/
+
+enum {
+	CTRL_CMD_UNSPEC,
+	CTRL_CMD_NEWFAMILY,
+	CTRL_CMD_DELFAMILY,
+	CTRL_CMD_GETFAMILY,
+	CTRL_CMD_NEWOPS,
+	CTRL_CMD_DELOPS,
+	CTRL_CMD_GETOPS,
+	CTRL_CMD_NEWMCAST_GRP,
+	CTRL_CMD_DELMCAST_GRP,
+	CTRL_CMD_GETMCAST_GRP, /* unused */
+	__CTRL_CMD_MAX,
+};
+
+#define CTRL_CMD_MAX (__CTRL_CMD_MAX - 1)
+
+enum {
+	CTRL_ATTR_UNSPEC,
+	CTRL_ATTR_FAMILY_ID,
+	CTRL_ATTR_FAMILY_NAME,
+	CTRL_ATTR_VERSION,
+	CTRL_ATTR_HDRSIZE,
+	CTRL_ATTR_MAXATTR,
+	CTRL_ATTR_OPS,
+	CTRL_ATTR_MCAST_GROUPS,
+	__CTRL_ATTR_MAX,
+};
+
+#define CTRL_ATTR_MAX (__CTRL_ATTR_MAX - 1)
+
+enum {
+	CTRL_ATTR_OP_UNSPEC,
+	CTRL_ATTR_OP_ID,
+	CTRL_ATTR_OP_FLAGS,
+	__CTRL_ATTR_OP_MAX,
+};
+
+#define CTRL_ATTR_OP_MAX (__CTRL_ATTR_OP_MAX - 1)
+
+enum {
+	CTRL_ATTR_MCAST_GRP_UNSPEC,
+	CTRL_ATTR_MCAST_GRP_NAME,
+	CTRL_ATTR_MCAST_GRP_ID,
+	__CTRL_ATTR_MCAST_GRP_MAX,
+};
+
+#define CTRL_ATTR_MCAST_GRP_MAX (__CTRL_ATTR_MCAST_GRP_MAX - 1)
+
+
+#endif /* __LINUX_GENERIC_NETLINK_H */
diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
new file mode 100644
index 000000000000..cb88bcb47287
--- /dev/null
+++ b/uapi/linux/if_link.h
@@ -0,0 +1,1051 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_IF_LINK_H
+#define _LINUX_IF_LINK_H
+
+#include <linux/types.h>
+#include <linux/netlink.h>
+
+/* This struct should be in sync with struct rtnl_link_stats64 */
+struct rtnl_link_stats {
+	__u32	rx_packets;		/* total packets received	*/
+	__u32	tx_packets;		/* total packets transmitted	*/
+	__u32	rx_bytes;		/* total bytes received 	*/
+	__u32	tx_bytes;		/* total bytes transmitted	*/
+	__u32	rx_errors;		/* bad packets received		*/
+	__u32	tx_errors;		/* packet transmit problems	*/
+	__u32	rx_dropped;		/* no space in linux buffers	*/
+	__u32	tx_dropped;		/* no space available in linux	*/
+	__u32	multicast;		/* multicast packets received	*/
+	__u32	collisions;
+
+	/* detailed rx_errors: */
+	__u32	rx_length_errors;
+	__u32	rx_over_errors;		/* receiver ring buff overflow	*/
+	__u32	rx_crc_errors;		/* recved pkt with crc error	*/
+	__u32	rx_frame_errors;	/* recv'd frame alignment error */
+	__u32	rx_fifo_errors;		/* recv'r fifo overrun		*/
+	__u32	rx_missed_errors;	/* receiver missed packet	*/
+
+	/* detailed tx_errors */
+	__u32	tx_aborted_errors;
+	__u32	tx_carrier_errors;
+	__u32	tx_fifo_errors;
+	__u32	tx_heartbeat_errors;
+	__u32	tx_window_errors;
+
+	/* for cslip etc */
+	__u32	rx_compressed;
+	__u32	tx_compressed;
+
+	__u32	rx_nohandler;		/* dropped, no handler found	*/
+};
+
+/* The main device statistics structure */
+struct rtnl_link_stats64 {
+	__u64	rx_packets;		/* total packets received	*/
+	__u64	tx_packets;		/* total packets transmitted	*/
+	__u64	rx_bytes;		/* total bytes received 	*/
+	__u64	tx_bytes;		/* total bytes transmitted	*/
+	__u64	rx_errors;		/* bad packets received		*/
+	__u64	tx_errors;		/* packet transmit problems	*/
+	__u64	rx_dropped;		/* no space in linux buffers	*/
+	__u64	tx_dropped;		/* no space available in linux	*/
+	__u64	multicast;		/* multicast packets received	*/
+	__u64	collisions;
+
+	/* detailed rx_errors: */
+	__u64	rx_length_errors;
+	__u64	rx_over_errors;		/* receiver ring buff overflow	*/
+	__u64	rx_crc_errors;		/* recved pkt with crc error	*/
+	__u64	rx_frame_errors;	/* recv'd frame alignment error */
+	__u64	rx_fifo_errors;		/* recv'r fifo overrun		*/
+	__u64	rx_missed_errors;	/* receiver missed packet	*/
+
+	/* detailed tx_errors */
+	__u64	tx_aborted_errors;
+	__u64	tx_carrier_errors;
+	__u64	tx_fifo_errors;
+	__u64	tx_heartbeat_errors;
+	__u64	tx_window_errors;
+
+	/* for cslip etc */
+	__u64	rx_compressed;
+	__u64	tx_compressed;
+
+	__u64	rx_nohandler;		/* dropped, no handler found	*/
+};
+
+/* The struct should be in sync with struct ifmap */
+struct rtnl_link_ifmap {
+	__u64	mem_start;
+	__u64	mem_end;
+	__u64	base_addr;
+	__u16	irq;
+	__u8	dma;
+	__u8	port;
+};
+
+/*
+ * IFLA_AF_SPEC
+ *   Contains nested attributes for address family specific attributes.
+ *   Each address family may create a attribute with the address family
+ *   number as type and create its own attribute structure in it.
+ *
+ *   Example:
+ *   [IFLA_AF_SPEC] = {
+ *       [AF_INET] = {
+ *           [IFLA_INET_CONF] = ...,
+ *       },
+ *       [AF_INET6] = {
+ *           [IFLA_INET6_FLAGS] = ...,
+ *           [IFLA_INET6_CONF] = ...,
+ *       }
+ *   }
+ */
+
+enum {
+	IFLA_UNSPEC,
+	IFLA_ADDRESS,
+	IFLA_BROADCAST,
+	IFLA_IFNAME,
+	IFLA_MTU,
+	IFLA_LINK,
+	IFLA_QDISC,
+	IFLA_STATS,
+	IFLA_COST,
+#define IFLA_COST IFLA_COST
+	IFLA_PRIORITY,
+#define IFLA_PRIORITY IFLA_PRIORITY
+	IFLA_MASTER,
+#define IFLA_MASTER IFLA_MASTER
+	IFLA_WIRELESS,		/* Wireless Extension event - see wireless.h */
+#define IFLA_WIRELESS IFLA_WIRELESS
+	IFLA_PROTINFO,		/* Protocol specific information for a link */
+#define IFLA_PROTINFO IFLA_PROTINFO
+	IFLA_TXQLEN,
+#define IFLA_TXQLEN IFLA_TXQLEN
+	IFLA_MAP,
+#define IFLA_MAP IFLA_MAP
+	IFLA_WEIGHT,
+#define IFLA_WEIGHT IFLA_WEIGHT
+	IFLA_OPERSTATE,
+	IFLA_LINKMODE,
+	IFLA_LINKINFO,
+#define IFLA_LINKINFO IFLA_LINKINFO
+	IFLA_NET_NS_PID,
+	IFLA_IFALIAS,
+	IFLA_NUM_VF,		/* Number of VFs if device is SR-IOV PF */
+	IFLA_VFINFO_LIST,
+	IFLA_STATS64,
+	IFLA_VF_PORTS,
+	IFLA_PORT_SELF,
+	IFLA_AF_SPEC,
+	IFLA_GROUP,		/* Group the device belongs to */
+	IFLA_NET_NS_FD,
+	IFLA_EXT_MASK,		/* Extended info mask, VFs, etc */
+	IFLA_PROMISCUITY,	/* Promiscuity count: > 0 means acts PROMISC */
+#define IFLA_PROMISCUITY IFLA_PROMISCUITY
+	IFLA_NUM_TX_QUEUES,
+	IFLA_NUM_RX_QUEUES,
+	IFLA_CARRIER,
+	IFLA_PHYS_PORT_ID,
+	IFLA_CARRIER_CHANGES,
+	IFLA_PHYS_SWITCH_ID,
+	IFLA_LINK_NETNSID,
+	IFLA_PHYS_PORT_NAME,
+	IFLA_PROTO_DOWN,
+	IFLA_GSO_MAX_SEGS,
+	IFLA_GSO_MAX_SIZE,
+	IFLA_PAD,
+	IFLA_XDP,
+	IFLA_EVENT,
+	IFLA_NEW_NETNSID,
+	IFLA_IF_NETNSID,
+	IFLA_TARGET_NETNSID = IFLA_IF_NETNSID, /* new alias */
+	IFLA_CARRIER_UP_COUNT,
+	IFLA_CARRIER_DOWN_COUNT,
+	IFLA_NEW_IFINDEX,
+	IFLA_MIN_MTU,
+	IFLA_MAX_MTU,
+	IFLA_PROP_LIST,
+	IFLA_ALT_IFNAME, /* Alternative ifname */
+	IFLA_PERM_ADDRESS,
+	__IFLA_MAX
+};
+
+
+#define IFLA_MAX (__IFLA_MAX - 1)
+
+/* backwards compatibility for userspace */
+#define IFLA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ifinfomsg))))
+#define IFLA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifinfomsg))
+
+enum {
+	IFLA_INET_UNSPEC,
+	IFLA_INET_CONF,
+	__IFLA_INET_MAX,
+};
+
+#define IFLA_INET_MAX (__IFLA_INET_MAX - 1)
+
+/* ifi_flags.
+
+   IFF_* flags.
+
+   The only change is:
+   IFF_LOOPBACK, IFF_BROADCAST and IFF_POINTOPOINT are
+   more not changeable by user. They describe link media
+   characteristics and set by device driver.
+
+   Comments:
+   - Combination IFF_BROADCAST|IFF_POINTOPOINT is invalid
+   - If neither of these three flags are set;
+     the interface is NBMA.
+
+   - IFF_MULTICAST does not mean anything special:
+   multicasts can be used on all not-NBMA links.
+   IFF_MULTICAST means that this media uses special encapsulation
+   for multicast frames. Apparently, all IFF_POINTOPOINT and
+   IFF_BROADCAST devices are able to use multicasts too.
+ */
+
+/* IFLA_LINK.
+   For usual devices it is equal ifi_index.
+   If it is a "virtual interface" (f.e. tunnel), ifi_link
+   can point to real physical interface (f.e. for bandwidth calculations),
+   or maybe 0, what means, that real media is unknown (usual
+   for IPIP tunnels, when route to endpoint is allowed to change)
+ */
+
+/* Subtype attributes for IFLA_PROTINFO */
+enum {
+	IFLA_INET6_UNSPEC,
+	IFLA_INET6_FLAGS,	/* link flags			*/
+	IFLA_INET6_CONF,	/* sysctl parameters		*/
+	IFLA_INET6_STATS,	/* statistics			*/
+	IFLA_INET6_MCAST,	/* MC things. What of them?	*/
+	IFLA_INET6_CACHEINFO,	/* time values and max reasm size */
+	IFLA_INET6_ICMP6STATS,	/* statistics (icmpv6)		*/
+	IFLA_INET6_TOKEN,	/* device token			*/
+	IFLA_INET6_ADDR_GEN_MODE, /* implicit address generator mode */
+	__IFLA_INET6_MAX
+};
+
+#define IFLA_INET6_MAX	(__IFLA_INET6_MAX - 1)
+
+enum in6_addr_gen_mode {
+	IN6_ADDR_GEN_MODE_EUI64,
+	IN6_ADDR_GEN_MODE_NONE,
+	IN6_ADDR_GEN_MODE_STABLE_PRIVACY,
+	IN6_ADDR_GEN_MODE_RANDOM,
+};
+
+/* Bridge section */
+
+enum {
+	IFLA_BR_UNSPEC,
+	IFLA_BR_FORWARD_DELAY,
+	IFLA_BR_HELLO_TIME,
+	IFLA_BR_MAX_AGE,
+	IFLA_BR_AGEING_TIME,
+	IFLA_BR_STP_STATE,
+	IFLA_BR_PRIORITY,
+	IFLA_BR_VLAN_FILTERING,
+	IFLA_BR_VLAN_PROTOCOL,
+	IFLA_BR_GROUP_FWD_MASK,
+	IFLA_BR_ROOT_ID,
+	IFLA_BR_BRIDGE_ID,
+	IFLA_BR_ROOT_PORT,
+	IFLA_BR_ROOT_PATH_COST,
+	IFLA_BR_TOPOLOGY_CHANGE,
+	IFLA_BR_TOPOLOGY_CHANGE_DETECTED,
+	IFLA_BR_HELLO_TIMER,
+	IFLA_BR_TCN_TIMER,
+	IFLA_BR_TOPOLOGY_CHANGE_TIMER,
+	IFLA_BR_GC_TIMER,
+	IFLA_BR_GROUP_ADDR,
+	IFLA_BR_FDB_FLUSH,
+	IFLA_BR_MCAST_ROUTER,
+	IFLA_BR_MCAST_SNOOPING,
+	IFLA_BR_MCAST_QUERY_USE_IFADDR,
+	IFLA_BR_MCAST_QUERIER,
+	IFLA_BR_MCAST_HASH_ELASTICITY,
+	IFLA_BR_MCAST_HASH_MAX,
+	IFLA_BR_MCAST_LAST_MEMBER_CNT,
+	IFLA_BR_MCAST_STARTUP_QUERY_CNT,
+	IFLA_BR_MCAST_LAST_MEMBER_INTVL,
+	IFLA_BR_MCAST_MEMBERSHIP_INTVL,
+	IFLA_BR_MCAST_QUERIER_INTVL,
+	IFLA_BR_MCAST_QUERY_INTVL,
+	IFLA_BR_MCAST_QUERY_RESPONSE_INTVL,
+	IFLA_BR_MCAST_STARTUP_QUERY_INTVL,
+	IFLA_BR_NF_CALL_IPTABLES,
+	IFLA_BR_NF_CALL_IP6TABLES,
+	IFLA_BR_NF_CALL_ARPTABLES,
+	IFLA_BR_VLAN_DEFAULT_PVID,
+	IFLA_BR_PAD,
+	IFLA_BR_VLAN_STATS_ENABLED,
+	IFLA_BR_MCAST_STATS_ENABLED,
+	IFLA_BR_MCAST_IGMP_VERSION,
+	IFLA_BR_MCAST_MLD_VERSION,
+	IFLA_BR_VLAN_STATS_PER_PORT,
+	IFLA_BR_MULTI_BOOLOPT,
+	__IFLA_BR_MAX,
+};
+
+#define IFLA_BR_MAX	(__IFLA_BR_MAX - 1)
+
+struct ifla_bridge_id {
+	__u8	prio[2];
+	__u8	addr[6]; /* ETH_ALEN */
+};
+
+enum {
+	BRIDGE_MODE_UNSPEC,
+	BRIDGE_MODE_HAIRPIN,
+};
+
+enum {
+	IFLA_BRPORT_UNSPEC,
+	IFLA_BRPORT_STATE,	/* Spanning tree state     */
+	IFLA_BRPORT_PRIORITY,	/* "             priority  */
+	IFLA_BRPORT_COST,	/* "             cost      */
+	IFLA_BRPORT_MODE,	/* mode (hairpin)          */
+	IFLA_BRPORT_GUARD,	/* bpdu guard              */
+	IFLA_BRPORT_PROTECT,	/* root port protection    */
+	IFLA_BRPORT_FAST_LEAVE,	/* multicast fast leave    */
+	IFLA_BRPORT_LEARNING,	/* mac learning */
+	IFLA_BRPORT_UNICAST_FLOOD, /* flood unicast traffic */
+	IFLA_BRPORT_PROXYARP,	/* proxy ARP */
+	IFLA_BRPORT_LEARNING_SYNC, /* mac learning sync from device */
+	IFLA_BRPORT_PROXYARP_WIFI, /* proxy ARP for Wi-Fi */
+	IFLA_BRPORT_ROOT_ID,	/* designated root */
+	IFLA_BRPORT_BRIDGE_ID,	/* designated bridge */
+	IFLA_BRPORT_DESIGNATED_PORT,
+	IFLA_BRPORT_DESIGNATED_COST,
+	IFLA_BRPORT_ID,
+	IFLA_BRPORT_NO,
+	IFLA_BRPORT_TOPOLOGY_CHANGE_ACK,
+	IFLA_BRPORT_CONFIG_PENDING,
+	IFLA_BRPORT_MESSAGE_AGE_TIMER,
+	IFLA_BRPORT_FORWARD_DELAY_TIMER,
+	IFLA_BRPORT_HOLD_TIMER,
+	IFLA_BRPORT_FLUSH,
+	IFLA_BRPORT_MULTICAST_ROUTER,
+	IFLA_BRPORT_PAD,
+	IFLA_BRPORT_MCAST_FLOOD,
+	IFLA_BRPORT_MCAST_TO_UCAST,
+	IFLA_BRPORT_VLAN_TUNNEL,
+	IFLA_BRPORT_BCAST_FLOOD,
+	IFLA_BRPORT_GROUP_FWD_MASK,
+	IFLA_BRPORT_NEIGH_SUPPRESS,
+	IFLA_BRPORT_ISOLATED,
+	IFLA_BRPORT_BACKUP_PORT,
+	__IFLA_BRPORT_MAX
+};
+#define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
+
+struct ifla_cacheinfo {
+	__u32	max_reasm_len;
+	__u32	tstamp;		/* ipv6InterfaceTable updated timestamp */
+	__u32	reachable_time;
+	__u32	retrans_time;
+};
+
+enum {
+	IFLA_INFO_UNSPEC,
+	IFLA_INFO_KIND,
+	IFLA_INFO_DATA,
+	IFLA_INFO_XSTATS,
+	IFLA_INFO_SLAVE_KIND,
+	IFLA_INFO_SLAVE_DATA,
+	__IFLA_INFO_MAX,
+};
+
+#define IFLA_INFO_MAX	(__IFLA_INFO_MAX - 1)
+
+/* VLAN section */
+
+enum {
+	IFLA_VLAN_UNSPEC,
+	IFLA_VLAN_ID,
+	IFLA_VLAN_FLAGS,
+	IFLA_VLAN_EGRESS_QOS,
+	IFLA_VLAN_INGRESS_QOS,
+	IFLA_VLAN_PROTOCOL,
+	__IFLA_VLAN_MAX,
+};
+
+#define IFLA_VLAN_MAX	(__IFLA_VLAN_MAX - 1)
+
+struct ifla_vlan_flags {
+	__u32	flags;
+	__u32	mask;
+};
+
+enum {
+	IFLA_VLAN_QOS_UNSPEC,
+	IFLA_VLAN_QOS_MAPPING,
+	__IFLA_VLAN_QOS_MAX
+};
+
+#define IFLA_VLAN_QOS_MAX	(__IFLA_VLAN_QOS_MAX - 1)
+
+struct ifla_vlan_qos_mapping {
+	__u32 from;
+	__u32 to;
+};
+
+/* MACVLAN section */
+enum {
+	IFLA_MACVLAN_UNSPEC,
+	IFLA_MACVLAN_MODE,
+	IFLA_MACVLAN_FLAGS,
+	IFLA_MACVLAN_MACADDR_MODE,
+	IFLA_MACVLAN_MACADDR,
+	IFLA_MACVLAN_MACADDR_DATA,
+	IFLA_MACVLAN_MACADDR_COUNT,
+	__IFLA_MACVLAN_MAX,
+};
+
+#define IFLA_MACVLAN_MAX (__IFLA_MACVLAN_MAX - 1)
+
+enum macvlan_mode {
+	MACVLAN_MODE_PRIVATE = 1, /* don't talk to other macvlans */
+	MACVLAN_MODE_VEPA    = 2, /* talk to other ports through ext bridge */
+	MACVLAN_MODE_BRIDGE  = 4, /* talk to bridge ports directly */
+	MACVLAN_MODE_PASSTHRU = 8,/* take over the underlying device */
+	MACVLAN_MODE_SOURCE  = 16,/* use source MAC address list to assign */
+};
+
+enum macvlan_macaddr_mode {
+	MACVLAN_MACADDR_ADD,
+	MACVLAN_MACADDR_DEL,
+	MACVLAN_MACADDR_FLUSH,
+	MACVLAN_MACADDR_SET,
+};
+
+#define MACVLAN_FLAG_NOPROMISC	1
+
+/* VRF section */
+enum {
+	IFLA_VRF_UNSPEC,
+	IFLA_VRF_TABLE,
+	__IFLA_VRF_MAX
+};
+
+#define IFLA_VRF_MAX (__IFLA_VRF_MAX - 1)
+
+enum {
+	IFLA_VRF_PORT_UNSPEC,
+	IFLA_VRF_PORT_TABLE,
+	__IFLA_VRF_PORT_MAX
+};
+
+#define IFLA_VRF_PORT_MAX (__IFLA_VRF_PORT_MAX - 1)
+
+/* MACSEC section */
+enum {
+	IFLA_MACSEC_UNSPEC,
+	IFLA_MACSEC_SCI,
+	IFLA_MACSEC_PORT,
+	IFLA_MACSEC_ICV_LEN,
+	IFLA_MACSEC_CIPHER_SUITE,
+	IFLA_MACSEC_WINDOW,
+	IFLA_MACSEC_ENCODING_SA,
+	IFLA_MACSEC_ENCRYPT,
+	IFLA_MACSEC_PROTECT,
+	IFLA_MACSEC_INC_SCI,
+	IFLA_MACSEC_ES,
+	IFLA_MACSEC_SCB,
+	IFLA_MACSEC_REPLAY_PROTECT,
+	IFLA_MACSEC_VALIDATION,
+	IFLA_MACSEC_PAD,
+	__IFLA_MACSEC_MAX,
+};
+
+#define IFLA_MACSEC_MAX (__IFLA_MACSEC_MAX - 1)
+
+/* XFRM section */
+enum {
+	IFLA_XFRM_UNSPEC,
+	IFLA_XFRM_LINK,
+	IFLA_XFRM_IF_ID,
+	__IFLA_XFRM_MAX
+};
+
+#define IFLA_XFRM_MAX (__IFLA_XFRM_MAX - 1)
+
+enum macsec_validation_type {
+	MACSEC_VALIDATE_DISABLED = 0,
+	MACSEC_VALIDATE_CHECK = 1,
+	MACSEC_VALIDATE_STRICT = 2,
+	__MACSEC_VALIDATE_END,
+	MACSEC_VALIDATE_MAX = __MACSEC_VALIDATE_END - 1,
+};
+
+enum macsec_offload {
+	MACSEC_OFFLOAD_OFF = 0,
+	MACSEC_OFFLOAD_PHY = 1,
+	__MACSEC_OFFLOAD_END,
+	MACSEC_OFFLOAD_MAX = __MACSEC_OFFLOAD_END - 1,
+};
+
+/* IPVLAN section */
+enum {
+	IFLA_IPVLAN_UNSPEC,
+	IFLA_IPVLAN_MODE,
+	IFLA_IPVLAN_FLAGS,
+	__IFLA_IPVLAN_MAX
+};
+
+#define IFLA_IPVLAN_MAX (__IFLA_IPVLAN_MAX - 1)
+
+enum ipvlan_mode {
+	IPVLAN_MODE_L2 = 0,
+	IPVLAN_MODE_L3,
+	IPVLAN_MODE_L3S,
+	IPVLAN_MODE_MAX
+};
+
+#define IPVLAN_F_PRIVATE	0x01
+#define IPVLAN_F_VEPA		0x02
+
+/* VXLAN section */
+enum {
+	IFLA_VXLAN_UNSPEC,
+	IFLA_VXLAN_ID,
+	IFLA_VXLAN_GROUP,	/* group or remote address */
+	IFLA_VXLAN_LINK,
+	IFLA_VXLAN_LOCAL,
+	IFLA_VXLAN_TTL,
+	IFLA_VXLAN_TOS,
+	IFLA_VXLAN_LEARNING,
+	IFLA_VXLAN_AGEING,
+	IFLA_VXLAN_LIMIT,
+	IFLA_VXLAN_PORT_RANGE,	/* source port */
+	IFLA_VXLAN_PROXY,
+	IFLA_VXLAN_RSC,
+	IFLA_VXLAN_L2MISS,
+	IFLA_VXLAN_L3MISS,
+	IFLA_VXLAN_PORT,	/* destination port */
+	IFLA_VXLAN_GROUP6,
+	IFLA_VXLAN_LOCAL6,
+	IFLA_VXLAN_UDP_CSUM,
+	IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
+	IFLA_VXLAN_UDP_ZERO_CSUM6_RX,
+	IFLA_VXLAN_REMCSUM_TX,
+	IFLA_VXLAN_REMCSUM_RX,
+	IFLA_VXLAN_GBP,
+	IFLA_VXLAN_REMCSUM_NOPARTIAL,
+	IFLA_VXLAN_COLLECT_METADATA,
+	IFLA_VXLAN_LABEL,
+	IFLA_VXLAN_GPE,
+	IFLA_VXLAN_TTL_INHERIT,
+	IFLA_VXLAN_DF,
+	__IFLA_VXLAN_MAX
+};
+#define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
+
+struct ifla_vxlan_port_range {
+	__be16	low;
+	__be16	high;
+};
+
+enum ifla_vxlan_df {
+	VXLAN_DF_UNSET = 0,
+	VXLAN_DF_SET,
+	VXLAN_DF_INHERIT,
+	__VXLAN_DF_END,
+	VXLAN_DF_MAX = __VXLAN_DF_END - 1,
+};
+
+/* GENEVE section */
+enum {
+	IFLA_GENEVE_UNSPEC,
+	IFLA_GENEVE_ID,
+	IFLA_GENEVE_REMOTE,
+	IFLA_GENEVE_TTL,
+	IFLA_GENEVE_TOS,
+	IFLA_GENEVE_PORT,	/* destination port */
+	IFLA_GENEVE_COLLECT_METADATA,
+	IFLA_GENEVE_REMOTE6,
+	IFLA_GENEVE_UDP_CSUM,
+	IFLA_GENEVE_UDP_ZERO_CSUM6_TX,
+	IFLA_GENEVE_UDP_ZERO_CSUM6_RX,
+	IFLA_GENEVE_LABEL,
+	IFLA_GENEVE_TTL_INHERIT,
+	IFLA_GENEVE_DF,
+	__IFLA_GENEVE_MAX
+};
+#define IFLA_GENEVE_MAX	(__IFLA_GENEVE_MAX - 1)
+
+enum ifla_geneve_df {
+	GENEVE_DF_UNSET = 0,
+	GENEVE_DF_SET,
+	GENEVE_DF_INHERIT,
+	__GENEVE_DF_END,
+	GENEVE_DF_MAX = __GENEVE_DF_END - 1,
+};
+
+/* Bareudp section  */
+enum {
+	IFLA_BAREUDP_UNSPEC,
+	IFLA_BAREUDP_PORT,
+	IFLA_BAREUDP_ETHERTYPE,
+	IFLA_BAREUDP_SRCPORT_MIN,
+	IFLA_BAREUDP_MULTIPROTO_MODE,
+	__IFLA_BAREUDP_MAX
+};
+
+#define IFLA_BAREUDP_MAX (__IFLA_BAREUDP_MAX - 1)
+
+/* PPP section */
+enum {
+	IFLA_PPP_UNSPEC,
+	IFLA_PPP_DEV_FD,
+	__IFLA_PPP_MAX
+};
+#define IFLA_PPP_MAX (__IFLA_PPP_MAX - 1)
+
+/* GTP section */
+
+enum ifla_gtp_role {
+	GTP_ROLE_GGSN = 0,
+	GTP_ROLE_SGSN,
+};
+
+enum {
+	IFLA_GTP_UNSPEC,
+	IFLA_GTP_FD0,
+	IFLA_GTP_FD1,
+	IFLA_GTP_PDP_HASHSIZE,
+	IFLA_GTP_ROLE,
+	__IFLA_GTP_MAX,
+};
+#define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
+
+/* Bonding section */
+
+enum {
+	IFLA_BOND_UNSPEC,
+	IFLA_BOND_MODE,
+	IFLA_BOND_ACTIVE_SLAVE,
+	IFLA_BOND_MIIMON,
+	IFLA_BOND_UPDELAY,
+	IFLA_BOND_DOWNDELAY,
+	IFLA_BOND_USE_CARRIER,
+	IFLA_BOND_ARP_INTERVAL,
+	IFLA_BOND_ARP_IP_TARGET,
+	IFLA_BOND_ARP_VALIDATE,
+	IFLA_BOND_ARP_ALL_TARGETS,
+	IFLA_BOND_PRIMARY,
+	IFLA_BOND_PRIMARY_RESELECT,
+	IFLA_BOND_FAIL_OVER_MAC,
+	IFLA_BOND_XMIT_HASH_POLICY,
+	IFLA_BOND_RESEND_IGMP,
+	IFLA_BOND_NUM_PEER_NOTIF,
+	IFLA_BOND_ALL_SLAVES_ACTIVE,
+	IFLA_BOND_MIN_LINKS,
+	IFLA_BOND_LP_INTERVAL,
+	IFLA_BOND_PACKETS_PER_SLAVE,
+	IFLA_BOND_AD_LACP_RATE,
+	IFLA_BOND_AD_SELECT,
+	IFLA_BOND_AD_INFO,
+	IFLA_BOND_AD_ACTOR_SYS_PRIO,
+	IFLA_BOND_AD_USER_PORT_KEY,
+	IFLA_BOND_AD_ACTOR_SYSTEM,
+	IFLA_BOND_TLB_DYNAMIC_LB,
+	IFLA_BOND_PEER_NOTIF_DELAY,
+	__IFLA_BOND_MAX,
+};
+
+#define IFLA_BOND_MAX	(__IFLA_BOND_MAX - 1)
+
+enum {
+	IFLA_BOND_AD_INFO_UNSPEC,
+	IFLA_BOND_AD_INFO_AGGREGATOR,
+	IFLA_BOND_AD_INFO_NUM_PORTS,
+	IFLA_BOND_AD_INFO_ACTOR_KEY,
+	IFLA_BOND_AD_INFO_PARTNER_KEY,
+	IFLA_BOND_AD_INFO_PARTNER_MAC,
+	__IFLA_BOND_AD_INFO_MAX,
+};
+
+#define IFLA_BOND_AD_INFO_MAX	(__IFLA_BOND_AD_INFO_MAX - 1)
+
+enum {
+	IFLA_BOND_SLAVE_UNSPEC,
+	IFLA_BOND_SLAVE_STATE,
+	IFLA_BOND_SLAVE_MII_STATUS,
+	IFLA_BOND_SLAVE_LINK_FAILURE_COUNT,
+	IFLA_BOND_SLAVE_PERM_HWADDR,
+	IFLA_BOND_SLAVE_QUEUE_ID,
+	IFLA_BOND_SLAVE_AD_AGGREGATOR_ID,
+	IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE,
+	IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE,
+	__IFLA_BOND_SLAVE_MAX,
+};
+
+#define IFLA_BOND_SLAVE_MAX	(__IFLA_BOND_SLAVE_MAX - 1)
+
+/* SR-IOV virtual function management section */
+
+enum {
+	IFLA_VF_INFO_UNSPEC,
+	IFLA_VF_INFO,
+	__IFLA_VF_INFO_MAX,
+};
+
+#define IFLA_VF_INFO_MAX (__IFLA_VF_INFO_MAX - 1)
+
+enum {
+	IFLA_VF_UNSPEC,
+	IFLA_VF_MAC,		/* Hardware queue specific attributes */
+	IFLA_VF_VLAN,		/* VLAN ID and QoS */
+	IFLA_VF_TX_RATE,	/* Max TX Bandwidth Allocation */
+	IFLA_VF_SPOOFCHK,	/* Spoof Checking on/off switch */
+	IFLA_VF_LINK_STATE,	/* link state enable/disable/auto switch */
+	IFLA_VF_RATE,		/* Min and Max TX Bandwidth Allocation */
+	IFLA_VF_RSS_QUERY_EN,	/* RSS Redirection Table and Hash Key query
+				 * on/off switch
+				 */
+	IFLA_VF_STATS,		/* network device statistics */
+	IFLA_VF_TRUST,		/* Trust VF */
+	IFLA_VF_IB_NODE_GUID,	/* VF Infiniband node GUID */
+	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
+	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for QinQ */
+	IFLA_VF_BROADCAST,	/* VF broadcast */
+	__IFLA_VF_MAX,
+};
+
+#define IFLA_VF_MAX (__IFLA_VF_MAX - 1)
+
+struct ifla_vf_mac {
+	__u32 vf;
+	__u8 mac[32]; /* MAX_ADDR_LEN */
+};
+
+struct ifla_vf_broadcast {
+	__u8 broadcast[32];
+};
+
+struct ifla_vf_vlan {
+	__u32 vf;
+	__u32 vlan; /* 0 - 4095, 0 disables VLAN filter */
+	__u32 qos;
+};
+
+enum {
+	IFLA_VF_VLAN_INFO_UNSPEC,
+	IFLA_VF_VLAN_INFO,	/* VLAN ID, QoS and VLAN protocol */
+	__IFLA_VF_VLAN_INFO_MAX,
+};
+
+#define IFLA_VF_VLAN_INFO_MAX (__IFLA_VF_VLAN_INFO_MAX - 1)
+#define MAX_VLAN_LIST_LEN 1
+
+struct ifla_vf_vlan_info {
+	__u32 vf;
+	__u32 vlan; /* 0 - 4095, 0 disables VLAN filter */
+	__u32 qos;
+	__be16 vlan_proto; /* VLAN protocol either 802.1Q or 802.1ad */
+};
+
+struct ifla_vf_tx_rate {
+	__u32 vf;
+	__u32 rate; /* Max TX bandwidth in Mbps, 0 disables throttling */
+};
+
+struct ifla_vf_rate {
+	__u32 vf;
+	__u32 min_tx_rate; /* Min Bandwidth in Mbps */
+	__u32 max_tx_rate; /* Max Bandwidth in Mbps */
+};
+
+struct ifla_vf_spoofchk {
+	__u32 vf;
+	__u32 setting;
+};
+
+struct ifla_vf_guid {
+	__u32 vf;
+	__u64 guid;
+};
+
+enum {
+	IFLA_VF_LINK_STATE_AUTO,	/* link state of the uplink */
+	IFLA_VF_LINK_STATE_ENABLE,	/* link always up */
+	IFLA_VF_LINK_STATE_DISABLE,	/* link always down */
+	__IFLA_VF_LINK_STATE_MAX,
+};
+
+struct ifla_vf_link_state {
+	__u32 vf;
+	__u32 link_state;
+};
+
+struct ifla_vf_rss_query_en {
+	__u32 vf;
+	__u32 setting;
+};
+
+enum {
+	IFLA_VF_STATS_RX_PACKETS,
+	IFLA_VF_STATS_TX_PACKETS,
+	IFLA_VF_STATS_RX_BYTES,
+	IFLA_VF_STATS_TX_BYTES,
+	IFLA_VF_STATS_BROADCAST,
+	IFLA_VF_STATS_MULTICAST,
+	IFLA_VF_STATS_PAD,
+	IFLA_VF_STATS_RX_DROPPED,
+	IFLA_VF_STATS_TX_DROPPED,
+	__IFLA_VF_STATS_MAX,
+};
+
+#define IFLA_VF_STATS_MAX (__IFLA_VF_STATS_MAX - 1)
+
+struct ifla_vf_trust {
+	__u32 vf;
+	__u32 setting;
+};
+
+/* VF ports management section
+ *
+ *	Nested layout of set/get msg is:
+ *
+ *		[IFLA_NUM_VF]
+ *		[IFLA_VF_PORTS]
+ *			[IFLA_VF_PORT]
+ *				[IFLA_PORT_*], ...
+ *			[IFLA_VF_PORT]
+ *				[IFLA_PORT_*], ...
+ *			...
+ *		[IFLA_PORT_SELF]
+ *			[IFLA_PORT_*], ...
+ */
+
+enum {
+	IFLA_VF_PORT_UNSPEC,
+	IFLA_VF_PORT,			/* nest */
+	__IFLA_VF_PORT_MAX,
+};
+
+#define IFLA_VF_PORT_MAX (__IFLA_VF_PORT_MAX - 1)
+
+enum {
+	IFLA_PORT_UNSPEC,
+	IFLA_PORT_VF,			/* __u32 */
+	IFLA_PORT_PROFILE,		/* string */
+	IFLA_PORT_VSI_TYPE,		/* 802.1Qbg (pre-)standard VDP */
+	IFLA_PORT_INSTANCE_UUID,	/* binary UUID */
+	IFLA_PORT_HOST_UUID,		/* binary UUID */
+	IFLA_PORT_REQUEST,		/* __u8 */
+	IFLA_PORT_RESPONSE,		/* __u16, output only */
+	__IFLA_PORT_MAX,
+};
+
+#define IFLA_PORT_MAX (__IFLA_PORT_MAX - 1)
+
+#define PORT_PROFILE_MAX	40
+#define PORT_UUID_MAX		16
+#define PORT_SELF_VF		-1
+
+enum {
+	PORT_REQUEST_PREASSOCIATE = 0,
+	PORT_REQUEST_PREASSOCIATE_RR,
+	PORT_REQUEST_ASSOCIATE,
+	PORT_REQUEST_DISASSOCIATE,
+};
+
+enum {
+	PORT_VDP_RESPONSE_SUCCESS = 0,
+	PORT_VDP_RESPONSE_INVALID_FORMAT,
+	PORT_VDP_RESPONSE_INSUFFICIENT_RESOURCES,
+	PORT_VDP_RESPONSE_UNUSED_VTID,
+	PORT_VDP_RESPONSE_VTID_VIOLATION,
+	PORT_VDP_RESPONSE_VTID_VERSION_VIOALTION,
+	PORT_VDP_RESPONSE_OUT_OF_SYNC,
+	/* 0x08-0xFF reserved for future VDP use */
+	PORT_PROFILE_RESPONSE_SUCCESS = 0x100,
+	PORT_PROFILE_RESPONSE_INPROGRESS,
+	PORT_PROFILE_RESPONSE_INVALID,
+	PORT_PROFILE_RESPONSE_BADSTATE,
+	PORT_PROFILE_RESPONSE_INSUFFICIENT_RESOURCES,
+	PORT_PROFILE_RESPONSE_ERROR,
+};
+
+struct ifla_port_vsi {
+	__u8 vsi_mgr_id;
+	__u8 vsi_type_id[3];
+	__u8 vsi_type_version;
+	__u8 pad[3];
+};
+
+
+/* IPoIB section */
+
+enum {
+	IFLA_IPOIB_UNSPEC,
+	IFLA_IPOIB_PKEY,
+	IFLA_IPOIB_MODE,
+	IFLA_IPOIB_UMCAST,
+	__IFLA_IPOIB_MAX
+};
+
+enum {
+	IPOIB_MODE_DATAGRAM  = 0, /* using unreliable datagram QPs */
+	IPOIB_MODE_CONNECTED = 1, /* using connected QPs */
+};
+
+#define IFLA_IPOIB_MAX (__IFLA_IPOIB_MAX - 1)
+
+
+/* HSR section */
+
+enum {
+	IFLA_HSR_UNSPEC,
+	IFLA_HSR_SLAVE1,
+	IFLA_HSR_SLAVE2,
+	IFLA_HSR_MULTICAST_SPEC,	/* Last byte of supervision addr */
+	IFLA_HSR_SUPERVISION_ADDR,	/* Supervision frame multicast addr */
+	IFLA_HSR_SEQ_NR,
+	IFLA_HSR_VERSION,		/* HSR version */
+	__IFLA_HSR_MAX,
+};
+
+#define IFLA_HSR_MAX (__IFLA_HSR_MAX - 1)
+
+/* STATS section */
+
+struct if_stats_msg {
+	__u8  family;
+	__u8  pad1;
+	__u16 pad2;
+	__u32 ifindex;
+	__u32 filter_mask;
+};
+
+/* A stats attribute can be netdev specific or a global stat.
+ * For netdev stats, lets use the prefix IFLA_STATS_LINK_*
+ */
+enum {
+	IFLA_STATS_UNSPEC, /* also used as 64bit pad attribute */
+	IFLA_STATS_LINK_64,
+	IFLA_STATS_LINK_XSTATS,
+	IFLA_STATS_LINK_XSTATS_SLAVE,
+	IFLA_STATS_LINK_OFFLOAD_XSTATS,
+	IFLA_STATS_AF_SPEC,
+	__IFLA_STATS_MAX,
+};
+
+#define IFLA_STATS_MAX (__IFLA_STATS_MAX - 1)
+
+#define IFLA_STATS_FILTER_BIT(ATTR)	(1 << (ATTR - 1))
+
+/* These are embedded into IFLA_STATS_LINK_XSTATS:
+ * [IFLA_STATS_LINK_XSTATS]
+ * -> [LINK_XSTATS_TYPE_xxx]
+ *    -> [rtnl link type specific attributes]
+ */
+enum {
+	LINK_XSTATS_TYPE_UNSPEC,
+	LINK_XSTATS_TYPE_BRIDGE,
+	LINK_XSTATS_TYPE_BOND,
+	__LINK_XSTATS_TYPE_MAX
+};
+#define LINK_XSTATS_TYPE_MAX (__LINK_XSTATS_TYPE_MAX - 1)
+
+/* These are stats embedded into IFLA_STATS_LINK_OFFLOAD_XSTATS */
+enum {
+	IFLA_OFFLOAD_XSTATS_UNSPEC,
+	IFLA_OFFLOAD_XSTATS_CPU_HIT, /* struct rtnl_link_stats64 */
+	__IFLA_OFFLOAD_XSTATS_MAX
+};
+#define IFLA_OFFLOAD_XSTATS_MAX (__IFLA_OFFLOAD_XSTATS_MAX - 1)
+
+/* XDP section */
+
+#define XDP_FLAGS_UPDATE_IF_NOEXIST	(1U << 0)
+#define XDP_FLAGS_SKB_MODE		(1U << 1)
+#define XDP_FLAGS_DRV_MODE		(1U << 2)
+#define XDP_FLAGS_HW_MODE		(1U << 3)
+#define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
+					 XDP_FLAGS_DRV_MODE | \
+					 XDP_FLAGS_HW_MODE)
+#define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
+					 XDP_FLAGS_MODES)
+
+/* These are stored into IFLA_XDP_ATTACHED on dump. */
+enum {
+	XDP_ATTACHED_NONE = 0,
+	XDP_ATTACHED_DRV,
+	XDP_ATTACHED_SKB,
+	XDP_ATTACHED_HW,
+	XDP_ATTACHED_MULTI,
+};
+
+enum {
+	IFLA_XDP_UNSPEC,
+	IFLA_XDP_FD,
+	IFLA_XDP_ATTACHED,
+	IFLA_XDP_FLAGS,
+	IFLA_XDP_PROG_ID,
+	IFLA_XDP_DRV_PROG_ID,
+	IFLA_XDP_SKB_PROG_ID,
+	IFLA_XDP_HW_PROG_ID,
+	__IFLA_XDP_MAX,
+};
+
+#define IFLA_XDP_MAX (__IFLA_XDP_MAX - 1)
+
+enum {
+	IFLA_EVENT_NONE,
+	IFLA_EVENT_REBOOT,		/* internal reset / reboot */
+	IFLA_EVENT_FEATURES,		/* change in offload features */
+	IFLA_EVENT_BONDING_FAILOVER,	/* change in active slave */
+	IFLA_EVENT_NOTIFY_PEERS,	/* re-sent grat. arp/ndisc */
+	IFLA_EVENT_IGMP_RESEND,		/* re-sent IGMP JOIN */
+	IFLA_EVENT_BONDING_OPTIONS,	/* change in bonding options */
+};
+
+/* tun section */
+
+enum {
+	IFLA_TUN_UNSPEC,
+	IFLA_TUN_OWNER,
+	IFLA_TUN_GROUP,
+	IFLA_TUN_TYPE,
+	IFLA_TUN_PI,
+	IFLA_TUN_VNET_HDR,
+	IFLA_TUN_PERSIST,
+	IFLA_TUN_MULTI_QUEUE,
+	IFLA_TUN_NUM_QUEUES,
+	IFLA_TUN_NUM_DISABLED_QUEUES,
+	__IFLA_TUN_MAX,
+};
+
+#define IFLA_TUN_MAX (__IFLA_TUN_MAX - 1)
+
+/* rmnet section */
+
+#define RMNET_FLAGS_INGRESS_DEAGGREGATION         (1U << 0)
+#define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
+#define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
+#define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
+
+enum {
+	IFLA_RMNET_UNSPEC,
+	IFLA_RMNET_MUX_ID,
+	IFLA_RMNET_FLAGS,
+	__IFLA_RMNET_MAX,
+};
+
+#define IFLA_RMNET_MAX	(__IFLA_RMNET_MAX - 1)
+
+struct ifla_rmnet_flags {
+	__u32	flags;
+	__u32	mask;
+};
+
+#endif /* _LINUX_IF_LINK_H */
diff --git a/uapi/linux/netlink.h b/uapi/linux/netlink.h
new file mode 100644
index 000000000000..2c28d329e595
--- /dev/null
+++ b/uapi/linux/netlink.h
@@ -0,0 +1,248 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __LINUX_NETLINK_H
+#define __LINUX_NETLINK_H
+
+#include <linux/kernel.h>
+#include <linux/socket.h> /* for __kernel_sa_family_t */
+#include <linux/types.h>
+
+#define NETLINK_ROUTE		0	/* Routing/device hook				*/
+#define NETLINK_UNUSED		1	/* Unused number				*/
+#define NETLINK_USERSOCK	2	/* Reserved for user mode socket protocols 	*/
+#define NETLINK_FIREWALL	3	/* Unused number, formerly ip_queue		*/
+#define NETLINK_SOCK_DIAG	4	/* socket monitoring				*/
+#define NETLINK_NFLOG		5	/* netfilter/iptables ULOG */
+#define NETLINK_XFRM		6	/* ipsec */
+#define NETLINK_SELINUX		7	/* SELinux event notifications */
+#define NETLINK_ISCSI		8	/* Open-iSCSI */
+#define NETLINK_AUDIT		9	/* auditing */
+#define NETLINK_FIB_LOOKUP	10	
+#define NETLINK_CONNECTOR	11
+#define NETLINK_NETFILTER	12	/* netfilter subsystem */
+#define NETLINK_IP6_FW		13
+#define NETLINK_DNRTMSG		14	/* DECnet routing messages */
+#define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
+#define NETLINK_GENERIC		16
+/* leave room for NETLINK_DM (DM Events) */
+#define NETLINK_SCSITRANSPORT	18	/* SCSI Transports */
+#define NETLINK_ECRYPTFS	19
+#define NETLINK_RDMA		20
+#define NETLINK_CRYPTO		21	/* Crypto layer */
+#define NETLINK_SMC		22	/* SMC monitoring */
+
+#define NETLINK_INET_DIAG	NETLINK_SOCK_DIAG
+
+#define MAX_LINKS 32		
+
+struct sockaddr_nl {
+	__kernel_sa_family_t	nl_family;	/* AF_NETLINK	*/
+	unsigned short	nl_pad;		/* zero		*/
+	__u32		nl_pid;		/* port ID	*/
+       	__u32		nl_groups;	/* multicast groups mask */
+};
+
+struct nlmsghdr {
+	__u32		nlmsg_len;	/* Length of message including header */
+	__u16		nlmsg_type;	/* Message content */
+	__u16		nlmsg_flags;	/* Additional flags */
+	__u32		nlmsg_seq;	/* Sequence number */
+	__u32		nlmsg_pid;	/* Sending process port ID */
+};
+
+/* Flags values */
+
+#define NLM_F_REQUEST		0x01	/* It is request message. 	*/
+#define NLM_F_MULTI		0x02	/* Multipart message, terminated by NLMSG_DONE */
+#define NLM_F_ACK		0x04	/* Reply with ack, with zero or error code */
+#define NLM_F_ECHO		0x08	/* Echo this request 		*/
+#define NLM_F_DUMP_INTR		0x10	/* Dump was inconsistent due to sequence change */
+#define NLM_F_DUMP_FILTERED	0x20	/* Dump was filtered as requested */
+
+/* Modifiers to GET request */
+#define NLM_F_ROOT	0x100	/* specify tree	root	*/
+#define NLM_F_MATCH	0x200	/* return all matching	*/
+#define NLM_F_ATOMIC	0x400	/* atomic GET		*/
+#define NLM_F_DUMP	(NLM_F_ROOT|NLM_F_MATCH)
+
+/* Modifiers to NEW request */
+#define NLM_F_REPLACE	0x100	/* Override existing		*/
+#define NLM_F_EXCL	0x200	/* Do not touch, if it exists	*/
+#define NLM_F_CREATE	0x400	/* Create, if it does not exist	*/
+#define NLM_F_APPEND	0x800	/* Add to end of list		*/
+
+/* Modifiers to DELETE request */
+#define NLM_F_NONREC	0x100	/* Do not delete recursively	*/
+
+/* Flags for ACK message */
+#define NLM_F_CAPPED	0x100	/* request was capped */
+#define NLM_F_ACK_TLVS	0x200	/* extended ACK TVLs were included */
+
+/*
+   4.4BSD ADD		NLM_F_CREATE|NLM_F_EXCL
+   4.4BSD CHANGE	NLM_F_REPLACE
+
+   True CHANGE		NLM_F_CREATE|NLM_F_REPLACE
+   Append		NLM_F_CREATE
+   Check		NLM_F_EXCL
+ */
+
+#define NLMSG_ALIGNTO	4U
+#define NLMSG_ALIGN(len) ( ((len)+NLMSG_ALIGNTO-1) & ~(NLMSG_ALIGNTO-1) )
+#define NLMSG_HDRLEN	 ((int) NLMSG_ALIGN(sizeof(struct nlmsghdr)))
+#define NLMSG_LENGTH(len) ((len) + NLMSG_HDRLEN)
+#define NLMSG_SPACE(len) NLMSG_ALIGN(NLMSG_LENGTH(len))
+#define NLMSG_DATA(nlh)  ((void*)(((char*)nlh) + NLMSG_LENGTH(0)))
+#define NLMSG_NEXT(nlh,len)	 ((len) -= NLMSG_ALIGN((nlh)->nlmsg_len), \
+				  (struct nlmsghdr*)(((char*)(nlh)) + NLMSG_ALIGN((nlh)->nlmsg_len)))
+#define NLMSG_OK(nlh,len) ((len) >= (int)sizeof(struct nlmsghdr) && \
+			   (nlh)->nlmsg_len >= sizeof(struct nlmsghdr) && \
+			   (nlh)->nlmsg_len <= (len))
+#define NLMSG_PAYLOAD(nlh,len) ((nlh)->nlmsg_len - NLMSG_SPACE((len)))
+
+#define NLMSG_NOOP		0x1	/* Nothing.		*/
+#define NLMSG_ERROR		0x2	/* Error		*/
+#define NLMSG_DONE		0x3	/* End of a dump	*/
+#define NLMSG_OVERRUN		0x4	/* Data lost		*/
+
+#define NLMSG_MIN_TYPE		0x10	/* < 0x10: reserved control messages */
+
+struct nlmsgerr {
+	int		error;
+	struct nlmsghdr msg;
+	/*
+	 * followed by the message contents unless NETLINK_CAP_ACK was set
+	 * or the ACK indicates success (error == 0)
+	 * message length is aligned with NLMSG_ALIGN()
+	 */
+	/*
+	 * followed by TLVs defined in enum nlmsgerr_attrs
+	 * if NETLINK_EXT_ACK was set
+	 */
+};
+
+/**
+ * enum nlmsgerr_attrs - nlmsgerr attributes
+ * @NLMSGERR_ATTR_UNUSED: unused
+ * @NLMSGERR_ATTR_MSG: error message string (string)
+ * @NLMSGERR_ATTR_OFFS: offset of the invalid attribute in the original
+ *	 message, counting from the beginning of the header (u32)
+ * @NLMSGERR_ATTR_COOKIE: arbitrary subsystem specific cookie to
+ *	be used - in the success case - to identify a created
+ *	object or operation or similar (binary)
+ * @__NLMSGERR_ATTR_MAX: number of attributes
+ * @NLMSGERR_ATTR_MAX: highest attribute number
+ */
+enum nlmsgerr_attrs {
+	NLMSGERR_ATTR_UNUSED,
+	NLMSGERR_ATTR_MSG,
+	NLMSGERR_ATTR_OFFS,
+	NLMSGERR_ATTR_COOKIE,
+
+	__NLMSGERR_ATTR_MAX,
+	NLMSGERR_ATTR_MAX = __NLMSGERR_ATTR_MAX - 1
+};
+
+#define NETLINK_ADD_MEMBERSHIP		1
+#define NETLINK_DROP_MEMBERSHIP		2
+#define NETLINK_PKTINFO			3
+#define NETLINK_BROADCAST_ERROR		4
+#define NETLINK_NO_ENOBUFS		5
+#define NETLINK_RX_RING			6
+#define NETLINK_TX_RING			7
+#define NETLINK_LISTEN_ALL_NSID		8
+#define NETLINK_LIST_MEMBERSHIPS	9
+#define NETLINK_CAP_ACK			10
+#define NETLINK_EXT_ACK			11
+#define NETLINK_GET_STRICT_CHK		12
+
+struct nl_pktinfo {
+	__u32	group;
+};
+
+struct nl_mmap_req {
+	unsigned int	nm_block_size;
+	unsigned int	nm_block_nr;
+	unsigned int	nm_frame_size;
+	unsigned int	nm_frame_nr;
+};
+
+struct nl_mmap_hdr {
+	unsigned int	nm_status;
+	unsigned int	nm_len;
+	__u32		nm_group;
+	/* credentials */
+	__u32		nm_pid;
+	__u32		nm_uid;
+	__u32		nm_gid;
+};
+
+enum nl_mmap_status {
+	NL_MMAP_STATUS_UNUSED,
+	NL_MMAP_STATUS_RESERVED,
+	NL_MMAP_STATUS_VALID,
+	NL_MMAP_STATUS_COPY,
+	NL_MMAP_STATUS_SKIP,
+};
+
+#define NL_MMAP_MSG_ALIGNMENT		NLMSG_ALIGNTO
+#define NL_MMAP_MSG_ALIGN(sz)		__ALIGN_KERNEL(sz, NL_MMAP_MSG_ALIGNMENT)
+#define NL_MMAP_HDRLEN			NL_MMAP_MSG_ALIGN(sizeof(struct nl_mmap_hdr))
+
+#define NET_MAJOR 36		/* Major 36 is reserved for networking 						*/
+
+enum {
+	NETLINK_UNCONNECTED = 0,
+	NETLINK_CONNECTED,
+};
+
+/*
+ *  <------- NLA_HDRLEN ------> <-- NLA_ALIGN(payload)-->
+ * +---------------------+- - -+- - - - - - - - - -+- - -+
+ * |        Header       | Pad |     Payload       | Pad |
+ * |   (struct nlattr)   | ing |                   | ing |
+ * +---------------------+- - -+- - - - - - - - - -+- - -+
+ *  <-------------- nlattr->nla_len -------------->
+ */
+
+struct nlattr {
+	__u16           nla_len;
+	__u16           nla_type;
+};
+
+/*
+ * nla_type (16 bits)
+ * +---+---+-------------------------------+
+ * | N | O | Attribute Type                |
+ * +---+---+-------------------------------+
+ * N := Carries nested attributes
+ * O := Payload stored in network byte order
+ *
+ * Note: The N and O flag are mutually exclusive.
+ */
+#define NLA_F_NESTED		(1 << 15)
+#define NLA_F_NET_BYTEORDER	(1 << 14)
+#define NLA_TYPE_MASK		~(NLA_F_NESTED | NLA_F_NET_BYTEORDER)
+
+#define NLA_ALIGNTO		4
+#define NLA_ALIGN(len)		(((len) + NLA_ALIGNTO - 1) & ~(NLA_ALIGNTO - 1))
+#define NLA_HDRLEN		((int) NLA_ALIGN(sizeof(struct nlattr)))
+
+/* Generic 32 bitflags attribute content sent to the kernel.
+ *
+ * The value is a bitmap that defines the values being set
+ * The selector is a bitmask that defines which value is legit
+ *
+ * Examples:
+ *  value = 0x0, and selector = 0x1
+ *  implies we are selecting bit 1 and we want to set its value to 0.
+ *
+ *  value = 0x2, and selector = 0x2
+ *  implies we are selecting bit 2 and we want to set its value to 1.
+ *
+ */
+struct nla_bitfield32 {
+	__u32 value;
+	__u32 selector;
+};
+
+#endif /* __LINUX_NETLINK_H */
diff --git a/uapi/linux/rtnetlink.h b/uapi/linux/rtnetlink.h
new file mode 100644
index 000000000000..9d802cd7f695
--- /dev/null
+++ b/uapi/linux/rtnetlink.h
@@ -0,0 +1,777 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef __LINUX_RTNETLINK_H
+#define __LINUX_RTNETLINK_H
+
+#include <linux/types.h>
+#include <linux/netlink.h>
+#include <linux/if_link.h>
+#include <linux/if_addr.h>
+#include <linux/neighbour.h>
+
+/* rtnetlink families. Values up to 127 are reserved for real address
+ * families, values above 128 may be used arbitrarily.
+ */
+#define RTNL_FAMILY_IPMR		128
+#define RTNL_FAMILY_IP6MR		129
+#define RTNL_FAMILY_MAX			129
+
+/****
+ *		Routing/neighbour discovery messages.
+ ****/
+
+/* Types of messages */
+
+enum {
+	RTM_BASE	= 16,
+#define RTM_BASE	RTM_BASE
+
+	RTM_NEWLINK	= 16,
+#define RTM_NEWLINK	RTM_NEWLINK
+	RTM_DELLINK,
+#define RTM_DELLINK	RTM_DELLINK
+	RTM_GETLINK,
+#define RTM_GETLINK	RTM_GETLINK
+	RTM_SETLINK,
+#define RTM_SETLINK	RTM_SETLINK
+
+	RTM_NEWADDR	= 20,
+#define RTM_NEWADDR	RTM_NEWADDR
+	RTM_DELADDR,
+#define RTM_DELADDR	RTM_DELADDR
+	RTM_GETADDR,
+#define RTM_GETADDR	RTM_GETADDR
+
+	RTM_NEWROUTE	= 24,
+#define RTM_NEWROUTE	RTM_NEWROUTE
+	RTM_DELROUTE,
+#define RTM_DELROUTE	RTM_DELROUTE
+	RTM_GETROUTE,
+#define RTM_GETROUTE	RTM_GETROUTE
+
+	RTM_NEWNEIGH	= 28,
+#define RTM_NEWNEIGH	RTM_NEWNEIGH
+	RTM_DELNEIGH,
+#define RTM_DELNEIGH	RTM_DELNEIGH
+	RTM_GETNEIGH,
+#define RTM_GETNEIGH	RTM_GETNEIGH
+
+	RTM_NEWRULE	= 32,
+#define RTM_NEWRULE	RTM_NEWRULE
+	RTM_DELRULE,
+#define RTM_DELRULE	RTM_DELRULE
+	RTM_GETRULE,
+#define RTM_GETRULE	RTM_GETRULE
+
+	RTM_NEWQDISC	= 36,
+#define RTM_NEWQDISC	RTM_NEWQDISC
+	RTM_DELQDISC,
+#define RTM_DELQDISC	RTM_DELQDISC
+	RTM_GETQDISC,
+#define RTM_GETQDISC	RTM_GETQDISC
+
+	RTM_NEWTCLASS	= 40,
+#define RTM_NEWTCLASS	RTM_NEWTCLASS
+	RTM_DELTCLASS,
+#define RTM_DELTCLASS	RTM_DELTCLASS
+	RTM_GETTCLASS,
+#define RTM_GETTCLASS	RTM_GETTCLASS
+
+	RTM_NEWTFILTER	= 44,
+#define RTM_NEWTFILTER	RTM_NEWTFILTER
+	RTM_DELTFILTER,
+#define RTM_DELTFILTER	RTM_DELTFILTER
+	RTM_GETTFILTER,
+#define RTM_GETTFILTER	RTM_GETTFILTER
+
+	RTM_NEWACTION	= 48,
+#define RTM_NEWACTION   RTM_NEWACTION
+	RTM_DELACTION,
+#define RTM_DELACTION   RTM_DELACTION
+	RTM_GETACTION,
+#define RTM_GETACTION   RTM_GETACTION
+
+	RTM_NEWPREFIX	= 52,
+#define RTM_NEWPREFIX	RTM_NEWPREFIX
+
+	RTM_GETMULTICAST = 58,
+#define RTM_GETMULTICAST RTM_GETMULTICAST
+
+	RTM_GETANYCAST	= 62,
+#define RTM_GETANYCAST	RTM_GETANYCAST
+
+	RTM_NEWNEIGHTBL	= 64,
+#define RTM_NEWNEIGHTBL	RTM_NEWNEIGHTBL
+	RTM_GETNEIGHTBL	= 66,
+#define RTM_GETNEIGHTBL	RTM_GETNEIGHTBL
+	RTM_SETNEIGHTBL,
+#define RTM_SETNEIGHTBL	RTM_SETNEIGHTBL
+
+	RTM_NEWNDUSEROPT = 68,
+#define RTM_NEWNDUSEROPT RTM_NEWNDUSEROPT
+
+	RTM_NEWADDRLABEL = 72,
+#define RTM_NEWADDRLABEL RTM_NEWADDRLABEL
+	RTM_DELADDRLABEL,
+#define RTM_DELADDRLABEL RTM_DELADDRLABEL
+	RTM_GETADDRLABEL,
+#define RTM_GETADDRLABEL RTM_GETADDRLABEL
+
+	RTM_GETDCB = 78,
+#define RTM_GETDCB RTM_GETDCB
+	RTM_SETDCB,
+#define RTM_SETDCB RTM_SETDCB
+
+	RTM_NEWNETCONF = 80,
+#define RTM_NEWNETCONF RTM_NEWNETCONF
+	RTM_DELNETCONF,
+#define RTM_DELNETCONF RTM_DELNETCONF
+	RTM_GETNETCONF = 82,
+#define RTM_GETNETCONF RTM_GETNETCONF
+
+	RTM_NEWMDB = 84,
+#define RTM_NEWMDB RTM_NEWMDB
+	RTM_DELMDB = 85,
+#define RTM_DELMDB RTM_DELMDB
+	RTM_GETMDB = 86,
+#define RTM_GETMDB RTM_GETMDB
+
+	RTM_NEWNSID = 88,
+#define RTM_NEWNSID RTM_NEWNSID
+	RTM_DELNSID = 89,
+#define RTM_DELNSID RTM_DELNSID
+	RTM_GETNSID = 90,
+#define RTM_GETNSID RTM_GETNSID
+
+	RTM_NEWSTATS = 92,
+#define RTM_NEWSTATS RTM_NEWSTATS
+	RTM_GETSTATS = 94,
+#define RTM_GETSTATS RTM_GETSTATS
+
+	RTM_NEWCACHEREPORT = 96,
+#define RTM_NEWCACHEREPORT RTM_NEWCACHEREPORT
+
+	RTM_NEWCHAIN = 100,
+#define RTM_NEWCHAIN RTM_NEWCHAIN
+	RTM_DELCHAIN,
+#define RTM_DELCHAIN RTM_DELCHAIN
+	RTM_GETCHAIN,
+#define RTM_GETCHAIN RTM_GETCHAIN
+
+	RTM_NEWNEXTHOP = 104,
+#define RTM_NEWNEXTHOP	RTM_NEWNEXTHOP
+	RTM_DELNEXTHOP,
+#define RTM_DELNEXTHOP	RTM_DELNEXTHOP
+	RTM_GETNEXTHOP,
+#define RTM_GETNEXTHOP	RTM_GETNEXTHOP
+
+	RTM_NEWLINKPROP = 108,
+#define RTM_NEWLINKPROP	RTM_NEWLINKPROP
+	RTM_DELLINKPROP,
+#define RTM_DELLINKPROP	RTM_DELLINKPROP
+	RTM_GETLINKPROP,
+#define RTM_GETLINKPROP	RTM_GETLINKPROP
+
+	RTM_NEWVLAN = 112,
+#define RTM_NEWNVLAN	RTM_NEWVLAN
+	RTM_DELVLAN,
+#define RTM_DELVLAN	RTM_DELVLAN
+	RTM_GETVLAN,
+#define RTM_GETVLAN	RTM_GETVLAN
+
+	__RTM_MAX,
+#define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
+};
+
+#define RTM_NR_MSGTYPES	(RTM_MAX + 1 - RTM_BASE)
+#define RTM_NR_FAMILIES	(RTM_NR_MSGTYPES >> 2)
+#define RTM_FAM(cmd)	(((cmd) - RTM_BASE) >> 2)
+
+/* 
+   Generic structure for encapsulation of optional route information.
+   It is reminiscent of sockaddr, but with sa_family replaced
+   with attribute type.
+ */
+
+struct rtattr {
+	unsigned short	rta_len;
+	unsigned short	rta_type;
+};
+
+/* Macros to handle rtattributes */
+
+#define RTA_ALIGNTO	4U
+#define RTA_ALIGN(len) ( ((len)+RTA_ALIGNTO-1) & ~(RTA_ALIGNTO-1) )
+#define RTA_OK(rta,len) ((len) >= (int)sizeof(struct rtattr) && \
+			 (rta)->rta_len >= sizeof(struct rtattr) && \
+			 (rta)->rta_len <= (len))
+#define RTA_NEXT(rta,attrlen)	((attrlen) -= RTA_ALIGN((rta)->rta_len), \
+				 (struct rtattr*)(((char*)(rta)) + RTA_ALIGN((rta)->rta_len)))
+#define RTA_LENGTH(len)	(RTA_ALIGN(sizeof(struct rtattr)) + (len))
+#define RTA_SPACE(len)	RTA_ALIGN(RTA_LENGTH(len))
+#define RTA_DATA(rta)   ((void*)(((char*)(rta)) + RTA_LENGTH(0)))
+#define RTA_PAYLOAD(rta) ((int)((rta)->rta_len) - RTA_LENGTH(0))
+
+
+
+
+/******************************************************************************
+ *		Definitions used in routing table administration.
+ ****/
+
+struct rtmsg {
+	unsigned char		rtm_family;
+	unsigned char		rtm_dst_len;
+	unsigned char		rtm_src_len;
+	unsigned char		rtm_tos;
+
+	unsigned char		rtm_table;	/* Routing table id */
+	unsigned char		rtm_protocol;	/* Routing protocol; see below	*/
+	unsigned char		rtm_scope;	/* See below */	
+	unsigned char		rtm_type;	/* See below	*/
+
+	unsigned		rtm_flags;
+};
+
+/* rtm_type */
+
+enum {
+	RTN_UNSPEC,
+	RTN_UNICAST,		/* Gateway or direct route	*/
+	RTN_LOCAL,		/* Accept locally		*/
+	RTN_BROADCAST,		/* Accept locally as broadcast,
+				   send as broadcast */
+	RTN_ANYCAST,		/* Accept locally as broadcast,
+				   but send as unicast */
+	RTN_MULTICAST,		/* Multicast route		*/
+	RTN_BLACKHOLE,		/* Drop				*/
+	RTN_UNREACHABLE,	/* Destination is unreachable   */
+	RTN_PROHIBIT,		/* Administratively prohibited	*/
+	RTN_THROW,		/* Not in this table		*/
+	RTN_NAT,		/* Translate this address	*/
+	RTN_XRESOLVE,		/* Use external resolver	*/
+	__RTN_MAX
+};
+
+#define RTN_MAX (__RTN_MAX - 1)
+
+
+/* rtm_protocol */
+
+#define RTPROT_UNSPEC	0
+#define RTPROT_REDIRECT	1	/* Route installed by ICMP redirects;
+				   not used by current IPv4 */
+#define RTPROT_KERNEL	2	/* Route installed by kernel		*/
+#define RTPROT_BOOT	3	/* Route installed during boot		*/
+#define RTPROT_STATIC	4	/* Route installed by administrator	*/
+
+/* Values of protocol >= RTPROT_STATIC are not interpreted by kernel;
+   they are just passed from user and back as is.
+   It will be used by hypothetical multiple routing daemons.
+   Note that protocol values should be standardized in order to
+   avoid conflicts.
+ */
+
+#define RTPROT_GATED	8	/* Apparently, GateD */
+#define RTPROT_RA	9	/* RDISC/ND router advertisements */
+#define RTPROT_MRT	10	/* Merit MRT */
+#define RTPROT_ZEBRA	11	/* Zebra */
+#define RTPROT_BIRD	12	/* BIRD */
+#define RTPROT_DNROUTED	13	/* DECnet routing daemon */
+#define RTPROT_XORP	14	/* XORP */
+#define RTPROT_NTK	15	/* Netsukuku */
+#define RTPROT_DHCP	16      /* DHCP client */
+#define RTPROT_MROUTED	17      /* Multicast daemon */
+#define RTPROT_BABEL	42      /* Babel daemon */
+#define RTPROT_BGP	186     /* BGP Routes */
+#define RTPROT_ISIS	187     /* ISIS Routes */
+#define RTPROT_OSPF	188     /* OSPF Routes */
+#define RTPROT_RIP	189     /* RIP Routes */
+#define RTPROT_EIGRP	192     /* EIGRP Routes */
+
+/* rtm_scope
+
+   Really it is not scope, but sort of distance to the destination.
+   NOWHERE are reserved for not existing destinations, HOST is our
+   local addresses, LINK are destinations, located on directly attached
+   link and UNIVERSE is everywhere in the Universe.
+
+   Intermediate values are also possible f.e. interior routes
+   could be assigned a value between UNIVERSE and LINK.
+*/
+
+enum rt_scope_t {
+	RT_SCOPE_UNIVERSE=0,
+/* User defined values  */
+	RT_SCOPE_SITE=200,
+	RT_SCOPE_LINK=253,
+	RT_SCOPE_HOST=254,
+	RT_SCOPE_NOWHERE=255
+};
+
+/* rtm_flags */
+
+#define RTM_F_NOTIFY		0x100	/* Notify user of route change	*/
+#define RTM_F_CLONED		0x200	/* This route is cloned		*/
+#define RTM_F_EQUALIZE		0x400	/* Multipath equalizer: NI	*/
+#define RTM_F_PREFIX		0x800	/* Prefix addresses		*/
+#define RTM_F_LOOKUP_TABLE	0x1000	/* set rtm_table to FIB lookup result */
+#define RTM_F_FIB_MATCH	        0x2000	/* return full fib lookup match */
+#define RTM_F_OFFLOAD		0x4000	/* route is offloaded */
+#define RTM_F_TRAP		0x8000	/* route is trapping packets */
+
+/* Reserved table identifiers */
+
+enum rt_class_t {
+	RT_TABLE_UNSPEC=0,
+/* User defined values */
+	RT_TABLE_COMPAT=252,
+	RT_TABLE_DEFAULT=253,
+	RT_TABLE_MAIN=254,
+	RT_TABLE_LOCAL=255,
+	RT_TABLE_MAX=0xFFFFFFFF
+};
+
+
+/* Routing message attributes */
+
+enum rtattr_type_t {
+	RTA_UNSPEC,
+	RTA_DST,
+	RTA_SRC,
+	RTA_IIF,
+	RTA_OIF,
+	RTA_GATEWAY,
+	RTA_PRIORITY,
+	RTA_PREFSRC,
+	RTA_METRICS,
+	RTA_MULTIPATH,
+	RTA_PROTOINFO, /* no longer used */
+	RTA_FLOW,
+	RTA_CACHEINFO,
+	RTA_SESSION, /* no longer used */
+	RTA_MP_ALGO, /* no longer used */
+	RTA_TABLE,
+	RTA_MARK,
+	RTA_MFC_STATS,
+	RTA_VIA,
+	RTA_NEWDST,
+	RTA_PREF,
+	RTA_ENCAP_TYPE,
+	RTA_ENCAP,
+	RTA_EXPIRES,
+	RTA_PAD,
+	RTA_UID,
+	RTA_TTL_PROPAGATE,
+	RTA_IP_PROTO,
+	RTA_SPORT,
+	RTA_DPORT,
+	RTA_NH_ID,
+	__RTA_MAX
+};
+
+#define RTA_MAX (__RTA_MAX - 1)
+
+#define RTM_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct rtmsg))))
+#define RTM_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct rtmsg))
+
+/* RTM_MULTIPATH --- array of struct rtnexthop.
+ *
+ * "struct rtnexthop" describes all necessary nexthop information,
+ * i.e. parameters of path to a destination via this nexthop.
+ *
+ * At the moment it is impossible to set different prefsrc, mtu, window
+ * and rtt for different paths from multipath.
+ */
+
+struct rtnexthop {
+	unsigned short		rtnh_len;
+	unsigned char		rtnh_flags;
+	unsigned char		rtnh_hops;
+	int			rtnh_ifindex;
+};
+
+/* rtnh_flags */
+
+#define RTNH_F_DEAD		1	/* Nexthop is dead (used by multipath)	*/
+#define RTNH_F_PERVASIVE	2	/* Do recursive gateway lookup	*/
+#define RTNH_F_ONLINK		4	/* Gateway is forced on link	*/
+#define RTNH_F_OFFLOAD		8	/* offloaded route */
+#define RTNH_F_LINKDOWN		16	/* carrier-down on nexthop */
+#define RTNH_F_UNRESOLVED	32	/* The entry is unresolved (ipmr) */
+
+#define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | RTNH_F_OFFLOAD)
+
+/* Macros to handle hexthops */
+
+#define RTNH_ALIGNTO	4
+#define RTNH_ALIGN(len) ( ((len)+RTNH_ALIGNTO-1) & ~(RTNH_ALIGNTO-1) )
+#define RTNH_OK(rtnh,len) ((rtnh)->rtnh_len >= sizeof(struct rtnexthop) && \
+			   ((int)(rtnh)->rtnh_len) <= (len))
+#define RTNH_NEXT(rtnh)	((struct rtnexthop*)(((char*)(rtnh)) + RTNH_ALIGN((rtnh)->rtnh_len)))
+#define RTNH_LENGTH(len) (RTNH_ALIGN(sizeof(struct rtnexthop)) + (len))
+#define RTNH_SPACE(len)	RTNH_ALIGN(RTNH_LENGTH(len))
+#define RTNH_DATA(rtnh)   ((struct rtattr*)(((char*)(rtnh)) + RTNH_LENGTH(0)))
+
+/* RTA_VIA */
+struct rtvia {
+	__kernel_sa_family_t	rtvia_family;
+	__u8			rtvia_addr[0];
+};
+
+/* RTM_CACHEINFO */
+
+struct rta_cacheinfo {
+	__u32	rta_clntref;
+	__u32	rta_lastuse;
+	__s32	rta_expires;
+	__u32	rta_error;
+	__u32	rta_used;
+
+#define RTNETLINK_HAVE_PEERINFO 1
+	__u32	rta_id;
+	__u32	rta_ts;
+	__u32	rta_tsage;
+};
+
+/* RTM_METRICS --- array of struct rtattr with types of RTAX_* */
+
+enum {
+	RTAX_UNSPEC,
+#define RTAX_UNSPEC RTAX_UNSPEC
+	RTAX_LOCK,
+#define RTAX_LOCK RTAX_LOCK
+	RTAX_MTU,
+#define RTAX_MTU RTAX_MTU
+	RTAX_WINDOW,
+#define RTAX_WINDOW RTAX_WINDOW
+	RTAX_RTT,
+#define RTAX_RTT RTAX_RTT
+	RTAX_RTTVAR,
+#define RTAX_RTTVAR RTAX_RTTVAR
+	RTAX_SSTHRESH,
+#define RTAX_SSTHRESH RTAX_SSTHRESH
+	RTAX_CWND,
+#define RTAX_CWND RTAX_CWND
+	RTAX_ADVMSS,
+#define RTAX_ADVMSS RTAX_ADVMSS
+	RTAX_REORDERING,
+#define RTAX_REORDERING RTAX_REORDERING
+	RTAX_HOPLIMIT,
+#define RTAX_HOPLIMIT RTAX_HOPLIMIT
+	RTAX_INITCWND,
+#define RTAX_INITCWND RTAX_INITCWND
+	RTAX_FEATURES,
+#define RTAX_FEATURES RTAX_FEATURES
+	RTAX_RTO_MIN,
+#define RTAX_RTO_MIN RTAX_RTO_MIN
+	RTAX_INITRWND,
+#define RTAX_INITRWND RTAX_INITRWND
+	RTAX_QUICKACK,
+#define RTAX_QUICKACK RTAX_QUICKACK
+	RTAX_CC_ALGO,
+#define RTAX_CC_ALGO RTAX_CC_ALGO
+	RTAX_FASTOPEN_NO_COOKIE,
+#define RTAX_FASTOPEN_NO_COOKIE RTAX_FASTOPEN_NO_COOKIE
+	__RTAX_MAX
+};
+
+#define RTAX_MAX (__RTAX_MAX - 1)
+
+#define RTAX_FEATURE_ECN	(1 << 0)
+#define RTAX_FEATURE_SACK	(1 << 1)
+#define RTAX_FEATURE_TIMESTAMP	(1 << 2)
+#define RTAX_FEATURE_ALLFRAG	(1 << 3)
+
+#define RTAX_FEATURE_MASK	(RTAX_FEATURE_ECN | RTAX_FEATURE_SACK | \
+				 RTAX_FEATURE_TIMESTAMP | RTAX_FEATURE_ALLFRAG)
+
+struct rta_session {
+	__u8	proto;
+	__u8	pad1;
+	__u16	pad2;
+
+	union {
+		struct {
+			__u16	sport;
+			__u16	dport;
+		} ports;
+
+		struct {
+			__u8	type;
+			__u8	code;
+			__u16	ident;
+		} icmpt;
+
+		__u32		spi;
+	} u;
+};
+
+struct rta_mfc_stats {
+	__u64	mfcs_packets;
+	__u64	mfcs_bytes;
+	__u64	mfcs_wrong_if;
+};
+
+/****
+ *		General form of address family dependent message.
+ ****/
+
+struct rtgenmsg {
+	unsigned char		rtgen_family;
+};
+
+/*****************************************************************
+ *		Link layer specific messages.
+ ****/
+
+/* struct ifinfomsg
+ * passes link level specific information, not dependent
+ * on network protocol.
+ */
+
+struct ifinfomsg {
+	unsigned char	ifi_family;
+	unsigned char	__ifi_pad;
+	unsigned short	ifi_type;		/* ARPHRD_* */
+	int		ifi_index;		/* Link index	*/
+	unsigned	ifi_flags;		/* IFF_* flags	*/
+	unsigned	ifi_change;		/* IFF_* change mask */
+};
+
+/********************************************************************
+ *		prefix information 
+ ****/
+
+struct prefixmsg {
+	unsigned char	prefix_family;
+	unsigned char	prefix_pad1;
+	unsigned short	prefix_pad2;
+	int		prefix_ifindex;
+	unsigned char	prefix_type;
+	unsigned char	prefix_len;
+	unsigned char	prefix_flags;
+	unsigned char	prefix_pad3;
+};
+
+enum 
+{
+	PREFIX_UNSPEC,
+	PREFIX_ADDRESS,
+	PREFIX_CACHEINFO,
+	__PREFIX_MAX
+};
+
+#define PREFIX_MAX	(__PREFIX_MAX - 1)
+
+struct prefix_cacheinfo {
+	__u32	preferred_time;
+	__u32	valid_time;
+};
+
+
+/*****************************************************************
+ *		Traffic control messages.
+ ****/
+
+struct tcmsg {
+	unsigned char	tcm_family;
+	unsigned char	tcm__pad1;
+	unsigned short	tcm__pad2;
+	int		tcm_ifindex;
+	__u32		tcm_handle;
+	__u32		tcm_parent;
+/* tcm_block_index is used instead of tcm_parent
+ * in case tcm_ifindex == TCM_IFINDEX_MAGIC_BLOCK
+ */
+#define tcm_block_index tcm_parent
+	__u32		tcm_info;
+};
+
+/* For manipulation of filters in shared block, tcm_ifindex is set to
+ * TCM_IFINDEX_MAGIC_BLOCK, and tcm_parent is aliased to tcm_block_index
+ * which is the block index.
+ */
+#define TCM_IFINDEX_MAGIC_BLOCK (0xFFFFFFFFU)
+
+enum {
+	TCA_UNSPEC,
+	TCA_KIND,
+	TCA_OPTIONS,
+	TCA_STATS,
+	TCA_XSTATS,
+	TCA_RATE,
+	TCA_FCNT,
+	TCA_STATS2,
+	TCA_STAB,
+	TCA_PAD,
+	TCA_DUMP_INVISIBLE,
+	TCA_CHAIN,
+	TCA_HW_OFFLOAD,
+	TCA_INGRESS_BLOCK,
+	TCA_EGRESS_BLOCK,
+	__TCA_MAX
+};
+
+#define TCA_MAX (__TCA_MAX - 1)
+
+#define TCA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct tcmsg))))
+#define TCA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct tcmsg))
+
+/********************************************************************
+ *		Neighbor Discovery userland options
+ ****/
+
+struct nduseroptmsg {
+	unsigned char	nduseropt_family;
+	unsigned char	nduseropt_pad1;
+	unsigned short	nduseropt_opts_len;	/* Total length of options */
+	int		nduseropt_ifindex;
+	__u8		nduseropt_icmp_type;
+	__u8		nduseropt_icmp_code;
+	unsigned short	nduseropt_pad2;
+	unsigned int	nduseropt_pad3;
+	/* Followed by one or more ND options */
+};
+
+enum {
+	NDUSEROPT_UNSPEC,
+	NDUSEROPT_SRCADDR,
+	__NDUSEROPT_MAX
+};
+
+#define NDUSEROPT_MAX	(__NDUSEROPT_MAX - 1)
+
+/* RTnetlink multicast groups - backwards compatibility for userspace */
+#define RTMGRP_LINK		1
+#define RTMGRP_NOTIFY		2
+#define RTMGRP_NEIGH		4
+#define RTMGRP_TC		8
+
+#define RTMGRP_IPV4_IFADDR	0x10
+#define RTMGRP_IPV4_MROUTE	0x20
+#define RTMGRP_IPV4_ROUTE	0x40
+#define RTMGRP_IPV4_RULE	0x80
+
+#define RTMGRP_IPV6_IFADDR	0x100
+#define RTMGRP_IPV6_MROUTE	0x200
+#define RTMGRP_IPV6_ROUTE	0x400
+#define RTMGRP_IPV6_IFINFO	0x800
+
+#define RTMGRP_DECnet_IFADDR    0x1000
+#define RTMGRP_DECnet_ROUTE     0x4000
+
+#define RTMGRP_IPV6_PREFIX	0x20000
+
+/* RTnetlink multicast groups */
+enum rtnetlink_groups {
+	RTNLGRP_NONE,
+#define RTNLGRP_NONE		RTNLGRP_NONE
+	RTNLGRP_LINK,
+#define RTNLGRP_LINK		RTNLGRP_LINK
+	RTNLGRP_NOTIFY,
+#define RTNLGRP_NOTIFY		RTNLGRP_NOTIFY
+	RTNLGRP_NEIGH,
+#define RTNLGRP_NEIGH		RTNLGRP_NEIGH
+	RTNLGRP_TC,
+#define RTNLGRP_TC		RTNLGRP_TC
+	RTNLGRP_IPV4_IFADDR,
+#define RTNLGRP_IPV4_IFADDR	RTNLGRP_IPV4_IFADDR
+	RTNLGRP_IPV4_MROUTE,
+#define	RTNLGRP_IPV4_MROUTE	RTNLGRP_IPV4_MROUTE
+	RTNLGRP_IPV4_ROUTE,
+#define RTNLGRP_IPV4_ROUTE	RTNLGRP_IPV4_ROUTE
+	RTNLGRP_IPV4_RULE,
+#define RTNLGRP_IPV4_RULE	RTNLGRP_IPV4_RULE
+	RTNLGRP_IPV6_IFADDR,
+#define RTNLGRP_IPV6_IFADDR	RTNLGRP_IPV6_IFADDR
+	RTNLGRP_IPV6_MROUTE,
+#define RTNLGRP_IPV6_MROUTE	RTNLGRP_IPV6_MROUTE
+	RTNLGRP_IPV6_ROUTE,
+#define RTNLGRP_IPV6_ROUTE	RTNLGRP_IPV6_ROUTE
+	RTNLGRP_IPV6_IFINFO,
+#define RTNLGRP_IPV6_IFINFO	RTNLGRP_IPV6_IFINFO
+	RTNLGRP_DECnet_IFADDR,
+#define RTNLGRP_DECnet_IFADDR	RTNLGRP_DECnet_IFADDR
+	RTNLGRP_NOP2,
+	RTNLGRP_DECnet_ROUTE,
+#define RTNLGRP_DECnet_ROUTE	RTNLGRP_DECnet_ROUTE
+	RTNLGRP_DECnet_RULE,
+#define RTNLGRP_DECnet_RULE	RTNLGRP_DECnet_RULE
+	RTNLGRP_NOP4,
+	RTNLGRP_IPV6_PREFIX,
+#define RTNLGRP_IPV6_PREFIX	RTNLGRP_IPV6_PREFIX
+	RTNLGRP_IPV6_RULE,
+#define RTNLGRP_IPV6_RULE	RTNLGRP_IPV6_RULE
+	RTNLGRP_ND_USEROPT,
+#define RTNLGRP_ND_USEROPT	RTNLGRP_ND_USEROPT
+	RTNLGRP_PHONET_IFADDR,
+#define RTNLGRP_PHONET_IFADDR	RTNLGRP_PHONET_IFADDR
+	RTNLGRP_PHONET_ROUTE,
+#define RTNLGRP_PHONET_ROUTE	RTNLGRP_PHONET_ROUTE
+	RTNLGRP_DCB,
+#define RTNLGRP_DCB		RTNLGRP_DCB
+	RTNLGRP_IPV4_NETCONF,
+#define RTNLGRP_IPV4_NETCONF	RTNLGRP_IPV4_NETCONF
+	RTNLGRP_IPV6_NETCONF,
+#define RTNLGRP_IPV6_NETCONF	RTNLGRP_IPV6_NETCONF
+	RTNLGRP_MDB,
+#define RTNLGRP_MDB		RTNLGRP_MDB
+	RTNLGRP_MPLS_ROUTE,
+#define RTNLGRP_MPLS_ROUTE	RTNLGRP_MPLS_ROUTE
+	RTNLGRP_NSID,
+#define RTNLGRP_NSID		RTNLGRP_NSID
+	RTNLGRP_MPLS_NETCONF,
+#define RTNLGRP_MPLS_NETCONF	RTNLGRP_MPLS_NETCONF
+	RTNLGRP_IPV4_MROUTE_R,
+#define RTNLGRP_IPV4_MROUTE_R	RTNLGRP_IPV4_MROUTE_R
+	RTNLGRP_IPV6_MROUTE_R,
+#define RTNLGRP_IPV6_MROUTE_R	RTNLGRP_IPV6_MROUTE_R
+	RTNLGRP_NEXTHOP,
+#define RTNLGRP_NEXTHOP		RTNLGRP_NEXTHOP
+	RTNLGRP_BRVLAN,
+#define RTNLGRP_BRVLAN		RTNLGRP_BRVLAN
+	__RTNLGRP_MAX
+};
+#define RTNLGRP_MAX	(__RTNLGRP_MAX - 1)
+
+/* TC action piece */
+struct tcamsg {
+	unsigned char	tca_family;
+	unsigned char	tca__pad1;
+	unsigned short	tca__pad2;
+};
+
+enum {
+	TCA_ROOT_UNSPEC,
+	TCA_ROOT_TAB,
+#define TCA_ACT_TAB TCA_ROOT_TAB
+#define TCAA_MAX TCA_ROOT_TAB
+	TCA_ROOT_FLAGS,
+	TCA_ROOT_COUNT,
+	TCA_ROOT_TIME_DELTA, /* in msecs */
+	__TCA_ROOT_MAX,
+#define	TCA_ROOT_MAX (__TCA_ROOT_MAX - 1)
+};
+
+#define TA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct tcamsg))))
+#define TA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct tcamsg))
+/* tcamsg flags stored in attribute TCA_ROOT_FLAGS
+ *
+ * TCA_FLAG_LARGE_DUMP_ON user->kernel to request for larger than TCA_ACT_MAX_PRIO
+ * actions in a dump. All dump responses will contain the number of actions
+ * being dumped stored in for user app's consumption in TCA_ROOT_COUNT
+ *
+ */
+#define TCA_FLAG_LARGE_DUMP_ON		(1 << 0)
+
+/* New extended info filters for IFLA_EXT_MASK */
+#define RTEXT_FILTER_VF		(1 << 0)
+#define RTEXT_FILTER_BRVLAN	(1 << 1)
+#define RTEXT_FILTER_BRVLAN_COMPRESSED	(1 << 2)
+#define	RTEXT_FILTER_SKIP_STATS	(1 << 3)
+
+/* End of information exported to user level */
+
+
+
+#endif /* __LINUX_RTNETLINK_H */
-- 
2.25.1

