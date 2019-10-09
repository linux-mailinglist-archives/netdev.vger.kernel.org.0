Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43144D1A52
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 23:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732455AbfJIU7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:59:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:52022 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732426AbfJIU7u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 16:59:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6F1ADB277;
        Wed,  9 Oct 2019 20:59:46 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 1BFFCE3785; Wed,  9 Oct 2019 22:59:46 +0200 (CEST)
Message-Id: <2972b39380c7c518f8037cd87a7c4c884947e290.1570654310.git.mkubecek@suse.cz>
In-Reply-To: <cover.1570654310.git.mkubecek@suse.cz>
References: <cover.1570654310.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v7 15/17] ethtool: provide link mode information with
 LINKMODES_GET request
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Wed,  9 Oct 2019 22:59:46 +0200 (CEST)
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
---
 Documentation/networking/ethtool-netlink.rst |  37 +++++
 include/linux/ethtool_netlink.h              |   3 +
 include/uapi/linux/ethtool_netlink.h         |  20 +++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/linkmodes.c                      | 163 +++++++++++++++++++
 net/ethtool/netlink.c                        |   8 +
 net/ethtool/netlink.h                        |   1 +
 7 files changed, 233 insertions(+), 1 deletion(-)
 create mode 100644 net/ethtool/linkmodes.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 48833b6092d9..e04c90ee526e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -169,6 +169,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_STRSET_GET``            get string set
   ``ETHTOOL_MSG_LINKINFO_GET``          get link settings
   ``ETHTOOL_MSG_LINKINFO_SET``          set link settings
+  ``ETHTOOL_MSG_LINKMODES_GET``         get link modes info
   ===================================== ================================
 
 Kernel to userspace:
@@ -177,6 +178,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_STRSET_GET_REPLY``      string set contents
   ``ETHTOOL_MSG_LINKINFO_GET_REPLY``    link settings
   ``ETHTOOL_MSG_LINKINFO_NTF``          link settings notification
+  ``ETHTOOL_MSG_LINKMODES_GET_REPLY``   link modes info
   ===================================== ================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -321,6 +323,39 @@ MDI(-X) status and transceiver cannot be set, request with the corresponding
 attributes is rejected.
 
 
+LINKMODES_GET
+=============
+
+Requests link modes (supported, advertised and peer advertised) and related
+information (autonegotiation status, link speed and duplex) as provided by
+``ETHTOOL_GLINKSETTINGS``. The request does not use any attributes and does
+not have any request specific flags.
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
 
@@ -332,6 +367,7 @@ have their netlink replacement yet.
   ioctl command                       netlink command
   =================================== =====================================
   ``ETHTOOL_GSET``                    ``ETHTOOL_MSG_LINKINFO_GET``
+                                      ``ETHTOOL_MSG_LINKMODES_GET``
   ``ETHTOOL_SSET``                    ``ETHTOOL_MSG_LINKINFO_SET``
   ``ETHTOOL_GDRVINFO``                n/a
   ``ETHTOOL_GREGS``                   n/a
@@ -406,6 +442,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GPHYSTATS``               n/a
   ``ETHTOOL_PERQUEUE``                n/a
   ``ETHTOOL_GLINKSETTINGS``           ``ETHTOOL_MSG_LINKINFO_GET``
+                                      ``ETHTOOL_MSG_LINKMODES_GET``
   ``ETHTOOL_SLINKSETTINGS``           ``ETHTOOL_MSG_LINKINFO_SET``
   ``ETHTOOL_PHY_GTUNABLE``            n/a
   ``ETHTOOL_PHY_STUNABLE``            n/a
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
index 78ee5584d5da..d8ec49aebe48 100644
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
@@ -168,6 +170,24 @@ enum {
 
 #define ETHTOOL_RFLAG_LINKINFO_ALL 0
 
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
+#define ETHTOOL_RFLAG_LINKMODES_ALL 0
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 28666a0eede8..9ae0786c343b 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -4,4 +4,4 @@ obj-y				+= ioctl.o common.o
 
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
-ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o
+ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
new file mode 100644
index 000000000000..3441f29b8e67
--- /dev/null
+++ b/net/ethtool/linkmodes.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
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
+/* prepare_data() handler */
+static int linkmodes_prepare(const struct ethnl_req_info *req_base,
+			     struct ethnl_reply_data *reply_base,
+			     struct genl_info *info)
+{
+	struct linkmodes_reply_data *data =
+		container_of(reply_base, struct linkmodes_reply_data, base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	data->lsettings = &data->ksettings.base;
+
+	ret = ethnl_before_ops(dev);
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
+	ethnl_bitmap_to_u32(data->ksettings.link_modes.supported,
+			    __ETHTOOL_LINK_MODE_MASK_NWORDS);
+	ethnl_bitmap_to_u32(data->ksettings.link_modes.advertising,
+			    __ETHTOOL_LINK_MODE_MASK_NWORDS);
+	ethnl_bitmap_to_u32(data->ksettings.link_modes.lp_advertising,
+			    __ETHTOOL_LINK_MODE_MASK_NWORDS);
+
+out:
+	ethnl_after_ops(dev);
+	return ret;
+}
+
+/* reply_size() handler */
+static int linkmodes_size(const struct ethnl_req_info *req_base,
+			  const struct ethnl_reply_data *reply_base)
+{
+	const struct linkmodes_reply_data *data =
+		container_of(reply_base, struct linkmodes_reply_data, base);
+	const struct ethtool_link_ksettings *ksettings = &data->ksettings;
+	const u32 *advertising;
+	const u32 *supported;
+	const u32 *lp_adv;
+	bool compact;
+	int len, ret;
+
+	supported = (const u32 *)ksettings->link_modes.supported;
+	advertising = (const u32 *)ksettings->link_modes.advertising;
+	lp_adv = (const u32 *)ksettings->link_modes.lp_advertising;
+	compact = req_base->global_flags & ETHTOOL_GFLAG_COMPACT_BITSETS;
+
+	len = nla_total_size(sizeof(u8)) /* LINKMODES_AUTONEG */
+		+ nla_total_size(sizeof(u32)) /* LINKMODES_SPEED */
+		+ nla_total_size(sizeof(u8)) /* LINKMODES_DUPLEX */
+		+ 0;
+	ret = ethnl_bitset32_size(advertising, supported,
+				  __ETHTOOL_LINK_MODE_MASK_NBITS,
+				  link_mode_names, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+	if (!data->peer_empty) {
+		ret = ethnl_bitset32_size(lp_adv, NULL,
+					  __ETHTOOL_LINK_MODE_MASK_NBITS,
+					  link_mode_names, compact);
+		if (ret < 0)
+			return ret;
+		len += ret;
+	}
+
+	return len;
+}
+
+/* fill_reply() handler */
+static int linkmodes_fill(struct sk_buff *skb,
+			  const struct ethnl_req_info *req_base,
+			  const struct ethnl_reply_data *reply_base)
+{
+	const struct linkmodes_reply_data *data =
+		container_of(reply_base, struct linkmodes_reply_data, base);
+	const struct ethtool_link_ksettings *ksettings = &data->ksettings;
+	const struct ethtool_link_settings *lsettings = &ksettings->base;
+	const u32 *advertising;
+	const u32 *supported;
+	const u32 *lp_adv;
+	bool compact;
+	int ret;
+
+	supported = (const u32 *)ksettings->link_modes.supported;
+	advertising = (const u32 *)ksettings->link_modes.advertising;
+	lp_adv = (const u32 *)ksettings->link_modes.lp_advertising;
+	compact = req_base->global_flags & ETHTOOL_GFLAG_COMPACT_BITSETS;
+
+	if (nla_put_u8(skb, ETHTOOL_A_LINKMODES_AUTONEG, lsettings->autoneg))
+		return -EMSGSIZE;
+
+	ret = ethnl_put_bitset32(skb, ETHTOOL_A_LINKMODES_OURS, advertising,
+				 supported, __ETHTOOL_LINK_MODE_MASK_NBITS,
+				 link_mode_names, compact);
+	if (ret < 0)
+		return -EMSGSIZE;
+	if (!data->peer_empty) {
+		ret = ethnl_put_bitset32(skb, ETHTOOL_A_LINKMODES_PEER,
+					 lp_adv, NULL,
+					 __ETHTOOL_LINK_MODE_MASK_NBITS,
+					 link_mode_names, compact);
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
+const struct get_request_ops linkmodes_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_LINKMODES_GET,
+	.reply_cmd		= ETHTOOL_MSG_LINKMODES_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_LINKMODES_HEADER,
+	.max_attr		= ETHTOOL_A_LINKMODES_MAX,
+	.req_info_size		= sizeof(struct linkmodes_req_info),
+	.reply_data_size	= sizeof(struct linkmodes_reply_data),
+	.request_policy		= linkmodes_get_policy,
+	.all_reqflags		= ETHTOOL_RFLAG_LINKMODES_ALL,
+
+	.prepare_data		= linkmodes_prepare,
+	.reply_size		= linkmodes_size,
+	.fill_reply		= linkmodes_fill,
+};
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 5b9d12656e97..73d990b4d5c1 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -294,6 +294,7 @@ struct ethnl_dump_ctx {
 static const struct get_request_ops *get_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_STRSET_GET]	= &strset_request_ops,
 	[ETHTOOL_MSG_LINKINFO_GET]	= &linkinfo_request_ops,
+	[ETHTOOL_MSG_LINKMODES_GET]	= &linkmodes_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -728,6 +729,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_linkinfo,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_LINKMODES_GET,
+		.doit	= ethnl_get_doit,
+		.start	= ethnl_get_start,
+		.dumpit	= ethnl_get_dumpit,
+		.done	= ethnl_get_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index ca136dd7ea02..b330b29fe927 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -349,6 +349,7 @@ struct get_request_ops {
 
 extern const struct get_request_ops strset_request_ops;
 extern const struct get_request_ops linkinfo_request_ops;
+extern const struct get_request_ops linkmodes_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 
-- 
2.23.0

