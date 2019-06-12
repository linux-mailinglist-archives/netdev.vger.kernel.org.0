Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C52242BC5
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407890AbfFLQGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:06:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49312 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406078AbfFLQGp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:06:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hTg31gYbszxYoo2WsfGpheWdKBC3ijV/ZWnEHh/Pam4=; b=qRnzZg+wYNr8c95epXEf5157Qt
        aBoqBgUYRTPc/daTiVq5F/lYU0VfyaoBTag6s+Rv1U5HAXHsDi3jAJMUuZoX30XUlOh36UuCyv/Jt
        OzWYVUoa3XNT+SatPogOcFcnOWq2Y1yWRN6KjvG2U0LLjW93Z0LmmzQwiMQiDyRZjVco=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5lD-00068R-0n; Wed, 12 Jun 2019 18:06:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 03/13] net: ethtool: netlink: Add support for triggering a cable test
Date:   Wed, 12 Jun 2019 18:05:24 +0200
Message-Id: <20190612160534.23533-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612160534.23533-1-andrew@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new ethtool netlink calls to trigger the starting of a PHY cable
test.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/Kconfig              |  1 +
 include/uapi/linux/ethtool_netlink.h | 12 +++++
 net/ethtool/actions.c                | 77 ++++++++++++++++++++++++++++
 net/ethtool/netlink.c                |  6 +++
 net/ethtool/netlink.h                |  4 ++
 5 files changed, 100 insertions(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index d6299710d634..fc2be56fd2f8 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -208,6 +208,7 @@ menuconfig PHYLIB
 	tristate "PHY Device support and infrastructure"
 	depends on NETDEVICES
 	select MDIO_DEVICE
+	select ETHTOOL_NETLINK
 	help
 	  Ethernet controllers are usually attached to PHY
 	  devices.  This option provides infrastructure for
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index c6686ebb35b2..e9d0d6fac23b 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -27,6 +27,7 @@ enum {
 	ETHNL_CMD_ACT_RESET,
 	ETHNL_CMD_GET_RXFLOW,
 	ETHNL_CMD_SET_RXFLOW,
+	ETHNL_CMD_ACT_CABLE_TEST,
 
 	__ETHNL_CMD_CNT,
 	ETHNL_CMD_MAX = (__ETHNL_CMD_CNT - 1)
@@ -106,6 +107,7 @@ enum {
 	ETHTOOL_A_EVENT_NEWDEV,			/* nest - ETHTOOL_A_NEWDEV_* */
 	ETHTOOL_A_EVENT_DELDEV,			/* nest - ETHTOOL_A_DELDEV_* */
 	ETHTOOL_A_EVENT_RENAMEDEV,		/* nest - ETHTOOL_A_RENAMEDEV_* */
+	ETHTOOL_A_EVENT_CABLE_TEST,		/* nest - ETHTOOL_A_CABLE_TEST_* */
 
 	__ETHTOOL_A_EVENT_CNT,
 	ETHTOOL_A_EVENT_MAX = (__ETHTOOL_A_EVENT_CNT - 1)
@@ -504,6 +506,16 @@ enum {
 	ETHTOOL_A_RXHASHOPT_MAX = (__ETHTOOL_A_RXHASHOPT_CNT - 1)
 };
 
+/* ACT_CABLE_TEST */
+
+enum {
+	ETHTOOL_A_CABLE_TEST_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_DEV,		/* nest - ETHTOOL_A_DEV_* */
+
+	__ETHTOOL_A_CABLE_TEST_CNT,
+	ETHTOOL_A_CABLE_TEST_MAX = (__ETHTOOL_A_CABLE_TEST_CNT - 1)
+};
+
 enum {
 	ETHTOOL_A_INDTBL_UNSPEC,
 	ETHTOOL_A_INDTBL_BLOCK32,		/* nest - ETH_ITBLK_* */
diff --git a/net/ethtool/actions.c b/net/ethtool/actions.c
index 1fa630cf303f..8a26ae1b2ada 100644
--- a/net/ethtool/actions.c
+++ b/net/ethtool/actions.c
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 
+#include <linux/phy.h>
 #include "netlink.h"
 #include "common.h"
 #include "bitset.h"
@@ -375,3 +376,79 @@ int ethnl_act_reset(struct sk_buff *skb, struct genl_info *info)
 		GENL_SET_ERR_MSG(info, "failed to send reply message");
 	return ret;
 }
+
+/* ACT_CABLE_TEST */
+
+static const struct
+nla_policy cable_test_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
+	[ETHTOOL_A_CABLE_TEST_UNSPEC]	= { .type = NLA_REJECT },
+	[ETHTOOL_A_CABLE_TEST_DEV]		= { .type = NLA_NESTED },
+};
+
+void ethnl_cable_test_notify(struct net_device *dev,
+			     struct netlink_ext_ack *extack, unsigned int cmd,
+			     u32 req_mask, const void *data)
+{
+	struct sk_buff *skb;
+	void *msg_payload;
+	int msg_len;
+	int ret;
+
+	msg_len = dev_ident_size();
+	skb = genlmsg_new(msg_len, GFP_KERNEL);
+	if (!skb)
+		return;
+
+	msg_payload = ethnl_bcastmsg_put(skb, ETHNL_CMD_ACT_CABLE_TEST);
+	if (!msg_payload)
+		goto err_skb;
+
+	ret = ethnl_fill_dev(skb, dev, ETHTOOL_A_CABLE_TEST_DEV);
+	if (ret < 0)
+		goto err_skb;
+
+	genlmsg_end(skb, msg_payload);
+	ethnl_multicast(skb, dev);
+	return;
+
+err_skb:
+	nlmsg_free(skb);
+}
+
+int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_MAX + 1];
+	struct net_device *dev;
+	int ret;
+
+	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
+			  ETHTOOL_A_CABLE_TEST_MAX, cable_test_policy,
+			  info->extack);
+	if (ret < 0)
+		return ret;
+
+	dev = ethnl_dev_get(info, tb[ETHTOOL_A_CABLE_TEST_DEV]);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+
+	ret = -EOPNOTSUPP;
+	if (!dev->phydev)
+		goto out_dev;
+
+	rtnl_lock();
+	ret = ethnl_before_ops(dev);
+	if (ret < 0)
+		goto out_rtnl;
+
+	ret = phy_start_cable_test(dev->phydev, info->extack);
+	ethnl_after_ops(dev);
+
+	if (ret == 0)
+		ethtool_notify(dev, NULL, ETHNL_CMD_ACT_CABLE_TEST, 0, NULL);
+
+out_rtnl:
+	rtnl_unlock();
+out_dev:
+	dev_put(dev);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 540c92091fe9..894dc81536c9 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -589,6 +589,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHNL_CMD_ACT_PHYS_ID]		= ethnl_physid_notify,
 	[ETHNL_CMD_ACT_RESET]		= ethnl_reset_notify,
 	[ETHNL_CMD_SET_RXFLOW]		= ethnl_rxflow_notify,
+	[ETHNL_CMD_ACT_CABLE_TEST]	= ethnl_cable_test_notify,
 };
 
 void ethtool_notify(struct net_device *dev, struct netlink_ext_ack *extack,
@@ -747,6 +748,11 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.flags	= GENL_UNS_ADMIN_PERM,
 		.doit	= ethnl_set_rxflow,
 	},
+	{
+		.cmd	= ETHNL_CMD_ACT_CABLE_TEST,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_act_cable_test,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index cb7dce82cc7e..4e7b40a8401d 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -269,6 +269,7 @@ int ethnl_set_rxflow(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_nway_rst(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_phys_id(struct sk_buff *skb, struct genl_info *info);
 int ethnl_act_reset(struct sk_buff *skb, struct genl_info *info);
+int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info);
 
 /* notify handlers */
 
@@ -281,5 +282,8 @@ void ethnl_reset_notify(struct net_device *dev, struct netlink_ext_ack *extack,
 			unsigned int cmd, u32 req_mask, const void *data);
 void ethnl_rxflow_notify(struct net_device *dev, struct netlink_ext_ack *extack,
 			 unsigned int cmd, u32 req_mask, const void *data);
+void ethnl_cable_test_notify(struct net_device *dev,
+			     struct netlink_ext_ack *extack,
+			     unsigned int cmd, u32 req_mask, const void *data);
 
 #endif /* _NET_ETHTOOL_NETLINK_H */
-- 
2.20.1

