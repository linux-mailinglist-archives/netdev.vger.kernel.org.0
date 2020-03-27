Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C66919588D
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 15:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgC0OHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 10:07:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:40670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgC0OHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 10:07:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BA3E9AD76;
        Fri, 27 Mar 2020 14:07:37 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 6BAA8E009C; Fri, 27 Mar 2020 15:07:37 +0100 (CET)
Message-Id: <d3e1670d6f6b98624e3f235cac0756cd4e7208fd.1585316159.git.mkubecek@suse.cz>
In-Reply-To: <cover.1585316159.git.mkubecek@suse.cz>
References: <cover.1585316159.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 04/12] ethtool: add COALESCE_NTF notification
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Mar 2020 15:07:37 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send ETHTOOL_MSG_COALESCE_NTF notification whenever coalescing parameters
of a network device are modified using ETHTOOL_MSG_COALESCE_SET netlink
message or ETHTOOL_SCOALESCE ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst | 1 +
 include/uapi/linux/ethtool_netlink.h         | 1 +
 net/ethtool/coalesce.c                       | 3 +++
 net/ethtool/ioctl.c                          | 6 +++++-
 net/ethtool/netlink.c                        | 2 ++
 5 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index b593c7f50934..d4be0a63786d 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -224,6 +224,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_CHANNELS_GET_REPLY``    channel counts
   ``ETHTOOL_MSG_CHANNELS_NTF``          channel counts
   ``ETHTOOL_MSG_COALESCE_GET_REPLY``    coalescing parameters
+  ``ETHTOOL_MSG_COALESCE_NTF``          coalescing parameters
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index d9f4047c64c3..fdbcaf76df1e 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -63,6 +63,7 @@ enum {
 	ETHTOOL_MSG_CHANNELS_GET_REPLY,
 	ETHTOOL_MSG_CHANNELS_NTF,
 	ETHTOOL_MSG_COALESCE_GET_REPLY,
+	ETHTOOL_MSG_COALESCE_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 6cf1a7ebf0c5..6afd99042d67 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -339,6 +339,9 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 
 	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
+	if (ret < 0)
+		goto out_ops;
+	ethtool_notify(dev, ETHTOOL_MSG_COALESCE_NTF, NULL);
 
 out_ops:
 	ethnl_ops_complete(dev);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 10d929abdf6a..198825ebc114 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1571,6 +1571,7 @@ static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
 						   void __user *useraddr)
 {
 	struct ethtool_coalesce coalesce;
+	int ret;
 
 	if (!dev->ethtool_ops->set_coalesce)
 		return -EOPNOTSUPP;
@@ -1581,7 +1582,10 @@ static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
 	if (!ethtool_set_coalesce_supported(dev, &coalesce))
 		return -EOPNOTSUPP;
 
-	return dev->ethtool_ops->set_coalesce(dev, &coalesce);
+	ret = dev->ethtool_ops->set_coalesce(dev, &coalesce);
+	if (!ret)
+		ethtool_notify(dev, ETHTOOL_MSG_COALESCE_NTF, NULL);
+	return ret;
 }
 
 static int ethtool_get_ringparam(struct net_device *dev, void __user *useraddr)
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 3a236b4dfbf3..117971e695ca 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -544,6 +544,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_PRIVFLAGS_NTF]	= &ethnl_privflags_request_ops,
 	[ETHTOOL_MSG_RINGS_NTF]		= &ethnl_rings_request_ops,
 	[ETHTOOL_MSG_CHANNELS_NTF]	= &ethnl_channels_request_ops,
+	[ETHTOOL_MSG_COALESCE_NTF]	= &ethnl_coalesce_request_ops,
 };
 
 /* default notification handler */
@@ -633,6 +634,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_PRIVFLAGS_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_RINGS_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_CHANNELS_NTF]	= ethnl_default_notify,
+	[ETHTOOL_MSG_COALESCE_NTF]	= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
-- 
2.25.1

