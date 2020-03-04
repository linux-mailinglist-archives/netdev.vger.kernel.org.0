Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF611799C5
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388375AbgCDU0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:26:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:33918 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387926AbgCDU03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:26:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DDC38B2B8;
        Wed,  4 Mar 2020 20:26:26 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 8DBAAE037F; Wed,  4 Mar 2020 21:26:26 +0100 (CET)
Message-Id: <4b49cd7e618bf0eee6d8dede639ee92167049496.1583347351.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 22/25] netlink: message format description for
 ethtool netlink
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed,  4 Mar 2020 21:26:26 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add description of ethtool netlink message formats to be used for pretty
printing infrastructure. These arrays map (numeric) attribute types to
their symbolic names and format of their payload so that attributes can be
displayed in human friendly form.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am            |   1 +
 netlink/desc-ethtool.c | 139 +++++++++++++++++++++++++++++++++++++++++
 netlink/prettymsg.h    |   7 +++
 3 files changed, 147 insertions(+)
 create mode 100644 netlink/desc-ethtool.c

diff --git a/Makefile.am b/Makefile.am
index baef0d20fa41..adbe5bc52b4b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -32,6 +32,7 @@ ethtool_SOURCES += \
 		  netlink/monitor.c netlink/bitset.c netlink/bitset.h \
 		  netlink/settings.c netlink/parser.c netlink/parser.h \
 		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
+		  netlink/desc-ethtool.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
new file mode 100644
index 000000000000..76c6f13e4648
--- /dev/null
+++ b/netlink/desc-ethtool.c
@@ -0,0 +1,139 @@
+/*
+ * desc-ethtool.c - ethtool netlink format descriptions
+ *
+ * Descriptions of ethtool netlink messages and attributes for pretty print.
+ */
+
+#include <linux/ethtool_netlink.h>
+
+#include "../internal.h"
+#include "prettymsg.h"
+
+static const struct pretty_nla_desc __header_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_HEADER_UNSPEC),
+	NLATTR_DESC_U32(ETHTOOL_A_HEADER_DEV_INDEX),
+	NLATTR_DESC_STRING(ETHTOOL_A_HEADER_DEV_NAME),
+	NLATTR_DESC_X32(ETHTOOL_A_HEADER_FLAGS),
+};
+
+static const struct pretty_nla_desc __bitset_bit_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_BITSET_BIT_UNSPEC),
+	NLATTR_DESC_U32(ETHTOOL_A_BITSET_BIT_INDEX),
+	NLATTR_DESC_STRING(ETHTOOL_A_BITSET_BIT_NAME),
+	NLATTR_DESC_FLAG(ETHTOOL_A_BITSET_BIT_VALUE),
+};
+
+static const struct pretty_nla_desc __bitset_bits_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_BITSET_BITS_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_BITSET_BITS_BIT, bitset_bit),
+};
+
+static const struct pretty_nla_desc __bitset_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_BITSET_UNSPEC),
+	NLATTR_DESC_FLAG(ETHTOOL_A_BITSET_NOMASK),
+	NLATTR_DESC_U32(ETHTOOL_A_BITSET_SIZE),
+	NLATTR_DESC_NESTED(ETHTOOL_A_BITSET_BITS, bitset_bits),
+	NLATTR_DESC_BINARY(ETHTOOL_A_BITSET_VALUE),
+	NLATTR_DESC_BINARY(ETHTOOL_A_BITSET_MASK),
+};
+
+static const struct pretty_nla_desc __string_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_STRING_UNSPEC),
+	NLATTR_DESC_U32(ETHTOOL_A_STRING_INDEX),
+	NLATTR_DESC_STRING(ETHTOOL_A_STRING_VALUE),
+};
+
+static const struct pretty_nla_desc __strings_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_STRINGS_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_STRINGS_STRING, string),
+};
+
+static const struct pretty_nla_desc __stringset_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_STRINGSET_UNSPEC),
+	NLATTR_DESC_U32(ETHTOOL_A_STRINGSET_ID),
+	NLATTR_DESC_U32(ETHTOOL_A_STRINGSET_COUNT),
+	NLATTR_DESC_NESTED(ETHTOOL_A_STRINGSET_STRINGS, strings),
+};
+
+static const struct pretty_nla_desc __stringsets_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_STRINGSETS_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_STRINGSETS_STRINGSET, stringset),
+};
+
+static const struct pretty_nla_desc __strset_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_STRSET_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_STRSET_HEADER, header),
+	NLATTR_DESC_NESTED(ETHTOOL_A_STRSET_STRINGSETS, stringsets),
+	NLATTR_DESC_FLAG(ETHTOOL_A_STRSET_COUNTS_ONLY),
+};
+
+static const struct pretty_nla_desc __linkinfo_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_LINKINFO_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_LINKINFO_HEADER, header),
+	NLATTR_DESC_U8(ETHTOOL_A_LINKINFO_PORT),
+	NLATTR_DESC_U8(ETHTOOL_A_LINKINFO_PHYADDR),
+	NLATTR_DESC_U8(ETHTOOL_A_LINKINFO_TP_MDIX),
+	NLATTR_DESC_U8(ETHTOOL_A_LINKINFO_TP_MDIX_CTRL),
+	NLATTR_DESC_U8(ETHTOOL_A_LINKINFO_TRANSCEIVER),
+};
+
+static const struct pretty_nla_desc __linkmodes_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_LINKMODES_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_LINKMODES_HEADER, header),
+	NLATTR_DESC_BOOL(ETHTOOL_A_LINKMODES_AUTONEG),
+	NLATTR_DESC_NESTED(ETHTOOL_A_LINKMODES_OURS, bitset),
+	NLATTR_DESC_NESTED(ETHTOOL_A_LINKMODES_PEER, bitset),
+	NLATTR_DESC_U32(ETHTOOL_A_LINKMODES_SPEED),
+	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_DUPLEX),
+};
+
+static const struct pretty_nla_desc __linkstate_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_LINKSTATE_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_LINKSTATE_HEADER, header),
+	NLATTR_DESC_BOOL(ETHTOOL_A_LINKSTATE_LINK),
+};
+
+static const struct pretty_nla_desc __debug_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_DEBUG_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_DEBUG_HEADER, header),
+	NLATTR_DESC_NESTED(ETHTOOL_A_DEBUG_MSGMASK, bitset),
+};
+
+static const struct pretty_nla_desc __wol_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_WOL_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_WOL_HEADER, header),
+	NLATTR_DESC_NESTED(ETHTOOL_A_WOL_MODES, bitset),
+	NLATTR_DESC_BINARY(ETHTOOL_A_WOL_SOPASS),
+};
+
+const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
+	NLMSG_DESC_INVALID(ETHTOOL_MSG_USER_NONE),
+	NLMSG_DESC(ETHTOOL_MSG_STRSET_GET, strset),
+	NLMSG_DESC(ETHTOOL_MSG_LINKINFO_GET, linkinfo),
+	NLMSG_DESC(ETHTOOL_MSG_LINKINFO_SET, linkinfo),
+	NLMSG_DESC(ETHTOOL_MSG_LINKMODES_GET, linkmodes),
+	NLMSG_DESC(ETHTOOL_MSG_LINKMODES_SET, linkmodes),
+	NLMSG_DESC(ETHTOOL_MSG_LINKSTATE_GET, linkstate),
+	NLMSG_DESC(ETHTOOL_MSG_DEBUG_GET, debug),
+	NLMSG_DESC(ETHTOOL_MSG_DEBUG_SET, debug),
+	NLMSG_DESC(ETHTOOL_MSG_WOL_GET, wol),
+	NLMSG_DESC(ETHTOOL_MSG_WOL_SET, wol),
+};
+
+const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
+
+const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
+	NLMSG_DESC_INVALID(ETHTOOL_MSG_KERNEL_NONE),
+	NLMSG_DESC(ETHTOOL_MSG_STRSET_GET_REPLY, strset),
+	NLMSG_DESC(ETHTOOL_MSG_LINKINFO_GET_REPLY, linkinfo),
+	NLMSG_DESC(ETHTOOL_MSG_LINKINFO_NTF, linkinfo),
+	NLMSG_DESC(ETHTOOL_MSG_LINKMODES_GET_REPLY, linkmodes),
+	NLMSG_DESC(ETHTOOL_MSG_LINKMODES_NTF, linkmodes),
+	NLMSG_DESC(ETHTOOL_MSG_LINKSTATE_GET_REPLY, linkstate),
+	NLMSG_DESC(ETHTOOL_MSG_DEBUG_GET_REPLY, debug),
+	NLMSG_DESC(ETHTOOL_MSG_DEBUG_NTF, debug),
+	NLMSG_DESC(ETHTOOL_MSG_WOL_GET_REPLY, wol),
+	NLMSG_DESC(ETHTOOL_MSG_WOL_NTF, wol),
+};
+
+const unsigned int ethnl_kmsg_n_desc = ARRAY_SIZE(ethnl_kmsg_desc);
diff --git a/netlink/prettymsg.h b/netlink/prettymsg.h
index 68ec275a22f6..9d8ca77fd42c 100644
--- a/netlink/prettymsg.h
+++ b/netlink/prettymsg.h
@@ -99,4 +99,11 @@ int pretty_print_genlmsg(const struct nlmsghdr *nlhdr,
 			 const struct pretty_nlmsg_desc *desc,
 			 unsigned int ndesc, unsigned int err_offset);
 
+/* message descriptions */
+
+extern const struct pretty_nlmsg_desc ethnl_umsg_desc[];
+extern const unsigned int ethnl_umsg_n_desc;
+extern const struct pretty_nlmsg_desc ethnl_kmsg_desc[];
+extern const unsigned int ethnl_kmsg_n_desc;
+
 #endif /* ETHTOOL_NETLINK_PRETTYMSG_H__ */
-- 
2.25.1

