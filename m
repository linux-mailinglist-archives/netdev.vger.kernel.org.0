Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBED183A46
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgCLUIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:08:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:45292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727133AbgCLUIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:08:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EB5DDAEA7;
        Thu, 12 Mar 2020 20:08:08 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 962E2E0C79; Thu, 12 Mar 2020 21:08:08 +0100 (CET)
Message-Id: <e5ac411b688c85401d3baa9e6f0b9f6b2f19c77b.1584043144.git.mkubecek@suse.cz>
In-Reply-To: <cover.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 07/15] ethtool: provide private flags with
 PRIVFLAGS_GET request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Mar 2020 21:08:08 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement PRIVFLAGS_GET request to get private flags for a network device.
These are traditionally available via ETHTOOL_GPFLAGS ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst |  30 +++-
 include/uapi/linux/ethtool_netlink.h         |  14 ++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/netlink.c                        |   8 ++
 net/ethtool/netlink.h                        |   1 +
 net/ethtool/privflags.c                      | 136 +++++++++++++++++++
 6 files changed, 189 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/privflags.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 47542f042e9d..7bba4c940ef7 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -191,6 +191,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_WOL_SET``               set wake-on-lan settings
   ``ETHTOOL_MSG_FEATURES_GET``          get device features
   ``ETHTOOL_MSG_FEATURES_SET``          set device features
+  ``ETHTOOL_MSG_PRIVFLAGS_GET``         get private flags
   ===================================== ================================
 
 Kernel to userspace:
@@ -209,6 +210,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_FEATURES_GET_REPLY``    device features
   ``ETHTOOL_MSG_FEATURES_SET_REPLY``    optional reply to FEATURES_SET
   ``ETHTOOL_MSG_FEATURES_NTF``          netdev features notification
+  ``ETHTOOL_MSG_PRIVFLAGS_GET_REPLY``   private flags
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -598,6 +600,32 @@ request but also each time features are modified with netdev_update_features()
 or netdev_change_features().
 
 
+PRIVFLAGS_GET
+=============
+
+Gets private flags like ``ETHTOOL_GPFLAGS`` ioctl request.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_PRIVFLAGS_HEADER``        nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_PRIVFLAGS_HEADER``        nested  reply header
+  ``ETHTOOL_A_PRIVFLAGS_FLAGS``         bitset  private flags
+  ====================================  ======  ==========================
+
+``ETHTOOL_A_PRIVFLAGS_FLAGS`` is a bitset with values of device private flags.
+These flags are defined by driver, their number and names (and also meaning)
+are device dependent. For compact bitset format, names can be retrieved as
+``ETH_SS_PRIV_FLAGS`` string set. If verbose bitset format is requested,
+response uses all private flags supported by the device as mask so that client
+gets the full information without having to fetch the string set with names.
+
+
 Request translation
 ===================
 
@@ -647,7 +675,7 @@ have their netlink replacement yet.
   ``ETHTOOL_SGSO``                    ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_GFLAGS``                  ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SFLAGS``                  ``ETHTOOL_MSG_FEATURES_SET``
-  ``ETHTOOL_GPFLAGS``                 n/a
+  ``ETHTOOL_GPFLAGS``                 ``ETHTOOL_MSG_PRIVFLAGS_GET``
   ``ETHTOOL_SPFLAGS``                 n/a
   ``ETHTOOL_GRXFH``                   n/a
   ``ETHTOOL_SRXFH``                   n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 3d0204cf96a6..d94bbf5e4d1c 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -26,6 +26,7 @@ enum {
 	ETHTOOL_MSG_WOL_SET,
 	ETHTOOL_MSG_FEATURES_GET,
 	ETHTOOL_MSG_FEATURES_SET,
+	ETHTOOL_MSG_PRIVFLAGS_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -48,6 +49,7 @@ enum {
 	ETHTOOL_MSG_FEATURES_GET_REPLY,
 	ETHTOOL_MSG_FEATURES_SET_REPLY,
 	ETHTOOL_MSG_FEATURES_NTF,
+	ETHTOOL_MSG_PRIVFLAGS_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -248,6 +250,18 @@ enum {
 	ETHTOOL_A_FEATURES_MAX = __ETHTOOL_A_FEATURES_CNT - 1
 };
 
+/* PRIVFLAGS */
+
+enum {
+	ETHTOOL_A_PRIVFLAGS_UNSPEC,
+	ETHTOOL_A_PRIVFLAGS_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_PRIVFLAGS_FLAGS,			/* bitset */
+
+	/* add new constants above here */
+	__ETHTOOL_A_PRIVFLAGS_CNT,
+	ETHTOOL_A_PRIVFLAGS_MAX = __ETHTOOL_A_PRIVFLAGS_CNT - 1
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 5be8c9ab26d1..58708bcc2968 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -5,4 +5,4 @@ obj-y				+= ioctl.o common.o
 obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
-		   linkstate.o debug.o wol.o features.o
+		   linkstate.o debug.o wol.o features.o privflags.o
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 5c0e361bfd66..9cbb1d8b4d23 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -216,6 +216,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_DEBUG_GET]		= &ethnl_debug_request_ops,
 	[ETHTOOL_MSG_WOL_GET]		= &ethnl_wol_request_ops,
 	[ETHTOOL_MSG_FEATURES_GET]	= &ethnl_features_request_ops,
+	[ETHTOOL_MSG_PRIVFLAGS_GET]	= &ethnl_privflags_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -733,6 +734,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_features,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_PRIVFLAGS_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 135836201e89..36cf077c3085 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -338,6 +338,7 @@ extern const struct ethnl_request_ops ethnl_linkstate_request_ops;
 extern const struct ethnl_request_ops ethnl_debug_request_ops;
 extern const struct ethnl_request_ops ethnl_wol_request_ops;
 extern const struct ethnl_request_ops ethnl_features_request_ops;
+extern const struct ethnl_request_ops ethnl_privflags_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ethtool/privflags.c b/net/ethtool/privflags.c
new file mode 100644
index 000000000000..169dd4a832f6
--- /dev/null
+++ b/net/ethtool/privflags.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+struct privflags_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct privflags_reply_data {
+	struct ethnl_reply_data		base;
+	const char			(*priv_flag_names)[ETH_GSTRING_LEN];
+	unsigned int			n_priv_flags;
+	u32				priv_flags;
+};
+
+#define PRIVFLAGS_REPDATA(__reply_base) \
+	container_of(__reply_base, struct privflags_reply_data, base)
+
+static const struct nla_policy
+privflags_get_policy[ETHTOOL_A_PRIVFLAGS_MAX + 1] = {
+	[ETHTOOL_A_PRIVFLAGS_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_PRIVFLAGS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_PRIVFLAGS_FLAGS]		= { .type = NLA_REJECT },
+};
+
+static int ethnl_get_priv_flags_info(struct net_device *dev,
+				     unsigned int *count,
+				     const char (**names)[ETH_GSTRING_LEN])
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	int nflags;
+
+	nflags = ops->get_sset_count(dev, ETH_SS_PRIV_FLAGS);
+	if (nflags < 0)
+		return nflags;
+
+	if (names) {
+		*names = kcalloc(nflags, ETH_GSTRING_LEN, GFP_KERNEL);
+		if (!*names)
+			return -ENOMEM;
+		ops->get_strings(dev, ETH_SS_PRIV_FLAGS, (u8 *)*names);
+	}
+
+	/* We can pass more than 32 private flags to userspace via netlink but
+	 * we cannot get more with ethtool_ops::get_priv_flags(). Note that we
+	 * must not adjust nflags before allocating the space for flag names
+	 * as the buffer must be large enough for all flags.
+	 */
+	if (WARN_ONCE(nflags > 32,
+		      "device %s reports more than 32 private flags (%d)\n",
+		      netdev_name(dev), nflags))
+		nflags = 32;
+	*count = nflags;
+
+	return 0;
+}
+
+static int privflags_prepare_data(const struct ethnl_req_info *req_base,
+				  struct ethnl_reply_data *reply_base,
+				  struct genl_info *info)
+{
+	struct privflags_reply_data *data = PRIVFLAGS_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	const char (*names)[ETH_GSTRING_LEN];
+	const struct ethtool_ops *ops;
+	unsigned int nflags;
+	int ret;
+
+	ops = dev->ethtool_ops;
+	if (!ops->get_priv_flags || !ops->get_sset_count || !ops->get_strings)
+		return -EOPNOTSUPP;
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	ret = ethnl_get_priv_flags_info(dev, &nflags, &names);
+	if (ret < 0)
+		goto out_ops;
+	data->priv_flags = ops->get_priv_flags(dev);
+	data->priv_flag_names = names;
+	data->n_priv_flags = nflags;
+
+out_ops:
+	ethnl_ops_complete(dev);
+	return ret;
+}
+
+static int privflags_reply_size(const struct ethnl_req_info *req_base,
+				const struct ethnl_reply_data *reply_base)
+{
+	const struct privflags_reply_data *data = PRIVFLAGS_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const u32 all_flags = ~(u32)0 >> (32 - data->n_priv_flags);
+
+	return ethnl_bitset32_size(&data->priv_flags, &all_flags,
+				   data->n_priv_flags,
+				   data->priv_flag_names, compact);
+}
+
+static int privflags_fill_reply(struct sk_buff *skb,
+				const struct ethnl_req_info *req_base,
+				const struct ethnl_reply_data *reply_base)
+{
+	const struct privflags_reply_data *data = PRIVFLAGS_REPDATA(reply_base);
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const u32 all_flags = ~(u32)0 >> (32 - data->n_priv_flags);
+
+	return ethnl_put_bitset32(skb, ETHTOOL_A_PRIVFLAGS_FLAGS,
+				  &data->priv_flags, &all_flags,
+				  data->n_priv_flags, data->priv_flag_names,
+				  compact);
+}
+
+static void privflags_cleanup_data(struct ethnl_reply_data *reply_data)
+{
+	struct privflags_reply_data *data = PRIVFLAGS_REPDATA(reply_data);
+
+	kfree(data->priv_flag_names);
+}
+
+const struct ethnl_request_ops ethnl_privflags_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_PRIVFLAGS_GET,
+	.reply_cmd		= ETHTOOL_MSG_PRIVFLAGS_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_PRIVFLAGS_HEADER,
+	.max_attr		= ETHTOOL_A_PRIVFLAGS_MAX,
+	.req_info_size		= sizeof(struct privflags_req_info),
+	.reply_data_size	= sizeof(struct privflags_reply_data),
+	.request_policy		= privflags_get_policy,
+
+	.prepare_data		= privflags_prepare_data,
+	.reply_size		= privflags_reply_size,
+	.fill_reply		= privflags_fill_reply,
+	.cleanup_data		= privflags_cleanup_data,
+};
-- 
2.25.1

