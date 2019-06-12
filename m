Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3BB42BC3
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440206AbfFLQG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:06:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49288 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437056AbfFLQG3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:06:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NRUTfPPaUheG9wH9PgwLAT7MFzAKqpZosY3Xjy7eW6s=; b=wq4EgnHn8LzYtgoQLX/KSgznmU
        AjWyB0cZUrdRBz3iS9kiTh2vkJqsy1cZAjdXZednCgZIq4bnzwz2xltgEmR1dR8q2Xkyk9beNMqdc
        QArVRf4d+Dcz46PGHSYQg9z/WcQv9GnOskTfwrqbp2rG84ynVRFoJWhxVxNAcRSGUti0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5lD-00068o-5S; Wed, 12 Jun 2019 18:06:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 07/13] net: phy: cable test: Use request seq in broadcast reply
Date:   Wed, 12 Jun 2019 18:05:28 +0200
Message-Id: <20190612160534.23533-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612160534.23533-1-andrew@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An ethtool netlink action is used to start the cable test. Use the
sequence number from this action in the multicast later used to send
the results of the cable test, so that the results can be match back
to the request.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/phy.c           | 5 +++--
 include/linux/ethtool_netlink.h | 1 +
 include/linux/phy.h             | 6 ++++--
 net/ethtool/actions.c           | 3 ++-
 net/ethtool/netlink.c           | 8 ++++++--
 5 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index db8a5957acdd..3c614639ce20 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -486,7 +486,7 @@ static void phy_cable_test_abort(struct phy_device *phydev)
 }
 
 int phy_start_cable_test(struct phy_device *phydev,
-			 struct netlink_ext_ack *extack)
+			 struct netlink_ext_ack *extack, u32 seq)
 {
 	int err = -ENOMEM;
 	int ret;
@@ -512,7 +512,8 @@ int phy_start_cable_test(struct phy_device *phydev,
 	if (!phydev->skb)
 		goto out;
 
-	phydev->ehdr = ethnl_bcastmsg_put(phydev->skb, ETHNL_CMD_EVENT);
+	phydev->ehdr = ethnl_bcastmsg_put_seq(phydev->skb, ETHNL_CMD_EVENT,
+					      seq);
 	if (!phydev->ehdr)
 		goto out_free;
 
diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 7d98592cd8a1..66a91e629694 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -29,6 +29,7 @@ static inline struct nlattr *ethnl_nest_start(struct sk_buff *skb,
 
 int ethnl_fill_dev(struct sk_buff *msg, struct net_device *dev, u16 attrtype);
 void *ethnl_bcastmsg_put(struct sk_buff *skb, u8 cmd);
+void *ethnl_bcastmsg_put_seq(struct sk_buff *skb, u8 cmd, u32 seq);
 int ethnl_multicast(struct sk_buff *skb, struct net_device *dev);
 
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/include/linux/phy.h b/include/linux/phy.h
index da8cc97b55dc..cea151c66ac1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1077,11 +1077,13 @@ int phy_reset_after_clk_enable(struct phy_device *phydev);
 
 #if IS_ENABLED(CONFIG_PHYLIB)
 int phy_start_cable_test(struct phy_device *phydev,
-			 struct netlink_ext_ack *extack);
+			 struct netlink_ext_ack *extack,
+			 u32 seq);
 #else
 static inline
 int phy_start_cable_test(struct phy_device *phydev,
-			 struct netlink_ext_ack *extack)
+			 struct netlink_ext_ack *extack,
+			 u32 seq)
 {
 	NL_SET_ERR_MSG(extack, "Kernel not compiled with PHYLIB support");
 	return -EOPNOTSUPP;
diff --git a/net/ethtool/actions.c b/net/ethtool/actions.c
index 8a26ae1b2ada..8595cc27d532 100644
--- a/net/ethtool/actions.c
+++ b/net/ethtool/actions.c
@@ -440,7 +440,8 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		goto out_rtnl;
 
-	ret = phy_start_cable_test(dev->phydev, info->extack);
+	ret = phy_start_cable_test(dev->phydev, info->extack, info->snd_seq);
+
 	ethnl_after_ops(dev);
 
 	if (ret == 0)
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 894dc81536c9..9d97de1c86aa 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -240,10 +240,14 @@ struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
 	return NULL;
 }
 
+void *ethnl_bcastmsg_put_seq(struct sk_buff *skb, u8 cmd, u32 seq)
+{
+	return genlmsg_put(skb, 0, seq, &ethtool_genl_family, 0, cmd);
+}
+
 void *ethnl_bcastmsg_put(struct sk_buff *skb, u8 cmd)
 {
-	return genlmsg_put(skb, 0, ++ethnl_bcast_seq, &ethtool_genl_family, 0,
-			   cmd);
+	return ethnl_bcastmsg_put_seq(skb, cmd, ++ethnl_bcast_seq);
 }
 
 int ethnl_multicast(struct sk_buff *skb, struct net_device *dev)
-- 
2.20.1

