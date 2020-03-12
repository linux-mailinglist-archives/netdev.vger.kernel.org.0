Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05829183A4D
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgCLUI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:08:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:45426 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727340AbgCLUI0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:08:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 08104AEA8;
        Thu, 12 Mar 2020 20:08:24 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id AA641E0C79; Thu, 12 Mar 2020 21:08:23 +0100 (CET)
Message-Id: <9a21d15cfd2453fd594be39a1e8a3416e0973bab.1584043144.git.mkubecek@suse.cz>
In-Reply-To: <cover.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 10/15] ethtool: provide ring sizes with RINGS_GET
 request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Mar 2020 21:08:23 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement RINGS_GET request to get ring sizes of a network device. These
are traditionally available via ETHTOOL_GRINGPARAM ioctl request.

Omit attributes for ring types which are not supported by driver or device
(zero reported for maximum).

v2: (all suggested by Jakub Kicinski)
  - minor cleanup in rings_prepare_data()
  - more descriptive rings_reply_size()
  - omit attributes with zero max size

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst |  30 +++++-
 include/uapi/linux/ethtool_netlink.h         |  21 ++++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/netlink.c                        |   8 ++
 net/ethtool/netlink.h                        |   1 +
 net/ethtool/rings.c                          | 108 +++++++++++++++++++
 6 files changed, 168 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/rings.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index e553112fa2d7..798c2f97d89b 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -193,6 +193,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_FEATURES_SET``          set device features
   ``ETHTOOL_MSG_PRIVFLAGS_GET``         get private flags
   ``ETHTOOL_MSG_PRIVFLAGS_SET``         set private flags
+  ``ETHTOOL_MSG_RINGS_GET``             get ring sizes
   ===================================== ================================
 
 Kernel to userspace:
@@ -213,6 +214,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_FEATURES_NTF``          netdev features notification
   ``ETHTOOL_MSG_PRIVFLAGS_GET_REPLY``   private flags
   ``ETHTOOL_MSG_PRIVFLAGS_NTF``         private flags
+  ``ETHTOOL_MSG_RINGS_GET_REPLY``       ring sizes
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -645,6 +647,32 @@ Request contents:
 modify only values of some of them.
 
 
+RINGS_GET
+=========
+
+Gets ring sizes like ``ETHTOOL_GRINGPARAM`` ioctl request.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_RINGS_HEADER``            nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_RINGS_HEADER``            nested  reply header
+  ``ETHTOOL_A_RINGS_RX_MAX``            u32     max size of RX ring
+  ``ETHTOOL_A_RINGS_RX_MINI_MAX``       u32     max size of RX mini ring
+  ``ETHTOOL_A_RINGS_RX_JUMBO_MAX``      u32     max size of RX jumbo ring
+  ``ETHTOOL_A_RINGS_TX_MAX``            u32     max size of TX ring
+  ``ETHTOOL_A_RINGS_RX``                u32     size of RX ring
+  ``ETHTOOL_A_RINGS_RX_MINI``           u32     size of RX mini ring
+  ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
+  ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
+  ====================================  ======  ==========================
+
+
 Request translation
 ===================
 
@@ -671,7 +699,7 @@ have their netlink replacement yet.
   ``ETHTOOL_SEEPROM``                 n/a
   ``ETHTOOL_GCOALESCE``               n/a
   ``ETHTOOL_SCOALESCE``               n/a
-  ``ETHTOOL_GRINGPARAM``              n/a
+  ``ETHTOOL_GRINGPARAM``              ``ETHTOOL_MSG_RINGS_GET``
   ``ETHTOOL_SRINGPARAM``              n/a
   ``ETHTOOL_GPAUSEPARAM``             n/a
   ``ETHTOOL_SPAUSEPARAM``             n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 7f23a7f0fca1..7cd220f8cf73 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -28,6 +28,7 @@ enum {
 	ETHTOOL_MSG_FEATURES_SET,
 	ETHTOOL_MSG_PRIVFLAGS_GET,
 	ETHTOOL_MSG_PRIVFLAGS_SET,
+	ETHTOOL_MSG_RINGS_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -52,6 +53,7 @@ enum {
 	ETHTOOL_MSG_FEATURES_NTF,
 	ETHTOOL_MSG_PRIVFLAGS_GET_REPLY,
 	ETHTOOL_MSG_PRIVFLAGS_NTF,
+	ETHTOOL_MSG_RINGS_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -264,6 +266,25 @@ enum {
 	ETHTOOL_A_PRIVFLAGS_MAX = __ETHTOOL_A_PRIVFLAGS_CNT - 1
 };
 
+/* RINGS */
+
+enum {
+	ETHTOOL_A_RINGS_UNSPEC,
+	ETHTOOL_A_RINGS_HEADER,				/* nest - _A_HEADER_* */
+	ETHTOOL_A_RINGS_RX_MAX,				/* u32 */
+	ETHTOOL_A_RINGS_RX_MINI_MAX,			/* u32 */
+	ETHTOOL_A_RINGS_RX_JUMBO_MAX,			/* u32 */
+	ETHTOOL_A_RINGS_TX_MAX,				/* u32 */
+	ETHTOOL_A_RINGS_RX,				/* u32 */
+	ETHTOOL_A_RINGS_RX_MINI,			/* u32 */
+	ETHTOOL_A_RINGS_RX_JUMBO,			/* u32 */
+	ETHTOOL_A_RINGS_TX,				/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_RINGS_CNT,
+	ETHTOOL_A_RINGS_MAX = (__ETHTOOL_A_RINGS_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 58708bcc2968..b48b70ef4ed0 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -5,4 +5,4 @@ obj-y				+= ioctl.o common.o
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
-		   linkstate.o debug.o wol.o features.o privflags.o
+		   linkstate.o debug.o wol.o features.o privflags.o rings.o
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index dec82b0b80bd..0dc25a490450 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -217,6 +217,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_WOL_GET]		= &ethnl_wol_request_ops,
 	[ETHTOOL_MSG_FEATURES_GET]	= &ethnl_features_request_ops,
 	[ETHTOOL_MSG_PRIVFLAGS_GET]	= &ethnl_privflags_request_ops,
+	[ETHTOOL_MSG_RINGS_GET]		= &ethnl_rings_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -748,6 +749,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_privflags,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_RINGS_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index ca789f587ef3..01761932ed15 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -339,6 +339,7 @@ extern const struct ethnl_request_ops ethnl_debug_request_ops;
 extern const struct ethnl_request_ops ethnl_wol_request_ops;
 extern const struct ethnl_request_ops ethnl_features_request_ops;
 extern const struct ethnl_request_ops ethnl_privflags_request_ops;
+extern const struct ethnl_request_ops ethnl_rings_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
new file mode 100644
index 000000000000..d3129d8a252d
--- /dev/null
+++ b/net/ethtool/rings.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+
+struct rings_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct rings_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_ringparam	ringparam;
+};
+
+#define RINGS_REPDATA(__reply_base) \
+	container_of(__reply_base, struct rings_reply_data, base)
+
+static const struct nla_policy
+rings_get_policy[ETHTOOL_A_RINGS_MAX + 1] = {
+	[ETHTOOL_A_RINGS_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_RINGS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_RINGS_RX_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_RINGS_RX_MINI_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_RINGS_RX_JUMBO_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_RINGS_TX_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_RINGS_RX]			= { .type = NLA_REJECT },
+	[ETHTOOL_A_RINGS_RX_MINI]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_RINGS_RX_JUMBO]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_RINGS_TX]			= { .type = NLA_REJECT },
+};
+
+static int rings_prepare_data(const struct ethnl_req_info *req_base,
+			      struct ethnl_reply_data *reply_base,
+			      struct genl_info *info)
+{
+	struct rings_reply_data *data = RINGS_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	if (!dev->ethtool_ops->get_ringparam)
+		return -EOPNOTSUPP;
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+	dev->ethtool_ops->get_ringparam(dev, &data->ringparam);
+	ethnl_ops_complete(dev);
+
+	return 0;
+}
+
+static int rings_reply_size(const struct ethnl_req_info *req_base,
+			    const struct ethnl_reply_data *reply_base)
+{
+	return nla_total_size(sizeof(u32)) +	/* _RINGS_RX_MAX */
+	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_MINI_MAX */
+	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_JUMBO_MAX */
+	       nla_total_size(sizeof(u32)) +	/* _RINGS_TX_MAX */
+	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX */
+	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_MINI */
+	       nla_total_size(sizeof(u32)) +	/* _RINGS_RX_JUMBO */
+	       nla_total_size(sizeof(u32));	/* _RINGS_TX */
+}
+
+static int rings_fill_reply(struct sk_buff *skb,
+			    const struct ethnl_req_info *req_base,
+			    const struct ethnl_reply_data *reply_base)
+{
+	const struct rings_reply_data *data = RINGS_REPDATA(reply_base);
+	const struct ethtool_ringparam *ringparam = &data->ringparam;
+
+	if ((ringparam->rx_max_pending &&
+	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_MAX,
+			  ringparam->rx_max_pending) ||
+	      nla_put_u32(skb, ETHTOOL_A_RINGS_RX,
+			  ringparam->rx_pending))) ||
+	    (ringparam->rx_mini_max_pending &&
+	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_MINI_MAX,
+			  ringparam->rx_mini_max_pending) ||
+	      nla_put_u32(skb, ETHTOOL_A_RINGS_RX_MINI,
+			  ringparam->rx_mini_pending))) ||
+	    (ringparam->rx_jumbo_max_pending &&
+	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_JUMBO_MAX,
+			  ringparam->rx_jumbo_max_pending) ||
+	      nla_put_u32(skb, ETHTOOL_A_RINGS_RX_JUMBO,
+			  ringparam->rx_jumbo_pending))) ||
+	    (ringparam->tx_max_pending &&
+	     (nla_put_u32(skb, ETHTOOL_A_RINGS_TX_MAX,
+			  ringparam->tx_max_pending) ||
+	      nla_put_u32(skb, ETHTOOL_A_RINGS_TX,
+			  ringparam->tx_pending))))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_rings_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_RINGS_GET,
+	.reply_cmd		= ETHTOOL_MSG_RINGS_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_RINGS_HEADER,
+	.max_attr		= ETHTOOL_A_RINGS_MAX,
+	.req_info_size		= sizeof(struct rings_req_info),
+	.reply_data_size	= sizeof(struct rings_reply_data),
+	.request_policy		= rings_get_policy,
+
+	.prepare_data		= rings_prepare_data,
+	.reply_size		= rings_reply_size,
+	.fill_reply		= rings_fill_reply,
+};
-- 
2.25.1

