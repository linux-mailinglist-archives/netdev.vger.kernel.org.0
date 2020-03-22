Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330C318EC14
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 21:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgCVUPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 16:15:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:42990 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgCVUPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 16:15:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DFBABAC92;
        Sun, 22 Mar 2020 20:15:52 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E11BAE0FD3; Sun, 22 Mar 2020 21:15:51 +0100 (CET)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] ethtool: fix reference leak in some *_SET handlers
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Message-Id: <20200322201551.E11BAE0FD3@unicorn.suse.cz>
Date:   Sun, 22 Mar 2020 21:15:51 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew noticed that some handlers for *_SET commands leak a netdev
reference if required ethtool_ops callbacks do not exist. A simple
reproducer would be e.g.

  ip link add veth1 type veth peer name veth2
  ethtool -s veth1 wol g
  ip link del veth1

Make sure dev_put() is called when ethtool_ops check fails.

Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/debug.c     | 4 +++-
 net/ethtool/linkinfo.c  | 4 +++-
 net/ethtool/linkmodes.c | 4 +++-
 net/ethtool/wol.c       | 4 +++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
index aaef4843e6ba..92599ad7b3c2 100644
--- a/net/ethtool/debug.c
+++ b/net/ethtool/debug.c
@@ -107,8 +107,9 @@ int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		return ret;
 	dev = req_info.dev;
+	ret = -EOPNOTSUPP;
 	if (!dev->ethtool_ops->get_msglevel || !dev->ethtool_ops->set_msglevel)
-		return -EOPNOTSUPP;
+		goto out_dev;
 
 	rtnl_lock();
 	ret = ethnl_ops_begin(dev);
@@ -129,6 +130,7 @@ int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info)
 	ethnl_ops_complete(dev);
 out_rtnl:
 	rtnl_unlock();
+out_dev:
 	dev_put(dev);
 	return ret;
 }
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index 5d16cb4e8693..6e9e0b590bb5 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -126,9 +126,10 @@ int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		return ret;
 	dev = req_info.dev;
+	ret = -EOPNOTSUPP;
 	if (!dev->ethtool_ops->get_link_ksettings ||
 	    !dev->ethtool_ops->set_link_ksettings)
-		return -EOPNOTSUPP;
+		goto out_dev;
 
 	rtnl_lock();
 	ret = ethnl_ops_begin(dev);
@@ -162,6 +163,7 @@ int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
 	ethnl_ops_complete(dev);
 out_rtnl:
 	rtnl_unlock();
+out_dev:
 	dev_put(dev);
 	return ret;
 }
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 96f20be64553..18cc37be2d9c 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -338,9 +338,10 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		return ret;
 	dev = req_info.dev;
+	ret = -EOPNOTSUPP;
 	if (!dev->ethtool_ops->get_link_ksettings ||
 	    !dev->ethtool_ops->set_link_ksettings)
-		return -EOPNOTSUPP;
+		goto out_dev;
 
 	rtnl_lock();
 	ret = ethnl_ops_begin(dev);
@@ -370,6 +371,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 	ethnl_ops_complete(dev);
 out_rtnl:
 	rtnl_unlock();
+out_dev:
 	dev_put(dev);
 	return ret;
 }
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
index e1b8a65b64c4..55e1ecaaf739 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -128,8 +128,9 @@ int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		return ret;
 	dev = req_info.dev;
+	ret = -EOPNOTSUPP;
 	if (!dev->ethtool_ops->get_wol || !dev->ethtool_ops->set_wol)
-		return -EOPNOTSUPP;
+		goto out_dev;
 
 	rtnl_lock();
 	ret = ethnl_ops_begin(dev);
@@ -172,6 +173,7 @@ int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info)
 	ethnl_ops_complete(dev);
 out_rtnl:
 	rtnl_unlock();
+out_dev:
 	dev_put(dev);
 	return ret;
 }
-- 
2.25.1

