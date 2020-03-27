Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1634219588B
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 15:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgC0OHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 10:07:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:40642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgC0OHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 10:07:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BC4C4AD60;
        Fri, 27 Mar 2020 14:07:32 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 6519FE009C; Fri, 27 Mar 2020 15:07:32 +0100 (CET)
Message-Id: <6e422c10036f247adb2a7984dc25d27edd52860e.1585316159.git.mkubecek@suse.cz>
In-Reply-To: <cover.1585316159.git.mkubecek@suse.cz>
References: <cover.1585316159.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 03/12] ethtool: set coalescing parameters with
 COALESCE_SET request
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Mar 2020 15:07:32 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement COALESCE_SET netlink request to set coalescing parameters of
a network device. These are traditionally set with ETHTOOL_SCOALESCE ioctl
request. This commit adds only support for device coalescing parameters,
not per queue coalescing parameters.

Like the ioctl implementation, the generic ethtool code checks if only
supported parameters are modified; if not, first offending attribute is
reported using extack.

v2: fix alignment (whitespace only)

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst |  42 +++++-
 include/uapi/linux/ethtool_netlink.h         |   1 +
 net/ethtool/coalesce.c                       | 136 +++++++++++++++++++
 net/ethtool/netlink.c                        |   5 +
 net/ethtool/netlink.h                        |   1 +
 5 files changed, 184 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 1e84686a998b..b593c7f50934 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -198,6 +198,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_CHANNELS_GET``          get channel counts
   ``ETHTOOL_MSG_CHANNELS_SET``          set channel counts
   ``ETHTOOL_MSG_COALESCE_GET``          get coalescing parameters
+  ``ETHTOOL_MSG_COALESCE_SET``          set coalescing parameters
   ===================================== ================================
 
 Kernel to userspace:
@@ -791,6 +792,45 @@ corresponding bit in ``ethtool_ops::supported_coalesce_params`` is set (i.e.
 they are declared as supported by driver).
 
 
+COALESCE_SET
+============
+
+Sets coalescing parameters like ``ETHTOOL_SCOALESCE`` ioctl request.
+
+Request contents:
+
+  ===========================================  ======  =======================
+  ``ETHTOOL_A_COALESCE_HEADER``                nested  request header
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
+Request is rejected if it attributes declared as unsupported by driver (i.e.
+such that the corresponding bit in ``ethtool_ops::supported_coalesce_params``
+is not set), regardless of their values. Driver may impose additional
+constraints on coalescing parameters and their values.
+
+
 Request translation
 ===================
 
@@ -816,7 +856,7 @@ have their netlink replacement yet.
   ``ETHTOOL_GEEPROM``                 n/a
   ``ETHTOOL_SEEPROM``                 n/a
   ``ETHTOOL_GCOALESCE``               ``ETHTOOL_MSG_COALESCE_GET``
-  ``ETHTOOL_SCOALESCE``               n/a
+  ``ETHTOOL_SCOALESCE``               ``ETHTOOL_MSG_COALESCE_SET``
   ``ETHTOOL_GRINGPARAM``              ``ETHTOOL_MSG_RINGS_GET``
   ``ETHTOOL_SRINGPARAM``              ``ETHTOOL_MSG_RINGS_SET``
   ``ETHTOOL_GPAUSEPARAM``             n/a
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index ed0c0fa103cd..d9f4047c64c3 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -33,6 +33,7 @@ enum {
 	ETHTOOL_MSG_CHANNELS_GET,
 	ETHTOOL_MSG_CHANNELS_SET,
 	ETHTOOL_MSG_COALESCE_GET,
+	ETHTOOL_MSG_COALESCE_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index ba5f2cec4ac4..6cf1a7ebf0c5 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -212,3 +212,139 @@ const struct ethnl_request_ops ethnl_coalesce_request_ops = {
 	.reply_size		= coalesce_reply_size,
 	.fill_reply		= coalesce_fill_reply,
 };
+
+/* COALESCE_SET */
+
+static const struct nla_policy
+coalesce_set_policy[ETHTOOL_A_COALESCE_MAX + 1] = {
+	[ETHTOOL_A_COALESCE_UNSPEC]		= { .type = NLA_REJECT },
+	[ETHTOOL_A_COALESCE_HEADER]		= { .type = NLA_NESTED },
+	[ETHTOOL_A_COALESCE_RX_USECS]		= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_RX_USECS_IRQ]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_USECS]		= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_USECS_IRQ]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_STATS_BLOCK_USECS]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX]	= { .type = NLA_U8 },
+	[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX]	= { .type = NLA_U8 },
+	[ETHTOOL_A_COALESCE_PKT_RATE_LOW]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_RX_USECS_LOW]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_USECS_LOW]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_PKT_RATE_HIGH]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_RX_USECS_HIGH]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_USECS_HIGH]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH]	= { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL] = { .type = NLA_U32 },
+};
+
+int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_COALESCE_MAX + 1];
+	struct ethtool_coalesce coalesce = {};
+	struct ethnl_req_info req_info = {};
+	const struct ethtool_ops *ops;
+	struct net_device *dev;
+	u32 supported_params;
+	bool mod = false;
+	int ret;
+	u16 a;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
+			  ETHTOOL_A_COALESCE_MAX, coalesce_set_policy,
+			  info->extack);
+	if (ret < 0)
+		return ret;
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_COALESCE_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
+	if (ret < 0)
+		return ret;
+	dev = req_info.dev;
+	ops = dev->ethtool_ops;
+	ret = -EOPNOTSUPP;
+	if (!ops->get_coalesce || !ops->set_coalesce)
+		goto out_dev;
+
+	/* make sure that only supported parameters are present */
+	supported_params = ops->supported_coalesce_params;
+	for (a = ETHTOOL_A_COALESCE_RX_USECS; a < __ETHTOOL_A_COALESCE_CNT; a++)
+		if (tb[a] && !(supported_params & attr_to_mask(a))) {
+			ret = -EINVAL;
+			NL_SET_ERR_MSG_ATTR(info->extack, tb[a],
+					    "cannot modify an unsupported parameter");
+			goto out_dev;
+		}
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl;
+	ret = ops->get_coalesce(dev, &coalesce);
+	if (ret < 0)
+		goto out_ops;
+
+	ethnl_update_u32(&coalesce.rx_coalesce_usecs,
+			 tb[ETHTOOL_A_COALESCE_RX_USECS], &mod);
+	ethnl_update_u32(&coalesce.rx_max_coalesced_frames,
+			 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES], &mod);
+	ethnl_update_u32(&coalesce.rx_coalesce_usecs_irq,
+			 tb[ETHTOOL_A_COALESCE_RX_USECS_IRQ], &mod);
+	ethnl_update_u32(&coalesce.rx_max_coalesced_frames_irq,
+			 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ], &mod);
+	ethnl_update_u32(&coalesce.tx_coalesce_usecs,
+			 tb[ETHTOOL_A_COALESCE_TX_USECS], &mod);
+	ethnl_update_u32(&coalesce.tx_max_coalesced_frames,
+			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES], &mod);
+	ethnl_update_u32(&coalesce.tx_coalesce_usecs_irq,
+			 tb[ETHTOOL_A_COALESCE_TX_USECS_IRQ], &mod);
+	ethnl_update_u32(&coalesce.tx_max_coalesced_frames_irq,
+			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ], &mod);
+	ethnl_update_u32(&coalesce.stats_block_coalesce_usecs,
+			 tb[ETHTOOL_A_COALESCE_STATS_BLOCK_USECS], &mod);
+	ethnl_update_bool32(&coalesce.use_adaptive_rx_coalesce,
+			    tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX], &mod);
+	ethnl_update_bool32(&coalesce.use_adaptive_tx_coalesce,
+			    tb[ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX], &mod);
+	ethnl_update_u32(&coalesce.pkt_rate_low,
+			 tb[ETHTOOL_A_COALESCE_PKT_RATE_LOW], &mod);
+	ethnl_update_u32(&coalesce.rx_coalesce_usecs_low,
+			 tb[ETHTOOL_A_COALESCE_RX_USECS_LOW], &mod);
+	ethnl_update_u32(&coalesce.rx_max_coalesced_frames_low,
+			 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW], &mod);
+	ethnl_update_u32(&coalesce.tx_coalesce_usecs_low,
+			 tb[ETHTOOL_A_COALESCE_TX_USECS_LOW], &mod);
+	ethnl_update_u32(&coalesce.tx_max_coalesced_frames_low,
+			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW], &mod);
+	ethnl_update_u32(&coalesce.pkt_rate_high,
+			 tb[ETHTOOL_A_COALESCE_PKT_RATE_HIGH], &mod);
+	ethnl_update_u32(&coalesce.rx_coalesce_usecs_high,
+			 tb[ETHTOOL_A_COALESCE_RX_USECS_HIGH], &mod);
+	ethnl_update_u32(&coalesce.rx_max_coalesced_frames_high,
+			 tb[ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH], &mod);
+	ethnl_update_u32(&coalesce.tx_coalesce_usecs_high,
+			 tb[ETHTOOL_A_COALESCE_TX_USECS_HIGH], &mod);
+	ethnl_update_u32(&coalesce.tx_max_coalesced_frames_high,
+			 tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], &mod);
+	ethnl_update_u32(&coalesce.rate_sample_interval,
+			 tb[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL], &mod);
+	ret = 0;
+	if (!mod)
+		goto out_ops;
+
+	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
+
+out_ops:
+	ethnl_ops_complete(dev);
+out_rtnl:
+	rtnl_unlock();
+out_dev:
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 3db6ad69ebc9..3a236b4dfbf3 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -794,6 +794,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.dumpit	= ethnl_default_dumpit,
 		.done	= ethnl_default_done,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_COALESCE_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_coalesce,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 8b8991867ee5..c3fb4fe5a3b7 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -351,5 +351,6 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.25.1

