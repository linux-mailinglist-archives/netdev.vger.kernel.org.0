Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 531B7194DCA
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 01:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgC0AMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 20:12:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:42488 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbgC0AMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 20:12:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2E947B1E1;
        Fri, 27 Mar 2020 00:11:58 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id CC077E00A5; Fri, 27 Mar 2020 01:11:57 +0100 (CET)
Message-Id: <0d94d1390e886c2d616291c46509fac4cd9eac11.1585267388.git.mkubecek@suse.cz>
In-Reply-To: <cover.1585267388.git.mkubecek@suse.cz>
References: <cover.1585267388.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 02/12] ethtool: provide coalescing parameters with
 COALESCE_GET request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Mar 2020 01:11:57 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement COALESCE_GET request to get coalescing parameters of a network
device. These are traditionally available via ETHTOOL_GCOALESCE ioctl
request. This commit adds only support for device coalescing parameters,
not per queue coalescing parameters.

Omit attributes with zero values unless they are declared as supported
(i.e. the corresponding bit in ethtool_ops::supported_coalesce_params is
set).

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst |  48 ++++-
 include/uapi/linux/ethtool_netlink.h         |  35 +++
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/coalesce.c                       | 214 +++++++++++++++++++
 net/ethtool/netlink.c                        |   8 +
 net/ethtool/netlink.h                        |   1 +
 6 files changed, 306 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/coalesce.c

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 31a601cafa3f..1e84686a998b 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -197,6 +197,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_RINGS_SET``             set ring sizes
   ``ETHTOOL_MSG_CHANNELS_GET``          get channel counts
   ``ETHTOOL_MSG_CHANNELS_SET``          set channel counts
+  ``ETHTOOL_MSG_COALESCE_GET``          get coalescing parameters
   ===================================== ================================
 
 Kernel to userspace:
@@ -221,6 +222,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_RINGS_NTF``             ring sizes
   ``ETHTOOL_MSG_CHANNELS_GET_REPLY``    channel counts
   ``ETHTOOL_MSG_CHANNELS_NTF``          channel counts
+  ``ETHTOOL_MSG_COALESCE_GET_REPLY``    coalescing parameters
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -745,6 +747,50 @@ driver. Driver may impose additional constraints and may not suspport all
 attributes.
 
 
+COALESCE_GET
+============
+
+Gets coalescing parameters like ``ETHTOOL_GCOALESCE`` ioctl request.
+
+Request contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_A_COALESCE_HEADER``         nested  request header
+  ====================================  ======  ==========================
+
+Kernel response contents:
+
+  ===========================================  ======  =======================
+  ``ETHTOOL_A_COALESCE_HEADER``                nested  reply header
+  ``ETHTOOL_A_COALESCE_RX_USECS``              u32     delay (us), normal Rx
+  ``ETHTOOL_A_COALESCE_RX_MAX_FRAMES``         u32     max packets, normal Rx
+  ``ETHTOOL_A_COALESCE_RX_USECS_IRQ``          u32     delay (us), Rx in IRQ
+  ``ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ``     u32     max packets, Rx in IRQ
+  ``ETHTOOL_A_COALESCE_TX_USECS``              u32     delay (us), normal Tx
+  ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES``         u32     max packets, normal Tx
+  ``ETHTOOL_A_COALESCE_TX_USECS_IRQ``          u32     delay (us), Tx in IRQ
+  ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ``     u32     IRQ packets, Tx in IRQ
+  ``ETHTOOL_A_COALESCE_STATS_BLOCK_USECS``     u32     delay of stats update
+  ``ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX``       bool    adaptive Rx coalesce
+  ``ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX``       bool    adaptive Tx coalesce
+  ``ETHTOOL_A_COALESCE_PKT_RATE_LOW``          u32     threshold for low rate
+  ``ETHTOOL_A_COALESCE_RX_USECS_LOW``          u32     delay (us), low Rx
+  ``ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW``     u32     max packets, low Rx
+  ``ETHTOOL_A_COALESCE_TX_USECS_LOW``          u32     delay (us), low Tx
+  ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW``     u32     max packets, low Tx
+  ``ETHTOOL_A_COALESCE_PKT_RATE_HIGH``         u32     threshold for high rate
+  ``ETHTOOL_A_COALESCE_RX_USECS_HIGH``         u32     delay (us), high Rx
+  ``ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH``    u32     max packets, high Rx
+  ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
+  ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
+  ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
+  ===========================================  ======  =======================
+
+Attributes are only included in reply if their value is not zero or the
+corresponding bit in ``ethtool_ops::supported_coalesce_params`` is set (i.e.
+they are declared as supported by driver).
+
+
 Request translation
 ===================
 
@@ -769,7 +815,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GLINK``                   ``ETHTOOL_MSG_LINKSTATE_GET``
   ``ETHTOOL_GEEPROM``                 n/a
   ``ETHTOOL_SEEPROM``                 n/a
-  ``ETHTOOL_GCOALESCE``               n/a
+  ``ETHTOOL_GCOALESCE``               ``ETHTOOL_MSG_COALESCE_GET``
   ``ETHTOOL_SCOALESCE``               n/a
   ``ETHTOOL_GRINGPARAM``              ``ETHTOOL_MSG_RINGS_GET``
   ``ETHTOOL_SRINGPARAM``              ``ETHTOOL_MSG_RINGS_SET``
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index c7c7a1a550af..ed0c0fa103cd 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -32,6 +32,7 @@ enum {
 	ETHTOOL_MSG_RINGS_SET,
 	ETHTOOL_MSG_CHANNELS_GET,
 	ETHTOOL_MSG_CHANNELS_SET,
+	ETHTOOL_MSG_COALESCE_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -60,6 +61,7 @@ enum {
 	ETHTOOL_MSG_RINGS_NTF,
 	ETHTOOL_MSG_CHANNELS_GET_REPLY,
 	ETHTOOL_MSG_CHANNELS_NTF,
+	ETHTOOL_MSG_COALESCE_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -310,6 +312,39 @@ enum {
 	ETHTOOL_A_CHANNELS_MAX = (__ETHTOOL_A_CHANNELS_CNT - 1)
 };
 
+/* COALESCE */
+
+enum {
+	ETHTOOL_A_COALESCE_UNSPEC,
+	ETHTOOL_A_COALESCE_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_COALESCE_RX_USECS,			/* u32 */
+	ETHTOOL_A_COALESCE_RX_MAX_FRAMES,		/* u32 */
+	ETHTOOL_A_COALESCE_RX_USECS_IRQ,		/* u32 */
+	ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_USECS,			/* u32 */
+	ETHTOOL_A_COALESCE_TX_MAX_FRAMES,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_USECS_IRQ,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ,		/* u32 */
+	ETHTOOL_A_COALESCE_STATS_BLOCK_USECS,		/* u32 */
+	ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX,		/* u8 */
+	ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX,		/* u8 */
+	ETHTOOL_A_COALESCE_PKT_RATE_LOW,		/* u32 */
+	ETHTOOL_A_COALESCE_RX_USECS_LOW,		/* u32 */
+	ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_USECS_LOW,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW,		/* u32 */
+	ETHTOOL_A_COALESCE_PKT_RATE_HIGH,		/* u32 */
+	ETHTOOL_A_COALESCE_RX_USECS_HIGH,		/* u32 */
+	ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_USECS_HIGH,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,		/* u32 */
+	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_COALESCE_CNT,
+	ETHTOOL_A_COALESCE_MAX = (__ETHTOOL_A_COALESCE_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index b0bd3decad02..7f7f40e03d16 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -6,4 +6,4 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
-		   channels.o
+		   channels.o coalesce.o
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
new file mode 100644
index 000000000000..ba5f2cec4ac4
--- /dev/null
+++ b/net/ethtool/coalesce.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "netlink.h"
+#include "common.h"
+
+struct coalesce_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct coalesce_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_coalesce		coalesce;
+	u32				supported_params;
+};
+
+#define COALESCE_REPDATA(__reply_base) \
+	container_of(__reply_base, struct coalesce_reply_data, base)
+
+#define __SUPPORTED_OFFSET ETHTOOL_A_COALESCE_RX_USECS
+static u32 attr_to_mask(unsigned int attr_type)
+{
+	return BIT(attr_type - __SUPPORTED_OFFSET);
+}
+
+/* build time check that indices in ethtool_ops::supported_coalesce_params
+ * match corresponding attribute types with an offset
+ */
+#define __CHECK_SUPPORTED_OFFSET(x) \
+	static_assert((ETHTOOL_ ## x) == \
+		      BIT((ETHTOOL_A_ ## x) - __SUPPORTED_OFFSET))
+__CHECK_SUPPORTED_OFFSET(COALESCE_RX_USECS);
+__CHECK_SUPPORTED_OFFSET(COALESCE_RX_MAX_FRAMES);
+__CHECK_SUPPORTED_OFFSET(COALESCE_RX_USECS_IRQ);
+__CHECK_SUPPORTED_OFFSET(COALESCE_RX_MAX_FRAMES_IRQ);
+__CHECK_SUPPORTED_OFFSET(COALESCE_TX_USECS);
+__CHECK_SUPPORTED_OFFSET(COALESCE_TX_MAX_FRAMES);
+__CHECK_SUPPORTED_OFFSET(COALESCE_TX_USECS_IRQ);
+__CHECK_SUPPORTED_OFFSET(COALESCE_TX_MAX_FRAMES_IRQ);
+__CHECK_SUPPORTED_OFFSET(COALESCE_STATS_BLOCK_USECS);
+__CHECK_SUPPORTED_OFFSET(COALESCE_USE_ADAPTIVE_RX);
+__CHECK_SUPPORTED_OFFSET(COALESCE_USE_ADAPTIVE_TX);
+__CHECK_SUPPORTED_OFFSET(COALESCE_PKT_RATE_LOW);
+__CHECK_SUPPORTED_OFFSET(COALESCE_RX_USECS_LOW);
+__CHECK_SUPPORTED_OFFSET(COALESCE_RX_MAX_FRAMES_LOW);
+__CHECK_SUPPORTED_OFFSET(COALESCE_TX_USECS_LOW);
+__CHECK_SUPPORTED_OFFSET(COALESCE_TX_MAX_FRAMES_LOW);
+__CHECK_SUPPORTED_OFFSET(COALESCE_PKT_RATE_HIGH);
+__CHECK_SUPPORTED_OFFSET(COALESCE_RX_USECS_HIGH);
+__CHECK_SUPPORTED_OFFSET(COALESCE_RX_MAX_FRAMES_HIGH);
+__CHECK_SUPPORTED_OFFSET(COALESCE_TX_USECS_HIGH);
+__CHECK_SUPPORTED_OFFSET(COALESCE_TX_MAX_FRAMES_HIGH);
+__CHECK_SUPPORTED_OFFSET(COALESCE_RATE_SAMPLE_INTERVAL);
+
+static const struct nla_policy
+coalesce_get_policy[ETHTOOL_A_COALESCE_MAX + 1] = {
+	[ETHTOOL_A_COALESCE_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_COALESCE_RX_USECS]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_RX_USECS_IRQ]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_TX_USECS]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_TX_USECS_IRQ]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_STATS_BLOCK_USECS]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_PKT_RATE_LOW]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_RX_USECS_LOW]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_TX_USECS_LOW]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_PKT_RATE_HIGH]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_RX_USECS_HIGH]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_TX_USECS_HIGH]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL] = { .type = NLA_REJECT },
+};
+
+static int coalesce_prepare_data(const struct ethnl_req_info *req_base,
+				 struct ethnl_reply_data *reply_base,
+				 struct genl_info *info)
+{
+	struct coalesce_reply_data *data = COALESCE_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	int ret;
+
+	if (!dev->ethtool_ops->get_coalesce)
+		return -EOPNOTSUPP;
+	data->supported_params = dev->ethtool_ops->supported_coalesce_params;
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+	ret = dev->ethtool_ops->get_coalesce(dev, &data->coalesce);
+	ethnl_ops_complete(dev);
+
+	return ret;
+}
+
+static int coalesce_reply_size(const struct ethnl_req_info *req_base,
+			       const struct ethnl_reply_data *reply_base)
+{
+	return nla_total_size(sizeof(u32)) +	/* _RX_USECS */
+	       nla_total_size(sizeof(u32)) +	/* _RX_MAX_FRAMES */
+	       nla_total_size(sizeof(u32)) +	/* _RX_USECS_IRQ */
+	       nla_total_size(sizeof(u32)) +	/* _RX_MAX_FRAMES_IRQ */
+	       nla_total_size(sizeof(u32)) +	/* _TX_USECS */
+	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_FRAMES */
+	       nla_total_size(sizeof(u32)) +	/* _TX_USECS_IRQ */
+	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_FRAMES_IRQ */
+	       nla_total_size(sizeof(u32)) +	/* _STATS_BLOCK_USECS */
+	       nla_total_size(sizeof(u8)) +	/* _USE_ADAPTIVE_RX */
+	       nla_total_size(sizeof(u8)) +	/* _USE_ADAPTIVE_TX */
+	       nla_total_size(sizeof(u32)) +	/* _PKT_RATE_LOW */
+	       nla_total_size(sizeof(u32)) +	/* _RX_USECS_LOW */
+	       nla_total_size(sizeof(u32)) +	/* _RX_MAX_FRAMES_LOW */
+	       nla_total_size(sizeof(u32)) +	/* _TX_USECS_LOW */
+	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_FRAMES_LOW */
+	       nla_total_size(sizeof(u32)) +	/* _PKT_RATE_HIGH */
+	       nla_total_size(sizeof(u32)) +	/* _RX_USECS_HIGH */
+	       nla_total_size(sizeof(u32)) +	/* _RX_MAX_FRAMES_HIGH */
+	       nla_total_size(sizeof(u32)) +	/* _TX_USECS_HIGH */
+	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_FRAMES_HIGH */
+	       nla_total_size(sizeof(u32));	/* _RATE_SAMPLE_INTERVAL */
+}
+
+static bool coalesce_put_u32(struct sk_buff *skb, u16 attr_type, u32 val,
+			     u32 supported_params)
+{
+	if (!val && !(supported_params & attr_to_mask(attr_type)))
+		return false;
+	return nla_put_u32(skb, attr_type, val);
+}
+
+static bool coalesce_put_bool(struct sk_buff *skb, u16 attr_type, u32 val,
+			      u32 supported_params)
+{
+	if (!val && !(supported_params & attr_to_mask(attr_type)))
+		return false;
+	return nla_put_u8(skb, attr_type, !!val);
+}
+
+static int coalesce_fill_reply(struct sk_buff *skb,
+			       const struct ethnl_req_info *req_base,
+			       const struct ethnl_reply_data *reply_base)
+{
+	const struct coalesce_reply_data *data = COALESCE_REPDATA(reply_base);
+	const struct ethtool_coalesce *coal = &data->coalesce;
+	u32 supported = data->supported_params;
+
+	if (coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_USECS,
+			     coal->rx_coalesce_usecs, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_MAX_FRAMES,
+			     coal->rx_max_coalesced_frames, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_USECS_IRQ,
+			     coal->rx_coalesce_usecs_irq, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ,
+			     coal->rx_max_coalesced_frames_irq, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_USECS,
+			     coal->tx_coalesce_usecs, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES,
+			     coal->tx_max_coalesced_frames, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_USECS_IRQ,
+			     coal->tx_coalesce_usecs_irq, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ,
+			     coal->tx_max_coalesced_frames_irq, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_STATS_BLOCK_USECS,
+			     coal->stats_block_coalesce_usecs, supported) ||
+	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX,
+			      coal->use_adaptive_rx_coalesce, supported) ||
+	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX,
+			      coal->use_adaptive_tx_coalesce, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_PKT_RATE_LOW,
+			     coal->pkt_rate_low, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_USECS_LOW,
+			     coal->rx_coalesce_usecs_low, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW,
+			     coal->rx_max_coalesced_frames_low, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_USECS_LOW,
+			     coal->tx_coalesce_usecs_low, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW,
+			     coal->tx_max_coalesced_frames_low, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_PKT_RATE_HIGH,
+			     coal->pkt_rate_high, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_USECS_HIGH,
+			     coal->rx_coalesce_usecs_high, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH,
+			     coal->rx_max_coalesced_frames_high, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_USECS_HIGH,
+			     coal->tx_coalesce_usecs_high, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,
+			     coal->tx_max_coalesced_frames_high, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,
+			     coal->rate_sample_interval, supported))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_coalesce_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_COALESCE_GET,
+	.reply_cmd		= ETHTOOL_MSG_COALESCE_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_COALESCE_HEADER,
+	.max_attr		= ETHTOOL_A_COALESCE_MAX,
+	.req_info_size		= sizeof(struct coalesce_req_info),
+	.reply_data_size	= sizeof(struct coalesce_reply_data),
+	.request_policy		= coalesce_get_policy,
+
+	.prepare_data		= coalesce_prepare_data,
+	.reply_size		= coalesce_reply_size,
+	.fill_reply		= coalesce_fill_reply,
+};
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 71855bdd3b38..3db6ad69ebc9 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -227,6 +227,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_PRIVFLAGS_GET]	= &ethnl_privflags_request_ops,
 	[ETHTOOL_MSG_RINGS_GET]		= &ethnl_rings_request_ops,
 	[ETHTOOL_MSG_CHANNELS_GET]	= &ethnl_channels_request_ops,
+	[ETHTOOL_MSG_COALESCE_GET]	= &ethnl_coalesce_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -786,6 +787,13 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_channels,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_COALESCE_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 45aad99a6021..8b8991867ee5 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -341,6 +341,7 @@ extern const struct ethnl_request_ops ethnl_features_request_ops;
 extern const struct ethnl_request_ops ethnl_privflags_request_ops;
 extern const struct ethnl_request_ops ethnl_rings_request_ops;
 extern const struct ethnl_request_ops ethnl_channels_request_ops;
+extern const struct ethnl_request_ops ethnl_coalesce_request_ops;
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
-- 
2.25.1

