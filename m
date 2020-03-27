Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F891194DD0
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 01:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgC0AMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 20:12:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:42594 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbgC0AMQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 20:12:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3C884B1E8;
        Fri, 27 Mar 2020 00:12:13 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id DF73AE00A5; Fri, 27 Mar 2020 01:12:12 +0100 (CET)
Message-Id: <6afd817607ac0e4f631611889268d550c2feda73.1585267388.git.mkubecek@suse.cz>
In-Reply-To: <cover.1585267388.git.mkubecek@suse.cz>
References: <cover.1585267388.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 05/12] ethtool: provide pause parameters with
 PAUSE_GET request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Mar 2020 01:12:12 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement PAUSE_GET request to get pause parameters of a network device.
These are traditionally available via ETHTOOL_GPAUSEPARAM ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 40 +++++++++-
 include/uapi/linux/ethtool_netlink.h         | 16 ++++
 net/ethtool/Makefile                         |  2 +-
 net/ethtool/netlink.c                        |  8 ++
 net/ethtool/netlink.h                        |  1 +
 net/ethtool/pause.c                          | 81 ++++++++++++++++++++
 6 files changed, 146 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/pause.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d4be0a63786d..43c7baf36b32 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -199,6 +199,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_CHANNELS_SET``          set channel counts
   ``ETHTOOL_MSG_COALESCE_GET``          get coalescing parameters
   ``ETHTOOL_MSG_COALESCE_SET``          set coalescing parameters
+  ``ETHTOOL_MSG_PAUSE_GET``             get pause parameters
   ===================================== ================================
 
 Kernel to userspace:
@@ -225,6 +226,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_CHANNELS_NTF``          channel counts
   ``ETHTOOL_MSG_COALESCE_GET_REPLY``    coalescing parameters
   ``ETHTOOL_MSG_COALESCE_NTF``          coalescing parameters
+  ``ETHTOOL_MSG_PAUSE_GET_REPLY``       pause parameters
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -832,6 +834,42 @@ is not set), regardless of their values. Driver may impose additional
 constraints on coalescing parameters and their values.
 
 
+PAUSE_GET
+============
+
+Gets channel counts like ``ETHTOOL_GPAUSE`` ioctl request.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_PAUSE_HEADER``             nested  request header
+  =====================================  ======  ==========================
+
+Kernel response contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_PAUSE_HEADER``             nested  request header
+  ``ETHTOOL_A_PAUSE_AUTONEG``            bool    pause autonegotiation
+  ``ETHTOOL_A_PAUSE_RX``                 bool    receive pause frames
+  ``ETHTOOL_A_PAUSE_TX``                 bool    transmit pause frames
+  =====================================  ======  ==========================
+
+
+PAUSE_SET
+============
+
+Sets pause parameters like ``ETHTOOL_GPAUSEPARAM`` ioctl request.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_PAUSE_HEADER``             nested  request header
+  ``ETHTOOL_A_PAUSE_AUTONEG``            bool    pause autonegotiation
+  ``ETHTOOL_A_PAUSE_RX``                 bool    receive pause frames
+  ``ETHTOOL_A_PAUSE_TX``                 bool    transmit pause frames
+  =====================================  ======  ==========================
+
+
 Request translation
 ===================
 
@@ -860,7 +898,7 @@ have their netlink replacement yet.
   ``ETHTOOL_SCOALESCE``               ``ETHTOOL_MSG_COALESCE_SET``
   ``ETHTOOL_GRINGPARAM``              ``ETHTOOL_MSG_RINGS_GET``
   ``ETHTOOL_SRINGPARAM``              ``ETHTOOL_MSG_RINGS_SET``
-  ``ETHTOOL_GPAUSEPARAM``             n/a
+  ``ETHTOOL_GPAUSEPARAM``             ``ETHTOOL_MSG_PAUSE_GET``
   ``ETHTOOL_SPAUSEPARAM``             n/a
   ``ETHTOOL_GRXCSUM``                 ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SRXCSUM``                 ``ETHTOOL_MSG_FEATURES_SET``
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index fdbcaf76df1e..1c8d1228f63f 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -34,6 +34,7 @@ enum {
 	ETHTOOL_MSG_CHANNELS_SET,
 	ETHTOOL_MSG_COALESCE_GET,
 	ETHTOOL_MSG_COALESCE_SET,
+	ETHTOOL_MSG_PAUSE_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -64,6 +65,7 @@ enum {
 	ETHTOOL_MSG_CHANNELS_NTF,
 	ETHTOOL_MSG_COALESCE_GET_REPLY,
 	ETHTOOL_MSG_COALESCE_NTF,
+	ETHTOOL_MSG_PAUSE_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -347,6 +349,20 @@ enum {
 	ETHTOOL_A_COALESCE_MAX = (__ETHTOOL_A_COALESCE_CNT - 1)
 };
 
+/* PAUSE */
+
+enum {
+	ETHTOOL_A_PAUSE_UNSPEC,
+	ETHTOOL_A_PAUSE_HEADER,				/* nest - _A_HEADER_* */
+	ETHTOOL_A_PAUSE_AUTONEG,			/* u8 */
+	ETHTOOL_A_PAUSE_RX,				/* u8 */
+	ETHTOOL_A_PAUSE_TX,				/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_PAUSE_CNT,
+	ETHTOOL_A_PAUSE_MAX = (__ETHTOOL_A_PAUSE_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 7f7f40e03d16..28589ad5fd8a 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -6,4 +6,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
-		   channels.o coalesce.o
+		   channels.o coalesce.o pause.o
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 117971e695ca..ca1695de8c9d 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -228,6 +228,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_RINGS_GET]		= &ethnl_rings_request_ops,
 	[ETHTOOL_MSG_CHANNELS_GET]	= &ethnl_channels_request_ops,
 	[ETHTOOL_MSG_COALESCE_GET]	= &ethnl_coalesce_request_ops,
+	[ETHTOOL_MSG_PAUSE_GET]		= &ethnl_pause_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -801,6 +802,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_coalesce,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_PAUSE_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index c3fb4fe5a3b7..e14ac089bfb1 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -342,6 +342,7 @@ extern const struct ethnl_request_ops ethnl_privflags_request_ops;
 extern const struct ethnl_request_ops ethnl_rings_request_ops;
 extern const struct ethnl_request_ops ethnl_channels_request_ops;
 extern const struct ethnl_request_ops ethnl_coalesce_request_ops;
+extern const struct ethnl_request_ops ethnl_pause_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
new file mode 100644
index 000000000000..9feafeb7bb1c
--- /dev/null
+++ b/net/ethtool/pause.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+
+struct pause_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct pause_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_pauseparam	pauseparam;
+};
+
+#define PAUSE_REPDATA(__reply_base) \
+	container_of(__reply_base, struct pause_reply_data, base)
+
+static const struct nla_policy
+pause_get_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
+	[ETHTOOL_A_PAUSE_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_PAUSE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_PAUSE_AUTONEG]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_PAUSE_RX]			= { .type = NLA_REJECT },
+	[ETHTOOL_A_PAUSE_TX]			= { .type = NLA_REJECT },
+};
+
+static int pause_prepare_data(const struct ethnl_req_info *req_base,
+			      struct ethnl_reply_data *reply_base,
+			      struct genl_info *info)
+{
+	struct pause_reply_data *data = PAUSE_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	if (!dev->ethtool_ops->get_pauseparam)
+		return -EOPNOTSUPP;
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+	dev->ethtool_ops->get_pauseparam(dev, &data->pauseparam);
+	ethnl_ops_complete(dev);
+
+	return 0;
+}
+
+static int pause_reply_size(const struct ethnl_req_info *req_base,
+			    const struct ethnl_reply_data *reply_base)
+{
+	return nla_total_size(sizeof(u8)) +	/* _PAUSE_AUTONEG */
+		nla_total_size(sizeof(u8)) +	/* _PAUSE_RX */
+		nla_total_size(sizeof(u8));	/* _PAUSE_TX */
+}
+
+static int pause_fill_reply(struct sk_buff *skb,
+			    const struct ethnl_req_info *req_base,
+			    const struct ethnl_reply_data *reply_base)
+{
+	const struct pause_reply_data *data = PAUSE_REPDATA(reply_base);
+	const struct ethtool_pauseparam *pauseparam = &data->pauseparam;
+
+	if (nla_put_u8(skb, ETHTOOL_A_PAUSE_AUTONEG, !!pauseparam->autoneg) ||
+	    nla_put_u8(skb, ETHTOOL_A_PAUSE_RX, !!pauseparam->rx_pause) ||
+	    nla_put_u8(skb, ETHTOOL_A_PAUSE_TX, !!pauseparam->tx_pause))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_pause_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_PAUSE_GET,
+	.reply_cmd		= ETHTOOL_MSG_PAUSE_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_PAUSE_HEADER,
+	.max_attr		= ETHTOOL_A_PAUSE_MAX,
+	.req_info_size		= sizeof(struct pause_req_info),
+	.reply_data_size	= sizeof(struct pause_reply_data),
+	.request_policy		= pause_get_policy,
+
+	.prepare_data		= pause_prepare_data,
+	.reply_size		= pause_reply_size,
+	.fill_reply		= pause_fill_reply,
+};
-- 
2.25.1

