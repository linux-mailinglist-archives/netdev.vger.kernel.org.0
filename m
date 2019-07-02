Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCFC55CED7
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfGBLum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:50:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:39170 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727229AbfGBLul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:50:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B5661B11F;
        Tue,  2 Jul 2019 11:50:39 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 5EC38E0159; Tue,  2 Jul 2019 13:50:39 +0200 (CEST)
Message-Id: <6a734345f85fb2010015303ee14941cdeea9559a.1562067622.git.mkubecek@suse.cz>
In-Reply-To: <cover.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 12/15] ethtool: provide link settings and link
 modes in SETTINGS_GET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue,  2 Jul 2019 13:50:39 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement SETTINGS_GET netlink request to get link settings and link mode
information provided by ETHTOOL_GLINKSETTINGS and ETHTOOL_GSET ioctl
commands.

The information in SETTINGS_GET_REPLY message sent as reply is divided into
two parts and client can use info mask in request header to select only
one of them:

  - ETHTOOL_IM_SETTINGS_LINKINFO: physical port, phy MDIO address, MDI(-X)
    status, MDI(-X) control and transceiver
  - ETHTOOL_IM_SETTINGS_LINKMODES: supported and advertised link modes,
    autonegotiation state, link speed and duplex

SETTINGS_GET request can be used with NLM_F_DUMP (and without device
identification) to request the information for all devices in current
network namespace providing the data.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.txt |  48 +++-
 include/linux/ethtool_netlink.h              |   3 +
 include/uapi/linux/ethtool_netlink.h         |  49 ++++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/common.c                         |  48 ++++
 net/ethtool/common.h                         |   4 +
 net/ethtool/ioctl.c                          |  48 ----
 net/ethtool/netlink.c                        |   8 +
 net/ethtool/netlink.h                        |   1 +
 net/ethtool/settings.c                       | 259 +++++++++++++++++++
 10 files changed, 419 insertions(+), 51 deletions(-)
 create mode 100644 net/ethtool/settings.c

diff --git a/Documentation/networking/ethtool-netlink.txt b/Documentation/networking/ethtool-netlink.txt
index 21e5030734aa..1d803488e02c 100644
--- a/Documentation/networking/ethtool-netlink.txt
+++ b/Documentation/networking/ethtool-netlink.txt
@@ -151,10 +151,12 @@ according to message purpose:
 Userspace to kernel:
 
     ETHTOOL_MSG_STRSET_GET		get string set
+    ETHTOOL_MSG_SETTINGS_GET		get device settings
 
 Kernel to userspace:
 
     ETHTOOL_MSG_STRSET_GET_REPLY	string set contents
+    ETHTOOL_MSG_SETTINGS_GET_REPLY	device settings
 
 "GET" requests are sent by userspace applications to retrieve device
 information. They usually do not contain any message specific attributes.
@@ -231,6 +233,48 @@ Flag ETHTOOL_A_STRSET_COUNTS tells kernel to only return string counts of the
 sets, not the actual strings.
 
 
+SETTINGS_GET
+------------
+
+SETTINGS_GET request retrieves information provided by ETHTOOL_GLINKSETTINGS,
+ETHTOOL_GWOL, ETHTOOL_GMSGLVL and ETHTOOL_GLINK ioctl requests. The request
+doesn't use any attributes.
+
+Request attributes:
+
+    ETHTOOL_A_SETTINGS_HEADER		(nested)	request header
+
+Info mask bits meaning:
+
+    ETHTOOL_IM_SETTINGS_LINKINFO	link settings
+    ETHTOOL_IM_SETTINGS_LINKMODES	link modes and related
+
+Response contents:
+
+    ETHTOOL_A_SETTINGS_HEADER		(nested)	reply header
+    ETHTOOL_A_SETTINGS_LINK_INFO	(nested)	link settings
+        ETHTOOL_A_LINKINFO_PORT		    (u8)	    physical port
+        ETHTOOL_A_LINKINFO_PHYADDR	    (u8)	    phy MDIO address
+        ETHTOOL_A_LINKINFO_TP_MDIX	    (u8)	    MDI(-X) status
+        ETHTOOL_A_LINKINFO_TP_MDIX_CTRL	    (u8)	    MDI(-X) control
+        ETHTOOL_A_LINKINFO_TRANSCEIVER	    (u8)	    transceiver
+    ETHTOOL_A_SETTINGS_LINK_MODES	(nested)	link modes
+        ETHTOOL_A_LINKMODES_AUTONEG	    (u8)	    autonegotiation status
+        ETHTOOL_A_LINKMODES_OURS	    (bitset)	    advertised link modes
+        ETHTOOL_A_LINKMODES_PEER	    (bitset)	    partner link modes
+        ETHTOOL_A_LINKMODES_SPEED	    (u32)	    link speed (Mb/s)
+        ETHTOOL_A_LINKMODES_DUPLEX	    (u8)	    duplex mode
+
+Most of the attributes and their values have the same meaning as matching
+members of the corresponding ioctl structures. For ETHTOOL_A_LINKMODES_OURS,
+value represents advertised modes and mask represents supported modes.
+ETHTOOL_A_LINKMODES_PEER in the reply is a bit list.
+
+SETTINGS_GET requests allow dumps and messages in the same format as response
+to them are broadcasted as notifications on change of these settings using
+netlink or ioctl ethtool interface.
+
+
 Request translation
 -------------------
 
@@ -240,7 +284,7 @@ have their netlink replacement yet.
 
 ioctl command			netlink command
 ---------------------------------------------------------------------
-ETHTOOL_GSET			n/a
+ETHTOOL_GSET			ETHTOOL_MSG_SETTINGS_GET
 ETHTOOL_SSET			n/a
 ETHTOOL_GDRVINFO		n/a
 ETHTOOL_GREGS			n/a
@@ -314,7 +358,7 @@ ETHTOOL_GTUNABLE		n/a
 ETHTOOL_STUNABLE		n/a
 ETHTOOL_GPHYSTATS		n/a
 ETHTOOL_PERQUEUE		n/a
-ETHTOOL_GLINKSETTINGS		n/a
+ETHTOOL_GLINKSETTINGS		ETHTOOL_MSG_SETTINGS_GET
 ETHTOOL_SLINKSETTINGS		n/a
 ETHTOOL_PHY_GTUNABLE		n/a
 ETHTOOL_PHY_STUNABLE		n/a
diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 2a15e64a16f3..e770e6e9acca 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -7,6 +7,9 @@
 #include <linux/ethtool.h>
 #include <linux/netdevice.h>
 
+#define __ETHTOOL_LINK_MODE_MASK_NWORDS \
+	DIV_ROUND_UP(__ETHTOOL_LINK_MODE_MASK_NBITS, 32)
+
 enum ethtool_multicast_groups {
 	ETHNL_MCGRP_MONITOR,
 };
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 11b8519d2c1d..a046dd8da50e 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -15,6 +15,7 @@
 enum {
 	ETHTOOL_MSG_USER_NONE,
 	ETHTOOL_MSG_STRSET_GET,
+	ETHTOOL_MSG_SETTINGS_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -25,6 +26,7 @@ enum {
 enum {
 	ETHTOOL_MSG_KERNEL_NONE,
 	ETHTOOL_MSG_STRSET_GET_REPLY,
+	ETHTOOL_MSG_SETTINGS_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -147,6 +149,53 @@ enum {
 
 #define ETHTOOL_RF_STRSET_ALL (ETHTOOL_RF_STRSET_COUNTS)
 
+/* SETTINGS */
+
+enum {
+	ETHTOOL_A_SETTINGS_UNSPEC,
+	ETHTOOL_A_SETTINGS_HEADER,		/* nest - _A_HEADER_* */
+	ETHTOOL_A_SETTINGS_LINK_INFO,		/* nest - _A_LINKINFO_* */
+	ETHTOOL_A_SETTINGS_LINK_MODES,		/* nest - _A_LINKMODES_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_SETTINGS_CNT,
+	ETHTOOL_A_SETTINGS_MAX = (__ETHTOOL_A_SETTINGS_CNT - 1)
+};
+
+#define ETHTOOL_IM_SETTINGS_LINKINFO		(1U << 0)
+#define ETHTOOL_IM_SETTINGS_LINKMODES		(1U << 1)
+
+#define ETHTOOL_IM_SETTINGS_ALL (ETHTOOL_IM_SETTINGS_LINKINFO | \
+				 ETHTOOL_IM_SETTINGS_LINKMODES)
+
+#define ETHTOOL_RF_SETTINGS_ALL 0
+
+enum {
+	ETHTOOL_A_LINKINFO_UNSPEC,
+	ETHTOOL_A_LINKINFO_PORT,		/* u8 */
+	ETHTOOL_A_LINKINFO_PHYADDR,		/* u8 */
+	ETHTOOL_A_LINKINFO_TP_MDIX,		/* u8 */
+	ETHTOOL_A_LINKINFO_TP_MDIX_CTRL,	/* u8 */
+	ETHTOOL_A_LINKINFO_TRANSCEIVER,		/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_LINKINFO_CNT,
+	ETHTOOL_A_LINKINFO_MAX = (__ETHTOOL_A_LINKINFO_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_LINKMODES_UNSPEC,
+	ETHTOOL_A_LINKMODES_AUTONEG,		/* u8 */
+	ETHTOOL_A_LINKMODES_OURS,		/* bitset */
+	ETHTOOL_A_LINKMODES_PEER,		/* bitset */
+	ETHTOOL_A_LINKMODES_SPEED,		/* u32 */
+	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_LINKMODES_CNT,
+	ETHTOOL_A_LINKMODES_MAX = (__ETHTOOL_A_LINKMODES_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 11ceb00821b3..1155e5e9ef69 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -4,4 +4,4 @@ obj-y				+= ioctl.o common.o
 
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
-ethtool_nl-y	:= netlink.o bitset.o strset.o
+ethtool_nl-y	:= netlink.o bitset.o strset.o settings.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index b0ce420e994e..abb00b3a7e77 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -82,3 +82,51 @@ phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_PHY_DOWNSHIFT]	= "phy-downshift",
 	[ETHTOOL_PHY_FAST_LINK_DOWN] = "phy-fast-link-down",
 };
+
+/* return false if legacy contained non-0 deprecated fields
+ * maxtxpkt/maxrxpkt. rest of ksettings always updated
+ */
+bool
+convert_legacy_settings_to_link_ksettings(
+	struct ethtool_link_ksettings *link_ksettings,
+	const struct ethtool_cmd *legacy_settings)
+{
+	bool retval = true;
+
+	memset(link_ksettings, 0, sizeof(*link_ksettings));
+
+	/* This is used to tell users that driver is still using these
+	 * deprecated legacy fields, and they should not use
+	 * %ETHTOOL_GLINKSETTINGS/%ETHTOOL_SLINKSETTINGS
+	 */
+	if (legacy_settings->maxtxpkt ||
+	    legacy_settings->maxrxpkt)
+		retval = false;
+
+	ethtool_convert_legacy_u32_to_link_mode(
+		link_ksettings->link_modes.supported,
+		legacy_settings->supported);
+	ethtool_convert_legacy_u32_to_link_mode(
+		link_ksettings->link_modes.advertising,
+		legacy_settings->advertising);
+	ethtool_convert_legacy_u32_to_link_mode(
+		link_ksettings->link_modes.lp_advertising,
+		legacy_settings->lp_advertising);
+	link_ksettings->base.speed
+		= ethtool_cmd_speed(legacy_settings);
+	link_ksettings->base.duplex
+		= legacy_settings->duplex;
+	link_ksettings->base.port
+		= legacy_settings->port;
+	link_ksettings->base.phy_address
+		= legacy_settings->phy_address;
+	link_ksettings->base.autoneg
+		= legacy_settings->autoneg;
+	link_ksettings->base.mdio_support
+		= legacy_settings->mdio_support;
+	link_ksettings->base.eth_tp_mdix
+		= legacy_settings->eth_tp_mdix;
+	link_ksettings->base.eth_tp_mdix_ctrl
+		= legacy_settings->eth_tp_mdix_ctrl;
+	return retval;
+}
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 41b2efc1e4e1..0381936d8e1e 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -14,4 +14,8 @@ tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN];
 extern const char
 phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN];
 
+bool convert_legacy_settings_to_link_ksettings(
+	struct ethtool_link_ksettings *link_ksettings,
+	const struct ethtool_cmd *legacy_settings);
+
 #endif /* _ETHTOOL_COMMON_H */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index b35366dd9997..ed53e07d619e 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -352,54 +352,6 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 }
 EXPORT_SYMBOL(ethtool_convert_link_mode_to_legacy_u32);
 
-/* return false if legacy contained non-0 deprecated fields
- * maxtxpkt/maxrxpkt. rest of ksettings always updated
- */
-static bool
-convert_legacy_settings_to_link_ksettings(
-	struct ethtool_link_ksettings *link_ksettings,
-	const struct ethtool_cmd *legacy_settings)
-{
-	bool retval = true;
-
-	memset(link_ksettings, 0, sizeof(*link_ksettings));
-
-	/* This is used to tell users that driver is still using these
-	 * deprecated legacy fields, and they should not use
-	 * %ETHTOOL_GLINKSETTINGS/%ETHTOOL_SLINKSETTINGS
-	 */
-	if (legacy_settings->maxtxpkt ||
-	    legacy_settings->maxrxpkt)
-		retval = false;
-
-	ethtool_convert_legacy_u32_to_link_mode(
-		link_ksettings->link_modes.supported,
-		legacy_settings->supported);
-	ethtool_convert_legacy_u32_to_link_mode(
-		link_ksettings->link_modes.advertising,
-		legacy_settings->advertising);
-	ethtool_convert_legacy_u32_to_link_mode(
-		link_ksettings->link_modes.lp_advertising,
-		legacy_settings->lp_advertising);
-	link_ksettings->base.speed
-		= ethtool_cmd_speed(legacy_settings);
-	link_ksettings->base.duplex
-		= legacy_settings->duplex;
-	link_ksettings->base.port
-		= legacy_settings->port;
-	link_ksettings->base.phy_address
-		= legacy_settings->phy_address;
-	link_ksettings->base.autoneg
-		= legacy_settings->autoneg;
-	link_ksettings->base.mdio_support
-		= legacy_settings->mdio_support;
-	link_ksettings->base.eth_tp_mdix
-		= legacy_settings->eth_tp_mdix;
-	link_ksettings->base.eth_tp_mdix_ctrl
-		= legacy_settings->eth_tp_mdix_ctrl;
-	return retval;
-}
-
 /* return false if ksettings link modes had higher bits
  * set. legacy_settings always updated (best effort)
  */
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index cba1f2259248..6c0cfa9001a1 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -280,6 +280,7 @@ struct ethnl_dump_ctx {
 
 static const struct get_request_ops *get_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_STRSET_GET]	= &strset_request_ops,
+	[ETHTOOL_MSG_SETTINGS_GET]	= &settings_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -632,6 +633,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_get_dumpit,
 		.done	= ethnl_get_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_SETTINGS_GET,
+		.doit	= ethnl_get_doit,
+		.start	= ethnl_get_start,
+		.dumpit	= ethnl_get_dumpit,
+		.done	= ethnl_get_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index d85b1edc1b91..27832a3956c8 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -294,5 +294,6 @@ struct get_request_ops {
 /* request handlers */
 
 extern const struct get_request_ops strset_request_ops;
+extern const struct get_request_ops settings_request_ops;
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
diff --git a/net/ethtool/settings.c b/net/ethtool/settings.c
new file mode 100644
index 000000000000..11ec30b9d48b
--- /dev/null
+++ b/net/ethtool/settings.c
@@ -0,0 +1,259 @@
+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+struct settings_data {
+	struct ethnl_req_info		reqinfo_base;
+
+	/* everything below here will be reset for each device in dumps */
+	struct ethnl_reply_data		repdata_base;
+	struct ethtool_link_ksettings	ksettings;
+	struct ethtool_link_settings	*lsettings;
+	bool				lpm_empty;
+};
+
+static const struct nla_policy
+settings_get_policy[ETHTOOL_A_SETTINGS_MAX + 1] = {
+	[ETHTOOL_A_SETTINGS_UNSPEC]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_SETTINGS_HEADER]	= { .type = NLA_NESTED },
+	[ETHTOOL_A_SETTINGS_LINK_INFO]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_SETTINGS_LINK_MODES]	= { .type = NLA_REJECT },
+};
+
+static int ethnl_get_link_ksettings(struct genl_info *info,
+				    struct net_device *dev,
+				    struct ethtool_link_ksettings *ksettings)
+{
+	int ret;
+
+	ret = __ethtool_get_link_ksettings(dev, ksettings);
+
+	if (ret < 0 && info)
+		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
+	return ret;
+}
+
+/* prepare_data() handler */
+static int settings_prepare(struct ethnl_req_info *req_info,
+			    struct genl_info *info)
+{
+	struct settings_data *data =
+		container_of(req_info, struct settings_data, reqinfo_base);
+	struct net_device *dev = data->repdata_base.dev;
+	u32 req_mask = req_info->req_mask;
+	int ret;
+
+	data->lsettings = &data->ksettings.base;
+	data->lpm_empty = true;
+
+	ret = ethnl_before_ops(dev);
+	if (ret < 0)
+		return ret;
+	if (req_mask &
+	    (ETHTOOL_IM_SETTINGS_LINKINFO | ETHTOOL_IM_SETTINGS_LINKMODES)) {
+		ret = ethnl_get_link_ksettings(info, dev, &data->ksettings);
+		if (ret < 0)
+			req_mask &= ~(ETHTOOL_IM_SETTINGS_LINKINFO |
+				      ETHTOOL_IM_SETTINGS_LINKMODES);
+	}
+	if (req_mask & ETHTOOL_IM_SETTINGS_LINKMODES) {
+		data->lpm_empty =
+			bitmap_empty(data->ksettings.link_modes.lp_advertising,
+				     __ETHTOOL_LINK_MODE_MASK_NBITS);
+		ethnl_bitmap_to_u32(data->ksettings.link_modes.supported,
+				    __ETHTOOL_LINK_MODE_MASK_NWORDS);
+		ethnl_bitmap_to_u32(data->ksettings.link_modes.advertising,
+				    __ETHTOOL_LINK_MODE_MASK_NWORDS);
+		ethnl_bitmap_to_u32(data->ksettings.link_modes.lp_advertising,
+				    __ETHTOOL_LINK_MODE_MASK_NWORDS);
+	}
+	ethnl_after_ops(dev);
+
+	data->repdata_base.info_mask = req_mask;
+	if (req_info->req_mask & ~req_mask && info)
+		GENL_SET_ERR_MSG(info,
+				 "not all requested data could be retrieved");
+	return 0;
+}
+
+static int settings_linkinfo_size(void)
+{
+	int len = 0;
+
+	/* port, phyaddr, mdix, mdixctrl, transcvr */
+	len += 5 * nla_total_size(sizeof(u8));
+	/* mdio_support */
+	len += nla_total_size(sizeof(struct nla_bitfield32));
+
+	/* nest */
+	return nla_total_size(len);
+}
+
+static int
+settings_linkmodes_size(const struct ethtool_link_ksettings *ksettings,
+			bool compact)
+{
+	unsigned int flags = compact ? ETHNL_BITSET_COMPACT : 0;
+	u32 *supported = (u32 *)ksettings->link_modes.supported;
+	u32 *advertising = (u32 *)ksettings->link_modes.advertising;
+	u32 *lp_advertising = (u32 *)ksettings->link_modes.lp_advertising;
+	int len = 0, ret;
+
+	/* speed, duplex, autoneg */
+	len += nla_total_size(sizeof(u32)) + 2 * nla_total_size(sizeof(u8));
+	ret = ethnl_bitset32_size(__ETHTOOL_LINK_MODE_MASK_NBITS, advertising,
+				  supported, link_mode_names, flags);
+	if (ret < 0)
+		return ret;
+	len += ret;
+	ret = ethnl_bitset32_size(__ETHTOOL_LINK_MODE_MASK_NBITS,
+				  lp_advertising, NULL, link_mode_names,
+				  flags & ETHNL_BITSET_LIST);
+	if (ret < 0)
+		return ret;
+	len += ret;
+
+	/* nest */
+	return nla_total_size(len);
+}
+
+/* reply_size() handler
+ *
+ * To keep things simple, reserve space for some attributes which may not
+ * be added to the message (e.g. ETHTOOL_A_SETTINGS_SOPASS); therefore the
+ * length returned may be bigger than the actual length of the message sent.
+ */
+static int settings_size(const struct ethnl_req_info *req_info)
+{
+	struct settings_data *data =
+		container_of(req_info, struct settings_data, reqinfo_base);
+	u32 info_mask = data->repdata_base.info_mask;
+	bool compact = req_info->global_flags & ETHTOOL_RF_COMPACT;
+	int len = 0, ret;
+
+	len += ethnl_reply_header_size();
+	if (info_mask & ETHTOOL_IM_SETTINGS_LINKINFO)
+		len += settings_linkinfo_size();
+	if (info_mask & ETHTOOL_IM_SETTINGS_LINKMODES) {
+		ret = settings_linkmodes_size(&data->ksettings, compact);
+		if (ret < 0)
+			return ret;
+		len += ret;
+	}
+
+	return len;
+}
+
+static int settings_fill_linkinfo(struct sk_buff *skb,
+				  const struct ethtool_link_settings *lsettings)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, ETHTOOL_A_SETTINGS_LINK_INFO);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (nla_put_u8(skb, ETHTOOL_A_LINKINFO_PORT, lsettings->port) ||
+	    nla_put_u8(skb, ETHTOOL_A_LINKINFO_PHYADDR,
+		       lsettings->phy_address) ||
+	    nla_put_u8(skb, ETHTOOL_A_LINKINFO_TP_MDIX,
+		       lsettings->eth_tp_mdix) ||
+	    nla_put_u8(skb, ETHTOOL_A_LINKINFO_TP_MDIX_CTRL,
+		       lsettings->eth_tp_mdix_ctrl) ||
+	    nla_put_u8(skb, ETHTOOL_A_LINKINFO_TRANSCEIVER,
+		       lsettings->transceiver)) {
+		nla_nest_cancel(skb, nest);
+		return -EMSGSIZE;
+	}
+
+	nla_nest_end(skb, nest);
+	return 0;
+}
+
+static int
+settings_fill_linkmodes(struct sk_buff *skb,
+			const struct ethtool_link_ksettings *ksettings,
+			bool lpm_empty, bool compact)
+{
+	const u32 *supported = (const u32 *)ksettings->link_modes.supported;
+	const u32 *advertising = (const u32 *)ksettings->link_modes.advertising;
+	const u32 *lp_adv = (const u32 *)ksettings->link_modes.lp_advertising;
+	const unsigned int flags = compact ? ETHNL_BITSET_COMPACT : 0;
+	const struct ethtool_link_settings *lsettings = &ksettings->base;
+	struct nlattr *nest;
+	int ret;
+
+	nest = nla_nest_start(skb, ETHTOOL_A_SETTINGS_LINK_MODES);
+	if (!nest)
+		return -EMSGSIZE;
+	if (nla_put_u8(skb, ETHTOOL_A_LINKMODES_AUTONEG, lsettings->autoneg))
+		goto nla_put_failure;
+
+	ret = ethnl_put_bitset32(skb, ETHTOOL_A_LINKMODES_OURS,
+				 __ETHTOOL_LINK_MODE_MASK_NBITS, advertising,
+				 supported, link_mode_names, flags);
+	if (ret < 0)
+		goto nla_put_failure;
+	if (!lpm_empty) {
+		ret = ethnl_put_bitset32(skb, ETHTOOL_A_LINKMODES_PEER,
+					 __ETHTOOL_LINK_MODE_MASK_NBITS,
+					 lp_adv, NULL, link_mode_names,
+					 flags | ETHNL_BITSET_LIST);
+		if (ret < 0)
+			goto nla_put_failure;
+	}
+
+	if (nla_put_u32(skb, ETHTOOL_A_LINKMODES_SPEED, lsettings->speed) ||
+	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+/* fill_reply() handler */
+static int settings_fill(struct sk_buff *skb,
+			 const struct ethnl_req_info *req_info)
+{
+	const struct settings_data *data =
+		container_of(req_info, struct settings_data, reqinfo_base);
+	u32 info_mask = data->repdata_base.info_mask;
+	bool compact = req_info->global_flags & ETHTOOL_RF_COMPACT;
+	int ret;
+
+	if (info_mask & ETHTOOL_IM_SETTINGS_LINKINFO) {
+		ret = settings_fill_linkinfo(skb, data->lsettings);
+		if (ret < 0)
+			return ret;
+	}
+	if (info_mask & ETHTOOL_IM_SETTINGS_LINKMODES) {
+		ret = settings_fill_linkmodes(skb, &data->ksettings,
+					      data->lpm_empty, compact);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+const struct get_request_ops settings_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_SETTINGS_GET,
+	.reply_cmd		= ETHTOOL_MSG_SETTINGS_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_SETTINGS_HEADER,
+	.max_attr		= ETHTOOL_A_SETTINGS_MAX,
+	.data_size		= sizeof(struct settings_data),
+	.repdata_offset		= offsetof(struct settings_data, repdata_base),
+	.request_policy		= settings_get_policy,
+	.default_infomask	= ETHTOOL_IM_SETTINGS_ALL,
+	.all_reqflags		= ETHTOOL_RF_SETTINGS_ALL,
+
+	.prepare_data		= settings_prepare,
+	.reply_size		= settings_size,
+	.fill_reply		= settings_fill,
+};
-- 
2.22.0

