Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA9CB1961AF
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 00:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgC0XBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 19:01:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:44796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgC0XBu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 19:01:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F118AADC9;
        Fri, 27 Mar 2020 23:01:48 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id A1162E0FC6; Sat, 28 Mar 2020 00:01:48 +0100 (CET)
Message-Id: <fce3407bfd8c49e06aa29aa96932352eb06b76bd.1585349448.git.mkubecek@suse.cz>
In-Reply-To: <cover.1585349448.git.mkubecek@suse.cz>
References: <cover.1585349448.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v3 10/12] ethtool: add EEE_NTF notification
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Date:   Sat, 28 Mar 2020 00:01:48 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send ETHTOOL_MSG_EEE_NTF notification whenever EEE settings of a network
device are modified using ETHTOOL_MSG_EEE_SET netlink message or
ETHTOOL_SEEE ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 1 +
 include/uapi/linux/ethtool_netlink.h         | 1 +
 net/ethtool/eee.c                            | 3 +++
 net/ethtool/ioctl.c                          | 6 +++++-
 net/ethtool/netlink.c                        | 2 ++
 5 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 856c4b5bcd6a..f1950a0a6c93 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -232,6 +232,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_PAUSE_GET_REPLY``       pause parameters
   ``ETHTOOL_MSG_PAUSE_NTF``             pause parameters
   ``ETHTOOL_MSG_EEE_GET_REPLY``         EEE settings
+  ``ETHTOOL_MSG_EEE_NTF``               EEE settings
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 8959bc899f3c..bacdd5363510 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -71,6 +71,7 @@ enum {
 	ETHTOOL_MSG_PAUSE_GET_REPLY,
 	ETHTOOL_MSG_PAUSE_NTF,
 	ETHTOOL_MSG_EEE_GET_REPLY,
+	ETHTOOL_MSG_EEE_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/eee.c b/net/ethtool/eee.c
index ded092d1b2b9..94aa19cff22f 100644
--- a/net/ethtool/eee.c
+++ b/net/ethtool/eee.c
@@ -192,6 +192,9 @@ int ethnl_set_eee(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 
 	ret = dev->ethtool_ops->set_eee(dev, &eee);
+	if (ret < 0)
+		goto out_ops;
+	ethtool_notify(dev, ETHTOOL_MSG_EEE_NTF, NULL);
 
 out_ops:
 	ethnl_ops_complete(dev);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index c7a039a6e11e..05a2bf64a96b 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1354,6 +1354,7 @@ static int ethtool_get_eee(struct net_device *dev, char __user *useraddr)
 static int ethtool_set_eee(struct net_device *dev, char __user *useraddr)
 {
 	struct ethtool_eee edata;
+	int ret;
 
 	if (!dev->ethtool_ops->set_eee)
 		return -EOPNOTSUPP;
@@ -1361,7 +1362,10 @@ static int ethtool_set_eee(struct net_device *dev, char __user *useraddr)
 	if (copy_from_user(&edata, useraddr, sizeof(edata)))
 		return -EFAULT;
 
-	return dev->ethtool_ops->set_eee(dev, &edata);
+	ret = dev->ethtool_ops->set_eee(dev, &edata);
+	if (!ret)
+		ethtool_notify(dev, ETHTOOL_MSG_EEE_NTF, NULL);
+	return ret;
 }
 
 static int ethtool_nway_reset(struct net_device *dev)
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 4630206837e0..e525c7b8ba4d 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -548,6 +548,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_CHANNELS_NTF]	= &ethnl_channels_request_ops,
 	[ETHTOOL_MSG_COALESCE_NTF]	= &ethnl_coalesce_request_ops,
 	[ETHTOOL_MSG_PAUSE_NTF]		= &ethnl_pause_request_ops,
+	[ETHTOOL_MSG_EEE_NTF]		= &ethnl_eee_request_ops,
 };
 
 /* default notification handler */
@@ -639,6 +640,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_CHANNELS_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_COALESCE_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_PAUSE_NTF]		= ethnl_default_notify,
+	[ETHTOOL_MSG_EEE_NTF]		= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
-- 
2.25.1

