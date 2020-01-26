Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6A9149D39
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 23:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgAZWLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 17:11:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:43668 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729127AbgAZWLN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 17:11:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DF40BAD73;
        Sun, 26 Jan 2020 22:11:10 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 93CC8E06B1; Sun, 26 Jan 2020 23:11:10 +0100 (CET)
Message-Id: <a6a0f4b5e3667e977be016dfada4ae64dae84f6e.1580075977.git.mkubecek@suse.cz>
In-Reply-To: <cover.1580075977.git.mkubecek@suse.cz>
References: <cover.1580075977.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 4/7] ethtool: add DEBUG_NTF notification
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Sun, 26 Jan 2020 23:11:10 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send ETHTOOL_MSG_DEBUG_NTF notification message whenever debugging message
mask for a device are modified using ETHTOOL_MSG_DEBUG_SET netlink message
or ETHTOOL_SMSGLVL ioctl request.

The notification message has the same format as reply to DEBUG_GET request.
As with other ethtool notifications, netlink requests only trigger the
notification if the mask is actually changed while ioctl request trigger it
whenever the request results in calling the ethtool_ops handler.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 1 +
 include/uapi/linux/ethtool_netlink.h         | 1 +
 net/ethtool/debug.c                          | 1 +
 net/ethtool/ioctl.c                          | 2 ++
 net/ethtool/netlink.c                        | 2 ++
 5 files changed, 7 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 58473c05319f..2263f885d18f 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -199,6 +199,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_LINKMODES_NTF``         link modes notification
   ``ETHTOOL_MSG_LINKSTATE_GET_REPLY``   link state info
   ``ETHTOOL_MSG_DEBUG_GET_REPLY``       debugging settings
+  ``ETHTOOL_MSG_DEBUG_NTF``             debugging settings notification
   ===================================== ================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 8f0b6fd277d5..67a06b94bf28 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -38,6 +38,7 @@ enum {
 	ETHTOOL_MSG_LINKMODES_NTF,
 	ETHTOOL_MSG_LINKSTATE_GET_REPLY,
 	ETHTOOL_MSG_DEBUG_GET_REPLY,
+	ETHTOOL_MSG_DEBUG_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
index 6fc3ef8113c0..aaef4843e6ba 100644
--- a/net/ethtool/debug.c
+++ b/net/ethtool/debug.c
@@ -123,6 +123,7 @@ int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 
 	dev->ethtool_ops->set_msglevel(dev, msg_mask);
+	ethtool_notify(dev, ETHTOOL_MSG_DEBUG_NTF, NULL);
 
 out_ops:
 	ethnl_ops_complete(dev);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 182bffbffa78..46e0b31782fc 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2545,6 +2545,8 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	case ETHTOOL_SMSGLVL:
 		rc = ethtool_set_value_void(dev, useraddr,
 				       dev->ethtool_ops->set_msglevel);
+		if (!rc)
+			ethtool_notify(dev, ETHTOOL_MSG_DEBUG_NTF, NULL);
 		break;
 	case ETHTOOL_GEEE:
 		rc = ethtool_get_eee(dev, useraddr);
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index bcdc42e0bd14..9a0a6c2f8dbb 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -524,6 +524,7 @@ static const struct ethnl_request_ops *
 ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_LINKINFO_NTF]	= &ethnl_linkinfo_request_ops,
 	[ETHTOOL_MSG_LINKMODES_NTF]	= &ethnl_linkmodes_request_ops,
+	[ETHTOOL_MSG_DEBUG_NTF]		= &ethnl_debug_request_ops,
 };
 
 /* default notification handler */
@@ -607,6 +608,7 @@ typedef void (*ethnl_notify_handler_t)(struct net_device *dev, unsigned int cmd,
 static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_LINKINFO_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_LINKMODES_NTF]	= ethnl_default_notify,
+	[ETHTOOL_MSG_DEBUG_NTF]		= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
-- 
2.25.0

