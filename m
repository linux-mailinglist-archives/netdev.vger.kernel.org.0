Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1BF183A57
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgCLUIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:08:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:45640 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727165AbgCLUIq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:08:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2459FAF7A;
        Thu, 12 Mar 2020 20:08:44 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id C4AA9E0C79; Thu, 12 Mar 2020 21:08:43 +0100 (CET)
Message-Id: <58eaff0d7ec1cd4a85142c07e4a1c97772b784e3.1584043144.git.mkubecek@suse.cz>
In-Reply-To: <cover.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 14/15] ethtool: set device channel counts with
 CHANNELS_SET request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Mar 2020 21:08:43 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement CHANNELS_SET netlink request to set channel counts of a network
device. These are traditionally set with ETHTOOL_SCHANNELS ioctl request.

Like the ioctl implementation, the generic ethtool code checks if supplied
values do not exceed driver defined limits; if they do, first offending
attribute is reported using extack. Checks preventing removing channels
used for RX indirection table or zerocopy AF_XDP socket are also
implemented.

Move ethtool_get_max_rxfh_channel() helper into common.c so that it can be
used by both ioctl and netlink code.

v2:
  - fix netdev reference leak in error path (found by Jakub Kicinsky)

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst |  23 +++-
 include/uapi/linux/ethtool_netlink.h         |   1 +
 net/ethtool/channels.c                       | 116 +++++++++++++++++++
 net/ethtool/common.c                         |  31 +++++
 net/ethtool/common.h                         |   1 +
 net/ethtool/ioctl.c                          |  31 -----
 net/ethtool/netlink.c                        |   5 +
 net/ethtool/netlink.h                        |   1 +
 8 files changed, 177 insertions(+), 32 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index decbbddfd8be..7df7476cf310 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -196,6 +196,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_RINGS_GET``             get ring sizes
   ``ETHTOOL_MSG_RINGS_SET``             set ring sizes
   ``ETHTOOL_MSG_CHANNELS_GET``          get channel counts
+  ``ETHTOOL_MSG_CHANNELS_SET``          set channel counts
   ===================================== ================================
 
 Kernel to userspace:
@@ -723,6 +724,26 @@ Kernel response contents:
   =====================================  ======  ==========================
 
 
+CHANNELS_SET
+============
+
+Sets channel counts like ``ETHTOOL_SCHANNELS`` ioctl request.
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_A_CHANNELS_HEADER``          nested  request header
+  ``ETHTOOL_A_CHANNELS_RX_COUNT``        u32     receive channel count
+  ``ETHTOOL_A_CHANNELS_TX_COUNT``        u32     transmit channel count
+  ``ETHTOOL_A_CHANNELS_OTHER_COUNT``     u32     other channel count
+  ``ETHTOOL_A_CHANNELS_COMBINED_COUNT``  u32     combined channel count
+  =====================================  ======  ==========================
+
+Kernel checks that requested channel counts do not exceed limits reported by
+driver. Driver may impose additional constraints and may not suspport all
+attributes.
+
+
 Request translation
 ===================
 
@@ -794,7 +815,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GFEATURES``               ``ETHTOOL_MSG_FEATURES_GET``
   ``ETHTOOL_SFEATURES``               ``ETHTOOL_MSG_FEATURES_SET``
   ``ETHTOOL_GCHANNELS``               ``ETHTOOL_MSG_CHANNELS_GET``
-  ``ETHTOOL_SCHANNELS``               n/a
+  ``ETHTOOL_SCHANNELS``               ``ETHTOOL_MSG_CHANNELS_SET``
   ``ETHTOOL_SET_DUMP``                n/a
   ``ETHTOOL_GET_DUMP_FLAG``           n/a
   ``ETHTOOL_GET_DUMP_DATA``           n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 2270eb115eca..f1384a8f3534 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -31,6 +31,7 @@ enum {
 	ETHTOOL_MSG_RINGS_GET,
 	ETHTOOL_MSG_RINGS_SET,
 	ETHTOOL_MSG_CHANNELS_GET,
+	ETHTOOL_MSG_CHANNELS_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 500dd5ad250b..ee232c11acae 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <net/xdp_sock.h>
+
 #include "netlink.h"
 #include "common.h"
 
@@ -106,3 +108,117 @@ const struct ethnl_request_ops ethnl_channels_request_ops = {
 	.reply_size		= channels_reply_size,
 	.fill_reply		= channels_fill_reply,
 };
+
+/* CHANNELS_SET */
+
+static const struct nla_policy
+channels_set_policy[ETHTOOL_A_CHANNELS_MAX + 1] = {
+	[ETHTOOL_A_CHANNELS_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_CHANNELS_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_CHANNELS_RX_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_CHANNELS_TX_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_CHANNELS_OTHER_MAX]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_CHANNELS_COMBINED_MAX]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_CHANNELS_RX_COUNT]		= { .type = NLA_U32 },
+	[ETHTOOL_A_CHANNELS_TX_COUNT]		= { .type = NLA_U32 },
+	[ETHTOOL_A_CHANNELS_OTHER_COUNT]	= { .type = NLA_U32 },
+	[ETHTOOL_A_CHANNELS_COMBINED_COUNT]	= { .type = NLA_U32 },
+};
+
+int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_CHANNELS_MAX + 1];
+	unsigned int from_channel, old_total, i;
+	struct ethtool_channels channels = {};
+	struct ethnl_req_info req_info = {};
+	const struct nlattr *err_attr;
+	const struct ethtool_ops *ops;
+	struct net_device *dev;
+	u32 max_rx_in_use = 0;
+	bool mod = false;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
+			  ETHTOOL_A_CHANNELS_MAX, channels_set_policy,
+			  info->extack);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_CHANNELS_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	ops = dev->ethtool_ops;
+	ret = -EOPNOTSUPP;
+	if (!ops->get_channels || !ops->set_channels)
+		goto out_dev;
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+	ops->get_channels(dev, &channels);
+	old_total = channels.combined_count +
+		    max(channels.rx_count, channels.tx_count);
+
+	ethnl_update_u32(&channels.rx_count, tb[ETHTOOL_A_CHANNELS_RX_COUNT],
+			 &mod);
+	ethnl_update_u32(&channels.tx_count, tb[ETHTOOL_A_CHANNELS_TX_COUNT],
+			 &mod);
+	ethnl_update_u32(&channels.other_count,
+			 tb[ETHTOOL_A_CHANNELS_OTHER_COUNT], &mod);
+	ethnl_update_u32(&channels.combined_count,
+			 tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT], &mod);
+	ret = 0;
+	if (!mod)
+		goto out_ops;
+
+	/* ensure new channel counts are within limits */
+	if (channels.rx_count > channels.max_rx)
+		err_attr = tb[ETHTOOL_A_CHANNELS_RX_COUNT];
+	else if (channels.tx_count > channels.max_tx)
+		err_attr = tb[ETHTOOL_A_CHANNELS_TX_COUNT];
+	else if (channels.other_count > channels.max_other)
+		err_attr = tb[ETHTOOL_A_CHANNELS_OTHER_COUNT];
+	else if (channels.combined_count > channels.max_combined)
+		err_attr = tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
+	else
+		err_attr = NULL;
+	if (err_attr) {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG_ATTR(info->extack, err_attr,
+				    "requested channel count exceeeds maximum");
+		goto out_ops;
+	}
+
+	/* ensure the new Rx count fits within the configured Rx flow
+	 * indirection table settings
+	 */
+	if (netif_is_rxfh_configured(dev) &&
+	    !ethtool_get_max_rxfh_channel(dev, &max_rx_in_use) &&
+	    (channels.combined_count + channels.rx_count) <= max_rx_in_use) {
+		GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing indirection table settings");
+		return -EINVAL;
+	}
+
+	/* Disabling channels, query zero-copy AF_XDP sockets */
+	from_channel = channels.combined_count +
+		       min(channels.rx_count, channels.tx_count);
+	for (i = from_channel; i < old_total; i++)
+		if (xdp_get_umem_from_qid(dev, i)) {
+			GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing zerocopy AF_XDP sockets");
+			return -EINVAL;
+		}
+
+	ret = dev->ethtool_ops->set_channels(dev, &channels);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+out_dev:
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 7b6969af5ae7..0b22741b2f8f 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -258,3 +258,34 @@ int __ethtool_get_link(struct net_device *dev)
 
 	return netif_running(dev) && dev->ethtool_ops->get_link(dev);
 }
+
+int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max)
+{
+	u32 dev_size, current_max = 0;
+	u32 *indir;
+	int ret;
+
+	if (!dev->ethtool_ops->get_rxfh_indir_size ||
+	    !dev->ethtool_ops->get_rxfh)
+		return -EOPNOTSUPP;
+	dev_size = dev->ethtool_ops->get_rxfh_indir_size(dev);
+	if (dev_size == 0)
+		return -EOPNOTSUPP;
+
+	indir = kcalloc(dev_size, sizeof(indir[0]), GFP_USER);
+	if (!indir)
+		return -ENOMEM;
+
+	ret = dev->ethtool_ops->get_rxfh(dev, indir, NULL, NULL);
+	if (ret)
+		goto out;
+
+	while (dev_size--)
+		current_max = max(current_max, indir[dev_size]);
+
+	*max = current_max;
+
+out:
+	kfree(indir);
+	return ret;
+}
diff --git a/net/ethtool/common.h b/net/ethtool/common.h
index 7dc1163800a7..03946e16e623 100644
--- a/net/ethtool/common.h
+++ b/net/ethtool/common.h
@@ -29,5 +29,6 @@ int __ethtool_get_link(struct net_device *dev);
 bool convert_legacy_settings_to_link_ksettings(
 	struct ethtool_link_ksettings *link_ksettings,
 	const struct ethtool_cmd *legacy_settings);
+int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max);
 
 #endif /* _ETHTOOL_COMMON_H */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 1d5c1b6b81a4..06224a03139e 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -929,37 +929,6 @@ void netdev_rss_key_fill(void *buffer, size_t len)
 }
 EXPORT_SYMBOL(netdev_rss_key_fill);
 
-static int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max)
-{
-	u32 dev_size, current_max = 0;
-	u32 *indir;
-	int ret;
-
-	if (!dev->ethtool_ops->get_rxfh_indir_size ||
-	    !dev->ethtool_ops->get_rxfh)
-		return -EOPNOTSUPP;
-	dev_size = dev->ethtool_ops->get_rxfh_indir_size(dev);
-	if (dev_size == 0)
-		return -EOPNOTSUPP;
-
-	indir = kcalloc(dev_size, sizeof(indir[0]), GFP_USER);
-	if (!indir)
-		return -ENOMEM;
-
-	ret = dev->ethtool_ops->get_rxfh(dev, indir, NULL, NULL);
-	if (ret)
-		goto out;
-
-	while (dev_size--)
-		current_max = max(current_max, indir[dev_size]);
-
-	*max = current_max;
-
-out:
-	kfree(indir);
-	return ret;
-}
-
 static noinline_for_stack int ethtool_get_rxfh_indir(struct net_device *dev,
 						     void __user *useraddr)
 {
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index ac35513abeed..f61654b8f210 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -771,6 +771,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_CHANNELS_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_channels,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 53bfe720ff1a..45aad99a6021 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -349,5 +349,6 @@ int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_features(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.25.1

