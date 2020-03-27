Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE287194DD5
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 01:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgC0AMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 20:12:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:42728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbgC0AMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 20:12:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 527F0B1ED;
        Fri, 27 Mar 2020 00:12:28 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id F4043E00A5; Fri, 27 Mar 2020 01:12:27 +0100 (CET)
Message-Id: <917c130bee700613bf0605dc4a54fbb3259b61c1.1585267388.git.mkubecek@suse.cz>
In-Reply-To: <cover.1585267388.git.mkubecek@suse.cz>
References: <cover.1585267388.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 08/12] ethtool: provide EEE settings with EEE_GET
 request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Mar 2020 01:12:27 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement EEE_GET request to get EEE settings of a network device. These
are traditionally available via ETHTOOL_GEEE ioctl request.

The netlink interface allows reporting EEE status for all link modes
supported by kernel but only first 32 link modes are provided at the moment
as only those are reported by the ethtool_ops callback and drivers.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst |  34 ++++-
 include/uapi/linux/ethtool_netlink.h         |  19 +++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/eee.c                            | 130 +++++++++++++++++++
 net/ethtool/netlink.c                        |   8 ++
 net/ethtool/netlink.h                        |   1 +
 6 files changed, 192 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/eee.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 0cc9e69cb90d..1d067f6e9d8a 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -201,6 +201,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_COALESCE_SET``          set coalescing parameters
   ``ETHTOOL_MSG_PAUSE_GET``             get pause parameters
   ``ETHTOOL_MSG_PAUSE_SET``             set pause parameters
+  ``ETHTOOL_MSG_EEE_GET``               get EEE settings
   ===================================== ================================
 
 Kernel to userspace:
@@ -229,6 +230,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_COALESCE_NTF``          coalescing parameters
   ``ETHTOOL_MSG_PAUSE_GET_REPLY``       pause parameters
   ``ETHTOOL_MSG_PAUSE_NTF``             pause parameters
+  ``ETHTOOL_MSG_EEE_GET_REPLY``         EEE settings
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -872,6 +874,36 @@ Request contents:
   =====================================  ======  ==========================
 
 
+EEE_GET
+=======
+
+Gets channel counts like ``ETHTOOL_GEEE`` ioctl request.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_EEE_HEADER``               nested  request header
+  =====================================  ======  ==========================
+
+Kernel response contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_EEE_HEADER``               nested  request header
+  ``ETHTOOL_A_EEE_MODES_OURS``           bool    supported/advertised modes
+  ``ETHTOOL_A_EEE_MODES_PEER``           bool    peer advertised link modes
+  ``ETHTOOL_A_EEE_ACTIVE``               bool    EEE is actively used
+  ``ETHTOOL_A_EEE_ENABLED``              bool    EEE is enabled
+  ``ETHTOOL_A_EEE_TX_LPI_ENABLED``       bool    Tx lpi enabled
+  ``ETHTOOL_A_EEE_TX_LPI_TIMER``         u32     Tx lpi timeout (in us)
+  =====================================  ======  ==========================
+
+In ``ETHTOOL_A_EEE_MODES_OURS``, mask consists of link modes for which EEE is
+enabled, value of link modes for which EEE is advertised. Link modes for which
+peer advertises EEE are listed in ``ETHTOOL_A_EEE_MODES_PEER`` (no mask). The
+netlink interface allows reporting EEE status for all link modes but only
+first 32 are provided by the ``ethtool_ops`` callback.
+
+
 Request translation
 ===================
 
@@ -950,7 +982,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GET_TS_INFO``             n/a
   ``ETHTOOL_GMODULEINFO``             n/a
   ``ETHTOOL_GMODULEEEPROM``           n/a
-  ``ETHTOOL_GEEE``                    n/a
+  ``ETHTOOL_GEEE``                    ``ETHTOOL_MSG_EEE_GET``
   ``ETHTOOL_SEEE``                    n/a
   ``ETHTOOL_GRSSH``                   n/a
   ``ETHTOOL_SRSSH``                   n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index a53d79dd5ad4..2231dc779c3e 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -36,6 +36,7 @@ enum {
 	ETHTOOL_MSG_COALESCE_SET,
 	ETHTOOL_MSG_PAUSE_GET,
 	ETHTOOL_MSG_PAUSE_SET,
+	ETHTOOL_MSG_EEE_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -68,6 +69,7 @@ enum {
 	ETHTOOL_MSG_COALESCE_NTF,
 	ETHTOOL_MSG_PAUSE_GET_REPLY,
 	ETHTOOL_MSG_PAUSE_NTF,
+	ETHTOOL_MSG_EEE_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -365,6 +367,23 @@ enum {
 	ETHTOOL_A_PAUSE_MAX = (__ETHTOOL_A_PAUSE_CNT - 1)
 };
 
+/* EEE */
+
+enum {
+	ETHTOOL_A_EEE_UNSPEC,
+	ETHTOOL_A_EEE_HEADER,				/* nest - _A_HEADER_* */
+	ETHTOOL_A_EEE_MODES_OURS,			/* bitset */
+	ETHTOOL_A_EEE_MODES_PEER,			/* bitset */
+	ETHTOOL_A_EEE_ACTIVE,				/* u8 */
+	ETHTOOL_A_EEE_ENABLED,				/* u8 */
+	ETHTOOL_A_EEE_TX_LPI_ENABLED,			/* u8 */
+	ETHTOOL_A_EEE_TX_LPI_TIMER,			/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_EEE_CNT,
+	ETHTOOL_A_EEE_MAX = (__ETHTOOL_A_EEE_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 28589ad5fd8a..a790f408aa5d 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -6,4 +6,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
-		   channels.o coalesce.o pause.o
+		   channels.o coalesce.o pause.o eee.o
diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
new file mode 100644
index 000000000000..666b9b284ff6
--- /dev/null
+++ b/net/ethtool/eee.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+#include "bitset.h"
+
+#define EEE_MODES_COUNT \
+	(sizeof_field(struct ethtool_eee, supported) * BITS_PER_BYTE)
+
+struct eee_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct eee_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_eee		eee;
+};
+
+#define EEE_REPDATA(__reply_base) \
+	container_of(__reply_base, struct eee_reply_data, base)
+
+static const struct nla_policy
+eee_get_policy[ETHTOOL_A_EEE_MAX + 1] = {
+	[ETHTOOL_A_EEE_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_EEE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_EEE_MODES_OURS]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_EEE_MODES_PEER]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_EEE_ACTIVE]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_EEE_ENABLED]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_EEE_TX_LPI_ENABLED]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_EEE_TX_LPI_TIMER]	= { .type = NLA_REJECT },
+};
+
+static int eee_prepare_data(const struct ethnl_req_info *req_base,
+				 struct ethnl_reply_data *reply_base,
+				 struct genl_info *info)
+{
+	struct eee_reply_data *data = EEE_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	if (!dev->ethtool_ops->get_eee)
+		return -EOPNOTSUPP;
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+	ret = dev->ethtool_ops->get_eee(dev, &data->eee);
+	ethnl_ops_complete(dev);
+
+	return ret;
+}
+
+static int eee_reply_size(const struct ethnl_req_info *req_base,
+			  const struct ethnl_reply_data *reply_base)
+{
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct eee_reply_data *data = EEE_REPDATA(reply_base);
+	const struct ethtool_eee *eee = &data->eee;
+	int len = 0;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(eee->advertised) * BITS_PER_BYTE !=
+		     EEE_MODES_COUNT);
+	BUILD_BUG_ON(sizeof(eee->lp_advertised) * BITS_PER_BYTE !=
+		     EEE_MODES_COUNT);
+
+	/* MODES_OURS */
+	ret = ethnl_bitset32_size(&eee->advertised, &eee->supported,
+				  EEE_MODES_COUNT, link_mode_names, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+	/* MODES_PEERS */
+	ret = ethnl_bitset32_size(&eee->lp_advertised, NULL,
+				  EEE_MODES_COUNT, link_mode_names, compact);
+	if (ret < 0)
+		return ret;
+	len += ret;
+
+	len += nla_total_size(sizeof(u8)) +	/* _EEE_ACTIVE */
+	       nla_total_size(sizeof(u8)) +	/* _EEE_ENABLED */
+	       nla_total_size(sizeof(u8)) +	/* _EEE_TX_LPI_ENABLED */
+	       nla_total_size(sizeof(u32));	/* _EEE_TX_LPI_TIMER */
+
+	return len;
+}
+
+static int eee_fill_reply(struct sk_buff *skb,
+			       const struct ethnl_req_info *req_base,
+			       const struct ethnl_reply_data *reply_base)
+{
+	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
+	const struct eee_reply_data *data = EEE_REPDATA(reply_base);
+	const struct ethtool_eee *eee = &data->eee;
+	int ret;
+
+	ret = ethnl_put_bitset32(skb, ETHTOOL_A_EEE_MODES_OURS,
+				 &eee->advertised, &eee->supported,
+				 EEE_MODES_COUNT, link_mode_names, compact);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_put_bitset32(skb, ETHTOOL_A_EEE_MODES_PEER,
+				 &eee->lp_advertised, NULL, EEE_MODES_COUNT,
+				 link_mode_names, compact);
+	if (ret < 0)
+		return ret;
+
+	if (nla_put_u8(skb, ETHTOOL_A_EEE_ACTIVE, !!eee->eee_active) ||
+	    nla_put_u8(skb, ETHTOOL_A_EEE_ENABLED, !!eee->eee_enabled) ||
+	    nla_put_u8(skb, ETHTOOL_A_EEE_TX_LPI_ENABLED,
+		       !!eee->tx_lpi_enabled) ||
+	    nla_put_u32(skb, ETHTOOL_A_EEE_TX_LPI_TIMER, eee->tx_lpi_timer))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_eee_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_EEE_GET,
+	.reply_cmd		= ETHTOOL_MSG_EEE_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_EEE_HEADER,
+	.max_attr		= ETHTOOL_A_EEE_MAX,
+	.req_info_size		= sizeof(struct eee_req_info),
+	.reply_data_size	= sizeof(struct eee_reply_data),
+	.request_policy		= eee_get_policy,
+
+	.prepare_data		= eee_prepare_data,
+	.reply_size		= eee_reply_size,
+	.fill_reply		= eee_fill_reply,
+};
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 4d492f1b3480..f9396d2a96f6 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -229,6 +229,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_CHANNELS_GET]	= &ethnl_channels_request_ops,
 	[ETHTOOL_MSG_COALESCE_GET]	= &ethnl_coalesce_request_ops,
 	[ETHTOOL_MSG_PAUSE_GET]		= &ethnl_pause_request_ops,
+	[ETHTOOL_MSG_EEE_GET]		= &ethnl_eee_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -816,6 +817,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_pause,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_EEE_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 49fee19bc6aa..8ad26d93590d 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -343,6 +343,7 @@ extern const struct ethnl_request_ops ethnl_rings_request_ops;
 extern const struct ethnl_request_ops ethnl_channels_request_ops;
 extern const struct ethnl_request_ops ethnl_coalesce_request_ops;
 extern const struct ethnl_request_ops ethnl_pause_request_ops;
+extern const struct ethnl_request_ops ethnl_eee_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
-- 
2.25.1

