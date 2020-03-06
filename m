Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAC917C3A4
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCFRG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:06:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:44342 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgCFRG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 12:06:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A00ACB378;
        Fri,  6 Mar 2020 17:05:55 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 4D7F7E00E7; Fri,  6 Mar 2020 18:05:55 +0100 (CET)
Message-Id: <dbf3bb12dd6919936f4ac15bd287dd3911da30b4.1583513281.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583513281.git.mkubecek@suse.cz>
References: <cover.1583513281.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v3 23/25] netlink: message format descriptions for
 genetlink control
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Fri,  6 Mar 2020 18:05:55 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the sake of completeness, add description of genetlink message formats
of GENL_ID_CTRL family. We use this to get the id of "ethtool" genetlink
family and "monitor" multicast group.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Makefile.am             |  2 +-
 netlink/desc-genlctrl.c | 56 +++++++++++++++++++++++++++++++++++++++++
 netlink/prettymsg.h     |  3 +++
 3 files changed, 60 insertions(+), 1 deletion(-)
 create mode 100644 netlink/desc-genlctrl.c

diff --git a/Makefile.am b/Makefile.am
index 5654b273a0a0..8d99315c4b0d 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -31,7 +31,7 @@ ethtool_SOURCES += \
 		  netlink/monitor.c netlink/bitset.c netlink/bitset.h \
 		  netlink/settings.c netlink/parser.c netlink/parser.h \
 		  netlink/permaddr.c netlink/prettymsg.c netlink/prettymsg.h \
-		  netlink/desc-ethtool.c \
+		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  uapi/linux/ethtool_netlink.h \
 		  uapi/linux/netlink.h uapi/linux/genetlink.h \
 		  uapi/linux/rtnetlink.h uapi/linux/if_link.h
diff --git a/netlink/desc-genlctrl.c b/netlink/desc-genlctrl.c
new file mode 100644
index 000000000000..9840179b0a1a
--- /dev/null
+++ b/netlink/desc-genlctrl.c
@@ -0,0 +1,56 @@
+/*
+ * desc-genlctrl.c - genetlink control format descriptions
+ *
+ * Descriptions of genetlink control messages and attributes for pretty print.
+ */
+
+#include <linux/genetlink.h>
+
+#include "../internal.h"
+#include "prettymsg.h"
+
+static const struct pretty_nla_desc __attrop_desc[] = {
+	NLATTR_DESC_INVALID(CTRL_ATTR_OP_UNSPEC),
+	NLATTR_DESC_U32(CTRL_ATTR_OP_ID),
+	NLATTR_DESC_X32(CTRL_ATTR_OP_FLAGS),
+};
+
+static const struct pretty_nla_desc __attrops_desc[] = {
+	NLATTR_DESC_NESTED(0, attrop),
+};
+
+static const struct pretty_nla_desc __mcgrp_desc[] = {
+	NLATTR_DESC_INVALID(CTRL_ATTR_MCAST_GRP_UNSPEC),
+	NLATTR_DESC_STRING(CTRL_ATTR_MCAST_GRP_NAME),
+	NLATTR_DESC_U32(CTRL_ATTR_MCAST_GRP_ID),
+};
+
+static const struct pretty_nla_desc __mcgrps_desc[] = {
+	NLATTR_DESC_NESTED(0, mcgrp),
+};
+
+static const struct pretty_nla_desc __attr_desc[] = {
+	NLATTR_DESC_INVALID(CTRL_ATTR_UNSPEC),
+	NLATTR_DESC_U16(CTRL_ATTR_FAMILY_ID),
+	NLATTR_DESC_STRING(CTRL_ATTR_FAMILY_NAME),
+	NLATTR_DESC_U32(CTRL_ATTR_VERSION),
+	NLATTR_DESC_U32(CTRL_ATTR_HDRSIZE),
+	NLATTR_DESC_U32(CTRL_ATTR_MAXATTR),
+	NLATTR_DESC_ARRAY(CTRL_ATTR_OPS, attrops),
+	NLATTR_DESC_ARRAY(CTRL_ATTR_MCAST_GROUPS, mcgrps),
+};
+
+const struct pretty_nlmsg_desc genlctrl_msg_desc[] = {
+	NLMSG_DESC_INVALID(CTRL_CMD_UNSPEC),
+	NLMSG_DESC(CTRL_CMD_NEWFAMILY, attr),
+	NLMSG_DESC(CTRL_CMD_DELFAMILY, attr),
+	NLMSG_DESC(CTRL_CMD_GETFAMILY, attr),
+	NLMSG_DESC(CTRL_CMD_NEWOPS, attr),
+	NLMSG_DESC(CTRL_CMD_DELOPS, attr),
+	NLMSG_DESC(CTRL_CMD_GETOPS, attr),
+	NLMSG_DESC(CTRL_CMD_NEWMCAST_GRP, attr),
+	NLMSG_DESC(CTRL_CMD_DELMCAST_GRP, attr),
+	NLMSG_DESC(CTRL_CMD_GETMCAST_GRP, attr),
+};
+
+const unsigned int genlctrl_msg_n_desc = ARRAY_SIZE(genlctrl_msg_desc);
diff --git a/netlink/prettymsg.h b/netlink/prettymsg.h
index 9d8ca77fd42c..50d0bbf43665 100644
--- a/netlink/prettymsg.h
+++ b/netlink/prettymsg.h
@@ -106,4 +106,7 @@ extern const unsigned int ethnl_umsg_n_desc;
 extern const struct pretty_nlmsg_desc ethnl_kmsg_desc[];
 extern const unsigned int ethnl_kmsg_n_desc;
 
+extern const struct pretty_nlmsg_desc genlctrl_msg_desc[];
+extern const unsigned int genlctrl_msg_n_desc;
+
 #endif /* ETHTOOL_NETLINK_PRETTYMSG_H__ */
-- 
2.25.1

