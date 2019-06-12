Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B76C242BC9
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440214AbfFLQHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:07:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49348 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408111AbfFLQHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CR+WOC4x8B508VyE/0A1cbeYxnJY9+uQIji/TrsjhEY=; b=pwKntDzF1u5TQPCc0Dqhc+AHgI
        9Rs5HiNMSHw9tBglnjPN29Xv8hjDq98TUYDFzjHeKzZJKXjXiY4fqfIjt1RqmkYW5v4DThKM2cTvQ
        njhl214p2leGpF4Ac4DGgeyVDncoksUrxwG86vfv04S7jwCYaS2c3FIKv555udsdnKSk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5lD-00068c-36; Wed, 12 Jun 2019 18:06:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 05/13] net: ethtool: Make helpers public
Date:   Wed, 12 Jun 2019 18:05:26 +0200
Message-Id: <20190612160534.23533-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190612160534.23533-1-andrew@lunn.ch>
References: <20190612160534.23533-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move Some helpers for building ethtool netlink messages into public
locations so drivers can make use of them.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/linux/ethtool_netlink.h | 11 +++++++++++
 net/ethtool/netlink.h           |  3 ---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 288e90f4dbb9..7d98592cd8a1 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -6,6 +6,7 @@
 #include <uapi/linux/ethtool_netlink.h>
 #include <linux/ethtool.h>
 #include <linux/netdevice.h>
+#include <net/netlink.h>
 
 #define __ETHTOOL_LINK_MODE_MASK_NWORDS \
 	DIV_ROUND_UP(__ETHTOOL_LINK_MODE_MASK_NBITS, 32)
@@ -20,4 +21,14 @@ struct ethtool_rxflow_notification_info {
 	u32	flow_type;
 };
 
+static inline struct nlattr *ethnl_nest_start(struct sk_buff *skb,
+					      int attrtype)
+{
+	return nla_nest_start(skb, attrtype | NLA_F_NESTED);
+}
+
+int ethnl_fill_dev(struct sk_buff *msg, struct net_device *dev, u16 attrtype);
+void *ethnl_bcastmsg_put(struct sk_buff *skb, u8 cmd);
+int ethnl_multicast(struct sk_buff *skb, struct net_device *dev);
+
 #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 4e7b40a8401d..d54fe7b6dac2 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -20,13 +20,10 @@ extern const char *const link_mode_names[];
 extern const char *const reset_flag_names[];
 
 struct net_device *ethnl_dev_get(struct genl_info *info, struct nlattr *nest);
-int ethnl_fill_dev(struct sk_buff *msg, struct net_device *dev, u16 attrtype);
 
 struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
 				 u16 dev_attrtype, struct genl_info *info,
 				 void **ehdrp);
-void *ethnl_bcastmsg_put(struct sk_buff *skb, u8 cmd);
-int ethnl_multicast(struct sk_buff *skb, struct net_device *dev);
 
 #if BITS_PER_LONG == 64 && defined(__BIG_ENDIAN)
 void ethnl_bitmap_to_u32(unsigned long *bitmap, unsigned int nwords);
-- 
2.20.1

