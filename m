Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F3418ECA7
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 22:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgCVVYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 17:24:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:57092 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgCVVYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 17:24:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1070BAB7F;
        Sun, 22 Mar 2020 21:24:22 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 4A8B1E0FD3; Sun, 22 Mar 2020 22:24:21 +0100 (CET)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net v2] ethtool: fix reference leak in some *_SET handlers
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Message-Id: <20200322212421.4A8B1E0FD3@unicorn.suse.cz>
Date:   Sun, 22 Mar 2020 22:24:21 +0100 (CET)
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

v2: add Fixes tags

Fixes: a53f3d41e4d3 ("ethtool: set link settings with LINKINFO_SET request")
Fixes: bfbcfe2032e7 ("ethtool: set link modes related data with LINKMODES_SET request")
Fixes: e54d04e3afea ("ethtool: set message mask with DEBUG_SET request")
Fixes: 8d425b19b305 ("ethtool: set wake-on-lan settings with WOL_SET request")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
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

