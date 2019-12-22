Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C79D1129061
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 00:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfLVXqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 18:46:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:55502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfLVXqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Dec 2019 18:46:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9BF9FB008;
        Sun, 22 Dec 2019 23:46:04 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 4A177E03A8; Mon, 23 Dec 2019 00:46:04 +0100 (CET)
Message-Id: <b7f798ede50bbffb66fa75ecf1a3e06dde41da82.1577052887.git.mkubecek@suse.cz>
In-Reply-To: <cover.1577052887.git.mkubecek@suse.cz>
References: <cover.1577052887.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v8 10/14] ethtool: add LINKINFO_NTF notification
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Dec 2019 00:46:04 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send ETHTOOL_MSG_LINKINFO_NTF notification message whenever device link
settings are modified using ETHTOOL_MSG_LINKINFO_SET netlink message or
ETHTOOL_SLINKSETTINGS or ETHTOOL_SSET ioctl commands.

The notification message has the same format as reply to LINKINFO_GET
request. ETHTOOL_MSG_LINKINFO_SET netlink request only triggers the
notification if there is a change but the ioctl command handlers do not
check if there is an actual change and trigger the notification whenever
the commands are executed.

As all work is done by ethnl_default_notify() handler and callback
functions introduced to handle LINKINFO_GET requests, all that remains is
adding entries for ETHTOOL_MSG_LINKINFO_NTF into ethnl_notify_handlers and
ethnl_default_notify_ops lookup tables and calls to ethtool_notify() where
needed.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst |  1 +
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/ioctl.c                          | 12 ++++++++++--
 net/ethtool/linkinfo.c                       |  2 ++
 net/ethtool/netlink.c                        |  2 ++
 5 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index e16ef058404f..e766a48d5cbb 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -179,6 +179,7 @@ Kernel to userspace:
   ===================================== ================================
   ``ETHTOOL_MSG_STRSET_GET_REPLY``      string set contents
   ``ETHTOOL_MSG_LINKINFO_GET_REPLY``    link settings
+  ``ETHTOOL_MSG_LINKINFO_NTF``          link settings notification
   ===================================== ================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 5b7806a5bef8..d530fa30de36 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -28,6 +28,7 @@ enum {
 	ETHTOOL_MSG_KERNEL_NONE,
 	ETHTOOL_MSG_STRSET_GET_REPLY,
 	ETHTOOL_MSG_LINKINFO_GET_REPLY,
+	ETHTOOL_MSG_LINKINFO_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index eca7462e6263..bada0f9a97ec 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -26,6 +26,7 @@
 #include <net/devlink.h>
 #include <net/xdp_sock.h>
 #include <net/flow_offload.h>
+#include <linux/ethtool_netlink.h>
 
 #include "common.h"
 
@@ -571,7 +572,10 @@ static int ethtool_set_link_ksettings(struct net_device *dev,
 	    != link_ksettings.base.link_mode_masks_nwords)
 		return -EINVAL;
 
-	return dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
+	err = dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
+	if (err >= 0)
+		ethtool_notify(dev, ETHTOOL_MSG_LINKINFO_NTF, NULL);
+	return err;
 }
 
 /* Query device for its ethtool_cmd settings.
@@ -620,6 +624,7 @@ static int ethtool_set_settings(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_link_ksettings link_ksettings;
 	struct ethtool_cmd cmd;
+	int ret;
 
 	ASSERT_RTNL();
 
@@ -632,7 +637,10 @@ static int ethtool_set_settings(struct net_device *dev, void __user *useraddr)
 		return -EINVAL;
 	link_ksettings.base.link_mode_masks_nwords =
 		__ETHTOOL_LINK_MODE_MASK_NU32;
-	return dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
+	ret = dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
+	if (ret >= 0)
+		ethtool_notify(dev, ETHTOOL_MSG_LINKINFO_NTF, NULL);
+	return ret;
 }
 
 static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index 8a5f68f92425..5d16cb4e8693 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -155,6 +155,8 @@ int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
 	ret = dev->ethtool_ops->set_link_ksettings(dev, &ksettings);
 	if (ret < 0)
 		GENL_SET_ERR_MSG(info, "link settings update failed");
+	else
+		ethtool_notify(dev, ETHTOOL_MSG_LINKINFO_NTF, NULL);
 
 out_ops:
 	ethnl_ops_complete(dev);
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 057b67f8ba8c..942da4ebdfe9 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -509,6 +509,7 @@ static int ethnl_default_done(struct netlink_callback *cb)
 
 static const struct ethnl_request_ops *
 ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
+	[ETHTOOL_MSG_LINKINFO_NTF]	= &ethnl_linkinfo_request_ops,
 };
 
 /* default notification handler */
@@ -589,6 +590,7 @@ typedef void (*ethnl_notify_handler_t)(struct net_device *dev, unsigned int cmd,
 				       const void *data);
 
 static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
+	[ETHTOOL_MSG_LINKINFO_NTF]	= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
-- 
2.24.1

