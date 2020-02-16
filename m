Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C880D1606FB
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 23:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbgBPWq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 17:46:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:33732 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbgBPWq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 17:46:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 28AC8AF2F;
        Sun, 16 Feb 2020 22:46:56 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id C782DE03D6; Sun, 16 Feb 2020 23:46:55 +0100 (CET)
Message-Id: <c8f2a961ecc843e49c1370ab9d2ae62fe393e2ed.1581892124.git.mkubecek@suse.cz>
In-Reply-To: <cover.1581892124.git.mkubecek@suse.cz>
References: <cover.1581892124.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 05/19] netlink: add netlink related UAPI header files
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Sun, 16 Feb 2020 23:46:55 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add copies of kernel UAPI header files needed for netlink interface:

  <linux/netlink.h>
  <linux/genetlink.h>
  <linux/ethtool_netlink.h>

The (sanitized) copies are taken from v5.6-rc1.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 uapi/linux/ethtool_netlink.h | 237 +++++++++++++++++++++++++++++++++
 uapi/linux/genetlink.h       |  89 +++++++++++++
 uapi/linux/netlink.h         | 248 +++++++++++++++++++++++++++++++++++
 3 files changed, 574 insertions(+)
 create mode 100644 uapi/linux/ethtool_netlink.h
 create mode 100644 uapi/linux/genetlink.h
 create mode 100644 uapi/linux/netlink.h

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
-- 
2.25.0

