Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A33718240F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 22:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbgCKVlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 17:41:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:46892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729656AbgCKVlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 17:41:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C9134AF8C;
        Wed, 11 Mar 2020 21:41:03 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 7DA77E0C0A; Wed, 11 Mar 2020 22:41:03 +0100 (CET)
Message-Id: <ee9a57d9bd6d637587a3ca653b6f0cc02a6c505a.1583962006.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583962006.git.mkubecek@suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 12/15] ethtool: add RINGS_NTF notification
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Wed, 11 Mar 2020 22:41:03 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send ETHTOOL_MSG_RINGS_NTF notification whenever ring sizes of a network
device are modified using ETHTOOL_MSG_RINGS_SET netlink message or
ETHTOOL_SRINGPARAM ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 1 +
 include/uapi/linux/ethtool_netlink.h         | 1 +
 net/ethtool/ioctl.c                          | 6 +++++-
 net/ethtool/netlink.c                        | 2 ++
 net/ethtool/rings.c                          | 3 +++
 5 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index ba31ae8f1feb..026a5fd4a08b 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -216,6 +216,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_PRIVFLAGS_GET_REPLY``   private flags
   ``ETHTOOL_MSG_PRIVFLAGS_NTF``         private flags
   ``ETHTOOL_MSG_RINGS_GET_REPLY``       ring sizes
+  ``ETHTOOL_MSG_RINGS_NTF``             ring sizes
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index ae71801b7aac..abfc8fd626da 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -55,6 +55,7 @@ enum {
 	ETHTOOL_MSG_PRIVFLAGS_GET_REPLY,
 	ETHTOOL_MSG_PRIVFLAGS_NTF,
 	ETHTOOL_MSG_RINGS_GET_REPLY,
+	ETHTOOL_MSG_RINGS_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 298822289496..1d5c1b6b81a4 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1635,6 +1635,7 @@ static int ethtool_get_ringparam(struct net_device *dev, void __user *useraddr)
 static int ethtool_set_ringparam(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_ringparam ringparam, max = { .cmd = ETHTOOL_GRINGPARAM };
+	int ret;
 
 	if (!dev->ethtool_ops->set_ringparam || !dev->ethtool_ops->get_ringparam)
 		return -EOPNOTSUPP;
@@ -1651,7 +1652,10 @@ static int ethtool_set_ringparam(struct net_device *dev, void __user *useraddr)
 	    ringparam.tx_pending > max.tx_max_pending)
 		return -EINVAL;
 
-	return dev->ethtool_ops->set_ringparam(dev, &ringparam);
+	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam);
+	if (!ret)
+		ethtool_notify(dev, ETHTOOL_MSG_RINGS_NTF, NULL);
+	return ret;
 }
 
 static noinline_for_stack int ethtool_get_channels(struct net_device *dev,
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 6a1ac8897a7e..653e009216cd 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -532,6 +532,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_WOL_NTF]		= &ethnl_wol_request_ops,
 	[ETHTOOL_MSG_FEATURES_NTF]	= &ethnl_features_request_ops,
 	[ETHTOOL_MSG_PRIVFLAGS_NTF]	= &ethnl_privflags_request_ops,
+	[ETHTOOL_MSG_RINGS_NTF]		= &ethnl_rings_request_ops,
 };
 
 /* default notification handler */
@@ -619,6 +620,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_WOL_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_FEATURES_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_PRIVFLAGS_NTF]	= ethnl_default_notify,
+	[ETHTOOL_MSG_RINGS_NTF]		= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
index 56e628456619..0e29443e13d6 100644
--- a/net/ethtool/rings.c
+++ b/net/ethtool/rings.c
@@ -176,6 +176,9 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam);
+	if (ret < 0)
+		goto out_ops;
+	ethtool_notify(dev, ETHTOOL_MSG_RINGS_NTF, NULL);
 
 out_ops:
 	ethnl_ops_complete(dev);
-- 
2.25.1

