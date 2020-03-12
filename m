Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF17183A4A
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgCLUIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:08:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:45392 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727283AbgCLUIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:08:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F1447AEAF;
        Thu, 12 Mar 2020 20:08:18 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id A39F2E0C79; Thu, 12 Mar 2020 21:08:18 +0100 (CET)
Message-Id: <57e5efaf9aef625a06bea72acb9594d65d2c722f.1584043144.git.mkubecek@suse.cz>
In-Reply-To: <cover.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 09/15] ethtool: add PRIVFLAGS_NTF notification
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Mar 2020 21:08:18 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send ETHTOOL_MSG_PRIVFLAGS_NTF notification whenever private flags of
a network device are modified using ETHTOOL_MSG_PRIVFLAGS_SET netlink
message or ETHTOOL_SPFLAGS ioctl request.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 include/uapi/linux/ethtool_netlink.h | 1 +
 net/ethtool/ioctl.c                  | 2 ++
 net/ethtool/netlink.c                | 2 ++
 net/ethtool/privflags.c              | 3 +++
 4 files changed, 8 insertions(+)

diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 13e631c86825..7f23a7f0fca1 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -51,6 +51,7 @@ enum {
 	ETHTOOL_MSG_FEATURES_SET_REPLY,
 	ETHTOOL_MSG_FEATURES_NTF,
 	ETHTOOL_MSG_PRIVFLAGS_GET_REPLY,
+	ETHTOOL_MSG_PRIVFLAGS_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 45d1bf1764b7..298822289496 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2716,6 +2716,8 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
 	case ETHTOOL_GPFLAGS:
 		rc = ethtool_get_value(dev, useraddr, ethcmd,
 				       dev->ethtool_ops->get_priv_flags);
+		if (!rc)
+			ethtool_notify(dev, ETHTOOL_MSG_PRIVFLAGS_NTF, NULL);
 		break;
 	case ETHTOOL_SPFLAGS:
 		rc = ethtool_set_value(dev, useraddr,
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index b6795aad7ccb..dec82b0b80bd 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -530,6 +530,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_DEBUG_NTF]		= &ethnl_debug_request_ops,
 	[ETHTOOL_MSG_WOL_NTF]		= &ethnl_wol_request_ops,
 	[ETHTOOL_MSG_FEATURES_NTF]	= &ethnl_features_request_ops,
+	[ETHTOOL_MSG_PRIVFLAGS_NTF]	= &ethnl_privflags_request_ops,
 };
 
 /* default notification handler */
@@ -616,6 +617,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_DEBUG_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_WOL_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_FEATURES_NTF]	= ethnl_default_notify,
+	[ETHTOOL_MSG_PRIVFLAGS_NTF]	= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
diff --git a/net/ethtool/privflags.c b/net/ethtool/privflags.c
index dfa76d552277..e8f03b33db9b 100644
--- a/net/ethtool/privflags.c
+++ b/net/ethtool/privflags.c
@@ -194,6 +194,9 @@ int ethnl_set_privflags(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0 || !mod)
 		goto out_free;
 	ret = ops->set_priv_flags(dev, flags);
+	if (ret < 0)
+		goto out_free;
+	ethtool_notify(dev, ETHTOOL_MSG_PRIVFLAGS_NTF, NULL);
 
 out_free:
 	kfree(names);
-- 
2.25.1

