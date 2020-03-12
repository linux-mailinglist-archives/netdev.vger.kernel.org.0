Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7D03183A54
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbgCLUIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:08:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:45594 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727165AbgCLUIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:08:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1FFA0AEED;
        Thu, 12 Mar 2020 20:08:39 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id BE325E0C79; Thu, 12 Mar 2020 21:08:38 +0100 (CET)
Message-Id: <94c8eef601034d8f7409a760479e472e506c3ea7.1584043144.git.mkubecek@suse.cz>
In-Reply-To: <cover.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 13/15] ethtool: provide channel counts with
 CHANNELS_GET request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Mar 2020 21:08:38 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement CHANNELS_GET request to get channel counts of a network device.
These are traditionally available via ETHTOOL_GCHANNELS ioctl request.

Omit attributes for channel types which are not supported by driver or
device (zero reported for maximum).

v2: (all suggested by Jakub Kicinski)
  - minor cleanup in channels_prepare_data()
  - more descriptive channels_reply_size()
  - omit attributes with zero max count

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst |  30 +++++-
 include/uapi/linux/ethtool_netlink.h         |  21 ++++
 net/ethtool/Makefile                         |   3 +-
 net/ethtool/channels.c                       | 108 +++++++++++++++++++
 net/ethtool/netlink.c                        |   8 ++
 net/ethtool/netlink.h                        |   1 +
 6 files changed, 169 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/channels.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 026a5fd4a08b..decbbddfd8be 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -195,6 +195,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_PRIVFLAGS_SET``         set private flags
   ``ETHTOOL_MSG_RINGS_GET``             get ring sizes
   ``ETHTOOL_MSG_RINGS_SET``             set ring sizes
+  ``ETHTOOL_MSG_CHANNELS_GET``          get channel counts
   ===================================== ================================
 
 Kernel to userspace:
@@ -217,6 +218,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_PRIVFLAGS_NTF``         private flags
   ``ETHTOOL_MSG_RINGS_GET_REPLY``       ring sizes
   ``ETHTOOL_MSG_RINGS_NTF``             ring sizes
+  ``ETHTOOL_MSG_CHANNELS_GET_REPLY``    channel counts
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -695,6 +697,32 @@ driver. Driver may impose additional constraints and may not suspport all
 attributes.
 
 
+CHANNELS_GET
+============
+
+Gets channel counts like ``ETHTOOL_GCHANNELS`` ioctl request.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_CHANNELS_HEADER``         nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_CHANNELS_HEADER``          nested  reply header
+  ``ETHTOOL_A_CHANNELS_RX_MAX``          u32     max receive channels
+  ``ETHTOOL_A_CHANNELS_TX_MAX``          u32     max transmit channels
+  ``ETHTOOL_A_CHANNELS_OTHER_MAX``       u32     max other channels
+  ``ETHTOOL_A_CHANNELS_COMBINED_MAX``    u32     max combined channels
+  ``ETHTOOL_A_CHANNELS_RX_COUNT``        u32     receive channel count
+  ``ETHTOOL_A_CHANNELS_TX_COUNT``        u32     transmit channel count
+  ``ETHTOOL_A_CHANNELS_OTHER_COUNT``     u32     other channel count
+  ``ETHTOOL_A_CHANNELS_COMBINED_COUNT``  u32     combined channel count
+  =====================================  ======  ==========================
+
+
 Request translation
 ===================
 
@@ -765,7 +793,7 @@ have their netlink replacement yet.
   ``ETHTOOL_SRXFHINDIR``              n/a
   ``ETHTOOL_GFEATURES``               ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SFEATURES``               ``ETHTOOL_MSG_FEATURES_SET``
-  ``ETHTOOL_GCHANNELS``               n/a
+  ``ETHTOOL_GCHANNELS``               ``ETHTOOL_MSG_CHANNELS_GET``
   ``ETHTOOL_SCHANNELS``               n/a
   ``ETHTOOL_SET_DUMP``                n/a
   ``ETHTOOL_GET_DUMP_FLAG``           n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index abfc8fd626da..2270eb115eca 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -30,6 +30,7 @@ enum {
 	ETHTOOL_MSG_PRIVFLAGS_SET,
 	ETHTOOL_MSG_RINGS_GET,
 	ETHTOOL_MSG_RINGS_SET,
+	ETHTOOL_MSG_CHANNELS_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -56,6 +57,7 @@ enum {
 	ETHTOOL_MSG_PRIVFLAGS_NTF,
 	ETHTOOL_MSG_RINGS_GET_REPLY,
 	ETHTOOL_MSG_RINGS_NTF,
+	ETHTOOL_MSG_CHANNELS_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -287,6 +289,25 @@ enum {
 	ETHTOOL_A_RINGS_MAX = (__ETHTOOL_A_RINGS_CNT - 1)
 };
 
+/* CHANNELS */
+
+enum {
+	ETHTOOL_A_CHANNELS_UNSPEC,
+	ETHTOOL_A_CHANNELS_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_CHANNELS_RX_MAX,			/* u32 */
+	ETHTOOL_A_CHANNELS_TX_MAX,			/* u32 */
+	ETHTOOL_A_CHANNELS_OTHER_MAX,			/* u32 */
+	ETHTOOL_A_CHANNELS_COMBINED_MAX,		/* u32 */
+	ETHTOOL_A_CHANNELS_RX_COUNT,			/* u32 */
+	ETHTOOL_A_CHANNELS_TX_COUNT,			/* u32 */
+	ETHTOOL_A_CHANNELS_OTHER_COUNT,			/* u32 */
+	ETHTOOL_A_CHANNELS_COMBINED_COUNT,		/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_CHANNELS_CNT,
+	ETHTOOL_A_CHANNELS_MAX = (__ETHTOOL_A_CHANNELS_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index b48b70ef4ed0..b0bd3decad02 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -5,4 +5,5 @@ obj-y				+= ioctl.o common.o
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
-		   linkstate.o debug.o wol.o features.o privflags.o rings.o
+		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
+		   channels.o
diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
new file mode 100644
index 000000000000..500dd5ad250b
--- /dev/null
+++ b/net/ethtool/channels.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+
+struct channels_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct channels_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_channels		channels;
+};
+
+#define CHANNELS_REPDATA(__reply_base) \
+	container_of(__reply_base, struct channels_reply_data, base)
+
+static const struct nla_policy
+channels_get_policy[ETHTOOL_A_CHANNELS_MAX + 1] = {
+	[ETHTOOL_A_CHANNELS_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_CHANNELS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_CHANNELS_RX_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_CHANNELS_TX_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_CHANNELS_OTHER_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_CHANNELS_COMBINED_MAX]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_CHANNELS_RX_COUNT]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_CHANNELS_TX_COUNT]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_CHANNELS_OTHER_COUNT]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_CHANNELS_COMBINED_COUNT]	= { .type = NLA_REJECT },
+};
+
+static int channels_prepare_data(const struct ethnl_req_info *req_base,
+				 struct ethnl_reply_data *reply_base,
+				 struct genl_info *info)
+{
+	struct channels_reply_data *data = CHANNELS_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	if (!dev->ethtool_ops->get_channels)
+		return -EOPNOTSUPP;
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+	dev->ethtool_ops->get_channels(dev, &data->channels);
+	ethnl_ops_complete(dev);
+
+	return 0;
+}
+
+static int channels_reply_size(const struct ethnl_req_info *req_base,
+			       const struct ethnl_reply_data *reply_base)
+{
+	return nla_total_size(sizeof(u32)) +	/* _CHANNELS_RX_MAX */
+	       nla_total_size(sizeof(u32)) +	/* _CHANNELS_TX_MAX */
+	       nla_total_size(sizeof(u32)) +	/* _CHANNELS_OTHER_MAX */
+	       nla_total_size(sizeof(u32)) +	/* _CHANNELS_COMBINED_MAX */
+	       nla_total_size(sizeof(u32)) +	/* _CHANNELS_RX_COUNT */
+	       nla_total_size(sizeof(u32)) +	/* _CHANNELS_TX_COUNT */
+	       nla_total_size(sizeof(u32)) +	/* _CHANNELS_OTHER_COUNT */
+	       nla_total_size(sizeof(u32));	/* _CHANNELS_COMBINED_COUNT */
+}
+
+static int channels_fill_reply(struct sk_buff *skb,
+			       const struct ethnl_req_info *req_base,
+			       const struct ethnl_reply_data *reply_base)
+{
+	const struct channels_reply_data *data = CHANNELS_REPDATA(reply_base);
+	const struct ethtool_channels *channels = &data->channels;
+
+	if ((channels->max_rx &&
+	     (nla_put_u32(skb, ETHTOOL_A_CHANNELS_RX_MAX,
+			  channels->max_rx) ||
+	      nla_put_u32(skb, ETHTOOL_A_CHANNELS_RX_COUNT,
+			  channels->rx_count))) ||
+	    (channels->max_tx &&
+	     (nla_put_u32(skb, ETHTOOL_A_CHANNELS_TX_MAX,
+			  channels->max_tx) ||
+	      nla_put_u32(skb, ETHTOOL_A_CHANNELS_TX_COUNT,
+			  channels->tx_count))) ||
+	    (channels->max_other &&
+	     (nla_put_u32(skb, ETHTOOL_A_CHANNELS_OTHER_MAX,
+			  channels->max_other) ||
+	      nla_put_u32(skb, ETHTOOL_A_CHANNELS_OTHER_COUNT,
+			  channels->other_count))) ||
+	    (channels->max_combined &&
+	     (nla_put_u32(skb, ETHTOOL_A_CHANNELS_COMBINED_MAX,
+			  channels->max_combined) ||
+	      nla_put_u32(skb, ETHTOOL_A_CHANNELS_COMBINED_COUNT,
+			  channels->combined_count))))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_channels_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_CHANNELS_GET,
+	.reply_cmd		= ETHTOOL_MSG_CHANNELS_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_CHANNELS_HEADER,
+	.max_attr		= ETHTOOL_A_CHANNELS_MAX,
+	.req_info_size		= sizeof(struct channels_req_info),
+	.reply_data_size	= sizeof(struct channels_reply_data),
+	.request_policy		= channels_get_policy,
+
+	.prepare_data		= channels_prepare_data,
+	.reply_size		= channels_reply_size,
+	.fill_reply		= channels_fill_reply,
+};
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 653e009216cd..ac35513abeed 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -218,6 +218,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_FEATURES_GET]	= &ethnl_features_request_ops,
 	[ETHTOOL_MSG_PRIVFLAGS_GET]	= &ethnl_privflags_request_ops,
 	[ETHTOOL_MSG_RINGS_GET]		= &ethnl_rings_request_ops,
+	[ETHTOOL_MSG_CHANNELS_GET]	= &ethnl_channels_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -763,6 +764,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_rings,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_CHANNELS_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index b30426d01890..53bfe720ff1a 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -340,6 +340,7 @@ extern const struct ethnl_request_ops ethnl_wol_request_ops;
 extern const struct ethnl_request_ops ethnl_features_request_ops;
 extern const struct ethnl_request_ops ethnl_privflags_request_ops;
 extern const struct ethnl_request_ops ethnl_rings_request_ops;
+extern const struct ethnl_request_ops ethnl_channels_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
-- 
2.25.1

