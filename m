Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16C5B12B56B
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 15:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfL0O4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 09:56:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:43064 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbfL0O4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 09:56:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B7DABAE00;
        Fri, 27 Dec 2019 14:56:18 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 66E01E008A; Fri, 27 Dec 2019 15:56:18 +0100 (CET)
Message-Id: <c8de94c6265278b791231024664d052f82371cfb.1577457846.git.mkubecek@suse.cz>
In-Reply-To: <cover.1577457846.git.mkubecek@suse.cz>
References: <cover.1577457846.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v9 13/14] ethtool: add LINKMODES_NTF notification
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Fri, 27 Dec 2019 15:56:18 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send ETHTOOL_MSG_LINKMODES_NTF notification message whenever device link
settings or advertised modes are modified using ETHTOOL_MSG_LINKMODES_SET
netlink message or ETHTOOL_SLINKSETTINGS or ETHTOOL_SSET ioctl commands.

The notification message has the same format as reply to LINKMODES_GET
request. ETHTOOL_MSG_LINKMODES_SET netlink request only triggers the
notification if there is a change but the ioctl command handlers do not
check if there is an actual change and trigger the notification whenever
the commands are executed.

As all work is done by ethnl_default_notify() handler and callback
functions introduced to handle LINKMODES_GET requests, all that remains is
adding entries for ETHTOOL_MSG_LINKMODES_NTF into ethnl_notify_handlers and
ethnl_default_notify_ops lookup tables and calls to ethtool_notify() where
needed.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/networking/ethtool-netlink.rst | 1 +
 include/uapi/linux/ethtool_netlink.h         | 1 +
 net/ethtool/ioctl.c                          | 8 ++++++--
 net/ethtool/linkmodes.c                      | 2 ++
 net/ethtool/netlink.c                        | 2 ++
 5 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 625c80183563..9d96d51e9360 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -193,6 +193,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_LINKINFO_GET_REPLY``    link settings
   ``ETHTOOL_MSG_LINKINFO_NTF``          link settings notification
   ``ETHTOOL_MSG_LINKMODES_GET_REPLY``   link modes info
+  ``ETHTOOL_MSG_LINKMODES_NTF``         link modes notification
   ===================================== ================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index cddf978b98df..35948df6d6e3 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -32,6 +32,7 @@ enum {
 	ETHTOOL_MSG_LINKINFO_GET_REPLY,
 	ETHTOOL_MSG_LINKINFO_NTF,
 	ETHTOOL_MSG_LINKMODES_GET_REPLY,
+	ETHTOOL_MSG_LINKMODES_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 11a467294a33..36e2ef2d900d 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -573,8 +573,10 @@ static int ethtool_set_link_ksettings(struct net_device *dev,
 		return -EINVAL;
 
 	err = dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
-	if (err >= 0)
+	if (err >= 0) {
 		ethtool_notify(dev, ETHTOOL_MSG_LINKINFO_NTF, NULL);
+		ethtool_notify(dev, ETHTOOL_MSG_LINKMODES_NTF, NULL);
+	}
 	return err;
 }
 
@@ -638,8 +640,10 @@ static int ethtool_set_settings(struct net_device *dev, void __user *useraddr)
 	link_ksettings.base.link_mode_masks_nwords =
 		__ETHTOOL_LINK_MODE_MASK_NU32;
 	ret = dev->ethtool_ops->set_link_ksettings(dev, &link_ksettings);
-	if (ret >= 0)
+	if (ret >= 0) {
 		ethtool_notify(dev, ETHTOOL_MSG_LINKINFO_NTF, NULL);
+		ethtool_notify(dev, ETHTOOL_MSG_LINKMODES_NTF, NULL);
+	}
 	return ret;
 }
 
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 790b60771d0e..0b99f494ad3b 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -364,6 +364,8 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 		ret = dev->ethtool_ops->set_link_ksettings(dev, &ksettings);
 		if (ret < 0)
 			GENL_SET_ERR_MSG(info, "link settings update failed");
+		else
+			ethtool_notify(dev, ETHTOOL_MSG_LINKMODES_NTF, NULL);
 	}
 
 out_ops:
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 5f28f3cb022d..1b5e1bd26504 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -511,6 +511,7 @@ static int ethnl_default_done(struct netlink_callback *cb)
 static const struct ethnl_request_ops *
 ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_LINKINFO_NTF]	= &ethnl_linkinfo_request_ops,
+	[ETHTOOL_MSG_LINKMODES_NTF]	= &ethnl_linkmodes_request_ops,
 };
 
 /* default notification handler */
@@ -592,6 +593,7 @@ typedef void (*ethnl_notify_handler_t)(struct net_device *dev, unsigned int cmd,
 
 static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_LINKINFO_NTF]	= ethnl_default_notify,
+	[ETHTOOL_MSG_LINKMODES_NTF]	= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
-- 
2.24.1

