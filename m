Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB7A12B567
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 15:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfL0O4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 09:56:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:42940 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbfL0O4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 09:56:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ABA16ACA7;
        Fri, 27 Dec 2019 14:56:08 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 5C230E008A; Fri, 27 Dec 2019 15:56:08 +0100 (CET)
Message-Id: <800c849d83874c48f787eb30b240d1063481f059.1577457846.git.mkubecek@suse.cz>
In-Reply-To: <cover.1577457846.git.mkubecek@suse.cz>
References: <cover.1577457846.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v9 11/14] ethtool: provide link mode information with
 LINKMODES_GET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Dec 2019 15:56:08 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement LINKMODES_GET netlink request to get link modes related
information provided by ETHTOOL_GLINKSETTINGS and ETHTOOL_GSET ioctl
commands.

This request provides supported, advertised and peer advertised link modes,
autonegotiation flag, speed and duplex.

LINKMODES_GET request can be used with NLM_F_DUMP (without device
identification) to request the information for all devices in current
network namespace providing the data.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/ethtool-netlink.rst |  36 +++++
 include/linux/ethtool_netlink.h              |   3 +
 include/uapi/linux/ethtool_netlink.h         |  18 +++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/linkmodes.c                      | 140 +++++++++++++++++++
 net/ethtool/netlink.c                        |   8 ++
 net/ethtool/netlink.h                        |   1 +
 7 files changed, 207 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/linkmodes.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 34254482d295..04c55be0264c 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -182,6 +182,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_STRSET_GET``            get string set
   ``ETHTOOL_MSG_LINKINFO_GET``          get link settings
   ``ETHTOOL_MSG_LINKINFO_SET``          set link settings
+  ``ETHTOOL_MSG_LINKMODES_GET``         get link modes info
   ===================================== ================================
 
 Kernel to userspace:
@@ -190,6 +191,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_STRSET_GET_REPLY``      string set contents
   ``ETHTOOL_MSG_LINKINFO_GET_REPLY``    link settings
   ``ETHTOOL_MSG_LINKINFO_NTF``          link settings notification
+  ``ETHTOOL_MSG_LINKMODES_GET_REPLY``   link modes info
   ===================================== ================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -332,6 +334,38 @@ MDI(-X) status and transceiver cannot be set, request with the corresponding
 attributes is rejected.
 
 
+LINKMODES_GET
+=============
+
+Requests link modes (supported, advertised and peer advertised) and related
+information (autonegotiation status, link speed and duplex) as provided by
+``ETHTOOL_GLINKSETTINGS``. The request does not use any attributes.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_LINKMODES_HEADER``        nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_LINKMODES_HEADER``        nested  reply header
+  ``ETHTOOL_A_LINKMODES_AUTONEG``       u8      autonegotiation status
+  ``ETHTOOL_A_LINKMODES_OURS``          bitset  advertised link modes
+  ``ETHTOOL_A_LINKMODES_PEER``          bitset  partner link modes
+  ``ETHTOOL_A_LINKMODES_SPEED``         u32     link speed (Mb/s)
+  ``ETHTOOL_A_LINKMODES_DUPLEX``        u8      duplex mode
+  ====================================  ======  ==========================
+
+For ``ETHTOOL_A_LINKMODES_OURS``, value represents advertised modes and mask
+represents supported modes. ``ETHTOOL_A_LINKMODES_PEER`` in the reply is a bit
+list.
+
+``LINKMODES_GET`` allows dump requests (kernel returns reply messages for all
+devices supporting the request).
+
+
 Request translation
 ===================
 
@@ -343,6 +377,7 @@ have their netlink replacement yet.
   ioctl command                       netlink command
   =================================== =====================================
   ``ETHTOOL_GSET``                    ``ETHTOOL_MSG_LINKINFO_GET``
+                                      ``ETHTOOL_MSG_LINKMODES_GET``
   ``ETHTOOL_SSET``                    ``ETHTOOL_MSG_LINKINFO_SET``
   ``ETHTOOL_GDRVINFO``                n/a
   ``ETHTOOL_GREGS``                   n/a
@@ -417,6 +452,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GPHYSTATS``               n/a
   ``ETHTOOL_PERQUEUE``                n/a
   ``ETHTOOL_GLINKSETTINGS``           ``ETHTOOL_MSG_LINKINFO_GET``
+                                      ``ETHTOOL_MSG_LINKMODES_GET``
   ``ETHTOOL_SLINKSETTINGS``           ``ETHTOOL_MSG_LINKINFO_SET``
   ``ETHTOOL_PHY_GTUNABLE``            n/a
   ``ETHTOOL_PHY_STUNABLE``            n/a
diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index c98f6852c8eb..d01b77887f82 100644
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
index d530fa30de36..dc1cae052eee 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -17,6 +17,7 @@ enum {
 	ETHTOOL_MSG_STRSET_GET,
 	ETHTOOL_MSG_LINKINFO_GET,
 	ETHTOOL_MSG_LINKINFO_SET,
+	ETHTOOL_MSG_LINKMODES_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -29,6 +30,7 @@ enum {
 	ETHTOOL_MSG_STRSET_GET_REPLY,
 	ETHTOOL_MSG_LINKINFO_GET_REPLY,
 	ETHTOOL_MSG_LINKINFO_NTF,
+	ETHTOOL_MSG_LINKMODES_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -161,6 +163,22 @@ enum {
 	ETHTOOL_A_LINKINFO_MAX = __ETHTOOL_A_LINKINFO_CNT - 1
 };
 
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
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 765736ec52c0..8023da6672ce 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -4,4 +4,4 @@ obj-y				+= ioctl.o common.o
 
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
-ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o
+ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
new file mode 100644
index 000000000000..81856fa1e632
--- /dev/null
+++ b/net/ethtool/linkmodes.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+struct linkmodes_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct linkmodes_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_link_ksettings	ksettings;
+	struct ethtool_link_settings	*lsettings;
+	bool				peer_empty;
+};
+
+#define LINKMODES_REPDATA(__reply_base) \
+	container_of(__reply_base, struct linkmodes_reply_data, base)
+
+static const struct nla_policy
+linkmodes_get_policy[ETHTOOL_A_LINKMODES_MAX + 1] = {
+	[ETHTOOL_A_LINKMODES_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKMODES_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_LINKMODES_AUTONEG]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKMODES_OURS]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKMODES_PEER]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKMODES_SPEED]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_LINKMODES_DUPLEX]		= { .type = NLA_REJECT },
+};
+
+static int linkmodes_prepare_data(const struct ethnl_req_info *req_base,
+				  struct ethnl_reply_data *reply_base,
+				  struct genl_info *info)
+{
+	struct linkmodes_reply_data *data = LINKMODES_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	data->lsettings = &data->ksettings.base;
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	ret = __ethtool_get_link_ksettings(dev, &data->ksettings);
+	if (ret < 0 && info) {
+		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
+		goto out;
+	}
+
+	data->peer_empty =
+		bitmap_empty(data->ksettings.link_modes.lp_advertising,
+			     __ETHTOOL_LINK_MODE_MASK_NBITS);
+
+out:
+	ethnl_ops_complete(dev);
+	return ret;
+}
+
+static int linkmodes_reply_size(const struct ethnl_req_info *req_base,
+				const struct ethnl_reply_data *reply_base)
+{
+	const struct linkmodes_reply_data *data = LINKMODES_REPDATA(reply_base);
+	const struct ethtool_link_ksettings *ksettings = &data->ksettings;
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	int len, ret;
+
+	len = nla_total_size(sizeof(u8)) /* LINKMODES_AUTONEG */
+		+ nla_total_size(sizeof(u32)) /* LINKMODES_SPEED */
+		+ nla_total_size(sizeof(u8)) /* LINKMODES_DUPLEX */
+		+ 0;
+	ret = ethnl_bitset_size(ksettings->link_modes.advertising,
+				ksettings->link_modes.supported,
+				__ETHTOOL_LINK_MODE_MASK_NBITS,
+				link_mode_names, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+	if (!data->peer_empty) {
+		ret = ethnl_bitset_size(ksettings->link_modes.lp_advertising,
+					NULL, __ETHTOOL_LINK_MODE_MASK_NBITS,
+					link_mode_names, compact);
+		if (ret < 0)
+			return ret;
+		len += ret;
+	}
+
+	return len;
+}
+
+static int linkmodes_fill_reply(struct sk_buff *skb,
+				const struct ethnl_req_info *req_base,
+				const struct ethnl_reply_data *reply_base)
+{
+	const struct linkmodes_reply_data *data = LINKMODES_REPDATA(reply_base);
+	const struct ethtool_link_ksettings *ksettings = &data->ksettings;
+	const struct ethtool_link_settings *lsettings = &ksettings->base;
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	int ret;
+
+	if (nla_put_u8(skb, ETHTOOL_A_LINKMODES_AUTONEG, lsettings->autoneg))
+		return -EMSGSIZE;
+
+	ret = ethnl_put_bitset(skb, ETHTOOL_A_LINKMODES_OURS,
+			       ksettings->link_modes.advertising,
+			       ksettings->link_modes.supported,
+			       __ETHTOOL_LINK_MODE_MASK_NBITS, link_mode_names,
+			       compact);
+	if (ret < 0)
+		return -EMSGSIZE;
+	if (!data->peer_empty) {
+		ret = ethnl_put_bitset(skb, ETHTOOL_A_LINKMODES_PEER,
+				       ksettings->link_modes.lp_advertising,
+				       NULL, __ETHTOOL_LINK_MODE_MASK_NBITS,
+				       link_mode_names, compact);
+		if (ret < 0)
+			return -EMSGSIZE;
+	}
+
+	if (nla_put_u32(skb, ETHTOOL_A_LINKMODES_SPEED, lsettings->speed) ||
+	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_linkmodes_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_LINKMODES_GET,
+	.reply_cmd		= ETHTOOL_MSG_LINKMODES_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_LINKMODES_HEADER,
+	.max_attr		= ETHTOOL_A_LINKMODES_MAX,
+	.req_info_size		= sizeof(struct linkmodes_req_info),
+	.reply_data_size	= sizeof(struct linkmodes_reply_data),
+	.request_policy		= linkmodes_get_policy,
+
+	.prepare_data		= linkmodes_prepare_data,
+	.reply_size		= linkmodes_reply_size,
+	.fill_reply		= linkmodes_fill_reply,
+};
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 942da4ebdfe9..703ff3a227a4 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -209,6 +209,7 @@ static const struct ethnl_request_ops *
 ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_STRSET_GET]	= &ethnl_strset_request_ops,
 	[ETHTOOL_MSG_LINKINFO_GET]	= &ethnl_linkinfo_request_ops,
+	[ETHTOOL_MSG_LINKMODES_GET]	= &ethnl_linkmodes_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -630,6 +631,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_linkinfo,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_LINKMODES_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 5d56d7779a06..256d38972d1e 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -332,6 +332,7 @@ struct ethnl_request_ops {
 
 extern const struct ethnl_request_ops ethnl_strset_request_ops;
 extern const struct ethnl_request_ops ethnl_linkinfo_request_ops;
+extern const struct ethnl_request_ops ethnl_linkmodes_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 
-- 
2.24.1

