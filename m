Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B93619BAF1
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 04:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfHXCnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 22:43:03 -0400
Received: from mail.nic.cz ([217.31.204.67]:37276 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfHXCnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 22:43:02 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id B6AD9140D20;
        Sat, 24 Aug 2019 04:42:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566614579; bh=MugrABbJ8AsshZDatXz+1ocRDwPULL+0ZzKYCe8l2mE=;
        h=From:To:Date;
        b=Nu6Or/RAmhsH+sDbnw7+YKz9nZiF3Mdxpgf/4O30gloicSpv1+tz0tKWgiq51aUv9
         VXCZbGHqdv7a9DO3bcKTxYiYAn54nKRboIdvBEQit+hUZzBJOBajBIJcTvXZKYP6mT
         P4FcXHMpLC4KPBaR+8jT+EcHK1MmyxprksBnjjMc=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC net-next 2/3] net: add ndo for setting the iflink property
Date:   Sat, 24 Aug 2019 04:42:49 +0200
Message-Id: <20190824024251.4542-3-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190824024251.4542-1-marek.behun@nic.cz>
References: <20190824024251.4542-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In DSA the iflink value is used to report to which CPU port a given
switch port is connected to. Since we want to support multi-CPU DSA, we
want the user to be able to change this value.

Add ndo_set_iflink method into the ndo strucutre to be a pair to
ndo_get_iflink. Also create dev_set_iflink and call this from the
netlink code, so that userspace can change the iflink value.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
---
 include/linux/netdevice.h |  5 +++++
 net/core/dev.c            | 15 +++++++++++++++
 net/core/rtnetlink.c      |  7 +++++++
 3 files changed, 27 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 55ac223553f8..45eeb6da8583 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1201,6 +1201,8 @@ struct tlsdev_ops;
  *	TX queue.
  * int (*ndo_get_iflink)(const struct net_device *dev);
  *	Called to get the iflink value of this device.
+ * int (*ndo_set_iflink)(struct net_device *dev, int iflink);
+ *	Called to set the iflink value of this device.
  * void (*ndo_change_proto_down)(struct net_device *dev,
  *				 bool proto_down);
  *	This function is used to pass protocol port error state information
@@ -1415,6 +1417,8 @@ struct net_device_ops {
 						      int queue_index,
 						      u32 maxrate);
 	int			(*ndo_get_iflink)(const struct net_device *dev);
+	int			(*ndo_set_iflink)(struct net_device *dev,
+						  int iflink);
 	int			(*ndo_change_proto_down)(struct net_device *dev,
 							 bool proto_down);
 	int			(*ndo_fill_metadata_dst)(struct net_device *dev,
@@ -2606,6 +2610,7 @@ void dev_add_offload(struct packet_offload *po);
 void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
+int dev_set_iflink(struct net_device *dev, int iflink);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
 struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
 				      unsigned short mask);
diff --git a/net/core/dev.c b/net/core/dev.c
index 49589ed2018d..966bab196694 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -693,6 +693,21 @@ int dev_get_iflink(const struct net_device *dev)
 }
 EXPORT_SYMBOL(dev_get_iflink);
 
+/**
+ *	dev_set_iflink - set 'iflink' value of an interface
+ *	@dev: target interface
+ *	@iflink: new value
+ *
+ *	Change the interface to which this interface is linked to.
+ */
+int dev_set_iflink(struct net_device *dev, int iflink)
+{
+	if (dev->netdev_ops && dev->netdev_ops->ndo_set_iflink)
+		return dev->netdev_ops->ndo_set_iflink(dev, iflink);
+
+	return -EOPNOTSUPP;
+}
+
 /**
  *	dev_fill_metadata_dst - Retrieve tunnel egress information.
  *	@dev: targeted interface
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1ee6460f8275..106d5e23ae6f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2507,6 +2507,13 @@ static int do_setlink(const struct sk_buff *skb,
 		status |= DO_SETLINK_MODIFIED;
 	}
 
+	if (tb[IFLA_LINK]) {
+		err = dev_set_iflink(dev, nla_get_u32(tb[IFLA_LINK]));
+		if (err)
+			goto errout;
+		status |= DO_SETLINK_MODIFIED;
+	}
+
 	if (tb[IFLA_CARRIER]) {
 		err = dev_change_carrier(dev, nla_get_u8(tb[IFLA_CARRIER]));
 		if (err)
-- 
2.21.0

