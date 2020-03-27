Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D28194DD4
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 01:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgC0AMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 20:12:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:42684 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727509AbgC0AMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 20:12:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 479BCB1EC;
        Fri, 27 Mar 2020 00:12:23 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id ED5F7E00A5; Fri, 27 Mar 2020 01:12:22 +0100 (CET)
Message-Id: <b500382ba0e0c17d5aeba19597ca7b53c33c6198.1585267388.git.mkubecek@suse.cz>
In-Reply-To: <cover.1585267388.git.mkubecek@suse.cz>
References: <cover.1585267388.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 07/12] ethtool: add PAUSE_NTF notification
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Mar 2020 01:12:22 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send ETHTOOL_MSG_PAUSE_NTF notification whenever pause parameters of
a network device are modified using ETHTOOL_MSG_PAUSE_SET netlink message
or ETHTOOL_SPAUSEPARAM ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 1 +
 include/uapi/linux/ethtool_netlink.h         | 1 +
 net/ethtool/ioctl.c                          | 6 +++++-
 net/ethtool/netlink.c                        | 2 ++
 net/ethtool/pause.c                          | 3 +++
 5 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index dc7b3fe47f37..0cc9e69cb90d 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -228,6 +228,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_COALESCE_GET_REPLY``    coalescing parameters
   ``ETHTOOL_MSG_COALESCE_NTF``          coalescing parameters
   ``ETHTOOL_MSG_PAUSE_GET_REPLY``       pause parameters
+  ``ETHTOOL_MSG_PAUSE_NTF``             pause parameters
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index a9a35c7b81d4..a53d79dd5ad4 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -67,6 +67,7 @@ enum {
 	ETHTOOL_MSG_COALESCE_GET_REPLY,
 	ETHTOOL_MSG_COALESCE_NTF,
 	ETHTOOL_MSG_PAUSE_GET_REPLY,
+	ETHTOOL_MSG_PAUSE_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 198825ebc114..c7a039a6e11e 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1705,6 +1705,7 @@ static int ethtool_get_pauseparam(struct net_device *dev, void __user *useraddr)
 static int ethtool_set_pauseparam(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_pauseparam pauseparam;
+	int ret;
 
 	if (!dev->ethtool_ops->set_pauseparam)
 		return -EOPNOTSUPP;
@@ -1712,7 +1713,10 @@ static int ethtool_set_pauseparam(struct net_device *dev, void __user *useraddr)
 	if (copy_from_user(&pauseparam, useraddr, sizeof(pauseparam)))
 		return -EFAULT;
 
-	return dev->ethtool_ops->set_pauseparam(dev, &pauseparam);
+	ret = dev->ethtool_ops->set_pauseparam(dev, &pauseparam);
+	if (!ret)
+		ethtool_notify(dev, ETHTOOL_MSG_PAUSE_NTF, NULL);
+	return ret;
 }
 
 static int ethtool_self_test(struct net_device *dev, char __user *useraddr)
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 1ca30578e642..4d492f1b3480 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -546,6 +546,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_RINGS_NTF]		= &ethnl_rings_request_ops,
 	[ETHTOOL_MSG_CHANNELS_NTF]	= &ethnl_channels_request_ops,
 	[ETHTOOL_MSG_COALESCE_NTF]	= &ethnl_coalesce_request_ops,
+	[ETHTOOL_MSG_PAUSE_NTF]		= &ethnl_pause_request_ops,
 };
 
 /* default notification handler */
@@ -636,6 +637,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_RINGS_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_CHANNELS_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_COALESCE_NTF]	= ethnl_default_notify,
+	[ETHTOOL_MSG_PAUSE_NTF]		= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index c307b91fdfba..7aea35d1e8a5 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -131,6 +131,9 @@ int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 
 	ret = dev->ethtool_ops->set_pauseparam(dev, &params);
+	if (ret < 0)
+		goto out_ops;
+	ethtool_notify(dev, ETHTOOL_MSG_PAUSE_NTF, NULL);
 
 out_ops:
 	ethnl_ops_complete(dev);
-- 
2.25.1

