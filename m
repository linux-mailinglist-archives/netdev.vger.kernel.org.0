Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C68FF182418
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 22:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbgCKVlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 17:41:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:47116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729842AbgCKVlV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 17:41:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DF4EBAFAA;
        Wed, 11 Mar 2020 21:41:18 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 91248E0C0A; Wed, 11 Mar 2020 22:41:18 +0100 (CET)
Message-Id: <62ce4aad74028e861c4c8d28b663ee16549226e0.1583962006.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583962006.git.mkubecek@suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 15/15] ethtool: add CHANNELS_NTF notification
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Wed, 11 Mar 2020 22:41:18 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send ETHTOOL_MSG_CHANNELS_NTF notification whenever channel counts of
a network device are modified using ETHTOOL_MSG_CHANNELS_SET netlink
message or ETHTOOL_SCHANNELS ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 1 +
 include/uapi/linux/ethtool_netlink.h         | 1 +
 net/ethtool/channels.c                       | 3 +++
 net/ethtool/ioctl.c                          | 6 +++++-
 net/ethtool/netlink.c                        | 2 ++
 5 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 7df7476cf310..31a601cafa3f 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -220,6 +220,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_RINGS_GET_REPLY``       ring sizes
   ``ETHTOOL_MSG_RINGS_NTF``             ring sizes
   ``ETHTOOL_MSG_CHANNELS_GET_REPLY``    channel counts
+  ``ETHTOOL_MSG_CHANNELS_NTF``          channel counts
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index f1384a8f3534..c7c7a1a550af 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -59,6 +59,7 @@ enum {
 	ETHTOOL_MSG_RINGS_GET_REPLY,
 	ETHTOOL_MSG_RINGS_NTF,
 	ETHTOOL_MSG_CHANNELS_GET_REPLY,
+	ETHTOOL_MSG_CHANNELS_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 412b6380766d..04d1a75a55c7 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -203,6 +203,9 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 		}
 
 	ret = dev->ethtool_ops->set_channels(dev, &channels);
+	if (ret < 0)
+		goto out_ops;
+	ethtool_notify(dev, ETHTOOL_MSG_CHANNELS_NTF, NULL);
 
 out_ops:
 	ethnl_ops_complete(dev);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 06224a03139e..258840b19fb5 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1649,6 +1649,7 @@ static noinline_for_stack int ethtool_set_channels(struct net_device *dev,
 	u16 from_channel, to_channel;
 	u32 max_rx_in_use = 0;
 	unsigned int i;
+	int ret;
 
 	if (!dev->ethtool_ops->set_channels || !dev->ethtool_ops->get_channels)
 		return -EOPNOTSUPP;
@@ -1680,7 +1681,10 @@ static noinline_for_stack int ethtool_set_channels(struct net_device *dev,
 		if (xdp_get_umem_from_qid(dev, i))
 			return -EINVAL;
 
-	return dev->ethtool_ops->set_channels(dev, &channels);
+	ret = dev->ethtool_ops->set_channels(dev, &channels);
+	if (!ret)
+		ethtool_notify(dev, ETHTOOL_MSG_CHANNELS_NTF, NULL);
+	return ret;
 }
 
 static int ethtool_get_pauseparam(struct net_device *dev, void __user *useraddr)
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index f61654b8f210..55c8ce4019d9 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -534,6 +534,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_FEATURES_NTF]	= &ethnl_features_request_ops,
 	[ETHTOOL_MSG_PRIVFLAGS_NTF]	= &ethnl_privflags_request_ops,
 	[ETHTOOL_MSG_RINGS_NTF]		= &ethnl_rings_request_ops,
+	[ETHTOOL_MSG_CHANNELS_NTF]	= &ethnl_channels_request_ops,
 };
 
 /* default notification handler */
@@ -622,6 +623,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_FEATURES_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_PRIVFLAGS_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_RINGS_NTF]		= ethnl_default_notify,
+	[ETHTOOL_MSG_CHANNELS_NTF]	= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
-- 
2.25.1

