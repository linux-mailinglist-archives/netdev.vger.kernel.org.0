Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD17B1B8861
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 20:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgDYSGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 14:06:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34912 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726145AbgDYSGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 14:06:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7Yos8VzW69UtO1fSvS/e7mjtNLPBC7jcfccMz/pY8KI=; b=oI/TBe4o+A+c6QpnjngcJKkWWY
        a0+mpozkbg4u3O6r/p3DDcJnZCt1YXQg6r9MgQvR/nmhCByXOkBVJzQVoCCxt4qyQC2Ng2GBCWTel
        kue2Ydf4+3CgjFKV8XbcggP/cSleok5f6nf+6gRPfUuDhRz5aFjVCjmwCLimOYmtUg2c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jSPCG-004mhm-Aa; Sat, 25 Apr 2020 20:06:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v1 5/9] net: ethtool: Make helpers public
Date:   Sat, 25 Apr 2020 20:06:17 +0200
Message-Id: <20200425180621.1140452-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200425180621.1140452-1-andrew@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make some helpers for building ethtool netlink messages available
outside the compilation unit, so they can be used for building
messages which are not simple get/set.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ethtool/netlink.c | 4 ++--
 net/ethtool/netlink.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 56efd12c58ba..ffd3d1e40293 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -181,13 +181,13 @@ struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
 	return NULL;
 }
 
-static void *ethnl_bcastmsg_put(struct sk_buff *skb, u8 cmd)
+void *ethnl_bcastmsg_put(struct sk_buff *skb, u8 cmd)
 {
 	return genlmsg_put(skb, 0, ++ethnl_bcast_seq, &ethtool_genl_family, 0,
 			   cmd);
 }
 
-static int ethnl_multicast(struct sk_buff *skb, struct net_device *dev)
+int ethnl_multicast(struct sk_buff *skb, struct net_device *dev)
 {
 	return genlmsg_multicast_netns(&ethtool_genl_family, dev_net(dev), skb,
 				       0, ETHNL_MCGRP_MONITOR, GFP_KERNEL);
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 03e65e2b9e3d..f948eab5fe16 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -19,6 +19,8 @@ int ethnl_fill_reply_header(struct sk_buff *skb, struct net_device *dev,
 struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
 				 u16 hdr_attrtype, struct genl_info *info,
 				 void **ehdrp);
+void *ethnl_bcastmsg_put(struct sk_buff *skb, u8 cmd);
+int ethnl_multicast(struct sk_buff *skb, struct net_device *dev);
 
 /**
  * ethnl_strz_size() - calculate attribute length for fixed size string
-- 
2.26.1

