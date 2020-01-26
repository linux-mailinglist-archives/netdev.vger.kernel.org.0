Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBF6149D3F
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 23:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgAZWLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 17:11:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:43770 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729159AbgAZWLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 17:11:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0415DAE2C;
        Sun, 26 Jan 2020 22:11:19 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id A748EE06B1; Sun, 26 Jan 2020 23:11:19 +0100 (CET)
Message-Id: <31ad6c1e5db5601cebf01a1f011cf39ea0ce9e4d.1580075977.git.mkubecek@suse.cz>
In-Reply-To: <cover.1580075977.git.mkubecek@suse.cz>
References: <cover.1580075977.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 7/7] ethtool: add WOL_NTF notification
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Sun, 26 Jan 2020 23:11:19 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send ETHTOOL_MSG_WOL_NTF notification whenever wake-on-lan settings of
a device are modified using ETHTOOL_MSG_WOL_SET netlink message or
ETHTOOL_SWOL ioctl request.

As notifications can be received by anyone, do not include SecureOn(tm)
password in notification messages.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 5 +++--
 include/uapi/linux/ethtool_netlink.h         | 1 +
 net/ethtool/ioctl.c                          | 1 +
 net/ethtool/netlink.c                        | 2 ++
 net/ethtool/wol.c                            | 4 +++-
 5 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index f16f74bbb546..f1f868479ceb 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -193,7 +193,7 @@ Userspace to kernel:
 
 Kernel to userspace:
 
-  ===================================== ================================
+  ===================================== =================================
   ``ETHTOOL_MSG_STRSET_GET_REPLY``      string set contents
   ``ETHTOOL_MSG_LINKINFO_GET_REPLY``    link settings
   ``ETHTOOL_MSG_LINKINFO_NTF``          link settings notification
@@ -203,7 +203,8 @@ Kernel to userspace:
   ``ETHTOOL_MSG_DEBUG_GET_REPLY``       debugging settings
   ``ETHTOOL_MSG_DEBUG_NTF``             debugging settings notification
   ``ETHTOOL_MSG_WOL_GET_REPLY``         wake-on-lan settings
-  ===================================== ================================
+  ``ETHTOOL_MSG_WOL_NTF``               wake-on-lan settings notification
+  ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
 information. They usually do not contain any message specific attributes.
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 59de35695521..7e0b460f872c 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -42,6 +42,7 @@ enum {
 	ETHTOOL_MSG_DEBUG_GET_REPLY,
 	ETHTOOL_MSG_DEBUG_NTF,
 	ETHTOOL_MSG_WOL_GET_REPLY,
+	ETHTOOL_MSG_WOL_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 46e0b31782fc..b88dd14e41c6 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1316,6 +1316,7 @@ static int ethtool_set_wol(struct net_device *dev, char __user *useraddr)
 		return ret;
 
 	dev->wol_enabled = !!wol.wolopts;
+	ethtool_notify(dev, ETHTOOL_MSG_WOL_NTF, NULL);
 
 	return 0;
 }
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 2c375f9095fe..180c194fab07 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -526,6 +526,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_LINKINFO_NTF]	= &ethnl_linkinfo_request_ops,
 	[ETHTOOL_MSG_LINKMODES_NTF]	= &ethnl_linkmodes_request_ops,
 	[ETHTOOL_MSG_DEBUG_NTF]		= &ethnl_debug_request_ops,
+	[ETHTOOL_MSG_WOL_NTF]		= &ethnl_wol_request_ops,
 };
 
 /* default notification handler */
@@ -610,6 +611,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_LINKINFO_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_LINKMODES_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_DEBUG_NTF]		= ethnl_default_notify,
+	[ETHTOOL_MSG_WOL_NTF]		= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
index a2724378fac4..e1b8a65b64c4 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -41,7 +41,8 @@ static int wol_prepare_data(const struct ethnl_req_info *req_base,
 		return ret;
 	dev->ethtool_ops->get_wol(dev, &data->wol);
 	ethnl_ops_complete(dev);
-	data->show_sopass = data->wol.supported & WAKE_MAGICSECURE;
+	/* do not include password in notifications */
+	data->show_sopass = info && (data->wol.supported & WAKE_MAGICSECURE);
 
 	return 0;
 }
@@ -165,6 +166,7 @@ int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info)
 	if (ret)
 		goto out_ops;
 	dev->wol_enabled = !!wol.wolopts;
+	ethtool_notify(dev, ETHTOOL_MSG_WOL_NTF, NULL);
 
 out_ops:
 	ethnl_ops_complete(dev);
-- 
2.25.0

