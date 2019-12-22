Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE13612905C
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 00:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfLVXpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 18:45:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:55376 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbfLVXpw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Dec 2019 18:45:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8D955AFD4;
        Sun, 22 Dec 2019 23:45:49 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 36527E03A8; Mon, 23 Dec 2019 00:45:49 +0100 (CET)
Message-Id: <f81ea527fcdaefeaea7993afd69e44f43d3d2d2b.1577052887.git.mkubecek@suse.cz>
In-Reply-To: <cover.1577052887.git.mkubecek@suse.cz>
References: <cover.1577052887.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v8 07/14] ethtool: provide link settings with
 LINKINFO_GET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Dec 2019 00:45:49 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement LINKINFO_GET netlink request to get basic link settings provided
by ETHTOOL_GLINKSETTINGS and ETHTOOL_GSET ioctl commands.

This request provides settings not directly related to autonegotiation and
link mode selection: physical port, phy MDIO address, MDI(-X) status,
MDI(-X) control and transceiver.

LINKINFO_GET request can be used with NLM_F_DUMP (without device
identification) to request the information for all devices in current
network namespace providing the data.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 37 +++++++-
 include/uapi/linux/ethtool_netlink.h         | 18 ++++
 net/ethtool/Makefile                         |  2 +-
 net/ethtool/common.c                         | 48 ++++++++++
 net/ethtool/common.h                         |  4 +
 net/ethtool/ioctl.c                          | 48 ----------
 net/ethtool/linkinfo.c                       | 94 ++++++++++++++++++++
 net/ethtool/netlink.c                        |  8 ++
 net/ethtool/netlink.h                        |  1 +
 9 files changed, 209 insertions(+), 51 deletions(-)
 create mode 100644 net/ethtool/linkinfo.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index afe0ee2ba138..3460d6e31b82 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -170,12 +170,14 @@ Userspace to kernel:
 
   ===================================== ================================
   ``ETHTOOL_MSG_STRSET_GET``            get string set
+  ``ETHTOOL_MSG_LINKINFO_GET``          get link settings
   ===================================== ================================
 
 Kernel to userspace:
 
   ===================================== ================================
   ``ETHTOOL_MSG_STRSET_GET_REPLY``      string set contents
+  ``ETHTOOL_MSG_LINKINFO_GET_REPLY``    link settings
   ===================================== ================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -268,6 +270,37 @@ Flag ``ETHTOOL_A_STRSET_COUNTS_ONLY`` tells kernel to only return string
 counts of the sets, not the actual strings.
 
 
+LINKINFO_GET
+============
+
+Requests link settings as provided by ``ETHTOOL_GLINKSETTINGS`` except for
+link modes and autonegotiation related information. The request does not use
+any attributes.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_LINKINFO_HEADER``         nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_LINKINFO_HEADER``         nested  reply header
+  ``ETHTOOL_A_LINKINFO_PORT``           u8      physical port
+  ``ETHTOOL_A_LINKINFO_PHYADDR``        u8      phy MDIO address
+  ``ETHTOOL_A_LINKINFO_TP_MDIX``        u8      MDI(-X) status
+  ``ETHTOOL_A_LINKINFO_TP_MDIX_CTRL``   u8      MDI(-X) control
+  ``ETHTOOL_A_LINKINFO_TRANSCEIVER``    u8      transceiver
+  ====================================  ======  ==========================
+
+Attributes and their values have the same meaning as matching members of the
+corresponding ioctl structures.
+
+``LINKINFO_GET`` allows dump requests (kernel returns reply message for all
+devices supporting the request).
+
+
 Request translation
 ===================
 
@@ -278,7 +311,7 @@ have their netlink replacement yet.
   =================================== =====================================
   ioctl command                       netlink command
   =================================== =====================================
-  ``ETHTOOL_GSET``                    n/a
+  ``ETHTOOL_GSET``                    ``ETHTOOL_MSG_LINKINFO_GET``
   ``ETHTOOL_SSET``                    n/a
   ``ETHTOOL_GDRVINFO``                n/a
   ``ETHTOOL_GREGS``                   n/a
@@ -352,7 +385,7 @@ have their netlink replacement yet.
   ``ETHTOOL_STUNABLE``                n/a
   ``ETHTOOL_GPHYSTATS``               n/a
   ``ETHTOOL_PERQUEUE``                n/a
-  ``ETHTOOL_GLINKSETTINGS``           n/a
+  ``ETHTOOL_GLINKSETTINGS``           ``ETHTOOL_MSG_LINKINFO_GET``
   ``ETHTOOL_SLINKSETTINGS``           n/a
   ``ETHTOOL_PHY_GTUNABLE``            n/a
   ``ETHTOOL_PHY_STUNABLE``            n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index cabef1fec42a..1966532993e5 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -15,6 +15,7 @@
 enum {
 	ETHTOOL_MSG_USER_NONE,
 	ETHTOOL_MSG_STRSET_GET,
+	ETHTOOL_MSG_LINKINFO_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -25,6 +26,7 @@ enum {
 enum {
 	ETHTOOL_MSG_KERNEL_NONE,
 	ETHTOOL_MSG_STRSET_GET_REPLY,
+	ETHTOOL_MSG_LINKINFO_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -141,6 +143,22 @@ enum {
 	ETHTOOL_A_STRSET_MAX = __ETHTOOL_A_STRSET_CNT - 1
 };
 
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
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index efcc42c34d62..765736ec52c0 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -4,4 +4,4 @@ obj-y				+= ioctl.o common.o
 
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
-ethtool_nl-y	:= netlink.o bitset.o strset.o
+ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 0a8728565356..1d4a0aeff2cb 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -169,3 +169,51 @@ const char link_mode_names[][ETH_GSTRING_LEN] = {
 	__DEFINE_LINK_MODE_NAME(400000, CR8, Full),
 };
 static_assert(ARRAY_SIZE(link_mode_names) == __ETHTOOL_LINK_MODE_MASK_NBITS);
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
index bbb788908cb1..c8a237402729 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -19,4 +19,8 @@ extern const char
 phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN];
 extern const char link_mode_names[][ETH_GSTRING_LEN];
 
+bool convert_legacy_settings_to_link_ksettings(
+	struct ethtool_link_ksettings *link_ksettings,
+	const struct ethtool_cmd *legacy_settings);
+
 #endif /* _ETHTOOL_COMMON_H */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index aed2c2cf1623..eca7462e6263 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -358,54 +358,6 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
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
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
new file mode 100644
index 000000000000..f52a31af6fff
--- /dev/null
+++ b/net/ethtool/linkinfo.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+
+struct linkinfo_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct linkinfo_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_link_ksettings	ksettings;
+	struct ethtool_link_settings	*lsettings;
+};
+
+#define LINKINFO_REPDATA(__reply_base) \
+	container_of(__reply_base, struct linkinfo_reply_data, base)
+
+static const struct nla_policy
+linkinfo_get_policy[ETHTOOL_A_LINKINFO_MAX + 1] = {
+	[ETHTOOL_A_LINKINFO_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKINFO_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKINFO_PORT]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKINFO_PHYADDR]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKINFO_TP_MDIX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKINFO_TP_MDIX_CTRL]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKINFO_TRANSCEIVER]	= { .type = NLA_REJECT },
+};
+
+static int linkinfo_prepare_data(const struct ethnl_req_info *req_base,
+				 struct ethnl_reply_data *reply_base,
+				 struct genl_info *info)
+{
+	struct linkinfo_reply_data *data = LINKINFO_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	data->lsettings = &data->ksettings.base;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+	ret = __ethtool_get_link_ksettings(dev, &data->ksettings);
+	if (ret < 0 && info)
+		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
+	ethnl_ops_complete(dev);
+
+	return ret;
+}
+
+static int linkinfo_reply_size(const struct ethnl_req_info *req_base,
+			       const struct ethnl_reply_data *reply_base)
+{
+	return nla_total_size(sizeof(u8)) /* LINKINFO_PORT */
+		+ nla_total_size(sizeof(u8)) /* LINKINFO_PHYADDR */
+		+ nla_total_size(sizeof(u8)) /* LINKINFO_TP_MDIX */
+		+ nla_total_size(sizeof(u8)) /* LINKINFO_TP_MDIX_CTRL */
+		+ nla_total_size(sizeof(u8)) /* LINKINFO_TRANSCEIVER */
+		+ 0;
+}
+
+static int linkinfo_fill_reply(struct sk_buff *skb,
+			       const struct ethnl_req_info *req_base,
+			       const struct ethnl_reply_data *reply_base)
+{
+	const struct linkinfo_reply_data *data = LINKINFO_REPDATA(reply_base);
+
+	if (nla_put_u8(skb, ETHTOOL_A_LINKINFO_PORT, data->lsettings->port) ||
+	    nla_put_u8(skb, ETHTOOL_A_LINKINFO_PHYADDR,
+		       data->lsettings->phy_address) ||
+	    nla_put_u8(skb, ETHTOOL_A_LINKINFO_TP_MDIX,
+		       data->lsettings->eth_tp_mdix) ||
+	    nla_put_u8(skb, ETHTOOL_A_LINKINFO_TP_MDIX_CTRL,
+		       data->lsettings->eth_tp_mdix_ctrl) ||
+	    nla_put_u8(skb, ETHTOOL_A_LINKINFO_TRANSCEIVER,
+		       data->lsettings->transceiver))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_linkinfo_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_LINKINFO_GET,
+	.reply_cmd		= ETHTOOL_MSG_LINKINFO_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_LINKINFO_HEADER,
+	.max_attr		= ETHTOOL_A_LINKINFO_MAX,
+	.req_info_size		= sizeof(struct linkinfo_req_info),
+	.reply_data_size	= sizeof(struct linkinfo_reply_data),
+	.request_policy		= linkinfo_get_policy,
+
+	.prepare_data		= linkinfo_prepare_data,
+	.reply_size		= linkinfo_reply_size,
+	.fill_reply		= linkinfo_fill_reply,
+};
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 7dc082bde670..ce86d97c922e 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -195,6 +195,7 @@ struct ethnl_dump_ctx {
 static const struct ethnl_request_ops *
 ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_STRSET_GET]	= &ethnl_strset_request_ops,
+	[ETHTOOL_MSG_LINKINFO_GET]	= &ethnl_linkinfo_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -526,6 +527,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_LINKINFO_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index c11b31dffd14..b2f4a49ae837 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -329,5 +329,6 @@ struct ethnl_request_ops {
 /* request handlers */
 
 extern const struct ethnl_request_ops ethnl_strset_request_ops;
+extern const struct ethnl_request_ops ethnl_linkinfo_request_ops;
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.24.1

