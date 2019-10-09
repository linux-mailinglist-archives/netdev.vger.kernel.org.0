Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8074ED1A4C
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 23:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732383AbfJIU7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:59:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:51872 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732357AbfJIU7l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 16:59:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5AC16B273;
        Wed,  9 Oct 2019 20:59:37 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 07A65E3785; Wed,  9 Oct 2019 22:59:37 +0200 (CEST)
Message-Id: <1568f00bf7275f1a872c177e29d5800cd73e50c8.1570654310.git.mkubecek@suse.cz>
In-Reply-To: <cover.1570654310.git.mkubecek@suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v7 12/17] ethtool: provide link settings with
 LINKINFO_GET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Wed,  9 Oct 2019 22:59:37 +0200 (CEST)
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
 include/uapi/linux/ethtool_netlink.h         | 20 ++++
 net/ethtool/Makefile                         |  2 +-
 net/ethtool/common.c                         | 48 ++++++++++
 net/ethtool/common.h                         |  4 +
 net/ethtool/ioctl.c                          | 48 ----------
 net/ethtool/linkinfo.c                       | 97 ++++++++++++++++++++
 net/ethtool/netlink.c                        |  8 ++
 net/ethtool/netlink.h                        |  1 +
 9 files changed, 214 insertions(+), 51 deletions(-)
 create mode 100644 net/ethtool/linkinfo.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d12e0e4f277c..0d21469debec 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -167,12 +167,14 @@ Userspace to kernel:
 
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
@@ -267,6 +269,37 @@ Flag ``ETHTOOL_A_STRSET_COUNTS`` tells kernel to only return string counts of
 the sets, not the actual strings.
 
 
+LINKINFO_GET
+============
+
+Requests link settings as provided by ``ETHTOOL_GLINKSETTINGS`` except for
+link modes and autonegotiation related information. The request does not use
+any attributes and does not have any request specific flags.
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
 
@@ -277,7 +310,7 @@ have their netlink replacement yet.
   =================================== =====================================
   ioctl command                       netlink command
   =================================== =====================================
-  ``ETHTOOL_GSET``                    n/a
+  ``ETHTOOL_GSET``                    ``ETHTOOL_MSG_LINKINFO_GET``
   ``ETHTOOL_SSET``                    n/a
   ``ETHTOOL_GDRVINFO``                n/a
   ``ETHTOOL_GREGS``                   n/a
@@ -351,7 +384,7 @@ have their netlink replacement yet.
   ``ETHTOOL_STUNABLE``                n/a
   ``ETHTOOL_GPHYSTATS``               n/a
   ``ETHTOOL_PERQUEUE``                n/a
-  ``ETHTOOL_GLINKSETTINGS``           n/a
+  ``ETHTOOL_GLINKSETTINGS``           ``ETHTOOL_MSG_LINKINFO_GET``
   ``ETHTOOL_SLINKSETTINGS``           n/a
   ``ETHTOOL_PHY_GTUNABLE``            n/a
   ``ETHTOOL_PHY_STUNABLE``            n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 751d725866df..56ab2a530d22 100644
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
@@ -146,6 +148,24 @@ enum {
 
 #define ETHTOOL_RFLAG_STRSET_ALL (ETHTOOL_RFLAG_STRSET_COUNTS_ONLY)
 
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
+#define ETHTOOL_RFLAG_LINKINFO_ALL 0
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 11ceb00821b3..28666a0eede8 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -4,4 +4,4 @@ obj-y				+= ioctl.o common.o
 
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
-ethtool_nl-y	:= netlink.o bitset.o strset.o
+ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 220d6b539180..84fed2eecb55 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -83,3 +83,51 @@ phy_tunable_strings[__ETHTOOL_PHY_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_PHY_FAST_LINK_DOWN] = "phy-fast-link-down",
 	[ETHTOOL_PHY_EDPD]	= "phy-energy-detect-power-down",
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
index 94307fbba96b..2cd04cb6b4b9 100644
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
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
new file mode 100644
index 000000000000..c28ca4d9dd2a
--- /dev/null
+++ b/net/ethtool/linkinfo.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
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
+/* prepare_data() handler */
+static int linkinfo_prepare(const struct ethnl_req_info *req_base,
+			    struct ethnl_reply_data *reply_base,
+			    struct genl_info *info)
+{
+	struct linkinfo_reply_data *data =
+		container_of(reply_base, struct linkinfo_reply_data, base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	data->lsettings = &data->ksettings.base;
+
+	ret = ethnl_before_ops(dev);
+	if (ret < 0)
+		return ret;
+	ret = __ethtool_get_link_ksettings(dev, &data->ksettings);
+	if (ret < 0 && info)
+		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
+	ethnl_after_ops(dev);
+
+	return ret;
+}
+
+/* reply_size() handler */
+static int linkinfo_size(const struct ethnl_req_info *req_base,
+			 const struct ethnl_reply_data *reply_base)
+{
+	return nla_total_size(sizeof(u8)) /* LINKINFO_PORT */
+		+ nla_total_size(sizeof(u8)) /* LINKINFO_PHYADDR */
+		+ nla_total_size(sizeof(u8)) /* LINKINFO_TP_MDIX */
+		+ nla_total_size(sizeof(u8)) /* LINKINFO_TP_MDIX_CTRL */
+		+ nla_total_size(sizeof(u8)) /* LINKINFO_TRANSCEIVER */
+		+ 0;
+}
+
+/* fill_reply() handler */
+static int linkinfo_fill(struct sk_buff *skb,
+			 const struct ethnl_req_info *req_base,
+			 const struct ethnl_reply_data *reply_base)
+{
+	const struct linkinfo_reply_data *data =
+		container_of(reply_base, struct linkinfo_reply_data, base);
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
+const struct get_request_ops linkinfo_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_LINKINFO_GET,
+	.reply_cmd		= ETHTOOL_MSG_LINKINFO_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_LINKINFO_HEADER,
+	.max_attr		= ETHTOOL_A_LINKINFO_MAX,
+	.req_info_size		= sizeof(struct linkinfo_req_info),
+	.reply_data_size	= sizeof(struct linkinfo_reply_data),
+	.request_policy		= linkinfo_get_policy,
+	.all_reqflags		= ETHTOOL_RFLAG_LINKINFO_ALL,
+
+	.prepare_data		= linkinfo_prepare,
+	.reply_size		= linkinfo_size,
+	.fill_reply		= linkinfo_fill,
+};
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index bc042502115f..47b6aefa0bf9 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -280,6 +280,7 @@ struct ethnl_dump_ctx {
 
 static const struct get_request_ops *get_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_STRSET_GET]	= &strset_request_ops,
+	[ETHTOOL_MSG_LINKINFO_GET]	= &linkinfo_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -620,6 +621,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_get_dumpit,
 		.done	= ethnl_get_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_LINKINFO_GET,
+		.doit	= ethnl_get_doit,
+		.start	= ethnl_get_start,
+		.dumpit	= ethnl_get_dumpit,
+		.done	= ethnl_get_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 07268c916518..a0ae47bebe51 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -347,5 +347,6 @@ struct get_request_ops {
 /* request handlers */
 
 extern const struct get_request_ops strset_request_ops;
+extern const struct get_request_ops linkinfo_request_ops;
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.23.0

