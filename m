Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 059961799C6
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388386AbgCDU0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:26:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:33954 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387926AbgCDU0e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:26:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E78EDB2BC;
        Wed,  4 Mar 2020 20:26:31 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 94421E037F; Wed,  4 Mar 2020 21:26:31 +0100 (CET)
Message-Id: <e88468e54a57e2f6af207d14bcf3c529f7d341d8.1583347351.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 23/25] netlink: message format descriptions for
 genetlink control
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed,  4 Mar 2020 21:26:31 +0100 (CET)
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
index adbe5bc52b4b..74143b727c4f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -32,7 +32,7 @@ ethtool_SOURCES += \
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

